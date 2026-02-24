// Widget tests for ProductFeedPage: loading skeleton, product grid, error/retry.
import 'package:beespoke_app/core/errors/failures.dart';
import 'package:beespoke_app/features/products/domain/models/product.dart';
import 'package:beespoke_app/features/products/presentation/pages/product_feed_page.dart';
import 'package:beespoke_app/features/products/presentation/providers/products_provider.dart';
import 'package:beespoke_app/shared/theme/app_theme.dart';
import 'package:beespoke_app/shared/widgets/error_view.dart';
import 'package:beespoke_app/shared/widgets/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_products.dart';

void main() {
  group('ProductFeedPage', () {
    Widget buildApp(List<Override> overrides) => ProviderScope(
          overrides: overrides,
          child: MaterialApp(
            theme: AppTheme.dark,
            home: const ProductFeedPage(),
          ),
        );

    testWidgets('shows skeleton cards while loading', (tester) async {
      final override = productsProvider.overrideWith(() => _LoadingNotifier());

      await tester.pumpWidget(buildApp([override]));
      // page is in loading state — skeletons should appear
      expect(find.byType(SkeletonCard), findsWidgets);
    });

    testWidgets('shows product cards when data is loaded', (tester) async {
      final override = productsProvider.overrideWith(
        () => _DataNotifier(testProducts),
      );

      await tester.pumpWidget(buildApp([override]));
      await tester.pump();

      expect(find.text(testProducts.first.title), findsOneWidget);
    });

    testWidgets('shows error view with retry on failure', (tester) async {
      final override = productsProvider.overrideWith(() => _ErrorNotifier());

      await tester.pumpWidget(buildApp([override]));
      await tester.pump();

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('search filters products by title', (tester) async {
      final override = productsProvider.overrideWith(
        () => _DataNotifier(testProducts),
      );

      await tester.pumpWidget(buildApp([override]));
      await tester.pump();

      await tester.enterText(find.byType(TextField), testProducts.first.title);
      await tester.pump();

      expect(find.text(testProducts.first.title), findsOneWidget);
    });
  });
}

// ─── Helper notifiers ─────────────────────────────────────────────────────────

class _LoadingNotifier extends ProductsNotifier {
  @override
  Future<List<Product>> build() async {
    await Future<void>.delayed(const Duration(days: 1)); // never resolves
    return [];
  }
}

class _DataNotifier extends ProductsNotifier {
  _DataNotifier(this._products);
  final List<Product> _products;

  @override
  Future<List<Product>> build() async => _products;
}

class _ErrorNotifier extends ProductsNotifier {
  @override
  Future<List<Product>> build() async =>
      throw Exception(const NetworkFailure().message);
}

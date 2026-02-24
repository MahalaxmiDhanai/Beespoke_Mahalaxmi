/// Main product feed page displaying grid of products.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/skeleton_card.dart';
import '../../domain/models/product.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';
import 'browsing_history_page.dart';
import 'product_webview_page.dart';

/// Product feed page: loads from FakeStoreAPI with search and like/dislike.
class ProductFeedPage extends ConsumerStatefulWidget {
  const ProductFeedPage({super.key});

  @override
  ConsumerState<ProductFeedPage> createState() => _ProductFeedPageState();
}

class _ProductFeedPageState extends ConsumerState<ProductFeedPage> {
  String _query = '';
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final asyncProducts = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Beespoke',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Browsing History',
            icon: const Icon(Icons.history_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const BrowsingHistoryPage(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(
            onChanged: (q) => setState(() => _query = q),
          ),
          asyncProducts.when(
            loading: () => const Expanded(child: _SkeletonGrid()),
            error: (err, _) => Expanded(
              child: ErrorView(
                message: err.toString().replaceFirst('Exception: ', ''),
                onRetry: () => ref.read(productsProvider.notifier).refresh(),
              ),
            ),
            data: (products) {
              final filtered = _filterProducts(products);
              final categories = _extractCategories(products);
              return Expanded(
                child: Column(
                  children: [
                    _CategoryFilter(
                      categories: categories,
                      selected: _selectedCategory,
                      onSelect: (c) => setState(() => _selectedCategory = c),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? const _EmptyState()
                          : _ProductGrid(
                              products: filtered,
                              onProductTap: _openWebView,
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Product> _filterProducts(List<Product> products) {
    var result = products;
    if (_selectedCategory != null) {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }
    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      result = result
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  List<String> _extractCategories(List<Product> products) {
    final categories = products.map((p) => p.category).toSet().toList()..sort();
    return categories;
  }

  void _openWebView(Product product) {
    final url = 'https://fakestoreapi.com/products/${product.id}';
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ProductWebViewPage(
          url: url,
          title: product.title,
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: TextField(
          onChanged: onChanged,
          decoration: const InputDecoration(
            hintText: 'Search products…',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
      );
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                label: const Text('All'),
                selected: selected == null,
                onSelected: (_) => onSelect(null),
              ),
            ),
            ...categories.map(
              (c) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(c),
                  selected: selected == c,
                  onSelected: (_) => onSelect(selected == c ? null : c),
                ),
              ),
            ),
          ],
        ),
      );
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({
    required this.products,
    required this.onProductTap,
  });

  final List<Product> products;
  final void Function(Product) onProductTap;

  @override
  Widget build(BuildContext context) => GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) => ProductCard(
          product: products[index],
          onTap: () => onProductTap(products[index]),
        ),
      );
}

class _SkeletonGrid extends StatelessWidget {
  const _SkeletonGrid();

  @override
  Widget build(BuildContext context) => GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const SkeletonCard(),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.cardBorder,
            ),
            const SizedBox(height: 12),
            Text(
              'No products found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white38,
                  ),
            ),
          ],
        ),
      );
}

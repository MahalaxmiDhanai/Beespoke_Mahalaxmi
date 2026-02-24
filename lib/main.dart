/// Application entry point.
///
/// Initialises Hive, opens boxes, and wraps the app in [ProviderScope].
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/products/presentation/pages/product_feed_page.dart';
import 'shared/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox<int>('likes_box');
  await Hive.openBox<Map<String, dynamic>>('history_box');

  runApp(const ProviderScope(child: BeespokeApp()));
}

/// Root widget of the Beespoke app.
class BeespokeApp extends StatelessWidget {
  const BeespokeApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Beespoke',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const ProductFeedPage(),
      );
}

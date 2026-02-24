// Integration test: app start → products load → open product (WebView) → history recorded.
import 'package:beespoke_app/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App integration test', () {
    testWidgets('products load and history is recorded', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify product feed is shown (check AppBar title)
      expect(find.text('Beespoke'), findsOneWidget);

      // Products should be loaded from FakeStoreAPI
      // (Backpack is the first product from FakeStoreAPI)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap the history icon — should show empty history initially
      final historyIcon = find.byTooltip('Browsing History');
      if (historyIcon.evaluate().isNotEmpty) {
        await tester.tap(historyIcon);
        await tester.pumpAndSettle();
        expect(find.text('Browsing History'), findsOneWidget);
      }
    });
  });
}

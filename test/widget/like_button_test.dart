// Widget tests for LikeButton.
import 'package:beespoke_app/features/products/presentation/widgets/like_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LikeButton', () {
    testWidgets('shows outline heart when not liked', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LikeButton(isLiked: false, onToggle: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
      expect(find.byIcon(Icons.favorite_rounded), findsNothing);
    });

    testWidgets('shows filled heart when liked', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LikeButton(isLiked: true, onToggle: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    });

    testWidgets('calls onToggle after tap animation', (tester) async {
      var toggled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LikeButton(
              isLiked: false,
              onToggle: () => toggled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LikeButton));
      // Forward + reverse animation duration ~350ms
      await tester.pump(const Duration(milliseconds: 400));

      expect(toggled, isTrue);
    });
  });
}

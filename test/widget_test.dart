import 'package:flutter_test/flutter_test.dart';
import 'package:rakhi_app/main.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const RakhiSurpriseApp());
    // Advance timers so Scene 1 splash auto-advance timer resolves cleanly
    await tester.pump(const Duration(seconds: 3));
    expect(find.textContaining('Raksha Bandhan'), findsOneWidget);
  });
}

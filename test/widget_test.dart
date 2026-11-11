import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_forge/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('StarForgeApp smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const StarForgeApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Verify main screen elements render correctly
    expect(find.text('ТАПНИ!'), findsOneWidget);
    expect(find.text('ЗВЁЗДНАЯ ПЫЛЬ'), findsOneWidget);
    expect(find.text('Астероид'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:go212/main.dart';

void main() {
  testWidgets('GO212 app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const Go212App());
    expect(find.text('GO'), findsOneWidget);
    expect(find.text('212'), findsOneWidget);
  });
}

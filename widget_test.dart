import 'package:flutter_test/flutter_test.dart';
import 'package:hasanur_gaming_99/main.dart';

void main() {
  testWidgets('Home page loads', (tester) async {
    await tester.pumpWidget(const HasanurGamingApp());

    expect(find.text('Hasanur Gaming 99'), findsOneWidget);
    expect(find.text('Customizable Flutter Project'), findsOneWidget);
  });
}

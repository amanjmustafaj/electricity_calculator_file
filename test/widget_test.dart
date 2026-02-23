import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart'; // دڵنیابە لێرە ناوی فۆڵدەری پڕۆژەکەت دروستە

Future<void> main() async => testWidgets('پشکنینی تایتڵ', (WidgetTester tester) async {
    await tester.pumpWidget(const ElectricityApp());
    expect(find.text('هەژمارکردنی نرخی کارەبا'), findsOneWidget);
  });
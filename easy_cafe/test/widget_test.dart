import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_cafe/main.dart';

void main() {
  testWidgets('App starts and shows landing screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EasyCafeApp());
    expect(find.text('Easy Cafe'), findsWidgets);
    expect(find.text('Staff Mode'), findsOneWidget);
    expect(find.text('Admin Mode'), findsOneWidget);
  });
}

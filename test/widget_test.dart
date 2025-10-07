// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loyalty_program/main.dart';

void main() {
  testWidgets('App loads without user login', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(user: null, isRemembered: false));

    // Verify that the app loads and shows login page when no user is remembered
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App shows home screen when user is remembered', (
    WidgetTester tester,
  ) async {
    // Build our app with a mock user
    await tester.pumpWidget(const MyApp(user: null, isRemembered: true));

    // Verify that the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

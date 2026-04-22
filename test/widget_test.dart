// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neoncave_arena/constant/app_branding.dart';

void main() {
  testWidgets('App branding title is wired into a MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: AppBranding.appDisplayName,
        home: SizedBox.shrink(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, AppBranding.appDisplayName);
    expect(AppBranding.appDisplayName, isNotEmpty);
  });
}

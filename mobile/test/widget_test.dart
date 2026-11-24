import 'dart:convert';

import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('shows the message returned by the backend', (tester) async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/hello');
      expect(request.url.queryParameters['name'], 'Ada');
      return http.Response(jsonEncode({'message': 'Hello, Ada!'}), 200);
    });

    await tester.pumpWidget(MaterialApp(home: HomePage(client: client)));

    await tester.enterText(find.byType(TextField), 'Ada');
    await tester.tap(find.text('Say hello'));
    await tester.pumpAndSettle();

    expect(find.text('Hello, Ada!'), findsOneWidget);
  });

  testWidgets('shows an error when the request fails', (tester) async {
    final client = MockClient((request) async => http.Response('boom', 500));

    await tester.pumpWidget(MaterialApp(home: HomePage(client: client)));

    await tester.tap(find.text('Say hello'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Error:'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterboard/flutterboard.dart';

void main() {
  testWidgets('renders a board document and fires button actions',
      (tester) async {
    String? fired;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FlutterBoard(
          spec: const {
            'type': 'column',
            'children': [
              {'type': 'text', 'value': 'Hello board', 'style': 'title'},
              {'type': 'divider'},
              {
                'type': 'button',
                'label': 'Tap me',
                'action': 'hello',
                'args': {'n': 1},
              },
            ],
          },
          onAction: (name, args) => fired = '$name:${args['n']}',
        ),
      ),
    ));

    expect(find.text('Hello board'), findsOneWidget);
    await tester.tap(find.text('Tap me'));
    expect(fired, 'hello:1');
  });

  testWidgets('unknown node types degrade to an error chip', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: FlutterBoard(spec: {'type': 'nope'})),
    ));
    expect(find.text('unknown node: nope'), findsOneWidget);
  });
}

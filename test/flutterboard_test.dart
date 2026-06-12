import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterboard/flutterboard.dart';

Widget _host(Map<String, dynamic> spec, {BoardActionHandler? onAction}) =>
    MaterialApp(home: Scaffold(body: FlutterBoard(spec: spec, onAction: onAction)));

void main() {
  testWidgets('renders a board document and fires button actions',
      (tester) async {
    String? fired;
    await tester.pumpWidget(_host(const {
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
    }, onAction: (name, args) => fired = '$name:${args['n']}'));

    expect(find.text('Hello board'), findsOneWidget);
    await tester.tap(find.text('Tap me'));
    expect(fired, 'hello:1');
  });

  testWidgets('unknown node types degrade to an error chip', (tester) async {
    await tester.pumpWidget(_host(const {'type': 'nope'}));
    expect(find.text('unknown node: nope'), findsOneWidget);
  });

  testWidgets('wrap lays out children with spacing', (tester) async {
    await tester.pumpWidget(_host(const {
      'type': 'wrap',
      'spacing': 4,
      'children': [
        {'type': 'chip', 'label': 'one'},
        {'type': 'chip', 'label': 'two'},
      ],
    }));
    expect(find.byType(Wrap), findsOneWidget);
    expect(find.text('one'), findsOneWidget);
    expect(find.text('two'), findsOneWidget);
  });

  testWidgets('icon renders known names and degrades unknown ones',
      (tester) async {
    await tester.pumpWidget(_host(const {
      'type': 'row',
      'children': [
        {'type': 'icon', 'value': 'star'},
        {'type': 'icon', 'value': 'no-such-icon'},
      ],
    }));
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byIcon(Icons.help_outline), findsOneWidget);
  });

  testWidgets('chip renders a label with an optional avatar icon',
      (tester) async {
    await tester.pumpWidget(
        _host(const {'type': 'chip', 'label': 'tagged', 'icon': 'check'}));
    expect(find.text('tagged'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('progress renders linear by default, circular on request',
      (tester) async {
    await tester.pumpWidget(_host(const {
      'type': 'column',
      'children': [
        {'type': 'progress', 'value': 0.5},
        {'type': 'progress', 'circular': true, 'value': 0.25},
      ],
    }));
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('list renders items and fires item actions', (tester) async {
    String? fired;
    await tester.pumpWidget(_host(const {
      'type': 'list',
      'items': [
        {'title': 'First', 'subtitle': 'with subtitle', 'icon': 'home'},
        {
          'title': 'Second',
          'action': 'open',
          'args': {'id': 'b'},
        },
      ],
    }, onAction: (name, args) => fired = '$name:${args['id']}'));

    expect(find.text('First'), findsOneWidget);
    expect(find.text('with subtitle'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    await tester.tap(find.text('Second'));
    expect(fired, 'open:b');
  });

  testWidgets('non-map children and missing fields are ignored gracefully',
      (tester) async {
    await tester.pumpWidget(_host(const {
      'type': 'column',
      'children': [
        'not-a-map',
        42,
        {'type': 'text'},
        {'type': 'button'},
        {'type': 'list'},
      ],
    }));
    // Nothing throws; the defaulted button label renders.
    expect(find.text('Button'), findsOneWidget);
  });

  testWidgets('padding and center wrap their first child', (tester) async {
    await tester.pumpWidget(_host(const {
      'type': 'center',
      'children': [
        {
          'type': 'padding',
          'value': 20,
          'children': [
            {'type': 'text', 'value': 'inner'},
          ],
        },
      ],
    }));
    expect(find.text('inner'), findsOneWidget);
    final padding = tester.widget<Padding>(find.ancestor(
        of: find.text('inner'), matching: find.byType(Padding)).first);
    expect(padding.padding, const EdgeInsets.all(20));
  });
}

import 'package:flutter/material.dart';
import 'package:flutterboard/flutterboard.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutterboard example',
      home: Scaffold(
        appBar: AppBar(title: const Text('flutterboard')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: FlutterBoard(
            spec: const {
              'type': 'column',
              'children': [
                {
                  'type': 'card',
                  'children': [
                    {'type': 'text', 'value': 'Hello board', 'style': 'title'},
                    {
                      'type': 'text',
                      'value': 'This whole screen is a JSON document.',
                      'style': 'caption',
                    },
                    {'type': 'spacer', 'value': 12},
                    {'type': 'button', 'label': 'Say hi', 'action': 'hi'},
                  ],
                },
              ],
            },
            onAction: (name, args) =>
                debugPrint('board action: $name $args'),
          ),
        ),
      ),
    );
  }
}

/// flutterboard — build Flutter widgets from declarative JSON board documents.
///
/// This is an early preview of the flutterboard engine. It renders a small
/// vocabulary of node types from a JSON-like map; the full engine (data-bound
/// views, actions, editors, theming) is under active development.
library;

import 'package:flutter/material.dart';

/// Signature for action callbacks fired by interactive nodes (e.g. `button`).
///
/// [name] is the action name from the node's `action` field; [args] is the
/// node's `args` map (empty when absent).
typedef BoardActionHandler = void Function(
    String name, Map<String, dynamic> args);

/// Renders a board document — a JSON-like tree of node maps — as widgets.
///
/// Supported node `type`s in this preview: `column`, `row`, `card`, `padding`,
/// `center`, `text`, `button`, `spacer`, `divider`. Unknown types render an
/// inline error chip rather than throwing, so a typo never takes down the
/// whole board.
///
/// ```dart
/// FlutterBoard(
///   spec: const {
///     'type': 'column',
///     'children': [
///       {'type': 'text', 'value': 'Hello board', 'style': 'title'},
///       {'type': 'button', 'label': 'Tap', 'action': 'hello'},
///     ],
///   },
///   onAction: (name, args) => debugPrint('action: $name'),
/// )
/// ```
class FlutterBoard extends StatelessWidget {
  /// The board document: a map with a `type` and type-specific fields.
  final Map<String, dynamic> spec;

  /// Called when an interactive node fires an action. Optional.
  final BoardActionHandler? onAction;

  const FlutterBoard({super.key, required this.spec, this.onAction});

  @override
  Widget build(BuildContext context) => _build(context, spec);

  Widget _build(BuildContext context, Map<String, dynamic> node) {
    final type = node['type'] as String?;
    switch (type) {
      case 'column':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _children(context, node),
        );
      case 'row':
        return Row(children: _children(context, node));
      case 'card':
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _children(context, node),
            ),
          ),
        );
      case 'padding':
        return Padding(
          padding: EdgeInsets.all((node['value'] as num?)?.toDouble() ?? 8),
          child: _firstChild(context, node),
        );
      case 'center':
        return Center(child: _firstChild(context, node));
      case 'text':
        return Text(
          '${node['value'] ?? ''}',
          style: switch (node['style']) {
            'title' => Theme.of(context).textTheme.titleLarge,
            'caption' => Theme.of(context).textTheme.bodySmall,
            _ => null,
          },
        );
      case 'button':
        return FilledButton(
          onPressed: () => onAction?.call(
            '${node['action'] ?? ''}',
            (node['args'] as Map?)?.cast<String, dynamic>() ?? const {},
          ),
          child: Text('${node['label'] ?? 'Button'}'),
        );
      case 'spacer':
        return SizedBox(
          width: (node['value'] as num?)?.toDouble() ?? 8,
          height: (node['value'] as num?)?.toDouble() ?? 8,
        );
      case 'divider':
        return const Divider();
      default:
        return Chip(label: Text('unknown node: $type'));
    }
  }

  List<Widget> _children(BuildContext context, Map<String, dynamic> node) {
    final raw = node['children'];
    if (raw is! List) return const [];
    return [
      for (final child in raw)
        if (child is Map) _build(context, child.cast<String, dynamic>()),
    ];
  }

  Widget? _firstChild(BuildContext context, Map<String, dynamic> node) {
    final children = _children(context, node);
    return children.isEmpty ? null : children.first;
  }
}

# flutterboard

Build Flutter widgets from declarative JSON board documents.

This is an **early preview** (0.0.x) of the flutterboard engine. The full
engine — data-bound views (lists, tables, calendars, kanban), an action
registry, in-app editors, and theming — is under active development and will
land here as it stabilizes. APIs in the 0.0.x line are experimental and will
change without notice.

## What works today

A `FlutterBoard` widget that renders a small node vocabulary from a JSON-like
map: `column`, `row`, `card`, `padding`, `center`, `text`, `button`, `spacer`,
`divider`. Interactive nodes fire named actions back to your code. Unknown
node types degrade to an inline error chip instead of throwing.

```dart
import 'package:flutterboard/flutterboard.dart';

FlutterBoard(
  spec: const {
    'type': 'card',
    'children': [
      {'type': 'text', 'value': 'Hello board', 'style': 'title'},
      {'type': 'text', 'value': 'This UI is a JSON document.', 'style': 'caption'},
      {'type': 'spacer'},
      {'type': 'button', 'label': 'Say hi', 'action': 'hi'},
    ],
  },
  onAction: (name, args) => debugPrint('action: $name $args'),
)
```

Because the document is plain JSON, boards can be stored, synced, edited at
runtime, and shared as data — that idea is the whole project.

## Status

Preview. The production engine exists in a private codebase and is being
prepared for release here incrementally. Pin an exact version if you depend
on this package.

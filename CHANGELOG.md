# 0.0.2

- New node types: `wrap`, `icon` (small stable name vocabulary, unknown names
  degrade), `chip`, `progress` (linear / `circular: true`), and `list` —
  static items with title/subtitle/icon and per-item tap actions.
- Test suite now covers every node type, action plumbing, and malformed-input
  resilience (9 widget tests).

# 0.0.1

- Initial preview: `FlutterBoard` renders a JSON board document — `column`,
  `row`, `card`, `padding`, `center`, `text`, `button`, `spacer`, `divider` —
  with named action callbacks and graceful unknown-node handling.

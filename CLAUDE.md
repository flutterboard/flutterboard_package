# flutterboard (pub.dev package) — working notes

This repo is the public face of the `flutterboard` name on pub.dev: a small,
honest, WORKING early preview (JSON board-document renderer). It legitimately
holds the package name until the real engine ships here as higher versions.

Status: v0.0.1 validated (analyze clean, tests pass, `dart pub publish
--dry-run` clean, 3 KB archive). **Publishing requires the user** — only they
can run `dart pub publish` (interactive Google OAuth). Never attempt it.

## Hard rules

- **No code from the private isan monorepo lands here.** Everything in this
  package is written fresh for it. The real engine arrives only via the
  user's deliberate extraction decision (currently PARKED).
- Keep the preview honest: it must genuinely work, README must describe real
  behavior, no placeholder-stub padding (pub.dev removes name squats).
- License is BSD-3-Clause; a future version may change it when the real
  engine lands (user's call).
- Every change: `flutter analyze && flutter test && dart pub publish
  --dry-run` before pushing. CI enforces the first two on push.
- Version bumps: update pubspec version + CHANGELOG entry together.
- This repo is single-session — claim it in
  `~/dev/github.com/_claude/BOARD.md` anyway, habit is the point.

Relationship to the rest: engine concepts come from the monorepo
(`~/dev/workspace1`); brand rules in
`~/dev/github.com/_claude/knowledge/flutterboard.md` (notably: flutterboard
is a package name, NOT a commercial product brand — Google trademark line).

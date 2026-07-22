# 04 — Export (CSV + Anki TSV)

**Goal:** export saved entries to a CSV file or an Anki-importable TSV file.

## Formats

### CSV (RFC-4180)
- Proper quoting: wrap fields containing `,`, `"`, or newlines in double quotes;
  escape embedded quotes by doubling them.
- Columns: `term, translation, context, sourceLang, targetLang, document, page,
  createdAt`.
- Includes a header row.

### Anki TSV
- Tab-separated. Escape tabs/newlines within fields (replace or wrap per Anki's
  rules).
- Optional Anki header lines: `#separator:tab` and `#columns:` so Anki maps
  fields automatically.
- Field mapping: **Front** = term, **Back** = translation + context,
  plus **tags** (document title, language pair).

## Scope & delivery

- Export scope: **all entries** or the **current multi-selection** from the
  vocab list.
- Write to a temp file in the app's Caches directory; filename includes the date
  and language pair (e.g. `flr-es-en-2026-07-22.csv`).
- Deliver via `ShareLink` / `UIActivityViewController`.

## Critical files

- `Export/ExportWriter.swift` (pure, unit-tested)
- `Export/ExportView.swift`

## Verification

- Export CSV; open in a spreadsheet — columns align, quoting handles commas and
  newlines in context sentences.
- Export Anki TSV; import into Anki desktop — cards land with correct
  Front/Back/tags.
- **Unit tests:** CSV quoting and TSV escaping are pure and must be covered by
  XCTest, including edge cases (commas, quotes, tabs, newlines in fields).

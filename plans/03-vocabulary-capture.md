# 03 — Vocabulary Capture & Storage

**Goal:** persist every saved selection + translation for later export.

## Data model

SwiftData `@Model VocabEntry`:

| field            | type            | notes                                  |
|------------------|-----------------|----------------------------------------|
| `id`             | `UUID`          | primary id                             |
| `term`           | `String`        | selected word/phrase                   |
| `translation`    | `String`        | chosen translation                     |
| `contextSentence`| `String?`       | surrounding sentence                   |
| `sourceLanguage` | `String?`       | BCP-47 tag                             |
| `targetLanguage` | `String?`       | BCP-47 tag                             |
| `providerUsed`   | `String`        | AppleIntelligence / Dictionary / Translate |
| `documentTitle`  | `String?`       | source document                        |
| `pageIndex`      | `Int?`          | page it came from                      |
| `createdAt`      | `Date`          |                                        |
| `notes`          | `String?`       | user-editable                          |

Companion `Document` model lives here too (see plan 01).

## Behavior

- Saving from the translation result sheet writes a `VocabEntry`.
- **De-dupe** on (term + document): if it already exists, show an "already
  saved" indicator instead of a duplicate; allow overwrite of the translation.
- Vocabulary list screen:
  - Searchable + sortable (by date, term, language, document).
  - Swipe-to-delete; edit translation/notes inline or in a detail sheet.
  - Multi-select for export (feeds plan 04).

## Critical files

- `Vocabulary/Models.swift` (`VocabEntry`, `Document`)
- `Vocabulary/VocabStore.swift` (insert/de-dupe/query helpers)
- `Vocabulary/VocabListView.swift`

## Verification

- Save several entries from different documents; confirm they persist across
  relaunch.
- Re-save the same term from the same document → no duplicate.
- Edit and delete entries; confirm changes persist.

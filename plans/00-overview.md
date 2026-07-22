# 00 — Overview & Architecture

## Goal

A native iOS app for reading foreign-language PDFs and building a personal
vocabulary bank. Select a word or phrase → translate (Apple Intelligence first,
then Apple Dictionary, then Apple Translate) → save the term + translation +
surrounding sentence → export the collection to CSV or Anki. Support inverting
PDF colors for dark-mode reading.

## Confirmed decisions

- **Deployment target: iOS 26+** — guarantees Foundation Models (on-device LLM)
  and the Translation framework everywhere; no legacy fallback paths.
- **Anki export: TSV/CSV import file** — no native `.apkg` in v1.
- **Translation sources: all three, Apple Intelligence first** as the default.

## Architecture

- **Language / UI:** Swift 6, SwiftUI app lifecycle. `UIViewRepresentable`
  wrappers where PDFKit needs UIKit.
- **PDF rendering:** PDFKit (`PDFView`, `PDFDocument`, `PDFSelection`).
- **Persistence:** SwiftData (`@Model`) for vocabulary entries and imported-
  document metadata, backed by **CloudKit** for cross-device sync (see plan 06).
- **Translation:** a `TranslationProvider` protocol with three implementations
  chosen at call time.
- **State:** an `@Observable` app model; a per-reader view model holds the
  current document, selection, and invert/dark-mode state.

## Module / folder layout

```
foreign-language-reader/
  README.md
  TODO.md
  plans/
  ForeignLanguageReader.xcodeproj   (generated during scaffolding)
  ForeignLanguageReader/
    App/            App entry, root navigation
    Reader/         PDFView wrapper, reader view + toolbar
    Translation/    TranslationProvider protocol + 3 providers
    Vocabulary/     SwiftData models, capture, list UI
    Export/         CSV + Anki TSV writers, share sheet
    Rendering/      color-invert filter helpers
    Shared/         extensions, utilities
```

## Build order (see TODO.md)

1. Scaffold project.
2. Feature 1 (PDF reader) — foundational.
3. Feature 5 (color inversion) — front-loaded to de-risk rendering.
4. Feature 2 (selection → translation) + the three providers.
5. Feature 3 (vocabulary storage).
6. Feature 4 (export).
7. Polish.

## Per-feature plans

- [01 — PDF Reader](01-pdf-reader.md)
- [02 — Selection → Translation](02-selection-translation.md)
- [03 — Vocabulary Capture & Storage](03-vocabulary-capture.md)
- [04 — Export](04-export.md)
- [05 — Dark-Mode Color Inversion](05-dark-mode-invert.md)
- [06 — iCloud Sync](06-icloud-sync.md)
- [07 — Text-to-Speech (Pronunciation)](07-tts.md)

## Backburner / v2 ideas

Captured but intentionally deferred past v1:

- **In-app spaced-repetition (SRS) review** — study saved words in-app (SM-2 /
  Leitner) instead of only exporting to Anki. The `VocabEntry` model already
  holds enough to support this later.
- **OCR for scanned PDFs** — Vision (`VNRecognizeTextRequest`) so
  selection/translation works on image-only PDFs. Big unlock, but meaty; pairs
  naturally with the color-inversion work once revisited.

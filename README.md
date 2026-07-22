# Foreign Language Reader

A native iOS app for reading foreign-language PDFs and building a personal
vocabulary bank while you read. Select a word or phrase and get an instant
translation from Apple Intelligence, the built-in Apple Dictionary, or Apple
Translate. Every selection — with its translation and surrounding sentence —
is saved so you can export the whole set to CSV or import it into Anki as
flashcards. Dense scanned PDFs can be color-inverted for comfortable dark-mode
reading.

## Status

Early planning / greenfield. See [`plans/`](plans/) for the architecture and
per-feature plans, and [`TODO.md`](TODO.md) for the ordered next steps.

## Requirements

- iOS 26+ (Foundation Models + Translation frameworks)
- Xcode 26+
- Swift 6

## Building

_Project scaffolding is not yet in place — see `TODO.md`. Once scaffolded:_

1. Open `ForeignLanguageReader.xcodeproj` in Xcode.
2. Select an iOS 26 Simulator or a supported device.
3. Build & run (⌘R).

## Tech stack

- SwiftUI + PDFKit for reading and text selection
- SwiftData for the vocabulary store
- Foundation Models (on-device LLM) + Translation framework for translation

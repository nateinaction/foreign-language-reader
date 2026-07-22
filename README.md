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

The `.xcodeproj` is generated from `project.yml` via [XcodeGen](https://github.com/yonaskolb/XcodeGen) and is not committed. On a Mac with Xcode 26+:

1. Enter the dev shell (`direnv allow`, or `nix develop`) — provides `xcodegen`, `swiftformat`, `swiftlint`.
2. Run `xcodegen generate`.
3. Open `ForeignLanguageReader.xcodeproj` in Xcode.
4. Select an iOS 26 Simulator or a supported device.
5. Build & run (⌘R).

A sample Spanish-language PDF for testing the reader is at `SampleFiles/el-principito-sample.pdf`.

## Tech stack

- SwiftUI + PDFKit for reading and text selection
- SwiftData for the vocabulary store
- Foundation Models (on-device LLM) + Translation framework for translation

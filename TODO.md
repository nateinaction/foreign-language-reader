# TODO

Ordered next steps. Feature 5 (color inversion) is deliberately front-loaded
because it carries the most rendering risk.

## Scaffolding
- [x] Decide project generation approach: raw `.xcodeproj` vs. `Package.swift` + XcodeGen → **XcodeGen** (`project.yml`, `.xcodeproj` gitignored/generated)
- [x] Set up folder groups: `App/`, `Reader/`, `Translation/`, `Vocabulary/`, `Export/`, `Rendering/`, `Shared/`
- [x] Add a sample foreign-language PDF for testing (`SampleFiles/el-principito-sample.pdf`)
- [x] `flake.nix` + `.envrc` for any tooling (swiftformat/swiftlint/xcodegen) per repo convention
- [ ] Scaffold Xcode project (run `xcodegen generate` on a Mac; SwiftData container wiring lands with plan 03)

## Feature 1 — PDF Reader
- [ ] `PDFKitView: UIViewRepresentable` wrapping `PDFView`
- [ ] Document import via `.fileImporter`; store security-scoped bookmarks in SwiftData
- [ ] Reader screen: thumbnail rail, page slider, page count
- [ ] Search via `PDFDocument.findString`
- [ ] Restore last-read page per document

## Feature 5 — Dark-Mode Color Inversion (de-risk early)
- [ ] `PDFColorInvert` filter helper (`CIColorInvert` / CA `colorInvert`)
- [ ] Toolbar toggle: System / Light / Invert (dark), persisted
- [ ] Prototype on both text and scanned PDFs; verify scroll performance
- [ ] Evaluate hue-rotate chain and fallback blend approaches

## Feature 2 — Selection → Translation
- [ ] Custom edit menu (`buildMenu(with:)`) with Translate ▸ three sources
- [ ] Read `currentSelection.string` + expand to surrounding sentence for context
- [ ] `TranslationProvider` protocol + `TranslationResult`
- [ ] AppleIntelligenceProvider (Foundation Models `LanguageModelSession`) — default
- [ ] DictionaryProvider (`UIReferenceLibraryViewController`)
- [ ] TranslateProvider (Translation framework `TranslationSession`, pack download)
- [ ] Translation result sheet with Save button

## Feature 3 — Vocabulary Capture & Storage
- [ ] SwiftData `@Model VocabEntry`
- [ ] Save from result sheet; de-dupe on (term + document)
- [ ] Vocab list: search, sort, swipe-delete, edit, multi-select

## Feature 4 — Export
- [ ] `ExportWriter`: CSV (RFC-4180) + Anki TSV (escaped)
- [ ] Export scope: all or selection
- [ ] Deliver via `ShareLink` / activity sheet from Caches temp file
- [ ] XCTest coverage for CSV quoting + TSV escaping

## Feature 6 — iCloud Sync
- [ ] Enable iCloud/CloudKit capability + container + remote-notifications background mode
- [ ] CloudKit-backed `ModelConfiguration` for the `ModelContainer`
- [ ] Make models CloudKit-compatible: optional/defaulted properties, no unique constraints, optional inverse relationships
- [ ] Move de-dupe (term + document) to app logic (query-before-insert) instead of a schema unique constraint
- [ ] New `Bookmark` `@Model` + bookmarks UI
- [ ] Store PDF bytes in the cloud (external-storage `Data`, size-guarded) — not a device-local security-scoped bookmark
- [ ] Sync reading position via `Document.pageIndex`
- [ ] Handle signed-out iCloud state (local store + "sign in to sync")
- [ ] Two-device verification (add/edit/delete propagation); large-PDF blob test

## Feature 7 — Text-to-Speech
- [ ] `SpeechService` (`AVSpeechSynthesizer`, `AVAudioSession` playback/duck)
- [ ] Voice resolution: prefer `.premium` → `.enhanced` → `.default` per source language
- [ ] Speaker buttons in translation result sheet + vocab detail (term & sentence)
- [ ] Graceful fallback + one-time "download enhanced voice" hint
- [ ] Settings: rate/pitch, preferred voice per language
- [ ] Device pass for premium-voice selection

## Polish
- [ ] Language auto-detect (source), target language setting
- [ ] Per-document last page restore
- [ ] Settings screen
- [ ] App icon, launch screen
- [ ] README build steps once scaffolding lands

## Backburner / v2 (not scheduled)
- [ ] In-app spaced-repetition (SRS) review — study saved words without exporting
- [ ] OCR for scanned PDFs (Vision `VNRecognizeTextRequest`)

# 01 — PDF Reader

**Goal:** import, render, and navigate PDFs; persist a library of opened
documents.

## Scope

- Document import via `.fileImporter` (Files app). A share-extension target for
  "Open in…" is a v1.1 stretch, not required for v1.
- Store **security-scoped bookmarks** in SwiftData so documents reopen across
  launches without re-importing.
- `PDFKitView: UIViewRepresentable` wrapping `PDFView`:
  - `displayMode = .singlePageContinuous`, `autoScales = true`.
  - `usePageViewController` toggle for a paged feel, exposed in the toolbar.
- Reader screen:
  - Thumbnail rail via `PDFThumbnailView`.
  - Page slider + current/total page count.
  - Search field driving `PDFDocument.findString`; jump between matches.
- Restore last-read page per document (persist `pageIndex`, restore on open).

## Data

- `Document` model (SwiftData): `id`, `title`, `bookmarkData`, `pageIndex`,
  `addedAt`, `lastOpenedAt`. (Defined alongside vocab models — see plan 03.)

## Critical files

- `Reader/PDFKitView.swift`
- `Reader/ReaderView.swift`
- `Reader/ReaderViewModel.swift`
- `Reader/ReaderToolbar.swift`
- `Vocabulary/Models.swift` (Document model)

## Risks / notes

- Security-scoped bookmarks require `startAccessingSecurityScopedResource()` /
  `stop…` bracketing around document loads.
- Large PDFs: rely on PDFKit's built-in lazy page rendering; avoid loading full
  documents into memory eagerly.

## Verification

- Import a sample foreign-language PDF; confirm it opens, paginates, and search
  finds/highlights terms.
- Kill and relaunch the app; confirm the document reopens at the last page.

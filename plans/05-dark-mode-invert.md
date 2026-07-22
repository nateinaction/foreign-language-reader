# 05 — Dark-Mode PDF Color Inversion

**Goal:** invert PDF colors for comfortable dark reading without wrecking
legibility. Front-loaded in the build order because it carries the most
rendering risk.

## Toolbar control

- Three modes: **System**, **Light**, **Invert (dark)**.
- Persist the preference (per-user, applied globally; per-document override is a
  later nicety).

## Implementation

- Apply a Core Image / Core Animation compositing filter to the `PDFView`'s
  document content layer:
  - **Primary approach:** `pdfView.layer.filters = [colorInvertFilter]` using
    `CIColorInvert` (or the Core Animation `colorInvert` filter). Optionally
    chain a slight hue-rotate so inverted photos/diagrams don't look
    radioactive.
  - **Fallbacks to evaluate during the prototype:**
    - Custom drawing via `PDFPage.draw(with:to:)` to blend/invert per page.
    - A `.difference` blend overlay.
  - Pick whichever renders **scanned** pages cleanly and stays performant while
    scrolling.
- Keep app-chrome dark mode driven normally by SwiftUI `preferredColorScheme`;
  only the PDF **content** layer gets the invert filter.

## Critical files

- `Rendering/PDFColorInvert.swift`
- `Reader/PDFKitView.swift` (apply/remove the filter on mode change)
- `Reader/ReaderToolbar.swift`

## Risks / notes

- This is the highest-risk rendering area — prototype early against both a
  text-based PDF and a scanned/image PDF.
- Watch scroll performance with the layer filter active; if it stutters,
  fall back to the per-page draw approach.

## Verification

- Toggle invert mode; confirm text stays legible on both text and scanned PDFs.
- Confirm smooth scrolling with the filter active.
- Confirm the mode persists across relaunch and doesn't fight the app chrome's
  own light/dark appearance.

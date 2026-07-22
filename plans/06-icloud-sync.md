# 06 — iCloud Sync

**Goal:** keep a user's library and study data consistent across all their
devices signed into the same iCloud account — the PDFs themselves, current
reading position, bookmarks, and the saved word list.

## What syncs

| Data                    | Source of truth model        | Transport                        |
|-------------------------|------------------------------|----------------------------------|
| Vocabulary (word list)  | `VocabEntry` (plan 03)       | SwiftData + CloudKit             |
| Document metadata       | `Document` (plans 01/03)     | SwiftData + CloudKit             |
| Current reading position| `pageIndex` on `Document`    | SwiftData + CloudKit             |
| Bookmarks               | `Bookmark` (new model)       | SwiftData + CloudKit             |
| PDF file bytes          | PDF blob (see below)         | CloudKit asset / iCloud container |

## Approach

Two synced stores working together:

1. **Structured data → SwiftData + CloudKit.**
   Use a CloudKit-backed `ModelConfiguration`
   (`ModelConfiguration(..., cloudKitDatabase: .private("iCloud.<bundle-id>"))`)
   so `VocabEntry`, `Document`, and `Bookmark` replicate automatically through
   the user's **private CloudKit database**. No manual record plumbing.

2. **PDF file bytes → cloud-stored blob, not a local bookmark.**
   The security-scoped bookmarks from plan 01 are **device-local** and do **not**
   transfer across devices. For synced documents we must store the actual PDF
   bytes in the cloud. Two candidate mechanisms — decide during implementation:
   - **`@Attribute(.externalStorage)` `Data` on `Document`**, synced via the
     same CloudKit-backed SwiftData store. Simplest; keeps everything in one
     sync path. Risk: large PDFs and CloudKit record/asset size limits.
   - **iCloud container document storage** (`CKAsset` or an iCloud Drive
     ubiquity container) with `Document` holding a reference. Better for large
     files and on-demand download, more plumbing.

   **Lean:** external-storage `Data` for v1 simplicity, with a size guard that
   falls back to the container approach for very large PDFs. Prototype with a
   representative (10–50 MB) scanned PDF before committing.

## New / changed models

- **New `Bookmark` `@Model`:** `id`, `documentID` (relationship to `Document`),
  `pageIndex`, `label?`, `createdAt`.
- **`Document` changes:** add the synced PDF blob (or container reference) and
  make it the canonical file source instead of a local security-scoped bookmark
  for synced docs. Keep last-read `pageIndex` here so position syncs for free.

## CloudKit constraints (affects plans 01 & 03)

SwiftData + CloudKit imposes rules the earlier models must satisfy:
- Every non-relationship property must be **optional or have a default value**.
- **No `@Attribute(.unique)`** — so the plan-03 de-dupe on (term + document)
  must be enforced **in app logic** (query-before-insert), not a schema unique
  constraint.
- Relationships must be **optional** and have **inverse** relationships.
- Revisit `VocabEntry` / `Document` definitions to comply before enabling
  CloudKit.

## Setup / capabilities

- Enable **iCloud** capability with **CloudKit** + the app's container; enable
  **Background Modes → Remote notifications** for push-driven sync.
- Add the entitlement and container id to the project.
- Handle account state: if the user isn't signed into iCloud, run against a
  local-only store and surface a gentle "sign in to sync" state (no data loss;
  switch to synced store when available).

## Conflict handling

- Structured data: rely on CloudKit's last-writer-wins per field; reading
  position naturally converges (latest wins). Acceptable for v1.
- Bookmarks/vocab are additive; deletions propagate through CloudKit tombstones.

## Critical files

- `Vocabulary/Models.swift` (add `Bookmark`, adjust `VocabEntry`/`Document`)
- `App/PersistenceController.swift` (or wherever the `ModelContainer` is built)
  — CloudKit-backed `ModelConfiguration`
- `Reader/ReaderViewModel.swift` — write reading position to the synced model
- `Reader/BookmarksView.swift` — bookmark list UI
- Project capabilities/entitlements (iCloud, CloudKit, remote notifications)

## Verification

- Two devices (or a device + Simulator) on the same iCloud account: add a PDF on
  device A → it appears on device B.
- Change reading position / add a bookmark / save a word on A → appears on B
  within a few seconds.
- Delete an entry on A → removed on B.
- Sign out of iCloud → app still works locally; sign back in → data reconciles.
- Test with a large scanned PDF to validate the chosen blob transport.

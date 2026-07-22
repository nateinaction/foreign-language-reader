# 02 — Selection → Translation

**Goal:** select a word or phrase in the PDF and translate it via a chosen
source, with Apple Intelligence as the default.

## Selection & menu

- Extend the `PDFView` edit menu via `buildMenu(with:)` (or the
  `UIEditMenuInteraction` delegate). On a text selection, show **Translate ▸**
  with three items: *Apple Intelligence*, *Dictionary*, *Apple Translate*.
- Primary/default action = Apple Intelligence.
- Read the selected text with `pdfView.currentSelection?.string`.
- Capture the **surrounding sentence** for context: expand the `PDFSelection`
  outward (via `selectionsByLine` and/or growing the selection to sentence
  boundaries) to feed the LLM and to store with the entry.

## Provider abstraction

```swift
protocol TranslationProvider {
    func translate(
        _ text: String,
        context: String?,
        from: Locale.Language?,
        to: Locale.Language
    ) async throws -> TranslationResult
}

struct TranslationResult {
    var lemma: String?          // dictionary form when available
    var translation: String
    var partOfSpeech: String?
    var provider: ProviderKind
    var raw: String?            // full source-provided text if any
}
```

### AppleIntelligenceProvider (default)
- Foundation Models `LanguageModelSession` with a guided prompt: "Translate this
  word/phrase given the sentence; return lemma + translation + part of speech."
- Prefer a `@Generable` structured output so the result maps cleanly to
  `TranslationResult`.
- Check `SystemLanguageModel.availability` first; if the model is unavailable or
  still downloading, surface a friendly message and offer another source.

### DictionaryProvider
- Present `UIReferenceLibraryViewController` for the term (definition look-up).
- Where a concise gloss can be parsed, populate `translation` for saving;
  otherwise the definition view is informational and the user types a note.

### TranslateProvider
- Translation framework `TranslationSession` (on-device, offline packs).
- If the language pair isn't installed, prompt the system download flow, then
  retry.

## Result presentation

- Lightweight sheet showing the source term, context sentence, translation, and
  provider. A **Save** button writes a `VocabEntry` (see plan 03).

## Critical files

- `Translation/TranslationProvider.swift`
- `Translation/AppleIntelligenceProvider.swift`
- `Translation/DictionaryProvider.swift`
- `Translation/TranslateProvider.swift`
- `Reader/SelectionMenu.swift`
- `Translation/TranslationResultSheet.swift`

## Risks / notes

- Foundation Models and the Translation framework have limited/no support in
  some Simulator configs — do a device pass for these two providers.
- Source-language detection: auto-detect (e.g. `NLLanguageRecognizer`) with a
  user override; target language from settings.

## Verification

- Select a word → each of the three menu items returns a result.
- Verify the Apple Intelligence path both when the model is available and when
  simulated-unavailable (graceful fallback message).
- Verify Translate prompts to download a missing language pack.

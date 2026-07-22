# 07 — Text-to-Speech (Pronunciation)

**Goal:** let the user hear the source-language pronunciation of a selected
word, phrase, or sentence, using Apple's high-quality neural voices.

## Scope

- Tap-to-hear on:
  - the selected term in the translation result sheet (plan 02),
  - the captured context sentence,
  - individual saved entries in the vocab list (plan 03).
- Speak in the **source language** (auto-detected per plan 02), not the UI
  language.

## Implementation

- `AVSpeechSynthesizer` + `AVSpeechUtterance`.
- **Voice selection — prefer high quality:** enumerate
  `AVSpeechSynthesisVoice.speechVoices()`, filter to the target
  `language`/BCP-47, and pick the best available by `quality`, preferring
  `.premium` → `.enhanced` → `.default`. Cache the chosen voice per language.
- Configure `AVAudioSession` (`.playback`, duck others) so playback works with
  the phone muted and mixes politely with other audio.
- Expose rate/pitch as optional settings; default to a slightly slowed rate for
  learner clarity.

### High-quality voice availability
- Premium/enhanced ("Personal Voice"-class neural) voices are **downloaded on
  demand by the user** in Settings ▸ Accessibility ▸ Spoken Content ▸ Voices.
  If only a compact/default voice is installed for the source language, fall
  back to it and surface a subtle, one-time hint: "Download an enhanced voice
  for <language> in Settings for better pronunciation."
- Never block playback on a missing premium voice — degrade gracefully.

## UI

- A speaker button (SF Symbol `speaker.wave.2`) next to the term and sentence in
  the result sheet and vocab detail.
- Show a subtle active/animating state while speaking; tap again to stop.

## Critical files

- `Shared/SpeechService.swift` (voice resolution, session config, speak/stop)
- `Translation/TranslationResultSheet.swift` (speaker buttons)
- `Vocabulary/VocabDetailView.swift` (speaker button)
- Settings: rate/pitch, preferred voice per language (later)

## Risks / notes

- Voice quality varies by language and by what the user has downloaded — the
  fallback path is the common case on a fresh device.
- Simulator has a limited voice set; verify premium-voice selection on device.

## Verification

- Select a word → tap speaker → hear it in the source language.
- With an enhanced voice installed, confirm it is preferred over the compact
  voice; with none installed, confirm graceful fallback + the hint.
- Confirm playback works with the ringer muted and ducks background audio.

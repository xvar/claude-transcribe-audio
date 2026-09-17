---
name: transcribe-audio
description: Transcribes audio files (.ogg/.oga voice notes, .mp3, .wav, .m4a, .webm, ...) to text entirely locally, no cloud API, no network call, no cost per use. Use this whenever a voice message arrives (e.g. via Telegram - an inbound message with a local file path or one fetched via a download tool) and its content needs to be read, whenever the user says "transcribe this", "what does this voice message say", "расшифруй", "распознай голосовое", "что в этом войсе", or shares any audio file and asks what's in it.
version: 1.0.0
---

# Transcribe audio

Turns an audio file into text using a local Whisper model (`faster-whisper`,
CPU, `small` model). Nothing leaves the machine and there's no per-call
cost, which matters for something that runs on every voice message.

## When to use this

- A voice message comes in (`.ogg`/`.oga`, Opus-encoded, e.g. from
  Telegram) - download it to a local path first if it isn't one already,
  then transcribe it with this skill before replying.
- The user shares any audio file and asks what's said in it.
- The user asks to transcribe, translate-then-transcribe, or summarize
  spoken content in a file.

## First-time setup (once per machine)

Check whether `${CLAUDE_PLUGIN_ROOT}/scripts/venv` exists. If not, run:

```
powershell -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/setup.ps1"
```

This needs Python 3 (`winget install --id=Python.Python.3.12 -e --accept-source-agreements --accept-package-agreements --silent --scope user`
on Windows if missing) and internet access for the one-time `pip install`
and the one-time Whisper model download (cached under
`~/.cache/huggingface` after that - fully offline from then on). No
compiler, no CUDA, no separate ffmpeg install needed - faster-whisper
decodes audio itself via bundled PyAV.

## How to run it

```
${CLAUDE_PLUGIN_ROOT}/scripts/venv/Scripts/python.exe ${CLAUDE_PLUGIN_ROOT}/scripts/transcribe.py "<path-to-audio-file>"
```

The transcript is printed to stdout as plain text. A line like
`[detected language: ru (p=0.94)]` goes to stderr - useful for sanity
checking, not part of the transcript itself.

Pass `--language ru` (or any ISO 639-1 code) to skip language
auto-detection when you already know it. Pass `--model` to use a
different faster-whisper model size (`tiny`, `base`, `small`, `medium`,
`large-v3`) when `small`'s accuracy/speed tradeoff isn't right for a given
clip.

## Notes

- First call after setup downloads the `small` model (~500MB); subsequent
  calls are instant to start.
- CPU-only inference: a typical voice message (under a minute) transcribes
  in a few seconds; warn the user before running this on long audio.
- If `import faster_whisper` fails, the venv is broken or missing - rerun
  `setup.ps1`.

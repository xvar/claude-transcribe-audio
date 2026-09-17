"""Transcribe an audio file (ogg/opus, mp3, wav, m4a, ...) to text using faster-whisper.

Usage:
    python transcribe.py <path-to-audio-file> [--language ru]

Prints the transcript to stdout. Model files are cached under
%USERPROFILE%\\.cache\\huggingface after the first run.
"""

import argparse
import sys

from faster_whisper import WhisperModel

MODEL_SIZE = "small"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("audio_path", help="Path to the audio file to transcribe")
    parser.add_argument(
        "--language",
        default=None,
        help="Force a language code (e.g. ru, en). Default: auto-detect.",
    )
    parser.add_argument(
        "--model",
        default=MODEL_SIZE,
        help=f"faster-whisper model size (default: {MODEL_SIZE})",
    )
    args = parser.parse_args()

    model = WhisperModel(args.model, device="cpu", compute_type="int8")
    segments, info = model.transcribe(args.audio_path, language=args.language, vad_filter=True)

    print(f"[detected language: {info.language} (p={info.language_probability:.2f})]", file=sys.stderr)

    text = " ".join(segment.text.strip() for segment in segments)
    print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

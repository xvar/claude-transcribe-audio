# transcribe-audio

A Claude Code plugin/skill that transcribes audio (voice messages, `.ogg`/
`.oga`/`.mp3`/`.wav`/`.m4a`/...) to text entirely locally with
[faster-whisper](https://github.com/SYSTRAN/faster-whisper) - CPU only, no
cloud API, no per-call cost, no audio leaving the machine. Built for the
"a Telegram voice message came in, what did it say" case.

## Use it on this machine

Already installed as a user-level skill at `~/.claude/skills/transcribe-audio`,
so it's available in every Claude Code session on this machine without
needing this repo at all. This repo exists so it can be carried to other
machines or shared with other people later.

## Try it elsewhere without installing

```
claude --plugin-dir /path/to/claude-transcribe-audio
```

## Install as a personal skill on another machine

Copy `skills/transcribe-audio/` into that machine's `~/.claude/skills/`,
then run its `scripts/setup.ps1` once (see the SKILL.md for the exact
command - it just needs Python 3 and an internet connection for the first
run).

## Publish it as an installable plugin (later, if wanted)

1. Push this repo to GitHub (or any git host).
2. Add a `.claude-plugin/marketplace.json` at the repo root listing this
   plugin (see any plugin in the `claude-plugins-official` marketplace
   for the exact schema - `~/.claude/plugins/marketplaces/claude-plugins-official/.claude-plugin/marketplace.json`
   is a good reference).
3. Anyone (including future-you on a different machine) can then run:
   ```
   /plugin marketplace add <this-repo-url>
   /plugin install transcribe-audio
   ```

## What's inside

```
.claude-plugin/plugin.json          - plugin manifest
skills/transcribe-audio/
  SKILL.md                          - what it does, when Claude should use it
  scripts/
    transcribe.py                   - the actual transcription script
    requirements.txt                - just faster-whisper
    setup.ps1                       - one-time venv + install, idempotent
```

No hardcoded paths - everything resolves relative to its own location
(`${CLAUDE_PLUGIN_ROOT}` in the skill, `$PSScriptRoot` in the setup
script), so this folder works wherever it's copied.

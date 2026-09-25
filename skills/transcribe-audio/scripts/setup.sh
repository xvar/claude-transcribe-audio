#!/usr/bin/env bash
# One-time setup for the transcribe-audio skill on Linux/WSL: creates a local
# venv and installs faster-whisper into it. Safe to re-run - skips work that's
# already done. Uses uv, since distro Python often ships without venv/ensurepip.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
venv_py="$here/venv/bin/python"

if [ -x "$venv_py" ] && "$venv_py" -c "import faster_whisper" 2>/dev/null; then
    echo "Already set up: $venv_py"
    exit 0
fi

uv_bin="$(command -v uv || echo "$HOME/.local/bin/uv")"
if [ ! -x "$uv_bin" ]; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    uv_bin="$HOME/.local/bin/uv"
fi

"$uv_bin" venv "$here/venv"
"$uv_bin" pip install --python "$venv_py" -r "$here/requirements.txt"
echo "Setup complete: $venv_py"

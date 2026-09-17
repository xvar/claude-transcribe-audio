# One-time setup for the transcribe-audio skill: creates a local venv and
# installs faster-whisper into it. Safe to re-run - skips work that's
# already done. Fully relative to this script's own location, so it works
# wherever the plugin/skill folder ends up.
$ErrorActionPreference = "Stop"

$venvDir = Join-Path $PSScriptRoot "venv"
$venvPy = Join-Path $venvDir "Scripts\python.exe"

function Find-Python {
    $candidates = @(
        (Get-Command python -ErrorAction SilentlyContinue).Source,
        (Get-Command python3 -ErrorAction SilentlyContinue).Source,
        "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe",
        "$env:LOCALAPPDATA\Programs\Python\Python313\python.exe",
        "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe"
    )
    foreach ($c in $candidates) {
        if ($c -and (Test-Path $c)) { return $c }
    }
    return $null
}

if (Test-Path $venvPy) {
    $check = & $venvPy -c "import faster_whisper" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Output "Already set up: $venvPy"
        exit 0
    }
}

$basePy = Find-Python
if (-not $basePy) {
    Write-Output "No Python found. Install it first, e.g.:"
    Write-Output "  winget install --id=Python.Python.3.12 -e --accept-source-agreements --accept-package-agreements --silent --scope user"
    exit 1
}

Write-Output "Using base Python: $basePy"
& $basePy -m venv $venvDir
& $venvPy -m pip install --upgrade pip
& $venvPy -m pip install -r (Join-Path $PSScriptRoot "requirements.txt")

Write-Output "Setup complete: $venvPy"

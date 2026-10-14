# ============================================================
#  Push the BaZi reference dataset to GitHub.
#  Run in PowerShell on YOUR machine (uses your own network):
#
#    & "C:\Users\Administrator\WorkBuddy\2026-08-19-02-44-13\destiny-ai\datasets\bazi-reference-dataset\push-to-github.ps1"
#
#  If PowerShell blocks it, first run:
#    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# ============================================================

$ErrorActionPreference = "Stop"

$gh       = "C:\Program Files\GitHub CLI\gh.exe"
$repoDir  = "C:\Users\Administrator\WorkBuddy\2026-08-19-02-44-13\destiny-ai\datasets\bazi-reference-dataset"
$remoteUrl= "https://github.com/cjz830108-oss/bazi-reference-dataset.git"

if (-not (Test-Path $gh))      { Write-Host "GitHub CLI not found at $gh" -ForegroundColor Red; exit 1 }
if (-not (Test-Path $repoDir))  { Write-Host "Dataset dir not found: $repoDir" -ForegroundColor Red; exit 1 }

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Step 1/2  -  Paste a GitHub token" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host " Need a token? Create one (mark 'repo' permission) at:"
Write-Host "   https://github.com/settings/personal-access-tokens/new"
Write-Host ""
Write-Host " The token is used in memory only - it is NOT saved to disk"
Write-Host " and NOT written into the git config."
Write-Host ""

$token = Read-Host "Paste token here (input is visible, but nothing is stored)"

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host ""
    Write-Host "No token entered - nothing was pushed." -ForegroundColor Yellow
    Write-Host "Alternative: open the repo page, Add file > uploading an existing file,"
    Write-Host "drag the folder $repoDir , then click 'Commit changes'."
    exit 1
}

$env:GH_TOKEN = $token.Trim()

Write-Host ""
Write-Host "Verifying token..." -ForegroundColor Cyan
try {
    $login = & $gh api user --jq .login 2>&1
    if ($LASTEXITCODE -ne 0) { throw "token rejected" }
    Write-Host "  Logged in as: $login" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host " Token rejected: $login" -ForegroundColor Red
    Write-Host " Check that the token belongs to cjz830108-oss and has 'repo' scope." -ForegroundColor Yellow
    $env:GH_TOKEN = $null
    exit 1
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Step 2/2  -  Pushing dataset" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

git -C $repoDir remote remove origin 2>$null
git -C $repoDir remote add origin $remoteUrl
git -C $repoDir push -u origin main

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host " Push failed." -ForegroundColor Red
    $env:GH_TOKEN = $null
    exit 1
}

# Clean the credential out of git config so nothing lingers.
git -C $repoDir config --unset-all http.https://github.com/.extraheader 2>$null
$env:GH_TOKEN = $null

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " DONE. The repo should now show 5 files and 1 commit:" -ForegroundColor Green
Write-Host "   https://github.com/cjz830108-oss/bazi-reference-dataset" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green

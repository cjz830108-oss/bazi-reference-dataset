@echo off
REM ============================================================
REM  One-shot: log in to GitHub CLI + push the BaZi reference dataset.
REM  Run this in PowerShell on YOUR machine (uses your own network).
REM  If asked for a token, paste a Fine-grained PAT with "repo" scope.
REM ============================================================
setlocal
set GH="C:\Program Files\GitHub CLI\gh.exe"
set REPO_DIR=C:\Users\Administrator\WorkBuddy\2026-08-19-02-44-13\destiny-ai\datasets\bazi-reference-dataset
set REMOTE_URL=https://github.com/cjz830108-oss/bazi-reference-dataset.git

echo ============================================================
echo  Step 1 of 2 - GitHub login
echo  Paste a Fine-grained token with "repo" permission when asked.
echo  Create one at: https://github.com/settings/personal-access-tokens/new
echo ============================================================
"%GH%" auth login --hostname github.com --git-protocol https --with-token

if errorlevel 1 (
  echo.
  echo Login failed or cancelled - nothing was pushed.
  echo Alternative: open the repo page and drag the folder
  echo   %REPO_DIR%
  echo then click "Commit changes".
  pause
  exit /b 1
)

echo.
echo ============================================================
echo  Step 2 of 2 - Pushing dataset
echo ============================================================
git -C "%REPO_DIR%" remote remove origin 2>nul
git -C "%REPO_DIR%" remote add origin "%REMOTE_URL%"
git -C "%REPO_DIR%" push -u origin main

if errorlevel 1 (
  echo.
  echo Push failed. Make sure the token has "repo" scope for this account.
  pause
  exit /b 1
)

echo.
echo ============================================================
echo  DONE - repo should now show 5 files and 1 commit:
echo  https://github.com/cjz830108-oss/bazi-reference-dataset
echo ============================================================
pause

@echo off
title Anti-LNK USB Cleaner
cd /d "%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -File "anti-lnk.ps1"

echo.
echo Script finished.
pause

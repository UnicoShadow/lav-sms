@echo off
title LAV SMS - Setup
cd /d "%~dp0"
echo Launching repair script...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0fix.ps1"
pause

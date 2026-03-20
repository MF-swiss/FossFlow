@echo off
cd /d "c:\Users\m_fri\OneDrive\Documents\GitHub\FossFlow\packages\fossflow-app"
setlocal enabledelayedexpansion
set PATH=C:\Program Files\nodejs;%PATH%
title FossFlow Desktop App
echo Starting FossFlow Desktop App...
echo Starting Dev Server on http://localhost:3000...
call npm run electron-dev


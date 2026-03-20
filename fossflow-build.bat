@echo off
cd /d "c:\Users\m_fri\OneDrive\Documents\GitHub\FossFlow\packages\fossflow-app"
setlocal enabledelayedexpansion
set PATH=C:\Program Files\nodejs;%PATH%
title FossFlow Build
echo Building FossFlow Desktop App...
echo This may take several minutes...
timeout /t 2 /nobreak
call npm run electron-build
echo.
echo Build completed!
echo The installer should be in the dist folder.
pause

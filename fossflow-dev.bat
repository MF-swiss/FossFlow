@echo off
cd /d "c:\Users\m_fri\OneDrive\Documents\GitHub\FossFlow"
setlocal enabledelayedexpansion
set PATH=C:\Program Files\nodejs;%PATH%
title FossFlow Dev Server
echo Starting FossFlow Dev Server...
echo Frontend: http://localhost:3000
echo Please wait while the server starts...
call npm run dev

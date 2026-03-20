@echo off
cd /d "c:\Users\m_fri\OneDrive\Documents\GitHub\FossFlow"
setlocal enabledelayedexpansion
set PATH=C:\Program Files\nodejs;%PATH%
call npm run dev
pause

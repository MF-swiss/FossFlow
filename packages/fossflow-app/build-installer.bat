@echo off
REM Build script für FossFlow Installer
REM Erstellt einen Windows Installer aus den Build-Dateien

setlocal enabledelayedexpansion
set PATH=C:\Program Files\nodejs;%PATH%

echo.
echo ========================================
echo   FossFlow Installer Builder
echo ========================================
echo.

REM Navigate to app directory
cd /d "%~dp0"

REM Check if build directory exists
if not exist "build" (
    echo [ERROR] Build directory not found!
    echo Please run: npm run build
    pause
    exit /b 1
)

REM Create dist directory for installer files
if not exist "dist" mkdir dist

REM Copy build files
echo Copying build files to dist...
if exist "dist\build" rmdir /s /q "dist\build"
xcopy /E /I /Y "build" "dist\build"

REM Copy electron files
echo Copying electron files...
if not exist "dist\electron" mkdir "dist\electron"
copy /Y "electron\main.js" "dist\electron\main.js" 2>nul || copy /Y "..\..\public\electron\main.js" "dist\electron\main.js"
copy /Y "electron\preload.js" "dist\electron\preload.js" 2>nul || copy /Y "..\..\public\electron\preload.js" "dist\electron\preload.js"

REM Create portable launcher
echo Creating portable launcher...
(
    echo @echo off
    echo title FossFlow
    echo setlocal enabledelayedexpansion
    echo set PATH=C:\Program Files\nodejs;%%PATH%%
    echo cd /d "%%~dp0"
    echo node electron\main.js
) > "dist\FossFlow.bat"

REM Create zip file with installer
echo Creating installer package...
if exist "dist\FossFlow-Setup.zip" del "dist\FossFlow-Setup.zip"

REM For Windows 11/10 with built-in ZIP support
powershell -Command "^
  Compress-Archive ^
    -Path @('dist\build', 'dist\electron', 'dist\install.bat', 'dist\FossFlow.bat') ^
    -DestinationPath 'dist\FossFlow-Setup.zip' ^
    -Force
" 2>nul

if exist "dist\FossFlow-Setup.zip" (
    echo [OK] Installer created: FossFlow-Setup.zip
) else (
    echo [WARNING] ZIP creation failed. Using manual method...
)

echo.
echo ========================================
echo   Build Complete!
echo ========================================
echo.
echo Installer files location:
echo   %CD%\dist\
echo.
echo To install FossFlow:
echo   1. Extract FossFlow-Setup.zip
echo   2. Run install.bat
echo   3. Click the desktop shortcut
echo.
pause

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

REM Copy local server script (no external deps)
echo Copying local server script...
copy /Y "FossFlowServer.js" "dist\FossFlowServer.js" >nul

REM Create launcher
echo Creating launcher...
(
    echo @echo off
    echo title FossFlow
    echo setlocal enabledelayedexpansion
    echo cd /d "%%~dp0"
    echo where node ^>nul 2^>^&1
    echo if errorlevel 1 ^(
    echo   echo [ERROR] Node.js not found. Please run install.bat again.
    echo   pause
    echo   exit /b 1
    echo ^)
    echo start "" "http://127.0.0.1:4173"
    echo node FossFlowServer.js
) > "dist\FossFlow.bat"

REM Create installer script
echo Creating install script...
(
    echo @echo off
    echo setlocal enableextensions
    echo title FossFlow Installer
    echo.
    echo set "SCRIPT_DIR=%%~dp0"
    echo if "%%SCRIPT_DIR:~-1%%"=="\" set "SCRIPT_DIR=%%SCRIPT_DIR:~0,-1%%"
    echo.
    echo set "DEFAULT_INSTALL_DIR=%%LOCALAPPDATA%%\Programs\FossFlow"
    echo net session ^>nul 2^>^&1
    echo if %%errorlevel%%==0 set "DEFAULT_INSTALL_DIR=%%ProgramFiles%%\FossFlow"
    echo set "INSTALL_DIR=%%DEFAULT_INSTALL_DIR%%"
    echo.
    echo echo Installing to: %%INSTALL_DIR%%
    echo.
    echo where node ^>nul 2^>^&1
    echo if not errorlevel 1 ^(
    echo     echo [OK] Node.js found.
    echo     node -v
    echo ^) else ^(
    echo     echo [INFO] Node.js not found.
    echo     choice /C YN /N /M "Install Node.js LTS automatically via winget? [Y/N]: "
    echo     if errorlevel 2 ^(
    echo         start "" "https://nodejs.org/en/download"
    echo         echo Please install Node.js and run install.bat again.
    echo         pause
    echo         exit /b 1
    echo     ^)
    echo     winget install --id OpenJS.NodeJS.LTS -e --accept-package-agreements --accept-source-agreements
    echo     if errorlevel 1 ^(
    echo         echo [ERROR] Node.js installation failed.
    echo         pause
    echo         exit /b 1
    echo     ^)
    echo ^)
    echo.
    echo if not exist "%%INSTALL_DIR%%" mkdir "%%INSTALL_DIR%%"
    echo if errorlevel 1 ^(
    echo     echo [ERROR] Could not create install directory: %%INSTALL_DIR%%
    echo     pause
    echo     exit /b 1
    echo ^)
    echo.
    echo echo Copying files...
    echo xcopy /E /I /Y "%%SCRIPT_DIR%%\build" "%%INSTALL_DIR%%\build" ^>nul
    echo xcopy /E /I /Y "%%SCRIPT_DIR%%\electron" "%%INSTALL_DIR%%\electron" ^>nul
    echo copy /Y "%%SCRIPT_DIR%%\FossFlow.bat" "%%INSTALL_DIR%%\FossFlow.bat" ^>nul
    echo copy /Y "%%SCRIPT_DIR%%\FossFlowServer.js" "%%INSTALL_DIR%%\FossFlowServer.js" ^>nul
    echo copy /Y "%%SCRIPT_DIR%%\uninstall.bat" "%%INSTALL_DIR%%\uninstall.bat" ^>nul
    echo.
    echo echo Creating shortcuts...
    echo powershell -NoProfile -ExecutionPolicy Bypass -Command "$ws = New-Object -ComObject WScript.Shell; $desktop = [Environment]::GetFolderPath('Desktop'); $icon = Join-Path '%%INSTALL_DIR%%' 'build\\favicon.ico'; $lnk = $ws.CreateShortcut((Join-Path $desktop 'FossFlow.lnk')); $lnk.TargetPath = Join-Path '%%INSTALL_DIR%%' 'FossFlow.bat'; $lnk.WorkingDirectory = '%%INSTALL_DIR%%'; $lnk.IconLocation = $icon; $lnk.Save(); $startMenu = Join-Path $env:APPDATA 'Microsoft\\Windows\\Start Menu\\Programs'; $lnk2 = $ws.CreateShortcut((Join-Path $startMenu 'FossFlow.lnk')); $lnk2.TargetPath = Join-Path '%%INSTALL_DIR%%' 'FossFlow.bat'; $lnk2.WorkingDirectory = '%%INSTALL_DIR%%'; $lnk2.IconLocation = $icon; $lnk2.Save();"
    echo.
    echo echo [OK] FossFlow installed to: %%INSTALL_DIR%%
    echo echo Use desktop/start menu shortcut to launch FossFlow.
    echo pause
) > "dist\install.bat"

REM Create uninstaller script
echo Creating uninstall script...
(
    echo @echo off
    echo setlocal enableextensions
    echo title FossFlow Uninstaller
    echo.
    echo set "INSTALL_DIR=%%~dp0"
    echo if "%%INSTALL_DIR:~-1%%"=="\" set "INSTALL_DIR=%%INSTALL_DIR:~0,-1%%"
    echo.
    echo echo Uninstalling FossFlow from: %%INSTALL_DIR%%
    echo.
    echo del "%%USERPROFILE%%\Desktop\FossFlow.lnk" 2^>nul
    echo del "%%APPDATA%%\Microsoft\Windows\Start Menu\Programs\FossFlow.lnk" 2^>nul
    echo.
    echo cd /d "%%TEMP%%"
    echo rmdir /s /q "%%INSTALL_DIR%%"
    echo.
    echo if exist "%%INSTALL_DIR%%" ^(
    echo     echo [WARNING] Some files could not be removed. Try running as Administrator.
    echo ^) else ^(
    echo     echo [OK] FossFlow was removed successfully.
    echo ^)
    echo pause
) > "dist\uninstall.bat"

REM Create zip file with installer
echo Creating installer package...
if exist "dist\FossFlow-Installer.zip" del "dist\FossFlow-Installer.zip"

REM For Windows 11/10 with built-in ZIP support
powershell -NoProfile -ExecutionPolicy Bypass -Command "Compress-Archive -Path @('dist\build','dist\electron','dist\install.bat','dist\uninstall.bat','dist\FossFlow.bat','dist\FossFlowServer.js') -DestinationPath 'dist\FossFlow-Installer.zip' -Force" 2>nul

if exist "dist\FossFlow-Installer.zip" (
    echo [OK] Installer created: FossFlow-Installer.zip
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
echo   1. Extract FossFlow-Installer.zip
echo   2. Run install.bat
echo   3. Click the desktop shortcut
echo.
pause

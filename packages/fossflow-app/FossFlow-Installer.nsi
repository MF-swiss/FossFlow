; FossFlow Windows Installer Script
; This script creates a Windows installer for FossFlow

!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"

; Name and file
Name "FossFlow"
OutFile "dist\FossFlow-Setup-1.10.8.exe"
InstallDir "$PROGRAMFILES\FossFlow"

; Request application privileges for Windows Vista and higher
RequestExecutionLevel admin

; Variables
Var StartMenuFolder

; MUI Settings
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "German"

; Installer sections
Section "Install"
  SetOutPath "$INSTDIR"
  
  ; Copy all files from build directory
  File /r "build\*.*"
  File "..\..\public\electron\main.js"
  File "..\..\public\electron\preload.js"
  File "..\..\public\electron\README.md"
  
  ; Copy Node.js wrapper script
  FileOpen $0 "$INSTDIR\FossFlow.bat" w
  FileWrite $0 "@echo off$\r$\n"
  FileWrite $0 "title FossFlow$\r$\n"
  FileWrite $0 "setlocal enabledelayedexpansion$\r$\n"
  FileWrite $0 "set PATH=C:\Program Files\nodejs;%PATH%$\r$\n"
  FileWrite $0 "cd /d ""$INSTDIR""$\r$\n"
  FileWrite $0 "node electron\main.js$\r$\n"
  FileClose $0
  
  ; Create start menu folder
  CreateDirectory "$SMPROGRAMS\FossFlow"
  CreateShortcut "$SMPROGRAMS\FossFlow\FossFlow.lnk" "$INSTDIR\FossFlow.bat" "" "$INSTDIR\favicon.ico"
  CreateShortcut "$SMPROGRAMS\FossFlow\Uninstall FossFlow.lnk" "$INSTDIR\uninstall.exe"
  
  ; Create desktop shortcut
  CreateShortcut "$DESKTOP\FossFlow.lnk" "$INSTDIR\FossFlow.bat" "" "$INSTDIR\favicon.ico"
  
  ; Create uninstaller
  WriteUninstaller "$INSTDIR\uninstall.exe"
  
  ; Registry entries for uninstall
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FossFlow" "DisplayName" "FossFlow"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FossFlow" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FossFlow" "DisplayVersion" "1.10.8"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FossFlow" "Publisher" "FossFlow"
  
SectionEnd

; Uninstaller section
Section "Uninstall"
  ; Remove files
  RMDir /r "$INSTDIR"
  
  ; Remove shortcuts
  RMDir /r "$SMPROGRAMS\FossFlow"
  Delete "$DESKTOP\FossFlow.lnk"
  
  ; Remove registry entries
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FossFlow"
SectionEnd

; Helper function to check if a string is in a list
Function un.onInit
  ; Check if app is running
  FindProcDLL::FindProc "FossFlow.bat"
  ${If} $R0 != 0
    MessageBox MB_OK "FossFlow is running. Please close it first."
    Quit
  ${EndIf}
FunctionEnd

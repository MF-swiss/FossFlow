# FossFlow Desktop Application

Diese Datei enthält die Electron-Konfiguration für die Desktop-Version von FossFlow.

## Verfügbare Scripts

### Entwicklungsmodus
```bash
npm run electron-dev --workspace=packages/fossflow-app
```
Oder nutze das Batch-Script:
```
fossflow-electron-dev.bat
```

Dies startet:
- Frontend Dev-Server (Port 3000)
- Electron App mit Hot-Reload
- Developer Tools

### Produktion Build
```bash
npm run electron-build --workspace=packages/fossflow-app
```
Oder nutze das Batch-Script:
```
fossflow-build.bat
```

Dies erzeugt:
- `FossFlow Setup.exe` - Windows Installer
- `FossFlow.exe` - Portable Version

## Dateien

- `public/electron/main.js` - Electron Main Process
- `public/electron/preload.js` - Sicherheits-Bridge
- `package.json` - Electron & Builder Konfiguration

## Icon

Ich habe noch kein Custom Icon erstellt. Du kannst folgende Icons hinzufügen:
- `public/icon.png` (256x256 oder größer)
- `public/icon.ico` (für Windows)

Oder lass mich ein Icon erstellen!

## Architektur

```
Frontend (React)
    ↓
Electron Browser Window
    ↓
Node.js Prozess (main.js)
```

Das Frontend lädt sich vom Dev-Server während der Entwicklung,
und vom Build-Ordner in der Produktion.

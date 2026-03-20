# FossFlow Windows Installer

Diese Anleitung beschreibt die **aktuelle, funktionierende Windows-Installation** von FossFlow.

## Voraussetzungen

- Windows 10/11
- Node.js >= 18
- Internet nur nötig, falls Node.js erst installiert werden muss

> Hinweis: Administratorrechte sind **optional**. Ohne Admin installiert der Installer pro Benutzer.

## Installation (Empfänger)

1. `FossFlow-Installer.zip` vollständig entpacken.
2. `install.bat` starten.
3. Falls Node.js fehlt:
  - `y` = automatische Installation via `winget`
  - `n` = Node.js Downloadseite öffnen
4. Nach Abschluss FossFlow über den Desktop-Shortcut starten.

## Installationsorte

- **Mit Admin-Rechten:** `C:\Program Files\FossFlow`
- **Ohne Admin-Rechte:** `%LOCALAPPDATA%\Programs\FossFlow`

## Wie der Start funktioniert

Beim Start von `FossFlow.bat` wird ein lokaler Webserver gestartet und dann die App geöffnet:

- URL: `http://127.0.0.1:4173`

Das ist beabsichtigt und notwendig, damit die gebaute Web-App korrekt läuft.

## Dateien im Installer-Paket

```text
FossFlow-Installer.zip
├── install.bat
├── uninstall.bat
├── build/
└── electron/
```

## Deinstallation

Im Installationsordner:

- `uninstall.bat` ausführen

## Troubleshooting

### Browser öffnet, aber App lädt nicht

1. Prüfen, ob der lokale Server erreichbar ist:
  - `http://127.0.0.1:4173`
2. Falls nicht erreichbar:
  - FossFlow erneut über den Shortcut starten
  - ggf. Antivirus/Firewall für lokalen Port 4173 prüfen

### Node.js wird nicht gefunden

- `node --version` prüfen
- Installer erneut starten und Auto-Installation mit `y` wählen

### Installer bricht direkt ab

- ZIP komplett entpacken (nicht aus dem ZIP heraus starten)
- Dann `install.bat` erneut ausführen

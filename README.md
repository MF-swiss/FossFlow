# FossFlow – Installationsanleitung (Windows)

Diese README enthält **nur eine Anleitung**: wie FossFlow als Windows-App verteilt und installiert wird.

## Wofür ist FossFlow anwendbar?

FossFlow ist eine Anwendung zum Erstellen von **isometrischen Diagrammen** (z. B. IT-Architektur, Netzwerke, Systemübersichten, technische Skizzen).

Typische Einsatzfälle:
- Infrastruktur- und Netzwerkdiagramme
- Architektur-Visualisierung für Projekte
- Dokumentation von Systemlandschaften
- Schnelle technische Skizzen für Teams

## Zielgruppe dieser Anleitung

Diese Anleitung ist für Personen, die FossFlow auf einem Windows-PC installieren möchten, ohne Docker zu nutzen.

## Installation beim Empfänger (Schritt-für-Schritt)

1. Datei `FossFlow-Installer.zip` entpacken.
2. `install.bat` starten.
3. Falls Node.js fehlt, fragt der Installer:
   - `y` = automatische Installation von Node.js LTS (via `winget`)
   - `n` = Öffnen der Node.js Download-Seite
4. Nach Abschluss über Desktop-Shortcut **FossFlow** starten.

## Voraussetzungen

- Windows 10/11
- Administratorrechte optional (ohne Admin wird pro Benutzer installiert)
- Internetverbindung (nur nötig, falls Node.js nachinstalliert werden muss)

## Was der Installer automatisch erledigt

- Prüft, ob Node.js vorhanden ist
- Installiert Node.js auf Wunsch automatisch (via `winget`)
- Kopiert die App nach:
   - `C:\Program Files\FossFlow` (mit Admin)
   - `%LOCALAPPDATA%\Programs\FossFlow` (ohne Admin)
- Erstellt Desktop- und Startmenü-Shortcut
- Legt `uninstall.bat` zur Deinstallation an
- Startet FossFlow über einen lokalen Server unter `http://127.0.0.1:4173`

## Deinstallation

Datei `uninstall.bat` im jeweiligen Installationsordner ausführen.

## Für die Verteilung (Publisher-Hinweis)

Zu versendende Datei:

`packages/fossflow-app/dist/FossFlow-Installer.zip`

Damit der Empfänger nur noch entpackt und `install.bat` ausführt.

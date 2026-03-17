# sshmgr — SSH Connection Manager

Leichtgewichtiges CLI-Tool zur Verwaltung von SSH-Verbindungen, direkt aus dem macOS-Terminal.

**Keine externen Abhängigkeiten** — nur Python 3 (auf macOS vorinstalliert).

## Installation

```bash
git clone <repo-url> ~/Projects/ssh-console-manager
cd ~/Projects/ssh-console-manager
chmod +x install.sh && ./install.sh
```

Das Installscript:
- Erstellt einen Symlink nach `/usr/local/bin/sshmgr`
- Installiert Zsh-Tab-Completion
- Erstellt das Config-Verzeichnis `~/.config/sshmgr/`

### Manuelle Installation

```bash
chmod +x sshmgr
ln -s "$(pwd)/sshmgr" /usr/local/bin/sshmgr
```

## Schnellstart

```bash
# Setup prüfen
sshmgr doctor

# Bestehende SSH-Config importieren
sshmgr import

# Neue Verbindung anlegen
sshmgr add webserver

# Alle Verbindungen auflisten
sshmgr list

# Verbinden
sshmgr connect webserver

# Interaktive Auswahl
sshmgr select
```

## Befehle

| Befehl | Alias | Beschreibung |
|--------|-------|-------------|
| `sshmgr list` | `ls` | Verbindungen auflisten |
| `sshmgr add [name]` | `new` | Neue Verbindung anlegen |
| `sshmgr edit <name>` | | Verbindung bearbeiten |
| `sshmgr delete <name>` | `rm` | Verbindung löschen |
| `sshmgr connect [name]` | `c`, `ssh` | SSH-Verbindung starten |
| `sshmgr select` | `s` | Interaktives Auswahlmenü |
| `sshmgr show <name>` | `info` | Details anzeigen |
| `sshmgr search <text>` | `find`, `grep` | Verbindungen suchen |
| `sshmgr favorites` | `favs` | Favoriten anzeigen |
| `sshmgr fav <name>` | | Favorit-Status umschalten |
| `sshmgr rename <alt> <neu>` | `mv` | Verbindung umbenennen |
| `sshmgr tag list` | | Alle Tags anzeigen |
| `sshmgr tag add <name> <tags..>` | | Tags hinzufügen |
| `sshmgr tag remove <name> <tags..>` | | Tags entfernen |
| `sshmgr import` | | Aus ~/.ssh/config importieren |
| `sshmgr export` | | Als SSH-Config exportieren |
| `sshmgr backup` | | Backup erstellen |
| `sshmgr restore <datei>` | | Backup wiederherstellen |
| `sshmgr doctor` | | Setup prüfen |

## Optionen

```bash
# Liste mit Details
sshmgr list -v

# Nur bestimmten Tag anzeigen
sshmgr list -t production

# Nur Favoriten
sshmgr list -f

# Verbinden ohne Bestätigung
sshmgr connect webserver -y

# Als JSON exportieren
sshmgr export --format json -o backup.json

# Aus eigener Config importieren
sshmgr import -f ~/custom-ssh-config
```

## Datenspeicherung

Alle Daten liegen in `~/.config/sshmgr/`:

```
~/.config/sshmgr/
├── connections.json    # Verbindungsdaten (chmod 600)
└── settings.json       # Einstellungen (optional)
```

**Keine Passwörter** werden gespeichert — Authentifizierung läuft ausschließlich über SSH-Keys.

### Verbindungs-Felder

| Feld | Beschreibung |
|------|-------------|
| `host` | Hostname oder IP |
| `port` | SSH-Port (Standard: 22) |
| `user` | Benutzername |
| `identity_file` | Pfad zum SSH-Key |
| `description` | Freitext-Beschreibung |
| `proxy_jump` | ProxyJump / Bastion Host |
| `alias` | Alternativer Name |
| `tags` | Liste von Tags/Gruppen |
| `favorite` | Favorit-Markierung |
| `ssh_options` | Zusätzliche SSH-Optionen |

## Zsh-Completion

Nach der Installation mit `install.sh` funktioniert Tab-Completion automatisch:

```bash
sshmgr con<TAB>        → sshmgr connect
sshmgr connect web<TAB> → sshmgr connect webserver
```

## Sicherheit

- Config-Verzeichnis: `700` (nur User)
- Verbindungsdatei: `600` (nur User lesen/schreiben)
- Keine Passwort-Speicherung
- SSH-Key-basierte Authentifizierung
- `sshmgr doctor` prüft Berechtigungen

## Erweiterbarkeit

Das Tool ist bewusst als einzelnes Python-Script gehalten. Erweiterungsmöglichkeiten:

- **Neue Befehle**: Funktion `cmd_xyz` erstellen + in `main()` als Subparser registrieren
- **SSH-Optionen**: Feld `ssh_options` in der Verbindung unterstützt beliebige `-o`-Flags
- **Integration**: `sshmgr export --format json` liefert maschinenlesbare Ausgabe
- **Scripting**: `sshmgr connect <name> -y` verbindet ohne Bestätigung

## Lizenz

MIT

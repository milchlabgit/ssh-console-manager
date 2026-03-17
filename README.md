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
# Setup pruefen
sshmgr doctor

# Bestehende SSH-Config importieren
sshmgr import

# Neue Verbindung anlegen (inkl. optionaler Key-Generierung)
sshmgr add webserver

# Alle Verbindungen auflisten
sshmgr list

# Verbinden
sshmgr connect webserver

# Interaktive Auswahl
sshmgr select

# SSH-Key generieren (standalone)
sshmgr keygen
```

## Befehle

### Verbindungen verwalten

| Befehl | Alias | Beschreibung |
|--------|-------|-------------|
| `sshmgr add [name]` | `new` | Neue Verbindung anlegen |
| `sshmgr edit <name>` | | Verbindung bearbeiten |
| `sshmgr delete <name>` | `rm` | Verbindung loeschen |
| `sshmgr rename <alt> <neu>` | `mv` | Verbindung umbenennen |
| `sshmgr show <name>` | `info` | Details + SSH-Befehl anzeigen |

### Verbinden

| Befehl | Alias | Beschreibung |
|--------|-------|-------------|
| `sshmgr connect [name]` | `c`, `ssh` | SSH-Verbindung starten |
| `sshmgr select` | `s` | Interaktives Auswahlmenue |

### Auflisten & Suchen

| Befehl | Alias | Beschreibung |
|--------|-------|-------------|
| `sshmgr list` | `ls` | Verbindungen auflisten |
| `sshmgr search <text>` | `find`, `grep` | Verbindungen durchsuchen |
| `sshmgr favorites` | `favs` | Favoriten anzeigen |
| `sshmgr fav <name>` | | Favorit-Status umschalten |

### Tags

| Befehl | Beschreibung |
|--------|-------------|
| `sshmgr tag list` | Alle Tags mit Balkendiagramm anzeigen |
| `sshmgr tag add <name> <tags..>` | Tags hinzufuegen |
| `sshmgr tag remove <name> <tags..>` | Tags entfernen |

### SSH-Keys

| Befehl | Alias | Beschreibung |
|--------|-------|-------------|
| `sshmgr keygen` | `key` | SSH-Key generieren (Assistent) |

Der Key-Assistent fuehrt durch:
1. Key-Typ waehlen (ed25519/rsa/ecdsa)
2. Dateiname und Kommentar festlegen
3. Passphrase (optional, mit macOS Keychain)
4. Key generieren
5. Public Key auf Server kopieren (`ssh-copy-id`)
6. Optional: direkt Verbindung anlegen

Beim `sshmgr add` kann der Key-Assistent direkt aufgerufen werden:
```
SSH Key (Pfad, oder 'neu' zum Generieren): neu
```
Nach der Key-Generierung wird angeboten, den Public Key direkt auf den Zielserver zu kopieren.

### Import / Export / Backup

| Befehl | Beschreibung |
|--------|-------------|
| `sshmgr import` | Aus `~/.ssh/config` importieren |
| `sshmgr export` | Als SSH-Config oder JSON exportieren |
| `sshmgr backup` | Backup der Verbindungsdaten erstellen |
| `sshmgr restore <datei>` | Backup wiederherstellen |

### System

| Befehl | Beschreibung |
|--------|-------------|
| `sshmgr doctor` | Setup, Keys und Berechtigungen pruefen |

## Optionen

```bash
# Liste mit Details
sshmgr list -v

# Nur bestimmten Tag anzeigen
sshmgr list -t production

# Nur Favoriten
sshmgr list -f

# Verbinden ohne Bestaetigungsdialog
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

**Keine Passwoerter** werden gespeichert — Authentifizierung laeuft ausschliesslich ueber SSH-Keys.

### Verbindungs-Felder

| Feld | Beschreibung |
|------|-------------|
| `host` | Hostname oder IP |
| `port` | SSH-Port (Standard: 22) |
| `user` | Benutzername |
| `identity_file` | Pfad zum SSH-Key |
| `description` | Freitext-Beschreibung |
| `proxy_jump` | ProxyJump / Bastion Host |
| `alias` | Alternativer Name (auch fuer connect/show nutzbar) |
| `tags` | Liste von Tags/Gruppen |
| `favorite` | Favorit-Markierung |
| `ssh_options` | Zusaetzliche SSH `-o` Optionen |
| `last_connected` | Zeitstempel der letzten Verbindung |

### settings.json (optional)

```json
{
  "editor": "nano",
  "default_port": 22,
  "default_user": "deploy",
  "color": true,
  "show_details_before_connect": true
}
```

## Terminal-Farben

sshmgr nutzt ANSI-Farben fuer eine uebersichtliche Darstellung:

- **Verbindungsnamen** in Weiss/Bold
- **User** in Gruen, **Host** in Cyan, **Port** in Gelb
- **Favoriten** mit gelbem Stern
- **Tags** in Magenta mit `#`-Prefix
- **Beschreibung/Details** mit Baumstruktur (`│`)
- **SSH-Befehl** in Gruen hervorgehoben
- **Tag-Uebersicht** mit Balkendiagramm
- **Header** mit Linien-Rahmen

Farben werden automatisch deaktiviert wenn:
- Die Ausgabe kein TTY ist (z.B. bei Pipe)
- `"color": false` in `settings.json` gesetzt ist

## Zsh-Completion

Nach der Installation mit `install.sh` funktioniert Tab-Completion automatisch:

```bash
sshmgr con<TAB>         → sshmgr connect
sshmgr connect web<TAB> → sshmgr connect webserver
sshmgr list -t pro<TAB> → sshmgr list -t production
```

Completion unterstuetzt: Befehle, Verbindungsnamen, Aliases, Tags und Optionen.

## Sicherheit

- Config-Verzeichnis: `700` (nur User)
- Verbindungsdatei: `600` (nur User lesen/schreiben)
- Keine Passwort-Speicherung
- SSH-Key-basierte Authentifizierung
- `sshmgr doctor` prueft Berechtigungen und Key-Dateien
- Key-Generierung ueber Standard `ssh-keygen`

## Erweiterbarkeit

Das Tool ist bewusst als einzelnes Python-Script gehalten. Erweiterungsmoeglichkeiten:

- **Neue Befehle**: Funktion `cmd_xyz` erstellen + in `main()` als Subparser registrieren
- **SSH-Optionen**: Feld `ssh_options` unterstuetzt beliebige `-o`-Flags
- **Integration**: `sshmgr export --format json` liefert maschinenlesbare Ausgabe
- **Scripting**: `sshmgr connect <name> -y` verbindet ohne Bestaetigungsdialog

## Lizenz

MIT

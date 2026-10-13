# sshmgr — SSH Connection Manager

## Project Identity

`sshmgr` is a lightweight, dependency-free Python 3 CLI tool for managing SSH connections on macOS. It is implemented as a single executable Python script (`sshmgr`) with no external dependencies beyond the Python 3 standard library. It targets macOS terminal users and integrates with the system SSH toolchain (`ssh`, `ssh-keygen`, `ssh-copy-id`).

Current version: **1.0.0**

---

## Tech Stack

- **Language**: Python 3 (standard library only — no pip dependencies)
- **Standard library modules used**: `argparse`, `json`, `os`, `re`, `shutil`, `subprocess`, `sys`, `textwrap`, `datetime`, `pathlib`
- **Shell integration**: Zsh tab-completion (`completions/_sshmgr`)
- **External tools invoked at runtime**: `ssh`, `ssh-keygen`, `ssh-copy-id`

---

## How to Run

```bash
# Run directly from the repo
./sshmgr <command>

# After installation (creates /usr/local/bin/sshmgr symlink)
sshmgr <command>
```

### Installation

```bash
git clone <repo-url> ~/Projects/ssh-console-manager
cd ~/Projects/ssh-console-manager
chmod +x install.sh && ./install.sh
```

The installer (`install.sh`):
- Makes `sshmgr` executable
- Creates a symlink at `/usr/local/bin/sshmgr` (uses `sudo` if needed)
- Installs Zsh completion to `~/.zsh/completions/_sshmgr`
- Adds the completion path to `~/.zshrc` if not already present
- Creates `~/.config/sshmgr/` with permissions `700`

### Manual installation

```bash
chmod +x sshmgr
ln -s "$(pwd)/sshmgr" /usr/local/bin/sshmgr
```

---

## Commands and Features

### Connection management

| Command | Alias | Description |
|---------|-------|-------------|
| `sshmgr add [name]` | `new` | Add a new connection (interactive wizard) |
| `sshmgr edit <name>` | | Edit an existing connection |
| `sshmgr delete <name>` | `rm` | Delete a connection |
| `sshmgr rename <old> <new>` | `mv` | Rename a connection |
| `sshmgr show <name>` | `info` | Show connection details and SSH command |

### Connecting

| Command | Alias | Description |
|---------|-------|-------------|
| `sshmgr connect [name]` | `c`, `ssh` | Start an SSH connection |
| `sshmgr select` | `s` | Interactive selection menu |

### Listing and searching

| Command | Alias | Description |
|---------|-------|-------------|
| `sshmgr list` | `ls` | List all connections |
| `sshmgr search <text>` | `find`, `grep` | Search connections |
| `sshmgr favorites` | `favs` | Show favorites only |
| `sshmgr fav <name>` | | Toggle favorite status |

### Tags

| Command | Description |
|---------|-------------|
| `sshmgr tag list` | Show all tags with bar chart |
| `sshmgr tag add <name> <tags..>` | Add tags to a connection |
| `sshmgr tag remove <name> <tags..>` | Remove tags from a connection |

### SSH Keys

| Command | Alias | Description |
|---------|-------|-------------|
| `sshmgr keygen` | `key` | Interactive SSH key generation wizard |

The key wizard covers: key type (ed25519/rsa/ecdsa), filename, comment, optional passphrase (with macOS Keychain), `ssh-copy-id` to target server, and optional immediate connection creation.

During `sshmgr add`, entering `neu` at the key prompt triggers the key wizard inline.

### Import / Export / Backup

| Command | Description |
|---------|-------------|
| `sshmgr import` | Import from `~/.ssh/config` |
| `sshmgr export` | Export as SSH config or JSON |
| `sshmgr backup` | Create a backup of connection data |
| `sshmgr restore <file>` | Restore from backup |

### System

| Command | Description |
|---------|-------------|
| `sshmgr doctor` | Check setup, SSH keys, and permissions |

### Key options

```bash
sshmgr list -v                        # Verbose (show details)
sshmgr list -t production             # Filter by tag
sshmgr list -f                        # Favorites only
sshmgr connect webserver -y           # Connect without confirmation
sshmgr export --format json -o out.json
sshmgr import -f ~/custom-ssh-config
sshmgr --version
```

---

## Data Storage and Config Files

All data lives in `~/.config/sshmgr/`:

```
~/.config/sshmgr/
├── connections.json    # Connection data (chmod 600)
└── settings.json       # Optional user settings (chmod 600)
```

No passwords are stored. Authentication is exclusively via SSH keys.

### connections.json fields

| Field | Description |
|-------|-------------|
| `host` | Hostname or IP |
| `port` | SSH port (default: 22) |
| `user` | Username |
| `identity_file` | Path to SSH private key |
| `description` | Free-text description |
| `proxy_jump` | ProxyJump / bastion host |
| `alias` | Alternative name usable with `connect`/`show` |
| `tags` | List of tag strings |
| `favorite` | Boolean favorite marker |
| `ssh_options` | Additional SSH `-o` options (list of strings) |
| `last_connected` | ISO timestamp of last connection |

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

The `editor` setting falls back to the `$EDITOR` environment variable, then `nano`. `default_user` falls back to `$USER`.

---

## SSH Config Integration

`sshmgr import` parses `~/.ssh/config` (or a custom file via `-f`) and imports Host blocks as managed connections. `sshmgr export --format ssh-config` writes connections back out as a standard SSH config file.

---

## Zsh Tab-Completion

After running `install.sh`, tab-completion is available for commands, connection names, aliases, tags, and options. The completion script (`completions/_sshmgr`) uses `python3` to read `~/.config/sshmgr/connections.json` at completion time for dynamic name and tag expansion.

```bash
sshmgr con<TAB>          # → sshmgr connect
sshmgr connect web<TAB>  # → sshmgr connect webserver
sshmgr list -t pro<TAB>  # → sshmgr list -t production
```

---

## Architecture

The entire tool is a single Python script (`sshmgr`) with no package structure:

- `C` class — ANSI color codes; `C.disable()` strips all colors for non-TTY output or when `"color": false` in settings
- `_load_connections()` / `_save_connections()` — JSON persistence
- `_load_settings()` / `_save_settings()` — settings with defaults
- `_build_ssh_args()` — constructs the `ssh` command from a connection dict
- `_generate_key_interactive()` — key generation wizard
- `cmd_*` functions — one per top-level command, registered as argparse subparsers in `main()`

Colors are disabled automatically when stdout is not a TTY (e.g., when piping output).

---

## Development Setup

No virtual environment or package installation is needed.

```bash
# Clone and make executable
git clone <repo-url> ~/Projects/ssh-console-manager
cd ~/Projects/ssh-console-manager
chmod +x sshmgr

# Run directly
./sshmgr doctor
./sshmgr list

# Verify Python 3 is available (macOS ships with it)
python3 --version
```

To add a new command: create a `cmd_<name>(args)` function and register it as a subparser in `main()`.

---

## Security Notes

- Config directory permissions: `700` (owner only)
- Connections file permissions: `600` (owner read/write only)
- No password storage
- `sshmgr doctor` checks file permissions and verifies key files exist

---

## Claude-Konfiguration

- **Modell-Stufe B**: `sonnet` (Sonnet 5.5), Effort `medium` – siehe `.claude/settings.json`.
- **Repo**: `milchlabgit/ssh-console-manager`, Default-Branch `main`. **Das Repo ist öffentlich (PUBLIC)** – keine echten Hostnamen, IPs, Benutzernamen, Keys oder `connections.json` des Owners in Code, Tests, Doku oder Issues. Beispiele nur mit `example.com`/`192.0.2.x`.
- `~/.config/sshmgr/` und `~/.ssh/` werden von Claude nicht gelesen (deny in settings); `sshmgr connect` wird nicht automatisch ausgeführt.

| Agent | Modell | Wann |
|---|---|---|
| `python-dev` | sonnet | Neue Subcommands, Bugfixes, Completion und README synchron halten |
| `qa-engineer` | sonnet | QA-Gate (py_compile, `--version`) und Akzeptanzkriterien, nach jeder Umsetzung |
| `code-reviewer` | fable | Nur lesend; Diff-Review vor jedem PR, Fokus Stdlib-Regel, chmod 600, keine Owner-Daten |
| `explorer` | haiku | Breite Suche („wo wird Feld X gelesen") |

| Skill | Zweck |
|---|---|
| `/issue <nr>` | Issue holen, Branch anlegen, umsetzen, QA, Review, PR |
| `/new-issue <text>` | Issue mit Template und Labels anlegen |
| `/qa` | QA-Gate ausführen und berichten |
| `/pr` | PR mit Template und `Closes #n` erstellen |
| `/add-command` | Neues Subcommand mit argparse, `cmd_*`, Completion und README |
| `/add-connection` | Verbindung per `sshmgr add`/`import` anlegen und prüfen (lokal beim Owner) |

**QA-Gate**: `python3 -m py_compile sshmgr && bash -n install.sh && ./sshmgr --version` → keine Tests konfiguriert → kein Build. Vorschlag: `unittest`-Suite mit `HOME` auf ein Temp-Verzeichnis (stdlib, keine pip-Abhängigkeiten).

**Workflow**: Nicht-triviale Arbeit braucht ein GitHub-Issue. Branch `feature/<nr>-<kurz>` oder `fix/<nr>-<kurz>`, nie direkt auf `main`. Commits als Conventional Commits `type(scope): description (#nr)`. PR-Body mit `Closes #nr`, Labels des Issues übernehmen. Vor jedem PR: `/qa` grün und `code-reviewer` gelaufen; Findings beheben oder als Issue (`qa`) festhalten. Keine Secrets committen; Produktionssysteme nur nach Freigabe.

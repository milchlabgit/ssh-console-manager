#!/bin/bash
# sshmgr installer — creates symlink and sets up zsh completion

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SSHMGR="$SCRIPT_DIR/sshmgr"
INSTALL_DIR="${1:-/usr/local/bin}"
COMPLETION_DIR="${HOME}/.zsh/completions"

echo "sshmgr Installer"
echo "================"
echo ""

# Make executable
chmod +x "$SSHMGR"
echo "✓ sshmgr ausführbar gemacht"

# Symlink
if [ -w "$INSTALL_DIR" ]; then
    ln -sf "$SSHMGR" "$INSTALL_DIR/sshmgr"
    echo "✓ Symlink erstellt: $INSTALL_DIR/sshmgr"
else
    echo "→ Root-Rechte nötig für $INSTALL_DIR"
    sudo ln -sf "$SSHMGR" "$INSTALL_DIR/sshmgr"
    echo "✓ Symlink erstellt: $INSTALL_DIR/sshmgr"
fi

# Zsh completion
mkdir -p "$COMPLETION_DIR"
cp "$SCRIPT_DIR/completions/_sshmgr" "$COMPLETION_DIR/_sshmgr"
echo "✓ Zsh-Completion installiert: $COMPLETION_DIR/_sshmgr"

# Check if completion dir is in fpath
if ! grep -q 'fpath.*\.zsh/completions' "${HOME}/.zshrc" 2>/dev/null; then
    echo "" >> "${HOME}/.zshrc"
    echo "# sshmgr completion" >> "${HOME}/.zshrc"
    echo 'fpath=(~/.zsh/completions $fpath)' >> "${HOME}/.zshrc"
    echo 'autoload -Uz compinit && compinit' >> "${HOME}/.zshrc"
    echo "✓ Completion zu ~/.zshrc hinzugefügt"
    echo ""
    echo "! Bitte 'source ~/.zshrc' oder neues Terminal öffnen"
else
    echo "✓ Completion-Pfad bereits in ~/.zshrc"
fi

# Create config dir
mkdir -p "${HOME}/.config/sshmgr"
chmod 700 "${HOME}/.config/sshmgr"
echo "✓ Config-Verzeichnis erstellt: ~/.config/sshmgr"

echo ""
echo "✓ Installation abgeschlossen!"
echo ""
echo "Teste mit:  sshmgr --version"
echo "Starte mit: sshmgr doctor"

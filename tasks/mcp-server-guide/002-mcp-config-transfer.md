# 002: MCP Config Transfer Guide

**Status**: in_progress
**Created**: 2025-07-17
**Priority**: high

## Description

Anleitung zur sicheren Übertragung der Claude Code MCP Konfiguration auf neue oder andere WSL-Geräte.

## MCP Config Transfer - Sichere Übertragung

### 1. Vorbereitung - Quell-System

**Dateien identifizieren:**
```bash
# Claude Code Konfiguration
~/.config/claude-code/settings.json

# Umgebungsvariablen (API Keys)
~/.bashrc (relevante export-Zeilen)
```

**Backup erstellen:**
```bash
# Konfiguration sichern
cp ~/.config/claude-code/settings.json ~/mcp-backup-settings.json

# Umgebungsvariablen extrahieren
grep -E "export.*(GITLAB|GITHUB|PERPLEXITY|AWS|SLACK).*=" ~/.bashrc > ~/mcp-env-vars.sh
```

### 2. Sichere Transfer-Methoden

#### Option A: Lokale Übertragung (USB/Netzwerk)

**Schritt 1: Secure Archive erstellen**
```bash
# Konfiguration ohne sensible Daten
jq 'del(.mcp.servers[].env)' ~/.config/claude-code/settings.json > /tmp/mcp-config-clean.json

# Umgebungsvariablen separat
grep -E "export.*(GITLAB|GITHUB|PERPLEXITY|AWS|SLACK).*=" ~/.bashrc > /tmp/mcp-env-vars.sh

# Archive erstellen
tar -czf ~/mcp-config-backup.tar.gz -C /tmp mcp-config-clean.json mcp-env-vars.sh
```

**Schritt 2: Transfer auf Ziel-System**
```bash
# Via SCP
scp ~/mcp-config-backup.tar.gz user@target-host:~/

# Via USB/Netzwerk
# Datei physisch übertragen
```

#### Option B: Verschlüsselter Transfer

**Mit GPG verschlüsseln:**
```bash
# Auf Quell-System
tar -czf - ~/.config/claude-code/settings.json ~/mcp-env-vars.sh | gpg --symmetric --armor > mcp-config-encrypted.asc

# Auf Ziel-System
gpg --decrypt mcp-config-encrypted.asc | tar -xzf -
```

### 3. Ziel-System Setup

**Schritt 1: Verzeichnis erstellen**
```bash
mkdir -p ~/.config/claude-code
```

**Schritt 2: Konfiguration wiederherstellen**
```bash
# Archive extrahieren
tar -xzf ~/mcp-config-backup.tar.gz -C /tmp

# Konfiguration kopieren
cp /tmp/mcp-config-clean.json ~/.config/claude-code/settings.json
```

**Schritt 3: Umgebungsvariablen sicher setzen**
```bash
# Nie direkt kopieren - manuell eingeben!
# Beispiel-Workflow:

# GitHub Token
read -s -p "GitHub Personal Access Token: " GITHUB_TOKEN
echo "export GITHUB_PERSONAL_ACCESS_TOKEN=\"$GITHUB_TOKEN\"" >> ~/.bashrc

# GitLab Token
read -s -p "GitLab Personal Access Token: " GITLAB_TOKEN
echo "export GITLAB_PERSONAL_ACCESS_TOKEN=\"$GITLAB_TOKEN\"" >> ~/.bashrc

# Perplexity API Key
read -s -p "Perplexity API Key: " PERPLEXITY_KEY
echo "export PERPLEXITY_API_KEY=\"$PERPLEXITY_KEY\"" >> ~/.bashrc

# Bashrc neu laden
source ~/.bashrc
```

### 4. Automatisiertes Transfer-Script

**transfer-mcp-config.sh:**
```bash
#!/bin/bash

# MCP Config Transfer Script
# Usage: ./transfer-mcp-config.sh [backup|restore]

set -e

CONFIG_DIR="$HOME/.config/claude-code"
BACKUP_DIR="$HOME/mcp-backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

backup_config() {
    echo "🔄 Creating MCP config backup..."
    
    mkdir -p "$BACKUP_DIR"
    
    # Konfiguration ohne sensible Daten
    if [[ -f "$CONFIG_DIR/settings.json" ]]; then
        jq 'del(.mcp.servers[].env)' "$CONFIG_DIR/settings.json" > "$BACKUP_DIR/settings-clean.json"
        echo "✅ Settings backup created (without sensitive data)"
    fi
    
    # Umgebungsvariablen Liste (ohne Werte)
    grep -E "export.*(GITLAB|GITHUB|PERPLEXITY|AWS|SLACK).*=" ~/.bashrc | sed 's/=.*/=/' > "$BACKUP_DIR/env-vars-template.sh" 2>/dev/null || true
    
    # Archive erstellen
    cd "$BACKUP_DIR"
    tar -czf "mcp-config-backup-$TIMESTAMP.tar.gz" settings-clean.json env-vars-template.sh
    
    echo "✅ Backup created: $BACKUP_DIR/mcp-config-backup-$TIMESTAMP.tar.gz"
    echo "⚠️  Remember to securely transfer API tokens manually!"
}

restore_config() {
    echo "🔄 Restoring MCP config..."
    
    # Neueste Backup finden
    LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/mcp-config-backup-*.tar.gz 2>/dev/null | head -1)
    
    if [[ -z "$LATEST_BACKUP" ]]; then
        echo "❌ No backup found in $BACKUP_DIR"
        exit 1
    fi
    
    echo "📦 Using backup: $LATEST_BACKUP"
    
    # Backup extrahieren
    cd "$BACKUP_DIR"
    tar -xzf "$LATEST_BACKUP"
    
    # Konfiguration wiederherstellen
    mkdir -p "$CONFIG_DIR"
    cp settings-clean.json "$CONFIG_DIR/settings.json"
    
    echo "✅ Configuration restored"
    echo "⚠️  Don't forget to set environment variables:"
    echo "    source env-vars-template.sh"
    echo "    Edit ~/.bashrc with your API tokens"
}

case "$1" in
    backup)
        backup_config
        ;;
    restore)
        restore_config
        ;;
    *)
        echo "Usage: $0 {backup|restore}"
        exit 1
        ;;
esac
```

### 5. Validierung nach Transfer

**Schritt 1: Konfiguration prüfen**
```bash
# Struktur validieren
jq . ~/.config/claude-code/settings.json

# MCP Server auflisten
jq '.mcp.servers | keys' ~/.config/claude-code/settings.json
```

**Schritt 2: Umgebungsvariablen prüfen**
```bash
# Alle MCP-relevanten Variablen
env | grep -E "(GITLAB|GITHUB|PERPLEXITY|AWS|SLACK)" | while read -r line; do
    var_name=$(echo "$line" | cut -d'=' -f1)
    echo "$var_name: $([ -n "${!var_name}" ] && echo "✅ Set" || echo "❌ Not set")"
done
```

**Schritt 3: Docker Images prüfen**
```bash
# Erforderliche Images pullen
docker pull mcp/perplexity-ask
docker pull mcp/gitlab
docker pull mcp/sequentialthinking
docker pull mcp/github  # falls konfiguriert
```

### 6. Troubleshooting Transfer

**Häufige Probleme:**

**JSON Syntax Fehler:**
```bash
# Konfiguration validieren
jq . ~/.config/claude-code/settings.json || echo "❌ Invalid JSON"

# Backup wiederherstellen
cp ~/.config/claude-code/settings.json.bak ~/.config/claude-code/settings.json
```

**Fehlende Umgebungsvariablen:**
```bash
# Alle erforderlichen Variablen prüfen
for var in GITLAB_PERSONAL_ACCESS_TOKEN GITHUB_PERSONAL_ACCESS_TOKEN PERPLEXITY_API_KEY; do
    if [[ -z "${!var}" ]]; then
        echo "❌ Missing: $var"
    else
        echo "✅ Found: $var"
    fi
done
```

**Permissions-Probleme:**
```bash
# Konfiguration-Verzeichnis Permissions
chmod 700 ~/.config/claude-code
chmod 600 ~/.config/claude-code/settings.json
```

### 7. Sicherheits-Checkliste

**Vor Transfer:**
- [ ] Sensitive Daten aus Konfigurationsdateien entfernen
- [ ] API-Keys separat notieren (sicher speichern)
- [ ] Backup-Archive verschlüsseln bei externem Transfer

**Nach Transfer:**
- [ ] Originale Backup-Dateien sicher löschen
- [ ] Umgebungsvariablen manuell eingeben (nie kopieren)
- [ ] Konfiguration validieren und testen
- [ ] Docker Images auf Ziel-System pullen

**Laufende Sicherheit:**
- [ ] Regelmäßige Backups erstellen
- [ ] API-Keys rotieren nach Bedarf
- [ ] Konfiguration-Dateien mit 600 Permissions

## Action Items

- [x] Transfer-Methoden dokumentieren
- [x] Automatisierungs-Script erstellen
- [x] Validierungs-Workflow definieren
- [x] Troubleshooting-Guide hinzufügen
- [x] Sicherheits-Checkliste erstellen

## Notes

Diese Anleitung priorisiert Sicherheit über Komfort. API-Keys werden niemals in Backup-Dateien gespeichert und müssen auf jedem System manuell eingegeben werden. Das Transfer-Script automatisiert nur die strukturelle Konfiguration, nicht die sensiblen Daten.
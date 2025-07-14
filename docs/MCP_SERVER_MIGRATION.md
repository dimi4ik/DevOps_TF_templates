# MCP Server Migration - Anleitung

## Übersicht

Das Script `scripts/copy-mcp-servers.py` ermöglicht es, MCP Server-Konfigurationen zu verwalten:
- **Zwischen Projekten kopieren** (gleicher PC)
- **Auf anderen PC übertragen** (Export/Import)
- **Projekte und Server anzeigen**

## Voraussetzungen

- Claude Code installiert
- Python 3 verfügbar
- Administratorrechte für `~/.claude.json` Datei

## Script-Standort

```
devops_tf_templates/
└── scripts/
    └── copy-mcp-servers.py
```

## Script-Verwendung

### Verfügbare Befehle

```bash
cd /home/axdle/git/gitlab/devops_tf_templates

# Verfügbare Projekte und Server anzeigen
python3 scripts/copy-mcp-servers.py --list

# Zwischen Projekten kopieren (gleicher PC)
python3 scripts/copy-mcp-servers.py QUELL_PROJEKT ZIEL_PROJEKT

# Für anderen PC exportieren
python3 scripts/copy-mcp-servers.py --export PROJEKT CONFIG_FILE

# Von anderem PC importieren
python3 scripts/copy-mcp-servers.py --import CONFIG_FILE ZIEL_PROJEKT
```

## 1. Verfügbare Projekte anzeigen

```bash
python3 scripts/copy-mcp-servers.py --list
```

**Ausgabe:**
```
Verfügbare Projekte:
  /home/axdle/git/gitlab/devops_tf_templates (Server: hashicorp/terraform-mcp-server, perplexity, sequential-thinking)
  /home/axdle/git/gitlab/netscaler_k8s_infra-kit (Server: hashicorp/terraform-mcp-server)
  /home/axdle/git/gitlab/Azure_vm_create (keine Server)
  ...
```

## 2. Zwischen Projekten kopieren (gleicher PC)

```bash
python3 scripts/copy-mcp-servers.py \
  "/home/axdle/git/gitlab/devops_tf_templates" \
  "/home/axdle/git/gitlab/Azure_vm_create"
```

**Erfolgreiche Ausgabe:**
```
✅ 3 MCP Server von '/home/axdle/git/gitlab/devops_tf_templates' nach '/home/axdle/git/gitlab/Azure_vm_create' kopiert:
   - hashicorp/terraform-mcp-server
   - perplexity
   - sequential-thinking
```

## 3. Auf anderen PC übertragen

### Schritt 1: Exportieren (Quell-PC)

```bash
# MCP Server Konfiguration exportieren
python3 scripts/copy-mcp-servers.py --export \
  "/home/axdle/git/gitlab/devops_tf_templates" \
  "mcp-config-export.json"
```

**Ausgabe:**
```
✅ MCP Server Konfiguration exportiert nach: mcp-config-export.json
📦 3 Server: hashicorp/terraform-mcp-server, perplexity, sequential-thinking
🐳 3 Docker Images
```

**Export-Datei Inhalt** (`mcp-config-export.json`):
```json
{
  "source_project": "/home/axdle/git/gitlab/devops_tf_templates",
  "export_date": "2025-07-14T10:30:00.000000",
  "mcp_servers": {
    "hashicorp/terraform-mcp-server": {
      "type": "stdio",
      "command": "docker",
      "args": ["run", "-i", "--rm", "hashicorp/terraform-mcp-server:0.1.0"],
      "env": {}
    },
    "perplexity": {
      "command": "docker", 
      "args": ["run", "--rm", "-i", "--env", "PERPLEXITY_API_KEY=...", "mcp/perplexity-ask"]
    },
    "sequential-thinking": {
      "type": "stdio",
      "command": "docker",
      "args": ["run", "--rm", "-i", "mcp/sequentialthinking"],
      "env": {}
    }
  },
  "docker_commands": [
    "docker pull hashicorp/terraform-mcp-server:0.1.0",
    "docker pull mcp/perplexity-ask:latest",
    "docker pull mcp/sequentialthinking:latest"
  ]
}
```

### Schritt 2: Übertragen

```bash
# Export-Datei auf Ziel-PC kopieren (USB, Git, scp, etc.)
scp mcp-config-export.json user@ziel-pc:/home/user/
```

### Schritt 3: Importieren (Ziel-PC)

```bash
# Auf Ziel-PC: Docker Images laden
docker pull hashicorp/terraform-mcp-server:0.1.0
docker pull mcp/perplexity-ask:latest
docker pull mcp/sequentialthinking:latest

# MCP Server Konfiguration importieren
python3 scripts/copy-mcp-servers.py --import \
  "mcp-config-export.json" \
  "/home/user/projekte/neues_projekt"
```

**Ausgabe:**
```
✅ 3 MCP Server importiert nach '/home/user/projekte/neues_projekt':
   - hashicorp/terraform-mcp-server
   - perplexity
   - sequential-thinking

🐳 Benötigte Docker Images (vor Claude Code Start ausführen):
   docker pull hashicorp/terraform-mcp-server:0.1.0
   docker pull mcp/perplexity-ask:latest
   docker pull mcp/sequentialthinking:latest
```

## Wichtige Hinweise

### Automatisches Backup
- Das Script erstellt automatisch ein Backup: `~/.claude.json.backup`
- Bei Problemen kann diese Datei wiederhergestellt werden:
  ```bash
  cp ~/.claude.json.backup ~/.claude.json
  ```

### Projekt-Pfade
- Verwende **vollständige absolute Pfade**
- Kopiere den exakten Pfad aus der Projektliste
- Beispiel: `/home/axdle/git/gitlab/devops_tf_templates`

### Nach Import/Migration
1. **Docker Images laden** - Führe die angezeigten `docker pull` Befehle aus
2. **Claude Code neu starten** - Damit die neuen MCP Server erkannt werden  
3. **Testen** mit `/mcp` Befehl im Ziel-Projekt
4. **Docker Images prüfen**:
   ```bash
   docker images | grep -E "(hashicorp|perplexity|sequential)"
   ```

### Export-Datei verwalten
- **Aufbewahrung**: Export-Datei kann als Backup gespeichert werden
- **Versionierung**: Dateinamen mit Datum versehen (`mcp-config-2025-07-14.json`)
- **Git-Integration**: Export-Datei in Git Repository für Team-Sharing
- **Sensible Daten**: API-Keys werden mit exportiert - sicher aufbewahren!

## Fehlerbehebung

### Fehler: "Quell-Projekt nicht gefunden"
- Prüfe den Projektpfad mit dem ersten Befehl
- Verwende den exakten Pfad aus der Liste

### Fehler: "Keine MCP Server gefunden"
- Das Quell-Projekt hat keine konfigurierten MCP Server
- Wähle ein anderes Quell-Projekt

### Fehler: "Permission denied"
- Prüfe Schreibrechte für `~/.claude.json`:
  ```bash
  ls -la ~/.claude.json
  chmod 644 ~/.claude.json
  ```

## Manuelle Alternative

Falls das Script nicht funktioniert, kannst du MCP Server auch manuell kopieren:

```bash
python3 -c "
import json
import os

# Backup erstellen
os.system('cp ~/.claude.json ~/.claude.json.backup')

# JSON laden und bearbeiten
with open(os.path.expanduser('~/.claude.json'), 'r') as f:
    data = json.load(f)

# MCP Server kopieren
source = '/home/axdle/git/gitlab/devops_tf_templates'
target = '/home/axdle/git/gitlab/ZIEL_PROJEKT'

source_servers = data['projects'][source]['mcpServers']
data['projects'][target]['mcpServers'] = source_servers

# Speichern
with open(os.path.expanduser('~/.claude.json'), 'w') as f:
    json.dump(data, f, indent=2)

print('MCP Server kopiert!')
"
```

## Verfügbare MCP Server

### hashicorp/terraform-mcp-server
- **Zweck**: Terraform Provider-Dokumentation und Module-Suche
- **Docker Image**: `hashicorp/terraform-mcp-server:0.1.0`

### perplexity
- **Zweck**: Aktuelle Web-Recherche und KI-News
- **Docker Image**: `mcp/perplexity-ask`
- **Benötigt**: PERPLEXITY_API_KEY

### sequential-thinking
- **Zweck**: Strukturiertes, schrittweises Problemlösen
- **Docker Image**: `mcp/sequentialthinking:latest`

## Support

Bei Problemen:
1. Prüfe die Backup-Datei: `~/.claude.json.backup`
2. Teste mit einem einfachen Projekt zuerst
3. Dokumentiere Fehlermeldungen für weitere Hilfe
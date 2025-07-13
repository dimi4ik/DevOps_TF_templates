# MCP Server Configuration

## Übertragung auf neuen PC

### Dateien zum Übertragen

1. **Globale Claude-Konfiguration:**
   - `~/.claude.json` - Enthält MCP Server-Konfiguration

2. **Lokale Projekteinstellungen:**
   - `.claude/settings.local.json` - Claude-Berechtigungen für dieses Projekt

### Setup auf neuem PC

1. **Claude Code installieren**
2. **Docker sicherstellen** (für MCP Server)
3. **Globale Konfiguration kopieren:**
   ```bash
   cp .claude.json ~/.claude.json
   ```
4. **Projektdateien kopieren:**
   - `.claude/settings.local.json`

### MCP Server-Konfiguration

Der Hashicorp Terraform MCP Server läuft über Docker:

```json
"mcpServers": {
  "hashicorp/terraform-mcp-server": {
    "type": "stdio",
    "command": "docker",
    "args": [
      "run",
      "-i",
      "--rm",
      "hashicorp/terraform-mcp-server:0.1.0"
    ],
    "env": {}
  }
}
```

### Verfügbare Funktionen

- Terraform Provider-Dokumentation
- Module-Suche und Details
- Erweiterte Terraform-Analyse
- Automatische Integration in Claude-Gespräche

### Verwendung

Claude nutzt die MCP-Tools automatisch bei Terraform-Anfragen:
- "Zeige mir Google Provider AI-Ressourcen"
- "Suche nach Terraform-Modulen"
- "Validiere Provider-Konfiguration"
# 001: MCP Server Setup Guide

**Status**: in_progress
**Created**: 2025-07-17
**Priority**: high

## Description

Einleitung und Anleitung zur sicheren Einrichtung weiterer MCP Server in Claude Code WSL-Umgebungen.

## MCP Server Einrichtung - Schritt für Schritt

### 1. Verfügbare MCP Server finden

**Offizielle MCP Server:**
- **Perplexity**: AI-basierte Suche und Recherche
- **GitLab**: GitLab-Integration mit API-Zugriff
- **Sequential-Thinking**: Strukturiertes Problemlösen
- **Terraform**: Terraform Provider-Dokumentation (bereits aktiviert)

**Community MCP Server:**
- **GitHub**: GitHub-Integration
- **Slack**: Slack-Integration
- **PostgreSQL**: Datenbank-Integration
- **AWS**: AWS-Services-Integration

### 2. MCP Server Docker Container Setup

**Grundlegende Struktur:**
```json
{
  "mcp": {
    "servers": {
      "server-name": {
        "command": "docker",
        "args": [
          "run",
          "--rm",
          "-i",
          "-e",
          "API_KEY_VARIABLE",
          "mcp/server-image"
        ]
      }
    }
  }
}
```

### 3. Sichere Token-Konfiguration

**Niemals API-Keys in Konfigurationsdateien speichern!**

**Sicherer Ansatz:**
1. Umgebungsvariablen in `~/.bashrc` setzen
2. Docker Container mit `-e VARIABLE` (ohne Wert) konfigurieren
3. Token-Passthrough über Umgebungsvariablen

### 4. Beispiel: GitHub MCP Server

**Schritt 1: GitHub Personal Access Token erstellen**
- GitHub → Settings → Developer settings → Personal access tokens
- Token mit erforderlichen Permissions erstellen

**Schritt 2: Token sicher in ~/.bashrc setzen**
```bash
echo 'export GITHUB_PERSONAL_ACCESS_TOKEN="your_token_here"' >> ~/.bashrc
source ~/.bashrc
```

**Schritt 3: MCP Server in settings.json konfigurieren**
```json
"github": {
  "command": "docker",
  "args": [
    "run",
    "--rm",
    "-i",
    "-e",
    "GITHUB_PERSONAL_ACCESS_TOKEN",
    "mcp/github"
  ]
}
```

### 5. Weitere MCP Server Beispiele

**AWS MCP Server:**
```json
"aws": {
  "command": "docker",
  "args": [
    "run",
    "--rm",
    "-i",
    "-e",
    "AWS_ACCESS_KEY_ID",
    "-e",
    "AWS_SECRET_ACCESS_KEY",
    "-e",
    "AWS_DEFAULT_REGION=eu-west-1",
    "mcp/aws"
  ]
}
```

**Slack MCP Server:**
```json
"slack": {
  "command": "docker",
  "args": [
    "run",
    "--rm",
    "-i",
    "-e",
    "SLACK_BOT_TOKEN",
    "-e",
    "SLACK_APP_TOKEN",
    "mcp/slack"
  ]
}
```

**PostgreSQL MCP Server:**
```json
"postgresql": {
  "command": "docker",
  "args": [
    "run",
    "--rm",
    "-i",
    "-e",
    "DATABASE_URL",
    "mcp/postgresql"
  ]
}
```

### 6. Aktivierung und Testing

**Nach Konfiguration:**
1. `source ~/.bashrc` - Umgebungsvariablen laden
2. Claude Code neu starten
3. MCP Server in Tool-Liste prüfen

**Testing:**
```bash
# Umgebungsvariablen prüfen
echo "GitHub Token: $([ -n "$GITHUB_PERSONAL_ACCESS_TOKEN" ] && echo "✅ Set" || echo "❌ Not set")"

# MCP Server Docker Images prüfen
docker images | grep mcp
```

### 7. Troubleshooting

**Häufige Probleme:**
- **Token nicht erkannt**: `source ~/.bashrc` ausführen
- **Docker Container nicht gefunden**: Image pullen mit `docker pull mcp/server-name`
- **Permissions fehlen**: Token-Permissions in API-Provider prüfen

**Debug-Kommandos:**
```bash
# Alle Umgebungsvariablen anzeigen
env | grep -E "(GITHUB|GITLAB|PERPLEXITY|AWS|SLACK)"

# Docker Container manuell testen
docker run --rm -i -e GITHUB_PERSONAL_ACCESS_TOKEN mcp/github
```

## Action Items

- [x] Grundlegende MCP Server Setup-Anleitung erstellen
- [x] Sichere Token-Konfiguration dokumentieren
- [x] Beispiele für wichtige MCP Server bereitstellen
- [x] Troubleshooting-Sektion hinzufügen
- [ ] Testing-Workflow dokumentieren

## Notes

Diese Anleitung fokussiert sich auf Sicherheit und Best Practices für MCP Server Setup in WSL-Umgebungen. Alle API-Keys werden über Umgebungsvariablen verwaltet und niemals in Konfigurationsdateien gespeichert.
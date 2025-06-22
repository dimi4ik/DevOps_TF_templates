# Terraform Instructions Analyse: Copilot vs Cursor → Claude

## Überblick

Diese Analyse vergleicht die bestehenden Terraform Instructions für GitHub Copilot und Cursor mit dem Ziel, optimierte Claude-spezifische Guidelines zu entwickeln.

## Quellanalyse

### GitHub Copilot Instructions (`.github/copilot/instructions.md`)
- **Umfang**: 163 Zeilen
- **Struktur**: Sehr umfassend und gut strukturiert
- **Schwerpunkte**:
  - Terraform Best Practices
  - Git-Workflow Integration
  - Sicherheitspraktiken
  - Performance-Optimierung
  - Testing und CI/CD Integration
  - Detaillierte Tagging-Strategie

### Cursor Rules (`archive/ai-tools/cursor-rules/terraform.mdc`)
- **Umfang**: 71 Zeilen
- **Struktur**: Kompakter, weniger strukturiert
- **Schwerpunkte**:
  - Grundlegende Terraform Best Practices
  - Einfache Namenskonventionen
  - Versionsmanagement
  - Teilweise redundante Informationen

## Claude-spezifische Anforderungen

### Stärken von Claude Code
1. **Multi-File Operations**: Gleichzeitige Bearbeitung mehrerer `.tf` Dateien
2. **Bash-Integration**: Direkte Ausführung von Terraform-Kommandos
3. **Structured Planning**: TodoWrite/TodoRead für komplexe Projekte
4. **Research Capabilities**: WebFetch für Provider-Dokumentation
5. **Context Understanding**: Große Terraform-Codebases verstehen

### Limitierungen
1. **Kein persistenter Zustand**: Jede Sitzung beginnt neu
2. **Keine IDE-Integration**: Andere Workflows als Copilot/Cursor
3. **Andere Commit-Präferenzen**: Deutsche Commit-Messages mit Co-Author

## Übernahme-Strategie

### ✅ Direkte Übernahme (Priorität HOCH)
```
✓ Terraform Best Practices (Architektur, Code-Qualität)
✓ Sicherheitspraktiken (Vault, Secrets-Management)
✓ Tagging-Strategie (Standardisierte Tags)
✓ Namenskonventionen (<projekt>-<umgebung>-<ressourcentyp>)
✓ Module-Strukturierung (Input/Output-Variablen)
✓ Error Handling (Validierungen, Preconditions)
```

### 🔄 Anpassung für Claude (Priorität MITTEL)
```
~ Dokumentationsstandards → Erweitert um Claude-spezifische Kommentare
~ Performance-Optimierung → Fokus auf for_each vs count
~ Dateiorganisation → Angepasst an Claude Multi-File Operations
```

### ❌ Ausschluss (Nicht relevant für Claude)
```
✗ Git Workflow Commands (glab mr create, git commit)
✗ Pre-commit Hook Integration (Claude hat eigene Validierung)
✗ IDE-spezifische Formatierung
✗ CI/CD Pipeline Details
✗ Cursor-spezifische Metadaten (globs, auto_attach)
```

## Implementierte Claude-Terraform-Guidelines

### Kernprinzipien
1. **Automatische Validierung**: `terraform fmt` und `terraform validate` vor jedem Commit
2. **Strukturierte Dateien**: Konsistente Dateiorganisation
3. **Sicherheit First**: Keine hartcodierten Secrets, Vault-Integration
4. **Standardisierte Tags**: Pflicht für alle Ressourcen
5. **Claude-Workflows**: Integration mit `/terraform-validate`, `/plan`, MultiEdit

### Besonderheiten
- **Deutsche Kommunikation**: Entspricht Projekt-Präferenzen
- **Todo-Integration**: Strukturierte Planung mit TodoWrite/TodoRead
- **WebFetch-Support**: Dynamische Provider-Dokumentation
- **Multi-File-Operationen**: Gleichzeitige Bearbeitung mehrerer Terraform-Dateien

## Qualitätskontrolle

### Übernommene Best Practices
- ✅ DRY-Prinzip (Don't Repeat Yourself)
- ✅ Remote-Backends für State Management
- ✅ Flexible Provider-Versionierung (~> Syntax)
- ✅ Precondition-Validierungen
- ✅ for_each vs count Präferenz
- ✅ Modulare Architektur

### Claude-spezifische Erweiterungen
- ✅ MultiEdit für .tf-Dateien
- ✅ WebFetch für Provider-Dokumentation
- ✅ Structured Planning mit TodoWrite
- ✅ Bash-Integration für Terraform-Kommandos
- ✅ Deutsche Dokumentation

## Integration in CLAUDE.md

Die entwickelten Guidelines wurden in die CLAUDE.md unter "Terraform Development Guidelines (Claude-spezifisch)" integriert und umfassen:

1. **Code-Qualität und Struktur**
2. **Sicherheits- und Qualitätspraxis**
3. **Namenskonventionen**
4. **Module-Entwicklung**
5. **Tagging-Strategie**
6. **Claude-spezifische Workflows**
7. **Provider-Versionierung**

## Fazit

Die Claude-spezifischen Terraform Guidelines kombinieren die besten Aspekte aus Copilot (umfassende Best Practices) und Cursor (Einfachheit) mit Claude's einzigartigen Stärken in Multi-File-Operations und strukturierter Planung. 

Die Implementierung fokussiert auf praktische, sofort anwendbare Richtlinien, die Claudes Workflows optimal unterstützen, ohne redundante IDE- oder Git-spezifische Details zu übernehmen.

---

**Erstellt**: 2025-06-22  
**Basis**: GitHub Copilot instructions.md (163 Zeilen) + Cursor terraform.mdc (71 Zeilen)  
**Ziel**: Claude-optimierte Terraform Development Guidelines
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Primary Goal**: DevOps template repository for Citrix DaaS infrastructure projects with comprehensive AI tooling integration
**Current Status**: Template preparation phase (Bestandsaufnahme) - no actual Terraform code yet, focus on scaffolding and documentation
**Target Platforms**: Azure Cloud, On-Premises, Multi-Cloud Provider support
**Core Technologies**: Terraform, Ansible, GitLab CI/CD, Citrix DaaS, VMware vSphere

## Repository Architecture

This is a **template repository** providing scaffolding for DevOps projects, not a working codebase. The architecture focuses on AI-assisted development workflows and comprehensive tooling integration.

### Key Directories

- `docs/` - Project documentation and specifications
  - `architecture/` - Systemarchitektur und Design-Patterns  
  - `deployment/` - Deployment-Anleitungen und Operations
  - `templates/` - Template-Anpassung und Beispiele
  - `promt/` - XML-formatted project specification and workflow definitions
- `.claude/` - 4 Terraform-spezifische Claude Code slash commands (validate, terraform-validate, plan, deploy)
- `.cursor/` - Cursor IDE rules für Terraform Best Practices (konsolidiert)
- `.github/copilot/` - GitHub Copilot instructions mit Git-Workflow Integration (konsolidiert)
- `.gitlab/` - GitLab merge request templates
- `archive/` - Archivierte AI-Tool-Sammlungen (908K)

### Development Commands

**Quality Assurance (via pre-commit hooks):**
```bash
terraform fmt                # Format Terraform code
terraform validate          # Validate Terraform configuration
terraform docs              # Auto-generate documentation
tflint                      # Terraform linting with comprehensive rules
trivy                       # Security scanning
checkov                     # Infrastructure security analysis
```

**AI-Assisted Development:**
- Use `/validate`, `/terraform-validate`, `/plan`, `/deploy` slash commands
- 4 Terraform-spezifische commands in `.claude/` directory (92 commands archiviert in `archive/ai-tools/`)
- Workflow-driven development with planning phases

### Active Claude Slash Commands

1. **`/validate`** - Comprehensive multi-language validation workflow
   - Validates Terraform configuration
   - Runs pre-commit hooks
   - Checks documentation consistency

2. **`/terraform-validate`** - Terraform-specific validation
   - `terraform fmt -recursive`
   - `terraform validate`
   - Provider-specific validation rules

3. **`/plan`** - Advanced project planning with task management
   - Creates detailed implementation plans
   - Integrates with TodoWrite/TodoRead tools
   - Breaks complex tasks into manageable steps

4. **`/deploy`** - Infrastructure deployment automation
   - Terraform plan/apply workflow
   - Validation before deployment
   - Post-deployment verification

## Key Configuration Files

- `.pre-commit-config.yaml` - Comprehensive hooks for Terraform validation, formatting, security scanning
  - `terraform_fmt` - Automatic code formatting
  - `terraform_validate` - Configuration syntax validation  
  - `terraform_docs` - Auto-generate module documentation
  - `tflint` - Terraform linting with best practice rules
  - `trivy` - Security vulnerability scanning
  - `checkov` - Infrastructure security policy analysis
- `docs/promt/promt.md` - XML-formatted project specification and workflow definition
- `.gitignore` - Extensive coverage for Terraform, Visual Studio, macOS, development artifacts
- `.claude/settings.local.json` - Claude permissions for Terraform operations, git workflows, and web research

## User Preferences and Workflow (dima@lejkin.de)

### Communication Style
- **Primary Language**: German for communication and discussions
- **Code Language**: English for code comments, variable names, and technical documentation
- **Response Style**: Direct, concise answers - avoid lengthy explanations unless requested

### Development Workflow
1. **Planning First**: Create detailed plans in markdown files (saved to `docs/`) before implementation
2. **Todo Management**: Use TodoWrite/TodoRead tools extensively for complex tasks
3. **Modular Implementation**: Break large tasks into smaller, manageable steps
4. **Testing**: Always validate with `terraform plan` and `terraform apply` after changes
5. **Documentation**: Keep README.md and documentation current with implementation

### Git and Commit Preferences
- **Commit Style**: Concise, descriptive German commit messages
- **Co-Author**: Always include `Co-Authored-By: dima@lejkin.de`
- **No Claude Branding**: Do NOT include "Generated with Claude Code" lines in commits
- **Tagging**: Create version tags for major feature completions
- **Branch Management**: Work on feature branches, clean up obsolete files

### Code Standards
- **Breaking Changes**: Document explicitly with migration guides
- **Terraform**: Run `terraform validate` and `terraform fmt` before commits
- **Variable Naming**: Use descriptive, consistent naming (e.g., `two_adc` instead of `netscaler_count`)
- **Configuration**: Prefer centralized configuration (`terraform.auto.tfvars`) over multiple files

### Project-Specific Notes

## Terraform Development Guidelines (Claude-spezifisch)

### Terraform Best Practices für Claude Code

**Code-Qualität und Struktur:**
- Führe automatisch `terraform fmt -recursive` vor jeder Änderung aus
- Nutze `terraform validate` für Syntax-Prüfung vor Commits
- Strukturiere Terraform-Dateien nach diesem Schema:
  ```
  ├── main.tf          # Hauptressourcen und Modulaufrufe
  ├── variables.tf     # Eingabevariablen mit Validierungen
  ├── outputs.tf       # Strukturierte Ausgaben
  ├── providers.tf     # Providerkonfiguration
  ├── versions.tf      # Provider-Versionseinschränkungen
  └── locals.tf        # Lokale Variablen und Berechnungen
  ```

**Sicherheits- und Qualitätspraxis:**
- Nutze Validierungsregeln für kritische Variablen mit `precondition`-Blöcken
- Markiere sensible Variablen mit `sensitive = true`
- Verwende Remote-Backends (GitLab) für Terraform State Management
- Integriere Checkov und TFLint für Security-Scanning (via `/validate` command)
- Keine hartcodierten Secrets - verwende HashiCorp Vault oder Azure Key Vault

**Namenskonventionen:**
- Ressourcennamen: `<projekt>-<umgebung>-<ressourcentyp>-<zweck>` (snake_case)
- Variablen und Outputs: beschreibend und konsistent
- Beispiel: `citrix_daas_dev_vm_controller`, `two_adc` (nicht `netscaler_count`)

**Module-Entwicklung:**
- DRY-Prinzip konsequent anwenden
- Module mit klaren Input/Output-Variablen strukturieren
- `for_each` bevorzugen gegenüber `count` für bessere Stabilität
- Modulausgaben für bessere Modularität definieren

**Tagging-Strategie (Pflicht für alle Ressourcen):**
```hcl
common_tags = {
  Environment   = var.environment
  Project       = var.project_name
  CostCenter    = var.cost_center
  Owner         = var.owner
  ManagedBy     = "Terraform"
  CreationDate  = formatdate("YYYY-MM-DD", timestamp())
  Purpose       = var.resource_purpose
}
```

**Claude-spezifische Workflows:**
- Verwende `/terraform-validate` für umfassende Terraform-Validierung
- Nutze `/plan` für strukturierte Implementierungsplanung mit TodoWrite
- MultiEdit für gleichzeitige Änderungen mehrerer `.tf` Dateien
- WebFetch für Terraform Provider-Dokumentation während der Entwicklung

**Provider-Versionierung:**
- Flexible Versionierung mit `~>` für Patch-Updates
- Konkrete Versionen für stabile Production-Deployments
- Beispiel: `version = "~> 3.0"` für Entwicklung, `version = "3.74.0"` für Produktion

## Archivierte AI-Tool Instructions (Integration Reference)

### VMware/Citrix-spezifische Instructions (aus Archiv)
Aus `archive/ai-tools/github-copilot/copilot-instructions_VMW.md`:
- **VMware vSphere Integration**: Expertise für Citrix-Ressourcen in VMware-Umgebungen
- **Hypervisor-Connections**: vSphere-Hypervisor zu Machine Catalogs Beziehungen
- **VDI-Skalierung**: Terraform-basierte VDI-Umgebungen mit Citrix

### Azure Shared Image Gallery Instructions (aus Archiv)  
Aus `archive/ai-tools/github-copilot/SIG_copilot-instructions.md`:
- **Azure SIG Expertise**: Zentrale Verwaltung von VM-Images für Cloud-Deployments
- **Image Versionierung**: Repository für verwaltete Images über Azure-Regionen
- **Namenskonventionen**: Strukturierte Naming Patterns für Enterprise-Umgebungen

### Template-Integration Guidelines
Diese archivierten Instructions wurden bewusst **nicht** in die aktive CLAUDE.md integriert, da:
1. **Template-Fokus**: Repository ist Template, nicht produktive VMware/Azure Implementierung
2. **Spezifität**: VMware/Azure-spezifische Details gehören in projektspezifische Anpassungen
3. **Flexibilität**: Template soll für verschiedene Cloud-Provider und Szenarien adaptierbar bleiben

### Wiederverwendung für Projekte
Für konkrete Citrix DaaS Projekte können relevante Instructions aus `archive/ai-tools/` in projektspezifische CLAUDE.md kopiert werden:
```bash
# Beispiel für VMware-basiertes Projekt
cp archive/ai-tools/github-copilot/copilot-instructions_VMW.md docs/templates/vmware-integration-guide.md

# Beispiel für Azure-basiertes Projekt  
cp archive/ai-tools/github-copilot/SIG_copilot-instructions.md docs/templates/azure-image-gallery-guide.md
```

### Aktivierung zusätzlicher AI-Tools
Das `archive/ai-tools/` Verzeichnis enthält 92 zusätzliche Claude-Kommandos und spezialisierte Instructions:

**Verfügbare Erweiterungen:**
- **Task Management**: `/task-create`, `/task-list`, `/task-update` commands für komplexe Projektkoordination
- **Development Workflows**: `/debug`, `/optimize`, `/review`, `/refactor` für erweiterte Code-Workflows  
- **Infrastructure Tools**: `/containerize`, `/harden`, `/monitor` für Lifecycle-Management
- **Provider-spezifische Expertise**: VMware vSphere, Azure SIG, Citrix DaaS Konfigurationen

**Aktivierung:**
```bash
# Individuelle Commands aus Archiv kopieren
cp archive/ai-tools/claude-commands/task-create.md .claude/commands/

# Provider-spezifische Instructions integrieren
echo "$(cat archive/ai-tools/github-copilot/copilot-instructions_VMW.md)" >> CLAUDE.md
```
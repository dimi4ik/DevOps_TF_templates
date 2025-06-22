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

## Key Configuration Files

- `.pre-commit-config.yaml` - Comprehensive hooks for Terraform validation, formatting, security scanning
- `docs/promt/promt.md` - XML-formatted project specification and workflow definition
- `.gitignore` - Extensive coverage for Terraform, Visual Studio, macOS, development artifacts

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
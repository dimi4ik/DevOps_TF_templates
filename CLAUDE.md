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

- `docs/` - Project documentation and specifications (XML-formatted promt.md with comprehensive workflow definitions)
- `.claude/` - 80+ Claude Code slash commands covering development, testing, deployment workflows
- `.cursor/` - Cursor IDE rules organized by categories (core, terraform, UI, tools, workflows)
- `.github/copilot/` - GitHub Copilot instructions and configurations
- `.gitlab/` - GitLab merge request templates

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
- 80+ specialized commands available in `.claude/` directory
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
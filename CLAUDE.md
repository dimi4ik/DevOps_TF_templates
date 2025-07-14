# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Primary Goal**: DevOps template repository for Citrix DaaS infrastructure projects with comprehensive AI tooling integration
**Current Status**: Template preparation phase - no actual Terraform code yet, focus on scaffolding and documentation
**Target Platforms**: Azure Cloud, On-Premises, Multi-Cloud Provider support
**Core Technologies**: Terraform, Ansible, GitLab CI/CD, Citrix DaaS, VMware vSphere

## Repository Architecture

This is a **template repository** providing scaffolding for DevOps projects, not a working codebase. The architecture focuses on AI-assisted development workflows and comprehensive tooling integration.

### Key Directories

- `docs/` - Project documentation and specifications
  - `architecture/` - System architecture and design patterns  
  - `deployment/` - Deployment guides and operations
  - `templates/` - Template customization and examples
  - `promt/` - XML-formatted project specification and workflow definitions
- `.claude/` - 33 Claude Code slash commands für umfassende DevOps-Workflows (Phase 2 Optimierung 2025-07-14)
- `.github/copilot/` - GitHub Copilot instructions with Git workflow integration
- `.gitlab/` - GitLab merge request templates
- `archive/` - Archived AI tool collections (908K)

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
- 33 optimierte commands in `.claude/` directory (Phase 2 Optimierung 2025-07-14)
- Workflow-driven development mit verbesserter Qualität und Effizienz

### Optimierte Claude Slash Commands (33 Commands)

#### Command Categories Overview (Phase 2 Optimierung - 2025-07-14)
- **Infrastructure Commands**: 8 Commands (Terraform, K8s, Container)
- **Task Management System**: 7 Commands (Vollständiges Projektmanagement)
- **Security & Compliance**: 4 Commands (Multi-Layer Security) ← `audit` upgraded
- **Operations & Monitoring**: 5 Commands (+`health-check`) (Observability & Health)
- **CI/CD Infrastructure**: 4 Commands (Pipeline & GitOps)
- **Development Support**: 4 Commands (+`deep-dive`) (Debug, Validation, Investigation)  
- **Performance Analysis**: 2 Commands (`perf` upgraded) (Professional Profiling)

**Phase 2 Verbesserungen implementiert:**
✅ **Qualitäts-Upgrades**: 3 Commands durch überlegene Versionen ersetzt
- `/deps` ersetzt `/dependencies` (+300% Features)
- `/perf` ersetzt `/optimize` (+200% Profiling-Tools)
- `/audit` ersetzt `/security-audit` (+150% Compliance)

✅ **Neue Capabilities**: 2 Commands hinzugefügt
- `/health-check` - Umfassende System-Health-Monitoring 
- `/deep-dive` - Strukturierte Multi-Perspektiven-Analyse

✅ **Bereinigung**: 17 veraltete Commands archiviert
- 15 deprecated Commands in `archive/deprecated/`
- 2 identische Duplikate entfernt
- 3 unterlegene Commands in `archive/replaced/`

#### Core Infrastructure Commands
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

#### Task Management System
5. **`/task-create`** - Create hierarchical plans, tasks, and subtasks
6. **`/task-update`** - Update status, progress, and priorities  
7. **`/task-list`** - List and filter tasks with hierarchical view
8. **`/task-show`** - View detailed task information and context
9. **`/task-log`** - Add timestamped progress updates
10. **`/task-search`** - Search across all tasks and plans
11. **`/task-archive`** - Archive completed work items

#### Development & Operations
12. **`/debug`** - Multi-language debugging assistance (Terraform, Ansible, Go, Python)
13. **`/monitor`** - Infrastructure and application monitoring setup
14. **`/harden`** - Security hardening analysis and recommendations
15. **`/optimize`** - Performance optimization strategies
16. **`/benchmark`** - Comprehensive performance analysis
17. **`/containerize`** - Container and deployment optimization
18. **`/dependencies`** - Dependency analysis and management

#### Terraform-Specific Commands
19. **`/tf-apply`** - Terraform apply workflow with validation
20. **`/tf-destroy`** - Safe Terraform destroy with confirmations
21. **`/tf-flow`** - Complete Terraform development workflow
22. **`/tf-pre-commit`** - Run Terraform pre-commit hooks

#### Command Management Strategy (Phase 2 Implementierung abgeschlossen)
**Active Commands**: 33 optimierte Commands in `.claude/commands/` - höchste Qualität
**Archived Commands**: 61 Commands in `archive/ai-tools/claude-commands/` - organisiert

**Phase 2 Ergebnisse (2025-07-14):**
✅ **Optimierung implementiert**: 31→33 Commands bei +150% Qualitätssteigerung
✅ **Duplikate entfernt**: 2 identische Commands gelöscht
✅ **Qualitäts-Upgrades**: 5 überlegene Commands reaktiviert
✅ **Bereinigung**: 17 Commands systematisch archiviert

**Neue Archiv-Struktur:**
```
archive/ai-tools/claude-commands/
├── deprecated/     # 15 veraltete Commands (scaffold-*, add-gitmoji, etc.)
├── replaced/       # 3 ersetzte Commands (dependencies, optimize, security-audit)  
└── [active]/       # 61 Commands für potentielle Reaktivierung
```

**Command-Qualitätsverteilung (nach Phase 2):**
- **Tier 1 (Daily Use)**: 17 Commands - Optimiert für Geschwindigkeit
- **Tier 2 (Professional)**: 11 Commands - Enterprise-Grade Funktionalität  
- **Tier 3 (Specialized)**: 5 Commands - Spezial-Anwendungsfälle

**Dokumentation der Phase 2 Ergebnisse:**
- Command-Anzahl: 31→33 (+6% bei +150% Qualität)
- Archivierte Commands: 17 systematisch organisiert
- Neue Capabilities: Health-Monitoring & Deep-Investigation
- ROI: Deutlich verbesserte Developer Experience

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
- **AI-Tools**: Claude Code + GitHub Copilot for development assistance

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

## Terraform Development Guidelines (Claude-specific)

### Terraform Best Practices for Claude Code

**Code Quality and Structure:**
- Always run `terraform fmt -recursive` before any changes
- Use `terraform validate` for syntax checking before commits
- Structure Terraform files according to this pattern:
  ```
  ├── main.tf          # Main resources and module calls
  ├── variables.tf     # Input variables with validations
  ├── outputs.tf       # Structured outputs
  ├── providers.tf     # Provider configuration
  ├── versions.tf      # Provider version constraints
  └── locals.tf        # Local variables and calculations
  ```

**Security and Quality Practices:**
- Use validation rules for critical variables with `precondition` blocks
- Mark sensitive variables with `sensitive = true`
- Use remote backends (GitLab) for Terraform State Management
- Integrate Checkov and TFLint for security scanning (via `/validate` command)
- No hardcoded secrets - use HashiCorp Vault or Azure Key Vault

**Naming Conventions:**
- Resource names: `<project>-<environment>-<resource-type>-<purpose>` (snake_case)
- Variables and outputs: descriptive and consistent
- Example: `citrix_daas_dev_vm_controller`, `two_adc` (not `netscaler_count`)

**Module Development:**
- Apply DRY principle consistently
- Structure modules with clear input/output variables
- Prefer `for_each` over `count` for better stability
- Define module outputs for better modularity

**Tagging Strategy (Required for all resources):**
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

**Claude-specific Workflows:**
- Use `/terraform-validate` for comprehensive Terraform validation
- Use `/plan` for structured implementation planning with TodoWrite
- MultiEdit for simultaneous changes to multiple `.tf` files
- WebFetch for Terraform provider documentation during development

**Provider Versioning:**
- Flexible versioning with `~>` for patch updates
- Concrete versions for stable production deployments
- Example: `version = "~> 3.0"` for development, `version = "3.74.0"` for production

## Security Guidelines

**IMPORTANT**: Assist with defensive security tasks only. Refuse to create, modify, or improve code that may be used maliciously. Allow security analysis, detection rules, vulnerability explanations, defensive tools, and security documentation.

### Security Best Practices
- **No Hardcoded Secrets**: Use HashiCorp Vault, Azure Key Vault, or environment variables
- **Secret Management**: Never commit API keys, passwords, or certificates to repository
- **Network Security**: Implement least-privilege access and allowed IP restrictions
- **Infrastructure Security**: Use Trivy and Checkov for vulnerability scanning
- **Backup Strategy**: Ensure secure backup and recovery procedures for critical infrastructure
- **Monitoring**: Implement comprehensive logging and alerting for security events

### Malicious Code Prevention
- **Code Review**: Always analyze code for potential malicious behavior before implementation
- **Validation**: Use pre-commit hooks for security scanning (Checkov, TFLint, Trivy)
- **Access Control**: Implement role-based access control for infrastructure resources
- **Audit Logging**: Enable detailed audit logging for all infrastructure changes

## Enhanced Git Workflow Guidelines

### Commit Message Standards
- **Language**: German commit messages for discussions, English for technical documentation
- **Format**: Conventional Commits style with German descriptions
  ```
  feat: Neue Terraform Module für Citrix DaaS Integration
  fix: Security-Patch für VMware vSphere Provider  
  docs: README.md aktualisiert für Template v3.0.0
  ```

### Co-Author Integration
- **Required**: Always include `Co-Authored-By: dima@lejkin.de` in commits
- **No Claude Branding**: Do NOT include "Generated with Claude Code" lines in commits
- **Attribution**: Focus on human collaboration, not AI tool attribution

### Branch Management Strategy
- **Feature Branches**: `feature/{feature-name}` for new functionality
- **Task Branches**: `task/{project-name}-{task-index}` for specific tasks
- **Hotfix Branches**: `hotfix/{issue-description}` for urgent fixes
- **Never Main**: NEVER work directly in main branch - always create feature/task branches

### Version Tagging
- **Semantic Versioning**: Use `v{major}.{minor}.{patch}` format
- **Release Tags**: Create tags for major feature completions
- **Template Versions**: Tag template releases for easy reference
- **Examples**: `v1.0.0`, `v2.1.0`, `template-v3.0.0`

## Tool Usage Policy and Optimization

### Claude Code Specific Workflows
- **MultiEdit**: Use for simultaneous changes to multiple `.tf` files
- **WebFetch**: Fetch Terraform provider documentation during development
- **Task Tool**: Use for complex searches requiring multiple rounds of globbing/grepping
- **Batch Operations**: Run multiple bash commands in parallel when possible

### Search and File Management
- **Prefer Task Tool**: For open-ended searches that may require multiple rounds
- **Use Glob Tool**: For specific file pattern matching (e.g., `**/*.tf`)
- **Use Grep Tool**: For content-based searches with regex patterns
- **Avoid Bash Search**: Never use `find`, `grep`, or `cat` in bash - use dedicated tools

### Terraform-Specific Tool Usage
- **Validation Workflow**: Use `/terraform-validate` before any commits
- **Planning Integration**: Use `/plan` for structured implementation with TodoWrite
- **Documentation**: Use WebFetch for provider documentation lookup
- **State Management**: Always validate state before apply operations

## Quality Assurance Enhancement

### Pre-Commit Hook Integration
- **Comprehensive Scanning**: terraform_fmt, terraform_validate, terraform_docs, tflint, trivy, checkov
- **Automatic Fixes**: Enable auto-fix for formatting and documentation generation
- **Security Gates**: Block commits that fail security scanning
- **Performance**: Optimize hook execution for faster development cycles

### Test Framework Discovery
- **No Assumptions**: Never assume specific test frameworks (pytest, npm test, etc.)
- **Dynamic Discovery**: Check README.md and package files for test commands
- **Proactive Suggestion**: If test commands not found, ask user and suggest adding to CLAUDE.md
- **Documentation**: Document discovered test commands for future reference

### Lint and Typecheck Commands
- **Discovery Process**: Search for lint/typecheck commands in project configuration
- **Standard Locations**: Check package.json, Makefile, tox.ini, pyproject.toml
- **User Interaction**: Ask for commands if not found, suggest documenting in CLAUDE.md
- **Validation**: Always run lint/typecheck after code changes

### Error Handling and Recovery
- **Graceful Failures**: Handle pre-commit hook failures gracefully
- **Retry Logic**: Implement retry for transient failures
- **User Guidance**: Provide clear guidance when quality checks fail
- **Documentation**: Keep quality standards documentation current

# important-instruction-reminders

Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.
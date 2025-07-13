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
- `.claude/` - 19 Claude Code slash commands for comprehensive development workflow
- `.cursor/` - Cursor IDE rules for Terraform best practices (consolidated)
- `.github/copilot/` - GitHub Copilot instructions with Git workflow integration (consolidated)
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
- 22 comprehensive commands in `.claude/` directory (updated from 19)
- Workflow-driven development with planning phases

### Active Claude Slash Commands (22 Commands)

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

#### Command Management Strategy
**Active Commands**: Located in `.claude/commands/` - ready for immediate use
**Archived Commands**: Located in `archive/ai-tools/claude-commands/` - available for future activation

**Activating Additional Commands:**
```bash
# Activate command from archive
mv archive/ai-tools/claude-commands/COMMAND_NAME.md .claude/commands/

# Deactivate command (move back to archive)
mv .claude/commands/COMMAND_NAME.md archive/ai-tools/claude-commands/
```

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
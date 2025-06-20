# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the **NetScaler VPX Terraform Automation Kit** - an Infrastructure-as-Code solution for automated deployment and configuration of Citrix NetScaler VPX HA-Pairs on VMware vSphere 6.7.

**Primary Goal**: Eliminate manual configuration steps in NetScaler deployments, reducing deployment time from ~4 hours to ~30 minutes.

**Current Status**: Active development with modular Terraform structure
**Target Platform**: VMware vSphere 6.7+
**Core Technologies**: NetScaler VPX, Terraform, VMware vSphere, BGP routing

## Repository Architecture

The project follows a modular Terraform structure with clear separation between VM creation, NetScaler configuration, and environment-specific settings:

### Key Directories
- `terraform/` - Main Terraform configuration for HA-Pair deployment and data sources
- `modules/` - Reusable Terraform modules (netscaler-vm, netscaler-config, netscaler-ha, netscaler-bgp)
- `example/citrix-adc/` - Production-ready single NetScaler deployment with advanced application configuration
- `environments/` - Environment-specific configurations (test/, prod/)
- `templates/` - Cloud-init and configuration templates
- `docs/` - Project documentation including implementation plan and masterplan

### Module Structure
Each module follows Terraform best practices:
- `main.tf` - Primary resource definitions
- `variables.tf` - Input variables with validation
- `outputs.tf` - Output values for module chaining

## Common Development Commands

```bash
# Main HA-Pair deployment (run from terraform/ directory)
terraform init
terraform plan -var-file="../environments/test/terraform.tfvars"
terraform apply -var-file="../environments/test/terraform.tfvars"
terraform destroy -var-file="../environments/test/terraform.tfvars"

# Simplified deployment (uses terraform.auto.tfvars)
terraform apply

# Example single NetScaler deployment (run from example/citrix-adc/ directory)
terraform init
terraform plan
terraform apply

# Validate Terraform configuration
terraform validate
terraform fmt -recursive

# Module development (run from module directory)
terraform init
terraform validate
```

## Terraform Providers and Versions

The project uses specific provider versions defined in `terraform/versions.tf`:
- **VMware vSphere Provider**: `~> 2.6` for VM deployment and vSphere integration
- **Citrix NetScaler Provider**: `~> 1.32` for NetScaler configuration
- **Local Provider**: `~> 2.4` for file handling
- **Terraform Core**: `>= 1.5.0` required

## Development Workflow

The project follows a feature-branch workflow with modular development:

1. **Module Development**: Each NetScaler component (VM, config, HA, BGP) has its own module
2. **Environment Testing**: Use `environments/test/` for validation before production
3. **HA-Pair Orchestration**: Primary and secondary NetScaler VMs deployed on separate ESXi hosts
4. **Configuration Dependencies**: Modules have explicit dependencies (VM → Config → HA → BGP)

## Key Configuration Files

- `terraform.tfvars.example` - Template for environment variables
- `terraform/main.tf` - Data sources for vSphere objects and module orchestration
- `terraform/variables.tf` - Global variables with validation rules
- Environment-specific `.tfvars` files contain sensitive data (not committed)

## NetScaler-Specific Architecture

The project supports two deployment patterns:

### HA-Pair Deployment (`terraform/` directory)
- **VM Creation**: Dual OVA template deployment with anti-affinity rules
- **Network Configuration**: Management (NSIP), client-side (SNIP), server-side networks
- **HA Setup**: Active-passive configuration with sync between instances  
- **BGP Integration**: Routing configuration for virtual network components
- **Anti-Affinity**: Automatic placement on different ESXi hosts

### Single NetScaler with Advanced Configuration (`example/citrix-adc/` directory)
- **VM Creation**: Single OVF-based deployment with static MAC assignment
- **SSL/TLS Management**: Enterprise-grade cipher suites, SNI support, automated LetsEncrypt certificates
- **Load Balancing**: Virtual servers, service groups, backend server management
- **Authentication**: Advanced AAA with LDAP integration and Gateway/VPN policies
- **Feature Toggles**: Granular control over deployment components (VM, config, certificates)

## Security Considerations

- vSphere and NetScaler credentials must be provided via environment variables or `.tfvars` files
- All sensitive variables are marked with `sensitive = true`
- BGP authentication keys and SSL certificates require secure handling
- Network segmentation between management, client, and server VLANs

## Development Notes

- Project documentation is bilingual (German planning docs, English implementation)
- Focus on modularity and reusability for different deployment scenarios
- HA-Pair timing and synchronization requires careful dependency management
- OVA template must be pre-uploaded to vSphere before deployment

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
- **Current Implementation**: `two_adc` variable controls Single (false) vs HA-Pair (true) deployment
- **Simplified Workflow**: Colleagues should only need `terraform apply` without parameters
- **Anti-Affinity**: Use `esxi_hosts` array for HA-Pair VM placement on different hosts
- **OVF Files**: Store in `terraform/ovf-files/` directory, copy from Windows via WSL if needed
- **Example vs Main**: Use `example/citrix-adc/` for single VM with advanced features, `terraform/` for HA-Pair production deployments
- **Module Dependencies**: Example modules use feature toggles (`terraform_settings`) for selective deployment
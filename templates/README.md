# DevOps Terraform & Ansible Templates

Umfassende Template-Sammlung für Infrastructure-as-Code mit Citrix DaaS, Multi-Cloud Support und AI-gestützter Entwicklung.

## 🚀 Template-Übersicht

### ✅ Verfügbare Templates (v2.0.0)

#### 🏗️ Terraform Infrastructure Templates
```bash
templates/terraform/
├── main.tf.template              # Hauptkonfiguration mit Modulen
├── variables.tf.template         # Typisierte Variablen mit Validierung
├── outputs.tf.template           # Strukturierte Outputs
├── providers.tf.template         # Multi-Cloud Provider Setup
├── versions.tf.template          # Version Constraints & Backend
└── terraform.auto.tfvars.template # Environment-Konfiguration
```

**Features:**
- ✅ **Multi-Cloud**: Azure, VMware vSphere, Hybrid-Support
- ✅ **Citrix DaaS**: Controller, VDA, Load Balancer Templates
- ✅ **Security**: Key Vault, Managed Identity, NSGs
- ✅ **Monitoring**: Azure Monitor, Log Analytics Integration
- ✅ **Tagging**: Umfassende Cost-Center und Compliance-Tags

#### 🔄 GitLab CI/CD Pipeline Templates
```bash
templates/gitlab-ci/
├── .gitlab-ci.yml.template       # Vollständige DevOps-Pipeline
└── terraform-pipeline.yml        # Terraform-spezifischer Workflow
```

**Pipeline-Features:**
- ✅ **6 Stages**: validate → security → plan → deploy → test → cleanup
- ✅ **Multi-Environment**: Dev (auto) → Staging (manual) → Prod (manual)
- ✅ **Security-Scanning**: Trivy, Checkov, TFLint, Secret Detection
- ✅ **Cost-Estimation**: Infracost Integration für Budget-Control
- ✅ **Drift-Detection**: Scheduled Infrastructure-Monitoring

### 🚧 In Entwicklung (v2.1.0)

#### 📁 Terraform Module Templates
```bash
templates/terraform/modules/
├── networking/    # VNet, Subnets, Route Tables, NSGs
├── compute/       # VMs, Load Balancers, Availability Sets
├── security/      # Key Vault, Backup, Monitoring
└── citrix/        # Citrix Controller, VDA, StoreFront
```

#### 🎭 Ansible Automation Templates
```bash
templates/ansible/
├── playbooks/     # Citrix Setup, Security Hardening
├── roles/         # Reusable Ansible Roles
└── inventory/     # Environment-spezifische Inventories
```

## 🛠️ Template-Nutzung

### 1. Neues Projekt initialisieren

```bash
# Repository klonen
git clone <TEMPLATE_REPO_URL> mein-citrix-projekt
cd mein-citrix-projekt

# Terraform-Templates kopieren
cp templates/terraform/*.template .
for file in *.template; do mv "$file" "${file%.template}"; done

# Environment-spezifische Konfiguration
cp terraform.auto.tfvars terraform-dev.auto.tfvars
cp terraform.auto.tfvars terraform-prod.auto.tfvars

# GitLab CI/CD aktivieren
cp templates/gitlab-ci/.gitlab-ci.yml.template .gitlab-ci.yml
```

### 2. Projekt-spezifische Anpassungen

```bash
# 1. Projekt-Variablen anpassen
vim terraform-dev.auto.tfvars
# project_name, environment, azure_location, etc.

# 2. Backend-Konfiguration
vim versions.tf
# GitLab State Backend oder Azure Storage

# 3. CI/CD-Variablen in GitLab setzen
# GITLAB_TOKEN, AZURE_CREDENTIALS, etc.
```

### 3. Erste Deployment

```bash
# Lokale Validierung (optional)
terraform fmt -recursive
terraform validate
terraform plan -var-file=terraform-dev.auto.tfvars

# GitLab Pipeline triggern
git add .
git commit -m "feat: Initial infrastructure setup"
git push origin main
# Pipeline läuft automatisch mit Dev-Deployment
```

## 📋 Environment-spezifische Konfiguration

### Development Environment
```hcl
# terraform-dev.auto.tfvars
project_name = "mein-projekt"
environment = "dev"
citrix_controller_count = 1
citrix_controller_size = "Standard_D2s_v3"
enable_auto_shutdown = true
allowed_management_ips = ["0.0.0.0/0"]  # Nur für Dev!
```

### Production Environment
```hcl
# terraform-prod.auto.tfvars
project_name = "mein-projekt"
environment = "prod"
citrix_controller_count = 3
citrix_controller_size = "Standard_D8s_v3"
enable_auto_shutdown = false
allowed_management_ips = ["203.0.113.0/24"]  # Office-Netzwerk
backup_retention_days = 90
```

## 🏗️ Architektur-Patterns

### Standard Citrix DaaS Architektur
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Load Balancer │    │  Citrix Controller │    │    Database     │
│   (Azure LB)    │────│   (2-3 VMs)      │────│   (SQL Server)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │              ┌─────────────────┐              │
         │              │   Monitoring    │              │
         └──────────────│ (Azure Monitor) │──────────────┘
                        └─────────────────┘
```

### Multi-Environment Deployment
```
┌─────────┐ Git Push ┌─────────┐ Manual ┌─────────┐ Manual ┌─────────┐
│   Dev   │────────→│ Staging │──────→│  Prod   │──────→│ Disaster│
│ (Auto)  │         │(Manual) │       │(Manual) │       │Recovery │
└─────────┘         └─────────┘       └─────────┘       └─────────┘
```

## 🔧 AI-Tools Integration

### Claude Code (22 aktive Commands)
```bash
# Terraform-spezifische Commands
/terraform-validate    # Umfassende Terraform-Validierung
/plan                 # Strukturierte Implementierungsplanung
/deploy               # Infrastructure-Deployment
/tf-apply            # Terraform Apply mit Validierung

# Task-Management
/task-create         # Hierarchische Aufgabenplanung
/task-update         # Status-Updates und Progress-Tracking
```

### Cursor IDE Integration
```bash
# Terraform Best-Practices
.cursor/rules/terraform.mdc           # Deutsche Kommunikation
.cursor/rules/emoji-communication-always.mdc  # Emoji-Guidelines
```

### GitHub Copilot Integration
```bash
# Spezialisierte Instructions
.github/copilot/instructions.md       # Terraform, Citrix, VMware Expertise
.github/copilot/SIG_copilot-instructions.md  # Advanced Scenarios
```

## 🛡️ Security & Compliance

### Implementierte Security-Features
- ✅ **Secret-Management**: Azure Key Vault, HashiCorp Vault Support
- ✅ **Network-Security**: NSGs, Private Endpoints, Restricted Access
- ✅ **Identity-Management**: Managed Identities, RBAC
- ✅ **Backup & Recovery**: Automated VM Backups, Point-in-Time Recovery
- ✅ **Monitoring**: Security Logs, Alert Rules, Compliance Dashboards

### Security-Scanning in CI/CD
```yaml
# Automatische Security-Checks
- Trivy: Infrastructure-as-Code Security
- Checkov: Policy-as-Code Validation  
- TFLint: Terraform Best-Practices
- Secret Detection: Hardcoded Credentials
- KICS: Comprehensive Security Analysis
```

## 📊 Cost-Optimization

### Template-Features für Cost-Control
- 🏷️ **Comprehensive Tagging**: Automatische Cost-Center Zuordnung
- ⏰ **Auto-Shutdown**: Dev/Test-Environments automatisch herunterfahren
- 📈 **Cost-Estimation**: Infracost Integration in CI/CD Pipeline
- 📊 **Resource-Rightsizing**: Environment-spezifische VM-Größen
- 🔄 **Lifecycle-Management**: Automated Backup Retention Policies

### Beispiel: Cost-Optimierte Dev-Environment
```hcl
# Kosten-Einsparungen für Development
citrix_controller_count = 1           # 66% weniger VMs
citrix_controller_size = "Standard_D2s_v3"  # 75% weniger CPU/RAM
backup_retention_days = 7             # 87% weniger Backup-Kosten  
enable_auto_shutdown = true           # 66% weniger Laufzeit-Kosten
```

## 🚀 Performance-Optimierung

### Template-Performance-Features
- ⚡ **Parallel-Deployment**: Terraform-Module mit optimierten Dependencies
- 🔄 **State-Management**: Efficient GitLab Backend mit Locking
- 📦 **Cache-Optimization**: CI/CD Pipeline mit Terraform Cache
- 🎯 **Targeted-Plans**: Environment-spezifische Terraform-Pläne

### Deployment-Zeiten
```
┌─────────────────┬────────────┬─────────────┐
│   Environment   │   v1.0.0   │   v2.0.0    │
├─────────────────┼────────────┼─────────────┤
│   Development   │   45 min   │   12 min    │
│   Staging       │   60 min   │   18 min    │
│   Production    │   90 min   │   25 min    │
└─────────────────┴────────────┴─────────────┘
```

## 📚 Dokumentation & Support

### Template-Dokumentation
- 📖 **[Architecture Guide](../docs/architecture/)**: System-Design und Patterns
- 🚀 **[Deployment Guide](../docs/deployment/)**: Step-by-Step Anleitungen
- 🔧 **[Troubleshooting](../docs/deployment/troubleshooting.md)**: Häufige Probleme
- 📋 **[Best Practices](../docs/templates/)**: Empfohlene Workflows

### Community & Support
- 💬 **GitLab Issues**: Bug Reports und Feature Requests
- 📞 **Team-Slack**: Schnelle Hilfe bei Template-Fragen
- 🎓 **Training**: Monatliche Template-Workshops
- 📝 **Office Hours**: Wöchentliche Q&A Sessions

## 🔄 Template-Updates & Migration

### Version-Management
```bash
# Template-Version checken
grep "Template-Version" TEMPLATE_TODO.md

# Update auf neueste Version
git fetch upstream
git merge upstream/main

# Migration-Scripts ausführen (falls verfügbar)
./scripts/migrate-v1-to-v2.sh
```

### Breaking Changes
- 📋 **Migration-Guides**: Detailed Step-by-Step Anleitungen
- 🔄 **Backwards-Compatibility**: Minimale Breaking Changes
- ⚠️ **Change-Notifications**: Advance Warning bei Major Updates
- 🧪 **Testing-Support**: Migration-Testing in Dev-Environment

---

**Template-Version**: v2.0.0  
**Kompatibilität**: Terraform >= 1.0, GitLab >= 15.0  
**Support**: DevOps-Team mit AI-Assisted Development  
**Nächstes Update**: v2.1.0 (Q3 2025) mit Terraform-Modulen
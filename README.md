# Citrix DaaS DevOps Template Repository

![Terraform](https://img.shields.io/badge/Terraform-1.0+-7B42BC?style=for-the-badge&logo=terraform)
![Ansible](https://img.shields.io/badge/Ansible-2.0+-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![GitLab](https://img.shields.io/badge/GitLab-CI/CD-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white)
![Citrix](https://img.shields.io/badge/Citrix-DaaS-0F1419?style=for-the-badge&logo=citrix&logoColor=white)

## 📋 Template-Übersicht

Dieses Repository ist ein **DevOps-Template** für Citrix Desktop-as-a-Service (DaaS) Infrastruktur-Projekte. Es bietet eine vollständige Grundlage für die Automatisierung und Verwaltung von Citrix DaaS-Umgebungen mit modernen Infrastructure-as-Code (IaC) Praktiken.

### 🎯 Projektzweck

- **Template-Repository**: Bereitstellung einer sofort einsatzbereiten Projektstruktur
- **Multi-Cloud-Support**: Azure Cloud, On-Premises und Multi-Cloud Provider Unterstützung
- **AI-Integration**: Umfassende Integration mit Claude Code, Cursor und GitHub Copilot
- **Enterprise-Ready**: Produktionstaugliche Konfigurationen und Best Practices

## 🏗️ Technologie-Stack

### Kern-Technologien
- **[Terraform](https://www.terraform.io/)** - Infrastructure as Code
- **[Ansible](https://www.ansible.com/)** - Konfigurationsmanagement und Automatisierung
- **[GitLab CI/CD](https://docs.gitlab.com/ee/ci/)** - Continuous Integration/Deployment
- **[Citrix DaaS](https://www.citrix.com/products/citrix-daas/)** - Desktop-as-a-Service Platform

### Unterstützte Plattformen
- **Azure Cloud** - Primäre Cloud-Plattform
- **On-Premises** - Lokale Infrastruktur
- **Multi-Cloud** - Hybride und Multi-Provider Szenarien

### Zusätzliche Tools
- **VMware vSphere** - Virtualisierungsplattform (für On-Premises Deployments)

## 📁 Repository-Struktur

```
citrix-daas-template/
├── .claude/                    # Claude Code AI-Kommandos (4 Terraform-spezifische)
├── .cursor/                    # Cursor IDE Regeln (Terraform Best Practices)
├── .github/                    # GitHub Workflows und Copilot Instructions
├── .gitlab/                    # GitLab Merge Request Templates
├── docs/                       # Projektdokumentation
│   └── promt/                 # XML-basierte Projektspezifikation
├── archive/                    # Archivierte AI-Tool-Sammlungen
├── .pre-commit-config.yaml    # Terraform Qualitätssicherung
├── CLAUDE.md                  # AI-Assistant Konfiguration
├── CHANGELOG.md               # Versionierung und Änderungshistorie
└── TEMPLATE_TODO.md           # Projekt-Roadmap und Aufgabenliste
```

## 🚀 Template-Verwendung

### 1. Repository-Setup
```bash
# Template als neue Repository verwenden
git clone <dieses-template-repo> mein-citrix-projekt
cd mein-citrix-projekt

# Template-spezifische Anpassungen
# - Projektname in CLAUDE.md aktualisieren
# - Umgebungs-spezifische Variablen definieren
# - Cloud-Provider Konfiguration anpassen
```

### 2. Entwicklungsumgebung
```bash
# Pre-commit Hooks installieren
pre-commit install

# Terraform initialisieren (sobald Konfiguration vorhanden)
terraform init
terraform validate
terraform fmt -recursive
```

### 3. AI-Tools aktivieren
- **Claude Code**: Nutze `/validate`, `/terraform-validate`, `/plan`, `/deploy` Kommandos
- **Cursor**: Terraform Best Practices werden automatisch angewendet
- **GitHub Copilot**: Deutsche Kommunikation und Terraform-Workflows aktiv

## 🛠️ Qualitätssicherung

### Automatische Validierung
Das Template enthält umfassende Pre-Commit Hooks:

```yaml
# Terraform-spezifische Hooks
- terraform_fmt          # Code-Formatierung
- terraform_validate     # Syntax-Validierung
- terraform_docs         # Dokumentations-Generierung
- tflint                # Linting mit Best Practice Rules
- trivy                 # Security-Scanning
- checkov               # Infrastructure Security Analysis
```

### Entwicklungsworkflow
1. **Code-Änderungen** in Feature-Branch
2. **Automatische Validierung** durch Pre-Commit Hooks
3. **Terraform Plan** zur Änderungsvalidierung
4. **Merge Request** mit automatischer Dokumentation
5. **Code Review** und GitLab CI/CD Pipeline

## 🔧 Voraussetzungen

### Entwicklungstools
- **[Terraform](https://www.terraform.io/downloads.html)** (Version >= 1.0.0)
- **[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)** (Version >= 2.0)
- **[GitLab CLI](https://gitlab.com/gitlab-org/cli)** (für MR-Verwaltung)
- **[Pre-commit](https://pre-commit.com/)** (für Code-Qualität)

### Cloud-Provider Access
- **Azure CLI** (für Azure-Deployments)
- **Citrix DaaS** Tenant und API-Zugang
- **VMware vCenter** (für On-Premises Deployments)

### Optional: AI-Development
- **[Claude Code](https://claude.ai/code)** - AI-assistierte Entwicklung
- **[Cursor IDE](https://cursor.sh/)** - AI-Code Editor
- **GitHub Copilot** - Code-Completion

## 📋 Template-Anpassung

### 1. Projektspezifische Konfiguration
```bash
# CLAUDE.md - AI-Tool Einstellungen anpassen
# docs/promt/promt.md - Projektspezifikation aktualisieren
# .pre-commit-config.yaml - Validierungsregeln anpassen
```

### 2. Umgebungs-Konfiguration
```bash
# Terraform-Variablen definieren (terraform.auto.tfvars)
# Ansible-Inventare erstellen
# GitLab CI/CD Variablen setzen
```

### 3. Cloud-Provider Setup
```bash
# Azure: Service Principal konfigurieren
# On-Premises: Netzwerk-Zugang einrichten
# Multi-Cloud: Provider-Credentials verwalten
```

## 🏷️ Tagging-Strategie

Standardisierte Tags für alle Ressourcen:
```hcl
common_tags = {
  Environment   = "dev|test|prod"
  Project       = "citrix-daas-projekt"
  CostCenter    = "IT-Infrastructure"
  Owner         = "DevOps-Team"
  ManagedBy     = "Terraform"
  CreationDate  = "2025-06-22"
  Purpose       = "citrix-daas-infrastructure"
}
```

## 📖 Dokumentation

- **[CLAUDE.md](./CLAUDE.md)** - Umfassende AI-Tool Konfiguration
- **[TEMPLATE_TODO.md](./TEMPLATE_TODO.md)** - Projekt-Roadmap und Entwicklungsstand
- **[docs/promt/promt.md](./docs/promt/promt.md)** - Detaillierte Projektspezifikation
- **[CHANGELOG.md](./CHANGELOG.md)** - Versionshistorie und Änderungen

## 🤝 Beitragen

### Entwicklungsrichtlinien
- **Deutsche Kommunikation** in allen Diskussionen
- **Terraform Best Practices** befolgen
- **Automatische Tests** vor jedem Commit
- **Dokumentation** für alle Änderungen aktualisieren

### Commit-Konventionen
```
feat: Neue Citrix DaaS Funktionalität
fix: Terraform Konfigurationsfehler behoben
docs: README.md Template-Anpassung aktualisiert
style: Terraform Code-Formatierung
refactor: Ansible Playbook Umstrukturierung
test: Terraform Validierung erweitert
```

## 📞 Support

Bei Fragen oder Problemen:
1. **Issues** in diesem Repository erstellen
2. **GitLab Merge Requests** für Verbesserungsvorschläge
3. **AI-Tools** für Entwicklungsunterstützung nutzen

---

**Template Version**: v1.0.0  
**Letztes Update**: 2025-06-22  
**Entwickelt für**: Enterprise Citrix DaaS Infrastruktur

*Dieses Template wurde mit umfassender AI-Tool Integration entwickelt und folgt modernen DevOps-Praktiken für Citrix DaaS Deployments.*
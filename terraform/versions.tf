# versions.tf - Terraform und Provider Version Constraints Template
# Template für DevOps Terraform Projekte
#
# WICHTIG: Diese Datei muss für jeden spezifischen Cloud-Provider angepasst werden.
# Definieren Sie nur die Provider, die Sie tatsächlich in Ihrem Projekt verwenden.

terraform {
  # Minimale Terraform Version - stellen Sie sicher, dass alle Features verfügbar sind
  required_version = ">= 1.0"
  
  # ================================================================
  # PROVIDER VERSION CONSTRAINTS
  # Wählen Sie die für Ihr Projekt relevanten Provider aus
  # ================================================================
  
  required_providers {
    # ┌─────────────────────────────────────────────────┐
    # │ BEISPIEL: Cloud Provider (wählen Sie einen)    │
    # └─────────────────────────────────────────────────┘
    
    # Azure Resource Manager Provider
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 3.74.0"  # Stable version für Production
    #   # version = "~> 3.0"   # Flexible version für Development
    # }
    
    # VMware vSphere Provider
    # vsphere = {
    #   source  = "hashicorp/vsphere"
    #   version = "~> 2.5.0"   # Stable version für Production
    #   # version = "~> 2.0"   # Flexible version für Development
    # }
    
    # Amazon Web Services Provider
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 5.0"
    # }
    
    # Google Cloud Platform Provider
    # google = {
    #   source  = "hashicorp/google"
    #   version = "~> 4.0"
    # }
    
    # ┌─────────────────────────────────────────────────┐
    # │ UNIVERSELLE PROVIDER (oft benötigt)            │
    # └─────────────────────────────────────────────────┘
    
    # Random Provider für Passwort-Generierung und eindeutige IDs
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~> 3.5.0"
    # }
    
    # TLS Provider für Zertifikat-Management
    # tls = {
    #   source  = "hashicorp/tls"
    #   version = "~> 4.0.0"
    # }
    
    # Local Provider für lokale Ressourcen
    # local = {
    #   source  = "hashicorp/local"
    #   version = "~> 2.4.0"
    # }
    
    # HTTP Provider für externe API Calls
    # http = {
    #   source  = "hashicorp/http"
    #   version = "~> 3.4.0"
    # }
    
    # Null Provider für Provisioners
    # null = {
    #   source  = "hashicorp/null"
    #   version = "~> 3.2.0"
    # }
    
    # Time Provider für zeitbasierte Ressourcen
    # time = {
    #   source  = "hashicorp/time"
    #   version = "~> 0.9.0"
    # }
    
    # ┌─────────────────────────────────────────────────┐
    # │ ENTERPRISE/ERWEITERTE PROVIDER                 │
    # └─────────────────────────────────────────────────┘
    
    # HashiCorp Vault Provider für Secret Management
    # vault = {
    #   source  = "hashicorp/vault"
    #   version = "~> 3.20.0"
    # }
    
    # GitLab Provider für Repository Management
    # gitlab = {
    #   source  = "gitlabhq/gitlab"
    #   version = "~> 16.0"
    # }
    
    # ┌─────────────────────────────────────────────────┐
    # │ UTILITY PROVIDER                               │
    # └─────────────────────────────────────────────────┘
    
    # Archive Provider für ZIP/TAR Operationen
    # archive = {
    #   source  = "hashicorp/archive"
    #   version = "~> 2.4.0"
    # }
    
    # External Provider für externe Commands
    # external = {
    #   source  = "hashicorp/external"
    #   version = "~> 2.3.0"
    # }
  }
  
  # ================================================================
  # BACKEND KONFIGURATION
  # Wählen Sie das für Ihr Setup passende Backend
  # ================================================================
  
  # GitLab HTTP Backend für State Management (Empfohlen für GitLab-Projekte)
  # backend "http" {
  #   # Diese Werte werden durch Backend-Konfigurationsdatei gesetzt:
  #   # terraform init -backend-config=backend-config.conf
  #   # 
  #   # Beispiel backend-config.conf:
  #   # address         = "https://gitlab.example.com/api/v4/projects/PROJECT_ID/terraform/state/ENVIRONMENT"
  #   # lock_address    = "https://gitlab.example.com/api/v4/projects/PROJECT_ID/terraform/state/ENVIRONMENT/lock"
  #   # unlock_address  = "https://gitlab.example.com/api/v4/projects/PROJECT_ID/terraform/state/ENVIRONMENT/lock"
  #   # username        = "terraform"
  #   # password        = "$GITLAB_ACCESS_TOKEN"
  #   # lock_method     = "POST"
  #   # unlock_method   = "DELETE"
  #   # retry_wait_min  = 5
  # }
  
  # Azure Storage Backend (für Azure-basierte Projekte)
  # backend "azurerm" {
  #   resource_group_name  = "terraform-state-rg"
  #   storage_account_name = "terraformstate12345"
  #   container_name       = "tfstate"
  #   key                  = "PROJECT_NAME/ENVIRONMENT/terraform.tfstate"
  # }
  
  # AWS S3 Backend (für AWS-basierte Projekte)
  # backend "s3" {
  #   bucket         = "terraform-state-bucket"
  #   key            = "PROJECT_NAME/ENVIRONMENT/terraform.tfstate"
  #   region         = "us-west-2"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
  
  # Google Cloud Storage Backend (für GCP-basierte Projekte)
  # backend "gcs" {
  #   bucket = "terraform-state-bucket"
  #   prefix = "PROJECT_NAME/ENVIRONMENT"
  # }
  
  # Lokales Backend (nur für Testing/Development)
  # backend "local" {
  #   path = "terraform.tfstate"
  # }
}

# ================================================================
# PROVIDER VERSION PINNING STRATEGIEN
# ================================================================
#
# Development Environment: Flexible Versioning
#   Erlaubt Minor und Patch Updates für neue Features
#   Beispiel: version = "~> 3.0" erlaubt 3.x.x aber nicht 4.x.x
#
# Staging Environment: Semi-Stable Versioning  
#   Erlaubt nur Patch Updates für Bugfixes
#   Beispiel: version = "~> 3.74.0" erlaubt 3.74.x aber nicht 3.75.x
#
# Production Environment: Exact Versioning
#   Verwendet exakte Versionen für maximale Stabilität
#   Beispiel: version = "3.74.0" - keine automatischen Updates
#
# ================================================================

# ================================================================
# VERSION UPGRADE STRATEGY
# ================================================================
#
# 1. Testing: Upgrade in Development Environment zuerst
# 2. Validation: Ausführliche Tests mit neuen Provider-Versionen
# 3. Staging: Deploy auf Staging für Integration Tests
# 4. Production: Kontrollertes Upgrade nach erfolgreicher Validierung
#
# Terraform Version Upgrade Checklist:
# □ Prüfe Terraform Changelog für Breaking Changes
# □ Update required_version in versions.tf
# □ Teste in Development Environment
# □ Update Provider Versionen schrittweise
# □ Führe terraform plan aus für Drift Detection
# □ Dokumentiere Änderungen in CHANGELOG.md
#
# Provider Upgrade Checklist:
# □ Prüfe Provider Changelog für Breaking Changes
# □ Update version constraints in versions.tf
# □ Führe terraform init -upgrade aus
# □ Teste terraform plan für unerwartete Änderungen
# □ Validiere Funktionalität in Test Environment
# □ Update Dokumentation falls erforderlich
#
# ================================================================

# ================================================================
# COMPATIBILITY MATRIX (REFERENZ)
# ================================================================
#
# Terraform Version Compatibility:
# - Terraform >= 1.0: Alle Provider unterstützt, stabile ABI
# - Terraform >= 1.3: Enhanced validation und moved blocks
# - Terraform >= 1.5: Import blocks und configuration-driven import
# - Terraform >= 1.6: Test framework und erweiterte Backend-Features
#
# Provider-spezifische Kompatibilität:
# - Immer die aktuellen Provider-Dokumentationen konsultieren
# - Provider-Matrix in offizieller Terraform Registry prüfen
# - Breaking Changes in Provider Release Notes beachten
#
# ================================================================
# main.tf - Hauptkonfiguration
# Template für DevOps Terraform Projekte
#
# WICHTIG: Provider-Konfiguration muss separat in providers.tf und versions.tf erfolgen
# Siehe examples/ Verzeichnis für Beispiel-Konfigurationen verschiedener Provider

# Terraform-Konfiguration wird in versions.tf definiert

# Lokale Variablen für wiederverwendbare Werte
locals {
  # Timestamp für eindeutige Ressourcen-Namen
  timestamp = formatdate("YYYYMMDDHHmm", timestamp())
  
  # Standardisierte Tagging-Strategie
  common_tags = {
    Environment   = var.environment
    Project       = var.project_name
    CostCenter    = var.cost_center
    Owner         = var.owner
    ManagedBy     = "Terraform"
    CreationDate  = formatdate("YYYY-MM-DD", timestamp())
    Purpose       = var.resource_purpose
    Repository    = var.repository_url
  }

  # Naming Convention: project-environment-resource-purpose
  name_prefix = "${var.project_name}-${var.environment}"
}

# ==================================================
# BEISPIEL: Provider-spezifische Ressourcen
# Implementierung abhängig vom gewählten Cloud-Provider
# ==================================================

# Beispiel für Resource Group/Organisation-Container
# resource "PROVIDER_resource_group" "main" {
#   name     = "${local.name_prefix}-rg"
#   location = var.primary_location
#   tags     = local.common_tags
# }

# ==================================================
# BEISPIEL: Modul-Integrationen
# Passen Sie an Ihre Provider-spezifischen Module an
# ==================================================

# Beispiel: Netzwerk-Modul (anpassbar für jeden Provider)
module "networking" {
  source = "./modules/networking"
  
  # Standard-Parameter (provider-agnostisch)
  name_prefix     = local.name_prefix
  location        = var.primary_location
  environment     = var.environment
  
  # Netzwerk-spezifische Parameter
  network_cidr    = var.network_cidr
  subnet_cidrs    = var.subnet_cidrs
  
  # Tags (universell anwendbar)
  tags = local.common_tags
}

# Beispiel: Compute/VM-Modul (anpassbar für verschiedene Workloads)
module "compute_infrastructure" {
  source = "./modules/compute"
  
  # Standard-Parameter (provider-agnostisch)
  name_prefix     = local.name_prefix
  location        = var.primary_location
  environment     = var.environment
  
  # Compute-spezifische Parameter
  vm_count           = var.vm_count
  vm_size            = var.vm_size
  subnet_id          = module.networking.subnet_ids["compute"]
  admin_username     = var.admin_username
  admin_password     = var.admin_password  # Sollte aus Secret Store kommen
  
  # Workload-spezifische Konfiguration
  application_version = var.application_version
  domain_join        = var.domain_join
  
  # Tags
  tags = merge(local.common_tags, {
    Component = "ComputeResources"
    Tier      = "Application"
  })
  
  # Abhängigkeiten
  depends_on = [module.networking]
}

# Beispiel: Security-Modul (universell anwendbar)
module "security" {
  source = "./modules/security"
  
  # Standard-Parameter (provider-agnostisch)
  name_prefix     = local.name_prefix
  location        = var.primary_location
  environment     = var.environment
  
  # Security-spezifische Parameter
  allowed_ips        = var.allowed_management_ips
  enable_monitoring  = var.enable_monitoring
  
  # Tags
  tags = merge(local.common_tags, {
    Component = "Security"
    Tier      = "Infrastructure"
  })
  
  # Abhängigkeiten
  depends_on = [module.networking]
}
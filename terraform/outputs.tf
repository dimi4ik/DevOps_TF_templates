# outputs.tf - Strukturierte Output-Werte Template
# Template für DevOps Terraform Projekte

# ================================================
# PROJEKT-INFORMATIONEN
# ================================================

output "project_info" {
  description = "Projekt-Grundinformationen"
  value = {
    name         = var.project_name
    environment  = var.environment
    timestamp    = local.timestamp
    location     = var.primary_location
  }
}

output "resource_naming" {
  description = "Verwendete Naming-Convention"
  value = {
    prefix      = local.name_prefix
    pattern     = "${var.project_name}-${var.environment}-<resource>-<purpose>"
    example     = "${local.name_prefix}-vm-app"
    tags        = local.common_tags
  }
}

# ================================================
# INFRASTRUCTURE OUTPUTS (Provider-agnostisch)
# ================================================

# output "resource_group" {
#   description = "Resource Group/Organisation Container Informationen"
#   value = {
#     name     = "Wird durch Provider-spezifische Ressource definiert"
#     location = var.primary_location
#     id       = "Wird durch Provider gesetzt"
#     tags     = local.common_tags
#   }
# }

# ================================================
# NETZWERK-OUTPUTS
# ================================================

# output "networking" {
#   description = "Netzwerk-Konfiguration und Ressourcen"
#   value = {
#     network_id   = module.networking.network_id
#     network_name = module.networking.network_name
#     network_cidr = var.network_cidr
#     subnet_ids   = module.networking.subnet_ids
#     subnet_names = module.networking.subnet_names
#   }
# }

# ================================================
# COMPUTE-OUTPUTS
# ================================================

# output "compute_infrastructure" {
#   description = "Compute-Ressourcen Informationen"
#   value = {
#     vm_ids         = module.compute_infrastructure.vm_ids
#     vm_names       = module.compute_infrastructure.vm_names
#     vm_ips         = module.compute_infrastructure.vm_ips
#     load_balancer  = module.compute_infrastructure.load_balancer_info
#   }
# }

# ================================================
# SECURITY-OUTPUTS
# ================================================

# output "security" {
#   description = "Security-Konfiguration und Ressourcen"
#   value = {
#     security_group_ids = module.security.security_group_ids
#     firewall_rules     = module.security.firewall_rules
#     key_vault_id       = module.security.key_vault_id
#     certificates       = module.security.certificate_info
#   }
# }

# ================================================
# ENVIRONMENT-SPEZIFISCHE OUTPUTS
# ================================================

output "environment_config" {
  description = "Environment-spezifische Konfiguration"
  value = {
    environment      = var.environment
    config          = local.current_env_config
    backup_policy   = local.current_env_config.backup_retention
    monitoring      = local.current_env_config.enable_monitoring
  }
}

# ================================================
# COST MANAGEMENT & TAGGING
# ================================================

output "cost_management" {
  description = "Cost Management und Tagging-Informationen"
  value = {
    cost_center     = var.cost_center
    owner          = var.owner
    project_tags   = local.common_tags
    estimated_cost = "Wird nach Deployment berechnet"
  }
}

# ================================================
# DEPLOYMENT-INFORMATIONEN
# ================================================

output "deployment_info" {
  description = "Deployment-spezifische Informationen"
  value = {
    terraform_version    = ">=1.0"
    deployment_time      = local.timestamp
    configuration_source = var.repository_url
    
    # Provider-Informationen (wird zur Laufzeit gesetzt)
    # provider_versions = {
    #   # Beispiele je nach verwendetem Provider:
    #   # azurerm = "~> 3.74.0"
    #   # vsphere = "~> 2.5.0"
    #   # aws     = "~> 5.0"
    #   # random  = "~> 3.5.0"
    # }
  }
}

# ================================================
# MONITORING & LOGGING
# ================================================

# output "monitoring" {
#   description = "Monitoring und Logging Endpunkte"
#   value = {
#     dashboard_url     = "Wird nach Provider-Setup konfiguriert"
#     log_endpoints     = ["Provider-spezifische Log-URLs"]
#     alert_endpoints   = ["Provider-spezifische Alert-URLs"]
#     health_checks     = ["Provider-spezifische Health-Check URLs"]
#   }
# }

# ================================================
# MANAGEMENT & OPERATIONS
# ================================================

# output "management_info" {
#   description = "Management und Operations Informationen"
#   value = {
#     management_endpoints = ["Provider-spezifische Management-URLs"]
#     backup_schedules     = local.current_env_config.backup_retention
#     maintenance_windows  = "Definiert durch Operations-Team"
#     
#     # Beispiel für Kommandos (provider-spezifisch)
#     useful_commands = {
#       "Status Check" = "terraform state list"
#       "Plan Check"   = "terraform plan"
#       "Validate"     = "terraform validate"
#     }
#   }
# }

# ================================================
# SENSITIVE OUTPUTS (mit sensitive = true markiert)
# ================================================

# output "connection_strings" {
#   description = "Verbindungsstrings für Anwendungen"
#   sensitive   = true
#   value = {
#     database_url    = "Wird durch Provider-spezifische Ressource gesetzt"
#     storage_keys    = "Wird durch Provider-spezifische Ressource gesetzt"
#     api_endpoints   = "Wird durch Provider-spezifische Ressource gesetzt"
#   }
# }

# ================================================
# DEBUG & TROUBLESHOOTING
# ================================================

# output "debug_info" {
#   description = "Debug und Troubleshooting Informationen"
#   value = {
#     locals_computed = {
#       name_prefix        = local.name_prefix
#       timestamp         = local.timestamp
#       environment_config = local.current_env_config
#     }
#     variables_used = {
#       project_name      = var.project_name
#       environment       = var.environment
#       primary_location  = var.primary_location
#     }
#   }
# }
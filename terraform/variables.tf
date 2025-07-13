# variables.tf - Input-Variablen Template
# Template für DevOps Terraform Projekte

# ================================================
# PROJEKT-GRUNDKONFIGURATION
# ================================================

variable "project_name" {
  description = "Name des Projekts (wird für Ressourcen-Naming verwendet)"
  type        = string
  
  validation {
    condition     = length(var.project_name) >= 3 && length(var.project_name) <= 15
    error_message = "Project name muss zwischen 3 und 15 Zeichen lang sein."
  }
  
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.project_name))
    error_message = "Project name darf nur Kleinbuchstaben, Zahlen und Bindestriche enthalten."
  }
}

variable "environment" {
  description = "Deployment-Umgebung"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "test", "staging", "prod"], var.environment)
    error_message = "Environment muss einer der folgenden Werte sein: dev, test, staging, prod."
  }
}

variable "repository_url" {
  description = "Git Repository URL für Tracking"
  type        = string
  default     = ""
}

# ================================================
# INFRASTRUKTUR-GRUNDKONFIGURATION
# ================================================

variable "primary_location" {
  description = "Primäre Deployment-Region/Standort"
  type        = string
  default     = ""
  
  validation {
    condition     = length(var.primary_location) > 0
    error_message = "Primary location darf nicht leer sein."
  }
}

variable "owner" {
  description = "Verantwortlicher für die Infrastruktur"
  type        = string
  default     = ""
}

variable "cost_center" {
  description = "Kostenstelle für Ressourcen-Zuordnung"
  type        = string
  default     = ""
}

variable "resource_purpose" {
  description = "Zweck der Ressourcen (z.B. app, db, cache)"
  type        = string
  default     = "general"
}

# ================================================
# NETZWERK-KONFIGURATION
# ================================================

variable "network_cidr" {
  description = "CIDR-Block für das Hauptnetzwerk"
  type        = string
  default     = "10.0.0.0/16"
  
  validation {
    condition     = can(cidrhost(var.network_cidr, 0))
    error_message = "Network CIDR muss ein gültiger CIDR-Block sein."
  }
}

variable "subnet_cidrs" {
  description = "CIDR-Blöcke für Subnetze"
  type        = map(string)
  default = {
    compute = "10.0.1.0/24"
    data    = "10.0.2.0/24"
    mgmt    = "10.0.3.0/24"
  }
}

# ================================================
# COMPUTE-KONFIGURATION
# ================================================

variable "vm_count" {
  description = "Anzahl der VMs"
  type        = number
  default     = 1
  
  validation {
    condition     = var.vm_count >= 1 && var.vm_count <= 10
    error_message = "VM count muss zwischen 1 und 10 liegen."
  }
}

variable "vm_size" {
  description = "VM-Größe/Typ (provider-spezifisch definieren)"
  type        = string
  default     = "medium"
  
  validation {
    condition     = contains(["small", "medium", "large"], var.vm_size)
    error_message = "VM size muss einer der folgenden Werte sein: small, medium, large."
  }
}

variable "admin_username" {
  description = "Administrator-Benutzername"
  type        = string
  default     = "admin"
  
  validation {
    condition     = length(var.admin_username) >= 3
    error_message = "Admin username muss mindestens 3 Zeichen lang sein."
  }
}

variable "admin_password" {
  description = "Administrator-Passwort (sollte aus Secret Store kommen)"
  type        = string
  sensitive   = true
  default     = ""
}

# ================================================
# SECURITY-KONFIGURATION
# ================================================

variable "allowed_management_ips" {
  description = "IP-Adressen/CIDR-Blöcke für Management-Zugriff"
  type        = list(string)
  default     = ["0.0.0.0/0"]
  
  validation {
    condition = alltrue([
      for ip in var.allowed_management_ips : can(cidrhost(ip, 0))
    ])
    error_message = "Alle IP-Adressen müssen gültige CIDR-Blöcke sein."
  }
}

variable "enable_monitoring" {
  description = "Aktiviert Monitoring für die Infrastruktur"
  type        = bool
  default     = true
}

variable "domain_join" {
  description = "Domain für Domain-Join (leer = kein Domain-Join)"
  type        = string
  default     = ""
}

# ================================================
# APPLICATION-KONFIGURATION
# ================================================

variable "application_version" {
  description = "Version der zu installierenden Anwendung"
  type        = string
  default     = "latest"
}

# ================================================
# CSV-IMPORT KONFIGURATION (Optional)
# ================================================

variable "csv_file_path" {
  description = "Pfad zur CSV-Datei für Massen-Import (optional)"
  type        = string
  default     = ""
  
  validation {
    condition     = var.csv_file_path == "" || can(regex("^.*\\.csv$", var.csv_file_path))
    error_message = "CSV file path muss leer sein oder mit .csv enden."
  }
}

# ================================================
# BACKUP & MAINTENANCE
# ================================================

variable "backup_enabled" {
  description = "Aktiviert automatische Backups"
  type        = bool
  default     = true
}

variable "maintenance_window" {
  description = "Wartungsfenster (z.B. 'Sunday:02:00-Sunday:04:00')"
  type        = string
  default     = "Sunday:02:00-Sunday:04:00"
}

# ================================================
# TAGS & METADATA
# ================================================

variable "additional_tags" {
  description = "Zusätzliche Tags für alle Ressourcen"
  type        = map(string)
  default     = {}
}

# ================================================
# PROVIDER-SPEZIFISCHE VARIABLEN (Beispiele)
# Entkommentieren und anpassen je nach verwendetem Provider
# ================================================

# # Azure-spezifische Variablen
# variable "azure_location" {
#   description = "Azure Region für Deployment"
#   type        = string
#   default     = "West Europe"
# }

# variable "azure_subscription_id" {
#   description = "Azure Subscription ID"
#   type        = string
#   sensitive   = true
#   default     = ""
# }

# # AWS-spezifische Variablen
# variable "aws_region" {
#   description = "AWS Region für Deployment"
#   type        = string
#   default     = "us-west-2"
# }

# # GCP-spezifische Variablen
# variable "gcp_project_id" {
#   description = "Google Cloud Project ID"
#   type        = string
#   default     = ""
# }

# variable "gcp_region" {
#   description = "Google Cloud Region"
#   type        = string
#   default     = "us-central1"
# }

# # VMware vSphere-spezifische Variablen
# variable "vcenter_server" {
#   description = "vCenter Server FQDN oder IP"
#   type        = string
#   default     = ""
# }

# variable "vsphere_username" {
#   description = "vSphere Benutzername"
#   type        = string
#   sensitive   = true
#   default     = ""
# }

# variable "vsphere_password" {
#   description = "vSphere Passwort"
#   type        = string
#   sensitive   = true
#   default     = ""
# }

# variable "vsphere_allow_unverified_ssl" {
#   description = "Erlaube unverified SSL certificates für vSphere"
#   type        = bool
#   default     = false
# }

# variable "datacenter_name" {
#   description = "Name des vSphere Datacenters"
#   type        = string
#   default     = ""
# }

# ================================================
# ENVIRONMENT-SPEZIFISCHE ÜBERSCHREIBUNGEN
# ================================================

variable "prod_management_cidrs" {
  description = "Spezielle Management-IPs für Production (überschreibt allowed_management_ips)"
  type        = list(string)
  default     = []
}
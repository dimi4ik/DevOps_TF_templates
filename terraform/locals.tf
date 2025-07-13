# =============================================================================
# Local Values and Computed Variables Template
# =============================================================================

locals {
  # Standardisierte Naming Convention
  # Format: ${project}-${environment}-${resource_type}-${purpose}
  name_prefix = "${var.project_name}-${var.environment}"

  # Universelle Tagging-Strategie (anpassbar für alle Provider)
  common_tags = {
    Environment   = var.environment
    Project       = var.project_name
    ManagedBy     = "Terraform"
    CreationDate  = formatdate("YYYY-MM-DD", timestamp())
    Owner         = var.owner
    CostCenter    = var.cost_center
    Repository    = var.repository_url
  }

  # Timestamp für eindeutige Ressourcen-Namen
  timestamp = formatdate("YYYYMMDDHHmm", timestamp())

  # Environment-spezifische Konfigurationen
  environment_config = {
    dev = {
      instance_size        = "small"
      backup_retention     = 7
      enable_monitoring    = false
      auto_shutdown        = true
    }
    test = {
      instance_size        = "small"
      backup_retention     = 14
      enable_monitoring    = true
      auto_shutdown        = true
    }
    prod = {
      instance_size        = "large"
      backup_retention     = 30
      enable_monitoring    = true
      auto_shutdown        = false
    }
  }

  # Aktuelle Environment-Konfiguration
  current_env_config = local.environment_config[var.environment]

  # ==========================================================================
  # BEISPIEL: CSV-basierte Konfiguration (optional)
  # Entkommentieren und anpassen, wenn CSV-Import benötigt wird
  # ==========================================================================

  # # CSV file parsing (beispielhaft für VM/Resource Import)
  # csv_content = var.csv_file_path != "" ? file(var.csv_file_path) : ""
  # csv_lines   = var.csv_file_path != "" ? split("\n", trimspace(local.csv_content)) : []
  # csv_rows    = length(local.csv_lines) > 1 ? slice(local.csv_lines, 1, length(local.csv_lines)) : []

  # # Beispiel: VM-Konfigurationen aus CSV parsen
  # csv_vm_configs = [
  #   for row in local.csv_rows : {
  #     name         = length(split(";", row)) > 0 ? split(";", row)[0] : ""
  #     size         = length(split(";", row)) > 1 ? split(";", row)[1] : ""
  #     network      = length(split(";", row)) > 2 ? split(";", row)[2] : ""
  #     # Weitere Felder nach Bedarf...
  #   } if row != "" && length(split(";", row)) >= 3
  # ]

  # ==========================================================================
  # PROVIDER-SPEZIFISCHE LOCALS (Beispiele)
  # Entkommentieren und anpassen je nach verwendetem Provider
  # ==========================================================================

  # # Azure-spezifische Locals
  # azure_config = {
  #   resource_group_name = "${local.name_prefix}-rg"
  #   location           = var.azure_location
  #   sku_tier          = local.current_env_config.instance_size == "small" ? "Standard_B2s" : "Standard_D4s_v3"
  # }

  # # AWS-spezifische Locals
  # aws_config = {
  #   instance_type = local.current_env_config.instance_size == "small" ? "t3.medium" : "m5.large"
  #   region        = var.aws_region
  # }

  # # VMware vSphere-spezifische Locals
  # vsphere_config = {
  #   datacenter_name = var.datacenter_name
  #   cluster_name    = var.cluster_name
  #   datastore_name  = var.datastore_name
  # }

  # # GCP-spezifische Locals
  # gcp_config = {
  #   machine_type = local.current_env_config.instance_size == "small" ? "e2-medium" : "e2-standard-4"
  #   region       = var.gcp_region
  #   zone         = var.gcp_zone
  # }

  # ==========================================================================
  # SECURITY UND COMPLIANCE
  # ==========================================================================

  # Netzwerk-Konfiguration basierend auf Environment
  network_config = {
    # CIDR-Bereiche pro Environment
    dev_cidr  = "10.0.0.0/16"
    test_cidr = "10.1.0.0/16"
    prod_cidr = "10.2.0.0/16"
  }

  # Security Gruppen/Firewall Regeln basierend auf Environment
  security_rules = {
    # Management-Zugriff nur für bestimmte IPs
    management_cidrs = var.environment == "prod" ? var.prod_management_cidrs : ["0.0.0.0/0"]
    
    # Port-Zugriff basierend auf Environment
    allowed_ports = var.environment == "prod" ? [22, 443] : [22, 80, 443, 3389]
  }
}
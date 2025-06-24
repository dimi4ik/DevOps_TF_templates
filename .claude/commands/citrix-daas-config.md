Citrix DaaS Konfigurationshilfe für Multi-Cloud Deployments:

## Citrix DaaS Konfiguration & Setup

1. **Citrix Cloud Setup:**
   
   **Cloud Connector Installation:**
   ```bash
   # Cloud Connector auf Domain Controller oder dedizierter VM
   # Download von Citrix Cloud Admin Console
   # Automatische Registrierung mit Cloud-Aktivierungscode
   ```
   
   **API-Zugang konfigurieren:**
   ```hcl
   # Citrix Cloud API Credentials
   variable "citrix_customer_id" {
     description = "Citrix Cloud Customer ID"
     type        = string
     sensitive   = true
   }
   
   variable "citrix_client_id" {
     description = "Citrix Cloud API Client ID"  
     type        = string
     sensitive   = true
   }
   
   variable "citrix_client_secret" {
     description = "Citrix Cloud API Client Secret"
     type        = string
     sensitive   = true
   }
   ```

2. **Resource Location Konfiguration:**
   
   **Azure Resource Location:**
   ```hcl
   # Azure Cloud Resource Location
   resource "citrix_daas_resource_location" "azure" {
     name = "${var.project_name}-azure-${var.environment}"
     
     hypervisor_connection {
       name = "${var.project_name}-azure-hypervisor"
       type = "AzureRM"
       
       connection_options = {
         SubscriptionId     = var.azure_subscription_id
         ActiveDirectoryId  = var.azure_tenant_id
         ApplicationId      = var.azure_client_id
         ApplicationSecret  = var.azure_client_secret
         Environment        = "AzureCloud"
         ManagementEndpoint = "https://management.azure.com/"
         StorageEndpoint    = "https://core.windows.net/"
       }
     }
     
     tags = merge(var.common_tags, {
       ResourceType = "CitrixResourceLocation"
       CloudProvider = "Azure"
     })
   }
   ```
   
   **On-Premises Resource Location:**
   ```hcl
   # VMware vSphere Resource Location
   resource "citrix_daas_resource_location" "on_premises" {
     name = "${var.project_name}-onprem-${var.environment}"
     
     hypervisor_connection {
       name = "${var.project_name}-vsphere-hypervisor"
       type = "VMwareVirtualCenter"
       
       connection_options = {
         Server   = var.vcenter_server
         Username = var.vcenter_username
         Password = var.vcenter_password
         SslThumbprints = var.vcenter_ssl_thumbprints
       }
     }
     
     tags = merge(var.common_tags, {
       ResourceType = "CitrixResourceLocation"
       CloudProvider = "VMware"
     })
   }
   ```

3. **Machine Catalog Konfiguration:**
   
   **Azure Machine Catalog:**
   ```hcl
   # Azure-basierter Machine Catalog
   resource "citrix_daas_machine_catalog" "azure_catalog" {
     name                = "${var.project_name}-azure-catalog-${var.environment}"
     description         = "Azure Machine Catalog für ${var.project_name}"
     allocation_type     = "Random"
     session_support     = "MultiSession"
     is_power_managed    = true
     is_remote_pc        = false
     
     provisioning_type   = "MCS"
     resource_location_id = citrix_daas_resource_location.azure.id
     
     # VM-Konfiguration
     master_image {
       hypervisor_connection_id = citrix_daas_resource_location.azure.hypervisor_connection.id
       resource_group_name      = var.azure_resource_group_name
       master_image_name        = var.azure_master_image_name
       storage_type            = "Premium_LRS"
       use_managed_disks       = true
     }
     
     # Machine-Spezifikationen
     machine_profile {
       vm_size           = var.azure_vm_size
       storage_type      = "Premium_LRS"
       use_accelerated_networking = true
     }
     
     # Anzahl der Maschinen
     total_machine_count = var.machine_count
     
     tags = merge(var.common_tags, {
       ResourceType = "CitrixMachineCatalog"
       CloudProvider = "Azure"
       SessionSupport = "MultiSession"
     })
   }
   ```
   
   **On-Premises Machine Catalog:**
   ```hcl
   # VMware-basierter Machine Catalog
   resource "citrix_daas_machine_catalog" "onprem_catalog" {
     name                = "${var.project_name}-onprem-catalog-${var.environment}"
     description         = "On-Premises Machine Catalog für ${var.project_name}"
     allocation_type     = "Static"
     session_support     = "MultiSession"
     is_power_managed    = true
     
     provisioning_type   = "MCS"
     resource_location_id = citrix_daas_resource_location.on_premises.id
     
     # VM Template Konfiguration
     master_image {
       hypervisor_connection_id = citrix_daas_resource_location.on_premises.hypervisor_connection.id
       template_name           = var.vmware_template_name
       snapshot_name          = var.vmware_snapshot_name
       cpu_count              = var.vmware_cpu_count
       memory_mb              = var.vmware_memory_mb
     }
     
     total_machine_count = var.machine_count
     
     tags = merge(var.common_tags, {
       ResourceType = "CitrixMachineCatalog"
       CloudProvider = "VMware"
       SessionSupport = "MultiSession"
     })
   }
   ```

4. **Delivery Group Konfiguration:**
   
   **Standard Delivery Group:**
   ```hcl
   # Delivery Group für Published Apps und Desktops
   resource "citrix_daas_delivery_group" "main" {
     name        = "${var.project_name}-delivery-group-${var.environment}"
     description = "Haupt Delivery Group für ${var.project_name}"
     
     # Machine Catalog Zuordnung
     machine_catalogs = [
       {
         machine_catalog_id = citrix_daas_machine_catalog.azure_catalog.id
         machine_count     = var.delivery_group_machine_count_azure
       },
       {
         machine_catalog_id = citrix_daas_machine_catalog.onprem_catalog.id  
         machine_count     = var.delivery_group_machine_count_onprem
       }
     ]
     
     # Delivery-Typ Konfiguration
     delivery_type = "DesktopsAndApps"
     
     # Session-Management
     session_sharing_enabled = true
     
     # User-Assignments
     users = var.delivery_group_users
     user_groups = var.delivery_group_user_groups
     
     # Automation und Policies
     enable_session_sharing = true
     restrict_to_tag       = var.delivery_group_restriction_tag
     
     tags = merge(var.common_tags, {
       ResourceType = "CitrixDeliveryGroup"
       DeliveryType = "DesktopsAndApps"
     })
   }
   ```

5. **Application Publishing:**
   
   **Published Applications:**
   ```hcl
   # Published App Konfiguration
   resource "citrix_daas_application" "office_suite" {
     name               = "Microsoft Office Suite"
     description        = "Microsoft Office 365 Apps"
     delivery_group_id  = citrix_daas_delivery_group.main.id
     
     application_path   = "C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE"
     command_line_args  = ""
     working_directory  = "%USERPROFILE%\\Documents"
     
     # Icon und Display
     icon_path          = "C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE"
     icon_index         = 0
     
     # Visibility und Access
     visible_to_users   = true
     enabled           = true
     
     # User Assignments
     users             = var.office_suite_users
     user_groups       = var.office_suite_user_groups
     
     # App-spezifische Einstellungen
     cpu_priority_level = "Normal"
     shortcut_added_to_desktop = true
     
     tags = merge(var.common_tags, {
       ResourceType = "CitrixApplication"
       ApplicationType = "Office365"
     })
   }
   ```

6. **Policies und Konfiguration:**
   
   **Session-Policies:**
   ```hcl
   # Citrix Policy für Session-Management
   resource "citrix_daas_policy_set" "session_policies" {
     name        = "${var.project_name}-session-policies-${var.environment}"
     description = "Session Management Policies"
     
     policies = [
       {
         name        = "Session Timeout Policy"
         description = "Konfiguration für Session Timeouts"
         enabled     = true
         priority    = 1
         
         settings = {
           "SessionTimeLimit"           = "7200"  # 2 Stunden
           "DisconnectedSessionLimit"   = "1440"  # 24 Stunden  
           "IdleSessionLimit"          = "900"   # 15 Minuten
         }
         
         filters = [
           {
             type  = "DeliveryGroup"
             value = citrix_daas_delivery_group.main.name
           }
         ]
       }
     ]
     
     tags = merge(var.common_tags, {
       ResourceType = "CitrixPolicySet"
       PolicyType = "SessionManagement"
     })
   }
   ```

7. **Monitoring und Logging:**
   
   **Performance Monitoring Setup:**
   ```hcl
   # Monitoring Konfiguration
   variable "enable_citrix_monitoring" {
     description = "Enable Citrix DaaS Monitoring"
     type        = bool
     default     = true
   }
   
   variable "monitoring_retention_days" {
     description = "Monitoring data retention in days"
     type        = number
     default     = 30
   }
   ```

8. **Security & Compliance:**
   
   **SSL/TLS Konfiguration:**
   ```hcl
   # SSL Certificate für Citrix Gateway
   variable "ssl_certificate_path" {
     description = "Path to SSL certificate for Citrix Gateway"
     type        = string
   }
   
   variable "ssl_certificate_password" {
     description = "Password for SSL certificate"
     type        = string
     sensitive   = true
   }
   ```

## Häufige Konfigurationsmuster:

**Development Environment:**
- Kleine Machine Catalogs (1-2 VMs)
- Relaxed Policies
- Shared Delivery Groups

**Production Environment:**  
- High Availability Machine Catalogs
- Strikte Session Policies
- Separate Delivery Groups nach User-Gruppen
- Backup und Disaster Recovery

**Hybrid Setup:**
- Azure für Burst Capacity
- On-Premises für Baseline Workload
- Smart Load Balancing zwischen Clouds

## Integration Commands:

- `/template-validate` für DaaS-Konfiguration überprüfen
- `/multi-cloud-deploy` für DaaS-Infrastruktur deployment
- `/template-optimize` für Performance-Tuning
- `/monitor` für DaaS-Monitoring Setup

## Troubleshooting:

**Häufige DaaS-Probleme:**
- Cloud Connector Connectivity Issues
- Hypervisor Connection Failures  
- Machine Catalog Provisioning Errors
- User Assignment Problems
- Policy Application Failures
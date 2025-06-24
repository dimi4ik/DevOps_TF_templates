Template Performance-Optimierung für Citrix DaaS Infrastruktur:

## Template-Optimierung Workflow

1. **Infrastructure Performance Analyse:**
   
   **Terraform State Optimierung:**
   ```bash
   # State-Größe analysieren
   terraform show -json | jq '. | length'
   
   # Resource-Dependencies optimieren
   terraform graph | dot -Tpng > dependency-graph.png
   
   # Parallele Resource-Erstellung maximieren
   terraform apply -parallelism=20
   ```
   
   **Provider Performance:**
   ```hcl
   # Azure Provider Optimierung
   provider "azurerm" {
     features {}
     
     # Performance Optimierungen
     skip_provider_registration = true
     use_msi                   = true
     
     # API-Rate Limiting reduzieren
     client_timeout_seconds = 300
   }
   
   # Citrix Provider Optimierung  
   provider "citrix" {
     # Connection Pooling
     max_connections    = 10
     connection_timeout = 300
     
     # Retry Logic
     max_retries = 3
     retry_delay = 5
   }
   ```

2. **Resource-Optimierung:**
   
   **VM-Sizing Optimierung:**
   ```hcl
   # Citrix DaaS VM-Sizing Matrix
   locals {
     vm_sizing = {
       # Light Users (Office Apps)
       light = {
         azure_vm_size = "Standard_D2s_v3"
         vcpu_count   = 2
         memory_gb    = 8
         users_per_vm = 15
       }
       
       # Medium Users (Mixed Workloads)
       medium = {
         azure_vm_size = "Standard_D4s_v3"  
         vcpu_count   = 4
         memory_gb    = 16
         users_per_vm = 25
       }
       
       # Heavy Users (Graphics/CAD)
       heavy = {
         azure_vm_size = "Standard_D8s_v3"
         vcpu_count   = 8
         memory_gb    = 32
         users_per_vm = 10
       }
     }
   }
   
   # Dynamic VM-Sizing basierend auf Workload
   resource "azurerm_virtual_machine_scale_set" "citrix_workers" {
     name     = "${var.project_name}-citrix-workers"
     sku      = local.vm_sizing[var.workload_type].azure_vm_size
     capacity = ceil(var.expected_users / local.vm_sizing[var.workload_type].users_per_vm)
     
     # Performance-Optimierung
     overprovision                = false
     single_placement_group       = false
     zones                       = var.availability_zones
     zone_balance                = true
     platform_fault_domain_count = 2
   }
   ```
   
   **Storage Performance-Optimierung:**
   ```hcl
   # Optimierte Storage-Konfiguration
   resource "azurerm_managed_disk" "citrix_os_disk" {
     for_each = var.machine_catalogs
     
     name                 = "${each.key}-os-disk"
     location            = var.location
     resource_group_name = var.resource_group_name
     
     # Performance-optimierte Storage
     storage_account_type = var.environment == "prod" ? "Premium_LRS" : "StandardSSD_LRS"
     disk_size_gb        = 128
     
     # Disk Performance Tuning
     disk_iops_read_write = var.environment == "prod" ? 3000 : 1000
     disk_mbps_read_write = var.environment == "prod" ? 125 : 60
     
     # Caching-Optimierung
     create_option = "Empty"
     
     tags = merge(var.common_tags, {
       DiskType = "OS"
       Performance = var.environment == "prod" ? "Premium" : "Standard"
     })
   }
   ```

3. **Netzwerk-Performance Optimierung:**
   
   **Accelerated Networking:**
   ```hcl
   # Accelerated Networking für bessere Performance
   resource "azurerm_network_interface" "citrix_worker_nic" {
     for_each = var.worker_instances
     
     name                          = "${each.key}-nic"
     location                     = var.location
     resource_group_name          = var.resource_group_name
     enable_accelerated_networking = true
     enable_ip_forwarding         = false
     
     ip_configuration {
       name                          = "internal"
       subnet_id                    = var.subnet_id
       private_ip_address_allocation = "Dynamic"
       
       # Load Balancer Integration
       load_balancer_backend_address_pool_ids = [
         azurerm_lb_backend_address_pool.citrix_workers.id
       ]
     }
   }
   ```
   
   **CDN und Caching:**
   ```hcl
   # Azure CDN für bessere Content-Delivery
   resource "azurerm_cdn_profile" "citrix_content" {
     count = var.enable_cdn ? 1 : 0
     
     name                = "${var.project_name}-cdn"
     location           = var.location
     resource_group_name = var.resource_group_name
     sku                = "Standard_Microsoft"
     
     tags = merge(var.common_tags, {
       Component = "ContentDelivery"
     })
   }
   ```

4. **Auto-Scaling Optimierung:**
   
   **Dynamic Machine Catalog Sizing:**
   ```hcl
   # Auto-Scaling für Machine Catalogs
   locals {
     # Peak-Hours Berechnung
     peak_hours_start = 8   # 8 AM
     peak_hours_end   = 18  # 6 PM
     
     # Dynamic Scaling Faktoren
     scaling_factors = {
       peak_multiplier    = 1.5
       off_peak_minimum   = 0.3
       weekend_factor     = 0.2
     }
     
     # Optimierte Machine Counts
     optimized_machine_count = {
       minimum = max(1, floor(var.base_machine_count * local.scaling_factors.off_peak_minimum))
       maximum = ceil(var.base_machine_count * local.scaling_factors.peak_multiplier)
       target  = var.base_machine_count
     }
   }
   
   # Citrix DaaS Auto-Scaling Policy
   resource "citrix_daas_power_time_scheme" "auto_scaling" {
     name        = "${var.project_name}-auto-scaling"
     description = "Optimierte Auto-Scaling Policy"
     
     # Peak Hours Configuration
     pool_size_schedules = [
       {
         time_range     = "08:00-18:00"
         days_of_week   = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
         pool_size      = local.optimized_machine_count.maximum
       },
       {
         time_range     = "18:00-08:00"
         days_of_week   = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
         pool_size      = local.optimized_machine_count.minimum
       },
       {
         time_range     = "00:00-23:59"
         days_of_week   = ["Saturday", "Sunday"]
         pool_size      = floor(local.optimized_machine_count.target * local.scaling_factors.weekend_factor)
       }
     ]
   }
   ```

5. **Database und State Performance:**
   
   **Terraform Backend Optimierung:**
   ```hcl
   # Optimierte Backend-Konfiguration
   terraform {
     backend "azurerm" {
       # Performance-optimierte Storage
       storage_account_name = var.terraform_storage_account
       container_name      = var.terraform_container
       key                = "${var.project_name}-${var.environment}.tfstate"
       
       # Parallele State-Operationen
       use_azuread_auth = true
       snapshot        = true
       
       # State-Locking Optimierung
       use_microsoft_graph = true
     }
   }
   
   # State-Split für große Deployments
   locals {
     # Module-basierte State-Trennung
     state_modules = [
       "networking",
       "security", 
       "compute",
       "citrix_daas"
     ]
   }
   ```

6. **Monitoring und Performance-Tracking:**
   
   **Performance Metriken:**
   ```hcl
   # Azure Monitor für Performance-Tracking
   resource "azurerm_monitor_diagnostic_setting" "citrix_performance" {
     name               = "${var.project_name}-performance-monitoring"
     target_resource_id = azurerm_virtual_machine_scale_set.citrix_workers.id
     
     log_analytics_workspace_id = var.log_analytics_workspace_id
     
     # Performance-relevante Metriken
     enabled_log {
       category = "Administrative"
     }
     
     metric {
       category = "AllMetrics"
       
       retention_policy {
         enabled = true
         days    = 30
       }
     }
   }
   
   # Custom Performance Dashboard
   resource "azurerm_dashboard" "citrix_performance" {
     name                = "${var.project_name}-performance-dashboard"
     resource_group_name = var.resource_group_name
     location           = var.location
     
     dashboard_properties = jsonencode({
       lenses = {
         "0" = {
           order = 0
           parts = {
             "0" = {
               position = { x = 0, y = 0, rowSpan = 4, colSpan = 6 }
               metadata = {
                 inputs = [{
                   name = "resourceGroup"
                   value = var.resource_group_name
                 }]
                 type = "Extension/HubsExtension/PartType/MonitorChartPart"
               }
             }
           }
         }
       }
     })
   }
   ```

7. **Cost-Optimierung:**
   
   **Resource-Rightsizing:**
   ```hcl
   # Automatische Cost-Optimierung
   locals {
     # Cost-Performance Ratio berechnen
     cost_optimization = {
       # Spot Instances für Non-Critical Workloads
       use_spot_instances = var.environment != "prod"
       spot_max_price    = var.environment != "prod" ? 0.5 : null
       
       # Reserved Instances für Production
       reserved_capacity = var.environment == "prod" ? var.base_machine_count : 0
       
       # Auto-Shutdown außerhalb Geschäftszeiten
       auto_shutdown_enabled = var.environment != "prod"
       shutdown_time        = "19:00"
       startup_time         = "07:00"
     }
   }
   
   # Spot Instance Integration
   resource "azurerm_linux_virtual_machine_scale_set" "citrix_spot_workers" {
     count = local.cost_optimization.use_spot_instances ? 1 : 0
     
     name     = "${var.project_name}-spot-workers"
     sku      = local.vm_sizing[var.workload_type].azure_vm_size
     priority = "Spot"
     
     # Spot-spezifische Konfiguration
     max_bid_price                = local.cost_optimization.spot_max_price
     eviction_policy             = "Deallocate"
     single_placement_group      = false
     
     # Automatische Spot-Instance Replacement
     upgrade_mode = "Automatic"
   }
   ```

## Performance-Optimierung Checkliste:

### **Infrastructure-Level:**
- [ ] VM-Sizing für Workload optimiert
- [ ] Storage Performance (Premium SSD) konfiguriert  
- [ ] Accelerated Networking aktiviert
- [ ] Auto-Scaling Policies implementiert
- [ ] Load Balancing optimiert

### **Citrix DaaS-Level:**
- [ ] Machine Catalog Sizing optimiert
- [ ] Session Sharing aktiviert
- [ ] Power Management konfiguriert
- [ ] Image-Optimierung (Master Images)
- [ ] Policy-Performance optimiert

### **Cost-Performance:**
- [ ] Spot Instances für Dev/Test
- [ ] Reserved Instances für Production
- [ ] Auto-Shutdown außerhalb Geschäftszeiten
- [ ] Resource-Rightsizing implementiert
- [ ] Monitoring und Alerting aktiv

## Performance-Monitoring Commands:

**Performance-Check ausführen:**
```bash
/template-optimize --analyze --environment=[env]
```

**Cost-Optimierung-Report:**
```bash
/template-optimize --cost-analysis --recommendations
```

**Benchmark vor/nach Optimierung:**
```bash
/benchmark --before-optimization
/template-optimize --apply-recommendations
/benchmark --after-optimization --compare
```

## Integration mit Task-Management:

**Performance-Optimierung Projekt:**
```bash
# Optimierungs-Projekt erstellen
/task-create project "template-performance-optimization" --description="Citrix DaaS Template Performance-Optimierung"

# Optimierungs-Phasen als Tasks
/task-create subtask "template-performance-optimization" "infrastructure-performance-analyse" --priority=high
/task-create subtask "template-performance-optimization" "resource-optimierung-implementierung" --priority=high
/task-create subtask "template-performance-optimization" "auto-scaling-konfiguration" --priority=medium
/task-create subtask "template-performance-optimization" "cost-performance-optimierung" --priority=medium
/task-create subtask "template-performance-optimization" "performance-monitoring-setup" --priority=low
```

**Optimierungs-Workflow mit Task-Tracking:**
```bash
# Performance-Analyse starten
/task-update "template-performance-optimization/infrastructure-performance-analyse" --status=in_progress
/template-optimize --analyze --environment=dev
/task-log "template-performance-optimization/infrastructure-performance-analyse" "Performance-Baseline ermittelt"
/task-update "template-performance-optimization/infrastructure-performance-analyse" --status=completed

# Optimierungen implementieren
/task-update "template-performance-optimization/resource-optimierung-implementierung" --status=in_progress
/template-optimize --apply-recommendations
/task-update "template-performance-optimization/resource-optimierung-implementierung" --status=completed

# Performance-Vergleich
/benchmark --after-optimization --compare
/task-log "template-performance-optimization" "Performance-Verbesserung: [X%] CPU, [Y%] Memory, [Z%] Cost"

# Progress verfolgen
/task-list --project=template-performance-optimization
```

**Kontinuierliche Performance-Optimierung:**
```bash
# Regelmäßige Performance-Reviews
/task-create project "continuous-performance-optimization" --description="Kontinuierliche Performance-Überwachung"
/task-create subtask "continuous-performance-optimization" "monthly-performance-review" --priority=medium

# Monatlicher Performance-Check
/task-update "continuous-performance-optimization/monthly-performance-review" --status=in_progress
/template-optimize --cost-analysis --recommendations
/template-optimize --performance-report
/task-update "continuous-performance-optimization/monthly-performance-review" --status=completed
```

## Integration mit anderen Commands:

- `/template-validate` - Performance-Konfiguration validieren
- `/multi-cloud-deploy` - Optimierte Deployments
- `/citrix-daas-config` - DaaS-Performance Tuning
- `/monitor` - Performance-Monitoring Setup
- `/task-create` - Performance-Optimierung projektbasiert verwalten
- `/benchmark` - Performance-Messungen mit Task-Dokumentation
Geführte Template-Anpassung für neue Citrix DaaS Projekte:

## Template-Anpassung Workflow

1. **Repository Setup (5 Minuten):**
   - Repository klonen oder als Template verwenden
   - Neue Branch für Projekt erstellen: `git checkout -b project/[projektname]`
   - Projektverzeichnis umbenennen falls erforderlich

2. **Grundkonfiguration anpassen (10 Minuten):**
   
   **Hauptkonfiguration:**
   - `terraform.auto.tfvars.template` → `terraform.auto.tfvars` kopieren
   - Projekt-spezifische Variablen anpassen:
     ```hcl
     # Projekt-Grundeinstellungen
     project_name = "[IHR_PROJEKTNAME]"
     environment = "[dev|test|prod]"
     cost_center = "[KOSTENSTELLE]"
     owner = "[PROJEKT_OWNER]"
     
     # Azure-spezifisch
     subscription_id = "[AZURE_SUBSCRIPTION_ID]"
     resource_group_name = "[RG_NAME]"
     location = "[azure_region]"
     
     # Citrix DaaS
     citrix_cloud_id = "[CITRIX_CLOUD_ID]"
     citrix_resource_location = "[RESOURCE_LOCATION]"
     ```

   **Provider-Authentifizierung:**
   - Azure Service Principal konfigurieren
   - Citrix Cloud Credentials einrichten
   - Terraform Backend anpassen (GitLab/Azure Storage)

3. **Environment-spezifische Anpassung (5 Minuten):**
   
   **Development Environment:**
   ```hcl
   # environments/dev/terraform.auto.tfvars
   environment = "dev"
   instance_count = 1
   vm_size = "Standard_B2s"
   enable_backup = false
   ```
   
   **Production Environment:**
   ```hcl
   # environments/prod/terraform.auto.tfvars  
   environment = "prod"
   instance_count = 3
   vm_size = "Standard_D4s_v3"
   enable_backup = true
   enable_monitoring = true
   ```

4. **Multi-Cloud Provider Setup (10 Minuten):**
   
   **Azure Cloud Setup:**
   - `providers/azure/` Konfiguration anpassen
   - Azure-spezifische Ressourcen konfigurieren
   - Network Security Groups definieren
   
   **On-Premises Setup:**
   - `providers/on-premises/` für VMware vSphere
   - vCenter Verbindungsparameter
   - Netzwerk-Konfiguration anpassen
   
   **Hybrid/Multi-Cloud:**
   - Provider-übergreifende Netzwerk-Konfiguration
   - Cross-Cloud Connectivity Setup

5. **Citrix DaaS spezifische Anpassung:**
   
   **Resource Locations:**
   ```hcl
   # Citrix DaaS Konfiguration
   resource_locations = {
     azure = {
       name = "[AZURE_RESOURCE_LOCATION]"
       hypervisor_type = "AzureRM"
       region = var.location
     }
     on_premises = {
       name = "[ONPREM_RESOURCE_LOCATION]"  
       hypervisor_type = "VMware"
       vcenter_server = "[VCENTER_FQDN]"
     }
   }
   ```
   
   **Machine Catalogs & Delivery Groups:**
   - VM-Templates und Images definieren
   - Delivery Group Konfiguration
   - User-Assignments konfigurieren

6. **Sicherheitskonfiguration:**
   
   **Tagging Strategy anwenden:**
   ```hcl
   common_tags = {
     Environment   = var.environment
     Project       = var.project_name
     CostCenter    = var.cost_center
     Owner         = var.owner
     ManagedBy     = "Terraform"
     CreationDate  = formatdate("YYYY-MM-DD", timestamp())
     Purpose       = "CitrixDaaS"
   }
   ```
   
   **Secret Management:**
   - Azure Key Vault Integration
   - Sensitive Variablen identifizieren
   - Credentials sicher verwalten

7. **Validierung und Test:**
   - `/template-validate` ausführen
   - `terraform plan` für Syntax-Check
   - Pre-commit hooks testen
   - Dokumentation aktualisieren

8. **Erste Deployment-Vorbereitung:**
   - Backend-Konfiguration finalisieren
   - State-Management einrichten  
   - CI/CD Pipeline konfigurieren
   - Rollback-Strategie definieren

## Schnell-Anpassung Checkliste (30 Minuten):

### Phase 1 (0-10 Min): Basis-Setup
- [ ] Repository klonen/template verwenden
- [ ] `terraform.auto.tfvars` aus Template erstellen
- [ ] Projekt-Grundvariablen anpassen

### Phase 2 (10-20 Min): Provider & Environment  
- [ ] Provider-Authentifizierung konfigurieren
- [ ] Environment-spezifische Einstellungen
- [ ] Multi-Cloud Setup (falls erforderlich)

### Phase 3 (20-30 Min): Citrix & Validierung
- [ ] Citrix DaaS spezifische Konfiguration
- [ ] Sicherheits- und Tagging-Einstellungen
- [ ] Template-Validierung ausführen
- [ ] Dokumentation aktualisieren

## Automatisierte Anpassungs-Unterstützung:

**Interactive Setup Script** (geplant):
```bash
# Automatisierte Template-Anpassung
./scripts/customize-template.sh --interactive
```

**Verwendung:** 
- Für neue Citrix DaaS Projekte
- Template-Updates auf bestehende Projekte
- Environment-spezifische Anpassungen
- Multi-Cloud Migration

**Integration mit Task-Management:**
- `/task-create` für Anpassungs-Tracking
- `/template-validate` zur Überprüfung
- `/multi-cloud-deploy` für Deployment
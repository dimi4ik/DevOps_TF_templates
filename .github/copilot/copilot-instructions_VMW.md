# GitHub Copilot Anweisungen für Citrix Resources VMware

## Projektbeschreibung
Dieses Terraform-Projekt automatisiert die Bereitstellung und Verwaltung von Citrix-Ressourcen in einer VMware vSphere-Umgebung. Es verwendet den Citrix Terraform Provider, um Citrix-Komponenten wie Delivery Groups, Machine Catalogs und Hypervisor-Connections zu konfigurieren.

## Rolle und Expertise
- **WICHTIG: Bitte mit mir nur auf deutsch sprechen!!!!!**
- Sie sind Experte für Terraform und Infrastructure as Code (IaC) für Cloud-Plattformen mit Schwerpunkt auf Citrix in VMware-Umgebungen.
- Sie kennen die Besonderheiten der Citrix-Module, die in diesem Projekt verwendet werden.
- Sie verstehen die Beziehungen zwischen vSphere-Hypervisor, Machine Catalogs und Delivery Groups in Citrix.
- Sie helfen bei der effizienten Implementierung von skalierenden VDI-Umgebungen mit Terraform.

## Allgemeine Regeln
- Terraform-Best-Practices befolgen.
- Schreiben Sie prägnanten, gut strukturierten Terraform-Code mit aussagekräftigen Beispielen.
- Organisieren Sie Infrastrukturressourcen in wiederverwendbaren Modulen.
- Verwenden Sie versionierte Module und Provider-Versionssperren, um konsistente Bereitstellungen zu gewährleisten.
- Vermeiden Sie fest codierte Werte; verwenden Sie stets Variablen für mehr Flexibilität.
- Strukturieren Sie Dateien in logische Abschnitte: Hauptkonfiguration, Variablen, Ausgaben und Module.

## Terraform-Best-Practices
- Organisieren Sie Ressourcen nach Dienst- oder Anwendungsdomäne (z. B. Netzwerk, Computing).
- Führen Sie stets „terraform fmt" aus, um eine konsistente Codeformatierung zu gewährleisten.
- Verwenden Sie „terraform validate" und Linting-Tools wie „tflint" oder „terrascan", um Fehler frühzeitig zu erkennen.
- Nach jeder Terraform-Code-Änderung ein `git add .` und `git commit -m "Beschreibung der Änderung"` ausführen.
- Terraform validieren und `terraform plan` ausführen, prüfen ob alles korrekt ist.
- Alle Änderungen in Terraform-Files kurz im README.md in einer neuen Zeile eintragen.

## Modulrichtlinien
- Teilen Sie Code in wiederverwendbare Module auf, um Duplikate zu vermeiden.
- Verwenden Sie Modulausgaben, um Informationen zwischen Konfigurationen zu übertragen.
- Nutzen Sie Versionskontrolle und semantische Versionierung für Stabilität der Module.
- Dokumentieren Sie die Modulnutzung anhand von Beispielen und definieren Sie Ein- und Ausgaben klar.

## Projektstruktur
- `main.tf`: Hauptkonfigurationsdatei für Citrix-Ressourcen
- `provider.tf`: Konfiguration des Citrix Terraform Providers
- `variables.tf`: Definitionen für alle Variablen
- `*.auto.tfvars`: Umgebungsspezifische Variablenwerte
- `archiv/`: Ältere oder alternative Konfigurationsdateien
- `module/`: Terraform-Module
  - `terraform-citrixdaas-dg-ndj/`: Module für Delivery Groups
  - `terraform-citrixdaas-hc-vsphere/`: Module für VMware Hypervisor-Connections
  - `terraform-citrixdaas-mc-ndj/`: Module für Machine Catalogs
  - `terraform-citrixdaas-ps-rendezvous/`: Module für Rendezvous Protocol
- `doks/`: Dokumentation, TODO-Listen und GitHub-Issue-Tracking

## Namenskonventionen
- Ressourcennamen sollten das Format `[TENANT]-[UMGEBUNG]-[TYP]-[ZWECK]-[NUMMER]` verwenden (z.B. `012-T-VDI-PER-BAU-002`)
- Variablennamen sollten mit dem entsprechenden Ressourcentyp beginnen (z.B. `vsphere_*` für vSphere-bezogene Variablen)
- Resource groups: `rg-{project}-{environment}`
- Virtual Networks: `vnet-{project}-{environment}`
- Virtual Machines: `vm-{purpose}-{number}-{environment}`
- Storage Accounts: `st{project}{environment}{uniquestring}`

## Code-Stil
- Verwende 2 Leerzeichen zur Einrückung
- Variablen sind nach Funktionalität gruppiert und mit Kommentaren versehen
- Ressourcennamen sollten aussagekräftig und konsistent mit der bestehenden Struktur sein
==============================================

- Führe stets `terraform fmt` aus, um eine konsistente Codeformatierung zu gewährleisten
- Verwende `terraform validate` und `terraform plan`, um sicherzustellen, dass der Code korrekt ist
- Wenn terraform plan erfolgreich ist, führe git commit mit sinnvollem Text im aktuellen Branch aus und
 - erstelle mir einen Merge-Request im GitLab mit dem Befehl
  `glab mr create --target-branch main --title "TF: {Beschreibung der Änderung}" --description "Detaillierte Beschreibung der durchgeführten Änderungen und deren Zweck"`

- Nach der Erstellung des Merge Requests kannst du ihn mit folgendem Befehl genehmigen (ersetze {MR_NUMMER} mit der tatsächlichen Merge-Request-Nummer):
  `glab mr merge {MR_NUMMER} --yes`

===============================================
- Linting-Tools wie `tflint` oder `terrascan` zur Fehlererkennung
- Strukturiere Dateien in logische Abschnitte: Hauptkonfiguration, Variablen, Ausgaben und Module

## Best Practices
- Verwende immer das `var.`-Präfix für Terraform-Variablen
- Sensitive Daten sollten als sensible Variablen gekennzeichnet werden
- Verwende für VMware-spezifische Ressourcen die entsprechenden Hypervisor-Referenzen
- Behalte die UUIDs für Ressourcen-Imports bei
- Verwende Terraform State Locking für Teamarbeit
- Halte die Module möglichst klein und fokussiert auf eine Aufgabe

## Import-Muster
Wenn du neuen Code generierst, denke daran, Terraform-Import-Anweisungen als Kommentare beizubehalten:
```terraform
# terraform import citrix_resource_type.resource_name resource_uuid
```

## Abhängigkeiten
- Citrix Terraform Provider v1.0.16
- Terraform >=1.2

## Projektspezifische Hinweise
- Achte auf die korrekten UUIDs für Referenzen zwischen Ressourcen
- Machine Catalogs müssen vor Delivery Groups erstellt werden
- VMware vSphere Hypervisor muss vor den Resource Pools definiert werden
- Tenant-spezifische Konfigurationen sind mit entsprechenden Präfixen gekennzeichnet

## Typische Fehler und Lösungen
- **Fehler: "Resource not found"**: Prüfe die UUID und stelle sicher, dass die Ressource in Citrix existiert
- **Fehler: "Invalid reference"**: Überprüfe die Abhängigkeiten zwischen Ressourcen (z.B. Hypervisor vor Resource Pool)
- **Fehler: "Timed out"**: API-Zeitüberschreitung, prüfe die Netzwerkverbindung oder versuche es erneut
- **Fehler: "Authentication failed"**: Überprüfe die Client-ID, Client-Secret und Customer-ID

## Codebeispiele

### VMware Hypervisor Connection
```terraform
module "hypervisor" {
  source = "./module/terraform-citrixdaas-hc-vsphere"

  hypervisor_name        = "012-T-VDI-PER-VSPHERE"
  hypervisor_address     = var.vsphere_server
  hypervisor_username    = var.vsphere_user
  hypervisor_password    = var.vsphere_password
  hypervisor_connection  = "VCenter"
  hypervisor_persistence = "PersistentAndOnDemand"
  zone_name              = "TENANT-001"
}
```

### Machine Catalog
```terraform
module "machine_catalog" {
  source = "./module/terraform-citrixdaas-mc-ndj"

  catalog_name            = "012-T-VDI-PER-BAU-MC"
  catalog_description     = "Machine Catalog für Bauabteilung"
  zone_name               = "TENANT-001"
  allocation_type         = "Random"
  session_support         = "MultiSession"
  provisioning_type       = "MCS"
  hypervisor_connection   = module.hypervisor.connection_name
  resource_pool           = var.vsphere_resource_pool
  persist_user_changes    = "OnLocal"

  depends_on = [module.hypervisor]
}
```

## Sicherheitsaspekte
- Credentials aus .tfvars Dateien sollten nicht im Repository gespeichert werden
- SSL Zertifikate und Thumbprints müssen validiert werden
- Netzwerk-Zugriffe sollten eingeschränkt werden
- Verwende Vault oder ein Key Management System für sensible Daten

## Erforderliche Variablen
- `client_id`: Die Citrix Cloud Client-ID
- `client_secret`: Das Citrix Cloud Client-Secret
- `customer_id`: Die Citrix Cloud Customer-ID
- `vsphere_server`: Der VMware vSphere Server
- `vsphere_user`: Der VMware vSphere Benutzername
- `vsphere_password`: Das VMware vSphere Passwort
- `vsphere_datacenter`: Das VMware vSphere Datacenter
- `vsphere_resource_pool`: Der VMware vSphere Resource Pool
- Weitere vSphere-spezifische Variablen (siehe variables.tf)

## Empfohlene Verbesserungen
- Hypervisor-Konfigurationen in eigene Module auslagern
- Resource Pools gruppieren und standardisieren
- Outputs für wichtige Ressourcen-IDs definieren
- Resource Tags für bessere Verwaltung hinzufügen
- Terraform Remote State mit Backend-Konfiguration für Teamarbeit

## Automatisierung und CI/CD
- Nutze GitHub Actions für automatisierte Validierung und Planung
- Implementiere eine Pipeline für das Testen von Terraform-Modulen
- Erstelle separate Workspaces für unterschiedliche Umgebungen
- Verwende Terraform Cloud oder eine ähnliche Plattform für zentrales State-Management

## Tests
Um zu testen, ob diese Anweisungen funktionieren:
- Stellen Sie sicher, dass Sie alle Voraussetzungen erfüllt haben
- Folgen Sie den Anweisungen Schritt für Schritt
- Überprüfen Sie die Bereitstellung in der Citrix- und VMware-Konsole
- Führen Sie `terraform destroy` aus, um Testressourcen zu entfernen

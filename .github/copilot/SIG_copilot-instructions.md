## **WICHTIG: Bitte mit mir nur auf deutsch sprechen!!!!!**

## Projektbeschreibung
Dieses Terraform-Projekt automatisiert die Erstellung und Verwaltung einer Azure Shared Image Gallery (SIG)
für Windows-Betriebssysteme. Es stellt eine zentrale Verwaltung von verschiedenen VM-Images bereit,
die für Cloud-Deployments verwendet werden können.
Die Shared Image Gallery fungiert als Repository für verwaltete Images und ermöglicht das Teilen,
Versionieren und Replizieren von VM-Images über Azure-Regionen hinweg.

## Projektstruktur
```
galery_create/
├── README.md               # Hauptdokumentation und Projektübersicht
├── todo.md                 # Liste der Verbesserungsvorschläge
└── terraform/              # Terraform-Konfigurationsdateien
    ├── TECHNICAL.md        # Technische Dokumentation
    ├── customer.auto.tfvars # Kundenbezogene Variablenwerte
    ├── locals.tf           # Lokale Variablen und Berechnungen
    ├── main.tf             # Hauptkonfigurationsdatei mit Ressourcen
    ├── outputs.tf          # Output-Definitionen
    ├── sklad.auto.tfvars   # Zusätzliche Variablenwerte
    ├── variables.tf        # Variablendefinitionen
    └── versions.tf         # Terraform- und Provider-Versionen
```

## Namenskonventionen
- Resource Groups: `rg-mvd-m{mandant_prefix}-{region}-{instance}`
- Image Gallery: `gal_mvd_{env}_{region}_{instance}`
- VM-Image-Definitionen folgen der Konvention `[env]_[os-typ]_[version]_[edition]_[role]_[state]_[sequence]`
  - env: Umgebungspräfix (sta für Staging, prd für Produktion)
  - os-typ: svr (Server) oder win (Windows)
  - version: Betriebssystemversion (19, 22 für Server oder 11 für Windows)
  - edition: Betriebssystemedition (23h2, std)
  - role: cor (Server Core) oder ctx (Citrix Worker) oder avd (Azure Virtual Desktop)
  - state: gen (generalisiert) oder spe (spezialisiert)
  - sequence: Sequenznummer der Definition (z.B. 001)

## Best Practices für Azure Shared Image Gallery
- Unterscheide klar zwischen spezialisierten und generalisierten Images
- Verwende Trusted Launch für verbesserte Sicherheit bei VMs
- Gruppiere zusammengehörige Images in einer gemeinsamen Gallery
- Definiere aussagekräftige Beschreibungen für alle Images
- Verwalte Image-Definitionen zentral in der customer.auto.tfvars-Datei
- Verwende Tags für zusätzliche Metadaten (PatchLevel, Creator, Department)



## Rolle und Expertise
- Sie sind ein Experte für Terraform, Packer, Ansible und Infrastructure as Code (IaC) mit Schwerpunkt auf Citrix, VMware, Azure-Cloud-Ressourcen und Gitlab.
- Sie haben Erfahrung mit der Implementierung robuster Tagging-Strategien und standardisierter Namenskonventionen.


## Allgemeine Regeln / Key Principles (Grundprinzipien)
- Terraform-Best-Practices befolgen.
- Schreiben Sie prägnanten, gut strukturierten Terraform-Code mit aussagekräftigen Kommentaren.
- Organisieren Sie Infrastrukturressourcen in logischen Einheiten und nutzen Sie wiederverwendbare Module.
- Verwenden Sie flexible Provider-Versionierungen mit `~>` Syntax für Patch-Updates.
- Verwenden Sie versionierte Module und Provider-Versionssperren, um konsistente Bereitstellungen zu gewährleisten.
- Vermeiden Sie hartcodierte Werte; verwenden Sie stets Variablen für mehr Flexibilität.
- Nutzen Sie Outputs für bessere Integration mit anderen Modulen.
- Vermeiden Sie fest codierte Werte; verwenden Sie stets Variablen für mehr Flexibilität.
- Strukturieren Sie Dateien in logische Abschnitte: Hauptkonfiguration, Variablen, Ausgaben und Module.
- Verwenden Sie Tagging für alle Ressourcen, um eine ordnungsgemäße Nachverfolgung und ein optimales Kostenmanagement zu gewährleisten.
- Stellen Sie sicher, dass Ressourcen modular und wiederverwendbar definiert sind, um die Skalierung zu vereinfachen.


## Versionsmanagement
- Verwende semantische Versionierung für Git-Tags (z.B. v1.0.0)
- Dokumentiere jede Änderung in der Änderungshistorie
- Erstelle neue Tags für bedeutende Änderungen oder Releases
- Nutze aussagekräftige Commit-Nachrichten nach dem Schema `typ: beschreibung`
  - feat: Neue Funktionalität
  - fix: Fehlerbehebung
  - docs: Dokumentationsänderungen
  - style: Formatierungsänderungen
  - refactor: Code-Umstrukturierung ohne Funktionsänderung
  - test: Testcodeänderungen
  - chore: Änderungen an Build-Prozessen oder Tools



## Code-Stil
- Verwende 2 Leerzeichen zur Einrückung
- Variablen sind nach Funktionalität gruppiert und mit Kommentaren versehen
- Ressourcennamen sollten aussagekräftig und konsistent sein
- Verwende snake_case für Ressourcennamen in Terraform
- Strukturiere Dateien in logische Abschnitte mit klaren Kommentaren


## Dokumentation
- Wenn du neuen Code generierst, denke daran, Terraform-Import-Anweisungen als Kommentare beizubehalten:
- haben Sie den Code generiert, fügen Sie Kommentare hinzu, um die Funktionsweise zu erklären.
- Dokumentiere alle Module und Variablen in der README.md
- Dokumentieren Sie alle Änderungen in der README.md Änderungshistorie.


## Terraform-Best-Practices
- Verwenden Sie Remote-Backends (gitlab) für die Statusverwaltung.
- Nutzen Sie Arbeitsbereiche zur Trennung von Umgebungen (z. B. Entwicklung, Staging, Produktion).
- Organisieren Sie Ressourcen nach Dienst- oder Anwendungsdomäne (z. B. Netzwerk, Computing).
- Führen Sie stets „terraform fmt“ aus, um eine konsistente Codeformatierung zu gewährleisten.
- Verwenden Sie „terraform validate“ und Linting-Tools wie „tflint“ oder „terrascan“, um Fehler frühzeitig zu erkennen.

https://www.terraform-best-practices.com/code-structure
https://www.terraform-best-practices.com/naming
https://www.terraform-best-practices.com/code-styling


## Security Practices (Sicherheitspraktiken)
- Vermeiden Sie die Festcodierung sensibler Werte (z. B. Passwörter, API-Schlüssel); verwenden Sie stattdessen Vault- oder Umgebungsvariablen.
- Stellen Sie die Verschlüsselung von Speicher und Kommunikation sicher (z. B. aktivieren Sie die Verschlüsselung für S3-Buckets, Azure Storage).
- Definieren Sie Zugriffskontrollen und Sicherheitsgruppen für jede Cloud-Ressource.
- Befolgen Sie die Sicherheitsrichtlinien der jeweiligen Cloud-Anbieter (z. B. AWS, Azure, GCP) für Best Practices.
- Azure-Authentifizierungsdaten sollten nicht im Code gespeichert werden
- Verwende sensitive Variablen für Geheimnisse
- Implementiere Trusted Launch für VM-Images
- Verwende berechtigungsbasierte Zugriffskontrolle
- Aktiviere Verschlüsselung für sensible Daten
- Backend-Konfiguration sollte verschlüsselt und sicher sein



## Error Handling and Validation (Fehlerbehandlung und -validierung)
- Verwenden Sie Validierungsregeln für Variablen, um falsche Eingabewerte zu vermeiden.
- Behandeln Sie Sonderfälle und optionale Konfigurationen mit bedingten Ausdrücken und Nullprüfungen.
- Verwenden Sie das Schlüsselwort „depends_on“, um explizite Abhängigkeiten bei Bedarf zu verwalten.



## Modulrichtlinien
- Verwenden Sie Terraform-Module für bessere Wiederverwendbarkeit und Wartbarkeit.
- Definieren Sie klare Input- und Output-Variablen für Module.
- Verwenden Sie semantische Versionierung für Module.
- Dokumentieren Sie die Modulverwendung mit Beispielen.
- Achten Sie auf minimale Abhängigkeiten zwischen Modulen.
- Teilen Sie Code in wiederverwendbare Module auf, um Duplikate zu vermeiden.
- Verwenden Sie Modulausgaben, um Informationen zwischen Konfigurationen zu übertragen.
- Versionskontrollmodule und semantische Versionierung für Stabilität.
- Dokumentieren Sie die Modulnutzung anhand von Beispielen und definieren Sie Ein- und Ausgaben klar.


## Performance Optimization (Leistungsoptimierung)
- Nutzen Sie die Ressourcenausrichtung („-target“), um ressourcenspezifische Änderungen zu beschleunigen.
- Cachen Sie Terraform-Anbieter-Plugins lokal, um die Downloadzeit während Planungs- und Anwendungsvorgängen zu reduzieren.
- Beschränken Sie die Verwendung von „count“ oder „for_each“, wenn dies nicht erforderlich ist, um unnötige Ressourcenduplizierung zu vermeiden.


## Testing and CI/CD Integration (Tests und CI/CD-Integration)
- Integrieren Sie Terraform in CI/CD-Pipelines (z. B. GitHub Actions, GitLab CI), um Tests, Planung und Bereitstellung zu automatisieren.
- Führen Sie „terraform plan“ in CI-Pipelines aus, um Probleme zu erkennen, bevor Infrastrukturänderungen angewendet werden.
- Verwenden Sie Tools wie „terratest“, um Unit-Tests für Terraform-Module zu schreiben.
- Richten Sie automatisierte Tests für kritische Infrastrukturpfade ein (z. B. Netzwerkkonnektivität, IAM-Richtlinien).

## Tagging-Strategie
- Standardisierte Tags für alle Ressourcen:
  - Environment: Umgebung (dev, test, prod, etc.)
  - Project: Projektname
  - CostCenter: Kostenstelle
  - Owner: Verantwortliches Team oder Person
  - ManagedBy: "Terraform"
  - CreationDate: Erstellungsdatum im Format YYYY-MM-DD
  - Purpose: Zweck der Ressource




## Terraform-Outputs
- Definiere aussagekräftige Outputs für bessere Modularität
- Gruppiere Outputs nach Ressourcentypen
- Verwende strukturierte Daten für komplexe Ausgaben
- Dokumentiere jeden Output mit einer klaren Beschreibung

## Terraform-Variablen
- Gruppiere zusammengehörige Variablen
- Verwende sinnvolle Standardwerte wo möglich
- Dokumentiere jede Variable
- Implementiere Validierungen für kritische Variablen
- Kennzeichne sensible Daten mit `sensitive = true`

## Import-Muster
```terraform
# terraform import azurerm_resource_type.resource_name resource_id
```

## Abhängigkeiten
- Terraform Version >=1.2
- Azure Provider ~> 4.5.0
- GitLab Provider ~> 17.3.0

## Beispiele

### Erstellen einer Resource Group
```terraform
module "azuererm_rg" {
  source                  = "gitlab.abraxas-tools.ch/sit/terraform-azurerm-rg-mvd-v2/azurerg"
  version                 = "0.0.7"
  resource_group_location = var.resource_group_location
  resource_group_name     = local.resource_group_name_value
  common_tags             = local.standard_tags
}
```

### Erstellen einer Shared Image Gallery
```terraform
resource "azurerm_shared_image_gallery" "windows" {
  name                = var.image_gallery_name
  resource_group_name = local.resource_group_name
  location            = var.resource_group_location
  description         = "Shared Image Gallery for Windows images"
  tags                = local.standard_tags
}
```

### Erstellen einer Image Definition
```terraform
resource "azurerm_shared_image" "windows_server" {
  name                = var.image_name
  description         = "Windows Server Image with Trusted Launch enabled"
  gallery_name        = azurerm_shared_image_gallery.windows.name
  resource_group_name = local.resource_group_name
  location            = var.resource_group_location
  os_type             = "Windows"
  specialized         = false
  hyper_v_generation  = "V2"
  trusted_launch_enabled = true
  tags                = local.standard_tags

  identifier {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2-generalized"
  }
}
```

## Sicherheitsaspekte

## Empfohlene Verbesserungen
- DRY-Prinzip anwenden für Image-Definitionen
- Variablen-Validierung implementieren
- Modulbasierte Struktur einführen
- Erweiterte Backends für Terraform-State nutzen
- Output-Definitionen weiter standardisieren und erweitern
- Automatisierte Tests implementieren

## Automatisierung und CI/CD
- Nutze Pre-commit-Hooks für Codeformatierung und Validierung
- Implementiere GitLab CI/CD-Pipelines für automatisierte Tests und Deployments
- Verwende terraform-docs zur automatischen Dokumentationsgenerierung
- Setze Checkov oder tfsec für Sicherheitsüberprüfungen ein

## Terraform-Befehle
```bash
# Initialisierung des Projektes
cd terraform
terraform init

# Überprüfung der Änderungen
terraform plan

# Anwendung der Konfiguration
terraform apply

# Formatierung des Codes
terraform fmt

# Validierung des Codes
terraform validate
```

## Git-Befehle
```bash
# Änderungen hinzufügen
git add .

# Commit erstellen
git commit -m "feat: Beschreibung der Änderung"

# Tag erstellen
git tag -a v1.0.0 -m "Version 1.0.0 - Vollständig dokumentierte und optimierte Implementation"

# Tag zum Remote-Repository pushen
git push origin v1.0.0
```

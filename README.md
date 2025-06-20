# Azure VM mit Terraform

![Terraform](https://img.shields.io/badge/Terraform-1.0+-7B42BC?style=for-the-badge&logo=terraform)
![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

Dieses Terraform-Projekt ermöglicht die Erstellung und Verwaltung einer virtuellen Maschine in Azure mit entsprechenden Netzwerkkomponenten nach Best Practices.

## Projektbeschreibung

Das Projekt stellt eine Linux-VM in Azure bereit, inklusive aller notwendigen Netzwerkkomponenten:

- Ressourcengruppe
- Virtuelles Netzwerk
- Subnetz
- Öffentliche IP-Adresse
- Netzwerksicherheitsgruppe
- Netzwerkschnittstelle

Die VM wird mit Ubuntu 18.04 LTS erstellt und ist über SSH erreichbar. Die Konfiguration folgt Azure und Terraform Best Practices.

## Projektstruktur

```
terraform/
├── main.tf               # Hauptkonfigurationsdatei
├── variables.tf          # Eingabevariablen
├── outputs.tf            # Ausgabewerte
├── terraform.tfvars      # Variablenwerte
├── README.md             # Projektdokumentation
├── .terraform-docs.yml   # Konfiguration für terraform-docs
├── generate-docs.sh      # Skript für die Dokumentationsgenerierung
└── examples/             # Beispiele und verbesserte Versionen
    ├── main_improved.tf  # Verbesserte Version mit Modulen
    ├── modules/          # Modulbeispiele
    │   └── network/      # Beispiel für Netzwerkmodul
    └── README.md         # Beispieldokumentation
```

## Voraussetzungen

- [Terraform](https://www.terraform.io/downloads.html) (Version >= 1.0.0)
- [Azure CLI](https://docs.microsoft.com/de-de/cli/azure/install-azure-cli) (für die Authentifizierung)
- Azure-Subscription
- SSH-Schlüsselpaar (für den Zugriff auf die VM)

## Verwendung

### Authentifizierung bei Azure

Bevor Sie Terraform ausführen, müssen Sie sich bei Azure authentifizieren:

```bash
az login
```

### Terraform-Befehle

1. Navigieren Sie in das Terraform-Verzeichnis:

   ```bash
   cd terraform
   ```

2. Initialisierung des Projekts:

   ```bash
   terraform init
   ```

3. Überprüfen des Plans:

   ```bash
   terraform plan -out=tfplan
   ```

4. Anwenden des Plans:

   ```bash
   terraform apply tfplan
   ```

5. Löschen der Ressourcen:

   ```bash
   terraform destroy
   ```

### Anpassung der Konfiguration

Die Konfiguration kann über die Datei `terraform.tfvars` angepasst werden:

```terraform
prefix              = "azure-vm"
location            = "westeurope"
resource_group_name = "terraform-vm-rg"
vm_size             = "Standard_B1s"
computer_name       = "linuxvm"
admin_username      = "azureuser"
ssh_public_key_path = "~/.ssh/id_rsa.pub"
```

## Variablen

| Name | Beschreibung | Typ | Standard |
|------|-------------|------|---------|
| `prefix` | Präfix für alle Ressourcennamen | string | "azure-vm" |
| `location` | Azure Region für die Ressourcen | string | "westeurope" |
| `resource_group_name` | Name der Ressourcengruppe | string | "terraform-vm-rg" |
| `vm_size` | Größe der virtuellen Maschine | string | "Standard_B1s" |
| `computer_name` | Name des Computers in der VM | string | "linuxvm" |
| `admin_username` | Benutzername für den Admin-Zugang | string | "azureuser" |
| `ssh_public_key_path` | Pfad zum öffentlichen SSH-Schlüssel | string | "~/.ssh/id_rsa.pub" |

## Outputs

| Name | Beschreibung |
|------|-------------|
| `resource_group_name` | Name der erstellten Ressourcengruppe |
| `public_ip_address` | Öffentliche IP-Adresse der VM |
| `vm_name` | Name der erstellten VM |
| `ssh_command` | SSH-Befehl für den Zugriff auf die VM |

## Automatische Dokumentationsgenerierung

Dieses Projekt verwendet [terraform-docs](https://github.com/terraform-docs/terraform-docs) zur automatischen Dokumentationsgenerierung:

```bash
cd terraform
./generate-docs.sh
```

## Features und Roadmap

### Aktuelle Features
- Grundlegende VM-Bereitstellung
- SSH-Zugriff
- Netzwerksicherheitsgruppen

### Geplante Features
- Modulare Architektur
- Mehrere Umgebungen (dev, test, prod)
- Verbesserte Sicherheit
- Automatisierte Tests
- CI/CD-Integration mit GitLab

## Tagging-Strategie

Standardisierte Tags für alle Ressourcen (wird in zukünftigen Versionen implementiert):

- Environment: Umgebung (dev, test, prod)
- Project: Projektname
- CostCenter: Kostenstelle
- Owner: Verantwortliches Team oder Person
- ManagedBy: "Terraform"
- CreationDate: Erstellungsdatum im Format YYYY-MM-DD
- Purpose: Zweck der Ressource

## Versionsverlauf

| Version | Datum       | Änderungen |
|---------|-------------|------------|
| v1.0.0  | 09.05.2025  | Initiale Version |

Für detaillierte Informationen siehe [CHANGELOG.md](./CHANGELOG.md) und die [Versionsstrategie](./terraform/docs/VERSION_STRATEGY.md).

## Autor

Terraform-Team
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
TERRAFORM.md updated successfully
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

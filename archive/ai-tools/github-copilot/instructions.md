# Copilot-Anweisungen

## **WICHTIG: Bitte mit mir nur auf deutsch sprechen!!!!!**
## **Dokumentiere jede Änderung in der Änderungshistorie README.md!!!!!**

## Vorgehen bei jeder Anfrage
1. Lies **immer zuerst** alle Anweisungen in dieser Datei vollständig durch
2. Beachte besonders die Punkte zu "Variablen und Parameter" und "Codequalität und -stil"
3. Vermeide hartcodierte Werte in der gesamten Konfiguration
4. Dokumentiere alle Änderungen in der CHANGELOG.md

## Rolle und Expertise
- Du bist ein Experte für Terraform, Packer, Ansible und Infrastructure as Code (IaC) mit Schwerpunkt auf Citrix, VMware, Azure-Cloud-Ressourcen und GitLab.
- Du hast Erfahrung mit der Implementierung robuster Tagging-Strategien und standardisierter Namenskonventionen.

## Terraform-Best-Practices

### Architektur und Organisation
- Verwende Remote-Backends (GitLab) für die Statusverwaltung.
- Nutze Arbeitsbereiche zur Trennung von Umgebungen (z.B. Entwicklung, Staging, Produktion).
- Organisiere Ressourcen nach Dienst- oder Anwendungsdomäne (z.B. Netzwerk, Computing).
- Strukturiere Dateien in logische Abschnitte:
  ```
  ├── main.tf          # Hauptressourcen und Modulaufrufe
  ├── variables.tf     # Eingabevariablen
  ├── outputs.tf       # Ausgaben
  ├── providers.tf     # Providerkonfiguration
  ├── versions.tf      # Terraform- und Providerversionen
  └── locals.tf        # Lokale Variablen und Berechnungen
  ```
- DRY-Prinzip anwenden (Don't Repeat Yourself).

### Codequalität und -stil
- Führe stets `terraform fmt` aus, um eine konsistente Codeformatierung zu gewährleisten.
- Verwende `terraform validate` und Linting-Tools wie `tflint` oder `terrascan`, um Fehler frühzeitig zu erkennen.
- Befolge offizielle Terraform-Best-Practices:
    - [Codestruktur](https://www.terraform-best-practices.com/code-structure)
    - [Namenskonventionen](https://www.terraform-best-practices.com/naming)
    - [Codestil](https://www.terraform-best-practices.com/code-styling)
- Verwende 2 Leerzeichen zur Einrückung.
- Schreibe prägnanten, gut strukturierten Terraform-Code mit aussagekräftigen Kommentaren.

### Versionen und Abhängigkeiten
- Verwende flexible Provider-Versionierungen mit `~>` Syntax für Patch-Updates.
- Verwende versionierte Module mit konkreten Versionen für stabile Bereitstellungen.

### Variablen und Parameter
- Vermeide hartcodierte Werte; verwende stets Variablen für mehr Flexibilität.
- Gruppiere zusammengehörige Variablen mit beschreibenden Kommentaren.
- Implementiere Validierungen für kritische Variablen.
- Kennzeichne sensible Daten mit `sensitive = true`.
- Nutze moderne Terraform-Features wie den Null-Coalescing-Operator.

### Namenskonventionen
- Verwende snake_case für Ressourcennamen in Terraform.
- Benenne Ressourcen, Variablen und Outputs aussagekräftig und konsistent nach dem Schema <projekt>-<umgebung>-<ressourcentyp>-<optional:zweck>.

### Module und Wiederverwendbarkeit
- Teile Code in wiederverwendbare Module auf, um Duplikate zu vermeiden.
- Definiere klare Input- und Output-Variablen für Module.
- Dokumentiere die Modulnutzung anhand von Beispielen.
- Achte auf minimale Abhängigkeiten zwischen Modulen.
- Verwende Modulausgaben, um Informationen zwischen Konfigurationen zu übertragen.

### Outputs
- Definiere aussagekräftige Outputs für bessere Modularität.
- Gruppiere Outputs nach Ressourcentypen.
- Verwende strukturierte Daten für komplexe Ausgaben.

## Versionsmanagement
- Verwende semantische Versionierung für Git-Tags (z.B. v1.0.0).
- Erstelle neue Tags für bedeutende Änderungen oder Releases.
- Nutze aussagekräftige Commit-Nachrichten nach dem Schema `typ: beschreibung`.
- Überprüfe die Code-Qualität vor jedem Commit.

## Dokumentation
- Füge beim Generieren von Code Terraform-Import-Anweisungen als Kommentare hinzu.
- Dokumentiere alle Module und Variablen in der README.md.
- Dokumentiere alle Änderungen in der README.md Änderungshistorie.
- Füge Codekommentare für komplexe Logik hinzu.

## Security Practices (Sicherheitspraktiken)
- Vermeide die Festcodierung sensibler Werte; verwende stattdessen HashiCorp Vault oder Azure Key Vault.
- Stelle die Verschlüsselung von Speicher und Kommunikation sicher.
- Definiere Zugriffskontrollen und Sicherheitsgruppen für jede Cloud-Ressource.
- Speichere Azure-Authentifizierungsdaten nicht im Code.
- Nutze Checkov und TFLint für Security- und Best-Practice-Prüfungen. Kommentiere bewusste Ausnahmen.

## Error Handling und Validierung
- Verwende Validierungsregeln für Variablen, um falsche Eingabewerte zu vermeiden.
- Behandle optionale Konfigurationen mit bedingten Ausdrücken.
- Nutze das `depends_on`-Attribut nur wenn nötig, um explizite Abhängigkeiten zu deklarieren.
- Verwende den `precondition`-Block für komplexe Validierungen.

## Performance-Optimierung
- Nutze die Ressourcenausrichtung (`-target`), um ressourcenspezifische Änderungen zu beschleunigen.
- Cache Terraform-Anbieter-Plugins lokal, um die Downloadzeit zu reduzieren.
- Beschränke die Verwendung von `count` oder `for_each` auf notwendige Fälle.
- Verwende `for_each` anstelle von `count` für bessere Beständigkeit.

## Testing und CI/CD-Integration
- Integriere Terraform in CI/CD-Pipelines (GitLab CI), um Tests, Planung und Bereitstellung zu automatisieren.
- Nutze pre-commit Hooks für Codeformatierung und Validierung.
- Verwende `terratest` für Unit-Tests von Terraform-Modulen.
- Richte automatisierte Tests für kritische Infrastrukturpfade ein.

## Tagging-Strategie
- Standardisierte Tags für alle Ressourcen.
- Empfohlene Tag-Struktur:
  - `Environment`: Umgebung (dev, test, prod, etc.)
  - `Project`: Projektname
  - `CostCenter`: Kostenstelle
  - `Owner`: Verantwortliches Team oder Person
  - `ManagedBy`: "Terraform"
  - `CreationDate`: Erstellungsdatum
  - `Purpose`: Zweck der Ressource

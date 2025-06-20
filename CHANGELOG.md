# Changelog

Alle wichtigen Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und dieses Projekt folgt [Semantischer Versionierung](https://semver.org/lang/de/).

## [Unreleased]

### Geplant
- Modulare Struktur für bessere Wiederverwendbarkeit
- Tagging für alle Ressourcen
- Verbesserte Sicherheitskonfigurationen

## [1.0.0] - 2025-05-09

### Hinzugefügt
- Initiale Terraform-Konfiguration für Azure VM-Erstellung
- Grundlegende Netzwerkkonfiguration (VNet, Subnetz, NSG)
- SSH-Zugriff für VM
- README.md mit ausführlicher Dokumentation
- Terraform-Variablen und Outputs
- terraform-docs Integration für automatische Dokumentationsgenerierung

### Geändert
- Keine Änderungen (erste Version)

### Entfernt
- Keine Entfernungen (erste Version)

### Sicherheit
- Grundlegende Netzwerksicherheitsgruppen-Regeln für SSH-Zugriff

## Versionierungsrichtlinien

Dieses Projekt verwendet [Semantische Versionierung](https://semver.org/lang/de/):

- **MAJOR-Version** (x.0.0): Inkompatible API-Änderungen
- **MINOR-Version** (0.x.0): Funktionalität wird rückwärtskompatibel hinzugefügt
- **PATCH-Version** (0.0.x): Rückwärtskompatible Bugfixes

### Commit-Nachrichtenrichtlinien

Commit-Nachrichten sollten dem folgenden Schema folgen:
- `feat:` - Neue Funktionalität
- `fix:` - Fehlerbehebung
- `docs:` - Dokumentationsänderungen
- `style:` - Formatierungsänderungen
- `refactor:` - Code-Umstrukturierung ohne Funktionsänderung
- `test:` - Testcodeänderungen
- `chore:` - Änderungen an Build-Prozessen oder Tools

## Release-Prozess

1. CHANGELOG.md aktualisieren
2. Version in relevanten Dateien erhöhen
3. Git-Tag im Format v1.0.0 erstellen
4. Änderungen auf main-Branch zusammenführen
5. Release in GitLab erstellen

[Unreleased]: https://gitlab.com/example/terraform-azure-vm/compare/v1.0.0...HEAD
[1.0.0]: https://gitlab.com/example/terraform-azure-vm/releases/tag/v1.0.0

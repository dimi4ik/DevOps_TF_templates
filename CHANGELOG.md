# Changelog

## [3.0.0] - 2025-01-13

### BREAKING CHANGES
- Provider-agnostisch: Alle hardcodierten Provider-Verweise entfernt
- Struktur: `templates/terraform/` → `terraform/` (produktiv-kompatibel)
- Keine `.template` Dateien mehr

### Hinzugefügt
- `terraform/` Struktur mit 6 Haupt-Dateien (provider-agnostisch)
- Provider-Beispiele: VMware vSphere, Azure
- GitLab CI/CD Pipeline (produktiv-getestet)
- 3-Minuten Setup für beliebige Cloud-Provider

### Entfernt
- `templates/` Ordner
- Provider-Lock-in

## [1.0.0] - 2025-06-22

### Hinzugefügt
- AI-Tool Integration (Claude Code, GitHub Copilot)
- Template-Dokumentation
- Pre-Commit Hooks für Terraform

### Geändert
- Repository-Fokus: Azure VM → DevOps Template
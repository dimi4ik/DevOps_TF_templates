Umfassende Validierung der Template-Struktur für Citrix DaaS Projekte:

## Template-Struktur Validierung

1. **Verzeichnisstruktur prüfen:**
   - Hauptverzeichnisse: `terraform/`, `ansible/`, `scripts/`, `docs/`
   - Provider-spezifische Struktur (falls vorhanden)
   - Environment-Verzeichnisse (dev/test/prod)
   - Modul-Struktur überprüfen

2. **Terraform Template Validierung:**
   - `terraform fmt -recursive` - Code-Formatierung prüfen
   - `terraform validate` - Syntax-Validierung aller .tf Dateien
   - Variable-Definitionen in `variables.tf` prüfen
   - Output-Definitionen in `outputs.tf` validieren
   - Provider-Konfiguration in `providers.tf` überprüfen
   - Version-Constraints in `versions.tf` validieren

3. **Template-Dateien Validierung:**
   - `terraform.auto.tfvars.template` - Platzhalter-Syntax prüfen
   - Environment-spezifische Template-Dateien validieren
   - Variable-Platzhalter auf Vollständigkeit prüfen
   - Sensitive-Variablen korrekt markiert überprüfen

4. **Konfigurationstemplates prüfen:**
   - Tagging-Strategie Implementation validieren:
     ```hcl
     common_tags = {
       Environment   = var.environment
       Project       = var.project_name
       CostCenter    = var.cost_center
       Owner         = var.owner
       ManagedBy     = "Terraform"
       CreationDate  = formatdate("YYYY-MM-DD", timestamp())
       Purpose       = var.resource_purpose
     }
     ```
   - Provider-Authentifizierung Templates überprüfen
   - Multi-Cloud Unterstützung validieren

5. **Dokumentation Validierung:**
   - README.md Vollständigkeit prüfen
   - Template-Anpassungsanleitung validieren
   - Deployment-Guides auf Korrektheit überprüfen
   - Link-Integrität in Dokumentation testen

6. **Pre-commit Hook Validierung:**
   - `.pre-commit-config.yaml` auf Template-spezifische Regeln prüfen
   - tflint, trivy, checkov Konfiguration validieren
   - Hook-Funktionalität testen

7. **AI-Tool Integration prüfen:**
   - `.claude/commands/` Vollständigkeit validieren
   - Claude-Berechtigungen in `settings.local.json` überprüfen
   - Task-Management Integration testen

8. **Citrix DaaS spezifische Validierung:**
   - Citrix-Provider Konfiguration (falls vorhanden)
   - DaaS-spezifische Variablen und Module überprüfen
   - Azure/On-Premises Integration validieren

9. **Sicherheits-Validierung:**
   - Keine hardcoded Secrets in Templates
   - Sensitive-Variablen korrekt behandelt
   - Provider-Authentifizierung sicher konfiguriert
   - trivy/checkov Sicherheits-Scans erfolgreich

10. **Template-Anpassbarkeit testen:**
    - Template in <30 Minuten anpassbar validieren
    - Platzhalter-Ersetzung funktional prüfen
    - Environment-spezifische Anpassung testen
    - Multi-Cloud Provider Wechsel validieren

## Validierungs-Report generieren:

```markdown
# Template Validierung Report

Generiert: [timestamp]
Template: Citrix DaaS DevOps Template
Branch: [current-branch]

## Struktur-Status

- Verzeichnisstruktur: ✓/✗
- Terraform-Validierung: ✓/✗  
- Template-Dateien: ✓/✗
- Dokumentation: ✓/✗

## Probleme nach Priorität

### Kritisch (Muss behoben werden)
- [Problem mit Datei:Zeile]

### Warnungen (Sollte behoben werden)  
- [Problem mit Datei:Zeile]

### Info (Überlegung wert)
- [Problem mit Datei:Zeile]

## Template-Anpassbarkeit
- Anpassungszeit: [geschätzte Minuten]
- Platzhalter-Vollständigkeit: ✓/✗
- Multi-Cloud Support: ✓/✗

## Empfehlungen
- [Spezifische Maßnahmen]
```

Report speichern unter: `/tmp/template-validation-report-[timestamp].md`

## Integration mit Task-Management:

**Template-Validierung in Projekten:**
```bash
# Validierung als Task-Schritt integrieren
/task-create subtask "[projekt-name]" "template-struktur-validierung" --priority=high
/task-update "[projekt-name]/template-struktur-validierung" --status=in_progress

# Template-Validierung ausführen
/template-validate

# Ergebnis dokumentieren
/task-log "[projekt-name]/template-struktur-validierung" "Template-Validierung erfolgreich - alle Checks bestanden"
/task-update "[projekt-name]/template-struktur-validierung" --status=completed
```

**Pre-Deployment Validierung Workflow:**
```bash
# Vor jedem Deployment validieren
/task-update "[deployment-projekt]/pre-deployment-validation" --status=in_progress
/template-validate  # Comprehensive validation
/terraform-validate  # Additional Terraform checks  
/task-update "[deployment-projekt]/pre-deployment-validation" --status=completed

# Erst nach erfolgreicher Validierung deployen
/multi-cloud-deploy --env=[environment]
```

**Kontinuierliche Validierung Setup:**
```bash
# Validierungs-Task für regelmäßige Überprüfung
/task-create project "template-quality-assurance" --description="Kontinuierliche Template-Qualitätssicherung"
/task-create subtask "template-quality-assurance" "weekly-template-validation" --priority=medium

# Wöchentliche Validierung
/task-update "template-quality-assurance/weekly-template-validation" --status=in_progress
/template-validate
/task-log "template-quality-assurance/weekly-template-validation" "Wöchentliche Validierung durchgeführt - $(date)"
/task-update "template-quality-assurance/weekly-template-validation" --status=completed
```

**Integration in CI/CD Pipeline:**
```bash
# Template-Validierung vor Git-Commits
/template-validate  # Als Pre-commit Hook
/task-log "[current-projekt]" "Template-Validierung vor Commit erfolgreich"

# Als GitLab CI/CD Job  
/template-validate  # In .gitlab-ci.yml Pipeline
```

**Verwendung:** Vor Template-Anpassungen, Commits und Deployments ausführen.
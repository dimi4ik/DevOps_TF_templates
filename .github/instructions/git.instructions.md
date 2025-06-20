---
applyTo: '**'
---

# Terraform Git Workflow

## Terraform Code-Qualitätssicherung

1. **Formatierung**:
   - Führe stets `terraform fmt -recursive` aus, um eine konsistente Codeformatierung in allen Dateien zu gewährleisten
   - Dies sollte vor jedem Commit durchgeführt werden

2. **Validierung**:
   - Verwende `terraform validate`, um syntaktische Fehler im Code zu identifizieren
   - Stelle sicher, dass alle Abhängigkeiten korrekt konfiguriert sind

3. **Planung**:
   - Führe `terraform plan -out=tfplan` aus, um die geplanten Änderungen zu prüfen
   - Überprüfe sorgfältig die Ausgabe auf unerwartete Änderungen oder Ressourcen, die gelöscht werden sollen
   - Speichere den Plan in einer Datei für die spätere Anwendung

## Sicherheitshinweise

- **Keine sensiblen Daten in Terraform-Dateien**:
  - Verwende niemals Klartext-Passwörter, API-Keys oder Tokens in *.tf oder *.tfvars Dateien
  - Nutze stattdessen Umgebungsvariablen, AWS KMS, HashiCorp Vault oder ähnliche sichere Methoden
  - Alle sensiblen Daten sollten in .gitignore eingetragen werden (*.auto.tfvars)

- **Überprüfe alle Commits vor dem Push**:
  - Führe `git diff --staged` aus, um sicherzustellen, dass keine sensiblen Daten committed werden

## Git Workflow

1. **Commits**:
   - Wenn terraform plan erfolgreich ist, führe git commit mit sinnvollem Text im aktuellen Branch aus
   - Verwende ein konsistentes Format: `TF: {Bereich} - {Kurze Beschreibung der Änderung}`
   - Beispiel: `TF: Networking - CIDR-Blöcke für Subnets aktualisiert`

2. **Merge-Requests erstellen**:
   - Erstelle einen Merge-Request im GitLab mit dem Befehl:
     ```
     glab mr create --target-branch main \
       --title "TF: {Beschreibung der Änderung}" \
       --description "Detaillierte Beschreibung der durchgeführten Änderungen und deren Zweck"
     ```
   - Die Beschreibung sollte alle wichtigen Änderungen und deren Begründung enthalten

3. **Merge-Requests genehmigen**:
   - Nach der Erstellung und Review des Merge Requests kann dieser mit folgendem Befehl genehmigt werden:
     ```
     glab mr merge {MR_NUMMER} --yes
     ```
   - Ersetze {MR_NUMMER} mit der tatsächlichen Merge-Request-Nummer aus der Ausgabe des vorherigen Befehls

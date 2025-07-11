# Template Repository - Zentrale To-Do Liste

*Basierend auf promt.md Workflow für Citrix DaaS DevOps Template*

## Phase 1: Bestandsaufnahme und Bereinigung ✅ ABGESCHLOSSEN

- [x] **Vollständige Inventarisierung** aller existierenden Files (333 Dateien analysiert)
- [x] **Kategorisierung nach Relevanz** (Essential/Optional/Archiv)  
- [x] **Identifikation unnötiger/veralteter Dateien** (908K Archive-Kandidaten)
- [x] **Erstellung Archiv-Ordner** für nicht-essentielle Dateien (`/archive/ai-tools/`)
- [x] **Bereinigung Hauptverzeichnisstruktur**
  - [x] Claude Commands: 92→4 Dateien (nur Terraform-relevante)
  - [x] GitHub Copilot: 6→1 Datei (nur instructions.md)
  - [x] Cursor Rules: 20+→2 Dateien (terraform.mdc, dimas.mdc)

## Phase 2: Dokumentations-Konsolidierung ✅ ABGESCHLOSSEN

- [x] **CLAUDE.md** mit AI-Tool Instructions konsolidiert
- [x] **Cursor Rules** konsolidiert (terraform.mdc + dimas.mdc → eine Datei)
- [x] **GitHub Copilot Instructions** konsolidiert (instructions.md + git.instructions.md → eine Datei)
- [x] **README.md** als zentrale Template-Dokumentation überarbeitet (HIGH)
  - [x] Citrix DaaS Fokus statt Azure VM
  - [x] Multi-Cloud Provider Unterstützung
  - [x] Template-Anpassungsanleitung
  - [x] Vollständige Repository-Struktur dokumentiert
  - [x] AI-Tool Integration Übersicht
- [x] **CHANGELOG.md** mit Template-Versionierung aktualisiert (MEDIUM)
  - [x] Template-spezifische Versionierung implementiert
  - [x] Vollständige v1.0.0 Dokumentation aller Änderungen
  - [x] Template-Commit-Richtlinien und Release-Prozess definiert
- [x] **NetScaler/BGP Referenzen entfernt** - Template-Fokus bereinigt (MEDIUM)
- [x] **Einheitliche Dokumentationsstruktur** erstellt (MEDIUM)
  - [x] docs/README.md - Hauptübersicht und Navigation
  - [x] docs/architecture/ - Systemarchitektur und Design-Patterns
  - [x] docs/deployment/ - Deployment-Anleitungen und Operations  
  - [x] docs/templates/ - Template-Anpassung und Beispiele
  - [x] README.md Repository-Struktur aktualisiert
- [x] **Integration aller verbliebenen AI-Tool Instructions** abgeschlossen (LOW)
  - [x] VMware/Citrix-spezifische Instructions referenziert (aus Archiv)
  - [x] Azure SIG Instructions referenziert (aus Archiv)  
  - [x] Template-Integration Guidelines dokumentiert
  - [x] Wiederverwendung für Projekte erklärt

### ⚠️ WICHTIGER WORKFLOW-HINWEIS
**Alle To-dos IMMER in dieser zentralen TEMPLATE_TODO.md speichern** - nicht nur in internen TodoWrite/TodoRead Tools!

## Phase 3: Template-Struktur Optimierung 📋 AUSSTEHEND

- [ ] **Standardisierte Ordnerstruktur** für Citrix DaaS Projekte definieren
  - [ ] `/terraform/` - Module, Environments, Providers
  - [ ] `/ansible/` - Playbooks, Roles
  - [ ] `/docs/` - Architecture, Deployment
- [ ] **Platzhalter-Konfigurationen** für verschiedene Cloud Provider erstellen
- [ ] **Terraform-Modulstruktur** vorbereiten (ohne Code-Generierung)
- [ ] **Ansible-Playbook Struktur** definieren (ohne Code-Generierung)
- [ ] **GitLab CI/CD Pipeline Template-Struktur** festlegen

## Phase 4: Template-Anpassbarkeit 📋 AUSSTEHEND

- [ ] **Konfigurationsdateien** mit Variablen-Platzhaltern erstellen
- [ ] **Environment-spezifische** Konfigurationstemplate definieren
- [ ] **Provider-spezifische** Konfigurationsabschnitte vorbereiten
- [ ] **Template-Anpassungsanleitung** erstellen

## Phase 5: Qualitätssicherung und Finalisierung 📋 AUSSTEHEND

- [ ] **Review der gesamten Template-Struktur** auf Vollständigkeit
- [ ] **Validierung der Dokumentation** auf Verständlichkeit
- [ ] **Test der Template-Anpassbarkeit** an Beispiel-Szenarien
- [ ] **Finale Bereinigung** und Strukturoptimierung
- [ ] **Template-Nutzungsanleitung** erstellen

---

## Archiv-Status (908K archiviert)
- `/archive/ai-tools/claude-commands/` - 92 Claude Commands
- `/archive/ai-tools/github-copilot/` - 5 GitHub Copilot Dateien  
- `/archive/ai-tools/cursor-rules/` - 20+ Cursor Rules & Workflows

## Constraints
- ✅ Nur Template-Funktion, kein produktiver Code
- ✅ Fokus auf Citrix DaaS Technologie
- ✅ Multi-Cloud-Provider Unterstützung
- ✅ Keine Code-Generierung in der Vorbereitungsphase

*Letzte Aktualisierung: 2025-06-22*
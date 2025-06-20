# Terraform ToDo: Best Practices Review

## Naming
- [ ] Einheitliche, sprechende Namen für Ressourcen und Variablen verwenden ([Naming Guide](https://www.terraform-best-practices.com/naming))

## Tagging
- [ ] Zentrale Tags für alle Ressourcen einführen (Owner, Environment, Cost Center, ...)

## Module
- [ ] Prüfen, ob Module für VM, Netzwerk, etc. sinnvoll sind
- [ ] Community-Module evaluieren

## Variable Validations
- [ ] Validation-Blöcke für Variablen ergänzen

## Sensitive Data
- [ ] Alle sensitiven Variablen als `sensitive = true` deklarieren

## Remote State
- [ ] Backend-Konfiguration auf Sicherheit prüfen und dokumentieren

## Outputs
- [ ] Alle Outputs mit Beschreibung versehen
- [ ] Zusätzliche relevante Outputs ergänzen

## Dependencies
- [ ] Explizite `depends_on`-Blöcke prüfen/ergänzen

## Formatting & Linting
- [ ] `terraform fmt` und `tflint` regelmäßig ausführen

## Documentation
- [ ] Ausführliche README mit Beispielen und Security-Hinweisen ergänzen
- [ ] Automatische Dokumentation mit [terraform-docs](https://github.com/terraform-docs/terraform-docs) generieren

## Security
- [ ] Security Groups/NSGs restriktiv gestalten
- [ ] Keine Secrets im Klartext im VCS

## Testing
- [ ] Automatisierte Tests mit terratest o.ä. ergänzen

---

**Quellen & weitere Tipps:**
- [Terraform Best Practices (Spacelift)](https://spacelift.io/blog/terraform-best-practices)
- [terraform-best-practices.com/naming](https://www.terraform-best-practices.com/naming)
- [Anton Babenko: terraform-best-practices](https://github.com/antonbabenko/terraform-best-practices/blob/master/todo.md)
- [terraform-docs für automatische Dokumentation](https://github.com/terraform-docs/terraform-docs)

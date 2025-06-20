# GitHub Copilot Konfiguration für VS Code

VS Code sucht in Ihrem Repository nach Anweisungen in diesem Pfad. Diese Anweisungen werden geladen, wenn GitHub Copilot aktiviert ist.

## Berücksichtigte Dateien:

- `.github/copilot/instructions.md` - Enthält die Hauptanweisungen für GitHub Copilot

## Wie es funktioniert:

1. GitHub Copilot liest automatisch die Anweisungen aus dieser Datei bei jeder neuen Anfrage.
2. Die Anweisungen werden als grundlegende Richtlinien für Codegenerierung und -vorschläge verwendet.
3. Besonders wichtig ist der Abschnitt "Variablen und Parameter", der die Vermeidung hartcodierter Werte betont.

## Verwendung:

Sie können Ihre Anfragen einfach stellen und GitHub Copilot wird automatisch die Anweisungen aus `.github/copilot/instructions.md` berücksichtigen.

Beispiel einer Anfrage:
```
Erstelle einen Windows Server 2022 in Azure Cloud
```

Dies wird automatisch unter Berücksichtigung aller bewährten Verfahren aus den Anweisungen beantwortet.

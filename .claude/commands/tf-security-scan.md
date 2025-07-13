# /tf-security-scan

Führt umfassende Sicherheitsscans für Terraform-Konfigurationen durch mit Integration von Wiz, HashiCorp und Compliance-Tools.

## Funktionalität

### Pre-Apply Security Validation
- Scannt Terraform-Pläne vor dem Apply auf Sicherheitslücken
- Integriert Wiz Security Platform für Cloud-Ressourcen-Analyse
- Enforcement-Level: Advisory oder Mandatory (blockiert unsichere Deployments)
- Erstellt Risk-Score-Reports mit CVSS-Bewertungen

### Security Checks
1. **Secrets Detection**: Erkennt hardcodierte API-Keys, Passwörter, Zertifikate
2. **IAM Policy Analysis**: Überprüft zu permissive Berechtigungen 
3. **Network Security**: Analysiert Security Groups, NACLs, öffentliche Zugriffe
4. **Storage Security**: Prüft öffentlich zugängliche S3 Buckets, Storage Accounts
5. **CVE Scanning**: Matched Provider-Versionen gegen bekannte Vulnerabilities

### Compliance Frameworks
- CIS Benchmarks (AWS, Azure, GCP)
- SOC 2 Type II Controls
- PCI DSS Requirements
- NIST Cybersecurity Framework

## Implementation

```bash
# Terraform Plan Security Scan
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json

# Wiz CLI Integration (falls verfügbar)
if command -v wiz &> /dev/null; then
    wiz iac scan tfplan.json --format json --output wiz-report.json
fi

# Checkov Security Scan
checkov -f tfplan.json --framework terraform_plan --output json --output-file checkov-report.json

# TFSec Analysis
tfsec . --format json --out tfsec-report.json

# Custom Security Rules
python3 ~/.claude/scripts/tf-security-analyzer.py --plan tfplan.json --output security-summary.json
```

## Output Format

```json
{
  "scan_timestamp": "2025-07-13T10:30:00Z",
  "terraform_plan": "tfplan.json",
  "security_score": 85,
  "risk_level": "MEDIUM",
  "findings": [
    {
      "severity": "HIGH",
      "rule_id": "CKV_AWS_20",
      "resource": "aws_s3_bucket.data_lake",
      "description": "S3 Bucket has an ACL defined which allows public access",
      "remediation": "Set bucket ACL to private and use bucket policies"
    }
  ],
  "compliance_status": {
    "cis_aws": "PASSED",
    "soc2": "FAILED",
    "pci_dss": "PASSED"
  },
  "blocked": false,
  "enforcement_level": "advisory"
}
```

## Prerequisites

```bash
# Required Tools Installation
pip install checkov
go install github.com/aquasecurity/tfsec/cmd/tfsec@latest
# Optional: Wiz CLI (enterprise)
```

## Integration Points

- **Pre-Commit Hook**: Automatischer Scan bei Terraform-Änderungen
- **GitLab CI**: Integration als Pipeline-Stage vor Apply
- **Slack/Teams**: Alert-Benachrichtigungen bei kritischen Findings
- **SIEM**: Export von Security-Events für Monitoring

## Command Usage

```bash
# Basic scan
/tf-security-scan

# Scan mit Enforcement-Level
/tf-security-scan --enforce mandatory

# Scan für spezifische Compliance
/tf-security-scan --compliance cis-aws,soc2

# Scan mit Custom Rules
/tf-security-scan --rules-dir ./security-rules/
```
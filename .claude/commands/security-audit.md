# /security-audit

Führt umfassende Sicherheitsaudits für Infrastructure-as-Code, Anwendungscode und Konfigurationsdateien durch.

## Funktionalität

### Multi-Layer Security Analysis
- **SAST (Static Application Security Testing)**: Analyse von Terraform, YAML, JSON, Scripts
- **DAST (Dynamic Application Security Testing)**: Runtime-Scans gegen bereitgestellte Infrastruktur
- **Secrets Detection**: Umfassende Suche nach Credentials in Code und Konfigurationen
- **Dependency Vulnerability Scanning**: CVE-Analyse für alle verwendeten Provider und Module

### Audit Bereiche
1. **Infrastructure Code**: Terraform, CloudFormation, Ansible Playbooks
2. **Configuration Files**: Docker, Kubernetes YAML, GitLab CI/CD
3. **Scripts & Automation**: Bash, Python, PowerShell Scripts
4. **Documentation**: README, Wiki für Security Best Practices
5. **Access Control**: IAM Policies, RBAC Konfigurationen

### Compliance Frameworks
- **CIS Benchmarks**: AWS, Azure, GCP, Kubernetes
- **OWASP Top 10**: Web Application Security Risks
- **SOC 2 Type II**: Operational Controls
- **PCI DSS**: Payment Card Industry Standards
- **NIST CSF**: Cybersecurity Framework
- **ISO 27001**: Information Security Management

## Implementation

```bash
# Infrastructure Security Scan
echo "🔍 Starting Infrastructure Security Audit..."

# Terraform Security Analysis
if [ -d "terraform" ] || [ -f "*.tf" ]; then
    echo "📋 Scanning Terraform configurations..."
    checkov --framework terraform --output json --output-file terraform-security.json .
    tfsec . --format json --out tfsec-results.json
    terrascan scan --iac-type terraform --policy-type all --output json > terrascan-results.json
fi

# Kubernetes Security Scan
if [ -d "k8s" ] || [ -f "*.yaml" ]; then
    echo "☸️  Scanning Kubernetes manifests..."
    kubesec scan k8s/*.yaml > kubesec-results.json
    kube-score score k8s/*.yaml --output-format json > kube-score-results.json
fi

# Container Security
if [ -f "Dockerfile" ]; then
    echo "🐳 Scanning Docker configurations..."
    hadolint Dockerfile --format json > hadolint-results.json
    trivy config . --format json --output trivy-config.json
fi

# Secrets Detection
echo "🔐 Scanning for secrets and credentials..."
gitleaks detect --source . --report-format json --report-path gitleaks-results.json
truffleHog filesystem . --json > trufflehog-results.json

# Dependency Vulnerability Scan
echo "📦 Scanning dependencies for vulnerabilities..."
if [ -f "requirements.txt" ]; then
    safety check --json > safety-results.json
fi
if [ -f "package.json" ]; then
    npm audit --json > npm-audit-results.json
fi
if [ -f "go.mod" ]; then
    govulncheck -json ./... > govulncheck-results.json
fi

# Generate Consolidated Report
python3 ~/.claude/scripts/security-audit-analyzer.py
```

## Advanced Security Rules

```yaml
# Custom Security Policy (.claude/security-policies.yaml)
policies:
  terraform:
    - rule: "no_public_s3_buckets"
      severity: "HIGH"
      description: "S3 buckets must not allow public access"
    
    - rule: "encrypt_ebs_volumes"
      severity: "MEDIUM"
      description: "All EBS volumes must be encrypted"
    
    - rule: "mfa_required_iam"
      severity: "HIGH"
      description: "IAM users must have MFA enabled"

  kubernetes:
    - rule: "no_privileged_containers"
      severity: "CRITICAL"
      description: "Containers must not run in privileged mode"
    
    - rule: "resource_limits_required"
      severity: "MEDIUM"
      description: "All containers must have CPU/memory limits"

  general:
    - rule: "no_hardcoded_secrets"
      severity: "CRITICAL"
      description: "No API keys, passwords, or tokens in code"
```

## Compliance Report Output

```json
{
  "audit_timestamp": "2025-07-13T11:15:00Z",
  "audit_scope": ["terraform", "kubernetes", "docker", "scripts"],
  "overall_score": 78,
  "risk_level": "MEDIUM",
  "compliance_status": {
    "cis_aws": {
      "score": 85,
      "passed": 34,
      "failed": 6,
      "status": "PARTIAL"
    },
    "owasp_top10": {
      "score": 90,
      "passed": 9,
      "failed": 1,
      "status": "GOOD"
    },
    "soc2": {
      "score": 72,
      "passed": 18,
      "failed": 7,
      "status": "NEEDS_IMPROVEMENT"
    }
  },
  "findings": [
    {
      "category": "Infrastructure",
      "severity": "HIGH",
      "rule": "CKV_AWS_18",
      "file": "main.tf",
      "line": 45,
      "description": "Ensure S3 bucket has access logging configured",
      "remediation": "Add logging configuration to S3 bucket resource",
      "cve_references": []
    },
    {
      "category": "Secrets",
      "severity": "CRITICAL",
      "rule": "SECRETS_001",
      "file": "scripts/deploy.sh",
      "line": 12,
      "description": "AWS Access Key detected in script",
      "remediation": "Move credentials to environment variables or AWS SSM",
      "cve_references": ["CWE-798"]
    }
  ],
  "remediation_plan": {
    "immediate_actions": [
      "Remove hardcoded AWS credentials from scripts/deploy.sh",
      "Enable S3 bucket access logging for compliance"
    ],
    "short_term": [
      "Implement HashiCorp Vault for secrets management",
      "Add resource limits to all Kubernetes deployments"
    ],
    "long_term": [
      "Establish automated security scanning in CI/CD pipeline",
      "Implement Zero Trust network architecture"
    ]
  }
}
```

## Security Hardening Recommendations

```bash
# Auto-Remediation Script Generation
cat > security-fixes.sh << 'EOF'
#!/bin/bash
# Generated Security Remediation Script

# Fix 1: Enable S3 bucket encryption
terraform plan -target=aws_s3_bucket.main -out=s3-fix.plan
terraform apply s3-fix.plan

# Fix 2: Update IAM policies to least privilege
aws iam put-role-policy --role-name MyRole --policy-name LeastPrivilegePolicy --policy-document file://iam-policy-fixed.json

# Fix 3: Enable CloudTrail logging
aws cloudtrail create-trail --name security-audit-trail --s3-bucket-name audit-logs-bucket

EOF
chmod +x security-fixes.sh
```

## Integration & Automation

### Pre-Commit Hook Integration
```yaml
repos:
  - repo: local
    hooks:
      - id: security-audit
        name: Security Audit
        entry: /usr/local/bin/claude
        args: ["/security-audit", "--fail-on", "HIGH,CRITICAL"]
        language: system
        pass_filenames: false
```

### GitLab CI Integration
```yaml
security_audit:
  stage: security
  script:
    - /usr/local/bin/claude /security-audit --format gitlab-sast
  artifacts:
    reports:
      sast: security-audit-results.json
  only:
    - merge_requests
    - main
```

## Command Usage

```bash
# Vollständiger Security Audit
/security-audit

# Audit für spezifische Compliance
/security-audit --compliance cis-aws,soc2,pci-dss

# Schneller Secrets-Scan
/security-audit --scope secrets

# Audit mit Auto-Remediation
/security-audit --auto-fix --approve-low-risk

# Export für SIEM/Security Tools
/security-audit --export splunk,elk,sentinel
```

## Prerequisites

```bash
# Security Tools Installation
pip install checkov safety
go install github.com/aquasecurity/tfsec/cmd/tfsec@latest
go install github.com/zricethezav/gitleaks/v8@latest
brew install hadolint kubesec kube-score
```
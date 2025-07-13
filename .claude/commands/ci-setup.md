# /ci-setup

Erstellt vollständige CI/CD-Pipelines für GitHub Actions, GitLab CI und Azure DevOps mit Best Practices und Terraform-Integration.

## Funktionalität

### Pipeline-Generierung
- **Multi-Platform Support**: GitHub Actions, GitLab CI, Azure DevOps, Jenkins
- **Terraform-Integration**: Plan/Apply-Workflows mit State-Management
- **Security-First**: Eingebaute Vulnerability-Scans und Compliance-Checks
- **Testing-Automation**: Unit, Integration, E2E Tests mit Parallelisierung
- **Deployment-Strategien**: Blue-Green, Canary, Rolling Updates

### Workflow-Features
1. **Dependency Management**: Automatisches Caching und Dependency-Updates
2. **Quality Gates**: Linting, Testing, Security-Scans als Pipeline-Blocker
3. **Environment Promotion**: Dev → Staging → Prod mit Approval-Gates
4. **Rollback-Automation**: Automatisches Rollback bei Deployment-Fehlern
5. **Notification-Integration**: Slack, Teams, Email bei Pipeline-Events

### Terraform-Spezifische Workflows
- **State-Locking**: Verhindert parallele Terraform-Ausführungen
- **Plan-Review**: Automatische PR-Kommentare mit Terraform-Plan-Output
- **Drift-Detection**: Scheduled Scans für Configuration-Drift
- **Cost-Estimation**: Infracost-Integration für Budget-Kontrolle

## Implementation

```bash
# CI/CD Pipeline Generator
generate_pipeline() {
    local platform=$1
    local project_type=$2
    local cloud_provider=$3
    
    echo "🚀 Generating CI/CD pipeline for ${platform}..."
    
    case $platform in
        "github")
            generate_github_actions_workflow "$project_type" "$cloud_provider"
            ;;
        "gitlab")
            generate_gitlab_ci_pipeline "$project_type" "$cloud_provider"
            ;;
        "azure-devops")
            generate_azure_pipeline "$project_type" "$cloud_provider"
            ;;
        *)
            echo "❌ Unsupported platform: $platform"
            exit 1
            ;;
    esac
    
    echo "✅ Pipeline generated successfully"
}
```

## GitHub Actions Templates

### Terraform Infrastructure Pipeline
```yaml
# .github/workflows/terraform.yml
name: 'Terraform Infrastructure'

on:
  push:
    branches: [ main ]
    paths: ['terraform/**']
  pull_request:
    branches: [ main ]
    paths: ['terraform/**']
  schedule:
    # Daily drift detection
    - cron: '0 6 * * *'

env:
  TF_VERSION: '1.5.0'
  TF_IN_AUTOMATION: true
  TF_INPUT: false

jobs:
  validate:
    name: 'Validate Terraform'
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: ${{ env.TF_VERSION }}
        
    - name: Terraform Format Check
      run: terraform fmt -check -recursive
      
    - name: Terraform Init
      run: terraform init
      working-directory: terraform/
      
    - name: Terraform Validate
      run: terraform validate
      working-directory: terraform/
      
    - name: TFLint
      uses: terraform-linters/setup-tflint@v3
      with:
        tflint_version: latest
    - run: tflint --init
    - run: tflint --format compact
      working-directory: terraform/

  security:
    name: 'Security Scan'
    runs-on: ubuntu-latest
    needs: validate
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Checkov Scan
      uses: bridgecrewio/checkov-action@master
      with:
        directory: terraform/
        framework: terraform
        output_format: sarif
        output_file_path: checkov-results.sarif
        
    - name: Upload Checkov results to GitHub Security
      uses: github/codeql-action/upload-sarif@v2
      if: always()
      with:
        sarif_file: checkov-results.sarif
        
    - name: TFSec Security Scan
      uses: aquasecurity/tfsec-sarif-action@v0.1.4
      with:
        sarif_file: tfsec-results.sarif
        
    - name: Upload TFSec results
      uses: github/codeql-action/upload-sarif@v2
      if: always()
      with:
        sarif_file: tfsec-results.sarif

  plan:
    name: 'Terraform Plan'
    runs-on: ubuntu-latest
    needs: [validate, security]
    if: github.event_name == 'pull_request'
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: ${{ env.TF_VERSION }}
        
    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ vars.AWS_REGION }}
        
    - name: Terraform Init
      run: terraform init
      working-directory: terraform/
      
    - name: Terraform Plan
      run: |
        terraform plan -out=tfplan -detailed-exitcode
        terraform show -json tfplan > tfplan.json
      working-directory: terraform/
      continue-on-error: true
      id: plan
      
    - name: Infracost Cost Estimation
      uses: infracost/actions/setup@v2
      with:
        api-key: ${{ secrets.INFRACOST_API_KEY }}
    - run: |
        infracost breakdown --path terraform/ --format json --out-file infracost-base.json
        infracost diff --path terraform/tfplan.json --compare-to infracost-base.json --format github-comment --out-file infracost-comment.md
      working-directory: terraform/
      
    - name: Post Plan Comment
      uses: actions/github-script@v6
      if: github.event_name == 'pull_request'
      with:
        script: |
          const fs = require('fs');
          const plan = fs.readFileSync('terraform/tfplan.txt', 'utf8');
          const cost = fs.readFileSync('terraform/infracost-comment.md', 'utf8');
          
          const output = `
          ## Terraform Plan 📋
          
          <details><summary>Show Plan</summary>
          
          \`\`\`\n${plan}\n\`\`\`
          
          </details>
          
          ${cost}
          `;
          
          github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner,
            repo: context.repo.repo,
            body: output
          });

  apply:
    name: 'Terraform Apply'
    runs-on: ubuntu-latest
    needs: [validate, security]
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    environment: production
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: ${{ env.TF_VERSION }}
        
    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ vars.AWS_REGION }}
        
    - name: Terraform Init
      run: terraform init
      working-directory: terraform/
      
    - name: Terraform Apply
      run: terraform apply -auto-approve
      working-directory: terraform/
      
    - name: Post-Apply Validation
      run: |
        # Validate deployed infrastructure
        terraform output -json > outputs.json
        python3 .github/scripts/validate-deployment.py
      working-directory: terraform/

  drift-detection:
    name: 'Configuration Drift Detection'
    runs-on: ubuntu-latest
    if: github.event_name == 'schedule'
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      
    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ vars.AWS_REGION }}
        
    - name: Terraform Init
      run: terraform init
      working-directory: terraform/
      
    - name: Terraform Plan (Drift Check)
      run: |
        terraform plan -detailed-exitcode -out=drift-plan
        exit_code=$?
        if [ $exit_code -eq 2 ]; then
          echo "🚨 Configuration drift detected!"
          terraform show drift-plan > drift-report.txt
          echo "drift_detected=true" >> $GITHUB_OUTPUT
        fi
      working-directory: terraform/
      id: drift
      
    - name: Create Drift Issue
      if: steps.drift.outputs.drift_detected == 'true'
      uses: actions/github-script@v6
      with:
        script: |
          const fs = require('fs');
          const driftReport = fs.readFileSync('terraform/drift-report.txt', 'utf8');
          
          github.rest.issues.create({
            owner: context.repo.owner,
            repo: context.repo.repo,
            title: `🚨 Configuration Drift Detected - ${new Date().toISOString().split('T')[0]}`,
            body: `
            ## Configuration Drift Report
            
            Automated drift detection has found differences between the Terraform state and actual infrastructure.
            
            <details><summary>Drift Details</summary>
            
            \`\`\`\n${driftReport}\n\`\`\`
            
            </details>
            
            **Action Required:**
            1. Review the changes above
            2. Determine if changes should be applied or reverted
            3. Update Terraform configuration if needed
            4. Close this issue once resolved
            `,
            labels: ['infrastructure', 'drift-detection', 'urgent']
          });
```

### Application CI/CD Pipeline
```yaml
# .github/workflows/application.yml
name: 'Application CI/CD'

on:
  push:
    branches: [ main, develop ]
    paths-ignore: ['terraform/**', 'docs/**']
  pull_request:
    branches: [ main ]
    paths-ignore: ['terraform/**', 'docs/**']

jobs:
  test:
    name: 'Test Application'
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18.x, 20.x]
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
        
    - name: Install Dependencies
      run: npm ci
      
    - name: Lint Code
      run: npm run lint
      
    - name: Type Check
      run: npm run type-check
      
    - name: Unit Tests
      run: npm run test:unit -- --coverage
      
    - name: Upload Coverage
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info
        
    - name: Integration Tests
      run: npm run test:integration
      env:
        DATABASE_URL: ${{ secrets.TEST_DATABASE_URL }}

  security:
    name: 'Security Scan'
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: NPM Audit
      run: npm audit --audit-level moderate
      
    - name: Snyk Security Scan
      uses: snyk/actions/node@master
      env:
        SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
      with:
        args: --severity-threshold=high
        
    - name: CodeQL Analysis
      uses: github/codeql-action/init@v2
      with:
        languages: javascript
    - uses: github/codeql-action/analyze@v2

  build:
    name: 'Build Application'
    runs-on: ubuntu-latest
    needs: [test, security]
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '20.x'
        cache: 'npm'
        
    - name: Install Dependencies
      run: npm ci
      
    - name: Build Application
      run: npm run build
      
    - name: Build Docker Image
      run: |
        docker build -t ${{ github.repository }}:${{ github.sha }} .
        docker tag ${{ github.repository }}:${{ github.sha }} ${{ github.repository }}:latest
        
    - name: Scan Docker Image
      uses: aquasecurity/trivy-action@master
      with:
        image-ref: '${{ github.repository }}:${{ github.sha }}'
        format: 'sarif'
        output: 'trivy-results.sarif'
        
    - name: Upload Trivy results
      uses: github/codeql-action/upload-sarif@v2
      with:
        sarif_file: 'trivy-results.sarif'

  deploy-staging:
    name: 'Deploy to Staging'
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/develop'
    environment: staging
    
    steps:
    - name: Deploy to Staging
      run: |
        echo "🚀 Deploying to staging environment..."
        # Add deployment commands here
        
  deploy-production:
    name: 'Deploy to Production'
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    environment: production
    
    steps:
    - name: Blue-Green Deployment
      run: |
        echo "🔄 Starting blue-green deployment..."
        # Implement blue-green deployment logic
        
    - name: Health Check
      run: |
        echo "🏥 Running health checks..."
        # Add health check validation
        
    - name: Rollback on Failure
      if: failure()
      run: |
        echo "🔄 Rolling back deployment..."
        # Add rollback logic
```

## GitLab CI Template

```yaml
# .gitlab-ci.yml
stages:
  - validate
  - security
  - test
  - build
  - deploy-staging
  - deploy-production

variables:
  TF_VERSION: "1.5.0"
  TF_IN_AUTOMATION: "true"
  TF_ADDRESS: "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/terraform/state/default"
  TF_USERNAME: "gitlab-ci-token"
  TF_PASSWORD: "${CI_JOB_TOKEN}"

.terraform-base:
  image: hashicorp/terraform:$TF_VERSION
  before_script:
    - terraform --version
    - terraform init -backend-config="address=${TF_ADDRESS}" -backend-config="lock_address=${TF_ADDRESS}/lock" -backend-config="unlock_address=${TF_ADDRESS}/lock" -backend-config="username=${TF_USERNAME}" -backend-config="password=${TF_PASSWORD}" -backend-config="lock_method=POST" -backend-config="unlock_method=DELETE" -backend-config="retry_wait_min=5"

terraform:validate:
  extends: .terraform-base
  stage: validate
  script:
    - terraform fmt -check -recursive
    - terraform validate
  only:
    changes:
      - terraform/**/*

terraform:plan:
  extends: .terraform-base
  stage: test
  script:
    - terraform plan -out=tfplan
    - terraform show -json tfplan > tfplan.json
  artifacts:
    paths:
      - terraform/tfplan
      - terraform/tfplan.json
    expire_in: 1 week
  only:
    - merge_requests

terraform:apply:
  extends: .terraform-base
  stage: deploy-production
  script:
    - terraform apply -auto-approve
  environment:
    name: production
  when: manual
  only:
    - main

security:checkov:
  image: bridgecrew/checkov:latest
  stage: security
  script:
    - checkov -d terraform/ --framework terraform --output json --output-file checkov-report.json
  artifacts:
    reports:
      sast: checkov-report.json
  only:
    changes:
      - terraform/**/*

security:tfsec:
  image: aquasec/tfsec:latest
  stage: security
  script:
    - tfsec terraform/ --format json --out tfsec-report.json
  artifacts:
    reports:
      sast: tfsec-report.json
  only:
    changes:
      - terraform/**/*
```

## Command Usage

```bash
# GitHub Actions Setup
/ci-setup github terraform aws

# GitLab CI mit Kubernetes
/ci-setup gitlab k8s-app gcp

# Azure DevOps Pipeline
/ci-setup azure-devops webapp azure

# Multi-Environment Setup
/ci-setup github terraform aws --environments dev,staging,prod

# Mit Custom Templates
/ci-setup gitlab terraform aws --template enterprise-template

# Security-Focused Pipeline
/ci-setup github terraform aws --security-profile high --compliance sox,pci
```

## Pipeline Features

### Advanced Deployment Strategies
- **Blue-Green**: Zero-downtime deployments
- **Canary**: Gradual traffic shifting
- **Rolling**: Sequential instance updates
- **Feature Flags**: Runtime feature toggles

### Monitoring Integration
- **Pipeline Metrics**: Success rates, duration, failure analysis
- **Infrastructure Monitoring**: Post-deployment health checks
- **Cost Tracking**: Resource usage and cost optimization
- **Performance**: Load testing and benchmark validation
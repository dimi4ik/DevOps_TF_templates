# /monitor-setup

Konfiguriert umfassende Monitoring- und Observability-Infrastruktur mit OpenTelemetry, Prometheus, Grafana und Cloud-Provider-spezifischen Monitoring-Services.

## Funktionalität

### Multi-Platform Monitoring Setup
- **OpenTelemetry**: Distributed Tracing, Metrics und Logs Collection
- **Prometheus Stack**: Metrics Storage, Alertmanager, Grafana Dashboards
- **Cloud-Provider Integration**: CloudWatch, Azure Monitor, Cloud Monitoring
- **Application Performance Monitoring**: APM für Kubernetes, Docker, Serverless
- **Infrastructure Monitoring**: Server, Network, Storage, Database Performance

### Monitoring Components
1. **Metrics Collection**: Custom metrics, System metrics, Business metrics
2. **Log Aggregation**: Centralized logging mit ELK/EFK Stack
3. **Distributed Tracing**: Request flow tracking über Microservices
4. **Alerting**: Intelligent alerting mit Machine Learning-basierter Anomalieerkennung
5. **Dashboards**: Real-time Visualisierung und Performance Analytics

### Claude Code Integration
- **Token Usage Tracking**: Claude API Token consumption monitoring
- **Session Analytics**: Development session insights und productivity metrics
- **Cost Optimization**: Claude usage cost tracking und optimization recommendations
- **Tool Usage Patterns**: Analysis von Claude Code tool usage für workflow optimization

## Implementation

```bash
# Monitoring Infrastructure Setup
setup_monitoring_stack() {
    local environment=$1
    local cloud_provider=$2
    local monitoring_profile=${3:-standard}
    
    echo "📊 Setting up monitoring infrastructure for ${environment}..."
    
    # Validate prerequisites
    validate_monitoring_prerequisites "$cloud_provider"
    
    # Deploy monitoring stack
    case $monitoring_profile in
        "minimal")
            deploy_minimal_monitoring "$environment" "$cloud_provider"
            ;;
        "standard")
            deploy_standard_monitoring "$environment" "$cloud_provider"
            ;;
        "enterprise")
            deploy_enterprise_monitoring "$environment" "$cloud_provider"
            ;;
    esac
    
    # Configure Claude Code telemetry
    setup_claude_telemetry "$environment"
    
    # Generate dashboards
    generate_monitoring_dashboards "$environment" "$cloud_provider"
    
    # Setup alerting rules
    configure_alerting_rules "$environment"
    
    echo "✅ Monitoring stack deployed successfully"
}

# OpenTelemetry Configuration
setup_opentelemetry() {
    local environment=$1
    
    echo "🔭 Configuring OpenTelemetry for ${environment}..."
    
    # Create OpenTelemetry configuration
    cat > otel-config-${environment}.yaml << 'EOF'
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318
  
  prometheus:
    config:
      scrape_configs:
        - job_name: 'claude-code'
          static_configs:
            - targets: ['localhost:8080']
          metrics_path: '/metrics'
          scrape_interval: 15s
  
  jaeger:
    protocols:
      grpc:
        endpoint: 0.0.0.0:14250

processors:
  batch:
    timeout: 1s
    send_batch_size: 1024
  
  memory_limiter:
    limit_mib: 512
  
  resource:
    attributes:
      - key: environment
        value: ${environment}
        action: upsert
      - key: service.name
        value: claude-code
        action: upsert

exporters:
  prometheus:
    endpoint: "0.0.0.0:8889"
    namespace: claude_code
    
  jaeger:
    endpoint: jaeger-collector:14250
    tls:
      insecure: true
      
  logging:
    loglevel: info
    
  # Cloud-specific exporters
  googlecloud:
    project: ${GCP_PROJECT_ID}
    
  azuremonitor:
    instrumentation_key: ${AZURE_INSTRUMENTATION_KEY}
    
  awsxray:
    region: ${AWS_REGION}

service:
  pipelines:
    traces:
      receivers: [otlp, jaeger]
      processors: [memory_limiter, batch, resource]
      exporters: [jaeger, logging]
      
    metrics:
      receivers: [otlp, prometheus]
      processors: [memory_limiter, batch, resource]
      exporters: [prometheus, logging]
      
    logs:
      receivers: [otlp]
      processors: [memory_limiter, batch, resource]
      exporters: [logging]
EOF

    # Deploy OpenTelemetry Collector
    kubectl apply -f - << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: otel-collector
  namespace: monitoring
spec:
  replicas: 2
  selector:
    matchLabels:
      app: otel-collector
  template:
    metadata:
      labels:
        app: otel-collector
    spec:
      containers:
      - name: otel-collector
        image: otel/opentelemetry-collector-contrib:latest
        command: ["/otelcol-contrib"]
        args: ["--config=/etc/otel/config.yaml"]
        volumeMounts:
        - name: config
          mountPath: /etc/otel
        resources:
          requests:
            memory: 256Mi
            cpu: 100m
          limits:
            memory: 512Mi
            cpu: 500m
      volumes:
      - name: config
        configMap:
          name: otel-config
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: otel-config
  namespace: monitoring
data:
  config.yaml: |
$(cat otel-config-${environment}.yaml | sed 's/^/    /')
EOF
}
```

## Claude Code Telemetry Integration

```bash
# Claude Code specific monitoring setup
setup_claude_telemetry() {
    local environment=$1
    
    echo "🤖 Setting up Claude Code telemetry..."
    
    # Create Claude Code metrics configuration
    cat > ~/.claude/telemetry.json << EOF
{
  "telemetry": {
    "enabled": true,
    "export_interval": "30s",
    "metrics": {
      "token_usage": {
        "enabled": true,
        "track_input_tokens": true,
        "track_output_tokens": true,
        "track_total_cost": true
      },
      "session_analytics": {
        "enabled": true,
        "track_session_duration": true,
        "track_tool_usage": true,
        "track_commands": true
      },
      "performance": {
        "enabled": true,
        "track_response_time": true,
        "track_error_rates": true
      }
    },
    "exporters": {
      "prometheus": {
        "endpoint": "http://localhost:8889/metrics",
        "enabled": true
      },
      "otlp": {
        "endpoint": "http://localhost:4318/v1/metrics",
        "enabled": true
      }
    }
  }
}
EOF

    # Create Claude Code metrics exporter script
    cat > ~/.claude/scripts/metrics-exporter.py << 'EOF'
#!/usr/bin/env python3
import json
import time
import requests
from datetime import datetime
from opentelemetry import metrics
from opentelemetry.exporter.prometheus import PrometheusMetricReader
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader

class ClaudeCodeMetrics:
    def __init__(self):
        self.meter_provider = MeterProvider(
            metric_readers=[
                PrometheusMetricReader(port=8080),
                PeriodicExportingMetricReader(exporter=OTLPMetricExporter(), export_interval_millis=30000)
            ]
        )
        self.meter = self.meter_provider.get_meter("claude-code")
        
        # Define metrics
        self.token_usage_counter = self.meter.create_counter(
            name="claude_code_tokens_total",
            description="Total tokens consumed by Claude Code",
            unit="token"
        )
        
        self.session_duration_histogram = self.meter.create_histogram(
            name="claude_code_session_duration_seconds",
            description="Duration of Claude Code sessions",
            unit="s"
        )
        
        self.tool_usage_counter = self.meter.create_counter(
            name="claude_code_tool_usage_total",
            description="Number of tool calls by type",
            unit="call"
        )
        
        self.cost_gauge = self.meter.create_gauge(
            name="claude_code_cost_usd",
            description="Current cost in USD",
            unit="usd"
        )
        
    def record_token_usage(self, input_tokens, output_tokens, model="claude-3"):
        self.token_usage_counter.add(
            input_tokens,
            {"type": "input", "model": model}
        )
        self.token_usage_counter.add(
            output_tokens,
            {"type": "output", "model": model}
        )
        
    def record_tool_usage(self, tool_name, success=True):
        self.tool_usage_counter.add(
            1,
            {"tool": tool_name, "status": "success" if success else "error"}
        )
        
    def record_session_duration(self, duration_seconds):
        self.session_duration_histogram.record(duration_seconds)
        
    def update_cost(self, cost_usd):
        self.cost_gauge.set(cost_usd)

# Usage tracking integration
metrics_client = ClaudeCodeMetrics()

def track_claude_session():
    """Track Claude Code session metrics"""
    session_start = time.time()
    
    # Load session data
    try:
        with open('~/.claude/session.json', 'r') as f:
            session_data = json.load(f)
            
        # Record metrics
        if 'token_usage' in session_data:
            tokens = session_data['token_usage']
            metrics_client.record_token_usage(
                tokens.get('input', 0),
                tokens.get('output', 0),
                tokens.get('model', 'claude-3')
            )
            
        if 'tools_used' in session_data:
            for tool, count in session_data['tools_used'].items():
                for _ in range(count):
                    metrics_client.record_tool_usage(tool)
                    
        if 'cost' in session_data:
            metrics_client.update_cost(session_data['cost'])
            
    except FileNotFoundError:
        pass  # No session data yet
        
if __name__ == "__main__":
    track_claude_session()
EOF

    chmod +x ~/.claude/scripts/metrics-exporter.py
    
    # Setup systemd service for metrics export (Linux)
    if command -v systemctl >/dev/null 2>&1; then
        sudo tee /etc/systemd/system/claude-metrics.service > /dev/null << EOF
[Unit]
Description=Claude Code Metrics Exporter
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart=$HOME/.claude/scripts/metrics-exporter.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

        sudo systemctl enable claude-metrics.service
        sudo systemctl start claude-metrics.service
    fi
}
```

## Prometheus & Grafana Setup

```yaml
# Prometheus configuration for Claude Code monitoring
# prometheus-config.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "claude-code-rules.yml"

scrape_configs:
  - job_name: 'claude-code'
    static_configs:
      - targets: ['localhost:8080']
    metrics_path: '/metrics'
    scrape_interval: 30s
    
  - job_name: 'infrastructure'
    kubernetes_sd_configs:
      - role: pod
        namespaces:
          names: ['default', 'monitoring', 'infrastructure']
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true

  - job_name: 'terraform-state'
    static_configs:
      - targets: ['terraform-exporter:9100']
    scrape_interval: 300s  # 5 minutes

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['alertmanager:9093']

---
# Claude Code specific alerting rules
# claude-code-rules.yml
groups:
  - name: claude-code-alerts
    rules:
      - alert: HighTokenUsage
        expr: rate(claude_code_tokens_total[5m]) > 1000
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "High Claude Code token usage detected"
          description: "Token usage rate is {{ $value }} tokens/sec for the last 5 minutes"
          
      - alert: ClaudeCodeSessionErrors
        expr: rate(claude_code_tool_usage_total{status="error"}[5m]) > 0.1
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Claude Code tool errors detected"
          description: "Error rate is {{ $value }} errors/sec"
          
      - alert: HighClaudeCodeCost
        expr: claude_code_cost_usd > 100
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Claude Code costs exceeding threshold"
          description: "Current cost is ${{ $value }} USD"
          
  - name: infrastructure-alerts
    rules:
      - alert: TerraformStateDrift
        expr: terraform_drift_detected > 0
        for: 0m
        labels:
          severity: critical
        annotations:
          summary: "Terraform configuration drift detected"
          description: "Infrastructure drift detected in {{ $labels.environment }}"
          
      - alert: PipelineFailureRate
        expr: rate(ci_pipeline_failures_total[10m]) > 0.3
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CI/CD pipeline failure rate"
          description: "Pipeline failure rate is {{ $value }}% over 10 minutes"
```

## Grafana Dashboards

```json
{
  "dashboard": {
    "title": "Claude Code DevOps Monitoring",
    "tags": ["claude-code", "devops", "monitoring"],
    "panels": [
      {
        "title": "Claude Code Token Usage",
        "type": "stat",
        "targets": [
          {
            "expr": "sum(rate(claude_code_tokens_total[5m])) by (type)",
            "legendFormat": "{{type}} tokens/sec"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "reqps"
          }
        }
      },
      {
        "title": "Session Duration Distribution",
        "type": "histogram",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(claude_code_session_duration_seconds_bucket[5m]))",
            "legendFormat": "95th percentile"
          }
        ]
      },
      {
        "title": "Tool Usage Heatmap",
        "type": "heatmap",
        "targets": [
          {
            "expr": "sum by (tool) (rate(claude_code_tool_usage_total[1h]))",
            "legendFormat": "{{tool}}"
          }
        ]
      },
      {
        "title": "Infrastructure Health",
        "type": "table",
        "targets": [
          {
            "expr": "up{job=~\"infrastructure|terraform.*\"}",
            "legendFormat": "{{instance}}"
          }
        ]
      },
      {
        "title": "Cost Tracking",
        "type": "timeseries",
        "targets": [
          {
            "expr": "claude_code_cost_usd",
            "legendFormat": "Claude Code Cost"
          },
          {
            "expr": "aws_billing_estimated_charges",
            "legendFormat": "AWS Cost"
          }
        ]
      },
      {
        "title": "CI/CD Pipeline Performance",
        "type": "timeseries",
        "targets": [
          {
            "expr": "rate(ci_pipeline_duration_seconds_sum[5m]) / rate(ci_pipeline_duration_seconds_count[5m])",
            "legendFormat": "Avg Pipeline Duration"
          }
        ]
      }
    ]
  }
}
```

## Cloud-Provider Integrations

### AWS CloudWatch Integration
```bash
# AWS CloudWatch setup for Claude Code
setup_aws_monitoring() {
    local environment=$1
    
    echo "☁️ Setting up AWS CloudWatch monitoring..."
    
    # Create CloudWatch custom metrics namespace
    aws logs create-log-group --log-group-name "/claude-code/${environment}" --region $AWS_REGION
    
    # CloudWatch agent configuration
    cat > cloudwatch-config.json << EOF
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "namespace": "ClaudeCode/${environment}",
    "metrics_collected": {
      "cpu": {
        "measurement": ["cpu_usage_idle", "cpu_usage_iowait"],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": ["used_percent"],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/claude-code.log",
            "log_group_name": "/claude-code/${environment}",
            "log_stream_name": "{instance_id}/claude-code"
          }
        ]
      }
    }
  }
}
EOF

    # Deploy CloudWatch agent
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
        -a fetch-config -m ec2 -c file:cloudwatch-config.json -s
}
```

### Azure Monitor Integration
```bash
# Azure Monitor setup
setup_azure_monitoring() {
    local environment=$1
    
    echo "🔷 Setting up Azure Monitor..."
    
    # Create Application Insights resource
    az monitor app-insights component create \
        --app claude-code-${environment} \
        --location westus2 \
        --resource-group monitoring-rg \
        --application-type web
    
    # Get instrumentation key
    INSTRUMENTATION_KEY=$(az monitor app-insights component show \
        --app claude-code-${environment} \
        --resource-group monitoring-rg \
        --query instrumentationKey -o tsv)
    
    # Configure Application Insights
    cat > appinsights-config.json << EOF
{
  "instrumentationKey": "${INSTRUMENTATION_KEY}",
  "sampling": {
    "percentage": 100
  },
  "enableAutoCollectRequests": true,
  "enableAutoCollectPerformance": true,
  "enableAutoCollectExceptions": true,
  "enableAutoCollectDependencies": true
}
EOF
}
```

## Command Usage

```bash
# Basic monitoring setup
/monitor-setup production aws

# Enterprise monitoring with custom configuration
/monitor-setup production azure --profile enterprise --custom-config monitoring.yaml

# Claude Code specific telemetry
/monitor-setup development --claude-telemetry-only

# Multi-cloud monitoring
/monitor-setup production --providers aws,azure,gcp

# Setup with specific components
/monitor-setup staging aws --components prometheus,grafana,jaeger

# Monitoring validation and health check
/monitor-setup production --validate-only --health-check

# Export monitoring configuration
/monitor-setup --export-config --output monitoring-template.yaml
```

## Health Checks & Validation

```bash
# Monitoring stack health validation
validate_monitoring_health() {
    echo "🏥 Validating monitoring stack health..."
    
    # Check Prometheus
    if curl -s http://localhost:9090/-/healthy | grep -q "Prometheus is Healthy"; then
        echo "✅ Prometheus is healthy"
    else
        echo "❌ Prometheus health check failed"
    fi
    
    # Check Grafana
    if curl -s http://localhost:3000/api/health | grep -q '"status":"ok"'; then
        echo "✅ Grafana is healthy"
    else
        echo "❌ Grafana health check failed"
    fi
    
    # Check OpenTelemetry Collector
    if curl -s http://localhost:13133/ | grep -q "Server available"; then
        echo "✅ OpenTelemetry Collector is healthy"
    else
        echo "❌ OpenTelemetry Collector health check failed"
    fi
    
    # Validate Claude Code metrics endpoint
    if curl -s http://localhost:8080/metrics | grep -q "claude_code"; then
        echo "✅ Claude Code metrics are being exported"
    else
        echo "❌ Claude Code metrics not found"
    fi
}
```
# /incident-response

Automatisierte Incident-Response-Orchestrierung mit intelligenter Triage, Auto-Remediation und Post-Mortem-Dokumentation.

## Funktionalität

### Incident Detection & Triage
- **Multi-Source Alert Aggregation**: Prometheus, CloudWatch, Azure Monitor, Custom Webhooks
- **Intelligent Classification**: ML-basierte Severity-Einschätzung und Impact-Analysis
- **Auto-Escalation**: Dynamische Eskalation basierend auf Response-Time und Severity
- **Context Enrichment**: Automatische Anreicherung mit Historical Data, Runbooks, Ownership-Info
- **Deduplication**: Intelligente Alert-Deduplication zur Noise-Reduction

### Automated Response Workflows
1. **Immediate Actions**: Auto-Scaling, Circuit Breaker Activation, Traffic Rerouting
2. **Diagnostic Collection**: Log Aggregation, Metrics Snapshots, Trace Collection
3. **Stakeholder Notification**: Slack, Teams, PagerDuty, SMS mit Context-aware Messaging
4. **Remediation Execution**: Rollback-Automation, Service Restart, Config-Fixes
5. **Documentation**: Real-time Incident Timeline, Communication Log, Action History

### Claude Code Integration
- **Session Correlation**: Verknüpfung von Claude Commands mit Incident-Triggers
- **AI-Assisted Diagnosis**: Claude-powered Root-Cause-Analysis und Remediation-Suggestions
- **Knowledge Base**: Integration von Claude Code Documentation für Troubleshooting
- **Learning Loop**: ML-Training basierend auf erfolgreichen Claude-assisted Resolutions

## Implementation

```bash
# Incident Response System Setup
setup_incident_response() {
    local environment=$1
    local integrations=${2:-"slack,pagerduty,prometheus"}
    
    echo "🚨 Setting up incident response system for ${environment}..."
    
    # Deploy incident management components
    deploy_alertmanager_config "$environment"
    setup_incident_coordinator "$environment"
    configure_auto_remediation "$environment"
    setup_notification_channels "$integrations"
    
    # Claude Code integration
    configure_claude_incident_integration "$environment"
    
    # Deploy runbook automation
    setup_runbook_automation "$environment"
    
    echo "✅ Incident response system configured successfully"
}

# Alertmanager Configuration with Intelligent Routing
deploy_alertmanager_config() {
    local environment=$1
    
    echo "📡 Configuring Alertmanager for ${environment}..."
    
    cat > alertmanager-config.yml << EOF
global:
  smtp_smarthost: 'smtp.company.com:587'
  smtp_from: 'alerts@company.com'
  slack_api_url: '${SLACK_WEBHOOK_URL}'
  pagerduty_url: 'https://events.pagerduty.com/v2/enqueue'

templates:
  - '/etc/alertmanager/templates/*.tmpl'

route:
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 30s
  repeat_interval: 12h
  receiver: 'default'
  routes:
    # Critical infrastructure alerts
    - match:
        severity: critical
      receiver: 'critical-infrastructure'
      routes:
        - match:
            alertname: 'TerraformStateDrift'
          receiver: 'infrastructure-team'
        - match:
            alertname: 'ClaudeCodeCriticalError'
          receiver: 'devops-team'
    
    # Security incidents
    - match:
        category: security
      receiver: 'security-team'
      group_wait: 0s
      
    # Application errors
    - match:
        severity: warning
        service: ~.+
      receiver: 'application-team'

inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'cluster', 'service']

receivers:
  - name: 'default'
    slack_configs:
      - channel: '#alerts'
        title: 'Alert: {{ .GroupLabels.alertname }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'

  - name: 'critical-infrastructure'
    pagerduty_configs:
      - routing_key: '${PAGERDUTY_INTEGRATION_KEY}'
        description: 'Critical Infrastructure Alert'
        severity: 'critical'
        client: 'Alertmanager'
        client_url: '{{ .ExternalURL }}'
        details:
          environment: '${environment}'
          alert_count: '{{ len .Alerts }}'
    slack_configs:
      - channel: '#incident-response'
        title: '🚨 CRITICAL: {{ .GroupLabels.alertname }}'
        text: |
          *Environment:* ${environment}
          *Severity:* {{ .CommonLabels.severity }}
          *Description:* {{ range .Alerts }}{{ .Annotations.description }}{{ end }}
          *Runbook:* {{ range .Alerts }}{{ .Annotations.runbook_url }}{{ end }}
        actions:
          - type: button
            text: 'Acknowledge'
            url: '{{ .ExternalURL }}/#/alerts'
          - type: button
            text: 'Start Incident Response'
            url: '${INCIDENT_MANAGEMENT_URL}/create'

  - name: 'infrastructure-team'
    email_configs:
      - to: 'infrastructure@company.com'
        subject: 'Infrastructure Alert: {{ .GroupLabels.alertname }}'
        body: |
          Alert Details:
          {{ range .Alerts }}
          - Alert: {{ .Annotations.summary }}
          - Description: {{ .Annotations.description }}
          - Severity: {{ .Labels.severity }}
          - Time: {{ .StartsAt }}
          {{ end }}
    slack_configs:
      - channel: '#infrastructure'
        title: '⚠️ Infrastructure Alert'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'

  - name: 'security-team'
    pagerduty_configs:
      - routing_key: '${SECURITY_PAGERDUTY_KEY}'
        description: 'Security Incident'
        severity: 'critical'
    slack_configs:
      - channel: '#security-incidents'
        title: '🔒 Security Alert'
        text: |
          *SECURITY INCIDENT DETECTED*
          {{ range .Alerts }}{{ .Annotations.description }}{{ end }}
        color: 'danger'
EOF

    kubectl create configmap alertmanager-config \
        --from-file=alertmanager.yml=alertmanager-config.yml \
        -n monitoring
}
```

## Incident Coordinator Engine

```python
#!/usr/bin/env python3
# ~/.claude/scripts/incident-coordinator.py

import json
import asyncio
import aiohttp
from datetime import datetime, timedelta
from typing import Dict, List, Any, Optional
from dataclasses import dataclass, asdict
from enum import Enum
import logging

class IncidentSeverity(Enum):
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"
    CRITICAL = "critical"

class IncidentStatus(Enum):
    DETECTED = "detected"
    TRIAGED = "triaged"
    INVESTIGATING = "investigating"
    MITIGATING = "mitigating"
    RESOLVED = "resolved"
    CLOSED = "closed"

@dataclass
class IncidentContext:
    incident_id: str
    title: str
    description: str
    severity: IncidentSeverity
    status: IncidentStatus
    detected_at: datetime
    affected_services: List[str]
    alerts: List[Dict[str, Any]]
    timeline: List[Dict[str, Any]]
    assigned_team: Optional[str] = None
    escalation_level: int = 0
    auto_actions_taken: List[str] = None
    claude_session_id: Optional[str] = None

class IncidentCoordinator:
    def __init__(self):
        self.active_incidents = {}
        self.runbooks = {}
        self.auto_actions = {}
        self.load_runbooks()
        self.load_auto_actions()
    
    async def handle_alert(self, alert_data: Dict[str, Any]) -> str:
        """Handle incoming alert and create or update incident"""
        
        # Check if this is part of existing incident
        existing_incident = self.find_related_incident(alert_data)
        
        if existing_incident:
            await self.update_incident(existing_incident, alert_data)
            return existing_incident
        
        # Create new incident
        incident_id = self.generate_incident_id()
        incident = IncidentContext(
            incident_id=incident_id,
            title=self.generate_incident_title(alert_data),
            description=alert_data.get('description', ''),
            severity=self.determine_severity(alert_data),
            status=IncidentStatus.DETECTED,
            detected_at=datetime.now(),
            affected_services=self.extract_affected_services(alert_data),
            alerts=[alert_data],
            timeline=[{
                'timestamp': datetime.now().isoformat(),
                'event': 'incident_created',
                'description': f'Incident created from alert: {alert_data.get("alertname", "unknown")}'
            }],
            auto_actions_taken=[]
        )
        
        self.active_incidents[incident_id] = incident
        
        # Start incident response workflow
        await self.start_incident_response(incident)
        
        return incident_id
    
    async def start_incident_response(self, incident: IncidentContext):
        """Start automated incident response workflow"""
        
        # Phase 1: Immediate triage and notification
        await self.triage_incident(incident)
        
        # Phase 2: Execute immediate auto-actions
        await self.execute_immediate_actions(incident)
        
        # Phase 3: Gather diagnostic information
        await self.collect_diagnostics(incident)
        
        # Phase 4: Attempt auto-remediation
        if incident.severity in [IncidentSeverity.LOW, IncidentSeverity.MEDIUM]:
            await self.attempt_auto_remediation(incident)
        
        # Phase 5: Start Claude Code assisted diagnosis
        await self.start_claude_analysis(incident)
        
        # Phase 6: Notify stakeholders
        await self.notify_stakeholders(incident)
    
    async def triage_incident(self, incident: IncidentContext):
        """Intelligent incident triage"""
        
        # Analyze historical patterns
        similar_incidents = self.find_similar_incidents(incident)
        
        # Determine impact and urgency
        impact_score = self.calculate_impact_score(incident)
        urgency_score = self.calculate_urgency_score(incident)
        
        # Auto-assign based on affected services
        incident.assigned_team = self.determine_responsible_team(incident.affected_services)
        
        # Update timeline
        incident.timeline.append({
            'timestamp': datetime.now().isoformat(),
            'event': 'incident_triaged',
            'description': f'Assigned to {incident.assigned_team}, Impact: {impact_score}, Urgency: {urgency_score}',
            'impact_score': impact_score,
            'urgency_score': urgency_score,
            'similar_incidents': len(similar_incidents)
        })
        
        incident.status = IncidentStatus.TRIAGED
    
    async def execute_immediate_actions(self, incident: IncidentContext):
        """Execute immediate automated response actions"""
        
        actions_taken = []
        
        # Auto-scaling based on resource alerts
        if any('resource' in alert.get('labels', {}).get('alertname', '').lower() for alert in incident.alerts):
            if await self.trigger_auto_scaling(incident):
                actions_taken.append('auto_scaling_triggered')
        
        # Circuit breaker activation for service errors
        if any('error_rate' in alert.get('labels', {}).get('alertname', '').lower() for alert in incident.alerts):
            if await self.activate_circuit_breakers(incident):
                actions_taken.append('circuit_breakers_activated')
        
        # Traffic routing for availability issues
        if incident.severity == IncidentSeverity.CRITICAL:
            if await self.reroute_traffic(incident):
                actions_taken.append('traffic_rerouted')
        
        # Log collection enhancement
        await self.enhance_log_collection(incident)
        actions_taken.append('enhanced_logging_enabled')
        
        incident.auto_actions_taken.extend(actions_taken)
        
        incident.timeline.append({
            'timestamp': datetime.now().isoformat(),
            'event': 'immediate_actions_executed',
            'description': f'Auto-actions taken: {", ".join(actions_taken)}',
            'actions': actions_taken
        })
    
    async def start_claude_analysis(self, incident: IncidentContext):
        """Start Claude Code assisted incident analysis"""
        
        # Create Claude Code session for incident
        claude_session = await self.create_claude_session(incident)
        incident.claude_session_id = claude_session['session_id']
        
        # Generate diagnostic commands for Claude
        diagnostic_commands = self.generate_claude_commands(incident)
        
        # Execute Claude analysis
        claude_analysis = await self.execute_claude_analysis(incident, diagnostic_commands)
        
        # Extract recommendations
        recommendations = claude_analysis.get('recommendations', [])
        
        incident.timeline.append({
            'timestamp': datetime.now().isoformat(),
            'event': 'claude_analysis_started',
            'description': f'Claude Code session {claude_session["session_id"]} created for incident analysis',
            'claude_session_id': claude_session['session_id'],
            'recommendations_count': len(recommendations)
        })
        
        # Execute high-confidence recommendations automatically
        for recommendation in recommendations:
            if recommendation.get('confidence', 0) > 0.8 and recommendation.get('risk', 'medium') == 'low':
                await self.execute_claude_recommendation(incident, recommendation)
    
    def generate_claude_commands(self, incident: IncidentContext) -> List[str]:
        """Generate Claude Code commands for incident diagnosis"""
        
        commands = []
        
        # Security-related incidents
        if 'security' in incident.title.lower() or any('security' in alert.get('labels', {}).get('alertname', '').lower() for alert in incident.alerts):
            commands.extend([
                '/security-audit --scope affected-services',
                '/tf-security-scan --emergency-mode'
            ])
        
        # Infrastructure drift incidents
        if 'drift' in incident.title.lower():
            commands.extend([
                '/gitops-sync --drift-check-only --affected-services',
                '/validate --infrastructure-only'
            ])
        
        # Performance incidents
        if any('performance' in alert.get('labels', {}).get('alertname', '').lower() for alert in incident.alerts):
            commands.extend([
                '/pipeline-optimize --analyze-only --real-time',
                '/log-trace profile --duration 30m --focus error'
            ])
        
        # General diagnostic commands
        commands.extend([
            '/monitor-setup --validate-only --health-check',
            '/log-trace correlate --incident-mode --auto-timerange'
        ])
        
        return commands
    
    async def attempt_auto_remediation(self, incident: IncidentContext):
        """Attempt automated remediation based on runbooks"""
        
        # Find applicable runbooks
        runbooks = self.find_applicable_runbooks(incident)
        
        for runbook in runbooks:
            if runbook.get('auto_executable', False):
                result = await self.execute_runbook(incident, runbook)
                
                incident.timeline.append({
                    'timestamp': datetime.now().isoformat(),
                    'event': 'auto_remediation_attempted',
                    'description': f'Executed runbook: {runbook["name"]}',
                    'runbook_id': runbook['id'],
                    'result': result['status'],
                    'actions_performed': result.get('actions', [])
                })
                
                # Check if remediation was successful
                if result['status'] == 'success':
                    await self.validate_remediation(incident)
    
    async def generate_post_mortem(self, incident: IncidentContext) -> Dict[str, Any]:
        """Generate automated post-mortem document"""
        
        post_mortem = {
            'incident_id': incident.incident_id,
            'title': incident.title,
            'duration': self.calculate_incident_duration(incident),
            'severity': incident.severity.value,
            'affected_services': incident.affected_services,
            'timeline': incident.timeline,
            'root_cause': await self.determine_root_cause(incident),
            'contributing_factors': await self.identify_contributing_factors(incident),
            'actions_taken': incident.auto_actions_taken,
            'claude_assistance': await self.summarize_claude_assistance(incident),
            'lessons_learned': await self.extract_lessons_learned(incident),
            'action_items': await self.generate_action_items(incident),
            'metrics': {
                'time_to_detect': self.calculate_detection_time(incident),
                'time_to_acknowledge': self.calculate_ack_time(incident),
                'time_to_resolve': self.calculate_resolution_time(incident),
                'auto_actions_effectiveness': self.evaluate_auto_actions(incident)
            }
        }
        
        return post_mortem
```

## Runbook Automation

```yaml
# Automated runbook definitions
runbooks:
  - id: "rb-001"
    name: "High Memory Usage Remediation"
    description: "Automated response to high memory usage alerts"
    trigger_conditions:
      - alertname: "HighMemoryUsage"
      - severity: ["warning", "critical"]
    auto_executable: true
    max_execution_time: "10m"
    steps:
      - name: "identify_memory_consumers"
        action: "execute_command"
        command: "kubectl top pods --sort-by=memory"
        timeout: "30s"
      
      - name: "check_memory_limits"
        action: "execute_command"
        command: "kubectl describe pods | grep -A 5 'Limits:'"
        timeout: "30s"
      
      - name: "restart_high_consumers"
        action: "conditional_restart"
        condition: "memory_usage > 90%"
        target: "highest_memory_pod"
        confirmation_required: false
      
      - name: "scale_if_needed"
        action: "auto_scale"
        condition: "cluster_memory_usage > 80%"
        scale_factor: 1.5
        max_replicas: 10

  - id: "rb-002"
    name: "Terraform State Drift Response"
    description: "Automated response to Terraform drift detection"
    trigger_conditions:
      - alertname: "TerraformStateDrift"
    auto_executable: false  # Requires human approval
    steps:
      - name: "analyze_drift"
        action: "claude_command"
        command: "/gitops-sync --drift-check-only --detailed"
      
      - name: "create_drift_report"
        action: "generate_report"
        template: "drift_analysis_template"
      
      - name: "notify_infrastructure_team"
        action: "send_notification"
        channels: ["slack:#infrastructure", "email:infra@company.com"]
      
      - name: "await_approval"
        action: "wait_for_approval"
        approvers: ["infrastructure-team"]
        timeout: "1h"
      
      - name: "execute_sync"
        action: "claude_command"
        command: "/gitops-sync --apply-drift-fixes --approved"
        requires_approval: true

  - id: "rb-003"
    name: "Claude Code Error Recovery"
    description: "Recovery procedures for Claude Code tool failures"
    trigger_conditions:
      - alertname: "ClaudeCodeToolError"
      - service: "claude-code"
    auto_executable: true
    steps:
      - name: "collect_claude_logs"
        action: "execute_command"
        command: "/log-trace claude-analysis --last 1h --include-errors"
      
      - name: "check_api_connectivity"
        action: "health_check"
        endpoint: "https://api.anthropic.com/health"
      
      - name: "validate_configurations"
        action: "claude_command"
        command: "/validate --claude-config-only"
      
      - name: "restart_claude_services"
        action: "service_restart"
        services: ["claude-metrics-exporter"]
        condition: "validation_failed"
```

## Command Usage

```bash
# Setup incident response system
/incident-response setup production --integrations slack,pagerduty,teams

# Handle specific alert
/incident-response handle --alert-data alert.json

# Create incident manually
/incident-response create --title "Database Performance Issue" --severity high --services database,api

# Run auto-remediation
/incident-response remediate --incident-id INC-2024-001 --auto-approve-safe

# Generate post-mortem
/incident-response post-mortem --incident-id INC-2024-001 --output post-mortem.md

# Update incident status
/incident-response update --incident-id INC-2024-001 --status investigating --assignee john.doe

# Test runbook
/incident-response test-runbook --runbook-id rb-001 --dry-run

# Claude-assisted diagnosis
/incident-response claude-assist --incident-id INC-2024-001 --focus root-cause

# Incident metrics
/incident-response metrics --timeframe 30d --format dashboard
```

## Integration Features

### Slack Bot Integration
```python
# Slack bot for incident management
@slack_app.event("app_mention")
def handle_incident_mention(event, say):
    text = event['text'].lower()
    
    if 'create incident' in text:
        # Extract incident details from message
        incident_data = parse_incident_request(text)
        incident_id = create_incident(incident_data)
        say(f"Incident {incident_id} created. Use `/incident status {incident_id}` for updates.")
    
    elif 'status' in text:
        incident_id = extract_incident_id(text)
        status = get_incident_status(incident_id)
        say(f"Incident {incident_id} status: {status}")
    
    elif 'remediate' in text:
        incident_id = extract_incident_id(text)
        start_auto_remediation(incident_id)
        say(f"Auto-remediation started for {incident_id}")
```

### PagerDuty Integration
```json
{
  "pagerduty_integration": {
    "incident_creation": {
      "auto_create": true,
      "severity_mapping": {
        "critical": "P1",
        "high": "P2", 
        "medium": "P3",
        "low": "P4"
      }
    },
    "escalation_policies": {
      "infrastructure": "P5DTCKX",
      "security": "P6EWKLY",
      "application": "P7FMQNZ"
    }
  }
}
```
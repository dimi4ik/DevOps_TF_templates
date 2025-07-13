# /log-trace

Implementiert Distributed Tracing und intelligente Log-Korrelation für DevOps-Workflows mit automatischer Root-Cause-Analyse.

## Funktionalität

### Distributed Tracing
- **Cross-Service Tracing**: Request-Flow-Tracking über Microservices und Infrastructure Components
- **OpenTelemetry Integration**: Standardisierte Tracing mit Jaeger, Zipkin, AWS X-Ray
- **Trace Correlation**: Automatische Verknüpfung von Logs, Metrics und Traces
- **Performance Profiling**: Latency-Analyse und Bottleneck-Identifikation
- **Error Propagation**: End-to-End Error-Tracking mit Context-Preservation

### Log Correlation Engine
1. **Multi-Source Aggregation**: Kubernetes, Docker, Cloud Logs, Application Logs
2. **Intelligent Parsing**: Strukturierung unstrukturierter Logs mit ML-Patterns
3. **Timeline Reconstruction**: Chronologische Event-Korrelation für Incident Analysis
4. **Anomaly Detection**: Baseline-Abweichungen und Pattern-Recognition
5. **Root Cause Analysis**: Automatische Identifikation von Failure-Ursachen

### Claude Code Integration
- **Session Tracing**: Verfolgung von Claude Code Sessions mit Tool-Usage-Patterns
- **Command Correlation**: Verknüpfung von Slash Commands mit Infrastructure Changes
- **Error Context**: Deep-Dive-Analysis bei Claude Tool-Failures
- **Performance Insights**: Claude Response-Times und Resource-Usage-Tracking

## Implementation

```bash
# Distributed Tracing Setup
setup_distributed_tracing() {
    local environment=$1
    local tracing_backend=${2:-jaeger}
    
    echo "🔍 Setting up distributed tracing with ${tracing_backend}..."
    
    # Deploy tracing backend
    case $tracing_backend in
        "jaeger")
            deploy_jaeger_stack "$environment"
            ;;
        "zipkin")
            deploy_zipkin_stack "$environment"
            ;;
        "aws-xray")
            setup_aws_xray "$environment"
            ;;
        "azure-insights")
            setup_azure_application_insights "$environment"
            ;;
    esac
    
    # Configure trace collection
    setup_trace_collection "$environment" "$tracing_backend"
    
    # Deploy log correlation engine
    deploy_log_correlation_engine "$environment"
    
    # Setup Claude Code tracing
    configure_claude_tracing "$environment"
    
    echo "✅ Distributed tracing configured successfully"
}

# Jaeger Deployment
deploy_jaeger_stack() {
    local environment=$1
    
    echo "📡 Deploying Jaeger tracing stack..."
    
    # Jaeger All-in-One deployment for development
    if [ "$environment" = "dev" ]; then
        kubectl apply -f - << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jaeger
  namespace: monitoring
  labels:
    app: jaeger
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jaeger
  template:
    metadata:
      labels:
        app: jaeger
    spec:
      containers:
      - name: jaeger
        image: jaegertracing/all-in-one:latest
        ports:
        - containerPort: 16686
          name: ui
        - containerPort: 14250
          name: grpc
        - containerPort: 14268
          name: http
        env:
        - name: COLLECTOR_OTLP_ENABLED
          value: "true"
        resources:
          requests:
            memory: 256Mi
            cpu: 100m
          limits:
            memory: 512Mi
            cpu: 500m
---
apiVersion: v1
kind: Service
metadata:
  name: jaeger
  namespace: monitoring
spec:
  selector:
    app: jaeger
  ports:
  - port: 16686
    name: ui
  - port: 14250
    name: grpc
  - port: 14268
    name: http
EOF
    else
        # Production Jaeger with Elasticsearch backend
        kubectl apply -f - << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jaeger-collector
  namespace: monitoring
spec:
  replicas: 3
  selector:
    matchLabels:
      app: jaeger-collector
  template:
    metadata:
      labels:
        app: jaeger-collector
    spec:
      containers:
      - name: jaeger-collector
        image: jaegertracing/jaeger-collector:latest
        ports:
        - containerPort: 14250
        - containerPort: 14268
        env:
        - name: SPAN_STORAGE_TYPE
          value: elasticsearch
        - name: ES_SERVER_URLS
          value: http://elasticsearch:9200
        resources:
          requests:
            memory: 512Mi
            cpu: 200m
          limits:
            memory: 1Gi
            cpu: 1000m
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jaeger-query
  namespace: monitoring
spec:
  replicas: 2
  selector:
    matchLabels:
      app: jaeger-query
  template:
    metadata:
      labels:
        app: jaeger-query
    spec:
      containers:
      - name: jaeger-query
        image: jaegertracing/jaeger-query:latest
        ports:
        - containerPort: 16686
        env:
        - name: SPAN_STORAGE_TYPE
          value: elasticsearch
        - name: ES_SERVER_URLS
          value: http://elasticsearch:9200
EOF
    fi
}
```

## Log Correlation Engine

```python
#!/usr/bin/env python3
# ~/.claude/scripts/log-correlation-engine.py

import re
import json
import pandas as pd
from datetime import datetime, timedelta
from typing import Dict, List, Any, Optional
from dataclasses import dataclass
from elasticsearch import Elasticsearch
import jaeger_client

@dataclass
class LogEntry:
    timestamp: datetime
    source: str
    level: str
    message: str
    trace_id: Optional[str] = None
    span_id: Optional[str] = None
    service: Optional[str] = None
    labels: Dict[str, str] = None

@dataclass
class TraceSpan:
    trace_id: str
    span_id: str
    parent_span_id: Optional[str]
    operation_name: str
    start_time: datetime
    duration: timedelta
    tags: Dict[str, Any]
    logs: List[Dict[str, Any]]

class LogCorrelationEngine:
    def __init__(self, elasticsearch_url: str, jaeger_url: str):
        self.es = Elasticsearch([elasticsearch_url])
        self.jaeger = jaeger_client.Config(
            config={'sampler': {'type': 'const', 'param': 1}},
            service_name='log-correlation-engine'
        ).initialize_tracer()
        
    def correlate_logs_with_traces(self, trace_id: str, time_window: timedelta = timedelta(minutes=5)) -> Dict[str, Any]:
        """Correlate logs with distributed traces"""
        
        # Get trace data from Jaeger
        trace_data = self.get_trace_data(trace_id)
        if not trace_data:
            return {"error": "Trace not found"}
            
        # Extract time range from trace
        start_time = trace_data['start_time']
        end_time = start_time + time_window
        
        # Query logs within time range
        logs = self.query_logs_by_timerange(start_time, end_time)
        
        # Correlate logs with trace spans
        correlated_data = self.perform_correlation(trace_data, logs)
        
        # Perform root cause analysis
        root_cause = self.analyze_root_cause(correlated_data)
        
        return {
            'trace_id': trace_id,
            'correlation_result': correlated_data,
            'root_cause_analysis': root_cause,
            'recommendations': self.generate_recommendations(root_cause)
        }
    
    def query_logs_by_timerange(self, start_time: datetime, end_time: datetime) -> List[LogEntry]:
        """Query logs from Elasticsearch within time range"""
        
        query = {
            "query": {
                "bool": {
                    "must": [
                        {
                            "range": {
                                "@timestamp": {
                                    "gte": start_time.isoformat(),
                                    "lte": end_time.isoformat()
                                }
                            }
                        }
                    ]
                }
            },
            "sort": [{"@timestamp": {"order": "asc"}}],
            "size": 10000
        }
        
        response = self.es.search(index="logs-*", body=query)
        logs = []
        
        for hit in response['hits']['hits']:
            source_data = hit['_source']
            log_entry = LogEntry(
                timestamp=datetime.fromisoformat(source_data['@timestamp'].replace('Z', '+00:00')),
                source=source_data.get('source', 'unknown'),
                level=source_data.get('level', 'info'),
                message=source_data.get('message', ''),
                trace_id=source_data.get('trace_id'),
                span_id=source_data.get('span_id'),
                service=source_data.get('service'),
                labels=source_data.get('labels', {})
            )
            logs.append(log_entry)
            
        return logs
    
    def analyze_error_patterns(self, logs: List[LogEntry]) -> Dict[str, Any]:
        """Analyze error patterns in logs"""
        
        error_logs = [log for log in logs if log.level.lower() in ['error', 'fatal', 'critical']]
        
        if not error_logs:
            return {"status": "no_errors", "patterns": []}
        
        # Pattern analysis
        error_patterns = {}
        for log in error_logs:
            # Extract error patterns using regex
            patterns = self.extract_error_patterns(log.message)
            for pattern in patterns:
                if pattern not in error_patterns:
                    error_patterns[pattern] = []
                error_patterns[pattern].append({
                    'timestamp': log.timestamp.isoformat(),
                    'service': log.service,
                    'message': log.message
                })
        
        # Frequency analysis
        pattern_frequency = {pattern: len(occurrences) for pattern, occurrences in error_patterns.items()}
        most_common_pattern = max(pattern_frequency.items(), key=lambda x: x[1]) if pattern_frequency else None
        
        return {
            'total_errors': len(error_logs),
            'error_patterns': error_patterns,
            'pattern_frequency': pattern_frequency,
            'most_common_error': most_common_pattern,
            'error_timeline': [{'timestamp': log.timestamp.isoformat(), 'service': log.service, 'message': log.message} for log in error_logs]
        }
    
    def extract_error_patterns(self, message: str) -> List[str]:
        """Extract common error patterns from log messages"""
        
        patterns = []
        
        # Common error patterns
        error_patterns_regex = [
            r'Connection\s+(?:refused|timeout|failed)',
            r'(?:File|Directory)\s+not\s+found',
            r'Permission\s+denied',
            r'Out\s+of\s+memory',
            r'Disk\s+(?:full|space)',
            r'Database\s+connection\s+(?:failed|lost)',
            r'Authentication\s+(?:failed|expired)',
            r'Timeout\s+(?:occurred|exceeded)',
            r'SSL\s+(?:certificate|handshake)\s+(?:error|failed)',
            r'Port\s+\d+\s+(?:closed|unreachable)'
        ]
        
        for pattern_regex in error_patterns_regex:
            if re.search(pattern_regex, message, re.IGNORECASE):
                patterns.append(pattern_regex)
                
        return patterns
    
    def perform_service_dependency_analysis(self, trace_data: Dict[str, Any]) -> Dict[str, Any]:
        """Analyze service dependencies from trace data"""
        
        spans = trace_data.get('spans', [])
        service_map = {}
        dependency_graph = {}
        
        for span in spans:
            service = span.get('service', 'unknown')
            operation = span.get('operation_name', 'unknown')
            
            if service not in service_map:
                service_map[service] = {
                    'operations': set(),
                    'call_count': 0,
                    'total_duration': 0,
                    'error_count': 0
                }
            
            service_map[service]['operations'].add(operation)
            service_map[service]['call_count'] += 1
            service_map[service]['total_duration'] += span.get('duration', 0)
            
            # Check for errors
            if span.get('tags', {}).get('error', False):
                service_map[service]['error_count'] += 1
            
            # Build dependency graph
            parent_span_id = span.get('parent_span_id')
            if parent_span_id:
                for parent_span in spans:
                    if parent_span.get('span_id') == parent_span_id:
                        parent_service = parent_span.get('service', 'unknown')
                        if parent_service not in dependency_graph:
                            dependency_graph[parent_service] = set()
                        dependency_graph[parent_service].add(service)
        
        # Calculate service metrics
        for service, metrics in service_map.items():
            metrics['operations'] = list(metrics['operations'])
            metrics['avg_duration'] = metrics['total_duration'] / metrics['call_count'] if metrics['call_count'] > 0 else 0
            metrics['error_rate'] = metrics['error_count'] / metrics['call_count'] if metrics['call_count'] > 0 else 0
        
        return {
            'service_metrics': service_map,
            'dependency_graph': {service: list(deps) for service, deps in dependency_graph.items()},
            'critical_path': self.identify_critical_path(spans),
            'bottlenecks': self.identify_bottlenecks(service_map)
        }
    
    def generate_claude_code_insights(self, logs: List[LogEntry]) -> Dict[str, Any]:
        """Generate Claude Code specific insights from logs"""
        
        claude_logs = [log for log in logs if 'claude' in log.source.lower() or 'claude' in log.message.lower()]
        
        if not claude_logs:
            return {"status": "no_claude_logs", "insights": {}}
        
        insights = {
            'session_analysis': self.analyze_claude_sessions(claude_logs),
            'tool_usage_patterns': self.analyze_tool_usage(claude_logs),
            'error_analysis': self.analyze_claude_errors(claude_logs),
            'performance_metrics': self.calculate_claude_performance(claude_logs)
        }
        
        return insights
    
    def analyze_claude_sessions(self, claude_logs: List[LogEntry]) -> Dict[str, Any]:
        """Analyze Claude Code session patterns"""
        
        sessions = {}
        
        for log in claude_logs:
            # Extract session ID from logs
            session_match = re.search(r'session[_-]?id[:\s]*([a-zA-Z0-9-]+)', log.message, re.IGNORECASE)
            if session_match:
                session_id = session_match.group(1)
                if session_id not in sessions:
                    sessions[session_id] = {
                        'start_time': log.timestamp,
                        'end_time': log.timestamp,
                        'commands': [],
                        'errors': 0,
                        'tools_used': set()
                    }
                
                sessions[session_id]['end_time'] = max(sessions[session_id]['end_time'], log.timestamp)
                
                # Extract commands
                command_match = re.search(r'command[:\s]*([/\\][a-zA-Z-]+)', log.message)
                if command_match:
                    sessions[session_id]['commands'].append(command_match.group(1))
                
                # Extract tool usage
                tool_match = re.search(r'tool[:\s]*([a-zA-Z_]+)', log.message)
                if tool_match:
                    sessions[session_id]['tools_used'].add(tool_match.group(1))
                
                if log.level.lower() == 'error':
                    sessions[session_id]['errors'] += 1
        
        # Calculate session metrics
        for session_id, session_data in sessions.items():
            duration = session_data['end_time'] - session_data['start_time']
            session_data['duration_minutes'] = duration.total_seconds() / 60
            session_data['tools_used'] = list(session_data['tools_used'])
            session_data['command_count'] = len(session_data['commands'])
        
        return sessions
```

## Real-time Log Analysis

```bash
# Real-time log streaming and analysis
setup_realtime_log_analysis() {
    local environment=$1
    
    echo "📊 Setting up real-time log analysis..."
    
    # Fluentd configuration for log collection
    cat > fluentd-config.conf << 'EOF'
<source>
  @type tail
  path /var/log/claude-code/*.log
  pos_file /var/log/fluentd/claude-code.log.pos
  tag claude.code
  format json
  time_key timestamp
  time_format %Y-%m-%dT%H:%M:%S.%L%z
</source>

<source>
  @type tail
  path /var/log/containers/*.log
  pos_file /var/log/fluentd/kubernetes.log.pos
  tag kubernetes.*
  format json
</source>

<filter claude.code>
  @type parser
  key_name message
  reserve_data true
  <parse>
    @type regexp
    expression /^(?<timestamp>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z)\s+(?<level>\w+)\s+\[(?<component>[^\]]+)\]\s+(?<message>.*)$/
  </parse>
</filter>

<filter kubernetes.**>
  @type kubernetes_metadata
  @log_level info
  ca_file /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  verify_ssl true
  bearer_token_file /var/run/secrets/kubernetes.io/serviceaccount/token
</filter>

# Enhance logs with trace correlation
<filter **>
  @type record_transformer
  <record>
    trace_id ${record["trace_id"] || "none"}
    span_id ${record["span_id"] || "none"}
    correlation_timestamp ${time}
  </record>
</filter>

<match **>
  @type elasticsearch
  host elasticsearch
  port 9200
  index_name logs-${environment}
  type_name _doc
  include_timestamp true
  reconnect_on_error true
  reload_on_failure true
  reload_connections false
  log_es_400_reason true
  <buffer>
    @type file
    path /var/log/fluentd/buffer
    flush_mode interval
    retry_type exponential_backoff
    flush_thread_count 2
    flush_interval 5s
    retry_forever true
    retry_max_interval 30
    chunk_limit_size 2M
    queue_limit_length 8
    overflow_action block
  </buffer>
</match>
EOF

    # Deploy Fluentd DaemonSet
    kubectl apply -f - << EOF
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: monitoring
spec:
  selector:
    matchLabels:
      name: fluentd
  template:
    metadata:
      labels:
        name: fluentd
    spec:
      serviceAccount: fluentd
      containers:
      - name: fluentd
        image: fluent/fluentd-kubernetes-daemonset:v1-debian-elasticsearch
        env:
        - name: FLUENT_ELASTICSEARCH_HOST
          value: "elasticsearch"
        - name: FLUENT_ELASTICSEARCH_PORT
          value: "9200"
        - name: FLUENT_ELASTICSEARCH_SCHEME
          value: "http"
        volumeMounts:
        - name: varlog
          mountPath: /var/log
        - name: varlibdockercontainers
          mountPath: /var/lib/docker/containers
          readOnly: true
        - name: config
          mountPath: /fluentd/etc/fluent.conf
          subPath: fluent.conf
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: varlibdockercontainers
        hostPath:
          path: /var/lib/docker/containers
      - name: config
        configMap:
          name: fluentd-config
EOF
}
```

## Command Usage

```bash
# Setup distributed tracing
/log-trace setup production --backend jaeger

# Correlate logs with specific trace
/log-trace correlate --trace-id abc123def456 --time-window 10m

# Real-time log analysis
/log-trace stream --services claude-code,kubernetes --level error

# Root cause analysis for incident
/log-trace analyze --incident-id INC-2024-001 --start-time "2024-07-13T10:00:00Z"

# Claude Code session analysis
/log-trace claude-analysis --session-id session-abc123 --include-performance

# Generate correlation report
/log-trace report --trace-id abc123def --output correlation-report.json

# Setup log aggregation
/log-trace setup-aggregation --sources k8s,docker,systemd --target elasticsearch

# Performance profiling
/log-trace profile --service user-service --duration 1h --include-traces
```

## Intelligent Log Parsing

```yaml
# Log parsing rules for common patterns
log_parsing_rules:
  claude_code:
    patterns:
      - name: "command_execution"
        regex: "Command (/[a-zA-Z-]+) executed in ([0-9.]+)ms"
        fields: ["command", "duration_ms"]
      
      - name: "tool_usage"
        regex: "Tool ([a-zA-Z_]+) called with status (success|error)"
        fields: ["tool_name", "status"]
      
      - name: "token_usage"
        regex: "Tokens: input=([0-9]+), output=([0-9]+), cost=([0-9.]+)"
        fields: ["input_tokens", "output_tokens", "cost_usd"]

  kubernetes:
    patterns:
      - name: "pod_events"
        regex: "Pod ([a-zA-Z0-9-]+) in namespace ([a-zA-Z0-9-]+) (Started|Failed|Killed)"
        fields: ["pod_name", "namespace", "event_type"]
      
      - name: "resource_limits"
        regex: "Container ([a-zA-Z0-9-]+) exceeded (memory|cpu) limit"
        fields: ["container_name", "resource_type"]

  terraform:
    patterns:
      - name: "resource_changes"
        regex: "([a-zA-Z_]+\\.[a-zA-Z0-9_-]+): (Creating|Updating|Destroying)"
        fields: ["resource_address", "action"]
      
      - name: "drift_detection"
        regex: "Drift detected in ([a-zA-Z_]+\\.[a-zA-Z0-9_-]+)"
        fields: ["resource_address"]
```

## Advanced Correlation Features

### Timeline Reconstruction
- Chronological event ordering across multiple services
- Causal relationship mapping between log events
- Impact analysis for cascading failures

### Anomaly Detection
- Baseline deviation detection using statistical models
- Pattern recognition for unusual log volumes or error rates
- Proactive alerting for emerging issues

### Cross-System Correlation
- Integration with Terraform state changes
- CI/CD pipeline correlation with infrastructure events
- Claude Code command execution tracking with system changes
local base = import 'github.com/oliver006/redis_exporter/contrib/redis-mixin/mixin.libsonnet';
local redis = base {
  redisConnectionsThreshold: '100',
  redisExporterSelector: 'job="redis"',
};
{

  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'Prometheus',
  metadata: {
    name: 'redis-alerts',
    namespace: 'monitoring',
    labels: {
      generated: 'by-jsonnet',

    },
  },
  spec: {
    groups: [
      {
        name: 'redis',
        rules: std.map(
          function(rule)
            rule {
              annotations+: {
                runbook_url: 'https://example.com/runbooks/' + rule.alert,
              },
            },
          redis.prometheusAlerts.groups[0].rules
        ),
      },
    ],
  },
}
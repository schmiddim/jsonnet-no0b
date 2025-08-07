local redisMixin = import 'github.com/oliver006/redis_exporter/contrib/redis-mixin/mixin.libsonnet';
local thanosMixin = import 'github.com/thanos-io/thanos/mixin/mixin.libsonnet';

local thanos = thanosMixin {
  thanosConnectionsThreshold: '100',
  thanosExporterSelector: 'job="thanos"',
  thanosAlertingRulesSelector: 'alertname="ThanosAlertingRules"',
  thanosQuerySelector: 'job="thanos-query"',
  thanosStoreSelector: 'job="thanos-store"',
  thanosRulerSelector: 'job="thanos-ruler"',
};

local redis = redisMixin {
  redisConnectionsThreshold: '100',
  redisExporterSelector: 'job="redis"',
};
[
  {

    apiVersion: 'monitoring.coreos.com/v1',
    kind: 'Prometheus',
    metadata: {
      name: 'thanos-alerts',
      namespace: 'monitoring',
      labels: {
        generated: 'by-jsonnet',

      },
    },
    spec: {
      groups: [
        {
          name: 'thanos',
          rules: std.map(
            function(rule)
              rule {
                annotations+: {
                  runbook_url: 'https://example.com/runbooks/' + rule.alert,
                },
              },
            thanosMixin.prometheusAlerts.groups[0].rules
          ),
        },
      ],
    },
  },
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
  },
]

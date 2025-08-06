local base = import 'github.com/oliver006/redis_exporter/contrib/redis-mixin/mixin.libsonnet';

local redis = base {
  _config+:: {
    redisConnectionsThreshold: '100000',
  },
};

{
  prometheusAlerts: {
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

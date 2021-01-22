[
  {
    "job_name": "REDACTED",
    "scheme": "https",
    "scrape_interval": "30s",
    "honor_labels": true,
    "metrics_path": "/federate",
    "params": {
      "match[]": [
        '{job="kube-state-metrics"}',
        '{job="prometheus-operator"}'
      ],
    },
    "static_configs": [
      {
        "targets": [
          "REDACTED"
        ],
        "labels": {
          "clusterID": "REDACTED"
        }
      }
    ]
  }
]
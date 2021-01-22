local urctlParams = import './urctl-params.libsonnet';
local datasource = import './datasources.libsonnet';
local kp = 
(import 'kube-prometheus/kube-prometheus.libsonnet') +
(import 'kube-prometheus/kube-prometheus-eks.libsonnet') +
(import "prometheus-pushgateway/pushgateway.libsonnet") + 
{
  _config+:: {
    namespace: 'monitoring',
    grafana+:: {
      config+: {
        sections: {
          metrics: { enabled: true },
          'auth.okta': {
            name: urctlParams['MONITORING_GRAFANA_OKTA_CLIENT_ID'],
            enabled: true,
            allow_sign_up: true,
            client_id: urctlParams['MONITORING_GRAFANA_OKTA_CLIENT_ID'],
            client_secret: urctlParams['MONITORING_GRAFANA_OKTA_CLIENT_SECRET'],
            scopes: 'openid profile email groups',
            auth_url: urctlParams['MONITORING_GRAFANA_OKTA_AUTHORIZE'],
            token_url: urctlParams['MONITORING_GRAFANA_OKTA_TOKEN'],
            api_url: urctlParams['MONITORING_GRAFANA_OKTA_USERINFO'],
            allowed_domains: '' ,
            allowed_groups: '',
            role_attribute_path: '',
          },
          server: {
            root_url: urctlParams['MONITORING_GRAFANA_URL'],
          },
        },
      },
      datasources: datasource,
    }
  },
  // Configure External URL's per application  
  alertmanager+:: {
    alertmanager+: {
      spec+: {
        externalUrl: urctlParams['MONITORING_ALERTMANAGER_URL'],
      },
    },
  },
  prometheus+:: {
      prometheus+: {
        spec+: {
          externalUrl: urctlParams['MONITORING_PROMETHEUS_URL'],
        },
      },
    },
};
{ ['setup/0namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor'), std.objectFields(kp.prometheusOperator))
} +
// serviceMonitor is separated so that it can be created after the CRDs are ready
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ ['pushgateway-' + name]: kp.pushgateway[name] for name in std.objectFields(kp.pushgateway) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }

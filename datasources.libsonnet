[
  {
    local urctlParams = import './urctl-params.libsonnet',
    name: 'prometheus',
    type: 'prometheus',
    access: 'proxy',
    orgId: 1,
    url: 'https://prometheus.' + urctlParams['ZONE_NAME'],
    version: 1,
    editable: false,
  }
]
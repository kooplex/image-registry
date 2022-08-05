local Config = import 'config.libsonnet';

{
  'svc.yaml-raw': {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: 'registry',
      namespace: Config.ns,
    },
    spec: {
      selector: {
        app: 'registry',
      },
      ports: [
        {
          name: 'https',
          protocol: 'TCP',
          port: 5000,
          targetPort: 443,
        },
      ],
    },
  },
}

local Config = import 'config.libsonnet';

{
  'ingress.yaml-raw': {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      annotations: {
        'nginx.ingress.kubernetes.io/proxy-body-size': '0',
        'nginx.ingress.kubernetes.io/proxy-read-timeout': '600',
        'nginx.ingress.kubernetes.io/proxy-send-timeout': '600',
        'kubernetes.io/tls-acme': 'true',
      },
      name: 'api',
      namespace: Config.ns,
    },
    spec: {
      ingressClassName: 'nginx',
      tls: [
        {
          hosts: [
            Config.fqdn,
          ],
          secretName: 'tls-' + Config.ns,
        },
      ],
      rules: [
        {
          host: Config.fqdn,
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: 'registry',
                    port: {
                      number: 5000,
                    },
                  },
                },
              },
            ],
          },
        },
      ],
    },
  },
}

local Config = import 'config.libsonnet';

{
  'statefulset.yaml-raw': {
    apiVersion: 'apps/v1',
    kind: 'StatefulSet',
    metadata: {
      name: Config.appname,
      namespace: Config.ns,
    },
    spec: {
      serviceName: 'registry',
      podManagementPolicy: 'Parallel',
      replicas: 1,
      selector: {
        matchLabels: {
          app: 'registry',
        },
      },
      template: {
        metadata: {
          labels: {
            app: 'registry',
          },
        },
        spec: {
          affinity: {
            nodeAffinity: {
              requiredDuringSchedulingIgnoredDuringExecution: {
                nodeSelectorTerms: [
                  {
                    matchExpressions: [
                      {
                        key: 'kubernetes.io/hostname',
                        operator: 'NotIn',
                        values: [
                          'atys',
                        ],
                      },
                    ],
                  },
                ],
              },
            },
          },
          containers: [
            {
              name: 'registry',
              image: 'registry',
              ports: [
                {
                  containerPort: 443,
                  name: 'http',
                },
              ],
              env: [
                {
                  name: 'REGISTRY_HTTP_ADDR',
                  value: '0.0.0.0:443',
                },
                {
                  name: 'REGISTRY_STORAGE_DELETE_ENABLED',
                  value: 'true',
                },
              ],
              volumeMounts: [
                {
                  name: 'mnt',
                  mountPath: '/var/lib/registry',
                },
                {
                  name: 'certs',
                  mountPath: '/certs',
                  readOnly: true,
                },
              ],
            },
          ],
          volumes: [
            {
              name: 'mnt',
              persistentVolumeClaim: {
                claimName: 'data',
              },
            },
            {
              name: 'certs',
              secret: {
                secretName: 'tls-' + Config.ns,
              },
            },
          ],
        },
      },
    },
  },
}

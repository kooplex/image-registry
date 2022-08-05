local Config = import 'config.libsonnet';

{
  'pv.yaml-raw': Config.PV(name=Config.ns, cap=Config.storagecapacity, path=Config.nfsvol, server=Config.nfsserver),
  'pvc.yaml-raw': Config.PVC(name='data', pvname=$['pv.yaml-raw'].metadata.name, cap=$['pv.yaml-raw'].spec.capacity.storage),
}

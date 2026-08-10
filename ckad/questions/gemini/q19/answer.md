1. `kubectl create ns monitoring-space`
2. `kubectl create sa cluster-monitor-sa -n monitoring-space`
3. `k create clusterrole global-resource-reader --verb=get,list,watch --resource=pods,persistentvolumes,namespaces`
4. `k describe clusterrole global-resource-reader`

```
Name:         global-resource-reader
Labels:       <none>
Annotations:  <none>
PolicyRule:
  Resources          Non-Resource URLs  Resource Names  Verbs
  ---------          -----------------  --------------  -----
  namespaces         []                 []              [get list watch]
  persistentvolumes  []                 []              [get list watch]
  pods               []                 []              [get list watch]
```

5. `k create clusterrolebinding global-monitor-binding --clusterrole=global-resource-reader --serviceaccount=monitoring-space:cluster-monitor-sa`
6. `k describe clusterrolebinding global-monitor-binding -n monitoring-space`

```
Name:         global-monitor-binding
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  ClusterRole
  Name:  global-resource-reader
Subjects:
  Kind            Name                Namespace
  ----            ----                ---------
  ServiceAccount  cluster-monitor-sa  monitoring-space
```

7. To test if a `ServiceAccount` in `monitoring-space` can list pods in the `kube-system` namespace

```sh
kubectl auth can-i list pods \
  --as=system:serviceaccount:monitoring-space:cluster-monitor-sa \
  -n kube-system

# yes
```

8. `k auth can-i list pods --as=system:serviceaccount:kube-system:cluster-monitor-sa`

```
no
```

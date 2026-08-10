1. `kubectl create ns rbac-space`
2. `kubectl config set-context --current --namespace rbac-space`
3. `kubectl create sa pod-reader-sa -n rbac-space`
4. `kubectl get sa -n rbac-space`

```
NAME            AGE
default         18s
pod-reader-sa   4s
```

5. `kubectl create role pod-reader-role -n rbac-space --verb=get,list,watch --resource=pods`
6. `kubectl describe role pod-reader-role -n rbac-space`

```
Name:         pod-reader-role
Labels:       <none>
Annotations:  <none>
PolicyRule:
  Resources  Non-Resource URLs  Resource Names  Verbs
  ---------  -----------------  --------------  -----
  pods       []                 []              [get list watch]
```

7. `kubectl create rolebinding pod-reader-binding -n rbac-space --role=pod-reader-role --serviceaccount=rbac-space:pod-reader-sa`
8. `kubectl describe rolebinding pod-reader-binding -n rbac-space`

```
Name:         pod-reader-binding
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  Role
  Name:  pod-reader-role
Subjects:
  Kind            Name           Namespace
  ----            ----           ---------
  ServiceAccount  pod-reader-sa  rbac-space
```

9. `kubectl auth can-i list pods --as=system:serviceaccount:rbac-space:pod-reader-sa -n rbac-space`

```
yes
```
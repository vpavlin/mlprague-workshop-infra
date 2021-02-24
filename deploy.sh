#!/bin/bash


if true; then
  echo "" > workshop/namespaces.yaml
  echo "" > workshop/rolebindings.yaml

  for user in `seq 1 200`; do
    ns="workshop-user${user}"

cat <<EOF >>workshop/namespaces.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: ${ns}
  labels:
    project: mlprague
spec:
EOF

cat <<EOF >>workshop/rolebindings.yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: workshop-edit
  namespace: ${ns}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: edit
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: user${user}

EOF
  done

else

cat <<EOF >>workshop/namespaces.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: workshop
  labels:
    project: mlprague
spec:
EOF

cat <<EOF >>workshop/rolebindings.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: workshop-edit
  namespace: workshop
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: edit
subjects:
- kind: Group
  name: system:authenticated
EOF
fi


echo "" > workshop/jsp.configmaps.yaml
for user in `seq 1 200`; do
cat <<EOF >>workshop/jsp.configmaps.yaml
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: jupyterhub-singleuser-profile-user${user}
  labels:
    app: jupyterhub
data:
  profile: |
    env: {}
    gpu: '0'
    last_selected_image: s2i-lab-elyra:mlprague
    last_selected_size: ''
EOF
done

echo "Deploying Open Data Hub Operator"
oc apply -f odh-operator/

echo "Deploying KFDefs"
oc apply -f kfdef/

echo "Deploying resource related to the workshop"
oc apply -f workshop/


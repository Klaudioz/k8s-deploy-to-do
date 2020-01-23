helm uninstall k10 -n kasten-io
helm uninstall my-release

apk add jq
apk add curl

# Cleaning ns kasten-io if there are issues.

NAMESPACE=kasten-io
kubectl proxy &
kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize

# Cleaning apiservices
kubectl delete apiservice v1alpha1.actions.kio.kasten.io
kubectl delete apiservice v1alpha1.apps.kio.kasten.io
kubectl delete apiservice v1alpha1.vault.kio.kasten.io

kubectl delete apiservice v1alpha1.config.kio.kasten.io

# Cleaning 

kubectl delete ClusterRole k10-admin
kubectl delete ClusterRole k10-basic
kubectl delete ClusterRole k10-dashboard-view

# Cleaning ClusterRoleBinding
kubectl delete ClusterRoleBinding kasten-io-k10-k10-cluster-admin

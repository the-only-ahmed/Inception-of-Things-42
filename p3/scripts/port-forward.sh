while true; do
  kubectl port-forward -n dev svc/playground-service 8888:80
  sleep 5
done
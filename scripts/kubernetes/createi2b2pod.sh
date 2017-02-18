kubectl delete deployment i2b2d
kubectl delete service i2b2d

kubectl create -f i2b2pod.yaml
kubectl expose deployment i2b2d --port=80 --target-port=80

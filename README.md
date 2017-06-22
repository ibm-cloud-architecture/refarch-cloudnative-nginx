# refarch-cloudnative-nginx
The repository host the tooling to create a Docker image using NGINX as load balancer for Bluecompute app

Follow these steps to configure NGINX as the load balancer across two BlueCompute deployment

* Clone this project

```
git clone https://github.com/ibm-cloud-architecture/refarch-cloudnative-nginx
cd refarch-cloudnative-nginx
```

* Edit file nginx.conf

  * Replace $BLUECOMPUTE1_URL and $BLUECOMPUTE2_URL with your BlueCompute web page URLs (example 184.172.247.213:31020)

* Load the nginx configuration as Kubernetes ConfigMap:

```
kubectl create configmap nginx-config --from-file=nginx.conf
```

* Run the nginx POD:
```
kubectl create -f nginx-pod.yaml
```

* Expose the POD port:
```
kubectl expose po nginx --type=NodePort
```

* Obtain the service port:
```
kubectl get services | grep nginx
```
You will see something like:
```
eduardos-mbp:refarch-cloudnative-nginx edu$ kubectl get services | grep nginx
nginx                   10.10.10.117   <nodes>       80:32397/TCP        1m
```

* Record the port number (32397) in this case.

* Obtain the node IP:
```
kubectl get nodes
```
You will see the following result:
```
eduardos-mbp:refarch-cloudnative-nginx edu$ kubectl get nodes
NAME              STATUS    AGE
184.172.247.213   Ready     15d
```

* Combine the IP address obtained in the command above with the port obtained in the previous step to open the nginx UI. You'll reach the nginx as a load balancer spraying the requests across the two instance

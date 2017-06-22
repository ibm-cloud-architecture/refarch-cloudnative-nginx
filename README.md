# Cloud Native HA - Hands-On Lab

## Introduction

This project is a **hands-on lab** to demo how to **add basic HA to cloud native application**.
For this lab we will add and test a [NGINX server](https://nginx.org), wich will be used as a proxy and load-balance the requests between two instances of a web applications.

### High-availability architecture for Cloud Native
![Graph](images/ha-glb.png)

### Hands-on lab architecture
For this limited hands-on lab, we will use a simplified architecture:
* Our load-
* We will not implement back-end synchronisation
![Graph](images/ha-nginx.png)

### Prerequisites
* A web application running on two different instances
  * You may for example deploy two instances of the [BlueCompute](https://github.com/ibm-cloud-architecture/refarch-cloudnative-kubernetes) reference application
* A Kubernetes cluster
  * This hands-on lab has been tested with [Bluemix free Kubernetes cluster](https://console.bluemix.net/containers-kubernetes/launch)

### Steps
The main steps of this lab are:
* edit the nginx load balancing configuration file
* deploy nginx configuration file to the kubernetes cluster
* deploy nginx to the kubernetes cluster
* test load balancing
* simulate a problem with one the application instance
* verify that the application is still available

## Configure

The repository host the tooling to create a Docker image using NGINX as load balancer for Bluecompute app

Follow these steps to configure NGINX as the load balancer across two BlueCompute deployment

* Clone this project

```
git clone https://github.com/ibm-cloud-architecture/refarch-cloudnative-nginx
cd refarch-cloudnative-nginx
```

* Edit file nginx.conf

  * Replace $BLUECOMPUTE1_URL and $BLUECOMPUTE2_URL with your BlueCompute web page URLs (example 184.172.247.213:31020)

* Load the nginx configuration as [Kubernetes ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configmap/):

```bash
kubectl create configmap nginx-config --from-file=nginx.conf
```

* Run the nginx POD:
```bash
kubectl create -f nginx-pod.yaml
```

* Expose the POD port:
```bash
kubectl expose po nginx --type=NodePort
```

* Obtain the service port:
```bash
kubectl get services | grep nginx
```
You will see something like:
```
eduardos-mbp:refarch-cloudnative-nginx edu$ kubectl get services | grep nginx
nginx                   10.10.10.117   <nodes>       80:32397/TCP        1m
```

* Record the port number (32397) in this case.

* Obtain the node IP:
```bash
kubectl get nodes
```
You will see the following result:
```
eduardos-mbp:refarch-cloudnative-nginx edu$ kubectl get nodes
NAME              STATUS    AGE
184.172.247.213   Ready     15d
```

* Combine the IP address obtained in the command above with the port obtained in the previous step to open the nginx UI. You'll reach the nginx as a load balancer spraying the requests across the two instance

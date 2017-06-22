# Cloud Native HA - Hands-On Lab

## Introduction

This project is a **hands-on lab** to demo how to **add basic HA to cloud native application**.
For this lab we will add and test a [NGINX server](https://nginx.org), wich will be used as a proxy and load-balance the requests between two instances of a web applications.

### Why is high-availability important for Cloud Native applications?
Pet vs Cattle
Manage fail

### High-availability architecture for Cloud Native
Example of high-availability architecture for cloud-native application:
* Global Load balancer (ex: Akamai)
* Backend synchronisation
  * Cloudant
  * MySQL
![Graph](images/ha-glb.png)

Of course, it is very important to understand business and technical requirements for high-availability to design the right architecture. There is no "one-size fits all" solution!

## Hands-on lab description

### Hands-on lab architecture
For this limited hands-on lab, we will use a simplified architecture:
* Our load-
* We will not implement back-end synchronisation
![Graph](images/ha-nginx.png)

### Prerequisites
* A web application running on two different instances
  * You may for example deploy two instances of the [BlueCompute](https://github.com/ibm-cloud-architecture/refarch-cloudnative-kubernetes) reference application
* A [Kubernetes](https://kubernetes.io/) cluster
  * This hands-on lab has been tested with [Bluemix free Kubernetes cluster](https://console.bluemix.net/containers-kubernetes/launch)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) command-line interface must be installed and configured
  * For Bluemix Kubernetes Cluster, check this [documentation page](https://console.bluemix.net/docs/containers/cs_cli_install.html) if needed

### Summary of the hands-on labs steps
The main steps of this lab are:
* edit the nginx load balancing configuration file
* deploy nginx configuration file to your kubernetes cluster
* deploy nginx to your kubernetes cluster
* test load balancing
* simulate a problem with one the application instance
* verify that the application is still available

## 1 - Edit the nginx load balancing configuration file
* Open a terminal
* Clone this git project

```
git clone https://github.com/ibm-cloud-architecture/refarch-cloudnative-nginx
cd refarch-cloudnative-nginx
```

* Edit file "nginx.conf"
  * Replace $APP_INSTANCE1_URL and $APP_INSTANCE2_URL with your web application URLs (example 184.172.247.213:31020)
  * For more information on this configuraton file, check the [nginx load balancing documentation](http://nginx.org/en/docs/http/load_balancing.html)
  
## 2 - Deploy nginx configuration file to your kubernetes cluster
* Load the nginx configuration as [Kubernetes ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configmap/):
  * Because containers must be immutable it is a good practice to not include the configuration directly in the container. ConfigMaps allow you to decouple configuration artifacts from image content to keep containerized applications portable.

```bash
kubectl create configmap nginx-config --from-file=nginx.conf
```

## 3 - Deploy nginx to your kubernetes cluster

* Run the nginx POD:
```bash
kubectl create -f nginx-pod.yaml
```

* Expose the POD port:
```bash
kubectl expose po nginx --type=NodePort
```

* Obtain the nginx public url
  * This command combines kubectl get services and kubectl get nodes to obtain the ip address and port of nginx
```bash
( kubectl get nodes | awk '{print $1}'; echo ":"; kubectl get services | grep nginx | sed 's/.*:\([0-9][0-9]*\)\/.*/\1/g') | grep -v NAME | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g'
```

You'll reach the nginx as a load balancer spraying the requests across the two instance

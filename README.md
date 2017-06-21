# refarch-cloudnative-nginx
The repository host the tooling to create a Docker image using NGINX as load balancer for Bluecompute app

Follow these steps to configure NGINX as the load balancer across two BlueCompute deployment

* Clone this project

* Edit file nginx.conf

* Replace $BLUECOMPUTE1_URL and $BLUECOMPUTE2_URL with the URLs (example 184.172.247.213:31020)

* Run `build_nginx_img.sh`

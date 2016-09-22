# refarch-cloudnative-nginx
The repository host the tooling to create a Docker image using NGINX as load balancer for Bluecompute app

You can use the script build_nginx_img_4APIC.sh to create a docker image from the NGINX docker base configured to route requests to two different APIC deployments.

The script configures NGINX to route transactions to the servers

    1) api.us.apiconnect.ibmcloud.com
    2) api.eu.apiconnect.ibmcloud.com  

You can replace those two servers in the script if you want to target different APIC servers.

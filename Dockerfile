FROM nginx

ARG APIC_US_FQHN=api.us.apiconnect.ibmcloud.com
ARG APIC_EU_FQHN=api.eu.apiconnect.ibmcloud.com

RUN rm /etc/nginx/conf.d/default.conf

COPY load-balancer.conf  /tmp
RUN sed -e "s/\${api.eu.apiconnect.ibmcloud.com}/$APIC_EU_FQHN/" -e "s/\${api.us.apiconnect.ibmcloud.com}/$APIC_US_FQHN/" -e "s/\${bluecompute-web-app.eu-gb.mybluemix.net}/$WEBAPP_EU_FQHN/" -e "s/\${bluecompute-web-app.us.mybluemix.net}/$WEBAPP_US_FQHN/" /tmp/load-balancer.conf > /etc/nginx/conf.d/load-balancer.conf
RUN cat /etc/nginx/conf.d/load-balancer.conf

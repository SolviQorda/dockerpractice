FROM nginx
MAINTAINER Solvi Naja
ENV REFRESHED_AT 2018-11-28

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# load nginx conf as root
COPY ./site.conf /etc/nginx/conf.d/default.conf
COPY ./fullchain.pem /etc/nginx/ssl.cert
COPY ./privkey.pem /etc/nginx/ssl.dkey

# make a directory for the API volume
RUN ["mkdir", "/opt/server"]

# start the server
CMD ["nginx", "-g", "daemon off;"]

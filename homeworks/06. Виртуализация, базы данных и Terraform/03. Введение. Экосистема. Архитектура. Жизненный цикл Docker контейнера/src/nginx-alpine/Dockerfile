FROM nginx:1.23.1-alpine

RUN apk -U upgrade && rm -rf /var/cache/apk

COPY index.html /usr/share/nginx/html/index.html

CMD ["nginx", "-g", "daemon off;"]

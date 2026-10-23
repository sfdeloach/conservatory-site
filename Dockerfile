FROM nginx:1.30.6-alpine

COPY ./public /usr/share/nginx/html

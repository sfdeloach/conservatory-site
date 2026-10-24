FROM ubuntu:26.04 AS build

WORKDIR /home/steven/workspace

RUN apt update
RUN apt install -y ca-certificates golang-go
RUN CGO_ENABLED=1 go install -tags extended,withdeploy github.com/gohugoio/hugo@latest

# FROM some base linux distro as BUILD
# Set working directory
# Install git, hugo, dart
# Clone repo (make public)
# Build site

# FROM nginx:1.30.6-alpine

# Copy files over
# COPY ./public /usr/share/nginx/html


# FROM some base linux distro as BUILD
# Set working directory
# Install git, hugo, dart
# Clone repo (make public)
# Build site

FROM nginx:1.30.6-alpine

# Copy files over
COPY ./public /usr/share/nginx/html


# Use the official Ubuntu base image
FROM ubuntu:latest

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install tmate and a lightweight HTTP server (Nginx)
RUN apt-get update && \
    apt-get install -y tmate nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a directory for serving the HTML page and a directory for logs
RUN mkdir -p /var/www/html /var/log/tmate

# Replace the default Nginx config with a basic one
RUN echo 'server { listen 80; location / { root /var/www/html; try_files $uri $uri/ =404; } }' > /etc/nginx/sites-available/default

# Expose port 80 for the web server
EXPOSE 80

# Start tmate and save session details to a file, while also running Nginx
CMD ["bash", "-c", "tmate -F > /var/www/html/index.html & while true; do cat /var/www/html/index.html; sleep 2; done & nginx -g 'daemon off;'"]

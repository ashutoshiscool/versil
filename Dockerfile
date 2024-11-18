# Use a lightweight Linux base image
FROM debian:bullseye-slim

# Set non-interactive frontend for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install tmate and a simple web server (e.g., busybox)
RUN apt update && apt install -y tmate busybox && apt clean

# Create a working directory
WORKDIR /app

# Script to capture tmate session details and start a web server
RUN echo '#!/bin/bash' > start.sh && \
    echo 'tmate -F > session.log &' >> start.sh && \
    echo 'sleep 5' >> start.sh && \
    echo 'SESSION=$(grep -oP "ssh://.*" session.log | head -n 1)' >> start.sh && \
    echo 'echo "<html><body><h1>Tmate Session:</h1><p>\$SESSION</p></body></html>" > /app/index.html' >> start.sh && \
    echo 'busybox httpd -f -p 8080 -h /app' >> start.sh && \
    chmod +x start.sh

# Expose the port for the web server
EXPOSE 8080

# Run the script
CMD ["bash", "start.sh"]


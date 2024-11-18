# Use a lightweight Linux base image
FROM debian:bullseye-slim

# Set non-interactive frontend for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update system and install dependencies
RUN apt update && apt install -y tmate curl && apt clean

# Working directory
WORKDIR /app

# Script to capture the tmate session and write to an HTML file
RUN echo '#!/bin/bash' > start.sh && \
    echo 'tmate -F > session.log &' >> start.sh && \
    echo 'sleep 5' >> start.sh && \
    echo 'SESSION=$(grep -oP "ssh://.*" session.log | head -n 1)' >> start.sh && \
    echo 'echo "<html><body><h1>Tmate Session:</h1><p>\$SESSION</p></body></html>" > index.html' >> start.sh && \
    echo 'curl -X POST -F "file=@index.html" https://api.netlify.com/api/v1/sites/YOUR_NETLIFY_SITE_ID/deploys -H "Authorization: Bearer YOUR_NETLIFY_ACCESS_TOKEN"' >> start.sh && \
    chmod +x start.sh

# Run the tmate session and publish
CMD ["bash", "start.sh"]

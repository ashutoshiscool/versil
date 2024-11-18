# Use a lightweight Linux base image
FROM debian:bullseye-slim

# Set non-interactive frontend for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install tmate
RUN apt update && apt install -y tmate && apt clean

# Run tmate and output session information
CMD tmate -F

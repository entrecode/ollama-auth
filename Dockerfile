FROM ollama/ollama

# Update and install wget to download caddy
RUN apt-get update && apt-get install -y wget

ENV CADDY_VERSION=2.9.1

# Download and install caddy
RUN wget --no-check-certificate https://github.com/caddyserver/caddy/releases/download/v${CADDY_VERSION}/caddy_${CADDY_VERSION}_linux_amd64.tar.gz \
    && tar -xvf caddy_${CADDY_VERSION}_linux_amd64.tar.gz \
    && mv caddy /usr/bin/ \
    && chown root:root /usr/bin/caddy \
    && chmod 755 /usr/bin/caddy

# Copy the Caddyfile to the container
COPY Caddyfile /etc/caddy/Caddyfile

# Set the environment variable for the ollama host
ENV OLLAMA_HOST 0.0.0.0

# Expose the port that caddy will listen on
EXPOSE 80

# Copy a script to start both ollama and caddy
COPY start_services.sh /start_services.sh
RUN chmod +x /start_services.sh

# Set the entrypoint to the script
ENTRYPOINT ["/start_services.sh"]

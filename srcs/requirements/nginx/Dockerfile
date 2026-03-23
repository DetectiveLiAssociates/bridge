FROM debian:bullseye

# Install NGINX and OpenSSL
RUN apt-get update -y && \
    apt-get install -y nginx openssl

# Create the directory for the SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate the Self-Signed Certificate
# -x509: Create a self-signed cert
# -nodes: Don't encrypt the private key (so Nginx can start without a password)
# -subj: Fill out the certificate info automatically
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=TH/ST=Bangkok/L=Bangkok/O=42/OU=42/CN=sasakuya.42.fr"

# Copy our custom configuration
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# Create the directory for Nginx to run
RUN mkdir -p /var/run/nginx

# Start NGINX in the foreground (daemon off)
# This is critical! If Nginx runs in the background, the container will exit immediately.
CMD ["nginx", "-g", "daemon off;"]

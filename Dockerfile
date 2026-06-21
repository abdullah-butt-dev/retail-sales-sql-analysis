FROM lovasoa/sqlpage:latest
COPY dashboard/ /var/www/

# Set the port using the official environment variable instead of a flag
ENV PORT=7860
ENV SQLPAGE_PORT=7860

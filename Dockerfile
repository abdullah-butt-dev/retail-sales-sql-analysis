FROM lovasoa/sqlpage:latest
COPY dashboard/ /var/www/
CMD ["sqlpage", "-p", "7860"]

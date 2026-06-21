FROM lovasoa/sqlpage:0.44.1
COPY dashboard/ /var/www/
CMD ["sqlpage", "-p", "7860"]

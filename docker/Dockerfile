FROM ubuntu:18.04


RUN apt -y update && apt -y install apache2 && \
echo 'Hello World from Docker!' > /var/www/html/index.html


CMD ["/usr/sbin/apache2ctl", "-D","FOREGROUND"]
EXPOSE 80

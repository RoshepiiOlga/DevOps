FROM ubuntu:18.04

RUN apt -y update && apt -y install apache2 && docker images &&\
  echo 'Hello World from Docker!'


CMD ["/usr/sbin/apache2ctl", "-D","FOREGROUND"]
EXPOSE 80
FROM ubuntu:18.04


RUN apt -y update && apt -y install apache2 && install-plugins.sh && docker-slaves && github-branch-source &&\
echo 'Hello World from Docker!' > /var/www/html/index.html


CMD ["/usr/sbin/apache2ctl", "-D","FOREGROUND"]
EXPOSE 80

#docker build -t dockerolga:test .
#docker images
#docker run -p 49160:7070 miltonc/dockerwebapp
#http://localhost:49160
#https://stackoverflow.com/questions/45140614/jenkins-pipeline-sh-fail-with-cannot-run-program-nohup-on-windows


#docker run -i -t ubuntu /bin/bash
#    echo docker images sudo
#set
#FROM ubuntu:20.04
# sudo docker images
#RUN sudo docker images : grep Ubuntu
#RUN sudo docker build -t testimage:test1 https://github.com/RoshepiiOlga/DevOps/tree/next/jenkinsfiles

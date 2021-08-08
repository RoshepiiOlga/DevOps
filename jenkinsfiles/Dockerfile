
docker build -t myimage:latest -<<EOF
FROM busybox
RUN echo "hello world"
EOF
docker images
docker run -d -p 49160:80 myimage:latest
http://localhost:49160

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

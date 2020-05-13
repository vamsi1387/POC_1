FROM ubuntu

COPY helloworld.sh /opt/

#ENTRYPOINT sh /home/ec2-user/myProjects/POC_1/helloworld.sh

ADD VERSION .

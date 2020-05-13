FROM ubuntu
MAINTAINER Vamsi vamsikrishna_a01@infosys.com
LABEL "rating"="5stars" class="Wow"
USER root
ENV AP /data/app

WORKDIR /home/ec2-user/myProjects/POC_1

ENTRYPOINT ["bash", "/home/ec2-user/myProjects/POC_1/helloworld.sh"]

CMD ["ls","-l"]
ADD VERSION .

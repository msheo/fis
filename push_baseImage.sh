#!/bin/sh
#Creating an Image Stream by Manually Pushing an Image
docker load < tomcat8.5.57_openjdk8.tar
docker tag tomcat:8.5.57-jdk8-openjdk docker-registry.default.svc:5000/fis-jenkins/tomcat:8.5.57-jdk8-openjdk
docker push docker-registry.default.svc:5000/fis-jenkins/tomcat:8.5.57-jdk8-openjdk
oc get is
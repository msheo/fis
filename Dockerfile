FROM tomcat:8.5.57-jdk8-openjdk
#After push base image(push_baseImage.sh), uncomment it
#FROM docker-registry.default.svc:5000/fis-jenkins/jeus8001:open-jdk-1.8.232

LABEL maintainer="minseok.heo@lotte.net" \
      description="TOMCAT Dockerfile for LGL-FIS Pjt."

#Change the HTTP PORT(Default-8080)
ARG HTTP_PORT=8080
#Add Java Options
ENV JAVA_OPTS="-Xms1g -Xmx1g"
#SET LOCALE
ENV LANG=ko_KR.UTF-8
ENV LANGUAGE=ko
ENV LC_ALL=C.UTF-8

#COPY WAR(Change name of something.war to ROOT.war for default context path '/' or change server.xml)
COPY *.war ${CATALINA_HOME}/webapps/
#COPY server.xml ${CATALINA_HOME}/conf/

###################################
###### NEVER CHANGE BELOW #########
###################################
RUN sed -i 's/port="8080"/port="'${HTTP_PORT:-8080}'"/' "${CATALINA_HOME}/conf/server.xml"

EXPOSE ${HTTP_PORT:-8080}

CMD ["catalina.sh", "run"]


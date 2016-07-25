FROM quay.io/jcmoraisjr/jdk:8
RUN apk add --no-cache ttf-dejavu

ARG JENKINS_VER=1.651.3
ARG jenkins_war=http://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VER}/jenkins-war-${JENKINS_VER}.war 
RUN wget -O/jenkins.war ${jenkins_war}\
 && echo "$(wget -qO- ${jenkins_war}.sha1)  /jenkins.war" | sha1sum -sc -

ENV JENKINS_HOME /var/jenkins_home
RUN mkdir -p "$JENKINS_HOME" /home/jenkins /usr/share/jenkins/init.groovy.d\
 && addgroup -g 1000 jenkins\
 && adduser -h "/home/jenkins" -u 1000 -G jenkins -D -s /bin/sh jenkins\
 && chown -R jenkins:jenkins "$JENKINS_HOME" /home/jenkins /usr/share/jenkins

VOLUME "$JENKINS_HOME"

USER jenkins

COPY plugins.sh /
COPY plugins.txt /home/jenkins/
RUN /plugins.sh /home/jenkins/plugins.txt

COPY init.groovy /usr/share/jenkins/init.groovy.d/

COPY jenkins-master.sh /
EXPOSE 8080 50000
ENTRYPOINT ["/jenkins-master.sh"]

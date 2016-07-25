FROM quay.io/jcmoraisjr/jdk:8

ARG swarm_ver=2.1
ARG swarm_jar=http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${swarm_ver}/swarm-client-${swarm_ver}-jar-with-dependencies.jar
RUN wget -O/swarm-client-jar-with-dependencies.jar ${swarm_jar}\
 && echo "$(wget -qO- ${swarm_jar}.sha1)  /swarm-client-jar-with-dependencies.jar" | sha1sum -sc -

ENV rootfs /var/jenkins
RUN mkdir -p "$rootfs" /home/agent\
 && addgroup -g 1000 agent\
 && adduser -h "/home/agent" -u 1000 -G agent -D -s /bin/sh agent\
 && chown -R agent:agent "$rootfs" /home/agent

USER agent

COPY jenkins-agent.sh /
ENTRYPOINT ["/jenkins-agent.sh"]

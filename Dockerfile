FROM jenkins/inbound-agent:latest

USER root

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    software-properties-common \
    openjdk-17-jdk \
    && apt-get clean

RUN curl -fsSL https://get.docker.com | sh

ENV JENKINS_URL=http://jenkins-server:8080
ENV JENKINS_SECRET=6bcd022d165755b7774540f4ddd5f0d2899b283dadb24681c0591b545ac6d128
ENV JENKINS_AGENT_NAME=jenkins-agent

RUN docker --version

COPY target/jenkins_project-0.0.1-SNAPSHOT.jar /app.jar

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER jenkins

ENTRYPOINT ["/entrypoint.sh"]
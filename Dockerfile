FROM jenkins/inbound-agent:latest

USER root

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    software-properties-common \
    openjdk-17-jdk \
    jq \
    && apt-get clean

# Установка Docker
RUN curl -fsSL https://get.docker.com | sh

# Добавляем пользователя jenkins в группу docker
RUN usermod -aG docker jenkins

# Установка docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && chown jenkins:jenkins /usr/local/bin/docker-compose \
    && docker-compose --version

# Убедитесь, что Docker и Docker Compose доступны
RUN docker --version && docker-compose --version

# Добавление /usr/local/bin в PATH для пользователя Jenkins
ENV PATH="/usr/local/bin:${PATH}"

# Настройки Jenkins
ENV JENKINS_URL=http://jenkins-server:8081
ENV JENKINS_SECRET=6bcd022d165755b7774540f4ddd5f0d2899b283dadb24681c0591b545ac6d128
ENV JENKINS_AGENT_NAME=jenkins-agent

# Копирование файла JAR в контейнер
COPY target/jenkins_project-0.0.1-SNAPSHOT.jar /app.jar

# Копирование entrypoint.sh в контейнер и установка прав
COPY entrypoint.sh /entrypoint.sh
RUN chown jenkins:jenkins /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER jenkins

# Установка точки входа
ENTRYPOINT ["/entrypoint.sh"]

FROM jenkins/jenkins:lts

USER root

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    software-properties-common \
    jq \
    && apt-get clean

# Устанавливаем Docker Compose
RUN curl -fsSL https://get.docker.com | sh \
    && curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && docker-compose --version

# Проверяем установку
RUN docker --version && docker-compose --version

USER jenkins

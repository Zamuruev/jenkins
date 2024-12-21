# Используем образ с Maven и OpenJDK 17 для сборки проекта
FROM maven:3.9.5-eclipse-temurin-17 as build

# Установим рабочую директорию для сборки
WORKDIR /build

# Клонируем репозиторий с GitHub (укажите правильный URL вашего репозитория)
RUN git clone https://github.com/Zamuruev/jenkins.git .

FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get install -y maven
USER jenkins

# Собираем проект с Maven (без тестов)
RUN mvn clean package -DskipTests

# Используем минимальный образ с OpenJDK 17 для запуска
FROM openjdk:17-jdk-slim

# Установим рабочую директорию для приложения
WORKDIR /app

# Копируем собранный JAR-файл из предыдущего этапа
COPY --from=build /build/target/*.jar app.jar

# Указываем команду для запуска приложения
CMD ["java", "-jar", "app.jar"]

# Добавляем образ Jenkins-агента с Docker CLI
FROM jenkins/inbound-agent

# Установим Docker CLI в агенте
USER root
RUN apt-get update && apt-get install -y docker.io

# Устанавливаем Git
RUN apt-get update && apt-get install -y git

# Устанавливаем переменные для Jenkins
ENV JENKINS_URL=http://jenkins-server:8080
ENV JENKINS_AGENT_NAME=jenkins-agent

# Копируем рабочие тома и Docker-сокет
VOLUME /var/run/docker.sock:/var/run/docker.sock
VOLUME /home/jenkins/agent

# Указываем точку входа для Jenkins-агента
ENTRYPOINT ["jenkins-agent"]

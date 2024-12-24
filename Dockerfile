# Используем официальный образ OpenJDK для сборки
FROM openjdk:17-jdk-slim as build

# Устанавливаем зависимости для Docker и Maven
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    lsb-release \
    maven \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y docker-ce

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта
COPY . /app/

# Собираем проект (для Maven)
RUN mvn clean install

# Копируем собранный JAR файл
COPY target/jenkins_project-0.0.1-SNAPSHOT.jar /app/jenkins_project.jar

# Открываем порт, на котором будет работать приложение
EXPOSE 8787

# Команда для запуска приложения
CMD ["java", "-jar", "jenkins_project.jar"]

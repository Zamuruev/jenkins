FROM jenkins/jenkins:lts

USER root

# Устанавливаем необходимые пакеты для Docker и Maven
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    lsb-release \
    sudo \
    maven \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/trusted.gpg.d/docker.asc \
    && echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Поменяем пользователя обратно на Jenkins
USER jenkins

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта
COPY . /app/

# Предоставляем права на все файлы в папке /app/target и удаляем каталог target
USER root
RUN chmod -R 777 /app/target && rm -rf /app/target

# Собираем проект с помощью Maven
USER jenkins
RUN mvn clean install -X

# Даем права на папку /app/target
RUN chmod -R 777 /app/target

# Копируем собранный JAR файл в рабочую директорию контейнера
COPY target/jenkins_project-0.0.1-SNAPSHOT.jar /app/jenkins_project.jar

# Открываем порт, на котором будет работать приложение
EXPOSE 8787

# Команда для запуска приложения
CMD ["java", "-jar", "jenkins_project.jar"]

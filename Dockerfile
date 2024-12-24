# Используем официальный образ OpenJDK для запуска Java-приложений
FROM openjdk:17-jdk-slim as build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранный JAR-файл в контейнер
COPY target/app.jar /app/app.jar  # для Maven
# COPY build/libs/app.jar /app/app.jar  # для Gradle

# Открываем порт, на котором будет работать приложение
EXPOSE 8787

# Команда для запуска приложения
CMD ["java", "-jar", "app.jar"]

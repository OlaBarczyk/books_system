# Dockerfile dla usługi backend

# Etap 1: Build
FROM maven:3.8.6-openjdk-11 AS build
WORKDIR /app
COPY ./books_system/pom.xml ./books_system/pom.xml
COPY ./books_system/src ./books_system/src
RUN mvn -f ./books_system/pom.xml clean package

# Etap 2: Run
FROM openjdk:11-jre-slim
VOLUME /tmp
COPY --from=build /app/books_system/target/*.jar app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]

# Dockerfile dla usługi bazy danych

FROM mysql:8.0

ENV MYSQL_DATABASE mydb
ENV MYSQL_USER root
ENV MYSQL_PASSWORD example
ENV MYSQL_ROOT_PASSWORD example  # Hasło dla użytkownika root

COPY ./database/init.sql /docker-entrypoint-initdb.d/init.sql  # Skrypt inicjalizacji (opcjonalny)


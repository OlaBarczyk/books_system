# Używamy obrazu OpenJDK z JRE 21
FROM eclipse-temurin:21-jdk

# Ustawienie katalogu roboczego
WORKDIR /app

# Kopiowanie pliku JAR do kontenera
COPY target/*.jar app.jar

# Eksponowanie portu aplikacji (zmień, jeśli używasz innego)
EXPOSE 8080

# Uruchomienie aplikacji Spring Boot
CMD ["java", "-jar", "app.jar"]

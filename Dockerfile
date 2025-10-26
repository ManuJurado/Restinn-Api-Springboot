# Etapa 1: build Maven
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: runtime con JRE liviano
FROM eclipse-temurin:21-jre
WORKDIR /app

# copiamos el jar ya compilado
COPY --from=build /app/target/*.jar app.jar

# copiamos el .env que compose le va a montar (si corre en docker)
# pero NO lo bakeamos en la imagen final
# (esto lo maneja docker-compose con volumes)

EXPOSE 80
ENTRYPOINT ["java", "-jar", "app.jar"]

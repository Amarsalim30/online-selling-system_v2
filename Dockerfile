# Stage 1: build
FROM maven:3.9.8-eclipse-temurin-21 AS build
WORKDIR /project
COPY mvnw .
COPY .mvn/ .mvn
COPY pom.xml .
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline -B
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: runtime
FROM openjdk:21-slim
WORKDIR /app
COPY --from=build /project/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

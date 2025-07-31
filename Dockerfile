# Build stage with Maven + JDK 21
FROM maven:3.9.8-eclipse-temurin-21 AS build
WORKDIR /project
COPY pom.xml .
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Runtime stage with valid image
FROM openjdk:21-slim
WORKDIR /app
COPY --from=build /project/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

# Stage 1: Build the app
FROM openjdk:20-jdk-slim AS build

WORKDIR /app

# Copy Maven wrapper and project files
COPY mvnw pom.xml ./
COPY .mvn .mvn
COPY src ./src

# Make Maven wrapper executable
RUN chmod +x mvnw

# Build the project and skip tests
RUN ./mvnw clean package -DskipTests

# Stage 2: Run the app
FROM openjdk:20-jdk-slim
WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port (Render provides PORT env variable)
EXPOSE 8080
ENV PORT=8080

# Start Spring Boot app with dynamic port
ENTRYPOINT ["sh", "-c", "java -jar /app/app.jar --server.port=$PORT"]

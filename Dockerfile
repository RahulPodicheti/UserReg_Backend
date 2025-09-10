# Use a stable OpenJDK image
FROM openjdk:20-jdk-slim

# Set working directory
WORKDIR /app

# Copy Maven wrapper and project files
COPY mvnw pom.xml ./
COPY .mvn .mvn
COPY src ./src

# Make Maven wrapper executable
RUN chmod +x mvnw

# Build the project and skip tests
RUN ./mvnw clean package -DskipTests

# Copy the generated JAR
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

# Expose port (Render will provide PORT environment variable)
EXPOSE 8080

# Use Render's dynamic PORT
ENV PORT=8080
ENTRYPOINT ["sh", "-c", "java -jar /app/app.jar --server.port=$PORT"]

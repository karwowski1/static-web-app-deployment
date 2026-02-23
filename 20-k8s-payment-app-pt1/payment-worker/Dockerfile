#Stage 1: Build the application
# To build app from source code .jar
FROM maven:3.9-eclipse-temurin-17-alpine AS builder
WORKDIR /app

# Deterministic build: copy only the files needed to build the application
COPY pom.xml .
# download dependencies
RUN mvn dependency:go-offline
# copy source code
COPY src ./src
# build the application
RUN mvn clean package -DskipTests


#Stage 2: Run the application
FROM eclipse-temurin:17-alpine
WORKDIR /app
#Non-root user for security & reduce attack surface
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# copy the built jar file from the build stage
COPY --from=builder /app/target/*.jar app.jar
#expose the port the application will run on
EXPOSE 8080
# switch to non-root user
USER appuser

# start command. Entrypoint SIGTERM handling for graceful shutdown
ENTRYPOINT ["java", "-jar", "app.jar"]
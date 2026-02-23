# To build app from source code
FROM maven:3.9-eclipse-temurin-17-alpine AS build
WORKDIR /app

# copy configuration files
COPY pom.xml .
# download dependencies
RUN mvn dependency:go-offline -B

# copy source code
COPY src ./src
# build the application
RUN mvn clean package -DskipTests


# run environment
FROM eclipse-temurin:17-alpine
WORKDIR /app

# copy the built jar file from the build stage
COPY --from=build /app/target/*.jar app.jar

#expose the port the application will run on
EXPOSE 8080

# start command
ENTRYPOINT ["java", "-jar", "app.jar"]


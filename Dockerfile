FROM maven:3.9-eclipse-temurin-17-alpine AS build
COPY . /app
WORKDIR /app
RUN mvn clean package -DskipTests

FROM tomcat:latest
EXPOSE 8080
COPY --from=build /app/target/maven-web-app.war /usr/local/tomcat/webapps/maven-web-app.war

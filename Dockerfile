# Build stage — JDK 8 required: source/target 1.6 and a dead import of an
# internal Nashorn package only resolve under JDK 8's classpath model.
FROM maven:3.6-jdk-8 AS build
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests clean package

# Runtime stage
FROM tomcat:9.0-jdk8
COPY --from=build /build/target/data.war /usr/local/tomcat/webapps/data.war
EXPOSE 8080

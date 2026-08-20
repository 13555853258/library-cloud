FROM maven:3.9.8-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn -pl library-book-service -am package -DskipTests
FROM eclipse-temurin:17-jre
COPY --from=build /app/library-book-service/target/library-book-service-1.0.0.jar /app.jar
ENTRYPOINT ["java","-jar","/app.jar"]


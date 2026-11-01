# build
FROM maven:3.9.6-amazoncorretto-17 AS builder
WORKDIR /build
COPY pom.xml .
COPY src ./src

# make jar file
RUN mvn clean package -DskipTests


# run
FROM amazoncorretto:17-alpine
WORKDIR /opt/app

RUN addgroup -g 1000 appgroup && adduser -D -u 1000 -G appgroup appuser

RUN mkdir -p /opt/app/logs && chown -R appuser:appgroup /opt/app

USER appuser

COPY --from=builder /build/target/api-1.0.0.jar ./app.jar

EXPOSE 8080

# run app
CMD ["java", "-jar", "app.jar"]

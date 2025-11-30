# ====== Build Stage ======

FROM eclipse-temurin:25-jdk AS builder

WORKDIR /app

# Copy gradle files first (caching)
COPY gradlew settings.gradle build.gradle ./
COPY gradle gradle

# Download dependencies (leverages Gradle's dependency caching)
RUN ./gradlew dependencies --no-daemon || true

COPY src src

# Build the actual app
RUN ./gradlew clean bootJar --no-daemon

# ====== Run Stage ======

FROM eclipse-temurin:25-jre

WORKDIR /app

# Copy built JAR file
COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]

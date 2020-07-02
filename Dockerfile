# syntax=docker/dockerfile:experimental
FROM openjdk:8-jdk-alpine as builder
WORKDIR /workspace/app
COPY . /workspace/app
RUN --mount=type=cache,target=/root/.gradle ./gradlew clean build
RUN mkdir -p build/dependency && (cd build/dependency; jar -xf ../libs/*.jar)


FROM openjdk:8-jre-alpine
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
COPY --from=builder /workspace/app/build/dependency/BOOT-INF/lib /app/lib
COPY --from=builder /workspace/app/build/dependency/META-INF /app/META-INF
COPY --from=builder /workspace/app/build/dependency/BOOT-INF/classes /app
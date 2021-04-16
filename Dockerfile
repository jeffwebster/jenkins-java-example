FROM adoptopenjdk/openjdk11:alpine-jre

ARG build_jar_path

COPY ${build_jar_path} /app.jar

CMD ["java", "-jar", "/app.jar"]

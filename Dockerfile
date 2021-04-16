FROM adoptopenjdk/openjdk11:alpine-jre

ARG build_jar_name

COPY ./target/${build_jar_name} /app.jar

CMD ["java", "-jar", "/app.jar"]

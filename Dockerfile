FROM java:8-jdk-alpine
VOLUME /target
ADD target/app.jar application.jar
EXPOSE 8080:8080
ENTRYPOINT ["java","-jar","application.jar"]

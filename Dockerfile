FROM eclipse-temurin:17-jdk AS builder

# Usa a imagem oficial OpenJDK 17 (versão leve)
# Etapa 1: Build
FROM maven:3.9.6-eclipse-temurin-17 AS builder


# Define a variável de ambiente JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/
java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"


# Comando para rodar a aplicação Spring Boot
CMD ["java", "-jar", "app.jar"]

WORKDIR /app

COPY .mvn/ .mvn
COPY mvnw pom.xml ./
COPY src ./src
COPY target/desmeta-0.0.1-SNAPSHOP.jar app.jar

RUN chmod +x mvnw && ./mvnw clean package -DskipTests

FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]

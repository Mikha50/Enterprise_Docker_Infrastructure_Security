# المرحلة 1: بناء كود الجافا وفك الضغط
FROM maven:3.9.6-eclipse-temurin-11 AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends git
RUN git clone https://github.com/devopshydclub/vprofile-project.git . && \
    git checkout docker && \
    mvn install -DskipTests

# فك ضغط ملف الـ war هنا في مرحلة البناء حيث يتوفر أمر jar
RUN mkdir -p /app/ROOT && \
    cd /app/ROOT && \
    jar -xf /app/target/vprofile-v2.war

# المرحلة 2: تشغيل التطبيق في Tomcat
FROM tomcat:9.0-jre11-temurin-jammy

LABEL maintainer="DevOps Team"
LABEL project="Enterprise VProfile"

RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -m -s /bin/bash appuser

# تنظيف المجلد ونسخ التطبيق مفكوكاً وجاهزاً للعمل مباشرة
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=builder /app/ROOT /usr/local/tomcat/webapps/ROOT

RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*

RUN chown -R appuser:appgroup /usr/local/tomcat

USER 10001:10001

EXPOSE 8080

HEALTHCHECK --interval=15s --timeout=5s --retries=5 \
  CMD curl -f http://127.0.0.1:8080/ || exit 1

CMD ["catalina.sh", "run"]

FROM nginx:alpine

RUN addgroup -g 10001 appgroup && \
    adduser -u 10001 -G appgroup -s /bin/sh -D appuser

RUN mkdir -p /var/cache/nginx /var/run /var/log/nginx && \
    chown -R appuser:appgroup /var/cache/nginx /var/run /var/log/nginx /etc/nginx

COPY nginx.conf /etc/nginx/nginx.conf
RUN chown -R appuser:appgroup /etc/nginx/nginx.conf

USER 10001:10001

EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:8080/health || exit 1

# تشغيل nginx مباشرة بدون سكريبتات الدخول
ENTRYPOINT ["nginx", "-g", "daemon off;"]

FROM openresty/openresty:1.15.8.1-1-alpine-fat

RUN apk update && apk --no-cache add tini

COPY index.html /app/index.html

RUN rm -rf /etc/nginx/conf.d
COPY nginx.conf /etc/nginx/conf.d/app.conf
COPY run.sh /app/run.sh
# RUN chown -R nobody /etc/nginx /app

# USER nobody
WORKDIR /app/
EXPOSE 80
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/app/run.sh"]
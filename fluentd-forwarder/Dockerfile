FROM fluent/fluentd:v1.12.0-1.0

USER root
RUN apk add --no-cache su-exec
COPY entrypoint.sh /bin/

USER fluent
COPY ${FLUENTD_CONF}.erb /fluentd/etc/
CMD ["fluentd", "-v"]

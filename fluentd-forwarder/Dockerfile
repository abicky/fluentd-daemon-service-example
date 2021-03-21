FROM fluent/fluentd:v1.12.0-1.0

USER root

RUN apk add --no-cache su-exec

COPY fluent.conf.erb /fluentd/etc/fluent.conf.erb
COPY entrypoint.sh /bin/
RUN chown -R fluent /fluentd

USER fluent

CMD ["fluentd", "-c", "/fluentd/etc/fluent.conf", "-v"]

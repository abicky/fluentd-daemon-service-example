FROM fluent/fluentd:v1.12.0-1.0

USER root
RUN fluent-gem install fluent-plugin-flowcounter && \
  rm /usr/lib/ruby/gems/*/cache/*

USER fluent
COPY fluent.conf /fluentd/etc/

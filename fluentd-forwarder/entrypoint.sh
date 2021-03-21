#!/bin/sh

#source vars if file exists
DEFAULT=/etc/default/fluentd

if [ -r $DEFAULT ]; then
    set -o allexport
    . $DEFAULT
    set +o allexport
fi

# If the user has supplied only arguments append them to `fluentd` command
if [ "${1#-}" != "$1" ]; then
    set -- fluentd "$@"
fi

erb /fluentd/etc/${FLUENTD_CONF}.erb > /fluentd/etc/${FLUENTD_CONF}

# If user does not supply config file or plugins, use the default
if [ "$1" = "fluentd" ]; then
    if ! echo $@ | grep ' \-c' ; then
       set -- "$@" -c /fluentd/etc/${FLUENTD_CONF}
    fi

    if ! echo $@ | grep ' \-p' ; then
       set -- "$@" -p /fluentd/plugins
    fi

    if [ $(id -u) -eq 0 ]; then
        # We assume that /var/run/fluentd on the host is mounted into /fluentd/var/run
        # and the ECS agent creates the directory with root:root ownership,
        # so the ownership must be changed to create a unix domain socket.
        chown -R fluent /fluentd/var/run
        set -- su-exec fluent "$@"
    fi
fi

exec "$@"

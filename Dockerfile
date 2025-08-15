FROM madebytimo/base

RUN install-autonomous.sh install ScriptsAdvanced SSHServer \
    && apt update -qq && apt install -y -qq netcat-openbsd \
    && rm -rf /var/lib/apt/lists/* \
    \
    && usermod --password '*' user \
    && mkdir /media/ssh

COPY files/sshd_config-template /opt/ssh-forwarder-server/sshd_config-template
COPY files/healthcheck.sh files/run-sshd.sh /usr/local/bin/

ENV AUTHORIZED_PUBLIC_KEYS=""
ENV HOST_KEY=""
ENV PERMIT_LISTEN=""
ENV PERMIT_OPEN=""

CMD [ "run-sshd.sh" ]

HEALTHCHECK CMD [ "healthcheck.sh" ]

LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/mbt-infrastructure/docker-ssh-forwarder-server"

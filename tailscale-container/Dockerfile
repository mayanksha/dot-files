FROM tailscale/tailscale:latest

RUN apk add --no-cache \
      bash \
      zsh \
      openssh-client \
      openssh-keygen \
      netcat-openbsd \
      curl \
      ca-certificates \
      iputils \
      bind-tools \
      mtr \
      tcpdump \
      vim \
      git \
      jq

RUN mkdir -p /etc/skel/.ssh && \
    printf '%s\n' \
        'Host 100.* *.ts.net' \
        '  ProxyCommand nc -X 5 -x localhost:1055 %h %p' \
        '  StrictHostKeyChecking accept-new' \
        '  UserKnownHostsFile /root/.ssh/known_hosts' \
        '  ServerAliveInterval 30' \
        '  ServerAliveCountMax 3' \
        > /etc/skel/.ssh/config && \
    chmod 700 /etc/skel/.ssh && \
    chmod 600 /etc/skel/.ssh/config

COPY entrypoint.sh /usr/local/bin/ts-warp-entrypoint.sh
RUN chmod +x /usr/local/bin/ts-warp-entrypoint.sh

ENV SHELL=/bin/bash

ENTRYPOINT ["/usr/local/bin/ts-warp-entrypoint.sh"]

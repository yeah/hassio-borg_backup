ARG BUILD_FROM=homeassistant/amd64-base:latest
FROM $BUILD_FROM
ENV LANG C.UTF-8

RUN apk add --no-cache --update \
          borgbackup \
          openssh-client \
          openssh-keygen

WORKDIR /

RUN ssh-keygen -q -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "hassio"

COPY start.sh /app/start.sh
RUN chmod a+x /app/start.sh
ENTRYPOINT ["/app/start.sh"]

LABEL io.hass.version="VERSION" io.hass.type="addon" io.hass.arch="armhf|aarch64|i386|amd64"

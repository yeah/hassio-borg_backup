ARG BUILD_FROM
FROM $BUILD_FROM
ENV LANG C.UTF-8

RUN apk add --no-cache --update \
        openssh-client \
        openssh-keygen \
        libacl \
        acl-dev \
        libffi \
        musl \
        openssl \
        g++ \
        libffi-dev \
        musl-dev \
        openssl-dev \
 && pip3 install cython borgbackup


WORKDIR /

RUN ssh-keygen -q -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "hassio"

COPY start.sh /app/start.sh
RUN chmod a+x /app/start.sh
ENTRYPOINT ["/app/start.sh"]

LABEL io.hass.version="VERSION" io.hass.type="addon" io.hass.arch="armhf|aarch64|i386|amd64|armv7"

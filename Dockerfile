ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache --update \
        openssh-keygen
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

RUN ssh-keygen -q -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "hassio"

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

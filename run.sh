#!/usr/bin/env bashio
BORG_REPO=$(bashio::config 'repo')
BORG_PASSPHRASE=$(bashio::config 'passphrase')

PUBLIC_KEY=`cat ~/.ssh/id_ed25519.pub`

bashio::log.info "Please use this public key on the server: ${PUBLIC_KEY}"

bashio::log.info "repo: ${BORG_REPO}"
bashio::log.info "passphrase: ${BORG_PASSPHRASE}"

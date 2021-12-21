#!/usr/bin/env bashio
export BORG_REPO="ssh://$(bashio::config 'user')@$(bashio::config 'host'):$(bashio::config 'port')/$(bashio::config 'path')"
export BORG_PASSPHRASE="$(bashio::config 'passphrase')"
export BORG_BASE_DIR="/data"
export BORG_RSH="ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/data/known_hosts"

PUBLIC_KEY=`cat ~/.ssh/id_ed25519.pub`

bashio::log.info "A public/private key pair was generated for you."
bashio::log.notice "Please use this public key on the backup server:"
bashio::log.notice "${PUBLIC_KEY}"

if [ ! -f /data/known_hosts ]; then
   bashio::log.info "Running for the first time, acquiring host key and storing it in /data/known_hosts."
   ssh-keyscan -p $(bashio::config 'port') "$(bashio::config 'host')" > /data/known_hosts \
     || bashio::exit.nok "Could not acquire host key from backup server."
fi

bashio::log.info 'Trying to initialize the Borg repository.'
/usr/bin/borg init -e repokey || true

if [ "$(date +%u)" = 7 ]; then
  bashio::log.info 'Checking archive integrity. (Today is Sunday.)'
  /usr/bin/borg check \
    || bashio::exit.nok "Could not check archive integrity."
fi

bashio::log.info 'Uploading backup.'
/usr/bin/borg create "::$(bashio::config 'archive')-{utcnow}" /backup \
  || bashio::exit.nok "Could not upload backup."

bashio::log.info 'Pruning old backups.'
/usr/bin/borg prune --list -P $(bashio::config 'archive') $(bashio::config 'prune_options') \
  || bashio::exit.nok "Could not prune backups."

local_snapshot_config=$(bashio::config 'local_snapshot')
local_snapshot=$((local_snapshot_config + 1))

if [ $local_snapshot -gt 1 ]; then
  bashio::log.info 'Cleaning old snapshots.'
  cd /backup
  ls -tp | grep -v '/$' | tail -n +$local_snapshot | tr '\n' '\0' | xargs -0 rm --
fi

bashio::log.info 'Finished.'
bashio::exit.ok

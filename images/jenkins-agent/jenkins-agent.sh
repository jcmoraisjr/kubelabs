#!/bin/sh
set -e

if [ $# -ne 0 ]; then
  exec "$@"
  exit 0
fi

die() { echo $*; exit 1; }
[ -n "${MASTER_HOST}" ] || die "\$MASTER_HOST wasn't defined"
[ -n "${DISCOVERY_HOST}" ] || die "\$DISCOVERY_HOST wasn't defined"

MASTER_PORT=${MASTER_PORT:-80}
DISCOVERY_PORT=${DISCOVERY_PORT:-50000}

AGENT_NAME=${AGENT_NAME:-linux}
AGENT_EXECUTORS=${AGENT_EXECUTORS:-1}
AGENT_LABELS=${AGENT_LABELS:-linux x86_64}

exec java \
 -jar /swarm-client-jar-with-dependencies.jar \
 -fsroot "$rootfs" \
 -name "$AGENT_NAME" \
 -master "http://${MASTER_HOST}:${MASTER_PORT}" \
 -tunnel "${DISCOVERY_HOST}:${DISCOVERY_PORT}" \
 -executors "$AGENT_EXECUTORS" \
 -labels "$AGENT_LABELS"

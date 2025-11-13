#!/usr/bin/env bash
set -euo pipefail

PAIRING_CODE="${PORTACODE_PAIRING_CODE:-}"
if [[ -z "${PAIRING_CODE}" ]]; then
  echo "PORTACODE_PAIRING_CODE environment variable must be set."
  exit 1
fi

# Derive a friendly suffix from container hostname (e.g., workshop-device-3 -> 3)
HOST_LABEL="${HOSTNAME:-device}"
if [[ "${HOST_LABEL}" == *-* ]]; then
  HOST_SUFFIX="${HOST_LABEL##*-}"
else
  HOST_SUFFIX="${HOST_LABEL:0:6}"
fi

if [[ -n "${PORTACODE_DEVICE_NAME:-}" ]]; then
  DEVICE_NAME="${PORTACODE_DEVICE_NAME}-${HOST_SUFFIX}"
else
  DEVICE_NAME="Workshop-Device-${HOST_SUFFIX}"
fi

export PORTACODE_DEVICE_NAME="${DEVICE_NAME}"
export PORTACODE_PAIRING_CODE="${PAIRING_CODE}"

mkdir -p /home/student/workspace /home/student/.portacode /home/student/logs
chown -R student:student /home/student/workspace /home/student/.portacode /home/student/logs

LOG_FILE="/home/student/logs/portacode.log"
touch "${LOG_FILE}"
chown student:student "${LOG_FILE}"

echo "[entrypoint] Starting device ${DEVICE_NAME}" | tee -a "${LOG_FILE}"

exec sudo -E -H -u student bash -c "cd /home/student && portacode connect --non-interactive --debug >> ${LOG_FILE} 2>&1"

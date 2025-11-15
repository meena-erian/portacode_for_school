#!/usr/bin/env bash
set -euo pipefail

PAIRING_CODE="${PORTACODE_PAIRING_CODE:-}"
if [[ -z "${PAIRING_CODE}" ]]; then
  echo "PORTACODE_PAIRING_CODE environment variable must be set."
  exit 1
fi

HOST_LABEL="${HOSTNAME:-device}"
if [[ "${HOST_LABEL}" == *-* ]]; then
  HOST_SUFFIX="${HOST_LABEL##*-}"
else
  HOST_SUFFIX="${HOST_LABEL:0:6}"
fi

if [[ -n "${PORTACODE_DEVICE_NAME:-}" ]]; then
  DEVICE_NAME="${PORTACODE_DEVICE_NAME}"
elif [[ -n "${PORTACODE_DEVICE_PREFIX:-}" ]]; then
  DEVICE_NAME="${PORTACODE_DEVICE_PREFIX}-${HOST_SUFFIX}"
else
  DEVICE_NAME="Workshop-Device-${HOST_SUFFIX}"
fi

PROJECT_PATHS_RAW="${PORTACODE_PROJECT_PATHS:-}"
PROJECT_PATHS=()
if [[ -n "${PROJECT_PATHS_RAW}" ]]; then
  IFS=':' read -r -a PROJECT_PATHS_CANDIDATES <<< "${PROJECT_PATHS_RAW}"
  for path in "${PROJECT_PATHS_CANDIDATES[@]}"; do
    if [[ -n "${path}" ]]; then
      PROJECT_PATHS+=("${path}")
    fi
  done
fi
if [[ ${#PROJECT_PATHS[@]} -eq 0 ]]; then
  PROJECT_PATHS=("/home/student/workspace")
fi

export PORTACODE_DEVICE_NAME="${DEVICE_NAME}"
export PORTACODE_PAIRING_CODE="${PAIRING_CODE}"

mkdir -p /home/student/workspace /home/student/.portacode /home/student/logs /home/student/.local/share/portacode/run
chown -R student:student /home/student/workspace /home/student/.portacode /home/student/logs /home/student/.local/share/portacode

# Clean up stale runtime pid files that can be left around when the container
# is stopped forcefully; otherwise the CLI kills itself on restart because the
# persisted PID value matches the current process.
PID_FILE="/home/student/.local/share/portacode/run/gateway.pid"
if [[ -f "${PID_FILE}" ]]; then
  echo "[entrypoint] removing stale portacode pid file: ${PID_FILE}"
  rm -f "${PID_FILE}"
fi

LOG_FILE="/home/student/logs/portacode.log"
touch "${LOG_FILE}"
chown student:student "${LOG_FILE}"

echo "[entrypoint] Starting device ${DEVICE_NAME}" | tee -a "${LOG_FILE}"
for path in "${PROJECT_PATHS[@]}"; do
  echo "[entrypoint] registering project path: ${path}" | tee -a "${LOG_FILE}"
done

CONNECT_CMD="portacode connect --non-interactive --debug"
for path in "${PROJECT_PATHS[@]}"; do
  CONNECT_CMD+=" --project-path $(printf '%q' "${path}")"
done

exec sudo -E -H -u student bash -c "cd /home/student && ${CONNECT_CMD} >> ${LOG_FILE} 2>&1"

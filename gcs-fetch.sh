#!/bin/bash
set -e

echo "[InitContainer] Checking GCS_PATH: $GCS_PATH"
if [[ -z "$GCS_PATH" ]]; then
  echo "[InitContainer] GCS_PATH is empty. Skipping copy."
else
  echo "[InitContainer] GCS_PATH is not empty: $GCS_PATH"
  IFS=',' read -ra PATHS <<< "$GCS_PATH"
  for path in "${PATHS[@]}"; do
    echo "[InitContainer] Copying from $path"
    gsutil -m cp -r "${path}*" /home/jovyan/work/
  done
fi

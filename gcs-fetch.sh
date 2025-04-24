#!/bin/bash
set -e

echo "[InitContainer] Checking GCS_PATH: $GCS_PATH"
if [[ -z "$GCS_PATH" ]]; then
  echo "[InitContainer] GCS_PATH is empty. Skipping copy."
else
  echo "[InitContainer] GCS_PATH is not empty: $GCS_PATH"
  IFS=',' read -ra PATHS <<< "$GCS_PATH"
  for path in "${PATHS[@]}"; do
    echo "[InitContainer] Processing path: $path"

    # Get list of all matching files
    FILE_LIST=$(gsutil ls "$path" || true)

    for file in $FILE_LIST; do
      # Skip directories
      if [[ "$file" == */ ]]; then
        continue
      fi

      # Remove 'gs://'
      FILE_WITHOUT_GS=${file#gs://}

      # Remove bucket name
      FILE_PATH_WITHIN_BUCKET=${FILE_WITHOUT_GS#*/}  # e.g., project/1/2/3.jpg

      # Split by '/'
      IFS='/' read -ra PARTS <<< "$FILE_PATH_WITHIN_BUCKET"
      TOP_LEVEL="${PARTS[0]}"            # e.g., project
      FILE_NAME="${PARTS[-1]}"           # e.g., 3.jpg

      TARGET_DIR="/home/jovyan/work/$TOP_LEVEL"
      TARGET_PATH="$TARGET_DIR/$FILE_NAME"

      echo "[InitContainer] Copying $file to $TARGET_PATH"
      mkdir -p "$TARGET_DIR"
      gsutil cp "$file" "$TARGET_PATH"
    done
  done
fi
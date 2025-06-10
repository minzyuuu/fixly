#!/data/data/com.termux/files/usr/bin/bash

cd ~/fixly  

last_checksum=""

while true; do
  new_checksum=$(find . -type f ! -path "./.git/*" -exec md5sum {} + | md5sum)

  if [ "$new_checksum" != "$last_checksum" ]; then
    echo "[+] Change detected. Pushing to GitHub..."

    # Get list of changed files (relative paths)
    changed_files=$(git status --porcelain | awk '{print $2}' | xargs)

    # Commit message with file list and timestamp
    commit_message="Auto push: $(date '+%Y-%m-%d %H:%M:%S')"$'\n'"Changed: $changed_files"

    git add .
    git commit -m "$commit_message" && git push origin main

    last_checksum="$new_checksum"
  fi

  sleep 10
done

#!/bin/bash
LOG_FILE="$PWD/repo_private.log"
GITHUB_TOKEN="" >> "$LOG_FILE"

REPOS_URL="https://api.github.com/user/repos?per_page=100"

REPOS=$(curl -H "Authorization: token $GITHUB_TOKEN" $REPOS_URL | jq -r '.[].name')

for REPO in $REPOS; do
    echo "Making repository $REPO private..."
    curl -X PATCH -H "Authorization: token $GITHUB_TOKEN" \
         -H "Accept: application/vnd.github.v3+json" \
         https://api.github.com/repos/tanujarora100/$REPO \
         -d '{"private": true}'
    echo "Repository $REPO made private." >> "$LOG_FILE"
done

echo "All repositories have been made private." >> "$LOG_FILE"


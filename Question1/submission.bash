#!/bin/bash

SUBMISSION="./submissions"
BACKUP="./unique_backups"
REPORT="./report.txt"
ERROR="./error_log.txt"

PROCESSED=0
DUPLICATED=0
BACKED=0

mkdir -p "$BACKUP" 2>> "$ERROR"

declare -A SEEN_HASHES

for file in "$SUBMISSION"/*; do
    if [[ -f "$file" ]]; then
        ((PROCESSED++))
        
        hash=$(md5sum "$file" 2>> "$ERROR" | awk '{print $1}')
        
        if [[ -n "${SEEN_HASHES[$hash]}" ]]; then
            ((DUPLICATED++))
        else
            SEEN_HASHES[$hash]=1
            cp "$file" "$BACKUP/" 2>> "$ERROR"
            ((BACKED++))
        fi
    fi
done

{
    echo "Submission Report"
    echo "Total files processed =  $PROCESSED"
    echo "Duplicate files skipped = $DUPLICATED"
    echo "Unique files backed up = $BACKED"
} > "$REPORT" 2>> "$ERROR"

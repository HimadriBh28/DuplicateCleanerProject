#!/bin/bash
source utils.sh

MODE="$1"          # delete / archive
LOGFILE="$2"       # log containing duplicates
ARCHIVE_DIR="duplicate_archive"
ACTION_LOG="cleanup_$(date +%Y-%m-%d_%H-%M-%S).log"

mkdir -p "$ARCHIVE_DIR"

info "Cleaning duplicates using mode: $MODE"

SPACE_SAVED=0

# Read duplicate file paths
while IFS= read -r line; do
    FILE_PATH=$(echo "$line" | awk '{for(i=2;i<=NF;i++) printf $i " "; print ""}')
    FILE_PATH=$(echo "$FILE_PATH" | xargs) # remove spaces

    if [[ -f "$FILE_PATH" ]]; then
        FILE_SIZE=$(stat -c "%s" "$FILE_PATH")
        
        if [[ "$MODE" == "delete" ]]; then
            rm "$FILE_PATH"
            echo "Deleted: $FILE_PATH" >> "$ACTION_LOG"
            SPACE_SAVED=$((SPACE_SAVED + FILE_SIZE))
        
        elif [[ "$MODE" == "archive" ]]; then
            mv "$FILE_PATH" "$ARCHIVE_DIR/"
            echo "Archived: $FILE_PATH" >> "$ACTION_LOG"
            SPACE_SAVED=$((SPACE_SAVED + FILE_SIZE))
        fi
    fi
done < "$LOGFILE"

info "Cleanup completed"
success "Space Saved: $((SPACE_SAVED / 1024 / 1024)) MB"
success "Cleanup Log: $ACTION_LOG"


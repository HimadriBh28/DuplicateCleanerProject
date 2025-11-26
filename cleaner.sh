#!/bin/bash
source utils.sh

MODE="$1"          # delete / archive
LOGFILE="$2"       # duplicates_found.txt
ARCHIVE_DIR="duplicate_archive"
ACTION_LOG="cleanup_$(date +%Y-%m-%d_%H-%M-%S).log"

mkdir -p "$ARCHIVE_DIR"

if [[ ! -f "$LOGFILE" ]] || [[ ! -s "$LOGFILE" ]]; then
    error "No duplicates log file found!"
    exit 1
fi

info "Cleaning duplicates using mode: $MODE"

SPACE_SAVED=0

while IFS= read -r FILE_PATH; do
    FILE_PATH=$(echo "$FILE_PATH" | xargs)  # trim spaces
    if [[ -f "$FILE_PATH" ]]; then
        FILE_SIZE=$(stat -f "%z" "$FILE_PATH")
        if [[ "$MODE" == "delete" ]]; then
            rm "$FILE_PATH"
            echo "Deleted: $FILE_PATH" >> "$ACTION_LOG"
        elif [[ "$MODE" == "archive" ]]; then
            mv "$FILE_PATH" "$ARCHIVE_DIR/"
            echo "Archived: $FILE_PATH" >> "$ACTION_LOG"
        fi
        SPACE_SAVED=$((SPACE_SAVED + FILE_SIZE))
    fi
done < "$LOGFILE"

info "Cleanup completed"
success "Space Saved: $((SPACE_SAVED / 1024 / 1024)) MB"
success "Cleanup Log: $ACTION_LOG"


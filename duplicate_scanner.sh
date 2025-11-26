#!/bin/bash
source utils.sh

DIR="$1"
LOG_FILE="$2"
DUP_LOG="duplicates_found.txt"

if [[ -z "$DIR" ]]; then
    error "No directory provided!"
    exit 1
fi

if [[ ! -d "$DIR" ]]; then
    error "Directory does not exist!"
    exit 1
fi

info "Scanning directory: $DIR"

# Clear duplicates log
> "$DUP_LOG"

# Temporary file to store hashes
TMPFILE=$(mktemp)

# Compute md5 hash for all files
find "$DIR" -type f -print0 | while IFS= read -r -d '' file; do
    hash=$(md5 -q "$file")  # macOS compatible
    echo "$hash|$file" >> "$TMPFILE"
done

# Find duplicates
cut -d'|' -f1 "$TMPFILE" | sort | uniq -d | while read dup_hash; do
    grep "^$dup_hash|" "$TMPFILE" | cut -d'|' -f2- >> "$DUP_LOG"
done

rm "$TMPFILE"

success "Scan Complete → Stored in: $DUP_LOG"
if [[ -n "$LOG_FILE" ]]; then
    success "Scan Finished → Log: $LOG_FILE"
fi


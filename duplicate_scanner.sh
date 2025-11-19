#!/bin/bash
source utils.sh

DIR="$1"
LOG="$2"

info "Scanning directory: $DIR"
find "$DIR" -type f -print0 | while IFS= read -r -d '' file; do
    md5sum "$file"
done | sort | awk '
{
    if ($1 == prev) {
        print $0 "\n" prev_line >> "'$LOG'"
    }
    prev=$1
    prev_line=$0
}
'

success "Scan Complete → Stored in: $LOG"

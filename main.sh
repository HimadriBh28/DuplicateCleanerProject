#!/bin/bash
source utils.sh

SCAN_LOG="scan_$(date +%Y-%m-%d_%H-%M-%S).log"

# Step 1: Ask for directory
read -p "Enter directory to scan: " DIR
if [[ ! -d "$DIR" ]]; then
    error "Invalid directory!"
    exit 1
fi

# Step 2: Show menu
echo ""
info "Choose Mode:"
echo "1) Safe Mode (Report Only)"
echo "2) Delete Duplicates"
echo "3) Archive Duplicates"
read -p "Enter choice: " CHOICE

# Step 3: Map choice to mode
case "$CHOICE" in
    1) MODE="safe" ;;
    2) MODE="delete" ;;
    3) MODE="archive" ;;
    *) error "Invalid choice!"; exit 1 ;;
esac

# Step 4: Run scanner
info "Starting scan..."
bash duplicate_scanner.sh "$DIR" "$SCAN_LOG"

DUP_LOG="duplicates_found.txt"

if [[ ! -f "$DUP_LOG" ]] || [[ ! -s "$DUP_LOG" ]]; then
    warn_msg "No duplicates found!"
else
    if [[ "$MODE" == "safe" ]]; then
        info "Safe mode: No cleaning performed. Duplicates found:"
        cat "$DUP_LOG"
    else
        info "Cleaning duplicates..."
        ./cleaner.sh "$MODE" "$DUP_LOG"
    fi
fi

success "All tasks completed!"


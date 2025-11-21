#!/bin/bash
source utils.sh

SCAN_LOG="scan_$(date +%Y-%m-%d_%H-%M-%S).log"

echo "Enter directory to scan:"
read DIR

if [[ ! -d "$DIR" ]]; then
    error "Invalid directory!"
    exit 1
fi

echo ""
info "Choose Mode:"
echo "1) Safe Mode (Report Only)"
echo "2) Delete Duplicates"
echo "3) Archive Duplicates"
read -p "Enter choice: " CHOICE

case $CHOICE in
    1) MODE="safe" ;;
    2) MODE="delete" ;;
    3) MODE="archive" ;;
    *)
        error "Invalid mode!"
        exit 1
        ;;
esac

info "Starting scan..."
bash scanner.sh "$DIR" "$SCAN_LOG"

success "Scan Finished → Log: $SCAN_LOG"

if [[ "$MODE" == "safe" ]]; then
    info "Safe mode: No cleaning performed"
    exit 0
fi

info "Cleaning duplicates..."
bash cleaner.sh "$MODE" "$SCAN_LOG"

success "All tasks completed!"


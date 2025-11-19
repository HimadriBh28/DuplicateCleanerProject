#!/bin/bash
source "./utils.sh"
source "./duplicate_scanner.sh"
source "./duplicate_cleaner.sh"

while true; do
    clear
    fancy_header "Duplicate File Cleaner System"

    echo "1) Scan for duplicates (Person A)"
    echo "2) Clean duplicates (Person B)"
    echo "3) Exit"
    read -p "Enter choice: " CH

    case $CH in
        1) scan_duplicates ;;
        2) clean_duplicates ;;
        3) exit ;;
        *) warn_msg "Invalid choice" ;;
    esac
done

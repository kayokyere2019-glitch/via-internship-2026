#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# @title       Task5_crud_app.sh
# @author      Kwaku Asare Okyere
# @index       <7361823>
# @school      Kwame Nkrumah University of Science and Technology (KNUST)
# @description Terminal Phonebook CRUD console application storing contacts in a CSV
#              file with automated backups, input validation, and search options.
# @date        2026-09-13
# -----------------------------------------------------------------------------

DATA_FILE="phonebook_data.csv"
BACKUP_FILE="phonebook_data.csv.bak"

# Ensure data file exists with header
if [[ ! -f "$DATA_FILE" ]]; then
    echo "ID,Name,Phone,Email" > "$DATA_FILE"
fi

# Usage guide function
usage() {
    echo "Usage: $0 [-h|--help]"
    echo "  Runs an interactive, menu-driven Phonebook CRUD console application."
    exit 1
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

# Function to create a backup prior to destructive actions
backup_data() {
    cp "$DATA_FILE" "$BACKUP_FILE" 2>/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to create backup file '$BACKUP_FILE'." >&2
        return 1
    fi
}

# 1. CREATE Operation: Add Contact
add_contact() {
    echo ""
    echo "--- ADD NEW CONTACT ---"
    
    # Generate auto-incrementing ID
    local last_id
    last_id=$(awk -F',' 'NR>1 {print $1}' "$DATA_FILE" | sort -n | tail -n 1)
    if [[ -z "$last_id" ]]; then
        local new_id=1
    else
        local new_id=$((last_id + 1))
    fi

    read -rp "Enter Name: " name
    read -rp "Enter Phone Number: " phone
    read -rp "Enter Email: " email

    # Input validation: reject empty fields
    if [[ -z "$name" || -z "$phone" || -z "$email" ]]; then
        echo "Error: All fields (Name, Phone, Email) are required. Operation aborted." >&2
        return 1
    fi

    # Append to CSV
    echo "${new_id},${name},${phone},${email}" >> "$DATA_FILE"
    if [[ $? -eq 0 ]]; then
        echo "[SUCCESS] Contact added with ID: ${new_id}"
    else
        echo "Error: Failed to save contact." >&2
    fi
}

# 2. READ Operation: View/List All Contacts
list_contacts() {
    echo ""
    echo "--- PHONEBOOK CONTACTS ---"
    if [[ $(wc -l < "$DATA_FILE") -le 1 ]]; then
        echo "No contacts found in phonebook."
        return 0
    fi

    column -s',' -t "$DATA_FILE"
}

# 3. SEARCH Operation: Search by Name, Phone, or Email
search_contacts() {
    echo ""
    echo "--- SEARCH CONTACTS ---"
    read -rp "Enter search query: " query

    if [[ -z "$query" ]]; then
        echo "Error: Search query cannot be empty." >&2
        return 1
    fi

    local results
    results=$(grep -i "$query" "$DATA_FILE")

    if [[ -n "$results" ]]; then
        echo ""
        echo "Matching Records:"
        echo "-----------------"
        head -n 1 "$DATA_FILE" | column -s',' -t
        echo "$results" | column -s',' -t
    else
        echo "No contacts found matching '$query'."
    fi
}

# 4. UPDATE Operation: Modify Existing Contact
update_contact() {
    echo ""
    echo "--- UPDATE CONTACT ---"
    read -rp "Enter Contact ID to update: " target_id

    if [[ -z "$target_id" ]]; then
        echo "Error: Contact ID cannot be empty." >&2
        return 1
    fi

    # Handle record not found
    if ! grep -q "^${target_id}," "$DATA_FILE"; then
        echo "Error: Record with ID '${target_id}' not found." >&2
        return 1
    fi

    # Display current contact details
    echo "Current Record:"
    grep "^${target_id}," "$DATA_FILE" | column -s',' -t

    read -rp "Enter New Name: " new_name
    read -rp "Enter New Phone: " new_phone
    read -rp "Enter New Email: " new_email

    if [[ -z "$new_name" || -z "$new_phone" || -z "$new_email" ]]; then
        echo "Error: Fields cannot be empty. Update cancelled." >&2
        return 1
    fi

    # Create backup before destructive operation
    backup_data || return 1

    # Perform update using temporary file
    local temp_file
    temp_file=$(mktemp)
    
    awk -F',' -v id="$target_id" -v name="$new_name" -v phone="$new_phone" -v email="$new_email" '
        BEGIN {OFS=","}
        $1 == id {$2=name; $3=phone; $4=email}
        {print $0}
    ' "$DATA_FILE" > "$temp_file"

    mv "$temp_file" "$DATA_FILE"
    echo "[SUCCESS] Contact ID '${target_id}' updated successfully (Backup saved to ${BACKUP_FILE})."
}

# 5. DELETE Operation: Remove Contact
delete_contact() {
    echo ""
    echo "--- DELETE CONTACT ---"
    read -rp "Enter Contact ID to delete: " target_id

    if [[ -z "$target_id" ]]; then
        echo "Error: Contact ID cannot be empty." >&2
        return 1
    fi

    # Handle record not found
    if ! grep -q "^${target_id}," "$DATA_FILE"; then
        echo "Error: Record with ID '${target_id}' not found." >&2
        return 1
    fi

    # Show record and request confirmation
    echo "Record to delete:"
    grep "^${target_id}," "$DATA_FILE" | column -s',' -t
    read -rp "Are you sure you want to delete this contact? (y/N): " confirm

    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "[INFO] Deletion cancelled."
        return 0
    fi

    # Create backup before destructive operation
    backup_data || return 1

    # Remove record
    local temp_file
    temp_file=$(mktemp)

    grep -v "^${target_id}," "$DATA_FILE" > "$temp_file"
    mv "$temp_file" "$DATA_FILE"

    echo "[SUCCESS] Contact ID '${target_id}' deleted successfully (Backup saved to ${BACKUP_FILE})."
}

# Main Application Menu Loop (while + case)
while true; do
    echo ""
    echo "=========================================="
    echo "       PHONEBOOK MANAGEMENT SYSTEM        "
    echo "=========================================="
    echo "1. Add Contact"
    echo "2. View/List All Contacts"
    echo "3. Search Contact"
    echo "4. Update Contact"
    echo "5. Delete Contact"
    echo "6. Exit"
    echo "=========================================="
    read -rp "Select an option [1-6]: " choice

    case "$choice" in
        1) add_contact ;;
        2) list_contacts ;;
        3) search_contacts ;;
        4) update_contact ;;
        5) delete_contact ;;
        6)
            echo "Exiting Phonebook Application. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose a number between 1 and 6." >&2
            ;;
    esac
done

#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# @title       Task2_permissions_sudo.sh
# @author      Kwaku Asare Okyere
# @index       <7361823>
# @school      Kwame Nkrumah University of Science and Technology (KNUST)
# @description Inspects file permissions in symbolic and numeric formats, applies
#              chmod updates, and checks root privileges (id -u) for chown execution.
# @date        2026-09-12
# -----------------------------------------------------------------------------

# Usage guide function
usage() {
    echo "Usage: $0 <file-path>"
    echo "  <file-path>  Path to the target file whose permissions will be checked and modified."
    exit 1
}

# 0. Check arguments and input validation
if [[ "$1" == "-h" || "$1" == "--help" || -z "$1" ]]; then
    usage
fi

FILE_PATH="$1"

if [[ ! -f "$FILE_PATH" ]]; then
    echo "Error: File '$FILE_PATH' does not exist or is not a regular file." >&2
    exit 1
fi

# Function to report permissions in symbolic and numeric forms
display_permissions() {
    local target="$1"
    local symbolic
    local numeric
    local owner
    local group

    symbolic=$(stat -c "%A" "$target")
    numeric=$(stat -c "%a" "$target")
    owner=$(stat -c "%U" "$target")
    group=$(stat -c "%G" "$target")

    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to fetch permissions for '$target'." >&2
        return 1
    fi

    echo "  - Path: $target"
    echo "  - Symbolic Permissions: $symbolic"
    echo "  - Numeric Permissions: $numeric"
    echo "  - Owner: $owner"
    echo "  - Group: $group"
}

# 1. Report initial permissions
echo "[INFO] Initial File Permissions:"
display_permissions "$FILE_PATH" || exit 1
echo "---------------------------------------------------"

# 2. Change permissions using both numeric and symbolic syntax
echo "[INFO] Applying permission changes..."

# Step 2a: Numeric demonstration (chmod 644)
if chmod 644 "$FILE_PATH"; then
    echo "[SUCCESS] Applied numeric permissions (chmod 644)."
else
    echo "Error: Failed to set numeric permissions (644) on '$FILE_PATH'." >&2
    exit 1
fi

# Step 2b: Symbolic demonstration (chmod u+x)
if chmod u+x "$FILE_PATH"; then
    echo "[SUCCESS] Applied symbolic permissions (chmod u+x)."
else
    echo "Error: Failed to set symbolic permissions (u+x) on '$FILE_PATH'." >&2
    exit 1
fi

echo "---------------------------------------------------"

# 3. Check for root privileges (id -u) and attempt chown
echo "[INFO] Checking user privileges for ownership modification..."
CURRENT_UID=$(id -u)

if [[ "$CURRENT_UID" -eq 0 ]]; then
    echo "[INFO] Running as root (UID 0). Attempting ownership change..."
    CURRENT_USER=$(id -un)
    
    # Attempt to re-assign ownership to the current root user/group
    if chown "$CURRENT_USER:$CURRENT_USER" "$FILE_PATH"; then
        echo "[SUCCESS] Successfully updated file ownership with chown."
    else
        echo "Error: chown operation failed." >&2
        exit 1
    fi
else
    echo "[NOTICE] Skipped chown step: Root/sudo privileges required (Current UID: $CURRENT_UID)."
fi

echo "---------------------------------------------------"

# 4. Report permissions after changes
echo "[INFO] Final File Permissions (After Changes):"
display_permissions "$FILE_PATH" || exit 1

exit 0

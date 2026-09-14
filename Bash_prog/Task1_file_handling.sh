#!/usr/bin/env bash
#--------------------------------------------
#@title  Task1_file_handling.sh
#@author Kwaku Asare Okyere
#@index <7361823>
#@school KNUST
#@description Demmostrates file handling operations including directory creation,writing/appending to files,copying and conditional deletion 
#@date 12-09-2026

# Usage guide function
usage() {
    echo "Usage: $0 <target_directory>"
    echo "  <target_directory>  Path to directory where operations will take place."
    exit 1
}

# 0. Check arguments
if [[ "$1" == "-h" || "$1" == "--help" || -z "$1" ]]; then
    usage
fi

TARGET_DIR="$1"
FILE_PATH="${TARGET_DIR}/sample_data.txt"
BAK_PATH="${TARGET_DIR}/sample_data.txt.bak"

# 1. Create directory if it doesn't exist & report status
if [[ -d "$TARGET_DIR" ]]; then
    echo "[INFO] Directory '$TARGET_DIR' already exists."
else
    echo "[INFO] Directory '$TARGET_DIR' does not exist. Creating now..."
    if mkdir -p "$TARGET_DIR"; then
        echo "[SUCCESS] Directory '$TARGET_DIR' created successfully."
    else
        echo "[ERROR] Failed to create directory '$TARGET_DIR'." >&2
        exit 1
    fi
fi

# 2. Create a new file and write initial content
echo "[INFO] Creating file and writing initial content..."
if echo "Initial entry: Task 1 file handling started." > "$FILE_PATH"; then
    echo "[SUCCESS] File '$FILE_PATH' created and written to."
else
    echo "[ERROR] Failed to write to file '$FILE_PATH'." >&2
    exit 1
fi

# 3. Append additional content to the file
echo "[INFO] Appending additional content..."
if echo "Appended entry: Adding secondary data log line." >> "$FILE_PATH"; then
    echo "[SUCCESS] Content appended successfully."
else
    echo "[ERROR] Failed to append content to '$FILE_PATH'." >&2
    exit 1
fi

# 4. Read and display the file's contents
echo "---------------------------------------------------"
echo "[INFO] Displaying contents of '$FILE_PATH':"
if cat "$FILE_PATH"; then
    echo "[SUCCESS] Displayed file contents successfully."
else
    echo "[ERROR] Failed to read '$FILE_PATH'." >&2
    exit 1
fi
echo "---------------------------------------------------"

# 5. Copy the file to a .bak version
echo "[INFO] Copying '$FILE_PATH' to backup file '$BAK_PATH'..."
if cp "$FILE_PATH" "$BAK_PATH"; then
    echo "[SUCCESS] Backup created at '$BAK_PATH'."
else
    echo "[ERROR] Failed to copy file to '$BAK_PATH'." >&2
    exit 1
fi

# 6. Delete original file only after checking it exists, with confirmation
if [[ -f "$FILE_PATH" ]]; then
    echo "[CONFIRMATION] Original file exists. Deleting '$FILE_PATH' now..."
    if rm "$FILE_PATH"; then
        echo "[SUCCESS] Original file deleted. Backup retained."
    else
        echo "[ERROR] Failed to delete original file '$FILE_PATH'." >&2
        exit 1
    fi
else
    echo "[ERROR] File '$FILE_PATH' does not exist, cannot delete." >&2
    exit 1
fi

exit 0


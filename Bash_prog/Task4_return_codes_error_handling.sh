#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# @title       Task4_return_codes_error_handling.sh
# @author      Kwaku Asare Okyere
# @index       <7361823>
# @school      Kwame Nkrumah University of Science and Technology (KNUST)
# @description Demonstrates disciplined exit-code handling, status checking,
#              system diagnostics, and cleanup using trap handlers.
# @date        2026-09-13
# -----------------------------------------------------------------------------
# Exit codes:
#   0 = all checks passed
#   1 = missing required argument / general usage error
#   2 = host unreachable
#   3 = insufficient disk space
#   4 = required file not found / not readable
#   5 = required command not found
# -----------------------------------------------------------------------------

# Create a temporary working directory for this execution
TEMP_DIR=$(mktemp -d -t task4_tmp.XXXXXX)

# Cleanup function triggered on EXIT or interruption (Ctrl+C, SIGTERM)
cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        echo "[CLEANUP] Removing temporary files from '$TEMP_DIR'..."
        rm -rf "$TEMP_DIR"
    fi
}

# Trap signals: EXIT, INT (Ctrl+C), TERM (kill)
trap cleanup EXIT INT TERM

# Usage guide function
usage() {
    echo "Usage: $0 <hostname>"
    echo "  <hostname>  Target host or IP address to ping (e.g., 8.8.8.8 or google.com)."
    exit 1
}

# Helper function to evaluate command return code ($?)
check_status() {
    local status_code="$1"
    local check_name="$2"
    local fail_exit_code="$3"

    if [[ "$status_code" -eq 0 ]]; then
        echo "[PASS] $check_name"
    else
        echo "[FAIL] $check_name (Exit Code: $fail_exit_code)" >&2
        exit "$fail_exit_code"
    fi
}

# 0. Validate argument
if [[ "$1" == "-h" || "$1" == "--help" || -z "$1" ]]; then
    usage
fi

HOST="$1"
CONFIG_FILE="README.md"
REQUIRED_COMMAND="git"

echo "=========================================="
echo "    RUNNING SYSTEM HEALTH DIAGNOSTICS     "
echo "=========================================="

# Check 1: Is a given host reachable?
ping -c 1 -W 2 "$HOST" > /dev/null 2>&1
check_status $? "Host reachability check for '$HOST'" 2

# Check 2: Is there enough free disk space? (Checks if root partition has at least 10% available)
AVAILABLE_SPACE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [[ "$AVAILABLE_SPACE" -lt 90 ]]; then
    CMD_STATUS=0
else
    CMD_STATUS=1
fi
check_status $CMD_STATUS "Disk space availability check (Usage < 90%)" 3

# Check 3: Does a given config/data file exist and is it readable?
if [[ -f "$CONFIG_FILE" && -r "$CONFIG_FILE" ]]; then
    CMD_STATUS=0
else
    CMD_STATUS=1
fi
check_status $CMD_STATUS "File accessibility check for '$CONFIG_FILE'" 4

# Check 4: Is a given command/tool installed?
command -v "$REQUIRED_COMMAND" > /dev/null 2>&1
check_status $? "Tool installation check for '$REQUIRED_COMMAND'" 5

echo "=========================================="
echo "[SUCCESS] All system health checks completed successfully."
exit 0

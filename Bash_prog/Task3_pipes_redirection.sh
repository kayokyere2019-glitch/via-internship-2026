#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# @title       Task3_pipes_redirection.sh
# @author      Kwaku Asare Okyere
# @index       7361823
# @school      Kwame Nkrumah University of Science and Technology (KNUST)
# @description Generates log data using a heredoc and parses log stats using standard
#              text processing tools with stdout/stderr redirection.
# @date        2026-09-13
# -----------------------------------------------------------------------------

# Usage guide function
usage() {
    echo "Usage: $0 [-h|--help]"
    echo "  Generates log data and processes summary analytics into results.txt."
    exit 1
}

# 0. Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

LOG_FILE="generated_activity.log"
RESULTS_FILE="results.txt"
ERRORS_FILE="errors.log"

# Clean up previous outputs if they exist
rm -f "$LOG_FILE" "$RESULTS_FILE" "$ERRORS_FILE"

# 1. Generate at least 50 lines of fake log data using a Heredoc
cat << 'EOF' > "$LOG_FILE" 2>> "$ERRORS_FILE"
2026-09-11 10:03:21 INFO 192.168.1.10 User login successful
2026-09-11 10:03:45 ERROR 192.168.1.23 Connection timeout
2026-09-11 10:04:02 WARN 192.168.1.10 Disk usage above 80%
2026-09-11 10:04:15 INFO 192.168.1.15 File downloaded successfully
2026-09-11 10:05:00 ERROR 192.168.1.10 Database connection lost
2026-09-11 10:05:12 INFO 192.168.1.42 User logout successful
2026-09-11 10:06:01 WARN 192.168.1.23 High memory usage detected
2026-09-11 10:06:40 INFO 192.168.1.10 API token refreshed
2026-09-11 10:07:05 ERROR 192.168.1.88 Unauthorized access attempt
2026-09-11 10:07:33 INFO 192.168.1.15 Password change requested
2026-09-11 10:08:10 WARN 192.168.1.10 CPU temperature high
2026-09-11 10:08:50 ERROR 192.168.1.23 Failed login attempt
2026-09-11 10:09:12 INFO 192.168.1.50 Service restarted
2026-09-11 10:09:44 INFO 192.168.1.10 Session extended
2026-09-11 10:10:01 ERROR 192.168.1.88 Invalid CSRF token
2026-09-11 10:10:30 WARN 192.168.1.15 Bandwidth limit near threshold
2026-09-11 10:11:02 INFO 192.168.1.10 User login successful
2026-09-11 10:11:45 ERROR 192.168.1.23 Out of memory exception
2026-09-11 10:12:10 INFO 192.168.1.42 File uploaded
2026-09-11 10:12:35 WARN 192.168.1.10 Slow response time
2026-09-11 10:13:00 ERROR 192.168.1.99 Disk write failure
2026-09-11 10:13:22 INFO 192.168.1.10 Ping request received
2026-09-11 10:14:05 ERROR 192.168.1.88 SSL handshake failed
2026-09-11 10:14:30 INFO 192.168.1.15 Settings updated
2026-09-11 10:15:11 WARN 192.168.1.23 Deprecated API endpoint used
2026-09-11 10:15:40 ERROR 192.168.1.10 Permission denied
2026-09-11 10:16:02 INFO 192.168.1.50 Cron job executed
2026-09-11 10:16:45 WARN 192.168.1.10 Network latency detected
2026-09-11 10:17:20 ERROR 192.168.1.23 Port scanning detected
2026-09-11 10:17:55 INFO 192.168.1.10 User profile updated
2026-09-11 10:18:12 ERROR 192.168.1.88 SQL injection pattern blocked
2026-09-11 10:18:40 INFO 192.168.1.15 Download completed
2026-09-11 10:19:05 WARN 192.168.1.10 Swap space filling up
2026-09-11 10:19:30 ERROR 192.168.1.99 Kernel panic warning
2026-09-11 10:20:00 INFO 192.168.1.42 User logout successful
2026-09-11 10:20:22 WARN 192.168.1.23 Too many open files
2026-09-11 10:21:10 INFO 192.168.1.10 User login successful
2026-09-11 10:21:40 ERROR 192.168.1.88 Rate limit exceeded
2026-09-11 10:22:05 INFO 192.168.1.15 Cache cleared
2026-09-11 10:22:30 ERROR 192.168.1.23 Service unreachable
2026-09-11 10:23:01 WARN 192.168.1.10 DNS resolution slow
2026-09-11 10:23:45 INFO 192.168.1.50 Configuration loaded
2026-09-11 10:24:12 ERROR 192.168.1.10 Payment gateway timeout
2026-09-11 10:24:50 WARN 192.168.1.15 High CPU utilization
2026-09-11 10:25:20 INFO 192.168.1.10 Heartbeat sent
2026-09-11 10:25:55 ERROR 192.168.1.88 SSH brute force blocked
2026-09-11 10:26:15 INFO 192.168.1.42 Metrics exported
2026-09-11 10:26:40 WARN 192.168.1.23 Certificate expiring soon
2026-09-11 10:27:10 ERROR 192.168.1.99 Storage volume unmounted
2026-09-11 10:27:35 INFO 192.168.1.10 Backup process initiated
2026-09-11 10:28:00 INFO 192.168.1.15 System check complete
EOF

if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: Failed to create log file '$LOG_FILE'." >&2
    exit 1
fi

# 2. Compute statistics using pipelines and write output to results.txt
{
    echo "=========================================="
    echo "        LOG ANALYSIS SUMMARY REPORT       "
    echo "=========================================="
    echo ""

    # Requirement 1: Total number of log lines
    TOTAL_LINES=$(wc -l < "$LOG_FILE")
    echo "1. Total Number of Log Lines: $TOTAL_LINES"
    echo ""

    # Requirement 2: Count of lines per log level (INFO, WARN, ERROR)
    echo "2. Count of Lines Per Log Level:"
    echo "---------------------------------"
    INFO_COUNT=$(grep -c " INFO " "$LOG_FILE" 2>> "$ERRORS_FILE" || echo 0)
    WARN_COUNT=$(grep -c " WARN " "$LOG_FILE" 2>> "$ERRORS_FILE" || echo 0)
    ERROR_COUNT=$(grep -c " ERROR " "$LOG_FILE" 2>> "$ERRORS_FILE" || echo 0)
    echo "   - INFO : $INFO_COUNT"
    echo "   - WARN : $WARN_COUNT"
    echo "   - ERROR: $ERROR_COUNT"
    echo ""

    # Requirement 3: Top 3 most frequent IP addresses using awk, sort, uniq, head
    echo "3. Top 3 Most Frequent IP Addresses:"
    echo "---------------------------------"
    awk '{print $4}' "$LOG_FILE" 2>> "$ERRORS_FILE" | sort 2>> "$ERRORS_FILE" | uniq -c 2>> "$ERRORS_FILE" | sort -nr 2>> "$ERRORS_FILE" | head -n 3 2>> "$ERRORS_FILE" | awk '{printf "   - IP: %s (Occurrences: %s)\n", $2, $1}'
    echo ""

    # Requirement 4: All ERROR lines only using grep
    echo "4. All ERROR Log Lines:"
    echo "---------------------------------"
    grep " ERROR " "$LOG_FILE" 2>> "$ERRORS_FILE"
    echo ""
    echo "=========================================="
} > "$RESULTS_FILE"

# Check if pipeline execution was successful
if [[ $? -eq 0 ]]; then
    echo "[SUCCESS] Log processing completed."
    echo "[INFO] Summary report saved to '$RESULTS_FILE'."
    echo "[INFO] Pipeline errors (if any) logged to '$ERRORS_FILE'."
    echo ""
    cat "$RESULTS_FILE"
else
    echo "Error: Log analysis pipeline failed." >&2
    exit 1
fi

exit 0

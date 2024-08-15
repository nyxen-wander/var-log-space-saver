#!/bin/bash
####################################### VARIABLES DECLARATION ######################################

#timestamp for logging and file naming
TIMESTAMP=$(date +%Y%m%d)

LOG_TIMESTAMP="[$TIMESTAMP-$(date +%H:%M)]"

#logs base path
LOGS_PATH="/var/log"

#get compressed file dir
ARCHIVED_PATH="$LOGS_PATH/archived"

#set this script log file name
SCRIPT_LOG="$ARCHIVED_PATH/backup_$TIMESTAMP.log"

#ensure $ARCHIVED_PATH exists
mkdir -pv "$ARCHIVED_PATH" || error_handler "Failed to create a directory in $LOGS_PATH." >> "$SCRIPT_LOG"

#ensure the script log file is exists
touch "$SCRIPT_LOG" || error_handler "Failed to create a file in $LOGS_PATH." >> "$SCRIPT_LOG"

####################################### FUNCTION DECLARATION #######################################

#error handler
error_handler(){

    echo "$LOG_TIMESTAMP ERROR: $1" 2>&1
    exit 1

}

####################################### BEGINNING OF SCRIPT ######################################

echo "$LOG_TIMESTAMP Script is starting..." | tee -a "$SCRIPT_LOG"
echo ''

#read each line of directory that reaches 100M by size
find "$LOGS_PATH/"* -type f -exec du -hat 100M {} + | awk '{print $2}' | while read -r output; do

    if [[ "$output" != "$ARCHIVED_PATH" ]]; then

        #set archive name
        ARCHIVED_NAME="archived_logs_$TIMESTAMP.tar.gz"

        #compress the log files
        echo "$LOG_TIMESTAMP Compressing log files..." | tee -a "$SCRIPT_LOG"
        echo ''

        tar -cvzf "$ARCHIVED_PATH/$ARCHIVED_NAME" -T - || error_handler "Failed to compress logs." >> "$SCRIPT_LOG"

        echo "$LOG_TIMESTAMP Log files compressed." | tee -a "$SCRIPT_LOG"
        echo ''

        echo "$LOG_TIMESTAMP Removing log files..." | tee -a "$SCRIPT_LOG"
        echo ''

        #check the log files existence and remove them if any to save more space
        rm -rv "$output" || error_handler "Failed to compress logs." >> "$SCRIPT_LOG"
        echo ''
        echo "$LOG_TIMESTAMP Log files removed." | tee -a "$SCRIPT_LOG"
        echo ''

    fi

done

echo "$LOG_TIMESTAMP Script is stopped." | tee -a "$SCRIPT_LOG"
echo '' | tee -a "$SCRIPT_LOG"

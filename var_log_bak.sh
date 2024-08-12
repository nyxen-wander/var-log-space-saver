#!/bin/bash

#get current date
TIMESTAMP=$(date +%Y%m%d)

#get compressed file dir
ARCHIVED_PATH="/var/log/archived"

#logs base path
LOGS_PATH="/var/log"

#ensure $ARCHIVED_PATH exists
sudo mkdir -p $ARCHIVED_PATH

#read each line of directory that reaches 100M by size
sudo du -d0 -t +100M $LOGS_PATH/* | while read -r output; do

    #get the specific target dir name
    DIR_NAME=$(echo "$output" | awk -F '/' '{print $4}')

    #set the tarball file name
    ARCHIVED_NAME="$ARCHIVED_PATH/archived_logs_$DIR_NAME-$TIMESTAMP.tar.gz"

    #compress the log files
    echo "$output" | awk '{print $2}'| sudo tar -czf "$ARCHIVED_NAME" -T -

    #prompt the result
    if [ $? -eq 0 ]; then

        echo "Log files compressed."
        echo ''

        echo "Removing log files..."
        echo ''

        #remove the log files to save more space
        sudo rm -r $LOGS_PATH/"$DIR_NAME"/*

        #prompt the removing result
        if [ $? -eq 0 ]; then

            echo "Log files removed."
            echo ''

        else

            echo "No log files left."
            echo ''

        fi

    else

        echo "WARNING: Couldn't compress files. Check this script logic."
        echo ''

    fi

done
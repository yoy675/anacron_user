#!/bin/bash

MAILTO="$user"
LOGFILE="$HOME/.anacron/anacron.log"  # Specify the path for the log file
last_mod_time=$(stat --printf=%Y "$0")
for (( current_mod_time=$(stat --printf=%Y "$0"); $current_mod_time == $last_mod_time; current_mod_time=$(stat --printf=%Y "$0") )); do
	{
        echo "$(date '+%H:%M:%S') - Starting anacron..."
        anacron -d -S $HOME/.anacron/spool/anacron -t $HOME/.anacron/anacrontab
        echo "$(date '+%H:%M:%S') - Finished anacron."
        echo "Job 'cron.hourly' started."
        cd $HOME/ && run-parts --report $HOME/.anacron/cron.hourly
        echo "Job cron.daily terminated on $(date '+%H:%M:%S')."
    } >> "$LOGFILE" 2>&1  # Append output and errors to the log file
	sleep 30m
done
pkill -P $(jobs | awk '{print $2}')
$0&
disown
exit 0
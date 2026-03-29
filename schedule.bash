#!/bin/bash

SHELL=/bin/sh
HOME=/home/david
LOGNAME=david
MAILTO="david"
LOGFILE="$HOME/.anacron/anacron.log"  # Specify the path for the log file
last_mod_time=$(stat --printf=%Y "$0")
while true;do if ps -C mailnag -o pid --no-headers| grep ".*" -q;then sleep 5m; else mailnag; fi; done >> "$LOGFILE" 2>&1&
sed "s|.*$(date --date='last month' '+%Y-%m-%d')||g" "$LOGFILE"
for (( current_mod_time=$(stat --printf=%Y "$0"); $current_mod_time == $last_mod_time; current_mod_time=$(stat --printf=%Y "$0") )); do
	{
        echo "$(date '+%H:%M:%S') - Starting anacron..."
        anacron -d -S /home/david/.anacron/spool/anacron -t /home/david/.anacron/anacrontab
        echo "$(date '+%H:%M:%S') - Finished anacron."
        echo "Job 'cron.hourly' started."
        cd /home/david/ && run-parts --report /home/david/.anacron/cron.hourly
        echo "Job cron.daily terminated on $(date '+%H:%M:%S')."
    } >> "$LOGFILE" 2>&1  # Append output and errors to the log file
	sleep 30m
done
pkill -P $(jobs | awk '{print $2}')
$0&
disown
exit 0
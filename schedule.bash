#!/bin/bash

MAILTO="$USER"
LOGFILE="$HOME/.anacron/anacron.log"  # Specify the path for the log file
crontab="$HOME/.anacron/crontab"
last_mod_time=$(stat --printf=%Y "$0")
last_hour=$(date '+%H')
for (( current_mod_time=$(stat --printf=%Y "$0"); $current_mod_time == $last_mod_time; current_mod_time=$(stat --printf=%Y "$0") )); do
	{
		if [ $(date '+%H')==$last_hour ];then
			echo "$(date '+%H:%M:%S') - Starting anacron..."
			anacron -d -S $HOME/.anacron/spool/anacron -t $HOME/.anacron/anacrontab
			echo "$(date '+%H:%M:%S') - Finished anacron."
			echo "Job 'cron.hourly' started."
			cd $HOME/ && run-parts --report $HOME/.anacron/cron.hourly
			echo "Job cron.hourly terminated on $(date '+%H:%M:%S')."
			last_hour=$(date '+%H')
		fi
		current_time=$(date '+%-M %-H %-d %-m %-w')
		cmd=$(cat $HOME/.anacron/crontab| grep -v ^#| awk -v time="$current_time" '{sch=($1=="*" ? "."$1 : $1); for (i=2; i<6; i++) {sch=($i=="*" ? sch OFS "."$i : sch OFS $i)};if (time ~ sch) {for(i=6;i<=NF;i++) printf "%s%s", $i, (i<NF? OFS:ORS)}}')
		eval $cmd
    } >> "$LOGFILE" 2>&1  # Append output and errors to the log file
	sleep 1m
done
kill $(jobs | grep "\[.\]" | sed 's|\[|%|g;s|].*||g')
$0&
disown
exit 0
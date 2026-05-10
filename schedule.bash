#!/bin/bash

MAILTO="$USER"
LOGFILE="$HOME/.anacron/anacron.log"  # Specify the path for the log file
crontab="$HOME/.anacron/crontab"
last_hour=$(date '+%H')
rm $HOME/.anacron/fifo.*
fifo="$HOME/.anacron/fifo.$$"
mkfifo "$fifo"
while true; do
	{
		current_time=$(date '+%-M %-H %-d %-m %-w')
		cmd=$(~/.anacron/rangeToRegex.py "$(sed '/^ \?#/d;/^ \?[A-Za-z_][A-Za-z0-9_]*=/d;/^$/d;s|#.*||g' $crontab)" "$current_time")
		eval "$(grep '^ \?[A-Za-z_][A-Za-z0-9_]*=' $crontab)" "$cmd"
		for file in $HOME/.anacron/cron.d/*;do
			if [ $(sed '/^ \?#/d;/^ \?[A-Za-z_][A-Za-z0-9_]*=/d;/^$/d;s|#.*||g' $file)=='' ];then continue;fi
			lines=$(~/.anacron/rangeToRegex.py "$(sed '/^ \?#/d;/^ \?[A-Za-z_][A-Za-z0-9_]*=/d;/^$/d;s|#.*||g' $file)" "$current_time")
			cmd="$(echo "$lines"| awk '{if ($0!="") print "sudo -u "$0}'| tr '\t' ' '| tr '%' '\n')"
			if [[ ! -n $cmd ]];then
				continue
			fi
			eval "$(grep '^ \?[A-Za-z_][A-Za-z0-9_]*=' $file)" "$cmd"
		done
    } >> "$LOGFILE" 2>&1&  # Append output and errors to the log file
    read last_hour < "$fifo"
	sleep 1m
done
rm "$fifo"
exit 0
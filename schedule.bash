#!/bin/bash

LOGFILE="$HOME/.anacron/anacron.log"  # Specify the path for the log file
crontab="$HOME/.anacron/crontab"
#~ last_mod_time=$(stat --printf=%Y "$0")
last_hour=25 # To make sure it runs anacron on the first iteration
rm $HOME/.anacron/fifo.*
fifo="$HOME/.anacron/fifo.$$"
mkfifo "$fifo"
#~ for (( current_mod_time=$(stat --printf=%Y "$0"); $current_mod_time == $last_mod_time; current_mod_time=$(stat --printf=%Y "$0") )); do
while true;do
	{
		current_time=$(date '+%-M %-H %-d %-m %-w')
		cmd=$(~/.anacron/rangeToRegex.py "$(sed '/^ \?#/d;/^ \?[A-Za-z_][A-Za-z0-9_]*=/d;/^$/d;s|#.*||g' $crontab)" "$current_time")
		eval "$(grep '^ \?[A-Za-z_][A-Za-z0-9_]*=' $crontab)" "$(echo $cmd| sed '/[^\\]%/ s|%|\n|')"
		for file in $HOME/.anacron/cron.d/*;do
			if [ $(sed '/^ \?#/d;/^ \?[A-Za-z_][A-Za-z0-9_]*=/d;/^$/d;s|#.*||g' $file)=='' ];then continue;fi
			lines=$(~/.anacron/rangeToRegex.py "$(sed '/^ \?#/d;/^ \?[A-Za-z_][A-Za-z0-9_]*=/d;/^$/d;s|#.*||g' $file)" "$current_time")
			cmd="$(echo "$lines"| awk '{if ($0!="") print "sudo -u "$0}')"
			if [[ ! -n $cmd ]];then
				continue
			fi
			eval "$(grep '^ \?[A-Za-z_][A-Za-z0-9_]*=' $file)" "$(echo $cmd| sed '/[^\\]%/ s|%|\n|')"
		done
    } >> "$LOGFILE" 2>&1&  # Append output and errors to the log file
    read last_hour < "$fifo"
	sleep 1m
done 2>> "$HOME/.anacron/crash.log"
rm "$fifo"
exit 0
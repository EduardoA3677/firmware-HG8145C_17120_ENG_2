#! /bin/sh  

l2_uptimeFile="/mnt/jffs2/l2_uptime"
max_time_diff=1000
base_line_time=$1
notice=""

current_time=`sed -n '1p' $l2_uptimeFile | cut -d ':' -f 2`

last_time=`sed -n '2p' $l2_uptimeFile | cut -d ':' -f 2`

up_time_diff=`expr $current_time - $last_time`
up_time_base_diff=`expr $current_time - $base_line_time`

if [ $max_time_diff -lt $up_time_diff ]
then
	notice="ONT takes $up_time_diff ms more than the last time to start. Please check and optimize your code to reduce the start time!"
fi

if [ $max_time_diff -lt $up_time_base_diff ]
then
	notice="$notice\nONT takes $up_time_base_diff ms more than the baseline time to start. Please check and optimize your code to reduce the start time!"
fi

times=0
if [ -n "$notice" ]
then
	while [ $times -lt 5 ]
	do
		echo -e "$notice"
		sleep 10
		times=$(( $times + 1 ))
	done
fi

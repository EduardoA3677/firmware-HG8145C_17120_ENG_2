#/bin/sh

#是否要处理输出信息开关
feature_info_calibrate=`GetFeature FT_INFO_CALIBRATE`

if [ 0 -ne $# ]; then
    echo "ERROR::input para is not right!";
    return 1;
fi

CLI_MODE=$(cat /var/collectshflag)

echo $CLI_MODE

if [ "$CLI_MODE" = "1" ]
then
    echo "Now ClientType Is TRANSCHNL, collect.sh can not be used in this ClientType."
    return 1
fi

if [ -f /var/diacollectisrunning ]
then
    echo "diagnose collection process is existed now!"
    return 1
fi

if [ "$LOCAL_TELNET" == "1" ]; then
    diag_src="com";
else
    diag_src="telnet";
fi

echo "local telnet flag is $LOCAL_TELNET, diag source is $diag_src"

if [ -p /var/collect_ctrl_fifo ]; then
        echo 1 > /var/collect_ctrl_fifo;
else
        echo !path "/var/console.log" > /proc/wap_proc/tty;
        echo !start > /proc/wap_proc/tty;
fi

collect_exe /etc/ssmp_collect $diag_src
collect_exe /etc/bbsp_collect $diag_src
collect_exe /etc/ldsp_collect $diag_src
collect_exe /etc/voice_collect $diag_src
collect_exe /etc/amp_collect $diag_src

if [ -p /var/collect_ctrl_fifo ]; then
        echo 2 > /var/collect_ctrl_fifo;
else
        echo !stop > /proc/wap_proc/tty;
fi

if [ "$LOCAL_TELNET" != "1" ]; then
        if [ $feature_info_calibrate = 1 ]; then
		cat /var/console.log | awk -f /etc/wap/info_calibrate.awk
	else
		cat /var/console.log	
	fi	
fi

return 0;

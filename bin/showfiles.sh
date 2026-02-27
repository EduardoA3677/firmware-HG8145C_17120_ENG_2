#!/bin/sh
# cat 封装，只能读取/var、 /proc、 /tmp 目录下面的文件内容
#产品侧DM加载之后就可以通过/proc/wap_proc/chip_attr文件获取芯片类型
var_calibrate=`GetFeature FT_INFO_CALIBRATE`

CheckFilePath()
{
    path=$1
    echo $1 | grep '\.\.' > /dev/null
	if [ 0 == $? ]
	then
        return 1;	
	fi
	
	echo $1 | grep '/\.' > /dev/null
	if [ 0 == $? ]
	then
        return 1;	
	fi
	
	echo $1 | grep '\./' > /dev/null
	if [ 0 == $? ]
	then
        return 1;		
	fi
    
	return 0;
}

DealWithJffsFile()
{
	case "$1" in
		 *hard_version* | *cwmp_rebootsave* | *reboot_info* | *main_version* | *board_type* | *optic_par_debug*  | *flashtestresult* | *equip_aging_temperature* | *panicinfo* | *keyreleasecount.txt*)  cat $1;;
		 *xmlcfgerrorcode* ) cat $1
		  echo ""
		  echo "show hex:"
		  hexdump $1;;
		 * ) echo "ERROR::The directory or file is wrong!"; return 1;;
	esac
	
	return $?
}

DealWithProcFile()
{
	case "$1" in
		/proc/[0-9]*/* |  *buddyinfo* | *bus* |  *crypto* | *devices* | *diskstats* | *driver* | *execdomains* | *filesystems* | *fs* |\
		*interrupts* | *iomem* | *ioports* | *irq* |    *kallsyms* | *kpagecount* | *kpageflags* | *loadavg* | *locks* | *misc* | \
		*modules* | *mounts* | *mtd* | *net* | *pagetypeinfo* |  *partitions* | *sched_debug* | *schedstat* | *self* | *simple_config* | *slabinfo* | \
		*softirqs* | *softlockup* | *stat* | *sys* | *sysrq-trigger* | *sysvipc* | *timer_list* | *tty* | *uptime* | *version* | *vmallocinfo* | \
		*vmstat* | *zoneinfo* | *wap_log* | *wap_lastword* ) cat $1;;
		*cmdline* | *kmsg* | *meminfo* | *cpu* | *cpuinfo* ) 
			if [ "$var_calibrate" == "1" ] ; then
				cat $1 | awk -f /etc/wap/info_calibrate.awk
			else
				cat $1
			fi
			;;
		* ) echo "ERROR::The directory or file is wrong!"; return 1;;
	esac

	return $?
}

DealWithVarFile()
{
	case "$1" in
		*dhcpd* | *dnsmasq* | *hosts* | *wan* | *dnsv6* ) cat $1;;
		* ) echo "ERROR::The directory or file is wrong!"; return 1;;
	esac

	return $?
}

if [ 1 -ne $# ]; 
then
    echo "ERROR::input para is not right!"
    return 1;	
else
    CheckFilePath $1
	if [ 0 -ne $? ]
	then
        echo "ERROR::input para is not right!"
        return 1;		
	fi
	
    case "$1" in
     *proc*  ) DealWithProcFile $1;;
     *jffs2* ) DealWithJffsFile $1;;
     *var* ) DealWithVarFile $1;;
     * ) echo "ERROR::The directory or file is wrong!"; return 1;;
    esac

    return $?
fi

#!/bin/sh

var_equipment_file="/mnt/jffs2/equipment.tar.gz"
if [ -f $var_equipment_file ];then
	cd /mnt/jffs2
	tar -xzf $var_equipment_file 
	rm -f $var_equipment_file
	rm -f /mnt/jffs2/module_desc.xml
	rm -f /mnt/jffs2/module_desc_bak.xml
    echo "<module>" > /mnt/jffs2/module_desc.xml
    echo '<moduleitem name="equipment" path="/mnt/jffs2/equipment"/>' >> /mnt/jffs2/module_desc.xml
    echo "</module>" >> /mnt/jffs2/module_desc.xml
    cp -f /mnt/jffs2/module_desc.xml /mnt/jffs2/module_desc_bak.xml
	cd /
fi

if [ ! -f /mnt/jffs2/ProductLineMode ]
then
    echo "" > /mnt/jffs2/ProductLineMode
fi

var_xpon_mode=`cat /mnt/jffs2/hw_boardinfo | grep "0x00000001" | cut -c38-38`
echo "xpon_mode:${var_xpon_mode}"

echo ${var_xpon_mode}>>/var/var_xpon_mode

echo "User init start......"

# load hisi modules
if [ -f /mnt/jffs2/TranStar/hi_sysctl.ko ]; then
	  cd /mnt/jffs2/TranStar/
	  echo "Loading the Temp HISI SD511X modules: "
else
	  cd /lib/modules/hisi_sdk
	  echo "Loading the HISI SD511X modules: "
fi
		
    insmod hi_sysctl.ko
    insmod hi_spi.ko	

   
tempChipType1=`md 0x10100800 1`
tempChipType=`echo $tempChipType1 | sed 's/.*:: //' | sed 's/[0-9][0-9]00//' | cut -b 1-4`

if [ $tempChipType -eq 5115 ]; then
    insmod hi_gpio_5115.ko
else
    insmod hi_gpio.ko
fi    
    insmod hi_i2c.ko
    insmod hi_timer.ko
    insmod hi_serdes.ko	

    insmod hi_hw.ko
    insmod hi_dma.ko
if [ -e /mnt/jffs2/PhyPatch ]; then
    echo "phy patch path is /mnt/jffs2/PhyPatch/ "
    if [ $tempChipType -eq 5115 ]; then
        insmod hi_bridge_5115.ko	pPhyPatchPath="/mnt/jffs2/PhyPatch/"
    else    
        insmod hi_bridge.ko pPhyPatchPath="/mnt/jffs2/PhyPatch/"
    fi
else
    if [ $tempChipType -eq 5115 ]; then
        insmod hi_bridge_5115.ko	
    else    
        insmod hi_bridge.ko
    fi
fi
    insmod hi_pie.ko tx_chk=0
    insmod hi_ponlp.ko
	
if [ ${var_xpon_mode} == "5" ]; then	
	insmod hi_xgpon.ko
	insmod hi_xepon.ko
elif [ ${var_xpon_mode} == "6" ]; then
	insmod hi_xgpon.ko
	insmod hi_xepon.ko
elif [ ${var_xpon_mode} == "7" ]; then
	insmod hi_xgpon.ko
	insmod hi_xepon.ko
else
    insmod hi_gpon.ko
    insmod hi_epon.ko
fi    

if [ $tempChipType -eq 5115 ]; then
    insmod hi_l3_5115.ko
else    	
    insmod hi_l3.ko napt_ext_ipv4_mode=2 napt_ext_ipv6_mode=0
fi    

if [ ${var_xpon_mode} == "2" ] || [ ${var_xpon_mode} == "6" ] || [ ${var_xpon_mode} == "7" ] || [ ${var_xpon_mode} == "4" ];  then 
	insmod hi_oam.ko
fi

cd /

# set lanmac 
getlanmac $HW_LANMAC_TEMP
if [ 0  -eq  $? ]; then
    read HW_BOARD_LANMAC < $HW_LANMAC_TEMP
    echo "ifconfig eth0 hw ether $HW_BOARD_LANMAC"
    ifconfig eth0 hw ether $HW_BOARD_LANMAC
fi

# delete temp lanmac file
if [ -f $HW_LANMAC_TEMP ]; then
    rm -f $HW_LANMAC_TEMP
fi

# activate ethernet drivers
ifconfig lo up
ifconfig eth0 192.168.100.1 up
ifconfig eth0 mtu 1500

mkdir /var/tmp

if [ -f /lib/modules/linux/extra/arch/arm/mach-hisi/pcie.ko ]; then
	insmod /lib/modules/linux/extra/arch/arm/mach-hisi/pcie.ko
fi

#echo "Loading the EchoLife WAP modules: LDSP"

# hw_module_common.ko hw_module_hlp.ko are needed by all of ko
insmod /lib/modules/wap/hw_module_common.ko
insmod /lib/modules/wap/hw_module_i2c.ko
insmod /lib/modules/wap/hw_module_gpio.ko
insmod /lib/modules/wap/hw_module_optic.ko
insmod /lib/modules/wap/hw_module_key.ko
insmod /lib/modules/wap/hw_module_led.ko

if [ ! -e /var/SD5116L.txt ]; then
  insmod /lib/modules/hisi_sdk/hi_sci.ko
  insmod /lib/modules/hisi_sdk/hi_uart.ko
	insmod /lib/modules/wap/hw_module_sim.ko
	insmod /lib/modules/wap/hw_module_uart.ko
	insmod /lib/modules/wap/hw_module_battery.ko
	echo 8192 > /proc/sys/vm/min_free_kbytes 
else
	echo 1024 > /proc/sys/vm/min_free_kbytes   
fi

insmod /lib/modules/wap/hw_module_dev.ko
#dm产品侧ko,需在hw_module_dev.ko加载后加载
insmod /lib/modules/wap/hw_dm_pdt.ko
insmod /lib/modules/wap/hw_module_feature.ko

#NFC
if [ ! -e /var/SD5116L.txt ]; then 
	insmod /lib/modules/wap/hw_module_nfc_st.ko
	insmod /lib/modules/wap/hw_module_nfc.ko
fi

insmod /lib/modules/wap/hw_module_amp.ko

if [ ${var_xpon_mode} == "1" ] ; then	
	 insmod /lib/modules/wap/hw_module_ploam.ko
	 insmod /lib/modules/wap/hw_module_gmac.ko
	 if [ ! -e /var/SD5116L.txt ]; then 
              insmod /lib/modules/wap/hw_module_ppm.ko
	 fi
elif [ ${var_xpon_mode} == "2" ] || [ ${var_xpon_mode} == "6" ] || [ ${var_xpon_mode} == "7" ]; then
   insmod /lib/modules/wap/hw_module_mpcp.ko
   insmod /lib/modules/wap/hw_module_emac.ko
elif [ ${var_xpon_mode} == "5" ]; then
   insmod /lib/modules/wap/hw_module_xgploam.ko
   insmod /lib/modules/wap/hw_module_gmac.ko
   if [ ! -e /var/SD5116L.txt ]; then 
 	insmod /lib/modules/wap/hw_module_ppm.ko
   fi
elif [ ${var_xpon_mode} == "4" ]; then
		if [ $tempChipType -eq 5118 ]; then
    		insmod /lib/modules/wap/hw_module_xgploam.ko
		else
    		insmod /lib/modules/wap/hw_module_ploam.ko
		fi
   insmod /lib/modules/wap/hw_module_mpcp.ko
   insmod /lib/modules/wap/hw_module_gmac.ko
   insmod /lib/modules/wap/hw_module_emac.ko
   if [ ! -e /var/SD5116L.txt ]; then 
 	insmod /lib/modules/wap/hw_module_ppm.ko
   fi
else
   echo "need not insmod ploam&mpcp ko!!!"
fi

if [ -e /var/bcm84846.txt ]; then
   insmod /lib/modules/hisi_sdk/hi_mdio.ko 
	 insmod /lib/modules/wap/hw_module_phy.ko
	 insmod /lib/modules/wap/hw_ker_phy_bcm84846.ko
elif [ -e /var/bcm50612e.txt ]; then
   insmod /lib/modules/hisi_sdk/hi_mdio.ko
   insmod /lib/modules/wap/hw_module_phy.ko 
	 insmod /lib/modules/wap/hw_ker_phy_bcm50612e.ko
elif [ -e /var/m88e151x.txt ]; then
   insmod /lib/modules/hisi_sdk/hi_mdio.ko
   insmod /lib/modules/wap/hw_module_phy.ko 
	 insmod /lib/modules/wap/hw_ker_phy_m88e151x.ko
fi


#判断/mnt/jffs2/customize_xml.tar.gz文件是否存在，存在解压
if [ -e /mnt/jffs2/customize_xml.tar.gz ]
then
    #解析customize_relation.cfg
    tar -xzf /mnt/jffs2/customize_xml.tar.gz -C /mnt/jffs2/ customize_xml/customize_relation.cfg  
fi

. /usr/bin/init_topo_info.sh

echo "pots_num="$pots_num
echo " usb_num="$usb_num
echo "hw_route="$hw_route
echo "   l3_ex="$l3_ex
echo "    ipv6="$ipv6
echo "rf_num="$rf_num
rm /var/topo.sh

#mem_totalsize=`cat proc/meminfo  | grep MemTotal | awk '{print $2}'`
mem_totalsize=`cat /proc/meminfo | grep MemTotal | cut -c11-22`
echo "Read MemInfo Des:"$mem_totalsize

if [ $rf_num -ne 0 ]
then 
	insmod /lib/modules/wap/hw_module_rf.ko
fi

# pots ko
if [ $pots_num -ne 0 ]
then 
    insmod /lib/modules/wap/hw_module_highway.ko
    insmod /lib/modules/wap/hw_module_spi.ko
    insmod /lib/modules/wap/hw_module_codec.ko
    if [ $pots_num -eq 1 ]
    then
         if [ -e /var/si32176.txt ]
         then
             insmod /lib/modules/wap/hw_ker_codec_si32176.ko
	     elif [ -e /var/pef3201.txt ]
	     then
	         insmod /lib/modules/wap/hw_ker_codec_pef3201.ko
	     elif [ -e /var/pef3100x.txt ]
	     then
	         insmod /lib/modules/wap/hw_ker_codec_pef31002.ko
	     elif [ -e /var/le964x.txt ]
	     then
	         insmod /lib/modules/wap/hw_ker_codec_le964x.ko    
	     else
             insmod /lib/modules/wap/hw_ker_codec_ve8910.ko
	     fi
    else
        if [ -e /var/le964x.txt ]
        then
             insmod /lib/modules/wap/hw_ker_codec_le964x.ko
		elif [ -e /var/pef3100x.txt ]
		then
             insmod /lib/modules/wap/hw_ker_codec_pef31002.ko		
        else     
             insmod /lib/modules/wap/hw_ker_codec_pef3201.ko
        fi
    fi
fi

#if file is existed ,don't excute
if [ $usb_num -ne 0 ]
then
  cd /lib/modules/linux/
  if [ -f ./extra/drivers/usb/storage/usb-storage.ko ]; then
	  insmod ./kernel/fs/nls/nls_ascii.ko
	  insmod ./kernel/fs/nls/nls_cp437.ko
	  insmod ./kernel/fs/nls/nls_utf8.ko
	  insmod ./kernel/fs/nls/nls_cp936.ko
	  insmod ./kernel/fs/fat/fat.ko
	  insmod ./kernel/fs/fat/vfat.ko
	  insmod ./kernel/fs/fuse/fuse.ko
	  insmod ./kernel/drivers/scsi/scsi_mod.ko
	  insmod ./kernel/drivers/scsi/scsi_wait_scan.ko
	  
	  insmod ./extra/drivers/scsi/sd_mod.ko
	  
	  insmod ./extra/drivers/usb/usb-common.ko
	  insmod ./extra/drivers/usb/core/usbcore.ko
	  insmod ./extra/drivers/usb/host/hiusb-sd511x.ko
	  insmod ./extra/drivers/usb/host/ehci-hcd.ko
	  insmod ./extra/drivers/usb/host/ehci-pci.ko
	  insmod ./extra/drivers/usb/host/ohci-hcd.ko
	  insmod ./extra/drivers/usb/host/xhci-hcd.ko
	  insmod ./extra/drivers/usb/storage/usb-storage.ko
	  insmod ./extra/drivers/usb/class/usblp.ko
	  insmod ./extra/drivers/usb/class/cdc-acm.ko
	  
	  insmod ./extra/drivers/usb/serial/usbserial.ko
	    insmod ./extra/drivers/usb/serial/pl2303.ko
	    insmod ./extra/drivers/usb/serial/cp210x.ko
	    insmod ./extra/drivers/usb/serial/ftdi_sio.ko
	  insmod ./extra/drivers/input/input-core.ko
	  insmod ./extra/drivers/hid/hid.ko
	  insmod ./extra/drivers/hid/usbhid/usbhid.ko
	    insmod ./extra/drivers/usb/serial/usbserial.ko
	  insmod ./extra/drivers/usb/serial/usb_wwan.ko
	  insmod ./extra/drivers/usb/serial/option.ko
	  insmod ./extra/drivers/net/usb/hw_cdc_driver.ko
  fi
  if [ -f ./extra/drivers/mmc/core/mmc_core.ko ]; then
	  insmod ./extra/drivers/mmc/core/mmc_core.ko
	  insmod ./extra/drivers/mmc/card/mmc_block.ko
	  insmod ./extra/drivers/mmc/host/himciv100/himci.ko
  fi
  cd /
 
    insmod /lib/modules/wap/hw_module_usb.ko
    insmod /lib/modules/wap/hw_module_datacard.ko
    insmod /lib/modules/wap/hw_module_datacard_chip.ko
    insmod /lib/modules/wap/hw_module_sd.ko
    insmod /lib/modules/wap/smp_usb.ko
fi

# AMP_KO
insmod /lib/modules/wap/hw_amp.ko
#

# BBSP_l2_basic
echo "Loading BBSP L2 modules: "
insmod /lib/modules/linux/kernel/drivers/net/slip/slhc.ko
insmod /lib/modules/linux/kernel/drivers/net/ppp/ppp_generic.ko
insmod /lib/modules/linux/kernel/drivers/net/ppp/pppox.ko
insmod /lib/modules/linux/kernel/drivers/net/ppp/pppoe.ko

insmod /lib/modules/wap/commondata.ko
insmod /lib/modules/wap/sfwd.ko
insmod /lib/modules/wap/l2ffwd.ko
insmod /lib/modules/wap/hw_ptp.ko
insmod /lib/modules/wap/hw_bbsp_lswadp.ko
insmod /lib/modules/wap/l2base.ko
insmod /lib/modules/wap/acl.ko
insmod /lib/modules/wap/cpu.ko
insmod /lib/modules/wap/bbsp_l2_adpt.ko
insmod /lib/modules/wap/qos_adpt.ko

# BBSP_l2_basic end

if [ $ssid_num -ne 0 ]
then
    insmod /lib/modules/wap/hw_module_wifi.ko
    insmod /lib/modules/wap/hw_module_acp.ko
fi

# BBSP_l2_extended
echo "Loading BBSP L2_extended modules: "
insmod /lib/modules/wap/l2ext.ko

# BBSP_l2_extended end

# BBSP_l3_basic
echo "Loading BBSP L3_basic modules: "
insmod /lib/modules/wap/hw_ssp_gpl_ext.ko

echo 16000 > /proc/sys/net/nf_conntrack_max 2>>/var/xcmdlog

echo 1 > proc/sys/net/netfilter/nf_conntrack_tcp_be_liberal 2>>/var/xcmdlog

iptables-restore -n < /etc/wap/sec_init

insmod /lib/modules/wap/hw_module_trigger.ko
insmod /lib/modules/wap/l3base.ko

#  load DSP modules
if [ $pots_num -ne 0 ]
then    
    echo "Loading DSP temporary modules: "
    insmod /lib/modules/wap/hw_module_dopra.ko
    insmod /lib/modules/wap/hw_module_dsp_sdk.ko
    insmod /lib/modules/wap/hw_module_dsp.ko
fi
#if file is existed ,don't excute

#add by zengwei for ip_forward and rp_filter nf_conntrack_tcp_be_liberal
#enable ip forward
echo 1 > /proc/sys/net/ipv4/ip_forward
#disable rp filter
echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
#end of add by zengwei for ip_forward and rp_filter nf_conntrack_tcp_be_liberal
# BBSP_l3_basic end

# BBSP_l3_extended
if [ $l3_ex -eq 0 ]
then    
    echo "NO L3_extended!"
else 
    echo "Loading BBSP L3_extended modules: "
	insmod /lib/modules/linux/kernel/net/ipv4/ip_tunnel.ko
    insmod /lib/modules/linux/kernel/net/ipv4/gre.ko
    insmod /lib/modules/linux/kernel/net/ipv4/ip_gre.ko
    insmod /lib/modules/wap/napt.ko
    insmod /lib/modules/wap/l3ext.ko
    insmod /lib/modules/wap/hw_module_conenat.ko
    insmod /lib/modules/wap/l3sfwd.ko

fi
# BBSP_l3_extended end

# BBSP_Ipv6_feature
if [ $ipv6 -eq 0 ]
then    
    echo "NO ipv6!"
else 
    echo "Loading BBSP IPv6 modules: "
	insmod /lib/modules/linux/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko
	insmod /lib/modules/linux/kernel/net/ipv6/netfilter/ip6_tables.ko
	insmod /lib/modules/linux/kernel/net/ipv6/netfilter/ip6table_filter.ko
	insmod /lib/modules/linux/kernel/net/ipv6/netfilter/ip6table_mangle.ko
	insmod /lib/modules/linux/kernel/net/ipv6/netfilter/ip6t_REJECT.ko
	
	insmod /lib/modules/linux/kernel/net/ipv6/tunnel6.ko
	insmod /lib/modules/linux/kernel/net/ipv6/ip6_tunnel.ko
	insmod /lib/modules/wap/wap_ipv6.ko
fi
# BBSP_Ipv6_feature end

# BBSP_hw_route
if [ $hw_route -eq 0 ]
then    
    echo "NO hw_rout!"
else 
    echo "Loading BBSP hw_rout modules: "
    insmod /lib/modules/wap/l3ext.ko
    insmod /lib/modules/wap/wap_ipv6.ko
fi

insmod /lib/modules/wap/bbsp_l3_adpt.ko
insmod /lib/modules/wap/ethoam_adpt.ko
insmod /lib/modules/wap/btv_adpt.ko

# BBSP_hw_route end

if [ $ssid_num -ne 0 ]
then
    insmod /lib/modules/wap/wifi_fwd.ko
fi

#add by zhaochao for ldsp_user
iLoop=0
echo -n "Start ldsp_user..."
if [ -e /bin/hw_ldsp_cfg ]
then
  hw_ldsp_cfg &
  while [ $iLoop -lt 50 ] && [ ! -e /var/hw_ldsp_tmp.txt ] 
  do
    #echo $iLoop
    iLoop=$(( $iLoop + 1 ))
    sleep 0.1
  done
  
  if [ -e /var/hw_ldsp_tmp.txt ]
  then 
      rm -rf /var/hw_ldsp_tmp.txt
  fi
fi

if [ -e /bin/hw_ldsp_xpon_adpt ]
then
    hw_ldsp_xpon_adpt &
fi
#end for hw_ldsp_cfg进行单板差异化配置，必须放在前面启动

iLoop=0
if [ -e /bin/hw_ldsp_cfg ]
then
  while [ $iLoop -lt 100 ] && [ ! -e /var/epon_up_mode.txt ] && [ ! -e /var/gpon_up_mode.txt ] && [ ! -e /var/ge_up_mode.txt ] 
  do
    #echo $iLoop
    iLoop=$(( $iLoop + 1 ))
    sleep 0.1
  done
fi

if [ -e /var/SD5116L.txt ]; then 
	[ -f /var/runinram ] && /bin/ramstart.sh && exit
fi

var_proc_name="ssmp bbsp igmp amp ldspcli"

if [ $pots_num -ne 0 ]
then
    var_proc_name=$var_proc_name" voice"
fi

if [ -e /var/gpon_up_mode.txt ]
then
    var_proc_name=$var_proc_name" omci"
fi

if [ -e /var/epon_up_mode.txt ]
then
    var_proc_name=$var_proc_name" oam"
fi

if [ $ssid_num -ne 0 ]
then
    var_proc_name=$var_proc_name" wifi"
fi

#Feature特性决定ldsp_dect
feature_dect=`GetFeature VOICE_FT_DECT_FEATURE`
if [ $feature_dect -eq 1 ] ;then
    var_proc_name=$var_proc_name" ldsp_dect"
fi

echo $var_proc_name

start $var_proc_name&


ssmp &

ldspcli equip &

bbsp equip &

amp equip &

if [ -e /var/gpon_up_mode.txt ]
then
    omci &
fi 

if [ -e /var/epon_up_mode.txt ]
then
    oam &
fi

if [ $ssid_num -ne 0 ]
then
    echo -n "Start WIFI..."
    wifi &
fi

igmp &

#Feature特性决定ldsp_dect
if [ $feature_dect -eq 1 ] ;then
	ldsp_dect &
fi

#if file is existed ,don't excute
if [ $pots_num -eq 0 ]
then    
	echo -n "Do not start VOICE..."
else 
    echo -n "Start VOICE ..."
	[ -f /bin/voice_h248 ] && voice_h248 equip&
	[ -f /bin/voice_sip ] && voice_sip equip&
	[ -f /bin/voice_h248sip ] && voice_h248sip equip&
fi

#通过特性开关来启动usb_mngt进程
usb_enble=`GetFeature HW_SSMP_FEATURE_USB`
if [ $usb_enble = 1 ];then
	while true;
	do
		sleep 10
		echo -n "Start usb_mngt..."
		usb_mngt& break;
	done &
fi 


while true; do 
    sleep 1
    # 如果ssmploadconfig文件存在，表示消息服务启动成功，可以启动PM进程了
    if [ -f /var/ssmploadconfig ]; then
	    procmonitor ssmp & break
	fi
done &

# After system up, drop the page cache.
while true; do sleep 30 ; echo 3 > /proc/sys/vm/drop_caches ; echo "Dropped the page cache."; break; done &
while true; do sleep 40 ; mu& break; done &

# Print system process status for debug.
ps

sleep 6

#skb内存池
feature_double_wlan=`GetFeature HW_AMP_FEATURE_DOUBLE_WLAN`
feature_11ac=`GetFeature HW_AMP_FEATURE_11AC`
if [ $feature_double_wlan = 1 ] || [ $feature_11ac = 1 ];then

	if [ -f /var/runinram ]; then
		echo "In MU Upgrade Mode, not need installed skpool!"
	else
		insmod /lib/modules/wap/skpool.ko
		echo "skpool installed ok!"
	fi
fi

echo "Start flash aging test..."
/mnt/jffs2/equipment/bin/aging &


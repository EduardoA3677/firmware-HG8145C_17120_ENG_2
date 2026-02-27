#! /bin/sh

# 输入参数变量
var_bin_ft_word=$(echo $1 | tr a-z A-Z)
var_cfg_ft_word_init=$(echo $2 | tr a-z A-Z)
var_cfg_ft_word_en=$(echo $2 | tr a-z A-Z)
var_ssid=$3
var_wpa=$4
var_input_para=$*
var_is_HGU=1
var_is_ENBG=0
var_para_num=$#
var_customize_telmex=/mnt/jffs2/TelmexCusomizePara

# 全局的文件变量
var_etc_default_ctree_file="/etc/wap/hw_default_ctree.xml"
var_jffs2_default_ctree_file="/mnt/jffs2/hw_default_ctree.xml"
var_jffs2_ctree_file="/mnt/jffs2/hw_ctree.xml"
var_jffs2_ctree_bak_file="/mnt/jffs2/hw_ctree_bak.xml"
var_jffs2_ctree_tmp_file="/mnt/jffs2/hw_ctree_tmp.xml"
var_jffs2_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_jffs2_boardinfo_temp="/mnt/jffs2/hw_boardinfo.temp"
var_boardinfo_bakfile="/mnt/jffs2/hw_boardinfo.bak"
var_jffs2_customize_txt_file="/mnt/jffs2/customize.txt"
var_telnet_flag="/mnt/jffs2/ProductLineMode"
var_hw_hardinfo_feature="/mnt/jffs2/hw_hardinfo_feature"
var_hw_hardinfo_feature_back="/mnt/jffs2/hw_hardinfo_feature.bak"

# 其它变量
var_pack_temp_dir=/bin/

#新增企业网防串货特性，会在配置特征字后添加_ENBG
var_cfg_ft_word_en=`echo $var_cfg_ft_word_init | sed 's/_ENBG$//g'`
if [ $var_cfg_ft_word_init != $var_cfg_ft_word_en ];then
	var_is_ENBG=1
fi

var_upcase_cfg_ft_word=$(echo $var_cfg_ft_word_en | tr '[a-z]' '[A-Z]')
var_BUCPEkeycfg=$(expr match "$var_upcase_cfg_ft_word" '.*\(BUCPE\).*')

#判断配置特征字是否包含:字符,var_cfg_ft_word 和 var_cfgfileword JSCT:8X2X定制 var_cfg_ft_word=JSCT，cfgfileword=8X2X
#将回显输入到空设备文件
echo $var_cfg_ft_word_en | grep : > /dev/null
if [ $? == 0 ]
then
	var_cfg_ft_word=`echo $var_cfg_ft_word_en | tr a-z A-Z | cut -d : -f1 `
	var_typeword=`echo $var_cfg_ft_word_en | tr a-z A-Z | cut -d : -f2 `
	var_bucpe=`echo $var_cfg_ft_word_en | tr a-z A-Z | cut -d : -f3 `
else
	var_cfg_ft_word=`echo $var_cfg_ft_word_en | tr a-z A-Z`
	var_typeword=""
fi

if [ "$var_typeword" = "BUCPE" ] || [ "$var_cfg_ft_word_en" = "CHOOSE_BUCPE" ] ; then
	if [ -f $var_hw_hardinfo_feature ]
	then
		echo 'feature.name="HW_SSMP_FEATURE_GXBMONITOR" feature.enable="1" feature.attribute="0"' >> $var_hw_hardinfo_feature
	else 
		echo 'feature.name="HW_SSMP_FEATURE_GXBMONITOR" feature.enable="1" feature.attribute="0"' > $var_hw_hardinfo_feature
	fi
	
	cp -rf $var_hw_hardinfo_feature $var_hw_hardinfo_feature_back
	var_typeword=""
fi

if [ "$var_bucpe" = "BUCPE" ] || [ "$var_BUCPEkeycfg" = "BUCPE" ]; then
	if [ -f $var_hw_hardinfo_feature ]
	then
		echo 'feature.name="HW_SSMP_FEATURE_GXBMONITOR" feature.enable="1" feature.attribute="0"' >> $var_hw_hardinfo_feature
	else 
		echo 'feature.name="HW_SSMP_FEATURE_GXBMONITOR" feature.enable="1" feature.attribute="0"' > $var_hw_hardinfo_feature
	fi
	
	cp -rf $var_hw_hardinfo_feature $var_hw_hardinfo_feature_back
fi

var_cfg_ft_word_save=`echo $var_cfg_ft_word_init | tr a-z A-Z`
var_cfg_ft_word1=$var_cfg_ft_word

var_cfg_ft_word_choose=$(echo $(echo $var_cfg_ft_word | cut -b -7) | tr a-z A-Z)

HW_Check_Boardinfo()
{
	if [ -f $var_jffs2_boardinfo_file ]; then
		return 0;
	else
		echo "ERROR::$var_jffs2_boardinfo_file is not exist!"
		return 1;
	fi
}

# 通过cfgtool设置程序特征字和配置特征字，这个操作在装备资源校验完成后执行
HW_Set_Feature_Word()
{
	#程序特征字的ID为0x0000001a，配置特征字的ID为0x0000001b,
	#这个是跟DM的代码保持一致的，产品平台存在强耦合，不能随意更改

	#判断配置特征字是否以WIFI结尾，如果是则删除
	var_cfg_ft_word_temp=`echo "$var_cfg_ft_word" | sed 's/WIFI$//g'`

	#如果是免预配置，电信定制为E8C E8C，联通定制为COMMON UNICOM
	if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ] ; then
		if [ "$var_bin_ft_word" = "E8C" ] ; then
			var_cfg_ft_word_temp="E8C"
		fi

		if [ "$var_bin_ft_word" = "CMCC" ];then
			var_cfg_ft_word_temp="CMCC"
		fi
		
		if [ "$var_bin_ft_word" = "CMCC_RMS" ];then
			var_cfg_ft_word_temp="CMCC_RMS"
		fi
		
		if [ "$var_bin_ft_word" = "BZTLF2" ];then
			var_cfg_ft_word_temp="BZTLF2"
		fi

		if [ "$var_cfg_ft_word" = "CHOOSE_UNICOMBRI" ];then
			var_cfg_ft_word_temp="UNICOMBRI"
		fi
	fi
	
	if [ "$var_cfg_ft_word_temp" = "CMCC_RMS2" ] ; then
		var_cfg_ft_word_temp="CMCC_RMS"
	fi

	#检查boardinfo是否存在
	HW_Check_Boardinfo
	if [ ! $? == 0 ]
	then
		echo "ERROR::Failed to Check Boardinfo!"
		return 1
	fi

	echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x0000001a\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x0000001a\" ; obj.value = \"'$var_bin_ft_word'\"/g' -i

	echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x0000001b\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x0000001b\" ; obj.value = \"'$var_cfg_ft_word_temp'\"/g' -i

    # 清除loid
    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000003\" ; obj.value = .*/obj.id = \"0x00000003\" ; obj.value = \"\";/g' -i
    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000004\" ; obj.value = .*/obj.id = \"0x00000004\" ; obj.value = \"\";/g' -i
    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000005\" ; obj.value = .*/obj.id = \"0x00000005\" ; obj.value = \"\";/g' -i
    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000006\" ; obj.value = .*/obj.id = \"0x00000006\" ; obj.value = \"\";/g' -i
    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000016\" ; obj.value = .*/obj.id = \"0x00000016\" ; obj.value = \"\";/g' -i
    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000017\" ; obj.value = .*/obj.id = \"0x00000017\" ; obj.value = \"\";/g' -i

	#根据配置特征字后是否带_ENBG判断其是否为企业网ONT，企业网为@EN#Common&，其它运营商为@CN#Common&
	if [ 1 == $var_is_ENBG ];then
		echo $var_jffs2_boardinfo_file | xargs sed 's/^obj.id = \"0x0000003a\".*$/obj.id = \"0x0000003a\" ; obj.value = \"\@EN\#Common\&\"/g' -i
	else
		echo $var_jffs2_boardinfo_file | xargs sed 's/^obj.id = \"0x0000003a\".*$/obj.id = \"0x0000003a\" ; obj.value = \"\@CN\#Common\&\"/g' -i
	fi
	
	#保存程序特征字和配置特征字到文件/mnt/jffs2/customize.txt，getcustomize.sh从这个文件中读取，为了保证boardinfo能够完全写入，需要放在最后面
	echo $var_bin_ft_word $var_cfg_ft_word_save > $var_jffs2_customize_txt_file
}

#设置typeword字段
HW_Customize_Set_CFGTypeFile()
{
	#后面会进行检查，再次不检查boardinfo是否存在
	echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000035\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x00000035\" ; obj.value = \"'$1'\"/g' -i
	return 0
}

#设置cfg fileword
HW_Set_CfgFile_Word()
{
	if [ -z "$var_typeword" ]
	then
		HW_Customize_Set_CFGTypeFile ""
		#不带typeword，删去typeword文件（之前定制的typeword）
		rm -f /mnt/jffs2/typeword
	else
		HW_Customize_Set_CFGTypeFile "$var_typeword"
	fi
	return 0
}

# 参数检测
HW_Customize_Check_Arg()
{
	if [ -z "$var_bin_ft_word" ] || [ -z "$var_cfg_ft_word" ]
	then
		echo "ERROR::The binfeature word and cfgword should not be null!"
		return 1
	fi

	return 0
}

# 如果是COMMON_WIFI ~COMMON定制，则将BinWord由COMMON_WIFI->COMMON，依然走定制流程
# 如果CfgWord以wifi结尾，则去掉"wifi"字符串
HW_Change_Customize_Parameter()
{
	if [ "$var_bin_ft_word" = "COMMON_WIFI" ] ; then
	{
		var_bin_ft_word="COMMON"
	}
	fi

	#判断配置特征字是否以WIFI结尾，如果是则删除
	var_cfg_ft_word_temp=`echo "$var_cfg_ft_word" | sed 's/WIFI$//g'`

	shift 2

	var_input_para="$var_bin_ft_word ""$var_cfg_ft_word_temp ""$*"

	return 0
}

# 如果CfgWord中去掉_SIP或者_H248字符
HW_Change_Customize_ParameterForVspa()
{
	#如果配置特征字中没有_SIP或者_H248则直接返回，不显示
	echo $var_cfg_ft_word | grep -iE "_SIP|_H248" > /dev/null
	if [ ! $? == 0 ]
	then
		return 0
	fi

	#删除配置特征字中去掉'_'后字符，并重新构造配置参数，作为Customize程序的参数
	var_cfg_ft_word_temp=`echo "$var_cfg_ft_word" | sed 's/_.*//g'`
	shift 2  #输入参数左移动2个
	var_input_para="$var_bin_ft_word ""$var_cfg_ft_word_temp ""$*"
	return 0
}

#设置CHOOSE字段
HW_Customize_Set_Choose()
{
	#后面会进行检查，再次不检查boardinfo是否存在
	echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000031\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x00000031\" ; obj.value = \"'$1'\"/g' -i
	return 0
}

# 资源检测
HW_Customize_Check_Resource()
{
	#HGU需要关注免预配置定制,需要涉及CHOOSE_WORD字段修改，SFU则可以直接传入
	if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ] \
	|| [ "$var_cfg_ft_word" = "UNICOM" ] \
	|| [ "$var_cfg_ft_word" = "UNICOM_BUCPE" ] \
	|| [ "$var_cfg_ft_word" = "UNICOMBRIDGE" ] \
	|| [ "$var_cfg_ft_word" = "BZTLF2" ] \
	|| [ "$var_cfg_ft_word" = "BZTLF2WIFI" ] \
	|| [ "$var_cfg_ft_word" = "CMCC" ] \
	|| [ "$var_cfg_ft_word" = "CMCC_BUCPE" ] \
	|| [ "$var_cfg_ft_word" = "CMCCWIFI" ] \
	|| [ "$var_cfg_ft_word" = "CMCC_RMS" ] \
	|| [ "$var_cfg_ft_word" = "CMCC_RMS2" ]  \
	|| [ "$var_cfg_ft_word" = "CMCC_RMS2WIFI" ]  \
	|| [ "$var_cfg_ft_word" = "CMCC_RMSWIFI" ] \
	|| [ "$var_cfg_ft_word" = "CMCC_RMSBRIDGE" ]; then
		shift 2
		if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ]; then
			var_input_para="$var_bin_ft_word ""$var_cfg_ft_word1 ""$*"
		elif [ "$var_cfg_ft_word" = "CMCCWIFI" ]; then
			var_input_para="$var_bin_ft_word ""CHOOSE_CMCC ""$*"	
		elif [ "$var_cfg_ft_word" = "CMCC_RMS2WIFI" ]; then
			var_input_para="$var_bin_ft_word ""CHOOSE_CMCC_RMS2 ""$*"
		elif [ "$var_cfg_ft_word" = "CMCC_RMSWIFI" ]; then
			var_input_para="$var_bin_ft_word ""CHOOSE_CMCC_RMS ""$*"
		elif [ "$var_cfg_ft_word" = "BZTLF2WIFI" ]; then
			var_input_para="$var_bin_ft_word ""CHOOSE_BZTLF2 ""$*"
		else
			if [ $var_is_HGU -eq 1 ] ; then
			var_input_para="$var_bin_ft_word ""CHOOSE_$var_cfg_ft_word1 ""$*"
			else
				var_input_para="$var_bin_ft_word ""$var_cfg_ft_word1 ""$*"
			fi
		fi
	fi

	#现在TELMEX只支持12个参数（customize.sh后面的），格式如下：
	#customize.sh COMMON TELMEX SSID WEP_KEY PPPoE_user PPPoE_pwd TR069_user TR069_pwd WEB_pwd CLI_user CLI_pwd  WPA_pwd
	if [ $var_cfg_ft_word == "TELMEX" ]
	then
		#对于之前的已经用5个参数定制的整机，返工场景（重新定制，要删除该文件，否则定制检查会失败）
		if [ -f $var_customize_telmex ]
		then
			rm -rf $var_customize_telmex
		fi
		#只支持12个参数（除customize.sh以外的其他参数）
		if [ 12 -ne $var_para_num ]
		then
			echo "ERROR::input para must be COMMON TELMEX SSID WEP_KEY PPPoE_user PPPoE_pwd TR069_user TR069_pwd WEB_pwd CLI_user CLI_pwd  WPA_pwd !"
			return 1
		fi
	fi

	# 调用Customize进程进行装备资源的校验, 把文件暂时写入typeword 暂时写入/mnt/jffs2/typeword 文件。 如果不通过文件传递，通过argv 传递
	# 需要函数扩展的函数有十个左右，且在Customize APP 中需要扩展解析该字段。
	if [ -f /mnt/jffs2/typeword ]; then
		cp -f /mnt/jffs2/typeword /mnt/jffs2/typeword_bak
	fi
	echo $var_typeword > /mnt/jffs2/typeword

	Customize $var_input_para

	var_result=$?

	if [ 0 -eq $var_result ]
	then
		#写boardinfo和文件
		HW_Set_CfgFile_Word
		rm -f /mnt/jffs2/typeword_bak
	else
		#定制失败, 如果存在备份文件,还原备份
		if [ -f /mnt/jffs2/typeword_bak ]; then
			mv -f /mnt/jffs2/typeword_bak /mnt/jffs2/typeword
		else
			#第一次定制失败
			rm -f /mnt/jffs2/typeword
		fi			
	fi

	return 0
}

HW_Customize_Check_PCCWMacCheck()
{
	# 如果是PCCW，需要进行WLAN MAC的校验
	if [ "$var_cfg_ft_word" = "PCCW3MAC" ] || [ "$var_cfg_ft_word" = "PCCW3MACWIFI" ] \
	  || [ "$var_cfg_ft_word" = "PCCW4MAC" ] || [ "$var_cfg_ft_word" = "PCCW4MACWIFI" ]
	then
		pccwmaccheck $var_input_para
		var_pccwresult=$?
	else
		var_pccwresult=0
	fi

	return 0
}

#定制处理
HW_Customize_Delete_File()
{
	rm -f $var_telnet_flag
	rm -f $var_boardinfo_bakfile
	rm -f /mnt/jffs2/smooth_finish
	return 0
}

# 结果输出
HW_Customize_Print_Result()
{
	# 根据不同的执行结果，返回不同的错误内容
	if [ 0 -eq $var_result ]
	then
		#pccw3mac pccw4mac定制中需进行wlanmac的校验
		HW_Customize_Check_PCCWMacCheck $var_input_para
		if [ 0 -eq $var_pccwresult ]
		then
			HW_Set_Feature_Word
			if [ ! $? == 0 ]
			then
				echo "ERROR::Failed to set Feature Word!"
			return 1
		fi
		elif [ 1 -eq $var_pccwresult ]
		then
		echo "ERROR::input para number is not enough!"
		return 1
		elif [ 2 -eq $var_pccwresult ]
		then
		echo "ERROR::SSIDMAC fail!"
		return 1
		else
		echo "ERROR::customize fail!"
		return 1
		fi
		return 0
	elif [ 1 -eq $var_result ]
	then
		echo "ERROR::input para number is not enough!"
		return 1
	elif [ 2 -eq $var_result ]
	then
		echo "ERROR::Updateflag file is not existed!"
		return 1
	elif [ 3 -eq $var_result ]
	then
		echo "ERROR::config tar file is not existed!"
		return 1
	elif [ 4 -eq $var_result ]
	then
		echo "ERROR::Null pointer!!"
		return 1
	elif [ 5 -eq $var_result ]
	then
		echo "ERROR::XML parse fail!!"
		return 1
	elif [ 6 -eq $var_result ]
	then
		echo "ERROR::XML get node or attribute fail!"
		return 1
	elif [ 7 -eq $var_result ]
	then
		echo "ERROR::XML get relation node fail!"
		return 1
	elif [ 8 -eq $var_result ]
	then
		echo "ERROR::Spec file is not existed!"
		return 1
	elif [ 9 -eq $var_result ]
	then
		echo "ERROR::Set bin word fail!"
		return 1
	elif [ 10 -eq $var_result ]
	then
		echo "ERROR::Set config word fail!"
		return 1
	elif [ 11 -eq $var_result ]
	then
		echo "ERROR::Uncompress tar fail!"
		return 1
	elif [ 12 -eq $var_result ]
	then
		echo "ERROR::Config file is not existed!"
		return 1
	elif [ 13 -eq $var_result ]
	then
		echo "ERROR::Recover file is ont existed!"
		return 1
	elif [ 14 -eq $var_result ]
	then
		echo "ERROR::Run script fail!"
		return 1
	elif [ 15 -eq $var_result ]
	then
		echo "ERROR::Create new recover config file fail!"
		return 1
	elif [ 16 -eq $var_result ]
	then
		echo "ERROR::Create old recover config file fail!"
		return 1
	elif [ 17 -eq $var_result ]
	then
		echo "ERROR::Copy spec default ctree fail!"
		return 1
	elif [ 18 -eq $var_result ]
	then
		echo "ERROR::Check Choose Res fail!"
		return 1
	elif [ 19 -eq $var_result ]
	then
		echo "ERROR::Resolver customize file fail!"
		return 1
	else
		echo "ERROR::customize fail!"
		return 1
	fi

	return 0
}

#HGU才支持免预配置，在此做判断
HW_Customize_CheckIsHGU()
{
	cat /proc/wap_proc/pd_static_attr | grep -w pdt_type | grep HGU > /dev/null
	if [ $? -eq 0 ] ; then
		return 1
	fi

	return 0
}

#echo /proc/pdt_proc/save_boardinfo to save boardinfo for add chooseid
echo "1" >  /proc/pdt_proc/save_boardinfo

#参数检测：至少应该包含BinWord&SpecWord
HW_Customize_Check_Arg
[ ! $? == 0 ] && exit 1

#参数处理
HW_Change_Customize_Parameter $var_input_para

#参数处理，主要是将配置特征字中的_SIP和_H248进行过滤
HW_Change_Customize_ParameterForVspa $var_input_para

#HGU才可以免预配置定制，免预配置定制才涉及CHOOSE_WORD的处理
HW_Customize_CheckIsHGU
if [ $? -eq 0 ] ; then
	var_is_HGU=0
fi

#免预配置模式，添加NOCHOOSE字段，并初始化为CHOOSE_XXX
if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ] \
|| [ "$var_cfg_ft_word" = "UNICOM" ] \
|| [ "$var_cfg_ft_word" = "UNICOM_BUCPE" ] \
|| [ "$var_cfg_ft_word" = "UNICOMBRIDGE" ] \
|| [ "$var_cfg_ft_word" = "BZTLF2" ] \
|| [ "$var_cfg_ft_word" = "BZTLF2WIFI" ] \
|| [ "$var_cfg_ft_word" = "CMCC" ] \
|| [ "$var_cfg_ft_word" = "CMCC_BUCPE" ] \
|| [ "$var_cfg_ft_word" = "CMCCWIFI" ] \
|| [ "$var_cfg_ft_word" = "CMCC_RMS" ] \
|| [ "$var_cfg_ft_word" = "CMCC_RMS2" ] \
|| [ "$var_cfg_ft_word" = "CMCC_RMSWIFI" ] \
|| [ "$var_cfg_ft_word" = "CMCC_RMS2WIFI" ] \
|| [ "$var_cfg_ft_word" = "CMCC_RMSBRIDGE" ] ; then
{
	#HW_Customize_Add_Choose
	if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ]; then
		HW_Customize_Set_Choose "$var_cfg_ft_word"
	elif [ "$var_cfg_ft_word" = "UNICOMBRIDGE" ] ; then
		HW_Customize_Set_Choose "CHOOSE_UNICOM"	
	elif [ "$var_cfg_ft_word" = "BZTLF2WIFI" ] ; then
		HW_Customize_Set_Choose "CHOOSE_BZTLF2"
	elif [ "$var_cfg_ft_word" = "CMCC_RMSBRIDGE" ] ; then
		HW_Customize_Set_Choose "CHOOSE_CMCC_RMS"
	elif [ "$var_cfg_ft_word" = "CMCC" ] ; then
		HW_Customize_Set_Choose "CHOOSE_$var_cfg_ft_word"
	elif [ "$var_cfg_ft_word" = "CMCCWIFI" ] ; then
		HW_Customize_Set_Choose "CHOOSE_CMCC"
	elif [ "$var_cfg_ft_word" = "CMCC_RMSWIFI" ] ; then
		HW_Customize_Set_Choose "CHOOSE_CMCC_RMS"
	elif [ "$var_cfg_ft_word" = "CMCC_RMS2WIFI" ] ; then
		HW_Customize_Set_Choose "CHOOSE_CMCC_RMS2"
	elif [ "$var_cfg_ft_word" = "CMCC_BUCPE" ] ; then
		HW_Customize_Set_Choose "CHOOSE_CMCC_BUCPE"
	elif [ "$var_cfg_ft_word" = "UNICOM_BUCPE" ] ; then
		HW_Customize_Set_Choose "CHOOSE_UNICOM_BUCPE"
	else
		#COMMON/UNICOM定制只有HGU支持免预配置
		if [ $var_is_HGU -eq 1 ]; then
			HW_Customize_Set_Choose "CHOOSE_$var_cfg_ft_word"
		else
			HW_Customize_Set_Choose ""
		fi
	fi
}
else
{
	HW_Customize_Set_Choose ""
}
fi

HW_Customize_Check_Resource $var_input_para
[ ! $? == 0 ] && exit 1

# 结果输出
HW_Customize_Print_Result $var_input_para
[ ! $? == 0 ] && exit 1

#定制处理
HW_Customize_Delete_File

sync
echo "success!" && exit 0



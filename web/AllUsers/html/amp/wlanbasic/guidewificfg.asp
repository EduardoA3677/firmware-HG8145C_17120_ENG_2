<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>
<script language="javascript" src="../common/wlan_extended.asp"></script>
<title>WiFi Configuration</title>
<script language="JavaScript" type="text/javascript">

var wlan1 = null;
var wlan5 = null;
var wlan5_exist = false;
var allPsk;
var allWep;
var encryTypeArr = new Array();
var pwdNoticeArr = new Array("pwd_notice", "pwd_notice_5G");
var psk1 = "";
var psk5 = "";
var wep1 = "";
var wep5 = "";
var url = "";

var wifiPasswordMask='<%HW_WEB_GetWlanPsdMask();%>';

var IsSurportInternetCfg  = "<%HW_WEB_GetFeatureSupport(BBSP_FT_GUIDE_PPPOE_WAN_CFG);%>";
var mngttype = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SONET);%>';

function stWEPKey(domain, value)
{
    this.domain = domain;
    this.value = value;
}

function stPreSharedKey(domain, value)
{
    this.domain = domain;
    this.value = value;
}

allPsk = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.PreSharedKey.1,PreSharedKey,stPreSharedKey);%>;
allWep = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.WEPKey.{i},WEPKey,stWEPKey);%>;

function getWlan()
{
	wlan1 = getFirstSSIDInst(1, allWlanInfo);	
	if(null != wlan1)
	{
		psk1 = getPsk(wlan1.InstId, allPsk);
		wep1 = getWep(wlan1.InstId, wlan1.KeyIndex, allWep);
	}

	if(1 == DoubleFreqFlag)
	{
		wlan5 = getFirstSSIDInst(2, allWlanInfo);
		wlan5_exist = (null != wlan5);
		if(wlan5_exist)
		{
			psk5 = getPsk(wlan5.InstId, allPsk);
			wep5 = getWep(wlan5.InstId, wlan5.KeyIndex, allWep);
		}
	}
}

function initWlanEncType(wlan)
{
	var idx = wlan==wlan1?0:1;
	
	if(wlan.BeaconType == 'Basic')
	{
		if(wlan.BasicEncryptionModes == 'WEPEncryption')
		{
			encryTypeArr[idx] = "wep";
		}
		else
		{
			encryTypeArr[idx] = "none";
		}
	}
	else
	{
		encryTypeArr[idx] = "psk";
	}
	
	if(encryTypeArr[idx] == "wep")
	{
		if("104-bit" == wlan.WEPEncryptionLevel)
		{
			getElById(pwdNoticeArr[idx]).innerHTML = cfg_wlancfgdetail_language['amp_encrypt_keynote_128'];
		}
		else
		{
			getElById(pwdNoticeArr[idx]).innerHTML = cfg_wlancfgdetail_language['amp_encrypt_keynote_64'];
		}
	}
	else
	{
		getElById(pwdNoticeArr[idx]).innerHTML = cfg_wlancfgdetail_language['amp_wpa_psknote'];
	}	
}

function GetInternetFlag()
{
	if (IsSurportInternetCfg == "1" && mngttype == "0")
	{
		return true;
	}
	return false;
}

function SubmitPwd(val)
{
	window.parent.onchangestep("guidesystemcfg.asp");	
}

if(allWlanInfo != null && allWlanInfo.length > 1)
{
	allWlanInfo.pop();
	
	allWlanInfo.sort(function(s1, s2)
	    {
	        return parseInt(s1.name.charAt(s1.name.length - 1), 10) - parseInt(s2.name.charAt(s2.name.length - 1), 10);
	    }
	);
}

function isShowWifiName()
{
	return !IsSonetSptUser();
}

function checkWep(val, keyBit)
{
	if ( val != '' && val != null)
	{
	   if ( keyBit == '104-bit' )
	   {
		   if (isValidKey(val, 13) == false )
		   {
			   AlertEx(cfg_wlancfgdetail_language['amp_key_check1'] + val + cfg_wlancfgdetail_language['amp_key_invalid1']);
			   return false;
		   }
	   }
	   else
	   {
		   if (isValidKey(val, 5) == false )
		   {
			   AlertEx(cfg_wlancfgdetail_language['amp_key_check1'] + val + cfg_wlancfgdetail_language['amp_key_invalid2']);
			   return false;
		   }
	   }
	}
	else
	{
	   AlertEx(cfg_wlancfgdetail_language['amp_wifipwd_empty']);
	   return false;
	}
	return true;
}

function CheckPsk(value)
{
	if (value == '')
	{
		AlertEx(cfg_wlancfgdetail_language['amp_wifipwd_empty']);
		return false;
	}

	if (isValidWPAPskKey(value) == false)
	{
		AlertEx(cfg_wlancfgdetail_language['amp_wifipwd_invalid']);
		return false;
	}

	return true;
}

function addParaWlan(wlan, form)
{
    var wlanInst = wlan.InstId;
    var idx = wlan==wlan1?0:1;
    var wlanDomain = "InternetGatewayDevice.LANDevice.1.WLANConfiguration." + wlanInst;
	var pwd = idx?getValue("pwd_wifipw_5G"):getValue("pwd_wifipw");
	var ssid = idx?getValue("txt_wifiname_5G"):getValue("txt_wifiname");
	
    if(!CheckSsid(ssid))
    {
        return false;
    }

    wlan.ssid = ssid;
    if(checkSSIDExist(wlan, allWlanInfo))
    {
        return false;
    }
    WifiCoverParaDefault(wlan, wlanInst);
	
    if(encryTypeArr[idx] == "wep")
    {	
        var wep1Domain = wlanDomain + ".WEPKey." + wlan.KeyIndex;
        if(!checkWep(pwd, wlan.WEPEncryptionLevel))
        {
            return false;
        }		
		
        form.addParameter('wep'+idx+'.WEPKey', pwd);
        url += "wep"+idx+"="+wep1Domain+"&";
        setCoverSsidNotifyFlag("", pwd, ENUM_Key);		
    }
    else
    {
        var pskDomain = "InternetGatewayDevice.LANDevice.1.WLANConfiguration."+wlanInst+".PreSharedKey.1";
        if(!CheckPsk(pwd))
	    {
            return false;
        }	    		
		
        form.addParameter('psk'+idx+'.PreSharedKey', pwd);
        url += "psk"+idx+"="+pskDomain+"&";
        setCoverSsidNotifyFlag("", pwd, ENUM_Key);		
    }
	
    if(encryTypeArr[idx] == "none")
    {
        form.addParameter('w'+idx+'.BeaconType', "WPAand11i");
        Form.addParameter('w'+idx+'.X_HW_WPAand11iAuthenticationMode','PSKAuthentication');
        form.addParameter('w'+idx+'.X_HW_WPAand11iEncryptionModes', "TKIPandAESEncryption");
        setCoverSsidNotifyFlag("", "WPAand11i", ENUM_BeaconType);
        setCoverSsidNotifyFlag("", "TKIPandAESEncryption", ENUM_MixEncryptionModes);
    }
	
    form.addParameter('w'+idx+'.SSID', ssid);
    url += "w"+idx+"="+wlanDomain+"&";
    SubmitWIfiCoverSsid(form, wlan, wlanInst);
	
    return true;
}

function SubmitForm(val)
{
    Form = window.parent.wifiForm;
    url = '';
    url_new = 'set.cgi?';
	
    if((null != wlan1) && !addParaWlan(wlan1, Form))
    {
        return ;
    }
    if(wlan5_exist)
    {
        if(!addParaWlan(wlan5, Form))
        {
            return ;
        }
    }
    url_new += url;
    Form.setAction(url_new + 'RequestFile=/html/ssmp/accoutcfg/guideaccountcfg.asp');						
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	
    guide_skip($('#guidesyscfg')[0]);
}

function setPwdText(idx)
{
	var pwdId = idx?"pwd_wifipw_5G":"pwd_wifipw";
	var txtId = idx?"txt_wifipw_5G":"txt_wifipw";
	if(encryTypeArr[idx] == "none")
	{
		setText(pwdId, "");
	}
	else
	{
		var pwd = (encryTypeArr[idx] == "wep")?(idx?wep5:wep1):(idx?psk5:psk1);
		setText(pwdId, pwd);
		setText(txtId, pwd);
	}
}

function LoadFrame()
{
	$("*").css("font-family", "微软雅黑");
	
	$(".textboxbg").addClass('tx_input');
	
	$("#guidesyscfg").width($("#span_skip").width());
    
    getWlan();
	
    if(null != wlan1)
	{
		initWlanEncType(wlan1);
		setText("txt_wifiname", wlan1.ssid);
		setPwdText(0);
	}
			
    setDisable("txt_wifiname", null==wlan1);
    setDisable("pwd_wifipw", null==wlan1);
    setDisable("txt_wifipw", null==wlan1);
    setDisable("cb_2g_pwd", null==wlan1);
    
    setDisable("txt_wifiname_5G", null==wlan5);
    setDisable("pwd_wifipw_5G", null==wlan5);
    setDisable("txt_wifipw_5G", null==wlan5);
    setDisable("cb_5g_pwd", null==wlan5);
    
    setDisable("btnNext", (null==wlan1 && null==wlan5));

	if(isShowWifiName())
	{
        setDisplay("tr_wifiname", 1);
        if(1 == DoubleFreqFlag)
        {
            setDisplay("tr_wifiname_5G", 1);
        }
	}
    if(1 == DoubleFreqFlag)
    {
        setDisplay("tr_wifipw_5G", 1);
        if(null != wlan5)
		{
			initWlanEncType(wlan5);
			setText("txt_wifiname_5G", wlan5.ssid);
			setPwdText(1);
        }
    }
}

function showPwd(id)
{
	var pwdId = "pwd_wifipw" + id;
	var txtId = "txt_wifipw" + id;
	
	if(getElById(pwdId).style.display == "none")
	{
		setDisplay(pwdId, 1);
		setDisplay(txtId, 0);
	}
	else
	{
		setDisplay(pwdId, 0);
		setDisplay(txtId, 1);
	}
}

function AddConfigFlag()
{
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/smartguide.cgi?1=1&RequestFile=index.asp',
		data:'Parainfo='+'0',
		success : function(data) {
		 ;
		}
	}); 
}

function guide_pre(obj)
{
	if(false == GetInternetFlag())
	{
		AddConfigFlag();
		window.parent.location="../../../index.asp";
	}
	else
	{
		window.parent.onchangestep(obj);
	}
}

function guide_skip(obj)
{
	if(false == GetInternetFlag())
	{
		AddConfigFlag();
	}
	
	window.parent.onchangestep(obj);
}

</script>
	
<style type="text/css">
    .tx_input
    {
		-webkit-border-radius: 4px;
		-moz-border-radius: 4px;
		border-radius: 4px;
		border: 1px solid #CECACA;
		vertical-align: middle;
		font-family: "微软雅黑";
		font-size: 16px;
		height: 32px;
		width: 228px;
		padding-left: 5px;
		margin-left: 0px;
		line-height: 32px;
		background-color: #ffffff;
    }
	.gray{
		color: #767676;
		font-family: "微软雅黑";
	};
</style>
</head>

<body onLoad="LoadFrame();" style="background-color: #ffffff;margin-top: 35px;">
<div align="center"> 

<table align="center" border="0" cellpadding="5" cellspacing="1">
	<tr>
		<td></td>
		<td colspan="2" align="left" style="font-size:16px;color:#666666;font-weight:bold;padding-bottom: 16px;"><script>document.write(cfg_wifiguide_language['amp_wifiguide_title']);</script></td>    
	</tr>
	<tr id="tr_wifiname" style="display:none;"> 
		<td  class="labelBox"><script>document.write(cfg_wifiguide_language['amp_wifiguide_wifiname_2G']);</script></td>
		<td> <input type="text" name="txt_wifiname" id="txt_wifiname" class="textboxbg" maxlength="32"></td>
	    <td class="gray" style="font-size: 14px; text-align: left;"><script>document.write(cfg_wlancfgdetail_language['amp_linkname_note']);</script></td>
	</tr>
	<tr id="tr_wifipw"> 
		<td class="labelBox"><script>document.write(cfg_wifiguide_language['amp_wifiguide_wifipwd_2G']);</script></td>
		<td> 
			<input type="password" name="pwd_wifipw" id="pwd_wifipw" class="textboxbg" onchange="pwd=getValue('pwd_wifipw');getElById('txt_wifipw').value = pwd;">
			<input type="text" name="txt_wifipw" id="txt_wifipw" class="textboxbg" style="display:none;" onchange="pwd=getValue('txt_wifipw');getElById('pwd_wifipw').value = pwd;">
		</td>
		<td style='text-align: left;'>
			<input  id="cb_2g_pwd" type="checkbox" checked="true" onClick="showPwd('');"/>
			<span class="gray" style="font-size: 14px;"><script>document.write(cfg_wifiguide_language['amp_wifipage_hidepwd']);</script></span>
			<span id="pwd_notice" class="gray" style="font-size: 14px; width:200px; text-align: left;" />
		</td>
	</tr>
    
    
    
    <tr id="tr_wifiname_5G" style="display:none;"> 
		<td  class="labelBox"><script>document.write(cfg_wifiguide_language['amp_wifiguide_wifiname_5G']);</script></td>
		<td> <input type="text" name="txt_wifiname_5G" id="txt_wifiname_5G" class="textboxbg" maxlength="32"></td>
	    <td class="gray" style="font-size: 14px; text-align: left;"><script>document.write(cfg_wlancfgdetail_language['amp_linkname_note']);</script></td>
	</tr>
	<tr id="tr_wifipw_5G" style="display:none;"> 
		<td class="labelBox"><script>document.write(cfg_wifiguide_language['amp_wifiguide_wifipwd_5G']);</script></td>
		<td> 
			<input type="password" name="pwd_wifipw_5G" id="pwd_wifipw_5G" class="textboxbg" onchange="pwd=getValue('pwd_wifipw_5G');getElById('txt_wifipw_5G').value = pwd;">
			<input type="text" name="txt_wifipw_5G" id="txt_wifipw_5G" class="textboxbg" style="display:none;" onchange="pwd=getValue('txt_wifipw_5G');getElById('pwd_wifipw_5G').value = pwd;">
		</td>
		<td style='text-align: left;'>
			<input  id="cb_5g_pwd" type="checkbox" checked="true" onClick="showPwd('_5G');"/>
			<span class="gray" style="font-size: 14px;"><script>document.write(cfg_wifiguide_language['amp_wifipage_hidepwd']);</script></span>
			<span id="pwd_notice_5G" class="gray" style="font-size: 14px; width:200px; text-align: left;" />
		</td>
	</tr>
    
    
	<tr>
	<td></td>
	<td align="left" colspan="2" style="padding-top: 20px;">
		<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		<input id="guideinternet" name="../../html/bbsp/guideinternet/guideinternet.asp" style="margin-left:0px;" type="button" class="CancleButtonCss buttonwidth_100px" onClick="guide_pre(this);">
		<script>
			if(false == GetInternetFlag())
			{
				setText('guideinternet', cfg_wifiguide_language['amp_wifiguide_exit']);
			}
			else
			{
				setText('guideinternet', cfg_wifiguide_language['amp_wifiguide_prestep']);
			}
		</script>
		</input>
		<input id="btnNext" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="SubmitForm(this);">
		<script>getElById('btnNext').value = cfg_wifiguide_language['amp_wifiguide_nextstep'];</script>
		</input>
		<a id="guidesyscfg" name="../../html/ssmp/accoutcfg/guideaccountcfg.asp" href="#" style="display:block; margin-top: -26px;margin-left: 250px;font-size:16px;text-decoration: none;color: #666666;" onclick="guide_skip(this);">
			<span id="span_skip"><script>document.write(cfg_wifiguide_language['amp_wifiguide_skip'])</script></span>
		</a>
	</td>
	</tr>

</table>
</div>
</div>

</body>
</html>

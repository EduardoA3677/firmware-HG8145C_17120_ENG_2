<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(guide.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>
<script language="javascript" src="../common/wlan_extended.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>

<title>WiFi Configuration</title>
<script language="JavaScript" type="text/javascript">
var enbl2G = 0;
var enbl5G = 0;
var wlan1 = null;
var wlan5 = null;

var allPsk;
var allWep;
var wlan5_exist = false;
var encryTypeArr = new Array();
var pwdNoticeArr = new Array("pwd_2g_notice", "pwd_5g_notice");
var wifi2g_enable;
var wifi5g_enable;
var psk1 = "";
var psk5 = "";
var wep1 = "";
var wep5 = "";
var url = "";
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var wifiPasswordMask='<%HW_WEB_GetWlanPsdMask();%>';
var AmpTDESepicalCharaterFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TDE_SEPCIAL_CHARACTER);%>';


function stWEPKey(domain, value)
{
    this.domain = domain;
    this.value = value;
}

function stPreSharedKey(domain, psk, kpp)
{
    this.domain = domain;
    this.value = psk;

    if('1' == kppUsedFlag)
    {
        this.value = kpp;
    }
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

allPsk = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.PreSharedKey.1,PreSharedKey|KeyPassphrase,stPreSharedKey);%>;
allWep = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.WEPKey.{i},WEPKey,stWEPKey);%>;

function isWepChanged(newWep, wlan)
{
	return newWep != getWep(wlan.InstId, wlan.KeyIndex, allWep);
}

function isPskChanged(newPsk, wlan)
{
	return newPsk != getPsk(wlan.InstId, allPsk);
}

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
	    getElById(pwdNoticeArr[idx]).innerHTML = cfg_wlancfgdetail_language['amp_wpa_psknote' + ('1' == kppUsedFlag ? '_63' : '')];
	}
	
}

function initEncType()
{
	initWlanEncType(wlan1);
	
	if(wlan5_exist)
	{
		initWlanEncType(wlan5)
	}
}

function setRadioEnable(id ,enabled)
{
	if(1 == enabled)
	{
		getElById(id).style.background = "url(../../../images/on.jpg) no-repeat";
	}
	else
	{
		getElById(id).style.background = "url(../../../images/off.jpg) no-repeat";
	}
}

function refreshWiFi(flag)
{
	var enable_idArr = new Array("txt_2g_wifiname", "pwd_2g_wifipwd", "cb_2g_hide", "cb_2g_pwd", "txt_2g_wifipwd");
	var radioEnabled;
	
	if(flag)
	{
		for(var i=0; i<enable_idArr.length; i++)
		{
			enable_idArr[i] = enable_idArr[i].replace("2g", "5g");
		}
		radioEnabled = enbl5G;
	}
	else
	{
		radioEnabled = enbl2G;
	}
	
	if(radioEnabled == 1)
	{	
		$.each(enable_idArr,function(n,value) {  
				getElById(value).removeAttribute('disabled');
            });
	}
	else
	{
		$.each(enable_idArr,function(n,value) {  
				getElById(value).disabled = "disabled";
            });  
	}

	if( (curUserType == sysUserType) && ('1' == wifiPasswordMask) )
	{
		getElById("cb_2g_pwd").disabled = 'disabled';
		getElById("cb_5g_pwd").disabled = 'disabled';
	}
}

function EnableWiFi(id)
{		
	var flag;
	var wlan;
	
	if(id=="enable2g")
	{
		enbl2G = 1 - enbl2G;
		flag = 0;
		wlan = wlan1;
		setRadioEnable(id ,enbl2G)
	}
	else
	{
		enbl5G = 1 - enbl5G;
		flag = 1;
		wlan = wlan5;
		setRadioEnable(id ,enbl5G)
	}

	if(null != wlan)
	{
		refreshWiFi(flag);
	}
}

function setPwdText(idx)
{
	var pwdId = idx?"pwd_5g_wifipwd":"pwd_2g_wifipwd";
	var txtId = idx?"txt_5g_wifipwd":"txt_2g_wifipwd";
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
	getWlan();

	if(null != wlan1)
	{
		initWlanEncType(wlan1);

		enbl2G = Radio[0].Enable;
		
		setText("txt_2g_wifiname", wlan1.ssid);
		setPwdText(0);
		getElById("cb_2g_hide").checked = wlan1.SSIDAdvertisementEnabled==1?false:true;
	}
	else
	{
		enbl2G = 0;
	}

	refreshWiFi(0);

	enbl2G = Radio[0].Enable;
	setRadioEnable("enable2g", enbl2G);
	
	if(1 == DoubleFreqFlag)
	{
		setDisplay('tb_5g', 1);
		setDisplay('div_separatrix1', 1);
		
		if(null != wlan5)
		{
			initWlanEncType(wlan5);

			enbl5G = Radio[1].Enable;
			
			setText("txt_5g_wifiname", wlan5.ssid);
			setPwdText(1);
			getElById("cb_5g_hide").checked = wlan5.SSIDAdvertisementEnabled==1?false:true;
		}
		else
		{
			enbl5G = 0;
		}

		refreshWiFi(1);

		enbl5G = Radio[1].Enable;
		setRadioEnable("enable5g", enbl5G);
	}
	
	var h = $('body').outerHeight(true);;
	window.parent.adjustParentHeight("ConfigWifiPage", h + 10);

	if( (curUserType == sysUserType) && ('1' == wifiPasswordMask) )
	{
		getElById("cb_2g_pwd").disabled = 'disabled';
		getElById("cb_5g_pwd").disabled = 'disabled';
	}
}

function showPwd(id)
{
	var pwdId = id=="cb_2g_pwd"?"pwd_2g_wifipwd":"pwd_5g_wifipwd";
	var txtId = id=="cb_2g_pwd"?"txt_2g_wifipwd":"txt_5g_wifipwd";
	
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

function isValidKey(val, size)
{
    var ret = false;
    var len = val.length;
    var dbSize = size * 2;
 
    if (isValidAscii(val) != '')
    { 
		return false;
    }

    if ( len == size )
       ret = true;
    else if ( len == dbSize )
    {
       for ( i = 0; i < dbSize; i++ )
          if ( isHexaDigit(val.charAt(i)) == false )
             break;
       if ( i == dbSize )
          ret = true;
    }
    else
      ret = false;

   return ret;
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


function checkSsid(ssid)
{
    if (ssid == '')
    {
        AlertEx(cfg_wlancfgother_language['amp_empty_ssid']);
        return false;
    }

    if (ssid.length > 32)
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_too_loog']);
        return false;
    }

    if (isValidAscii(ssid) != '')
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_invalid'] + isValidAscii(ssid));
        return false;
    }

	return true;
}

function addRadioEnablePara(form)
{
	var oldRadioEbl = Radio[0].Enable;
	if(enbl2G != oldRadioEbl)
	{
		form.addParameter('r1.Enable',enbl2G);
		url += 'r1=InternetGatewayDevice.LANDevice.1.WiFi.Radio.1&';
	}
		
	if(1 == DoubleFreqFlag)
	{
		oldRadioEbl = Radio[1].Enable;
		if(enbl5G != oldRadioEbl)
		{
			form.addParameter('r2.Enable',enbl5G);
			url += 'r2=InternetGatewayDevice.LANDevice.1.WiFi.Radio.2&';
		}
	}
}

function addParaWlan(wlan, form)
{
	var wlanInst = wlan.InstId;
	var idx = wlan==wlan1?0:1;
	var wlanDomain = "InternetGatewayDevice.LANDevice.1.WLANConfiguration." + wlanInst;
	var pwd = idx?getValue("pwd_5g_wifipwd"):getValue("pwd_2g_wifipwd");
	var ssid = idx?getValue("txt_5g_wifiname"):getValue("txt_2g_wifiname");
	var ssidVisible = 1 - (idx?getCheckVal("cb_5g_hide"):getCheckVal("cb_2g_hide"));
	
	if (true == AmpTDESepicalCharaterFlag)
	{
	    if (true != checkSepcailStrValid(ssid))
        {
            AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_invalid']);
            return false;
        }
		if(getTDEStringActualLen(ssid) > 32)
	    {
            AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_too_loog']);
            return false;
	    }
	}
	else
	{ 
	    if(!checkSsid(ssid))
	    {
		  return false;
	    }
	}
	wlan.ssid = ssid;
	if(checkSSIDExist(wlan, allWlanInfo))
		return false;
	
	WifiCoverParaDefault(wlan, wlanInst);
	
	if(encryTypeArr[idx] == "wep")
	{	
		var wep1Domain = wlanDomain + ".WEPKey." + wlan.KeyIndex;
		if(!checkWep(pwd, wlan.WEPEncryptionLevel))
			return false;
		
		if(isWepChanged(pwd, wlan))
		{
			form.addParameter('wep'+idx+'.WEPKey', pwd);
			url += "wep"+idx+"="+wep1Domain+"&";
			setCoverSsidNotifyFlag("", pwd, ENUM_Key);
		}
	}
	else
	{
		var pskDomain = "InternetGatewayDevice.LANDevice.1.WLANConfiguration."+wlanInst+".PreSharedKey.1";
        if (true == AmpTDESepicalCharaterFlag)
	    {
	        if (true != isValidWPAPskSepcialKey(pwd))
            {
                return false;
            }
	    }
	    else
	    { 
	        if(!CheckPsk(pwd))
	        {
		       return false;
	        }
	    }
	
		
		if((encryTypeArr[idx] == "none") ||
				isPskChanged(pwd, wlan))
		{
			form.addParameter('psk'+idx+'.PreSharedKey', pwd);
			
			if('1' == kppUsedFlag)
            {
                form.addParameter('psk'+idx+'.KeyPassphrase', pwd);
            }
			
			url += "psk"+idx+"="+pskDomain+"&";
			setCoverSsidNotifyFlag("", pwd, ENUM_Key);
		}
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
	form.addParameter('w'+idx+'.SSIDAdvertisementEnabled', ssidVisible);
    if(0 == ssidVisible)
    {
        form.addParameter('z'+idx+'.Enable', 0);
    }
    if(0 == ssidVisible)
    {
        url += "z"+idx+"=" + wlanDomain + '.WPS' + "&";
    }
	url += "w"+idx+"="+wlanDomain+"&";
	SubmitWIfiCoverSsid(form, wlan, wlanInst);
	
	return true;
}

function SubmitForm()
{
    
    
    var form = new webSubmitForm();
    url = '';
	url_new = 'set.cgi?';
	
	if((null != wlan1) && !addParaWlan(wlan1, form))
		return ;

	if(wlan5_exist)
	{
		if(!addParaWlan(wlan5, form))
			return ;
	}

	addRadioEnablePara(form);
	url_new += url;
	form.setAction(url_new+'RequestFile=html/amp/wlanbasic/simplewificfg.asp');
	
	form.addParameter('x.X_HW_Token', getValue('onttoken'));
    
	form.submit();
}

function cancelClick()
{
    $('#WIFIIcon', window.parent.document).css("background", "url( ../../../images/wifiseticon.jpg) no-repeat center");
    window.parent.ChangeClickConfigDiv(1,"wifi",null);
}

</script>

<style type="text/css">
    .tb_label
    {
        font-size: 14px;
		font-family: "微软雅黑";
        color: #666666;
		width:100px;
    }
	.sp_checkbox
    {
        font-size: 13px;
		font-family: "微软雅黑";
        color: #666666;
    }
	.tb_input
	{
		-webkit-border-radius: 4px;
		-moz-border-radius: 4px;
		border-radius: 4px;
		border: 1px solid #CECACA;
		vertical-align: middle;
		font-family: "微软雅黑";
		font-size: 14px;
		height: 32px;
		width: 228px;
		padding-left: 5px;
		line-height: 32px;
		background-color: #ffffff;
	}
	
	.tb_input11
	{
		height: 32px;
		width: 228px;
		padding-left: 5px;
		line-height: 30px;
		font-size: 14px;
		background: none;
		border: none;
		background: url(../../../images/userinput.jpg) no-repeat;
	}
	
	.tb_radio
	{
		height: 30px;
		width: 70px;
		background: url(../../../images/on.jpg) no-repeat;
	}
	.gray
	{
		font-size: 13px;
		font-family: "微软雅黑";
		color: #666666;
	}
</style>

</head>

<body onLoad="LoadFrame();" style="background-color: #EDF1F2;text-align: left">
<div> 
<table border="0" cellspacing="0" cellpadding="0" style="margin-left: 23px;">
  <tr>  
    <td style="padding-bottom: 10px;font-family:微软雅黑;font-size:16px;font-style:normal;text-decoration:none;color:#333333;" BindText="amp_wifipage_wificfg" />   
  </tr> 
</table>

<table id="tb_2g" border="0" cellpadding="3" cellspacing="1" style="margin-left: 20px;">
	<tr>
		<td class="tb_label" BindText="amp_wifipage_wifi2on"></td>
		<td><div id="enable2g" class="tb_radio" onClick="EnableWiFi(this.id);"></div></td>
	</tr>
	<tr>
		<td class="tb_label" BindText="amp_wifiguide_wifiname"></td>
		<td> <input type="text" name="txt_2g_wifiname" id="txt_2g_wifiname" class="tb_input" maxlength="32"></td>
		<td><span class="sp_checkbox" BindText="amp_wifipage_name_notice"></span></td>
	</tr>
	<tr>
		<td class="tb_label" BindText="amp_wifipage_pwd"></td>
		<td> 
			<input type="password" name="pwd_2g_wifipwd" id="pwd_2g_wifipwd" class="tb_input" onchange="pwd=getValue('pwd_2g_wifipwd');getElById('txt_2g_wifipwd').value = pwd;">
			<input type="text" name="txt_2g_wifipwd" id="txt_2g_wifipwd" class="tb_input" style="display:none;" onchange="pwd=getValue('txt_2g_wifipwd');getElById('pwd_2g_wifipwd').value = pwd;">
		</td>
		<td> 
			<input  id="cb_2g_pwd" type="checkbox" checked="true" onClick="showPwd(this.id);"/>
			<span class="sp_checkbox" BindText="amp_wifipage_hidepwd"></span>
			<span id="pwd_2g_notice" class="gray" style="font-size: 13px; text-align: left;"></span>
		</td>
	</tr>
	<tr>
	<td></td>
	<td><input id="cb_2g_hide" type="checkbox" /><span class="sp_checkbox" BindText="amp_wifipage_hidessid"></span></td>
	</tr>
</table>
<div id="div_separatrix1" style="display:none; height: 10px; margin: 15px 10px 15px 10px; background:url(../../../images/wifi-separatrix1.jpg) no-repeat;"></div>
<table id="tb_5g" border="0" cellpadding="3" cellspacing="1" style="display:none;margin-left: 20px;" >
	<tr>
		<td class="tb_label" BindText="amp_wifipage_wifi5on"></td>
		<td><div id="enable5g" class="tb_radio" onClick="EnableWiFi(this.id);"></div></td>
	</tr>
	<tr>
		<td class="tb_label" BindText="amp_wifiguide_wifiname"></td>
		<td> <input type="text" name="txt_5g_wifiname" id="txt_5g_wifiname" class="tb_input" maxlength="32"></td>
		<td><span class="sp_checkbox" BindText="amp_wifipage_name_notice"></span></td>
	</tr>
	<tr>
		<td class="tb_label" BindText="amp_wifipage_pwd"></td>
		<td> 
			<input type="password" name="pwd_5g_wifipwd" id="pwd_5g_wifipwd" class="tb_input" onchange="pwd=getValue('pwd_5g_wifipwd');getElById('txt_5g_wifipwd').value = pwd;">
			<input type="text" name="txt_5g_wifipwd" id="txt_5g_wifipwd" class="tb_input" style="display:none;" onchange="pwd=getValue('txt_5g_wifipwd');getElById('pwd_5g_wifipwd').value = pwd;">
		</td>
		<td> 
			<input  id="cb_5g_pwd" type="checkbox" checked="true" onClick="showPwd(this.id);"/>
			<span class="sp_checkbox" checked="true" BindText="amp_wifipage_hidepwd"></span>
			<span id="pwd_5g_notice" class="gray" style="font-size: 13px; text-align: left;"></span>
		</td>
	</tr>
	<tr>
	<td></td>
	<td><input id="cb_5g_hide" type="checkbox" /><span class="sp_checkbox" BindText="amp_wifipage_hidessid"></span></td>
	</tr>
</table>
<div id="div_separatrix2" style="height: 10px; margin: 15px 10px 15px 10px; background:url(../../../images/wifi-separatrix2.jpg) no-repeat;"></div>
<div align="center">
<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">

<input id="btnSave" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="SubmitForm();">
<script>getElById('btnSave').value = cfg_wifiguide_language['amp_wifipage_save'];</script>
</input>
<input id="btnCancel" type="button" class="CancleButtonCss buttonwidth_100px" onClick="cancelClick();">
<script>getElById('btnCancel').value = cfg_wifiguide_language['amp_wifipage_cancel'];</script>
</input>
		
</div>

</div>
<script>
ParseBindTextByTagName(cfg_wifiguide_language,"span",1);
ParseBindTextByTagName(cfg_wifiguide_language,"td",1);
ParseBindTextByTagName(cfg_wifiguide_language,"input",2);
</script>
</body>
</html>

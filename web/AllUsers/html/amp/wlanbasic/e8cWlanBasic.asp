<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>
<script language="javascript" src="./refreshTime.asp"></script>
<title>wireless basic configure</title>
<script language="JavaScript" type="text/javascript">

var WapiFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WAPI);%>';
var wifiPasswordMask='<%HW_WEB_GetWlanPsdMask();%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';

var wep1password;
var wpapskpassword;
var radiuspassword;
var wep1PsdModFlag = false;
var pskPsdModFlag = false;
var radPsdModFlag = false;

var g_flags = new Array();
g_flags[0] = 0;
g_flags[1] = 0;
g_flags[2] = 0;
var desc_show = "点击显示密码";
var desc_hide = "点击隐藏密码";


function GetLanguageDesc(Name)
{
    return cfg_wlancfgdetail_language[Name];
}

var wlanpage;
if (location.href.indexOf("e8cWlanBasic.asp?") > 0)
{
	wlanpage = location.href.split("?")[1]; 
	top.WlanBasicPage = wlanpage;
}

wlanpage = top.WlanBasicPage;


function ShowOrHideText(flag, checkBoxId, passwordId, textId, value)
{
    if (1 == g_flags[flag])
    {
		getElById(checkBoxId).innerHTML = desc_show;
        setDisplay(passwordId, 1);
        setDisplay(textId, 0);
		g_flags[flag] = 0;		
    }
    else
    {
		getElById(checkBoxId).innerHTML = desc_hide;
        setDisplay(passwordId, 0);
        setDisplay(textId, 1);
		g_flags[flag] = 1;
    }
}

function stWlan(domain,name,enable,ssid,BeaconType,BasicEncryptionModes,BasicAuthenticationMode,
                KeyIndex,EncryptionLevel,WPAEncryptionModes,WPAAuthenticationMode,IEEE11iEncryptionModes,IEEE11iAuthenticationMode,
                X_HW_WPAand11iEncryptionModes,X_HW_WPAand11iAuthenticationMode,RadiusServer,RadiusPort,RadiusKey,X_HW_ServiceEnable, LowerLayers,
				X_HW_WAPIEncryptionModes,X_HW_WAPIAuthenticationMode,X_HW_WAPIServer,X_HW_WAPIPort)
{
    this.domain = domain;
    this.name = name;
    this.enable = enable;
    this.ssid = ssid;
    this.BeaconType = BeaconType;
    this.BasicEncryptionModes = BasicEncryptionModes;
    this.BasicAuthenticationMode = BasicAuthenticationMode;
    this.KeyIndex = KeyIndex;
    this.EncypBit = EncryptionLevel;
    this.WPAEncryptionModes = WPAEncryptionModes;
    this.WPAAuthenticationMode = WPAAuthenticationMode;
    this.IEEE11iEncryptionModes = IEEE11iEncryptionModes;
    this.IEEE11iAuthenticationMode = IEEE11iAuthenticationMode;
    this.X_HW_WPAand11iEncryptionModes = X_HW_WPAand11iEncryptionModes;
    this.X_HW_WPAand11iAuthenticationMode = X_HW_WPAand11iAuthenticationMode;
    this.RadiusServer = RadiusServer;
    this.RadiusPort = RadiusPort;
    this.RadiusKey = RadiusKey;
	this.X_HW_ServiceEnable = X_HW_ServiceEnable;
	this.LowerLayers = LowerLayers;
	this.X_HW_WAPIEncryptionModes = X_HW_WAPIEncryptionModes;
	this.X_HW_WAPIAuthenticationMode = X_HW_WAPIAuthenticationMode;
	this.X_HW_WAPIServer = X_HW_WAPIServer;
	this.X_HW_WAPIPort = X_HW_WAPIPort;
}


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

function stMaxWLAN(idx, lang)
{
    this.MAX_ID = idx;
    this.MAX_ID_LANG = lang;
}

function stIndexMapping(index,portIndex)
{
    this.index = index;
    this.portIndex = portIndex;
}

function stWlanWifi(domain,name,enable,ssid,mode,channel,power,Country,AutoChannelEnable,channelWidth)
{
    this.domain = domain;
    this.name = name;
    this.enable = enable;
    this.ssid = ssid;
    this.mode = mode;
    this.channel = channel;
    this.power = power;
    this.RegulatoryDomain = Country;
    this.AutoChannelEnable = AutoChannelEnable;
    this.channelWidth = channelWidth;
}


var WlanWifiArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|X_HW_Standard|Channel|TransmitPower|RegulatoryDomain|AutoChannelEnable|X_HW_HT20,stWlanWifi);%>;
var WlanWifi = WlanWifiArr[0];
if (null == WlanWifi)
{
	WlanWifi = new stWlanWifi("","","","","11n","","","","","");
}

var enbl = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>';

var Wlan = new Array();

var WlanArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WEPKeyIndex|WEPEncryptionLevel|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|X_HW_RadiuServer|X_HW_RadiusPort|X_HW_RadiusKey|X_HW_ServiceEnable|LowerLayers|X_HW_WAPIEncryptionModes|X_HW_WAPIAuthenticationMode|X_HW_WAPIServer|X_HW_WAPIPort,stWlan);%>;

var wlanArrLen = WlanArr.length - 1;

if (1 == TwoSsidCustomizeGroup)
{
	if (wlanArrLen >= 2)
	{
		wlanArrLen = 2;
	}
}
else
{
	if (wlanArrLen >= 1)
	{
		wlanArrLen = 1;
	}
}

if (1 == DoubleFreqFlag)
{
	wlanArrLen++;
}

for (i=0; i < wlanArrLen; i++)
{
    Wlan[i] = new stWlan();
    Wlan[i] = WlanArr[i];
}

var g_keys = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.WEPKey.{i},WEPKey,stWEPKey);%>;
if (null != g_keys)
{
	wep1password = g_keys[0];
}

var wpaPskKey = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.PreSharedKey.1,PreSharedKey,stPreSharedKey);%>;

var wlanMac = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_WlanMac);%>';

var ssidIdx = -1;
var ssidAccessAttr = 'Subscriber';
var AddFlag = true;
var currentWlan = new stWlan();
var maxSingleWLAN     = new stMaxWLAN(4,'four');
var maxDoubleWLAN     = new stMaxWLAN(8,'eight');

function getWlanPortNumber(name)
{
    var length = name.length;
    var number;
    var str = parseInt(name.charAt(length-1));
    return str;
}

var uiFirstRecordFor5G = 0;
var RecordFor5G = 0;
var flag5Ghide = 0;
function FirstRecordFor5G()
{
	if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
	{
		for (var loop = 0; loop < WlanMap.length; loop++)
		{
			if (WlanMap[loop].portIndex > 3)
			{
				uiFirstRecordFor5G = parseInt(getIndexFromPort(WlanMap[loop].portIndex));
				WlanWifi = WlanWifiArr[uiFirstRecordFor5G];	
				RecordFor5G = loop;
				break;
			}
		}
	}	
}

var uiFirstRecordFor2G = 0;
var RecordFor2G = 0;
function FirstRecordFor2G()
{
	if ((1 == DoubleFreqFlag) && ("2G" == wlanpage))
	{
		for (var loop = 0; loop < WlanMap.length; loop++)
		{
			if (WlanMap[loop].portIndex < 4)
			{
				uiFirstRecordFor2G = parseInt(getIndexFromPort(WlanMap[loop].portIndex));
				WlanWifi = WlanWifiArr[uiFirstRecordFor2G];			
				RecordFor2G = loop;
				break;
			}
		}
	}	
}

var uiTotal2gNum = 0;
var uiTotal5gNum = 0;
var uiTotalNum = 0;
function Total2gNum()
{
	uiTotal2gNum = 0;
	uiTotal5gNum = 0;
	uiTotalNum = Wlan.length;

	for (var loop = 0; loop < Wlan.length; loop++)
	{
		if ('' == Wlan[loop].name)
		{
			continue;
		}
		
		if (getWlanPortNumber(Wlan[loop].name) > 3)
		{
			uiTotal5gNum++;
		}
		else
		{
			uiTotal2gNum++;
		}
	}
}

var WlanMap = new Array();
var j = 0;
for (var i = 0; i < Wlan.length; i++)
{
    var index = getWlanPortNumber(Wlan[i].name);
    var wlanInst = getWlanInstFromDomain(Wlan[i].domain);

    if ((isSsidForIsp(wlanInst) == 1) && (1 != ShowISPSsidFlag))
    {
     	continue;
    }
    else
    {
   		WlanMap[j] = new stIndexMapping(i,index);
   		j++;
    }
}

if (WlanMap.length >= 2)
{
    for (var i = 0; i < WlanMap.length-1; i++)
    {
        for( var j =0; j < WlanMap.length-i-1; j++)
        {
            if (WlanMap[j+1].portIndex < WlanMap[j].portIndex)
            {
                var middle = WlanMap[j+1];
                WlanMap[j+1] = WlanMap[j];
                WlanMap[j] = middle;
            }
        }
    }
}

function getIndexFromPort(index)
{
    for (var i = 0; i < WlanMap.length; i++)
    {
        if (index == WlanMap[i].portIndex)
        {
            return WlanMap[i].index;
        }
    }
}

function getPortFromIndex(index)
{
    for (var i = 0; i < WlanMap.length; i++)
    {
        if (index == WlanMap[i].index)
        {
            return WlanMap[i].portIndex;
        }
    }
} 

function isValidRadiusPort(port) 
{ 
    if (!isInteger(port) || port < 0 || port > 65535)
    {
        return false;
    }

    return true;
}

function getEncryLevel(encrylevel)
{
    var level = '';
    for (var i = 0; i < encrylevel.length; i++)
    {
        if (encrylevel.charAt(i) != '-')
        {
            level += encrylevel.charAt(i);
        }
        else
        {
            break;
        }
    }
    return level;
}

var auth_none = "NONE";
var auth_wep = "WEP";
var auth_wpa_psk = "WPA-PSK";
var auth_wpa2_psk = "WPA2-PSK";
var auth_wpawpa2_psk = "WPA-PSK/WPA2-PSK";
var auth_wpa = cfg_wlancfgdetail_language['amp_auth_wpa'];
var auth_wpa2 = cfg_wlancfgdetail_language['amp_auth_wpa2'];
var auth_wpawpa2 = cfg_wlancfgdetail_language['amp_auth_wpawpa2'];

var encrypt_none = "NONE";
var encrypt_open = "OPEN";
var encrypt_share = "SHARE";
var encrypt_both = "OPEN+SHARE";
var encrypt_tkip = "TKIP";
var encrypt_aes = "AES";
var encrypt_tkipaes = "TKIP+AES";

function addAuthModeOption()
{
    var len = document.forms[0].WlanAuthMode_select.options.length;    
    var authMode = getSelectVal('WlanAuthMode_select'); 
    var mode = WlanWifi.mode; 
    
    for (i = 0; i < len; i++)
    {
        document.forms[0].WlanAuthMode_select.remove(0);
    }

    if (mode == "11n")
    {
		document.forms[0].WlanAuthMode_select[0] = new Option(auth_none, "open");
		document.forms[0].WlanAuthMode_select[1] = new Option(auth_wpa_psk, "wpa-psk");
		document.forms[0].WlanAuthMode_select[2] = new Option(auth_wpa2_psk, "wpa2-psk");
		document.forms[0].WlanAuthMode_select[3] = new Option(auth_wpawpa2_psk, "wpa/wpa2-psk");
		document.forms[0].WlanAuthMode_select[4] = new Option(auth_wpa, "wpa");
		document.forms[0].WlanAuthMode_select[5] = new Option(auth_wpa2, "wpa2");
		document.forms[0].WlanAuthMode_select[6] = new Option(auth_wpawpa2, "wpa/wpa2");
    }
    else
    {
		document.forms[0].WlanAuthMode_select[0] = new Option(auth_none, "open");
        document.forms[0].WlanAuthMode_select[1] = new Option(auth_wep, "shared");
		document.forms[0].WlanAuthMode_select[2] = new Option(auth_wpa_psk, "wpa-psk");
		document.forms[0].WlanAuthMode_select[3] = new Option(auth_wpa2_psk, "wpa2-psk");
		document.forms[0].WlanAuthMode_select[4] = new Option(auth_wpawpa2_psk, "wpa/wpa2-psk");
		document.forms[0].WlanAuthMode_select[5] = new Option(auth_wpa, "wpa");
		document.forms[0].WlanAuthMode_select[6] = new Option(auth_wpa2, "wpa2");
		document.forms[0].WlanAuthMode_select[7] = new Option(auth_wpawpa2, "wpa/wpa2");
		if(1 == WapiFlag)
		{
			document.forms[0].WlanAuthMode_select[8] = new Option(cfg_wlancfgdetail_language['amp_auth_wapi_psk'], "wapi-psk");
			document.forms[0].WlanAuthMode_select[9] = new Option(cfg_wlancfgdetail_language['amp_auth_wapi'], "wapi");
		}
    }
    
    setSelect('WlanAuthMode_select',authMode);
}

function addWapiEncryMethodOption()
{
	var len = document.forms[0].WlanPwdMode_select.options.length;
	for (i = 0; i < len; i++)
    {
        document.forms[0].WlanPwdMode_select.remove(0);
    }
	document.forms[0].WlanPwdMode_select[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_sms4'], "SMS4");
			
}

function addEncryMethodOption(type1,type2)
{
    var len = document.forms[0].WlanPwdMode_select.options.length;
    var mode = WlanWifi.mode;
    
    for (i = 0; i < len; i++)
    {
        document.forms[0].WlanPwdMode_select.remove(0);
    }

    if ((type1 == 0) && (type2 == 0))
    {
    }
    else if ((type1 == 0) && (type2 == 1))
    {
    }
    else
    {
        if (mode == "11n")
        {
            document.forms[0].WlanPwdMode_select[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_aes'], "AESEncryption");    	
        }
        else
        {
			document.forms[0].WlanPwdMode_select[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_aes'], "AESEncryption");
			document.forms[0].WlanPwdMode_select[1] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkip'], "TKIPEncryption");
			document.forms[0].WlanPwdMode_select[2] = new Option(encrypt_tkipaes, "TKIPandAESEncryption");
        }
    }
}

function GetWepEncrypt(BasicAuthenticationMode)
{
	if ((BasicAuthenticationMode == 'None') ||(BasicAuthenticationMode == 'OpenSystem'))
	{
		return 'OpenSystem';
	}
	else if ((BasicAuthenticationMode == 'SharedAuthentication') ||(BasicAuthenticationMode == 'SharedKey'))
	{
		return 'SharedKey';
	}
	else
	{
		return 'Both';
	}
}

function ClearPsdModFlag()
{
    wep1PsdModFlag = false;
    pskPsdModFlag = false;
    radPsdModFlag = false;
}

function authModeChange()
{   
	ClearPsdModFlag();
	
    setDisplay("wlEncryMethod",0);
	setDisplay("wlEncryWep",0);
    setDisplay("keyInfo", 0);
    setDisplay("wlRadius", 0);
    setDisplay("wpaPreShareKey", 0);
    setDisable("WlanPwdMode_select",0);
	setDisplay('wlWapi',0);

    var authMode = getSelectVal('WlanAuthMode_select');      

    switch (authMode)
    {
        case 'open':
            break;

        case 'shared':
            var level = getEncryLevel(Wlan[ssidIdx].EncypBit);
            var mode = WlanWifi.mode;              
            
            if (mode == "11n")
            {
            }
            else
            {
				setDisplay("wlEncryWep",1);
                setDisplay('keyInfo', 1);
                if (AddFlag == false)
                {
					setSelect('WlanWepPwd_select', GetWepEncrypt(Wlan[ssidIdx].BasicAuthenticationMode));
                    setSelect('WlanKeyBit_select', parseInt(level)+24);
                    setText('wlKeys1',g_keys[ssidIdx * 4].value);
                    wep1password = g_keys[ssidIdx * 4].value; 
                    setText('twlKeys1',g_keys[ssidIdx * 4].value);
                }
                else
                {
					setSelect('WlanWepPwd_select', 'Both');
                    setSelect('WlanKeyBit_select', 128);
                    setText('wlKeys1','');
                    wep1password = ''; setText('twlKeys1','');
                }
            }			      
            break;

        case 'wpa':
        case 'wpa2':
	    case 'wpa/wpa2':
			setDisplay('wlEncryMethod',1);
			addEncryMethodOption(1,0);
            setDisplay('wlRadius', 1);
            if (AddFlag == false)
            {
                if (authMode == 'wpa')
                {
                    setSelect('WlanPwdMode_select',Wlan[ssidIdx].WPAEncryptionModes);
                }
                else if (authMode == 'wpa2')
                {
                    setSelect('WlanPwdMode_select',Wlan[ssidIdx].IEEE11iEncryptionModes);
                }
				else
				{
				    setSelect('WlanPwdMode_select',Wlan[ssidIdx].X_HW_WPAand11iEncryptionModes);
				}
                setText('wlRadiusIPAddr',Wlan[ssidIdx].RadiusServer);
                setText('wlRadiusPort',Wlan[ssidIdx].RadiusPort);
                setText('wlRadiusKey',Wlan[ssidIdx].RadiusKey);
				radiuspassword = Wlan[ssidIdx].RadiusKey; 
				setText('twlRadiusKey',Wlan[ssidIdx].RadiusKey);
            }
            else
            {
                setText('wlRadiusIPAddr','');
                setText('wlRadiusPort','');
                setText('wlRadiusKey','');
				radiuspassword = ''; 
				setText('twlRadiusKey','');
            }
            break;

        case 'wpa-psk':
        case 'wpa2-psk':
	    case 'wpa/wpa2-psk':
			setDisplay('wlEncryMethod',1);
			addEncryMethodOption(1,0);

            setDisplay('wpaPreShareKey', 1);
            if (AddFlag == false)
            {
                if (authMode == 'wpa-psk')
                {
                    setSelect('WlanPwdMode_select',Wlan[ssidIdx].WPAEncryptionModes);
                }
				else if (authMode == 'wpa2-psk')
                {
                    setSelect('WlanPwdMode_select',Wlan[ssidIdx].IEEE11iEncryptionModes);
                }
                else
                {
                    setSelect('WlanPwdMode_select',Wlan[ssidIdx].X_HW_WPAand11iEncryptionModes);
                }
                setText('WlanPassword_password',wpaPskKey[ssidIdx].value);
				wpapskpassword = wpaPskKey[ssidIdx].value;
				setText('tWlanPassword_password',wpaPskKey[ssidIdx].value);
            }
            else
            {
                setText('WlanPassword_password','');
				wpapskpassword = '';
				setText('tWlanPassword_password','');
            }
            break;
		case 'wapi-psk':
			setDisplay('wlEncryMethod',1);             
            addWapiEncryMethodOption();  
			document.getElementById('wpa_psk').innerHTML = GetLanguageDesc("amp_wapi_psk");
			setDisable('WlanPwdMode_select',1);
			setDisplay("wpaPreShareKey", 1);
			setText('WlanPassword_password',wpaPskKey[ssidIdx].value);
			setText('tWlanPassword_password',wpaPskKey[ssidIdx].value);
			wpapskpassword = wpaPskKey[ssidIdx].value;
			if(AddFlag == false)
			{

				setSelect('WlanPwdMode_select',Wlan[ssidIdx].X_HW_WAPIEncryptionModes);
			}
			break;
		case 'wapi':
			setDisplay('wlEncryMethod',1);             
            addWapiEncryMethodOption();  
			setDisable('WlanPwdMode_select',1);
			setDisplay('wlWapi',1); 
			setText('wapiIPAddr',Wlan[ssidIdx].X_HW_WAPIServer);
			setText('wapiPort',Wlan[ssidIdx].X_HW_WAPIPort);
			if(AddFlag == false)
			{
				setSelect('WlanPwdMode_select',Wlan[ssidIdx].X_HW_WAPIEncryptionModes);
			}
			break;
        default:
            break;
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

function displaywepkey()
{   
    if (AddFlag == false)
    {
        setText('wlKeys1',g_keys[ssidIdx * 4].value);
		wep1password = g_keys[ssidIdx * 4].value; 
		setText('twlKeys1',g_keys[ssidIdx * 4].value);
    }
    else
    {
        setText('wlKeys1','');
		wep1password = ''; 
		setText('twlKeys1', '');
    }
}

function beaconTypeChange(mode)
{
    setDisplay('wlEncryMethod',0);
	setDisplay("wlEncryWep",0);
    setDisplay('keyInfo', 0);
    setDisplay('wlRadius', 0);
    setDisplay('wpaPreShareKey', 0);
	setDisplay('wlWapi',0);
    
    if (mode == 'Basic')
    {
        var BasicAuthenticationMode = Wlan[ssidIdx].BasicAuthenticationMode;
        var BasicEncryptionModes = Wlan[ssidIdx].BasicEncryptionModes;
        if (BasicEncryptionModes == 'None')
	    {
            setSelect('WlanAuthMode_select','open');
        }
        else
        {
            var level = getEncryLevel(Wlan[ssidIdx].EncypBit);
			setDisplay("wlEncryWep",1);
            setDisplay('keyInfo', 1);
            setSelect('WlanAuthMode_select','shared');
            setSelect('WlanWepPwd_select',GetWepEncrypt(BasicAuthenticationMode));
            setSelect('WlanKeyBit_select', parseInt(level)+24);
			WlanKeyBit_selectChange();
            displaywepkey();
        }
    }
	else if (mode == 'WPA')
	{
	    if (Wlan[ssidIdx].WPAAuthenticationMode == 'EAPAuthentication')
        {
            setDisplay("wlEncryMethod",1);
			addEncryMethodOption(1,0);
            setDisplay("wlRadius", 1);
            setSelect('WlanAuthMode_select','wpa');
            setSelect('WlanPwdMode_select',Wlan[ssidIdx].WPAEncryptionModes);
            setText('wlRadiusIPAddr',Wlan[ssidIdx].RadiusServer);
            setText('wlRadiusPort',Wlan[ssidIdx].RadiusPort);
            setText('wlRadiusKey',Wlan[ssidIdx].RadiusKey);
			radiuspassword = Wlan[ssidIdx].RadiusKey; 
			setText('twlRadiusKey',Wlan[ssidIdx].RadiusKey);
        }
        else
        {
            setDisplay("wlEncryMethod",1);
			addEncryMethodOption(1,1);
            setDisplay("wpaPreShareKey", 1);
            setSelect('WlanAuthMode_select','wpa-psk');
            setSelect('WlanPwdMode_select',Wlan[ssidIdx].WPAEncryptionModes);
            setText('WlanPassword_password',wpaPskKey[ssidIdx].value); 
			wpapskpassword = wpaPskKey[ssidIdx].value; 
			setText('tWlanPassword_password',wpaPskKey[ssidIdx].value);
        }
	}
	else if ((mode == '11i') || (mode == 'WPA2') )
    {
        if (Wlan[ssidIdx].IEEE11iAuthenticationMode == 'EAPAuthentication')
        {
            setDisplay("wlEncryMethod",1);
			addEncryMethodOption(1,0);
            setDisplay("wlRadius", 1);
            setSelect('WlanAuthMode_select','wpa2');
            setSelect('WlanPwdMode_select',Wlan[ssidIdx].IEEE11iEncryptionModes);
            setText('wlRadiusIPAddr',Wlan[ssidIdx].RadiusServer);
            setText('wlRadiusPort',Wlan[ssidIdx].RadiusPort);
            setText('wlRadiusKey',Wlan[ssidIdx].RadiusKey);
			radiuspassword = Wlan[ssidIdx].RadiusKey; 
			setText('twlRadiusKey',Wlan[ssidIdx].RadiusKey);
        }
        else
        {
            setDisplay("wlEncryMethod",1);
			addEncryMethodOption(1,2);
            setDisplay("wpaPreShareKey", 1);
            setSelect('WlanAuthMode_select','wpa2-psk');
            setSelect('WlanPwdMode_select',Wlan[ssidIdx].IEEE11iEncryptionModes);
            setText('WlanPassword_password',wpaPskKey[ssidIdx].value); 
			wpapskpassword = wpaPskKey[ssidIdx].value; 
			setText('tWlanPassword_password',wpaPskKey[ssidIdx].value);
        }
	}
	else if ((mode == 'WPAand11i')|| (mode == 'WPA/WPA2'))
    {
        if (Wlan[ssidIdx].X_HW_WPAand11iAuthenticationMode == 'EAPAuthentication')
        {
            setDisplay("wlEncryMethod",1);
			addEncryMethodOption(1,0);
            setDisplay("wlRadius", 1);
            setSelect('WlanAuthMode_select','wpa/wpa2');
            setSelect('WlanPwdMode_select',Wlan[ssidIdx].X_HW_WPAand11iEncryptionModes);
            setText('wlRadiusIPAddr',Wlan[ssidIdx].RadiusServer);
            setText('wlRadiusPort',Wlan[ssidIdx].RadiusPort);
            setText('wlRadiusKey',Wlan[ssidIdx].RadiusKey);
			radiuspassword = Wlan[ssidIdx].RadiusKey; 
			setText('twlRadiusKey',Wlan[ssidIdx].RadiusKey);
        }
        else
        {
            setDisplay("wlEncryMethod",1);
			addEncryMethodOption(0,2);
            setDisplay("wpaPreShareKey", 1);
            setSelect('WlanAuthMode_select','wpa/wpa2-psk');
            setSelect('WlanPwdMode_select',Wlan[ssidIdx].X_HW_WPAand11iEncryptionModes);
            setText('WlanPassword_password',wpaPskKey[ssidIdx].value); 
			wpapskpassword = wpaPskKey[ssidIdx].value; 
			setText('tWlanPassword_password',wpaPskKey[ssidIdx].value);
        }
	}
	else if(mode == 'X_HW_WAPI')
	{
		if(Wlan[ssidIdx].X_HW_WAPIAuthenticationMode == 'WAPIPSK')
		{
			setSelect('WlanAuthMode_select','wapi-psk');
			setDisplay('wlEncryMethod',1);             
            		addWapiEncryMethodOption();  
			
			setDisable('WlanPwdMode_select',1);
			setDisplay("wpaPreShareKey", 1);
			document.getElementById('wpa_psk').innerHTML = GetLanguageDesc("amp_wapi_psk");
			setText('WlanPassword_password',wpaPskKey[ssidIdx].value);
			setText('tWlanPassword_password',wpaPskKey[ssidIdx].value);
			wpapskpassword = wpaPskKey[ssidIdx].value; 



			setSelect('WlanPwdMode_select',Wlan[ssidIdx].X_HW_WAPIEncryptionModes);
		}
		else
		{
			setSelect('WlanAuthMode_select','wapi');
			setDisplay('wlEncryMethod',1);             
            addWapiEncryMethodOption();  
			setDisable('WlanPwdMode_select',1);
			setDisplay('wlWapi',1); 
			setText('wapiIPAddr',Wlan[ssidIdx].X_HW_WAPIServer);
			setText('wapiPort',Wlan[ssidIdx].X_HW_WAPIPort);
		}
	}
    else
    {
        setSelect('WlanAuthMode_select','open');
    }
}

function WlanKeyBit_selectChange()
{
	var desc;
	
    if (getSelectVal('WlanKeyBit_select') == 128)
	{
		desc = "128位无线网络密钥需输入13个ASCII字符或26个十六进制数";
	}
	else
	{
		desc = "64位无线网络密钥需输入5个ASCII字符或10个十六进制数";
	}

	getElById("Title_wlan_key_tips_lable").innerHTML = desc;
}

function onMethodChange(isSelected)
{   
	var authMode = getSelectVal('WlanAuthMode_select');
	if (authMode == 'open')
	{
    	var var2 = getSelectVal('WlanPwdMode_select');

	    if (var2 == 'None')
        {
            setDisplay('keyInfo', 0);
        }
        else
        {
            if (AddFlag == false)
            {
                var level = getEncryLevel(Wlan[ssidIdx].EncypBit);
                setDisplay('keyInfo', 1);
                setSelect('WlanKeyBit_select', parseInt(level)+24);

                setText('wlKeys1',g_keys[ssidIdx * 4].value);
				wep1password = g_keys[ssidIdx * 4].value; 
				setText('twlKeys1',g_keys[ssidIdx * 4].value);
            }
            else
            {
                setDisplay('keyInfo', 1);
                setSelect('WlanKeyBit_select', 128);

                setText('wlKeys1','');
				wep1password = ''; 
				setText('twlKeys1','');
            }
        }
	}
    else
    {
        setDisplay('keyInfo', 0);
    }
}

function onWepChange()
{

}

function SsidEnable()
{
    if (true == AddFlag)
    {
        return;
    }
	
	if (Wlan[ssidIdx].X_HW_ServiceEnable == 1)
    {
    }
    else
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_state']);
        setCheck('wlEnable', 0);
    }
	
	return;
}

function ShowSsidEnable(currentWlan)
{
	if (currentWlan.X_HW_ServiceEnable == 1)
    {
	    setCheck('wlEnable', currentWlan.enable);
    }
    else
    {
        setCheck('wlEnable', 0);
    }
	
	return;
}

function ltrim(str)
{ 
 return str.replace(/(^\s*)/g,""); 
}

function addParameter1(Form)
{   
    Form.addParameter('y.Enable',getCheckVal('wlEnable'));
    var ssid;
    ssid = ltrim(getValue('WlanSsid_text'));
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

    for (i = 0; i < Wlan.length; i++)
    {
        if (ssidIdx != i)
        {
            if (TextTranslate(Wlan[i].ssid) == ssid)
            {
                AlertEx(cfg_wlancfgother_language['amp_ssid_exist']);
                return false;
            }
        }
        else
        {
            continue;
        }
    }
    
	if ('CMCC_RMS' != CfgMode.toUpperCase())
	{
		if((0 == getWlanPortNumber(currentWlan.name)) && (0 != ssid.indexOf("ChinaNet-")) )
		{
			AlertEx(cfg_wlancfgother_language['amp_ssid_must_be_chinanet']);
			return false;
		}

		if (1 == DoubleFreqFlag)
		{
			if((4 == getWlanPortNumber(currentWlan.name)) && (0 != ssid.indexOf("ChinaNet-")) )
			{
				AlertEx(cfg_wlancfgother_language['amp_ssid_must_be_chinanet_5G']);
				return false;
			}
		}
	}
	
    Form.addParameter('y.SSID',ssid);
}

function addParameter2(Form)
{ 
    var url = '';
    var temp = '';

    var AuthMode = getSelectVal('WlanAuthMode_select');

	if (AuthMode == 'open')
	{
		Form.addParameter('y.BeaconType','None');
		Form.addParameter('y.BasicAuthenticationMode','OpenSystem');
		Form.addParameter('y.BasicEncryptionModes','None');
	}
    else if (AuthMode == 'shared')
    {
        var KeyBit = getSelectVal('WlanKeyBit_select');
		var index = 1;
		var wlKeys1 = getValue('wlKeys1');
		var val;
		var i;
		var vKey = 0;
		var KeyDesc;

		for (vKey = 0; vKey < 1; vKey++)
		{
		   if (vKey == 0)
		   {
			   val = wlKeys1;
			   KeyDesc = cfg_wlancfgdetail_language['amp_encrypt_key1'];
		   }

		   if ( val != '' && val != null)
		   {
			   if ( KeyBit == '128' )
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
			   AlertEx(cfg_wlancfgdetail_language['amp_key_invalid3']);
			   return false;
		   }
		}
		Form.addParameter('y.WEPEncryptionLevel',(KeyBit-24)+'-bit');
		Form.addParameter('y.WEPKeyIndex',index);

        if (wifiPasswordMask == '1')
        {
            if (KeyBit == '128')
            {
                if ( (wlKeys1 != "*************") || (wep1PsdModFlag == true) )
                {
                    Form.addParameter('k1.WEPKey', wlKeys1);
                    Form.addParameter('k2.WEPKey', wlKeys1);
                    Form.addParameter('k3.WEPKey', wlKeys1);
                    Form.addParameter('k4.WEPKey', wlKeys1);  
                }
            }
            else
            {
                if ( (wlKeys1 != "*****") || (wep1PsdModFlag == true) )
                {
                    Form.addParameter('k1.WEPKey', wlKeys1);
                    Form.addParameter('k2.WEPKey', wlKeys1);
                    Form.addParameter('k3.WEPKey', wlKeys1);
                    Form.addParameter('k4.WEPKey', wlKeys1);
                }
            }
        }
        else
        {
            Form.addParameter('k1.WEPKey', wlKeys1);
            Form.addParameter('k2.WEPKey', wlKeys1);
            Form.addParameter('k3.WEPKey', wlKeys1);
            Form.addParameter('k4.WEPKey', wlKeys1);  
        }

        
        Form.addParameter('y.BeaconType','Basic');
		Form.addParameter('y.BasicAuthenticationMode',getSelectVal('WlanWepPwd_select'));
        Form.addParameter('y.BasicEncryptionModes','WEPEncryption');
    }
    else if (AuthMode == 'wpa' || AuthMode == 'wpa2' || AuthMode == 'wpa/wpa2')
    {
        var wlRadiusKey = getValue('wlRadiusKey');
        var wlRadiusIPAddr = getValue('wlRadiusIPAddr');
        var wlRadiusPort = getValue('wlRadiusPort');
        
        if (wlRadiusIPAddr == '' || wlRadiusPort == '')
        {
            AlertEx(cfg_wlancfgother_language['amp_empty_para']);
            return false;
        }

		if (isValidRaiusKey(wlRadiusKey) == false)
		{
		    AlertEx(cfg_wlancfgdetail_language['amp_radius_keyinvalid']);
            return false;
		}

        if (isAbcIpAddress(wlRadiusIPAddr) == false)
        {
            AlertEx(cfg_wlancfgdetail_language['amp_srvip_invalid']);
            return false;
        }

        if (isValidRadiusPort(parseInt(wlRadiusPort,10)) == false)
        {
            AlertEx(cfg_wlancfgdetail_language['amp_srvport_invalid']);
            return false;
        }
        
        if (AuthMode == 'wpa')
        {
            Form.addParameter('y.BeaconType','WPA');
            Form.addParameter('y.WPAAuthenticationMode','EAPAuthentication');
            Form.addParameter('y.WPAEncryptionModes',getSelectVal('WlanPwdMode_select'));
        }
        else if (AuthMode == 'wpa2')
        {
            Form.addParameter('y.BeaconType','11i');
            Form.addParameter('y.IEEE11iAuthenticationMode','EAPAuthentication');
            Form.addParameter('y.IEEE11iEncryptionModes',getSelectVal('WlanPwdMode_select'));
        }
		else
		{
		    Form.addParameter('y.BeaconType','WPAand11i');
            Form.addParameter('y.X_HW_WPAand11iAuthenticationMode','EAPAuthentication');
            Form.addParameter('y.X_HW_WPAand11iEncryptionModes',getSelectVal('WlanPwdMode_select'));
		}
        
        if (wifiPasswordMask == '1')
        {
            if ( (wlRadiusKey != "********") || (radPsdModFlag == true) )
            {
                Form.addParameter('y.X_HW_RadiusKey',wlRadiusKey);
            }
        }
        else
        {
           Form.addParameter('y.X_HW_RadiusKey',wlRadiusKey);
        }

        Form.addParameter('y.X_HW_RadiuServer',wlRadiusIPAddr);

        wlRadiusPort = parseInt(getValue('wlRadiusPort'),10);
        Form.addParameter('y.X_HW_RadiusPort',wlRadiusPort);
    }
    else if (AuthMode == 'wpa-psk' || AuthMode == 'wpa2-psk' || AuthMode == 'wpa/wpa2-psk'|| AuthMode == 'wapi'|| AuthMode == 'wapi-psk')
    {
        var value = getValue('WlanPassword_password');
		var wapiIP = getValue('wapiIPAddr');
		var wapiPort = getValue('wapiPort');
		

		if(AuthMode == 'wpa-psk' || AuthMode == 'wpa2-psk' || AuthMode == 'wpa/wpa2-psk')
		{
	
			if (value == '')
			{
				AlertEx(cfg_wlancfgother_language['amp_empty_para']);
				return false;
			}
			
			if (isValidWPAPskKey(value) == false)
			{
				AlertEx(cfg_wlancfgdetail_language['amp_wpskey_invalid']);
				return false;
			}
		}
		
        if (AuthMode == 'wpa-psk')
        {
            Form.addParameter('y.BeaconType','WPA');
            Form.addParameter('y.WPAAuthenticationMode','PSKAuthentication');
            Form.addParameter('y.WPAEncryptionModes',getSelectVal('WlanPwdMode_select'));
        }
        else if (AuthMode == 'wpa2-psk')
        {
            Form.addParameter('y.BeaconType','11i');
            Form.addParameter('y.IEEE11iAuthenticationMode','PSKAuthentication');
            Form.addParameter('y.IEEE11iEncryptionModes',getSelectVal('WlanPwdMode_select'));
        } 
		else if(AuthMode == 'wapi')
		{
			if (isAbcIpAddress(wapiIP) == false)
			{
				AlertEx(cfg_wlancfgdetail_language['amp_wapisrvip_invalid']);
				return false;
			}
			
			if (isValidRadiusPort(parseInt(wapiPort,10)) == false)
			{
				AlertEx(cfg_wlancfgdetail_language['amp_wapisrvport_invalid']);
				return false;
			}
			Form.addParameter('y.BeaconType','X_HW_WAPI');
			Form.addParameter('y.X_HW_WAPIAuthenticationMode','WAPICERT');
			Form.addParameter('y.X_HW_WAPIEncryptionModes','SMS4');
			Form.addParameter('y.X_HW_WAPIServer',wapiIP);
			Form.addParameter('y.X_HW_WAPIPort',parseInt(getValue('wapiPort')),10);
		}
		else if(AuthMode == 'wapi-psk')
		{
			 if (value == '')
			{
				AlertEx(cfg_wlancfgother_language['amp_empty_para']);
				return false;
			}

			if (isValidWPAPskKey(value) == false)
			{
				AlertEx(cfg_wlancfgdetail_language['amp_wpskey_invalid']);
				return false;
			}
			Form.addParameter('y.BeaconType','X_HW_WAPI');
			Form.addParameter('y.X_HW_WAPIAuthenticationMode','WAPIPSK');
			Form.addParameter('y.X_HW_WAPIEncryptionModes','SMS4');
		}
		else
        {
            Form.addParameter('y.BeaconType','WPAand11i');
            Form.addParameter('y.X_HW_WPAand11iAuthenticationMode','PSKAuthentication');
            Form.addParameter('y.X_HW_WPAand11iEncryptionModes',getSelectVal('WlanPwdMode_select'));
        }

        if (wifiPasswordMask == '1')
        {
            if ( (value != "********") || (pskPsdModFlag == true) )
            {
                Form.addParameter('k.PreSharedKey',value);
            }
             
        }
        else
        {
            Form.addParameter('k.PreSharedKey',value);
        }
    }
    else
    {
    }

    return true;
}

var guiCoverSsidNotifyFlag = 0;

function setCoverSsidNotifyFlag(DBvalue, WebValue)
{
    if (DBvalue != WebValue)
    {
        guiCoverSsidNotifyFlag++;
    }
}

function stExtendedWLC(domain, SSIDIndex)
{
    this.domain = domain;
    this.SSIDIndex = SSIDIndex;
}

var apExtendedWLC = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i}.WifiCover.ExtendedWLC.{i}, SSIDIndex, stExtendedWLC);%>;

function isWifiCoverSsidNotify()
{    
    if (guiCoverSsidNotifyFlag > 0)
    {
        return true;
    }
    return false;
}

function isWifiCoverSsid(wlanInst)
{
    for (var j = 0; j < apExtendedWLC.length - 1; j++)
    {
        if (wlanInst == apExtendedWLC[j].SSIDIndex)
        {
            if (isWifiCoverSsidNotify())
            {
                   return true;            
            }
        }
    }

    return false
}

function AddParaForCover(Form)
{
    var wlandomain = Wlan[ssidIdx].domain;
    var length = wlandomain.length;
    var wlanInstId = parseInt(wlandomain.charAt(length-1));
    var beaconType = "Basic";

    Form.addParameter('w.SsidInst',wlanInstId);
    
    Form.addParameter('w.SSID',ltrim(getValue('WlanSsid_text')));
    setCoverSsidNotifyFlag(Wlan[ssidIdx].ssid, ltrim(getValue('WlanSsid_text')));
    
    Form.addParameter('w.Enable',getCheckVal('wlEnable'));

    Form.addParameter('w.Standard',WlanWifi.mode);

    Form.addParameter('w.BasicAuthenticationMode','None');
    Form.addParameter('w.BasicEncryptionModes','WEPEncryption');
    Form.addParameter('w.WPAAuthenticationMode','EAPAuthentication');
    Form.addParameter('w.WPAEncryptionModes',getSelectVal('WlanPwdMode_select'));
    Form.addParameter('w.IEEE11iAuthenticationMode','EAPAuthentication');
    Form.addParameter('w.IEEE11iEncryptionModes',getSelectVal('WlanPwdMode_select'));
    Form.addParameter('w.MixAuthenticationMode','EAPAuthentication');
    Form.addParameter('w.MixEncryptionModes',getSelectVal('WlanPwdMode_select'));
    
    var AuthMode = getSelectVal('WlanAuthMode_select');
    if (AuthMode == 'shared' || AuthMode == 'open')
    {    
        Form.addParameter('w.BeaconType','Basic');
        setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, 'Basic');        
        
        Form.addParameter('w.BasicAuthenticationMode',getSelectVal('WlanWepPwd_select'));
        setCoverSsidNotifyFlag(Wlan[ssidIdx].BasicAuthenticationMode, getSelectVal('WlanWepPwd_select'));        
        
        Form.addParameter('w.BasicEncryptionModes','WEPEncryption');
        setCoverSsidNotifyFlag(Wlan[ssidIdx].BasicEncryptionModes, 'WEPEncryption');
    } 
    else if (AuthMode == 'wpa' || AuthMode == 'wpa2' || AuthMode == 'wpa/wpa2')
    {
        if (AuthMode == 'wpa')
        {
            Form.addParameter('w.BeaconType','WPA');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, 'WPA');            
            
            beaconType = "WPA";
            Form.addParameter('w.WPAAuthenticationMode','EAPAuthentication');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].WPAAuthenticationMode, 'EAPAuthentication');
            
            Form.addParameter('w.WPAEncryptionModes',getSelectVal('WlanPwdMode_select'));
            setCoverSsidNotifyFlag(Wlan[ssidIdx].WPAEncryptionModes, getSelectVal('WlanPwdMode_select'));
        }
        else if (AuthMode == 'wpa2')
        {
            Form.addParameter('w.BeaconType','11i');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, '11i');
            
            beaconType = "11i";
            Form.addParameter('w.IEEE11iAuthenticationMode','EAPAuthentication');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].IEEE11iAuthenticationMode, 'EAPAuthentication');
            
            Form.addParameter('w.IEEE11iEncryptionModes',getSelectVal('WlanPwdMode_select'));
            setCoverSsidNotifyFlag(Wlan[ssidIdx].IEEE11iEncryptionModes, getSelectVal('WlanPwdMode_select'));
        }
        else
        {
            Form.addParameter('w.BeaconType','WPAand11i');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, 'WPAand11i');
            
            beaconType = "WPAand11i";
            Form.addParameter('w.MixAuthenticationMode','EAPAuthentication');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].X_HW_WPAand11iAuthenticationMode, 'EAPAuthentication');
            
            Form.addParameter('w.MixEncryptionModes',getSelectVal('WlanPwdMode_select'));
            setCoverSsidNotifyFlag(Wlan[ssidIdx].X_HW_WPAand11iEncryptionModes, getSelectVal('WlanPwdMode_select'));
        }
    }
    else if (AuthMode == 'wpa-psk' || AuthMode == 'wpa2-psk' || AuthMode == 'wpa/wpa2-psk'|| AuthMode == 'wapi'|| AuthMode == 'wapi-psk')
    {
        if (AuthMode == 'wpa-psk')
        {
            Form.addParameter('w.BeaconType','WPA');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, 'WPA');
            
            beaconType = "WPA";
            Form.addParameter('w.WPAAuthenticationMode','PSKAuthentication');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].WPAAuthenticationMode, 'PSKAuthentication');
            
            Form.addParameter('w.WPAEncryptionModes',getSelectVal('WlanPwdMode_select'));
            setCoverSsidNotifyFlag(Wlan[ssidIdx].WPAEncryptionModes, getSelectVal('WlanPwdMode_select'));
        }
        else if (AuthMode == 'wpa2-psk')
        {
            Form.addParameter('w.BeaconType','11i');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, '11i');
            
            beaconType = "11i";
            Form.addParameter('w.IEEE11iAuthenticationMode','PSKAuthentication');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].IEEE11iAuthenticationMode, 'PSKAuthentication');
            
            Form.addParameter('w.IEEE11iEncryptionModes',getSelectVal('WlanPwdMode_select'));
            setCoverSsidNotifyFlag(Wlan[ssidIdx].IEEE11iEncryptionModes, getSelectVal('WlanPwdMode_select'));
        } 
        else if(AuthMode == 'wapi')
        {
            Form.addParameter('w.BeaconType','X_HW_WAPI');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, 'X_HW_WAPI');
            
            beaconType = "X_HW_WAPI";
            
        }
        else if(AuthMode == 'wapi-psk')
        {
            Form.addParameter('w.BeaconType','X_HW_WAPI');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, 'X_HW_WAPI');
            
            beaconType = "X_HW_WAPI";
        }
        else
        {
            Form.addParameter('w.BeaconType','WPAand11i');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, 'WPAand11i');
            
            beaconType = "WPAand11i";
            Form.addParameter('w.MixAuthenticationMode','PSKAuthentication');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].X_HW_WPAand11iAuthenticationMode, 'PSKAuthentication');
            
            Form.addParameter('w.MixEncryptionModes',getSelectVal('WlanPwdMode_select'));
            setCoverSsidNotifyFlag(Wlan[ssidIdx].X_HW_WPAand11iEncryptionModes, getSelectVal('WlanPwdMode_select'));
        } 
    }
    var KeyBit = getSelectVal('WlanKeyBit_select');    
    Form.addParameter('w.WEPEncryptionLevel',(KeyBit-24)+'-bit');
    setCoverSsidNotifyFlag(Wlan[ssidIdx].EncypBit, (KeyBit-24)+'-bit');
    
    //var keyIndex = getSelectVal('wlKeyIndex');
    var keyIndex = 1;
    Form.addParameter('w.WEPKeyIndex', keyIndex);            
   
    var weppsdModifyFLag = false;
    var key;
    if (1 == keyIndex)
    {
        key = getValue('wlKeys1');
        weppsdModifyFLag = wep1PsdModFlag;
    }
    else if (2 == keyIndex)
    {
        key = getValue('wlKeys2');
        weppsdModifyFLag = wep2PsdModFlag;
    }
    else if (3 == keyIndex)
    {
        key = getValue('wlKeys3');
        weppsdModifyFLag = wep3PsdModFlag;
    } 
    else  if (4 == keyIndex)
    {
        key = getValue('wlKeys4');
        weppsdModifyFLag = wep4PsdModFlag;
    } 

    if ("Basic" != beaconType)
    {
        key = getValue('WlanPassword_password');
    }    
    
    if (wifiPasswordMask == '1')
    {
        if ("Basic" != beaconType) 
        {
            if ( (key != "********") || (pskPsdModFlag == true) )
            {
                Form.addParameter('w.Key', key);
            }
        }
        else
        {
            if ('WEPEncryption' == getSelectVal('WlanPwdMode_select'))
            {
                if (KeyBit == '128')
                {
                    if ( (key != "*************") || (weppsdModifyFLag == true) )
                    {                        
                        Form.addParameter('w.Key', key);
                    }
                }
                else
                {
                    if ( (key != "*****") || (weppsdModifyFLag == true) )
                    {
                        Form.addParameter('w.Key', key);
                    }
                }
            }
        }
    }
    else
    {
        Form.addParameter('w.Key', key);
    }
    

    if ("Basic" != beaconType)
    {
        setCoverSsidNotifyFlag(wpaPskKey[ssidIdx].value, key);
    }
    else
    {
        if (('WEPEncryption' == getSelectVal('WlanPwdMode_select')) && (1 <= keyIndex) && (keyIndex <= 4))
        {
            setCoverSsidNotifyFlag(Wlan[ssidIdx].KeyIndex, keyIndex);
            setCoverSsidNotifyFlag(g_keys[ssidIdx * 4 + (keyIndex - 1)].value, key);
        }
    }
    
    return true;
}

function SubmitForm()
{
    var Form = new webSubmitForm();

    if (addParameter1(Form) == false)
    {
		setDisable('Save_button',0);
    	setDisable('Cancel_button',0);	
		return;
    }
    
    if (addParameter2(Form) == false)
    {
		setDisable('Save_button',0);
    	setDisable('Cancel_button',0);	    
        return;
    }
    
    if (AddParaForCover(Form) == false)
    {
    	setDisable('Save_button',0);
    	setDisable('Cancel_button',0);     
        return;
    }
    
    var wlandomain = Wlan[ssidIdx].domain;
    var AuthMode = getSelectVal('WlanAuthMode_select');

    if (isWifiCoverSsid(getWlanInstFromDomain(wlandomain)))
    {
        if (false == ConfirmEx(cfg_wificover_basic_language['amp_wificover_ssid_change_notify'])) 
        {
            guiCoverSsidNotifyFlag = 0;
            setDisable('Save_button',0);
            setDisable('Cancel_button',0);           
            return;
        }
    }      


	var url;

	if (AuthMode == 'open')
	{
		url = 'set.cgi?w=InternetGatewayDevice.X_HW_DEBUG.AMP.WifiCoverSetWlanBasic&y=' + wlandomain;
	}
    else if (AuthMode == 'shared')
    {
        url = 'set.cgi?w=InternetGatewayDevice.X_HW_DEBUG.AMP.WifiCoverSetWlanBasic&y=' + wlandomain
                    + '&k1=' + wlandomain + '.WEPKey.1'
                    + '&k2=' + wlandomain + '.WEPKey.2'
                    + '&k3=' + wlandomain + '.WEPKey.3'
                    + '&k4=' + wlandomain + '.WEPKey.4';
    }
    else if (AuthMode == 'wpa' || AuthMode == 'wpa2' || AuthMode == 'wpa/wpa2')
    {
		url = 'set.cgi?w=InternetGatewayDevice.X_HW_DEBUG.AMP.WifiCoverSetWlanBasic&y=' + wlandomain;
    }
    else if (AuthMode == 'wpa-psk' || AuthMode == 'wpa2-psk' || AuthMode == 'wpa/wpa2-psk')
    {
        url = 'set.cgi?w=InternetGatewayDevice.X_HW_DEBUG.AMP.WifiCoverSetWlanBasic&y=' + wlandomain
                    + '&k=' + wlandomain + '.PreSharedKey.1';
    }
	else if(AuthMode == 'wapi' || AuthMode == 'wapi-psk')
	{
		url = 'set.cgi?w=InternetGatewayDevice.X_HW_DEBUG.AMP.WifiCoverSetWlanBasic&y=' + wlandomain
		   		+'&k=' + wlandomain + '.PreSharedKey.1';
	}
    else
    {
		url = 'set.cgi?w=InternetGatewayDevice.X_HW_DEBUG.AMP.WifiCoverSetWlanBasic&x=InternetGatewayDevice.LANDevice.1'
                    + '&y=' + wlandomain;
    }

	url += '&RequestFile=html/amp/wlanbasic/e8cWlanBasic.asp';
	Form.setAction(url);

    setDisable('Save_button',1);
    setDisable('Cancel_button',1);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function WlanBasic(enable)
{
	setDisplay('wlanBasicCfg',1);
	setCheck('WlanEnable_checkbox', enable);	

	if ((1 == enable) && (WlanArr[0] != null))
	{
    	ssidIdx = 0;

		if ((1 == DoubleFreqFlag) && ("5G" == wlanpage) && (uiTotal5gNum > 0))
		{
			FirstRecordFor5G();
			selectLine('record_' + RecordFor5G);

		}
        else if((1 == DoubleFreqFlag) && ("2G" == wlanpage) && ((uiTotal2gNum > 0)))
        {
			FirstRecordFor2G();
			selectLine('record_' + RecordFor2G);
        }
		else if (uiTotalNum > 0)
		{
			selectLine('record_0');	
		}
	
    	setDisplay('wlanCfg',1);
    	var authMode = Wlan[ssidIdx].BeaconType;
		beaconTypeChange(authMode); 
	}
	else
	{
    	setDisplay('wlanCfg',0);
	}
}

function BindPsdModifyEvent()
{
    $('#wlKeys1').bind("propertychange input", function(){ 
        var KeyBit = getSelectVal('WlanKeyBit_select');
        if (KeyBit == '128')
        {
            if (getValue('wlKeys1') != "*************")
            {
                wep1PsdModFlag = true;
            }            
        }
        else 
        {
            if(getValue('wlKeys1') != "*****") 
            {
                wep1PsdModFlag = true;
            }
        }
    } );

    $('#WlanPassword_password').bind("propertychange input", function(){ 
        if(getValue('WlanPassword_password') != "********") 
        {
            pskPsdModFlag = true;
        } 
    } );

    $('#wlRadiusKey').bind("propertychange input", function(){ 
        if(getValue('wlRadiusKey') != "********") 
        {
            radPsdModFlag = true;
        }
    } );
}



function LoadFrame()
{   	
	var flag5G =0;
	var flag2G =0;

	Total2gNum();

	if (enbl == '')
    {
        setDisplay('wlanBasicCfg',0);
    }
    else
    {
		setDisplay('ConfigForm',1); 
        if (1 == DoubleFreqFlag)
		{
		    FirstRecordFor5G();
			
            if ('2G' == wlanpage)
            {
                WlanBasic(enbl2G);
            }

            if ('5G' == wlanpage)
            {
                WlanBasic(enbl5G);
            }
		}
		else
		{
			WlanBasic(enbl);
		}		
    }

	if (1 == DoubleFreqFlag)
	{
		if("2G" == wlanpage)
		{
			for(var j = 0; j < WlanMap.length; j++)
			{
				if(WlanMap[j].portIndex < 4 )
				{
					flag2G++
				}
			}
			if(flag2G > 0)
			{
				setDisplay('ssidDetail',1);
			}
			else
			{
				setDisplay('ssidDetail',0);
			}
		}

		if("5G" == wlanpage)
		{
			for(var j = 0; j < WlanMap.length; j++)
			{
				if(WlanMap[j].portIndex >= 4 )
				{
					flag5G++
				}
			}
			if(flag5G > 0)
			{
				setDisplay('ssidDetail',1);
			}
			else
			{
				setDisplay('ssidDetail',0);
			}
		}
	}
	else 
    {
		if(0 == WlanMap.length)
		{
        	setDisplay('ssidDetail',0);
		}
    }

    addAuthModeOption();

	WlanKeyBit_selectChange();

	if (1 == '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_HUNCT);%>')
	{
		setDisable("WlanPwdMode_select",1);
		setDisable("WlanAuthMode_select",1);
	}

    if (wifiPasswordMask == 1)
    {
        BindPsdModifyEvent();
        
    	setDisable('hidewlRadiusKey', 1);
    	setDisable('hidewlKeys', 1);
    	setDisable('CheckoutPassword_button', 1);    	
    }
	
	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		
		if (cfg_wlancfgbasic_language[b.getAttribute("BindText")]) {
			b.innerHTML = cfg_wlancfgbasic_language[b.getAttribute("BindText")];
		} else if (cfg_wlancfgdetail_language[b.getAttribute("BindText")]) {
			b.innerHTML = cfg_wlancfgdetail_language[b.getAttribute("BindText")];	
		} else if (cfg_wlancfgadvance_language[b.getAttribute("BindText")]) {
			b.innerHTML = cfg_wlancfgadvance_language[b.getAttribute("BindText")];	
		} else if (cfg_wlancfgother_language[b.getAttribute("BindText")]) {
			b.innerHTML = cfg_wlancfgother_language[b.getAttribute("BindText")];		
		} else if (cfg_wlanzone_language[b.getAttribute("BindText")]) {
			b.innerHTML = cfg_wlanzone_language[b.getAttribute("BindText")];		
		}	
	}

	if (g_keys[0] != null)
    {
        document.getElementById('wlKeys1').title = posswordComplexTitle;
        document.getElementById('twlKeys1').title = posswordComplexTitle;  
    } 
    document.getElementById('WlanPassword_password').title = posswordComplexTitle;
    document.getElementById('tWlanPassword_password').title = posswordComplexTitle;
    document.getElementById('wlRadiusKey').title = posswordComplexTitle;
    document.getElementById('twlRadiusKey').title = posswordComplexTitle;	
}

function ApplySubmit1()
{
    var Form = new webSubmitForm();   

    if (addParameter1(Form) == false)
    {
        setDisable('Save_button',0);
        setDisable('Cancel_button',0);	
        return;
    }
    
	if (1 == DoubleFreqFlag)
	{
		if ("2G" == wlanpage)
		{
  			Form.addParameter('y.LowerLayers', node2G);
			Form.setAction('add.cgi?y=InternetGatewayDevice.LANDevice.1.WLANConfiguration'
	               					+ '&RequestFile=html/amp/wlanbasic/e8cWlanBasic.asp');	
		}
		else if ("5G" == wlanpage)
		{
  			Form.addParameter('y.LowerLayers', node5G);
			Form.setAction('add.cgi?y=InternetGatewayDevice.LANDevice.1.WLANConfiguration'
	              					 + '&RequestFile=html/amp/wlanbasic/e8cWlanBasic.asp');
		}
		else
		{}

	}
	else
	{
        Form.setAction('add.cgi?y=InternetGatewayDevice.LANDevice.1.WLANConfiguration' 
	                       + '&RequestFile=html/amp/wlanbasic/e8cWlanBasic.asp');
	}

    setDisable('Save_button',1);
    setDisable('Cancel_button',1);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function ApplySubmit2()
{
    SubmitForm();
}

function ApplySubmit()
{
    if (AddFlag == true)
    {
        setDisable('BtnAdd', 1);
        setDisable('BtnRemove', 1);
        setDisable('Save_button',1);
        setDisable('Cancel_button',1);

        ApplySubmit1();
    }
    else
    {
        ApplySubmit2();
    }
}

function EnableSubmit()
{
    setDisable('WlanEnable_checkbox', 1);
    AddFlag = false;
    var Form = new webSubmitForm();
    var enable = getCheckVal('WlanEnable_checkbox');
	var url;
	
    setDisable('Save_button', 1);
    setDisable('Cancel_button', 1);
	
    if (1 == DoubleFreqFlag)
    {
        if ("2G" == wlanpage)
        {
    	    Form.addParameter('x.Enable',enable);
		    if ('InternetGatewayDevice.LANDevice.1.WiFi.Radio.1' == node2G)
		    {
				url = 'set.cgi?x=InternetGatewayDevice.LANDevice.1.WiFi.Radio.1'; 
		    }
		    else
		    {
				url = 'set.cgi?x=InternetGatewayDevice.LANDevice.1.WiFi.Radio.2';	
		    }
        }
        else if ("5G" == wlanpage)
        {
    	    Form.addParameter('x.Enable',enable);
  		    if ('InternetGatewayDevice.LANDevice.1.WiFi.Radio.1' == node5G)
		    {
				url = 'set.cgi?x=InternetGatewayDevice.LANDevice.1.WiFi.Radio.1'; 
		    }
		    else
		    {
				url = 'set.cgi?x=InternetGatewayDevice.LANDevice.1.WiFi.Radio.2';	
		    }
        }
		else
		{
		
		}		
	}
    else
    {
    	Form.addParameter('x.X_HW_WlanEnable',enable);
		url = 'set.cgi?x=InternetGatewayDevice.LANDevice.1';
    }

	url += '&RequestFile=html/amp/wlanbasic/e8cWlanBasic.asp';
	Form.setAction(url);
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function showWlan(currentWlan)
{
    with (document.forms[0])
    {
        ShowSsidEnable(currentWlan);
        setText('WlanSsid_text',currentWlan.ssid);
        if (ssidAccessAttr.indexOf('Subscriber') < 0)
        {
            setDisable('WlanSsid_text',1);
        }

        beaconTypeChange(currentWlan.BeaconType);
    }
}

function setControl(idIndex)
{   
    if (-1 == idIndex)
    {   
        if (1 == SingleFreqFlag)
		{
			if (Wlan.length >= maxSingleWLAN.MAX_ID)
			{
				setDisplay('cfg_table', 0);
				AlertEx(cfg_wlancfgother_language['amp_ssid_4max']);
				return;
			}
		}
		else if (1 == DoubleFreqFlag)
		{
			Total2gNum();

			if ("2G" == wlanpage)
			{
				if ((uiTotal2gNum >= 4) || (uiTotalNum >= 8))
				{
					setDisplay('cfg_table', 0);
					AlertEx(cfg_wlancfgother_language['amp_ssid_4max']);
					return;
				}
			}
			
			else if("5G" == wlanpage)
			{
				if ((uiTotal5gNum >= 4) || (uiTotalNum >= 8))
				{
					setDisplay('cfg_table', 0);
					AlertEx(cfg_wlancfgother_language['amp_ssid_4max']);
					return;
				}
			}
		}
   	
        ssidIdx = -1;
        AddFlag = true;

        currentWlan = new stWlan('','','','',1,32,1,'','','','','','','','','','','','','','','');

        setDisplay('ssidDetail', 1);
        setDisplay('securityCfg',0);
    }
    else
    {
        setDisplay('cfg_table', 1);
        setDisplay('securityCfg',1);
        ssidIdx = parseInt(WlanMap[idIndex].index);
        AddFlag = false;
		
        currentWlan = Wlan[ssidIdx];
    }

    showWlan(currentWlan);
	setDisplay("wlanshareconf",0);

	if ((1 == isSsidForIsp(wlanInst)) && (1 == ShowISPSsidFlag))
	{
		setDisable('Save_button', 1);
		setDisable('Cancel_button', 1);
		initWlanShare();
		setDisplay("wlanshareconf",1);
		
		ClearPsdModFlag();
		
		return;
	}

    setDisable('Save_button', 0);
    setDisable('Cancel_button', 0);

	var curWlanInst = getWlanInstFromDomain(currentWlan.domain);

	if ((1 == isSsidForIsp(curWlanInst)) && (1 == ShowISPSsidFlag))
	{
		initWlanShare();
		setDisplay("wlanshareconf",1);
		
		setDisable('Save_button', 1);
        setDisable('Cancel_button', 1);
	}


    ClearPsdModFlag();
}

function selectRemoveCnt(curCheck)
{
}

function Cancel_buttonValue()
{
	var temp1 =0;
	var temp2 =0;
    if (AddFlag == true)
    {
        var tableRow = getElement("wlanInst");
		if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
		{
			FirstRecordFor5G();
			selectLine('record_' + RecordFor5G);
			
			for(var i = 0; i < WlanMap.length; i++)
			{
				if(WlanMap[i].portIndex >3)
				{
					temp1++;
				}
			}
			if(temp1==0)
			{
				setDisplay('ssidDetail',0);
			}
		}
		else if((1 == DoubleFreqFlag) && ("2G" == wlanpage))
		{
			FirstRecordFor2G();
			selectLine('record_' + RecordFor2G);
			
			for(var j = 0; j < WlanMap.length; j++)
			{
				if(WlanMap[j].portIndex < 4)
				{
					temp2++;
				}
			}
			if(temp2==0)
			{
				setDisplay('ssidDetail',0);
			}
           
        }
		else
		{
			selectLine('record_0');
		}
        
        tableRow.deleteRow(tableRow.rows.length-1);
    }
    else
    {
        var currentWlan = Wlan[ssidIdx];
        showWlan(currentWlan);
    }

    ClearPsdModFlag();
}

var authmode = cfg_wlancfgdetail_language['amp_authmode_help'];
var encryption = cfg_wlancfgdetail_language['amp_encrypt_help'];
var ssid = cfg_wlancfgdetail_language['amp_ssid_help'];
var posswordComplexTitle = cfg_wlancfgdetail_language['amp_wlanpasswordcomplex_title'];

</script>
</head>

<body class="mainbody" onLoad="LoadFrame();">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<tr> 
		<td class="table_head" width="100%">无线基本配置</td> 
	</tr>

	<tr> 
		<td height="5"></td> 
	</tr>

    <tr>
      <td class="prompt">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
		    <tr>
			    <td class="title_common">
					<script language="JavaScript">
					if((1 == DoubleFreqFlag) && ("2G" == wlanpage))
					{
						document.write(cfg_wlancfgother_language['amp_wlanbasic_title_2G']);
					}
					else if((1 == DoubleFreqFlag) && ("5G" == wlanpage))
					{
						document.write(cfg_wlancfgother_language['amp_wlanbasic_title_5G']);
					}
					else
					{
						document.write("说明：可设置无线的基本功能，" +
						"包括启用/禁用无线连接、设置无线网络SSID以及无线安全配置、指定加入无线网络是否需要网络密钥及密钥强度等基本功能(在无线网络功能关闭时，此页面内容可能为空)。");
					}
                    </script>
					<label id="Title_wlan_common_set_lable" class="title_common">					
					</label>                    
				</td>
			</tr>		
    <tr> 
      <td class="title_common">  
	  <div>	
	  <table>
          <tr> 
            <td class='width_per15 align_left'><img style="margin-bottom:2px" src="../../../images/icon_01.gif" width="15" height="15" /></td> 
            <td class='width_per85 align_left'><script>document.write(cfg_wlancfgother_language['amp_wlan_note1']);</script></td> 
          </tr>
	 </table>
	 </div>
          <tr><td class="title_common"><script>document.write("1. " + cfg_wlancfgother_language['amp_wlan_note']);</script></td></tr>
          <tr><td class="title_common"><script>document.write("2. " + cfg_wlancfgother_language['amp_wlan_note2']);</script></td></tr>
       </td> 
    </tr> 
        </table>
      </td>
    </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" id="table_space1">
    <tr ><td class="height15p"></td></tr>
</table>

<form id="ConfigForm" action="../network/set.cgi" style="display:none">
 <table width="100%" border="0" cellspacing="0" cellpadding="0" >
  <tr ><td>
  
    <div id='wlanBasicCfg'>
    <div id='wlanswitch'>
    <table cellspacing="0" cellpadding="0" width="100%" id="wlanOnOff">
      <tr>
        <td><input type='checkbox' name='WlanEnable_checkbox' id='WlanEnable_checkbox' onClick='EnableSubmit();' value="ON">
          启用无线网络</input></td>
      </tr>
    </table>
  	</div>

    <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table_space2">
      <tr ><td class="width_10px"></td></tr>
    </table>

    <div id='wlanCfg'>
    <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="wlanInst">
      <tr class="table_title" align="center">
        <td>&nbsp;</td>
        <td ><div class="align_center"><script>document.write(cfg_wlancfgbasic_language['amp_ssid_id']);</script></div></td>
        <td ><div class="align_center"><script>document.write(cfg_wlancfgbasic_language['amp_ssid_name']);</script></div></td>
        <td ><div class="align_center"><script>document.write(cfg_wlancfgbasic_language['amp_ssid_link']);</script></div></td>
        <td ><div class="align_center"><script>document.write(cfg_wlancfgbasic_language['amp_security_cfg']);</script></div></td>
      </tr>
        <script language="JavaScript" type="text/javascript">
        for (var i = 0;i < WlanMap.length; i++)
        {   
			if ('' == Wlan[i].name)
			{
				continue;
			}

            var mapIndex = parseInt(getIndexFromPort(WlanMap[i].portIndex));

			if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
            {
                if (WlanMap[i].portIndex < 4)
                {
                    continue;
                }
            }
					
			if ((1 == DoubleFreqFlag) && ("2G" == wlanpage))
            {
                if (WlanMap[i].portIndex > 3)
                {
                    continue;
                }					
            }

            document.write('<TR id="record_' + i  + '" class="tabal_01" onclick="selectLine(this.id);">');

            if ((0 == WlanMap[i].portIndex) || (4 == WlanMap[i].portIndex))
            {
                document.write('<TD>' + '<input type="checkbox" name="rml" id="rml"'  + ' value="'+ Wlan[mapIndex].domain + '" onclick="selectRemoveCnt(i);" disabled="true" >' + '</TD>');
            }
            else
            {
                document.write('<TD>' + '<input type="checkbox" name="rml" id="rml"'  + ' value="'+ Wlan[mapIndex].domain + '" onclick="selectRemoveCnt(i);">' + '</TD>');
            }
			
            document.write('<TD>' + getWlanInstFromDomain(Wlan[mapIndex].domain) + '</TD>');
			document.write('<TD>' + GetSSIDStringContent(Wlan[mapIndex].ssid,32)+ '</TD>');
			
            if ((Wlan[mapIndex].enable == 1) && (Wlan[mapIndex].X_HW_ServiceEnable == 1))
            {
                document.write('<TD>' + cfg_wlancfgbasic_language['amp_ssid_enable'] + '</TD>');
            }
            else
            {
                document.write('<TD>' + cfg_wlancfgbasic_language['amp_ssid_disable'] + '</TD>');
            }

            if ((Wlan[mapIndex].BeaconType == 'Basic' && Wlan[mapIndex].BasicEncryptionModes == 'None') || (Wlan[mapIndex].BeaconType == 'None'))
            {
                document.write('<TD>' + cfg_wlancfgbasic_language['amp_ssid_disauth'] + '</TD>');
            }
            else
            {
                document.write('<TD>' + cfg_wlancfgbasic_language['amp_ssid_enauth'] + '</TD>');
            }
            document.write('</TR>');
        }
        </script>
    </table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr ><td class="height5p"></td></tr>
</table>

<div id='ssidDetail'>
<table width="100%" border="0" cellpadding="0" cellspacing="1" id="cfg_table">
  <tr>
    <td colspan="6">
	
	<table  width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="tabal_head" id="ssid_defail">
          <td BindText='amp_ssid_detail'></td>
        </tr>
      </table>

      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr>
          <td class="table_left width_per25">SSID:&nbsp;</td>
            <td class="table_right" id="TdSSID">
              <input type="text" name="WlanSsid_text" id="WlanSsid_text" style="width:123px" maxlength="32">
              <font class="color_red">*</font><span class="gray">
              <script>document.write(cfg_wlancfgdetail_language['amp_linkname_note']);</script></span> 
          </td>
        </tr>

        <tr>
          <td class="table_left width_per25" BindText='amp_link_status'></td>
          <td class="table_right" id="TdEnable">
            <input type='checkbox' id='wlEnable' name='wlEnable' value="ON" onClick="SsidEnable();">
            <span class="gray"> </span></td>
        </tr>
      </table>

    <div id='securityCfg'>
    <div id='WlanAuthMode_selectDiv'>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr>
          <td class="table_left width_per25">认证模式:&nbsp;</td>
          <td class="table_right" id="TdAuth">
            <select id='WlanAuthMode_select' name='WlanAuthMode_select' size="1" onChange='authModeChange()' style = "width:145px">
            <script language="JavaScript" type="text/javascript">
            document.write("<option value='open' selected>"+cfg_wlancfgdetail_language['amp_auth_open']+"</option>");
			document.write("<option value='shared'>"+cfg_wlancfgdetail_language['amp_auth_shared']+"</option>");
			document.write("<option value='wpa-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpapsk']+"</option>");
			document.write("<option value='wpa2-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpa2psk']+"</option>");
			document.write("<option value='wpa/wpa2-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpawpa2psk']+"</option>");
			document.write("<option value='wpa'>"+cfg_wlancfgdetail_language['amp_auth_wpa']+"</option>");
			document.write("<option value='wpa2'>"+cfg_wlancfgdetail_language['amp_auth_wpa2']+"</option>");
			document.write("<option value='wpa/wpa2'>"+cfg_wlancfgdetail_language['amp_auth_wpawpa2']+"</option>");
			if(1 == WapiFlag)
			{
				document.write("<option value='wapi-psk'>"+cfg_wlancfgdetail_language['amp_auth_wapi_psk']+"</option>");
				document.write("<option value='wapi'>"+cfg_wlancfgdetail_language['amp_auth_wapi']+"</option>");
			}
            </script>			
            </select> <span class="gray"> </span>
			<label id="Title_wlan_authentication_tips_lable" class="title_common">
			  	推荐使用WPA-PSK/WPA2-PSK认证模式
			</label>
		</td>
        </tr>
      </table>
    </div>

    <div id='wlEncryMethod'>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr>
          <td class="table_left width_per25" BindText='amp_encrypt_mode'>加密方式:&nbsp;</td>
          <td class="table_right" id="TdEncrypt">
            <select id = 'WlanPwdMode_select' name = 'WlanPwdMode_select'  size='1'  onChange='onMethodChange(0);' style = "width:145px">
            </select>
			<label id="Title_wlan_tkip+aes_tips_lable" class="title_common">
			  	推荐使用TKIP+AES加密方式
			</label>
          </td>
        </tr>
      </table>
    </div>

	<div id='wlEncryWep'>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr>
          <td class="table_left width_per25">WEP加密:&nbsp;</td>
          <td class="table_right" id="TdEncrypt">
            <select id = 'WlanWepPwd_select' name = 'WlanWepPwd_select'  size='1'  onChange='onWepChange(0);' style = "width:145px">
				<option value="OpenSystem" selected>OPEN</option>
				<option value="SharedKey">SHARE</option>
				<option value="Both">OPEN+SHARE</option>
            </select>
			<label id="Title_wlan_open+share_tips_lable" class="title_common">
			  	推荐使用OPEN+SHARE加密
			</label>
          </td>
        </tr>
      </table>
    </div>

    <div id='keyInfo'>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr>
          <td class="table_left width_per25">加密长度:&nbsp;</td>
          <td class="table_right">
              <select id='WlanKeyBit_select' name='WlanKeyBit_select' size='1' onChange='WlanKeyBit_selectChange()' style = "width:145px">
                <option value="128" selected><script>document.write(cfg_wlancfgdetail_language['amp_encrypt_128key']);</script></option>
                <option value="64"><script>document.write(cfg_wlancfgdetail_language['amp_encrypt_64key']);</script></option>
              </select>
			  <label id="Title_wlan_key_tips_lable" class="title_common">
			  </label>
		 </td>
        </tr>

        <tr>
          <td class="table_left  width_per25">无线网络密钥:&nbsp;</td>
          <td class="table_right"> <script language="JavaScript" type="text/javascript">
            if (g_keys[0] != null)
            {
                document.write("<input type='password' id='wlKeys1' name='wlKeys1' size='20' maxlength=26 onchange=\"wep1password=getValue('wlKeys1');getElById('twlKeys1').value=wep1password\" value='" + g_keys[0][1] + "'>")
                document.write("<input type='text' id='twlKeys1' name='twlKeys1' size='20' maxlength=26 style='display:none'  onchange=\"wep1password=getValue('twlKeys1');getElById('wlKeys1').value=wep1password\" value='" + g_keys[0][1] + "'>");
            }
            </script>
			<font class="color_red">*</font>
		  	<button type='button' id='hidewlKeys' name='hidewlKeys' class="submit" onClick="ShowOrHideText(0, 'hidewlKeys', 'wlKeys1', 'twlKeys1', wep1password);"/>		 	
				<script>document.write(desc_show);</script>
			</button>
		  </td>
        </tr>        
      </table>
    </div>

    <div id='wpaPreShareKey'>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr>
          <td class="table_left width_per25" id= "wpa_psk">
		  <script>
		  var authMode = getSelectVal('WlanAuthMode_select'); 
		  if(authMode == 'wapi-psk')
		  {
		  		document.write(cfg_wlancfgdetail_language['amp_wapi_psk']);
		  }
		  else
		  {
		  		document.write("无线网络密钥:&nbsp;");
		  }
		  </script>
		  </td>
          <td class="table_right">
            <input type='password' id='WlanPassword_password' name='WlanPassword_password' size='20' maxlength='64' class="amp_font"  onchange="wpapskpassword=getValue('WlanPassword_password');getElById('tWlanPassword_password').value=wpapskpassword;" />
            <input type='text' id='tWlanPassword_password' name='tWlanPassword_password' size='20' maxlength='64' class="amp_font" style='display:none' onchange="wpapskpassword=getValue('tWlanPassword_password');getElById('WlanPassword_password').value=wpapskpassword;"/>
			<font class="color_red">*</font><span class="gray">
			<button type="button" id="CheckoutPassword_button" name="CheckoutPassword_button" class="submit" onClick="ShowOrHideText(1, 'CheckoutPassword_button', 'WlanPassword_password', 'tWlanPassword_password', wpapskpassword);">
				<script>document.write(desc_show);</script>
			</button>		
			<script>document.write(cfg_wlancfgdetail_language['amp_wpa_psknote']);</script></span>	
		 </td>
        </tr>
      </table>
    </div>

	 <div id='wlWapi'>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr>
           <td class="table_left width_per25" BindText='amp_wapi_ip'></td>
           <td class="table_right">
              <input type='text' id='wapiIPAddr' name='wapiIPAddr' size='20' maxlength='15'>
			  <font class="color_red">*</font>
          </td>
        </tr>
      </table>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr>
          <td class="table_left width_per25" BindText='amp_wapi_port'></td>
           <td class="table_right">
              <input type='text' id='wapiPort' name='wapiPort' size='20' maxlength='15'>
			  <font class="color_red">*</font><span class="gray">
			  <script>document.write(cfg_wlancfgdetail_language['amp_radiusport_note']);</script></span> 
          </td>
        </tr>
      </table>
    </div>

    <div id='wlRadius'>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr>
          <td class="table_left width_per25" BindText='amp_radius_srvip'></td>
          <td class="table_right">
              <input type='text' id='wlRadiusIPAddr' name='wlRadiusIPAddr' size='20' maxlength='15'>
              <font class="color_red">*</font>
          </td>
        </tr>
      </table>

      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr>
          <td class="table_left width_per25" BindText='amp_radius_srvport'></td>
          <td class="table_right">
            <input type='text' id='wlRadiusPort' name='wlRadiusPort' size='20' maxlength='5'>
            <font class="color_red">*</font><span class="gray">
            <script>document.write(cfg_wlancfgdetail_language['amp_radiusport_note']);</script></span> 
          </td>
        </tr>
      </table>

      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr>
          <td class="table_left width_per25" BindText='amp_radius_sharekey'></td>

          <td class="table_right">
            <input type='password' id='wlRadiusKey' name='wlRadiusKey' size='20' maxlength='64' class="amp_font" onchange="radiuspassword=getValue('wlRadiusKey');getElById('twlRadiusKey').value=radiuspassword;" />
            <input type='text' id='twlRadiusKey' name='twlRadiusKey' size='20' maxlength='64' class="amp_font" style='display:none'  onchange="radiuspassword=getValue('twlRadiusKey');getElById('wlRadiusKey').value=radiuspassword;"/>
			<button type="button" id="hidewlRadiusKey" name="hidewlRadiusKey" class="submit" onClick="ShowOrHideText(2, 'hidewlRadiusKey', 'wlRadiusKey', 'twlRadiusKey', radiuspassword);"/>
			<script>document.write(desc_show);</script>
			</button>
          </td>
        </tr>
      </table>
    </div>

</div>
	
    <table width="100%" border="0" cellpadding="0" cellspacing="0"  >
      <tr><td>
        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
          <tr align="right">
            <td class="table_submit width_per25"></td>
            <td class="table_submit">
			  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
              <button id="Save_button" name="Save_button" type="button" class="submit" onClick="ApplySubmit();"><script>document.write(cfg_wlancfgother_language['amp_wlancfg_sure']);</script></button>
              <button id="Cancel_button" name="Cancel_button" type="button" class="submit" onClick="Cancel_buttonValue();"><script>document.write(cfg_wlancfgother_language['amp_wlancfg_cancel']);</script></button>
            </td>
          </tr>
        </table>
        </td> 
	  </tr>
    </table>
    
	</td> 
    </tr>
</table>

</div>
</div>
</div>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr ><td class="height15p"></td></tr>
</table>

</td></tr>
</table>
</form>

<!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd --></html>

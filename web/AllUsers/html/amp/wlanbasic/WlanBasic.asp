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

var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var sptUserType ='1';
var gzcmccFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_GZCMCC);%>';
var TelMexFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TELMEX);%>';
var PccwFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PCCW);%>';
var WapiFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WAPI);%>';
var OnlySsid1Flag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_ONLY_SSID1);%>';
var CurrentBin = '<%HW_WEB_GetBinMode();%>';
var ShowISPSsidFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_SHOW_ISPSSID);%>';
var IspSSIDVisibility = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_ISPSSID_VISIBILITY);%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
var wifiPasswordMask='<%HW_WEB_GetWlanPsdMask();%>';
var noWlanSwitchFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN_ENABLE_ITMS_ONLY);%>';
var WPAPSKFlag = '<%HW_WEB_GetFeatureSupport(FT_WLAN_WPAPSK_SUPPORT);%>';
var noWep64Flag = '<%HW_WEB_GetFeatureSupport(FT_WLAN_NO_WEP_64);%>';
var AmpTDESepicalCharaterFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TDE_SEPCIAL_CHARACTER);%>';

var wep1password;
var wep2password;
var wep3password;
var wep4password;
var wpapskpassword;
var radiuspassword;
var telmexSpan = false;
var wep1PsdModFlag = false;
var wep2PsdModFlag = false;
var wep3PsdModFlag = false;
var wep4PsdModFlag = false;
var pskPsdModFlag = false;
var radPsdModFlag = false;

var jQ_IspDisabledItem = null;
var jQ_IspEnabledItem  = null;
var g_currentwlanInst  = null;

if ((('TELMEX' == CfgMode.toUpperCase()) || ('TELMEX5G' == CfgMode.toUpperCase())) && 'SPANISH' == curLanguage.toUpperCase())
{
    telmexSpan = true;
}

function GetLanguageDesc(Name)
{
    return cfg_wlancfgdetail_language[Name];
}

var prefix = 'PLDTHOMEFIBR';
var preflag = 0;
if ('PLDT' == CfgMode.toUpperCase())
{
    preflag = 1;
}

function getInstIdByDomain(domain)
{
    if ('' != domain)
    {
        return parseInt(domain.charAt(domain.length - 1));    
    }
}

var wlanpage;
if (location.href.indexOf("WlanBasic.asp?") > 0)
{
    wlanpage = location.href.split("?")[1]; 
    top.WlanBasicPage = wlanpage;
}

wlanpage = top.WlanBasicPage;

initWlanCap(wlanpage);

function ShowOrHideText(checkBoxId, passwordId, textId, value)
{
    if (1 == getCheckVal(checkBoxId))
    {
        setDisplay(passwordId, 1);
        setDisplay(textId, 0);
    }
    else
    {
        setDisplay(passwordId, 0);
        setDisplay(textId, 1);
    }
}

function stWlan(domain,name,enable,ssid,wlHide,DeviceNum,wmmEnable,BeaconType,BasicEncryptionModes,BasicAuthenticationMode,
                KeyIndex,EncryptionLevel,WPAEncryptionModes,WPAAuthenticationMode,IEEE11iEncryptionModes,IEEE11iAuthenticationMode,
                X_HW_WPAand11iEncryptionModes,X_HW_WPAand11iAuthenticationMode,WPARekey,RadiusServer,RadiusPort,RadiusKey,X_HW_ServiceEnable, LowerLayers,
                X_HW_WAPIEncryptionModes,X_HW_WAPIAuthenticationMode,X_HW_WAPIServer,X_HW_WAPIPort)
{
    this.domain = domain;
    this.name = name;
    this.enable = enable;
    this.ssid = ssid;
    this.wlHide = wlHide;
    this.DeviceNum = DeviceNum;
    this.wmmEnable = wmmEnable;
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
    this.WPARekey = WPARekey;
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

function stPreSharedKey(domain, psk, kpp)
{
    this.domain = domain;
    this.value = psk;

    if('1' == kppUsedFlag)
    {
        this.value = kpp;
    }
}

function stWpsPin(domain, X_HW_ConfigMethod, DevicePassword, X_HW_PinGenerator, Enable)
{
    this.domain = domain;
    this.X_HW_ConfigMethod = X_HW_ConfigMethod;
    this.DevicePassword = DevicePassword;
    this.X_HW_PinGenerator = X_HW_PinGenerator;
    this.Enable = Enable;
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

function stLanDevice(domain, WlanCfg, Wps2)
{
    this.domain = domain;
    this.WlanCfg = WlanCfg;
    this.Wps2 = Wps2;
}

var WpsTimeInfo = '<%HW_WEB_GetWPSTime();%>';

function getWpsTimer()
{
    $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "refreshTime.asp?&1=1",
            success : function(data) {
                WpsTimeInfo = data;
            }
        });
}

var WpsIndex = WpsTimeInfo.split(',')[0];
var WpsTime = WpsTimeInfo.split(',')[1];
var WpsTimeHandle;

var SsidNum = '<%HW_WEB_GetSsidNum();%>';
var SsidNum2g = SsidNum.split(',')[0];
var SsidNum5g = SsidNum.split(',')[1];

var WlanWifiArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|X_HW_Standard|Channel|TransmitPower|RegulatoryDomain|AutoChannelEnable|X_HW_HT20,stWlanWifi);%>;
var WlanWifi = WlanWifiArr[0];
if (null == WlanWifi)
{
    WlanWifi = new stWlanWifi("","","","","11n","","","","","");
}

var LanDeviceArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1, X_HW_WlanEnable|X_HW_Wps2Enable, stLanDevice,EXTEND);%>;
var LanDevice = LanDeviceArr[0];

var enbl = LanDevice.WlanCfg;
var Wps2 = LanDevice.Wps2;

var WlanCus = '<%HW_WEB_GetWlanCus();%>';
var WpsCapa = WlanCus.split(',')[0];

var Wlan = new Array();

var WlanArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|SSIDAdvertisementEnabled|X_HW_AssociateNum|WMMEnable|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WEPKeyIndex|WEPEncryptionLevel|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|X_HW_GroupRekey|X_HW_RadiuServer|X_HW_RadiusPort|X_HW_RadiusKey|X_HW_ServiceEnable|LowerLayers|X_HW_WAPIEncryptionModes|X_HW_WAPIAuthenticationMode|X_HW_WAPIServer|X_HW_WAPIPort,stWlan);%>;

var wlanArrLen = WlanArr.length - 1;

for (i=0; i < wlanArrLen; i++)
{
    Wlan[i] = new stWlan();
    Wlan[i] = WlanArr[i];
}

var g_keys = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.WEPKey.{i},WEPKey,stWEPKey);%>;
if (null != g_keys)
{
    wep1password = g_keys[0];
    wep2password = g_keys[1];
    wep3password = g_keys[2];
    wep4password = g_keys[3];
}

var wpaPskKey = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.PreSharedKey.1,PreSharedKey|KeyPassphrase,stPreSharedKey);%>;

var wpsPinNum = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.WPS,X_HW_ConfigMethod|DevicePassword|X_HW_PinGenerator|Enable,stWpsPin);%>;

var ssidIdx = -1;
var ssidAccessAttr = 'Subscriber';
var AddFlag = true;
var currentWlan = new stWlan();
var SsidPerBand = '<%HW_WEB_GetSPEC(AMP_SPEC_SSID_NUM_MAX_BAND.UINT32);%>';


function wlanSetSelect(id, val)
{
	setSelect(id, val);
	
	if(id == 'wlKeyBit')
	{
		wlKeyBitChange();
	}
}
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
                if (null == WlanWifi)
                {
                    WlanWifi = new stWlanWifi("","","","","11n","","","","","");
                } 
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
                if (null == WlanWifi)
                {
                    WlanWifi = new stWlanWifi("","","","","11n","","","","","");
                }            
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
    
    WlanMap[j] = new stIndexMapping(i,index);
    j++;

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

function ValidateChecksum(PIN) 
{
    var accum = 0;
    var iRet;
    accum += 3 * (parseInt(PIN / 10000000) % 10); 
    accum += 1 * (parseInt(PIN / 1000000) % 10); 
    accum += 3 * (parseInt(PIN / 100000) % 10);
    accum += 1 * (parseInt(PIN / 10000) % 10);
    accum += 3 * (parseInt(PIN / 1000) % 10);
    accum += 1 * (parseInt(PIN / 100) % 10);
    accum += 3 * (parseInt(PIN / 10) % 10);
    accum += 1 * (parseInt(PIN / 1) % 10);
    if (0 == (accum % 10))
    {
        iRet = 0;                                 
    }
    else
    {
        iRet = 1;
    }
    return iRet;
} 


function computeDefaultPin()
{
    var pin = 0;
    var datavalue = 0;
    var wlandomain = Wlan[ssidIdx].domain;
    var wlanId = wlandomain.charAt(wlandomain.length - 1);
    
    $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "WlanWpsPin.asp?&1=1",
            data :"wlanid="+wlanId,
            success : function(data) {
            datavalue = data.split("\r");
            }
        });
    
    pin = datavalue[0];
    return pin;
}

function computePinInteger()
{
    var defaultpin = 0;
    var datavalue = 0;
    $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "WlanWpsPin.asp?&1=1",
            data :"wlanid="+0,
            success : function(data) {
            datavalue = data.split("\r");
            }
        });
    
    defaultpin = datavalue[0];
    return defaultpin;
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

function addAuthModeOption()
{
    var mode = WlanWifi.mode;
	var auth = getSelectVal('wlAuthMode');
	
    var authModes = { 'open' : [cfg_wlancfgdetail_language['amp_auth_open'], 1], 
	                  'shared' : [cfg_wlancfgdetail_language['amp_auth_shared'], (1 == wepCap)], 
	                  'wpa-psk' : [cfg_wlancfgdetail_language['amp_auth_wpapsk'], (1 == capWPAPSK) && ('1' == WPAPSKFlag)], 
	                  'wpa2-psk' : [cfg_wlancfgdetail_language['amp_auth_wpa2psk'], 1], 
	                  'wpa/wpa2-psk' : [cfg_wlancfgdetail_language['amp_auth_wpawpa2psk'], (1 == capWPAWPA2PSK)], 
	                  'wpa' : [cfg_wlancfgdetail_language['amp_auth_wpa'], (1 == capWPAEAP)], 
	                  'wpa2' : [cfg_wlancfgdetail_language['amp_auth_wpa2'], 1], 
	                  'wpa/wpa2' : [cfg_wlancfgdetail_language['amp_auth_wpawpa2'], (1 == capWPAWPA2EAP)],
	                  'wapi-psk' : [cfg_wlancfgdetail_language['amp_auth_wapi_psk'], 1], 
	                  'wapi' : [cfg_wlancfgdetail_language['amp_auth_wapi'], 1]
	                };

	if ((mode == "11n") || (1 == TelMexFlag)||(mode == "11ac") || (1 == DTHungaryFlag))
	{
		authModes['shared'][1] = 0;
	}

	if ('ANTEL' == CfgMode.toUpperCase())
	{
		authModes['open'][1] = 0;
		authModes['shared'][1] = 0;
		authModes['wpa'][1] = 0;
		authModes['wpa2'][1] = 0;
		authModes['wpa/wpa2'][1] = 0;
		authModes['wapi-psk'][1] = 0;
		authModes['wapi'][1] = 0;
	}
	
	if((1 != WapiFlag) || (0 == wapiCap))
    {
    	authModes['wapi-psk'][1] = 0;
    	authModes['wapi'][1] = 0;
    }

	InitDropDownListWithSelected('wlAuthMode', authModes, auth);
}

function addWapiEncryMethodOption()
{
    var len = document.forms[0].wlEncryption.options.length;
    for (i = 0; i < len; i++)
    {
        document.forms[0].wlEncryption.remove(0);
    }
    document.forms[0].wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_sms4'], "SMS4");
            
}

function addEncryMethodOption(type1,type2)
{
    var len = document.forms[0].wlEncryption.options.length;
    var mode = WlanWifi.mode;
    
    for (i = 0; i < len; i++)
    {
        document.forms[0].wlEncryption.remove(0);
    }
    
    if ((type1 == 0) && (type2 == 0))
    {
        document.forms[0].wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_none'], "None");
        
        if ((mode == "11n") || (mode == "11ac") || (1 == DTHungaryFlag) || (0 == wepCap))
        {
            document.forms[0].wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_none'], "None");        
        }
        else
        {
            document.forms[0].wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_none'], "None");
            document.forms[0].wlEncryption[1] = new Option(cfg_wlancfgdetail_language['amp_encrypt_wep'], "WEPEncryption");
        }        
    }
    else if ((type1 == 0) && (type2 == 1))
    {        
        if ((mode != "11n") && (mode != "11ac"))
        {
            document.forms[0].wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_wep'], "WEPEncryption");             
        }           
    }
    else
    {
        if (mode == "11n")
        {
            document.forms[0].wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_aes'], "AESEncryption");        
        }
        else
        {
            if(1 == PccwFlag)
            {
                if((type1 == 1) && (type2 == 2))
                {
                    document.forms[0].wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_aes'], "AESEncryption");    
                }
                else if((type1 == 1) && (type2 == 1))
                {
                    document.forms[0].wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkip'], "TKIPEncryption");
                }
                else if((type1 == 0) && (type2 == 2))
                {
                    document.forms[0].wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkipaes'], "TKIPandAESEncryption");  
                }
                else
                {
                    document.forms[0].wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_aes'], "AESEncryption");
                    document.forms[0].wlEncryption[1] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkip'], "TKIPEncryption");
                    document.forms[0].wlEncryption[2] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkipaes'], "TKIPandAESEncryption");
                }
            }
            else
            {
                document.forms[0].wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_aes'], "AESEncryption");
                if('1' == capTkip)
                {
                    document.forms[0].wlEncryption[1] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkip'], "TKIPEncryption");
                    document.forms[0].wlEncryption[2] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkipaes'], "TKIPandAESEncryption");
                }
            }
        }           
    }
}

function ShowPinNote(mode)
{
    var PinNote = '';
    if (1 == DTHungaryFlag)
    {
        if ('PBC' != mode)
        {
            PinNote = cfg_wlancfgdetail_language['amp_wps_pin_alert'];
        }

        getElById('DivPinNote').innerHTML = PinNote;

        getElById('DivWpsNote').innerHTML = cfg_wlancfgdetail_language['amp_wps_auth_alert'];
 
    }

    ShowWpsTimer();
   
}
 

function ShowWpsTimer()
{
    var portIndex = getPortFromIndex(ssidIdx);

    setDisplay('DivPBCTimeNote', 0);
    setDisplay('DivPinTimeNote', 0);
    setDisplay('DivAPPinTimeNote', 0);


    if ((1 == DTHungaryFlag) && (portIndex == WpsIndex))
    {
        if ('PushButton' == wpsPinNum[ssidIdx].X_HW_ConfigMethod)
        {
            setDisplay('DivPBCTimeNote', 1);
        }
        else if ('STA' == wpsPinNum[ssidIdx].X_HW_PinGenerator)
        {
            setDisplay('DivPinTimeNote', 1);
        }
        else if ('AP' == wpsPinNum[ssidIdx].X_HW_PinGenerator)
        {
            setDisplay('DivAPPinTimeNote', 1);
        }
        
    }

}

function HideWpsConfig()
{
    setDisplay("wpsPinNumber",0);
    setDisplay("wpsPinNumVal",0);
    setDisplay("wpsAPPinNumVal",0);
    setDisplay('wpsPBCButton',0);
}

function displayWpsConfig()
{
    if (IsWpsConfigDisplay() == false)
    {
        HideWpsConfig();
        return;
    }

    setDisplay('wpsPinNumber',1);
    setCheck('wlWPSEnable',wpsPinNum[ssidIdx].Enable);
    
    if (wpsPinNum[ssidIdx].X_HW_ConfigMethod == 'Lable')
    {
        if (wpsPinNum[ssidIdx].X_HW_PinGenerator == 'AP')
        {
            wlanSetSelect('wlWPSMode','AP-PIN');
            setDisplay('wpsPBCButton',0);
            setDisplay('wpsAPPinNumVal',1);
            setDisplay('wpsPinNumVal',0);
            setText('wlSelfPinNum',changeToPinNumber(wpsPinNum[ssidIdx].DevicePassword,8));

            ShowPinNote('AP-PIN');
        }
        else
        {
            wlanSetSelect('wlWPSMode','PIN');
            setDisplay('wpsPBCButton',0);
            setDisplay('wpsPinNumVal',1);
            setDisplay('wpsAPPinNumVal',0);
            setText('wlClientPinNum',changeToPinNumber(wpsPinNum[ssidIdx].DevicePassword,8));

            ShowPinNote('PIN');
        }
    }
    else
    {
        wlanSetSelect('wlWPSMode','PBC');
        
        if (getSelectVal('wlWPSMode') == 'PBC')
        {
            wlanSetSelect('wlWPSMode','PBC');
            setDisplay('wpsPBCButton',1);
            setDisplay('wpsPinNumVal',0);
            setDisplay('wpsAPPinNumVal',0);

            var wpsEnable = wpsPinNum[ssidIdx].Enable;
            if (1 == wpsEnable)
            {
                setDisable('btnWpsPBC', 0);
            }
            else if (0 == wpsEnable)
            {
                setDisable('btnWpsPBC', 1);
            }

            ShowPinNote('PBC');
        }
        else
        {
            wlanSetSelect('wlWPSMode','AP-PIN');
            setDisplay('wpsPBCButton',0);
            setDisplay('wpsAPPinNumVal',1);
            setDisplay('wpsPinNumVal',0);

            var wpsDefaultPIN = computeDefaultPin()+'';
            setText('wlSelfPinNum',changeToPinNumber(wpsDefaultPIN,8));

	    ShowPinNote('AP-PIN');
        }  
    }
}

function WPSAndHideCheck()
{
    if((true == IsWpsConfigDisplay()) && 1 == getCheckVal('wlWPSEnable'))
    {
       setCheck('wlHide',1);
    }
}

function WPSEnable()
{
    var wpsEnable = getCheckVal('wlWPSEnable');
    if (1 == wpsEnable)
    {
        setDisable('btnWpsPBC', 0);
    }
    else if (0 == wpsEnable)
    {
        setDisable('btnWpsPBC', 1);
    }
}

function keyIndexChange(iSelect)
{
    var keyIndex;

    if (1 != TelMexFlag)
    {
        return;
    }
    
    if (0 != iSelect)
    {
        keyIndex = iSelect;
    }
    else
    {
        keyIndex = getSelectVal('wlKeyIndex');
    }    
    
    setDisable("wlKeys1", 1);
    setDisable("twlKeys1", 1); 
    setDisable("wlKeys2", 1);
    setDisable("twlKeys2", 1);
    setDisable("wlKeys3", 1);
    setDisable("twlKeys3", 1);
    setDisable("wlKeys4", 1);
    setDisable("twlKeys4", 1);
    setDisable("wlKeys"+keyIndex, 0);
    setDisable("twlKeys"+keyIndex, 0);
}

function authModeChange()
{
    setDisplay("wlEncryMethod",0);
    setDisplay("keyInfo", 0);
    setDisplay("wlRadius", 0);
    setDisplay("wpaGTKRekey", 0);
    setDisplay("wpaPreShareKey", 0);
    setDisable("wlEncryption",0);
    setDisplay('wlWapi',0);
    HideWpsConfig();

    var authMode = getSelectVal('wlAuthMode');      
    
    switch (authMode)
    {
        case 'open':
            setDisable('wlHide', 0);
            setDisplay('wlEncryMethod',1);             
            addEncryMethodOption(0,0);            
            if (AddFlag == false)
            {
                wlanSetSelect('wlEncryption',Wlan[ssidIdx].BasicEncryptionModes);
                if ((Wlan[ssidIdx].BasicEncryptionModes == 'None') || (WlanWifi.mode == '11n'))
                {
                    setDisplay('keyInfo', 0);
                }
                else
                {                      
                    var level = getEncryLevel(Wlan[ssidIdx].EncypBit);
                    setDisplay('keyInfo', 1); 
                    wlanSetSelect('wlKeyBit', parseInt(level)+24);
                    
                    if (1 == TelMexFlag)
                    {
                        keyIndexChange(Wlan[ssidIdx].KeyIndex);
                    }
                    
                    wlanSetSelect('wlKeyIndex',Wlan[ssidIdx].KeyIndex);
                    setText('wlKeys1',g_keys[ssidIdx * 4].value); 
                    wep1password = g_keys[ssidIdx * 4].value; 
                    setText('twlKeys1',g_keys[ssidIdx * 4].value);
                    setText('wlKeys2',g_keys[ssidIdx * 4+1].value);
                    wep2password = g_keys[ssidIdx * 4+1].value; 
                    setText('twlKeys2',g_keys[ssidIdx * 4+1].value);
                    setText('wlKeys3',g_keys[ssidIdx * 4+2].value);
                    wep3password = g_keys[ssidIdx * 4+2].value; 
                    setText('twlKeys3',g_keys[ssidIdx * 4+2].value);
                    setText('wlKeys4',g_keys[ssidIdx * 4+3].value);
                    wep4password = g_keys[ssidIdx * 4+3].value; 
                    setText('twlKeys4',g_keys[ssidIdx * 4+3].value);
                }
            }
            else
            {
                setDisplay('keyInfo', 0);
                wlanSetSelect('wlEncryption','None');
                setText('wlKeys1','');
                wep1password = ''; 
                setText('twlKeys1','');
                setText('wlKeys2','');
                wep2password = ''; 
                setText('twlKeys2','');
                setText('wlKeys3','');
                wep3password = ''; 
                setText('twlKeys3','');
                setText('wlKeys4','');
                wep4password = ''; 
                setText('twlKeys4','');
            }
            break;
            
        case 'shared':
            setDisable('wlHide', 0);
            var level = getEncryLevel(Wlan[ssidIdx].EncypBit);
            var mode = WlanWifi.mode;              
            
            if ((mode == "11n") || (mode == "11ac"))
            {                  
                  setDisplay('wlEncryMethod',0);  
                  setDisplay('keyInfo', 0);                
            }
            else
            {                  
                setDisplay('wlEncryMethod',1); 
                setDisplay('keyInfo', 1);
                addEncryMethodOption(0,1);
                if (AddFlag == false)
                {
                    wlanSetSelect('wlKeyBit', parseInt(level)+24);
                
                    if (1 == TelMexFlag)
                    {
                      keyIndexChange(Wlan[ssidIdx].KeyIndex);
                    }
                
                    wlanSetSelect('wlKeyIndex',Wlan[ssidIdx].KeyIndex);
                    setText('wlKeys1',g_keys[ssidIdx * 4].value);
                    wep1password = g_keys[ssidIdx * 4].value; 
                    setText('twlKeys1',g_keys[ssidIdx * 4].value);
                    setText('wlKeys2',g_keys[ssidIdx * 4+1].value);
                    wep2password = g_keys[ssidIdx * 4+1].value; 
                    setText('twlKeys2',g_keys[ssidIdx * 4+1].value);
                    setText('wlKeys3',g_keys[ssidIdx * 4+2].value);
                    wep3password = g_keys[ssidIdx * 4+2].value; 
                    setText('twlKeys3',g_keys[ssidIdx * 4+2].value);
                    setText('wlKeys4',g_keys[ssidIdx * 4+3].value);
                    wep4password = g_keys[ssidIdx * 4+3].value; 
                    setText('twlKeys4',g_keys[ssidIdx * 4+3].value);
                }
                else
                {
                    wlanSetSelect('wlKeyBit', 128);
                    setText('wlKeys1','');
                    wep1password = ''; setText('twlKeys1','');
                    setText('wlKeys2','');
                    wep2password = ''; setText('twlKeys2','');
                    setText('wlKeys3','');
                    wep3password = ''; setText('twlKeys3','');
                    setText('wlKeys4','');
                    wep4password = ''; setText('twlKeys4','');
                }
            }                  
            break;

        case 'wpa':
        case 'wpa2':
        case 'wpa/wpa2':
            setDisable('wlHide', 0);
            setDisplay('wlEncryMethod',1);
            addEncryMethodOption(1,0);
            setDisplay('wlRadius', 1);
            setDisplay('wpaGTKRekey', 1);
            if (AddFlag == false)
            {
                if (authMode == 'wpa')
                {
                    wlanSetSelect('wlEncryption',Wlan[ssidIdx].WPAEncryptionModes);
                }
                else if (authMode == 'wpa2')
                {
                    wlanSetSelect('wlEncryption',Wlan[ssidIdx].IEEE11iEncryptionModes);
                    
                }
                else
                {
                    wlanSetSelect('wlEncryption',Wlan[ssidIdx].X_HW_WPAand11iEncryptionModes);
                }
                setText('wlRadiusIPAddr',Wlan[ssidIdx].RadiusServer);
                setText('wlRadiusPort',Wlan[ssidIdx].RadiusPort);
                setText('wlRadiusKey',Wlan[ssidIdx].RadiusKey);
                radiuspassword = Wlan[ssidIdx].RadiusKey; 
                setText('twlRadiusKey',Wlan[ssidIdx].RadiusKey);
                setText('wlWpaGtkRekey',Wlan[ssidIdx].WPARekey); 
            }
            else
            {
                setText('wlRadiusIPAddr','');
                setText('wlRadiusPort','');
                setText('wlRadiusKey','');
                radiuspassword = ''; 
                setText('twlRadiusKey','');
                setText('wlWpaGtkRekey',''); 
            }
            break;

        case 'wpa-psk':
        case 'wpa2-psk':
        case 'wpa/wpa2-psk':
            setDisplay('wlEncryMethod',1);
            if(1 == PccwFlag)
            {
                if (authMode == 'wpa-psk')
                {
                    addEncryMethodOption(1,1);
                }
                else if (authMode == 'wpa2-psk')
                {
                    addEncryMethodOption(1,2);
                }
                else
                {
                    addEncryMethodOption(0,2);          
                }
            }
            else
            {
                addEncryMethodOption(1,0);
            }
            
            setDisplay('wpaPreShareKey', 1);
            setDisplay('wpaGTKRekey', 1);
            document.getElementById('wpa_psk').innerHTML = GetLanguageDesc("amp_wpa_psk");
            if (AddFlag == false)
            {
                if (authMode == 'wpa-psk')
                {
                    wlanSetSelect('wlEncryption',Wlan[ssidIdx].WPAEncryptionModes);
                }
                else if (authMode == 'wpa2-psk')
                {
                    wlanSetSelect('wlEncryption',Wlan[ssidIdx].IEEE11iEncryptionModes);
                    
                }
                else
                {
                    wlanSetSelect('wlEncryption',Wlan[ssidIdx].X_HW_WPAand11iEncryptionModes);
                }
                setText('wlWpaPsk',wpaPskKey[ssidIdx].value);
                wpapskpassword = wpaPskKey[ssidIdx].value;
                setText('twlWpaPsk',wpaPskKey[ssidIdx].value);
                setText('wlWpaGtkRekey',Wlan[ssidIdx].WPARekey); 
                
                displayWpsConfig();
            }
            else
            {
                setText('wlWpaPsk','');
                setText('wlWpaGtkRekey','');
                wpapskpassword = '';
                setText('twlWpaPsk','');
                
                setCheck('wlWPSEnable',0);
                setDisable('btnWpsPBC', 1);
                if (Wlan.length >= 1)
                {
                    wlanSetSelect('wlWPSMode','AP-PIN');
                    setDisplay('wpsPBCButton',0);
                    setDisplay('wpsAPPinNumVal',1);
                    setDisplay('wpsPinNumVal',0);
                    
                    var wpsDefaultPIN = computeDefaultPin()+'';
                    setText('wlSelfPinNum',changeToPinNumber(wpsDefaultPIN,8));
                }
                else
                {
                    wlanSetSelect('wlWPSMode','PBC');
                    setDisplay('wpsPBCButton',1);
                    setDisplay('wpsPinNumVal',0);
                    setDisplay('wpsAPPinNumVal',0);
                }
            }
            WPSAndHideCheck();
            break;
        case 'wapi-psk':
            setDisable('wlHide', 0);
            setDisplay('wlEncryMethod',1);             
            addWapiEncryMethodOption();  
            document.getElementById('wpa_psk').innerHTML = GetLanguageDesc("amp_wapi_psk");
            setDisable('wlEncryption',1);
            setDisplay("wpaPreShareKey", 1);
            setText('wlWpaPsk',wpaPskKey[ssidIdx].value);
            setText('twlWpaPsk',wpaPskKey[ssidIdx].value);
            wpapskpassword = wpaPskKey[ssidIdx].value;
            if(AddFlag == false)
            {

                wlanSetSelect('wlEncryption',Wlan[ssidIdx].X_HW_WAPIEncryptionModes);
            }
            break;
        case 'wapi':
            setDisable('wlHide', 0);
            setDisplay('wlEncryMethod',1);             
            addWapiEncryMethodOption();  
            setDisable('wlEncryption',1);
            setDisplay('wlWapi',1); 
            setText('wapiIPAddr',Wlan[ssidIdx].X_HW_WAPIServer);
            setText('wapiPort',Wlan[ssidIdx].X_HW_WAPIPort);
            if(AddFlag == false)
            {
                wlanSetSelect('wlEncryption',Wlan[ssidIdx].X_HW_WAPIEncryptionModes);
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

function wlWPSEnableChange()
{
    if((0 == getCheckVal('wlHide')) && (1 == getCheckVal('wlWPSEnable')))
    {        
		 AlertEx(cfg_wlancfgother_language['amp_wps_on_help']);
		 setCheck('wlWPSEnable',0);
    }
}

function wlPinModeChange()
{
    var wpsEnable = wpsPinNum[ssidIdx].Enable;
    if (1 == wpsEnable)
    {
        setDisable('btnWpsPBC', 0);
    }
    else if (0 == wpsEnable)
    {
        setDisable('btnWpsPBC', 1);
    }

    if (getSelectVal('wlWPSMode') == 'PBC')
    {
        setDisplay('wpsPBCButton',1);
        setDisplay('wpsPinNumVal',0);
        setDisplay('wpsAPPinNumVal',0);
    }
    else if (getSelectVal('wlWPSMode') == 'PIN')
    {
        setDisplay('wpsPBCButton',0);
        setDisplay('wpsPinNumVal',1);
        setDisplay('wpsAPPinNumVal',0);
        
        if ((wpsPinNum[ssidIdx].X_HW_ConfigMethod == 'Lable') && (wpsPinNum[ssidIdx].X_HW_PinGenerator == 'STA'))
        {
            setText('wlClientPinNum',changeToPinNumber(wpsPinNum[ssidIdx].DevicePassword,8));
        }
        else
        {
            var wpsDefaultPIN = computeDefaultPin()+'';
            setText('wlClientPinNum',changeToPinNumber(wpsDefaultPIN,8));
        }
    }
    else
    {
        setDisplay('wpsPBCButton',0);
        setDisplay('wpsAPPinNumVal',1);
        setDisplay('wpsPinNumVal',0);
        
        if ((wpsPinNum[ssidIdx].X_HW_ConfigMethod == 'Lable') && (wpsPinNum[ssidIdx].X_HW_PinGenerator == 'AP'))
        {
            setText('wlSelfPinNum',changeToPinNumber(wpsPinNum[ssidIdx].DevicePassword,8));
        }
        else
        {
            var wpsDefaultPIN = computeDefaultPin()+'';
            setText('wlSelfPinNum',changeToPinNumber(wpsDefaultPIN,8));
        }
    }   
    ShowPinNote(getSelectVal('wlWPSMode'));
}

function OnRegeneratePIN()
{
    var number = computePinInteger();
    setText('wlSelfPinNum', changeToPinNumber(number,8));
}

function OnResetPIN()
{
    var wpsDefaultPIN = computeDefaultPin()+'';
    setText('wlSelfPinNum',changeToPinNumber(wpsDefaultPIN,8));
}

function displaywepkey()
{   
    if (AddFlag == false)
    {
        setText('wlKeys1',g_keys[ssidIdx * 4].value);
        wep1password = g_keys[ssidIdx * 4].value; 
        setText('twlKeys1',g_keys[ssidIdx * 4].value);
        setText('wlKeys2',g_keys[ssidIdx * 4 + 1].value);
        wep2password = g_keys[ssidIdx * 4+1].value; 
        setText('twlKeys2',g_keys[ssidIdx * 4+1].value);
        setText('wlKeys3',g_keys[ssidIdx * 4 + 2].value);
        wep3password = g_keys[ssidIdx * 4+2].value; 
        setText('twlKeys3',g_keys[ssidIdx * 4+2].value);
        setText('wlKeys4',g_keys[ssidIdx * 4 + 3].value);
        wep4password = g_keys[ssidIdx * 4+3].value; 
        setText('twlKeys4',g_keys[ssidIdx * 4+3].value);
    }
    else
    {
        setText('wlKeys1','');
        wep1password = ''; 
        setText('twlKeys1', '');
        setText('wlKeys2','');
        wep2password = ''; 
        setText('twlKeys2', '');
        setText('wlKeys3','');
        wep3password = ''; 
        setText('twlKeys3', '');
        setText('wlKeys4','');
        wep4password = ''; 
        setText('twlKeys4', '');
    }
}

function beaconTypeChange(mode)
{
    setDisplay('wlEncryMethod',0);
    setDisplay('keyInfo', 0);
    setDisplay('wlRadius', 0);
    setDisplay('wpaGTKRekey', 0);
    setDisplay('wpaPreShareKey', 0);
    setDisplay('wpsPinNumber',0);
    setDisplay('wpsPinNumVal',0);
    setDisplay('wpsAPPinNumVal',0);
    setDisplay('wpsPBCButton',0);
    setDisplay('wlWapi',0);

    if (mode == 'Basic')
    {
        var BasicAuthenticationMode = Wlan[ssidIdx].BasicAuthenticationMode;
        var BasicEncryptionModes = Wlan[ssidIdx].BasicEncryptionModes;
        setDisplay('wlEncryMethod',1);
        if ((BasicAuthenticationMode == 'None') || (BasicAuthenticationMode == 'OpenSystem'))
        {
            addEncryMethodOption(0,0);
            wlanSetSelect('wlAuthMode','open');
            wlanSetSelect('wlEncryption',BasicEncryptionModes);
            if (BasicEncryptionModes == 'None')
            {
                setDisplay('keyInfo', 0);
            } 
            else
            {
                var level = getEncryLevel(Wlan[ssidIdx].EncypBit);
                setDisplay('keyInfo', 1);
                wlanSetSelect('wlKeyBit', parseInt(level)+24);
                wlanSetSelect('wlKeyIndex',Wlan[ssidIdx].KeyIndex);
                displaywepkey();
            }
        }
        else
        {
            var level = getEncryLevel(Wlan[ssidIdx].EncypBit);
            addEncryMethodOption(0,1);
            setDisplay('keyInfo', 1);
            wlanSetSelect('wlAuthMode','shared');
            wlanSetSelect('wlEncryption',BasicEncryptionModes);
            wlanSetSelect('wlKeyBit', parseInt(level)+24);
            wlanSetSelect('wlKeyIndex',Wlan[ssidIdx].KeyIndex);
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
            setDisplay("wpaGTKRekey", 1);
            wlanSetSelect('wlAuthMode','wpa');
            wlanSetSelect('wlEncryption',Wlan[ssidIdx].WPAEncryptionModes);
            setText('wlRadiusIPAddr',Wlan[ssidIdx].RadiusServer);
            setText('wlRadiusPort',Wlan[ssidIdx].RadiusPort);
            setText('wlRadiusKey',Wlan[ssidIdx].RadiusKey);
            radiuspassword = Wlan[ssidIdx].RadiusKey; 
            setText('twlRadiusKey',Wlan[ssidIdx].RadiusKey);
            setText('wlWpaGtkRekey',Wlan[ssidIdx].WPARekey);
        }
        else
        {
            setDisplay("wlEncryMethod",1);
            addEncryMethodOption(1,1);
            setDisplay("wpaPreShareKey", 1);
            setDisplay("wpaGTKRekey", 1);
            wlanSetSelect('wlAuthMode','wpa-psk');
            wlanSetSelect('wlEncryption',Wlan[ssidIdx].WPAEncryptionModes);
            setText('wlWpaPsk',wpaPskKey[ssidIdx].value); 
            wpapskpassword = wpaPskKey[ssidIdx].value; 
            setText('twlWpaPsk',wpaPskKey[ssidIdx].value);
            setText('wlWpaGtkRekey',Wlan[ssidIdx].WPARekey);
            
            displayWpsConfig();
        }
    }
    else if ((mode == '11i') || (mode == 'WPA2') )
    {
        if (Wlan[ssidIdx].IEEE11iAuthenticationMode == 'EAPAuthentication')
        {
            setDisplay("wlEncryMethod",1);
            addEncryMethodOption(1,0);
            setDisplay("wlRadius", 1);
            setDisplay("wpaGTKRekey", 1);
            wlanSetSelect('wlAuthMode','wpa2');
            wlanSetSelect('wlEncryption',Wlan[ssidIdx].IEEE11iEncryptionModes);
            setText('wlRadiusIPAddr',Wlan[ssidIdx].RadiusServer);
            setText('wlRadiusPort',Wlan[ssidIdx].RadiusPort);
            setText('wlRadiusKey',Wlan[ssidIdx].RadiusKey);
            radiuspassword = Wlan[ssidIdx].RadiusKey; 
            setText('twlRadiusKey',Wlan[ssidIdx].RadiusKey);
            setText('wlWpaGtkRekey',Wlan[ssidIdx].WPARekey);
        }
        else
        {
            setDisplay("wlEncryMethod",1);
            addEncryMethodOption(1,2);
            setDisplay("wpaPreShareKey", 1);
            setDisplay("wpaGTKRekey", 1);
            wlanSetSelect('wlAuthMode','wpa2-psk');
            wlanSetSelect('wlEncryption',Wlan[ssidIdx].IEEE11iEncryptionModes);
            setText('wlWpaPsk',wpaPskKey[ssidIdx].value); 
            wpapskpassword = wpaPskKey[ssidIdx].value; 
            setText('twlWpaPsk',wpaPskKey[ssidIdx].value);
            setText('wlWpaGtkRekey',Wlan[ssidIdx].WPARekey); 
            
            displayWpsConfig();
        }
    }
    else if ((mode == 'WPAand11i')|| (mode == 'WPA/WPA2'))
    {
        if (Wlan[ssidIdx].X_HW_WPAand11iAuthenticationMode == 'EAPAuthentication')
        {
            setDisplay("wlEncryMethod",1);
            addEncryMethodOption(1,0);
            setDisplay("wlRadius", 1);
            setDisplay("wpaGTKRekey", 1);
            wlanSetSelect('wlAuthMode','wpa/wpa2');
            wlanSetSelect('wlEncryption',Wlan[ssidIdx].X_HW_WPAand11iEncryptionModes);
            setText('wlRadiusIPAddr',Wlan[ssidIdx].RadiusServer);
            setText('wlRadiusPort',Wlan[ssidIdx].RadiusPort);
            setText('wlRadiusKey',Wlan[ssidIdx].RadiusKey);
            radiuspassword = Wlan[ssidIdx].RadiusKey; 
            setText('twlRadiusKey',Wlan[ssidIdx].RadiusKey);
            setText('wlWpaGtkRekey',Wlan[ssidIdx].WPARekey);
        }
        else
        {
            setDisplay("wlEncryMethod",1);
            addEncryMethodOption(0,2);
            setDisplay("wpaPreShareKey", 1);
            setDisplay("wpaGTKRekey", 1);
            wlanSetSelect('wlAuthMode','wpa/wpa2-psk');
            wlanSetSelect('wlEncryption',Wlan[ssidIdx].X_HW_WPAand11iEncryptionModes);
            setText('wlWpaPsk',wpaPskKey[ssidIdx].value); 
            wpapskpassword = wpaPskKey[ssidIdx].value; 
            setText('twlWpaPsk',wpaPskKey[ssidIdx].value);
            setText('wlWpaGtkRekey',Wlan[ssidIdx].WPARekey); 
            
            displayWpsConfig();
        }
    }
    else if(mode == 'X_HW_WAPI')
    {
        if(Wlan[ssidIdx].X_HW_WAPIAuthenticationMode == 'WAPIPSK')
        {
            wlanSetSelect('wlAuthMode','wapi-psk');
            setDisplay('wlEncryMethod',1);             
                    addWapiEncryMethodOption();  
            
            setDisable('wlEncryption',1);
            setDisplay("wpaPreShareKey", 1);
            document.getElementById('wpa_psk').innerHTML = GetLanguageDesc("amp_wapi_psk");
            setText('wlWpaPsk',wpaPskKey[ssidIdx].value);
            setText('twlWpaPsk',wpaPskKey[ssidIdx].value);
            wpapskpassword = wpaPskKey[ssidIdx].value; 



            wlanSetSelect('wlEncryption',Wlan[ssidIdx].X_HW_WAPIEncryptionModes);
        }
        else
        {
            wlanSetSelect('wlAuthMode','wapi');
            setDisplay('wlEncryMethod',1);             
            addWapiEncryMethodOption();  
            setDisable('wlEncryption',1);
            setDisplay('wlWapi',1); 
            setText('wapiIPAddr',Wlan[ssidIdx].X_HW_WAPIServer);
            setText('wapiPort',Wlan[ssidIdx].X_HW_WAPIPort);
        }
    }
    else
    {   
        addEncryMethodOption(0,0);
        setDisplay('wlEncryMethod',1);
        wlanSetSelect('wlAuthMode','open');
        wlanSetSelect('wlEncryption','None');
    }
}

function wlKeyBitChange()
{
	var selVal = getSelectVal('wlKeyBit');
	
	if("128" == selVal)
	{
		getElById('span_wep_keynote').innerHTML = cfg_wlancfgdetail_language['amp_encrypt_keynote_128'];
	}
	else
	{
		getElById('span_wep_keynote').innerHTML = cfg_wlancfgdetail_language['amp_encrypt_keynote_64'];
	}
}

function IsAuthModePsk(AuthMode)
{
    if (AuthMode == 'wpa-psk' || AuthMode == 'wpa2-psk' || AuthMode == 'wpa/wpa2-psk')
    {
        return true;
    }
    else
    {
        return false;
    }
}

function IsWpsConfigDisplay( )
{
    var AuthMode = getSelectVal('wlAuthMode');
    var EncryMode = getSelectVal('wlEncryption');

    if (IsAuthModePsk(AuthMode))
    {
        if (((Wps2 == 1) && (EncryMode == 'TKIPEncryption')) || (WpsCapa == 0))
        {
        	return false;
        }

        if(0 == wps1Cap)
        {
            if((AuthMode == 'wpa2-psk') && (EncryMode == 'AESEncryption'))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
        return true;
    }

    return false;
}

function onMethodChange(isSelected)
{ 
    var authMode = getSelectVal('wlAuthMode');
    var encryMode = getSelectVal('wlEncryption');

    setDisplay('keyInfo', 0);

    if (authMode == 'open')
    {
        if (encryMode == 'None')
        {
            setDisplay('keyInfo', 0);
        }
        else
        {
            if (AddFlag == false)
            {
                var level = getEncryLevel(Wlan[ssidIdx].EncypBit);
                setDisplay('keyInfo', 1);
                wlanSetSelect('wlKeyBit', parseInt(level)+24);
                
                if (1 == TelMexFlag)
                {
                    keyIndexChange(Wlan[ssidIdx].KeyIndex);
                }
                
                wlanSetSelect('wlKeyIndex',Wlan[ssidIdx].KeyIndex);
                setText('wlKeys1',g_keys[ssidIdx * 4].value);
                wep1password = g_keys[ssidIdx * 4].value; 
                setText('twlKeys1',g_keys[ssidIdx * 4].value); 
                setText('wlKeys2',g_keys[ssidIdx * 4+1].value);
                wep2password = g_keys[ssidIdx * 4+1].value; 
                setText('twlKeys2',g_keys[ssidIdx * 4+1].value); 
                setText('wlKeys3',g_keys[ssidIdx * 4+2].value);
                wep3password = g_keys[ssidIdx * 4+2].value; 
                setText('twlKeys3',g_keys[ssidIdx * 4+2].value); 
                setText('wlKeys4',g_keys[ssidIdx * 4+3].value);
                wep4password = g_keys[ssidIdx * 4+3].value; 
                setText('twlKeys4',g_keys[ssidIdx * 4+3].value); 
            }
            else
            {
                setDisplay('keyInfo', 1);
                wlanSetSelect('wlKeyBit', 128);
                
                if (1 == TelMexFlag)
                {
                    keyIndexChange(Wlan[ssidIdx].KeyIndex);
                }
                
                wlanSetSelect('wlKeyIndex',Wlan[ssidIdx].KeyIndex);
                setText('wlKeys1','');
                wep1password = ''; 
                setText('twlKeys1','');
                setText('wlKeys2','');
                wep2password = ''; 
                setText('twlKeys2','');
                setText('wlKeys3','');
                wep3password = ''; 
                setText('twlKeys3','');
                setText('wlKeys4','');
                wep4password = ''; 
                setText('twlKeys4','');
            }
        }
    }

    displayWpsConfig();
    WPSAndHideCheck();
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
 return str.toString().replace(/(^\s*)/g,""); 
}

function addParameter1(Form)
{   
    Form.addParameter('y.Enable',getCheckVal('wlEnable'));
    Form.addParameter('y.SSIDAdvertisementEnabled',getCheckVal('wlHide'));
    if(0 == getCheckVal('wlHide') && (false == IsWpsConfigDisplay()))
    {
        Form.addParameter('z.Enable', 0);
    }

    if ((0 == AddFlag) && (-1 != ssidIdx) && (Wlan[ssidIdx].wmmEnable != getCheckVal('enableWmm')))
    {
        Form.addParameter('y.WMMEnable',getCheckVal('enableWmm'));
    }

    if ((1 == AddFlag) || (-1 == ssidIdx))
    {
        Form.addParameter('y.WMMEnable',getCheckVal('enableWmm'));
    }
    
    var ssid;
    
    if (1 == preflag)
    {
        ssid = getValue('wlSsid1');
        var ssid2 = getValue('wlSsid2');

        var ssidParts = ssid.split('_');
        if (ssidParts.length != 1)
        {
            if(ssidParts[1] != "" )
            {
                ssid = ssid;
            }
            else
            {
                ssid = ssid + ssid2;
            }
        }
    }
    else
    {
        ssid = getValue('wlSsid');
    }
     
    ssid = ltrim(ssid);
    
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
	
	if(true == AmpTDESepicalCharaterFlag)
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
	    if (isValidAscii(ssid) != '')
        {
            AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_invalid'] + isValidAscii(ssid));
            return false;
        }
	}
    

    for (i = 0; i < Wlan.length; i++)
    {
        if ((getWlanPortNumber(Wlan[i].name) > 3) && ((1 == DoubleFreqFlag) && ("2G" == wlanpage)) )
        {
            continue;
        }
        
        if ((getWlanPortNumber(Wlan[i].name) <= 3) && ((1 == DoubleFreqFlag) && ("5G" == wlanpage)) )
        {
            continue;
        }

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

	if (1 == preflag)
	{
		if((ssidIdx == 0) && (0 != ssid.indexOf("PLDTHOMEFIBR_")))
		{
			alert(cfg_wlancfgother_language['amp_ssid_must_be_pldthomefibr']);
			return false;
		}
	}

    Form.addParameter('y.SSID',ssid);

    var deviceNum = parseInt(getValue('X_HW_AssociateNum'),10);

    if('128' == '<%HW_WEB_GetSPEC(AMP_SPEC_MAX_STA_NUM.UINT32);%>')
    {
        if (isPlusInteger(deviceNum) == false
        || parseInt(deviceNum) < 1
        || parseInt(deviceNum) > 128)
        {
            AlertEx(cfg_wlancfgother_language['amp_dev_num_128']);
            return false;
        }
    }
    else if('64' == '<%HW_WEB_GetSPEC(AMP_SPEC_MAX_STA_NUM.UINT32);%>')
    {
        if (isPlusInteger(deviceNum) == false
        || parseInt(deviceNum) < 1
        || parseInt(deviceNum) > 64)
        {
            AlertEx(cfg_wlancfgother_language['amp_dev_num_64']);
            return false;
        }
    }
    else
    {
        if (isPlusInteger(deviceNum) == false
        || parseInt(deviceNum) < 1
        || parseInt(deviceNum) > 32)
        {
            AlertEx(cfg_wlancfgother_language['amp_dev_num']);
            return false;
        }
    }
    
    Form.addParameter('y.X_HW_AssociateNum',deviceNum);

}

function changeToInteger(number,length)
{
    var i;
    for (i = 0; i < number.length; i++)
    {
        if (number.charAt(i) != '0')
        {
            break;
        }
    }
    return number.substr(i,length-i);
}

function changeToPinNumber(number,length)
{
    var pinNumber = '';
    for (var i = 0; i < length-number.length; i++)
    {
        pinNumber += '0';
    }
    pinNumber += number;
    return pinNumber;
}

function addParameter2(Form)
{ 
    var url = '';
    var temp = '';

    var AuthMode = getSelectVal('wlAuthMode');

    if (AuthMode == 'shared' || AuthMode == 'open')
    {
        var method = getSelectVal('wlEncryption');
        
        if ((AuthMode == 'open' && method != 'None')
            || (AuthMode == 'shared'))
        {
            var KeyBit = getSelectVal('wlKeyBit');
            var index = getSelectVal('wlKeyIndex');
            var wlKeys1 = getValue('wlKeys1');
            var wlKeys2 = getValue('wlKeys2');
            var wlKeys3 = getValue('wlKeys3');
            var wlKeys4 = getValue('wlKeys4');
            var val;
            var i;
            var vKey = 0;
            var KeyDesc;
            var telmaxWepModFlag = false;

            var keyIndex = getSelectVal('wlKeyIndex');
            for (vKey = 0; vKey < 4; vKey++)
            {
               if (1 == TelMexFlag)
               {
                   if (vKey+1 != keyIndex)
                   {
                       continue;
                   }
               }
               
               if (vKey == 0)
               {
                   val = wlKeys1;
                   telmaxWepModFlag = wep1PsdModFlag;
                   KeyDesc = cfg_wlancfgdetail_language['amp_encrypt_key1'];
               }
               else if (vKey == 1)
               {
                   val = wlKeys2;
                   telmaxWepModFlag = wep2PsdModFlag;
                   KeyDesc = cfg_wlancfgdetail_language['amp_encrypt_key2'];
               }
               else if (vKey == 2)
               {
                   val = wlKeys3;
                   telmaxWepModFlag = wep3PsdModFlag;
                   KeyDesc = cfg_wlancfgdetail_language['amp_encrypt_key3'];
               }
               else
               {
                   val = wlKeys4;
                   telmaxWepModFlag = wep4PsdModFlag;
                   KeyDesc = cfg_wlancfgdetail_language['amp_encrypt_key4'];
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
            
            if (1 == TelMexFlag)
            {
                if (wifiPasswordMask == '1')
                {
                    if (KeyBit == '128')
                    {
                        if ( (value != "*************") || (telmaxWepModFlag == true) )
                        {
                            Form.addParameter('k1.WEPKey', val);
                        }
                    }
                    else
                    {
                        if ( (value != "*****") || (telmaxWepModFlag == true) )
                        {
                            Form.addParameter('k1.WEPKey', val);
                        }
                    }
                }
                else
                {
                    Form.addParameter('k1.WEPKey', val);
                }
            }
            else
            {
                if (wifiPasswordMask == '1')
                {
                    if (KeyBit == '128')
                    {
                        if ( (wlKeys1 != "*************") || (wep1PsdModFlag == true) )
                        {
							
                            Form.addParameter('k1.WEPKey', wlKeys1);
                        }

                        if ( (wlKeys2 != "*************") || (wep2PsdModFlag == true) )
                        {
                            Form.addParameter('k2.WEPKey', wlKeys2);
                        }

                        if ( (wlKeys3 != "*************") || (wep3PsdModFlag == true) )
                        {
                            Form.addParameter('k3.WEPKey', wlKeys3);
                        }

                        if ( (wlKeys4 != "*************") || (wep4PsdModFlag == true) )
                        {
                            Form.addParameter('k4.WEPKey', wlKeys4);
                        }
                    }
                    else
                    {
                        if ( (wlKeys1 != "*****") || (wep1PsdModFlag == true) )
                        {
                            Form.addParameter('k1.WEPKey', wlKeys1);
                        }

                        if ( (wlKeys2 != "*****") || (wep2PsdModFlag == true) )
                        {
                            Form.addParameter('k2.WEPKey', wlKeys2);
                        }

                        if ( (wlKeys3 != "*****") || (wep3PsdModFlag == true) )
                        {
                            Form.addParameter('k3.WEPKey', wlKeys3);
                        }

                        if ( (wlKeys4 != "*****") || (wep4PsdModFlag == true) )
                        {
                            Form.addParameter('k4.WEPKey', wlKeys4);
                        }
                    } 
                }
                else
                {
                    Form.addParameter('k1.WEPKey', wlKeys1);
                    Form.addParameter('k2.WEPKey', wlKeys2);
                    Form.addParameter('k3.WEPKey', wlKeys3);
                    Form.addParameter('k4.WEPKey', wlKeys4);
                }
            }
        }
        
        Form.addParameter('y.BeaconType','Basic');
        if (AuthMode == 'open')
        {
            Form.addParameter('y.BasicAuthenticationMode','None');
        }
        else
        {
            Form.addParameter('y.BasicAuthenticationMode','SharedAuthentication');
        }
        Form.addParameter('y.BasicEncryptionModes',getSelectVal('wlEncryption'));
    }
    else if (AuthMode == 'wpa' || AuthMode == 'wpa2' || AuthMode == 'wpa/wpa2')
    {
        var wlRadiusKey = getValue('wlRadiusKey');
        var wlRadiusIPAddr = getValue('wlRadiusIPAddr');
        var wlRadiusPort = getValue('wlRadiusPort');
        var wlWpaGtkRekey = getValue('wlWpaGtkRekey');
        
        if (wlRadiusIPAddr == '' || wlRadiusPort == '' || wlWpaGtkRekey == '')
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

        if (isInteger(wlWpaGtkRekey) == false)
        {
            AlertEx(cfg_wlancfgdetail_language['amp_wpakey_invalid']);
            return false;
        }

        if ((parseInt(wlWpaGtkRekey,10) > 86400) || (parseInt(wlWpaGtkRekey,10) < 600))
        {
            AlertEx(cfg_wlancfgdetail_language['amp_wpakey_range']);
            return false;
        }
        
        if (AuthMode == 'wpa')
        {
            Form.addParameter('y.BeaconType','WPA');
            Form.addParameter('y.WPAAuthenticationMode','EAPAuthentication');
            Form.addParameter('y.WPAEncryptionModes',getSelectVal('wlEncryption'));
        }
        else if (AuthMode == 'wpa2')
        {
            Form.addParameter('y.BeaconType','11i');
            Form.addParameter('y.IEEE11iAuthenticationMode','EAPAuthentication');
            Form.addParameter('y.IEEE11iEncryptionModes',getSelectVal('wlEncryption'));
        }
        else
        {
            Form.addParameter('y.BeaconType','WPAand11i');
            Form.addParameter('y.X_HW_WPAand11iAuthenticationMode','EAPAuthentication');
            Form.addParameter('y.X_HW_WPAand11iEncryptionModes',getSelectVal('wlEncryption'));
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
        wlWpaGtkRekey = parseInt(getValue('wlWpaGtkRekey'),10);
        Form.addParameter('y.X_HW_RadiusPort',wlRadiusPort);
        Form.addParameter('y.X_HW_GroupRekey',wlWpaGtkRekey);
    }
    else if (AuthMode == 'wpa-psk' || AuthMode == 'wpa2-psk' || AuthMode == 'wpa/wpa2-psk'|| AuthMode == 'wapi'|| AuthMode == 'wapi-psk')
    {
        var value = getValue('wlWpaPsk');
        var wlWpaGtkRekey = getValue('wlWpaGtkRekey');
        var wapiIP = getValue('wapiIPAddr');
        var wapiPort = getValue('wapiPort');
        

    if(AuthMode == 'wpa-psk' || AuthMode == 'wpa2-psk' || AuthMode == 'wpa/wpa2-psk')
    {

        if (value == '' || wlWpaGtkRekey == '')
        {
            AlertEx(cfg_wlancfgother_language['amp_empty_para']);
            return false;
        }
		
        if ( true == AmpTDESepicalCharaterFlag)
		{
		    if (true != isValidWPAPskSepcialKey(value))
            {
                return false;
            }
		}
		else
		{
		     if (isValidWPAPskKey(value) == false)
            {
                AlertEx(cfg_wlancfgdetail_language['amp_wpskey_invalid']);
                return false;
            }
		}

        
        if (isInteger(wlWpaGtkRekey) == false)
        {
            AlertEx(cfg_wlancfgdetail_language['amp_wpakey_invalid']);
            return false;
        }

        if ((parseInt(wlWpaGtkRekey,10) > 86400) || (parseInt(wlWpaGtkRekey,10) < 600))
        {
            AlertEx(cfg_wlancfgdetail_language['amp_wpakey_range']);
            return false;
        }
    }
        
        if (AuthMode == 'wpa-psk')
        {
            Form.addParameter('y.BeaconType','WPA');
            Form.addParameter('y.WPAAuthenticationMode','PSKAuthentication');
            Form.addParameter('y.WPAEncryptionModes',getSelectVal('wlEncryption'));
        }
        else if (AuthMode == 'wpa2-psk')
        {
            Form.addParameter('y.BeaconType','11i');
            Form.addParameter('y.IEEE11iAuthenticationMode','PSKAuthentication');
            Form.addParameter('y.IEEE11iEncryptionModes',getSelectVal('wlEncryption'));
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
             if (value == '' || wlWpaGtkRekey == '')
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
            Form.addParameter('y.X_HW_WPAand11iEncryptionModes',getSelectVal('wlEncryption'));
        } 
        

        if (wifiPasswordMask == '1')
        {
            if ( (value != "********") || (pskPsdModFlag == true) )
            {
                Form.addParameter('k.PreSharedKey',value);

                if('1' == kppUsedFlag)
                {
                    Form.addParameter('k.KeyPassphrase',value);
                }
            }			 
        }
        else
        {
            Form.addParameter('k.PreSharedKey',value);

            if('1' == kppUsedFlag)
            {
                Form.addParameter('k.KeyPassphrase',value);
            }
        }
        

        wlWpaGtkRekey = parseInt(getValue('wlWpaGtkRekey'),10);
        Form.addParameter('y.X_HW_GroupRekey',wlWpaGtkRekey);
        
        var wpsEnable = getCheckVal('wlWPSEnable');
        if((IsWpsConfigDisplay() == true))
        {
            Form.addParameter('z.Enable',wpsEnable);
        }
        
        if (getSelectVal('wlWPSMode')== 'PBC')
        {
            if((IsWpsConfigDisplay() == true))
            {
                Form.addParameter('z.X_HW_ConfigMethod','PushButton');
            }
        }
        else if (getSelectVal('wlWPSMode')== 'PIN')
        {
        	if (IsWpsConfigDisplay() != false)
        	{
	            var clientPinNum = getValue('wlClientPinNum');
	            if (clientPinNum == '')
	            {
	                AlertEx(cfg_wlancfgother_language['amp_clientpin_empty']);
	                return false;
	            }
	                
	             if (isInteger(clientPinNum) == false)
	             {
	                  AlertEx(cfg_wlancfgother_language['amp_clientpin_int']);
	                  return false;
	              }

	              if (clientPinNum.length != 8)
	              {
	                  AlertEx(cfg_wlancfgother_language['amp_clientpin_8int']);
	                  return false;
	               }

	              if (clientPinNum == 0)
	              {   
	                  AlertEx(cfg_wlancfgother_language['amp_clientpin_invalid']);
	                  return false;
	              }
	                
	              var pinNum = parseInt(changeToInteger(clientPinNum,8));
	              if (ValidateChecksum(parseInt(pinNum)) != 0)
	              {
	                  AlertEx(cfg_wlancfgother_language['amp_clientpin_invalid']);
	                  return false;
	              }
	              Form.addParameter('z.X_HW_ConfigMethod','Lable');
	              Form.addParameter('z.X_HW_PinGenerator','STA');
	              Form.addParameter('z.DevicePassword',parseInt(pinNum));
                }
        }
        else
        {
            var selPinNum = getValue('wlSelfPinNum');
            if (selPinNum == '')
            {
                AlertEx(cfg_wlancfgother_language['amp_localpin_empty']);
                return false;
            }
            if((IsWpsConfigDisplay() == true))
            {
                Form.addParameter('z.X_HW_ConfigMethod','Lable');
                Form.addParameter('z.X_HW_PinGenerator','AP');
                Form.addParameter('z.DevicePassword',parseInt(changeToInteger(selPinNum,8)));
            }
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

function AddParaForCover(Form)
{
    var wlandomain = Wlan[ssidIdx].domain;
    var length = wlandomain.length;
    var wlanInstId = parseInt(wlandomain.charAt(length-1));
    var beaconType = "Basic";

    Form.addParameter('w.SsidInst',wlanInstId);
    
    Form.addParameter('w.SSID',ltrim(getValue('wlSsid')));
    setCoverSsidNotifyFlag(Wlan[ssidIdx].ssid, ltrim(getValue('wlSsid')));
    
    Form.addParameter('w.Enable',getCheckVal('wlEnable'));

    Form.addParameter('w.Standard',WlanWifi.mode);

    Form.addParameter('w.BasicAuthenticationMode','None');
    Form.addParameter('w.BasicEncryptionModes',getSelectVal('wlEncryption'));
    Form.addParameter('w.WPAAuthenticationMode','EAPAuthentication');
    Form.addParameter('w.WPAEncryptionModes',getSelectVal('wlEncryption'));
    Form.addParameter('w.IEEE11iAuthenticationMode','EAPAuthentication');
    Form.addParameter('w.IEEE11iEncryptionModes',getSelectVal('wlEncryption'));
    Form.addParameter('w.MixAuthenticationMode','EAPAuthentication');
    Form.addParameter('w.MixEncryptionModes',getSelectVal('wlEncryption'));
    
    var AuthMode = getSelectVal('wlAuthMode');
    if (AuthMode == 'shared' || AuthMode == 'open')
    {    
        Form.addParameter('w.BeaconType','Basic');
        setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, 'Basic');
        
        if (AuthMode == 'open')
        {
            Form.addParameter('w.BasicAuthenticationMode','None');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BasicAuthenticationMode, 'None');
        }
        else
        {
            Form.addParameter('w.BasicAuthenticationMode','SharedAuthentication');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BasicAuthenticationMode, 'SharedAuthentication');
        }
        
        Form.addParameter('w.BasicEncryptionModes',getSelectVal('wlEncryption'));
        setCoverSsidNotifyFlag(Wlan[ssidIdx].BasicEncryptionModes, getSelectVal('wlEncryption'));
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
            
            Form.addParameter('w.WPAEncryptionModes',getSelectVal('wlEncryption'));
            setCoverSsidNotifyFlag(Wlan[ssidIdx].WPAEncryptionModes, getSelectVal('wlEncryption'));
        }
        else if (AuthMode == 'wpa2')
        {
            Form.addParameter('w.BeaconType','11i');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, '11i');
            
            beaconType = "11i";
            Form.addParameter('w.IEEE11iAuthenticationMode','EAPAuthentication');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].IEEE11iAuthenticationMode, 'EAPAuthentication');
            
            Form.addParameter('w.IEEE11iEncryptionModes',getSelectVal('wlEncryption'));
            setCoverSsidNotifyFlag(Wlan[ssidIdx].IEEE11iEncryptionModes, getSelectVal('wlEncryption'));
        }
        else
        {
            Form.addParameter('w.BeaconType','WPAand11i');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, 'WPAand11i');
            
            beaconType = "WPAand11i";
            Form.addParameter('w.MixAuthenticationMode','EAPAuthentication');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].X_HW_WPAand11iAuthenticationMode, 'EAPAuthentication');
            
            Form.addParameter('w.MixEncryptionModes',getSelectVal('wlEncryption'));
            setCoverSsidNotifyFlag(Wlan[ssidIdx].X_HW_WPAand11iEncryptionModes, getSelectVal('wlEncryption'));
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
            
            Form.addParameter('w.WPAEncryptionModes',getSelectVal('wlEncryption'));
            setCoverSsidNotifyFlag(Wlan[ssidIdx].WPAEncryptionModes, getSelectVal('wlEncryption'));
        }
        else if (AuthMode == 'wpa2-psk')
        {
            Form.addParameter('w.BeaconType','11i');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].BeaconType, '11i');
            
            beaconType = "11i";
            Form.addParameter('w.IEEE11iAuthenticationMode','PSKAuthentication');
            setCoverSsidNotifyFlag(Wlan[ssidIdx].IEEE11iAuthenticationMode, 'PSKAuthentication');
            
            Form.addParameter('w.IEEE11iEncryptionModes',getSelectVal('wlEncryption'));
            setCoverSsidNotifyFlag(Wlan[ssidIdx].IEEE11iEncryptionModes, getSelectVal('wlEncryption'));
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
            
            Form.addParameter('w.MixEncryptionModes',getSelectVal('wlEncryption'));
            setCoverSsidNotifyFlag(Wlan[ssidIdx].X_HW_WPAand11iEncryptionModes, getSelectVal('wlEncryption'));
        } 
    }

    var KeyBit = getSelectVal('wlKeyBit');
    Form.addParameter('w.WEPEncryptionLevel',(KeyBit-24)+'-bit');
    setCoverSsidNotifyFlag(Wlan[ssidIdx].EncypBit, (KeyBit-24)+'-bit');
    
    var keyIndex = getSelectVal('wlKeyIndex');
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
        key = getValue('wlWpaPsk');
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
            if ('WEPEncryption' == getSelectVal('wlEncryption'))
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
        if (('WEPEncryption' == getSelectVal('wlEncryption')) && (1 <= keyIndex) && (keyIndex <= 4))
        {
            setCoverSsidNotifyFlag(Wlan[ssidIdx].KeyIndex, keyIndex);
            setCoverSsidNotifyFlag(g_keys[ssidIdx * 4 + (keyIndex - 1)].value, key);
        }
    }
    
    return true;
}

function stExtendedWLC(domain, SSIDIndex)
{
    this.domain = domain;
    this.SSIDIndex = SSIDIndex;
}

var apExtendedWLC = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.X_HW_APDevice.{i}.WifiCover.ExtendedWLC.{i}, SSIDIndex, stExtendedWLC,EXTEND);%>;

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

function SubmitForm()
{
    var Form = new webSubmitForm();
    
    if (addParameter1(Form) == false)
    {
        setDisable('btnApplySubmit',0);
        setDisable('cancel',0);    
        return;
    }
    
    if (addParameter2(Form) == false)
    {
        setDisable('btnApplySubmit',0);
        setDisable('cancel',0);        
        return;
    }

    if (AddParaForCover(Form) == false)
    {
        setDisable('btnApplySubmit',0);
        setDisable('cancel',0);        
        return;
    }
    
    var wlandomain = Wlan[ssidIdx].domain;
    var AuthMode = getSelectVal('wlAuthMode');
    var Url = 'set.cgi?w=InternetGatewayDevice.X_HW_DEBUG.AMP.WifiCoverSetWlanBasic&y=' + wlandomain;

    if (isWifiCoverSsid(getWlanInstFromDomain(wlandomain)))
    {
        if (false == ConfirmEx(cfg_wificover_basic_language['amp_wificover_ssid_change_notify'])) 
        {
            guiCoverSsidNotifyFlag = 0;
            setDisable('btnApplySubmit',0);
            setDisable('cancel',0);        
            return;
        }
    }

    if (AuthMode == 'shared' || AuthMode == 'open')
    {
        if (getSelectVal('wlEncryption') == 'None')
        {            
            if(0 == getCheckVal('wlHide'))
            {
                Url += '&z=' + wlandomain + '.WPS';
            }
        }
        else
        {
            if (1 == TelMexFlag)
            {                
                Url += '&k1=' + wlandomain + '.WEPKey.' + getSelectVal('wlKeyIndex');
                if(0 == getCheckVal('wlHide'))
                {
                    Url += '&z=' + wlandomain + '.WPS';
                }
            }
            else
            {                
                Url += '&k1=' + wlandomain + '.WEPKey.1'
                    + '&k2=' + wlandomain + '.WEPKey.2'
                    + '&k3=' + wlandomain + '.WEPKey.3'
                    + '&k4=' + wlandomain + '.WEPKey.4';
                if(0 == getCheckVal('wlHide'))
                {
                    Url += '&z=' + wlandomain + '.WPS';
                }
            }
        } 
    }
    else if (AuthMode == 'wpa' || AuthMode == 'wpa2' || AuthMode == 'wpa/wpa2')
    {        
        if(0 == getCheckVal('wlHide'))
        {
            Url += '&z=' + wlandomain + '.WPS';
        }
    }
    else if (AuthMode == 'wpa-psk' || AuthMode == 'wpa2-psk' || AuthMode == 'wpa/wpa2-psk')
    {        
        Url += '&k=' + wlandomain + '.PreSharedKey.1';
        if((0 == getCheckVal('wlHide')) || (IsWpsConfigDisplay() == true))
        {
            Url += '&z=' + wlandomain + '.WPS';
        }
    }
    else if(AuthMode == 'wapi' || AuthMode == 'wapi-psk')
    {        
        Url += '&k=' + wlandomain + '.PreSharedKey.1';
        if(0 == getCheckVal('wlHide'))
        {
            Url += '&z=' + wlandomain + '.WPS';
        }
    }
    else
    {        
        Url += '&x=InternetGatewayDevice.LANDevice.1';
        if(0 == getCheckVal('wlHide'))
        {
            Url += '&z=' + wlandomain + '.WPS';
        }
    }
    Url += '&RequestFile=html/amp/wlanbasic/WlanBasic.asp';
    Form.setAction(Url);
    if(!isWlanInitFinished(wlanpage, WlanWifi.mode, WlanWifi.channelWidth))
    {
        return;
    }
    setDisable('btnWpsPBC', 1);
    setDisable('btnApplySubmit',1);
    setDisable('cancel',1);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    

    
    Form.submit();
}

function WpsPBCSubmit()
{
    var wpsEnable = getCheckVal('wlWPSEnable');
    if (wpsEnable == 0)
    {
        AlertEx(cfg_wlancfgdetail_language['amp_wps_enable_note']);
        return;
    }

    if (ConfirmEx(cfg_wlancfgdetail_language['amp_wps_start'])) 
    {
        var Form = new webSubmitForm();
        setDisable('btnWpsPBC', 1);
        
        if ('5G' == wlanpage)
        {
            Form.setAction('WpsPBC.cgi?freq=5G' + '&RequestFile=html/amp/wlanbasic/WlanBasic.asp');
        }
        else
        {
            Form.setAction('WpsPBC.cgi?freq=2G' + '&RequestFile=html/amp/wlanbasic/WlanBasic.asp');
        }
        
        Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        Form.submit();
    }
}

function WlanBasic(enable)
{
    setDisplay('wlanBasicCfg',1);
    setCheck('wlEnbl', enable);    

    if ((1 == enable) && (WlanArr[0] != null))
    {
        ssidIdx = 0;

        if ((1 == DoubleFreqFlag) && ("5G" == wlanpage) && (uiTotal5gNum > 0))
        {
            FirstRecordFor5G();
            selectLine('record_' + RecordFor5G);

        }
        else if((1 == DoubleFreqFlag) && ("2G" == wlanpage) && (uiTotal2gNum > 0))
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

        if (1 == DTHungaryFlag)
        {
            SetWpsTimeNoTimer();
            WpsTimeHandle = setInterval("SetWpsTime();", 1000);
        }
    }
    else if ((0 == enable))
    {
        setDisplay('wlanCfg',0);
    } 
    else
    {
        setDisplay('ssidDetail', 0);
    }
}

function SetWpsTime()
{
    var desc = '';
    var portIndex = getPortFromIndex(ssidIdx);
    
    getWpsTimer();

    WpsIndex = WpsTimeInfo.split(',')[0];
    WpsTime = WpsTimeInfo.split(',')[1];

    if ((0 != WpsTime) && (portIndex == WpsIndex))
    {
        desc = WpsTime + ' seconds left';
    }
        
    ShowWpsTimer();
        
    getElById('DivPBCTimeNote').innerHTML = desc;
    getElById('DivPinTimeNote').innerHTML = desc;
    getElById('DivAPPinTimeNote').innerHTML = desc;
    
    if ((0 == WpsTime) && 
        !((wpsPinNum[ssidIdx].X_HW_ConfigMethod == 'Lable') && (wpsPinNum[ssidIdx].X_HW_PinGenerator == 'AP')))
    {
        if(WpsTimeHandle != undefined)
        {
           clearInterval(WpsTimeHandle);
        }
    }

}

function SetWpsTimeNoTimer()
{
    var desc = '';
 
    var portIndex = getPortFromIndex(ssidIdx);

    if ((0 != WpsTime) && (portIndex == WpsIndex))
    {
        desc = WpsTime + ' seconds left';
    }

    getElById('DivPBCTimeNote').innerHTML = desc;
    getElById('DivPinTimeNote').innerHTML = desc;
    getElById('DivAPPinTimeNote').innerHTML = desc;
}

function check11nAndWmm()
{
    if (WlanWifi.mode == '11n')
    {
        setDisable('enableWmm', 1);
    }
}

function checkAuthModeAndWPS()
{
    var authMode = getSelectVal('wlAuthMode');
	switch (authMode)
    {
        case 'open':
        case 'shared':
        case 'wpa':
        case 'wpa2':
        case 'wpa/wpa2':
            setDisable('wlHide', 0); 
            break; 

        case 'wpa-psk':
        case 'wpa2-psk':
        case 'wpa/wpa2-psk':
            WPSAndHideCheck();
            break;
        
        default:
            break;
    }
}

function wlHideChange()
{
    if((1 == getCheckVal('wlWPSEnable')) && (0 == getCheckVal('wlHide')) && (true == IsWpsConfigDisplay()))
    {
        AlertEx(cfg_wlancfgother_language['amp_bcastssid_off_help']);
		setCheck('wlHide',1);
    }
}

function wmmChange()
{
    if ((0 == getCheckVal('enableWmm')) && ((WlanWifi.mode == "n") || (WlanWifi.mode == "11bgn") || (WlanWifi.mode == "11na")))
    {
        AlertEx(cfg_wlancfgother_language['amp_wlan_wmm_disable_notify']);
    }
}

function ClearPsdModFlag()
{
	wep1PsdModFlag = false;
	wep2PsdModFlag = false;
	wep3PsdModFlag = false;
	wep4PsdModFlag = false;
	pskPsdModFlag = false;
	radPsdModFlag = false;
}

function BindPsdModifyEvent()
{
    $('#wlKeys1').bind("propertychange input", function(){ 
        var KeyBit = getSelectVal('wlKeyBit');
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

    $('#wlKeys2').bind("propertychange input", function(){ 
        var KeyBit = getSelectVal('wlKeyBit');
        if ( KeyBit == '128' )
        {
            if (getValue('wlKeys2') != "*************")
            {
                wep2PsdModFlag = true;
            }            
        }
        else 
        {
            if(getValue('wlKeys2') != "*****") 
            {
                wep2PsdModFlag = true;
            }
        }
    } );

    $('#wlKeys3').bind("propertychange input", function(){ 
        var KeyBit = getSelectVal('wlKeyBit');
        if (KeyBit == '128')
        {
            if (getValue('wlKeys3') != "*************")
            {
                wep3PsdModFlag = true;
            }
            
        }
        else 
        {
            if(getValue('wlKeys3') != "*****") 
            {
                wep3PsdModFlag = true;
            }
        }
    } );

    $('#wlKeys4').bind("propertychange input", function(){ 
        var KeyBit = getSelectVal('wlKeyBit');
        if (KeyBit == '128') 
        {
            if (getValue('wlKeys4') != "*************")
            {
                 wep4PsdModFlag = true;
            }
           
        }
        else 
        {
            if (getValue('wlKeys4') != "*****") 
            {
                wep4PsdModFlag = true;
            }
        }
    } );


    $('#wlWpaPsk').bind("propertychange input", function(){ 
        if(getValue('wlWpaPsk') != "********") 
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

function LoadResource()
{
    if('128' == '<%HW_WEB_GetSPEC(AMP_SPEC_MAX_STA_NUM.UINT32);%>')
    {
        getElById('SpanDeviceNum').innerHTML = cfg_wlancfgdetail_language['amp_AssociateNum_note_128'];
        getElById('TdDeviceNum').title = cfg_wlancfgdetail_language['amp_devnum_help_128'];
    }
    else if('64' == '<%HW_WEB_GetSPEC(AMP_SPEC_MAX_STA_NUM.UINT32);%>')
    {
        getElById('SpanDeviceNum').innerHTML = cfg_wlancfgdetail_language['amp_AssociateNum_note_64'];
        getElById('TdDeviceNum').title = cfg_wlancfgdetail_language['amp_devnum_help_64'];
    }
}

function LoadFrame()
{       
    var flag5G =0;
    var flag2G =0;
    g_currentwlanInst = 0;

    Total2gNum();

    if (enbl == '')
    {
        setDisplay('wlanBasicCfg',0);
    }
    else
    {    
        if(1 == PccwFlag)
        {
            if((1 == DoubleFreqFlag)&&('2G' == wlanpage))
            {
                if ((null == Wlan[0]) || (0 == Wlan[0].X_HW_ServiceEnable) || ("ath0" != Wlan[0].name))
                {     
                       setDisplay('ConfigForm',0); 
                       return;
                }        
            }
            else if((1 == DoubleFreqFlag)&&('5G' == wlanpage))
            {
                var index;
                for(index = 0; index < Wlan.length; index++)
                {
                    if("ath4" == Wlan[index].name)
                    {
                        break;
                    }
                }                
                if ((index >= Wlan.length) || (0 == Wlan[index].X_HW_ServiceEnable))
                {     
                       setDisplay('ConfigForm',0); 
                       return;
                }        
            }
            else
            {
                if ((null == Wlan[0]) || (0 == Wlan[0].X_HW_ServiceEnable))
                {     
                   setDisplay('ConfigForm',0); 
                   return;
                }
            }        
        }  
        
        setDisplay('ConfigForm',1); 
        if (1 == DoubleFreqFlag)
        {
            FirstRecordFor5G();
            
            if ('2G' == wlanpage)
            {
                WlanBasic(enbl2G & enbl);
            }

            if ('5G' == wlanpage)
            {
                WlanBasic(enbl5G & enbl);
            }
        }
        else
        {
            WlanBasic(enbl);
        }        
    }
        
    keyIndexChange(0);
    
    document.getElementById('TdSSID').title = ssid;
    document.getElementById('TdDeviceNum').title = deviceNumber;
    document.getElementById('TdHide').title = hide;
    document.getElementById('TdWMM').title = wmm;
    document.getElementById('TdAuth').title = authmode;
    document.getElementById('TdEncrypt').title = encryption;

    if (g_keys[0] != null)
	{
    	document.getElementById('wlKeys1').title      = posswordComplexTitle;
    	document.getElementById('twlKeys1').title     = posswordComplexTitle;
	}

	if (g_keys[1] != null)
	{
    	document.getElementById('wlKeys2').title      = posswordComplexTitle;
    	document.getElementById('twlKeys2').title     = posswordComplexTitle;
	}

	if (g_keys[2] != null)
	{
    	document.getElementById('wlKeys3').title      = posswordComplexTitle;
    	document.getElementById('twlKeys3').title     = posswordComplexTitle;
	}

	if (g_keys[3] != null)
	{
    	document.getElementById('wlKeys4').title      = posswordComplexTitle;        
    	document.getElementById('twlKeys4').title     = posswordComplexTitle; 
    }  

    document.getElementById('wlWpaPsk').title     = posswordComplexTitle; 
    document.getElementById('twlWpaPsk').title    = posswordComplexTitle;
    document.getElementById('wlRadiusKey').title  = posswordComplexTitle;
    document.getElementById('twlRadiusKey').title = posswordComplexTitle;

    if ('SPANISH' == curLanguage.toUpperCase())
    {
         document.getElementById('wlAuthMode').style.width = '220px';
         document.getElementById('wlEncryption').style.width = '220px';
    }

    if(1 == PccwFlag)
    {           

        setDisplay('wlanOnOff',0);
        setDisplay('table_space1',0); 
        setDisplay('table_space2',0);
		setDisplay('DivSSIDList_Table_Container',0);
		setDisplay('list_table_spread',0);
        setDisplay('ssid_defail',0);   
        setDisable('enableWmm', 1);

        if ((enbl != 1) || ((1 == DoubleFreqFlag) && ("2G" == wlanpage) && (1 != enbl2G)) || ((1 == DoubleFreqFlag) && ("5G" == wlanpage) && (1 != enbl5G)))
        {
            setDisplay('ssidDetail',0);
        }
    }
    else
    {
        if ((1 == gzcmccFlag) && ((curUserType == sptUserType)))
        {
            setDisable('Newbutton', 1);
            setDisable('DeleteButton', 1);   
            setDisable('wlEnbl', 1);
        }

        if (1 == L2WifiFlag)
        {
            setDisplay('Newbutton', 0);  
            setDisplay('DeleteButton', 0);  
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
    }

    addAuthModeOption();

    check11nAndWmm();
    checkAuthModeAndWPS();
    LoadResource();
    
    if (wifiPasswordMask == 1)
    {
    	BindPsdModifyEvent();   
    	
    	setDisable('hidewlRadiusKey', 1);
    	setDisable('hidewlWpaPsk', 1);
    	setDisable('hidewlKeys', 1);    	
    }
    
    if ('CMCC' == CurrentBin.toUpperCase())
    {
        setDisplay('Newbutton', 0);  
        setDisplay('DeleteButton', 0);  
    }
	
	if ((1 == OnlySsid1Flag) && (curUserType == sptUserType))
    {
        setDisplay('Newbutton', 0);  
        setDisplay('DeleteButton', 0);  
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
        } else if (cfg_wlancfgother_language[b.getAttribute("BindText")]) {
            b.innerHTML = cfg_wlancfgother_language[b.getAttribute("BindText")];        
        } else if (cfg_wificover_basic_language[b.getAttribute("BindText")]) {
            b.innerHTML = cfg_wificover_basic_language[b.getAttribute("BindText")];        
        } else {
            ;
        }
        
        if (true == telmexSpan)
		{
			if (b.getAttribute("BindText") == 'amp_link_cdevnum')
			{
			   b.innerHTML = cfg_wlancfgdetail_language['amp_link_cdevnum_telmex'];
			   continue;
			}
			if (b.getAttribute("BindText") == 'amp_bcast_cssid')
			{
			   b.innerHTML = cfg_wlancfgdetail_language['amp_bcast_cssid_telmex'];
			   continue;
			}
			
		}      
        
    }

	if('1' == noWlanSwitchFlag)
	{
		setDisplay("wlanswitch", 0);
	}

	if (1 == IspSSIDVisibility)
    {
        if (jQ_IspEnabledItem == null)
        {
            jQ_IspDisabledItem = $("#ssidDetail input:disabled, #ssidDetail select:disabled, #ssidDetail button:disabled").get();
            jQ_IspEnabledItem  = $("#ssidDetail input:enabled,  #ssidDetail select:enabled,  #ssidDetail button:enabled").get();
        }

        if (1 == isSsidForIsp(g_currentwlanInst) )
        {
            $(jQ_IspEnabledItem).each(function ()
            {
                setDisable(""+this.id, 1);
            })
        }
    }

	$("#DivSSIDList_Table_Container").width($("#ConfigForm").width());
	fixIETableScroll("DivSSIDList_Table_Container", "wlanInst");
	
}

function ApplySubmit1()
{
    var Form = new webSubmitForm();   

    if (addParameter1(Form) == false)
    {
        setDisable('btnApplySubmit',0);
        setDisable('cancel',0);    
        return;
    }
    
    if (1 == DoubleFreqFlag)
    {
        if ("2G" == wlanpage)
        {
              Form.addParameter('y.LowerLayers', node2G);
            Form.setAction('add.cgi?y=InternetGatewayDevice.LANDevice.1.WLANConfiguration'
                                       + '&RequestFile=html/amp/wlanbasic/WlanBasic.asp');    
        }
        else if ("5G" == wlanpage)
        {
              Form.addParameter('y.LowerLayers', node5G);
            Form.setAction('add.cgi?y=InternetGatewayDevice.LANDevice.1.WLANConfiguration'
                                       + '&RequestFile=html/amp/wlanbasic/WlanBasic.asp');    
        }
        else
        {}

    }
    else
    {
          if (CfgMode.toUpperCase() == 'ANTEL')
	  {
	      Form.addParameter('y.BeaconType','WPAand11i');
              Form.addParameter('y.X_HW_WPAand11iAuthenticationMode','PSKAuthentication');
              Form.addParameter('y.X_HW_WPAand11iEncryptionModes','TKIPandAESEncryption');
	  }
        Form.setAction('add.cgi?y=InternetGatewayDevice.LANDevice.1.WLANConfiguration' 
                           + '&RequestFile=html/amp/wlanbasic/WlanBasic.asp');    
    }

    setDisable('btnApplySubmit',1);
    setDisable('cancel',1);
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
        setDisable('Newbutton', 1);
        setDisable('DeleteButton', 1);   

        setDisable('btnApplySubmit',1);
        setDisable('cancel',1);

        ApplySubmit1();
    }
    else
    {
        ApplySubmit2();
    }
}

function EnableSubmit()
{
	if('1' == noWlanSwitchFlag)
	{
		return;
	}
    setDisable('wlEnbl', 1);
    AddFlag = false;
    var Form = new webSubmitForm();
    var enable = getCheckVal('wlEnbl');
    
    setDisable('btnApplySubmit', 1);
    setDisable('cancel', 1);
    
    if (1 == DoubleFreqFlag)
    {
        if ("2G" == wlanpage)
        {
            Form.addParameter('x.Enable',enable);
            if ('InternetGatewayDevice.LANDevice.1.WiFi.Radio.1' == node2G)
            {
                Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.WiFi.Radio.1'
                                    + '&RequestFile=html/amp/wlanbasic/WlanBasic.asp');    
            }
            else
            {
                Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.WiFi.Radio.2'
                                    + '&RequestFile=html/amp/wlanbasic/WlanBasic.asp');              
            }
        }
        else if ("5G" == wlanpage)
        {
            Form.addParameter('x.Enable',enable);
              if ('InternetGatewayDevice.LANDevice.1.WiFi.Radio.1' == node5G)
            {
                Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.WiFi.Radio.1'
                                    + '&RequestFile=html/amp/wlanbasic/WlanBasic.asp');    
            }
            else
            {
                Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.WiFi.Radio.2'
                                    + '&RequestFile=html/amp/wlanbasic/WlanBasic.asp');              
            }
        }
        else
        {
        
        }        
    }
    else
    {
        Form.addParameter('x.X_HW_WlanEnable',enable);
        Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1'
                                + '&RequestFile=html/amp/wlanbasic/WlanBasic.asp');
    }
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function SetStyleValue(Id, Value)
{
    try
    {
        var Div = document.getElementById(Id);
        Div.setAttribute("style", Value);
        Div.style.cssText = Value;
    }
    catch(ex)
    {
    }
}

function SetDivValue(Id, Value)
{
    try
    {
        var Div = document.getElementById(Id);
        Div.innerHTML = Value;
    }
    catch(ex)
    {

    }
}

function SpecShowWlan(currentWlan)
{
    var ssidInst = getInstIdByDomain(currentWlan.domain);
    var ssidTipsNew = ssidTips;
    if ((true == AddFlag)|| (ssidInst != 1))
    {
        setText('wlSsid1',currentWlan.ssid);
        setDisable('wlSsid1',0);
        setDisplay('wlSsid2',0);
        setText('wlSsid2',"");
        SetStyleValue("wlSsid1", "width:123px");
    }
    else
    {
        var ssidParts = currentWlan.ssid.split('_');

        if (ssidParts.length == 1)
        {
            setText('wlSsid1',currentWlan.ssid);
            setDisable('wlSsid1',0);
            setDisplay('wlSsid2',0);
            setText('wlSsid2',"");
            SetStyleValue("wlSsid1", "width:123px");
        }
        else
        {
            if(ssidParts[0] == prefix)
            {
                var strSSID1 = ssidParts[0] + "_";
                var strSSID2 = currentWlan.ssid.substr(strSSID1.length,currentWlan.ssid.length);
                var ssidTipsLen = 32 - prefix.length - 1;
                setText('wlSsid1',strSSID1);
                setDisable('wlSsid1',1);
                setText('wlSsid2',strSSID2);
                setDisplay('wlSsid2',1);
                SetStyleValue("wlSsid1", "width:100px;border:0");
                ssidTipsNew = ssidTips.replace("32", ssidTipsLen);
            }
            else
            {
                setText('wlSsid1',currentWlan.ssid);
                setDisable('wlSsid1',0);
                setDisplay('wlSsid2',0);
                setText('wlSsid2',"");
                SetStyleValue("wlSsid1", "width:123px");
            }
        }
    }
    SetDivValue("ssidLenTips", ssidTipsNew);
}

function showWlan(currentWlan)
{
    with (document.forms[0])
    {
        ShowSsidEnable(currentWlan);
        setCheck('wlHide', currentWlan.wlHide);
        setText('X_HW_AssociateNum',currentWlan.DeviceNum);
        setCheck('enableWmm', currentWlan.wmmEnable)
        
        if (1 == preflag)
        {
            SpecShowWlan(currentWlan);
            if (ssidAccessAttr.indexOf('Subscriber') < 0)
            {
                setDisable('wlSsid1',1);
                setDisable('wlSsid2',1);

            }
        }
        else
        {
            setText('wlSsid',currentWlan.ssid);
            if (ssidAccessAttr.indexOf('Subscriber') < 0)
            {
                setDisable('wlSsid',1);
            }
        }

        beaconTypeChange(currentWlan.BeaconType);
        WPSAndHideCheck();
    }
}


function IsInSameRadio(WlanMap_index, Wlan_index)
{
    var WlanMap_index_portIndex = 0;
    var Wlan_index_portIndex = 0;
		
    if ('1' != '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WPS_MULIT_PBC);%>')
	{
		return true;
	}

	for (var i = 0; i < WlanMap.length; i++)
	{
		if (WlanMap[i].index == WlanMap_index)
		{
			WlanMap_index_portIndex = parseInt(WlanMap[i].portIndex);
			break;
		}
	}

    for (var i = 0; i < WlanMap.length; i++)
    {
        if (WlanMap[i].index == Wlan_index)
        {
            Wlan_index_portIndex = parseInt(WlanMap[i].portIndex);
            break;
        }
    }

    if (   ((WlanMap_index_portIndex < 4) && (Wlan_index_portIndex < 4)) 
        || ((WlanMap_index_portIndex > 3) && (Wlan_index_portIndex > 3)) )
    {
        return true;
    }
    else
    {
        return false;
    }
}


function addWPSModeOption(wlaninstId)
{
    var len = document.forms[0].wlWPSMode.options.length;
    var existPushBut = 0;

    for (i = 0; i < len; i++)
    {
        document.forms[0].wlWPSMode.remove(0);
    }
    
    for (i = 0; i < Wlan.length; i++)
    {        
        if (IsInSameRadio(wlaninstId, i) && (wpsPinNum[i].X_HW_ConfigMethod == 'PushButton') && (true == wpsPinNum[i].Enable) 
        && ((((Wlan[i].BeaconType == 'WPA2') || (Wlan[i].BeaconType == '11i')) && (Wlan[i].IEEE11iAuthenticationMode == 'PSKAuthentication'))
        || ((Wlan[i].BeaconType == 'WPA') && (Wlan[i].WPAAuthenticationMode == 'PSKAuthentication'))
        || (((Wlan[i].BeaconType == 'WPAand11i') || (Wlan[i].BeaconType == 'WPA/WPA2')) && (Wlan[i].X_HW_WPAand11iAuthenticationMode == 'PSKAuthentication'))))
        {
            existPushBut = 1;
            break;
        }
    }
    
    if ((0 == existPushBut) || ((1 == existPushBut) && (wlaninstId == i)))
    {
        document.forms[0].wlWPSMode[0] = new Option(cfg_wlancfgother_language['amp_wpsmode_pbc'], "PBC");
        document.forms[0].wlWPSMode[1] = new Option(cfg_wlancfgother_language['amp_wpsmode_pin'], "PIN");
        document.forms[0].wlWPSMode[2] = new Option(cfg_wlancfgother_language['amp_wpsmode_appin'], "AP-PIN");
    }
    else
    {
        document.forms[0].wlWPSMode[0] = new Option(cfg_wlancfgother_language['amp_wpsmode_pin'], "PIN");
        document.forms[0].wlWPSMode[1] = new Option(cfg_wlancfgother_language['amp_wpsmode_appin'], "AP-PIN");
    }
}

function selectLine(id)
{
	var objTR = getElement(id);

	if (objTR != null)
	{
		var temp = objTR.id.split('_')[1];
		if ((temp == 'null') || (id == 'Wireless_record_null'))
		{
			setLineHighLight(objTR);
		    setControl(-1);
			setDisable('btnApply',0);
			setDisable('btnCancel',0);
		}
        else if (temp == 'no')
        {
            setControl(-2);
            setDisable('btnApply',0);
			setDisable('btnCancel',0);
        }
		else
		{
			var index = parseInt(temp);
			setControl(index);
            setLineHighLight(objTR);
			setDisable('btnApply',1);
			setDisable('btnCancel',1);
		}
	}
}

function loadssid(tableRow, maxssidband)
{
    setDisplay('cfg_table', 0);
    if (tableRow.rows.length > 2)
    {
        tableRow.deleteRow(tableRow.rows.length-1);
    }

    if (maxssidband == 4)
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_4max']);
    }
    else
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_8max']);
    }

    LoadFrame();
}

function setControl(idIndex)
{
    var tableRow = getElement("wlanInst");
	var wlanInst = 0;
	
	ClearPsdModFlag();
    if (-1 == idIndex)
    {   
        if (1 == SingleFreqFlag)
        {
            if (SsidPerBand == 8)
            {
                if (SsidNum2g >= 8)
                {
                    loadssid(tableRow, 8);
                    return;
                }
                
            }
            else if (SsidNum2g >= 4)
            {
                loadssid(tableRow, 4);
                return;
            }
        }
        else if (1 == DoubleFreqFlag)
        {
            Total2gNum();

            if ("2G" == wlanpage)
            {
                if (SsidNum2g >= 4)
                {
                    loadssid(tableRow, 4);
                    return;
                }
            }
 
            else if("5G" == wlanpage)
            {
                if (SsidNum5g >= 4)
                {
                    loadssid(tableRow, 4);
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
		wlanInst = getWlanInstFromDomain(Wlan[idIndex].domain);
        AddFlag = false;
        
        
        currentWlan = Wlan[ssidIdx];
        guiCoverSsidNotifyFlag = 0;

        addWPSModeOption(ssidIdx);    
           
        if (1 == TelMexFlag)
        {
            keyIndexChange(currentWlan.KeyIndex);
        }
    }
    
    showWlan(currentWlan);
	
	if ((1 == isSsidForIsp(wlanInst)) && (1 == ShowISPSsidFlag))
	{
		setDisable('btnApplySubmit', 1);
		setDisable('cancel', 1);
		return;
	}

    if ((1 == gzcmccFlag) && (curUserType == sptUserType))
    {
        setDisable('btnApplySubmit', 1);
        setDisable('cancel', 1);
        return;
    }

    if (1 == IspSSIDVisibility)
    {
        var wlanInst = getWlanInstFromDomain(currentWlan.domain);
        g_currentwlanInst = wlanInst;

        if (jQ_IspEnabledItem != null)
        {
            $(jQ_IspDisabledItem).each(function ()
            {
                setDisable(""+this.id, 1);
            }) 

            $(jQ_IspEnabledItem).each(function ()
            {
                setDisable(""+this.id, 0);
            }) 

            if (1 == isSsidForIsp(wlanInst))
            {
                $(jQ_IspEnabledItem).each(function ()
                {
                    setDisable(""+this.id, 1);
                })    
            }
        }
    }

}

function selectRemoveCnt(curCheck)
{
}

function clickRemove(tabTitle)
{
    btnRemoveWlanCnt();
}

function addDeleteDomain(SubmitForm)
{    
    var rml = getElement('rml');    
    if (rml == null)        
        return;
    
    with (document.forms[0])
    {
        if (rml.length > 0)
        {
            for (var i = 0; i < rml.length; i++)
            {
                if (rml[i].checked == true)
                {
                    wlandomain = rml[i].value;
                    SubmitForm.addParameter(wlandomain, '');
                }
            }
        }
        else if (rml.checked == true)
        {
            wlandomain = rml.value;
            SubmitForm.addParameter(wlandomain, '');
        }        
    }
}

function btnRemoveWlanCnt()
{
    if (AddFlag == true)
    {
        if (WlanMap.length == 0)
        {
            AlertEx(cfg_wlancfgother_language['amp_ssid_select']);
            return ;
        }
        
       AlertEx(cfg_wlancfgother_language['amp_ssid_del']);
       return;
    }

    var rml = getElement('rml');
    var noChooseFlag = true;    
    if ( rml.length > 0)
    {
        for (var i = 0; i < rml.length; i++)
        {
            if (rml[i].checked == true)
            {
                noChooseFlag = false;
            }
        }
    }
    else if (rml.checked == true)
    {
        noChooseFlag = false;
    }

    if ( noChooseFlag )
    {   
        AlertEx(cfg_wlancfgother_language['amp_ssid_select']);
        return ;
    }

    if (ConfirmEx(cfg_wlancfgother_language['amp_delssid_confirm']) == false)
    {   
        document.getElementById("DeleteButton").disabled = false;
        return;
    }

    var Form = new webSubmitForm();    
    addDeleteDomain(Form);
    Form.setAction('del.cgi?RequestFile=html/amp/wlanbasic/WlanBasic.asp');
    setDisable('btnApplySubmit',1);
    setDisable('cancel',1);
	setDisable('Newbutton', 1);

    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function TDEGetSSIDStringContent(str, Length)
{		
    if(null != str)
    {
	    str = str.toString().replace(/&amp;/g,"&");
    	str = str.toString().replace(/&nbsp;/g," ");
    	str = str.toString().replace(/&quot;/g,"\"");
    	str = str.toString().replace(/&gt;/g,">");
    	str = str.toString().replace(/&lt;/g,"<");
    	str = str.toString().replace(/&#39;/g, "\'");
    	str = str.toString().replace(/&#40;/g, "\(");
    	str = str.toString().replace(/&#41;/g, "\)");
			
		str = str.toString().replace(/&Aacute;/g,"Á");
        str = str.toString().replace(/&aacute;/g,"á");
		
        str = str.toString().replace(/&Agrave;/g,"À");
        str = str.toString().replace(/&agrave;/g,"à");	

        str = str.toString().replace(/&Eacute;/g,"É");
        str = str.toString().replace(/&eacute;/g,"é");	
				
        str = str.toString().replace(/&Iacute;/g,"Í");
        str = str.toString().replace(/&iacute;/g,"í");	
		
        str = str.toString().replace(/&Oacute;/g,"Ó");
        str = str.toString().replace(/&oacute;/g,"ó");		

		str = str.toString().replace(/&Uacute;/g,"Ú");
        str = str.toString().replace(/&uacute;/g,"ú");

		str = str.toString().replace(/&Acirc;/g,"Â");
        str = str.toString().replace(/&acirc;/g,"â");	
		
		str = str.toString().replace(/&Ecirc;/g,"Ê");
        str = str.toString().replace(/&ecirc;/g,"ê");	

		str = str.toString().replace(/&Icirc;/g,"Î");
        str = str.toString().replace(/&icirc;/g,"î");	

        str = str.toString().replace(/&ouml;/g,"ö");	

		str = str.toString().replace(/&Ucirc;/g,"Û");
        str = str.toString().replace(/&ucirc;/g,"û");			

		str = str.toString().replace(/&Uuml;/g,"Ü");
        str = str.toString().replace(/&uuml;/g,"ü");
		
		str = str.toString().replace(/&Ccedil;/g,"Ç");
        str = str.toString().replace(/&ccedil;/g,"ç");	

		str = str.toString().replace(/&Atilde;/g,"Ã");
        str = str.toString().replace(/&atilde;/g,"ã");	
		
		str = str.toString().replace(/&Otilde;/g,"Õ");
        str = str.toString().replace(/&otilde;/g,"õ");			

        str = str.toString().replace(/&Ntilde;/g,"Ñ");	    
        str = str.toString().replace(/&ntilde;/g,"ñ");	
		
		str = str.toString().replace(/&euro;/g,"€");			
		
		str = str.toString().replace(/&Ograve;/g,"Ò");
        str = str.toString().replace(/&ograve;/g,"ò");	

		str = str.toString().replace(/&Ugrave;/g,"Ù");
        str = str.toString().replace(/&ugrave;/g,"ù");			

		str = str.toString().replace(/&Egrave;/g,"È");
        str = str.toString().replace(/&eacute;/g,"è");

		str = str.toString().replace(/&Igrave;/g,"Ì");
        str = str.toString().replace(/&iacute;/g,"ì");
		
		str = str.toString().replace(/&Iuml;/g,"Ï");
        str = str.toString().replace(/&iuml;/g,"ï");
		
		str = str.toString().replace(/&ordf;/g,"ª");
        str = str.toString().replace(/&ordm;/g,"º");	
		
        str = str.toString().replace(/&iquest;/g,"¿");	

    }

	if (str.length > Length)
    {
        str=str.substr(0, Length) + "......";
    }

	if(null != str)
    {
	    str = str.toString().replace(/&/g,"&amp;");
        str = str.toString().replace(/ /g,"&nbsp;");
    	str = str.toString().replace(/\"/g,"&quot;");
    	str = str.toString().replace(/>/g,"&gt;");
    	str = str.toString().replace(/</g,"&lt;");
    	str = str.toString().replace(/\'/g, "&#39;");
    	str = str.toString().replace(/\(/g, "&#40;");
    	str = str.toString().replace(/\)/g, "&#41;");
		
		str = str.toString().replace(/Á/g,"&Aacute;");
        str = str.toString().replace(/á/g,"&aacute;");
		
        str = str.toString().replace(/À/g,"&Agrave;");
        str = str.toString().replace(/à/g,"&agrave;");	

        str = str.toString().replace(/É/g,"&Eacute;");
        str = str.toString().replace(/é/g,"&eacute;");	
				
        str = str.toString().replace(/Í/g,"&Iacute;");
        str = str.toString().replace(/í/g,"&iacute;");	
		
        str = str.toString().replace(/Ó/g,"&Oacute;");
        str = str.toString().replace(/ó/g,"&oacute;");		

		str = str.toString().replace(/Ú/g,"&Uacute;");
        str = str.toString().replace(/ú/g,"&uacute;");

		str = str.toString().replace(/Â/g,"&Acirc;");
        str = str.toString().replace(/â/g,"&acirc;");	
		
		str = str.toString().replace(/Ê/g,"&Ecirc;");
        str = str.toString().replace(/ê/g,"&ecirc;");	

		str = str.toString().replace(/Î/g,"&Icirc;");
        str = str.toString().replace(/î/g,"&icirc;");	

        str = str.toString().replace(/ö/g,"&ouml;");	

		str = str.toString().replace(/Û/g,"&Ucirc;");
        str = str.toString().replace(/û/g,"&ucirc;");			

		str = str.toString().replace(/Ü/g,"&Uuml;");
        str = str.toString().replace(/ü/g,"&uuml;");
		
		str = str.toString().replace(/Ç/g,"&Ccedil;");
        str = str.toString().replace(/ç/g,"&ccedil;");	

		str = str.toString().replace(/Ã/g,"&Atilde;");
        str = str.toString().replace(/ã/g,"&atilde;");	
		
		str = str.toString().replace(/Õ/g,"&Otilde;");
        str = str.toString().replace(/õ/g,"&otilde;");			

        str = str.toString().replace(/Ñ/g,"&Ntilde;");	    
        str = str.toString().replace(/ñ/g,"&ntilde;");	
		
		str = str.toString().replace(/€/g,"&euro;");			
	
		str = str.toString().replace(/Ò/g,"&Ograve;");
        str = str.toString().replace(/ò/g,"&ograve;");	

		str = str.toString().replace(/Ù/g,"&Ugrave;");
        str = str.toString().replace(/ù/g,"&ugrave;");			

		str = str.toString().replace(/È/g,"&Egrave;");
        str = str.toString().replace(/è/g,"&eacute;");

		str = str.toString().replace(/Ì/g,"&Igrave;");
        str = str.toString().replace(/ì/g,"&iacute;");
		
		str = str.toString().replace(/Ï/g,"&Iuml;");
        str = str.toString().replace(/ï/g,"&iuml;");
		
		str = str.toString().replace(/ª/g,"&ordf;");
        str = str.toString().replace(/º/g,"&ordm;");	
		
        str = str.toString().replace(/¿/g,"&iquest;");	
			
    }

    return str;
}


function cancelValue()
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
            
            if (0 == WlanMap.length)
			{
				setDisplay('ssidDetail',0);
			}
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


var hide = cfg_wlancfgdetail_language['amp_bcastssid_help'];
var wmm = cfg_wlancfgdetail_language['amp_vmm_help'];
var authmode = cfg_wlancfgdetail_language['amp_authmode_help'];
var encryption = cfg_wlancfgdetail_language['amp_encrypt_help'];
var ssid = cfg_wlancfgdetail_language['amp_ssid_help'];
var deviceNumber = cfg_wlancfgdetail_language['amp_devnum_help'];
var posswordComplexTitle = cfg_wlancfgdetail_language['amp_wlanpasswordcomplex_title'];


function wlanWriteTabTail()
{
    document.write("<\/td><\/tr><\/table>");
}


</script>
</head>


<body class="mainbody" onLoad="LoadFrame();">
<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"><tr> <td></td></tr></table>  
<script language="JavaScript" type="text/javascript">
var wlanbasic_note = ""; 
var wlanbasic_header = ""; 
if((1 == DoubleFreqFlag) && ("2G" == wlanpage))
{
	wlanbasic_note = cfg_wlancfgother_language['amp_wlanbasic_title_2G'];
	wlanbasic_header = cfg_wlancfgbasic_language['amp_wlan_basic_header_2G'];
}
else if((1 == DoubleFreqFlag) && ("5G" == wlanpage))
{
	wlanbasic_note = cfg_wlancfgother_language['amp_wlanbasic_title_5G'];
	wlanbasic_header = cfg_wlancfgbasic_language['amp_wlan_basic_header_5G'];
}
else
{
	wlanbasic_note = cfg_wlancfgother_language['amp_wlanbasic_title'];
	wlanbasic_header = cfg_wlancfgbasic_language['amp_wlan_basic_header'];
}

if (1 == PccwFlag)
{
	wlanbasic_note = cfg_wlancfgother_language['amp_wlanbasic_title_pccw'];
}

var WlanBasicSummaryArray = new Array(new stSummaryInfo("text",wlanbasic_note),
                                    new stSummaryInfo("img","../../../images/icon_01.gif", GetDescFormArrayById(cfg_wlancfgother_language, "amp_wlan_note1")),
                                    new stSummaryInfo("text","1. " + GetDescFormArrayById(cfg_wlancfgother_language, "amp_wlan_note") + "<br>"),
									new stSummaryInfo("text","2. " + GetDescFormArrayById(cfg_wlancfgother_language, "amp_wlan_note2")),
                                    null);
HWCreatePageHeadInfo("wlanbasicSummary", wlanbasic_header, WlanBasicSummaryArray, true);
</script>

<div class="title_spread"></div>

<form id="ConfigForm" action="../network/set.cgi" style="display:none">
 <table width="100%" border="0" cellspacing="0" cellpadding="0" >
  <tr ><td>
  
    <div id='wlanBasicCfg'>
    <div id='wlanswitch'>
    <table cellspacing="0" cellpadding="0" width="100%" id="wlanOnOff">
      <tr>
        <td class="func_title"><input type='checkbox' name='wlEnbl' id='wlEnbl' onClick='EnableSubmit();' value="ON">
          <script>document.write(cfg_wlancfgother_language['amp_wlan_enable']);  </script></input></td>
      </tr>
    </table>

      </div>

    <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table_space2">
      <tr ><td class="width_10px"></td></tr>
    </table>

    <div id='wlanCfg'>

    <script language="JavaScript" type="text/javascript">
     if(1 != PccwFlag)
    {
        writeTabCfgHeader('Wireless',"100%");
    }

    </script>
		
	<div id="DivSSIDList_Table_Container" style="overflow:auto;overflow-y:hidden;">
	
    <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="wlanInst">
      <tr class="head_title">
        <td>&nbsp;</td>
        <td ><div class="align_center"><script>document.write(cfg_wlancfgbasic_language['amp_ssid_id']);</script></div></td>
        <td ><div class="align_center"><script>document.write(cfg_wlancfgbasic_language['amp_ssid_name']);</script></div></td>
        <td ><div class="align_center"><script>document.write(cfg_wlancfgbasic_language['amp_ssid_link']);</script></div></td>
        
        <script>
        
        if( '1' != AmpTDESepicalCharaterFlag )
        {
            document.write("<td ><div class='align_center'>");
            if (true != telmexSpan)
            {
                document.write(cfg_wlancfgbasic_language['amp_link_devnum']);
            }
            else
            {
                document.write(cfg_wlancfgbasic_language['amp_link_devnum_telmex']);
            }
            document.write("</div></td>");
        }
        
        </script>
        
        <td ><div class="align_center">
        <script>
        if (true != telmexSpan)
        {
            document.write(cfg_wlancfgbasic_language['amp_bcast_ssid']);
        }
        else
        {
            document.write(cfg_wlancfgbasic_language['amp_bcast_ssid_telmex']);
        }
        </script>
        </div></td>
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

            var curWlanInst = getWlanInstFromDomain(Wlan[mapIndex].domain);

            document.write('<TR id="record_' + i  + '" class="tabal_01" onclick="selectLine(this.id);">');

            if (   ( 0 == WlanMap[i].portIndex ) 
                || ( (4 == WlanMap[i].portIndex) && (1 == DoubleFreqFlag) ) 
                || ( (1 == IspSSIDVisibility) && (1 == isSsidForIsp(curWlanInst)) )   )

            {
                document.write('<TD>' + '<input type="checkbox" name="rml" id="rml"'  + ' value="'+ Wlan[mapIndex].domain + '" onclick="selectRemoveCnt(i);" disabled="true" >' + '</TD>');
            }
            else
            {
                document.write('<TD>' + '<input type="checkbox" name="rml" id="rml"'  + ' value="'+ Wlan[mapIndex].domain + '" onclick="selectRemoveCnt(i);">' + '</TD>');
            }
            
            document.write('<TD>' + curWlanInst + '</TD>');
            document.write('<TD>' + TDEGetSSIDStringContent(Wlan[mapIndex].ssid,32)+ '</TD>');
            
            if ((Wlan[mapIndex].enable == 1) && (Wlan[mapIndex].X_HW_ServiceEnable == 1))
            {
                document.write('<TD>' + cfg_wlancfgbasic_language['amp_ssid_enable'] + '</TD>');
            }
            else
            {
                document.write('<TD>' + cfg_wlancfgbasic_language['amp_ssid_disable'] + '</TD>');
            }
            if('1' != AmpTDESepicalCharaterFlag)
            {
                document.write('<TD>' + Wlan[mapIndex].DeviceNum+ '</TD>');
            }
            if (Wlan[mapIndex].wlHide == 1)
            {
                document.write('<TD>' + cfg_wlancfgbasic_language['amp_bcast_enable'] + '</TD>');
            }
            else
            {
                document.write('<TD>' + cfg_wlancfgbasic_language['amp_bcast_disable'] + '</TD>');
            }
            if ((Wlan[mapIndex].BeaconType == 'Basic' && Wlan[mapIndex].BasicAuthenticationMode == 'None' && Wlan[mapIndex].BasicEncryptionModes == 'None') || (Wlan[mapIndex].BeaconType == 'None'))
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
    
    </div>

<script language="JavaScript" type="text/javascript">
    wlanWriteTabTail();
</script>

<div id="list_table_spread" class="list_table_spread"></div>

<div id='ssidDetail'>
<table width="100%" border="0" cellpadding="0" cellspacing="1" id="cfg_table">
  <tr>
    <td colspan="6">

    <table  width="100%" border="0" cellpadding="0" cellspacing="0"><tr class="tabal_head" id="ssid_defail"><td class="block_title" BindText='amp_ssid_detail'></td></tr></table>

    <div id="wlanbasicWeb" class="configborder">
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr>
          <td class="table_title width_per25" BindText='amp_link_name'></td>
            <td class="table_right" id="TdSSID">
              <script language="JavaScript" type="text/javascript">
              if (1 == preflag)
              {
                  document.write('<input type="text" name="wlSsid1" id="wlSsid1" maxlength="32">');
                  document.write('<input type="text" name="wlSsid2" id="wlSsid2" style="width:123px" maxlength="32">');                 	
              }
              else
              {
                  document.write('<input type="text" name="wlSsid" id="wlSsid" style="width:123px" maxlength="32">');
              }
              </script>            
              <font class="color_red">*</font><span id="ssidLenTips" class="gray">
              <script>
              var ssidTips = cfg_wlancfgdetail_language['amp_linkname_note'];
              document.write(ssidTips);
              </script>
              </span> 
          </td>
        </tr>

        <tr>
          <td class="table_title width_per25" BindText='amp_link_status'></td>
          <td class="table_right" id="TdEnable">
            <input type='checkbox' id='wlEnable' name='wlEnable' value="ON" onClick="SsidEnable();">
            <span class="gray"> </span></td>
        </tr>

        <tr id="tr_sta_num_max_limit">
          <td class="table_title width_per25" BindText='amp_link_cdevnum'></td>
          <td  class="table_right" id="TdDeviceNum">
            <input type='text' id='X_HW_AssociateNum' name='X_HW_AssociateNum' size='10' class="width_120px">
            <font class="color_red">*</font><span id='SpanDeviceNum' class="gray"> 
            <script>document.write(cfg_wlancfgdetail_language['amp_AssociateNum_note']);</script></span> 
          </td>
          <script>
            setDisplay('tr_sta_num_max_limit', '1' != AmpTDESepicalCharaterFlag);
          </script>
        </tr>

        <tr>
          <td class="table_title width_per25" BindText='amp_bcast_cssid'></td>
          <td class="table_right" id="TdHide">
            <input type='checkbox' id='wlHide' name='wlHide' value="ON" onclick='wlHideChange()'>
            <span class="gray"> </span></td>
        </tr>

        <tr>
          <td class="table_title width_per25" BindText='amp_multi_mdia'></td>
          <td class="table_right" id="TdWMM">
            <input type='checkbox' id='enableWmm' name='enableWmm' onclick='wmmChange()'>
            <span class="gray"></span></td>
        </tr>
      </table>

    <div id='securityCfg'>
    <div id='wlAuthModeDiv'>
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr>
          <td class="table_title width_per25" BindText='amp_auth_mode'></td>
          <td class="table_right" id="TdAuth">
            <select id='wlAuthMode' name='wlAuthMode' size="1" onChange='authModeChange()' class="width_180px">
            <script language="JavaScript" type="text/javascript">
            if ((1 == TelMexFlag)||(1 == DTHungaryFlag))
            {
                document.write("<option value='open' selected>"+cfg_wlancfgdetail_language['amp_auth_open']+"</option>");
                document.write("<option value='wpa-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpapsk']+"</option>");
                document.write("<option value='wpa2-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpa2psk']+"</option>");
                document.write("<option value='wpa/wpa2-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpawpa2psk']+"</option>");
                document.write("<option value='wpa'>"+cfg_wlancfgdetail_language['amp_auth_wpa']+"</option>");
                document.write("<option value='wpa2'>"+cfg_wlancfgdetail_language['amp_auth_wpa2']+"</option>");
                document.write("<option value='wpa/wpa2'>"+cfg_wlancfgdetail_language['amp_auth_wpawpa2']+"</option>");        
            }
            else if ('ANTEL' == CfgMode.toUpperCase())
            {
                document.write("<option value='wpa-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpapsk']+"</option>");
                document.write("<option value='wpa2-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpa2psk']+"</option>");
                document.write("<option value='wpa/wpa2-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpawpa2psk']+"</option>");
            }
            else
            {
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

            }
            </script>
            </select> <span class="gray"> </span></td>
        </tr>
      </table>
    </div>

    <div id='wlEncryMethod'>
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr>
          <td class="table_title width_per25" BindText='amp_encrypt_mode'></td>
          <td class="table_right" id="TdEncrypt">
            <select id = 'wlEncryption' name = 'wlEncryption'  size='1'  onChange='onMethodChange(0);' class="width_180px">
            </select>
          </td>
        </tr>
      </table>
    </div>

    <div id='keyInfo'>
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr id="tr_wepKeyBit">
          <td class="table_title width_per25" BindText='amp_encrypt_keylen'></td>
            <td colspan="2" class="table_right">
              <select id='wlKeyBit' name='wlKeyBit' size='1' onChange='wlKeyBitChange()' class="width_150px">
                <option value="128" selected><script>document.write(cfg_wlancfgdetail_language['amp_encrypt_128key']);</script></option>
                <option value="64"><script>document.write(cfg_wlancfgdetail_language['amp_encrypt_64key']);</script></option>
              </select>
              <span class="gray"> <script>document.write(cfg_wlancfgdetail_language['amp_keylen_note']);</script></span> </td>
              <script>
                setDisplay("tr_wepKeyBit", ('1' != noWep64Flag));
              </script>
        </tr>

        <tr>
          <td class="table_title width_per25" BindText='amp_key_index'></td>
          <td colspan="2" class="table_right">
            <select id='wlKeyIndex' name='wlKeyIndex' size='1' onChange='keyIndexChange(0)' class="width_150px">
            <script language="JavaScript" type="text/javascript">
                for (var i = 1; i < 5 ; i++)
                {
                    document.write("<option value=" + i + ">" + i + "</option>");
                }
            </script>
            </select> <span class="gray"> </span> </td>
        </tr>

        <tr>
          <td class="table_title width_per25" BindText='amp_encrypt_key1'></td>
          <td class="table_right"> <script language="JavaScript" type="text/javascript">
            if (g_keys[0] != null)
            {
                document.write("<input type='password' id='wlKeys1' name='wlKeys1' size='20' maxlength=26 onchange=\"wep1password=getValue('wlKeys1');getElById('twlKeys1').value=wep1password\" value='" + g_keys[0][1] + "'>")
                document.write("<input type='text' id='twlKeys1' name='twlKeys1' size='20' maxlength=26 style='display:none'  onchange=\"wep1password=getValue('twlKeys1');getElById('wlKeys1').value=wep1password\" value='" + g_keys[0][1] + "'>");
            }
            </script> </td>
          <td rowspan="4"  class="table_right"> <font class="color_red">*</font> 
            <input checked type='checkbox' id='hidewlKeys' name='hidewlKeys' value='on' onClick="ShowOrHideText('hidewlKeys', 'wlKeys1', 'twlKeys1', wep1password);ShowOrHideText('hidewlKeys', 'wlKeys2', 'twlKeys2', wep2password);ShowOrHideText('hidewlKeys', 'wlKeys3', 'twlKeys3', wep3password);ShowOrHideText('hidewlKeys', 'wlKeys4', 'twlKeys4', wep4password);"/>
            <script>document.write(cfg_wlancfgdetail_language['amp_wlanpassword_hide']);</script>
            <span id="span_wep_keynote" class="gray"> <script>document.write(cfg_wlancfgdetail_language['amp_encrypt_keynote']);</script></span> 
          </td>
        </tr>
        <tr>
          <td class="table_title width_per25" BindText='amp_encrypt_key2'></td>
          <td class="table_right"> <script language="JavaScript" type="text/javascript">
            if(g_keys[1] != null)
            {
                document.write("<input type='password' id='wlKeys2' name='wlKeys2' size='20' maxlength=26 onchange=\"wep2password=getValue('wlKeys2');getElById('twlKeys2').value=wep2password\" value='" + g_keys[1][1]+ "'>")
                document.write("<input type='text' id='twlKeys2' name='twlKeys2' size='20' maxlength=26  style='display:none'  onchange=\"wep2password=getValue('twlKeys2');getElById('wlKeys2').value=wep2password\" value='" + g_keys[1][1] + "'>");
            }
            </script> </td>
        </tr>
        <tr>
          <td class="table_title width_per25" BindText='amp_encrypt_key3'></td>
          <td class="table_right"> <script language="JavaScript" type="text/javascript">
            if(g_keys[2] != null)
            {
                document.write("<input type='password' id='wlKeys3' name='wlKeys3' size='20' maxlength=26 onchange=\"wep3password=getValue('wlKeys3');getElById('twlKeys3').value=wep3password\" value='" + g_keys[2][1] + "'>")
                document.write("<input type='text' id='twlKeys3' name='twlKeys3' size='20' maxlength=26  style='display:none' onchange=\"wep3password=getValue('twlKeys3');getElById('wlKeys3').value=wep3password\" value='" + g_keys[2][1] + "'>");
            }
            </script> </td>
        </tr>
        <tr>
          <td class="table_title width_per25" BindText='amp_encrypt_key4'></td>
          <td class="table_right"> <script language="JavaScript" type="text/javascript">
            if(g_keys[3] != null)
            {
                document.write("<input type='password' id='wlKeys4' name='wlKeys4' size='20' maxlength=26 onchange=\"wep4password=getValue('wlKeys4');getElById('twlKeys4').value=wep4password\" value='" + g_keys[3][1] + "'>")
                document.write("<input type='text' id='twlKeys4' name='twlKeys4' size='20' maxlength=26  style='display:none' onchange=\"wep4password=getValue('twlKeys4');getElById('wlKeys4').value=wep4password\" value='" + g_keys[3][1] + "'>");
            }
            </script> </td>
        </tr>
      </table>
    </div>

    <div id='wpaPreShareKey'>
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr>
          <td class="table_title width_per25" id= "wpa_psk">
          <script>
          var authMode = getSelectVal('wlAuthMode'); 
          if(authMode == 'wapi-psk')
          {
                  document.write(cfg_wlancfgdetail_language['amp_wapi_psk']);
          }
          else
          {
                  document.write(cfg_wlancfgdetail_language['amp_wpa_psk']);
          }
          </script>
          </td>
          <td class="table_right">
            <input type='password' id='wlWpaPsk' name='wlWpaPsk' size='20' maxlength='64' class="amp_font"  onchange="wpapskpassword=getValue('wlWpaPsk');getElById('twlWpaPsk').value=wpapskpassword;" />
            <input type='text' id='twlWpaPsk' name='twlWpaPsk' size='20' maxlength='64' class="amp_font" style='display:none' onchange="wpapskpassword=getValue('twlWpaPsk');getElById('wlWpaPsk').value=wpapskpassword;"/>
            <input checked type="checkbox" id="hidewlWpaPsk" name="hidewlWpaPsk" value="on" onClick="ShowOrHideText('hidewlWpaPsk', 'wlWpaPsk', 'twlWpaPsk', wpapskpassword);"/>
            <script>document.write(cfg_wlancfgdetail_language['amp_wlanpassword_hide']);</script>
            <font class="color_red">*</font><span class="gray">
            <script>
                document.write(cfg_wlancfgdetail_language['amp_wpa_psknote' + ('1' == kppUsedFlag ? '_63' : '')]);
            </script></span></td>
        </tr>
      </table>
    </div>
    
     <div id='wlWapi'>
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr>
           <td class="table_title width_per25" BindText='amp_wapi_ip'></td>
           <td class="table_right">
              <input type='text' id='wapiIPAddr' name='wapiIPAddr' size='20' maxlength='15'>
              <font class="color_red">*</font>
          </td>
        </tr>
      </table>
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr>
          <td class="table_title width_per25" BindText='amp_wapi_port'></td>
           <td class="table_right">
              <input type='text' id='wapiPort' name='wapiPort' size='20' maxlength='15'>
              <font class="color_red">*</font><span class="gray">
              <script>document.write(cfg_wlancfgdetail_language['amp_radiusport_note']);</script></span> 
          </td>
        </tr>
      </table>
    </div>
    
    <div id='wlRadius'>
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr>
          <td class="table_title width_per25" BindText='amp_radius_srvip'></td>
          <td class="table_right">
              <input type='text' id='wlRadiusIPAddr' name='wlRadiusIPAddr' size='20' maxlength='15'>
              <font class="color_red">*</font>
          </td>
        </tr>
      </table>

      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr>
          <td class="table_title width_per25" BindText='amp_radius_srvport'></td>
          <td class="table_right">
            <input type='text' id='wlRadiusPort' name='wlRadiusPort' size='20' maxlength='5'>
            <font class="color_red">*</font><span class="gray">
            <script>document.write(cfg_wlancfgdetail_language['amp_radiusport_note']);</script></span> 
          </td>
        </tr>
      </table>

      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr>
          <td class="table_title width_per25" BindText='amp_radius_sharekey'></td>
          <td class="table_right">
            <input type='password' id='wlRadiusKey' name='wlRadiusKey' size='20' maxlength='64' class="amp_font" onchange="radiuspassword=getValue('wlRadiusKey');getElById('twlRadiusKey').value=radiuspassword;" />
            <input type='text' id='twlRadiusKey' name='twlRadiusKey' size='20' maxlength='64' class="amp_font" style='display:none'  onchange="radiuspassword=getValue('twlRadiusKey');getElById('wlRadiusKey').value=radiuspassword;"/>
            <input checked type="checkbox" id="hidewlRadiusKey" name="hidewlRadiusKey" value="on" onClick="ShowOrHideText('hidewlRadiusKey', 'wlRadiusKey', 'twlRadiusKey', radiuspassword);"/>
            <script>document.write(cfg_wlancfgdetail_language['amp_wlanpassword_hide']);</script>
          </td>
        </tr>
      </table>
    </div>

    <div id='wpaGTKRekey'>
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr>
          <td class="table_title width_per25" BindText='amp_wpakey_time'></td>
          <td class="table_right"><input type='text' id='wlWpaGtkRekey' name='wlWpaGtkRekey' size='20' maxlength='10' value='3600' class="amp_font">
            <font class="color_red">*</font><span class="gray"><script>document.write(cfg_wlancfgdetail_language['amp_wpakey_timenote']);</script></span></td>
        </tr>
      </table>
    </div>

    <div id='wpsPinNumber'>
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr> 
          <td class="table_title width_per25" BindText='amp_wps_enable'></td>
          <td class="table_right" id="TdWPSEnable"> <input id='wlWPSEnable' name='wlWPSEnable' type='checkbox' value="ON" onClick="wlWPSEnableChange();";> 
            <span class="gray" id='DivWpsNote'>
            </span>          
          </td>
        </tr>

        <tr>
          <td class="table_title width_per25" BindText='amp_wps_mode'></td>
          <td class="table_right">
            <select id='wlWPSMode' name='wlWPSMode' size='1' class="width_180px" onchange='wlPinModeChange();'> 
            </select> 
            <span class="gray" id='DivPinNote'>
            </span>
          </td>
        </tr> 
      </table>
    </div>

    <div id='wpsPBCButton'>
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr>
          <td class="table_title width_per25"><script>document.write(cfg_wlancfgother_language['amp_wlan_pbc']);</script></td>
          <td class="table_right"> 
            <input id="btnWpsPBC" name="btnWpsPBC" type="button" class="CancleButtonCss buttonwidth_height_30px" style="margin-left:0px" onClick="WpsPBCSubmit();">    
            <script language="JavaScript" type="text/javascript">setText('btnWpsPBC',cfg_wlancfgother_language['amp_btn_wpsstart']);</script>
            <span class="gray" id='DivPBCTimeNote'>
            </span>
          </td>
        </tr>
      </table>
    </div>

    <div id='wpsPinNumVal'>
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr>
          <td class="table_title width_per25">PIN:</td>
          <td class="table_right"> <input type='text' id='wlClientPinNum' name='wlClientPinNum' size='20' maxlength='8' class="amp_font"> 
            <span class="gray" id='DivPinTimeNote'>
            </span>
          </td>
        </tr>
      </table>
    </div>

    <div id='wpsAPPinNumVal'> 
      <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr> 
          <td class="table_title width_per25">AP-PIN:</td>
          <td class="table_right"> <input type='text' id='wlSelfPinNum' name='wlSelfPinNum' size='20' maxlength='8' disabled class="amp_font"> 
            <button id="RegeneratePIN" name="RegeneratePIN" type="button" class="CancleButtonCss buttonwidth_height_30px" onclick="OnRegeneratePIN();"/><script>document.write(cfg_wlancfgother_language['amp_reg_pin']);</script></button>
            <button id="ResetPIN" name="ResetPIN" type="button" class="CancleButtonCss buttonwidth_height_30px" onclick="OnResetPIN();"/><script>document.write(cfg_wlancfgother_language['amp_reset_pin']);</script></button>
            <span class="gray" id='DivAPPinTimeNote'>
            </span>
          </td>
        </tr>
      </table>
    </div>

    </div>

	</div>
    
    <table width="100%" border="0" cellpadding="0" cellspacing="0"  >
      <tr><td>
        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
          <tr>
            <td class="table_submit width_per25"></td>
            <td class="table_submit">
              <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
              <button id="btnApplySubmit" name="btnApplySubmit" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="ApplySubmit();"><script>document.write(cfg_wlancfgother_language['amp_wlancfg_apply']);</script></button>
              <button id="cancel" name="cancel" type="button" class="CancleButtonCss buttonwidth_100px" onClick="cancelValue();"><script>document.write(cfg_wlancfgother_language['amp_wlancfg_cancel']);</script></button>
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
<table width="100%" border="0" cellspacing="5" cellpadding="0">
<tr ><td class="height10p"></td></tr>
</table>
<!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd --></html>

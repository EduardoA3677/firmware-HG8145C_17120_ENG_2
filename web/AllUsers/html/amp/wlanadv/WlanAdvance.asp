<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>
<title>WLAN Advanced Configuration</title>
<style>
.StyleSelect
{
    width:160px;  
}
</style>

<script language="JavaScript" type="text/javascript">

var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var sptUserType ='1';
var gzcmccFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_GZCMCC);%>';
var TelMexFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TELMEX);%>';
var AtTelecomFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TELECOM);%>';
var PccwFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PCCW);%>';     
var Wlan11acFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_11AC);%>';
var WdsFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WDS);%>';
var AisPrev = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_AIS);%>';
var AntGain = '<%HW_WEB_GetSPEC(AMP_SPEC_ANT_GAIN.UINT32);%>';
var AisFlag;
if ((AisPrev == 1) && (AntGain == 5))
{
	AisFlag = 1;
}
else
{
	AisFlag = 0;
}
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
var curWlanChipType2G = '<%HW_WEB_GetWlanChipType(2G);%>';
var curWlanChipType5G = '<%HW_WEB_GetWlanChipType(5G);%>';
var AmpTxBeamformingFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TX_BEAMFORMING_SHOW);%>';
var ShowMCSFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_MCS_VISIBILITY);%>';
var RegulatoryDomainImmutable = '<%HW_WEB_GetFeatureSupport(FT_WLAN_REGULATORYDOMAIN_IMMUTABLE);%>';
var t2Flag = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_TDE);%>';
var RSSIThrFlag = '<%HW_WEB_GetFeatureSupport(AMP_FT_RSSI_THRESHOLD);%>';
var chlwidth80Res = (t2Flag=='1')?'amp_chlwidth_80':'amp_chlwidth_auto204080';

var telmexSpan = false;
if ((('TELMEX' == CfgMode.toUpperCase()) || ('TELMEX5G' == CfgMode.toUpperCase())) && 'SPANISH' == curLanguage.toUpperCase())
{
    telmexSpan = true;
}

var wlanpage;
if (location.href.indexOf("WlanAdvance.asp?") > 0)
{
    wlanpage = location.href.split("?")[1]; 
    top.WlanAdvancePage = wlanpage;
}

wlanpage = top.WlanAdvancePage;  

initWlanCap(wlanpage);

var curWlanChipType = curWlanChipType2G;
if ('5G' == wlanpage)
{
	curWlanChipType = curWlanChipType5G;
}

var possibleChannels = "";

function stWlan(domain,name,enable,ssid,wlHide,DeviceNum,wmmEnable,BeaconType,BasicEncryptionModes,BasicAuthenticationMode,
                KeyIndex,EncryptionLevel,WPAEncryptionModes,WPAAuthenticationMode,IEEE11iEncryptionModes,IEEE11iAuthenticationMode,
                X_HW_WPAand11iEncryptionModes,X_HW_WPAand11iAuthenticationMode,WPARekey,RadiusServer,RadiusPort,RadiusKey,X_HW_ServiceEnable)
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
}

var enbl = WlanEnable[0].enable;

var Wlan = new Array();

var WlanArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|SSIDAdvertisementEnabled|X_HW_AssociateNum|WMMEnable|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WEPKeyIndex|WEPEncryptionLevel|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|X_HW_GroupRekey|X_HW_RadiuServer|X_HW_RadiusPort|X_HW_RadiusKey|X_HW_ServiceEnable,stWlan);%>;

var wlanArrLen = WlanArr.length - 1;

for (i=0; i < wlanArrLen; i++)
{
    Wlan[i] = new stWlan();
    Wlan[i] = WlanArr[i];
}

function stWiFiRadio(domain,GuardInterval)
{
    this.domain = domain;
	this.GuardInterval = GuardInterval;
}

var WiFiRadioArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WiFi.Radio.{i},GuardInterval,stWiFiRadio,EXTEND);%>;
var WiFiRadioArrLen = WiFiRadioArr.length - 1;
var WiFiRadio = WiFiRadioArr[0];


function getWlanPortNumber(name)
{
    var length = name.length;
    var number;
    var str = parseInt(name.charAt(length-1));
    return str;
}

function stExtendedWLC(domain, SSIDIndex)
{
    this.domain = domain;
    this.SSIDIndex = SSIDIndex;
}

var apExtendedWLC = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.X_HW_APDevice.{i}.WifiCover.ExtendedWLC.{i}, SSIDIndex, stExtendedWLC,EXTEND);%>;

var uiBandIncludeWifiCoverSsid = 0;

function setBandWifiCoverSsidFlag(wlanInst)
{
    for (var j = 0; j < apExtendedWLC.length - 1; j++)
    {
        if (wlanInst == apExtendedWLC[j].SSIDIndex)
        {
            uiBandIncludeWifiCoverSsid++;
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

            setBandWifiCoverSsidFlag(getWlanInstFromDomain(Wlan[loop].domain));
        }
    }
}

function InitX_HW_Standard()
{  
    var wlgmode = getSelectVal('X_HW_Standard'); 
    var isshow11n = 0;    
    var isshow11ac = 0;	 
    var isshow11a = 0;
    var isantel = (CfgMode.toUpperCase() == 'ANTEL');
    
    for (i = 0; i < Wlan.length; i++) 
    {
        var BeaconType = Wlan[i].BeaconType;    
        var BasicEncryptionModes =  Wlan[i].BasicEncryptionModes;       
        var WPAEncryptionModes  = Wlan[i].WPAEncryptionModes;
        var IEEE11iEncryptionModes = Wlan[i].IEEE11iEncryptionModes;
        var X_HW_WPAand11iEncryptionModes = Wlan[i].X_HW_WPAand11iEncryptionModes;

        var name = Wlan[i].name;
        var portIndex = parseInt(name.charAt(length-1));
        if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
        {
            if (portIndex < 4)
            {
                continue;
            }
        }

        if ((1 == DoubleFreqFlag) && ("2G" == wlanpage))
        {
            if (portIndex > 3)
            {
                continue;
            }                    
        }
       
        if ((BeaconType == "Basic") && (BasicEncryptionModes == "WEPEncryption"))
        {
           isshow11n += 1;
           isshow11ac +=1;
        }
       
        else if ((BeaconType =="WPA" )
                   && ((WPAEncryptionModes == "TKIPEncryption")||(WPAEncryptionModes == "TKIPandAESEncryption")))
        {
           isshow11n += 1;           
        }
       
        else if ( ((BeaconType =="11i" ) || (BeaconType =="WPA2") )
                   && ((IEEE11iEncryptionModes == "TKIPEncryption")||(IEEE11iEncryptionModes == "TKIPandAESEncryption")) )
        {
           isshow11n += 1;           
        }
       
        else if ( ((BeaconType =="WPAand11i" ) || (BeaconType =="WPA/WPA2") )
                   && ((X_HW_WPAand11iEncryptionModes == "TKIPEncryption")||(X_HW_WPAand11iEncryptionModes == "TKIPandAESEncryption")))
        {
           isshow11n += 1;           
        }
        
        if (0 == Wlan[i].wmmEnable)
        {
            isshow11n += 1;
        }
        
    }          

    isshow11n += (1 - cap11n) + isantel;
    isshow11a += 1 - cap11a;
    
    $('X_HW_Standard').empty();

    var standardArr = { '11a' : ["802.11a", 0], 
	                  '11b' : ["802.11b", 0], 
	                  '11g' : ["802.11g", 0], 
	                  '11n' : ["802.11n", 0], 
	                  '11bg' : ["802.11b/g", 0], 
	                  '11bgn' : ["802.11b/g/n", 0], 
	                  '11na' : ["802.11a/n", 0], 
	                  '11ac' : ["802.11a/n/ac", 0]
	                };

    standardArr['11n'][1] = (0 == isshow11n);
    
    if ("5G" == wlanpage)
    {
        standardArr['11a'][1] = (0 == isshow11a);
        standardArr['11na'][1] = 1;
        standardArr['11ac'][1] = ((1 == Wlan11acFlag) && (0 == isshow11ac));
    }
    else
    {
        standardArr['11b'][1] = 1;
        standardArr['11g'][1] = !isantel;
        standardArr['11bg'][1] = 1;
        standardArr['11bgn'][1] = 1;
    }

    InitDropDownListWithSelected('X_HW_Standard', standardArr, wlgmode)
    
}

function InitX_HW_MCS()
{
    var len = document.forms[0].X_HW_MCS.options.length;    
    var wlgmcs = WlanBasic.X_HW_MCS; 
    var wlgmode =  WlanBasic.X_HW_Standard;
			
    for (i = 0; i < len; i++)
    {
        document.forms[0].X_HW_MCS.remove(0);
    }
    
    if((1 == DoubleFreqFlag) && ("5G" == wlanpage))
    {
        if('11na' == wlgmode)
        {
            var MAXMCS = 32;
            document.forms[0].X_HW_MCS[0] = new Option(cfg_wlancfgadvance_language['amp_shortgi_auto'], -1);
            for(var i=1; i<=MAXMCS; i++)
            {
                document.forms[0].X_HW_MCS[i] = new Option(i-1, i-1);
            }
            setSelect('X_HW_MCS',wlgmcs);
        }
        if('11ac' == wlgmode)
        {
            var MAXMCS = 10;
            document.forms[0].X_HW_MCS[0] = new Option(cfg_wlancfgadvance_language['amp_shortgi_auto'], -1);
            for(var j=1; j<=4; j++)
            {
                for(var i=1; i<=MAXMCS; i++)
                {
                    var acMCS = i-1+j*100;
                    document.forms[0].X_HW_MCS[i+(j-1)*10] = new Option(acMCS, acMCS);
                }
            }
            setSelect('X_HW_MCS',wlgmcs);
        }
    }
}

function stWlanAdv(domain,DtimPeriod,BeaconPeriod,RTSThreshold,FragThreshold)
{
    this.domain = domain;
    this.DtimPeriod = DtimPeriod;
    this.BeaconPeriod = BeaconPeriod;
    this.RTSThreshold = RTSThreshold;
    this.FragThreshold = FragThreshold;
}

function stWlanWifi(domain,Name,Enable,SSID,X_HW_Standard,Channel,TransmitPower,RegulatoryDomain,AutoChannelEnable,X_HW_HT20,PossibleChannels, wmmEnable, X_HW_WorkMode,X_IEEE80211wEnabled,X_TxBFEnabled,X_OCCACEnables, X_HW_MCS, X_HW_RSSIThreshold, X_HW_RSSIThresholdEnable)
{
    this.domain = domain;
    this.Name = Name;
    this.Enable = Enable;
    this.SSID = SSID;
    this.X_HW_Standard = X_HW_Standard;
    this.Channel = Channel;
    this.TransmitPower = TransmitPower;
    this.RegulatoryDomain = RegulatoryDomain;
    this.AutoChannelEnable = AutoChannelEnable;
    this.X_HW_HT20 = X_HW_HT20;
    this.PossibleChannels = PossibleChannels;
    this.wmmEnable = wmmEnable;
    this.X_HW_WorkMode = X_HW_WorkMode;
	this.X_IEEE80211wEnabled = X_IEEE80211wEnabled;	
    this.X_TxBFEnabled = X_TxBFEnabled;	
    this.X_OCCACEnables = X_OCCACEnables;		
    this.X_HW_MCS = X_HW_MCS;
    this.X_HW_RSSIThreshold = X_HW_RSSIThreshold;
    this.X_HW_RSSIThresholdEnable = X_HW_RSSIThresholdEnable;
}

var WlanAdvs = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.X_HW_AdvanceConf,DtimPeriod|BeaconPeriod|RTSThreshold|FragThreshold,stWlanAdv);%>;
var WlanAdv = WlanAdvs[0];

var WlanBasicArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|X_HW_Standard|Channel|TransmitPower|RegulatoryDomain|AutoChannelEnable|X_HW_HT20|PossibleChannels|WMMEnable|X_HW_WorkMode|X_IEEE80211wEnabled|X_TxBFEnabled|X_OCCACEnables|X_HW_MCS|X_HW_RSSIThreshold|X_HW_RSSIThresholdEnable, stWlanWifi);%>;
var WlanBasic = WlanBasicArr[0];
if (null == WlanBasic)
{
    WlanBasic = new stWlanWifi("","","","","11n","","","","","","","","","","","","","","");
}

var uiFirstIndexFor5G = 0;
function WlanWifiInitFor5G()
{
    for (i=0; i < wlanArrLen; i++)
    {
        if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
        {
            if (('ath4' == WlanArr[i].name) || ('ath5' == WlanArr[i].name) || ('ath6' == WlanArr[i].name) || ('ath7' == WlanArr[i].name))
            {
                uiFirstIndexFor5G = i;        
                WlanBasic = WlanBasicArr[uiFirstIndexFor5G];
                WlanAdv = WlanAdvs[uiFirstIndexFor5G];
                return;
            }
        }
    }
}

function SetWlanWifiDefaultFor2G()
{
    if ("5G" == wlanpage)
    {
        return;
    }

    for (i=0; i < wlanArrLen; i++)
    {
        if (('ath0' == WlanArr[i].name) || ('ath1' == WlanArr[i].name) || ('ath2' == WlanArr[i].name) || ('ath3' == WlanArr[i].name))
        {
            WlanBasic = WlanBasicArr[i];
            WlanAdv = WlanAdvs[i];
            return;
        }
    }
}

function SetWiFiRadioDefault()
{
    if ("5G" == wlanpage)
	{
		WiFiRadio = WiFiRadioArr[1];
	}
	else if("2G" == wlanpage)
	{
	   WiFiRadio = WiFiRadioArr[0];
	}
	else
	{
	}
	
	return;
}
SetWlanWifiDefaultFor2G();
WlanWifiInitFor5G();
SetWiFiRadioDefault();

function stTotalWlanAttr(WlanBasic, WlanAdv,WiFiRadio)
{
	this.TransmitPower = WlanBasic.TransmitPower;
	this.RegulatoryDomain = WlanBasic.RegulatoryDomain;
	this.AutoChannelEnable = WlanBasic.AutoChannelEnable;
	this.GuardInterval = WiFiRadio.GuardInterval;	
	this.X_IEEE80211wEnabled = WlanBasic.X_IEEE80211wEnabled;	
	this.X_TxBFEnabled = WlanBasic.X_TxBFEnabled;
	this.X_OCCACEnables = WlanBasic.X_OCCACEnables;	

	
	if (1 == WlanBasic.AutoChannelEnable)
	{
		this.Channel = 0;
	}
	else
	{
		this.Channel = WlanBasic.Channel;
	}

	this.X_HW_WorkMode = WlanBasic.X_HW_WorkMode;
	this.X_HW_HT20 = WlanBasic.X_HW_HT20;
	this.X_HW_Standard = WlanBasic.X_HW_Standard;
    this.X_HW_MCS = WlanBasic.X_HW_MCS;

	this.DtimPeriod = WlanAdv.DtimPeriod;
	this.BeaconPeriod = WlanAdv.BeaconPeriod;
	this.RTSThreshold = WlanAdv.RTSThreshold;
	this.FragThreshold = WlanAdv.FragThreshold;
}

var TotalWlanAttr = new stTotalWlanAttr(WlanBasic, WlanAdv,WiFiRadio);

function getPossibleChannels(freq, country, mode, width)
{
    $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "../common/WlanChannel.asp?&1=1",
            data :"freq="+freq+"&country="+country+"&standard="+mode + "&width="+width,
            success : function(data) {
                possibleChannels = data;
            }
        });
}

function load2GChannelList(country, mode)
{
    var WebChannel = getSelectVal('Channel');
    var WebChannelValid = 0;
    var len = document.forms[0].Channel.options.length;

    for (i = 0; i < len; i++)
    {
        document.forms[0].Channel.remove(0);
    }

    document.forms[0].Channel[0] = new Option(cfg_wlancfgadvance_language['amp_chllist_auto'], "0");

    for (i = 1; i <= 11; i++)
    {
        if (WebChannel == i)
        {
            WebChannelValid = 1;
        }
        document.forms[0].Channel[i] = new Option(i, i);
    }

    if (country != "CA" && country != "CO" && country != "DO" && country != "GT" && country != "MX"
        && country != "PA" && country != "PR" && country != "TW" && country != "US" && country != "UZ" && country != "PH")
    {
        if ((WebChannel == 12) || (WebChannel == 13))
        {
            WebChannelValid = 1;
        }
        document.forms[0].Channel[12] = new Option("12", "12");
        document.forms[0].Channel[13] = new Option("13", "13");
    }
        
    if ((mode == "11b") &&  (country == "JP"))
    {
        if (WebChannel == 14)
        {
            WebChannelValid = 1;
        }
        document.forms[0].Channel[14] = new Option("14", "14");
    }

    if (1 == WebChannelValid)
    {
        setSelect('Channel', WebChannel);
    }
    else
    {
        setSelect('Channel', 0);    
    }
}

function loadChannelListByFreq(freq, country, mode, width)
{
    var len = document.forms[0].Channel.options.length;
    var index = 0;
    var i;
    var WebChannel = getSelectVal('Channel');
    var WebChannelValid = 0;    

    getPossibleChannels(freq, country, mode, width);
    var ShowChannels = possibleChannels.split(',');

    for (i = 0; i < len; i++)
    {
        document.forms[0].Channel.remove(0);
    }

    document.forms[0].Channel[0] = new Option(cfg_wlancfgadvance_language['amp_chllist_auto'], "0");
    
    for (var j=1; j<=ShowChannels.length; j++)
    {
        if(j==ShowChannels.length)
        {
            for(i = 0; i < ShowChannels[ShowChannels.length-1].length;i++)
            {
                if((ShowChannels[ShowChannels.length-1].charCodeAt(i)< 0x30)||(ShowChannels[ShowChannels.length-1].charCodeAt(i) > 0x39))
                {
                    index = i;
                    break;
                    
                }
            }
            ShowChannels[j-1] = ShowChannels[ShowChannels.length-1].substring(0,index);
        }
        
        if (WebChannel == ShowChannels[j-1])
        {
            WebChannelValid = 1;
        }
        document.forms[0].Channel[j] = new Option(ShowChannels[j-1], ShowChannels[j-1]);
    }

    if (1 == WebChannelValid)
    {
        setSelect('Channel', WebChannel);
    }
    else
    {
        setSelect('Channel', 0);    
    }
}

function loadChannelList(country, mode, width)
{
    var freq = '2G';
    if ("5G" == wlanpage)
    {
        freq = '5G';
    }
    loadChannelListByFreq(freq, country, mode, width);
}

function X_HW_MCSChange()
{
    if(('0' == ShowMCSFlag) || (curUserType == sptUserType) || (1 != DoubleFreqFlag) || ("5G" != wlanpage))
    {
        setDisplay('X_HW_MCS' + 'Row', 0);
        return;
    }
    var mode = getSelectVal('X_HW_Standard');
    var lenMCS = document.forms[0].X_HW_MCS.options.length;
			
    for (i = 0; i < lenMCS; i++)
    {
        document.forms[0].X_HW_MCS.remove(0);
    }
    if('11na' == mode)
    {
        var MAXMCS = 32;
        document.forms[0].X_HW_MCS[0] = new Option(cfg_wlancfgadvance_language['amp_shortgi_auto'], -1);
        for(var i=1; i<=MAXMCS; i++)
        {
            document.forms[0].X_HW_MCS[i] = new Option(i-1, i-1);
        }
        setSelect('X_HW_MCS', -1);
    }
    if('11ac' == mode)
    {
        var MAXMCS = 10;
        document.forms[0].X_HW_MCS[0] = new Option(cfg_wlancfgadvance_language['amp_shortgi_auto'], -1);
		for (var j = 1; j <= 4; j++)
        {
            for (var i = 1; i <= MAXMCS; i++)
            {
                var acMCS = i - 1 + j * 100;
                document.forms[0].X_HW_MCS[i + (j - 1) * 10] = new Option(acMCS, acMCS);
            }
        }
        setSelect('X_HW_MCS', -1);
    }
		
    if('11ac' == mode || '11na' == mode)
    {
        setDisplay('X_HW_MCS' + 'Row', 1);
    }
    else
    {
        setDisplay('X_HW_MCS' + 'Row', 0);
    }	
}

function X_HW_StandardChange()
{
    var mode = getSelectVal('X_HW_Standard');
    var channelWidthRestore = getSelectVal('X_HW_HT20');
    var channel = getSelectVal('Channel');
    var country = getSelectVal('RegulatoryDomain');
		
    var len = document.forms[0].X_HW_HT20.options.length;
    var lenChannel = document.forms[0].Channel.options.length;
    X_HW_MCSChange();


    if ((14 == channel) && ("11b" != mode))
    {
        setSelect('Channel', 0);
    }

    for (i = 0; i < len; i++)
    {
        document.forms[0].X_HW_HT20.remove(0);
    }

    if ((mode == "11b") || (mode == "11g") || (mode == "11bg") || (mode == "11a"))
    {    
        document.forms[0].X_HW_HT20[0] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_20'], "1");
    }
    else
    {
        if (CfgMode.toUpperCase() == 'ANTEL')
        {
            document.forms[0].X_HW_HT20[0] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_20'], "1");
            document.forms[0].X_HW_HT20[1] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_40'], "2");
        }
        else
        {
            document.forms[0].X_HW_HT20[0] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_auto2040'], "0");
            document.forms[0].X_HW_HT20[1] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_20'], "1");
            document.forms[0].X_HW_HT20[2] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_40'], "2");
        }
        
        if ( (1 == Wlan11acFlag) && (1 == DoubleFreqFlag) && ("5G" == wlanpage) && (mode == "11ac") )
        {
            if (country != "RU")
            {
                document.forms[0].X_HW_HT20[3] = new Option(cfg_wlancfgadvance_language[chlwidth80Res], "3");			
            }
        }

        if ((3 != channelWidthRestore) || (mode == "11ac"))
        {
            setSelect('X_HW_HT20', channelWidthRestore);
        }
        else
        {
            setSelect('X_HW_HT20', 0);
        }
    }

	var width = getValue('X_HW_HT20');
    loadChannelList(country, mode, width);
}

function X_HW_HT20Change()
{
	X_HW_StandardChange();
}

function ChannelChange()
{

}

function RegulatoryDomainChange()
{
	X_HW_StandardChange();
}

function X_HW_RSSIThresholdEnableClick()
{
    setDisplay('X_HW_RSSIThreshold' + 'Row', getCheckVal('X_HW_RSSIThresholdEnable'));
}

function WifiAdvanceShow(enable)
{
	if ((1 != enable) || (WlanAdv == null) || (WlanBasic == null))
	{
		setDisplay('div_wlanadv', 0);
	}
	else
	{
		setDisplay('div_wlanadv', 1);
	}
}

function stWdsClientAp(domain, BSSID)
{
    this.domain = domain;
    this.BSSID = BSSID;
}

function WdsSetDisplayFunc(enable)
{
    if(1 == WdsFlag)
    {
        setDisplay('X_HW_WlanMac' + 'Row', enable);
		setDisplay('wds_Ap1_BSSID' + 'Row', enable);
		setDisplay('wds_Ap2_BSSID' + 'Row', enable);
		setDisplay('wds_Ap3_BSSID' + 'Row', enable);
		setDisplay('wds_Ap4_BSSID' + 'Row', enable);
	}else
	{
		setDisplay('wds_Enable' + 'Row', 0);
        setDisplay('X_HW_WlanMac' + 'Row', 0);
        setDisplay('wds_Ap1_BSSID' + 'Row', 0);
        setDisplay('wds_Ap2_BSSID' + 'Row', 0);
        setDisplay('wds_Ap3_BSSID' + 'Row', 0);
        setDisplay('wds_Ap4_BSSID' + 'Row', 0);
	}
}

function WdsClickFunc()
{
    var WdsEnable = getCheckVal('wds_Enable');
	WdsSetDisplayFunc(WdsEnable);
}

function stWdsEnable(domain,enable)
{
    this.domain = domain;
    this.enable = enable;
}

function LoadWdsConfig()
{
    var WdsEnable = 0;
    if (1 == WdsFlag)
    {
        WdsEnable = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS, Enable, stWdsEnable, EXTEND);%>;
        WdsEnable = WdsEnable[0].enable;
		
        var WdsClientApMacAddr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.{i}, BSSID, stWdsClientAp, EXTEND);%>;

        if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
        {
            if(t2Flag == '1')
            {
                WdsClientApMacAddr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.2.X_HW_WDS.ClientAP.{i}, BSSID, stWdsClientAp, EXTEND);%>;

                WdsEnable = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.2.X_HW_WDS, Enable, stWdsEnable, EXTEND);%>;
                WdsEnable = WdsEnable[0].enable;
            }
            else
            {
                WdsClientApMacAddr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.ClientAP.{i}, BSSID, stWdsClientAp, EXTEND);%>;

                WdsEnable = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS, Enable, stWdsEnable, EXTEND);%>;
                WdsEnable = WdsEnable[0].enable;
            }
        }

        var WdsMasterMac = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_WlanMac);%>';
        if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
        {
            WdsMasterMac = '<%HW_WEB_GetWlanMac_5G();%>';
        }

        setCheck('wds_Enable', WdsEnable);
        document.getElementById("X_HW_WlanMac").innerHTML = WdsMasterMac;
        setText('wds_Ap1_BSSID', WdsClientApMacAddr[0].BSSID.toUpperCase());
        setText('wds_Ap2_BSSID', WdsClientApMacAddr[1].BSSID.toUpperCase());
        setText('wds_Ap3_BSSID', WdsClientApMacAddr[2].BSSID.toUpperCase());
        setText('wds_Ap4_BSSID', WdsClientApMacAddr[3].BSSID.toUpperCase());
    }

    WdsSetDisplayFunc(WdsEnable);
}

function RemoveDropDownListTransmitPower()
{
    var len = document.forms[0].TransmitPower.options.length;    

    for (i = 0; i < len; i++)
    {
        document.forms[0].TransmitPower.remove(0);
    }
}

function RebuildWlanBasicDropDownList()
{
	InitX_HW_Standard();
    X_HW_StandardChange();
    InitX_HW_MCS();
    InitGuardInterval("GuardInterval");
}

function PccwSetDislayFunc()
{
    if ("PCCW4MAC" == CfgMode.toUpperCase())
	{
	    return;
	}
	
    getElById("wlanadv_head").style.display = "none";
	setDisplay('RegulatoryDomain' + 'Row', 0);
	setDisplay('DtimPeriod' + 'Row', 0);
	setDisplay('BeaconPeriod' + 'Row', 0);
	setDisplay('RTSThreshold' + 'Row', 0);
	setDisplay('FragThreshold' + 'Row', 0);
}

function LoadFrameWifi()
{
    SetWlanWifiDefaultFor2G();
    
    WlanWifiInitFor5G();
	
	SetWiFiRadioDefault();

    Total2gNum();
    if (1 == DoubleFreqFlag)
    {
        if (1 == enbl)
        {
            if ('2G' == wlanpage)
            {
                WifiAdvanceShow((enbl2G != "0") && (uiTotal2gNum > 0));
            }
            
            if ('5G' == wlanpage)
            {
                WifiAdvanceShow((enbl5G != "0") && (uiTotal5gNum > 0));
            }
        }
        else
        {
            WifiAdvanceShow((enbl != "0") && (uiTotalNum > 0));
        }
 
        if (IsSonetSptUser())
        {
			setDisplay('RegulatoryDomain' + 'Row', 0);
        }
    }
    else       
    {
        WifiAdvanceShow((enbl != "0") && (uiTotalNum > 0));
    }

    if ((1 == gzcmccFlag) && (curUserType == sptUserType))
    {
        setDisable('applyButton', 1);
        setDisable('cancelButton', 1);
    }
 
    if ((1 == AtTelecomFlag) && (curUserType == sptUserType))
    {
		setDisable('TransmitPower' + 'Col', 1);
		setDisable('RegulatoryDomain' + 'Col', 1);
		setDisable('Channel' + 'Col', 1);
		setDisable('X_HW_HT20' + 'Col', 1);
		setDisable('X_HW_Standard' + 'Col', 1);
		
		setDisable('DtimPeriod' + 'Col', 1);
		setDisable('BeaconPeriod' + 'Col', 1);
		setDisable('RTSThreshold' + 'Col', 1);
		setDisable('FragThreshold' + 'Col', 1);

        setDisable('applyButton', 1);
        setDisable('cancelButton', 1);
    }

    InitX_HW_Standard();
    InitX_HW_MCS();
    if((1 == DoubleFreqFlag) && ("5G" == wlanpage) && ('1' == ShowMCSFlag) && (curUserType == sysUserType) 
    && ('11na' == WlanBasic.X_HW_Standard || '11ac' == WlanBasic.X_HW_Standard))
    {
        setDisplay('X_HW_MCS' + 'Row', 1);
    }
    else
    {
        setDisplay('X_HW_MCS' + 'Row', 0);
    }
    
    InitX_HW_RSSIThreshold();

    if ((1 == DTHungaryFlag) && (curUserType == sptUserType))
    {
       setDisable('RegulatoryDomain',1);
    }

    if (IsPTVDFSptUser())
    {
        setDisplay('RegulatoryDomain' + 'Row', 0);
    }
	
            if ((2 == curWlanChipType) && (1 == '<%HW_WEB_GetFeatureSupport(AMP_FT_WIFI_WORK_MODE);%>'))
            {
                setDisplay('X_HW_WorkMode' + 'Row', 1);
                var title = cfg_wlancfgadvance_language['amp_workmode_alert_normal'] + '\n'
                            + cfg_wlancfgadvance_language['amp_workmode_alert_crosswall'] + '\n'
                            + cfg_wlancfgadvance_language['amp_workmode_alert_highspeed'];

                if (1 == '<%HW_WEB_GetFeatureSupport(AMP_FT_REMOVE_CROSSWALL);%>')
                {
                    title = cfg_wlancfgadvance_language['amp_workmode_alert_normal'] + '\n'
                            + cfg_wlancfgadvance_language['amp_workmode_alert_highspeed'];
                    document.getElementById('X_HW_WorkMode').remove(1);
                }

                document.getElementById('X_HW_WorkMode').setAttribute('title',title);
            }
			else
			{
			    setDisplay('X_HW_WorkMode' + 'Row', 0);
			}


    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length ; i++) 
    {
        var b = all[i];
        if(b.getAttribute("BindText") == null)
        {
            continue;
        }

        if (cfg_wlancfgadvance_language[b.getAttribute("BindText")]) {
            b.innerHTML = cfg_wlancfgadvance_language[b.getAttribute("BindText")];    
        } else if (cfg_wlancfgother_language[b.getAttribute("BindText")]) {
            b.innerHTML = cfg_wlancfgother_language[b.getAttribute("BindText")];        
        } else if (cfg_wlanzone_language[b.getAttribute("BindText")]) {
            b.innerHTML = cfg_wlanzone_language[b.getAttribute("BindText")];        
        } else {
            ;
        }    
        
        if (true == telmexSpan)
        {
            if (b.getAttribute("BindText") == 'amp_wlan_zone')
            {
                b.innerHTML = cfg_wlancfgadvance_language['amp_wlan_zone_telmex'];
            }
        }    
    }

    LoadWdsConfig();

    if(1 == PccwFlag)
    {    
        if((1 == DoubleFreqFlag)&&('2G' == wlanpage))
        {
            if ((null == Wlan[0]) || (0 == Wlan[0].X_HW_ServiceEnable) || ("ath0" != Wlan[0].name))
            {    
				setDisplay('div_wlanadv', 0); 
            }   
            else
            {                                                                                 
                PccwSetDislayFunc();  
            }
            return;
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
				setDisplay('div_wlanadv', 0);  
            }   
            else
            {                                                                                 
                PccwSetDislayFunc();   
            }
            return;
        }
        else
        {
            if ((null == Wlan[0]) || (0 == Wlan[0].X_HW_ServiceEnable))
            {   
    			setDisplay('div_wlanadv', 0);   
            }   
            else
            {                                                                                 
                PccwSetDislayFunc();  
            }
            return;
        }
    }

    if (1 == AmpTxBeamformingFlag) 
    {
        if ('2G' == wlanpage)
        {
		    setDisplay('GuardIntervalRow', 1); 
            setDisplay('X_TxBFEnabledRow', 0); 
            setDisplay('X_IEEE80211wEnabledRow', 0);
            setDisplay('X_OCCACEnablesRow', 0);  			
        }
        else if ('5G' == wlanpage)
        {
		    setDisplay('GuardIntervalRow', 1); 
            setCheck('X_IEEE80211wEnabled',WlanBasic.X_IEEE80211wEnabled);
            setDisplay('X_IEEE80211wEnabledRow', 1);
            setDisable('X_IEEE80211wEnabled', 1);
            
            setCheck('X_TxBFEnabled',WlanBasic.X_TxBFEnabled);
            setDisplay('X_TxBFEnabledRow', 1); 
            
            setCheck('X_OCCACEnables',WlanBasic.X_OCCACEnables);
            setDisplay('X_OCCACEnablesRow', 1);  
            setDisable('X_OCCACEnables', 1);
        }
    }
    else
    {
        setDisplay('GuardIntervalRow', 0); 
        setDisplay('X_TxBFEnabledRow', 0); 
        setDisplay('X_IEEE80211wEnabledRow', 0);
        setDisplay('X_OCCACEnablesRow', 0);  	
    
    }

    if(0 == fragCap)
    {
    	setDisplay("FragThresholdRow", 0);
    }

    setDisable("RegulatoryDomain", '1' == RegulatoryDomainImmutable);

}

function CancelConfig()
{
    RemoveDropDownListTransmitPower();

	InitWlanBasicDropDownList();

	HWSetTableByLiIdList(wlanadvFormList, TotalWlanAttr, null);
    InitX_HW_RSSIThreshold();
	RebuildWlanBasicDropDownList();
	LoadWdsConfig();    
}


function stInitOption(value, innerText)
{
	this.value = value;
	this.innerText = innerText;
}

function InitDropDownList(id, ArrayOption)
{
    var Control = getElById(id);
    var i = 0;   

    for(i = 0; i < ArrayOption.length; i++)
    {
        var Option = document.createElement("Option");
        Option.value = ArrayOption[i].value;
        Option.innerText = ArrayOption[i].innerText;
        Option.text = ArrayOption[i].innerText;
        Control.appendChild(Option);
    }
}

function InitTransmitPowerList(id)
{
	if(1 == TelMexFlag)
	{
        var ArrayTransmitPower = new Array(new stInitOption("100","100%"), new stInitOption("75","75%"), new stInitOption("50","50%"), new stInitOption("25","25%"));
	}else if (1 == PccwFlag)
	{
        var ArrayTransmitPower = new Array(new stInitOption("100","HongKong"), new stInitOption("80","Europe"), new stInitOption("60","USA"));
		if ("PCCW4MAC" == CfgMode.toUpperCase())
		{
		    var ArrayTransmitPower = new Array(new stInitOption("100","100%"), new stInitOption("80","80%"), new stInitOption("60","60%"), new stInitOption("40","40%"), new stInitOption("20","20%"));
		}
	}else if (1 == AisFlag)
	{
        var ArrayTransmitPower = new Array(new stInitOption("100","Default"), new stInitOption("50","Thailand"));	
	}else
	{
        var ArrayTransmitPower = new Array(new stInitOption("100","100%"), new stInitOption("80","80%"), new stInitOption("60","60%"), new stInitOption("40","40%"), new stInitOption("20","20%"));
	}

    InitDropDownList(id, ArrayTransmitPower);
}

function InitRegulatoryDomainList(id)
{
    if(1 == DoubleFreqFlag)
	{
        var ArrayRegulatoryDomain = new Array(
			new stInitOption("AL", cfg_wlanzone_language['amp_wlanzone_AL']),
			new stInitOption("DZ", cfg_wlanzone_language['amp_wlanzone_DZ']),
			new stInitOption("AR", cfg_wlanzone_language['amp_wlanzone_AR']),
			new stInitOption("AU", cfg_wlanzone_language['amp_wlanzone_AU']),
			new stInitOption("AT", cfg_wlanzone_language['amp_wlanzone_AT']),
			new stInitOption("AZ", cfg_wlanzone_language['amp_wlanzone_AZ']),
			new stInitOption("BH", cfg_wlanzone_language['amp_wlanzone_BH']),
			new stInitOption("BY", cfg_wlanzone_language['amp_wlanzone_BY']),
			new stInitOption("BE", cfg_wlanzone_language['amp_wlanzone_BE']),
			new stInitOption("BA", cfg_wlanzone_language['amp_wlanzone_BA']),
			new stInitOption("BR", cfg_wlanzone_language['amp_wlanzone_BR']),
			new stInitOption("BN", cfg_wlanzone_language['amp_wlanzone_BN']),
			new stInitOption("BG", cfg_wlanzone_language['amp_wlanzone_BG']),
			new stInitOption("CA", cfg_wlanzone_language['amp_wlanzone_CA']),
			new stInitOption("CL", cfg_wlanzone_language['amp_wlanzone_CL']),
			new stInitOption("CN", cfg_wlanzone_language['amp_wlanzone_CN']),
			new stInitOption("CO", cfg_wlanzone_language['amp_wlanzone_CO']),
			new stInitOption("CR", cfg_wlanzone_language['amp_wlanzone_CR']),
			new stInitOption("HR", cfg_wlanzone_language['amp_wlanzone_HR']),
			new stInitOption("CY", cfg_wlanzone_language['amp_wlanzone_CY']),
			new stInitOption("CZ", cfg_wlanzone_language['amp_wlanzone_CZ']),
			new stInitOption("DK", cfg_wlanzone_language['amp_wlanzone_DK']),
			new stInitOption("DO", cfg_wlanzone_language['amp_wlanzone_DO']),
			new stInitOption("EC", cfg_wlanzone_language['amp_wlanzone_EC']),
			new stInitOption("EG", cfg_wlanzone_language['amp_wlanzone_EG']),
			new stInitOption("SV", cfg_wlanzone_language['amp_wlanzone_SV']),
			new stInitOption("EE", cfg_wlanzone_language['amp_wlanzone_EE']),
			new stInitOption("FK", cfg_wlanzone_language['amp_wlanzone_FK']),
			new stInitOption("FI", cfg_wlanzone_language['amp_wlanzone_FI']),
			new stInitOption("FR", cfg_wlanzone_language['amp_wlanzone_FR']),
			new stInitOption("GE", cfg_wlanzone_language['amp_wlanzone_GE']),
			new stInitOption("DE", cfg_wlanzone_language['amp_wlanzone_DE']),
			new stInitOption("GR", cfg_wlanzone_language['amp_wlanzone_GR']),
			new stInitOption("GT", cfg_wlanzone_language['amp_wlanzone_GT']),
			new stInitOption("HN", cfg_wlanzone_language['amp_wlanzone_HN']),
			new stInitOption("HK", cfg_wlanzone_language['amp_wlanzone_HK']),
			new stInitOption("HU", cfg_wlanzone_language['amp_wlanzone_HU']),
			new stInitOption("IS", cfg_wlanzone_language['amp_wlanzone_IS']),
			new stInitOption("IN", cfg_wlanzone_language['amp_wlanzone_IN']),
			new stInitOption("ID", cfg_wlanzone_language['amp_wlanzone_ID']),
			new stInitOption("IR", cfg_wlanzone_language['amp_wlanzone_IR']),
			new stInitOption("IE", cfg_wlanzone_language['amp_wlanzone_IE']),
			new stInitOption("IL", cfg_wlanzone_language['amp_wlanzone_IL']),
			new stInitOption("IT", cfg_wlanzone_language['amp_wlanzone_IT']),
			new stInitOption("JM", cfg_wlanzone_language['amp_wlanzone_JM']),
			new stInitOption("JP", cfg_wlanzone_language['amp_wlanzone_JP']),
			new stInitOption("JO", cfg_wlanzone_language['amp_wlanzone_JO']),
			new stInitOption("KZ", cfg_wlanzone_language['amp_wlanzone_KZ']),
			new stInitOption("KE", cfg_wlanzone_language['amp_wlanzone_KE']),
			new stInitOption("KW", cfg_wlanzone_language['amp_wlanzone_KW']),
			new stInitOption("LV", cfg_wlanzone_language['amp_wlanzone_LV']),
			new stInitOption("LB", cfg_wlanzone_language['amp_wlanzone_LB']),
			new stInitOption("LR", cfg_wlanzone_language['amp_wlanzone_LR']),
			new stInitOption("LI", cfg_wlanzone_language['amp_wlanzone_LI']),
			new stInitOption("LT", cfg_wlanzone_language['amp_wlanzone_LT']),
			new stInitOption("LU", cfg_wlanzone_language['amp_wlanzone_LU']),
			new stInitOption("MO", cfg_wlanzone_language['amp_wlanzone_MO']),
			new stInitOption("MK", cfg_wlanzone_language['amp_wlanzone_MK']),
			new stInitOption("MY", cfg_wlanzone_language['amp_wlanzone_MY']),
			new stInitOption("MT", cfg_wlanzone_language['amp_wlanzone_MT']),
			new stInitOption("MX", cfg_wlanzone_language['amp_wlanzone_MX']),
			new stInitOption("MC", cfg_wlanzone_language['amp_wlanzone_MC']),
			new stInitOption("MA", cfg_wlanzone_language['amp_wlanzone_MA']),
			new stInitOption("NP", cfg_wlanzone_language['amp_wlanzone_NP']),
			new stInitOption("NL", cfg_wlanzone_language['amp_wlanzone_NL']),
			new stInitOption("AN", cfg_wlanzone_language['amp_wlanzone_AN']),
			new stInitOption("NZ", cfg_wlanzone_language['amp_wlanzone_NZ']),
			new stInitOption("NI", cfg_wlanzone_language['amp_wlanzone_NI']),
			new stInitOption("NO", cfg_wlanzone_language['amp_wlanzone_NO']),
			new stInitOption("OM", cfg_wlanzone_language['amp_wlanzone_OM']),
			new stInitOption("PK", cfg_wlanzone_language['amp_wlanzone_PK']),
			new stInitOption("PA", cfg_wlanzone_language['amp_wlanzone_PA']),
			new stInitOption("PG", cfg_wlanzone_language['amp_wlanzone_PG']),
			new stInitOption("PY", cfg_wlanzone_language['amp_wlanzone_PY']),
			new stInitOption("PE", cfg_wlanzone_language['amp_wlanzone_PE']),
			new stInitOption("PH", cfg_wlanzone_language['amp_wlanzone_PH']),
			new stInitOption("PL", cfg_wlanzone_language['amp_wlanzone_PL']),
			new stInitOption("PT", cfg_wlanzone_language['amp_wlanzone_PT']),
			new stInitOption("PR", cfg_wlanzone_language['amp_wlanzone_PR']),
			new stInitOption("QA", cfg_wlanzone_language['amp_wlanzone_QA']),
			new stInitOption("RO", cfg_wlanzone_language['amp_wlanzone_RO']),
			new stInitOption("RU", cfg_wlanzone_language['amp_wlanzone_RU']),
			new stInitOption("SA", cfg_wlanzone_language['amp_wlanzone_SA']),
			new stInitOption("SG", cfg_wlanzone_language['amp_wlanzone_SG']),
			new stInitOption("SK", cfg_wlanzone_language['amp_wlanzone_SK']),
			new stInitOption("SI", cfg_wlanzone_language['amp_wlanzone_SI']),
			new stInitOption("ZA", cfg_wlanzone_language['amp_wlanzone_ZA']),
			new stInitOption("ES", cfg_wlanzone_language['amp_wlanzone_ES']),
			new stInitOption("LK", cfg_wlanzone_language['amp_wlanzone_LK']),
			new stInitOption("SE", cfg_wlanzone_language['amp_wlanzone_SE']),
			new stInitOption("CH", cfg_wlanzone_language['amp_wlanzone_CH']),
			new stInitOption("SY", cfg_wlanzone_language['amp_wlanzone_SY']),
			new stInitOption("TW", cfg_wlanzone_language['amp_wlanzone_TW']),
			new stInitOption("TH", cfg_wlanzone_language['amp_wlanzone_TH']),
			new stInitOption("TT", cfg_wlanzone_language['amp_wlanzone_TT']),
			new stInitOption("TN", cfg_wlanzone_language['amp_wlanzone_TN']),
			new stInitOption("TR", cfg_wlanzone_language['amp_wlanzone_TR']),
			new stInitOption("UA", cfg_wlanzone_language['amp_wlanzone_UA']),
			new stInitOption("AE", cfg_wlanzone_language['amp_wlanzone_AE']),
			new stInitOption("GB", cfg_wlanzone_language['amp_wlanzone_GB']),
			new stInitOption("US", cfg_wlanzone_language['amp_wlanzone_US']),
			new stInitOption("UY", cfg_wlanzone_language['amp_wlanzone_UY']),
			new stInitOption("VE", cfg_wlanzone_language['amp_wlanzone_VE']),
			new stInitOption("VN", cfg_wlanzone_language['amp_wlanzone_VN']),
			new stInitOption("ZW", cfg_wlanzone_language['amp_wlanzone_ZW'])
		);
	}else
	{
        var ArrayRegulatoryDomain = new Array(
			new stInitOption("AL", cfg_wlanzone_language['amp_wlanzone_AL']),
			new stInitOption("DZ", cfg_wlanzone_language['amp_wlanzone_DZ']),
			new stInitOption("AR", cfg_wlanzone_language['amp_wlanzone_AR']),
			new stInitOption("AM", cfg_wlanzone_language['amp_wlanzone_AM']),
			new stInitOption("AU", cfg_wlanzone_language['amp_wlanzone_AU']),
			new stInitOption("AT", cfg_wlanzone_language['amp_wlanzone_AT']),
			new stInitOption("AZ", cfg_wlanzone_language['amp_wlanzone_AZ']),
			new stInitOption("BH", cfg_wlanzone_language['amp_wlanzone_BH']),
			new stInitOption("BY", cfg_wlanzone_language['amp_wlanzone_BY']),
			new stInitOption("BE", cfg_wlanzone_language['amp_wlanzone_BE']),
			new stInitOption("BZ", cfg_wlanzone_language['amp_wlanzone_BZ']),
			new stInitOption("BO", cfg_wlanzone_language['amp_wlanzone_BO']),
			new stInitOption("BA", cfg_wlanzone_language['amp_wlanzone_BA']),
			new stInitOption("BR", cfg_wlanzone_language['amp_wlanzone_BR']),
			new stInitOption("BN", cfg_wlanzone_language['amp_wlanzone_BN']),
			new stInitOption("BG", cfg_wlanzone_language['amp_wlanzone_BG']),
			new stInitOption("CA", cfg_wlanzone_language['amp_wlanzone_CA']),
			new stInitOption("CL", cfg_wlanzone_language['amp_wlanzone_CL']),
			new stInitOption("CN", cfg_wlanzone_language['amp_wlanzone_CN']),
			new stInitOption("CO", cfg_wlanzone_language['amp_wlanzone_CO']),
			new stInitOption("CR", cfg_wlanzone_language['amp_wlanzone_CR']),
			new stInitOption("HR", cfg_wlanzone_language['amp_wlanzone_HR']),
			new stInitOption("CY", cfg_wlanzone_language['amp_wlanzone_CY']),
			new stInitOption("CZ", cfg_wlanzone_language['amp_wlanzone_CZ']),
			new stInitOption("DK", cfg_wlanzone_language['amp_wlanzone_DK']),
			new stInitOption("DO", cfg_wlanzone_language['amp_wlanzone_DO']),
			new stInitOption("EC", cfg_wlanzone_language['amp_wlanzone_EC']),
			new stInitOption("EG", cfg_wlanzone_language['amp_wlanzone_EG']),
			new stInitOption("SV", cfg_wlanzone_language['amp_wlanzone_SV']),
			new stInitOption("EE", cfg_wlanzone_language['amp_wlanzone_EE']),
			new stInitOption("FK", cfg_wlanzone_language['amp_wlanzone_FK']),
			new stInitOption("FI", cfg_wlanzone_language['amp_wlanzone_FI']),
			new stInitOption("FR", cfg_wlanzone_language['amp_wlanzone_FR']),
			new stInitOption("GE", cfg_wlanzone_language['amp_wlanzone_GE']),
			new stInitOption("DE", cfg_wlanzone_language['amp_wlanzone_DE']),
			new stInitOption("GR", cfg_wlanzone_language['amp_wlanzone_GR']),
			new stInitOption("GT", cfg_wlanzone_language['amp_wlanzone_GT']),
			new stInitOption("HN", cfg_wlanzone_language['amp_wlanzone_HN']),
			new stInitOption("HK", cfg_wlanzone_language['amp_wlanzone_HK']),
			new stInitOption("HU", cfg_wlanzone_language['amp_wlanzone_HU']),
			new stInitOption("IS", cfg_wlanzone_language['amp_wlanzone_IS']),
			new stInitOption("IN", cfg_wlanzone_language['amp_wlanzone_IN']),
			new stInitOption("ID", cfg_wlanzone_language['amp_wlanzone_ID']),
			new stInitOption("IR", cfg_wlanzone_language['amp_wlanzone_IR']),
			new stInitOption("IQ", cfg_wlanzone_language['amp_wlanzone_IQ']),
			new stInitOption("IE", cfg_wlanzone_language['amp_wlanzone_IE']),
			new stInitOption("IL", cfg_wlanzone_language['amp_wlanzone_IL']),
			new stInitOption("IT", cfg_wlanzone_language['amp_wlanzone_IT']),
			new stInitOption("JM", cfg_wlanzone_language['amp_wlanzone_JM']),
			new stInitOption("JP", cfg_wlanzone_language['amp_wlanzone_JP']),
			new stInitOption("JO", cfg_wlanzone_language['amp_wlanzone_JO']),
			new stInitOption("KZ", cfg_wlanzone_language['amp_wlanzone_KZ']),
			new stInitOption("KE", cfg_wlanzone_language['amp_wlanzone_KE']),
			new stInitOption("KW", cfg_wlanzone_language['amp_wlanzone_KW']),
			new stInitOption("LV", cfg_wlanzone_language['amp_wlanzone_LV']),
			new stInitOption("LB", cfg_wlanzone_language['amp_wlanzone_LB']),
			new stInitOption("LR", cfg_wlanzone_language['amp_wlanzone_LR']),
			new stInitOption("LI", cfg_wlanzone_language['amp_wlanzone_LI']),
			new stInitOption("LT", cfg_wlanzone_language['amp_wlanzone_LT']),
			new stInitOption("LU", cfg_wlanzone_language['amp_wlanzone_LU']),
			new stInitOption("MO", cfg_wlanzone_language['amp_wlanzone_MO']),
			new stInitOption("MK", cfg_wlanzone_language['amp_wlanzone_MK']),
			new stInitOption("MY", cfg_wlanzone_language['amp_wlanzone_MY']),
			new stInitOption("MT", cfg_wlanzone_language['amp_wlanzone_MT']),
			new stInitOption("MX", cfg_wlanzone_language['amp_wlanzone_MX']),
			new stInitOption("MC", cfg_wlanzone_language['amp_wlanzone_MC']),
			new stInitOption("MA", cfg_wlanzone_language['amp_wlanzone_MA']),
			new stInitOption("NP", cfg_wlanzone_language['amp_wlanzone_NP']),
			new stInitOption("NL", cfg_wlanzone_language['amp_wlanzone_NL']),
			new stInitOption("AN", cfg_wlanzone_language['amp_wlanzone_AN']),
			new stInitOption("NZ", cfg_wlanzone_language['amp_wlanzone_NZ']),
			new stInitOption("NI", cfg_wlanzone_language['amp_wlanzone_NI']),
			new stInitOption("NO", cfg_wlanzone_language['amp_wlanzone_NO']),
			new stInitOption("OM", cfg_wlanzone_language['amp_wlanzone_OM']),
			new stInitOption("PK", cfg_wlanzone_language['amp_wlanzone_PK']),
			new stInitOption("PA", cfg_wlanzone_language['amp_wlanzone_PA']),
			new stInitOption("PG", cfg_wlanzone_language['amp_wlanzone_PG']),
			new stInitOption("PY", cfg_wlanzone_language['amp_wlanzone_PY']),
			new stInitOption("PE", cfg_wlanzone_language['amp_wlanzone_PE']),
			new stInitOption("PH", cfg_wlanzone_language['amp_wlanzone_PH']),
			new stInitOption("PL", cfg_wlanzone_language['amp_wlanzone_PL']),
			new stInitOption("PT", cfg_wlanzone_language['amp_wlanzone_PT']),
			new stInitOption("PR", cfg_wlanzone_language['amp_wlanzone_PR']),
			new stInitOption("QA", cfg_wlanzone_language['amp_wlanzone_QA']),
			new stInitOption("RO", cfg_wlanzone_language['amp_wlanzone_RO']),
			new stInitOption("RU", cfg_wlanzone_language['amp_wlanzone_RU']),
			new stInitOption("SA", cfg_wlanzone_language['amp_wlanzone_SA']),
			new stInitOption("SG", cfg_wlanzone_language['amp_wlanzone_SG']),
			new stInitOption("SK", cfg_wlanzone_language['amp_wlanzone_SK']),
			new stInitOption("SI", cfg_wlanzone_language['amp_wlanzone_SI']),
			new stInitOption("ZA", cfg_wlanzone_language['amp_wlanzone_ZA']),
			new stInitOption("ES", cfg_wlanzone_language['amp_wlanzone_ES']),
			new stInitOption("LK", cfg_wlanzone_language['amp_wlanzone_LK']),
			new stInitOption("SE", cfg_wlanzone_language['amp_wlanzone_SE']),
			new stInitOption("CH", cfg_wlanzone_language['amp_wlanzone_CH']),
			new stInitOption("SY", cfg_wlanzone_language['amp_wlanzone_SY']),
			new stInitOption("TW", cfg_wlanzone_language['amp_wlanzone_TW']),
			new stInitOption("TH", cfg_wlanzone_language['amp_wlanzone_TH']),
			new stInitOption("TT", cfg_wlanzone_language['amp_wlanzone_TT']),
			new stInitOption("TN", cfg_wlanzone_language['amp_wlanzone_TN']),
			new stInitOption("TR", cfg_wlanzone_language['amp_wlanzone_TR']),
			new stInitOption("UA", cfg_wlanzone_language['amp_wlanzone_UA']),
			new stInitOption("AE", cfg_wlanzone_language['amp_wlanzone_AE']),
			new stInitOption("GB", cfg_wlanzone_language['amp_wlanzone_GB']),
			new stInitOption("US", cfg_wlanzone_language['amp_wlanzone_US']),
			new stInitOption("UY", cfg_wlanzone_language['amp_wlanzone_UY']),
			new stInitOption("UZ", cfg_wlanzone_language['amp_wlanzone_UZ']),
			new stInitOption("VE", cfg_wlanzone_language['amp_wlanzone_VE']),
			new stInitOption("VN", cfg_wlanzone_language['amp_wlanzone_VN']),
			new stInitOption("YE", cfg_wlanzone_language['amp_wlanzone_YE']),
			new stInitOption("ZW", cfg_wlanzone_language['amp_wlanzone_ZW'])
		);
	}

    if (IsCaribbeanReg())
    {
        var insertpos = 0;

   		for (i = 0; i < ArrayRegulatoryDomain.length; i++)
    	{
        	if (ArrayRegulatoryDomain[i].value== "CA")
        	{
        		insertpos = i + 1;
				break;
        	}
   		}

		if (insertpos == 0)
		{
			insertpos = ArrayRegulatoryDomain.length;
		}
		
        ArrayRegulatoryDomain.splice(insertpos, 0, new stInitOption("CB", cfg_wlanzone_language['amp_wlanzone_CB']) );
    }

    InitDropDownList(id, ArrayRegulatoryDomain);
}

function InitChannelList(id)
{
    if((1 == DoubleFreqFlag) && ("5G" == wlanpage))
	{
		var ArrayChannel = new Array(new stInitOption("0",cfg_wlancfgadvance_language['amp_chllist_auto']),
									 new stInitOption("36",36), new stInitOption("40",40), new stInitOption("44",44), new stInitOption("48",48), 
									 new stInitOption("52",52), new stInitOption("56",56), new stInitOption("60",60), new stInitOption("64",64), 
									 new stInitOption("100",100), new stInitOption("104",104), new stInitOption("108",108), new stInitOption("112",112), 
									 new stInitOption("116",116), new stInitOption("120",120), new stInitOption("124",124), new stInitOption("128",128), 
									 new stInitOption("132",132), new stInitOption("136",136), new stInitOption("140",140), new stInitOption("144",144), 
									 new stInitOption("149",149), new stInitOption("153",153), new stInitOption("157",157), new stInitOption("161",161), 
									 new stInitOption("165",165));	
	}
	else
	{
		var ArrayChannel = new Array(new stInitOption("0",cfg_wlancfgadvance_language['amp_chllist_auto']),
									 new stInitOption("1",1), new stInitOption("2",2), new stInitOption("3",3), new stInitOption("4",4), 
									 new stInitOption("5",5), new stInitOption("6",6), new stInitOption("7",7), new stInitOption("8",8), 
									 new stInitOption("9",9), new stInitOption("10",10), new stInitOption("11",11), new stInitOption("12",12), 
									 new stInitOption("13",13), new stInitOption("14",14));
	}

    InitDropDownList(id, ArrayChannel);
}

function InitChannelWidthList(id)
{
	if(CfgMode.toUpperCase() == 'ANTEL')
	{
        var ArrayChannelWidth = new Array(new stInitOption("1",cfg_wlancfgadvance_language['amp_chlwidth_20']),
										  new stInitOption("2",cfg_wlancfgadvance_language['amp_chlwidth_40']));
	}else
	{
		if((1 == Wlan11acFlag) && (1 == DoubleFreqFlag) && ("5G" == wlanpage) && (WlanBasic.X_HW_Standard == "11ac"))
		{
            var ArrayChannelWidth = new Array(new stInitOption("0",cfg_wlancfgadvance_language['amp_chlwidth_auto2040']), 
											  new stInitOption("1",cfg_wlancfgadvance_language['amp_chlwidth_20']), 
											  new stInitOption("2",cfg_wlancfgadvance_language['amp_chlwidth_40']),
											  new stInitOption("3",cfg_wlancfgadvance_language[chlwidth80Res]));
		}else
		{
            var ArrayChannelWidth = new Array(new stInitOption("0",cfg_wlancfgadvance_language['amp_chlwidth_auto2040']), 
											  new stInitOption("1",cfg_wlancfgadvance_language['amp_chlwidth_20']), 
											  new stInitOption("2",cfg_wlancfgadvance_language['amp_chlwidth_40']));
		}
    }

    InitDropDownList(id, ArrayChannelWidth);
}

function InitHwStandardList(id)
{
    var ArrayHwStandard = new Array(new stInitOption("11a","802.11a"), new stInitOption("11na","802.11a/n"), new stInitOption("11ac","802.11a/n/ac"), 
	 								new stInitOption("11b","802.11b"), new stInitOption("11g","802.11g"), new stInitOption("11n","802.11n"),
									new stInitOption("11bg","802.11b/g"), new stInitOption("11bgn","802.11b/g/n"));
    InitDropDownList(id, ArrayHwStandard);
}

function InitHwWorkModeList(id)
{
    var ArrayHwWorkMode = new Array(new stInitOption("0",cfg_wlancfgadvance_language['amp_workmode_normal']), 
									new stInitOption("1",cfg_wlancfgadvance_language['amp_workmode_crosswall']), 
									new stInitOption("2",cfg_wlancfgadvance_language['amp_workmode_highspeed']));
    InitDropDownList(id, ArrayHwWorkMode);
}

function InitGuardInterval(id)
{
    var wlgmcs = WiFiRadio.GuardInterval; 
    var len = document.forms[0].GuardInterval.options.length;  
	
    for (i = 0; i < len; i++)
    {
        document.forms[0].GuardInterval.remove(0);
    }
	
    var ArrayGuardInterval = new Array(new stInitOption("Auto",cfg_wlancfgadvance_language['amp_shortgi_auto']), 
		                               new stInitOption("400nsec","400nsec"), 
		                               new stInitOption("800nsec","800nsec"));
    InitDropDownList(id, ArrayGuardInterval);
	
    setSelect('GuardInterval',wlgmcs);
}

function InitX_HW_RSSIThreshold()
{
    setCheck('X_HW_RSSIThresholdEnable', WlanBasic.X_HW_RSSIThresholdEnable);
    setText('X_HW_RSSIThreshold', WlanBasic.X_HW_RSSIThreshold);
    
    if (1 == RSSIThrFlag)
    {
        setDisplay('X_HW_RSSIThresholdEnable' + 'Row', 1);
        setDisplay('X_HW_RSSIThreshold' + 'Row', WlanBasic.X_HW_RSSIThresholdEnable);
        document.getElementById('X_HW_RSSIThreshold').setAttribute('title',cfg_wlancfgadvance_language['amp_wlan_rssithreshold_alert']);
    }
    else
    {
        setDisplay('X_HW_RSSIThresholdEnable' + 'Row', 0);
        setDisplay('X_HW_RSSIThreshold' + 'Row', 0);
    }
}

function InitWlanBasicDropDownList()
{
	InitHwWorkModeList("X_HW_WorkMode");
	InitTransmitPowerList("TransmitPower");
	InitRegulatoryDomainList("RegulatoryDomain");
	InitChannelList("Channel");
	InitChannelWidthList("X_HW_HT20");
	InitHwStandardList("X_HW_Standard");
}
function wdsIsMacAddrRepeat()
{
    var aucMac = new Array();
    var i = 0;
    var j = 0;
    
    aucMac[0] = getValue('wds_Ap1_BSSID');
    aucMac[1] = getValue('wds_Ap2_BSSID');
    aucMac[2] = getValue('wds_Ap3_BSSID');
    aucMac[3] = getValue('wds_Ap4_BSSID');
    
    for (i = 0; i < 4; i++)
    {
        for (j= i + 1; j < 4; j++)
        {
            if ( (17 == aucMac[i].length) && (17 == aucMac[j].length) )
            {
                if (aucMac[i].toLowerCase() == aucMac[j].toLowerCase())
                {
                    return true;
                }
            }
        }
    }
    
    return false;
}


function wdsIsMacAddrInvalid(Mac)
{
    var loop = 0;
    
    if ((0 != Mac.length) && (17 != Mac.length))
    {
        return true;
    }
    
    if (17 == Mac.length)
    {
        for (loop = 0; loop < 17; loop++)
        {
            if (0 == (1 + loop)%3)
            {
                if (':' != Mac.charAt(loop))
                {
                    return true;
                }
            }
            else
            {
                if ( (('0' <= Mac.charAt(loop)) && ('9' >= Mac.charAt(loop))) || (('a' <= Mac.charAt(loop)) && ('f' >= Mac.charAt(loop))) || (('A' <= Mac.charAt(loop)) && ('F' >= Mac.charAt(loop))) )
                {
                    continue;
                }
                else
                {
                    return true;
                }
            }
        }
    }

    return false;
}


function AddSubmitParam(Form,type)
{
    
    if (getSelectVal('Channel') == 0)
    {
        Form.addParameter('y.Channel',getSelectVal('Channel'));
        Form.addParameter('y.AutoChannelEnable',1); 
    }
    else
    {
        Form.addParameter('y.Channel',getSelectVal('Channel'));
        Form.addParameter('y.AutoChannelEnable',0);
    }

    Form.addParameter('y.X_HW_HT20',getSelectVal('X_HW_HT20'));

    if('1' != RegulatoryDomainImmutable)
    {
        Form.addParameter('y.RegulatoryDomain',getSelectVal('RegulatoryDomain'));
    }
    
    Form.addParameter('y.TransmitPower',getSelectVal('TransmitPower'));      
    Form.addParameter('y.X_HW_Standard',getSelectVal('X_HW_Standard'));
    if ('1' == AmpTxBeamformingFlag) 
    {
        Form.addParameter('r.GuardInterval',getSelectVal('GuardInterval'));  
        Form.addParameter('y.X_TxBFEnabled',getCheckVal('X_TxBFEnabled'));
    }
	var wlgmode = getSelectVal('X_HW_Standard'); 
	
    if('1' == ShowMCSFlag && ((curUserType != sptUserType)) && (('11na' == wlgmode) || ('11ac' == wlgmode)))
    {
        Form.addParameter('y.X_HW_MCS',getSelectVal('X_HW_MCS'));
    }
    
	if ((2 == curWlanChipType) && (1 == '<%HW_WEB_GetFeatureSupport(AMP_FT_WIFI_WORK_MODE);%>'))
    {
        Form.addParameter('y.X_HW_WorkMode',getSelectVal('X_HW_WorkMode'));
    }
	
    if (WlanBasic.X_HW_Standard != getSelectVal('X_HW_Standard'))
    {
        if ((0 == DoubleFreqFlag) || ("2G" == wlanpage))
        {
            if (0 < uiBandIncludeWifiCoverSsid)
            {
                if (false == ConfirmEx(cfg_wificover_adv_language['amp_wificover_ssid_glb_notify'])) 
                {
                    uiBandIncludeWifiCoverSsid = 0;
                    setDisable('applyButton', 1);
                    setDisable('cancelButton', 1);                
                    return;
                }
            }
        }
    }

    Form.addParameter('x.DtimPeriod',getValue('DtimPeriod'));
    Form.addParameter('x.BeaconPeriod',getValue('BeaconPeriod'));
    Form.addParameter('x.RTSThreshold',getValue('RTSThreshold'));
    Form.addParameter('x.FragThreshold',getValue('FragThreshold'));

    if (1 == RSSIThrFlag)
    {
        Form.addParameter('y.X_HW_RSSIThreshold', parseInt(getValue('X_HW_RSSIThreshold'), 10));
        Form.addParameter('y.X_HW_RSSIThresholdEnable', parseInt(getCheckVal('X_HW_RSSIThresholdEnable'), 10));
    }
    
    if (1 == WdsFlag)
    {
        var wdsCheckValue = getCheckVal('wds_Enable');
        if (wdsCheckValue == 1)
        {
            Form.addParameter('m.Enable',wdsCheckValue);
            Form.addParameter('n.BSSID',getValue('wds_Ap1_BSSID').toUpperCase());
            Form.addParameter('o.BSSID',getValue('wds_Ap2_BSSID').toUpperCase());
            Form.addParameter('p.BSSID',getValue('wds_Ap3_BSSID').toUpperCase());
            Form.addParameter('q.BSSID',getValue('wds_Ap4_BSSID').toUpperCase());
            
            if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
            {
                Form.setAction('set.cgi?x=' + WlanBasic.domain + '.X_HW_AdvanceConf'		 
					       + '&y=' + WlanBasic.domain
                           + '&m=' + WlanBasic.domain + '.X_HW_WDS'
                           + '&n=' + WlanBasic.domain + '.X_HW_WDS.ClientAP.1'
                           + '&o=' + WlanBasic.domain + '.X_HW_WDS.ClientAP.2'
                           + '&p=' + WlanBasic.domain + '.X_HW_WDS.ClientAP.3'
                           + '&q=' + WlanBasic.domain + '.X_HW_WDS.ClientAP.4'                           
                           + '&RequestFile=html/amp/wlanadv/WlanAdvance.asp');
            }
            else
            {
                Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_AdvanceConf'
                           + '&y=' + WlanBasic.domain
                           + '&m=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS'
                           + '&n=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.1'
                           + '&o=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.2'
                           + '&p=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.3'
                           + '&q=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.4'
                           + '&RequestFile=html/amp/wlanadv/WlanAdvance.asp');
            }            
        }
        else
        {
            Form.addParameter('m.Enable',wdsCheckValue);

            if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
            {
                Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_AdvanceConf'
                           + '&y=' + WlanBasic.domain
                           + '&m=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS'
                           + '&RequestFile=html/amp/wlanadv/WlanAdvance.asp');
            }
            else
            {
                Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_AdvanceConf'
                           + '&y=' + WlanBasic.domain
                           + '&m=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS'
                           + '&RequestFile=html/amp/wlanadv/WlanAdvance.asp');
            }
        }

    }
    else
    {
        if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
        {
            Form.setAction('set.cgi?x=' + WlanBasic.domain + '.X_HW_AdvanceConf'
                       + '&y=' + WlanBasic.domain
                       + '&r=' + WiFiRadio.domain
                       + '&RequestFile=html/amp/wlanadv/WlanAdvance.asp');
        }
        else
        {
            Form.setAction('set.cgi?x=' + WlanBasic.domain + '.X_HW_AdvanceConf'
                       + '&y=' + WlanBasic.domain
                       + '&r=' + WiFiRadio.domain
                       + '&RequestFile=html/amp/wlanadv/WlanAdvance.asp');
        }
    }

    setDisable('applyButton', 1);
    setDisable('cancelButton', 1);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    
}

function CheckForm(type)
{

        if((getSelectVal('TransmitPower') == "") || (getSelectVal('RegulatoryDomain') == "") || (getSelectVal('Channel') == "") 
        || (getSelectVal('X_HW_Standard') == "") || (getSelectVal('X_HW_HT20') == ""))
        {
              AlertEx(cfg_wlancfgother_language['amp_basic_empty']);
                   return false;
        }
		
		if((1 == PccwFlag) && (1 == DoubleFreqFlag) && ("PCCW4MAC" != CfgMode.toUpperCase()))
            {
                var pccw_TxPwr = getSelectVal('TransmitPower');
                if( pccw_TxPwr != WlanBasic.TransmitPower)
                {
                    AlertEx(cfg_wlancfgother_language['amp_wlancfg_resetvalid']);
                }
            }

        var dtimPeriod = getValue('DtimPeriod');
        var beaconPeriod = getValue('BeaconPeriod');
        var rtsThreshold = getValue('RTSThreshold');
        var fragThreshold = getValue('FragThreshold'); 
        var RSSIThreshold = getValue('X_HW_RSSIThreshold');
        
        if((dtimPeriod == "") || (beaconPeriod == "")
           || (rtsThreshold == "") || (fragThreshold == ""))
        {
            AlertEx(cfg_wlancfgother_language['amp_advance_empty']);
            return false;
        }

        if(!isPlusInteger(dtimPeriod))
        {
            AlertEx(cfg_wlancfgadvance_language['amp_dtimtime_int']);
            return false;
        }
        else
        {
            if((parseInt(dtimPeriod,10) < 1) || (parseInt(dtimPeriod,10) > 255))
            {
                AlertEx(cfg_wlancfgadvance_language['amp_dtimtime_range']);
                return false;
            }
        }           
        
        if(!isPlusInteger(beaconPeriod))
        {
            AlertEx(cfg_wlancfgadvance_language['amp_beacon_int']);
            return false;
        }
        else
        {
            if((parseInt(beaconPeriod,10) < 20) || (parseInt(beaconPeriod,10) > 1000))
            {
                AlertEx(cfg_wlancfgadvance_language['amp_beacon_range']);
                return false;
            }
        }       
        
        if(!isPlusInteger(rtsThreshold))
        {
            AlertEx(cfg_wlancfgadvance_language['amp_rts_int']);
            return false;
        }
        else
        {
            if((parseInt(rtsThreshold,10) < 1) || (parseInt(rtsThreshold,10) > 2346))
            {
                AlertEx(cfg_wlancfgadvance_language['amp_rts_range']);
                return false;
            }
        }
        
        if(!isPlusInteger(fragThreshold))
        {
            AlertEx(cfg_wlancfgadvance_language['amp_frag_int']);
            return false;
        }
        else
        {
            if((parseInt(fragThreshold,10) < 256) || (parseInt(fragThreshold,10) > 2346))
            {
                AlertEx(cfg_wlancfgadvance_language['amp_frag_range']);
                return false;
            }
        }
    if (1 == RSSIThrFlag)
    {
        if(RSSIThreshold == "")
        {
            AlertEx(cfg_wlancfgother_language['amp_advance_empty']);
            return false;
        }

        if(!isInteger(RSSIThreshold))
        {
            AlertEx(cfg_wlancfgadvance_language['amp_wlan_rssithreshold_int']);
            return false;
        }
        else
        {
            if((parseInt(RSSIThreshold, 10) < -95) || (parseInt(RSSIThreshold, 10) > -75))
            {
                AlertEx(cfg_wlancfgadvance_language['amp_wlan_rssithreshold_range']);
                return false;
            }
        }
    }
    
    if ((1 == DoubleFreqFlag) || (4 == curWlanChipType))
    {
        var country = getSelectVal('RegulatoryDomain');
        if( country != WlanBasic.RegulatoryDomain)
        {
            AlertEx(cfg_wlancfgother_language['amp_wlancfg_resetvalid']);
        }
    }  

    if (1 == WdsFlag)
    {
        if (1 == getCheckVal('wds_Enable'))
        {
            if (wdsIsMacAddrInvalid(getValue('wds_Ap1_BSSID')) || wdsIsMacAddrInvalid(getValue('wds_Ap2_BSSID')) || wdsIsMacAddrInvalid(getValue('wds_Ap3_BSSID')) || wdsIsMacAddrInvalid(getValue('wds_Ap4_BSSID')))
            {
                AlertEx(cfg_wlancfgadvance_language['amp_wds_address_invalid']);
                return false;
            }

            if (wdsIsMacAddrRepeat())
            {
                AlertEx(cfg_wlancfgadvance_language['amp_wds_address_repeat']);
                return false;
            }
        }
    }
    if(!isWlanInitFinished(wlanpage, WlanBasic.X_HW_Standard, WlanBasic.X_HW_HT20))
    {
        return false;
    }
    
    return true;
}

</script>
</head>
<body class="mainbody" onLoad="LoadFrameWifi();">
<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"><tr> <td></td></tr></table> 
<script language="JavaScript" type="text/javascript">
var wlanadv_note = ""; 
var wlanadv_header = ""; 
if((1 == DoubleFreqFlag) && ("2G" == wlanpage))
{
	wlanadv_note = cfg_wlancfgother_language['amp_wlanadvance_title_2G'];
	wlanadv_header = cfg_wlancfgadvance_language['amp_wlan_advance_header_2G'];
}
else if((1 == DoubleFreqFlag) && ("5G" == wlanpage))
{
	wlanadv_note = cfg_wlancfgother_language['amp_wlanadvance_title_5G'];
	wlanadv_header = cfg_wlancfgadvance_language['amp_wlan_advance_header_5G'];
}
else
{
	wlanadv_note = cfg_wlancfgother_language['amp_wlanadvance_title'];
	wlanadv_header = cfg_wlancfgadvance_language['amp_wlan_advance_header'];
}

if (1 == PccwFlag)
{
	wlanadv_note = cfg_wlancfgother_language['amp_wlanadvance_title_pccw'];
}

var WlanAdvSummaryArray = new Array(new stSummaryInfo("text",wlanadv_note),
                                    new stSummaryInfo("img","../../../images/icon_01.gif", GetDescFormArrayById(cfg_wlancfgother_language, "amp_wlan_note1")),
                                    new stSummaryInfo("text",GetDescFormArrayById(cfg_wlancfgother_language, "amp_wlan_note")),
                                    null);
HWCreatePageHeadInfo("wlanadvsummary", wlanadv_header, WlanAdvSummaryArray, true);
</script>

<div class="title_spread"></div>

<div id='div_wlanadv'>  

<table id="wlanadv_head" width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_head"> 
<tr><td class="func_title" BindText="amp_wlan_advance"></td></tr>
</table> 

<form id="wlanadvForm">
<table id="wlanadv" class="tabal_noborder_bg" width="100%" cellspacing="1" cellpadding="0"> 
<li  id="X_HW_WorkMode"    RealType="DropDownList"  DescRef="amp_wlan_workmode"   	 RemarkRef="Empty"   				ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.X_HW_WorkMode"    InitValue="Empty"/>
<li  id="TransmitPower"    RealType="DropDownList"  DescRef="amp_tx_power"      	 RemarkRef="Empty"   				ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.TransmitPower"    InitValue="Empty"/>
<li  id="RegulatoryDomain" RealType="DropDownList"  DescRef="amp_wlan_zone"     	 RemarkRef="Empty"   				ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.RegulatoryDomain" InitValue="Empty" ClickFuncApp="onChange=RegulatoryDomainChange"/>
<li  id="Channel"          RealType="DropDownList"  DescRef="amp_wlan_channel"  	 RemarkRef="Empty"   				ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.Channel"       	 InitValue="Empty" ClickFuncApp="onChange=ChannelChange"/>
<li  id="X_HW_HT20"        RealType="DropDownList"  DescRef="amp_channel_width" 	 RemarkRef="Empty"   				ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.X_HW_HT20"        InitValue="Empty" ClickFuncApp="onChange=X_HW_HT20Change"/>
<li  id="X_HW_Standard"    RealType="DropDownList"  DescRef="amp_channel_mode"	 	 RemarkRef="Empty"   				ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.X_HW_Standard"    InitValue="Empty" ClickFuncApp="onChange=X_HW_StandardChange"/>
<li  id="X_HW_MCS"    	   RealType="DropDownList"  DescRef="amp_mcs_rate"	 	     RemarkRef="Empty"   				ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.X_HW_MCS"         InitValue="Empty" />

<li  id="GuardInterval"    RealType="DropDownList"  DescRef="amp_wlan_guardinterval"   	 RemarkRef="Empty"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="r.GuardInterval"    InitValue="Empty"/>
<li  id="X_IEEE80211wEnabled"  RealType="CheckBox"   DescRef="amp_ieee80211w"	     RemarkRef="Empty"          ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.X_IEEE80211wEnabled"    InitValue="Empty" />
<li  id="X_TxBFEnabled"    RealType="CheckBox"      DescRef="amp_tx_beamforming"	 RemarkRef="Empty"                  ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.X_TxBFEnabled"    InitValue="Empty" />
<li  id="X_OCCACEnables"    RealType="CheckBox"     DescRef="amp_occac"	             RemarkRef="Empty"                  ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.X_OCCACEnables"    InitValue="Empty" />

<li  id="DtimPeriod"       RealType="TextBox"       DescRef="amp_dtim_time"          RemarkRef="amp_dtim_timenote"   	ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.DtimPeriod"    InitValue="Empty" />
<li  id="BeaconPeriod"     RealType="TextBox"       DescRef="amp_beacon_time"        RemarkRef="amp_beacon_timenote"   	ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.BeaconPeriod"  InitValue="Empty" />
<li  id="RTSThreshold"     RealType="TextBox"       DescRef="amp_rts_threshold"      RemarkRef="amp_rts_thresholdnote"  ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.RTSThreshold"  InitValue="Empty" />
<li  id="FragThreshold"    RealType="TextBox"       DescRef="amp_frag_threshold"	 RemarkRef="amp_frag_thresholdnote" ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.FragThreshold" InitValue="Empty" />

<li  id="X_HW_RSSIThresholdEnable"    RealType="CheckBox"     DescRef="amp_wlan_rssithreshold_enable"	 RemarkRef="Empty"                          ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.X_HW_RSSIThresholdEnable"    InitValue="Empty" ClickFuncApp="onClick=X_HW_RSSIThresholdEnableClick"/>
<li  id="X_HW_RSSIThreshold"          RealType="TextBox"      DescRef="amp_wlan_rssithreshold"	         RemarkRef="amp_wlan_rssithreshold_note"    ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.X_HW_RSSIThreshold"          InitValue="Empty" />

<li  id="wds_Enable"       RealType="CheckBox"      DescRef="amp_wds_enable"         RemarkRef="amp_wds_notes"   		ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"       InitValue="Empty" ClickFuncApp="onClick=WdsClickFunc"/>
<li  id="X_HW_WlanMac"     RealType="HtmlText"      DescRef="amp_wds_address_master" RemarkRef="Empty"   				ErrorMsgRef="Empty"    Require="FALSE"    BindField="X_HW_WlanMac"    InitValue="Empty"/>
<li  id="wds_Ap1_BSSID"    RealType="TextBox"       DescRef="amp_wds_address_ap1"    RemarkRef="amp_wds_address_demo"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"       InitValue="Empty"/>
<li  id="wds_Ap2_BSSID"    RealType="TextBox"       DescRef="amp_wds_address_ap2"    RemarkRef="amp_wds_address_demo"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"       InitValue="Empty"/>
<li  id="wds_Ap3_BSSID"    RealType="TextBox"       DescRef="amp_wds_address_ap3"    RemarkRef="amp_wds_address_demo"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"       InitValue="Empty"/>
<li  id="wds_Ap4_BSSID"    RealType="TextBox"       DescRef="amp_wds_address_ap4"    RemarkRef="amp_wds_address_demo"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"       InitValue="Empty"/>
</table>
<script>
var wlanadvFormList = HWGetLiIdListByForm("wlanadvForm", null);
var TableClass = new stTableClass("width_per30", "width_per70", "", "StyleSelect");
HWParsePageControlByID("wlanadvForm", TableClass ,cfg_wlancfgadvance_language, null);

InitWlanBasicDropDownList();
HWSetTableByLiIdList(wlanadvFormList, TotalWlanAttr, null);
RebuildWlanBasicDropDownList();
LoadWdsConfig();
setDisplay('X_HW_MCS' + 'Row', 0);
setDisplay('GuardIntervalRow', 0); 
setDisplay('X_TxBFEnabledRow', 0); 
setDisplay('X_IEEE80211wEnabledRow', 0);
setDisplay('X_OCCACEnablesRow', 0);
setDisplay('X_HW_RSSIThresholdEnable' + 'Row', 0);
setDisplay('X_HW_RSSIThreshold' + 'Row', 0);

</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
<tr>
    <td class="table_submit width_per25"></td>
    <td class="table_submit"> 
    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
    <button id="applyButton" name="applyButton" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="Submit();"><script>document.write(cfg_wlancfgother_language['amp_wlancfg_apply']);</script></button>
    <button id="cancelButton" name="cancelButton" type="button" class="CancleButtonCss buttonwidth_100px" onClick="CancelConfig();"><script>document.write(cfg_wlancfgother_language['amp_wlancfg_cancel']);</script></button>
    </td>
</tr>
</table>

</form>
<table width="100%" border="0" cellspacing="5" cellpadding="0">
<tr ><td class="height10p"></td></tr>
</table>
</div>

</body>
</html>

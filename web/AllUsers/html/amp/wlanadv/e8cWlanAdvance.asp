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
<title>wireless advance configure</title>
<script language="JavaScript" type="text/javascript">

var Wlan11acFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_11AC);%>';
var WdsFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WDS);%>';
var WiFiPowerFixFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WIFI_POWER_FIX);%>';

var wlanpage;
if (location.href.indexOf("e8cWlanAdvance.asp?") > 0)
{
    wlanpage = location.href.split("?")[1]; 
    top.WlanAdvancePage = wlanpage;
}

wlanpage = top.WlanAdvancePage;     

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

var enbl = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>';

var Wlan = new Array();

var WlanArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|SSIDAdvertisementEnabled|X_HW_AssociateNum|WMMEnable|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WEPKeyIndex|WEPEncryptionLevel|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|X_HW_GroupRekey|X_HW_RadiuServer|X_HW_RadiusPort|X_HW_RadiusKey|X_HW_ServiceEnable,stWlan);%>;

var wlanArrLen = WlanArr.length - 1;

for (i=0; i < wlanArrLen; i++)
{
    Wlan[i] = new stWlan();
    Wlan[i] = WlanArr[i];
}

if (1 == DoubleFreqFlag)
{
	wlanArrLen++;
}

var hide = cfg_wlancfgdetail_language['amp_bcastssid_help'];
var wmm = cfg_wlancfgdetail_language['amp_vmm_help'];
var authmode = cfg_wlancfgdetail_language['amp_authmode_help'];
var encryption = cfg_wlancfgdetail_language['amp_encrypt_help'];
var ssid = cfg_wlancfgdetail_language['amp_ssid_help'];
var deviceNumber = cfg_wlancfgdetail_language['amp_devnum_help'];

function stWlanWifi(domain,name,enable,ssid,mode,channel,power,Country,AutoChannelEnable,channelWidth,PossibleChannels, Advertisement)
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
    this.PossibleChannels = PossibleChannels;
	this.Advertisement = Advertisement;
}

var WlanWifiArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|X_HW_Standard|Channel|TransmitPower|RegulatoryDomain|AutoChannelEnable|X_HW_HT20|PossibleChannels|SSIDAdvertisementEnabled,stWlanWifi);%>;
var WlanWifi = WlanWifiArr[0];
if (null == WlanWifi)
{
	WlanWifi = new stWlanWifi("","","","","11n","","","","","","", "");
}

var GuardInterval = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WiFi.Radio.1.GuardInterval);%>';

var WdsMasterMac = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_WlanMac);%>';
if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
{
    WdsMasterMac = '<%HW_WEB_GetWlanMac_5G();%>';
}

var uiFirstIndexFor5G = 0;
function WlanWifiInitFor5G()
{
    for (i=0; i < wlanArrLen; i++)
    {
        if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
        {
            if ('ath4' == WlanArr[i].name)
            {
                uiFirstIndexFor5G = i;        
                WlanWifi = WlanWifiArr[uiFirstIndexFor5G];

                return;
            }
        }
    }
}

function getWlanPortNumber(name)
{
    var length = name.length;
    var number;
    var str = parseInt(name.charAt(length-1));
    return str;
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

function loadChannelListByFreq(freq, country, mode, width)
{
    var len = document.forms[0].WlanChannel_select.options.length;
    var index = 0;
    var i;
    var WebChannel = getSelectVal('WlanChannel_select');
    var WebChannelValid = 0;    

    getPossibleChannels(freq, country, mode, width);
    var ShowChannels = possibleChannels.split(',');

    for (i = 0; i < len; i++)
    {
        document.forms[0].WlanChannel_select.remove(0);
    }

    document.forms[0].WlanChannel_select[0] = new Option(cfg_wlancfgadvance_language['amp_chllist_auto'], "0");
    
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
        document.forms[0].WlanChannel_select[j] = new Option(ShowChannels[j-1], ShowChannels[j-1]);
    }

    if (1 == WebChannelValid)
    {
        setSelect('WlanChannel_select', WebChannel);
    }
    else
    {
        setSelect('WlanChannel_select', 0);    
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

function ChannelChange()
{
}

function ChannelWidthChange()
{
    loadChannelList(WlanWifi.RegulatoryDomain, WlanWifi.mode, getSelectVal('WlanBandWidth_select'));
}

function WifiAdvanceShow(enable)
{
    if (enable == 1)
    {
		WlanWifiInitFor5G();

		loadChannelList(WlanWifi.RegulatoryDomain,WlanWifi.mode, WlanWifi.channelWidth);

		setDisplay('wifiCfg',1);
		setSelect('WlanTransmit_select',WlanWifi.power);
		if (WlanWifi.AutoChannelEnable == 1)
		{
			setSelect('WlanChannel_select',0);
		}
		else
		{   
			setSelect('WlanChannel_select',WlanWifi.channel);
		}
		setSelect('WlanBandWidth_select',WlanWifi.channelWidth);
		if (1 == WlanWifi.Advertisement)
		{
			setCheck('WlanHide_checkbox', 0);
		}
		else
		{
			setCheck('WlanHide_checkbox', 1);
		}

		if ('800nsec' == GuardInterval)
		{
			setSelect('WlanInterval_select', '800nsec');
		}
		else
		{
			setSelect('WlanInterval_select', '400nsec');
		}

        if ((WlanWifi.mode == "11b") || (WlanWifi.mode == "11g") || (WlanWifi.mode == "11bg") || (WlanWifi.mode == "11a"))
        {    
            var len = document.forms[0].WlanBandWidth_select.options.length;
            for (i = 0; i < len; i++)
            {
                document.forms[0].WlanBandWidth_select.remove(0);
            }
            document.forms[0].WlanBandWidth_select[0] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_20'], "1");
        }

    }
    else
    {
        setDisplay('wifiCfg',0);
    }
}

function stWdsClientAp(domain, BSSID)
{
    this.domain = domain;
    this.BSSID = BSSID;
}

function WdsClickFunc()
{
	if (0 == getCheckVal('wds_enable'))
	{
        setDisplay('div_wds_mac', 0);
	}
	else
	{
        setDisplay('div_wds_mac', 1);
	}
}

function LoadWdsConfig()
{
    if (1 == WdsFlag)
    {
        var WdsEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.Enable);%>';
        var WdsClientApMacAddr = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.{i}, BSSID, stWdsClientAp);%>;

        if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
        {
            WdsClientApMacAddr = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.ClientAP.{i}, BSSID, stWdsClientAp);%>;
            WdsEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.Enable);%>';
        }

        setCheck('wds_enable', WdsEnable);
        setText('wds_text_ap1', WdsClientApMacAddr[0].BSSID);
        setText('wds_text_ap2', WdsClientApMacAddr[1].BSSID);
        setText('wds_text_ap3', WdsClientApMacAddr[2].BSSID);
        setText('wds_text_ap4', WdsClientApMacAddr[3].BSSID);

        getElById("div_wds_config").style.display = ""; 
        
        if (0 == WdsEnable)
        {
            setDisplay('div_wds_mac', 0);
        }
    }
    else
    {
    	getElById("div_wds_config").style.display = "none"; 
    }
}

function LoadFrameWifi()
{
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
            WifiAdvanceShow(enbl != "0");
        }
    }
    else       
    {
        WifiAdvanceShow((enbl != "0") && (uiTotalNum > 0));
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

	if(WiFiPowerFixFlag == "1")
	{
		setDisable('WlanTransmit_select', 1);
	}	

	LoadWdsConfig();		
    
    getElById("AdvanceConfig").style.display = ""; 
}

function CancelConfig()
{
    LoadFrameWifi();
}

function wdsIsMacAddrRepeat()
{
	var aucMac = new Array();
	var i = 0;
	var j = 0;
	
	aucMac[0] = getValue('wds_text_ap1');
	aucMac[1] = getValue('wds_text_ap2');
	aucMac[2] = getValue('wds_text_ap3');
	aucMac[3] = getValue('wds_text_ap4');
	
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
    if (getSelectVal('WlanChannel_select') == 0)
    {
        Form.addParameter('y.Channel',getSelectVal('WlanChannel_select'));
        Form.addParameter('y.AutoChannelEnable',1); 
    }
    else
    {
        Form.addParameter('y.Channel',getSelectVal('WlanChannel_select'));
        Form.addParameter('y.AutoChannelEnable',0);
    }

    Form.addParameter('y.X_HW_HT20',getSelectVal('WlanBandWidth_select')); 
    Form.addParameter('y.TransmitPower',getSelectVal('WlanTransmit_select'));

	if (1 == getCheckVal('WlanHide_checkbox'))
	{
		Form.addParameter('y.SSIDAdvertisementEnabled',0);
	}
	else
	{
		Form.addParameter('y.SSIDAdvertisementEnabled',1);
	}
	
	Form.addParameter('z.GuardInterval', getSelectVal('WlanInterval_select'));

	url = 'set.cgi?z=InternetGatewayDevice.LANDevice.1.WiFi.Radio.1';

    if (1 == WdsFlag)
    {
	    var wdsCheckValue = getCheckVal('wds_enable');
	    if (wdsCheckValue == 1)
		{
		    Form.addParameter('m.Enable',wdsCheckValue);
			Form.addParameter('n.BSSID',getValue('wds_text_ap1'));
			Form.addParameter('o.BSSID',getValue('wds_text_ap2'));
			Form.addParameter('p.BSSID',getValue('wds_text_ap3'));
			Form.addParameter('q.BSSID',getValue('wds_text_ap4'));
			
            if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
            {
				url += '&y=' + WlanWifi.domain
                           + '&m=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS'
                           + '&n=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.ClientAP.1'
                           + '&o=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.ClientAP.2'
                           + '&p=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.ClientAP.3'
                           + '&q=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.ClientAP.4';
            }
            else
            {
				url += '&y=' + WlanWifi.domain
                           + '&m=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS'
                           + '&n=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.1'
                           + '&o=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.2'
                           + '&p=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.3'
                           + '&q=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.4';
            }			
		}
		else
		{
            Form.addParameter('m.Enable',wdsCheckValue);

            if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
            {
				url += '&y=' + WlanWifi.domain
                           + '&m=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS';
            }
            else
            {
				url += '&y=' + WlanWifi.domain
                           + '&m=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS';
            }
		}

    }
	else
	{
        if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
        {
			url += '&y=' + WlanWifi.domain;
        }
        else
        {
			url += '&y=' + WlanWifi.domain;
        }
    }
	
	url += '&RequestFile=html/amp/wlanadv/e8cWlanAdvance.asp';
	Form.setAction(url);
	
    setDisable('Save_button', 1);
    setDisable('Cancel_button', 1);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
}

function CheckForm(type)
{
    if((getSelectVal('WlanTransmit_select') == "") || (getSelectVal('WlanChannel_select') == "") 
	|| (getSelectVal('WlanBandWidth_select') == ""))
	{
		  AlertEx(cfg_wlancfgother_language['amp_basic_empty']);
			   return false;
	}

    if (1 == WdsFlag)
    {
	    if (1 == getCheckVal('wds_enable'))
		{
		    if (wdsIsMacAddrInvalid(getValue('wds_text_ap1')) || wdsIsMacAddrInvalid(getValue('wds_text_ap2')) || wdsIsMacAddrInvalid(getValue('wds_text_ap3')) || wdsIsMacAddrInvalid(getValue('wds_text_ap4')))
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
    
    return true;
}
</script>
</head>



<body class="mainbody" onLoad="LoadFrameWifi();">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="prompt">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	<tr> 
			<td class="table_head" width="100%">无线高级配置</td> 
		</tr>
		<tr> 
			<td height="5"></td> 
		</tr>

        <tr>
            <td class="title_common">				
				<script language="JavaScript" type="text/javascript">
				if((1 == DoubleFreqFlag) && ("2G" == wlanpage))
				{
					document.write(cfg_wlancfgother_language['amp_wlanadvance_title_2G']);
				}
				else if((1 == DoubleFreqFlag) && ("5G" == wlanpage))
				{
					document.write(cfg_wlancfgother_language['amp_wlanadvance_title_5G']);
				}
				else
				{
					document.write("说明：无线连接的高级功能设置，可设置开放的信道，发射功率等一些高级参数(在无线网络功能关闭时，此页面内容可能为空)。");
				}
                </script>
				<label id="Title_wlan_advanced_set_lable" class="title_common">				
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
          <tr>
          <td class="title_common">
          <script>document.write(cfg_wlancfgother_language['amp_wlan_note']);</script>
          </td>
          </tr>
       </td> 
    </tr> 
    
      </table>
    </td>
  </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" id="AdvanceConfig" style="display:none">
  <tr ><td>
    <form id="ConfigForm" action="../network/set.cgi">
	
    <div id='wifiCfg'>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
		<tr>
          <td class="table_left width_per25">隐藏无线网络名称:&nbsp;</td>
          <td class="table_right" id="TdHide">
            <input type='checkbox' id='WlanHide_checkbox' name='WlanHide_checkbox' value="OFF"><span class="gray"> </span></td>
        </tr>
  
      <tr id='switchChannel'>
		  <td class="table_left width_per25" BindText='amp_wlan_channel'></td>
		  <td class="table_right">
			<select id='WlanChannel_select' name='WlanChannel_select' size="1" onChange="ChannelChange()" class="width_150px">
			</select>
		  </td>
      </tr>

      <tr id='switchChannelWidth'>
        <td class="table_left width_per25" BindText='amp_channel_width'></td>
        <td class="table_right">
          <select id='WlanBandWidth_select' name='WlanBandWidth_select' size="1" onChange="ChannelWidthChange()" class="width_150px">
            <option value="0" selected><script>document.write("20MHz/40MHz");</script></option>
            <option value="1"><script>document.write(cfg_wlancfgadvance_language['amp_chlwidth_20']);</script></option>
            <option value="2"><script>document.write(cfg_wlancfgadvance_language['amp_chlwidth_40']);</script></option>
            <script>
            WlanWifiInitFor5G();
            var mode = WlanWifi.mode;
            if ((1 == Wlan11acFlag) && (1 == DoubleFreqFlag) && ("5G" == wlanpage) && (mode == "11ac"))
            {
                document.forms[0].WlanBandWidth_select[3] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_auto204080'], "3");
            }
            </script>

          </select>
        </td>
      </tr>

	  <tr>
        <td class="table_left width_per25">802.11保护间隔:&nbsp;</td>
        <td class="table_right">
          <select id="WlanInterval_select" name="WlanInterval_select" size="1" class="width_150px">
            <option value="800nsec"> 长</option>
            <option value="400nsec"> 短</option>
          </select>
        </td>
      </tr>

	  <tr id="wlPutOutPower">
        <td class="table_left width_per25">发射功率:&nbsp;</td>
        <td  class="table_right"> 
			<select id='WlanTransmit_select' name='WlanTransmit_select' class='width_150px'>
				<option value='100'> 100% </option>
				<option value='80'> 80% </option>
				<option value='60'> 60% </option>
				<option value='40'> 40% </option>
				<option value='20'> 20% </option>
			</select>
        </td>
      </tr>
	  
    </table>

    <div id="div_wds_config" style="display:none">
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr id="wds_config">
          <td class="table_left width_per25" BindText='amp_wds_enable'></td>
          <td class="table_left width_per75">
		    <input type='checkbox' id='wds_enable' name='wds_enable' class="table_left" onClick='WdsClickFunc();'>
            <span class="gray"><script>document.write(cfg_wlancfgadvance_language['amp_wds_notes']);</script></span>
          </td>
        </tr>
      </table>

	<div id='div_wds_mac'>	  
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr id="wds_master">
          <td class="table_left width_per25"></td>
		  <td class="table_left width_per20">WDS <script>document.write(cfg_wlancfgadvance_language['amp_wds_address_label']);</script></span></td>
		  <td class="table_left width_per55"><script>document.write(WdsMasterMac);</script></td>
        </tr>

        <tr id="wds_ap1">
          <td class="table_left width_per25"></td>
		  <td class="table_left width_per20">AP1 <script>document.write(cfg_wlancfgadvance_language['amp_wds_address_label']);</script></span></td>
		  <td class="table_left width_per55"><input type='text' id='wds_text_ap1' name='wds_text_ap1' size='10' class="width_150px">
		  <span class="gray"><script>document.write(cfg_wlancfgadvance_language['amp_wds_address_demo']);</script></span></td>
        </tr>

        <tr id="wds_ap2">
          <td class="table_left width_per25"></td>
		  <td class="table_left width_per20">AP2 <script>document.write(cfg_wlancfgadvance_language['amp_wds_address_label']);</script></span></td>
		  <td class="table_left width_per55"><input type='text' id='wds_text_ap2' name='wds_text_ap2' size='10' class="width_150px">
		  <span class="gray"><script>document.write(cfg_wlancfgadvance_language['amp_wds_address_demo']);</script></span></td>
        </tr>

        <tr id="wds_ap3">
          <td class="table_left width_per25"></td>
		  <td class="table_left width_per20">AP3 <script>document.write(cfg_wlancfgadvance_language['amp_wds_address_label']);</script></span></td>
		  <td class="table_left width_per55"><input type='text' id='wds_text_ap3' name='wds_text_ap3' size='10' class="width_150px">
		  <span class="gray"><script>document.write(cfg_wlancfgadvance_language['amp_wds_address_demo']);</script></span></td>
        </tr>

        <tr id="wds_ap4">
          <td class="table_left width_per25"></td>
		  <td class="table_left width_per20">AP4 <script>document.write(cfg_wlancfgadvance_language['amp_wds_address_label']);</script></span></td>
		  <td class="table_left width_per55"><input type='text' id='wds_text_ap4' name='wds_text_ap4' size='10' class="width_150px">
		  <span class="gray"><script>document.write(cfg_wlancfgadvance_language['amp_wds_address_demo']);</script></span></td>
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
          <button id="Save_button" name="Save_button" type="button" class="submit" onClick="Submit();"><script>document.write(cfg_wlancfgother_language['amp_wlancfg_sure']);</script></button>
          <button id="Cancel_button" name="Cancel_button" type="button" class="submit" onClick="CancelConfig();"><script>document.write(cfg_wlancfgother_language['amp_wlancfg_cancel']);</script></button>
        </td>
      </tr>
    </table>
  </td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr ><td class="width_10px"></td></tr>
</table> 
  
</div>

</form>
</td></tr>
</table>

<!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd --></html>

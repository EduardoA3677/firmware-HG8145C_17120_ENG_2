<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<title>Wlan information</title>
<script language="JavaScript" type="text/javascript">

var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var sptUserType ='1';
var curWebFrame='<%HW_WEB_GetWEBFramePath();%>';
var CfgMode = '<%HW_WEB_GetCfgMode();%>';

var CurrentBin = '<%HW_WEB_GetBinMode();%>';
var wlaninfo_channel_display = 0;

var TELMEX = false;
var TelMexFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TELMEX);%>';

var isStaWorkingModeShow = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PTVDF);%>';

var PCCW = false;
var PCCWFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PCCW);%>';

var BjcuFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_BJCU);%>';
var IspSSIDVisibility = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_ISPSSID_VISIBILITY);%>';


var TwoSsidCustomizeGroup = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_GZCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_JSCT);%>' 
                             | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_NXCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_HUNCT);%>' 
							 | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_GSCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SZCT);%>' 
							 | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_QHCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_HLJCT);%>' 
							 | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_JXCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_XJCT);%>'
							 | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_JLCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_HAINCT);%>'
							 | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SCCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_YNCT);%>'
							 | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_CQCT);%>';
if (1 == TelMexFlag)
{
	TELMEX = true;
}
else
{
	TELMEX = false;
}

if (1 == PCCWFlag)
{
	PCCW = true;
}
else
{
	PCCW = false;
}

function getRadarMode()
{
  $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "./getradar.asp",
            success : function(data) {
               	WlanWorkMode = data;
            }
        });
}

if (!((curWebFrame == 'frame_CMCC') && (curUserType == sptUserType)))
{
	wlaninfo_channel_display = 1;
}

var SsidPerBand = '<%HW_WEB_GetSPEC(AMP_SPEC_SSID_NUM_MAX_BAND.UINT32);%>';

function stWlan(domain,enable,name,ssid,BeaconType,BasicEncrypt,BasicAuth,WPAEncrypt,WPAAuth,IEEE11iEncrypt,IEEE11iAuth,WPAand11iEncrypt,WPAand11iAuth,Channel,LowerLayers)
{
    this.domain = domain;
    this.enable = enable;
    this.name = name;
    this.ssid = ssid;
    this.BeaconType = BeaconType;    
    this.BasicAuth = BasicAuth;
	this.BasicEncrypt = BasicEncrypt;    
    this.WPAAuth = WPAAuth;
	this.WPAEncrypt = WPAEncrypt;    
    this.IEEE11iAuth = IEEE11iAuth;
	this.IEEE11iEncrypt = IEEE11iEncrypt;
	this.WPAand11iAuth = WPAand11iAuth;
	this.WPAand11iEncrypt = WPAand11iEncrypt;
	this.Channel = Channel;	
	this.LowerLayers = LowerLayers;
}

function stWlanTb(wlanInst, ssid, wetherConfig, auth, encrypt)
{
	this.wlanInst = wlanInst;
	this.ssid = ssid;
	this.wetherConfig = wetherConfig;
	this.auth = auth;
	this.encrypt = encrypt;
}

function stPacketInfo(domain,totalBytesSent,totalPacketsSent,totalBytesReceived,totalPacketsReceived)
{
    this.domain = domain;
    this.totalBytesSent = totalBytesSent;
	this.totalPacketsSent = totalPacketsSent;
	this.totalBytesReceived = totalBytesReceived;
	this.totalPacketsReceived = totalPacketsReceived;
}

function stStats(domain,errorsSent,errorsReceived,discardPacketsSent,discardPacketsReceived)
{
    this.domain = domain;
    this.errorsSent = errorsSent;
    this.errorsReceived = errorsReceived;
    this.discardPacketsSent = discardPacketsSent;
    this.discardPacketsReceived = discardPacketsReceived;
}

function stRadio(domain,OperatingFrequencyBand,Enable)
{
    this.domain = domain;
    this.OperatingFrequencyBand = OperatingFrequencyBand;
    this.Enable = Enable;
}


function stIndexMapping(index,portIndex)
{
    this.index = index;
    this.portIndex = portIndex;
}

function stAssociatedDevice(domain,AssociatedDeviceMACAddress,X_HW_Uptime,X_HW_RxRate,X_HW_TxRate,X_HW_RSSI,X_HW_Noise,X_HW_SNR,X_HW_SingalQuality,X_HW_WorkingMode,X_HW_WMMStatus,X_HW_PSMode)
{
	this.domain = domain;
	this.AssociatedDeviceMACAddress = AssociatedDeviceMACAddress;
    this.X_HW_Uptime = X_HW_Uptime;
    this.X_HW_RxRate = X_HW_RxRate;
    this.X_HW_TxRate = X_HW_TxRate;
    this.X_HW_RSSI   = X_HW_RSSI;
    this.X_HW_Noise  = X_HW_Noise;
    this.X_HW_SNR    = X_HW_SNR;
    this.X_HW_SingalQuality  = X_HW_SingalQuality;
    this.X_HW_WorkingMode  = X_HW_WorkingMode;
    this.X_HW_WMMStatus  = X_HW_WMMStatus;
    this.X_HW_PSMode  = X_HW_PSMode;
    this.ssidname = 0;
}

function stNeighbourAP(domain,SSID,BSSID,NetworkType,Channel,RSSI,Noise,DtimPeriod,BeaconPeriod,Security,Standard,MaxBitRate)
{
	this.domain = domain;
	this.SSID = SSID;
    this.BSSID = BSSID;
    this.NetworkType = NetworkType;
    this.Channel = Channel;
    this.RSSI = RSSI;
    this.Noise = Noise;
    this.DtimPeriod = DtimPeriod;
    this.BeaconPeriod = BeaconPeriod;
    this.Security = Security;
    this.Standard = Standard;
    this.MaxBitRate = MaxBitRate;
}

var WlanInfo = new Array();
WlanInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Enable|Name|SSID|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|Channel|LowerLayers,stWlan,STATUS);%>;  

var WlanChannel = '';

var PacketInfo = new Array();
PacketInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},TotalBytesSent|TotalPacketsSent|TotalBytesReceived|TotalPacketsReceived,stPacketInfo,STATUS);%>; 

var Stats = new Array();
Stats = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.Stats,ErrorsSent|ErrorsReceived|DiscardPacketsSent|DiscardPacketsReceived,stStats,STATUS);%>;
	
var wlanEnbl = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>';

var AssociatedDevice = new stAssociatedDevice("0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0");

var NeighbourAP = new stNeighbourAP("0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0");

function getWlanPortNumber(name)
{
    var length = name.length;
    var number;
    var str = parseInt(name.charAt(length-1));
    return str;
}


var WlanMap = new Array();

for (var i = 0; i < WlanInfo.length-1; i++)
{
    var index = getWlanPortNumber(WlanInfo[i].name);
	WlanMap[i] = new stIndexMapping(i, index);
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

if (true == TELMEX)
{
	var wifiMac = "--:--:--:--:--:--";
	function stDeviceMac(domain,LanMac,WLanMac)
	{
		this.domain = domain;
		this.LanMac = LanMac;
		this.WLanMac = WLanMac;		
	}	
	var deviceMacs = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo, X_HW_LanMac|X_HW_WlanMac, stDeviceMac);%>; 
	wifiMac = deviceMacs[0].WLanMac;
	
	if ((1 == DoubleFreqFlag) && (2 == top.changeWlanClick))
    {
        wifiMac = '<%HW_WEB_GetWlanMac_5G();%>';
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

function onClickMethod()
{   
    if ((1 == getRadioVal("WlanMethod")))
    {   
        top.changeWlanClick = 1;
    }
    else if (2 == getRadioVal("WlanMethod"))
    {   
        top.changeWlanClick = 2;
    }
	else
    {
        top.changeWlanClick = 1;	
    }

	window.location = "/html/amp/wlaninfo/wlaninfo.asp";
}

function LoadFrame()
{ 		
	if ((curWebFrame == 'frame_CTCOM') && ('E8C' == CurrentBin.toUpperCase()))
	{
		setDisplay("DivSSIDStats",0);
	}
	
	if (1 == DoubleFreqFlag)
	{
		setDisplay("WlanDoubleChannel",1);
	}
	else
	{
		setDisplay("WlanDoubleChannel",0);
	}

	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}

		b.innerHTML = status_wlaninfo_language[b.getAttribute("BindText")];
	}

    if (TELMEX == true)
	{
		setDisplay("divTelmexMacInfo",1);
	}
	else
	{
		setDisplay("divTelmexMacInfo",0);
	}

    if ((TELMEX == true) || (BjcuFlag == '1'))
	{
		setDisplay("DivStaInfo",0);
        setDisplay("DivNAPInfo",0);
	}
    else if (IsSonetSptUser())
    {
        setDisplay("DivStaInfo",1);
        setDisplay("DivNAPInfo",0);
    }
    else
    {
        setDisplay("DivStaInfo",1);
        setDisplay("DivNAPInfo",1);
    }

    if (curWebFrame == 'frame_UNICOM')
    {
    	var currentPageURLFlag = document.URL.split('?')[1];
    	if(currentPageURLFlag == 'statistics')
    	{    		
    		setDisplay("divWlanInfo", 0);  
    		setDisplay("divSSIDInfo", 0);      	
    	}
    }
	
	if (0 == isStaWorkingModeShow)
    {
		setDisplay("amp_stainfo_working_mode", 0);
		setDisplay("amp_stainfo_wmm_status", 0);
		setDisplay("amp_stainfo_ps_mode", 0);
    }

	if ( sysUserType == curUserType )
	{
		setDisplay("stalogtitle",1);
		setDisplay("btn_sta_event",1);
		setDisplay("logarea",1);
	}
	
	fixIETableScroll("DivPacketStatistics_Table_Container", "wlan_pkts_statistic_table");
	
}

function expandMenu()
{
    if (curUserType == sysUserType)
    {
       var menuID = 'link_Admin_3';
    }
    else
    {
       var menuID = 'link_User_3';
    }
   
    window.parent.frames["menufrm"].clickMenuLink(menuID);
}
function setControl()
{
}
</script>

</head>
<body class="mainbody" onLoad="LoadFrame();">

<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("amp_wlaninfo_desc", 
	GetDescFormArrayById(status_wlaninfo_language, "amp_wlaninfo_desc_head"), 
	GetDescFormArrayById(status_wlaninfo_language, "amp_wlaninfo_desc"), false);
</script>

<div class="title_spread"></div>

<div id="WlanDoubleChannel" style="display:none;">
<table id="DoubleChannel" width="100%" cellspacing="1" class="tabal_noborder_bg" style="font-size:14px;">
    <tr>       	
    <td height = "30px"> <input name="WlanMethod" id="WlanMethod" type="radio" value="1" checked="checked" onclick="onClickMethod()"/>
    <script>document.write(cfg_wlaninfo_db_language['amp_wlan_display2g_info']);</script></td>
    <td height = "30px"> <input name="WlanMethod" id="WlanMethod" type="radio"  value="2"  onclick="onClickMethod()" />
    <script>document.write(cfg_wlaninfo_db_language['amp_wlan_display5g_info']); </script></td> 
    <script>
        var Method = top.changeMethod;
        if (1 ==top.changeWlanClick)
        {   
            setRadio("WlanMethod",1);
        }
        else if (2 == top.changeWlanClick)
        {
            setRadio("WlanMethod",2);
        }
        else
        {    
            setRadio("WlanMethod",1);
        }
    </script>
    </tr> 
</table>

<div class="func_spread"></div>

</div>

<!-- begin Telmex 定制 -->
<div id="divTelmexMacInfo" style="display:none;"> 

<div class="func_title"><SCRIPT>document.write(status_wlaninfo_language["amp_wifimacinfo_title"]);</SCRIPT></div>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
<tr> 
	<td class="table_title width_per35" style="color: #000000;" BindText='amp_wifimac'></td>
	<td class="table_right" style="color: #000000;">
		<script language="JavaScript" type="text/javascript">
		if (true == TELMEX)
		{
			document.write(wifiMac);
		}
		</script>
	</td> 
</tr> 
</table>

<div class="func_spread"></div>

</div>
<!-- end Telmex 定制 -->

<div id="divWlanInfo">

<div class="func_title"><SCRIPT>document.write(status_wlaninfo_language["amp_wlaninfo_title"]);</SCRIPT></div>

<table id="wlanlink_status_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
    <tr>
        <td class="table_title width_per35" style="color: #000000;" BindText='amp_wlanlink_status'></td>
        <td class="table_right" style="color: #000000;"> 
	        <script language="JavaScript" type="text/javascript">
				WlanInfoRefresh();

	            if (wlanEnbl == 1)
				{
					document.write(status_wlaninfo_language['amp_wlanlink_on'] + '&nbsp;&nbsp;')
				}
				else
				{
					document.write(status_wlaninfo_language['amp_wlanlink_off'] + '&nbsp;&nbsp;')
				}
	        </script>
	    </td>
    </tr>

    <script language="JavaScript" type="text/javascript">
    if(true == TELMEX)
    {	      
       
        $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "./getassociateddeviceinfo.asp",
            success : function(data) {
            AssociatedDevice = eval(data);	
            }
        });

    }

	if (wlaninfo_channel_display == 1)
	{
        document.write('<tr>');
        document.write('<td class="table_title width_per35" style="color: #000000;">' + status_wlaninfo_language['amp_wlaninfo_channel'] + '</td>');
        document.write('<td class="table_right" style="color: #000000;">');
		document.write(WlanChannel);
	    document.write('</td>');
        document.write('</tr>');	
	}
	</script>
</table>

<div class="func_spread"></div>

</div>

<div id="DivSSIDStats" >

<div class="func_title"><SCRIPT>document.write(status_wlaninfo_language["amp_wlanstat_title"]);</SCRIPT></div>

<div id="DivPacketStatistics_Table_Container" style="overflow:auto;overflow-y:hidden">

<table id="wlan_pkts_statistic_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
  <tr class="head_title"> 
    <td class="width_per10" rowspan="2" BindText='amp_wlanstat_id'></td>
    <td class="width_per25" rowspan="2" BindText='amp_wlanstat_name'></td>
    <td colspan="4" BindText='amp_wlanstat_rx'></td>
    <td colspan="4" BindText='amp_wlanstat_tx'></td>
  </tr>
  <tr class="head_title"> 
    <td BindText='amp_wlanstat_bytes'></td>
    <td BindText='amp_wlanstat_pkts'></td>
    <td BindText='amp_wlanstat_err'></td>
    <td BindText='amp_wlanstat_drop'></td>
    <td BindText='amp_wlanstat_bytes'></td>
    <td BindText='amp_wlanstat_pkts'></td>
    <td BindText='amp_wlanstat_err'></td>
    <td BindText='amp_wlanstat_drop'></td>
  </tr>
    <script language="JavaScript" type="text/javascript">
    if (wlanEnbl != '')
    {
        if ((wlanEnbl == 1) && (WlanMap.length != 0))
        {
            for (i = 0; i < WlanMap.length; i++)
            {			
                var index = getIndexFromPort(WlanMap[i].portIndex);
                var wlanInst = getWlanInstFromDomain(WlanInfo[index].domain);

                if ((1 == DoubleFreqFlag) && (1 == top.changeWlanClick))
                {
                    if (WlanMap[i].portIndex > 3)
                    {
                        continue;
                    }					
                }
					
                if ((1 == DoubleFreqFlag) && (2 == top.changeWlanClick))
                {
                    if (WlanMap[i].portIndex < 4)
                    {
                        continue;
                    }					
                }
					
                if (1 == isSsidForIsp(wlanInst) && 1 != IspSSIDVisibility)                
                {
                    continue;
                }
					
                if ((PacketInfo[index] != null) && (Stats[index] != null))
                {   
                    if (i%2 == 0)
                    {
                        document.writeln("<tr class='tabal_01'>");
                    }
                    else
                    {
                        document.writeln("<tr class='tabal_02'>");
                    }
					
                    document.writeln("<td class='align_center'>" + wlanInst + "</td>");
                    document.writeln("<td class='align_center'>" + GetSSIDStringContent(WlanInfo[index].ssid,32) + "</td>");
                    document.writeln("<td class='align_center'>" + PacketInfo[index].totalBytesReceived + "&nbsp;</td>");
                    document.writeln("<td class='align_center'>" + PacketInfo[index].totalPacketsReceived + "&nbsp;</td>");
                    document.writeln("<td class='align_center'>" + Stats[index].errorsReceived + "&nbsp;</td>");
                    document.writeln("<td class='align_center'>" + Stats[index].discardPacketsReceived + "&nbsp;</td>");
                    document.writeln("<td class='align_center'>" + PacketInfo[index].totalBytesSent + "&nbsp;</td>");
                    document.writeln("<td class='align_center'>" + PacketInfo[index].totalPacketsSent + "&nbsp;</td>");
                    document.writeln("<td class='align_center'>" + Stats[index].errorsSent + "&nbsp;</td>");
                    document.writeln("<td class='align_center'>" + Stats[index].discardPacketsSent  + "&nbsp;</td>");
                    document.writeln("</tr>");
                }
            }
        }
    }

    </script>
</table>

</div>

<div class="func_spread"></div>

</div>

<div id="divSSIDInfo">

<div class="func_title"><SCRIPT>document.write(status_wlaninfo_language["amp_ssidinfo_title"]);</SCRIPT></div>

<div id="DivSSIDInfo_Table_Container" style="overflow:auto;overflow-y:hidden">

<script language="javascript">

	var ShowTableFlag = 1;
	var ShowButtonFlag = 0;
	var ColumnNum = 5;
	var SSIDInfoArr = new Array();
	var SSIDConfiglistInfo = new Array(new stTableTileInfo("amp_wlanstat_id","align_center","wlanInst",false),
				new stTableTileInfo("amp_wlanstat_name","align_center","ssid",false),
				new stTableTileInfo("amp_ssidinfo_secu","align_center","wetherConfig",false),
				new stTableTileInfo("amp_ssidinfo_auth","align_center","auth",false),
				new stTableTileInfo("amp_ssidinfo_encry","align_center","encrypt",false),null);
		
    if (wlanEnbl != '')
    {	
        if ((wlanEnbl == 1) && (WlanMap.length != 0))
        {
            var wlanlen = WlanMap.length;
		
            if (curWebFrame == 'frame_CTCOM')
			{
				if (1 == TwoSsidCustomizeGroup)
				{
					if (wlanlen >= 2)
					{
						wlanlen = 2;
					}
				}
				else
				{
				    if (wlanlen >= 1)
					{
						wlanlen = 1;
					}
				}
			}

            for (i = 0; i < wlanlen; i++)
            {
                var index = getIndexFromPort(WlanMap[i].portIndex);
                var wlanInst = getWlanInstFromDomain(WlanInfo[index].domain);
				
				if ('' == WlanInfo[i].name)
				{
					continue;
				}

                if ((1 == DoubleFreqFlag) && (1 == top.changeWlanClick))
                {
                    if (WlanMap[i].portIndex > 3)
                    {
                        continue;
                    }					
                }
					
                if ((1 == DoubleFreqFlag) && (2 == top.changeWlanClick))
                {
                    if (WlanMap[i].portIndex < 4)
                    {
                        continue;
                    }					
                }
				
                if (1 == isSsidForIsp(wlanInst) && 1 != IspSSIDVisibility)                
                {
					continue;
                }
					
                if (WlanInfo[index].BeaconType == 'Basic')
                {
                    Auth = WlanInfo[index].BasicAuth;
                    Encrypt = WlanInfo[index].BasicEncrypt;
                }
                else if (WlanInfo[index].BeaconType == 'WPA')
                {
                    Auth = WlanInfo[index].WPAAuth;
                    Encrypt = WlanInfo[index].WPAEncrypt;
                }
                else if ( (WlanInfo[index].BeaconType == '11i') || (WlanInfo[index].BeaconType == 'WPA2') )
                {
                    Auth = WlanInfo[index].IEEE11iAuth;
                    Encrypt = WlanInfo[index].IEEE11iEncrypt;
                }
                else if ( (WlanInfo[index].BeaconType == 'WPAand11i') || (WlanInfo[index].BeaconType == 'WPA/WPA2'))
                {
                    Auth = WlanInfo[index].WPAand11iAuth;
                    Encrypt = WlanInfo[index].WPAand11iEncrypt;
                }
                else
                {
                }
                   				
                if (Auth == 'None')
                {
                    Auth = cfg_wlaninfo_detail_language['amp_auth_open'];
                }
                else if (Auth == 'SharedAuthentication')
                {
                    Auth = cfg_wlaninfo_detail_language['amp_auth_shared'];
                }
                else if(Auth == 'PSKAuthentication')
                {
                    if (WlanInfo[index].BeaconType == 'WPA')
                    {
                        Auth = cfg_wlaninfo_detail_language['amp_auth_wpapsk'];
                    }
                    else if( (WlanInfo[index].BeaconType == '11i') || (WlanInfo[index].BeaconType == 'WPA2') )
                    {
                        Auth = cfg_wlaninfo_detail_language['amp_auth_wpa2psk'];
                    }
                    else if( (WlanInfo[index].BeaconType == 'WPAand11i') || (WlanInfo[index].BeaconType == 'WPA/WPA2') )
                    {
                        Auth = cfg_wlaninfo_detail_language['amp_auth_wpawpa2psk'];
                    }
                    else
                    {
                    }
                }
                else if(Auth == 'EAPAuthentication')
                {   
                    if(WlanInfo[index].BeaconType == 'WPA')
                    {  
                        Auth = cfg_wlaninfo_detail_language['amp_auth_wpa'];
                    }
                    else if( (WlanInfo[index].BeaconType == '11i') || (WlanInfo[index].BeaconType == 'WPA2') )
                    { 
                        Auth = cfg_wlaninfo_detail_language['amp_auth_wpa2'];
                    }
                    else if( (WlanInfo[index].BeaconType == 'WPAand11i') || (WlanInfo[index].BeaconType == 'WPA/WPA2') )
                    { 
                        Auth = cfg_wlaninfo_detail_language['amp_auth_wpawpa2'];
                    }
                }
				
                if(Encrypt == 'NONE' || Encrypt == 'None')
                {  
                    if (Auth == 'Both')
                    {
                        Encrypt = cfg_wlaninfo_detail_language['amp_encrypt_wep'];
                    }
                    else
                    {
                        Encrypt = cfg_wlaninfo_detail_language['amp_encrypt_none'];
                    }
                }
                else if(Encrypt == 'WEPEncryption')
                {
                    Encrypt = cfg_wlaninfo_detail_language['amp_encrypt_wep'];
                }
                else if(Encrypt == 'AESEncryption') 
                {
                    Encrypt = cfg_wlaninfo_detail_language['amp_encrypt_aes'];
                }
                else if(Encrypt == 'TKIPEncryption')
                {
                    Encrypt = cfg_wlaninfo_detail_language['amp_encrypt_tkip'];
                }
                else if(Encrypt == 'TKIPandAESEncryption')
                {
                    Encrypt = cfg_wlaninfo_detail_language['amp_encrypt_tkipaes'];
                }

				if (Auth == cfg_wlaninfo_detail_language['amp_auth_open'] && 
						Encrypt == cfg_wlaninfo_detail_language['amp_encrypt_none'])
                {
                    wetherConfig = status_wlaninfo_language['amp_authencry_off'];
                }
                else
                {
                    wetherConfig = status_wlaninfo_language['amp_authencry_on'];
                }  

                if (1 == DTHungaryFlag)
                {
                    if (Auth == cfg_wlaninfo_detail_language['amp_auth_open'])
                    {
                        Auth = 'WEP open';
                    }
                    else if (Auth == cfg_wlaninfo_detail_language['amp_auth_shared'])
                    {
                        Auth = 'WEP shared';
                    }
                }

				SSIDInfoArr.push(new stWlanTb(wlanInst, GetSSIDStringContent(WlanInfo[index].ssid,32),
					wetherConfig, Auth, Encrypt));
            }
        }
		
    }
	
	if(SSIDInfoArr.length != 0)
		SSIDInfoArr.push(null);
	
	HWShowTableListByType(ShowTableFlag, "wlan_ssidinfo_table", ShowButtonFlag, ColumnNum, SSIDInfoArr, SSIDConfiglistInfo, status_wlaninfo_language, null);

	fixIETableScroll("DivSSIDInfo_Table_Container", "wlan_ssidinfo_table");
</script>

</div>

<div class="func_spread"></div>

</div>

<div id="DivStaInfo">

<div id="ApplyBthSTA" >
	<div class="func_title"><SCRIPT>document.write(status_wlaninfo_language["amp_stainfo_title"]);</SCRIPT></div>

	<input id="btn_sta_query" name="btnCheck" type="button" value="" class="NewDelbuttoncss">
	<script>
	  document.getElementById('btn_sta_query').value = status_wlaninfo_language['amp_stainfo_query'];
	</script>
		
	<div class="button_spread"></div>
	
</div>

<div id="DivStaQueryInfo_Table_Container" style="overflow:auto;overflow-y:hidden;">

<script language="javascript">
  $(document).ready(function () {
        var viewModel = {
            $DivStaInfo: $('#DivStaInfo'),
            $btn_sta_query: $('#btn_sta_query'),
            $StaInfoTable: $('#wlan_stainfo_table'),
            
             appendStaInfo: function(record) {

			 var TbHtml = '';

			 var STATShowableFlag = 1;
  			 var STAShowButtonFlag = 0;
  			 var STAColumnNum = 12;
			 var STAArray = new Array();
  			 var STAConfiglistInfo = new Array(
			 			new stTableTileInfo("amp_stainfo_macadd","align_center","AssociatedDeviceMACAddress",false),
  						new stTableTileInfo("amp_wlanstat_name","align_center","ssidname",false),
  						new stTableTileInfo("amp_stainfo_uptime","align_center","X_HW_Uptime",false),
  						new stTableTileInfo("amp_stainfo_txrate","align_center","X_HW_TxRate",false),
  						new stTableTileInfo("amp_stainfo_rxrate","align_center","X_HW_RxRate",false),
  						new stTableTileInfo("amp_stainfo_rssi","align_center","X_HW_RSSI",false),
  						new stTableTileInfo("amp_stainfo_noise","align_center","X_HW_Noise",false),
  						new stTableTileInfo("amp_stainfo_snr","align_center","X_HW_SNR",false),
  						new stTableTileInfo("amp_stainfo_sigqua","align_center","X_HW_SingalQuality",false),
  						new stTableTileInfo("amp_stainfo_working_mode","align_center","X_HW_WorkingMode",0==isStaWorkingModeShow),
  						new stTableTileInfo("amp_stainfo_wmm_status","align_center","X_HW_WMMStatus",0==isStaWorkingModeShow),
  						new stTableTileInfo("amp_stainfo_ps_mode","align_center","X_HW_PSMode",0==isStaWorkingModeShow),null);

	          var ssidstart = 0;
	          var ssidend   = SsidPerBand - 1; 

	          if ((1 == DoubleFreqFlag) && (1 == top.changeWlanClick))
	          {
	            ssidstart = 0;
	            ssidend   = 3;
	          }

	          if ((1 == DoubleFreqFlag) && (2 == top.changeWlanClick))
	          {
	            ssidstart = 4;
	            ssidend   = 7;				
	          }   
            
            for (i = 0; i < record.length - 1; i++)
            {
                var ssid = getWlanInstFromDomain(record[i].domain);  

                for (j = 0; j < WlanInfo.length - 1; j++)
                {
                    var ret = WlanInfo[j].domain.indexOf("InternetGatewayDevice.LANDevice.1.WLANConfiguration."+ssid);
                    if (ret == 0)
                    {
                        var wlanInst = getWlanInstFromDomain(WlanInfo[j].domain);
                        if (1 == isSsidForIsp(wlanInst) && 1 != IspSSIDVisibility)                        
                        {
                            continue;
                        }	

                        var athindex = getWlanPortNumber(WlanInfo[j].name);
                        if (( athindex >= ssidstart )&&( athindex <= ssidend ))
                        {
                            record[i].ssidname = WlanInfo[j].ssid;
							viewModel.convertStaDataToHtml(record[i]);
				   			STAArray.push(record[i]);
                        }
                    }
                }
            }            

			if(STAArray.length != 0)
            	STAArray.push(null);
			
            var _write = document.write;
			document.write = function( str )
			{
			    TbHtml += str;
			}

			HWShowTableListByType(STATShowableFlag, "wlan_stainfo_table", STAShowButtonFlag, STAColumnNum, STAArray, STAConfiglistInfo, status_wlaninfo_language, null);
			$('#DivStaQueryInfo_Table_Container').html(TbHtml);
			document.write = _write;

			fixIETableScroll("DivStaQueryInfo_Table_Container", "wlan_stainfo_table");
			
			},
            processEmptyValue: function(record) {
          	if(!record || typeof record != 'object') return ;
          	
          	for(var pKey in record) {
          		record[pKey] = record[pKey] || '--';
          		}
          		
          	return record;
          },
            convertStaDataToHtml: function(record) {
            	
       			record = viewModel.processEmptyValue(record);
          		if(!record) return "";
          		
          		if( record.X_HW_RSSI < -80 )
			        {
			            record.X_HW_RSSI += status_wlaninfo_language['amp_stainfo_level1'];  
			        }
			        if(( record.X_HW_RSSI >= -80 )&&( record.X_HW_RSSI <= -75 ))
			        {
			            record.X_HW_RSSI += status_wlaninfo_language['amp_stainfo_level2'];  
			        }
			        if(( record.X_HW_RSSI > -75 )&&( record.X_HW_RSSI <= -69 ))
			        {
			            record.X_HW_RSSI += status_wlaninfo_language['amp_stainfo_level3'];  
			        }
			        if(( record.X_HW_RSSI > -69 )&&( record.X_HW_RSSI <= -63 ))
			        {
			            record.X_HW_RSSI += status_wlaninfo_language['amp_stainfo_level4'];  
			        }
			        if( record.X_HW_RSSI > -63 )
			        {
			           record.X_HW_RSSI += status_wlaninfo_language['amp_stainfo_level5'];  
			        }
					
				if( 1 == record.X_HW_WMMStatus )
				{
					record.X_HW_WMMStatus = status_wlaninfo_language['amp_stainfo_wmm_on'];
				}
				else if( 0 == record.X_HW_WMMStatus )
				{
					record.X_HW_WMMStatus = status_wlaninfo_language['amp_stainfo_wmm_off'];
				}
				else
				{
					record.X_HW_WMMStatus = '--';
				}
				
				if( 1 == record.X_HW_PSMode )
				{
					record.X_HW_PSMode = status_wlaninfo_language['amp_stainfo_ps_on'];
				}
				else if( 0 == record.X_HW_PSMode )
				{
					record.X_HW_PSMode = status_wlaninfo_language['amp_stainfo_ps_off'];
				}
				else
				{
					record.X_HW_PSMode = '--';
				}
    	  
          		record.AssociatedDeviceMACAddress = record.AssociatedDeviceMACAddress.toUpperCase();
				record.ssidname = GetSSIDStringContent(record.ssidname,32);
          	}
        };

		viewModel.$btn_sta_query.click(function(){
			    
				if (wlanEnbl == 0)
		        {
		            return;
		        }

				viewModel.$btn_sta_query.attr('disabled', 'disabled');

           		$.ajax({
					type : "post",
					async : true,
					url : "./getassociateddeviceinfo.asp",
					success : function(data) {	
					
					AssociatedDevice = eval(data);	

					viewModel.appendStaInfo(AssociatedDevice);	

					viewModel.$btn_sta_query.removeAttr('disabled');
					}		
				});
			});

		viewModel.appendStaInfo(new Array());
    }); 

</script>

</div>

<div class="func_spread"></div>

</div>

<div id="DivNAPInfo">

<div id="ApplyBthNAP" >

	<div class="func_title"><SCRIPT>document.write(status_wlaninfo_language["amp_napinfo_title"]);</SCRIPT></div>
	
	<input id="btn_nap_query" name="btnCheck" type="button" value="" class="NewDelbuttoncss">
	
	<script>
	  document.getElementById('btn_nap_query').value = status_wlaninfo_language['amp_stainfo_query'];
	</script>
		
	<span style="font-size: 12px;margin-left:20px;" ><script>document.write(status_wlaninfo_language['amp_stainfo_napinfoprompt']);</script></span>

	<div class="button_spread"></div>
	
</div>

<div id="DivNAPQueryInfo_Table_Container" style="overflow:auto;overflow-y:hidden;">

<script type="text/javascript">
	    $(document).ready(function () {
        var ap_viewModel = {      
            $DivNAPInfo: $('#DivNAPInfo'),
            $btn_nap_query: $('#btn_nap_query'),
            $ApInfoTable: $('#wlan_napinfo_table'),

            appendApInfo: function(info) {

			 var TbHtml = '';
			 
			 var APShowableFlag = 1;
  			 var APShowButtonFlag = 0;
  			 var APColumnNum = 11;
			 var APArray = new Array();
  			 var APConfiglistInfo = new Array(
			 			new stTableTileInfo("amp_wlanstat_name","align_center","SSID",false),
  						new stTableTileInfo("amp_stainfo_macadd","align_center","BSSID",false),
  						new stTableTileInfo("amp_napinfo_type","align_center","NetworkType",false),
  						new stTableTileInfo("amp_napinfo_channel","align_center","Channel",false),
  						new stTableTileInfo("amp_stainfo_rssi","align_center","RSSI",false),
  						new stTableTileInfo("amp_stainfo_noise","align_center","Noise",false),
  						new stTableTileInfo("amp_napinfo_dtim","align_center","DtimPeriod",false),
  						new stTableTileInfo("amp_napinfo_beacon","align_center","BeaconPeriod",false),
  						new stTableTileInfo("amp_napinfo_security","align_center","Security",false),
  						new stTableTileInfo("amp_napinfo_standard","align_center","Standard",false),
  						new stTableTileInfo("amp_napinfo_maxrate","align_center","MaxBitRate",false),null);
                          
            	if(info instanceof Array) {
            		$.each(info, function(index, item) {
            			item = ap_viewModel.processEmptyValue(item);
            			if(!item) return false;
            			
            			if ((1 == DoubleFreqFlag) && (1 == top.changeWlanClick))
		                {
		                    if (item.domain.indexOf(node2G) != 0)
		                    {
		                       return true;
		                    }
		                }
		                if ((1 == DoubleFreqFlag) && (2 == top.changeWlanClick))
		                {
		                    if (item.domain.indexOf(node5G) != 0)
		                    {
		                       return true;
		                    }				
		                }
	               
            			ap_viewModel.convertApDataToHtml(item);
						APArray.push(item);
            		});

					if(APArray.length != 0)
						APArray.push(null);

					var _write = document.write;
					document.write = function( str ){TbHtml += str;}

					HWShowTableListByType(APShowableFlag, "wlan_napinfo_table", APShowButtonFlag, APColumnNum, APArray, APConfiglistInfo, status_wlaninfo_language, null);
					$('#DivNAPQueryInfo_Table_Container').html(TbHtml);
					
					document.write = _write;

					fixIETableScroll("DivNAPQueryInfo_Table_Container", "wlan_napinfo_table");
            	}
            },
          processEmptyValue: function(record) {
          	if(!record || typeof record != 'object') return;
          	
          	for(var pKey in record) {
          		record[pKey] = record[pKey] || '--';
          		}
          		
          	return record;
          },
			convertApDataToHtml: function(record) {
				
				if(!record) return "";
				
				if( record.RSSI < -80 )
				{
				    record.RSSI += status_wlaninfo_language['amp_stainfo_level1'];  
				}
				if(( record.RSSI >= -80 )&&( record.RSSI <= -75 ))
				{
				    record.RSSI += status_wlaninfo_language['amp_stainfo_level2'];  
				}
				if(( record.RSSI > -75 )&&( record.RSSI <= -69 ))
				{
				    record.RSSI += status_wlaninfo_language['amp_stainfo_level3'];  
				}
				if(( record.RSSI > -69 )&&( record.RSSI <= -63 ))
				{
				    record.RSSI += status_wlaninfo_language['amp_stainfo_level4'];  
				}
				if( record.RSSI > -63 )
				{
				    record.RSSI += status_wlaninfo_language['amp_stainfo_level5'];  
				}

				record.BSSID = record.BSSID.toUpperCase();
				record.SSID = GetSSIDStringContent(record.SSID,32);
          	}
        };
        
        ap_viewModel.$btn_nap_query.click(function(){
				if (wlanEnbl == 0)
        		{
            		return;
        		}

		        if ((1 == DoubleFreqFlag) && (2 == top.changeWlanClick))
		        {
		            getRadarMode();
		        	 if(1 == WlanWorkMode )
			        {
			        	AlertEx(status_wlaninfo_language['amp_stainfo_workmodeprompt']);
			        	return;
			        }
		        }

				ap_viewModel.$btn_nap_query.attr('disabled', 'disabled');
              
				$.ajax({
					type : "post",
					async : true,
					url : "./getneighbourAPinfo.asp",
					success : function(data) {	
					
					NeighbourAP = eval(data);	
					
					ap_viewModel.appendApInfo(NeighbourAP);		

					ap_viewModel.$btn_nap_query.removeAttr('disabled');
					}
				});
			});

		ap_viewModel.appendApInfo(new Array());
    });

</script> 

</div>


</div>

<script language="JavaScript" type="text/javascript">
function backupSetting()
{
  var Form = new webSubmitForm();
	Form.addParameter('logtype', "opt");
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('staeventlog.cgi?FileType=wifilog&RequestFile=html/amp/wlaninfo/wlaninfo.asp');
	Form.submit();
}
</script>

<div>
<div class="title_spread"></div>
<div class="func_title" id = "stalogtitle" style='display:none'><SCRIPT>document.write(status_wlaninfo_language["amp_stainfo_event_log"]);</SCRIPT></div>
	<div>
		<tr>
			<td>
				<input id="btn_sta_event" name="btnCheck" type="button" value="" class="NewDelbuttoncss" onClick='backupSetting()' style='display:none'>
				<input type="hidden" name="onttoken" id="onttoken" value="<%HW_WEB_GetToken();%>">
				<script>
					document.getElementById('btn_sta_event').value = status_wlaninfo_language['amp_stainfo_event_log_download'];
				</script>
			</tr>
		</td>
	</div>

<div class="button_spread"></div>
<div id="logviews"> 
  <textarea name="logarea" id="logarea" class="text_log" wrap="off" readonly="readonly" style='display:none'><%HW_WEB_GetStaEventLog();%>
  </textarea> 
	<script type="text/javascript">
		var textarea = document.getElementById("logarea");
		textarea.value = textarea.value.replace(new RegExp("�","g"),"");
	</script> 
</div> 
</div>

</body>
</html>

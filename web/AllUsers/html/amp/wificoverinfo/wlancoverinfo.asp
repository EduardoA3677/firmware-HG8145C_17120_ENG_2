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
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>

<title>Smart WiFi Coverage</title>
<script language="JavaScript" type="text/javascript">

function stPlcAdptInfos(domain, DeviceName, Manufacturer, ManufacturerOUI, SerialNumber, HardwareVersion, SoftwareVersion, MacAddress, DuplexMode, Speed)
{
    this.domain = domain;
    this.DeviceName = DeviceName;
    this.Manufacturer = Manufacturer;    
    this.ManufacturerOUI = ManufacturerOUI.toUpperCase();
    this.SerialNumber = SerialNumber;
    this.HardwareVersion = HardwareVersion;
    this.SoftwareVersion = SoftwareVersion;
    this.MacAddress = MacAddress.toUpperCase();
    this.DuplexMode = DuplexMode;
    this.Speed = Speed;
}

function stPlcInfos(domain, MacAddress, RxRate, TxRate) 
{
    this.domain = domain;
    this.MacAddress = MacAddress.toUpperCase();
    this.RxRate = RxRate;    
    this.TxRate = TxRate;
}


var PlcAdptInfo = new Array();
var PlcInfo = new Array();
var PlcAdptNum = 0;
var PlcNum = 0;
PlcAdptInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_PLCAdaptor.{i}, DeviceName|Manufacturer|ManufacturerOUI|SerialNumber|HardwareVersion|SoftwareVersion|MacAddress|DuplexMode|Speed, stPlcAdptInfos);%>;
PlcAdptNum = PlcAdptInfo.length - 1;
PlcInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_PLCAdaptor.1.X_HW_PLCDevice.{i}, MacAddress|RxRate|TxRate, stPlcInfos);%>;
PlcNum = PlcInfo.length - 1;

var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';

function LoadResource()
{
    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length ; i++) 
    {
        var b = all[i];
        if(b.getAttribute("BindText") == null)
        {
            continue;
        }

        if (cfg_wificoverinfo_language[b.getAttribute("BindText")]) 
        {
            b.innerHTML = cfg_wificoverinfo_language[b.getAttribute("BindText")];
        }
    }
}

function getInstIdByDomain(domain)
{
    if ('' != domain)
    {
        return parseInt(domain.charAt(domain.length - 1));    
    }
}

function  stApDevice(domain, type, sn, hwversion, swversion,uptime, channel, transmitepower, ApOnlineFlag)
{
    this.domain = domain;
    this.type = type;
    this.sn = sn;
    this.hwversion = hwversion;
    this.swversion = swversion;
    this.uptime = uptime;
    this.channel = channel;
    this.transmitepower = transmitepower;
    this.ApOnlineFlag = ApOnlineFlag;

	this.ssidList = '';
}

var apDeviceList = new Array();
apDeviceList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i}, DeviceType|SerialNumber|HardwareVersion|SoftwareVersion|UpTime|CurrentChannel|TransmitPower|ApOnlineFlag, stApDevice);%>;

function getSecMac(macSet)
{
    var secMac = "00:00:00:00:00:00";
    var len = secMac.length;
    if(macSet.length >= 2 * len + 1)
    {
        secMac = macSet.substring(len + 1, 2 * len + 1);
    }
    return secMac.toUpperCase();         
}

function getInstFromMacDom(domain)
{
    var path = "InternetGatewayDevice.X_HW_APDevice.1";
    var apdomain = '';
    if(domain.length >= path.length)
    {
        apdomain = domain.substring(0, path.length);
    }
    return getInstIdByDomain(apdomain);         
}

function stApMacInfo(domain, MacAddress) 
{
    this.domain = domain;
    this.MacAddress = getSecMac(MacAddress);
}

var ApMacInfo = new Array();
ApMacInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i}.ApMacPool, MacPool, stApMacInfo);%>;

function stApSsid(domain,SSID)
{
    this.domain = domain;
    this.SSID = SSID;
}

var apSsid= <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i}.WLANConfiguration.{i}, SSID, stApSsid);%>;

var ApSsidList = '';
function getApSsidList(domain)
{
    ApSsidList = '';
    for (var i = 0; i < apSsid.length - 1; i++)
    {
        var pathlength = "InternetGatewayDevice.X_HW_APDevice.1";
        var pathApWlc = apSsid[i].domain;

        var pathAp = pathApWlc.substring(0, pathlength.length);
        
        if (domain == pathAp)
        {
            if ('' == ApSsidList)
            {
                ApSsidList = apSsid[i].SSID;
            }
            else
            {
                ApSsidList += ',' + apSsid[i].SSID;
            }
        }    
    }
}

var wificoverApId = 1;
var wificoverTabN = 1;
function setControl1(ApInstId)
{
    wificoverApId = ApInstId;
    if (2 == wificoverTabN)
    {
        window.coverinfo_content.location = "./apNeighborList.asp?" + wificoverApId;
    }
    else if (3 == wificoverTabN)
    {
        window.coverinfo_content.location = "./apssidStat.asp?" + wificoverApId;
    }
    else
    {
        window.coverinfo_content.location = "./apssidStation.asp?" + wificoverApId;
    }
}

var apInstIdArr = new Array();
function setControl(val)
{
	var plcId = 1;
	
	if(val >= 0 && val < apInstIdArr.length)
	{
		wificoverApId = apInstIdArr[val];
		plcId = getPlcIdFromAp(''+apInstIdArr[val]);
	}
	
    if (2 == wificoverTabN)
    {
        window.coverinfo_content.location = "./apNeighborList.asp?" + wificoverApId;
    }
    else if (3 == wificoverTabN)
    {
        window.coverinfo_content.location = "./apssidStat.asp?" + wificoverApId;
    }
    else
    {
        window.coverinfo_content.location = "./apssidStation.asp?" + wificoverApId;
    }

    switchPlc(plcId);  
}

var FirstOnlineApInst = 0;
function switchTab(TableN)
{
    for (var i = 1; i <= 3; i++)
    {
        if ("tab" + i == TableN) 
        {
            document.getElementById(TableN).style.backgroundColor = "#f6f6f6";
        }
        else
        {
            document.getElementById("tab" + i).style.backgroundColor = "";
        }
    }

    if ("tab2" == TableN)
    {
        wificoverTabN = 2;
    }
    else if ("tab3" == TableN)
    {
        wificoverTabN = 3;
    }
    else
    {
        wificoverTabN = 1;
    }

    setControl(-1);
}

function switchPlc(id)
{
    for (var i = 1; i <= PlcNum; i++)
    {
        if ("plc_" + i == id) 
        {
            document.getElementById(id).style.backgroundColor = "#c7e7fe";
        }
        else
        {
            document.getElementById("plc_" + i).style.backgroundColor = "";
        }
    }

}

function getPlcInstIdById(id)
{
    if ('' != id)
    {
        return parseInt(id.charAt(id.length - 1));    
    }
}

function IsApDevOnline(id)
{
    for (var index = 0; index < apDeviceList.length - 1; index++)
    {
        apDevice =  apDeviceList[index];
            
        if (0 == apDevice.ApOnlineFlag)
        {
            continue;
        }

        var ApInstId = getInstIdByDomain(apDevice.domain);
            
        if (id == ApInstId)
        {
            return 1;
        }
    }
    
    return 0;
}


function OnSelectPlc(id)
{ 
    var plcInst = getPlcInstIdById(id);
    var MacAddress = PlcInfo[plcInst-1].MacAddress
    var apNum = ApMacInfo.length - 1;
    var index = 0;

    for (index = 0; index < apNum; index++)
    {
        var apMac = ApMacInfo[index].MacAddress;
        var domain = ApMacInfo[index].domain;
        var apInstId = getInstFromMacDom(domain);
        if ((MacAddress == apMac) && (1 == IsApDevOnline(apInstId)))
        {
            switchPlc(id);
            selectLine('record_' + apInstId);
            break;
        }
    }

}


function getPlcIdFromAp(id)
{ 
    var apInstSel = getPlcInstIdById(id);
    var apNum = ApMacInfo.length - 1;
    var plcNum = PlcInfo.length - 1;
    var MacAddress = '';
    var plcId = '';  
    var index = 0;

    for (index = 0; index < apNum; index++)
    {
        var apMacpool = ApMacInfo[index];
        var apInstId = getInstFromMacDom(apMacpool.domain);
        if( apInstId == apInstSel )
        {
            MacAddress = apMacpool.MacAddress;
            break;
        }
    }

    for (index = 0; index < plcNum; index++)
    {
        var plcMac = PlcInfo[index].MacAddress;
        var plcInst = 0;
        if( MacAddress == plcMac )
        { 
            plcInst = index + 1;
            plcId = 'plc_' + plcInst;
            break;
        }

    }

    return plcId;

}

function OnSelectAp(id)
{ 
    var plcId = getPlcIdFromAp(id);
    selectLine(id);
    switchPlc(plcId);        
}

function LoadFrame()
{
    LoadResource();
    if (PlcAdptNum > 0)
    {
        setDisplay('plcadpt_title', 1);
        setDisplay('plcadpt_tab', 1);
		setDisplay('divPlc', 1);
    }
    if (PlcNum > 0)
    {
        switchPlc(getPlcIdFromAp('record_' + FirstOnlineApInst));
    }
    selectLine('record_' + FirstOnlineApInst);
}
</script>

</head>
<body class="mainbody" onLoad="LoadFrame();" scrolling ="auto">

<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("amp_wificover_status_desc", 
	GetDescFormArrayById(cfg_wificoverinfo_language, "amp_wificover_status_desc_head"), 
	GetDescFormArrayById(cfg_wificoverinfo_language, "amp_wificover_status_desc"), false);
</script>

<div class="title_spread"></div>

<div id="divPlc" style="display:none;">

<div id="plcadpt_title" class="func_title" style="display:none;">
	<SCRIPT>document.write(cfg_wificoverinfo_language["amp_plcnetwork_state"]);</SCRIPT>
</div>

<table id="plcadpt_tab" width="100%" border="0" cellpadding="0" cellspacing="0" style="display:none;"> 
  <tr>
    <td class="width_per15">
      <table width="100%" height="150" style="border:1px #000000 solid;" cellpadding="0" cellspacing="0" class="tabal_bg">
        <tr>
          <td class="tabal_01" align="center">
		  <script>
				document.write(ProductName);
			</script> 
		  </td>
        </tr>
      </table>
    </td>
    <td class="width_per20">
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr align="center" valign="bottom">
          <td style="border-bottom:1px #0000FF solid;color:#0000FF">
          <script>
            if (PlcAdptNum > 0)
            {   
                if (PlcAdptInfo[0].DuplexMode == "HALF_DUPLEX")
                {
                    document.write(cfg_wificoverinfo_language['amp_plcadpt_duplex_half']);
                }
                else
                {
                    document.write(cfg_wificoverinfo_language['amp_plcadpt_duplex_full']);
                }
            }
          </script> 
          </td>
        </tr>
        <tr align="center" valign="top">
          <td style="color:#0000FF">
          <script>
            if (PlcAdptNum > 0)
            {
                document.write(PlcAdptInfo[0].Speed+"Mbps"); 
            }
          </script> 
          </td>
        </tr>
      </table>
    </td>  
   <td class="width_per30">
      <table width="100%" style="border:1px #000000 solid;word-break:break-all" cellpadding="0" cellspacing="0" class="tabal_bg">
        <script>
            if (PlcNum > 5)
            {
                document.write('<tr><td class="tabal_01"></td></tr>');
            }
            if (PlcNum > 7)
            {
                document.write('<tr><td class="tabal_01"></td></tr>');
            }
        </script>
  <tr>
  <td class="tabal_01" style="font-size:12px;font-weight:bold">
  <script>
    if (PlcAdptNum > 0)
    {
        var plcadpt = cfg_wificoverinfo_language['amp_plcadpt_devleft'] + PlcAdptInfo[0].MacAddress + cfg_wificoverinfo_language['amp_plcadpt_devright'];
        document.write(plcadpt);
    }   
  </script>
  </td>
  </tr>
  <tr>
  <td class="tabal_01">
  <script>
    if (PlcAdptNum > 0)
    {
        document.write(cfg_wificoverinfo_language['amp_plcadpt_vendor']+PlcAdptInfo[0].Manufacturer); 
    }
  </script>
  </td>
  </tr>
    <tr>
  <td class="tabal_01">
  <script>
    if (PlcAdptNum > 0)
    {
        document.write(cfg_wificoverinfo_language['amp_plcadpt_vendoroui']+PlcAdptInfo[0].ManufacturerOUI); 
    }
  </script>
  </td>
  </tr>
    <tr>
  <td class="tabal_01">
  <script>
    if (PlcAdptNum > 0)
    {
        document.write(cfg_wificoverinfo_language['amp_plcadpt_snleft'] + PlcAdptInfo[0].SerialNumber + cfg_wificoverinfo_language['amp_plcadpt_snright']);
    }
  </script>
  </td>
  </tr>
    <tr>
  <td class="tabal_01">
  <script>
    if (PlcAdptNum > 0)
    {
        document.write(cfg_wificoverinfo_language['amp_plcadpt_hardver']+PlcAdptInfo[0].HardwareVersion);
    }
  </script>
  </td>
  </tr>
    <tr>
  <td class="tabal_01">
  <script>
    if (PlcAdptNum > 0)
    {
        document.write(cfg_wificoverinfo_language['amp_plcadpt_softver']+'<br>'+PlcAdptInfo[0].SoftwareVersion);
    }
  </script>
  </td>
  </tr>
  <script>
    if (PlcNum > 5)
    {
        document.write('<tr><td class="tabal_01"></td></tr>');
    }
    if (PlcNum > 7)
    {
        document.write('<tr><td class="tabal_01"></td></tr>');
    }
  </script>
  </table>
  </td>
  <td class="width_per25">
  <table width="100%" border="0" cellpadding="0" cellspacing="0">
    <script language="JavaScript" type="text/JavaScript">
    var index = 0;
    var plcInstId = 0;
    var plcdev;
    if (PlcNum > 0)
    {
        for (index = 0; index < PlcNum; index++)
        {
            plcInstId = index + 1;
            plcdev = PlcInfo[index];
            document.write('<tr align="center" valign="bottom">');
            document.write('<td style="border-bottom:1px #0000FF solid;color:#0000FF;">');
            document.write('&lt&middot&middot&middot'+ plcdev.RxRate + 'Mbps</td></tr>');
            document.write('<tr align="center" valign="bottom"><td style="color:#0000FF">');
            document.write('&middot&middot&middot&gt'+ plcdev.TxRate + 'Mbps</td></tr>');
            if ((PlcNum == 2) || (PlcNum == 3))
            {
                document.write('<tr><td>&nbsp</td></tr>');
            }

        }
    }
      </script>     	  	  
  </table>
  </td>
  <td class="width_per25">
  <table width="100%" border="0" cellpadding="0" cellspacing="0">
  <script language="JavaScript" type="text/JavaScript">
    var index = 0;
    var plcInstId = 0;
    var plcdev;
    var plcmac;
    if (PlcNum > 0)
    {
        for (index = 0; index < PlcNum; index++)
        {
            plcInstId = index + 1;
            plcdev = PlcInfo[index];
            plcmac = cfg_wificoverinfo_language['amp_plcadpt_plcleft']+ plcdev.MacAddress + cfg_wificoverinfo_language['amp_plcadpt_plcright'];
            document.write('<tr id="plcline_'+ plcInstId + '"> <td class="width_per20" >');
            document.write('<input class="tabal_01" align="center" type="button"  dir="ltr" ');
            document.write('id="plc_'+ plcInstId + '" style="width:200px;height:30px" ');
            document.write('value="'+ plcmac + '" onclick="OnSelectPlc(this.id);"/>');    
            document.write('</td></tr>');
            if ((PlcNum == 2) || (PlcNum == 3))
            {
                document.write('<tr><td>&nbsp</td></tr>');
            }
        }
        
    }   
  </script>
  </table>
  </td>
  
  </tr> 
</table> 

<div class="func_spread"></div>

</div>


<div id="wlancoverAPInfo">

<div class="func_title">
	<SCRIPT>document.write(cfg_wificoverinfo_language["amp_wificover_onlineap_head"]);</SCRIPT>
</div>

<div id="wlancoverAPInfo_Table_Container" style="overflow:auto;overflow-y:hidden">

<script language="JavaScript" type="text/JavaScript">
var index = 0;
var apDevice ;

FirstOnlineApInst = 0;

var WCShowableFlag = 1;
var WCShowButtonFlag = 0;
var WCColumnNum = 8;
var WCArray = new Array();
var WCConfiglistInfo = new Array(
		new stTableTileInfo("amp_wificover_onlineap_type","align_center","type",false),
		new stTableTileInfo("amp_wificover_onlineap_sn","align_center","sn",false),
		new stTableTileInfo("amp_wificover_onlineap_hwver","align_center","hwversion",false),
		new stTableTileInfo("amp_wificover_onlineap_swver","align_center","swversion",false),
		new stTableTileInfo("amp_wificover_onlineap_onlinetime","align_center","uptime",false),
		new stTableTileInfo("amp_wificover_onlineap_ssidlist","align_center","ssidList",false),
		new stTableTileInfo("amp_wificover_onlineap_channel","align_center","channel",false),
		new stTableTileInfo("amp_wificover_onlineap_txpoer","align_center","transmitepower",false),null);

if ( 0 != apDeviceList.length - 1)
{
    for (index = 0; index < apDeviceList.length - 1; index++)
    {
        apDevice =  apDeviceList[index];
        
        if (apDevice.ApOnlineFlag == 0)
        {
            continue;
        }

        var ApInstId = getInstIdByDomain(apDevice.domain);

		apInstIdArr.push(ApInstId);
		
        getApSsidList(apDevice.domain);
		apDevice.ssidList = ApSsidList;

		WCArray.push(apDevice);
   }
   wificoverApId = apInstIdArr[0];
   FirstOnlineApInst = apInstIdArr[0];
}

WCArray.push(null);
HWShowTableListByType(WCShowableFlag, "tbWlancoverAPInfo", WCShowButtonFlag, WCColumnNum, WCArray, WCConfiglistInfo, cfg_wificoverinfo_language, null);

fixIETableScroll("wlancoverAPInfo_Table_Container", "tbWlancoverAPInfo");

</script>

</div>

<div class="func_spread"></div>

</div>

<table width="100%" height="100%"  class="tabal_bg">
      <tr class="head_title">
        <td width="20%" id="tab1" onclick="switchTab('tab1');" style="background-color:#f6f6f6"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ap_device_title']);</script></td>
        <td width="20%" id="tab2" onclick="switchTab('tab2');"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ap_neigh_title']);</script></td>
        <td width="20%" id="tab3" onclick="switchTab('tab3');"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ap_stats_title']);</script></td>
      </tr>
    </table>
    
<iframe id="coverinfo_content" name="coverinfo_content" width="100%" height="0" scrolling="auto" frameborder="0" >
   </iframe>


</body>
</html>

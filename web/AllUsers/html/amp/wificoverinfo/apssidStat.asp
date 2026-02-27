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

<title>WLAN智能覆盖网络信息</title>
<script language="JavaScript" type="text/javascript">

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

function stApSsidStat(domain,TotalBytesSent,TotalBytesReceived,TotalPacketsSent,TotalPacketsReceived,ErrorsSent,ErrorsReceived,DiscardPacketsSent,DiscardPacketsReceived)
{
	this.domain = domain;
	this.TotalBytesSent = TotalBytesSent;
	this.TotalBytesReceived = TotalBytesReceived;
	this.TotalPacketsSent = TotalPacketsSent;
	this.TotalPacketsReceived = TotalPacketsReceived;
	this.ErrorsSent = ErrorsSent;
	this.ErrorsReceived = ErrorsReceived;
	this.DiscardPacketsSent = DiscardPacketsSent;
	this.DiscardPacketsReceived = DiscardPacketsReceived;
}

var apStats = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i}.WLANConfiguration.{i}.Stats, TotalBytesSent|TotalBytesReceived|TotalPacketsSent|TotalPacketsReceived|ErrorsSent|ErrorsReceived|DiscardPacketsSent|DiscardPacketsReceived, stApSsidStat);%>;

function stApSsid(domain,SSID)
{
	this.domain = domain;
	this.SSID = SSID;
}

var apSsid= <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i}.WLANConfiguration.{i}, SSID, stApSsid);%>;


function ApSsidStation(domain)
{
	this.domain = domain;
}

var stApSta = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i}.WLANConfiguration.{i}.AssociatedDevice.{i}, , ApSsidStation);%>;;

var ApWlcStaNum = 0;
function getSsidStaNum(domain)
{	
	ApWlcStaNum = 0;
	for (var i = 0; i < stApSta.length - 1; i++)
	{
		var pathlength = "InternetGatewayDevice.X_HW_APDevice.1.WLANConfiguration.1";
		var pathApSta = stApSta[i].domain;
		
		var pathApWlc = pathApSta.substring(0, pathlength.length);
		
		if (domain == pathApWlc)
		{
			ApWlcStaNum++;
		}
	}
}

var wificoverApId = 1;
if (location.href.indexOf("apssidStat.asp?") > 0)
{
	wificoverApId = location.href.split("?")[1]; 
}

function LoadFrame()
{ 
    LoadResource();
	parent.document.getElementById('coverinfo_content').height = document.body.scrollHeight + 10;
	fixIETableScroll("ApssidstatInfo_Table_Container", "tbApssidstat");
}

</script>
</head>

<body  class="mainbody"  style="margin-left:0;margin-right:0;margin-top:0" onLoad="LoadFrame();">

<div id="ApssidstatInfo">

<div id="ApssidstatInfo_Table_Container" style="overflow:auto;overflow-y:hidden">

<table id="tbApssidstat" width="100%" cellspacing="1" class="tabal_bg" border="0">
  <tr class="head_title"> 
    <td rowspan="2" BindText='amp_wificover_common_ssidname'></td>
    <td rowspan="2" BindText='amp_wificover_ap_stats_devnum'></td>
    <td colspan="4" align="center"BindText='amp_wificover_ap_stats_rx'></td>
    <td colspan="4" align="center"BindText='amp_wificover_ap_stats_tx'></td>
  </tr>
  <tr  class="head_title"> 
    <td BindText='amp_wificover_ap_stats_byte'></td>
    <td BindText='amp_wificover_ap_stats_pkg'></td>
    <td BindText='amp_wificover_ap_stats_errpkg'></td>
    <td BindText='amp_wificover_ap_stats_droppkg'></td>
    <td BindText='amp_wificover_ap_stats_byte'></td>
    <td BindText='amp_wificover_ap_stats_pkg'></td>
    <td BindText='amp_wificover_ap_stats_errpkg'></td>
    <td BindText='amp_wificover_ap_stats_droppkg'></td>
  </tr>
  <script language="JavaScript" type="text/JavaScript">
   var index = 0;
   if (0 == apSsid.length - 1)
   {
            document.writeln("<tr class='tabal_01'>");
            document.writeln("<td class='align_center'>--</td>");
            document.writeln("<td class='align_center'>--</td>");
            document.writeln("<td class='align_center'>--</td>");
            document.writeln("<td class='align_center'>--</td>");
            document.writeln("<td class='align_center'>--</td>");
            document.writeln("<td class='align_center'>--</td>");
            document.writeln("<td class='align_center'>--</td>");
            document.writeln("<td class='align_center'>--</td>");
            document.writeln("<td class='align_center'>--</td>");
            document.writeln("<td class='align_center'>--</td>");
            document.writeln("</tr>");
   }
   else
   {
   	   var curApStaNum = 0; 
	   for (index = 0; index < apSsid.length - 1; index++)
	   {

	   		var path = "InternetGatewayDevice.X_HW_APDevice.";
			var ApInst = apStats[index].domain.charAt(path.length);
	   
 	   		if ( (wificoverApId != ApInst) || (apStats[index].TotalBytesSent == ""))
			{
				continue;
			}
			else
			{
				curApStaNum++;
				
				if( curApStaNum%2 )
				{
					document.write("<tr class=\"tabal_01\">");
				}
				else
				{
					document.write("<tr class=\"tabal_02\">");
				}

				document.write('<td class=\"align_center\">'+ apSsid[index].SSID +'</td>');
				
				getSsidStaNum(apSsid[index].domain);
				document.write('<td class=\"align_center\">'+ ApWlcStaNum +'</td>');
				
				document.write('<td class=\"align_center\">'+apStats[index].TotalBytesReceived	+'</td>');
				document.write('<td class=\"align_center\">'+apStats[index].TotalPacketsReceived	+'</td>');
				document.write('<td class=\"align_center\">'+apStats[index].ErrorsReceived	+'</td>');
				document.write('<td class=\"align_center\">'+apStats[index].DiscardPacketsReceived	+'</td>');
				document.write('<td class=\"align_center\">'+apStats[index].TotalBytesSent	+'</td>');
				document.write('<td class=\"align_center\">'+apStats[index].TotalPacketsSent	+'</td>');
				document.write('<td class=\"align_center\">'+apStats[index].ErrorsSent	+'</td>');
				document.write('<td class=\"align_center\">'+apStats[index].DiscardPacketsSent	+'</td>');
		
				document.write("</tr>");
			}
	   }

		if (0 == curApStaNum)
	   	{
			document.writeln("<tr class='tabal_01'>");
			document.writeln("<td class='align_center'>--</td>");
			document.writeln("<td class='align_center'>--</td>");
			document.writeln("<td class='align_center'>--</td>");
			document.writeln("<td class='align_center'>--</td>");
			document.writeln("<td class='align_center'>--</td>");
			document.writeln("<td class='align_center'>--</td>");
			document.writeln("<td class='align_center'>--</td>");
			document.writeln("<td class='align_center'>--</td>");
			document.writeln("<td class='align_center'>--</td>");
			document.writeln("<td class='align_center'>--</td>");
			document.writeln("</tr>");
	   	}	   
	}
  </script>
  
</table>

</div>

<div class="func_spread"></div>

</div>

</body>
</html>

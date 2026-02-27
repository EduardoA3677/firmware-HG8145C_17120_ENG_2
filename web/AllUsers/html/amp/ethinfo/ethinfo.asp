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
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/lanuserinfo.asp"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>

<title>Eth Port Information</title>
<script language="JavaScript" type="text/javascript">

var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var curWebFrame='<%HW_WEB_GetWEBFramePath();%>';
var sys_com_eng_display = 0;
var isOpticUpMode = '<%HW_WEB_IsOpticUpMode();%>';
var P2pFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_P2P);%>';

var TelMexFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TELMEX);%>';

var BjcuFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_BJCU);%>';

if (curLanguage.toUpperCase() == 'CHINESE')
{
		var CommonFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_COMMON);%>';
		if( (curUserType == sysUserType) || (1 == CommonFlag) )
		{
			sys_com_eng_display = 1;
		}
}
else
{
	sys_com_eng_display = 1;
}


function LoadFrame() 
{
	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}

		b.innerHTML = status_ethinfo_language[b.getAttribute("BindText")];
	}

    if (1 == TelMexFlag)
	{
		setDisplay("divVlanMacInfo",1);
    }
    if (('1' == P2pFlag) && ('0' == isOpticUpMode) && (6 == geInfos.length))
    {
        getElById('ExtId').className = "gray";
        getElById('ModeId').className = "gray"; getElById('ModeId').innerHTML = "-";
        getElById('SpeedId').className = "gray"; getElById('SpeedId').innerHTML = "-";
        getElById('StatusId').className = "gray"; getElById('StatusId').innerHTML = "-";
        getElById('RxBId').className = "gray"; getElById('RxBId').innerHTML = "-";
        getElById('RxFId').className = "gray"; getElById('RxFId').innerHTML = "-";
        getElById('TxBId').className = "gray"; getElById('TxBId').innerHTML = "-";
        getElById('TxFId').className = "gray"; getElById('TxFId').innerHTML = "-";
    }
}


function LANStats(domain,txPakets,txBytes,rxPackets,rxBytes)
{  
    this.domain   = domain;
    this.txPackets = txPakets;
    this.txBytes  = txBytes;
	this.rxPackets = rxPackets;
	this.rxBytes  = rxBytes;
}

var userEthInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.LANPort.{i}.Statistics,SendFrame|SendGoodPktOcts|RcvFrame|RcvGoodPktOcts,LANStats);%>;

function IncorrectStats(domain, RcvFrame_Undersize, RcvTooLong, RcvFragmentFrame, RcvJabbersFrame, RcvFcsErrFrame, RcvAlignErrFrame, MacRxErrFrame, CarrierSenseErrCnt,ExcessCollisionFrame, MacSendErrFrame)
{  
    var delta = 0;
    if ( (parseInt(RcvTooLong) >= parseInt(RcvJabbersFrame)) && (parseInt(RcvFcsErrFrame) >= parseInt(RcvJabbersFrame)) )
    {
    	delta = parseInt(RcvTooLong) + parseInt(RcvFcsErrFrame) - parseInt(RcvJabbersFrame);
    }
    else
    {
    	delta = parseInt(RcvTooLong) + parseInt(RcvFcsErrFrame);
    }

    this.domain   			= domain;

    this.rxDiscardPackets 	=   parseInt(RcvFrame_Undersize)     						 
    						  + parseInt(RcvAlignErrFrame) 
    						  + parseInt(MacRxErrFrame)
    						  + delta;

    this.txDiscardPackets 	=   parseInt(CarrierSenseErrCnt)
    						  + parseInt(ExcessCollisionFrame)
    						  + parseInt(MacSendErrFrame);

    this.rxErrorPackets 	=   parseInt(RcvFrame_Undersize)     						
    						  + parseInt(MacRxErrFrame)
    						  + delta;

    this.txErrorPackets 	= 0; 
}

var incorrectPortStats = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.LANPort.{i}.Statistics, RcvFrame_Undersize|RcvTooLong|RcvFragmentFrame|RcvJabbersFrame|RcvFcsErrFrame|RcvAlignErrFrame|MacRxErrFrame|CarrierSenseErrCnt|ExcessCollisionFrame|MacSendErrFrame, IncorrectStats);%>;

function GEInfo(domain,Mode,Speed,Status)
{
	this.domain		= domain;
	this.Mode 		= Mode;
	this.Speed 		= Speed;
	this.Status 	= Status; 
	
	if(Status==1)
	{
		if(Mode==0)this.Mode = status_ethinfo_language['amp_port_halfduplex'];
		if(Mode==1)this.Mode = status_ethinfo_language['amp_port_fullduplex'];

		if(Speed==0)this.Speed = status_ethinfo_language['amp_port_10M'];
		if(Speed==1)this.Speed = status_ethinfo_language['amp_port_100M'];
		if(Speed==2)this.Speed = status_ethinfo_language['amp_port_1000M'];
		if(Speed==3)this.Speed = status_ethinfo_language['amp_port_10000M'];
		
		this.Status = status_ethinfo_language['amp_port_linkup'];
	}
	else
	{
		this.Mode = "--";
		this.Speed = "--";
		this.Status = status_ethinfo_language['amp_port_linkdown'];
	}
}

var geInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.LANPort.{i}.CommonConfig,Duplex|Speed|Link,GEInfo);%>;


var lanMac = "--:--:--:--:--:--";
function DeviceLanMAC(domain,LanMac,WLanMac)
{
	this.domain 	= domain;
	this.LanMac   = LanMac;
	this.WLANMac	= WLanMac;
}

var DeviceLanMACs = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo,X_HW_LanMac|X_HW_WlanMac,DeviceLanMAC);%>;

lanMac = DeviceLanMACs[0].LanMac;

var WanEthInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANEthernetInterfaceConfig, X_HW_DuplexMode|X_HW_Speed|Status, WanEthInfo);%>;

function WanEthInfo(domain,Mode,Speed,Status)
{
	this.domain	= domain;
	this.Mode 	= Mode;
	if((Mode == "Auto_Half") || (Mode == "Half"))this.Mode = status_ethinfo_language['amp_port_halfduplex'];
	if((Mode == "Auto_Full") || (Mode == "Full"))this.Mode = status_ethinfo_language['amp_port_fullduplex'];
	if(Mode == "")this.Mode = status_ethinfo_language['amp_port_halfduplex'];
	
	this.Speed 	= Speed; 
	if((Speed == "Auto_10") || (Speed == "10"))this.Speed = status_ethinfo_language['amp_port_10M'];
	if((Speed == "Auto_100") || (Speed == "100"))this.Speed = status_ethinfo_language['amp_port_100M'];
	if((Speed == "Auto_1000") || (Speed == "1000"))this.Speed = status_ethinfo_language['amp_port_1000M'];
	if(Speed == "")this.Speed = status_ethinfo_language['amp_port_10M'];;
	
	this.Status = status_ethinfo_language['amp_port_linkdown'];
	if(Status == "Up")this.Status = status_ethinfo_language['amp_port_linkup'];
}

var WanEthStats = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANEthernetInterfaceConfig.Stats, BytesReceived|PacketsReceived|BytesSent|PacketsSent, WanEthStats);%>;

function WanEthStats(domain, BytesReceived, PacketsReceived, BytesSent, PacketsSent)
{  
	this.domain             = domain;
	this.BytesReceived 	    = BytesReceived;
	this.PacketsReceived    = PacketsReceived;
	this.BytesSent  	= BytesSent;
	this.PacketsSent 	= PacketsSent;     
}

</script>

</head>
<body onLoad="LoadFrame();" class="mainbody">

<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("amp_ethinfo_desc", 
	GetDescFormArrayById(status_ethinfo_language, "amp_ethinfo_desc_head"), 
	GetDescFormArrayById(status_ethinfo_language, "amp_ethinfo_desc"), false);
</script>

<div class="title_spread"></div>

<div id="divVlanMacInfo" style="display:none">

<div class="func_title"><SCRIPT>document.write(status_ethinfo_language["amp_lanmacinfo_title"]);</SCRIPT></div>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
<tr>
	<td width="25%"  class="table_title" style="color: #000000;" BindText='amp_lanmac'></td>
	<td class="table_right" style="color: #000000;">
		<script language="JavaScript" type="text/javascript">
		document.write(lanMac);
		</script>
	</td> 
</tr>
</table>

<div class="func_spread"></div>

</div>

<div id="divDhcpInfo" style="display:none">

<div class="func_title"><SCRIPT>document.write(status_ethinfo_language["amp_dhcpinfo_title"]);</SCRIPT></div>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
	<tr class="head_title" id="dhcpinfotitle">
	    <td BindText='amp_dhcpinfo_ipadd'></td>
	    <td BindText='amp_dhcpinfo_macadd'></td>
	    <td BindText='amp_dhcpinfo_dev'></td>
	</tr>
	<script type="text/javascript" language="javascript">
	function appendstr(str)
	{
		return str;
	}
	function createdhcptable(dhcpInfos)
	{
	    var dhcpNum = dhcpInfos.length - 1;
		var Count = 0;
		var output = "";
		for(i=0;i< dhcpNum ;i++)
		{
			if (0 == dhcpInfos[i].remaintime)
	        {  
	  			continue;
	        }
	              
	        Count++;		

	        if(Count%2 == 0)
	 		{
	 		    output = output + appendstr("<tr class=\"tabal_01\">");
	 		}
	 		else
	 		{
	 		    output = output + appendstr("<tr class=\"tabal_02\">");
	 		}

			output = output + appendstr('<td class=\"align_center\">'+dhcpInfos[i].ip	+'</td>');
			output = output + appendstr('<td class=\"align_center\">'+dhcpInfos[i].mac	+'</td>');
			output = output + appendstr('<td class=\"align_center\">'+dhcpInfos[i].devtype	+'</td>');

			output = output + appendstr("</tr>");
		}

		if(( 0 == dhcpNum ) || (Count == 0) )
		{
			output = output + appendstr("<tr class=\"tabal_01\">");
			output = output + appendstr('<td class=\"align_center\">'+'--'	+'</td>');
			output = output + appendstr('<td class=\"align_center\">'+'--'	+'</td>');
			output = output + appendstr('<td class=\"align_center\">'+'--'	+'</td>');
			output = output + appendstr("</tr>");
		}

		$("#dhcpinfotitle").after(output);
	}
	

	GetLanUserDhcpInfo(function(para)
	{
		createdhcptable(para);	
	});
	</script>
</table>

<div class="func_spread"></div>

</div>

<div style="overflow:auto;overflow-y:hidden"> 

<div class="func_title"><SCRIPT>document.write(status_ethinfo_language["amp_ethinfo_title"]);</SCRIPT></div>

<table id="eth_status_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
	<tr class="head_title">
    <td colspan="1" rowspan="2" BindText='amp_ethinfo_portnum'></td>
	<td colspan="3" BindText='amp_ethinfo_portstatus'></td>
    <script type="text/javascript" language="javascript">
	
    if( 1 == sys_com_eng_display )
	{
       if (1 == TelMexFlag)
       {
        	document.write('<td colspan="4">' + status_ethinfo_language['amp_ethinfo_rx'] + '</td>');
        	document.write('<td colspan="4">' + status_ethinfo_language['amp_ethinfo_tx'] + '</td>');
	   }
	   else
	   {
	   		document.write('<td colspan="2">' + status_ethinfo_language['amp_ethinfo_rx'] + '</td>');
        	document.write('<td colspan="2">' + status_ethinfo_language['amp_ethinfo_tx'] + '</td>');
	   } 
	}
	</script>
	</tr>
                    
    <tr class="head_title">
    <td BindText='amp_ethinfo_duplex'></td>
    <td BindText='amp_ethinfo_speed'></td>
    <td BindText='amp_ethinfo_link'></td>
    <script type="text/javascript" language="javascript">

    if( 1 == sys_com_eng_display )
	{
        document.write('<td>' + status_ethinfo_language['amp_ethinfo_bytes'] + '</td>');        
        document.write('<td>' + status_ethinfo_language['amp_ethinfo_pkts'] + '</td>');

        if (1 == TelMexFlag)
        {
         	document.write('<td>' + status_ethinfo_language['amp_ethstat_err'] + '</td>');        
        	document.write('<td>' + status_ethinfo_language['amp_ethstat_drop'] + '</td>');
        }

        document.write('<td>' + status_ethinfo_language['amp_ethinfo_bytes'] + '</td>');        
        document.write('<td>' + status_ethinfo_language['amp_ethinfo_pkts'] + '</td>');

        if (1 == TelMexFlag)
        {
         	document.write('<td>' + status_ethinfo_language['amp_ethstat_err'] + '</td>');        
        	document.write('<td>' + status_ethinfo_language['amp_ethstat_drop'] + '</td>');
        }
	}
	</script>

    </tr>
    <script type="text/javascript" language="javascript">
	if( 1 == userEthInfos.length || null == userEthInfos)
	{
		document.write("<tr class=\"tabal_01\">");
		document.write('<td>'+'&nbsp '	+'</td>');
		document.write('<td>'+'&nbsp '	+'</td>');
		document.write('<td>'+'&nbsp '	+'</td>');
		document.write('<td>'+'&nbsp '	+'</td>');
		
        if( 1 == sys_com_eng_display )
	    {
		    document.write('<td>'+'&nbsp '	+'</td>');
		    document.write('<td>'+'&nbsp '	+'</td>');

			if (1 == TelMexFlag)
			{
				document.write('<td>'+'&nbsp '	+'</td>');
		    	document.write('<td>'+'&nbsp '	+'</td>');				    	
			}

		    document.write('<td>'+'&nbsp '	+'</td>');
		    document.write('<td>'+'&nbsp '	+'</td>');

		    if (1 == TelMexFlag)
			{
				document.write('<td>'+'&nbsp '	+'</td>');
		    	document.write('<td>'+'&nbsp '	+'</td>');				    	
			}
		}
		document.write("</tr>");
	}

	var lanid;
	for(i=0; i<userEthInfos.length - 1; i++)
	{
	    lanid = i+1;
		if (('1' == P2pFlag) && (lanid >= userEthInfos.length - 1) && (5 != userEthInfos.length))
		{
			break;
		}
		if(i%2 == 0)
		{
		    document.write("<tr class=\"tabal_01\">");
		}
		else
		{
		    document.write("<tr class=\"tabal_02\">");
		}
		document.write('<td>'+  lanid	+'</td>');
		document.write('<td>'+geInfos[i].Mode	+'</td>');
		document.write('<td>'+geInfos[i].Speed	+'</td>');
		document.write('<td>'+geInfos[i].Status	+'</td>');

        if( 1 == sys_com_eng_display )
        {
		    document.write('<td>'+userEthInfos[i].rxBytes	+'</td>');
		    document.write('<td>'+userEthInfos[i].rxPackets	+'</td>');

		    if (1 == TelMexFlag)
			{
				document.write('<td>'+ incorrectPortStats[i].rxErrorPackets	+'</td>');
		    	document.write('<td>'+ incorrectPortStats[i].rxDiscardPackets +'</td>');	    	
			}

		    document.write('<td>'+userEthInfos[i].txBytes	+'</td>');
		    document.write('<td>'+userEthInfos[i].txPackets	+'</td>');

		    if (1 == TelMexFlag)
			{
				document.write('<td>'+ incorrectPortStats[i].txErrorPackets	+'</td>');
		    	document.write('<td>'+ incorrectPortStats[i].txDiscardPackets +'</td>');    	
			}
        }
		document.write("</tr>");
	   
	}

	if ('1' == P2pFlag)
	{
		if (6 == geInfos.length)
		{
			var uiExtEthId = 4;
 		
			document.write("<tr class=\"tabal_01\">");
			document.write('<td id="ExtId">' + status_ethinfo_language['amp_port_ext1'] +'</td>');
			document.write('<td id="ModeId">'+ geInfos[uiExtEthId].Mode	+'</td>');
			document.write('<td id="SpeedId">'+ geInfos[uiExtEthId].Speed	+'</td>');
			document.write('<td id="StatusId">'+ geInfos[uiExtEthId].Status	+'</td>');
			if( 1 == sys_com_eng_display )
			{
				document.write('<td id="RxBId">'+ userEthInfos[uiExtEthId].rxBytes	+'</td>');
				document.write('<td id="RxFId">'+ userEthInfos[uiExtEthId].rxPackets	+'</td>');
				document.write('<td id="TxBId">'+ userEthInfos[uiExtEthId].txBytes	+'</td>');
				document.write('<td id="TxFId">'+ userEthInfos[uiExtEthId].txPackets	+'</td>');
			}
			document.write("</tr>");

			document.write("<tr class=\"tabal_02\">");
			document.write('<td>' + status_ethinfo_language['amp_port_wan'] + '</td>');
			document.write('<td>'+ WanEthInfos[0].Mode	+'</td>');
			document.write('<td>'+ WanEthInfos[0].Speed	+'</td>');
			document.write('<td>'+ WanEthInfos[0].Status	+'</td>');
			if( 1 == sys_com_eng_display )
			{
				document.write('<td>'+WanEthStats[0].BytesReceived	+'</td>');
				document.write('<td>'+WanEthStats[0].PacketsReceived	+'</td>');
				document.write('<td>'+WanEthStats[0].BytesSent	+'</td>');
				document.write('<td>'+WanEthStats[0].PacketsSent	+'</td>');
			}
			document.write("</tr>");
		}
		else
		{
			if(lanid%2 == 1)
			{
			    document.write("<tr class=\"tabal_01\">");
			}
			else
			{
			    document.write("<tr class=\"tabal_02\">");
			}
			document.write('<td>' + status_ethinfo_language['amp_port_wan'] + '</td>');
			document.write('<td>'+ WanEthInfos[0].Mode	+'</td>');
			document.write('<td>'+ WanEthInfos[0].Speed	+'</td>');
			document.write('<td>'+ WanEthInfos[0].Status	+'</td>');
			if( 1 == sys_com_eng_display )
			{
				document.write('<td>'+WanEthStats[0].BytesReceived	+'</td>');
				document.write('<td>'+WanEthStats[0].PacketsReceived	+'</td>');
				document.write('<td>'+WanEthStats[0].BytesSent	+'</td>');
				document.write('<td>'+WanEthStats[0].PacketsSent	+'</td>');
			}
			document.write("</tr>");
		}
	}
	</script>
</table>
</div>

<table width="100%" border="0" cellspacing="5" cellpadding="0">
<tr ><td class="height_10p"></td></tr>
</table>
</body>
<script language="JavaScript" type="text/JavaScript">
if((curWebFrame == 'frame_CMCC') || (curWebFrame == 'frame_telmex') || (BjcuFlag == '1'))
{
    setDisplay("divDhcpInfo",1);
}
</script>
</html>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="../common/userinfo.asp"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/wanipv6state.asp"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/EquipTestResult.asp"></script>
<script language="JavaScript" type="text/javascript">
var DATA_BLOCK_DEFAULT=56;
var REPEATE_TIME_DEFAULT=4;
var DSCP_DEFAULT=0;
var MaxTimeout_DEFAULT = 10;
var TraceRoute_DATA_BLOCK_DEFAULT = 38;

var PING_FLAG="Ping";
var TRACEROUTE_FLAG="Traceroute";
var EQUIPTEST_FLAG="EquipTest";

var CLICK_INIT_FLAG="None";
var CLICK_START_FLAG="START";
var CLICK_TERMINAL_FLAG="TERMIANL";

var STATE_INIT_FLAG="None";
var STATE_DOING_FLAG="Doing";
var STATE_DONE_FLAG="Done";

var TimerHandle ;
var TimerHandlePing;
var TimerHandlePingDns;
var TimerHandleEquip;

var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>';

function loadlanguage()
{
	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		b.innerHTML = diagnose_language[b.getAttribute("BindText")];
	}
}

function Br0IPAddressItem(domain, IPAddress, SubnetMask)
{
    this.domain = domain;
    this.IPAddress = IPAddress;
    this.SubnetMask = SubnetMask;
}
function PingResultClass(domain, DiagnosticsState,Interface,Host,NumberOfRepetitions,Timeout,DataBlockSize,DSCP,FailureCount, SuccessCount,MinimumResponseTime,MaximumResponseTime,AverageResponseTime)
{
    this.domain = domain;
    this.DiagnosticsState = DiagnosticsState;
    this.Interface = Interface;
    this.Host = Host;
    this.NumberOfRepetitions = NumberOfRepetitions;
    this.Timeout = Timeout;
    this.DataBlockSize = DataBlockSize;
    this.DSCP = DSCP;
    this.FailureCount = FailureCount;
    this.SuccessCount = SuccessCount;
    this.MinimumResponseTime = MinimumResponseTime;
    this.MaximumResponseTime = MaximumResponseTime;
    this.AverageResponseTime = AverageResponseTime;
}
function TracertResultClass(domain,DiagnosticsState,Interface,Host,NumberOfTries,Timeout,DataBlockSize,DSCP,MaxHopCount,ResponseTime,RouteHopsNumberOfEntries)
{
	this.domain = domain;
	this.DiagnosticsState = DiagnosticsState;
	this.Interface = Interface;
	this.Host = Host;
	this.NumberOfTries = NumberOfTries;
	this.Timeout = Timeout;
	this.DataBlockSize = DataBlockSize;
	this.DSCP = DSCP;
	this.MaxHopCount = MaxHopCount;
	this.ResponseTime = ResponseTime;
	this.RouteHopsNumberOfEntries = RouteHopsNumberOfEntries;
}

function GEInfo(domain,Mode,Speed,Status)
{
	this.domain		= domain;
	this.Mode 		= Mode;
	if(Mode==0)this.Mode = status_ethinfo_language['amp_port_halfduplex'];
	if(Mode==1)this.Mode = status_ethinfo_language['amp_port_fullduplex'];

	this.Speed 		= Speed;
	if(Speed==0)this.Speed = status_ethinfo_language['amp_port_10M'];
	if(Speed==1)this.Speed = status_ethinfo_language['amp_port_100M'];
	if(Speed==2)this.Speed = status_ethinfo_language['amp_port_1000M'];
	if(Speed==3)this.Speed = status_ethinfo_language['amp_port_10000M'];
	
	this.Status 	= Status; 
	if(Status==0)this.Status = status_ethinfo_language['amp_port_linkdown'];
	if(Status==1)this.Status = status_ethinfo_language['amp_port_linkup'];
}

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

function stRadio(domain,OperatingFrequencyBand,Enable)
{
    this.domain = domain;
    this.OperatingFrequencyBand = OperatingFrequencyBand;
    this.Enable = Enable;
}

var LanHostInfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterSlaveLanHostIp, InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,Br0IPAddressItem);%>;
var LanHostInfo = LanHostInfos[0];
var PingResultList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetPingResult, InternetGatewayDevice.IPPingDiagnostics,DiagnosticsState|Interface|Host|NumberOfRepetitions|Timeout|DataBlockSize|DSCP|FailureCount|SuccessCount|MinimumResponseTime|MaximumResponseTime|AverageResponseTime, PingResultClass);%>;
var PingResult = PingResultList[0];
var TracertResultList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.TraceRouteDiagnostics,DiagnosticsState|Interface|Host|NumberOfTries|Timeout|DataBlockSize|DSCP|MaxHopCount|ResponseTime|RouteHopsNumberOfEntries, TracertResultClass);%>;
var TracerResult = TracertResultList[0];
var splitobj = "[@#@]";
var dnsString = "";

var PingClickFlag= "<%HW_WEB_GetRunState("Ping");%>";
var TracerouteClickFlag= "<%HW_WEB_GetRunState("Traceroute");%>";
var EquipTestClickFlag= "<%HW_WEB_GetRunState("EquipTest");%>";

var PingState=STATE_INIT_FLAG;
var TraceRouteState=STATE_INIT_FLAG;
var EquipCheckState=STATE_INIT_FLAG;

var P2pFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_P2P);%>';
var geInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.LANPort.{i}.CommonConfig,Duplex|Speed|Link,GEInfo);%>;
var WanEthInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANEthernetInterfaceConfig, X_HW_DuplexMode|X_HW_Speed|Status, WanEthInfo);%>;

var wlanFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';
var WlanInfos = new Array();

var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
var opticInfo = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic.RxPower);%>';
var gponStatus = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT.State);%>';
var eponStatus = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.OAM.ONT.State);%>';

function WlanInfoRefresh()
{
	if('1' != wlanFlag)
	{
		return;
	}
	
    var ChanInfo = '<%HW_WEB_GetChanInfo();%>';
    var DoubleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>';
    var wlanEnbl = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>';
	var Radio  = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WiFi.Radio.{i},OperatingFrequencyBand|Enable,stRadio);%>;
	
	WlanInfos.push(['2.4 GHz', 
		('1' == wlanEnbl && '1' == Radio[0].Enable)?status_wlaninfo_language['amp_wlanlink_on']:status_wlaninfo_language['amp_wlanlink_off'], 
		ChanInfo.split(',')[0]]);
		
	if(1 == DoubleFreqFlag)
	{
		WlanInfos.push(['5 GHz', 
			('1' == wlanEnbl && '1' == Radio[1].Enable)?status_wlaninfo_language['amp_wlanlink_on']:status_wlaninfo_language['amp_wlanlink_off'],  
			ChanInfo.split(',')[1]]);
	}
}

function setOpticLinkStatus()
{
	var status = '';
	if(opticInfo == "--" || opticInfo == "")
	{ 
		status = status_ethinfo_language['amp_port_linkdown'];
	}
	else
	{
		status = status_ethinfo_language['amp_port_linkup'];
	}
	document.write(status);
}

function setRegistrationStatus()
{
	var status = '';
	if (ontPonMode.toUpperCase() == 'GPON')
	{
		status = gponStatus.toUpperCase();
	}
	else if (ontPonMode.toUpperCase() == 'EPON')
	{
		status = eponStatus.toUpperCase();
	}
	else
	{
		status = '--';
	}
	document.write(status);
}

function OnApply()
{
    var IPAddress = getValue("IPAddress");
    var WanName = getSelectVal("WanNameList");

    IPAddress = removeSpaceTrim(IPAddress);
    if (IPAddress.length == 0)
    {
		AlertEx(diagnose_language['bbsp_taraddrisreq']);
        return false;
    }
	if(IPAddress.indexOf("\"") >= 0)
	{
		AlertEx(diagnose_language['bbsp_targetaddrinvalid']);
        return false;
	}
 
	var DataBlockSize = getValue("DataBlockSize");
	DataBlockSize = removeSpaceTrim(DataBlockSize);
	if(DataBlockSize!="")
	{
       if ( false == CheckNumber(DataBlockSize,32, 65500) )
       {
         AlertEx(diagnose_language['bbsp_pingdatablocksizeinvalid']);
         return false;
       }
    }
    else
    {
  	   DataBlockSize=DATA_BLOCK_DEFAULT;
    }
	
	var NumberOfRepetitions = getValue("NumOfRepetitions");
	NumberOfRepetitions = removeSpaceTrim(NumberOfRepetitions);
	if(NumberOfRepetitions!="")
	{
	   var maxRepetitions = ("1" == GetCfgMode().TELMEX) ? 300000 : 3600;
       if ( false == CheckNumber(NumberOfRepetitions,1, maxRepetitions) )
       {
			if("1" == GetCfgMode().TELMEX)
			{
				AlertEx(diagnose_language['bbsp_numofrepetitionsinvalid_telmex']);
				return false;
			}
			else
			{
				AlertEx(diagnose_language['bbsp_numofrepetitionsinvalid']);
				return false;
			}
       }
	}
	else
	{
	   NumberOfRepetitions=REPEATE_TIME_DEFAULT;
	}

	var DSCP = getValue("DscpValue");
	DSCP = removeSpaceTrim(DSCP);
    if(DSCP!="")
	{
       if ( false == CheckNumber(DSCP,0, 63) )
       {
         AlertEx(diagnose_language['bbsp_dscpvalueinvalid']);
         return false;
       }
  }else
  {
  	   DSCP=DSCP_DEFAULT;
  }

	var MaxTimeout = getValue("MaxTimeout");
	MaxTimeout = removeSpaceTrim(MaxTimeout);
	if(MaxTimeout != "")
	{
       if ( false == CheckNumber(MaxTimeout,1, 4294967) )
       {
         AlertEx(diagnose_language['bbsp_maxtimeoutinvalid']);
         return false;
       }
  }else
  {
  	   MaxTimeout = MaxTimeout_DEFAULT;
  }
	MaxTimeout = MaxTimeout*1000;
	
	setDisable("ButtonApply", "1");	
	setDisable("ButtonStopPing", "1");
	getElement('PingTestTitle').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
	getElement('DnsTitle').innerHTML ="";
	getElement('DnsText').innerHTML ="";
	getElement('PingTitle').innerHTML ="";
	getElement('PingText').innerHTML ="";
	
    var Form = new webSubmitForm();

    Form.addParameter('x.Host', IPAddress);
    Form.addParameter('x.DiagnosticsState','Requested');
    Form.addParameter('x.NumberOfRepetitions',NumberOfRepetitions);
    if(DSCP != "")
	{
       Form.addParameter('x.DSCP',DSCP);
    }
    Form.addParameter('x.DataBlockSize',DataBlockSize);
    Form.addParameter('x.Timeout',MaxTimeout);

    if (WanName != "")
    {
       Form.addParameter('x.Interface',WanName); 
    }
	
	Form.addParameter('RUNSTATE_FLAG.value',CLICK_START_FLAG);
	Form.addParameter('x.X_HW_Token', getValue('onttoken')); 
    Form.setAction('complex.cgi?x=InternetGatewayDevice.IPPingDiagnostics&RUNSTATE_FLAG='+PING_FLAG+'&RequestFile=html/bbsp/maintenance/diagnosetool.asp');   
 
    Form.submit(); 
}

function OnStopPing()
{
    var IPAddress = getValue("IPAddress");
    var WanName = getSelectVal("WanNameList");

    if (IPAddress.length == 0)
    {
        return false;
    }
    
    setDisable("ButtonApply", "1");	
	setDisable("ButtonStopPing", "1");
	
	var Form = new webSubmitForm();

    Form.addParameter('x.Host', IPAddress);	
	
    Form.addParameter('x.NumberOfRepetitions',PingResult.NumberOfRepetitions);

    Form.addParameter('x.DSCP',PingResult.DSCP);

    Form.addParameter('x.DataBlockSize',PingResult.DataBlockSize);
    Form.addParameter('x.Timeout',PingResult.Timeout);
    if (WanName != "")
    {
       Form.addParameter('x.Interface',WanName); 
    }

    Form.addParameter('RUNSTATE_FLAG.value',CLICK_TERMINAL_FLAG);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
    Form.setAction('complex.cgi?x=InternetGatewayDevice.IPPingDiagnostics&RUNSTATE_FLAG='+PING_FLAG+'&RequestFile=html/bbsp/maintenance/diagnosetool.asp');   
    Form.submit(); 
}

function replaceSpace(str)
{ 
	var Result = str.split("\n");
	var str_encode = "";
	
	for(var i=0; i<Result.length; i++)
	{
		str_encode += $('<div/>').text(Result[i]).html() + '<br />';
	}
	
	return str_encode;
}

function showPingDnsInfo(dnsTitle, dnsText)
{
	if (dnsString.indexOf("NONE") == -1)
	{
		getElement('DnsTitle').innerHTML = dnsTitle;
		getElement('DnsText').innerHTML = replaceSpace(dnsText);
	}
}


function ParsePingResult(pingString)
{   
	 var subString = pingString.split(splitobj);
	 var result = "";
	 var status = "";
	 if (subString.length >= 2)
	 {

	 	if ("\n" == subString[1])
		{
			status = subString[0];
			getElement('PingTestTitle').innerHTML ='';
			showPingDnsInfo('', '');
			getElement('PingTitle').innerHTML = '';
			getElement('PingText').innerHTML = '';
			substring=null;
			return;
		}
		else
		{
			status = subString[1];
			result = subString[0];
		}
	 }
	 else
	 {
	 	 substring=null;
	 	 return ;
	 }
	 if ((status.indexOf("None") >= 0)
	     ||( status.indexOf("Requested") >= 0) )
	 {
		 if (CLICK_START_FLAG == PingClickFlag)
		 {
			if("1" == GetCfgMode().TELMEX)
			{
				var requestResult = "";
				if(dnsString.indexOf("NONE") == -1)
				{
					requestResult = diagnose_language['bbsp_dnstitle'] + '\n' + dnsString + '\n';
				}
				requestResult += diagnose_language['bbsp_pingtitle'] + '\n';
				if(result.indexOf("NONE") == -1)
				{
					requestResult += result;
				}
				getElement("PingResultArea").value = requestResult;	
			}
			else
			{
				result = ChangeRetsult(result);
				getElement('PingTestTitle').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
			}
			PingState=STATE_DOING_FLAG;
		 }
		 else if(CLICK_INIT_FLAG == PingClickFlag)
		 {
		    PingState=STATE_INIT_FLAG;
		 }		
		  
		 showPingDnsInfo('', '');
		 getElement('PingTitle').innerHTML = '';
		 getElement('PingText').innerHTML = '';
	 }
	 else if( status.indexOf("Complete_Err") >= 0)
	 {
		PingState=STATE_DONE_FLAG;		
		setDisable('ButtonApply',0);		
		setDisable("ButtonStopPing", 1);	
		getElement('PingTestTitle').innerHTML ='<B><FONT color=red>'+diagnose_language['bbsp_fail']+ '</FONT><B>';
		showPingDnsInfo(diagnose_language['bbsp_dnstitle'], dnsString);
		getElement('PingTitle').innerHTML = diagnose_language['bbsp_pingtitle'];
		getElement('PingText').innerHTML = diagnose_language['bbsp_pingfail1'];
		
		var errResult = "";
		if(dnsString.indexOf("NONE") == -1)
		{
			errResult = diagnose_language['bbsp_dnstitle'] + '\n' + dnsString + '\n';
		}
		errResult += diagnose_language['bbsp_pingtitle'] + '\n' + result;
		getElement("PingResultArea").value = errResult;
	 }
	 else if( status.indexOf("Complete") >= 0)
	 {
		PingState=STATE_DONE_FLAG;		
		setDisable('ButtonApply',0);		
		setDisable("ButtonStopPing", 1);	
		var tmpResult = ChangeRetsult(result);
		var SubStatisticResult = tmpResult.split("ping statistics ---<br/>");
		var StatisticResult = SubStatisticResult[1];
		var Result = StatisticResult.split("<br/>");
		
		getElement('PingTestTitle').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_result']+ '</FONT><B>';
		showPingDnsInfo(diagnose_language['bbsp_dnstitle'], dnsString);
		getElement('PingTitle').innerHTML = diagnose_language['bbsp_pingtitle'];
		getElement('PingText').innerHTML = Result[0] + '<br/>' + Result[1];
		
		var completeResult = "";
		if(dnsString.indexOf("NONE") == -1)
		{
			completeResult = diagnose_language['bbsp_dnstitle'] + '\n' + dnsString + '\n';
		}
		completeResult += diagnose_language['bbsp_pingtitle'] + '\n' + result;
		getElement("PingResultArea").value = completeResult;		
	 }
	 else 
	 {
		PingState=STATE_DONE_FLAG;		
		var otherResult = "";
		setDisable('ButtonApply',0);
		setDisable("ButtonStopPing", 1);	
		getElement('PingTestTitle').innerHTML ='<B><FONT color=red>'+diagnose_language['bbsp_fail']+ '</FONT><B>';
		if( false == CheckIsIpOrNot(removeSpaceTrim(getValue("IPAddress"))) )
		{
			if (dnsString.indexOf("NONE") == -1)
			{
				getElement('DnsTitle').innerHTML = diagnose_language['bbsp_dnstitle'];
				getElement('DnsText').innerHTML = replaceSpace(dnsString);
				otherResult = diagnose_language['bbsp_dnstitle'] + '\n' + dnsString + '\n';
			}
			else
			{
				getElement('DnsTitle').innerHTML = diagnose_language['bbsp_dnstitle'];
				getElement('DnsText').innerHTML = diagnose_language['bbsp_pingfail1'];
				otherResult = diagnose_language['bbsp_dnstitle'] + '\n' + diagnose_language['bbsp_pingfail1'] + '\n';
			}
		}
		getElement('PingTitle').innerHTML = diagnose_language['bbsp_pingtitle'];
		getElement('PingText').innerHTML = diagnose_language['bbsp_pingfail1'];
		
		otherResult += diagnose_language['bbsp_pingtitle'] + '\n' + diagnose_language['bbsp_pingfail1'];
		getElement("PingResultArea").value = otherResult;
	 }
	 otherResult = null;
	 completeResult = null;
	 errResult = null;
	 tmpResult=null;
	 SubStatisticResult=null;
	 Result=null;
	 return ;
}

function GetPingResult()
{
	var PingContent="";
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : "./GetPingResult.asp",
		success : function(data) {

			if ((data.length > 8) && ('\\n" + ' == data.substr(2,6)))
			{
				data = data.substr(8);
			}
			PingContent = eval(data);
			ParsePingResult(PingContent);
		},
		complete: function (XHR, TS) { 
            PingContent=null;			
			XHR = null;
		}
	});
}

function GetPingDnsResult()
{
	var PingDnsContent="";
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : "./GetPingDnsResult.asp",
		success : function(data) {

			if ((data.length > 8) && ('\\n" + ' == data.substr(2,6)))
			{
				data = data.substr(8);
			}
			PingDnsContent = eval(data);
			dnsString = PingDnsContent;
		},
		complete: function (XHR, TS) { 
            PingDnsContent = null;			
			XHR = null;
		}
	});
}

function GetPingAllResult()
{
    GetPingDnsResult();
    GetPingResult();
    
	if (CLICK_START_FLAG  ==  PingClickFlag && STATE_DOING_FLAG == PingState)
    { 	
        if(TimerHandlePing == undefined)
        {            
            TimerHandlePing = setInterval("GetPingAllResult()", 10000);
        }
    }
    
    if ((CLICK_START_FLAG  ==  PingClickFlag && STATE_DONE_FLAG == PingState)
        || (CLICK_TERMINAL_FLAG  ==  PingClickFlag) )
    { 	
        if(TimerHandlePing != undefined)
        {
            clearInterval(TimerHandlePing);
        }
    }   
}


function LoadFrame()
{
	if (curUserType == sysUserType)
	{
	    setDisplay("space",0);
	}
	else
	{
	    setDisplay("space",1);
	}
	setDisplay("TraceRoute",1);

	if (CLICK_START_FLAG == TracerouteClickFlag)
	{
		setDisable('btnTraceroute',1);
		setDisable('btnStopTraceroute',0);
		GetRouteResult();		
	}
	else if  (CLICK_TERMINAL_FLAG == TracerouteClickFlag)
	{
		var href = window.location.href.split('&');
		if( (href.length == 3) && (href[2] == 1) )
		{
			getElement('traceRouteresult').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
		}
		setDisable('btnTraceroute',0);
		setDisable("btnStopTraceroute", 1);	 
	 }
	 else if(CLICK_INIT_FLAG == TracerouteClickFlag)//no ping oper after reboot
	 {
	    setDisable('btnTraceroute',0);
		setDisable("btnStopTraceroute", 1);
     }
     else
     {
        //not impossible
	 }

	if (CLICK_START_FLAG == EquipTestClickFlag)
	{
		getElement('equipTestResult').innerHTML = '<B><FONT color=red>'+diagnose_language['selftestwait']+ '</FONT><B>';
		setDisable('EquipCheck',1);
	}
	else
	{
		getElement('equipTestResult').innerHTML ="";
		getElement('EquipTestText').innerHTML = "";
	}
	
	if("1" != GetCfgMode().TELMEX)
	{
		setDisplay("PingTestTitle",1);
		setDisplay("DnsTitle",1);
		setDisplay("DnsTextDiv",1);
		setDisplay("PingTitle",1);
		setDisplay("PingTextDiv",1);
	}
   	 if(CLICK_START_FLAG == PingClickFlag)
	 {
		getElement('PingTestTitle').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
		setDisable('ButtonApply',1);
		setDisable("ButtonStopPing", 0);
		GetPingAllResult();
		if("1" == GetCfgMode().TELMEX)
		{
			setDisplay("PingResultDiv",1);
		}
	 }
	 else if(CLICK_TERMINAL_FLAG == PingClickFlag)
	 {
		var href = window.location.href.split('&');
		if( (href.length == 4) && (href[3] == 1) )
		{
			getElement('PingTestTitle').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_stopping']+ '</FONT><B>';
			
			if("1" == GetCfgMode().TELMEX)
			{
				GetPingAllResult();
				setDisplay("PingResultDiv",1);
			}
		}
		else
		{

		}
		setDisable('ButtonApply',0);
		setDisable("ButtonStopPing", 1);	 
	 }
	 else if(CLICK_INIT_FLAG == PingClickFlag)
	 {
	    setDisable('ButtonApply',0);
		setDisable("ButtonStopPing", 1);
     }
	 

	loadlanguage();
	
	
	var FeatureInfo = GetFeatureInfo();
	if (FeatureInfo.Wan != 1)
	{	
		setDisplay('ThirdPlayerPanel',0);
	}
	
	InitPingTargetList();
	ControlPingDropWanList();

	if('1' == wlanFlag)
	{
		setDisplay('divWlanInfo', 1);
	}
}

function WriteOptionFortraceRoute()
{
   	InitWanNameListControl2("wanname", function(item){
		if((curUserType != sysUserType) && (CfgModeWord.toUpperCase() == "RDSGATEWAY"))
		{
			if ((item.Mode == 'IP_Routed') && (item.Enable == 1) && (item.Tr069Flag == '0') && (item.ServiceList.toString().toUpperCase().indexOf("INTERNET") >=0)){
				return true;
			}
		}
		else if ((curUserType != sysUserType) && (CfgModeWord.toUpperCase() == "DT_HUNGARY"))
        {
            if ((item.Mode == 'IP_Routed') && (item.Enable == 1) && (item.Tr069Flag == '0')
                && (item.ServiceList.toString().toUpperCase().indexOf("INTERNET") >= 0))
            {
                return true;
            }           
        }
		else
		{
			if(IsRadioWanSupported(item))
			{
				if ((item.Mode == "IP_Routed") && (item.RadioWanPSEnable == 1) && (item.Tr069Flag == '0')){
					return true;
				}
			}
			else
			{
				if ((item.Mode == 'IP_Routed') && (item.Enable == 1) && (item.Tr069Flag == '0'))
				{
					return true;
				}
			}
		}
		return false;
   	});
}

function isHostName(name) 
{
    var reg = new RegExp("^[a-z|A-Z]\.");
    return reg.test(name);
}


function startTraceroute()
{
    getElement('TraceRouteText').innerHTML ="";
	with (getElement('TraceRouteForm'))
	{
		var url = getValue('urladdress');
		var wanVal;

		if (url.length == 0)
		{
			AlertEx(diagnose_language['bbsp_taraddrisreq']);
			return false;
		}

		if ((IsIPv6AddressValid(url) == true) && (IsIPv6LinkLocalAddress(url) == true))
		{
			AlertEx(diagnose_language['bbsp_linkLocalnotsup']);
			return false;
		}

		var DataBlockSize = getValue('TraceRouteDataBlockSize');
		DataBlockSize = removeSpaceTrim(DataBlockSize);
		if(DataBlockSize!="")
		{
       		if ( false == CheckNumber(DataBlockSize,38, 32768) )
       		{
         		AlertEx(diagnose_language['bbsp_tracertdatablocksizeinvalid']);
         		return false;
       		}
  		}else
  		{
  	   		DataBlockSize = TraceRoute_DATA_BLOCK_DEFAULT;
  		}

		setDisable('urladdress',1);
		setDisable('TraceRouteDataBlockSize',1);
		setDisable('btnTraceroute',1);
		setDisable('btnStopTraceroute',1);
		getElement('traceRouteresult').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';

		var Form = new webSubmitForm();
		wanVal = getSelectVal('wanname');
		if (wanVal != "")
		{
			Form.addParameter('x.Interface',wanVal); 
		}
		Form.addParameter('x.DiagnosticsState',"Requested"); 
		Form.addParameter('x.Host',url);  
		Form.addParameter('x.DataBlockSize',DataBlockSize);
		Form.addParameter('RUNSTATE_FLAG.value',CLICK_START_FLAG);
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('complex.cgi?x=InternetGatewayDevice.TraceRouteDiagnostics&RUNSTATE_FLAG='+TRACEROUTE_FLAG+'&RequestFile=html/bbsp/maintenance/diagnosetool.asp');               		
        Form.submit();
	}
	return true;
}

function stopTraceroute()
{
    getElement('TraceRouteText').innerHTML ="";
    var url = getValue('urladdress');
    var wanVal;
    if (url.length == 0)
    {
        return false;
    }
    setDisable('urladdress',1);
    setDisable('TraceRouteDataBlockSize',1);
    setDisable('btnTraceroute',1);
    setDisable('btnStopTraceroute',1);
    getElement('traceRouteresult').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
    var Form = new webSubmitForm();
    wanVal = getSelectVal('wanname');
    if (wanVal != "")
    {
        Form.addParameter('x.Interface',wanVal); 
    }
    Form.addParameter('x.Host',url); 
    Form.addParameter('x.DataBlockSize',TracerResult.DataBlockSize);
    Form.addParameter('RUNSTATE_FLAG.value',CLICK_TERMINAL_FLAG);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('complex.cgi?x=InternetGatewayDevice.TraceRouteDiagnostics&RUNSTATE_FLAG='+TRACEROUTE_FLAG+'&RequestFile=html/bbsp/maintenance/diagnosetool.asp');                      
    Form.submit();
	return true;
}

function ChangeRetsult(text)
{
    var result = "";
    if (text.toLowerCase() != 'none')
	{
	   var str=text.replace("!H"," ");
	   res = str.split("\n");
	   
	   for(i=0;i<res.length;i++)
	   {
		  result+=res[i]+'<br/>';
	   }
	}
	return result;
}

function FindResultEnd(string)
{   
	 var newString = string.split(splitobj);
	 var status =  newString[1];
	 var result =  newString[0];

	 if (  (status.indexOf("None") >= 0)
	     ||( status.indexOf("Requested") >= 0) )
	 {
	 	var result;
		result = ChangeRetsult(result);
		getElement('traceRouteresult').innerHTML ='<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
		getElement('TraceRouteText').innerHTML =result;						
		TraceRouteState=STATE_DOING_FLAG;		
	 }
	 else if( status.indexOf("Complete") >= 0)
	 {
		TraceRouteState=STATE_DONE_FLAG;
		
		setDisable('btnTraceroute',0);
		setDisable('btnStopTraceroute',1);
		
		var tmpResult = ChangeRetsult(newString[0]);
		getElement('traceRouteresult').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_result']+ '</FONT><B>';
		if(tmpResult == "" || tmpResult == "<br/>")
		{
			getElement('TraceRouteText').innerHTML = diagnose_language['bbsp_pingfail1'];
		}
		else
		{
			getElement('TraceRouteText').innerHTML = tmpResult;
		}
		tmpResult=null;
	 }
     else 
	 {
		TraceRouteState=STATE_DONE_FLAG;
		if(('TELECOM' == CfgModeWord.toUpperCase()) &&(curUserType != sysUserType))
		{
			setDisable('btnTraceroute',1);
		}
		else
		{
			setDisable('btnTraceroute',0);
		}
		setDisable('btnStopTraceroute',1);
		getElement('traceRouteresult').innerHTML ='<B><FONT color=red>'+diagnose_language['bbsp_fail']+ '</FONT><B>';
		var tmpResult = ChangeRetsult(newString[0]);
		if(tmpResult == "" || tmpResult == "<br/>")
		{
			getElement('TraceRouteText').innerHTML = "";
		}
		else
		{
			getElement('TraceRouteText').innerHTML = tmpResult;
		}
		tmpResult=null;
	 }
	newString=null;
	result=null;
	return ;
}

function SetFlag(flag,value)
{    
    $.ajax({
     type : "POST",
     async : false,
     cache : false,
     data : "RUNSTATE_FLAG.value="+value +"&x.X_HW_Token="+getValue('onttoken'),
     url : "complex.cgi?RUNSTATE_FLAG="+flag,
     success : function(data) {
     },
     complete: function (XHR, TS) {
        XHR=null;
     }
    });
}

function GetRouteResult()
{
	var traceRouteTxt="";
    $.ajax({
     type : "POST",
     async : true,
     cache : false,
     url : "./GetRouteResult.asp",
     success : function(data) {
        traceRouteTxt = eval(data);
        FindResultEnd(traceRouteTxt);
     },
     complete: function (XHR, TS) {
        if (CLICK_START_FLAG  ==  TracerouteClickFlag && TraceRouteState == STATE_DOING_FLAG)
        {
            if(TimerHandle == undefined)
            {
                TimerHandle=setInterval("GetRouteResult()", 10000);
            }
        }
        
        if( CLICK_START_FLAG  ==  TracerouteClickFlag && TraceRouteState == STATE_DONE_FLAG )
        {
            if(TimerHandle != undefined)
            {
	            clearInterval(TimerHandle);
	        }else
	        {
	        }
        }      
        

        traceRouteTxt=null;

     	XHR = null;
     }
    });
}


var EquipTestResultInfo = new EquipTestResultClass("0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0");
var PhyResult = new Array();
function GetEquipInfo()
{
	PhyResult[0] = EquipTestResultInfo.Port1Result;
	PhyResult[1] = EquipTestResultInfo.Port2Result;
	PhyResult[2] = EquipTestResultInfo.Port3Result;
	PhyResult[3] = EquipTestResultInfo.Port4Result;
	PhyResult[4] = EquipTestResultInfo.Port5Result;
	PhyResult[5] = EquipTestResultInfo.Port6Result;
}


function GetEquipTestResult()
{
	if (CLICK_START_FLAG  ==  EquipTestClickFlag)
	{
		$.ajax({
			type : "POST",
			async : true,
			cache : false,
			url : "./getEquipTestResult.asp",
			success : function(data) {
			EquipTestResultInfo = eval(data);
			GetEquipInfo();
			EquipTestResult();
			},
            complete: function (XHR, TS) { 

                traceRouteTxt=null;

             	XHR = null;
          }			
		});		
	}
	else
	{
	    if(TimerHandleEquip != undefined)
	    {
	        clearInterval(TimerHandleEquip);
	    }		
	}
}

function ParseSelfTestResult(SelfTestResult, PhyResult)
{
	var result = "";
	var resulttemp = "";
	if (SelfTestResult.SD5113Result.indexOf("Failed") >= 0)
	{
		result += diagnose_language['bbsp_sd5113fail'];
	}

	if (SelfTestResult.WifiResult.indexOf("Failed") >= 0)
	{
		result += diagnose_language['bbsp_wififail'];
	}

	if (SelfTestResult.LswResult.indexOf("Failed") >= 0)
	{
		result += diagnose_language['bbsp_lswfailk'];
	}

	if (SelfTestResult.CodecResult.indexOf("Failed") >= 0)
	{
		result += diagnose_language['bbsp_codecfail'];
	}

	if (SelfTestResult.OpticResult.indexOf("Failed") >= 0)
	{
		result += diagnose_language['bbsp_lightfail'];
	}

	for (i = 0; i < 6; i++)
	{
		if (PhyResult[i].indexOf("Failed") >= 0)
		{
			resulttemp = "ETH" + (i+1) + diagnose_language['bbsp_phyfail'] ;
			result += resulttemp;
		}
	}
	
	if (SelfTestResult.ExtRfResult.indexOf("Failed") >= 0)
	{
		result += diagnose_language['bbsp_rffail'];
	}
	
	return result;
}

function ParseLinkTestResult(rawresult)
{
	var result = "";
	var resulttemp = "";
	var nochecknum = 0;
	portres = rawresult.split(";");

	for (i =0; i < 12; i++)
	{
		innerres = portres[i].split(":");
		finalres = innerres[1];

		if (finalres.indexOf("NoCheck") >= 0)
		{
			nochecknum++;
			continue;
		}

		if (!(i % 2))
		{
			if (finalres.indexOf("Failed") >= 0)
			{
				resulttemp = "511X ETH" + (i + 2)/2 + diagnose_language['bbsp_machwabnormal'];
				result += resulttemp;
			}			
		}
		else
		{
			if (finalres.indexOf("Failed") >= 0)
			{
				resulttemp = "ETH" + (i + 1)/2 + diagnose_language['bbsp_phyhwabnmormal'];
				result += resulttemp;
			}
		}
	}

	if (nochecknum == 12)
	{
		result = "NoCheck";
	}	
	return result;
}

function EquipTestResult()
{
	var ShowStr = "";
	var PrifixStr = diagnose_language['bbsp_test'];
	LinkResult = ParseLinkTestResult(EquipTestResultInfo.LinkTestResult);
	EquipFinalStr = ParseSelfTestResult(EquipTestResultInfo, PhyResult) + LinkResult;

	if (EquipFinalStr == "")
	{
		ShowStr = PrifixStr + diagnose_language['bbsp_ok'];
	}
	else
	{
		ShowStr = PrifixStr + EquipFinalStr + "!";
		ShowStr = ShowStr.replace("；!", "");
	}

	if (LinkResult.indexOf("NoCheck") >= 0)
	{
		ShowStr = "";
	}
	
	getElement('equipTestResult').innerHTML ='<B><FONT color=red>'+diagnose_language['bbsp_result']+ '</FONT><B>';
	getElement('EquipTestText').innerHTML = ShowStr;
	EquipTestClickFlag = CLICK_TERMINAL_FLAG;
	SetFlag(EQUIPTEST_FLAG,CLICK_TERMINAL_FLAG);
	setDisable('EquipCheck',0);
	return ShowStr;
}

function OnEquipCheck()
{
	var lanid = "";
    setDisable('EquipCheck', 1);
	getElement('EquipTestText').innerHTML ="";
	getElement('equipTestResult').innerHTML = '<B><FONT color=red>'+diagnose_language['selftestwait']+ '</FONT><B>';	
	EquipTestClickFlag = CLICK_START_FLAG;		
	EquipTestResultInfo = GetCommonEquipTestResultInfo();
	GetEquipInfo();

    var Form = new webSubmitForm();

	if (EquipTestResultInfo.SD5113Result.indexOf("OK") >= 0)
	{
		for (i = 0; i < 6; i++)
		{
			if (PhyResult[i].indexOf("OK") >= 0)
			{
				lanid += "" + (i +1);
			}
		}
	}

	Form.addParameter('x.portid', lanid);
	Form.addParameter('RUNSTATE_FLAG.value',CLICK_START_FLAG);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
	Form.setAction('complex.cgi?x=InternetGatewayDevice.X_HW_DEBUG.BBSP.ExtendPortTransCheck&RUNSTATE_FLAG='+EQUIPTEST_FLAG+'&RequestFile=html/bbsp/maintenance/diagnosetool.asp');	
	Form.submit();
	
}

</script>
<title>Diagnose Ping Configuration</title>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<form> 
<form> </form> 
<div id="ThirdPlayerPanel">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("DCpingtitle", GetDescFormArrayById(diagnose_language, "bbsp_maint"), GetDescFormArrayById(diagnose_language, ""), false);
	if (IsAdminUser() == true)
	{
		document.getElementById("DCpingtitle_content").innerHTML = diagnose_language["bbsp_diagnose_titleadmin"] + '<br>' + diagnose_language["bbsp_diagnose_title8"] + diagnose_language["bbsp_diagnose_title6"] + diagnose_language["bbsp_diagnose_title7"];
	}
	else
	{
		document.getElementById("DCpingtitle_content").innerHTML = diagnose_language["bbsp_diagnose_titleuser"];
	}
</script>
<div class="title_spread"></div>

<div id="divEthInfo" style="overflow:auto;overflow-y:hidden"> 

<div class="func_title"><SCRIPT>document.write(status_ethinfo_language["amp_ethinfo_title"]);</SCRIPT></div>

<table id="eth_status_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style='text-align:center;'>
	<tr class="head_title">
    <td><SCRIPT>document.write(status_ethinfo_language["amp_ethinfo_portnum"]);</SCRIPT></td>
    <td><SCRIPT>document.write(status_ethinfo_language["amp_ethinfo_link"]);</SCRIPT></td>
    <td><SCRIPT>document.write(status_ethinfo_language["amp_ethinfo_duplex"]);</SCRIPT></td>
    <td><SCRIPT>document.write(status_ethinfo_language["amp_ethinfo_speed"]);</SCRIPT></td>
    
    <script>
	var lanid;
	for(i=0; i<geInfos.length - 1; i++)
	{
	    lanid = i+1;
		if (('1' == P2pFlag) && (lanid > 4))
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
		document.write('<td>'+geInfos[i].Status	+'</td>');
		document.write('<td>'+geInfos[i].Mode	+'</td>');
		document.write('<td>'+geInfos[i].Speed	+'</td>');
		document.write("</tr>");
	}

	if ('1' == P2pFlag)
	{
		if (6 == geInfos.length)
		{
			var uiExtEthId = 4;
 		
			document.write("<tr class=\"tabal_01\">");
			document.write('<td id="ExtId">' + status_ethinfo_language['amp_port_ext1'] +'</td>');
			document.write('<td id="StatusId">'+ geInfos[uiExtEthId].Status	+'</td>');
			document.write('<td id="ModeId">'+ geInfos[uiExtEthId].Mode	+'</td>');
			document.write('<td id="SpeedId">'+ geInfos[uiExtEthId].Speed	+'</td>');
			document.write("</tr>");

			document.write("<tr class=\"tabal_02\">");
			document.write('<td>' + status_ethinfo_language['amp_port_wan'] + '</td>');
			document.write('<td>'+ WanEthInfos[0].Mode	+'</td>');
			document.write('<td>'+ WanEthInfos[0].Speed	+'</td>');
			document.write('<td>'+ WanEthInfos[0].Status	+'</td>');
			document.write("</tr>");
		}
	}
	</script>
</table>

<div class="func_spread"></div>

</div>

<div id="divWlanInfo" style="display:none;">

<div class="func_title"><SCRIPT>document.write(status_wlaninfo_language["amp_wlaninfo_title"]);</SCRIPT></div>

<table id="wlanInfo_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
    <tr class='head_title'  style='text-align:left;color: #000000;'>
    	<td class="table_title width_per30"></td>
        		
        <td class="table_title width_per35">
        	<SCRIPT>
        		var s1 = status_wlaninfo_language["amp_wlanlink_status"];
        		document.write(s1.substring(0, s1.length-1));</SCRIPT></td>
        		
        <td class="table_title width_per35">
        	<SCRIPT>
        		var s2 = status_wlaninfo_language["amp_wlaninfo_channel"];
        		document.write(s2.substring(0, s2.length-1));</SCRIPT></td>
    </tr>

    <script language="JavaScript" type="text/javascript">
		WlanInfoRefresh();
		$.each(WlanInfos, function(idx, value){
				document.write('<tr>');
				document.write('<td class="table_title width_per30" style="color: #000000;">' + value[0] + '</td>');
				document.write('<td class="table_right width_per35" style="color: #000000;">' + value[1] + '</td>');
				document.write('<td class="table_right width_per35" style="color: #000000;">' + value[2] + '</td>');
				document.write('</tr>');
			});
	</script>
</table>

<div class="func_spread"></div>

</div>

<div id="divPonInfo">

<div class="func_title">Pon Link Status</div>

<table id="link_status_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
    <tr>
    	<td class="table_title width_per35"><SCRIPT>document.write(telmex_language["Telmex_ponLinkStatus_title"]);</SCRIPT></td>
    	<td class="table_right"><script>setOpticLinkStatus();</script></td>
    </tr>
    <tr>
    	<td class="table_title width_per35"><SCRIPT>document.write(cfg_ontauth_language["amp_registration_status"]);</SCRIPT></td>
    	<td class="table_right"><script>setRegistrationStatus()</script></td>
    </tr>
</table>

<div class="func_spread"></div>

</div>

<table width="100%" border="0" cellpadding="0" id="table_ping_title" cellspacing="0" class="func_title"> 
  <tr> 
    <td  class="width_per100 align_left" BindText='bbsp_pingtest'>
	</td> 
	<td>
		<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	</td>
  </tr> 
</table> 

<form id="table_ping" style="display:block;"> 
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg"> 
		<li id="WanNameList" RealType="DropDownList" DescRef="bbsp_wannamemh" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Interface" Elementclass="width_260px restrict_dir_ltr" ClickFuncApp="onchange=OnChangeList"/>
		<li id="IPAddress" RealType="TextOtherBox" DescRef="Empty" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE" BindField="x.Host"  Elementclass="width_254px restrict_dir_ltr" 
			InitValue="[{Type:'select',Item:[{AttrName:'id',AttrValue:'PingTarget'},{AttrName:'class', AttrValue:'width_230px'},{AttrName:'onChange',AttrValue:'PingTargetChange()'}]}]"/>    
		<li id="DataBlockSize" RealType="TextBox" DescRef="bbsp_datablocksize" RemarkRef="bbsp_pingdatablocksizerange" ErrorMsgRef="Empty" Require="FALSE" BindField="x.DataBlockSize" Elementclass="width_254px" InitValue="56"/>
		<li id="NumOfRepetitions" RealType="TextBox" DescRef="bbsp_numofrepetitions" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.NumberOfRepetitions" Elementclass="width_254px" InitValue="4"/>
		<li id="MaxTimeout" RealType="TextBox" DescRef="bbsp_maxtimeout" RemarkRef="bbsp_pingmaxtimeoutrange" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Timeout" Elementclass="width_254px" InitValue="10"/>
		<li id="DscpValue" RealType="TextBox" DescRef="bbsp_dscpvalue" RemarkRef="bbsp_dscpPrompt" ErrorMsgRef="Empty" Require="FALSE" BindField="x.DSCP" Elementclass="width_254px" InitValue="0"/>
	</table>
	<script>
		var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
		var PingConfigFormList = new Array();
		PingConfigFormList = HWGetLiIdListByForm("table_ping", null);
		var formid_hide_id = null;
		HWParsePageControlByID("table_ping", TableClass, diagnose_language, formid_hide_id);
		
		document.getElementById("IPAddressColleft").innerHTML = diagnose_language['bbsp_targetmh'];

		setText('DataBlockSize', '56');

		document.getElementById("NumOfRepetitionsRemark").innerHTML = diagnose_language['bbsp_repetitionsPromptTelmex'];

		setText('NumOfRepetitions', '4');
		setText('MaxTimeout', '10');
		setText('DscpValue', '0');
		
		function GetIPv6WanDnsList(selWanObj)
		{
			var ipv6WanForDns = GetIPv6WanInfo(selWanObj.MacId);
			var DnsListTmp = new Array();
			
			if(null != ipv6WanForDns)
			{
				var IPv6DNS = ipv6WanForDns.DNSServers;
				if(null != IPv6DNS && "" != IPv6DNS)
				{
					var DnsList = IPv6DNS.split(",");
					DnsListTmp.push(DnsList[0]);

					if(DnsList[1] != null)
					{
						DnsListTmp.push(DnsList[1]);
					}
				}
			}
			
			return DnsListTmp;	
		}
		
		function GetWanInstByDomain(wandomain)
		{
			var WanInstList = GetWanList();
			for(var i = 0; i < WanInstList.length; i++)
			{
				if(wandomain == WanInstList[i].domain)
				{
					return WanInstList[i];
				}
			}
			
			return null;
		}
		
		function InitPingTargetList()
		{
			var initlist = '<option value="0">' + diagnose_language['bbsp_spceficip'] + '</option>';
			var TargetIpList = getElementById("PingTarget");
			TargetIpList.options.length = 0;

			if('' != getValue("WanNameList") && 'InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.1' != getValue("WanNameList"))
			{
				var selWanObj = GetWanInstByDomain(getValue("WanNameList"));
				if(null != selWanObj)
				{
					var dnsTmpList = new Array();
					var IPv6WanDnsTmp = new Array();
					var protocoltype = GetProtocolType(selWanObj.IPv4Enable, selWanObj.IPv6Enable);
					if("IPv4/IPv6" == protocoltype)
					{
						if(("Connected" == selWanObj.Status ) && ('' != selWanObj.IPv4IPAddress))
						{
							if("" != selWanObj.IPv4PrimaryDNS)
							{
								dnsTmpList.push(selWanObj.IPv4PrimaryDNS);
							}
							if("" != selWanObj.IPv4SecondaryDNS)
							{
								dnsTmpList.push(selWanObj.IPv4SecondaryDNS);
							}
						}
						
						IPv6WanDnsTmp = GetIPv6WanDnsList(selWanObj);
						for(var i = 0; i < IPv6WanDnsTmp.length; i++)
						{
							dnsTmpList.push(IPv6WanDnsTmp[i]);
						}
					}
					else if("IPv4" == protocoltype)
					{
						if(("Connected" == selWanObj.Status ) && ('' != selWanObj.IPv4IPAddress))
						{
							if("" != selWanObj.IPv4PrimaryDNS)
							{
								dnsTmpList.push(selWanObj.IPv4PrimaryDNS);
							}
							if("" != selWanObj.IPv4SecondaryDNS)
							{
								dnsTmpList.push(selWanObj.IPv4SecondaryDNS);
							}
						}
					}
					else
					{
						IPv6WanDnsTmp = GetIPv6WanDnsList(selWanObj);
						for(var i = 0; i < IPv6WanDnsTmp.length; i++)
						{
							dnsTmpList.push(IPv6WanDnsTmp[i]);
						}
					}

					for(var j = 0; j < dnsTmpList.length; j++)
					{
						initlist += '<option value=' + dnsTmpList[j] + '>' + diagnose_language['bbsp_wanpridns'] + dnsTmpList[j] +'</option>';
					}
				}			
			}

			$("#PingTarget").append(initlist);		
		}
		
		
		function PingTargetChange()
		{
			if('0' == getValue("PingTarget"))
			{
				setText("IPAddress", "");
			}
			else
			{
				var dnsIp = "";
				dnsIp = getValue("PingTarget");
				setText("IPAddress", dnsIp);
			}
		}
		
		function OnChangeList()
		{
			InitPingTargetList();
			ControlPingDropWanList();
		}
		
		function ControlPingDropWanList()
		{
			setSelect("PingTarget", '0');
			if('' == getValue("WanNameList") || 'InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.1' == getValue("WanNameList"))
			{
				setSelect("PingTarget", '0');
			}
			else
			{
				var curIp = getValue("IPAddress");
				setSelect("PingTarget", curIp);
			}

		}
		
	</script>
	<table id="OperatorPanel" class="table_button" style="width: 100%;"> 
	  <tr> 
		<td class="table_submit width_per25" ></td> 
		<td class="table_submit width_per75">
		<button id="ButtonApply"  type="button" onclick="javascript: OnApply();" class="ApplyButtoncss buttonwidth_100px" ><script>document.write(diagnose_language['bbsp_start']);</script></button>
		<button id="ButtonStopPing"  type="button" onclick="javascript: OnStopPing();" class="CancleButtonCss buttonwidth_100px" ><script>document.write(diagnose_language['bbsp_stop']);</script></button>
		</td> 
	  </tr> 
	</table> 
	<div name="PingTestTitle" id="PingTestTitle" style="display:none;"></div> 
	<div name="DnsTitle" id="DnsTitle" style="display:none;"></div> 
	<div name="DnsTextDiv" id="DnsTextDiv" style="display:none;word-break:break-all"><table><tr><td id="DnsText" class="restrict_dir_ltr"></td></tr></table></div> 
	 <div name="PingTitle" id="PingTitle" style="display:none;"></div> 
	 <div name="PingTextDiv" id="PingTextDiv" style="display:none;"><table><tr><td id="PingText" class="restrict_dir_ltr"></td></tr></table></div>
	 <div id="PingResultDiv" style="display:none;"> 
	  <textarea name="PingResultArea" id="PingResultArea"  wrap="off" readonly="readonly" style="width: 100%;height: 150px;margin-top: 10px;">
	  </textarea> 
     </div> 	 
<div class="func_spread"></div>	
</form> 

<div id="TraceRouteForm"> 
  <div id ="TraceRoute"> 
    <table width="100%" border="0" id="TraceRoute_title" cellpadding="0" cellspacing="0" class="func_title"> 
      <tr> 
        <td  class="width_per100 align_left" BindText='bbsp_tracertest'> </td> 
      </tr> 
    </table> 
	
	<form id="table_trace" style="display:block;"> 
		<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg"> 
			<li id="urladdress" RealType="TextBox" DescRef="Empty" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE" BindField="y.Host" Elementclass="width_254px restrict_dir_ltr"/>
			<li id="wanname" RealType="DropDownList" DescRef="bbsp_wannamemh" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="y.Interface" Elementclass="width_260px restrict_dir_ltr"/>
			<li id="TraceRouteDataBlockSize" RealType="TextBox" DescRef="bbsp_datablocksize" RemarkRef="bbsp_tracertdatablocksizerange" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Timeout" Elementclass="width_254px" InitValue="38"/>
		</table>
		<script>
			var TraceRouteConfigFormList = new Array();
			TraceRouteConfigFormList = HWGetLiIdListByForm("table_trace", null);
			HWParsePageControlByID("table_trace", TableClass, diagnose_language, null);

			document.getElementById("urladdressColleft").innerHTML = diagnose_language['bbsp_targetmh'];

			$("#wanname").append('<option value=""></option>');
			if(!((curUserType != sysUserType) && ((CfgModeWord.toUpperCase() == "RDSGATEWAY")||(CfgModeWord.toUpperCase() == "DT_HUNGARY"))))
			{
				$("#wanname").append('<option value="br0">'
							+ "br0" + '</option>');
			}
			WriteOptionFortraceRoute();
			setText('TraceRouteDataBlockSize', '38');
		</script>
		<table width="100%" border="0" cellspacing="1" cellpadding="0" id="table_trace_button" class="table_button">  
			<td class="table_submit width_per25" ></td> 
        <td class="table_submit width_per75">
		<button  class="ApplyButtoncss buttonwidth_100px" name="btnTraceroute" id= "btnTraceroute" type="button" onClick="startTraceroute();"><script>document.write(diagnose_language['bbsp_start']);</script> </button>
        <button  class="CancleButtonCss buttonwidth_100px" name="btnStopTraceroute" id= "btnStopTraceroute" type="button" onClick="stopTraceroute();"><script>document.write(diagnose_language['bbsp_stop']);</script> </button>
		</td> 
	  </tr> </table> 
    <div name="traceRouteresult" id="traceRouteresult"></div> 
    <div name="TraceRouteTextDiv" id="TraceRouteTextDiv"><table><tr><td id="TraceRouteText" class="restrict_dir_ltr"></td></tr></table></div> 
    <div id="space"> 
    </div>
	<div class="func_spread"></div>
	</form> 
  </div> 
</div>

</div>

<form id="EquipForm"> 
<div id ="EquipDiv"> 
  <table id="EquipTitle" width="100%" border="0" cellpadding="0" cellspacing="0" class="func_title"> 
    <tr> 
      <td  class="align_left width_per100" BindText='bbsp_hwtest'></td> 
    </tr> 
  </table> 
  
  <table id= "EquipButton"  width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button"> 
    <tr > 
      <td class="table_submit width_per1" > </td> 
	  <td class="table_submit width_per99"> <button id="EquipCheck" name="EquipCheck" type="button" class="ApplyButtoncss buttonwidth_150px_300px"  onclick="OnEquipCheck();"><script>document.write(diagnose_language['bbsp_starthwtest']);</script> </button></td> 
		 </tr> 
	   </table> 
		<div name="equipTestResult" id="equipTestResult"></div> 
			<div name="EquipTestText" id="EquipTestText"></div> 
			<div id="equipTestSpace"> 
			  <div class="func_spread"></div>
			</div>
</div>
</form> 
  
  <script>
    function IsValidWan(Wan)
    {
		if ((curUserType != sysUserType) 
			&& ((CfgModeWord.toUpperCase() == "RDSGATEWAY") || (CfgModeWord.toUpperCase() == "DT_HUNGARY")))
		{
			if ((Wan.ServiceList.toString().toUpperCase().indexOf("INTERNET") >=0) && (Wan.Enable == 1) && (Wan.Mode == "IP_Routed")){
				return true;
			}
		}
		else
		{
			if(IsRadioWanSupported(Wan))
			{
				if ((Wan.Mode == "IP_Routed") && (Wan.RadioWanPSEnable == 1)){
					return true;
				}
			}
			else
			{
				if ((Wan.Mode == "IP_Routed") && (Wan.Enable == 1)){
					return true;
				}
			}
		}
		return false;
    }
    function InitWanList()
    {
        var Option = document.createElement("Option");
        Option.value = "";
        Option.innerText = "";
        Option.text = "";
        getElById("WanNameList").appendChild(Option);
		if(!((curUserType != sysUserType) && ((CfgModeWord.toUpperCase() == "DT_HUNGARY") || (CfgModeWord.toUpperCase() == "RDSGATEWAY"))))
		{
			if (LanHostInfo != null)
			{
				var OptionBr0 = document.createElement("Option");
				OptionBr0.value = LanHostInfo.domain;
				OptionBr0.innerText = "br0";
				OptionBr0.text = "br0";
				getElById("WanNameList").appendChild(OptionBr0);            
			}
		}
        
        InitWanNameListControl2("WanNameList", IsValidWan);
    }
	
    function ControlPage()
    {
        if (("1" == GetCfgMode().TELMEX)||(IsAdminUser() == false))
        {
			setDisplay("EquipForm", "0");
        }
    }
    InitWanList();
    ControlPage();
	
	setText("TraceRouteDataBlockSize",TracerResult.DataBlockSize);
	setText("urladdress",TracerResult.Host);
	setSelect("wanname",TracerResult.Interface);
	
	for (var i=0; i < document.getElementById("wanname").length; i++)
	{
		if (document.getElementById("wanname")[i].value == TracerResult.Interface)
		{
			try
			{
				document.getElementById("wanname")[i].selected = true;
			}
			catch(Exception)
			{
			}
		}
	}

  if(PingResult.Host!="")
  {	
      setText("IPAddress",PingResult.Host);
      setText("DataBlockSize", PingResult.DataBlockSize);
      setText("NumOfRepetitions",PingResult.NumberOfRepetitions);
      setText("DscpValue",PingResult.DSCP); 
	  setText("MaxTimeout",parseInt(PingResult.Timeout/1000,10)); 	
	  setSelect("WanNameList",PingResult.Interface);
  }

	
	for (var i=0; i < document.getElementById("WanNameList").length; i++)
	{
		if (document.getElementById("WanNameList")[i].value == PingResult.Interface)
		{
			try
			{
				document.getElementById("WanNameList")[i].selected = true;
			}
			catch(Exception)
			{
			}
		}
	}
    
  </script> 
</form> 

<table width="100%" height="20" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
  </table> 
<script language="JavaScript" type="text/javascript">
if ("1" != GetCfgMode().TELMEX)
{
	TimerHandleEquip = setInterval("GetEquipTestResult()", 30000);
}
</script> 
</body>
</html>

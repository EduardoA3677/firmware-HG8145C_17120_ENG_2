
function PolicyRouteItem(_Domain, _Type, _VenderClassId, _WanName, _EtherType,_PhyPortName)
{
    this.Domain = _Domain;
    this.Type = _Type;
    this.VenderClassId = _VenderClassId;
    this.WanName = _WanName;
    this.EtherType = _EtherType;
    this.PhyPortName = _PhyPortName;
}

var PolicyRouteList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterPolicyRoute, InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route.{i},PolicyRouteType|VenderClassId|WanName|EtherType|PhyPortName,PolicyRouteItem);%>;  

function GetPolicyRouteList()
{
    return PolicyRouteList;
} 

var IPProtVerMode = <%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_IPProtocolVersion.Mode);%>;
function GetIPProtVerMode()
{
    return IPProtVerMode;
}

var LanWanBindList = new Array();
var AnyPortAnyServiceList = new Array();
var EthRouteList = new Array();
var PortVlanBindList = new Array();
var i=0,j=0,k=0,m=0,n=0;
for (; i < PolicyRouteList.length-1; i++)
{
    if ( ((PolicyRouteList[i].Type == "SourcePhyPort") || (PolicyRouteList[i].Type == "SourcePhyPortV6") ))
    {
        LanWanBindList[j++] = PolicyRouteList[i];
    }
    
    if (PolicyRouteList[i].Type == "SoureIP")
    {
        AnyPortAnyServiceList[k++] = PolicyRouteList[i];
    }
    
    if (PolicyRouteList[i].Type == "EtherType")
    {
        EthRouteList[m++] = PolicyRouteList[i];
    }

    if (PolicyRouteList[i].Type == "PortVlan")
    {
        PortVlanBindList[n++] = PolicyRouteList[i];
    }
    
}

function GetLanWanBindList()
{
    return LanWanBindList;
}
function GetLanWanBindInfo(WanName)
{
    var BindList = GetLanWanBindList();
    for (var i = 0; i < BindList.length; i++)
    {
        if (WanName == BindList[i].WanName)
        {
            return BindList[i];
        }
    }
}


function GetAnyPortAnyServiceList()
{
    return AnyPortAnyServiceList;
}
function GetEthRouteList()
{
    return EthRouteList;
}
function GetPortVlanRouteList()
{
    return PortVlanBindList;
}


function domainTowanname(domain)
{
	if((null != domain) && (undefined != domain))
	{
		var domaina = domain.split('.');
		var type = (-1 == domain.indexOf("WANIPConnection")) ? '.ppp' : '.ip' ;
		return 'wan' + domaina[2]  + '.' + domaina[4] + type + domaina[6] ;
	}
}

function GetWanConnectioDevicePath(WanFullPath)
{
    var IndexOfConnction = WanFullPath.indexOf("WANIPConnection");
    if (-1 == IndexOfConnction)
    {
        IndexOfConnction = WanFullPath.indexOf("WANPPPConnection");
    }
    return WanFullPath.substr(0, IndexOfConnction-1);
}

function MakeWanNameForPTVDF(wan)
{
	var currentWanName = '';
	
	if (true == IsRadioWanSupported(wan))
	{
		return "Mobile";
	}
	
	switch (wan.ServiceList.toUpperCase())
    {
		case "INTERNET":
		case "TR069_INTERNET":
    		currentWanName = "Internet";
    		break;
    	case "VOIP":
		case "TR069_VOIP":
    		currentWanName = "VoIP";
    		break;
		case "IPTV":
		case "TR069_IPTV":
    		currentWanName = "IPTV";
    		break;
		case "TR069":
    		currentWanName = "TR069";
    		break;
		case "OTHER":
    		currentWanName = "OTHER";
    		break;
    	case "VOIP_INTERNET":
		case "TR069_VOIP_INTERNET":
    		currentWanName = "VoIP_Internet";
    		break;
		case "VOIP_IPTV":
		case "TR069_VOIP_IPTV":
			currentWanName = "VoIP_IPTV";
			break;
		case "IPTV_INTERNET":
		case "TR069_IPTV_INTERNET":
    		currentWanName = "IPTV_Internet";
    		break;
		case "VOIP_IPTV_INTERNET":
		case "TR069_VOIP_IPTV_INTERNET":
			currentWanName = "VoIP_IPTV_Internet";
			break;
    	default:
    		break;
    }
	
	return currentWanName;
}

var IsPTVDFMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDF);%>';
var IsTDE2Mode   = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_TDE);%>';



function MakeDefaultWanName(wan)
{
	var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var currentWanName = '';
	
    wanInst = wan.MacId;
    wanServiceList  = wan.ServiceList.toUpperCase();
    wanMode         = (wan.Mode == 'IP_Routed' ) ? "R" : "B";
    vlanId          = wan.VlanId;
  
	if (true == IsRadioWanSupported(wan))
	{
		currentWanName = wanInst + "_" + RADIOWAN_NAMEPREFIX + "_" + wanServiceList + "_" + wanMode + "_VID_";
	}
    else
    {
	    if (0 != parseInt(vlanId))
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_" + vlanId;
	    }
	    else
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_";
	    }   
    }

    return currentWanName;
}

function MakeWanNameForQtelMTN(wan)
{
	var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var currentWanName = '';
	
    wanInst = wan.MacId;
    wanServiceList  = wan.ServiceList.toUpperCase();
    wanMode         = (wan.Mode == 'IP_Routed' ) ? "R" : "B";
    vlanId          = wan.VlanId;
  
	if (true == IsRadioWanSupported(wan))
	{
		currentWanName = "Mobile";
	}
    else
    {
	    if (0 != parseInt(vlanId))
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_" + vlanId;
	    }
	    else
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_";
	    }   
    }

    return currentWanName;
}

function MakeWanNameForPCCW(wan)
{
	var currentWanName = '';
	var wanInst = 0;
	var wanMode = '';
	
	wanInst = wan.MacId;
	wanMode = (wan.Mode == 'IP_Routed' ) ? "R" : "B";
	if(true == IsRadioWanSupported(wan))
	{
		currentWanName = wanInst + "_" + RADIOWAN_NAMEPREFIX + "_" + wanServiceList + "_" + wanMode + "_VID_";
	}
	else
	{
		wanMode = (wan.Mode == 'IP_Routed' ) ? "Route" : "Bridge"
		currentWanName = wanInst + "_" + wanMode + "_" + "WAN";
	}
	
	return currentWanName;
}

function MakeWanNameForVoice(wan)
{
    var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var currentWanName = '';
	
    wanInst = wan.MacId;
    wanServiceList  = wan.ServiceList.toUpperCase().replace(new RegExp(/(VOIP)/g),"VOICE");
    wanMode         = (wan.Mode == 'IP_Routed' ) ? "R" : "B";
    vlanId          = wan.VlanId;
  
	if (true == IsRadioWanSupported(wan))
	{
		currentWanName = wanInst + "_" + RADIOWAN_NAMEPREFIX + "_" + wanServiceList + "_" + wanMode + "_VID_";
	}
    else
    {
	    if (0 != parseInt(vlanId))
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_" + vlanId;
	    }
	    else
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_";
	    }
    }

    return currentWanName;
}


function MakeWanName_New(wan)
{
	var currentWanName = '';
	var Layer2Feature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_SERVICELIST_BY_LAYER2);%>";
	var IsPTVDFMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDF);%>';
	var CfgModePCCWHK = "<%HW_WEB_GetFeatureSupport(BBSP_FT_PCCW);%>";
	var MngtShct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SHCT);%>';
	var CUVoiceFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_UNICOM_DIS_VOICE);%>";
	var CurCfgModeWord ='<%HW_WEB_GetCfgMode();%>';
	var CurrentBin = '<%HW_WEB_GetBinMode();%>'; 
	var IsCUMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_CU);%>';

    if ("AIS" == CfgModeWord.toUpperCase() && wan.Name != '')
    {
        return wan.Name;       
    }
	
	currentWanName = wan.Name;
	if(wan.Name.indexOf("OLT") >= 0)
	{
		return MakeDefaultWanName(wan);
	}
	
	if("1" == Layer2Feature)
	{
		return ("" != currentWanName) ? currentWanName : MakeDefaultWanName(wan);
	}
	
	if ('1' == IsPTVDFMode)
	{
		currentWanName = MakeWanNameForPTVDF(wan);
	}
	else if("1" == CfgModePCCWHK)
	{
		currentWanName = MakeWanNameForPCCW(wan);
	}
	else if('QTEL' == CurCfgModeWord.toUpperCase() || 'MTN2' == CurCfgModeWord.toUpperCase())
	{
		currentWanName = MakeWanNameForQtelMTN(wan);
	}
	else if(("0" == CUVoiceFeature) && ('1' == IsCUMode))
	{
	    currentWanName = MakeDefaultWanName(wan);
	}
	else if('E8C' == CurrentBin.toUpperCase() || "1" == CUVoiceFeature)
	{
		currentWanName = MakeWanNameForVoice(wan);
	}
	else if('RDS' == CurCfgModeWord.toUpperCase())
	{
		currentWanName = MakeDefaultWanName(wan);
	}
	else
	{
		if ((IsTDE2Mode == "1") && ("" == currentWanName))
		{
		    currentWanName = "untag";
		}
		else
		{
		    currentWanName = ("" != currentWanName) ? currentWanName : MakeDefaultWanName(wan);
		}
	}
	
	return currentWanName;
}

function MakeWanName(wan)
{
    return MakeWanName_New(wan);
}
    
function MakeWanName1(wan)
{
    return MakeWanName_New(wan);
}    


function WlanISPSSID(domain, SSID, EnableUserId, UserId)
{
    this.domain = domain;
    this.SSID = SSID;
    this.EnableUserId = EnableUserId;
    this.UserId = UserId;
}

try
{
var ISPSSIDList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_WLANForISP.{i},SSID_IDX|EnableUserId|UserId,WlanISPSSID);%>;
}
catch(e)
{
var ISPSSIDList = new Array(null);
}
function stWlanInfo(domain,name,X_HW_ServiceEnable,enable,bindenable)
{
    this.domain = domain;
    this.name = name;
    this.X_HW_ServiceEnable = X_HW_ServiceEnable;
    this.enable = enable;
    this.bindenable = bindenable;
}
var WlanInfo = '<%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|X_HW_ServiceEnable|Enable,stWlanInfo);%>'
if (WlanInfo.length > 0) 
{
	WlanInfo = eval(WlanInfo);
}
else
{
	WlanInfo = new Array(null);
}

function GetSSIDNameIndex(index)
{
	for ( i = 0 ; i < WlanInfo.length - 1 ; i++ )
	{
	var domain = WlanInfo[i].domain.split('.');
		if(domain[domain.length-1] == index)
		{
			  return parseInt(WlanInfo[i].name.charAt(WlanInfo[i].name.length-1));
		}
	}
}
function GetISPSSIDList()
{
    var ISPPortList = new Array();
    var ssid_i = new Array();

    for(var j = 0; j < ISPSSIDList.length - 1; j++)
    {
        ssid_i = ISPSSIDList[j].SSID;
        ISPPortList.push('SSID' + ssid_i);

    }   
    return ISPPortList;
}

function BindWhichWan(BindList, Port)
{
    for (var i in BindList)
    {
        if(BindList[i].PhyPortName.toUpperCase().indexOf(Port.toUpperCase()) >= 0)
            return BindList[i].WanName;
    }
    
    return '';
}

function GetISPWanList(BindList, PortList)
{
    var WanList = new Array();
    
    for(var port in PortList)
    {
        var Wan = BindWhichWan(BindList, PortList[port]);
        if(Wan.length != 0)
        {
            if(ArrayIndexOf(WanList, Wan) < 0)
                WanList.push(Wan);
        }
    }

    if(IsVnpt())
	{
		if(ArrayIndexOf(WanList, "wan1.7.ip1") < 0)
			WanList.push("wan1.7.ip1");

		if(ArrayIndexOf(WanList, "wan1.7.ppp1") < 0)
			WanList.push("wan1.7.ppp1");

		if(ArrayIndexOf(WanList, "wan1.8.ip1") < 0)
			WanList.push("wan1.8.ip1");

		if(ArrayIndexOf(WanList, "wan1.8.ppp1") < 0)
			WanList.push("wan1.8.ppp1");
	}
	
    
    return WanList;
}

function ArrayIndexOf(List, Value){
    for(var i in List)
    {       
        if(List[i] == Value)
            return i;
    }
    return -1;
}

try
{
    function GetISPWanOnlyRead()
	{
		if(typeof(__GetISPWanOnlyRead) == 'function'){

			return __GetISPWanOnlyRead();
		}
		else
		{
			return false;
		}
	}

	

	var ISPWanList =  new Array();
	if(typeof(GetLanWanBindList) == 'function'){

		ISPWanList = GetISPWanList(GetLanWanBindList(), GetISPSSIDList());
	}
	GetISPPortList = function(){return GetISPSSIDList();};
	IsWanHidden = function(interface){if(ArrayIndexOf(ISPWanList, interface) >= 0){return true;}else{return false;}}

	IsWanMustHidden = function(interface) { return (!GetISPWanOnlyRead()) && IsWanHidden(interface);}
}
catch(e)
{
	GetISPPortList = function(){return new Array();};
	IsWanHidden = function(interface){return false;};
}
    
var WanList = new Array();

var Tr069WanOnlyRead = <%HW_WEB_GetFeatureSupport("BBSP_FT_TR069_WAN_ONLY_READ");%>;

var IPWanList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayIPWAN, InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i},ConnectionTrigger|MACAddress|ConnectionStatus|LastConnectionError|X_HW_RemoteWanInfo|Name|Enable|X_HW_LanDhcpEnable|X_HW_IPForwardList|ConnectionStatus|ConnectionType|AddressingType|ExternalIPAddress|SubnetMask|DefaultGateway|NATEnabled|X_HW_NatType|DNSServers|X_HW_VLAN|X_HW_MultiCastVLAN|X_HW_PRI|X_HW_VenderClassID|X_HW_ClientID|X_HW_SERVICELIST|X_HW_ExServiceList|X_HW_TR069FLAG|X_HW_MacId|X_HW_IPv4Enable|X_HW_IPv6Enable|X_HW_IPv6MultiCastVLAN|X_HW_PriPolicy|X_HW_DefaultPri|MaxMTUSize|X_HW_DHCPLeaseTime|X_HW_NTPServer|X_HW_TimeZoneInfo|X_HW_SIPServer|X_HW_StaticRouteInfo|X_HW_VendorInfo|X_HW_DHCPLeaseTimeRemaining|Uptime|DNSOverrideAllowed|X_HW_LowerLayers,WanIP);%>;

var PPPWanList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayPPPWAN, InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},ConnectionTrigger|MACAddress|ConnectionStatus|LastConnectionError|X_HW_RemoteWanInfo|Name|Enable|X_HW_LanDhcpEnable|X_HW_IPForwardList|ConnectionStatus|ConnectionType|ExternalIPAddress|DefaultGateway|NATEnabled|X_HW_NatType|DNSServers|Username|Password|ConnectionTrigger|X_HW_ConnectionControl|X_HW_VLAN|X_HW_MultiCastVLAN|X_HW_PRI|X_HW_LcpEchoReqCheck|X_HW_SERVICELIST|X_HW_ExServiceList|X_HW_TR069FLAG|IdleDisconnectTime|X_HW_MacId|X_HW_IPv4Enable|X_HW_IPv6Enable|X_HW_IPv6MultiCastVLAN|X_HW_PriPolicy|X_HW_DefaultPri|MaxMRUSize|PPPoEACName|X_HW_IdleDetectMode|Uptime|DNSOverrideAllowed|X_HW_LowerLayers,WanPPP);%>;

var IPDSLiteList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayIPWAN, InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}.X_HW_IPv6.DSLite,WorkMode|AFTRName,DsLiteInfo);%>;
var PPPDSLiteList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayPPPWAN, InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}.X_HW_IPv6.DSLite,WorkMode|AFTRName,DsLiteInfo);%>;

var IP6RDTunnelList =  <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayIPWAN, InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}.X_HW_6RDTunnel,Enable|RdMode|RdPrefix|RdPrefixLen|RdBRIPv4Address|RdIPv4MaskLen,GetIpWan6RDTunnelInfo);%>;

var PPP6RDTunnelList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayPPPWAN, InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}.X_HW_6RDTunnel,Enable|RdPrefix|RdPrefixLen|RdBRIPv4Address|RdIPv4MaskLen,GetPppWan6RDTunnelInfo);%>;

var RadioWanParaList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaRadioWanPara, InternetGatewayDevice.X_HW_Radio_WAN.{i},Username|APN|DialNumber|TriggerMode,RadioWanClass);%>;

var RadioWanPSList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaRadioWanPs, InternetGatewayDevice.X_HW_RadioWanPS.{i}, Enable|SwitchMode|SwitchDelayTime|PingIP|Radio_WAN_Index ,RadioWanPSClass);%>;

var TDEIPWanIPv6AddressList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i},X_HW_UnnumberedModel|X_HW_TDE_IPv6AddressingType|X_HW_DHCPv6ForAddress,TDEIPWanIPv6AddressClass);%>;
var TDEPPPWanIPv6AddressList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}, X_HW_UnnumberedModel|X_HW_TDE_IPv6AddressingType|X_HW_DHCPv6ForAddress,TDEPPPWanIPv6AddressClass);%>;

var TDEIPDelegationEnabled = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}, X_HW_E8C_IPv6PrefixDelegationEnabled, TDE_IP_DelegationEnabledClass);%>;

var TDEPPPDelegationEnabled = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}, X_HW_E8C_IPv6PrefixDelegationEnabled, TDE_PPP_DelegationEnabledClass);%>;

function IsInvalidRadioWan()
{
	if (((1 == RadioWanParaList.length) && (RadioWanParaList.length < RadioWanPSList.length))
		|| ((1 == RadioWanPSList.length)&&(RadioWanParaList.length > RadioWanPSList.length)))
	{
	    return true;
	}
	return false;
}

function CompensateRadioWanCfg()
{
	var requestUrl = "";
	var Onttoken = "<%HW_WEB_GetToken();%>";

	if ((1 == RadioWanParaList.length)&&(RadioWanParaList.length < RadioWanPSList.length))
	{
		requestUrl = 'InternetGatewayDevice.X_HW_RadioWanPS.1' + '=';
	}
	else if ((1 == RadioWanPSList.length)&&(RadioWanParaList.length > RadioWanPSList.length))
	{
		requestUrl = 'InternetGatewayDevice.X_HW_Radio_WAN.1' + '=';
	}
	else
	{
		return;
	}	
	requestUrl += '&x.X_HW_Token=' + Onttoken;
	
	$.ajax({
	type : "POST",
	async : false,
	cache : false,
	data : requestUrl,
	url :  "del.cgi?" + "&RequestFile=html/ipv6/not_find_file.asp",
	error:function(XMLHttpRequest, textStatus, errorThrown) 
	{
		
	}
	});	
}


for(i=0, j=0;IPWanList.length > 0 && i < IPWanList.length -1;i++, j++)
{		
    if("1" == IPWanList[i].Tr069Flag || IsWanMustHidden(domainTowanname(IPWanList[i].domain)) == true)
    {
	    j--;
	    continue;
    }
	
    if(true == IsRDSGatewayUser() && -1 == IPWanList[i].ServiceList.toString().toUpperCase().indexOf("INTERNET"))
    {
	    j--;
	    continue;
    }
    if(filterWanOnlyTr069(IPWanList[i]) == false )
    {
	    j--;
	    continue;
    }
    
    if(filterWanByVlan(IPWanList[i]) == false )
    {
	    j--;
	    continue;
    }
	
    if ((true == IsRadioWanSupported(IPWanList[i])) && (true == IsInvalidRadioWan()))
	{
		j--;
		CompensateRadioWanCfg();
		continue;
	}
	
    WanList[j] = new WanInfoInst();
    ConvertIPWan(IPWanList[i], WanList[j]);
    WanList[j].Name = MakeWanName(IPWanList[i]);
	
	if((WanList[j].ProtocolType.toString() == "IPv6") && (WanList[j].Mode.toString().toUpperCase() == "IP_ROUTED"))
	{
		switch(IPDSLiteList[i].WorkMode.toUpperCase())
		{
			case "OFF":
			IPDSLiteList[i].WorkMode = "Off";
			break;
			case "STATIC":
			IPDSLiteList[i].WorkMode = "Static";
			break;
			case "DYNAMIC":
			IPDSLiteList[i].WorkMode = "Dynamic";
			break;
			default:
			break;
		}
	    WanList[j].IPv6DSLite = IPDSLiteList[i].WorkMode;
		if(IPDSLiteList[i].WorkMode == "Off")
		{
			WanList[j].EnableDSLite = "0";
		}
		else
		{
			WanList[j].EnableDSLite = "1";
		}
		
		WanList[j].IPv6AFTRName = IPDSLiteList[i].AFTRName;	
	}

    if ((1 == IsTDE2Mode) && ("1" == WanList[j].IPv6Enable))
	{    
	    WanList[j].X_HW_UnnumberedModel = TDEIPWanIPv6AddressList[i].X_HW_UnnumberedModel;
        WanList[j].X_HW_TDE_IPv6AddressingType = TDEIPWanIPv6AddressList[i].X_HW_TDE_IPv6AddressingType;
        WanList[j].X_HW_DHCPv6ForAddress  = TDEIPWanIPv6AddressList[i].X_HW_DHCPv6ForAddress;
		WanList[j].X_HW_E8C_IPv6PrefixDelegationEnabled  = TDEIPDelegationEnabled[i].X_HW_E8C_IPv6PrefixDelegationEnabled;
	}

	if (true == Is6RdSupported()){
    	if((WanList[j].ProtocolType.toString() == "IPv4") && (WanList[j].Mode.toString().toUpperCase() == "IP_ROUTED"))
    	{
			WanList[j].RdMode = (IP6RDTunnelList[i].Enable6Rd == '1') ? IP6RDTunnelList[i].RdMode : "Off";
			WanList[j].Enable6Rd = IP6RDTunnelList[i].Enable6Rd;
			WanList[j].RdPrefix = IP6RDTunnelList[i].RdPrefix;
			WanList[j].RdPrefixLen = IP6RDTunnelList[i].RdPrefixLen;
			WanList[j].RdBRIPv4Address = IP6RDTunnelList[i].RdBRIPv4Address;
			WanList[j].RdIPv4MaskLen = IP6RDTunnelList[i].RdIPv4MaskLen;
    	}
	}
	
	if (true == IsRadioWanSupported(IPWanList[i]))
	{	
		if (RadioWanPSList.length > 1)
		{
			WanList[j].RadioWanPSEnable = RadioWanPSList[0].RadioWanPSEnable;
			WanList[j].AccessType = RadioWanPSList[0].AccessType;
			WanList[j].SwitchMode = RadioWanPSList[0].SwitchMode;
			WanList[j].SwitchDelayTime = RadioWanPSList[0].SwitchDelayTime;
			WanList[j].PingIPAddress = RadioWanPSList[0].PingIPAddress;
 		}
		
		if (RadioWanParaList.length > 1)
		{
			WanList[j].RadioWanUsername = RadioWanParaList[0].RadioWanUsername;
			WanList[j].RadioWanPassword = RadioWanParaList[0].RadioWanPassword;
			WanList[j].APN = RadioWanParaList[0].APN;
			WanList[j].DialNumber = RadioWanParaList[0].DialNumber;
			WanList[j].TriggerMode = WanList[j].ConnectionTrigger;
		}
	}
}

for(i=0; PPPWanList.length > 0 && i < PPPWanList.length - 1; j++,i++)
{	
    if("1" == PPPWanList[i].Tr069Flag || IsWanMustHidden(domainTowanname(PPPWanList[i].domain)) == true && ('JSCMCC' != CfgModeWord.toUpperCase() || PPPWanList[i].VlanId != 4031 || curUserType != 0))
	{
		j--;
    	continue;
	}

	if(true == IsRDSGatewayUser() && -1 == PPPWanList[i].ServiceList.toString().toUpperCase().indexOf("INTERNET"))
    {
	    j--;
	    continue;
    }
	if(filterWanOnlyTr069(PPPWanList[i]) == false )
    {
	    j--;
	    continue;
   	}
    	
    if(filterWanByVlan(PPPWanList[i]) == false )
   	{
	    j--;
	    continue;
   	}	
	
	if ((true == IsRadioWanSupported(PPPWanList[i])) && (true == IsInvalidRadioWan()))
	{
		j--;
		CompensateRadioWanCfg();
		continue;
	}

	WanList[j] = new WanInfoInst();
    ConvertPPPWan(PPPWanList[i], WanList[j]);
    WanList[j].Name = MakeWanName(PPPWanList[i]);

	if((WanList[j].ProtocolType.toString() == "IPv6") && (WanList[j].Mode.toString().toUpperCase() == "IP_ROUTED"))
	{
		switch(PPPDSLiteList[i].WorkMode.toUpperCase())
		{
			case "OFF":
			PPPDSLiteList[i].WorkMode = "Off";
			break;
			case "STATIC":
			PPPDSLiteList[i].WorkMode = "Static";
			break;
			case "DYNAMIC":
			PPPDSLiteList[i].WorkMode = "Dynamic";
			break;
			default:
			break;
		}
	    WanList[j].IPv6DSLite = PPPDSLiteList[i].WorkMode;
		if(PPPDSLiteList[i].WorkMode == "Off")
		{
			WanList[j].EnableDSLite = "0";
		}
		else
		{
			WanList[j].EnableDSLite = "1";
		}
		WanList[j].IPv6AFTRName = PPPDSLiteList[i].AFTRName;
	}

	if ((1 == IsTDE2Mode) && ("1" == WanList[j].IPv6Enable))
	{    
	    WanList[j].X_HW_UnnumberedModel = TDEPPPWanIPv6AddressList[i].X_HW_UnnumberedModel;
        WanList[j].X_HW_TDE_IPv6AddressingType = TDEPPPWanIPv6AddressList[i].X_HW_TDE_IPv6AddressingType;
        WanList[j].X_HW_DHCPv6ForAddress  = TDEPPPWanIPv6AddressList[i].X_HW_DHCPv6ForAddress;
		WanList[j].X_HW_E8C_IPv6PrefixDelegationEnabled  = TDEPPPDelegationEnabled[i].X_HW_E8C_IPv6PrefixDelegationEnabled;
	}

	if (true == Is6RdSupported()){
    	if((WanList[j].ProtocolType.toString() == "IPv4") && (WanList[j].Mode.toString().toUpperCase() == "IP_ROUTED"))
    	{
			WanList[j].RdMode = (PPP6RDTunnelList[i].Enable6Rd == '1') ? "Static" : "Off";
        	WanList[j].Enable6Rd = PPP6RDTunnelList[i].Enable6Rd;
        	WanList[j].RdPrefix = PPP6RDTunnelList[i].RdPrefix;
        	WanList[j].RdPrefixLen = PPP6RDTunnelList[i].RdPrefixLen;
        	WanList[j].RdBRIPv4Address = PPP6RDTunnelList[i].RdBRIPv4Address;
        	WanList[j].RdIPv4MaskLen = PPP6RDTunnelList[i].RdIPv4MaskLen;
    	}
    }
	
	if (true == IsRadioWanSupported(PPPWanList[i])) 
	{
		if (RadioWanPSList.length > 1)
		{
			WanList[j].RadioWanPSEnable = RadioWanPSList[0].RadioWanPSEnable;
			WanList[j].AccessType = RadioWanPSList[0].AccessType;
			WanList[j].SwitchMode = RadioWanPSList[0].SwitchMode;
			WanList[j].SwitchDelayTime = RadioWanPSList[0].SwitchDelayTime;
			WanList[j].PingIPAddress = RadioWanPSList[0].PingIPAddress;
 		}

		if (RadioWanParaList.length > 1)
		{
			WanList[j].RadioWanUsername = RadioWanParaList[0].RadioWanUsername;
			WanList[j].RadioWanPassword = RadioWanParaList[0].RadioWanPassword;
			WanList[j].APN = RadioWanParaList[0].APN;
			WanList[j].DialNumber = RadioWanParaList[0].DialNumber;
			WanList[j].TriggerMode = WanList[j].ConnectionTrigger;
		}
	}
}

WanList.sort(
	function (wan1, wan2)
	{
		var cmp = 0;
		
		if(wan1.MacId > wan2.MacId)
				cmp = 1;
		else if(wan1.MacId < wan2.MacId)
			cmp = -1;
		else 
			cmp = 0;
			
		return cmp;
	}
);

try
{
    this.IPv6PrefixMode   = "PrefixDelegation";
    this.IPv6AddressStuff = "";
    this.IPv6AddressMode  = "DHCPv6";
    this.IPv6StaticPrefix = "20::01/64";
    this.IPv6IPAddress    = "20::02";
    this.IPv6AddrMaskLenE8c    = "64";
    this.IPv6GatewayE8c    = "";
	this.IPv6ReserveAddress = "";
    this.IPv6SubnetMask   = "";
    this.IPv6Gateway      = "";
    this.IPv6PrimaryDNS   = "";
    this.IPv6SecondaryDNS = "";
    this.IPv6WanMVlanId   = "";
    
    for (var i = 0; i < WanList.length; i++)
    {
        var AddressAcquireItem = GetIPv6AddressAcquireInfo(WanList[i].domain);
        var PrefixAcquireItem = GetIPv6PrefixAcquireInfo(WanList[i].domain);

        WanList[i].IPv6AddressMode = (null != AddressAcquireItem && AddressAcquireItem.Origin!="") ? AddressAcquireItem.Origin : "None";
        WanList[i].IPv6AddressStuff = (null != AddressAcquireItem) ? AddressAcquireItem.ChildPrefixBits : "";
        WanList[i].IPv6IPAddress = (null != AddressAcquireItem) ? AddressAcquireItem.IPAddress : "";
        WanList[i].IPv6AddrMaskLenE8c = (null != AddressAcquireItem) ? AddressAcquireItem.AddrMaskLen : "";
        WanList[i].IPv6GatewayE8c = (null != AddressAcquireItem) ? AddressAcquireItem.DefaultGateway : "";
		if (WanList[i].EncapMode == "IPoE")
		{	
			WanList[i].IPv6ReserveAddress = (null != AddressAcquireItem) ? AddressAcquireItem.IPv6ReserveAddress : "";
		}
		else if (WanList[i].EncapMode == "PPPoE")
		{
			WanList[i].IPv6ReserveAddress = "";
		}
        WanList[i].IPv6PrefixMode = (null != PrefixAcquireItem && PrefixAcquireItem.Origin!="") ? PrefixAcquireItem.Origin : "None";
		
		WanList[i].EnablePrefix =(WanList[i].IPv6PrefixMode == "None") ? "0":"1";
		
        WanList[i].IPv6StaticPrefix = (null != PrefixAcquireItem) ? PrefixAcquireItem.Prefix : "";
    }
}
catch(ex)
{
    
}

function GetIPv6WanDNS(IPv6WanDomain)
{
  var DnsServer = GetIPv6WanDnsServerInfo(domainTowanname(IPv6WanDomain));

  if(DnsServer == null || DnsServer=="")
  {
    return null;
  }

  return DnsServer.DNSServer;
}


try
{
    for (var i = 0; i < WanList.length; i++)
    {
        var DnsServer = GetIPv6WanDNS(WanList[i].domain);

        if (DnsServer == null)
        {
            continue;
        }
        
        var DnsServerList = DnsServer.split(",");
        if (DnsServerList == null)
        {
            continue;
        }
        
        WanList[i].IPv6PrimaryDNS = ((DnsServerList.length >= 1) ? DnsServerList[0] : "");
        WanList[i].IPv6SecondaryDNS = ((DnsServerList.length >= 2) ? DnsServerList[1] : "");
    }    
}catch(ex){}

function ModifyWanList(ModifyFunc)
{
	if (ModifyFunc == null || ModifyFunc == undefined)
	{
		return;
	}

	for (var i = 0; i < WanList.length; i++)
	{	
		try
		{
			ModifyFunc(WanList[i]);
		}
		catch(e)
		{
			
		}
	}
}

function GetWanList()
{
    return WanList;
}

function IsOnlyReadWan(wan)
{
	return (GetISPWanOnlyRead() && IsWanHidden(domainTowanname(wan.domain)));
}


function GetRadioWanParaList()
{
	return RadioWanParaList;
}

function GetRadioWanPSList()
{
	return RadioWanPSList;
}

function IsTr069WanOnlyRead()
{
    return Tr069WanOnlyRead;
}

function GetWanListByFilter(filterFunction)
{
  var WansResult = new Array();
  var WanList = GetWanList();
  var i=0;
  var j=0;
  
  for (i = 0; i < WanList.length; i++)
  {    
     if (filterFunction != null && filterFunction != undefined)
     {
        if (filterFunction(WanList[i]) == false)
        {
           continue;
        }
     }
     
     WansResult[j]=WanList[i];
     j++;
  }

  return WansResult;
}

function InitWanNameListControl(WanListControlId, IsThisWanOkFunction)
{
    var Control = getElById(WanListControlId);
    var WanList = GetWanListByFilter(IsThisWanOkFunction);
    var i = 0;
    var NullOption = document.createElement("Option");
    NullOption.value = '';
    NullOption.innerText = '';
    NullOption.text = '';
    Control.appendChild(NullOption);
	
    for (i = 0; i < WanList.length; i++)
    {    
        var Option = document.createElement("Option");
        Option.value = domainTowanname(WanList[i].domain);
        Option.innerText = MakeWanName1(WanList[i]);
        Option.text = MakeWanName1(WanList[i]);
        Control.appendChild(Option);
    }
}
function InitWanNameListControl1(WanListControlId, IsThisWanOkFunction)
{
    var Control = getElById(WanListControlId);
    var WanList = GetWanListByFilter(IsThisWanOkFunction);
    var i = 0;
    var NullOption = document.createElement("Option");
    NullOption.value = '';
    NullOption.innerText = '';
    NullOption.text = '';
    Control.appendChild(NullOption); 
    
    for (i = 0; i < WanList.length; i++)
    {    
        var Option = document.createElement("Option");
        Option.value = WanList[i].domain;
        Option.innerText = MakeWanName1(WanList[i]);
        Option.text = MakeWanName1(WanList[i]); 
        
        Control.appendChild(Option);
    }
}
function InitWanNameListControl2(WanListControlId, IsThisWanOkFunction)
{
    var Control = getElById(WanListControlId);
    var WanList = GetWanListByFilter(IsThisWanOkFunction);
    var i = 0;

    for (i = 0; i < WanList.length; i++)
    {
        var Option = document.createElement("Option");
        Option.value = WanList[i].domain;
        Option.innerText = MakeWanName1(WanList[i]);
        Option.text = MakeWanName1(WanList[i]);

        Control.appendChild(Option);
    }
}
function InitWanNameListControlWanname(WanListControlId, IsThisWanOkFunction)
{
    var Control = getElById(WanListControlId);
    var WanList = GetWanListByFilter(IsThisWanOkFunction);
    var i = 0;   

    for (i = 0; i < WanList.length; i++)
    {
        var Option = document.createElement("Option");
        Option.value = domainTowanname(WanList[i].domain);
        Option.innerText = MakeWanName1(WanList[i]);
        Option.text = MakeWanName1(WanList[i]);
        Control.appendChild(Option);
    }
}


function GetWanFullName(WanName)
{
    for (var i = 0; i < WanList.length;i++)
    {
	    if (WanList[i].NewName == WanName)
		{
			return MakeWanName(WanList[i]);
		}
    }

    return WanName;
}

function PS_GetCmdFormat(type, dev, protocal, start, end)
{
    var cmd = type 
              + "/" + dev 
              + "/" + (("TCP/UDP" == protocal.toUpperCase())?"tcpudp":protocal) 
              + "/" + start 
              + "/" + (((end.length == 0) || (parseInt(end, 10) == 0))? 1:(parseInt(end, 10) - parseInt(start, 10) + 1));
              
    return cmd.toLowerCase();
}

function PS_CheckReservePort(Operation, NewPort, OldPOrt)
{
    var conflict = false;   
    
    $.ajax({
        type  : "POST",
        async : false,
        cache : false,
        data  : "act=" + Operation+ "&new=" + NewPort + "&old=" + OldPOrt,
        url   : "pdtportcheck",
        success : function(data) {
            conflict = true;
        },
        error : function(XMLHttpRequest, textStatus, errorThrown) {
            conflict = false;
        },
        complete: function (XHR, TS) { 
            XHR = null;
      }         
    }); 
    
    return conflict;
}

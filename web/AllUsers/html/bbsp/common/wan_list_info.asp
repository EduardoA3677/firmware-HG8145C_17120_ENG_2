var CfgModePCCWHK = "<%HW_WEB_GetFeatureSupport(BBSP_FT_PCCW);%>";
var SupportIPv6 = "<%HW_WEB_GetFeatureSupport(BBSP_FT_IPV6);%>";
var supportTelmex = "<%HW_WEB_GetFeatureSupport(BBSP_FT_TELMEX);%>";
var SetIdleDisconnectMode = "<%HW_WEB_GetFeatureSupport(BBSP_FT_PPPOE_DETECTUPSTREAM);%>";
var MngtShct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SHCT);%>';
var RdFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_IPV6_6RD);%>";
var RadioWanFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_RADIO_WAN_LOAD);%>";
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var CUVoiceFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_UNICOM_DIS_VOICE);%>";
var radio_hidepassword=",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,";
var SonetFlag = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SONET);%>';
var IsSupportVoice = '<%HW_WEB_GetFeatureSupport(HW_VSPA_FEATURE_VOIP);%>';
var CurrentBin = '<%HW_WEB_GetBinMode();%>'; 

var RADIOWAN_NAMEPREFIX = "RADIO";
function stAuthState(AuthState)
{
	this.AuthState=AuthState;
}
var SimConnStates=<%HW_Web_GetCardOntAuthState(stAuthState);%>;
var SimIsAuth=SimConnStates[0].AuthState;
var JsctSpecVlan='<%HW_WEB_GetSPEC(BBSP_SPEC_FILTERWAN_BYVLAN.STRING);%>';

function GetWebConfigRGEnable()
{
    var WebConfigRGEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_FeatureList.BBSPWebCustomization.WebConfigRGEnable);%>';
    
    switch(WebConfigRGEnable)
    {
		case '0':
		case '1':
			return WebConfigRGEnable;
		default:
			return '0';
	}
}

function bin3board()
{
	if((productName == 'HG8242') || (productName == 'HG8010') || (productName == 'HG8110') || (productName == 'HG8120') || (productName == 'HG8240B') || (productName == 'HG8240J') || (productName == 'HG8240S') || (productName == 'HG8040'))
	{
		return true;
	}
	return false;
}

function bin4board_nonvoice()
{
	if(productName == 'HG8045A' || productName == 'HG8045H' || productName == 'HG8045D' || IsSupportVoice != '1')
	{
		return true;
	}
	return false;
}

var FtWebRgEn = "<% HW_WEB_GetFeatureSupport(BBSP_FT_WEB_CFG_RG_EN_VALID);%>";
var FtBin5Enhanced = "<%HW_WEB_GetFeatureSupport(BBSP_FT_BIN5_ENHANCED);%>";
var FtBin5Board = "<%HW_WEB_GetFeatureSupport(BBSP_FT_BIN5_BOARD);%>";

function bin5board()
{
	var name = productName.toUpperCase();
    if ("1" == FtBin5Enhanced){
  	  return false;
    }
	
	if(name == 'HG8240F')
	{
		if (("1" == FtWebRgEn) && ('1' == GetWebConfigRGEnable()))
    	{
        	return false;
    	}
		else
		{
			return true;
		}
	}

	if ("1" == FtBin5Board)
	{
  	  return true;
    }
    
	return false;
}

function IsSonetUser()
{
	if((SonetFlag == '1')
	   && curUserType != '0')
	{
		return true;
	}
	else
	{
		return false;
	}
}


function IsSCCT()
{
	return ('SCCT' == CfgModeWord.toUpperCase() );
}

function IsRDSGatewayUser()
{
	if('RDSGATEWAY' == CfgModeWord.toUpperCase() && curUserType != sysUserType)
	{
		return true;
	}
	else
	{
		return false;
	}
}

function IsVnpt()
{
	return ('VNPT' == CfgModeWord.toUpperCase());
}

function filterWanByFeature(WanItem)
{
	var filterWanFeater = "<%HW_WEB_GetFeatureSupport(FT_NORMAL_ONLY_SHOW_PPPOE_INFO);%>";
	if("1" == filterWanFeater && curUserType != '0' && !(WanItem.EncapMode.toUpperCase() == "PPPOE" && WanItem.Mode == "IP_Routed") && (false == IsLanUpport()))
	{
		return false;
	}
	return true;
}

function filterWanOnlyTr069(WanItem)
{
	if ("0" == SimIsAuth && WanItem.ServiceList.indexOf("TR069") < 0)
	{
	    return false;
	}
	return true;
}

function filterWanByVlan(WanItem)
{
	if (WanItem.VlanId == parseInt(JsctSpecVlan) && curUserType != 0)
	{
	    return false;
	}
	return true;
}

function Is6RdSupported()
{
	if (("1" == RdFeature) && ("1" == supportTelmex))
	{
		return true;
	}
	
    return false;
} 

function IsRadioWanSupported(wan)
{
    if ("1" != RadioWanFeature)
    {
        return false;
    }
    
	if ((wan.Name.indexOf(RADIOWAN_NAMEPREFIX) >=0) || (wan.Name.indexOf("Mobile") >=0) || (wan.X_HW_LowerLayers.indexOf("radio") >=0))
	{
		return true;
	}
		
	return false;
}

function WanInfoInst()
{
    this.domain  = null;
    
    this.RealName     = "";
    this.ConnectionTrigger = "";
    this.ConnectionControl = "";
    this.MACAddress   = "";
    this.Status       = "";
    this.LastConnErr  = "";
    this.Enable       = "1";
	this.RemoteWanInfo = "";
    this.Name         = "";
	this.NewName 	  = "";
    this.EncapMode    = "IPoE";
    this.ProtocolType = "IPv4";
    this.IPv4Enable   = "1";
    this.IPv6Enable   = "0";
    this.Mode         = "IP_Routed";
    this.ServiceList  = "INTERNET";
	if (bin5board() == true) 
    {
        this.ServiceList  = "TR069";
    }
	if("TELMEXACCESS" == CfgModeWord.toUpperCase())
	{
		this.ServiceList  = "TR069_INTERNET";
	}
    this.EnableVlan   = "1";
    this.VlanId       = "";
    //this.PriorityPolicy = "Specified";
    this.PriorityPolicy = ("1" == supportTelmex)?"CopyFromIPPrecedence":"Specified";
    this.DefaultPriority   = "0";
    this.Priority     = "0";
	if ("1" == supportTelmex)
	{
		this.UserName     = "";
		this.Password     = "";
	}
	else
	{
		this.UserName     = "iadtest@pppoe";
		this.Password     = "iadtest";
	}
    this.LcpEchoReqCheck = "0";
	this.PPPoEACName  = "";
	this.MacId        = "0";
    
    this.IPv4AddressMode   = "DHCP";
	this.IPv4MXU           = "";
    this.IPv4NATEnable     = "1";
    this.NatType = "0";
    this.IPv4VendorId      = "";
    this.IPv4ClientId      = "";
    
    this.IPv4IPAddress    = "";
    this.IPv4SubnetMask   = "";
    this.IPv4Gateway      = "";
    this.IPv4PrimaryDNS   = "";
    this.IPv4SecondaryDNS = "";
	
    this.DHCPLeaseTime = "0";
    this.DHCPLeaseTimeRemaining = "0";
	this.NTPServer = "";
	this.TimeZoneInfo = "";
	this.SIPServer = "";
	this.StaticRouteInfo = "";
	this.VendorInfo = "";
    
    this.IPv4DialMode     = "AUTO";
	if( true == IsSCCT() )
    {
		this.IPv4DialIdleTime = "1800";
    }
    else
    {
		this.IPv4DialIdleTime = "180";
    }
    this.IPv4IdleDisconnectMode = "";
    this.IPv4PPPoEAccountEnable = "disable";
    this.IPv4WanMVlanId   = "";
    this.IPv4BindLanList  = new Array();
	this.IPv4BindSsidList  = new Array();
    this.EnableLanDhcp   = "1";
    this.DstIPForwardingList   = "";

    this.IPv6PrefixMode   = "PrefixDelegation";
    this.IPv6AddressStuff = "";
    this.IPv6AddressMode  = "AutoConfigured";
	this.X_HW_E8C_IPv6PrefixDelegationEnabled = "1";
    this.X_HW_UnnumberedModel = "0";
    this.X_HW_TDE_IPv6AddressingType = "SLAAC";
    this.X_HW_DHCPv6ForAddress  = "0";
    this.IPv6StaticPrefix = "";
	this.IPv6ReserveAddress = "";
    this.IPv6IPAddress    = "";
    this.IPv6AddrMaskLenE8c    = "64";
    this.IPv6GatewayE8c    = "";
    this.IPv6SubnetMask   = "";
    this.IPv6Gateway      = "";
    this.IPv6PrimaryDNS   = "";
    this.IPv6SecondaryDNS = "";
    this.IPv6WanMVlanId   = "";
	
	this.IPv6DSLite         = "Off";
	this.EnableDSLite       = "0";
	this.IPv6AFTRName       = "";
	this.EnablePrefix       = "1";

	this.Enable6Rd = "0";
	this.RdMode = "Off";
	this.RdPrefix = "";
	this.RdPrefixLen = "";
	this.RdBRIPv4Address = "";
	this.RdIPv4MaskLen = "";
	
	this.RadioWanPSEnable = "0";
	this.AccessType = "1"; 
	this.SwitchMode = "Auto"; 
	this.SwitchDelayTime = "30";
	this.PingIPAddress = "";
 	
	this.RadioWanUsername = "";
	this.RadioWanPassword = radio_hidepassword;
	this.APN = "";
	this.DialNumber = "";
	this.TriggerMode = "AlwaysOn";
	this.Uptime = 0;
	this.IPv4DNSOverrideSwitch = "0";
	this.X_HW_LowerLayers = "";
}

function GetIpWan6RDTunnelInfo(domain,Enable,RdMode,RdPrefix,RdPrefixLen, RdBRIPv4Address,RdIPv4MaskLen)
{
	this.domain = domain;
	this.Enable6Rd = Enable;
	this.RdMode = RdMode;
	this.RdPrefix = RdPrefix;
	this.RdPrefixLen = RdPrefixLen;
	this.RdBRIPv4Address = RdBRIPv4Address;
	this.RdIPv4MaskLen = RdIPv4MaskLen;
	
} 

function GetPppWan6RDTunnelInfo(domain,Enable,RdPrefix,RdPrefixLen, RdBRIPv4Address,RdIPv4MaskLen)
{
	this.domain = domain;
	this.Enable6Rd = Enable;
	this.RdPrefix = RdPrefix;
	this.RdPrefixLen = RdPrefixLen;
	this.RdBRIPv4Address = RdBRIPv4Address;
	this.RdIPv4MaskLen = RdIPv4MaskLen;
} 

function DsLiteInfo(domain, WorkMode, AFTRName)
{
	this.domain = domain;
	this.WorkMode = WorkMode;
	this.AFTRName = AFTRName;
} 

function RadioWanClass(domain, RadioWanUsername, APN, DialNumber, TriggerMode)
{
	this.domain = domain;
	this.RadioWanUsername  = RadioWanUsername;
	this.RadioWanPassword  = radio_hidepassword;
	this.APN  = APN;
	this.DialNumber  = DialNumber;
	this.TriggerMode  = TriggerMode;
}

function RadioWanPSClass(domain, RadioWanPSEnable, SwitchMode, SwitchDelayTime, PingIPAddress, RadioWANIndex)
{
	this.domain = domain;
	this.RadioWanPSEnable = RadioWanPSEnable;
	this.AccessType = "0";
	this.SwitchMode = SwitchMode;
	this.SwitchDelayTime = SwitchDelayTime;
	this.PingIPAddress = PingIPAddress;
	this.RadioWANIndex = RadioWANIndex; 
}

function TDEIPWanIPv6AddressClass(domain, X_HW_UnnumberedModel, X_HW_TDE_IPv6AddressingType, X_HW_DHCPv6ForAddress)
{
	this.domain = domain;
	this.X_HW_UnnumberedModel = X_HW_UnnumberedModel;
	this.X_HW_TDE_IPv6AddressingType = X_HW_TDE_IPv6AddressingType;
	this.X_HW_DHCPv6ForAddress = X_HW_DHCPv6ForAddress;
}

function TDEPPPWanIPv6AddressClass(domain, X_HW_UnnumberedModel, X_HW_TDE_IPv6AddressingType, X_HW_DHCPv6ForAddress)
{
	this.domain = domain;
	this.X_HW_UnnumberedModel = X_HW_UnnumberedModel;
	this.X_HW_TDE_IPv6AddressingType = X_HW_TDE_IPv6AddressingType;
	this.X_HW_DHCPv6ForAddress = X_HW_DHCPv6ForAddress;
}

function TDE_IP_DelegationEnabledClass(domain, X_HW_E8C_IPv6PrefixDelegationEnabled)
{
	this.domain = domain;
	this.X_HW_E8C_IPv6PrefixDelegationEnabled = X_HW_E8C_IPv6PrefixDelegationEnabled;
}

function TDE_PPP_DelegationEnabledClass(domain, X_HW_E8C_IPv6PrefixDelegationEnabled)
{
	this.domain = domain;
	this.X_HW_E8C_IPv6PrefixDelegationEnabled = X_HW_E8C_IPv6PrefixDelegationEnabled;
}

WanInfoInst.prototype.clone = function()
{
	var newObj = new WanInfoInst();
	for(emplement in this)
	{
		newObj[emplement] = this[emplement];
	}
	return newObj;	
}

function GetProtocolType(IPv4Enable, IPv6Enable)
{
    if (IPv4Enable == "1" && IPv6Enable == "1")
    {
        return "IPv4/IPv6";
    }
    if (IPv4Enable == "1")
    {
        return "IPv4";
    }
    return "IPv6"
}

function WanIP(domain,ConnectionTrigger,MACAddress, Status, LastConnErr, RemoteWanInfo, Name,Enable,EnableLanDhcp,DstIPForwardingList,ConnectionStatus,
                Mode,IPMode,IPAddress,SubnetMask,Gateway,
                NATEnable,X_HW_NatType,dnsstr,VlanId,MultiVlanID,Pri8021,VenderClassID,ClientID,ServiceList,ExServiceList,
                Tr069Flag, MacId, IPv4Enable, IPv6Enable, IPv6MultiCastVlan, PriPolicy, DefaultPri,MaxMTUSize,
                DHCPLeaseTime,NTPServer,TimeZoneInfo,SIPServer,StaticRouteInfo,VendorInfo,DHCPLeaseTimeRemaining,Uptime,DNSOverrideAllowed,X_HW_LowerLayers)
{
    this.domain 	= domain;	
    this.Uptime = Uptime;
    this.ConnectionTrigger = ConnectionTrigger;
    this.MACAddress = MACAddress;
    this.Status = Status;
    this.LastConnErr  = LastConnErr;
	this.RemoteWanInfo = RemoteWanInfo;
    this.Name 		= Name;
	this.NewName   =  domainTowanname(domain);
    this.Enable		= Enable;
    this.EnableLanDhcp = EnableLanDhcp;
    this.DstIPForwardingList   = DstIPForwardingList;
    this.ConnectionStatus = ConnectionStatus;

    this.Mode		= Mode;
    this.IPMode		= IPMode;

    this.IPAddress	= IPAddress;
    this.SubnetMask = SubnetMask;
    this.Gateway    = Gateway;

    this.NATEnable = NATEnable;
    this.X_HW_NatType = X_HW_NatType;

    var dnss 		= dnsstr.split(',');
    this.PrimaryDNS	 = dnss[0];  
    this.SecondaryDNS = (dnss.length >= 2) ? dnss[1] : "";
    this.VlanId   = VlanId;

    if((IPv6MultiCastVlan==0) && ('E8C' == CurrentBin.toUpperCase()))
    {
    	IPv6MultiCastVlan="";
    }

    this.MultiVlanID=(MultiVlanID > 4094 )?"":MultiVlanID;
    this.IPv6MultiVlanID=(IPv6MultiCastVlan > 4094 ) ? "":IPv6MultiCastVlan;
    this.PriorityPolicy = ((PriPolicy.toUpperCase() == "COPYFROMIPPRECEDENCE") ? "CopyFromIPPrecedence" : "Specified");
    this.DefaultPriority = DefaultPri;
    this.Pri8021  =  Pri8021;
    this.VenderClassID = VenderClassID;
    this.ClientID = ClientID;
    this.ServiceList = (ExServiceList.length == 0)?ServiceList.toUpperCase():ExServiceList.toUpperCase();

    this.isPPPoEAccountEnable = "disable";
    this.Tr069Flag = Tr069Flag;
	this.MacId = MacId;
    
    this.IPv4Enable = IPv4Enable;
    this.IPv6Enable = IPv6Enable;
	if (0 == SupportIPv6)
	{
		this.IPv6Enable = 0;
		this.IPv4Enable = 1;
	}

	this.DHCPLeaseTime = DHCPLeaseTime;
	this.DHCPLeaseTimeRemaining = DHCPLeaseTimeRemaining;
	this.NTPServer = NTPServer;
	this.TimeZoneInfo = TimeZoneInfo;
	this.SIPServer = SIPServer;
	this.StaticRouteInfo = StaticRouteInfo;
	this.VendorInfo = VendorInfo;
	
    if(0 == MaxMTUSize)
	{
		this.IPv4MXU = 1500;
	}		
	else
	{
		this.IPv4MXU = MaxMTUSize;
	}
	this.DNSOverrideAllowed = DNSOverrideAllowed;
	this.X_HW_LowerLayers = X_HW_LowerLayers;
}

function WanPPP(domain, ConnectionTrigger, MACAddress, Status, LastConnErr, RemoteWanInfo, Name,Enable,EnableLanDhcp,DstIPForwardingList,ConnectionStatus,Mode,IPAddress,Gateway,NATEnable,X_HW_NatType,dnsstr,
                Username,Password,DialMode,ConnectionControl,VlanId,MultiVlanID,Pri8021,LcpEchoReqCheck,ServiceList,ExServiceList,Tr069Flag,
                IdleDisconnectTime, MacId, IPv4Enable, IPv6Enable, IPv6MultiCastVlan, PriPolicy, DefaultPri, MaxMRUSize, PPPoEACName,X_HW_IdleDetectMode, Uptime, DNSOverrideAllowed, X_HW_LowerLayers)
{
    this.domain 	       = domain;
    this.ConnectionTrigger = ConnectionTrigger;
    this.Uptime = Uptime;
    
    if (parseInt(ConnectionControl, 10) == 0xFFFFFFFF )
    {
        this.ConnectionControl = 0;
    }
    else
    {
        this.ConnectionControl = ConnectionControl;
    }
    
    this.MACAddress = MACAddress;
    
    if ((Status.toUpperCase() == "CONNECTING") && (this.ConnectionControl == "0") && (ConnectionTrigger == "Manual"))
    {
        this.Status = "Disconnected";
    }
    else
    {
        this.Status = Status;
    }
    
    this.LastConnErr  = LastConnErr;
	this.RemoteWanInfo = RemoteWanInfo;
	this.Name		  = Name;
    this.NewName	  = domainTowanname(domain);
    this.Enable		= Enable;
    this.EnableLanDhcp = EnableLanDhcp;
    this.DstIPForwardingList   = DstIPForwardingList;
    this.ConnectionStatus = ConnectionStatus;

    this.Mode		= Mode;
    this.IPMode		= 'PPPoE';

    this.IPAddress	= IPAddress;
    this.SubnetMask    = '255.255.255.255';
    this.Gateway        = Gateway;

    this.NATEnable 	= NATEnable; 
    this.X_HW_NatType = X_HW_NatType;
    
    var dnss 		= dnsstr.split(',');
    this.PrimaryDNS	= dnss[0];
    this.SecondaryDNS = (dnss.length >= 2) ? dnss[1] : "";

    this.Username = Username;
    
   if( (Password == 'd41d8cd98f00b204e9800998ecf8427e')
			|| (Password == 'D41D8CD98F00B204E9800998ECF8427E') )
	 {	
			this.Password = '';
	 }else
	 {
	 		this.Password = Password;
	 }
    
     this.LcpEchoReqCheck = LcpEchoReqCheck;
    

    this.DialMode = DialMode;

    this.VlanId    = VlanId;

    if(IPv6MultiCastVlan==0)
    {
    	IPv6MultiCastVlan="";
    }

    this.MultiVlanID=(MultiVlanID > 4094 )?"":MultiVlanID;
    this.IPv6MultiVlanID =(IPv6MultiCastVlan > 4094 ) ? "":IPv6MultiCastVlan;
    this.PriorityPolicy = ((PriPolicy.toUpperCase() == "COPYFROMIPPRECEDENCE") ? "CopyFromIPPrecedence" : "Specified")
    this.DefaultPriority = DefaultPri;
    this.Pri8021  =  Pri8021;
    this.ServiceList = (ExServiceList.length == 0)?ServiceList.toUpperCase():ExServiceList.toUpperCase();

    this.IdleDisconnectTime = IdleDisconnectTime;
    this.IPv4IdleDisconnectMode = X_HW_IdleDetectMode;
    this.Tr069Flag = Tr069Flag;
	this.MacId = MacId;
    
    this.IPv4Enable = IPv4Enable;
    this.IPv6Enable = IPv6Enable;
	if (0 == SupportIPv6)
	{
		this.IPv6Enable = 0;
		this.IPv4Enable = 1;
	}
	
	this.PPPoEACName = PPPoEACName;
	if(0 == MaxMRUSize)
		this.IPv4MXU = 1492;
	else
		this.IPv4MXU = MaxMRUSize;

    this.DNSOverrideAllowed = DNSOverrideAllowed;
    this.X_HW_LowerLayers = X_HW_LowerLayers;
}

function ConvertIPWan(IPWan, CommonWanInfo)
{
    CommonWanInfo.domain  = IPWan.domain;
    
    CommonWanInfo.RealName     = IPWan.Name;
    CommonWanInfo.ConnectionTrigger = IPWan.ConnectionTrigger
    CommonWanInfo.MACAddress   = IPWan.MACAddress;
    CommonWanInfo.Status       = IPWan.Status;
    CommonWanInfo.LastConnErr  = IPWan.LastConnErr;
    CommonWanInfo.Enable       = IPWan.Enable;
    CommonWanInfo.EnableLanDhcp   = IPWan.EnableLanDhcp;
    CommonWanInfo.DstIPForwardingList   = IPWan.DstIPForwardingList;
	CommonWanInfo.RemoteWanInfo = IPWan.RemoteWanInfo;
    CommonWanInfo.Name         = IPWan.Name;
	CommonWanInfo.NewName      = IPWan.NewName;
    CommonWanInfo.ProtocolType = GetProtocolType(IPWan.IPv4Enable, IPWan.IPv6Enable);
    CommonWanInfo.IPv4Enable   = IPWan.IPv4Enable;
    CommonWanInfo.IPv6Enable   = IPWan.IPv6Enable;
    CommonWanInfo.EncapMode    = "IPoE";
    CommonWanInfo.Mode         = IPWan.Mode;
    CommonWanInfo.ServiceList  = IPWan.ServiceList.toUpperCase();
    CommonWanInfo.EnableVlan   = (IPWan.VlanId == "0") ? "0" : "1";
    CommonWanInfo.VlanId       = IPWan.VlanId;
    CommonWanInfo.PriorityPolicy  = IPWan.PriorityPolicy;
    CommonWanInfo.DefaultPriority = IPWan.DefaultPriority;
    CommonWanInfo.Priority     = IPWan.Pri8021;
    CommonWanInfo.Tr069Flag    = IPWan.Tr069Flag;
	if ("1" == supportTelmex )
	{
		CommonWanInfo.UserName     = "";
		CommonWanInfo.Password     = "";
	}
	else
	{
		CommonWanInfo.UserName     = "iadtest@pppoe";
		CommonWanInfo.Password     = "iadtest";
	}
    CommonWanInfo.LcpEchoReqCheck  = "0";
	CommonWanInfo.MacId        = IPWan.MacId;

	switch(IPWan.IPMode.toString().toUpperCase())
	{
		case 'STATIC':
			CommonWanInfo.IPv4AddressMode = 'Static';
			break;
		case 'DHCP':
			CommonWanInfo.IPv4AddressMode = 'DHCP';
			break;
	    case 'AUTO':
	        CommonWanInfo.IPv4AddressMode = 'Auto';
			break;
		default:
			break;
	}
	CommonWanInfo.IPv4MXU           = IPWan.IPv4MXU;
    CommonWanInfo.IPv4NATEnable     = IPWan.NATEnable;
    CommonWanInfo.NatType     = IPWan.X_HW_NatType;
    CommonWanInfo.IPv4VendorId      = IPWan.VenderClassID;
    CommonWanInfo.IPv4ClientId      = IPWan.ClientID;
    
    CommonWanInfo.IPv4IPAddress    = IPWan.IPAddress;
    CommonWanInfo.IPv4SubnetMask   = IPWan.SubnetMask;
    CommonWanInfo.IPv4Gateway      = IPWan.Gateway;
    CommonWanInfo.IPv4PrimaryDNS   = IPWan.PrimaryDNS;
    CommonWanInfo.IPv4SecondaryDNS = IPWan.SecondaryDNS;
    CommonWanInfo.DHCPLeaseTime = IPWan.DHCPLeaseTime;
    CommonWanInfo.DHCPLeaseTimeRemaining = IPWan.DHCPLeaseTimeRemaining;
	CommonWanInfo.NTPServer = IPWan.NTPServer;
	CommonWanInfo.TimeZoneInfo = IPWan.TimeZoneInfo;
	CommonWanInfo.SIPServer = IPWan.SIPServer;
	CommonWanInfo.StaticRouteInfo = IPWan.StaticRouteInfo;
	CommonWanInfo.VendorInfo = IPWan.VendorInfo;
    
    CommonWanInfo.IPv4DialMode     = "AUTO";
    CommonWanInfo.IPv4DialIdleTime = "180";
    CommonWanInfo.IPv4IdleDisconnectMode = IPWan.IPv4IdleDisconnectMode;
    CommonWanInfo.IPv4WanMVlanId   = IPWan.MultiVlanID;
    CommonWanInfo.IPv4BindLanList  = new Array();
	CommonWanInfo.IPv4BindSsidList  = new Array();


    CommonWanInfo.IPv6PrefixMode   = "SLAAC";
    CommonWanInfo.IPv6AddressMode  = "DHCP";
    CommonWanInfo.IPv6AddressStuff = "";
    CommonWanInfo.IPv6StaticPrefix = "";
	CommonWanInfo.IPv6ReserveAddress = IPWan.IPv6ReserveAddress;
    CommonWanInfo.IPv6IPAddress    = "";
    CommonWanInfo.IPv6AddrMaskLenE8c    = "64";
    CommonWanInfo.IPv6GatewayE8c    = "";
    CommonWanInfo.IPv6SubnetMask   = "";
    CommonWanInfo.IPv6Gateway      = "";
    CommonWanInfo.IPv6PrimaryDNS   = "";
    CommonWanInfo.IPv6SecondaryDNS = "";
    CommonWanInfo.IPv6WanMVlanId   = (IPWan.IPv6MultiVlanID == "-1")  ?  "" : IPWan.IPv6MultiVlanID;
    CommonWanInfo.Uptime = IPWan.Uptime;
    CommonWanInfo.IPv4DNSOverrideSwitch = IPWan.DNSOverrideAllowed;
    CommonWanInfo.X_HW_LowerLayers = IPWan.X_HW_LowerLayers;
}

function ConvertPPPWan(PPPWan, CommonWanInfo)
{
    CommonWanInfo.domain  = PPPWan.domain;

    CommonWanInfo.RealName     = PPPWan.Name;
    CommonWanInfo.ConnectionTrigger = PPPWan.ConnectionTrigger;
    CommonWanInfo.ConnectionControl = PPPWan.ConnectionControl;
    CommonWanInfo.MACAddress   = PPPWan.MACAddress;
    CommonWanInfo.Status       = PPPWan.Status;
    CommonWanInfo.LastConnErr  = PPPWan.LastConnErr;
    CommonWanInfo.Enable       = PPPWan.Enable;
    CommonWanInfo.EnableLanDhcp   = PPPWan.EnableLanDhcp;
    CommonWanInfo.DstIPForwardingList   = PPPWan.DstIPForwardingList;
	CommonWanInfo.RemoteWanInfo = PPPWan.RemoteWanInfo;
    CommonWanInfo.Name         = PPPWan.Name; 
	CommonWanInfo.NewName      = PPPWan.NewName; 
    CommonWanInfo.ProtocolType = GetProtocolType(PPPWan.IPv4Enable, PPPWan.IPv6Enable);
    CommonWanInfo.IPv4Enable   = PPPWan.IPv4Enable;
    CommonWanInfo.IPv6Enable   = PPPWan.IPv6Enable;
    CommonWanInfo.EncapMode    = "PPPoE";
	if (PPPWan.Mode.toString().toUpperCase().indexOf("BRIDGED") >= 0)
	{
		CommonWanInfo.Mode     = "IP_Bridged";
	}
	else
	{
		CommonWanInfo.Mode     = "IP_Routed";
	}
    CommonWanInfo.ServiceList  = PPPWan.ServiceList.toUpperCase();
    CommonWanInfo.EnableVlan   = (PPPWan.VlanId == "0") ? "0" : "1";
    CommonWanInfo.VlanId       = PPPWan.VlanId;
    CommonWanInfo.PriorityPolicy  = PPPWan.PriorityPolicy;
    CommonWanInfo.DefaultPriority = PPPWan.DefaultPriority;
    CommonWanInfo.Priority     = PPPWan.Pri8021;
    CommonWanInfo.Tr069Flag    = PPPWan.Tr069Flag;
    CommonWanInfo.UserName     = PPPWan.Username;
    CommonWanInfo.Password     = PPPWan.Password;
    CommonWanInfo.LcpEchoReqCheck = PPPWan.LcpEchoReqCheck;
	CommonWanInfo.PPPoEACName  = PPPWan.PPPoEACName;
	CommonWanInfo.MacId        = PPPWan.MacId;
    
    CommonWanInfo.IPv4AddressMode   = PPPWan.IPMode;
	CommonWanInfo.IPv4MXU           = PPPWan.IPv4MXU;
    CommonWanInfo.IPv4NATEnable     = PPPWan.NATEnable;
    CommonWanInfo.NatType     = PPPWan.X_HW_NatType;
    CommonWanInfo.IPv4VendorId      = "";
    CommonWanInfo.IPv4ClientId      = "";
    
    CommonWanInfo.IPv4IPAddress    = PPPWan.IPAddress;
    CommonWanInfo.IPv4SubnetMask   = PPPWan.SubnetMask;
    CommonWanInfo.IPv4Gateway      = PPPWan.Gateway;
    CommonWanInfo.IPv4PrimaryDNS   = PPPWan.PrimaryDNS;
    CommonWanInfo.IPv4SecondaryDNS = PPPWan.SecondaryDNS;
    CommonWanInfo.IPv4DialMode     = PPPWan.DialMode;
    CommonWanInfo.IPv4DialIdleTime = PPPWan.IdleDisconnectTime; 
    CommonWanInfo.IPv4IdleDisconnectMode = PPPWan.IPv4IdleDisconnectMode;
    CommonWanInfo.IPv4PPPoEAccountEnable = PPPWan.IPv4PPPoEAccountEnable;
    CommonWanInfo.IPv4WanMVlanId   = PPPWan.MultiVlanID;
    CommonWanInfo.IPv4BindLanList  = new Array();
	CommonWanInfo.IPv4BindSsidList  = new Array();

    CommonWanInfo.IPv6PrefixMode   = "SLAAC";
    CommonWanInfo.IPv6AddressMode  = "DHCP";
    CommonWanInfo.IPv6AddressStuff = "";
    CommonWanInfo.IPv6StaticPrefix = "";
	CommonWanInfo.IPv6ReserveAddress = PPPWan.IPv6ReserveAddress;
    CommonWanInfo.IPv6IPAddress    = "";
    CommonWanInfo.IPv6AddrMaskLenE8c    = "64";
    CommonWanInfo.IPv6GatewayE8c    = "";
    CommonWanInfo.IPv6SubnetMask   = "";
    CommonWanInfo.IPv6Gateway      = "";
    CommonWanInfo.IPv6PrimaryDNS   = "";
    CommonWanInfo.IPv6SecondaryDNS = "";
    CommonWanInfo.IPv6WanMVlanId   = (PPPWan.IPv6MultiVlanID == "-1")  ?  "" : PPPWan.IPv6MultiVlanID;
    CommonWanInfo.Uptime = PPPWan.Uptime;
    CommonWanInfo.IPv4DNSOverrideSwitch = PPPWan.DNSOverrideAllowed;
    CommonWanInfo.X_HW_LowerLayers = PPPWan.X_HW_LowerLayers;
}

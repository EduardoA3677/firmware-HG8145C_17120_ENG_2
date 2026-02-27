function USERDevice(Domain,IpAddr,MacAddr,Port,IpType,DevType,DevStatus,PortType,Time,HostName,IPv4Enabled,IPv6Enabled,DeviceType)
{
	this.Domain 	= Domain;
	this.IpAddr	    = IpAddr;
	this.MacAddr	= MacAddr;
	this.Port 		= Port;
	this.PortType	= PortType;
	
	this.DevStatus 	= DevStatus;
	this.IpType		= IpType;
	if(IpType=="Static")
	{
	  this.DevType="--";
	}
	else
	{
		if(DevType=="")
		{
			this.DevType	= "--";	
		}
		else
		{
			this.DevType	= DevType;		
		}	
	}
	this.Time	    = Time;
	
	if(HostName=="")
	{
		this.HostName	= "--";
	}
	else
	{
	   this.HostName	= HostName;
	}
	
	this.IPv4Enabled = IPv4Enabled;
	this.IPv6Enabled = IPv6Enabled;
	this.DeviceType = DeviceType;
	this.instid       = '';
	this.IsClickDev   = false;
}

var UserDevinfo = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecialGetUserDevInfo,InternetGatewayDevice.LANDevice.1.X_HW_UserDev.{i},IpAddr|MacAddr|PortID|IpType|DevType|DevStatus|PortType|time|HostName|IPv4Enabled|IPv6Enabled|DeviceType ,USERDevice);%>;

var UserDevinfoTmp = new Array();
for(var i = 0; i < UserDevinfo.length - 1; i++)
{
	var id = UserDevinfo[i].Domain.split(".");
	UserDevinfo[i].instid = id[id.length -1];
	if("1" == UserDevinfo[i].IPv4Enabled )
	{
		UserDevinfoTmp.push(UserDevinfo[i]);
	}
}
UserDevinfoTmp.push(null);

function GetUserDevInfoList()
{
	return UserDevinfoTmp;
}

GetUserDevInfoList();
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<style>
.padstyle {
	*padding-left: 0px;
	*padding-right: 0px;
}
</style>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<title>User Device Information</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>
<script language="javascript" src="../common/lanuserinfo.asp"></script>
<script language="JavaScript" type="text/javascript">
var MAX_DEV_TYPE=10;
var MAX_HOST_TYPE=10;
var appName = navigator.appName;
var DHCPLeaseTimes = new Array();
var UserDevices = new Array();
var UserDevicesTemp = new Array();

var ipaddress = "";
var macaddress = "";
var porttype = "";
var portid   = "";
var PccwFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PCCW);%>';
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var curCfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 


function GetRemainLeaseTime(ipaddr, macaddr)
{
	for (var i = 0; i < DHCPLeaseTimes.length - 1; i++)
	{
		if ((ipaddr == DHCPLeaseTimes[i].ip) && (macaddr == DHCPLeaseTimes[i].mac))
		{
			return DHCPLeaseTimes[i].remaintime;
		}
	}
	
	return -1;
}

function ShowTimeDisplay(UserDevicesInfo)
{
	var h = parseInt(UserDevicesInfo[i].Time.split(":")[0],10);
	var m = parseInt(UserDevicesInfo[i].Time.split(":")[1],10);
	var allSec = h*3600 + m*60;
	var unit_day = (parseInt(allSec/86400,10) > 1) ? userdevinfo_language['bbsp_days'] : userdevinfo_language['bbsp_day'];
	var day = parseInt(allSec/86400,10);
	var hour = parseInt((allSec%86400)/3600,10);
	var minitute = parseInt((allSec%3600)/60,10);
	var sec = parseInt(allSec%60,10);
	var timestr = day + unit_day + ','  + hour + ':' + minitute + ':' + sec;
	return timestr;
}

function appendstr(str)
{
	return str;
}
function showlistcontrol(UserDevicesInfo)
{
	var outputlist = "";
	var RecordCount = UserDevicesInfo.length;
	
	if( 0 == RecordCount )
	{
		outputlist = outputlist + appendstr("<tr class=\"tabal_01 align_center\">");
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr("</tr>");

		$("#devlist").append(outputlist);
		return;
	}

	for(var i = 0; i < RecordCount; i++)   
	{
		if (UserDevicesInfo[i].Port.toUpperCase().indexOf("SSID") >=0)
		{	
			var ssidindex = UserDevicesInfo[i].Port;	
			ssidindex = ssidindex.charAt(ssidindex.length-1);
			if (1 == isSsidForIsp(ssidindex) || 1 == IsRDSGatewayUserSsid(ssidindex))
			{
				continue;
			}
		}
		
		var hostport = '';
		if( "LAN0" == UserDevicesInfo[i].Port.toUpperCase() || "SSID0" == UserDevicesInfo[i].Port.toUpperCase())
		{
			hostport = "--";
		}
		else
		{
			hostport = UserDevicesInfo[i].Port.toUpperCase();
		}
		
		outputlist = outputlist + appendstr("<tr class=\"tabal_01 align_center\" >");
		outputlist = outputlist + '<td class="align_center">' + '<input name="rml" id="record_' + i+'" type="checkbox" value="' + UserDevicesInfo[i].Domain + '" nowrap></td>';
		if(('--' == UserDevicesInfo[i].HostName) && ("1" == GetCfgMode().TELMEX))
		{
		    outputlist = outputlist + appendstr('<td class="width_per15" nowrap>'+ UserDevicesInfo[i].MacAddr +'</td>');
		}
		else
		{
		    outputlist = outputlist + appendstr('<td class="width_per15" title="' + UserDevicesInfo[i].HostName + '" nowrap>'+GetStringContent(UserDevicesInfo[i].HostName, MAX_HOST_TYPE) +'</td>');
		}
		
		outputlist = outputlist + appendstr('<td class="width_per10" title="' + UserDevicesInfo[i].DevType + '" nowrap>'+GetStringContent(UserDevicesInfo[i].DevType, MAX_DEV_TYPE) +'</td>');
		outputlist = outputlist + appendstr('<td class="width_per15" nowrap>'+UserDevicesInfo[i].IpAddr+'</td>');
		outputlist = outputlist + appendstr('<td class="width_per15" nowrap>'+UserDevicesInfo[i].MacAddr+'</td>');
		outputlist = outputlist + appendstr('<td class="width_per5" nowrap>'+userdevinfo_language[UserDevicesInfo[i].DevStatus]  +'</td>');		
		outputlist = outputlist + appendstr('<td class="width_per5" nowrap>'+hostport+'</td>');
		
		var unit_h = (parseInt(UserDevicesInfo[i].Time.split(":")[0],10) > 1) ? userdevinfo_language['bbsp_hours'] : userdevinfo_language['bbsp_hour'];
		var unit_m = (parseInt(UserDevicesInfo[i].Time.split(":")[1],10) > 1) ? userdevinfo_language['bbsp_mins'] : userdevinfo_language['bbsp_min'];
		var time = '';
		if ('ONLINE' != UserDevicesInfo[i].DevStatus.toUpperCase())
		{
			time = '--';
		}
		else
		{
			time = UserDevicesInfo[i].Time.split(":")[0] + unit_h + UserDevicesInfo[i].Time.split(":")[1] + unit_m;
		}		
		outputlist = outputlist + appendstr('<td class="width_per20" nowrap>'+time  +'</td>');
		
		var leasetime = '';
		if ('DHCP' == UserDevicesInfo[i].IpType)
		{
			var remainleasetime = GetRemainLeaseTime(UserDevicesInfo[i].IpAddr, UserDevicesInfo[i].MacAddr);
			if (remainleasetime > 0)
			{
				leasetime = remainleasetime + userdevinfo_language['bbsp_second'];
			}
			else
			{
				leasetime = '--';
			}
		}
		else
		{
			leasetime = '--';
		}				
		outputlist = outputlist + appendstr('<td class="width_per10" nowrap>'+leasetime  +'</td>');
	}

	$("#devlist").append(outputlist);
}

function ButtonDisableAll()
{
	setDisable('detail',1);
	setDisable('delete',1);
	setDisable('ipfilter',1);
	setDisable('macfilter',1);
	setDisable('portmapping',1);
	setDisable('reserveip',1);
}

function IsSelectMulBox()
{
	var CheckBoxList = document.getElementsByName('rml');
	var Count = 0;
	for (var i = 0; i < CheckBoxList.length; i++)
	{
		if (CheckBoxList[i].checked != true)
		{
			continue;
		}
		
		Count++;
	}
	if (Count <= 1)
	{
		return false;
	}
	return true;
}

function getSelectIndex()
{
	var index = -1;
	for(var i = 0; i < UserDevices.length; i++)   
	{
		var CheckBox = document.getElementById('record_'+i);
		if (CheckBox.checked == true)
		{
			index = i;
			return index;
		}
	}
	return index;
}

function GetHpa(MainName)
{
	var menuItems = top.Frame.menuItems;	
	
	for(var i in menuItems)
	{		
		if(MainName == menuItems[i].name)
		{
			return menuItems.length - i;
		}
	}
	
	return -1;
}

function GetZpa(MainName, SubItemName)
{
	var Hpa = GetHpa(MainName);
	if(Hpa == -1)
	{
		return -1;
	}
	
	var subItems = top.Frame.menuItems[top.Frame.menuItems.length - Hpa].subMenus;
	for(var i in subItems)
	{
		if(SubItemName == subItems[i].name)
		{	
			return i;
		}
	}
	
	return -1;
}

function OnDetial()
{
	if (true == IsSelectMulBox())
	{
		AlertEx(userdevinfo_language['bbsp_selectonedev']);
		return;
	}
	var index = getSelectIndex();
	if (-1 == index)
	{
		AlertEx(userdevinfo_language['bbsp_selectdevice']);
		return;
	}
	
	window.location="userdetdevinfo.asp?" + index +  "?" + 'NOPAGE';
}

function OnDelete()
{
	var Form = new webSubmitForm();
	var Count = 0;
	for(var i = 0; i < UserDevices.length; i++)   
	{
		var CheckBox = document.getElementById('record_'+i);
		if (CheckBox.checked != true)
		{
			continue;
		}
		if ('ONLINE' == UserDevices[i].DevStatus.toUpperCase())
		{
			AlertEx(userdevinfo_language['bbsp_nodeletedev']);
			return false;
		}
		
		Count++;
		Form.addParameter(CheckBox.value,'');
	}
	if (Count <= 0)
	{
		AlertEx(userdevinfo_language['bbsp_selectdevice']);
		return false;
	}
	if (false == ConfirmEx(userdevinfo_language['bbsp_devinfodelconfirm'])) 
	{
		return false;
	}
        
    ButtonDisableAll();
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('del.cgi?' +'x=InternetGatewayDevice.LANDevice.1.X_HW_UserDev' + '&RequestFile=html/bbsp/userdevinfo/userdevinfo1.asp');
	Form.submit();
}

function OnIpFilter()
{
	if (true == IsSelectMulBox())
	{
		AlertEx(userdevinfo_language['bbsp_selectonedev']);
		return;
	}
	var index = getSelectIndex();
	if (-1 == index)
	{
		AlertEx(userdevinfo_language['bbsp_selectdevice']);
		return;
	}
	ipaddress = UserDevices[index].IpAddr;
	
	var MainName = userdevinfo_language['bbsp_ipincoming_main_item'];
	var SubItemName = userdevinfo_language['bbsp_ipincoming_sub_item'];

	if(curCfgModeWord.toUpperCase() == "PTVDF2")
	{
		var url = '../../../html/bbsp/ipincoming/ipincoming.asp?' + ipaddress;
		window.parent.onMenuChange1("ipincoming",url);
		return;
	}

	var hpa = GetHpa(MainName);
	var zpa = GetZpa(MainName, SubItemName);

	if(hpa != -1 && zpa != -1)
	{
		top.Frame.showjump(hpa, zpa);
	}
	else
	{
		if(curUserType == sysUserType)
		{
			if(1 == PccwFlag)
			{
				top.Frame.showjump(5,0);
			}
			else
			{
				if (bin4board_nonvoice() == true)
				{
					top.Frame.showjump(5,1);
				}
				else
				{
					top.Frame.showjump(6,1);
				}
			}
		}
		else
		{
			if(1 == PccwFlag)
			{
				top.Frame.showjump(4,0);
			}
			else
			{
				top.Frame.showjump(4,1);
			}
		}
	}
	window.location='../../../html/bbsp/ipincoming/ipincoming.asp?' + ipaddress;
}

function OnMacFilter()
{
	if (true == IsSelectMulBox())
	{
		AlertEx(userdevinfo_language['bbsp_selectonedev']);
		return;
	}
	var index = getSelectIndex();
	if (-1 == index)
	{
		AlertEx(userdevinfo_language['bbsp_selectdevice']);
		return;
	}
	macaddress = UserDevices[index].MacAddr;
	porttype = UserDevices[index].PortType;
	
	if ("ETH" == porttype)
	{
		var MainName = userdevinfo_language['bbsp_macfilter_main_item'];
		var SubItemName = userdevinfo_language['bbsp_macfilter_sub_item'];
		if(curCfgModeWord.toUpperCase() == "PTVDF2")
		{
			var url = '../../../html/bbsp/macfilter/macfilter.asp?' + macaddress;
			window.parent.onMenuChange1("macfilter",url);
			return;
		}

		var hpa = GetHpa(MainName);
		var zpa = GetZpa(MainName, SubItemName);

		if(hpa != -1 && zpa != -1)
		{
			top.Frame.showjump(hpa, zpa);
		}
		else
		{
			if(curUserType == sysUserType)
			{
				if(1 == PccwFlag)
				{
					top.Frame.showjump(5,1);
				}
				else
				{
					if (bin4board_nonvoice() == true)
					{
						top.Frame.showjump(5,2);
					}
					else
					{
						top.Frame.showjump(6,2);
					}
				}
			}
			else
			{
				if(1 == PccwFlag)
				{
					top.Frame.showjump(4,1);
				}else if(curCfgModeWord.toUpperCase() == "RDSGATEWAY"){
				    top.Frame.showjump(4,0);
				}
				else
				{
					top.Frame.showjump(4,2);
				}
			}
		}
		window.location='../../../html/bbsp/macfilter/macfilter.asp?' + macaddress;
	}
	else
	{
		var MainName = userdevinfo_language['bbsp_wlanmacfil_main_item'];
		var SubItemName = userdevinfo_language['bbsp_wlanmacfil_sub_item'];

		if(curCfgModeWord.toUpperCase() == "PTVDF2")
		{
			var url = '../../../html/bbsp/wlanmacfilter/wlanmacfilter.asp?' + macaddress + '?' + portid;
			window.parent.onMenuChange1("wlanmacfilter",url);
			return;
		}
		
		var hpa = GetHpa(MainName);
		var zpa = GetZpa(MainName, SubItemName);

		if(hpa != -1 && zpa != -1)
		{
			top.Frame.showjump(hpa, zpa);
		}
		else
		{
			if(curUserType == sysUserType)
			{
				if(1 == PccwFlag)
				{
					top.Frame.showjump(5,2);
				}
				else
				{
					if (bin4board_nonvoice() == true)
					{
						top.Frame.showjump(5,3);
					}
					else
					{
						top.Frame.showjump(6,3);
					}
				}
			}
			else
			{
				if((1 == PccwFlag)||(curCfgModeWord.toUpperCase() == "RDSGATEWAY"))
				{
					top.Frame.showjump(4,1);
				}
				else
				{
					top.Frame.showjump(4,2);
				}
			}
		}
		window.location='../../../html/bbsp/wlanmacfilter/wlanmacfilter.asp?' + macaddress + '?' + portid;
	}
}

function OnPortMapping()
{
	if (true == IsSelectMulBox())
	{
		AlertEx(userdevinfo_language['bbsp_selectonedev']);
		return;
	}
	var index = getSelectIndex();
	if (-1 == index)
	{
		AlertEx(userdevinfo_language['bbsp_selectdevice']);
		return;
	}
	ipaddress = UserDevices[index].IpAddr;
	
	var MainName = userdevinfo_language['bbsp_portmapping_main_item'];
	var SubItemName = userdevinfo_language['bbsp_portmapping_sub_item'];

	if(curCfgModeWord.toUpperCase() == "PTVDF2")
	{
		var url = '../../../html/bbsp/portmapping/portmapping.asp?' + ipaddress;
		window.parent.onMenuChange1("portmapping",url);
		return;
	}
	
	var hpa = GetHpa(MainName);
	var zpa = GetZpa(MainName, SubItemName);

	if(hpa != -1 && zpa != -1)
	{
		top.Frame.showjump(hpa, zpa);
	}
	else
	{
		if(curUserType == sysUserType)
		{
			if(1 == PccwFlag)
			{
				top.Frame.showjump(3,1);
			}
			else
			{
				if (bin4board_nonvoice() == true)
				{
					top.Frame.showjump(3,1);
				}
				else
				{
					top.Frame.showjump(4,1);
				}
			}
		}
		else
		{
			if(curCfgModeWord.toUpperCase() == "RDSGATEWAY")
			{
				top.Frame.showjump(3,0);
			}
			else
			{
				top.Frame.showjump(3,1);
			}
		}
	}
	window.location='../../../html/bbsp/portmapping/portmapping.asp?' + ipaddress;
}

function OnReserveIp()
{
	if (true == IsSelectMulBox())
	{
		AlertEx(userdevinfo_language['bbsp_selectonedev']);
		return;
	}
	var index = getSelectIndex();
	if (-1 == index)
	{
		AlertEx(userdevinfo_language['bbsp_selectdevice']);
		return;
	}
	ipaddress = UserDevices[index].IpAddr;
	macaddress = UserDevices[index].MacAddr;
	
	var MainName = userdevinfo_language['bbsp_dhcp_static_main_item'];
	var SubItemName = userdevinfo_language['bbsp_dhcp_static_sub_item'];
	
	if(curCfgModeWord.toUpperCase() == "PTVDF2")
	{
		var url = '../../../html/bbsp/dhcpstatic/dhcpstatic.asp?' + ipaddress + '?' + macaddress;
		window.parent.onMenuChange1("dhcpstatic",url);
		return;
	}

	var hpa = GetHpa(MainName);
	var zpa = GetZpa(MainName, SubItemName);

	if(hpa != -1 && zpa != -1)
	{
		top.Frame.showjump(hpa, zpa);
	}
	else
	{	
		if (curUserType == sysUserType)
		{
			if (("1" == "<% HW_WEB_GetFeatureSupport(BBSP_FT_IPV6);%>") 
				&& ("1" == "<% HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>"))
			{
				top.Frame.showjump(9,3);
			}
			else if (("1" != "<% HW_WEB_GetFeatureSupport(BBSP_FT_IPV6);%>") 
					 && ("1" != "<% HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>"))
			{
				top.Frame.showjump(7,3);
			}
			else
			{
				top.Frame.showjump(8,3);
			}
		}
		else
		{
			top.Frame.showjump(6, 2);
		}
	}
	window.location = '../../../html/bbsp/dhcpstatic/dhcpstatic.asp?' + ipaddress + '?' + macaddress;
}

function SortDevByIP(devlist, num)
{
	if (num < 2)
	{
		return devlist;
	}
	
	var IpList = new Array();
	var InstList = new Array();
	var DevNewList = new Array();
	for(var i = 0; i < num; i++)
	{
		IpList[i] = devlist[i].IpAddr;
		InstList[i] = devlist[i].instid;
	}  
	
	for(var j = 0; j < num - 1; j++)   
	{
		for(var i = 0; i < num - 1 - j; i++)
		{
			var ip1 = IpAddress2DecNum(IpList[i]);
			var ip2 = IpAddress2DecNum(IpList[i+1]);
			var temp = '';
			if (ip1 > ip2)
			{
				temp = InstList[i];
				InstList[i] = InstList[i+1];
				InstList[i+1] = temp;
			}
		}   
	}
	
	for(var i = 0; i < num; i++)
	{
		for(var j = 0; j < num; j++)
		{
			if (InstList[i] == devlist[j].instid)
			{
				DevNewList.push(devlist[j]);
			}
		}
	}
	
	return DevNewList;
}

function SortUserDevice(UserDevicesInfo)
{
	if (0 == RecordCount)
	{
		return UserDevicesInfo;
	}
	
	var List1 = new Array();
	var List2 = new Array();
	var DevOnlineList = new Array();
	var DevOfflineList = new Array();
	var UserDevNewList = new Array();
	var RecordCount = UserDevicesInfo.length - 1;
	var OnlineNum = 0;
	var OfflineNum = 0;
	
	for(var i = 0; i < RecordCount; i++)   
	{
		if ('ONLINE' == UserDevicesInfo[i].DevStatus.toUpperCase())
		{
			List1.push(UserDevicesInfo[i]);
			OnlineNum++;
		}
		else
		{
			List2.push(UserDevicesInfo[i]);
			OfflineNum++;
		}
	}
	
	DevOnlineList = SortDevByIP(List1,OnlineNum);
	DevOfflineList = SortDevByIP(List2,OfflineNum);
	
	if ((0 == OnlineNum) && (0 < OfflineNum))
	{
		return DevOfflineList;
	}	
	else if ((0 == OfflineNum) && (0 < OnlineNum))
	{
		return DevOnlineList;
	}
	else
	{
		for(var i = 0; i < OnlineNum; i++)
		{
			UserDevNewList.push(DevOnlineList[i]);
		}		
		for(var j = 0; j < OfflineNum; j++)
		{
			UserDevNewList.push(DevOfflineList[j]);
		}
		return UserDevNewList;
	}
}

function getHeight(id)
{
	var item = id;
	var height;
	if (item != null)
	{
		if (item.style.display == 'none')
		{
			//item invisible
			return 0;
		}
		if (navigator.appName.indexOf("Internet Explorer") == -1)
		{
			height = item.offsetHeight;
		}
		else
		{
			height = item.scrollHeight;
		}
		if (typeof height == 'number')
		{
			return height;
		}
		return null;
	}

	return null;
}

function adjustParentHeight()
{
	var dh = getHeight(document.getElementById("divuserdevice"));
	var height = (dh > 0 ? dh : 0);
	var newHeight = '';
	
	if (appName == "Microsoft Internet Explorer")
	{
		newHeight = (height > 476) ? 476 : height;
	}
	else
	{
		newHeight = (height > 458) ? 458 : height;	
	}
	$("#divuserdevice").css("height", newHeight + "px");
}

function LoadFrame()
{

}

</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("userdevinfotitle", GetDescFormArrayById(userdevinfo_language, "bbsp_mune"), GetDescFormArrayById(userdevinfo_language, "bbsp_userdevinfo_title1"), false);
</script> 
<div class="title_spread"></div>
<div  id="divuserdevice" style="overflow-x:auto;overflow-y:auto;width:100%;height:100%;">
<table width="100%" class='tabal_bg' border="0" align="center" cellpadding="0" cellspacing="1" id='devlist'>
	<tr class="head_title">
	<td class='width_per5'></td>
	<td class='width_per15' BindText='bbsp_hostname'></td>	
	<td class='width_per10' BindText='bbsp_devtype'></td> 
	<td class="width_per15" BindText='bbsp_ip'></td> 
	<td class="width_per15" BindText='bbsp_mac'></td> 
	<td class="width_per5" BindText='bbsp_devstate'></td> 
	<td class="width_per5" BindText='bbsp_interface'></td> 
	<td class="width_per20" BindText='bbsp_onlinetime'></td> 
	<td class="width_per10" BindText='bbsp_leasetime'></td> 
	</tr> 
</table>
<div style="height:10px;"></div>
</div>

<div id="AppBtnList" style="display:none;"> 
	<div style="height:10px;"></div>
    <table cellpadding="0" cellspacing="0"  width="100%" class="width_per100"> 
		<tr > 
			<td class='title_bright1' nowrap>
				<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
				<input name="detail" id="detail" class="ApplyButtoncss buttonwidth_70px padstyle" type="button" onClick="OnDetial();" BindText="bbsp_detinfo"/> 
				<input name="delete" id="delete" class="ApplyButtoncss buttonwidth_70px padstyle" type="button" onClick="OnDelete();" BindText="bbsp_delete"/> 
				<input name="ipfilter" id="ipfilter"  class="ApplyButtoncss buttonwidth_99px padstyle" type="button" onClick="OnIpFilter();" BindText="bbsp_ipfilt"/> 
				<input name="macfilter"  id="macfilter" class="ApplyButtoncss buttonwidth_100px padstyle" type="button" onClick="OnMacFilter();" BindText="bbsp_macfilt"/> 
				<input name="portmapping"  id="portmapping" class="ApplyButtoncss buttonwidth_120px padstyle" type="button" onClick="OnPortMapping();" BindText="bbsp_poermap"/> 
				<input name="reserveip"  id="reserveip" class="ApplyButtoncss buttonwidth_99px padstyle" type="button" onClick="OnReserveIp();" BindText="bbsp_reserveip"/> 
			</td>
		</tr> 	  
    </table> 
</div>  
<div style="height:20px;"></div>
<script> 
	ParseBindTextByTagName(userdevinfo_language, "td",    1);
	ParseBindTextByTagName(userdevinfo_language, "div",   1);
	ParseBindTextByTagName(userdevinfo_language, "input", 2);
    GetLanUserInfo(function(para1, para2)
	{
		UserDevicesTemp = para2;
		UserDevices = SortUserDevice(UserDevicesTemp);	
		DHCPLeaseTimes = para1;
		showlistcontrol(UserDevices);
		setDisplay('AppBtnList',1);
		adjustParentHeight();
	});
</script> 
</body>
</html>

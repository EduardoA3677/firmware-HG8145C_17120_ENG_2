<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../../bbsp/common/topoinfo.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<title>Easy Setup</title>
<script language="JavaScript" type="text/javascript">

var url = "";
var MultiUser = 0;
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var ShowOldPwd = 0;
var sptUserName;
var sptAdminName;
var UserNum = 0;
var CurUserBuf = new Array(); 
var CurUserInst = new Array();

function GetLanguageDesc(Name)
{
    return CfgguideLgeDes[Name];
}

var PortVlanInfoFromAsp='<%HW_WEB_GetTagSvrMap();%>';

function MainDHCP(domain, DHCPServerEnable)
{
	this.domain = domain;
	this.DHCPServerEnable = DHCPServerEnable;
}

function TagSvrInfo(domain, TagServiceMappingInfo)
{
	this.domain = domain;
	this.TagServiceMappingInfo = TagServiceMappingInfo;
}

function stLayer3Enable(domain, lay3enable)
{
	this.domain = domain;
	this.lay3enable = lay3enable;
}

function stLanbindInfo(domain,lan1enable,lan2enable,lan3enable,lan4enable)
{
	this.domain = domain;
	this.lan1enable = lan1enable;
	this.lan2enable = lan2enable;
	this.lan3enable = lan3enable;
	this.lan4enable = lan4enable;
}

function stPortTagPriInfo(vlan, pri)
{
	this.vlan = vlan;
	this.pri = pri;
}

function stSvrMapInfo(vlan, pri, info)
{
	this.vlan = vlan;
	this.pri = pri;
	this.info = info;
}

var Lay3Enables = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.{i}, X_HW_L3Enable,stLayer3Enable);%>; 
var wanppplanbind = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}.X_HW_LANBIND,Lan1Enable|Lan2Enable|Lan3Enable|Lan4Enable,stLanbindInfo);%>;
var waniplanbind = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}.X_HW_LANBIND,Lan1Enable|Lan2Enable|Lan3Enable|Lan4Enable,stLanbindInfo);%>;

var MainDhcpRangeInst = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaMainDhcpPool, InternetGatewayDevice.LANDevice.1.LANHostConfigManagement,DHCPServerEnable,MainDHCP);%>;  
var MainDhcpRange = MainDhcpRangeInst[0];

var TagServiceMappingInfoInst = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_FeatureList.BBSPWebCustomization,TagServiceMappingInfo,TagSvrInfo);%>;  
var TagSvrMapInfo = ""; 
if (1 < TagServiceMappingInfoInst.length)
{
    TagSvrMapInfo = TagServiceMappingInfoInst[0];
}

var wan = GetWanList();

function isL3port(PortId)
{
	if (PortId<1 || PortId>TopoInfo.EthNum)
		return false;
		
	if (Lay3Enables[PortId-1].lay3enable == "1")
	{
		return true;
	}
	else
	{
		return false;
	}
}

function GetBindWanDomain(PortId)
{
	var WanDomain = new Array();

	if (PortId<1 || PortId>TopoInfo.EthNum)
		return "";

	for (var i=0; i<wanppplanbind.length-1; i++)
	{
		if ((PortId == "1" && wanppplanbind[i].lan1enable == "1")
			|| (PortId == "2" && wanppplanbind[i].lan2enable == "1")
			|| (PortId == "3" && wanppplanbind[i].lan3enable == "1")
			|| (PortId == "4" && wanppplanbind[i].lan4enable == "1"))
		{
			WanDomain.push(wanppplanbind[i].domain.substring(0, wanppplanbind[i].domain.length-13)) ;
		}
	}
	
	for (var i=0; i<waniplanbind.length-1; i++)
	{
		if ((PortId == "1" && waniplanbind[i].lan1enable == "1")
			|| (PortId == "2" && waniplanbind[i].lan2enable == "1")
			|| (PortId == "3" && waniplanbind[i].lan3enable == "1")
			|| (PortId == "4" && waniplanbind[i].lan4enable == "1"))
		{
			WanDomain.push(waniplanbind[i].domain.substring(0, waniplanbind[i].domain.length-13)) ;
		}
	}

	return WanDomain;
}

function GetWanVlanPrinByDomain(domain)
{
	var VlanPri = new stPortTagPriInfo("","");
	
	for (var i=0; i<wan.length; i++)
	{
		if (domain == wan[i].domain)
		{
			VlanPri.vlan = wan[i].VlanId;
			if (wan[i].PriorityPolicy == "CopyFromIPPrecedence")
			{
				VlanPri.pri = "";
			}
			else
			{
				VlanPri.pri = wan[i].Priority;				
			}
		}
	}
	
	return VlanPri;
}

function ParseXmlInfo()
{
	var XmlSvrInfo = TagSvrMapInfo.TagServiceMappingInfo.split(';');
	var SvrMapInfo = new Array();
	
	for (var i=0; i<XmlSvrInfo.length-1; i++)
	{
		var SvrInfo = XmlSvrInfo[i].split("#");
		if (SvrInfo.length == 3)
		{
			if (SvrInfo[0] == ""&&SvrInfo[1] != "")
			{
				SvrInfo[0] = 0;
			}
			SvrMapInfo.push( new stSvrMapInfo(SvrInfo[0], SvrInfo[1], SvrInfo[2]));
		}
		else
		{
			return "";
		}
	}

	return SvrMapInfo;
}

function GetPortOrWanTagInfo(portId)
{
	var domainInfo = new Array();
	var WanVlan = new Array();
	var portVlanInfo = new Array();
	var portVlan = new Array();
	
	if (portId<"1" || portId>TopoInfo.EthNum)
		return "";
		
	if (isL3port(portId) == true)
	{
		domainInfo = GetBindWanDomain(portId);

		if (domainInfo != "")
		{
			for (var i=0; i<domainInfo.length; i++)
			{
				WanVlan.push(GetWanVlanPrinByDomain(domainInfo[i]));
			}
		}
		else
		{
			WanVlan.push(new stPortTagPriInfo("",""));
		}
	}
	else
	{
		portVlanInfo = PortVlanInfoFromAsp.split('*');

		for (var i=0; i<portVlanInfo.length-1; i++)
		{
			portVlan = portVlanInfo[i].split('#');
			
			if (portVlan[0] == "LAN"+portId)
			{
				for (var j=1; j<portVlan.length-1; j++)
				{
					WanVlan.push(new stPortTagPriInfo(portVlan[j].split('/')[0], portVlan[j].split('/')[1]));
				}
			}
		}
	}

	return WanVlan;
}

function findInfo(finalInfo, info)
{
	for (var i=0; i<finalInfo.length; i++)
	{
		if (finalInfo[i] == info)
		{
			return "";
		}
	}
	
	return info;
}

function InitPortServiceInfo()
{
	var EthNum = TopoInfo.EthNum;
	var i;
	var xmlInfo = ParseXmlInfo();
	var find = 0;

	for (i = 1; i <= EthNum; i++)
	{
		var tagInfo = GetPortOrWanTagInfo(i);
		var ServiceInfoFinal = new Array;
		find = 0;
				
		document.write('<td>');
		if (tagInfo.length != 0)
		{
			if (tagInfo[0].vlan == "" && tagInfo[0].pri == "")
			{
				for (var k=0; k<xmlInfo.length; k++)
				{
					if (xmlInfo[k].vlan == "" && xmlInfo[k].pri == "")
					{
						if (xmlInfo[k].info != "")
						{
							ServiceInfoFinal.push(xmlInfo[k].info);
							find = 1;
						}
					}
				}
			}
			else
			{
				for (var j=0; j<tagInfo.length; j++)
				{
					for (var k=0; k<xmlInfo.length; k++)
					{
						if (tagInfo[j].vlan == xmlInfo[k].vlan && tagInfo[j].pri == xmlInfo[k].pri)
						{
							if ("" != findInfo(ServiceInfoFinal, xmlInfo[k].info))
							{
								ServiceInfoFinal.push(xmlInfo[k].info);
							}
							find = 1;
						}
					}
				}
				
				if (find == 0)
				{
					for (var j=0; j<tagInfo.length; j++)
					{
						for (var k=0; k<xmlInfo.length; k++)
						{
							if (tagInfo[j].vlan == xmlInfo[k].vlan && "" == xmlInfo[k].pri )
							{
								if ("" != findInfo(ServiceInfoFinal, xmlInfo[k].info))
								{
									ServiceInfoFinal.push(xmlInfo[k].info);
								}
								find = 1;
							}
						}
					}
				}
			}
		}
		
		if (find == 0)
		{
			document.write('<div align="center">' + 'unknown' + '</div>');
		}
		else
		{
			for (var j=0; j<ServiceInfoFinal.length; j++)
			{
				document.write('<div align="center">' + ServiceInfoFinal[j] + '</div>');
			}
		}
		
		document.write('</td>');
	}
}

function SetDhcpData()
{
	setCheck('dhcpSrvEnable', MainDhcpRange.DHCPServerEnable);
}

var PPPwanInfo = new Array();

function GetFirstPPPoEWanByType(type)
{
	for(var i=0;i<wan.length;i++)
	{
		if ((wan[i].ServiceList == type) && (wan[i].EncapMode == "PPPoE")&&(wan[i].Mode == "IP_Routed"))
		{
			return wan[i];
		}
	}
	
	return "";
}

function InitServiceData()
{
	var internet = GetFirstPPPoEWanByType("INTERNET");
	var voip = GetFirstPPPoEWanByType("VOIP");

	if(internet != "")
	{
		PPPwanInfo.push(internet);
	}
	
	if(voip != "")
	{
		PPPwanInfo.push(voip);
	}
}

InitServiceData();

function replaceSpace(str)
{
	var str_encode = $('<div/>').text(str).html();
	
	if(str_encode.indexOf(" ") != -1)
	{
		str_encode = str_encode.replace(/ /g,"&nbsp;");
	}
	return str_encode;
}

function CheckInput()
{
	var i;

	for (i=0; i<PPPwanInfo.length; i++)
	{
		PPPwanInfo[i].UserName = getValue('username'+i);
		
		$('#cf_username'+i).html(replaceSpace(getValue('username'+i)));
		document.getElementById('cf_password'+i).innerHTML = "**********";
	}

	if (getCheckVal("dhcpSrvEnable")=="1")
	{
		document.getElementById('cf_dhcpSrvEnable').innerHTML = waninfo_language['bbsp_enable'];
	}
	else
	{
		document.getElementById('cf_dhcpSrvEnable').innerHTML = waninfo_language['bbsp_disable'];
	}
	
	return true;
}

function DrawWanMenu(step)
{
	if (step != "config" && step != "confirm")
	{
		return false;
	}
	
	for (var i=0; i<PPPwanInfo.length; i++)
	{
		document.write('<table width="100%" border="0" cellspacing="1" cellpadding="0" class="tabal_bg">');
		document.write('<tr class="head_title">');
		if (PPPwanInfo[i].ServiceList == "INTERNET")
		{
			document.write('<td class="align_left" colspan="2" width="100%">Internet WAN: PPPoE</td>');
		}
		else if (PPPwanInfo[i].ServiceList == "VOIP")
		{
			document.write('<td class="align_left" colspan="2" width="100%">VoIP WAN: PPPoE</td>');
		}
		document.write('</tr>');

		document.write('<tr>');

		document.write('<td class="table_title width_per25" >' +Languages['IPv4UserName'] +'</td>');
		if (step == "config")
		{
			document.write('<td class=\"table_right width_per75\">'+ '<input name=\"username' + i + '\" type=\"TextBox\" maxLength=\"63\" id=\"username' + i + '\" size=\"15\" value=\"' + PPPwanInfo[i].UserName + '\">'+'</td>' );
		}
		else if (step == "confirm")
		{
			document.write('<td class="table_right width_per75" id="cf_username'+i+'"></td>');
		}
		
		document.write('</tr>');
		document.write('<tr>');
		document.write('<td class="table_title width_per25" >' +Languages['IPv4Password'] +'</td>');
		if (step == "config")
		{
			document.write('<td class=\"table_right_pwd  width_per75\">' + '<input name=\"password'+i +'\" type=\"password\" maxLength=\"63\" id=\"password' + i +'\" size=\"15\" value=\"' + PPPwanInfo[i].Password+'\">'+'</td>');
		}
		else if (step == "confirm")
		{
			document.write('<td class="table_right  width_per75" id="cf_password'+i+'"></td>');
		}
		document.write('</tr>');

		document.write('</table>');
	}
}

function SubmitWanMenu(Form)
{
	var i=0;

	for (i=0; i<PPPwanInfo.length; i++)
	{
		Form.addParameter('y'+i+'.Username', getValue('username'+i));
		
		if(PPPwanInfo[i].Password != getValue('password'+i) )
		{
			Form.addParameter('y'+i+'.Password', getValue('password'+i));
		}
	}
}

function Reboot()
{
	if(ConfirmEx(GetLanguageDesc("s0601"))) 
	{
		setDisable('btnReboot',1);
		
		var Form = new webSubmitForm();
				
		Form.setAction('set.cgi?x=' + 'InternetGatewayDevice.X_HW_DEBUG.SMP.DM.ResetBoard'
								+ '&RequestFile=html/ssmp/reset/reset.asp');
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));						
		Form.submit();
	}
}

function stModifyUserInfo(domain,UserName,UserLevel,Enable)
{
    this.domain = domain;
 	this.UserName = UserName;
    this.UserLevel = UserLevel;
    this.Enable = Enable;
}

var stModifyUserInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.{i}, UserName|UserLevel|Enable, stModifyUserInfo);%>;  

for (var i = 0; i < stModifyUserInfos.length - 1; i++)
{
	if (stModifyUserInfos[i].UserLevel == 0)
	{
		sptAdminName = stModifyUserInfos[i].UserName;
	}
	
	if (stModifyUserInfos[i].Enable == 1) 	
	{
		if (0 == UserNum) 
		{
			if (stModifyUserInfos[i].UserLevel == 0)
			{
				ShowOldPwd = 1;
			}
			
			sptUserName = stModifyUserInfos[i].UserName;
		}
		
		CurUserInst[UserNum] = i;
		UserNum++;
	}
}

if (1 < UserNum)
{
	MultiUser = 1;
}

function setWebUserOption()
{
	var j = 0;
    if (stModifyUserInfos != 'null')
	{
		for (i = 0; i < stModifyUserInfos.length - 1; i++)
		{
			if (stModifyUserInfos[i].Enable == 1) 
			{
				document.write('<option value=' + (j+1) + '>' + stModifyUserInfos[i].UserName + '</option>');
				CurUserBuf[j] = stModifyUserInfos[i].UserName; 
				j++;
			}	
		}
		return true;
	}
	else
	{
	    return false;
	}
}

function CheckPwdIsComplex(str)
{
	var i = 0;
	if ( 6 > str.length )
	{
		return false;
	}
	
	if (!CompareString(str, sptUserName) )
	{
		return false;
	}
	
	if ( isLowercaseInString(str) )
	{
		i++;
	}
	
	if ( isUppercaseInString(str) )
	{
		i++;
	}
	
	if ( isDigitInString(str) )
	{
		i++;
	}
	
	if ( isSpecialCharacterNoSpace(str) )
	{
		i++;
	}
	if ( i >= 2 )
	{
		return true;
	}
	return false;
}

function ShowOldArea(pwdlevel)
{
	if (pwdlevel == 0)
	{	
		return;
	}
	
	sptUserName = CurUserBuf[pwdlevel - 1];
	if (sptAdminName == sptUserName)
	{
		ShowOldPwd = 1;
		document.getElementById('TroldPassword').style.display  = ""; 
	}
	else
	{
		ShowOldPwd = 0;
		document.getElementById('TroldPassword').style.display  = "none"; 
	}
	CancelValue();
}

function CheckPasswd()
{
    var newPassword = document.getElementById("newPassword");
    var cfmPassword = document.getElementById("cfmPassword");
	var oldPassword = document.getElementById("oldPassword");

	if(oldPassword.value == '' && newPassword.value == '' && cfmPassword.value == '')
	{
		document.getElementById('ispwdChange').innerHTML = "No";
		return true;
	}
	
	if (1 == ShowOldPwd)
	{	
		if (oldPassword.value == "")
		{	
			AlertEx(GetLanguageDesc("s0f0f")); 
			return false;
		}
	}
	
	var NormalPwdInfo = FormatUrlEncode(oldPassword.value);
    var CheckResult = 0;

	$.ajax({
	type : "POST",
	async : false,
	cache : false,
	url : "../common/CheckAdminPwd.asp?&1=1",
	data :'NormalPwdInfo='+NormalPwdInfo, 
	success : function(data) {
		CheckResult=data;
		}
	});

	if (CheckResult != 1)
	{
		AlertEx(GetLanguageDesc("s0f11"));
		return false;
	}
	
	if (newPassword.value == "")
	{
		AlertEx(GetLanguageDesc("s0f02"));
		return false;
	}
	
	if (newPassword.value.length > 127)
	{
		AlertEx(GetLanguageDesc("s1904"));
		return false;
	}

	if (isValidAscii(newPassword.value) != '')
	{
		AlertEx(GetLanguageDesc("s0f04"));
		return false;
	}
	
	if (cfmPassword.value != newPassword.value)
	{
		AlertEx(GetLanguageDesc("s0f06"));
		return false;
	}
	
	if(!CheckPwdIsComplex(newPassword.value))
	{
		AlertEx(GetLanguageDesc("s1902"));
		return false;
	}
	document.getElementById('ispwdChange').innerHTML = "Yes";
	return true;
}

function SubmitPwd(Form)
{
	var InstNo = 1;
	
	if (1 == MultiUser)	
	{
		InstNo = getValue('WebUserList');
	}
	
	InstNo = CurUserInst[InstNo - 1];
	if (1 == ShowOldPwd)			
	{
	    Form.addParameter('x.OldPassword', getValue('oldPassword'));	
	}	
    Form.addParameter('x.Password', getValue('newPassword'));	
	
    url +="&x="  + stModifyUserInfos[InstNo].domain;
}

function stWlan(domain,ssid)
{
    this.domain = domain;
    this.ssid = ssid;
}

function stPsk(domain,psk)
{
    this.domain = domain;
    this.psk = psk;
}

var WlanArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},SSID, stWlan);%>;
var PskArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.PreSharedKey.1,PreSharedKey, stPsk);%>;

function CheckPsk(value)
{
	if (value == '')
	{
		AlertEx("The Wi-Fi Password cannot be empty.");
		return false;
	}

	if (isValidWPAPskKey(value) == false)
	{
		AlertEx("The Wi-Fi Password must be between 8 and 63 ASCII characters or 64 hexadecimal characters.");
		return false;
	}

	if (isValidStr(value) != '')
	{
		AlertEx("The Wi-Fi Password" + " "+ value + cfg_wlancfgother_language['amp_wlanstr_invalid'] + " " + isValidStr(value));
		return false;
	}

	return true;
}

function WlanAddFormPara(Form)
{
    Form.addParameter('p.SSID', ltrim(getValue('Wizard_text02_text')));
	Form.addParameter('p.BeaconType','11i');
    Form.addParameter('p.IEEE11iAuthenticationMode','PSKAuthentication');
    Form.addParameter('p.IEEE11iEncryptionModes','AESEncryption');

	Form.addParameter('q.PreSharedKey', getValue('Wizard_password02_password'));
}

function WlanNext()
{
    var ssid = ltrim(getValue('Wizard_text02_text'));
    var psk  = getValue('Wizard_password02_password');

	if (false == CheckSsid(ssid))
	{
		return false;
	}

	if (false == CheckPsk(psk))
	{
		return false;
	}

    if (false == CheckSsidExist(ssid, WlanArr))
	{
		return false;
	}

	return true;
}

function CancelValue()
{
    setText('newPassword','');
    setText('cfmPassword','');
	setText('oldPassword','');
}

function HideAll()
{
	setDisplay('id_confirm', 0);
	setDisplay('id_config', 0);
}

function LoadFrame()
{

	HideAll();
	setDisplay('id_config', 1);

    if(IsWlanAvailable())
	{
		setDisplay('wizard2',1);
        setText('Wizard_text02_text', WlanArr[0].ssid);
        setText('Wizard_password02_password', PskArr[0].psk);
	}

	SetDhcpData();
}

function CheckFormStep()
{
    if(!WlanNext())
	{
		return false;
	}

	if ((!CheckPasswd()) || (!CheckInput()))
	{
		return false;
	}

	return true;
}

function OnNextStep()
{
	if(false == CheckFormStep())
	{
		return false;
	}

	HideAll();
	setDisplay('id_confirm',1);

    if (true == IsWlanAvailable())
	{
		setDisplay('wlaninfo', 1);
		$('#wlan_ssid').text(getValue('Wizard_text02_text'));
        document.getElementById('wlan_psk').innerHTML= GetSSIDStringContent(getValue('Wizard_password02_password'),64);
	}
}

function OnBackStep()
{
	HideAll();
    setDisplay('id_config',1);
}

function OnfinishStep()
{	
    var Form = new webSubmitForm();
	SubmitWanMenu(Form);
		
	setDisable('BackStep', 1);
	setDisable('FinishStep', 1);

    url = 'set.cgi?';

    if ((true == IsWlanAvailable()) && (null != WlanArr))
	{
		WlanAddFormPara(Form);
		url += '&p=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1' + '&q=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.PreSharedKey.1';
	}

	if("Yes" == document.getElementById('ispwdChange').innerHTML)
	{
		SubmitPwd(Form);
	}
	
	for (var j=0; j<PPPwanInfo.length; j++)
	{
		url += '&y'+j+'='+PPPwanInfo[j].domain;
	}
	
	if (getCheckVal("dhcpSrvEnable")==0)
	{
		Form.addParameter('n.DHCPEnable', 0);
		Form.addParameter('z.DHCPServerEnable',getCheckVal("dhcpSrvEnable"));
		url += '&n=InternetGatewayDevice.X_HW_DHCPSLVSERVER&z=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement';
	}
	else 
	{
		Form.addParameter('z.DHCPServerEnable',getCheckVal("dhcpSrvEnable"));
		url += '&z=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement';
	}
	
	
    url += '&RequestFile=html/ssmp/cfgguide/setup.asp';
	Form.setAction(url);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
}

function confirmresult()
{
	if( ( window.location.href.indexOf("set.cgi?") > 0) )
	{
		AlertEx(GetLanguageDesc("s030e"));
	}
	clearInterval(TimerHandle);	    
}

var TimerHandle = setInterval("confirmresult()", 50);
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();">
<br>
<div id="id_config">

<script language="JavaScript" type="text/javascript">
	DrawWanMenu("config");
</script> 
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"> 
<tr class="head_title"> 
    <td class='align_left' colspan="2">Lan configuration</td> 
</tr> 
<tr> 
<script language="JavaScript" type="text/javascript">
	document.write('<td class="table_title width_per25">' +Languages['EnableLanDhcp'] +'</td>');		
</script> 	
	<td  class="table_right width_per75"> <input type='checkbox' value=0 id='dhcpSrvEnable' name='dhcpSrvEnable'> </td> 
</tr> 
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="1"  class="tabal_bg">  
<tr  class="head_title">
<td  style="display:none" id = "LanId1" width="25%">LAN1</td> 
<td style="display:none"  id = "LanId2" width="25%">LAN2</td> 
<td style="display:none"  id = "LanId3" width="25%">LAN3</td> 
<td  style="display:none" id = "LanId4" width="25%">LAN4</td> 
 </tr>
<tr  class="head_title">
<td id="headerLogoImg1" style="background: url(../../../images/rj45.jpg) no-repeat center; height: 50px; width: 20px; display:none; background-color:rgb(230, 230, 230)"></td>
<td id="headerLogoImg2" style="background: url(../../../images/rj45.jpg) no-repeat center; height: 50px; width: 20px; display:none; background-color:rgb(230, 230, 230);"></td>
<td id="headerLogoImg3" style="background: url(../../../images/rj45.jpg) no-repeat center; height: 50px; width: 20px; display:none; background-color:rgb(230, 230, 230)"></td>
<td id="headerLogoImg4" style="background: url(../../../images/rj45.jpg) no-repeat center; height: 50px; width: 20px; display:none; background-color:rgb(230, 230, 230)"></td>
</tr> 
<script>
      var EthNum = TopoInfo.EthNum;
      var i;
      for (i = 1; i <= EthNum; i++)
      {
            setDisplay("LanId"+i, 1);
			setDisplay("headerLogoImg"+i, 1);
      }
</script>
<tr  class="table_title">

<script>
InitPortServiceInfo();

</script>
 </tr>
 
 

</table>

<div id="wizard2">
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="tabal_bg">
    <tr class="head_title">
        <td class='align_left' colspan="2">Wireless setting</td>
    </tr>
	<tr>
		<td class="table_title"  width="25%">SSID name</td>
		<td class="table_right" width="75%">
		<input type="text" name="Wizard_text02_text" id="Wizard_text02_text" size="15" maxlength="32">
			<span class="gray"><script>document.write(cfg_wlancfgdetail_language['amp_linkname_note']);</script></span>
		</td>
	</tr>
	<tr>
		<td class="table_title"  width="25%">Password</td>
		<td class="table_right" width="75%">
		<input type='password' id='Wizard_password02_password' name='Wizard_password02_password' size="15" maxlength='64'>
			<span class="gray"><script>document.write(cfg_wlancfgdetail_language['amp_wpa_psknote']);</script></span>
		</td>
	</tr>
</table>
</div>

<table width="100%" border="0" cellspacing="1" cellpadding="0" class="tabal_bg">
<tr class="head_title"> 
<td class='align_left' colspan="3">Modify administrator password</td>
</tr>
<tr>
  <td class="table_title width_per25" BindText="s0f08"></td>
   	<script language="JavaScript" type="text/javascript">
	if (1 == MultiUser)	
	{
		document.write('<td class="table_right">'); 
		document.write('<select id="WebUserList" name="WebUserList" onchange="ShowOldArea(this.value)">'); 
		setWebUserOption();
		document.write('</select>'); 
		document.write('</td>');
	}
	else
	{
		document.write('<td class="table_right">');
		document.write(sptUserName);
		document.write('</td>');
	}
	</script>
	<td class="tabal_pwd_notice" rowspan="4" id="PwdNotice" BindText="s1116a"></td>	
</tr>

<tr name="TroldPassword" id="TroldPassword" style="display:none"> 
  <td class="table_title width_per25" BindText="s0f13"></td>
  <td class="table_right"><input name='oldPassword' type="password" id="oldPassword" size="15"></td>
    <script language="JavaScript" type="text/javascript">
	if (1 == ShowOldPwd)
	{
		document.getElementById('TroldPassword').style.display  = ""; 
	}	
	</script> 
</tr> 
<tr> 
  <td class="table_title width_per25" BindText="s0f09"></td>
  <td class="table_right"><input name='newPassword' type="password" id="newPassword" size="15"></td> 
</tr>
<tr> 
  <td class="table_title width_per25" BindText="s0f0b"></td>
  <td class="table_right"><input name='cfmPassword' type='password' id="cfmPassword" size="15"></td>
</tr>
  
  
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button" id="wizard1_table2"> 
  <tr><td class="table_submit width_per25" align="right"></td>
	<td class="table_submit">
	<input class="submit" id="config" type="button" onClick="OnNextStep();"  value="Next" style="width:70px;"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input  class="submit" name="btnReboot" id="btnReboot" type='button' onClick='Reboot()' value="RESET" style="width:70px;">
	</td>
  </tr>         
</table>
</div>
<div class="func_spread"></div>
<div id="id_confirm" style="display:none"> 
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="tabal_head">
<tr><td class="align_left" width="100%"><label id="Title_wizard3_lable">Confirm configuration</label></td></tr>
</table>

<script language="JavaScript" type="text/javascript">
DrawWanMenu("confirm");
</script> 
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"> 
<tr class="head_title"> 
    <td class='align_left' colspan="2">Lan configuration</td> 
</tr> 
<tr> 
<script language="JavaScript" type="text/javascript">
	document.write('<td class="table_title width_per25" >' +Languages['EnableLanDhcp'] +'</td>');		
</script> 	
	<td  class="table_right width_per75" id='cf_dhcpSrvEnable'></td> 
</tr> 
</table>


<div id="wlaninfo" style="display:none">
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
    <tr class="head_title">
        <td class='align_left' colspan="2">Wireless setting</td>
    </tr>
	<tr>
	    <td class="table_title" width="25%">SSID name</td>
	    <td class="table_right" width="75%" id="wlan_ssid"></td>
	</tr>
	<tr>
	    <td class="table_title" width="25%">Password</td>
	    <td class="table_right" width="75%" id="wlan_psk"></td>
	</tr>
</table>
</div>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"> 
<tr class="head_title"> 
<td class='align_left' colspan="2">Modify administrator password</td> 
</tr> 
	<tr> 
	<td class="table_title" width="25%">Modify administrator password</td>
	<td class="table_right" width="75%" id="ispwdChange"></td>
	</td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0"  class="table_button">
  <tr> 
    <td class="table_submit" width="25%"></td> 
    <td class="table_submit">
	  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	  <input  class="submit" name="BackStep" id="BackStep" type="button" onClick="OnBackStep();" value="Back" style="width:70px;"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <input  class="submit" name="FinishStep" id="FinishStep" type="button" onClick="OnfinishStep();"  value="Finish" style="width:70px;"> 
	</td> 
  </tr> 
</table> 
</div>
<script>
var all = document.getElementsByTagName("td");
for (var i = 0; i < all.length; i++)
{
    var b = all[i];
	var c = b.getAttribute("BindText");
	if(c == null)
	{
		continue;
	}
    b.innerHTML = CfgguideLgeDes[c];
}

var all = document.getElementsByTagName("input");
for (var i = 0; i < all.length; i++)
{
    var b = all[i];
	var c = b.getAttribute("BindText");
	if(c == null)
	{
		continue;
	}
    b.value = CfgguideLgeDes[c];
}
</script>

</body>
</html>

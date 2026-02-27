<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<title>Portmapping</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var enblPortList = new Array();
var fileUrl = 'html/bbsp/ipv6portmapping/portmappingsrc.asp';


function FormatPortStr(port)
{
    var portList = port.split(':');
    if ((portList.length > 1) && (parseInt(portList[1], 10) == 0))
    {
        return portList[0];
    }

    return port;
}


function stFirewallPort(domain, IPAddress, Mask, StartPort, EndPort)
{
	this.domain = domain;
	this.IPAddress = IPAddress;
	this.Mask = Mask;
	this.StartPort = StartPort;
	this.EndPort = EndPort;
	this.ppindex = domain.split('.')[3];
	this.pindex = domain.split('.')[5];
}

function stFirewallRule(domain, Enabled, Protocol, Action, PrivateFlag)
{
	this.domain = domain;
	this.Enabled = Enabled;
	this.Protocol = Protocol;
	this.Action = Action;
	this.PrivateFlag = PrivateFlag;
	this.pindex = domain.split('.')[3];
	this.index = domain.split('.')[5];
}

function stFirewall(domain, Name, Interface, Type, IPVersion)
{
	this.domain = domain;
	this.Name = Name;
	this.Interface = Interface;
	this.Type = Type;
	this.IPVersion = IPVersion;
	this.index = domain.split('.')[3];
	
	this.Enabled = GetCurrentRule(this.index).Enabled;
	this.Protocol = GetCurrentRule(this.index).Protocol;
	this.Action = GetCurrentRule(this.index).Action;
	this.PrivateFlag = GetCurrentRule(this.index).PrivateFlag;
	
	this.IPAddress = GetCurrentRulePort(GetCurrentRule(this.index)).IPAddress;
	this.Mask = GetCurrentRulePort(GetCurrentRule(this.index)).Mask;
	this.StartPort = GetCurrentRulePort(GetCurrentRule(this.index)).StartPort;
	this.EndPort = GetCurrentRulePort(GetCurrentRule(this.index)).EndPort;
	
	this.PortRange = this.StartPort + ':' + this.EndPort;
}

var TempIPv6Prefix = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_IPv6Interface.1.IPv6Prefix.1.Prefix);%>';
var Br0IPv6Prefix = TempIPv6Prefix.split('/')[0];

var PortMapping3 = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_TDE_Firewall.Firewall.{i}.Rule.1.Destination, IPAddress|Mask|StartPort|EndPort, stFirewallPort);%>;

var PortMapping2 = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_TDE_Firewall.Firewall.{i}.Rule.1, Enabled|Protocol|Action|X_HW_PrivateFlag, stFirewallRule);%>;

var PortMapping1 = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_TDE_Firewall.Firewall.{i}, Name|Interface|Type|IPVersion, stFirewall);%>;

function GetCurrentRule(index)
{
	var tmpRule = new stFirewallRule("", "", "", "", "");
	for(var i = 0; i < PortMapping2.length -1; i++)
	{
		if(PortMapping2[i].pindex == index)
		{
			tmpRule = PortMapping2[i];
			break;
		}
	}
	
	return tmpRule;
}

function GetCurrentRulePort(rule)
{
	var tmpRulePort = new stFirewallPort("", "", "", "", "");
	for(var i = 0; i < PortMapping3.length -1; i++)
	{
		if((PortMapping3[i].pindex == rule.index) && (PortMapping3[i].ppindex == rule.pindex))
		{
			tmpRulePort = PortMapping3[i];
			break;
		}
	}
	
	return tmpRulePort;
}

var PortMapping = new Array();

for(var i = 0; i < PortMapping1.length - 1; i++)
{
	if((parseInt(PortMapping1[i].PrivateFlag) & 0x01) != 1)
	{
		continue;
	}
	if(PortMapping1[i].IPVersion != "6")
	{
		continue;
	}
	
	if((PortMapping1[i].IPAddress == "") ||　(PortMapping1[i].Enabled == ""))
	{
		continue;
	}
	
	PortMapping.push(PortMapping1[i]);
}

function setPortMapEnable(id ,enabled)
{
	if(1 == enabled)
	{
		getElById(id).style.background = "url(../../../images/cus_images/btn_on.png) no-repeat";
	}
	else
	{
		getElById(id).style.background = "url(../../../images/cus_images/btn_off.png) no-repeat";
	}
}

function EnablePortMapping(id)
{
	var instId = id.split('_')[1];
	enblPortList[instId] = 1 - enblPortList[instId];
	setPortMapEnable(id, enblPortList[instId]);
}

function stPortMappingInst(domain, stName, stProtocol, stPortRange, stIPAddress, stEnabled)
{
	this.domain = domain;
	this.instId = domain.split('.')[3];
	this.stName = stName;
	this.stProtocol = stProtocol;
	this.stPortRange = stPortRange; 
	this.stIPAddress = stIPAddress;
	this.stEnabled = stEnabled;
	
	this.modifyFlag = false;
}

function PortMappingInstList(record)
{
	var instNum = record.length;
	
	this.showPortmappingList = function()
	{
		var htmlLines = '';
		var tdClass = "<td class=\"table_title align_center\"";
		
		if (instNum == 0 )
		{
			htmlLines += '<tr id="portMappingInst_record_no"' + ' class="tabal_center01" >';
			htmlLines += '<td >--</td>';
			htmlLines += '<td >--</td>';
			htmlLines += '<td >--</td>';
			htmlLines += '<td >--</td>';
			htmlLines += '<td >--</td>';
			htmlLines += '</tr>';
		}
		else
		{ 
			for(var i = 0; i < instNum; i++)
			{
				htmlLines += "<tr id=\"portMappingInst_record_" + i + "\" >";
				htmlLines += tdClass + ">" + "<input type=\"text\" id=\"portMappingInst_" + i + "_1\" " + " size=\"5\" maxlength=\"256\" style=\"width: 150px\">" +  "</td>";
				
			    htmlLines += tdClass + ">" + "<select id=\"portMappingInst_" + i + "_2\" " + " size=\"1\">"
			    htmlLines += "<option value=\"TCP\" selected>TCP</option>" + "<option value=\"UDP\">UDP</option>" + "</select></td>";

				htmlLines += tdClass + ">" + "<input type=\"text\" id=\"portMappingInst_" + i + "_3\" " + " size=\"5\" maxlength=\"11\" style=\"width: 140px\">" +  "</td>";
				
				htmlLines += tdClass + ">" + "<input type=\"text\" id=\"portMappingInst_" + i + "_4\" " + " size=\"5\" maxlength=\"255\" style=\"width: 250px\">" +  "</td>";
				
				htmlLines += "<td>" + "<div id=\"portMappingInst_" + i + "_5\" " + " class=\"tb_switch\" onclick=\"EnablePortMapping(this.id);\">" + "</div>" + "</td>";
				
				htmlLines += "<td>" + "<div id=\"portMappingInst_" + i + "_6\" " + " class=\"tb_delete\" onclick=\"DeletePortMapping(this.id);\">" + "</div>" + "</td>" + "</tr>";
			}
		}
		
		return htmlLines;
	}
	
	this.showTblListDelIco = function()
	{
		for(var inst = 0; inst < record.length; inst++)
		{
			var icoId = "portMappingInst_" + inst + "_6";
			$("#" + icoId).css({
				"display" : "block"
			});
		}
	}

	this.fillUpListTblInst = function()
	{
		for(var inst = 0; inst < instNum; inst++)
		{
			setText("portMappingInst_" + inst + "_1", record[inst].Name);
			setSelect("portMappingInst_" + inst + "_2", record[inst].Protocol);
			setText("portMappingInst_" + inst + "_3", record[inst].PortRange);
			setText("portMappingInst_" + inst + "_4", record[inst].IPAddress);
			enblPortList.push(record[inst].Enabled);
			setPortMapEnable("portMappingInst_" + inst + "_5" ,enblPortList[inst]);
		}
	}
	
	this.getCurListInst = function(instId)
	{
		var curRowData = new stPortMappingInst(record[instId].domain,
											getValue("portMappingInst_" + instId + "_1"),
											getValue("portMappingInst_" + instId + "_2"),
											getValue("portMappingInst_" + instId + "_3"),
											getValue("portMappingInst_" + instId + "_4"),
											enblPortList[instId]);
											
		return curRowData;
	}
	
	this.getAllListInst = function()
	{
		var curDataList = new Array();
		for(var inst = 0; inst < instNum; inst++)
		{
			curDataList.push(this.getCurListInst(inst));
		}
		
		return curDataList;
	}
	
}

function GetCurrentPortMapList()
{
    var curPortMappingList = new PortMappingInstList(PortMapping);
	return curPortMappingList;
}

function CheckForm(type)
{
    switch (type)
    {
       case 3:
          return CheckPortMappingCfg();
          break;
    }
	return true;
}

function portmappingDescpChk(portmappingDescrip)
{
    if (isValidName(portmappingDescrip) == false) 
    {
        AlertEx(ipv6portmapping_language['bbsp_mappinginvalid']);
        return false;
    }
    return true;
}

function portListInstIpChk(innerHostIp)
{
    if ((CheckIpv6Parameter(innerHostIp) == false))
    {
        AlertEx(ipv6portmapping_language['bbsp_hostipinvalid']);
        return false;
    }
	
	return true;
}

function portValueValidChk(portrange)
{
    var innerPort = $.trim(portrange);
	var portList = FormatPortStr(innerPort).split(':');
    var innerStartPort = portList[0];
    var innerEndPort = portList[0];
    if(portList.length > 1){
        innerEndPort = portList[1];
    }
	
	if(portList.length > 2)
	{
		AlertEx(ipv6portmapping_language['bbsp_portrangeinvalid']);
        return false;
	}
	
    if (innerStartPort == "")
    {
        AlertEx(ipv6portmapping_language['bbsp_startportisreq']);
        return false;
    }
	else if ((innerStartPort.charAt(0) == "0") || (isValidPort(innerStartPort) == false))
	{
	    AlertEx(ipv6portmapping_language['bbsp_startport'] +  innerStartPort + ipv6portmapping_language['bbsp_invalid']);
        return false;
	}
	
	if (innerEndPort == "")
    {
        AlertEx(ipv6portmapping_language['bbsp_endportisreq']);
        return false;
    }
    if ((innerEndPort != "") && ((innerEndPort.charAt(0) == "0") || (isValidPort2(innerEndPort) == false)))
    {
        AlertEx(ipv6portmapping_language['bbsp_endport'] +  innerEndPort + ipv6portmapping_language['bbsp_invalid']);
        return false;
    }
	
	if ((innerStartPort != "") && (innerEndPort != "")
		&& (parseInt(innerStartPort, 10) > parseInt(innerEndPort, 10)))
	{
		AlertEx(ipv6portmapping_language['bbsp_startportleqendport']);
		return false;     	
	}	
	
	return true;
}

function CheckPortMappingCfg()
{
	var MAX_INST_NUM = (getValue('PMProtocol') == "TCP/UDP") ? '31' : '32';
	
	if(PortMapping1.length >= parseInt(MAX_INST_NUM))
	{
		AlertEx(ipv6portmapping_language['bbsp_mappingfulltde']);
		return false;
	}
	
	if (true != portmappingDescpChk(getValue("PMDescription")))
	{
	    return false;
	}

	if (true != portListInstIpChk(getValue("PMIPv6Address")))
	{
	    return false;
	}
	
	if (true != portValueValidChk(getValue("PMInnerPort")))
	{
        return false;
    }
	
	return true;
}

function AddFirstParam(stDescription, stIpAdress, stStartPort, stEndPort)
{
	var Onttoken = getValue('onttoken');
	
	$.ajax({
	type : "POST",
	async : false,
	cache : false,
	data : 'GROUP_a_x.Name='+ stDescription + '&GROUP_a_x.Interface=WAN'+ '&GROUP_a_x.Type=In' + '&GROUP_a_x.IPVersion=6' + '&GROUP_a_y.Enabled=1'  + '&GROUP_a_y.Protocol=TCP' + '&GROUP_a_y.Action=Permit'
		  + '&GROUP_a_y.X_HW_PrivateFlag=1' + '&GROUP_a_m.IPAddress=' + stIpAdress + '&GROUP_a_m.StartPort=' + stStartPort + '&GROUP_a_m.EndPort=' + stEndPort + '&x.X_HW_Token=' + Onttoken,
	url :  'addcfg.cgi?GROUP_a_x=InternetGatewayDevice.X_HW_TDE_Firewall.Firewall' + '&GROUP_a_y=GROUP_a_x.Rule' + '&GROUP_a_m=GROUP_a_y.Destination'
		   + '&RequestFile=html/ipv6/not_find_file.asp',
	error:function(XMLHttpRequest, textStatus, errorThrown) 
	{
		if(XMLHttpRequest.status == 404)
		{
		}
	}
	});
}

function AddSubmitParam(SubmitForm,type)
{
	setDisable('btnApply',1);
	
	var url;
	var RulePrefix = "GROUP_a_y";
	
	var stProtocol = getValue('PMProtocol');
	var stDescription = getValue('PMDescription');
	var stIpAdress = getValue('PMIPv6Address');
	var stInterPort = getValue('PMInnerPort');
	
	var portList = FormatPortStr(stInterPort).split(':');
    var stStartPort = portList[0];
    var stEndPort = portList[0];
    if(portList.length > 1){
        stEndPort = portList[1];
    }
	
	switch(stProtocol)
	{
		case "TCP":
		case "UDP":
			break;
		case "TCP/UDP":
			stProtocol = "UDP";
			AddFirstParam(stDescription, stIpAdress, stStartPort, stEndPort);
		default:
			break;
	}
	
    SubmitForm.addParameter('GROUP_a_x.Name', stDescription);
    SubmitForm.addParameter('GROUP_a_x.Interface', "WAN");
	SubmitForm.addParameter('GROUP_a_x.Type', 'In');
	SubmitForm.addParameter('GROUP_a_x.IPVersion', '6');
	
	SubmitForm.addParameter(RulePrefix +'.Enabled', '1');
	SubmitForm.addParameter(RulePrefix +'.Protocol', stProtocol);
	SubmitForm.addParameter(RulePrefix +'.Action', 'Permit');
	SubmitForm.addParameter(RulePrefix +'.X_HW_PrivateFlag', '1');
	
	SubmitForm.addParameter('GROUP_a_m.IPAddress', stIpAdress);
	SubmitForm.addParameter('GROUP_a_m.StartPort', stStartPort);
	SubmitForm.addParameter('GROUP_a_m.EndPort', stEndPort);


	url = "addcfg.cgi?GROUP_a_x=InternetGatewayDevice.X_HW_TDE_Firewall.Firewall" + "&GROUP_a_y=GROUP_a_x.Rule" +"&GROUP_a_m=GROUP_a_y.Destination" + '&RequestFile=' + fileUrl;
	
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	SubmitForm.setAction(url);
    	
}

function DeletePortMapping(id)
{
	var instId = id.split('_')[1];
	var SubmitForm = new webSubmitForm();
	SubmitForm.addParameter(PortMapping[instId].domain,'');
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	SubmitForm.setAction('del.cgi?RequestFile=' + fileUrl);
	SubmitForm.submit();
}

function DeletePortMappingList()
{
	if(PortMapping.length == 0)return;
	
	var SubmitForm = new webSubmitForm();
	for(var i = 0; i < PortMapping.length; i++)
	{
		SubmitForm.addParameter(PortMapping[i].domain,'');
	}
	
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	SubmitForm.setAction('del.cgi?RequestFile=' + fileUrl);
	SubmitForm.submit();
}

function GetModifiedPmList()
{
	var modifyPmList = GetCurrentPortMapList().getAllListInst();
	
	for(var i = 0; i < modifyPmList.length; i++)
	{
		if(modifyPmList[i].stProtocol != oldPmList[i].stProtocol)
		{
			modifyPmList[i].modifyFlag = true;
			continue;
		}
		if(modifyPmList[i].stPortRange != oldPmList[i].stPortRange)
		{
			modifyPmList[i].modifyFlag = true;
			continue;
		}
		if(modifyPmList[i].stName != oldPmList[i].stName)
		{
			modifyPmList[i].modifyFlag = true;
			continue;
		}
		if(modifyPmList[i].stIPAddress != oldPmList[i].stIPAddress)
		{
			modifyPmList[i].modifyFlag = true;
			continue;
		}
		if(modifyPmList[i].stEnabled != oldPmList[i].stEnabled)
		{
			modifyPmList[i].modifyFlag = true;
			continue;
		}
	}

	return modifyPmList;
}

function GetChangedPmList()
{
	var newPmList = new Array();
	var tmpPmList = GetModifiedPmList();

	for(var i = 0; i < tmpPmList.length; i++)
	{
		if(tmpPmList[i].modifyFlag == true)
		{
			newPmList.push(tmpPmList[i]);
		}
	}

	if(newPmList.length == 0)
	{
		newPmList.push(tmpPmList[0]);
	}

	return newPmList;
}

function CheckPortMappingModify(instList)
{
	for(var i = 0; i < instList.length; i++)
	{
		if (true != portmappingDescpChk(instList[i].stName))
		{
			return false;
		}
		if (true != portListInstIpChk(instList[i].stIPAddress))
		{
			return false;
		}
		if (true != portValueValidChk(instList[i].stPortRange))
		{
			return false;
		}
	}
	
	return true;
}

function GetRowIndexByDomain(_domain)
{
	var rowIndex = 0;
	for(var i = 0; i < PortMapping.length; i++)
	{
		if(_domain == PortMapping[i].domain)
		{
			rowIndex = i;
		}
	}
	
	return rowIndex;
}

function ModifyPortMappingList()
{
	var prefixList = new Array('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');
	var needModifyList = GetChangedPmList();
	
	if(true != CheckPortMappingModify(needModifyList))
	{
		return false;
	}
	
	setDisable('btnModify',1);
	setDisable('btnDelete',1);
	
	var instPrefix;
	var rulePrefix;
	var destPrefix;
	var SubmitForm = new webSubmitForm();
	var url = 'complex.cgi?';
	for(var i = 0; i < needModifyList.length; i++)
	{
		instPrefix = prefixList[i];
		rulePrefix = 'm' + prefixList[i];
		destPrefix = 'n' + prefixList[i];
		
		var pref1 = (i == 0) ? instPrefix : ('&' + instPrefix);
		var pref2 = rulePrefix + '=' + needModifyList[i].domain  + '.Rule.1';
		var pref3 = destPrefix + '=' + needModifyList[i].domain  + '.Rule.1.Destination';
		var rowindex = GetRowIndexByDomain(needModifyList[i].domain);
	
		url += pref1 + '=' + needModifyList[i].domain + '&' + pref2 + '&' + pref3;
		
		SubmitForm.addParameter(instPrefix+'.Name', getValue("portMappingInst_" + rowindex + "_1"));
		SubmitForm.addParameter(rulePrefix+'.Enabled', enblPortList[rowindex]);
		SubmitForm.addParameter(rulePrefix+'.Protocol', getValue("portMappingInst_" + rowindex + "_2"));
		
		SubmitForm.addParameter(destPrefix+'.IPAddress', getValue("portMappingInst_" + rowindex + "_4"));

		var portList = FormatPortStr(getValue("portMappingInst_" + rowindex + "_3")).split(':');
		var stStartPort = portList[0];
		var stEndPort = portList[0];
		if(portList.length > 1){
			stEndPort = portList[1];
		}
		SubmitForm.addParameter(destPrefix+'.StartPort', stStartPort);
		SubmitForm.addParameter(destPrefix+'.EndPort', stEndPort)
	}
	
	url +=  '&RequestFile=' + fileUrl;
	
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	SubmitForm.setAction(url);
	SubmitForm.submit();
	
}

function JumpToModify()
{
	if(PortMapping.length == 0)return;
	
	setDisplay('btnEditRow', 0);
	setDisplay('btnModifyRow', 1);
	GetCurrentPortMapList().showTblListDelIco();
	
}

function getHeight(id)
{
	var item = id;
	var height;
	if (item != null)
	{
		if (item.style.display == 'none')
		{
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
	var dh = getHeight(document.getElementById("DivContent"));
	var height = dh > 0 ? dh : 0;
	window.parent.adjustParentHeight("PortmappingWarpContent", height+10);
}

function LoadFrame()
{
	if(PortMapping.length == 0)
	{
		setDisplay('btnEditRow', 0);
	}
	else
	{
		setDisplay('btnEditRow', 1);
	}
	
	
	setText('PMIPv6Address', Br0IPv6Prefix);
	
	GetCurrentPortMapList().fillUpListTblInst();
	
	oldPmList = GetCurrentPortMapList().getAllListInst();
	
	adjustParentHeight();
	
}

var TableClass = new stTableClass("PageSumaryTitleCss table_title width_per40", "table_right", "");

</script>
<style type="text/css">
	.TextBox
	{
		width:280px;  
	}
	.Select
	{
		width:153px;  
	}
	.SelectCfg
	{
		width:153px; 
	}
	.tb_switch
	{
		height: 20px;
		width: 55px;
		background: url(../../../images/cus_images/btn_on.png) no-repeat;
	}
	.tb_delete
	{
		height: 20px;
		width: 25px;
		background: url(../../../images/cus_images/del.png) no-repeat;
		display : none;
	}
</style>
</head>
<body onLoad="LoadFrame();" class="iframebody" >
<div id="DivContent">
<div class="title_spread"></div>
<div id="FuctionPageArea" class="FuctionPageAreaCss">
<div id="FunctionPageTitle" class="FunctionPageTitleCss">
<span id="PageTitleText" class="PageTitleTextCss" BindText="bbsp_ipv6ports"></span>
</div>
<div id="PmContentitle" class="FuctionPageContentCss">
<div id="PageSumaryInfo1" class="PageSumaryInfoCss" BindText="bbsp_portmapping_title_tde"></div>
</div>
<form id="ConfigForm">
<table border="0" cellpadding="0" cellspacing="1"  width="100%">
<li   id="PMDescription"   RealType="TextBox"            DescRef="bbsp_mappingtde"       RemarkRef="Empty"   		  ErrorMsgRef="Empty"    Require="FALSE"     BindField="Empty"      InitValue="Empty"  Maxlength="256"/>
<li   id="PMIPv6Address"   RealType="TextBox"  			DescRef="bbsp_inthosttde"       RemarkRef="Empty"     	  ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"   InitValue="Empty"  MaxLength="256"/>                                                                  
<li   id="PMProtocol"      RealType="DropDownList"       DescRef="bbsp_protocolmh"      RemarkRef="Empty"          ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"  Elementclass="SelectCfg"   InitValue="[{TextRef:'TCP',Value:'TCP'},{TextRef:'UDP',Value:'UDP'},{TextRef:'TCPUDP',Value:'TCP/UDP'}]"/>
<li   id="PMInnerPort"     RealType="TextBox"            DescRef="bbsp_intportmh"       RemarkRef="bbsp_portrange"   ErrorMsgRef="Empty"    Require="FALSE"     BindField="Empty"             InitValue="Empty"/>
</table>
<script>
PortMappingCfgFormList = HWGetLiIdListByForm("ConfigForm", null);
HWParsePageControlByID("ConfigForm", TableClass, ipv6portmapping_language, null);
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0" > 
  <tr> 
	<td class="table_submit"> 
		<button name="btnApply" id="btnApply" type="button" class="BluebuttonGreenBgcss buttonwidth_100px" onClick="Submit(3);"><script>document.write(ipv6portmapping_language['bbsp_add']);</script></button>
  </tr> 
</table> 
</form>
<div style="height:20px;"></div>
<table class="tabal_noborder_bg" id="portMappingInst" width="100%" cellpadding="0" cellspacing="1" style="padding-left:10px;padding-right:10px;"> 
<tr class="head_title_tde"> 
  <td width="25%" BindText='bbsp_mappingtde1'></td> 
  <td width="10%" BindText='bbsp_protocol'></td> 
  <td width="25%" BindText='bbsp_intporttde'></td> 
  <td width="30%" BindText='bbsp_inthosttde1'></td> 
  <td width="10%" colspan="2" BindText='bbsp_enabletde'></td> 
</tr> 
<script language="JavaScript" type="text/javascript">
document.write(GetCurrentPortMapList().showPortmappingList());
</script> 
</table> 

<table width="100%" border="0" cellspacing="0" cellpadding="0" > 
  <tr id="btnEditRow"> 
	<td class="title_bright1"> 
	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	<a id="btnEdit" href="#" onClick="JumpToModify();" style="font-size:14px;color:#266B94;text-decoration:none;white-space:nowrap;padding-right:180px;"><script>document.write(ipv6portmapping_language['bbsp_edit']);</script></a></td> 
  </tr> 
  <tr id="btnModifyRow" style="display:none"> 
	<td class="title_bright1"> 
	<a id="btnModify" href="#" onClick="ModifyPortMappingList();" style="font-size:14px;color:#266B94;text-decoration:none;white-space:nowrap;padding-right:50px;"><script>document.write(ipv6portmapping_language['bbsp_ok']);</script></a>
	<a id="btnDelete" href="#" onClick="DeletePortMappingList();" style="font-size:14px;color:#266B94;text-decoration:none;white-space:nowrap;padding-right:100px;"><script>document.write(ipv6portmapping_language['bbsp_del_all']);</script></a></td> 
  </tr> 
</table> 
<div style="height:20px;"></div>
</div>
</div>
<div style="height:20px;"></div>
<script>
ParseBindTextByTagName(ipv6portmapping_language, "span",  1);
ParseBindTextByTagName(ipv6portmapping_language, "td",    1);
ParseBindTextByTagName(ipv6portmapping_language, "div",  1);
</script>
</body>
</html>

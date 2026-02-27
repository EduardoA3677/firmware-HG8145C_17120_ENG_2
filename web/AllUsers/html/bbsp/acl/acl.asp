<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>ACL</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="javascript" src="../common/userinfo.asp"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>

<script language="JavaScript" type="text/javascript">
var FltsecLevel = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.X_HW_FirewallLevel);%>'.toUpperCase();

var SingleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_SINGLE_WLAN);%>';
var DoubleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>';

var selctIndex = -1;
var wantelflag = '<%HW_WEB_GetRemoteTelnetAbility();%>';
var curUserType='<%HW_WEB_GetUserType();%>';

var CfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 
var TableName = "SIPWhiteListConfigList";

function wanwhitelist(domain,WANSrcWhiteListEnable,WANSrcWhiteListNumberOfEntries)
{
	this.domain = domain;
	this.WANSrcWhiteListEnable = WANSrcWhiteListEnable;
	this.WANSrcWhiteListNumberOfEntries = WANSrcWhiteListNumberOfEntries;
}

function IsOSKNormalUser()
{
	if ('OSK' == CfgModeWord.toUpperCase() && curUserType != '0')
	{
		return true;
	}
	else
	{
		return false;
	}
}

function telnetwifienable()
{   
	if(IsE8cFrame())
	{
		var enabletelnetwifi = getCheckVal('telnetlan');
		setDisplay('telnetwifiRow', enabletelnetwifi);
		setDisable('telnetwifi', !enabletelnetwifi);		
	}
}

function IsTelmexOpenAccess()
{
	return ('TELMEXACCESS' == CfgModeWord.toUpperCase())? true : false;
}

function list(domain,SrcIPPrefix)
{
	this.domain = domain;
	this.SrcIPPrefix = SrcIPPrefix;
}

var WANSrcWhiteList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_WANSrcWhiteList, InternetGatewayDevice.X_HW_Security.WANSrcWhiteList,WANSrcWhiteListEnable|WANSrcWhiteListNumberOfEntries, wanwhitelist);%>;

var WhiteList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaWhiteList, InternetGatewayDevice.X_HW_Security.WANSrcWhiteList.List.{i},SrcIPPrefix,list);%>;
function stAclInfo(domain,HttpLanEnable,HttpWanEnable,FtpLanEnable,FtpWanEnable,TelnetLanEnable,TelnetWanEnable,HTTPWifiEnable,TELNETWifiEnable, SSHLanEnable, SSHWanEnable)
{
	this.domain = domain;
	this.HttpWifiEnable = HTTPWifiEnable;
	this.TelnetWifiEnable = TELNETWifiEnable;
	this.HttpLanEnable = HttpLanEnable;
	this.HttpWanEnable = HttpWanEnable;
	this.FtpLanEnable = FtpLanEnable;
	this.FtpWanEnable = FtpWanEnable;
	this.TelnetLanEnable = TelnetLanEnable;
	this.TelnetWanEnable = TelnetWanEnable;
	this.SSHLanEnable = SSHLanEnable;
	this.SSHWanEnable = SSHWanEnable;
}

var aclinfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecAclInfos, InternetGatewayDevice.X_HW_Security.AclServices,HTTPLanEnable|HTTPWanEnable|FTPLanEnable|FTPWanEnable|TELNETLanEnable|TELNETWanEnable|HTTPWifiEnable|TELNETWifiEnable|SSHLanEnable|SSHWanEnable,stAclInfo);%>;  
var AclInfo = aclinfos[0];

function SetCtrlConfigPanel(iDisable)
{
	setDisable('httpwifi', iDisable);
	setDisable('telnetwifi', iDisable);
	setDisable('ftplan' , iDisable);
	setDisable('httplan' , iDisable);
	setDisable('telnetlan' , iDisable);
	setDisable('ftpwan' , iDisable);
	setDisable('httpwan' , iDisable);
	setDisable('telnetwan' , iDisable);
	setDisable('bttnApply' , iDisable);
	setDisable('cancelValue' , iDisable);
	setDisable('sshlan' , iDisable);
	setDisable('sshwan' , iDisable);
}

function LoadFrame()
{
         
	if (WhiteList.length > 1)
	{
		selectLine(TableName + '_record_0');
	}
	
    //with (getElement('ConfigForm'))
	{                                 

		setCheck('ftplan',AclInfo.FtpLanEnable);
		setCheck('ftpwan',AclInfo.FtpWanEnable);
		setCheck('httpwifi',AclInfo.HttpWifiEnable);
		setCheck('httplan',AclInfo.HttpLanEnable);
		setCheck('httpwan',AclInfo.HttpWanEnable);
		setCheck('telnetlan',AclInfo.TelnetLanEnable);
		setCheck('telnetwan',AclInfo.TelnetWanEnable);
		setCheck('telnetwifi',AclInfo.TelnetWifiEnable);
		setCheck('sshlan',AclInfo.SSHLanEnable);
		setCheck('sshwan',AclInfo.SSHWanEnable);
		setCheck('wanwhite',WANSrcWhiteList[0].WANSrcWhiteListEnable);
	}       
        if( AclInfo.TelnetLanEnable == 0)
	{
	    setDisable('telnetwifi' , 1);
	}   
	if(parseInt(AclInfo.HttpLanEnable,10) == 0)
	{
	    setDisable('httpwifi' , 1);  
	}

	if((FltsecLevel != 'CUSTOM')&&('CMCC_RMS' != CfgModeWord.toUpperCase()))
	{                
	    SetCtrlConfigPanel(1);
	}    
	
	if(IsTelmexOpenAccess())
	{
		SetCtrlConfigPanel(1);
		setDisable('wanwhite', 1);
	}
	
    if(IsAdminUser() == false)     		
	{              
	    setDisplay('lan_table', 0);    	    
	    setDisplay('telnetwifiRow', 0); 
	    setDisplay('wan_table', 0);                     
	    setDisplay('ListConfigPanel', 0);  
	    setDisplay('ConfigPanel', 0);
		setDisplay('wifi_space', 0);
		setDisplay('wan_space', 0);
	}
	else if(IsE8cFrame())
	{
	    setDisplay('lan_table', 1); 
		setDisplay('ftplanRow', 0); 
	    setDisplay('httplanRow', 0); 
	    setDisplay('sshlanRow', 0); 			    
	    setDisplay('telnetwifiRow', getCheckVal('telnetlan')); 
	    setDisplay('wan_table', 0);                     
	    setDisplay('ListConfigPanel', 0);  
	    setDisplay('ConfigPanel', 0);
		setDisplay('wifi_space', 0);
		setDisplay('wan_space', 0);
	}
	else
	{
		setDisplay('lan_table', 1);    	    
	    setDisplay('telnetwifiRow', 1); 
	    setDisplay('wan_table', 1);                     
	    setDisplay('ListConfigPanel', 1);  
	}
	
	if (true == IsOSKNormalUser())
    {
	    setDisplay('lan_table', 1);    	    
	    setDisplay('telnetwifiRow', 1); 
	    setDisplay('wan_table', 1);                     
	    setDisplay('ListConfigPanel', 1); 
		if (WhiteList.length > 1)
		{
			selectLine(TableName + '_record_0');
		}		
    }

	if('0' == wantelflag)
	{
		setDisable('telnetwan' , 1);
		setCheck('telnetwan', 0);
	}
	
	if(SingleFreqFlag != 1 && DoubleFreqFlag != 1)
	{ 
	  	setDisplay('wifi_space', 0);
		setDisplay('wifi_table', 0);   
	} 

    if ('CLARO' == CfgModeWord.toUpperCase())
    {
	    setDisplay('lan_table', 1);    	    
	    setDisplay('wifi_telnet', 1); 
	    setDisplay('wan_table', 1);                     
	    setDisplay('ListConfigPanel', 1);  
		
		setDisable('telnetwifi', 0);
		setDisable('httpwifi' , 0);
		if (WhiteList.length > 1)
		{
			selectLine(TableName + '_record_0');
		}	
    }
	
	
}

function FormCheck()
{
    //with (getElement('ConfigForm'))
	{	
		  
		    if((AclInfo.HttpWifiEnable != getCheckVal('httpwifi'))&&(0 == getCheckVal('httpwifi')))
		    {
		    
    		    if(false == ConfirmEx(acl_language['bbsp_confirm_wifi']))
			{
        		    setCheck('httpwifi',1);
			    return false;
			}
		    }
		


		if((AclInfo.HttpLanEnable != getCheckVal('httplan'))&&(0 == getCheckVal('httplan')))
		{
		    
    		if(false == ConfirmEx(acl_language['bbsp_confirm_lan']))
			{
        		setCheck('httplan',1);
				return false;
			}
		}

		if((AclInfo.HttpWanEnable != getCheckVal('httpwan'))&&(0 == getCheckVal('httpwan')))
		{
    		if(false == ConfirmEx(acl_language['bbsp_confirm_wan']))
			{
        		setCheck('httpwan',1);
				return false;
			}
		}
    }

	return true;
}

function SubmitForm()
{
	if(false == FormCheck())
    {
        return;
    }

	setDisable('btnApply', 1);
    setDisable('cancelValue', 1);

    var Form = new webSubmitForm();

    Form.usingPrefix('x');
    
	    
		if(((IsAdminUser() == true) && !IsE8cFrame())
			|| (true == IsOSKNormalUser())
			|| ('CLARO' == CfgModeWord.toUpperCase()))
		{
			Form.addParameter('FTPLanEnable',getCheckVal('ftplan'));
			Form.addParameter('FTPWanEnable',getCheckVal('ftpwan'));	
			Form.addParameter('HTTPLanEnable',getCheckVal('httplan'));
			Form.addParameter('HTTPWanEnable',getCheckVal('httpwan'));
			Form.addParameter('TELNETLanEnable',getCheckVal('telnetlan'));
			Form.addParameter('TELNETWanEnable',getCheckVal('telnetwan'));
			Form.addParameter('HTTPWifiEnable',getCheckVal('httpwifi'));	
			Form.addParameter('TELNETWifiEnable',getCheckVal('telnetwifi'));
			Form.addParameter('SSHLanEnable',getCheckVal('sshlan'));
			Form.addParameter('SSHWanEnable',getCheckVal('sshwan'));
		}
		else if((IsAdminUser() == true) && IsE8cFrame())
		{
			Form.addParameter('TELNETLanEnable',getCheckVal('telnetlan'));
			Form.addParameter('HTTPWifiEnable',getCheckVal('httpwifi')); 		
			Form.addParameter('TELNETWifiEnable',getCheckVal('telnetwifi'));			
		}
		else
		{ 
			 Form.addParameter('HTTPWifiEnable',getCheckVal('httpwifi')); 
		}
    Form.endPrefix();		
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security.AclServices&RequestFile=html/bbsp/acl/acl.asp');	
	Form.submit();			
	setDisable('bttnApply',1);
    setDisable('cancelValue',1);  
}

function ChangeLevel(level)
{
	 
}

function CancelConfig()
{
    LoadFrame();
}

	function CheckParameter()
	{
		var SrcIPPrefix = getElement('SrcIPPrefix').value;
		if (SrcIPPrefix == '')
		{
			AlertEx(acl_language['bbsp_alert_srcip1']);			
	        return false;
		}

		if (SrcIPPrefix.length > 64)
		{		    
			AlertEx(acl_language['bbsp_alert_srcip2']);	
	        return false;
		}

		var addrParts = SrcIPPrefix.split('/');
		if (addrParts.length != 2) 
		{			
			AlertEx(acl_language['bbsp_alert_addaddr']);	
			return false;
		}
		
        	if((addrParts[1].length>2)
		||((addrParts[1]=='8 ') &&(addrParts[1].length==2)))
		{
			AlertEx(acl_language['bbsp_alert_addaddr']);
			return false;
		}


       if ((isValidIpAddress(addrParts[0]) == false) && (IsIPv6AddressValid(addrParts[0]) == false))
		{			
			AlertEx(acl_language['bbsp_alert_invalidipaddr']);	
			return false;
	 	}

		if(isNaN(addrParts[1].replace(' ', 'a')) == true)
		{
			AlertEx(acl_language['bbsp_maskinvalid1']);
			return false;
		}


	var IsIPv4 = isValidIpAddress(addrParts[0]);
	var num = parseInt(addrParts[1],10);
	if (num == 0 || ((IsIPv4 == true) && (num > 32)))
	{
		AlertEx(acl_language['bbsp_maskinvalid3']);
		return false;
	}

	if ((IsIPv4 == true) && (iSIPmatchMask(addrParts[0],num) == false))
	{
		AlertEx(acl_language['bbsp_maskinvalid4']);
		return false;    
	}

	if (IsIPv4 == true)
	{
		var addrs=SrcIPPrefix.split('.');
		var addr=parseInt(addrs[0],10);
		if(addr>=224&&addr<=239)
		{
			AlertEx(acl_language['bbsp_alert_invalidipaddr']);
			return false; 
		}
	}
	for (i = 0; i < WhiteList.length-1; i++)
	{
		if((selctIndex != i) && (WhiteList[i].SrcIPPrefix == SrcIPPrefix))
		{
			AlertEx(acl_language['bbsp_iprepeat']);
			return false; 
		}
	}

	return true;
}
function checkzeronum(num)
{
	var temp = 0;
	var ZeroNum = 0;
	
	for(var i = 0; i<= 7; i++)
	{
		temp = num >> i ;
		if((temp & 1) == 0)
		{
			ZeroNum++;
		}
		else
		{
			return ZeroNum;
		}
	}
	return ZeroNum;
}

function iSIPmatchMask(ip ,mask)
{
	var addripv4 = ip.split('.')
	var ZeroTotal = 0;
	
	for(var k=3; k>=0; k--)
	{
		ZeroTotal += checkzeronum(addripv4[k]);
		if(8 != checkzeronum(addripv4[k]))
		{		
			if((mask < (32 - ZeroTotal)) || (mask >32))
			{
				return false; 
			} 
			return true;  
		}
	}
}

function DeleteLineRow()
{
   var tableRow = getElementById(TableName);
   if (tableRow.rows.length > 2)
   tableRow.deleteRow(tableRow.rows.length-1);
   return false;
}

function setControl(Index)
{
	selctIndex = Index;
	if (Index < -1)
	{
		return;
	}
	if (Index == -1)
	{
		if(WhiteList.length >= 17)
		{
			DeleteLineRow();
			AlertEx(acl_language['bbsp_ipaddrfull']);
			setDisplay('ConfigPanel', 0);
			setControl(0);
			return ;
		}
		else
		{
			SetAddMode();
			setText('SrcIPPrefix', '');
			setDisplay("ConfigPanel", "1"); 
		}
	}
	else
	{ 
		SetEditMode();
		setDisplay("ConfigPanel", "1");
        setText('SrcIPPrefix',WhiteList[Index].SrcIPPrefix);
	}
}

function SIPWhiteListConfigListselectRemoveCnt(val)
{

}
    function OnDeleteButtonClick(TableID) 
    {        
        var Form = new webSubmitForm();
        var SelectCount = 0;
		var CheckBoxList = document.getElementsByName(TableName + 'rml');
		
		for (var i = 0; i < CheckBoxList.length; i++)
		{
			if (CheckBoxList[i].checked != true)
			{
           		continue;
       		}
			SelectCount++;
			Form.addParameter(CheckBoxList[i].value,'');
		}

        if (SelectCount == 0)
        {			
			AlertEx(acl_language['bbsp_alert_selwhite']);	
            return false;
        }
		
		Form.addParameter('x.X_HW_Token', getValue('onttoken')); 
        Form.setAction('del.cgi?' +'x=InternetGatewayDevice.X_HW_Security.WANSrcWhiteList.List' + '&RequestFile=html/bbsp/acl/acl.asp');   
        Form.submit();       
    }


    function OnApplyButtonClick()
    {
		if (CheckParameter() == false)
		{
			return false;
		}

		var Form = new webSubmitForm();

		Form.addParameter('x.SrcIPPrefix', getValue('SrcIPPrefix'));
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		
		if (IsAddMode() == true)
		{
			 Form.setAction('add.cgi?' +'x=InternetGatewayDevice.X_HW_Security.WANSrcWhiteList.List' + '&RequestFile=html/bbsp/acl/acl.asp');
		}
	   else
		{
			 Form.setAction('set.cgi?x=' + WhiteList[selctIndex].domain + '&RequestFile=html/bbsp/acl/acl.asp'); 
		}

		Form.submit();
		DisableRepeatSubmit();
    }


    function OnCancelButtonClick()
    {
		setDisplay("ConfigPanel", 0);
        var tableRow = getElement(TableName);
        
        if ((tableRow.rows.length > 2) && (IsAddMode() == true))
        {
            tableRow.deleteRow(tableRow.rows.length-1);
        }
    }


	function EnableForm()
	{
		var Form = new webSubmitForm();
		var Enable = getElById("wanwhite").checked;
		if (Enable == true)
		{
		   Form.addParameter('x.WANSrcWhiteListEnable',1);
		}
		else
		{
		   Form.addParameter('x.WANSrcWhiteListEnable',0);
		}
		
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security.WANSrcWhiteList'
							+ '&RequestFile=html/bbsp/acl/acl.asp');
		Form.submit();
	}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<script language="JavaScript" type="text/javascript">
if (('PTVDF' == CfgModeWord.toUpperCase()) || ('PTVDF2' == CfgModeWord.toUpperCase()))
{
	HWCreatePageHeadInfo("acltitle", GetDescFormArrayById(acl_language, "bbsp_mune"), GetDescFormArrayById(acl_language, "bbsp_title_prompt1"), false);
}
else
{
	HWCreatePageHeadInfo("acltitle", GetDescFormArrayById(acl_language, "bbsp_mune"), GetDescFormArrayById(acl_language, "bbsp_title_prompt"), false);
}
</script>
<div class="title_spread"></div>

<form id="lan_table" style="display:none;"> 
	<div id="LanServiceTitle" class="func_title" BindText="bbsp_table_lan"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
		<li   id="ftplan"   RealType="CheckBox"  DescRef="bbsp_table_lanftp"   RemarkRef="Empty"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.FTPLanEnable"  InitValue="" />
		<li   id="httplan"   RealType="CheckBox"  DescRef="bbsp_table_lanhttp"   RemarkRef="Empty"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.HTTPLanEnable"  InitValue="" />
		<li   id="telnetlan"   RealType="CheckBox"  DescRef="bbsp_table_lantel"   RemarkRef="Empty"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.TELNETLanEnable"  InitValue="" ClickFuncApp="onclick=telnetwifienable" />
		<li   id="sshlan"   RealType="CheckBox"  DescRef="bbsp_table_lanssh"   RemarkRef="Empty"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.SSHLanEnable"  InitValue="" />
	</table>
	<script>
		var TableClass = new stTableClass("per_35_52", "per_65_48", "ltr");
		var LanServiceFormList = new Array();
		LanServiceFormList = HWGetLiIdListByForm("lan_table",null);
		HWParsePageControlByID("lan_table",TableClass,acl_language,null);
	</script>
	<div class="func_spread"></div>
</form> 

<form id="wifi_table" style="display:block;"> 
	<div id="WlanServiceTitle" class="func_title" BindText="bbsp_table_wifi"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
		<li   id="httpwifi"     RealType="CheckBox"  DescRef=""   RemarkRef="Empty"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.HTTPWifiEnable"  InitValue="" />
		<li   id="telnetwifi"   RealType="CheckBox"  DescRef="bbsp_table_wifitelnet"   RemarkRef="Empty"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.TELNETWifiEnable"  InitValue="" />
	</table>
	<script>
		var WlanServiceFormList = new Array();
		WlanServiceFormList = HWGetLiIdListByForm("wifi_table",null);
		HWParsePageControlByID("wifi_table",TableClass,acl_language,null);
		if (('PTVDF' == CfgModeWord.toUpperCase()) || ('PTVDF2' == CfgModeWord.toUpperCase()))
		{
			document.getElementById("httpwifiColleft").innerHTML = acl_language['bbsp_table_wifihttp1'];
		}
		else
		{
			document.getElementById("httpwifiColleft").innerHTML = acl_language['bbsp_table_wifihttp'];
		}
	</script>
</form> 

<form id="wan_table" style="display:none;"> 
<div class="func_spread"></div>
	<div id="WanServiceTitle" class="func_title" BindText="bbsp_table_wan"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
		<li   id="ftpwan"   RealType="CheckBox"  DescRef="bbsp_table_wanftp"   RemarkRef="Empty"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.FTPWanEnable"  InitValue="" />
		<li   id="httpwan"   RealType="CheckBox"  DescRef="bbsp_table_wanhttp"   RemarkRef="Empty"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.HTTPLanEnable"  InitValue="" />
		<li   id="telnetwan"   RealType="CheckBox"  DescRef="bbsp_table_wantel"   RemarkRef="Empty"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.TELNETWanEnable"  InitValue="" />
		<li   id="sshwan"   RealType="CheckBox"  DescRef="bbsp_table_wanssh"   RemarkRef="Empty"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.SSHWanEnable"  InitValue="" />
	</table>
	<script>
		var WanServiceFormList = new Array();
		WanServiceFormList = HWGetLiIdListByForm("wan_table",null);
		HWParsePageControlByID("wan_table",TableClass,acl_language,null);
	</script>
</form> 
<table class="table_button" width="100%"> 
  <tr>
	<td class='width_per35'></td> 
	<td class="table_submit width_per65"> <button id="bttnApply" name="bttnApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="SubmitForm();" id="Button1"><script>document.write(acl_language['bbsp_app']);</script></button>
	  <button name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" onClick="CancelConfig();"><script>document.write(acl_language['bbsp_cancel']);</script></button></td> 
  </tr> 
</table>
<div class="func_spread"></div>

<div id="ListConfigPanel" style="display:none;"> 
	<form id="WanSideEnableForm" style="display:block;"> 
		<div id="WanSideEnableTitle" class="func_title" BindText="bbsp_title_wanwhite"></div>
		<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
			<li   id="wanwhite"   RealType="CheckBox"  DescRef="bbsp_title_wanwhiteenable"   RemarkRef="Empty"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.WANSrcWhiteListEnable"  InitValue=""  ClickFuncApp="onclick=EnableForm"/>
		</table>
		<script>
			var WanSideEnableFormList = new Array();
			WanSideEnableFormList = HWGetLiIdListByForm("WanSideEnableForm",null);
			HWParsePageControlByID("WanSideEnableForm",TableClass,acl_language,null);
		</script>
		<div class="func_spread"></div>
	</form> 

	<script language="JavaScript" type="text/javascript">
		var SIpWhiteListConfiglistInfo = new Array(new stTableTileInfo("Empty","width_per20","DomainBox"),
										new stTableTileInfo("bbsp_title_ipwhitelist","width_per80","SrcIPPrefix"),null);
		var ColumnNum = 2;
		var ShowButtonFlag = true;
		var TableDataInfo =  HWcloneObject(WhiteList, 1);
		//TableDataInfo.push(null);
		HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, SIpWhiteListConfiglistInfo, acl_language, null);
	</script> 
</div>   
	<form id="ConfigPanel" style="display:none;">
		<div class="list_table_spread"></div>
		<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg"> 
			<li   id="SrcIPPrefix"       RealType="TextBox"          DescRef="bbsp_table_srcaddrwlist"         RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.VenderClassId"   Elementclass="width_150px"  InitValue="Empty"  MaxLength="64"/>
			<script>
				var TableClass = new stTableClass("width_per20", "width_per80", "ltr");
				var SrcIpPrefixConfigFormList = new Array();
				SrcIpPrefixConfigFormList = HWGetLiIdListByForm("ConfigPanel", null);
				var formid_hide_id = null;
				HWParsePageControlByID("ConfigPanel", TableClass, acl_language, formid_hide_id);
				document.getElementById("SrcIPPrefixRemark").innerHTML = "(A.B.C.D/E)";
			</script>
		</table>
	
        <table id="ConfigPanelButtons" width="100%"  class="table_button"> 
          <tr> 
            <td class='width_per20'> </td> 
            <td class="table_submit pad_left5p"> 
			  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			  <button id="ButtonApply"  type="button" onclick="javascript:return OnApplyButtonClick();" class="ApplyButtoncss buttonwidth_100px" ><script>document.write(acl_language['bbsp_app']);</script></button>
              <button id="ButtonCancel" type="button" onclick="javascript:OnCancelButtonClick();" class="CancleButtonCss buttonwidth_100px" ><script>document.write(acl_language['bbsp_cancel']);</script></button> </td> 
          </tr>
		  <tr> 
			  <td  style="display:none"> <input type='text'> </td> 
		  </tr>          
        </table> 
     </form> 

   
<br>
<br>
<script>
	ParseBindTextByTagName(acl_language, "td",    1);
	ParseBindTextByTagName(acl_language, "div",   1);
</script>
</body>
</html>

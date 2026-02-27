<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<title>Firewall Level</title>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var FltsecLevelx = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.X_HW_FirewallLevel);%>';
var FltsecLevel = changechar(FltsecLevelx);
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 
var curUserType = '<%HW_WEB_GetUserType();%>';
var SonetFlag = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SONET);%>';

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

function IsOSKNormalUser()
{
	if (('OSK' == CfgModeWord.toUpperCase()) && (curUserType != '0'))
	{
		return true;
	}
	else
	{
		return false;
	}
}

function IsCroatiahtUser()
{
	if ('CROATIAHT' == CfgModeWord.toUpperCase())
	{
		return true;
	}
	else
	{
		return false;
	}
}

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
		b.innerHTML = firewalllevel_language[b.getAttribute("BindText")];
	}
}

function changechar(str)
{
	if(!str)
	{
		return "";
	}
	return str.substring(0,1).toUpperCase()+str.substring(1,10).toLowerCase();
}

function LoadFrame()
{
	setSelect("SecurityLevel", FltsecLevel);
	setDisable("SecurityLevel" , (curUserType != '0') ? 1 : 0);
	setDisable("btnApply" , (curUserType!= '0') ? 1 : 0);
	if(IsSonetUser() || IsOSKNormalUser() || IsCroatiahtUser())
	{
		setDisable("SecurityLevel" , 0);
		setDisable("btnApply" , 0);
	}

	loadlanguage();
}

function SubmitForm()
{
    var Form = new webSubmitForm();   
    Form.addParameter('x.X_HW_FirewallLevel',getValue('SecurityLevel'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security'+ '&RequestFile=html/bbsp/firewalllevel/firewalllevel.asp');	
	Form.submit();	
}

function ChangeLevel(level)
{		

}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("firewallleveltitle", GetDescFormArrayById(firewalllevel_language, "bbsp_mune"), GetDescFormArrayById(firewalllevel_language, ""), false);
	if((CfgModeWord.toUpperCase() == "PTVDF")|| (CfgModeWord.toUpperCase() == "PTVDF2"))
	{
		  document.getElementById("firewallleveltitle_content").innerHTML = firewalllevel_language['bbsp_firewalllevel_title_short'];
	}else
	{
		  document.getElementById("firewallleveltitle_content").innerHTML = firewalllevel_language['bbsp_firewalllevel_title'];
	}
</script>
<div class="title_spread"></div>

<form id="FirewallLevelForm" name="FirewallLevelForm">
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
		<li id="currentlevel"   RealType="HtmlText" DescRef="bbsp_currentlevelmh" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE" BindField="Empty"  MaxLength="15" InitValue="Empty" />
		<li id="SecurityLevel"  RealType="DropDownList" DescRef="bbsp_setlevelmh"   RemarkRef="Empty"   ErrorMsgRef="Empty"  Require="FALSE"   BindField="x.X_HW_FirewallLevel"  InitValue="[{TextRef:'Disable',Value:'Disable'},{TextRef:'High',Value:'High'},{TextRef:'Medium',Value:'Medium'},{TextRef:'Low',Value:'Low'},{TextRef:'Custom',Value:'Custom'}]"/>
	</table>
	<script>
		var TableClass = new stTableClass("width_per40", "width_per60", "ltr");
		var FirewallLevelFormList = new Array();
		FirewallLevelFormList = HWGetLiIdListByForm("FirewallLevelForm",null);
		HWParsePageControlByID("FirewallLevelForm",TableClass,firewalllevel_language,null);
		if( undefined != firewalllevel_language[FltsecLevel])
		{      
			document.getElementById('currentlevel').innerHTML = "&nbsp;&nbsp;"+firewalllevel_language[FltsecLevel];
		}
		else
		{
		   document.getElementById('currentlevel').innerHTML = "&nbsp;&nbsp;"+firewalllevel_language['Custom'];
		}
	</script>
</form>

<table id="OperatorPanel" class="table_button" style="width: 100%" cellpadding="0">
  <tr>
  <td class="table_submit width_per40"></td>
  <td class="table_submit">
  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
  <button name="btnApply" id="btnApply" type="button"  onClick="SubmitForm();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(firewalllevel_language['bbsp_app']);</script></button>
  </td>
  </tr>
</table>

</body>
</html>

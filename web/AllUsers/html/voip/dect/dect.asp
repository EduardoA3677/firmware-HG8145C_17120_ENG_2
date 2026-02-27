<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.js);%>"></script>
<title>VOIP Interface</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(tabdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(voicedes.html);%>"></script>
<script language="JavaScript" type="text/javascript"> 

var isLanIP = '<%HW_WEB_GetRemoteIPType();%>';

var VoiceProfileNumber = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.VoiceService.1.VoiceProfileNumberOfEntries);%>';

var TableClass = new stTableClass("width_per30", "width_per70", "ltr");

var curUserType='<%HW_WEB_GetUserType();%>';
var pinPwd = '';

var BasePin = '<%HW_WEB_GetPINCode();%>';


function stDectBase(Domain, PIN)
{
    this.Domain = Domain;
    this.PIN = PIN;
}
var Base= <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.DECT.Base.1,PIN,stDectBase);%>;

function CheckForm1()
{
	if(1 == getCheckVal("PaswordPINCheck"))
	{
		pinPwd = getValue('PINPassword');
	}
	else
	{
		pinPwd = getValue('PINPwdText');
	}
	
	if (pinPwd == "****")
	{
		return true;
	}
	
	if ( '' != removeSpaceTrim(pinPwd))
	{
		if ( false == isInteger(pinPwd) )
		{
			AlertEx(dect['pin_alert']);
			return false;
		}
	}
	
	
	if (pinPwd.length != 4)
	{
		AlertEx(dect['pin_len']);
		return false;
	}
	
	return true;
}


function CheckForm(type)
{
    var ulret = CheckForm1();  
	  
    if (ulret != true )
    {
        return false;
    }
	
    return true;
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
        b.innerHTML = dect[b.getAttribute("BindText")];
    }
	
	setText('PINPassword', BasePin);
	
	
	setDisplay("PINPwdTextRow", 0);
	
	if('0' == curUserType)
	{
		setDisable("PaswordPINCheck", 1);
	}
	
	if(1 == isLanIP)
	{
		setDisable('PINPassword',1);
		setDisable('btnApplyVoipUser',1);
		setDisable('cancelValue',1);
		setDisable("PaswordPINCheck", 1);
	}
}

function AddSubmitParam(Form,type)
{  
    var domain;
	if (pinPwd != "****")
	{
		Form.addParameter('x.PIN',pinPwd);  
	}
	    
	domain ='x=' + Base[0].Domain  ;

    Form.setAction('SetDectPin.cgi?' + domain + '&RequestFile=html/voip/dect/dect.asp');
	
    setDisable('btnApplyVoipUser',1);
    setDisable('cancelValue',1);
}

function DectCancel()
{
	setText('PINPassword', BasePin);
	setText('PINPwdText', BasePin);
}

function ShowOrHideText(checkBoxId, otherCheckBoxId)
{
    setCheck(otherCheckBoxId, getCheckVal(checkBoxId));
	
	 if (1 == getCheckVal(checkBoxId))
	 {
	 	setDisplay("PINPwdTextRow", 0);
		setDisplay("PINPasswordRow", 1);
		setText("PINPassword", getValue("PINPwdText"));
	 }
	else
	{
		setDisplay("PINPwdTextRow", 1);
		setDisplay("PINPasswordRow", 0);
		setText("PINPwdText", getValue("PINPassword"));
	}	
}

</script>
</head>

<body  class="mainbody" onLoad="LoadFrame();">  
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("VoipProtocol", GetDescFormArrayById(dect, "v01"), GetDescFormArrayById(dect, "v02"), false);
</script>

<div class="title_spread"></div>
<div id="vag_is_exist">
<form id="dect">
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
<li id="PINPassword" RealType="TextOtherBox" DescRef="vspa_pin" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="PINPassword"   InitValue=
"[{Item:[{AttrName:'id', AttrValue:'PaswordPINCheck'},{AttrName:'Type', AttrValue:'CheckBox'}, {AttrName:'checked', AttrValue:'true'},{AttrName:'onClick', AttrValue:'ShowOrHideText(this.id, \'TxtPINCheck\')'}]} ,{Type:'span', Item:[{AttrName:'id', AttrValue:'showpwdspanDecode'},{AttrName:'Type', AttrValue:'span'},{AttrName:'innerhtml', AttrValue:'pin_hint'}]}]" MaxLength="256"/>

<li id="PINPwdText" RealType="TextOtherBox" DescRef="vspa_pin" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="PINPassword"   InitValue=
"[{Item:[{AttrName:'id', AttrValue:'TxtPINCheck'},{AttrName:'Type', AttrValue:'CheckBox'}, {AttrName:'value', AttrValue:'1'},{AttrName:'onClick', AttrValue:'ShowOrHideText(this.id, \'PaswordPINCheck\')'}]} ,{Type:'span', Item:[{AttrName:'id', AttrValue:'showpwdspanDecode'},{AttrName:'Type', AttrValue:'span'},{AttrName:'innerhtml', AttrValue:'pin_hint'}]}]" MaxLength="256"/>

<script>
var VoipConfigFormList = HWGetLiIdListByForm("dect", null);
HWParsePageControlByID("dect", TableClass, dect, null);
</script>
</table>
</form>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
<tr >
<td class="table_submit width_per25"></td>
<td class="table_submit"> 
<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
<input name="btnApplyVoipUser" id="btnApplyVoipUser" type="button" class="ApplyButtoncss buttonwidth_100px" value="Apply" onClick="Submit();"/>
<script type="text/javascript">
document.getElementsByName('btnApplyVoipUser')[0].value = dect['vspa_apply'];    
</script>
<input name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" value="Cancel" onClick="DectCancel();"/>
<script>
document.getElementsByName('cancelValue')[0].value = dect['vspa_cancel'];
</script>

</td>
</tr>
</table>

</body>
</div>
</html>

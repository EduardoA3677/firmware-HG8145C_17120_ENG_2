<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="./xgponauth_func.asp"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>

<title>ONT Authentication</title>
<script language="JavaScript" type="text/javascript">
var isGuidePage = false;

if(window.parent.wifiPara != null)
{
	isGuidePage = true;
}

if(isGuidePage && window.parent.wifiPara.wifiFlag)
{
	window.parent.wifiPara.wifiFlag = 0;
	window.parent.onchangestep(window.parent.wifiPara);
}
var TypeWord_com = '<%HW_WEB_GetTypeWord();%>';
var passwordTips;
var passwordLen;
var eponpassword;
var gponpassword;
var hexgponpassword;
var sysUserType = '0';
var sptUserType = '1';
var instalUserType = '3';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';
var NullPwdFlag = '<%HW_WEB_IsNullSnPwd();%>';
var PtvdfFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PTVDF);%>';
var logo_singtel = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_SINGTEL);%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var OnlinedFlag = '<%HW_WEB_GetOnlinedFlag();%>';
var PWDHEXINIT = '40314756295A3C21';
var telmexSpan = false;
var t2Flag = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_TDE);%>';
var bztlfFlag = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_BZTLF);%>';
var ont2onrEnable = 0;
var onr = new Array('amp_auth_title','amp_auth_title_head','amp_ontauth_protectPwdLoidKey','amp_registration_status','amp_auth_ont_id','amp_auth_note_1','amp_auth_attention_content','amp_pass_word','amp_psk_note','amp_registerid_note');
var BytelFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_BYTEL);%>';
var TelMexFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TELMEX);%>';

var LoidCommon = '0';
var LoidEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_AmpInfo.DefaultLoidAuth);%>';
if ('1' == LoidEnable)
{
    LoidCommon = '1';
}

if (('COMMON' == CfgMode.toUpperCase()) || ('COMMON2' == CfgMode.toUpperCase()) || ('CLOSETELNET' == CfgMode.toUpperCase()))
{
    LoidCommon = '1';
}

if (999 == top.changeMethod)
{
    top.changeMethod = ((1 == LoidEnable) ? 1 : 2);
}

if ('1' == TelMexFlag && 'SPANISH' == curLanguage.toUpperCase())
{
    telmexSpan = true;
}

if ((1 == '<%HW_WEB_GetFeatureSupport(FT_FEATURE_SINGTEL);%>') && ('ENGLISH' == curLanguage.toUpperCase()))
{
    ont2onrEnable = 1;
}

function ont2onr(resourcename)
{
    var index = 0;
    var len = onr.length;

    if (0 == ont2onrEnable)
    {
        return resourcename;
    }
    
    for (index = 0; index < len; index++)
    {
        if (resourcename == onr[index])
        {
            return resourcename+'_onr';
        }
    }
    
    return resourcename;
}
    
function convTo20Bit(str)
{
    var newStr = str;
    
    if(newStr == null)
    {
        newStr = "";
    }
    
    for(var i = 0; (i < 20) && (newStr.length < 20); i++)
    {
        newStr += "0";
    }

    return newStr;
}

function stDevInfo(domain, serialnumber, devtype, loid, eponpwd, hexpassword)
{
    this.domain = domain;
    this.serialnumber = serialnumber;    
    this.devtype="1";
    if((1 == PtvdfFlag) && (0 == NullPwdFlag))
    {
        this.hexpassword = PWDHEXINIT;
        hexgponpassword = PWDHEXINIT;
        gponpassword = ChangeHextoAscii(PWDHEXINIT);
    }
    else
    {
        if('1' == t2Flag)
        {
            hexpassword = convTo20Bit(hexpassword);
        }
        this.hexpassword = hexpassword;
        hexgponpassword = hexpassword;
        gponpassword = ChangeHextoAscii(hexpassword);
    }

	this.loid       = loid;
    this.eponpwd = eponpwd;
	eponpassword = eponpwd;
}

var stDevInfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetOntAuthInfo, InternetGatewayDevice.DeviceInfo, SerialNumber|X_HW_UpPortMode|X_HW_Loid|X_HW_EponPwd|X_HW_PonHexPassword, stDevInfo);%>;

var stDevinfo = stDevInfos[0];

var stOnlineStatusInfo = <%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.OntOnlineStatus.ontonlinestatus);%>;
var isOntOnline = stOnlineStatusInfo;

var PWDINIT = '@1GV)Z<!';


var StarhubncFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_STARHUBNC);%>';
var NCFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_NC);%>';
var AtTelecomFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TELECOM);%>';
var FobidSnFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_FORBID_SN);%>';
var hexPwdDefualtFlag = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_TDE);%>';
var OntAuthentication= '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_ONT_AUTHENTICATION);%>';
var SingtelFlag = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_SINGTEL);%>';

function Debug(para)
{
}

function SetDivValue(Id, Value)
{
    try
    {
        var Div = document.getElementById(Id);
        Div.innerHTML = Value;
    }
    catch(ex)
    {

    }
}

function IsLogicIDSupport()
{
    var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
    var ontXGMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.XG_AccessMode);%>';
    var IsGponXGpon = '0';
	if ((ontPonMode == 'gpon') || (ontPonMode.indexOf("gpon")) > 0)
    {
	    IsGponXGpon = '1';
    }

    if ((curLanguage.toUpperCase == "CHINESE") || (('1' == LoidCommon) && ('1' == IsGponXGpon)))
    {
        return true;
    }

    return false;
}


function ShowOrHideText(checkBoxId, passwordId,textId, value)
{
    if (1 == getCheckVal(checkBoxId))
	{
	      setDisplay(passwordId, 1);
	      setDisplay(textId, 0);
	}
	else
	{
	      setDisplay(passwordId, 0);
	      setDisplay(textId, 1);
	}
}

function CheckStr(strField, strCheckStr, uiMinLen, uiMaxLen)
{
    var ret = true;
    var strTmp = "";

	if (('' == strCheckStr || strCheckStr == null) && (uiMinLen > 0))
    {
        strTmp = "";
        strTmp = strField + cfg_ontauth_language['amp_auth_chklen1'] + uiMinLen + cfg_ontauth_language['amp_auth_chklen2'] + uiMaxLen + cfg_ontauth_language['amp_auth_chklen3'];
        AlertEx(strTmp);
        return false;
    }

    if(false == isSafeStringExc(strCheckStr,''))
    {
        strTmp = "";
        strTmp = strField + cfg_ontauth_language['amp_auth_chk6'] + strCheckStr + cfg_ontauth_language['amp_auth_chk7'] + cfg_ontauth_language['amp_auth_chk5'];
        AlertEx(strTmp);
        return false;	
    }
	
    if ((uiMaxLen < strCheckStr.length) || (uiMinLen > strCheckStr.length))
    {
        strTmp = "";
        strTmp = strField + cfg_ontauth_language['amp_auth_chklen1'] + uiMinLen + cfg_ontauth_language['amp_auth_chklen2'] + uiMaxLen + cfg_ontauth_language['amp_auth_chklen3'];
        AlertEx(strTmp);
        return false;
    }   
	
      return ret;
}

function CheckT2CharPwd(gponpwd)
{
    var ret = true;
    var len = gponpwd.length;
    
    if( (len != 7 && len != 10) || (false == isSafeStringExc(gponpwd,'')))
    {
        ret = false;
        AlertEx(cfg_ontauth_language['amp_hexpaswd_tde2_char']);
    }
    
    return ret;
}


function IsNum(s)
{
    s = parseInt(s, 10);
    
    return !isNaN(s);
}

function isDecNumber(number)
{
    for (var index = 0; index < number.length; index++)
    {
        if (IsNum(number.charAt(index)) == false)
        {
            return false;
        }
    }
    return true;
}

function CheckBztlfCharPwd(gponpwd)
{
    var ret = true;
    var len = gponpwd.length;
    
    if( ( 10 != len) || (isDecNumber(gponpwd) == false) )
    {
        ret = false;
        AlertEx(cfg_ontauth_language['amp_hexpaswd_bztlf']);
    }
    
    return ret;
}

function isPwdSubmit(passwd)
{
    if ( (1 == PtvdfFlag) && (PWDINIT == ChangeHextoAscii(passwd)) )
    {
        return false;
    }

    return true;

}

function CheckForm(type)
{
    var ret = false;

	if( IsLogicIDSupport() && (1 == getRadioVal("rMethod")) )
	{
		var loid = getValue('LOIDValue');
        var eponpwd = getValue('PwdEponValue');

        ret = CheckStr("LOID", loid, 0, 24);
        if (false == ret)
        {
             return ret;
        }
        if (eponpwd.length > 0)
        {
             return CheckStr(cfg_ontauth_language['amp_passwd_str'], eponpwd, 0, 12); 
        }
        else
        {
             return true;
        }
	}

    with (getElById ("ConfigForm"))
    {

        ret = CheckSN();
        if(false == ret)
        {
            return ret;
        }

        if (0 == getSelectVal('Passwordmode'))
        {
            var gponpwd = getValue('PwdGponValue');

            if('1' == t2Flag)
            {
                ret = CheckT2CharPwd(gponpwd);
            }
            else if ('1' == bztlfFlag)
            {
                ret = CheckBztlfCharPwd(gponpwd);
            }
            else
            {
                ret = CheckStr(cfg_ontauth_language['amp_passwd_str'], gponpwd, 0, 10);
            }
        }
        else if (1 == getSelectVal('Passwordmode'))
        {
            ret = CheckHexPassWord();
        }

        if(!ret) return false;
    }
	
	ret = checkxgponinfo();
	if (false == ret)
	{
		return false;		
	}
	
	return ret;
}

function conv12to16HexSn(SerialNum)
{
    var charVid = "";
	var hexVid = "";
	var vssd = "";
	var i;
	
    charVid = SerialNum.substr(0,4);
	vssd = SerialNum.substr(4,8);

	for(i=0; i<4; i++)
	{
		hexVid += charVid.charCodeAt(i).toString(16);
	}	
	
	return hexVid+vssd;
}

function conv16to12Sn(SerialNum)
{
    var charVid = "";
	var hexVid = "";
	var vssd = "";
	var i;

    hexVid = SerialNum.substr(0,8);
	vssd = SerialNum.substr(8,8);
	
	for(i=0; i<8; i+=2)
	{
		charVid += String.fromCharCode("0x"+hexVid.substr(i, 2));
	}

	return charVid+vssd;
}

function refreshPasswordMode()
{
    setDisplay("TrPasswordmode",1);

    if (0 == getSelectVal('Passwordmode'))
    {
        setDisplay("TrPasswordGpon",1);
        setDisplay("TrHexPassword",0);		
        getElById("PwdGponValue").value = ChangeHextoAscii(stDevinfo.hexpassword);
        getElById("tPwdGponValue").value = ChangeHextoAscii(stDevinfo.hexpassword);
        top.Passwordmode=0;
    }
    else if (1 == getSelectVal('Passwordmode'))
    {
        setDisplay("TrPasswordGpon",0);
        setDisplay("TrHexPassword",1);
        setText('HexPwdValue', stDevinfo.hexpassword);
        setText('tHexPwdValue', stDevinfo.hexpassword);
        top.Passwordmode=1;
    }

    protectPwdLoidKey();
    
}

function onClickMethod()
{   
    if ((1 == getRadioVal("rMethod")))
    {   
        setDisplay("TrLoid",1);
        setDisplay("TrPasswordEpon",1);
        setDisplay("TrPasswordGpon",0);
		
		setDisplay("TrHexPassword",0);
		setDisplay("TrPasswordmode",0);

        setText("LOIDValue",stDevinfo.loid);
        setText("PwdEponValue",stDevinfo.eponpwd);
        setText("tPwdEponValue",stDevinfo.eponpwd);
        setDisable('SNValue',0);
        top.changeMethod = 1;
        setDisplay("TrSN",0);
    }

    if (2 == getRadioVal("rMethod"))
    {  
		setDisplay("TrLoid",0);
        setDisplay("TrPasswordEpon",0);

		if (curUserType == sptUserType)
		{
			setDisplay("TrSN", 0);
		}
		else
        {
			setDisplay("TrSN", 1);
		}
		
        hexgponpassword = stDevinfo.hexpassword;
        gponpassword = ChangeHextoAscii(stDevinfo.hexpassword);
        refreshPasswordMode();
        if (1 == TelMexFlag)
        {
            setText("SNValue1", conv16to12Sn(stDevinfo.serialnumber.substr(0,8)));
	        setText('SNValue2', stDevinfo.serialnumber.substr(8,8));
        }
        else
        {
            setText('SNValue', stDevinfo.serialnumber);	
        }
        top.changeMethod = 2;
    }

	xgpon_init();
}

function OnChangeMode1()
{
	if(0 == getSelectVal('Passwordmode'))
	{
		setDisplay("TrPasswordGpon",1);
		setDisplay("TrHexPassword",0);		
		getElById("PwdGponValue").value = gponpassword;
		getElById("tPwdGponValue").value = gponpassword;
		top.Passwordmode=0;
	}
    else if(1 == getSelectVal('Passwordmode'))
    {
        setDisplay("TrPasswordGpon",0);
        setDisplay("TrHexPassword",1);
		
        if('1' == t2Flag)
        {
            setText('HexPwdValue', convTo20Bit(hexgponpassword));
            setText('tHexPwdValue', convTo20Bit(hexgponpassword));
        }
        else
        {
            setText('HexPwdValue', hexgponpassword);
            setText('tHexPwdValue', hexgponpassword);
        }
		
        top.Passwordmode=1;
    }
}

function ChangeHextoAscii(hexpasswd)
{
    var str;
	var len = 0;
	
	len = hexpasswd.length;

	if (0 != len%2)
	{
	    hexpasswd += "0";
	}
	
    str = hexpasswd.replace(/[a-f\d]{2}/ig, function(m){
    return String.fromCharCode(parseInt(m, 16));});

    return str;
}

function ChangeAsciitoHex(passwd)
{
    var hexstr = "";
	var temp = "";
	var code = 0;
	for (var i = 0; i < passwd.length; i++)
	{
	     code = parseInt(passwd.charCodeAt(i));
		 if (code < 16)
		 {
		     hexstr += "0";
			 hexstr += code.toString(16);
		 } 
		 else
		 {
		     hexstr += code.toString(16);
		 }
	}
	
	return hexstr;	
}

function CheckHexPassWord()
{
	var ret = true;
    var len = 0;
	var i;
	var temp1 = 0;
	var temp2 = 0;
	with (getElById('ConfigForm'))
	{		
		var hexpassword = getValue('HexPwdValue');
		
		len = hexpassword.length;

        if('1' == t2Flag)
        {
            if( ( (14 != len) && (20 != len) ) || (isHexaNumber(hexpassword) == false) )
            {
                AlertEx(cfg_ontauth_language['amp_hexpaswd_tde2_hex']);
                return false;
            }
        }
        else
        {
    		if (20 < hexpassword.length)
    		{
    			AlertEx(cfg_ontauth_language['amp_hexpaswd_chk1']);
    		    return false;
    		}
    	
    		if (0 != len%2)
    		{
    			AlertEx(cfg_ontauth_language['amp_hexpaswd_chk1']);
    			return false;
    		}

      
    		if (isHexaNumber(hexpassword) == false)
    		{
    			AlertEx(cfg_ontauth_language['amp_hexpaswd_chk2']);
    			return false;
    		}
		}

	}
	return ret;
}

function AddSubmitParam(SubmitForm,type)
{
	getOntOnlineStatus();
	if  (isOntOnline == 1)
	{
	    if(curUserType != sysUserType)
	    {
    		AlertEx(cfg_ontauth_language[ont2onr('amp_ontauth_protectPwdLoidKey')]);
    		return;
		}

		if('1' == t2Flag)
		{
		    return ;
		}
	}
	
    {
    	if(1 == getRadioVal('rMethod'))
		{
			SubmitForm.addParameter('x.X_HW_Loid', getValue('LOIDValue'));
            SubmitForm.addParameter('x.X_HW_EponPwd', getValue('PwdEponValue'));
    	}
        else
        {
        	if (0 == getSelectVal('Passwordmode'))
	        {
	            var password;
	            password = ChangeAsciitoHex(getValue('PwdGponValue'));

	            if(true == isPwdSubmit(password))
	            {
	                SubmitForm.addParameter('x.X_HW_PonHexPassword', password);
	            }
	        }
	        else if (1 == getSelectVal('Passwordmode'))
	        {   
	            if(true == isPwdSubmit(getValue('HexPwdValue')))
	            {
	                SubmitForm.addParameter('x.X_HW_PonHexPassword', getValue('HexPwdValue'));
	            }
	        }

			if (1 == TelMexFlag)
			{
			    var SerialNum = getValue('SNValue1') + getValue('SNValue2');
			    SubmitForm.addParameter('x.X_HW_PonSN', conv12to16HexSn(SerialNum));
			}
			else
			{
			    SubmitForm.addParameter('x.X_HW_PonSN', getValue('SNValue'));
			}
		}
    }
    
	SubmitForm.addParameter('x.X_HW_ForceSet', 1);
	
	if(isGuidePage) { window.parent.wifiPara.wifiFlag = 1; }

	SubmitForm.setAction('set.cgi?' +'x=InternetGatewayDevice.DeviceInfo' 
						+ '&RequestFile=html/amp/ontauth/passwordcommon.asp');
	AddXgponForm(SubmitForm, 'html/amp/ontauth/passwordcommon.asp');
    setDisable('btnApply_ex2',1);
    setDisable('cancelValue2',1);
	SubmitForm.addParameter('x.X_HW_Token', getValue(isGuidePage?'gd_onttoken':'onttoken'));
}

function isHexaNumber(number)
{
    for (var index = 0; index < number.length; index++)
    {
        if (isHexaDigit(number.charAt(index)) == false)
        {
            return false;
        }
    }
    return true;
}

function CheckSN()
{
	var i = 0;
    var SerialNum;

    if (1 == TelMexFlag)
	{
	    SerialNum = getValue('SNValue1') + getValue('SNValue2');
	}
	else
	{
	    SerialNum = getValue('SNValue');
	}

    if (SerialNum == '')
    {
        AlertEx(cfg_ontauth_language['amp_sn_empty']);
        return false;
    }

    if (stDevinfo.devtype != "1" && SerialNum != stDevinfo.serialnumber )
    {
        AlertEx(cfg_ontauth_language['amp_modsn_check']);
        return false;
    }

    if (1 != TelMexFlag)
    {
        if (!((16 == SerialNum.length)||(12 == SerialNum.length)))
        {
            AlertEx(cfg_ontauth_language['amp_sn_check1']);
            return false;
        }
		
        if (16 == SerialNum.length)
        {
            if (isInteger(SerialNum) == false && isHexaNumber(SerialNum) == false)
            {
                AlertEx(cfg_ontauth_language['amp_sn_check1']);
                return false;
            }
        }

        if (12 == SerialNum.length)
        { 
            if (isValidAscii(SerialNum) != '')
            {
                AlertEx(cfg_ontauth_language['amp_sn_check1']);
                return false;
            }
        
            if (last8isHexaNumber(SerialNum) == false)
            {
                AlertEx(cfg_ontauth_language['amp_sn_check1']);
                return false;
            }  
        }
    }
    else
    {
        if(12 != SerialNum.length)
        {
            AlertEx(cfg_ontauth_language['amp_sn_check2']);
            return false;
        }
		
        for (i=0; i<4; i++)
        {
            if (!((SerialNum.charAt(i) >= 'A') && (SerialNum.charAt(i)<= 'Z')))
            {
                AlertEx(cfg_ontauth_language['amp_sn_check3']);
                return false;
            }
        }
		
        if ((isInteger(SerialNum.substr(4,8)) == false)
         && (isHexaNumber(SerialNum.substr(4,8)) == false))
        {
            AlertEx(cfg_ontauth_language['amp_sn_check2']);
            return false;
        }
    }
	
    return true;
}

function ChangePWforSingtel()
{   
	var inputTest=document.getElementById("RegisterId");
    inputTest.maxLength=10;	
    inputTest=document.getElementById("tRegisterId");
    inputTest.maxLength=10;
	inputTest.style.display = "inline";
}

function init()
{   
    protectPwdLoidKey();

    hexgponpassword = stDevinfo.hexpassword;
    gponpassword = ChangeHextoAscii(stDevinfo.hexpassword);
	
	if ((1 == NCFlag) || (1 == StarhubncFlag) || ('1' == bztlfFlag))
	{
		top.Passwordmode = 0; 
	}

	if('1' == hexPwdDefualtFlag)
	{
	    top.Passwordmode = 1; 
	}

    if(1 == BytelFlag)
	{
	   top.Passwordmode = 1;
	}
	
    if (stDevinfo != null)
    {
		password = ChangeHextoAscii(stDevinfo.hexpassword);
			

        getElById("PwdGponValue").value = password;
        getElById("tPwdGponValue").value = password;
        setText('HexPwdValue', stDevinfo.hexpassword); 
        setText('tHexPwdValue', stDevinfo.hexpassword);

		setText('LOIDValue', stDevinfo.loid);
		setText('PwdEponValue', stDevinfo.eponpwd);
        setText('tPwdEponValue', stDevinfo.eponpwd);
            
        if (1 == TelMexFlag)
        {
            setText("SNValue1", conv16to12Sn(stDevinfo.serialnumber.substr(0,8)));
	        setText('SNValue2', stDevinfo.serialnumber.substr(8,8));
        }
        else
        {
            setText('SNValue', stDevinfo.serialnumber);	
        }        
    }
    if (true != telmexSpan)
    {
        SetDivValue("tb_top_content", cfg_ontauth_language[ont2onr('amp_auth_title')]);
    }
    else
    {
        SetDivValue("tb_top_content", cfg_ontauth_language['amp_auth_title_telmex']);
    }
    
    if(stDevinfo.devtype == "1")
    {

        {   
			setDisplay("TrPasswordmode",1);
			setDisplay("TrSN",1);

			if (0 == top.Passwordmode)
			{
				setDisplay("TrPasswordGpon",1);
				setDisplay("TrHexPassword",0);
				
				getElById("PwdGponValue").value = ChangeHextoAscii(stDevinfo.hexpassword);
				getElById("tPwdGponValue").value = ChangeHextoAscii(stDevinfo.hexpassword);
				setSelect("Passwordmode",0);
			}
			else
			{
				setDisplay("TrPasswordGpon",0);
				setDisplay("TrHexPassword",1);
				setText('HexPwdValue', stDevinfo.hexpassword);	
				setText('tHexPwdValue', stDevinfo.hexpassword);	
				setSelect("Passwordmode",1);
			}

	        if(curUserType == sysUserType)
	        {
	           setDisplay("TrSN",1);
	        }
	        else
	        {
	           setDisplay("TrSN",0);
	        }
        }
		
        if (1 == TelMexFlag)
		{
            setText("SNValue1", conv16to12Sn(stDevinfo.serialnumber.substr(0,8)));
	        setText('SNValue2', stDevinfo.serialnumber.substr(8,8));
		}
		else
		{
		    setText("SNValue",stDevinfo.serialnumber);
		}
		
    }
	
    if (1 == PtvdfFlag)
    {
        setDisplay('tPwdGponValue', 0);
        setDisplay('tHexPwdValue', 0);
        setDisplay('hidePwdGponValue', 0);
        setDisplay('hideHexPwdValue', 0);
        if ((1 == OnlinedFlag) && (curUserType != sysUserType))
        {
            setDisplay('TblPwd', 0);
			setDisplay('TblApplySN', 0);
            SetDivValue("tb_top_content", cfg_ontauth_language['amp_onlineauth_title']);
        }
    }

	if ((1 == NCFlag) || (1 == StarhubncFlag))
	{
		setDisable("Passwordmode",1); 
		setDisable("hidePwdGponValue",1); 
		setDisable("hideHexPwdValue",1); 
	}

    if (1 == FobidSnFlag)
    {
    		setDisable('SNValue', 1);
    }

    if (1 == <%HW_WEB_GetFeatureSupport(AMP_FT_SN_HIDDEN);%>)
    {
    	setDisplay("TrSN", 0);
    }

    if (1 == StarhubncFlag)
	{
		setDisable("SNValue", 1);
	}

    if ((CfgMode.toUpperCase() == 'ANTEL') && (curUserType == instalUserType))
    {
        setDisplay("TrPasswordmode", 0);
        setDisplay("TrSN",1);
        setDisable('PwdGponValue', 0);
        setDisable('tPwdGponValue', 0);
        setDisable("SNValue", 1);
        setDisable('btnApply_ex2', 0);
        setDisable('cancelValue2', 0);
    }
    
	if(IsLogicIDSupport())
	{
		setRadio("rMethod", top.changeMethod);
        onClickMethod();
	}
	else
	{ 
    	setDisplay("TrSelectMethod",0);
		setDisplay("TrLoid",0);
        setDisplay("TrPasswordEpon",0);
        
        refreshPasswordMode();
	}

    if('1' == t2Flag)
    {
        setDisplay('HexPwdValue', 0);
        setDisplay('tHexPwdValue', 1);
        $("#hideHexPwdValue").attr("checked", false);

        setDisplay('PwdGponValue', 0);
        setDisplay('tPwdGponValue', 1);
        $("#hidePwdGponValue").attr("checked", false);

        setText("HexPwdValue", stDevinfo.hexpassword);
        setText("tHexPwdValue", stDevinfo.hexpassword);

        if(stOnlineStatusInfo == "1")
        {
            setDisable('PwdGponValue', 1);
            setDisable('tPwdGponValue', 1);
            setDisable('HexPwdValue', 1);
            setDisable('tHexPwdValue', 1);
            setDisable('SNValue', 1);

            setDisable('btnApply_ex2', 1);
            setDisable('cancelValue2', 1);

            setDisplay('TblApplySN', 0);
        }
    }

    if (1 == '<%HW_WEB_GetFeatureSupport(FT_FEATURE_SINGTEL);%>')
    {
        setDisplay("TrPasswordmode",0);
        ChangePWforSingtel();
        setDisplay("PwdGponValue",0);
		setDisplay("tPwdGponValue",1);
		setDisplay("hidePwdGponValue",0);
		
		setDisplay("RegisterId",0);
		setDisplay("tRegisterId",1);
		setDisplay("hideRegisterId",0);
		setDisplay("reddot",1);
		setDisplay("reddotGpon",1);
    }    
    else
	{
	   setDisplay("reddot",0);
	   setDisplay("reddotGpon",0);
	}
    
    if ('1' == bztlfFlag)
    {
        setDisplay("TrPasswordmode", 0);        
    }
    
    if ((1 == AtTelecomFlag) && (curUserType == sptUserType))
    {
        setDisable("Passwordmode", 1);
        setDisable("hidePwdGponValue", 1);
        setDisable("hideHexPwdValue", 1);

        setDisable('PwdGponValue', 1);
        setDisable('tPwdGponValue', 1);
        setDisable('HexPwdValue', 1);
        setDisable('tHexPwdValue', 1);
        setDisable('btnApply_ex2', 1);
        setDisable('cancelValue2', 1);
    }
    
  	xgpon_init();
}

function CancelConfig()
{
    init();
}

function protectPwdLoidKey()
{
    if ((stOnlineStatusInfo == "1") && (curUserType != sysUserType))
    {
    	setDisable('LOIDValue', 1);
        setDisable('PwdEponValue', 1);
        setDisable('tPwdEponValue', 1);
        setDisable('PwdGponValue', 1);
        setDisable('tPwdGponValue', 1);
        setDisable('HexPwdValue', 1);
        setDisable('tHexPwdValue', 1);
        setDisable('btnApply_ex2', 1);
        setDisable('cancelValue2', 1);
    }
    else
    {
    	setDisable('LOIDValue', 0);
        setDisable('PwdEponValue', 0);
        setDisable('tPwdEponValue', 0);
        setDisable('PwdGponValue', 0);
        setDisable('tPwdGponValue', 0);
        setDisable('HexPwdValue', 0);
        setDisable('tHexPwdValue', 0);
        setDisable('btnApply_ex2', 0);
        setDisable('cancelValue2', 0);        
    }
}

function getOntOnlineStatus()
{
  $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "ontOnlineStatus.asp",
            success : function(data) {
               	isOntOnline = data;
            }
        });
}

function LoadGuidePage()
{
	$('body').css({'background-color': '#ffffff', 'margin': '35px 0px 0px 0px', 'height': '400px'});
	
	setDisplay("tb_toptitle", 0);
	setDisplay("tb_top_content", 0);
	setDisplay("TblApplySN", 0);
    setDisplay("tr_guide_apply", 1);
	
	$("td:nth-child(1)").addClass("tb_label");
	
	$("select").addClass("tb_input");
	$("select").css({"height": "34px", "width": "233px"});

	$("#tb_form").css({"table-layout": "fixed", "margin-left": "200px"});
	
	$("#tb_form").attr("cellpadding", "5");
	
	$(":text").addClass("tb_input");
	$(":checkbox").css({"margin-right": "-2px"});
	$(":password").addClass("tb_input");

	$("#a_skip").width($("#span_skip").width());

	$(".gray").css({"font-size":"13px"});
	
	$("#tr_guide_apply input").removeClass("tb_input");
	
	$('input').css('line-height', '32px');
	
	document.documentElement.style.overflow='auto';

	$("#tb_form tr td:nth-child(1)").css({"width":"150px"});
	$("#tb_form tr td:nth-child(2)").css({"width":"235px"});
	$("#tb_form tr td:nth-child(3)").css({"width":"600px", "font-size":"13px"});
	
}

function LoadCommonPage()
{
	$("#ConfigForm").addClass("configborder");
	$("#tb_form").addClass("tabal_noborder_bg");
	$("#tb_form").attr("width", "100%");
	
	$("#tb_form tr td:nth-child(1)").addClass("table_title");
	$("#tb_form tr td:nth-child(1)").addClass("width_per20");
	$("#tb_form tr td:nth-child(1)").css({"line-height":"18px"});
	$("#tb_form tr td:nth-child(2)").addClass("table_right");
	$("#tb_form tr td:nth-child(3)").addClass("table_right");
	$("#tb_form tr td:nth-child(3)").addClass("td3");

	$("#TrTdSelectMethod").attr("colspan", "2");
	$("#TrTdPasswordmode").attr("colspan", "2");
	$("#TrTdMutualAuth").attr("colspan", "2");
}

function LoadFrame()
{
    init();
	
	if(1 == OntAuthentication)
	{
		setDisable('Passwordmode',1);
		setDisable('PwdGponValue',1);
		setDisable('hidePwdGponValue',1);
		setDisable('SNValue1',1);
		setDisable('SNValue2',1);
		setDisable('btnApply_ex2',1);
		setDisable('cancelValue2',1);
	}
	
	if(1 == BytelFlag)
	{   
	    setDisable("Passwordmode", 1);
        setDisable("hidePwdGponValue", 1);
        setDisable("hideHexPwdValue", 1);

        setDisable('PwdGponValue', 1);
        setDisable('tPwdGponValue', 1);
        setDisable('HexPwdValue', 1);
        setDisable('tHexPwdValue', 1);
        setDisable('btnApply_ex2', 1);
        setDisable('cancelValue2', 1);
	    setDisable("SNValue", 1);
		setDisable('SNValue1',1);
		setDisable('SNValue2',1);

	}
	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		b.innerHTML = cfg_ontauth_language[ont2onr(b.getAttribute("BindText"))];
	}
	
	if(isGuidePage)
	{
		LoadGuidePage();
	}
	else
	{
		LoadCommonPage();
	}
}

</script>

<style type="text/css">
    .tb_label
    {
        font-size: 16px;
        color: #666666;
		width: 90px;
    }
	.tb_input
	{
		-webkit-border-radius: 4px;
		-moz-border-radius: 4px;
		border-radius: 4px;
		border: 1px solid #CECACA;
		vertical-align: middle;
		font-size: 16px;
		height: 32px;
		width: 228px;
		padding-left: 5px;
		line-height: 32px;
		background-color: #ffffff;
	}

	.td3{
		width: 666px;
		color: #666666;
		font-size: 13px;
		line-height: normal;
	}

</style>
</head>
<body  class="mainbody" onLoad="LoadFrame();">

<script language="JavaScript" type="text/javascript">

if(!isGuidePage)
{
	HWCreatePageHeadInfo("tb_top", 
		GetDescFormArrayById(cfg_ontauth_language, ont2onr('amp_auth_title_head')), 
		GetDescFormArrayById(cfg_ontauth_language, ont2onr("amp_auth_title")), false);

	document.write('<div class="title_spread"></div>');
}

</script>

<table id="TblPwd" width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td> <form id="ConfigForm" action="">
        <table id="tb_form" border="0" cellpadding="0" cellspacing="1">

        <tr id="TrSelectMethod"> 
            <td BindText='amp_auth_mode'></td>
            <td id="TrTdSelectMethod" > 
            	<div style="display:inline"><input name="rMethod" id="rMethod" type="radio" value="1" checked="checked" onclick="onClickMethod()"/>
              		LOID </div>
            	<div style="display:inline; margin-left:60px;"><input name="rMethod" id="rMethod" type="radio"  value="2"  onclick="onClickMethod()" />
              		Password </div>
            </td>
            <script>
                    if((top.changeMethod !=1) && (top.changeMethod != 2) && (IsLogicIDSupport() == false))
                    {   
                    	setRadio("rMethod",2);
                    	top.changeMethod = 2;
                    }
                    else
                    {    
                        setRadio("rMethod", top.changeMethod);
                    }
            </script>
        </tr>

          <tr id="TrLoid"> 
            <td BindText='amp_scenario_loid'></td>
            <td > <input type="text" name="LOIDValue" id="LOIDValue"  maxlength="24"> </td>
			<td BindText='amp_loid_note'></td>
          </tr>
          
          <tr id="TrPasswordEpon"> 
            <td><script>
                if ('1' == LoidCommon){document.write(cfg_ontauth_language['amp_pass_word_common']);} else{document.write(cfg_ontauth_language['amp_pass_word']);}
            </script></td>
            <td>
              <input name="PwdEponValue" type="password" id="PwdEponValue" maxlength="12" onchange="eponpassword=getValue('PwdEponValue');getElById('tPwdEponValue').value = eponpassword;"/> 
              <input name="tPwdEponValue" type="text" id="tPwdEponValue" maxlength="12" style="display:none" onchange="eponpassword=getValue('tPwdEponValue');getElById('PwdEponValue').value = eponpassword;"/> 
            </td>
            <td>
    		  <input checked type="checkbox" id="hidePwdEponValue" name="hidePwdEponValue" value="on" onClick="ShowOrHideText('hidePwdEponValue', 'PwdEponValue', 'tPwdEponValue', eponpassword);" style="margin-right:-2px"/> 
    			  <script>
    			  	document.write(cfg_ontauth_language['amp_password_hide']);
    			  	document.write(cfg_ontauth_language['amp_passwd_note1']);
    			  </script>
            </td>
          </tr>
          
          <tr id="TrPasswordmode"> 
            <td BindText='amp_passwd_mode'></td>
            <td id="TrTdPasswordmode"> <select name="Passwordmode" size="1" id="Passwordmode" onChange="OnChangeMode1()">
                <option value="0" selected="selected"> 
                <script>
                if (true != telmexSpan)
	        	{   
                    document.write(cfg_ontauth_language['amp_char_mode']);
                }
                else
                {
                    document.write(cfg_ontauth_language['amp_char_mode_telmex']);
                }
                </script>
                </option>
                <option value="1"> 
                <script>document.write(cfg_ontauth_language['amp_hex_mode']);</script>
                </option>
              </select></td>
          </tr>
          <tr id="TrPasswordGpon"> 
            <td BindText='amp_pass_word'></td>
            <td> <input name="PwdGponValue" type="password" id="PwdGponValue" maxlength="10" onchange="gponpassword=getValue('PwdGponValue'); getElById('tPwdGponValue').value = gponpassword;hexgponpassword = ChangeAsciitoHex(gponpassword); getElById('tHexPwdValue').value = hexgponpassword; getElById('HexPwdValue').value = hexgponpassword;"/> 
              <input name="tPwdGponValue" type="text" id="tPwdGponValue" maxlength="10" style="display:none" onchange="gponpassword=getValue('tPwdGponValue');getElById('PwdGponValue').value = gponpassword;hexgponpassword = ChangeAsciitoHex(gponpassword);getElById('tHexPwdValue').value = hexgponpassword;getElById('HexPwdValue').value = hexgponpassword;"/> 
            </td>
              <td>
	              <input checked type="checkbox" id="hidePwdGponValue" name="hidePwdGponValue" value="on" onClick="ShowOrHideText('hidePwdGponValue', 'PwdGponValue', 'tPwdGponValue', gponpassword);" /> 
				  <font id= "reddotGpon" style="color: red;">*</font>	
				  <script>
	              if ((1 != PtvdfFlag)&&(1 != SingtelFlag))
	              {
	                  document.write(cfg_ontauth_language['amp_password_hide']);
	              } 
	              
				  if('1' == t2Flag)
	              {
	                document.write(cfg_ontauth_language['amp_passwd_t2_note_char']);
	              }
                  else if ('1' == bztlfFlag)
                  {
                    document.write(cfg_ontauth_language['amp_passwd_bztlf_note_char']);
                  }
	              else
	              {
	                document.write(cfg_ontauth_language['amp_passwd_note2']);
	              }
	              </script>
              </td>
          </tr>
          <tr id="TrHexPassword"> 
            <td BindText='amp_pass_word'></td>
            <td> <input name="HexPwdValue" type="password" id="HexPwdValue" maxlength="20" onchange="hexgponpassword=getValue('HexPwdValue');getElById('tHexPwdValue').value = hexgponpassword;gponpassword = ChangeHextoAscii(hexgponpassword);getElById('PwdGponValue').value = gponpassword;getElById('tPwdGponValue').value = gponpassword;"/> 
              <input name="tHexPwdValue" type="text" id="tHexPwdValue" maxlength="20"  style="display:none" onchange="hexgponpassword=getValue('tHexPwdValue');getElById('HexPwdValue').value = hexgponpassword;gponpassword = ChangeHextoAscii(hexgponpassword);getElById('PwdGponValue').value = gponpassword;getElById('tPwdGponValue').value = gponpassword;"/> 
           </td>
              <td>
	              <input checked type="checkbox" id="hideHexPwdValue" name="hideHexPwdValue" value="on" onClick="ShowOrHideText('hideHexPwdValue', 'HexPwdValue', 'tHexPwdValue', hexgponpassword);" /> 
	              <script>
	              if (1 != PtvdfFlag)
	              {
	                  document.write(cfg_ontauth_language['amp_password_hide']);
	              }
	              
	              if('1' == t2Flag)
	              {
	                document.write(cfg_ontauth_language['amp_passwd_t2_note_hex']);
	              }
	              else
	              {
	                document.write(cfg_ontauth_language['amp_passwd_note3']);
	              }
	              </script>
              </td>
          </tr>
          <tr id="TrMutualAuth" style="display:none"> 
            <td BindText='amp_mutual_auth'></td>
            <td id="TrTdMutualAuth"><input checked type="checkbox" id="MutualAuth" name="MutualAuth" value="on" onClick="onMutualAuthSwitch()"/> 
          </tr>
		  <tr id="TrRegisterId" style="display:none"> 
            <td BindText='amp_pass_word'></td>
            <td> <input name="RegisterId" type="password" id="RegisterId" maxlength="36" onchange="xgponregisterid=getValue('RegisterId');getElById('tRegisterId').value = xgponregisterid;"/> 
              <input name="tRegisterId" type="text" id="tRegisterId" maxlength="36"  style="display:none" onchange="xgponregisterid=getValue('tRegisterId');getElById('RegisterId').value = xgponregisterid;"/> 
            </td>
              <td>
              	<input checked type="checkbox" id="hideRegisterId" name="hideRegisterId" value="on" onClick="ShowOrHideText('hideRegisterId', 'RegisterId', 'tRegisterId', xgponregisterid);" />
                <font id= "reddot" style="color: red;">*</font>				
	              <script>
				  if(1 != SingtelFlag)
				  {
				    document.write(cfg_ontauth_language['amp_password_hide']);
				  }
				  
				  document.write(cfg_ontauth_language[ont2onr('amp_registerid_note')]);
				  </script>
              </td>
          </tr>
		  <tr id="TrPSK" style="display:none"> 
            <td BindText='amp_pass_word'></td>
            <td> <input name="Psk" type="password" id="Psk" maxlength="16" onchange="xgponpsk=getValue('Psk');getElById('tPsk').value = xgponpsk;"/> 
              <input name="tPsk" type="text" id="tPsk" maxlength="16"  style="display:none" onchange="xgponpsk=getValue('tPsk');getElById('Psk').value = xgponpsk;"/> 
            </td>
              <td>
              	 <input checked type="checkbox" id="hidePsk" name="hidePsk" value="on" onClick="ShowOrHideText('hidePsk', 'Psk', 'tPsk', xgponpsk);"/>
	              <script>document.write(cfg_ontauth_language['amp_password_hide']);
				  document.write(cfg_ontauth_language[ont2onr('amp_psk_note')]);</script>
              </td>
          </tr>		  
          <tr  id="TrSN"> 
            <td><script>document.write(cfg_ontauth_language['amp_scenario_sn']);</script></td>
            <td > <script>
              if(1 == TelMexFlag)
              {
            	  document.write('<input type="text" name="SNValue1" id="SNValue1"  maxlength="4" style="width:50px">');
                  document.write('<input type="text" name="SNValue2" id="SNValue2"  maxlength="8" style="width:68px">');                
              }
              else
              {
            	  document.write('<input type="text" name="SNValue" id="SNValue"  maxlength="16" >');                
              }
              </script></td>
              <td>
              	<font style="color: red;">*</font>
	              <script>
				  if(1 == TelMexFlag)
				  {
				  		document.write(cfg_ontauth_language['amp_telmexsn_note']);
				  }
				  else
				  {
				  		document.write(cfg_ontauth_language['amp_passwd_note4']);
				  }
				  </script>
              </td>
          </tr>
		  <tr id="tr_guide_apply" style="display:none;">
			<td></td>
			<td colspan="2" style="padding-top: 20px;">
				<input type="hidden" name="gd_onttoken" id="gd_hwonttoken" value="<%HW_WEB_GetToken();%>">
				
				<input id="pre" type="button" class="CancleButtonCss buttonwidth_100px" style="margin-left:0px;" onClick="if (true == logo_singtel && TypeWord_com != 'COMMON'){window.parent.location.href='../../ssmp/cfgguide/guideindex_singtel.asp';}else{window.parent.location.href='../../ssmp/cfgguide/guideindex.asp';}">
					<script>getElById('pre').value = cfg_ontauth_language['amp_wifiguide_prestep'];</script>
				</input>
				
				<input id="guidewancfg" type="button" name="../../html/bbsp/wan/wan.asp?cfgguide=1" class="ApplyButtoncss buttonwidth_100px" onClick="Submit();">
					<script>getElById('guidewancfg').value = cfg_ontauth_language['amp_wifiguide_nextstep'];</script>
				</input>

				<a id="a_skip" href="#" style="display: block;margin-left: 250px;margin-top: -27px;font-size:16px;text-decoration: none;color: #666666;" onclick="window.parent.onchangestep(window.parent.wifiPara);">
					<span id="span_skip"><script>document.write(cfg_ontauth_language['amp_wifiguide_skip']);</script></span>
				</a>
			</td>
	    </tr>
        </table>
        
      </form></td>
  </tr>
</table>

 <table id="TblApplySN" width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
      <tr> 
          <td class="table_submit width_per20"></td>
          <td class="table_submit width_per80"> 
		  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		  <button name="btnApply_ex2" id="btnApply_ex2" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="Submit();"><script>document.write(cfg_ontauth_language['amp_ontauth_apply']);</script></button>
            <button name="cancelValue2" id="cancelValue2" type="button" class="CancleButtonCss buttonwidth_100px" style="margin-left:6px;" onClick="CancelConfig();"><script>document.write(cfg_ontauth_language['amp_ontauth_cancel']);</script></button>
          </td>
      </tr>
 </table>
     
</body>
</html>

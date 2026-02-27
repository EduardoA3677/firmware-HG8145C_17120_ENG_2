<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="Cuscss/<%HW_WEB_GetCusSource(login.css);%>"  media="all" rel="stylesheet" />
<style type="text/css">
#first{
	background-color:white;
	height:25px;
	text-align: center;
	color: red;
	position:absolute;
	width: 380px;
	top: 312px;
}
</style>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
<script language="JavaScript" type="text/javascript">
function MD5(str) { return hex_md5(str); }

var FailStat ='<%HW_WEB_GetLoginFailStat();%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var LoginTimes = '<%HW_WEB_GetLoginFailCount();%>';
var ModeCheckTimes = '<%HW_WEB_GetModPwdFailCnt();%>';
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Var_LastLoginLang = '<%HW_WEB_GetLoginRequestLangue();%>';
var LockTime = '<%HW_WEB_GetLockTime();%>';
var LockLeftTime = '<%HW_WEB_GetLeftLockTime();%>';
var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';
var errVerificationCode = '<%HW_WEB_GetCheckCodeResult();%>';
var Language = '';
var locklefttimerhandle;
var SonetFlag = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SONET);%>'; 
var IsPTVDF = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_PTVDF);%>';

if(Var_LastLoginLang == '')
{
	Language = Var_DefaultLang;
}
else
{
	Language = Var_LastLoginLang;
}

if ('ORO' == CfgMode.toUpperCase())
{
	ProductName = "Internet Box 1000";
}
document.title = ProductName;

function getValue(sId)
{
	var item;
	if (null == (item = getElement(sId)))
	{
		debug(sId + " is not existed" );
		return -1;
	}

	return item.value;
}

function showlefttime()
{
	if(LockLeftTime <= 0)
	{
		window.location="/login.asp";
		return;
	}

	if(LockLeftTime == 1)
	{
		if(Language == 'portuguese')
		{
			if(1 == IsPTVDF)
			{
				var errhtml = 'Demasiadas tentativas, volte a tentar daqui a ' +  LockLeftTime + ' segundo';
			}
			else
			{
				var errhtml = 'Demasiadas tentativas, tente ' +  LockLeftTime + ' segundos mais tarde';
			}
		}
		else if(Language == 'japanese')
		{
			var errhtml = '再試行回数が多すぎます。' +  LockLeftTime + '秒後に再試行してください。';
		}
		else if(Language == 'spanish')
		{
			var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' +  LockLeftTime + ' segundo/s.';
		}
		else if(Language == 'russian')
		{
			var errhtml = 'Слишком много попыток. Попробуйте снова через ' +  LockLeftTime + ' с.';
		}
		else
		{
			if(1 == IsPTVDF)
			{
				var errhtml = 'Too many retries, please retry in ' +  LockLeftTime + ' second.';
			}
			else
			{
				var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' second later.';
			}
		}
	}
	else
	{
		if(Language == 'portuguese')
		{
			if(1 == IsPTVDF)
			{
				var errhtml = 'Demasiadas tentativas, volte a tentar daqui a ' +  LockLeftTime + ' segundos';
			}
			else
			{
				var errhtml = 'Demasiadas tentativas, tente ' +  LockLeftTime + ' segundos mais tarde.';
			}
		}
		else if(Language == 'japanese')
		{
			var errhtml = '再試行回数が多すぎます。' +  LockLeftTime + '秒後に再試行してください。';
		}
		else if(Language == 'spanish')
		{
			var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' +  LockLeftTime + ' segundos.';
		}
		else if(Language == 'russian')
		{
			var errhtml = 'Слишком много попыток. Попробуйте снова через ' +  LockLeftTime + ' с.';
		}
		else
		{
			if(1 == IsPTVDF)
			{
				var errhtml = 'Too many retries, please retry in ' +  LockLeftTime + ' seconds.';
			}
			else
			{
				var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
			}
		}
	}

	SetDivValue("DivErrPage", errhtml);
	LockLeftTime = LockLeftTime - 1;
}

function setErrorStatus()
{
	clearInterval(locklefttimerhandle);
	if('1' == FailStat || (ModeCheckTimes >= errloginlockNum))
	{

		if(Language == 'portuguese')
		{
			var errhtml = "Demasiadas tentativas.";
		}
		else if(Language == 'japanese')
		{
			var errhtml = "再試行回数が多すぎます。";
		}
		else if(Language == 'spanish')
		{
			var errhtml = "Ha intentado muchas veces.";
		}
		else if(Language == 'russian')
		{
			var errhtml = 'Слишком много попыток.';
		}
		else
		{
			var errhtml = 'Too many retrials.';
		}
		SetDivValue("DivErrPage", errhtml);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
		if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase())
		{
			setDisable('VerificationCode',1);
			setDisable('tripletbtn',1);
		}
		setDisable('button',1);
	}
	else if(LoginTimes >= errloginlockNum && parseInt(LockLeftTime) > 0)
	{
		if(Language == 'portuguese')
		{
			if(1 == IsPTVDF)
			{
				var errhtml = 'Demasiadas tentativas, volte a tentar daqui a ' +  LockLeftTime + ' segundos';
			}
			else
			{
				var errhtml = 'Demasiadas tentativas, tente ' +  LockLeftTime + ' segundos mais tarde.';
			}
		}
		else if(Language == 'japanese')
		{
			var errhtml = '再試行回数が多すぎます。' +  LockLeftTime + ' 秒後に再試行してください。';
		}
		else if(Language == 'spanish')
		{
			var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' +  LockLeftTime + ' segundos.';
		}
		else if(Language == 'russian')
		{
			var errhtml = 'Слишком много попыток. Попробуйте снова через ' +  LockLeftTime + ' с.';
		}
		else
		{
			if(1 == IsPTVDF)
			{
				var errhtml = 'Too many retries, please retry in ' +  LockLeftTime + ' seconds.';
			}
			else
			{
				var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
			}
		}

		SetDivValue("DivErrPage", errhtml);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
		if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase())
		{
			setDisable('VerificationCode',1);
			setDisable('tripletbtn',1);
		}
		setDisable('button',1);
		locklefttimerhandle = setInterval('showlefttime()', 1000);
	}
	else if( 1== errVerificationCode)
	{
		SetDivValue("DivErrPage", "Incorrect validate code.");
	}
	else if( 2== errVerificationCode)
	{
		SetDivValue("DivErrPage", "Login failure.");
	}
	else if((LoginTimes > 0) && (LoginTimes < errloginlockNum))
	{
		if(Language == 'portuguese')
		{
			var errhtml = "Nome de conta ou palavra-passe inválidos. Tente novamente.";
		}
		else if(Language == 'japanese')
		{
			var errhtml = "アカウントとパスワードの組み合わせが不正確です。 もう一度やり直してください。";
		}
		else if(Language == 'spanish')
		{
			var errhtml = "La combinación de la usuario/contraseña es incorrecta. Favor de volver a intentarlo.";
		}
		else if(Language == 'russian')
		{
			var errhtml = 'Неверное имя аккаунта или пароль. Повторите попытку.';
		}
		else if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase())
		{
			var errhtml = 'Login failure.';
		}
		else
		{
			var errhtml = 'Incorrect account/password combination. Please try again.';
		}

		SetDivValue("DivErrPage", errhtml);
	}
	else
	{
		document.getElementById('loginfail').style.display = 'none';
	}
}


function SubmitForm() {
	var Username = document.getElementById('txt_Username');
	var Password = document.getElementById('txt_Password');
	var appName = navigator.appName;
	var version = navigator.appVersion;

	if(Language == "portuguese")
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("Versões IE inferiores a 6.0 não são compatíveis.");
				return false;
			}
		}

		if (Username.value == "") {
			alert("Conta não pode ficar em branco.");
			Username.focus();
			return false;
		}

		if (Password.value == "") {
			alert("Palavra-passe não pode ficar em branco.");
			Password.focus();
			return false;
		}

	}
	else if(Language == "japanese")
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("6.0以前のIEバージョンには対応していません。");
				return false;
			}
		}

		if (Username.value == "") {
			alert("アカウントは必須項目です。");
			Username.focus();
			return false;
		}

		if (Password.value == "") {
			alert("パスワードは必須項目です。");
			Password.focus();
			return false;
		}

	}
	else if(Language == "spanish")
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("No se puede soportar la versión de IE inferior a la 6.0.");
				return false;
			}
		}

		if (Username.value == "") {
			alert("La usuario es un campo obligatorio.");
			Username.focus();
			return false;
		}

		if (Password.value == "")
		{
			alert("La contraseña es un campo requerido.");
			Password.focus();
			return false;
		}
	}
	else if(Language == "russian")
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("Версии браузера IE меньше 6.0 не поддерживаются.");
				return false;
			}
		}
		
		if (Username.value == "") {
			alert("Введите имя аккаунта.");
			Username.focus();
        	return false;
		}
		
	
		if (Password.value == "") {
			alert("Введите пароль.");
			Password.focus();
        	return false;
		}
	}
	else
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("We cannot support the IE version which is lower than 6.0.");
				return false;
			}
		}

		if (Username.value == "") {
			if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase())
			{
				alert("User Name is a required field.");
			}
			else
			{
				alert("Account is a required field.");
			}
			Username.focus();
			return false;
		}

		if (Password.value == "") {
			alert("Password is a required field.");
			Password.focus();
			return false;
		}

	}

	var cookie = document.cookie;
	if ("" != cookie)
	{
		var date=new Date();
		date.setTime(date.getTime()-10000);
		var cookie22 = cookie + ";expires=" + date.toGMTString();
		document.cookie=cookie22;
	}

	var cnt;

	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/asp/GetRandCount.asp',
		success : function(data) {
			cnt = data;
		}
		});

	var Form = new webSubmitForm();
	if('DT' == CfgMode.toUpperCase())
	{
		var cookie2 = "Cookie=" + "rid=" + RndSecurityFormat("" + cnt) + RndSecurityFormat(Username.value + cnt ) + RndSecurityFormat(RndSecurityFormat(MD5(Password.value)) + cnt) + ":" + "Language:" + Language + ":" +"id=-1;path=/";
	}
	else
	{
		var cookie2 = "Cookie=body:" + "Language:" + Language + ":" + "id=-1;path=/";
		Form.addParameter('UserName', Username.value);
		Form.addParameter('PassWord', base64encode(Password.value));
	}
	
	document.cookie = cookie2;
	Username.disabled = true;
	Password.disabled = true;

	if('TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase())
	{
		Form.addParameter('CheckCode', getValue('VerificationCode'));
		Form.setAction('login.cgi?' +'&CheckCodeErrFile=login.asp');
	}
	else
	{
		Form.setAction('/login.cgi');
	}
	Form.addParameter('x.X_HW_Token', cnt);
	Form.submit();
	return true;
}

function LoadFrame() 
{
	document.getElementById('txt_Username').focus();
	clearInterval(locklefttimerhandle);

	var UserLeveladmin = '<%HW_WEB_CheckUserInfo();%>';

	if(Language == "portuguese")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Conta';
		document.getElementById('Password').innerHTML = 'Palavra-passe';
		document.getElementById('button').innerHTML = 'Iniciar sessão';
		document.getElementById('footer').innerHTML = 'Copyright © Huawei Technologies Co., Ltd 2009-2017. Todos os direitos reservados.';
	}
	else if(Language == "japanese")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'アカウント';
		document.getElementById('Password').innerHTML = 'パスワード';
		document.getElementById('button').innerHTML = 'ログイン';
		document.getElementById('footer').innerHTML = 'Copyright © Huawei Technologies Co., Ltd 2009-2017. All rights reserved.';
	}
	else if(Language == "spanish")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Usuario';
		document.getElementById('Password').innerHTML = 'Contraseña';
		document.getElementById('button').innerHTML = 'Iniciar sesión';
		document.getElementById('footer').innerHTML = 'Copyright © Tecnologias Huawei Co., Ltd 2009-2017. Todos los derechos reservados.';
	}
	else if(Language == "russian")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
        document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Аккаунт';
		document.getElementById('Password').innerHTML = 'Пароль';
		document.getElementById('button').innerHTML = 'Вход';
		document.getElementById('footer').innerHTML = 'Copyright © Huawei Technologies Co., Ltd 2009-2017. Все права защищены.';
    }	
	else
	{
		document.getElementById('Specical_language').style.color = '#434343';
		document.getElementById('English').style.color = '#9b0000';
		if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase())
		{
			document.getElementById('account').innerHTML = 'User Name';
		}
		else
		{
			document.getElementById('account').innerHTML = 'Account';
		}
		document.getElementById('Password').innerHTML = 'Password';
		document.getElementById('button').innerHTML = 'Login';
		document.getElementById('footer').innerHTML = 'Copyright © Huawei Technologies Co., Ltd 2009-2017. All rights reserved';
	}

	if ((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0)) {
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
	if( "1" == FailStat || (ModeCheckTimes >= errloginlockNum))
	{
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
	init();
	
	if('VIETTEL' == CfgMode.toUpperCase())
	{
		var tiphtml = 'Tên truy nhập và mật khẩu của quý khách được in ở mặt đáy thiết bị ONT';
		SetDivValue("DivTipPage", tiphtml);
		document.getElementById('tipText').style.display = '';
	}
	
	if((UserLeveladmin == '0'))
	{
		if(Language == "portuguese")
		{
			alert("O administrador não tem autorização para abrir esta página de Internet.");
			return false;
		}
		else if(Language == "japanese")
		{
			alert("管理者はこのウェブページの閲覧を許可されていません。");
			return false;
		}
		else if (Language == "spanish")
		{
			alert("El administrador no puede abrir esta página.");
			return false;
		}
		else if (Language == "russian")
		{
			alert("У текущего пользователя нет права входа.");
			return false;
		}
		else
		{
			alert("The current user is not allowed to log in.");
			return false;
		}
	}
 }

function init() {
	if (document.addEventListener) {
		document.addEventListener("keypress", onHandleKeyDown, false);
	} else {
		document.onkeypress = onHandleKeyDown;
	}
}
function onHandleKeyDown(event) {
	var e = event || window.event;
	var code = e.charCode || e.keyCode;

	if (code == 13) {
		SubmitForm();
	}
}
function onChangeLanguage(language) {
	Language = language;
	if(language == "portuguese")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Conta';
		document.getElementById('Password').innerHTML = 'Palavra-passe';
		document.getElementById('button').innerHTML = 'Iniciar sessão';
		document.getElementById('footer').innerHTML = 'Copyright © Huawei Technologies Co., Ltd 2009-2017. Todos os direitos reservados.';
	}
	else if(language == "japanese")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'アカウント';
		document.getElementById('Password').innerHTML = 'パスワード';
		document.getElementById('button').innerHTML = 'ログイン';
		document.getElementById('footer').innerHTML = 'Copyright © Huawei Technologies Co., Ltd 2009-2017. All rights reserved.';
	}
	else if (language == "spanish")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Usuario';
		document.getElementById('Password').innerHTML = 'Contraseña';
		document.getElementById('button').innerHTML = 'Iniciar sesión';
		document.getElementById('footer').innerHTML = 'Copyright © Tecnologias Huawei Co., Ltd 2009-2017. Todos los derechos reservados.';
    }
	else if (language == "russian") 
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
        document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Аккаунт';
		document.getElementById('Password').innerHTML = 'Пароль';
		document.getElementById('button').innerHTML = 'Вход';
		document.getElementById('footer').innerHTML = 'Copyright © Huawei Technologies Co., Ltd 2009-2017. Все права защищены.';
    }
	else 
	{
		document.getElementById('Specical_language').style.color = '#434343';
		document.getElementById('English').style.color = '#9b0000';
		document.getElementById('account').innerHTML = 'Account';
		document.getElementById('Password').innerHTML = 'Password';
		document.getElementById('button').innerHTML = 'Login';
		document.getElementById('footer').innerHTML = 'Copyright © Huawei Technologies Co., Ltd 2009-2017. All rights reserved.';
	}

	if (((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0))
	   ||( "1" == FailStat) || (ModeCheckTimes >= errloginlockNum) )
	{
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
}

function BthRefresh()
{
	document.getElementById("imgcode").src = 'getCheckCode.cgi?&rand=' + new Date().getTime();
}
</script>
</head>
<body onLoad="LoadFrame();">
<div id="main_wrapper">
<script language="JavaScript" type="text/javascript">
if ('ORO' == CfgMode.toUpperCase())
{
	document.write('<div style="position:absolute;margin-left:30px;top:30px;height:50px;width:50px;background: url(images/logo_Oro.gif);"></div>');
}

</script>
<div style="position:absolute; top:300px;margin-left:250px;height:300px; width:490px;background: url('images/pic.jpg') no-repeat center;">
<table id="tablecheckcode" border="0" cellpadding="0" cellspacing="0" width="100%" style="display: none">
	<tr>
	<td height="8"></td>
	</tr>
	<tr>
		<td>
			<img id="imgcode" style="margin-left:111px;height:30px;width:100px;" onClick="BthRefresh();">
			<input type="button" id="changecode" style="margin-left:20px;width:58px;" class="submit" value="Refresh" onClick="BthRefresh();"/>
		</td>
	</tr>

	<tr>
		<td height="8"></td>
	</tr>
	<tr align="center">
	<td>
	 <button style="font-size:12px;font-family:Tahoma,Arial;margin-left:-70px;" id="tripletbtn" class="submit" name="tripletbtn" onClick="SubmitForm();" type="button">Login</button>
	</td>
  </tr>
	  <tr>
	  <td class="info_text" height="25" id="tipletfooter"><span style="margin-left:-55px;">Copyright © Huawei Technologies Co., Ltd 2009-2017. All rights reserved.</span></td>
	</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr id="Copyrightfooter" style="position:absolute; margin-left:20px;top:-25px;display: none;color:#9d9d9d;">
	<td height="25" id="footer" style="font-size:11px;"></td>
	</tr>
	<tr>
	<td valign="top" style="padding-top: 20px;"> 
		<div id="tipText" style="display: none">
			<table border="0" cellpadding="0" cellspacing="5" height="33" width="99%"> 
				<tr> 
					<td align="center" bgcolor="#FFFFFF" height="21"> <span style="color:red;font-size:12px;font-family:Arial;">
						<div id="DivTipPage"></div> 
						</span> 
					</td>
				</tr> 
			</table> 
		</div>
	</td>
	</tr>
	<tr>
	<td valign="top" style="padding-top: 20px;"> <div id="loginfail" style="display: none">
		<table border="0" cellpadding="0" cellspacing="5" height="33" width="99%">
		  <tr>
			<td align="center" bgcolor="#FFFFFF" height="21"> <span style="color:red;font-size:12px;font-family:Arial;">
			  <div id="DivErrPage"></div>
			  </span> </td>
		  </tr>
		</table>
	  </div>
	  </td>
  </tr>
</table>
</div>
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<script language="JavaScript" type="text/javascript">
			if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase() || 'ORO' == CfgMode.toUpperCase())
			{
				document.write('<td align="center" height="210" valign="bottom"> <table border="0" cellpadding="0" cellspacing="0" width="44%"> ');
			}
			else if ( 'VIETTEL' == CfgMode.toUpperCase())
			{
				document.write('<td align="center" height="210" valign="bottom"> <table border="0" cellpadding="0" cellspacing="0" width="38%"> ');								
			}
			else
			{
				document.write('<td align="center" height="210" valign="bottom"> <table border="0" cellpadding="0" cellspacing="0" width="36%"> ');
			}
		</script>
		<tr>
			<script language="JavaScript" type="text/javascript">
				if ('DIGICEL' == CfgMode.toUpperCase() || 'DIGICEL2' == CfgMode.toUpperCase())
				{
					document.write('<td align="center" width="81%"> ');
				}
				else
				{
					document.write('<td align="center" width="29%"> ');
				}

				if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase())
				{
					document.write('<img height="70" src="images/logo3bb.gif" width="144" alt="">');
				}
				else if ('ORANGEMT' == CfgMode.toUpperCase())
				{
					document.write('<img height="118" src="images/logo_MA.gif" width="118" alt="">');
				}
				else if ('ORO' == CfgMode.toUpperCase())
				{
					document.write('');
				}
				else if('NOS' == CfgMode.toUpperCase())
				{
					document.write('<img height="72" src="images/logo_nos.gif" width="136" alt="">');
				}
				else if('ANTEL' == CfgMode.toUpperCase())
				{
					document.write('<img height="36" src="images/logo_antel.gif" width="100" alt="">');
				}
				else if (1 == SonetFlag)
				{
					document.write('<img height="0" src="images/logo.gif" width="0" alt="">');
				}
				else if('DIGICEL' == CfgMode.toUpperCase() || 'DIGICEL2' == CfgMode.toUpperCase())
				{
					document.write('<img height="72" src="images/logo_digicel.jpg" width="127" alt="">');
				}
				else if ('PLDT' == CfgMode.toUpperCase())
				{
					document.write('<img height="72" src="images/logo_pldt.gif" width="144" alt="">');
				}
				else if ('VIETTEL' == CfgMode.toUpperCase())
				{
					document.write('<img height="72" src="images/logo_viettel.jpg" width="136" alt="">');
				}
				else
				{
					document.write('<img height="75" src="images/logo.gif" width="70" alt="">');
				}
			</script>
			</td>
			<script language="JavaScript" type="text/javascript">
				if('DIGICEL' == CfgMode.toUpperCase() || 'DIGICEL2' == CfgMode.toUpperCase())
				{
					document.write('<td class="hg_logo" width="11%" id="hg_logo" nowrap></td>');
					document.write('<td valign="bottom" width="8%">');
				}
				else
				{
					document.write('<td class="hg_logo" width="21%" id="hg_logo" nowrap>');
					document.write(ProductName);
					document.write('</td>');
					document.write('<td valign="bottom" width="50%">');
				}
			</script>
			<table border="0" cellpadding="0" cellspacing="0" class="text_copyright" width="100%">
				<tr>
				  <script language="JavaScript" type="text/javascript">
					if (1 == SonetFlag)
					{
						document.write('<td width="47%" nowrap> <a id="English" href="#" name="English" onClick="onChangeLanguage(' + "'english'" + ');" style="font-size:12px;font-family:Arial;">[English]</a> </td>');
						document.write('<td width="53%" nowrap> <a id="Specical_language" href="#" name="Specical_language" onClick="onChangeLanguage(' + "'japanese'" + ');" style="font-size:12px;font-family:Arial;">[日本語]</a> </td>');
					}
					else if (1 == IsPTVDF)
					{
						document.write('<td width="47%" nowrap> <a id="English" href="#" name="English" onClick="onChangeLanguage(' + "'english'" + ');" style="font-size:12px;font-family:Arial;">[English]</a> </td>');
						document.write('<td width="53%" nowrap> <a id="Specical_language" href="#" name="Specical_language" onClick="onChangeLanguage(' + "'portuguese'" + ');" style="font-size:12px;font-family:Arial;">[Portuguese]</a> </td>');
					}
					else if ('ANTEL' == CfgMode.toUpperCase())
					{
						document.write('<td width="47%" nowrap> <a id="English" href="#" name="English" onClick="onChangeLanguage(' + "'english'" + ');" style="font-size:12px;font-family:Arial;">[English]</a> </td>');
						document.write('<td width="53%" nowrap> <a id="Specical_language" href="#" name="Specical_language" onClick="onChangeLanguage(' + "'spanish'" + ');" style="font-size:12px;font-family:Arial;">[Spanish]</a> </td>');
                  	}
					else if ('UZBEKISTAN' == CfgMode.toUpperCase() || 'ROSTELECOM' == CfgMode.toUpperCase()
							  || 'ROSCNT' == CfgMode.toUpperCase() || 'NWT' == CfgMode.toUpperCase())
                  	{
                  		document.write('<td width="47%" nowrap> <a id="English" href="#" name="English" onClick="onChangeLanguage(' + "'english'" + ');" style="font-size:12px;font-family:Arial;">[English]</a> </td>');
                  		document.write('<td width="53%" nowrap> <a id="Specical_language" href="#" name="Specical_language" onClick="onChangeLanguage(' + "'russian'" + ');" style="font-size:12px;font-family:Arial;">[Русский]</a> </td>');	
					}
					else
					{
						document.write('<td width="47%" nowrap> <a id="English" href="#" name="English" style="font-size:12px;font-family:Arial;"></a> </td>');
						document.write('<td width="53%" nowrap> <a id="Specical_language" href="#" name="Specical_language"  style="font-size:12px;font-family:Arial;"></a> </td>');
					}
				  </script>
				</tr>
			  </table></td>
		  </tr>
		</table></td>
	</tr>
	<tr>
      <td align="center" height="65"> <table border="0" cellpadding="0" cellspacing="0" class="tblcalss" height="65" width="45%" style="font-size:16px;"> 
		  <tr>
			<td class="whitebold" height="37" align="right" width="20%" id="account"></td>
			<td class="whitebold" height="37" align="center" width="2%">:</td>
			<td width="78%"> <input style="font-size:12px;font-family:Tahoma,Arial;" id="txt_Username" class="input_login" name="txt_Username" type="text" maxlength="31"> </td>
		  </tr>
		  <tr>
			<td class="whitebold" height="28" align="right" id="Password"></td>
			<td class="whitebold" height="28" align="center" >:</td>
			<td> <input style="font-size:12px;font-family:Tahoma,Arial;" id="txt_Password" class="input_login" name="txt_Password" type="password" maxlength="127">
&nbsp;
			<button style="font-size:12px;font-family:Tahoma,Arial;display: none;" id="button" class="submit" name="Submit" onClick="SubmitForm();" type="button"></button>
			</td>
		</tr>

		<tr id="txtVerificationCode" style="display: none">
			<td class="whitebold" height="28" align="right" id="Validate">Validate Code</td>
			<td class="whitebold" height="32" align="center" >:</td>
			<td>
			<input style="font-size:12px;font-family:Tahoma,Arial;height:21px;" id="VerificationCode" class="input_login" name="VerificationCode" type="text" maxlength="127"></td>
		</tr>

		</table></td>
	</tr>
	</table>
</div>
	<script language="JavaScript" type="text/javascript">
		if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase())
		{
			document.getElementById('tablecheckcode').style.display = '';
			document.getElementById('txtVerificationCode').style.display = '';
			document.getElementById("imgcode").src = 'getCheckCode.cgi?&rand=' + new Date().getTime();
		}
		else
		{
			document.getElementById('Copyrightfooter').style.display = '';
			document.getElementById('button').style.display = '';
		}
	</script>
</body>
</html>

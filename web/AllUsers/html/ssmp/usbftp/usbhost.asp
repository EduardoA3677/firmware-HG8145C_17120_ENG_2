<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link type='text/css' rel="stylesheet" href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>'>
<link type='text/css' rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(errdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var USBFileName;
var curWebFrame='<%HW_WEB_GetWEBFramePath();%>';

function GetLanguageDesc(Name)
{
	return UsbHostLgeDes[Name];
}

function stUSBDevice(domain,DeviceList)
{
	this.domain = domain;
	this.DeviceList = DeviceList;
}

function stFtpSrvCfg(domain, enable, username, ftpport, rootdirpath, usrnum)
{
	this.domain = domain ;
	this.enable  = enable ;
	this.username = username ;
	this.passwd = '********************************';
	this.ftpport = ftpport;
	this.rootdirpath = rootdirpath;
	this.usrnum = usrnum;
}

var LoginRequestLanguage = '<%HW_WEB_GetLoginRequestLangue();%>';
var CfgMode = '<%HW_WEB_GetCfgMode();%>';
var telmexFlag = (CfgMode.toUpperCase() == "TELMEX") || (CfgMode.toUpperCase() == "TELMEX5G") || (CfgMode.toUpperCase() == "TELMEXACCESS") ;
var UsbDevice = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UsbInterface.X_HW_UsbStorageDevice,DeviceList,stUSBDevice);%>;
var FtpSrvCfgs = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_ServiceManage, FtpEnable|FtpUserName|FtpPort|FtpRoorDir|FtpUserNum, stFtpSrvCfg);%>;

var ftpsrvcfg = FtpSrvCfgs[0];

var usb1 = null;
var usb2 = null;

var DeviceStr = null;
var DeviceArray = null;

if ( UsbDevice.length > 1 )
{
	usb1 = UsbDevice[0].DeviceList;
}

if (UsbDevice.length > 2)
{
	usb2 = UsbDevice[1].DeviceList;
}

DeviceStr = usb1 + usb2;

if(DeviceStr != '')
{
	DeviceArray = DeviceStr.split("|");
}

function MakeDeviceName(DiskName)
{
	var device = DiskName.split("/");
	return device[3];
}

function init()
{
	with(document.forms[0])
	{
		if (DeviceArray == '')
			btnDown.disabled = true;

		setCheck('FtpdEnable', ftpsrvcfg.enable);
		setText('SrvUsername', ftpsrvcfg.username);
		setText('SrvPort', ftpsrvcfg.ftpport);
		setText('Srvpassword', ftpsrvcfg.passwd);

		var tmp;
		var i;
		var newPath="";

		if("" != ftpsrvcfg.rootdirpath)
		{
			tmp = ftpsrvcfg.rootdirpath.split("/");
			for(i=0; i<tmp.length - 3; i++)
			{
				newPath += tmp[3+i];

				if(i != tmp.length - 4)
				{
					newPath += '/';
				}
			}


			if ( 'jffs2' == newPath )
			{
				newPath='';
			}
			setText('RootDirPath', newPath);
			setSelect('SrvClDevType', '/mnt/usb/'+tmp[3]+'/');
		}
		else
		{
			setText('RootDirPath',    '');
			setSelect('SrvClDevType', '');
		}

		SetFtpEnable ();
	}
}

function isSafeCharSN(val)
{
	if ( ( val == '<' )
	  || ( val == '>' )
	  || ( val == '\'' )
	  || ( val == '\"' )
	  || ( val == '#' )
	  || ( val == '{' )
	  || ( val == '}' )
	  || ( val == '\\' )
	  || ( val == '|' )
	  || ( val == '^' )
	  || ( val == '[' )
	  || ( val == ']' ) )
	{
		return false;
	}

	return true;
}

function isSafeStringSN(val)
{
	if ( val == "" )
	{
		return false;
	}

	for ( var j = 0 ; j < val.length ; j++ )
	{
		if ( !isSafeCharSN(val.charAt(j)) )
		{
			return false;
		}
	}

	return true;
}

function WriteDeviceOption(id)
{
	var select = document.getElementById(id);

	if (DeviceStr != 'null')
	{
		for (var i in DeviceArray)
		{
			if ((DeviceArray[i] == 'null')
				|| (DeviceArray[i] == 'undefined'))
				continue;
			var opt = document.createElement('option');
			var html = document.createTextNode(MakeDeviceName(DeviceArray[i]));
			opt.value = DeviceArray[i] + '/';
			opt.appendChild(html);
			select.appendChild(opt);
		}
		return true;
	}
	else
	{
		var opt = document.createElement('option');
		var html = document.createTextNode(UsbHostLgeDes['s052e']);
		opt.value = '';
		opt.appendChild(html);
		select.appendChild(opt);
		return false;
	}

}

function CheckPwdIsComplex(str, strName)
{
	var i = 0;
	if ( 6 > str.length )
	{
		return false;
	}

	if (!CompareString(str,strName) )
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

	if ( isSpecialCharacterInString(str) )
	{
		i++;
	}

	if ( i >= 2 )
	{
		return true;
	}
	return false;
}

function title_show(input)
{
	var div=document.getElementById("title_show");

	if ("ARABIC" == LoginRequestLanguage.toUpperCase())
	{
		div.style.right = (input.offsetLeft + 50) + "px";
	}
	else if (curWebFrame == 'frame_UNICOM')
	{
		div.style.left = (input.offsetLeft + 300) + "px";
	}
	else
	{
		div.style.left = (input.offsetLeft + 370) + "px";
	}

	div.innerHTML = UsbHostLgeDes['ss1116b'];
	div.style.display = '';
}

function title_back(input)
{
	var div=document.getElementById("title_show");
	div.style.display = "none";
}

function setControl(index, id)
{
}

function LoadFrame()
{
	init();
}

function checkFtpURL()
{
	var ServerPos;
	var URLValue = document.getElementById('URL').value;

	if (URLValue == '' || URLValue.substr(0, 6) != "ftp://" || URLValue.length <= 6)
	{
		AlertEx(UsbHostLgeDes["s050a"]);
		return false;
	}

	if (!isSafeStringSN(URLValue))
	{
		AlertEx(UsbHostLgeDes["s0534"]);
		document.getElementById('URL').focus();
		return false;
	}

	if(URLValue.charAt(URLValue.length - 1) == '/')
	{
		AlertEx(UsbHostLgeDes["s050a"]);
		return false;
	}

	ServerPos=URLValue.substr(6, URLValue.length);
	if(ServerPos.indexOf('/') <= 0)
	{
		AlertEx(UsbHostLgeDes["s050a"]);
		return false;
	}
	else
	{
		USBFileName = ServerPos.substr(ServerPos.indexOf('/') + 1,ServerPos.length);
		if (USBFileName == '')
		{
			AlertEx(UsbHostLgeDes["s050a"]);
			return false;
		}
		return true;
	}
}

function CheckUSBFileIsExist()
{
	var USBFileLocalPath = document.getElementById('LocalPath').value;
	var CheckResult = 0;
	var USBFileInfo;

	if(USBFileLocalPath == '')
	{
		USBFileInfo = getSelectVal('ClDevType')+USBFileName;
	}
	else
	{
		USBFileInfo = getSelectVal('ClDevType')+USBFileLocalPath;
	}

	$.ajax(
	{
		type : "POST",
		async : false,
		cache : false,
		url : "../common/CheckUSBFileExist.asp?&1=1",
		data :'USBFileInfo=' + USBFileInfo,
		success : function(data) {
			CheckResult = data;
		}
	});

	if (CheckResult == 1)
	{
		if (!ConfirmEx(UsbHostLgeDes["s0533"]))
		{
			return false;
		}
	}

	return true;
}

function checkFtpClient()
{
	with( document.forms[0] )
	{
		if ( (Port.value !='') &&(isNaN(parseInt(Port.value )) == true))
		{
			AlertEx(GetLanguageDesc("s0501"));
			return false;
		}
		var info = parseFloat(Port.value );
		if (info < 1 || info > 65535)
		{
			AlertEx(GetLanguageDesc("s0502"));
			return false;
		}

		if (Username.value.length > 20)
		{
			AlertEx(GetLanguageDesc("s0503"));
			return false;
		}
		if (isValidString(Username.value) == false )
		{
			msg = GetLanguageDesc("s0504");
			AlertEx(msg);
			return false;
		}

		for (var iTemp = 0; iTemp < Username.value.length; iTemp ++)
		{
			if (Username.value.charAt(iTemp) == ' ')
			{
				AlertEx(GetLanguageDesc("s0505"));
				return false;
			}
		}

		if (Userpassword.value.length > 20)
		{
			AlertEx(GetLanguageDesc("s0506"));
			return false;
		}
		if ( isValidString(Userpassword.value) == false )
		{
			msg = GetLanguageDesc("s0507");
			AlertEx(msg);
			return false;
		}

		var tmp = LocalPath.value;
		if (tmp.length > 40)
		{
			AlertEx(GetLanguageDesc("s0508"));
			return false;
		}
		if (tmp.indexOf("..") >= 0 || tmp == '\\' || tmp.charAt(0) == '/'
			|| tmp.charAt(tmp.length-1) == '/')
		{
			msg = GetLanguageDesc("s0509");
			AlertEx(msg);
			return false;
		}

		if(checkFtpURL()==false)
		{
			return;
		}

		if ( getSelectVal('ClDevType') == "" )
		{
			AlertEx(GetLanguageDesc("s050c"));
			return false;
		}
	}

	if(!CheckUSBFileIsExist())
	{
		return false;
	}
	return true;

}

function CheckForm()
{
	return checkFtpClient();
}

function AddSubmitParam(Form,type)
{
	setDisable('ClDevType', 1);
	setDisable('LocalPath', 1);
	setDisable('btnDown',   1);

	var tmp = getValue('URL');
	var URLPath = tmp.toString().replace(/%20/g, " ");

	Form.usingPrefix('x');

	Form.addParameter('Username',     getValue('Username'));
	Form.addParameter('Userpassword', getValue('Userpassword'));
	Form.addParameter('URL',          URLPath);
	var NullCheckValue = getValue('Port');
	if(NullCheckValue != '')
	{
		Form.addParameter('Port', getValue('Port'));
	}
	
	if( NullCheckValue == '' && CfgMode.toUpperCase() == "TELMEXACCESS" )
	{
		Form.addParameter('Port', 21);
	}

	Form.addParameter('Device',       getSelectVal('ClDevType'));
	Form.addParameter('LocalPath',    getValue('LocalPath'));
	Form.addParameter('X_HW_Token',   getValue('onttoken'));
	Form.endPrefix();
	Form.setAction('add.cgi?x=InternetGatewayDevice.X_HW_DEBUG.SMP.DM.FtpClient&'
				 + 'RequestFile=html/ssmp/usbftp/usbhost.asp');
}

function checkFtpSrv()
{
	with (document.forms[0])
	{
		if( 0 == getCheckVal('FtpdEnable') || '0' == getCheckVal('FtpdEnable') )
		{
			return true;
		}

		if (getValue("SrvUsername").length > 256)
		{
			AlertEx(GetLanguageDesc("s050d"));
			return false;
		}

		if (getValue("SrvUsername").length == 0)
		{
			AlertEx(GetLanguageDesc("s050e"));
			return false;
		}

		if (getValue("SrvUsername") == 'anonymous' || getValue("SrvUsername") == 'Anonymous')
		{
			AlertEx(GetLanguageDesc("s050f"));
			return false;
		}

		if (isValidString(getValue("SrvUsername")) == false )
		{
			msg = GetLanguageDesc("s050f");
			AlertEx(msg);
			return false;
		}

		var srvUName = getValue("SrvUsername");
		for (var iTemp = 0; iTemp < srvUName.length; iTemp ++)
		{
			if (srvUName.charAt(iTemp) == ' ')
			{
				AlertEx(GetLanguageDesc("s0505"));
				return false;
			}
		}

		if (getValue("Srvpassword").length > 256)
		{
			AlertEx(GetLanguageDesc("s0511"));
			return false;
		}

		if (getValue("Srvpassword").length == 0)
		{
			AlertEx(GetLanguageDesc("s0512"));
			return false;
		}

		if(getValue("Srvpassword").charAt(0) == ' ')
		{
			AlertEx(GetLanguageDesc("s052c"));
			return false;
		}

		if(getValue("Srvpassword").charAt(getValue("Srvpassword").length - 1) == ' ')
		{
			AlertEx(GetLanguageDesc("s052d"));
			return false;
		}

		if ( isValidString(getValue("Srvpassword")) == false )
		{
			msg = GetLanguageDesc("s0513");
			AlertEx(msg);
			return false;
		}

		var tmpSrvPasswd = getValue("Srvpassword");
		for (var iTemp = 0; iTemp < tmpSrvPasswd.length; iTemp ++)
		{
			if (tmpSrvPasswd.charAt(iTemp) == ' ')
			{
				AlertEx(GetLanguageDesc("s0513"));
				return false;
			}
		}
		
		var portVal = getValue("SrvPort");
		if ((portVal == '') || (isPlusInteger(portVal) == false))
		{
		    AlertEx(GetLanguageDesc("s0501"));
		    return false;
		}		

		var portInfo = parseInt(portVal, 10);
		if (portInfo < 1 || portInfo > 65535)
		{
			AlertEx(GetLanguageDesc("s0502"));
			return false;
		}

		if ( getSelectVal('SrvClDevType') == "" )
		{
			AlertEx(GetLanguageDesc("s0514"));
			return false;
		}

		var tmp = getValue("RootDirPath");
		if (tmp.length > 256)
		{
			AlertEx(GetLanguageDesc("s0515"));
			return false;
		}

		if (isValidString(getValue("RootDirPath")) == false )
		{
			msg = GetLanguageDesc("s0516");
			AlertEx(msg);
			return false;
		}

	}

	var pwd_value = getValue("Srvpassword");
	if (ftpsrvcfg.passwd != pwd_value)
	{
		if (!CheckPwdIsComplex(pwd_value, srvUName))
		{
			if (false == ConfirmEx(UsbHostLgeDes['s1439']))
			{
				return false;
			}
		}
	}

	if (ConfirmEx(GetLanguageDesc("s0517")))
	{
		return true;
	}
	else
	{
		return false;
	}

	return true;

}

function ShowResult(Result)
{
	var i = 0;
	var errorCodeArray = new Array('0xf734b001', '0xf734b002', '0xf734b003', '0xf734b004', '0xf734b005');
	var errorstring = new Array('s0540', 's0541', 's0542', 's0543', 's0544');

	if (Result == '{ "result": 0 }')
	{
		return;
	}

    for (i = 0; i < Result.length ; i++)
	{
		if (Result.split(":")[i].toString().indexOf("error") >= 0)
		{
			break;
		}
	}

	if (i == Result.length)
	{
		return;
	}
	
	var sub = Result.split(":")[i + 1];		
	var errorcode = sub.substring(2, 12);
	for (i = 0; i < errorCodeArray.length; i++)
	{
		if (errorCodeArray[i] == errorcode)
		{
			AlertEx(GetLanguageDesc(errorstring[i]));
			return;
		}
	}

	var errData = errLanguage['s' + errorcode];
    if ('string' != typeof(errData))
    {
		errData = errLanguage['s0xf7205001'];
    }

	AlertEx(errData);
}

function SrvSubmit()
{
	var Ret;

	Ret = checkFtpSrv();
	if (false == Ret)
	{
		return;
	}

	setDisable('SrvClDevType', 1);
	setDisable('RootDirPath', 1);
	setDisable('btnDownSrvApply',  1);
	setDisable('btnDownSrcCancle', 1);

	var ftpInfoData="x.FtpEnable=" + getCheckVal('FtpdEnable');

	if (1 == getCheckVal('FtpdEnable') || '1' == getCheckVal('FtpdEnable'))
	{
		ftpInfoData += "&x.FtpUserName=" + getValue('SrvUsername');

		if (ftpsrvcfg.passwd != getValue('Srvpassword'))
		{
			ftpInfoData += "&x.FtpPassword=" + getValue('Srvpassword');
		}
	
		ftpInfoData += "&x.FtpPort=" + getValue('SrvPort');

		ftpInfoData += "&x.FtpRoorDir=/mnt/usb/" + getValue('RootDirPath');
	}

	$.ajax({
		 type : "POST",
		 async : false,
		 cache : false,
		 data : ftpInfoData + "&x.X_HW_Token=" + getValue('onttoken'),
		 url : "setajax.cgi?x=InternetGatewayDevice.X_HW_ServiceManage&RequestFile=html/ssmp/usbftp/usbhost.asp",
		 success : function(data) {
			ShowResult(data);
			window.location.href = "/html/ssmp/usbftp/usbhost.asp";
		 }
	});
}

function SetFtpEnable()
{
	var enable = getCheckVal('FtpdEnable');

	if(1 == enable || '1' == enable)
	{
		setDisable("SrvUsername",  0);
		setDisable("Srvpassword",  0);
		setDisable("SrvPort",  0);
		setDisable("SrvClDevType", 0);
		setDisable("RootDirPath",  0);
	}
	else
	{
		setDisable("SrvUsername",  1);
		setDisable("Srvpassword",  1);
		setDisable("SrvPort",  1);
		setDisable("SrvClDevType", 1);
		setDisable("RootDirPath",  1);
	}
}

function onChangeDev()
{
	var dev = getSelectVal('SrvClDevType');
	var tmp;

	if(DeviceArray.length-1 > 1)
	{
		return;
	}

	if( "" != dev)
	{
		tmp = dev.split("/");
		setText('RootDirPath', tmp[3]+'/');
	}
	else
	{
		setText('RootDirPath', '');
	}
}


function onSelectDev()
{
	var dev = getSelectVal('SrvClDevType');
	var tmp;

	if( "" != dev)
	{
		tmp = dev.split("/");
		setText('RootDirPath', tmp[3] + '/');
	}
	else
	{
		setText('RootDirPath', '');
	}
}

function stDownloadInfo(Domain,Username,URL,Port,LocalPath,Status,Device)
{
	this.Domain = null;
	this.Username = null;
	this.URL = null;
	this.Port = null;
	this.LocalPath = null;
	this.Status = null;
	this.Device = null;
}

function stRecordList(domain, Username, URL, Port, LocalPath, Status, Device)
{
	this.domain = domain;
	this.Username = Username;
	this.URL = URL;
	this.Port = Port;
	this.LocalPath = LocalPath;
	this.Status = Status;
	this.Device = Device;
}

var RecordString = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.SMP.DM.FtpClient.{i},Username|URL|Port|LocalPath|Status|Device,stRecordList);%>;

var DownloadInfo = new Array();

CreateUsbRecord();

function CreateUsbRecord()
{
	for(i = 0; i < RecordString.length - 1; i++)
	{
		DownloadInfo[i] = new stDownloadInfo();
		if(RecordString[i].LocalPath.replace(/(^\s*)|(\s*$)/g, "")=='')
		{
			var pos = RecordString[i].URL.lastIndexOf('/');
			RecordString[i].LocalPath = RecordString[i].Device + RecordString[i].URL.substr(pos + 1, RecordString[i].URL.length - pos -1);
		}
		else
		{
			RecordString[i].LocalPath = RecordString[i].Device + RecordString[i].LocalPath;
		}
		DownloadInfo[i] = RecordString[i];
	}
}

function Cancleconfig()
{
	init();
}
var TableClass = new stTableClass("width_per25", "width_per75");
</script>
<style type="text/css">
input .UserInput{
	width:160px;
}

input .UserPort{
	width:40px;
}
</style>
</head>

<body class="mainbody" onLoad="LoadFrame();">
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("USBHOST", GetDescFormArrayById(UsbHostLgeDes, "s0538"), GetDescFormArrayById(UsbHostLgeDes, "s0539"), false);
	</script>
	<div class="title_spread"></div>
	<div class="func_title" BindText="s0518"></div>
	<form id="ConfigForm" action="">
		<table id="table_downloadinfo" width="100%" cellspacing="1" cellpadding="0">
			<li id="URL"          RealType="TextBox"      DescRef="s052f" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="256"   ElementClass="UserInput" InitValue="Empty"/>
			<li id="Port"         RealType="TextBox"      DescRef="s051a" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="5"     ElementClass="UserPort"  InitValue="Empty"/>
			<li id="Username"     RealType="TextBox"      DescRef="s051b" RemarkRef="s0506b" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="20"    ElementClass="UserInput" InitValue="Empty"/>
			<li id="Userpassword" RealType="TextBox"      DescRef="s051c" RemarkRef="s0506b" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="20"    ElementClass="UserInput" InitValue="Empty"/>
			<li id="ClDevType"    RealType="DropDownList" DescRef="s051d" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty" Elementclass="UserInput"/>
			<li id="LocalPath"    RealType="TextBox"      DescRef="s051e" RemarkRef="s0535" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="40"    ElementClass="UserInput" InitValue="Empty"/>
		</table>
		<script>
			var UsbConfigFormList = HWGetLiIdListByForm("ConfigForm", null);
			var formid_hide_id = null;

			HWParsePageControlByID("ConfigForm", TableClass, UsbHostLgeDes, formid_hide_id);
			
			if(CfgMode.toUpperCase() != "TELMEXACCESS")
			{
				document.getElementById("URL").value = "ftp://";
				document.getElementById("Port").value = "21";
			}
			else
			{
				document.getElementById("URL").value = "";
				document.getElementById("Port").value = "";
			}
			
			WriteDeviceOption('ClDevType');
			if (!telmexFlag)
			{
				document.getElementById('LocalPathRemark').style.display = "none";
			}
		</script>
		<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
			<tr>
				<td class="table_submit width_per25"></td>
				<td class="table_submit">
					<input type="button" name="btnDown" id="btnDown" class="ApplyButtoncss buttonwidth_100px" BindText="s051f" onClick='Submit()'>
				</td>
			</tr>
		</table>

		<div class="func_spread"></div>
		<script type="text/javascript">
			var UsbConfiglistInfo = new Array(new stTableTileInfo("s0528", null, "Username", false, 10),
											  new stTableTileInfo("s0529", null, "UserPassword"),
											  new stTableTileInfo("s052a", null, "Port"),
											  new stTableTileInfo("s0530", null, "URL", false, 30),
											  new stTableTileInfo("s052b", null, "LocalPath", false, 30),
											  new stTableTileInfo("s0520", null, "Status", false, 8),
											  null);

			var ColumnNum = 6;
			var TableDataInfo = HWcloneObject(DownloadInfo, 1);
			for (var i in TableDataInfo)
			{
				TableDataInfo[i].UserPassword = '*****';
			}
			TableDataInfo[TableDataInfo.length] = 'null';
			HWShowTableListByType(1, "UsbConfigList", 0, ColumnNum, TableDataInfo, UsbConfiglistInfo, UsbHostLgeDes, null);
		</script>
		<div class="func_spread"></div>
	</form>

	<form id="SvrConfigForm" action="">
		<div class="func_title" BindText="s0521"></div>
		<table id="table_downloadinfo" width="100%" cellspacing="1" cellpadding="0">
			<li id="FtpdEnable"   RealType="CheckDivBox"  DescRef="s0524" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="[{Item:[{AttrName:'id', AttrValue:'title_show'},{AttrName:'style', AttrValue:'position:absolute; display:none; line-height:16px; width:310px; border:solid 1px #999999; background:#edeef0;'}]}]" ClickFuncApp="onClick=SetFtpEnable"/>
			<li id="SrvUsername"  RealType="TextBox"      DescRef="s051b" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" ElementClass="UserInput" InitValue="Empty"/>
			<li id="Srvpassword"  RealType="TextBox"      DescRef="s051c" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" ElementClass="UserInput" InitValue="Empty" ClickFuncApp="onmouseover=title_show;onmouseout=title_back"/>
			<li id="SrvPort"      RealType="TextBox"      DescRef="s051a" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="5" ElementClass="UserPort" InitValue="Empty"/>
			<li id="SrvClDevType" RealType="DropDownList" DescRef="s051d" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty" Elementclass="UserInput" ClickFuncApp="onClick=onChangeDev;onChange=onSelectDev"/>
			<li id="RootDirPath"  RealType="TextBox"      DescRef="s0525" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" ElementClass="UserInput" InitValue="Empty"/>
		</table>

		<script>
			var UsbConfigFormList = HWGetLiIdListByForm("SvrConfigForm", null);
			var formid_hide_id = null;

			HWParsePageControlByID("SvrConfigForm", TableClass, UsbHostLgeDes, formid_hide_id);
			WriteDeviceOption('SrvClDevType');
		</script>
		<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
			<tr>
				<td class="table_submit width_per25"></td>
				<td class="table_submit">
					<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>" />
					<input type="button" name="btnDownSrvApply"  id="btnDownSrvApply"  class="ApplyButtoncss  buttonwidth_100px" BindText="s0526" onClick='SrvSubmit()' />
					<input type="button" name="btnDownSrcCancle" id="btnDownSrcCancle" class="CancleButtonCss buttonwidth_100px" BindText="s0527" onClick='Cancleconfig()' />
				</td>
			</tr>
		</table>
		<div class="func_spread"></div>
	</form>
	<script>
		ParseBindTextByTagName(UsbHostLgeDes, "div",    1);
		ParseBindTextByTagName(UsbHostLgeDes, "td",     1);
		ParseBindTextByTagName(UsbHostLgeDes, "input",  2);
	</script>
</body>
</html>

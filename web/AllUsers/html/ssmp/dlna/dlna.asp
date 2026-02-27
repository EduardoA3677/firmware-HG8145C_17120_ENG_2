<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script type="text/javascript" src="../smblist/<%HW_WEB_CleanCache_Resource(jquery_mini.js);%>"></script>
<script type="text/javascript" src="../smblist/<%HW_WEB_CleanCache_Resource(thickbox.js);%>"></script>
<link rel="stylesheet" href="../smblist/<%HW_WEB_CleanCache_Resource(thickbox.css);%>" type="text/css" media="screen" />
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" type="text/javascript">
try
{
	document.execCommand('BackgroundImageCache', false, true);
}
catch(e)
{}
</script>

<script language="JavaScript" type="text/javascript">
function stDlnaService(domain,Enable,ShareAllPath)
{
	this.domain = domain;
	this.Enable = Enable;
	this.ShareAllPath = ShareAllPath;
}

function stdlnaDirectory(domain,Active,ContentDirectory,ContentDirectoryUTF)
{
	this.domain = domain;
	this.Active = Active;
	this.ContentDirectory = ContentDirectory;
	this.ContentDirectoryUTF = ContentDirectoryUTF;
}

var dlnaServices = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.X_HW_DmsService,Enable|ShareAllPath,stDlnaService);%>;
var dlnaService = dlnaServices[0];
var dlnaDirectorys =<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.X_HW_DmsService.Directory.{i},Active|ContentDirectory|ContentDirectoryUTF,stdlnaDirectory);%>;

function radioChooseDirOption()
{
	var radioIndex = getRadioVal('idRadioDirectory');

	if('1' == radioIndex)
	{
		setDisplay('ConfigForm', 0);
	}
	else
	{
		setDisplay('ConfigForm', 1);
	}

	setDisplay('tablesubmit', 1);

}
function dlnaDirlistselectRemoveCnt()
{

}

function LoadFrame()
{
	setRadio('idRadioDirectory', parseInt(dlnaService.ShareAllPath));
	setCheck('dlnaEnable',       dlnaService.Enable);

	if (dlnaDirectorys.length - 1 == 0)
	{
		selectLine('dlnaDirlist_record_no');
		setDisplay('ConfigForm', 0);
	}
	else
	{
		selectLine('dlnaDirlist_record_0');
		setDisplay('ConfigForm', 1);
	}

	radioChooseDirOption();
}

function CheckForm()
{
	var UrlPath = getValue('UrlUtf')
	if (UrlPath == '')
	{
		AlertEx(DlnaLgeDes['s1607']);
		return false;
	}

	for(var i = 0; i < dlnaDirectorys.length - 1; i++)
	{
		if(selctIndex == i)
		{
			continue;
		}

		if(UrlPath == dlnaDirectorys[i].ContentDirectory)
		{
			AlertEx(DlnaLgeDes['s1608']);
			return false;
		}
	}
	return true;
}

function SubmitForm()
{
	var Form = new webSubmitForm();

	var UrlUtfPath= getValue('UrlUtf');

	if (UrlUtfPath.length > 503)
	{
		AlertEx(DlnaLgeDes['s1610']);
		return false;
	}

	Form.addParameter('x.Enable',               getCheckVal('dlnaEnable'));
	Form.addParameter('x.ShareAllPath',         getRadioVal('idRadioDirectory'));
	Form.addParameter('Add_y.ContentDirectory', UrlUtfPath);

	if( 1 == getRadioVal('idRadioDirectory'))
	{
		Form.addParameter('x.X_HW_Token',       getValue('onttoken'));
		Form.setAction('set.cgi?x=InternetGatewayDevice.Services.X_HW_DmsService&RequestFile=html/ssmp/dlna/dlna.asp');
	}
	else
	{
		var ulret = CheckForm();
		if (ulret != true )
		{
			return false;
		}
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		if( -1 == selctIndex || -2 == selctIndex)
		{

			Form.setAction('complex.cgi?x=' + 'InternetGatewayDevice.Services.X_HW_DmsService'
											+ '&Add_y=' + 'InternetGatewayDevice.Services.X_HW_DmsService.Directory'
											+ '&RequestFile=html/ssmp/dlna/dlna.asp');
		}
		else
		{
			Form.setAction('set.cgi?x=' + 'InternetGatewayDevice.Services.X_HW_DmsService'
										+ '&Add_y=' + dlnaDirectorys[selctIndex].domain
										+ '&RequestFile=html/ssmp/dlna/dlna.asp');
		}

	}

	setDisable('btnApplydlna', 1);
	setDisable('cancelValue',  1);
	Form.submit();
}

function CancelConfig()
{
	LoadFrame();
}

var selctIndex = -1;

function setControl(index)
{
	var record;
	selctIndex = index;

	if (index == -1)
	{
		if (dlnaDirectorys.length - 1 >= 10)
		{
			setText('UrlUtf',         '');
			setDisplay('DeviceDir',   0);
			setDisplay('tablesubmit', 0);
			AlertEx(DlnaLgeDes['s1606']);
			return;
		}
		else
		{
			record = new stdlnaDirectory('', '', '');
			setText('UrlUtf',        '');
			setDisplay('ConfigForm', 1);
		}
	}
	else if (index == -2)
	{
		setDisplay('ConfigForm', 0);
	}
	else
	{

		record = dlnaDirectorys[index];
		var dlnapath = record.ContentDirectory;
		if("1_1" == record.ContentDirectory)
		{
			dlnapath = "/usb1_1";
		}
				
		setText('UrlUtf', dlnapath);
		setDisplay('ConfigForm', 1);
	}
	setDisplay('DeviceDir',    1);
	setDisplay('tablesubmit',  1);
	setDisable('btnApplydlna', 0);
	setDisable('cancelValue',  0);
}

function stDelete(form, index)
{
	form.addParameter(dlnaDirectorys[index].domain, '');
}

function clickRemove()
{
	var Form = new webSubmitForm();
	var cnt = 0;
	var rml = getElement('dlnaDirlistrml');
	if (rml != null)
	{
		with (document.forms[0])
		{
			if (rml.length > 0)
			{
				for (var i = 0; i < rml.length; i++)
				{
					if (rml[i].checked == true)
					{

						stDelete(Form, i);
						cnt++;
					}
				}

			}
			else if (rml.checked == true)
			{

				stDelete(Form,0);
				cnt++;
			}
		}
		if( 0 != cnt)
		{
			Form.setAction('del.cgi?RequestFile=html/ssmp/dlna/dlna.asp');
			Form.addParameter('x.X_HW_Token', getValue('onttoken'));
			Form.submit();
		}
	}
}

var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
var DlnaConfigFormList = new Array();

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
	<script language="JavaScript" type="text/javascript">
		var DLNASummaryArray = new Array(new stSummaryInfo("text", GetDescFormArrayById(DlnaLgeDes, "s1600")),
										 new stSummaryInfo("img", "../../../images/icon_01.gif", GetDescFormArrayById(DlnaLgeDes, "s0531")),
										 new stSummaryInfo("text", GetDescFormArrayById(DlnaLgeDes, "s0532")),
										 null);
		HWCreatePageHeadInfo("dlnainfo", GetDescFormArrayById(DlnaLgeDes, "s1611"), DLNASummaryArray, true);
	</script>
	<div class="title_spread"></div>
	<div id="dlnaConfigDiv">
		<form id="dlnaConfig">
			<table id="dlnaConfigTable" cellpadding="0" cellspacing="1" width="100%">
				<li id="dlnaEnable"       RealType="CheckBox"         DescRef="s1601" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Enable"       InitValue="Empty" />
				<li id="idRadioDirectory" RealType="RadioButtonList"  DescRef="s1410" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.ShareAllPath" InitValue="[{TextRef:'s1603',Value:'1'},{TextRef:'s1604',Value:'0'}]" ClickFuncApp="onClick=radioChooseDirOption"/>
			</table>
			<script language="JavaScript" type="text/javascript">
				DlnaConfigFormList = HWGetLiIdListByForm("dlnaConfig", null);
				var formid_hide_id = null;
				HWParsePageControlByID("dlnaConfig", TableClass, DlnaLgeDes, formid_hide_id);
			</script>
		</form>
	</div>
	<div id="ConfigForm">
	<div class="button_spread"></div>
		<div id="dlnaShareConfig">
			<script type="text/javascript">
				var dlnaConfiglistInfo = new Array(new stTableTileInfo("Empty", null, "DomainBox"),
												   new stTableTileInfo("s1604", null, "ContentDirectory", false, 32), null);

				var ColumnNum = 2;
				var TableDataInfo =  HWcloneObject(dlnaDirectorys, 1);
				var dlnaDirlist = ((getRadioVal('idRadioDirectory') == "1") ? 0 : 1);
				for(var index = 0; index < TableDataInfo.length - 1; index++)
				{
					if(undefined != TableDataInfo[index] && undefined != TableDataInfo[index].ContentDirectory && TableDataInfo[index].ContentDirectory == "1_1")
					{
						TableDataInfo[index].ContentDirectory = "/usb1_1";
					}
				}
				
				HWShowTableListByType(dlnaDirlist, "dlnaDirlist", 1, ColumnNum, TableDataInfo, dlnaConfiglistInfo, DlnaLgeDes, null);
			</script>
		</div>
		<div class="list_table_spread"></div>
		<div id="dlnaShareConfigDetail">
			<form id="dlnaShareConfigDetailFrom" name="dlnaShareConfigDetailFrom">
				<table id="dlnaShareConfigDetailTable" width="100%;" cellspacing="1" cellpadding="0">
					<li id="UrlUtf" disabled="disabled" RealType="TextOtherBox" DescRef="s1609" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE" BindField="Add_y.ContentDirectory"
					InitValue="[{Item:[{AttrName:'id', AttrValue:'UrlBase'},{AttrName:'type', AttrValue:'text'}, {AttrName:'style', AttrValue:'display:none'}]},{Item:[{AttrName:'id', AttrValue:'MediaChooseInput'},{AttrName:'name', AttrValue:'MediaChooseInput'},{AttrName:'type', AttrValue:'button'}, {AttrName:'class', AttrValue:'CancleButtonCss browserbutton thickbox'}, {AttrName:'value', AttrValue:'s1605'}, {AttrName:'title', AttrValue:'s1436'}, {AttrName:'alt', AttrValue:'../smblist/smb_choosedir_list.asp?&Choose=1&TB_iframe=true'}]}]"/>
				</table>
				<script>
					SambaConfigFormList = HWGetLiIdListByForm("dlnaShareConfigDetailFrom", null);
					var formid_hide_id = null;
					HWParsePageControlByID("dlnaShareConfigDetailFrom", TableClass, DlnaLgeDes, formid_hide_id);
				</script>
			</form>
		</div>
	</div>
	<table id="tablesubmit" cellpadding="0" cellspacing="0"  width="100%" class="table_button">
		<tr>
			<td class='width_per25'></td>
			<td class="table_submit">
				<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
				<input type="button" name="btnApplydlna" id="btnApplydlna" BindText="s0526" class="ApplyButtoncss buttonwidth_100px"  onClick="SubmitForm();">
				<input type="button" name="cancelValue"  id="cancelValue"  BindText="s0527" class="CancleButtonCss buttonwidth_100px" onClick="CancelConfig();">
			</td>
		</tr>
	</table>
	<script>
		ParseBindTextByTagName(SambaLgeDes, "td",    1);
		ParseBindTextByTagName(SambaLgeDes, "input", 2);
	</script>
</body>
</html>

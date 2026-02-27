<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>Chinese -- MAC Filter</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="Javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>
<script language="javascript" src="../common/topoinfo.asp"></script>
<style type="text/css">
.tabnoline td
{
   border:0px;
}
</style>
<script language="JavaScript" type="text/javascript"> 
var selctIndex = -1;
var numpara = "";
var portid  = "";
var TableName = "WMacfilterConfigList";
var SSIDnum = 8;
var DoubleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>';    
if( window.location.href.indexOf("?") > 0)
{
    numpara = window.location.href.split("?")[1]; 
    portid  = window.location.href.split("?")[2];
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
		b.innerHTML = wlanmacfil_language[b.getAttribute("BindText")];
	}
}

var enableFilter = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.WlanMacFilterRight);%>';
var Mode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.WlanMacFilterPolicy);%>';


function stMacFilter(domain,SSIDName,MACAddress)
{
   this.domain = domain;   
   this.SSIDName = SSIDName;
   this.MACAddress = MACAddress; 
}

var MacFilterSrc = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GeWlanMacFilter, InternetGatewayDevice.X_HW_Security.WLANMacFilter.{i},SSIDName|SourceMACAddress,stMacFilter);%>;
var MacFilter = new Array();
for (var i = 0; i < MacFilterSrc.length-1; i++)
{
	var SSIDIndex = MacFilterSrc[i].SSIDName.charAt(MacFilterSrc[i].SSIDName.length - 1);
	if(IsVisibleSSID('SSID' + SSIDIndex) == true)
		MacFilter.push(MacFilterSrc[i]);
}
MacFilter.push(null);

function stAthName(domain,Name,Enable)
{
	this.domain = domain;
	this.Name   = Name;
	this.Enable = Enable;
}

function ShowMacFilter(obj)
{
	if (obj.checked)
	{
		setDisplay('FilterInfo', 1);
	}
	else
	{
		setDisplay('FilterInfo', 0);
	}
}

function removeClick() 
{
   var rml = getElement('rml');
  
   if (rml == null)
   	   return;
 
   var Form = new webSubmitForm();

   var k;	   
   if (rml.length > 0)
   {
      for (k = 0; k < rml.length; k++) 
	  {
         if ( rml[k].checked == true )
         {
			 Form.addParameter(rml[k].value,'');
		 }	
      }
   }  
   else if ( rml.checked == true )
   {
	  Form.addParameter(rml.value,'');
   }
   Form.addParameter('x.X_HW_Token', getValue('onttoken'));	  
   Form.setAction('del.cgi?RequestFile=html/bbsp/wlanmacfilter/wlanmacfilter.asp');
   Form.submit();
}

function LoadFrame()
{
   if (enableFilter != '' && Mode != '')
   {    
       setDisplay('FilterInfo',1);
       setSelect('FilterMode',Mode);
       if (MacFilter.length - 1 == 0)
       {
           selectLine('record_no');
           setDisplay('TableConfigInfo',0);
       }
       else
       {
           selectLine(TableName + '_record_0');
           setDisplay('TableConfigInfo',1);
       }
       setDisable('EnableMacFilter',0);
       setDisable('FilterMode',0);
       setDisable('btnApply_ex',0);
       setDisable('cancel',0);
   }
   else
   {
       setDisplay('FilterInfo',0);
   }
   
   if (enableFilter == "1")
   {
       getElById("EnableMacFilter").checked = true;
   }

	if(isValidMacAddress(numpara) == true)
	{
		clickAdd(TableName + '_head');
		setSelect('ssidindex', 'SSID-' + portid.charAt(portid.length - 1));        
		setText('SourceMACAddress', numpara);
	}

	loadlanguage();
}

function selFilter(filter)
{
   if (filter.checked)
   {   
       FilterInfo.style.display = "";
	   if (enableFilter == 0)
	   {
		   var mode = getElement('FilterMode');
		   mode[0].disabled = true;
		   mode[1].disabled = true;
	   }
   }
   else
   {
	   setDisplay('FilterInfo',0);
   }
   SubmitForm();
   setDisable('EnableMacFilter',1);
}

function ChangeMode()
{
	var WMacfilterPolicySpecCfgParaList = new Array();
    var FilterMode = getElById("FilterMode");

    if (FilterMode[0].selected == true)
	{ 
		if (ConfirmEx(wlanmacfil_language['bbsp_macfilterconfirm1']))
		{
			WMacfilterPolicySpecCfgParaList.push(new stSpecParaArray("x.WlanMacFilterPolicy", 0, 1));
		}
		else
		{
		    FilterMode[0].selected = false;
			FilterMode[1].selected = true;
			return;
		}
	}
	else if (FilterMode[1].selected == true)
	{
		if (ConfirmEx(wlanmacfil_language['bbsp_macfilterconfirm2']))
		{
			WMacfilterPolicySpecCfgParaList.push(new stSpecParaArray("x.WlanMacFilterPolicy", 1, 1));
		}
		else
		{
		    FilterMode[0].selected = true;
		    FilterMode[1].selected = false;
			return;
		}
	}
	var Parameter = {};
	Parameter.asynflag = null;
	Parameter.FormLiList = WMacfilterInfoConfigFormList;
	Parameter.SpecParaPair = WMacfilterPolicySpecCfgParaList;
	var tokenvalue = getValue('onttoken');
	var url = 'set.cgi?x=InternetGatewayDevice.X_HW_Security'
                + '&RequestFile=html/bbsp/wlanmacfilter/wlanmacfilter.asp';
	HWSetAction(null, url, Parameter, tokenvalue);	
}

function SubmitForm()
{
	var WMacfilterRightSpecCfgParaList = new Array();
	var Enable = getElById("EnableMacFilter").checked;
	if (Enable == true)
	{
	   WMacfilterRightSpecCfgParaList.push(new stSpecParaArray("x.WlanMacFilterRight", 1, 1));
	}
	else
	{
	   WMacfilterRightSpecCfgParaList.push(new stSpecParaArray("x.MacFilterRight", 0, 1));
	}
    var Parameter = {};
	Parameter.asynflag = null;
	Parameter.FormLiList = WMacfilterInfoConfigFormList;
	Parameter.SpecParaPair = WMacfilterRightSpecCfgParaList;
	var tokenvalue = getValue('onttoken');
	var url = 'set.cgi?x=InternetGatewayDevice.X_HW_Security'
				+ '&RequestFile=html/bbsp/wlanmacfilter/wlanmacfilter.asp';
				
	HWSetAction(null, url, Parameter, tokenvalue);	
}

function CheckSSIDEnable(SSIDName)
{
	return GetSSIDStatusByName('SSID' + SSIDName.charAt(SSIDName.length - 1));
}

function GetInstIDNameBySSIDName(SSIDName)
{
	var SSIDDomain = GetSSIDDomainByName('SSID' + SSIDName.charAt(SSIDName.length - 1));
	return getWlanInstFromDomain(SSIDDomain);
}

function CheckForm()
{   
    var SSIDName = getValue('ssidindex');
    var macAddress = getElement('SourceMACAddress').value;
    var num=0;

    if (macAddress == '') 
    {
		AlertEx(wlanmacfil_language['bbsp_macfilterisreq']);
        return false;
    }
    if (macAddress != '' && isValidMacAddress1(macAddress) == false ) 
    {
		AlertEx(wlanmacfil_language['bbsp_themac'] + macAddress + macfilter_language['bbsp_macisinvalid']);       
        return false;
    }
	
	for (var i = 0; i < MacFilter.length-1; i++)
    {
        if (selctIndex != i)
        {
            if ((macAddress.toUpperCase() == MacFilter[i].MACAddress.toUpperCase()) && (SSIDName == MacFilter[i].SSIDName))
            {
                AlertEx(macfilter_language['bbsp_themac'] + macAddress + macfilter_language['bbsp_macrepeat']);
                return false;
            }
            if (SSIDName == MacFilter[i].SSIDName)
            {
               num++;
            }
        }
        else
        {
            continue;
        }
    }
    if (num >= SSIDnum)
    {
        AlertEx(wlanmacfil_language['bbsp_rulenum']);
        return false;
    }

    return true;
}

function AddSubmitParam()
{
	if (false == CheckForm())
	{
		return;
	}
	var enable = getElById("EnableMacFilter").checked;
	var EnableMacFilter = (enable == true)?1:0;
	var WMacfilterSpecCfgParaList = new Array(new stSpecParaArray("x.SourceMACAddress",getValue('SourceMACAddress'), 1),
											new stSpecParaArray("x.SSIDName",getValue('ssidindex'), 1),
											new stSpecParaArray("x.Enable",EnableMacFilter, 1));
											
	
	var url = '';
    if( selctIndex == -1 )
	{
		 url = 'add.cgi?x=InternetGatewayDevice.X_HW_Security.WLANMacFilter'
		                        + '&RequestFile=html/bbsp/wlanmacfilter/wlanmacfilter.asp';
	}
	else
	{
	     url = 'set.cgi?x=' + MacFilter[selctIndex].domain
							+ '&RequestFile=html/bbsp/wlanmacfilter/wlanmacfilter.asp';
	}
	var Parameter = {};
	Parameter.asynflag = null;
	Parameter.FormLiList = WMacfilterConfigFormList;
	Parameter.SpecParaPair = WMacfilterSpecCfgParaList;
	var tokenvalue = getValue('onttoken');
	HWSetAction(null, url, Parameter, tokenvalue);	
	
    setDisable('EnableMacFilter',1);
    setDisable('FilterMode',1);
    setDisable('btnApply_ex',1);
    setDisable('cancel',1);
}

function setCtlDisplay(record)
{
	if (record == null)
	{
		setText('SourceMACAddress','');
	}
	else
	{
        var ssid = getElementById('ssidindex');
        ssid.value = record.SSIDName;
        setText('SourceMACAddress', record.MACAddress);
	}	
}

function setMacInfo()
{
	if (Mode == 1)
    {   
        setDisplay("MacAlert",1);
        AlertEx(wlanmacfil_language['bbsp_rednote']);
    }
    else 
    {
        setDisplay("MacAlert",0);
    }
}

function setControl(index)
{   
    var record;
    selctIndex = index;
    if (index == -1)
	{
        if (MacFilter.length >= (TopoInfo.SSIDNum*SSIDnum)+1)
        {
            setDisplay('TableConfigInfo', 0);
			if(DoubleFreqFlag == 1)
			{
            	AlertEx(wlanmacfil_language['bbsp_rulenum2']);
			}
			else
			{
				AlertEx(wlanmacfil_language['bbsp_rulenum1']);
			}
            return;
        }
        else
        {
            setDisplay('TableConfigInfo', 1);
			setMacInfo();
            setCtlDisplay(record);
        }
	}
    else if (index == -2)
    {
        setDisplay('TableConfigInfo', 0);
    }
	else
	{
	    record = MacFilter[index];
        setDisplay('TableConfigInfo', 1);
        setCtlDisplay(record);
	}
    setDisable('btnApply_ex',0);
    setDisable('cancel',0);
}

function WMacfilterConfigListselectRemoveCnt(val)
{

}

function OnDeleteButtonClick(TableID)
{ 
    if ((MacFilter.length-1) == 0)
	{
	    AlertEx(wlanmacfil_language['bbsp_nonerulealert']);
	    return;
	}

	if (selctIndex == -1)
	{
	    AlertEx(wlanmacfil_language['bbsp_saverulealert']);
	    return;
	}

    var CheckBoxList = document.getElementsByName(TableName+'rml');
    var Form = new webSubmitForm();
	var Count = 0;
    for (var i = 0; i < CheckBoxList.length; i++)
	{
		if (CheckBoxList[i].checked != true)
		{
			continue;
		}
		
		Count++;
		Form.addParameter(CheckBoxList[i].value,'');
	}
    if (Count <= 0)
	{
		AlertEx(wlanmacfil_language['bbsp_chooserulealert']);
		return;
	}

    if (enableFilter == 1 && Mode == 1)
    {   
        if(ConfirmEx(wlanmacfil_language['bbsp_whitealert']))
        {
			Form.addParameter('x.X_HW_Token', getValue('onttoken'));
			Form.setAction('del.cgi?' +'x=InternetGatewayDevice.X_HW_Security.WLANMacFilter' + '&RequestFile=html/bbsp/wlanmacfilter/wlanmacfilter.asp');
			Form.submit();
            setDisable('btnApply_ex',1);
            setDisable('cancel',1);
        }
        else
        {
            return;
        }
    }
    else
    {
        if (ConfirmEx(wlanmacfil_language['bbsp_deletealert']) == false)
    	{
			document.getElementById("DeleteButton").disabled = false;
			return;
        }
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('del.cgi?' +'x=InternetGatewayDevice.X_HW_Security.WLANMacFilter' + '&RequestFile=html/bbsp/wlanmacfilter/wlanmacfilter.asp');
		Form.submit();
        setDisable('btnApply_ex',1);
        setDisable('cancel',1);
    }  
}

function CancelValue()
{   
    if (selctIndex == -1)
    {
        var tableRow = getElement(TableName);

        if (tableRow.rows.length == 1)
        {
        }
        else if (tableRow.rows.length == 2)
        {
			setDisplay('TableConfigInfo',0);
        }   
        else
        {
            tableRow.deleteRow(tableRow.rows.length-1);
            selectLine(TableName + '_record_0');
        }
    }
    else
    {
        setText('SourceMACAddress',MacFilter[selctIndex].MACAddress);
    }
}

function ChangeSSID()
{

}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("wlanmacfilter", GetDescFormArrayById(wlanmacfil_language, "bbsp_mune"), GetDescFormArrayById(wlanmacfil_language, "bbsp_wlanmac_title"), false);
</script> 
<div class="title_spread"></div>

<div id="FilterInfo">
<form id="MacFilterCfg" style="display:block;">
	<table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
		<li   id="EnableMacFilter"                 RealType="CheckBox"           DescRef="bbsp_filterenable"       RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.WlanMacFilterRight"             InitValue="Empty" ClickFuncApp="onclick=SubmitForm"/>
		<li   id="FilterMode"                RealType="DropDownList"       DescRef="bbsp_filterpolicy"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.WlanMacFilterPolicy"         InitValue="[{TextRef:'bbsp_blacklist',Value:'0'},{TextRef:'bbsp_whitelist',Value:'1'}]" ClickFuncApp="onchange=ChangeMode"/>
	</table>
	<script>
		var TableClass = new stTableClass("width_per30", "width_per70", "ltr");
		WMacfilterInfoConfigFormList = HWGetLiIdListByForm("MacFilterCfg", null);
		HWParsePageControlByID("MacFilterCfg", TableClass, wlanmacfil_language, null);
		getElById("EnableMacFilter").title = wlanmacfil_language['bbsp_macfilternote1'];
		getElById("FilterMode").title = wlanmacfil_language['bbsp_macfilternote2'];
	</script>
</form>
<div class="func_spread"></div>

<script language="JavaScript" type="text/javascript">
	var WMacfilterConfiglistInfo = new Array(new stTableTileInfo("Empty","","DomainBox"),									
								new stTableTileInfo("bbsp_ssidindex","","SSIDName"),
								new stTableTileInfo("bbsp_macaddr","","MACAddress"),null);	
	var ColumnNum = 3;
	var ShowButtonFlag = true;
	var WMacfilterTableConfigInfoList = new Array();
	var TableDataInfo = HWcloneObject(MacFilter, 1);
	for (i = 0; i < TableDataInfo.length - 1; i++)
	{
	   if (TableDataInfo[i].MACAddress != '')
	   {
	    	TableDataInfo[i].SSIDName = GetInstIDNameBySSIDName(TableDataInfo[i].SSIDName);
	   }
	}
	HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, WMacfilterConfiglistInfo, wlanmacfil_language, null);
</script>

<div class="list_table_spread"></div>
<form id="TableConfigInfo" style="display:none;"> 
	<table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
		<li   id="ssidindex"                RealType="DropDownList"       DescRef="bbsp_ssidaddrtitle"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.SSIDName"         InitValue="" ClickFuncApp="onchange=ChangeSSID"/>
		<li   id="SourceMACAddress"         RealType="TextBox"            DescRef="bbsp_macaddrtitle"                 RemarkRef="bbsp_macfilternote3"     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.SourceMACAddress"      InitValue="Empty" MaxLength='17'/>
	</table>
	<script language="JavaScript" type="text/javascript">
		TableClass = new stTableClass("width_per20", "width_per80", "ltr");
		WMacfilterConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
		HWParsePageControlByID("TableConfigInfo", TableClass, wlanmacfil_language, null);
		var svrlist = getElementById('ssidindex');
		svrlist.options.length = 0;
	    for (var i = 0, WIFIName = GetSSIDList(); i < WIFIName.length; i++)
		{
			var value = 'SSID-' + WIFIName[i].name.charAt(WIFIName[i].name.length - 1);
			var TextRef = 'SSID'+ getWlanInstFromDomain(WIFIName[i].domain);
			svrlist.options.add(new Option(TextRef, value));
		}
	</script>
	<div id="MacAlert" style="display:none;"> 
		<table cellpadding="2" cellspacing="0" class="pm_tabal_bg" width="100%"> 
		  <tr> 
			<td class='color_red' BindText='bbsp_rednote'></td> 
		  </tr> 
		</table> 
	 </div>
	 <table cellpadding="0" cellspacing="0" width="100%" class="table_button"> 
          <tr>
            <td class='width_per20'></td> 
            <td class="table_submit">
			  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
			  <button id='btnApply_ex' name="btnApply_ex" class="ApplyButtoncss buttonwidth_100px" type="button" onClick="AddSubmitParam();"> <script>document.write(wlanmacfil_language['bbsp_apply']);</script> </button> 
              <button id='Cancel' name="cancel" class="CancleButtonCss buttonwidth_100px" type="button" onClick="CancelValue();"/> <script>document.write(wlanmacfil_language['bbsp_cancle']);</script> </button></td> 
          </tr> 
		  <tr> 
			  <td  style="display:none"> <input type='text'> </td> 
		  </tr>
      </table> 
</form>
</div>
</body>
</html>

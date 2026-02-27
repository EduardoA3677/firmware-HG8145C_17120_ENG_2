<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="../common/userinfo.asp"></script>
<script language="javascript" src="../common/topoinfo.asp"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/lanmodelist.asp"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
	
<script language="JavaScript" type="text/javascript">
var MaxVlanPairsPerPort = 4;
var MaxVlanPairs = 8;
var SelectIndex = -1;
var TableName = "tabinfo";

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
		b.innerHTML = vlan_ctc_language[b.getAttribute("BindText")];
	}
}

function IsLanPortType(BindInfo)
{
	if(BindInfo.domain.indexOf("LANEthernetInterfaceConfig") >= 0)
		return true;
	else
		return false;
}
	
function BindInfoClass(domain, Mode, Vlan, MultiCastVlanAct, MultiCastVlan)
{
	this.domain = domain;
	this.Mode = Mode;
	if(Mode == 1)
		this.Vlan = Vlan.replace(/;/g, ",");
	else
		this.Vlan = "";
	this.PortName = '';
	this.MultiCastVlanAct = MultiCastVlanAct;
    this.MultiCastVlan = MultiCastVlan;
}

function BindInfoClassByWlan(domain, Mode, Vlan)
{
	this.domain = domain;
	this.Mode = Mode;
	if(Mode == 1)
		this.Vlan = Vlan.replace(/;/g, ",");
	else
		this.Vlan = "";
	this.PortName = '';
	this.MultiCastVlanAct = 0;
    this.MultiCastVlan = 1;
}

var LanArray = new Array();
var __LanArray = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.{i},X_HW_Mode|X_HW_VLAN|X_HW_MultiCastVlanAct|X_HW_MultiCastVlan,BindInfoClass);%>;
var __SSIDArray = '<%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},X_HW_Mode|X_HW_VLAN,BindInfoClassByWlan);%>';
if (__SSIDArray.length > 0) 
{
	__SSIDArray = eval(__SSIDArray);
}
else
{
	__SSIDArray = new Array(null);
}

var wlanstate = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>'; 

for(var i = 0; i < __LanArray.length - 1; i++)
{
	__LanArray[i].PortName = 'LAN' + __LanArray[i].domain.charAt(__LanArray[i].domain.length-1)
	LanArray.push(__LanArray[i]);
}

for(var j = 0, SL = GetSSIDList(); (TopoInfo.SSIDNum != 0) && (j < SL.length) ; j++)
{		
	for(var i = 0; i < __SSIDArray.length - 1; i++)
	{
		if(__SSIDArray[i].domain == SL[j].domain)
		{
			__SSIDArray[i].PortName = "SSID" + getWlanInstFromDomain(SL[j].domain);
			LanArray.push(__SSIDArray[i]);
			
			break;
		}
	}
}

function OnPageLoad()
{
	loadlanguage();
    return true; 
}

function IsBindBindVlanValid(BindVlan)
{   
    var LanVlanWanVlanList = BindVlan.split(",");
    var LanVlan0;
    var WanVlan;
    var TempList;
    var vlanpairnum = 0;
    	
    for (var i = 0; i < LanVlanWanVlanList.length; i++)
    {
    	TempList = LanVlanWanVlanList[i].split("/");
    		
    	if (TempList.length != 2)
    	{
    		AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_vlanpainvalid1']);
    		return false;
    	}
    		
    	if ((!isNum(TempList[0])) || (!isNum(TempList[1])))
    	{
    		AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_vlanpainvalid1']);
    		return false;				
    	}
    		
    	if (!(parseInt(TempList[0],10) >= 1 && parseInt(TempList[0],10) <= 4094))
    	{
    		AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_invlan']+vlan_ctc_language['bbsp_vlanpainvalid1']);
    		return false;
    	}
    		
    	if (!(parseInt(TempList[1],10) >= 1 && parseInt(TempList[1],10) <= 4094))
    	{
    		AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_wan_vlan']+vlan_ctc_language['bbsp_vlanpainvalid1']);
    		return false;
    	}	
    	
    	vlanpairnum++;
    	
    	if (vlanpairnum > MaxVlanPairsPerPort)
    	{
    		AlertEx(vlan_ctc_language['bbsp_vp_per_port_overflow']);
    		return false;
    	}

    }

    for(var i in LanArray)
    {
    	if((LanArray[i].Vlan.length != 0) && ((SelectIndex - 1) != i))
    	{
    		vlanpairnum += LanArray[i].Vlan.split(",").length;
    	}
    }

    if (vlanpairnum > MaxVlanPairs)
    {
    	AlertEx(vlan_ctc_language['bbsp_vlanpairs_overflow']);
    	return false;
    }		

    return true;
}

function GetDnMultiActByNumber(MultiactionNumber)
{
    if (3 == MultiactionNumber)
    {
        return "specified";
    }
    else if (2 == MultiactionNumber)
    {
        return "transparenttransmission";
    }
    else if (1 == MultiactionNumber)
    {
        return "stripping";
    }
    else
    {
        return "unconcern";
    }
}

function GetDnMultiActNumberByStr(Multiaction)
{
    if ("specified" == Multiaction)
    {
        return 3;
    }
    else if ("transparenttransmission" == Multiaction)
    {
        return 2;
    }
    else if ("stripping" == Multiaction)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

function CheckParameter(BindVlan, Mode, Multiaction, Multivlan)
{
    var PortId = $("#PortId").text(); 

    if ((Mode == "vlanbinding") && (0 == BindVlan.length) )
    {
        AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_vlanisreq']);
        return false;
    }

    if (Mode == "vlanbinding")
    {
        if (IsBindBindVlanValid(BindVlan) == false)
        {
            return false;
        }
    }

    if((PortId.indexOf("SSID") >= 0) && (1 != wlanstate))
    {
    	AlertEx(vlan_ctc_language['bbsp_vlan_wifi_invalid']);
    	return false;
    }
   
    return true;
}

function FillBindInfo(Form)
{
    var BindVlan = getElById("UrlAddressControl").value.replace(/;/g, ",");
    var PortMode = getElById("ChooseDeviceType").value;

    if (CheckParameter(BindVlan, PortMode) == false)
    {
         return false;
    }
	
    Form.addParameter('z.X_HW_Mode', "0");
    
    if(PortMode == "vlanbinding")
    {
         Form.addParameter('z.X_HW_Mode', "1");
    }
    else if (PortMode == "lanwanbinding")
    {
         Form.addParameter('z.X_HW_Mode', "0");
    }

    if (BindVlan == "")
    {
         Form.addParameter('z.X_HW_VLAN', BindVlan);
    }
        
    Form.addParameter('z.X_HW_VLAN', BindVlan);

    return true;
}

function FillMultiVlanInfo(Form)
{
    if(getElementById("ChooseDeviceType").value == "lanwanbinding")
    {
        Form.addParameter('z.X_HW_MultiCastVlanAct', 0);
        Form.addParameter('z.X_HW_MultiCastVlan', 1);

        return true;
    }

    var Multiaction = getElById("ChooseDnMultiAction").value;
    var Multivlan = getElById("DnMultiVlan").value;
    
    if (Multiaction == "specified")
    {
        if (false == CheckNumber(Multivlan, 1, 4094))
        {
            AlertEx(vlan_ctc_language['bbsp_multivlan_invalid']);
            return false;
        }
    }

    Form.addParameter('z.X_HW_MultiCastVlanAct', GetDnMultiActNumberByStr(Multiaction));
    if (Multiaction == "specified")
    {
        Form.addParameter('z.X_HW_MultiCastVlan', Multivlan);
    }
    else
    {
        Form.addParameter('z.X_HW_MultiCastVlan', 1);
    }

    return true;
}

function OnApplyButtonClick()
{
    var Path = "";
    var PortId = $("#PortId").text(); 
    var i;
    if(PortId.indexOf("LAN") >= 0)
    {
        Path = "z=InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig." + PortId.charAt(PortId.length - 1); 
    }
    else if(PortId.indexOf("SSID") >= 0)
    {
        Path = "z=InternetGatewayDevice.LANDevice.1.WLANConfiguration." + PortId.charAt(PortId.length - 1); 
    }

    var Form = new webSubmitForm();

	if(getElementById("ChooseDeviceType").value == "lanwanbinding")
	{
		getElById("UrlAddressControl").value = "";
	}

    if (FillBindInfo(Form) == false)
    {
        return false;
    }

    if ((PortId.indexOf("LAN") >= 0) && (FillMultiVlanInfo(Form) == false))
    {
        return false;
    }

	Form.addParameter('x.X_HW_Token', getValue('onttoken'));

    Form.setAction('set.cgi?' +Path+ '&RequestFile=html/bbsp/vlanctc/vlanctc.asp');   
    Form.submit();
    
    return false;
}


function OnCancelButtonClick()
{
    document.getElementById("TableUrlInfo").style.display = "none";
    return false;
} 

function OnChooseDeviceType(Select)
{
    var Mode = getElementById("ChooseDeviceType").value;

    getElById("ChooseDnMultiActionRow").style.display = "none"; 
    getElById("DnMultiVlanRow").style.display = "none";  

    if (Mode == "lanwanbinding")
    {
        getElById("UrlAddressControlRow").style.display = "none";
    }
    else if (Mode == "vlanbinding")
    {
        getElById("UrlAddressControlRow").style.display = "";
        
        if (IsLanPortType(LanArray[SelectIndex -1]))
        {            
            getElById("ChooseDnMultiActionRow").style.display = ""; 
           
            if (getElById("ChooseDnMultiAction").value == "specified")
            {
                getElById("DnMultiVlanRow").style.display = "";    
            }
            else
            {
                getElById("DnMultiVlanRow").style.display = "none";         
            }  
        }
    }
}

function OnChooseDnMultiAction(Select)
{
   var Mode = getElementById("ChooseDnMultiAction").value;

   if (Mode == "specified")
   {
       getElById("DnMultiVlanRow").style.display = "";     
   }
   else
   {
       getElById("DnMultiVlanRow").style.display = "none"; 
   }
    
}

function CreateRouteList()
{       
	var TableDataInfo = new Array();
	var ShowButtonFlag = false;
	var Listlen = 0;

      for (var i = 1; i <= LanArray.length; i++)
      {  
          var modestr = "";
          if (LanArray[i-1].Mode == 0)
          {
              modestr = vlan_ctc_language['bbsp_portbind'];
          }
          else if (LanArray[i-1].Mode == 1)
          {
              modestr = vlan_ctc_language['bbsp_vlanbind'];
          }
		  
		  TableDataInfo[Listlen] = new BindInfoClass();
		  TableDataInfo[Listlen].PortName = LanArray[i-1].PortName;
		  TableDataInfo[Listlen].X_HW_Mode = modestr;
          
          if( (LanArray[i-1].Vlan == "") || (LanArray[i-1].Mode == 0))
          {
			  TableDataInfo[Listlen].X_HW_VLAN = '--';
          }
          else
          {
			  TableDataInfo[Listlen].X_HW_VLAN = LanArray[i-1].Vlan;
          }
          Listlen++;
      }  
	 TableDataInfo.push(null);
	 HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, VlanctcConfiglistInfo, vlan_ctc_language, null);
}
</script>
<title>LAN VLAN Bind Configuration</title>

</head>
<body  class="mainbody" onload="OnPageLoad();">

<div id="PromptPanel">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("vlanctctitle", GetDescFormArrayById(vlan_ctc_language, "bbsp_mune"), GetDescFormArrayById(vlan_ctc_language, "bbsp_vlan_ctc_title"), false);
</script> 
<div class="title_spread"></div>
</div>

<script language="JavaScript" type="text/javascript">
	var VlanctcConfiglistInfo = new Array(new stTableTileInfo("bbsp_port","align_center","PortName"),
								new stTableTileInfo("bbsp_portmode","align_center","X_HW_Mode"),
								new stTableTileInfo("bbsp_vlanpairs","align_center","X_HW_VLAN"),null);	
	var ColumnNum = 3;
	CreateRouteList();
</script>

<script language="JavaScript" type="text/javascript">

function ModifyInstance(index)
{
    var lanmode = LanArray[index -1].Mode;
    var vlanpair = LanArray[index -1].Vlan;
    var DnMultiVlanAct = LanArray[index -1].MultiCastVlanAct;
    var DnMultiVlan = LanArray[index -1].MultiCastVlan;

    document.getElementById("TableUrlInfo").style.display = ""; 
    getElById("UrlAddressControl").value = vlanpair;
    
	if (IsLanPortType(LanArray[index -1]) && IsL3Mode(index) == "0")
	{
		setDisable("ChooseDeviceType", 1);
	}
	else
	{
		setDisable("ChooseDeviceType", 0);
	}

    getElById("ChooseDnMultiAction").value = GetDnMultiActByNumber(DnMultiVlanAct);
    getElById("DnMultiVlan").value = DnMultiVlan;
	
    if (lanmode == 0)
    {
        getElById("ChooseDeviceType").value = "lanwanbinding";
        getElById("UrlAddressControlRow").style.display = "none";     
        getElById("ChooseDnMultiActionRow").style.display = "none"; 
        getElById("DnMultiVlanRow").style.display = "none";  
    }
    else if (lanmode == 1)
    {
        getElById("ChooseDeviceType").value = "vlanbinding"; 
        getElById("UrlAddressControlRow").style.display = "";
 
        if (IsLanPortType(LanArray[index -1]))
        {
            getElById("ChooseDnMultiActionRow").style.display = "";

            if (DnMultiVlanAct == 3)
            {
                getElById("DnMultiVlanRow").style.display = "";    
            }
            else
            {
                getElById("DnMultiVlanRow").style.display = "none";         
            }
        }
        else
        {
            getElById("ChooseDnMultiActionRow").style.display = "none"; 
            getElById("DnMultiVlanRow").style.display = "none";
        }
    }
}
 
function setControl(index) 
{ 
	SelectIndex = index + 1;
	if (index < -1)
	{
		return;
	}

	$("#PortId").text(LanArray[SelectIndex - 1].PortName);
	return ModifyInstance(SelectIndex);
}

</script>

<form id="TableUrlInfo" style="display:none">
  <div class="list_table_spread"></div>
  <table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg"> 
  		<li id="PortId" RealType="HtmlText" DescRef="bbsp_portmh" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="PortName"  InitValue="Empty" />
		<li   id="ChooseDeviceType"       RealType="DropDownList"     DescRef="bbsp_portmodemh"     RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.X_HW_Mode" 
		InitValue="[{TextRef:'bbsp_vlanbind',Value:'vlanbinding'},{TextRef:'bbsp_portbind',Value:'lanwanbinding'}]" ClickFuncApp="onchange=OnChooseDeviceType"/>                                                                   
		<li   id="UrlAddressControl"           RealType="TextBox"          DescRef="bbsp_vlanpairsmh"         RemarkRef="bbsp_note"     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.X_HW_VLAN"  Elementclass="width_300px"  Maxlength="255" InitValue="Empty"/>
		<li   id="ChooseDnMultiAction"       RealType="DropDownList"     DescRef="bbsp_multiaction"     RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.X_HW_MultiCastVlanAct" 
		InitValue="[{TextRef:'bbsp_dnmulti_unconcern',Value:'unconcern'},{TextRef:'bbsp_dnmulti_stripping',Value:'stripping'},{TextRef:'bbsp_dnmulti_transparent',Value:'transparenttransmission'},{TextRef:'bbsp_dnmulti_specified',Value:'specified'}]" ClickFuncApp="onchange=OnChooseDnMultiAction"/>                                                                   
        <li   id="DnMultiVlan"           RealType="TextBox"          DescRef="bbsp_multivlan"         RemarkRef="bbsp_multivlan_range"     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.X_HW_MultiCastVlan"  Elementclass="width_300px"  Maxlength="255" InitValue="Empty"/>
		<script language="JavaScript" type="text/javascript">
			var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
			var VlanctcConfigFormList = new Array();
			VlanctcConfigFormList = HWGetLiIdListByForm("TableUrlInfo", null);
			var formid_hide_id = null;
			HWParsePageControlByID("TableUrlInfo", TableClass, vlan_ctc_language, formid_hide_id);
		</script>
  </table>
  
  <table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button">
    <tr>
        <td class='width_per25'>
        </td>
        <td class="table_submit pad_left5p">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
            <button id="ButtonApply"  type="button" onclick="javascript:return OnApplyButtonClick();" class="ApplyButtoncss buttonwidth_100px" ><script>document.write(vlan_ctc_language['bbsp_app']);</script></button>
            <button id="ButtonCancel" type="button" onclick="javascript:OnCancelButtonClick();" class="CancleButtonCss buttonwidth_100px" ><script>document.write(vlan_ctc_language['bbsp_cancel']);</script></button>
        </td>
    </tr>
  </table>
</form>
</body>
</html>


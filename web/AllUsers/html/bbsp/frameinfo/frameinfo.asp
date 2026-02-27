<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<title>用户侧丢帧检测信息</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

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

		b.innerHTML = status_frameinfo_language[b.getAttribute("BindText")];
	}
}

function FrameInfo(domain,DetectionsState,ResultNumber,ResultTotal)
{  
    this.domain   = domain;
    this.state    = DetectionsState;
    this.number   = ResultNumber;
	this.result   = ResultTotal;
}
function DevFrameInst(mac, lostrate, delay, jetter)
{  
    this.mac        = mac;
    this.lostrate   = lostrate;
    this.delay      = delay;
	this.jetter     = jetter;
}
var FrameInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo.X_HW_Framedetection, DetectionsState|ResultNumberOfEntries|ResultTotal,FrameInfo);%>;

var state = false;
var DevFrameArray = new Array();

if (FrameInfos.length > 1)
{
    if (FrameInfos[0].state == "Complete")
	{
	    state =  true;
		
		var Idx = 0;
		records = FrameInfos[0].result.split('-');
		for (var i = 0; i < records.length; i++)
	    {
		    var temp = records[i].split(':');
	        if (temp.length != 9)
			{
			    continue;
			}
			
		    DevFrameArray[Idx] = new DevFrameInst(temp[0] + ":"+ temp[1] + ":" + temp[2] + ":" + temp[3] +":" + temp[4] +":"+ temp[5], temp[6], temp[7], temp[8]);
			Idx++;
		}
	}
}


function appendstr(str)
{
	return str;
}

function createframetable()
{
    var output = "";
    if(( false == state ) || (DevFrameArray.length == 0) )
    {			
        output = output + appendstr("<tr class=\"tabal_01\">");
        output = output + appendstr('<td class=\"align_left\">' + '--'	+ '</td>');
        output = output + appendstr('<td class=\"align_left\">' + '--'	+ '</td>');
        output = output + appendstr('<td class=\"align_left\">' + '--'	+ '</td>');
        output = output + appendstr('<td class=\"align_left\">' + '--'	+ '</td>');
        output = output + appendstr("</tr>");
    }
	else
	{
	    for(i = 0; i < DevFrameArray.length; i++)
        {
            output = output + appendstr("<tr class=\"tabal_01\">");
            output = output + appendstr('<td class=\"align_left\">' + DevFrameArray[i].mac + '</td>');
            output = output + appendstr('<td class=\"align_left\">' + DevFrameArray[i].lostrate + '</td>');
            output = output + appendstr('<td class=\"align_left\">' + DevFrameArray[i].delay + '</td>');
            output = output + appendstr('<td class=\"align_left\">' + DevFrameArray[i].jetter + '</td>');
            output = output + appendstr("</tr>");
        } 
	}
		
    $("#frameinfotitle").after(output);
}
	
</script>
</head>

<body onLoad="LoadFrame();" class="mainbody">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="prompt">
            <label id="Title_frameinfo_lable" class="title_common">在本页面上，您可以查询用户侧设备丢帧检测信息。</label>
        </td>
    </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr ><td class="height_15px"></td>
	</tr>
</table>

<div id="divFrameInfo">
<table id="frameinfo_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
    <tr>
        <td class="table_left width_25p" BindText='bbsp_frameinfo_status'></td>
        <td class="table_right"> 
        <script language="JavaScript" type="text/javascript">
            if ( true == state )
            {
                document.write(status_frameinfo_language['bbsp_frameinfo_completed'] + '&nbsp;&nbsp;');
            }
            else
            {
                document.write(status_frameinfo_language['bbsp_frameinfo_uncompleted'] + '&nbsp;&nbsp;');
            }
        </script>
    </td>
    </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr ><td class="height_15px"></td></tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" cellspacing="1" >
	<tr class="tabal_head">  
	<td BindText='bbsp_frameinfo_result'></td>
	</tr>
</table>


<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
	<tr class="table_title" id="frameinfotitle">
	    <td class="table_left width_25p" BindText='bbsp_frameinfo_devmac'></td>
	    <td class="table_left width_25p" BindText='bbsp_frameinfo_lostrate'></td>
	    <td class="table_left width_25p" BindText='bbsp_frameinfo_delay'></td>
		<td class="table_left width_25p" BindText='bbsp_frameinfo_jitter'></td>
	</tr>
	<script type="text/javascript" language="javascript">
	    createframetable();	
	</script>
</table>
</div>

</body>
</html>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<title>Automatic WiFi Shutdown</title>
<script language="JavaScript" type="text/javascript">

function stDuration(domain, StartTime, EndTime, RepeatDay)
{
    this.domain = domain;
    this.StartTime = StartTime;
    this.EndTime = EndTime;
    this.RepeatDay = RepeatDay;
}

var DurationArr = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_WLANShutDownCtrl.Duration.{i}, StartTime|EndTime|RepeatDay, stDuration);%>;


function ModifyDurtionArr()
{
    var Druationitem = new Array(null, null, null, null);
    var ItemIndex;
    
    for (var i = 0; i < 4; i++)
    {
        if (DurationArr[i] != null)
        {
            ItemIndex = GetDurationIndex(DurationArr[i].domain);
			Druationitem[ItemIndex - 1] = DurationArr[i];
        }
    }

    for (var i = 1; i < 5; i++)
    {
        if (Druationitem[i-1] == null)
        {
            Druationitem[i-1] = new stDuration("InternetGatewayDevice.LANDevice.1.X_HW_WLANShutDownCtrl.Duration."+i, "", "", "1,2,3,4,5,6,7");
        }
    }

    for (var i = 0; i < 4; i++)
    {
	    DurationArr[i] = Druationitem[i];
    }
	
}

function GetDurationIndex(DurationDomain)
{
    var textIndex = '';
    var index = 0;
    index = DurationDomain.indexOf('.Duration.', 0);
    index += '.Duration.'.length;
    return DurationDomain.substr(index, index+1) ;
}

function wlanTimeSplit(InstId, strTimeStart, strTimeEnd)
{
    var InputStart_Hour = 'time_start' + InstId + '_hour';
    var InputStart_Min = 'time_start' + InstId + '_min';
    var InputEnd_Hour = 'time_end' + InstId + '_hour';
    var InputEnd_Min = 'time_end' + InstId + '_min';        
    
    var i = strTimeStart.indexOf(':', 0);
    if (0 != i)
    {
        setText(InputStart_Hour, strTimeStart.substr(0, i));
        setText(InputStart_Min, strTimeStart.substr(i + 1));
    }

    i = strTimeEnd.indexOf(':', 0);
    if (0 != i)
    {
        setText(InputEnd_Hour, strTimeEnd.substr(0, i));
        setText(InputEnd_Min, strTimeEnd.substr(i + 1));
    }
}

function wlanRepeatSplit(InstId, strValue)
{
    var i = 0;
	
    if ('' == strValue)
    {
        return;
    }

    for (i = 1; i <= 7; i++)
    {
        var CheckID = 'repeat' + InstId + '_day' + + i;
        setCheck(CheckID, 0);
    }

    for (i = 0; i < strValue.length; i = i + 2)
    {
        var CheckID = 'repeat' + InstId + '_day' + + strValue.charAt(i);
        setCheck(CheckID, 1);
    }
}

function LoadResource()
{
    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length ; i++) 
    {
        var b = all[i];
        if(b.getAttribute("BindText") == null)
        {
            continue;
        }

        if (cfg_wlanschedule_language[b.getAttribute("BindText")]) 
        {
            b.innerHTML = cfg_wlanschedule_language[b.getAttribute("BindText")];
        }
    }
}

function LoadFrameSche()
{
    LoadResource();

    var wlanSchecuelEnable = <%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WLANShutDownCtrl.Enable);%>;
    setCheck('wlanScheEnable', wlanSchecuelEnable);    

    setDisplay('wlanShutDownCtrlTable',wlanSchecuelEnable);
    setDisplay('wlanApplyTable',wlanSchecuelEnable);
    
    ModifyDurtionArr();
	
    if (1 == wlanSchecuelEnable)
    {
        wlanTimeSplit(1, DurationArr[0].StartTime, DurationArr[0].EndTime);
        wlanTimeSplit(2, DurationArr[1].StartTime, DurationArr[1].EndTime);
        wlanTimeSplit(3, DurationArr[2].StartTime, DurationArr[2].EndTime);
        wlanTimeSplit(4, DurationArr[3].StartTime, DurationArr[3].EndTime);
    
        wlanRepeatSplit(1, DurationArr[0].RepeatDay);
        wlanRepeatSplit(2, DurationArr[1].RepeatDay);
        wlanRepeatSplit(3, DurationArr[2].RepeatDay);
        wlanRepeatSplit(4, DurationArr[3].RepeatDay);
    }  
}

function wlanScheSetEnable()
{
    var Form = new webSubmitForm();
    var enable = getCheckVal('wlanScheEnable');

    setDisplay('wlanShutDownCtrlTable',enable);
    setDisplay('wlanApplyTable',enable);

    Form.addParameter('x.Enable',enable);
    Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.X_HW_WLANShutDownCtrl'
                    + '&RequestFile=html/amp/wifische/WlanSchedule.asp');
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function dayEnable()
{

}

function isIntegerOrNull(value)
{
    if ((true != isPlusInteger(value)) && ('' != value))
    {
        return false;
    }
    
    return true;
}

function setParameterTimeCheck(Form)
{
    var time1_begin_h = getValue('time_start1_hour');
    var time2_begin_h = getValue('time_start2_hour');
    var time3_begin_h = getValue('time_start3_hour');
    var time4_begin_h = getValue('time_start4_hour');            
    
    var time1_begin_m = getValue('time_start1_min');
    var time2_begin_m = getValue('time_start2_min');
    var time3_begin_m = getValue('time_start3_min');
    var time4_begin_m = getValue('time_start4_min');        
    
    var time1_end_h = getValue('time_end1_hour');
    var time2_end_h = getValue('time_end2_hour');
    var time3_end_h = getValue('time_end3_hour');
    var time4_end_h = getValue('time_end4_hour');            
    
    var time1_end_m = getValue('time_end1_min');
    var time2_end_m = getValue('time_end2_min');
    var time3_end_m = getValue('time_end3_min');
    var time4_end_m = getValue('time_end4_min');            

    if (   ('-' == time1_begin_h.charAt(0)) || ('-' == time2_begin_h.charAt(0)) || ('-' == time3_begin_h.charAt(0)) || ('-' == time4_begin_h.charAt(0))
        || ('-' == time1_begin_m.charAt(0)) || ('-' == time2_begin_m.charAt(0)) || ('-' == time3_begin_m.charAt(0)) || ('-' == time4_begin_m.charAt(0))
        || ('-' == time1_end_h.charAt(0)) || ('-' == time2_end_h.charAt(0)) || ('-' == time3_end_h.charAt(0)) || ('-' == time4_end_h.charAt(0))
        || ('-' == time1_end_m.charAt(0)) || ('-' == time2_end_m.charAt(0)) || ('-' == time3_end_m.charAt(0)) || ('-' == time4_end_m.charAt(0))
        || ('+' == time1_begin_h.charAt(0)) || ('+' == time2_begin_h.charAt(0)) || ('+' == time3_begin_h.charAt(0)) || ('+' == time4_begin_h.charAt(0))
        || ('+' == time1_begin_m.charAt(0)) || ('+' == time2_begin_m.charAt(0)) || ('+' == time3_begin_m.charAt(0)) || ('+' == time4_begin_m.charAt(0))
        || ('+' == time1_end_h.charAt(0)) || ('+' == time2_end_h.charAt(0)) || ('+' == time3_end_h.charAt(0)) || ('+' == time4_end_h.charAt(0))
        || ('+' == time1_end_m.charAt(0)) || ('+' == time2_end_m.charAt(0)) || ('+' == time3_end_m.charAt(0)) || ('+' == time4_end_m.charAt(0))   )
    {
        AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_type_invalid']);
        return false;
    }        

    if (('' == time1_begin_h) || ('' == time1_begin_m) || ('' == time1_end_h) || ('' == time1_end_m))
    {
        if (('' != time1_begin_h) || ('' != time1_begin_m) || ('' != time1_end_h) || ('' != time1_end_m))
        {
            AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_time_empty']);
            return false;
        }
    }

    if (('' == time2_begin_h) || ('' == time2_begin_m) || ('' == time2_end_h) || ('' == time2_end_m))
    {
        if (('' != time2_begin_h) || ('' != time2_begin_m) || ('' != time2_end_h) || ('' != time2_end_m))
        {
            AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_time_empty']);
            return false;
        }
    }

    if (('' == time3_begin_h) || ('' == time3_begin_m) || ('' == time3_end_h) || ('' == time3_end_m))
    {
        if (('' != time3_begin_h) || ('' != time3_begin_m) || ('' != time3_end_h) || ('' != time3_end_m))
        {
            AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_time_empty']);
            return false;
        }
    }

    if (('' == time4_begin_h) || ('' == time4_begin_m) || ('' == time4_end_h) || ('' == time4_end_m))
    {
        if (('' != time4_begin_h) || ('' != time4_begin_m) || ('' != time4_end_h) || ('' != time4_end_m))
        {
            AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_time_empty']);
            return false;
        }
    }

    if (   ( (('0' == time4_begin_h)||('00' == time4_begin_h)) && (('0' == time4_begin_m)||('00' == time4_begin_m)) && (('0' == time4_end_h)||('00' == time4_end_h)) && (('0' == time4_end_m)||('00' == time4_end_m)) )
        || ( (('0' == time3_begin_h)||('00' == time3_begin_h)) && (('0' == time3_begin_m)||('00' == time3_begin_m)) && (('0' == time3_end_h)||('00' == time3_end_h)) && (('0' == time3_end_m)||('00' == time3_end_m)) )
        || ( (('0' == time2_begin_h)||('00' == time2_begin_h)) && (('0' == time2_begin_m)||('00' == time2_begin_m)) && (('0' == time2_end_h)||('00' == time2_end_h)) && (('0' == time2_end_m)||('00' == time2_end_m)) )
        || ( (('0' == time1_begin_h)||('00' == time1_begin_h)) && (('0' == time1_begin_m)||('00' == time1_begin_m)) && (('0' == time1_end_h)||('00' == time1_end_h)) && (('0' == time1_end_m)||('00' == time1_end_m)) )  )
    {
        AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_time_error']);
        return false;        
    }

    if (!(isIntegerOrNull(time1_begin_h) && isIntegerOrNull(time2_begin_h) && isIntegerOrNull(time3_begin_h) && isIntegerOrNull(time4_begin_h)
        && isIntegerOrNull(time1_begin_m) && isIntegerOrNull(time2_begin_m) && isIntegerOrNull(time3_begin_m) && isIntegerOrNull(time4_begin_m)
        && isIntegerOrNull(time1_end_h) && isIntegerOrNull(time2_end_h) && isIntegerOrNull(time3_end_h) && isIntegerOrNull(time4_end_h)
        && isIntegerOrNull(time1_end_m) && isIntegerOrNull(time2_end_m) && isIntegerOrNull(time3_end_m) && isIntegerOrNull(time4_end_m)))
    {
        AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_type_invalid']);
        return false;
    }

    if (('' == time1_begin_h) && ('' == time1_begin_m) && ('' == time1_end_h) && ('' == time1_end_m))
    {
        time1_begin_h = 0;
        time1_begin_m = 0;
        time1_end_h = 0;
        time1_end_m = 0;
    }

    if (('' == time2_begin_h) && ('' == time2_begin_m) && ('' == time2_end_h) && ('' == time2_end_m))
    {
        time2_begin_h = 0;
        time2_begin_m = 0;
        time2_end_h = 0;
        time2_end_m = 0;
    }

    if (('' == time3_begin_h) && ('' == time3_begin_m) && ('' == time3_end_h) && ('' == time3_end_m))
    {
        time3_begin_h = 0;
        time3_begin_m = 0;
        time3_end_h = 0;
        time3_end_m = 0;
    }

    if (('' == time4_begin_h) && ('' == time4_begin_m) && ('' == time4_end_h) && ('' == time4_end_m))
    {
        time4_begin_h = 0;
        time4_begin_m = 0;
        time4_end_h = 0;
        time4_end_m = 0;
    }

    if ((time1_begin_h > 23)||(time2_begin_h > 23)||(time3_begin_h > 23)||(time4_begin_h > 23)
        ||(time1_end_h > 23)||(time2_end_h > 23)||(time3_end_h > 23)||(time4_end_h > 23))
    {
        AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_hour_invalid']);
        return false;
    }

    if ((time1_begin_m > 59)||(time2_begin_m > 59)||(time3_begin_m > 59)||(time4_begin_m > 59)
         ||(time1_end_m > 59)||(time2_end_m > 59)||(time3_end_m > 59)||(time4_end_m > 59))
    {
        AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_min_invalid']);
        return false;
    }

    if ((time1_begin_h * 60 + time1_begin_m * 1) == (time1_end_h * 60 + time1_end_m * 1))
    {
        if ((0 != (time1_begin_h * 60 + time1_begin_m * 1)) || ( 0 != (time1_end_h * 60 + time1_end_m * 1)))
        {
            AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_time_error']);
            return false;        
        }
    }

    if ((time2_begin_h * 60 + time2_begin_m * 1) == (time2_end_h * 60 + time2_end_m * 1))
    {
        if ((0 != (time2_begin_h * 60 + time2_begin_m * 1)) || ( 0 != (time2_end_h * 60 + time2_end_m * 1)))
        {
            AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_time_error']);
            return false;        
        }
    }

    if ((time3_begin_h * 60 + time3_begin_m * 1) == (time3_end_h * 60 + time3_end_m * 1))
    {
        if ((0 != (time3_begin_h * 60 + time3_begin_m * 1)) || ( 0 != (time3_end_h * 60 + time3_end_m * 1)))
        {
            AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_time_error']);
            return false;        
        }
    }

    if ((time4_begin_h * 60 + time4_begin_m * 1) == (time4_end_h * 60 + time4_end_m * 1))
    {
        if ((0 != (time4_begin_h * 60 + time4_begin_m * 1)) || ( 0 != (time4_end_h * 60 + time4_end_m * 1)))
        {
            AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_time_error']);
            return false;        
        }
    }

    return true;
}

function repeatdayformat(repeatday)
{
    if (getCheckVal(repeatday) == 1)
    {
        var length = repeatday.length;
        var str = parseInt(repeatday.charAt(length-1));
        return str + ',';
    }

    return '';
}

function droplastsplitRepeatDay(time_repeat)
{
    var length = time_repeat.length; 
    if (0 < length)
    {
        return time_repeat.substr(0,length-1);
    }

    return '';
}

function droplastsplitTime(time_value)
{
    if (':' ==  time_value)
    {
        return '';
    }
    
    return time_value;
}

function Apply()
{
    var Form = new webSubmitForm();
    var enable = getCheckVal('wlanScheEnable');

    if (setParameterTimeCheck(Form) == false)
    {
        return false;
    }

    var time1_start = getValue('time_start1_hour') + ':' + getValue('time_start1_min');
    var time1_end = getValue('time_end1_hour') + ':' + getValue('time_end1_min');
    var time1_repeat = repeatdayformat('repeat1_day1') + repeatdayformat('repeat1_day2') + repeatdayformat('repeat1_day3') + repeatdayformat('repeat1_day4') 
                       + repeatdayformat('repeat1_day5') + repeatdayformat('repeat1_day6') + repeatdayformat('repeat1_day7');
    time1_repeat = droplastsplitRepeatDay(time1_repeat);
    time1_start = droplastsplitTime(time1_start);
    time1_end = droplastsplitTime(time1_end);

    var time2_start = getValue('time_start2_hour') + ':' + getValue('time_start2_min');
    var time2_end = getValue('time_end2_hour') + ':' + getValue('time_end2_min');
    var time2_repeat = repeatdayformat('repeat2_day1') + repeatdayformat('repeat2_day2') + repeatdayformat('repeat2_day3') + repeatdayformat('repeat2_day4') 
                       + repeatdayformat('repeat2_day5') + repeatdayformat('repeat2_day6') + repeatdayformat('repeat2_day7');
    time2_repeat = droplastsplitRepeatDay(time2_repeat);
    time2_start = droplastsplitTime(time2_start);
    time2_end = droplastsplitTime(time2_end);

    var time3_start = getValue('time_start3_hour') + ':' + getValue('time_start3_min');
    var time3_end = getValue('time_end3_hour') + ':' + getValue('time_end3_min');
    var time3_repeat = repeatdayformat('repeat3_day1') + repeatdayformat('repeat3_day2') + repeatdayformat('repeat3_day3') + repeatdayformat('repeat3_day4') 
                       + repeatdayformat('repeat3_day5') + repeatdayformat('repeat3_day6') + repeatdayformat('repeat3_day7');
    time3_repeat = droplastsplitRepeatDay(time3_repeat);
    time3_start = droplastsplitTime(time3_start);
    time3_end = droplastsplitTime(time3_end);

    var time4_start = getValue('time_start4_hour') + ':' + getValue('time_start4_min');
    var time4_end = getValue('time_end4_hour') + ':' + getValue('time_end4_min');
    var time4_repeat = repeatdayformat('repeat4_day1') + repeatdayformat('repeat4_day2') + repeatdayformat('repeat4_day3') + repeatdayformat('repeat4_day4') 
                       + repeatdayformat('repeat4_day5') + repeatdayformat('repeat4_day6') + repeatdayformat('repeat4_day7');
    time4_repeat = droplastsplitRepeatDay(time4_repeat);
    time4_start = droplastsplitTime(time4_start);
    time4_end = droplastsplitTime(time4_end);
    
    if (('' == time1_repeat) || ('' == time2_repeat) || ('' == time3_repeat) || ('' == time4_repeat))
    {
        AlertEx(cfg_wlanschedule_language['amp_wlan_schedule_week_empty']);
        return false;
    }
    
    Form.addParameter('x.StartTime',time1_start);
    Form.addParameter('x.EndTime',time1_end);
    Form.addParameter('x.RepeatDay',time1_repeat);
    
    Form.addParameter('y.StartTime',time2_start);
    Form.addParameter('y.EndTime',time2_end);
    Form.addParameter('y.RepeatDay',time2_repeat);
    
    Form.addParameter('z.StartTime',time3_start);
    Form.addParameter('z.EndTime',time3_end);
    Form.addParameter('z.RepeatDay',time3_repeat);
    
    Form.addParameter('w.StartTime',time4_start);
    Form.addParameter('w.EndTime',time4_end);
    Form.addParameter('w.RepeatDay',time4_repeat);

    Form.setAction('set.cgi?' 
                    + 'x=' + 'InternetGatewayDevice.LANDevice.1.X_HW_WLANShutDownCtrl.Duration.1'
                    + '&y=' + 'InternetGatewayDevice.LANDevice.1.X_HW_WLANShutDownCtrl.Duration.2'
                    + '&z=' + 'InternetGatewayDevice.LANDevice.1.X_HW_WLANShutDownCtrl.Duration.3'
                    + '&w=' + 'InternetGatewayDevice.LANDevice.1.X_HW_WLANShutDownCtrl.Duration.4'
                    + '&RequestFile=html/amp/wifische/WlanSchedule.asp');
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function Cancel()
{
    LoadFrameSche();
}
</script>
</head>

<body class="mainbody" onLoad="LoadFrameSche();">
<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"><tr> <td></td></tr></table>  
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("WlanSche", GetDescFormArrayById(cfg_wlanschedule_language, "amp_wlan_schedule_header"), GetDescFormArrayById(cfg_wlanschedule_language, "amp_wlan_schedule_title"), false);
</script>

<div class="title_spread"></div>

<div class="func_title"><SCRIPT>document.write(cfg_wlanschedule_language["amp_wlan_schedule_config"]);</SCRIPT></div>

<table width="100%" border="0" cellspacing="0" cellpadding="0" id="wlanScheCfg">
<tr><td>
<form id="ConfigForm" action="../network/set.cgi">
    <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
        <tr id="para_enable">
            <td class="table_title" width="100%"><input type='checkbox' id='wlanScheEnable' name='wlanScheEnable' onClick='wlanScheSetEnable();' value="OFF">
                                               <script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_enable']);</script></input></td>
        </tr>
    </table>

    <table id="wlanShutDownCtrlTable" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style="display:none">
        <tr id="para_header">
          <td class="table_title" width="1%"></td>
          <td class="table_title" width="14%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_time_start']);</script></td>
            </table>
          </td>
          <td class="table_title" width="14%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_time_end']);</script></td>
            </table>
          </td>
          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_week_mon']);</script></td>
            </table>
          </td>
          
          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">          
            <td class="table_title" width="100%"><script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_week_tue']);</script></td>
            </table>
          </td>

          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">          
            <td class="table_title" width="100%"><script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_week_wed']);</script></td>
            </table>
          </td>

          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_week_thu']);</script></td>
            </table>
          </td>

          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_week_fri']);</script></td>
            </table>
          </td>

          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_week_sat']);</script></td>
            </table>
          </td>

          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_week_sun']);</script></td>  
            </table>         
          </td>
        </tr>

        <tr id="para_time1">
          <td class="table_title" width="1%" >1</td>
          <td class="table_title" width="14%">
            <input type='text' id="time_start1_hour" name="time_start1_hour" style="width: 18px" maxlength="2">
           <script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_time_separator']);</script>
            <input type='text' id="time_start1_min" name="time_start1_min" style="width: 18px" maxlength="2">
          </td>
          <td class="table_title" width="14%">
            <input type='text' id="time_end1_hour" name="time_end1_hour" style="width: 18px" maxlength="2">
            <script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_time_separator']);</script>
            <input type='text' id="time_end1_min" name="time_end1_min" style="width: 18px" maxlength="2">
          </td>

          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat1_day1' name='repeat1_day1' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>

          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat1_day2' name='repeat1_day2' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>

          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat1_day3' name='repeat1_day3' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>

          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat1_day4' name='repeat1_day4' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>

          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat1_day5' name='repeat1_day5' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>

          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat1_day6' name='repeat1_day6' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>


          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat1_day7' name='repeat1_day7' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>
        </tr>
        
        <tr id="para_time2">
          <td class="table_title" width="1%">2</td>
          <td class="table_title" width="14%">
            <input type='text' id="time_start2_hour" name="time_start2_hour" style="width: 18px" maxlength="2">
            <script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_time_separator']);</script>
           <input type='text' id="time_start2_min" name="time_start2_min" style="width: 18px" maxlength="2">
          </td>
          <td class="table_title" width="14%">
            <input type='text' id="time_end2_hour" name="time_end2_hour" style="width: 18px" maxlength="2">
            <script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_time_separator']);</script>
            <input type='text' id="time_end2_min" name="time_end2_min" style="width: 18px" maxlength="2">
          </td>
          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat2_day1' name='repeat2_day1' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>

        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat2_day2' name='repeat2_day2' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>
          
        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat2_day3' name='repeat2_day3' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>

        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat2_day4' name='repeat2_day4' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>


        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat2_day5' name='repeat2_day5' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>

        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat2_day6' name='repeat2_day6' onClick='dayEnable();' value="OFF"></td>
            </table>         
          </td>

        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat2_day7' name='repeat2_day7' onClick='dayEnable();' value="OFF"></td>
            </table>
          </td>
        </tr>
        
        <tr id="para_time3">
            <td class="table_title" width="1%">3</td>
          <td class="table_title" width="14%">
            <input type='text' id="time_start3_hour" name="time_start3_hour" style="width: 18px" maxlength="2">
            <script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_time_separator']);</script>
            <input type='text' id="time_start3_min" name="time_start3_min" style="width: 18px" maxlength="2">
          </td>
          <td class="table_title" width="14%">
            <input type='text' id="time_end3_hour" name="time_end3_hour" style="width: 18px" maxlength="2">
            <script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_time_separator']);</script>
            <input type='text' id="time_end3_min" name="time_end3_min" style="width: 18px" maxlength="2">
          </td>
          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat3_day1' name='repeat3_day1' onClick='dayEnable();' value="OFF"></td>
            </table>            
          </td>

        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat3_day2' name='repeat3_day2' onClick='dayEnable();' value="OFF"></td>
            </table>            
          </td>

        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat3_day3' name='repeat3_day3' onClick='dayEnable();' value="OFF"></td>
            </table>            
          </td>
          
        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat3_day4' name='repeat3_day4' onClick='dayEnable();' value="OFF"></td>
            </table>            
          </td>

        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat3_day5' name='repeat3_day5' onClick='dayEnable();' value="OFF"></td>
            </table>            
          </td>

        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat3_day6' name='repeat3_day6' onClick='dayEnable();' value="OFF"></td>
            </table>            
          </td>
          
        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat3_day7' name='repeat3_day7' onClick='dayEnable();' value="OFF"></td>
            </table>            
          </td>
        </tr>
        
        <tr id="para_time4">
            <td class="table_title" width="1%">4</td>
          <td class="table_title" width="14%">
            <input type='text' id="time_start4_hour" name="time_start4_hour" style="width: 18px" maxlength="2">
            <script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_time_separator']);</script>
           <input type='text' id="time_start4_min" name="time_start4_min" style="width: 18px" maxlength="2">
          </td>
          <td class="table_title" width="14%">
            <input type='text' id="time_end4_hour" name="time_end4_hour" style="width: 18px" maxlength="2">
            <script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_time_separator']);</script>
            <input type='text' id="time_end4_min" name="time_end4_min" style="width: 18px" maxlength="2">
          </td>
          
          <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat4_day1' name='repeat4_day1' onClick='dayEnable();' value="OFF"></td>
            </table>           
          </td>

        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat4_day2' name='repeat4_day2' onClick='dayEnable();' value="OFF"></td>
            </table>           
          </td>


        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat4_day3' name='repeat4_day3' onClick='dayEnable();' value="OFF"></td>
            </table>           
          </td>

        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat4_day4' name='repeat4_day4' onClick='dayEnable();' value="OFF"></td>
            </table>           
          </td>

        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat4_day5' name='repeat4_day5' onClick='dayEnable();' value="OFF"></td>
            </table>           
          </td>

        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat4_day6' name='repeat4_day6' onClick='dayEnable();' value="OFF"></td>
            </table>           
          </td>
          
        <td class="table_title" width="10%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat4_day7' name='repeat4_day7' onClick='dayEnable();' value="OFF"></td>
            </table>           
          </td>
        </tr>
    </table>

    <table id="wlanApplyTable" width="100%" border="0" cellpadding="0" cellspacing="0" style="display:none">
      <tr><td>
        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
          <tr>
            <td class="table_submit width_per25"></td>
            <td class="table_submit"> 
			  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
              <button id="applyButton" name="applyButton" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="Apply();"><script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_apply']);</script></button>
              <button id="cancelButton" name="cancelButton" type="button" class="CancleButtonCss buttonwidth_100px" onClick="Cancel();"><script>document.write(cfg_wlanschedule_language['amp_wlan_schedule_cancel']);</script></button>
            </td>
          </tr>
        </table>
      </td></tr>
    </table>
 
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr ><td class="width_15px"></td></tr>
    </table> 

</form>
</td></tr>
</table>
<!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd -->
</html>



function stTopoSsid(Domain, SsidNum)
{   
    this.Domain = Domain;
    this.SsidNum = SsidNum;
}
var TopoSsidInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Topo,X_HW_SsidNum, stTopoSsid);%>
var TopoSsidInfo = TopoSsidInfoList[0];
var PccwFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PCCW);%>'; 
var kppUsedFlag = '<%HW_WEB_GetFeatureSupport(FT_WLAN_PWD_KPP_USED);%>';

var CfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 
var curUserType = '<%HW_WEB_GetUserType();%>';
function IsSonetSptUser()
{
    if(('<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SONET);%>' == 1) && curUserType != '0')
    {
        return true;
    }
    else
    {
        return false;
    }
}

function IsCaribbeanReg()
{
	if('DIGICEL' == CfgModeWord.toUpperCase() || 'DIGICEL2' == CfgModeWord.toUpperCase())  
    {
    	return true;
    }
	else
    {
    	return false;
    }
}

function IsPTVDFSptUser()
{
	if(('<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PTVDF);%>' == 1) && curUserType != '0')
    {
    	return true;
    }
	else
    {
    	return false;
    }
}

function IsRDSGatewayUserSsid(index)
{
	if ('RDSGATEWAY' == CfgModeWord.toUpperCase() && curUserType != '0' && index > 1)
    {
    	return true;
    }
	else
    {
    	return false;
    }
}

function stWlanInfo(domain,name,ssid,X_HW_ServiceEnable,enable,bindenable)
{
    this.domain = domain;
    this.name = name;
    this.ssid = ssid;
    this.X_HW_ServiceEnable = X_HW_ServiceEnable;
    this.enable = enable;
    this.bindenable = bindenable;
}

function stWlanEnable(domain,enable)
{
    this.domain = domain;
    this.enable = enable;
}

var WlanEnable = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1, X_HW_WlanEnable,stWlanEnable,EXTEND);%>

var WlanInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|SSID|X_HW_ServiceEnable|Enable,stWlanInfo);%>
if (WlanInfo.length > 0) 
{
	WlanInfo = eval(WlanInfo);
}
else
{
	WlanInfo = new Array(null);
}

var WlanList = new Array();


for ( i = 0 ; i < TopoSsidInfo.SsidNum ; i++ )
{
    var tid = parseInt(i+1);
    WlanList[i] = new stWlanInfo('domain','SSID'+tid,'','0','1','0');
}

for ( i = 0 ; i < WlanInfo.length - 1 ; i++ )
{
    var length = WlanInfo[i].name.length;

    if ('' == WlanInfo[i].name)
    {
        continue;
    }

    var wlanInst = getWlanInstFromDomain(WlanInfo[i].domain);
    wlanInst = wlanInst-1; 
    if(1 == PccwFlag)
    {
        WlanList[wlanInst].bindenable = 1;
    }
    else
    {
        if ( (1 == WlanInfo[i].enable) && (1 == WlanEnable[0].enable) &&  (1 == WlanInfo[i].X_HW_ServiceEnable) )
        {
            WlanList[wlanInst].bindenable = 1;
        }
        else
        {
            WlanList[wlanInst].bindenable = 0;
        }
    }
}    


function GetWlanList()
{
    return WlanList;
}



var DTHungaryFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DT_HUNGARY);%>';

var TwoSsidCustomizeGroup = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_GZCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_JSCT);%>' 
                             | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_NXCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_HUNCT);%>' 
                             | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_GSCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SZCT);%>' 
                             | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_QHCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_HLJCT);%>' 
                             | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_JXCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_XJCT);%>'
                             | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_JLCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_HAINCT);%>'
                             | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SCCT);%>' | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_YNCT);%>'
                             | '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_CQCT);%>';

function GetSSIDStringContent(str, Length)
{
    if(null != str)
    {
    	str = str.toString().replace(/&nbsp;/g," ");
    	str = str.toString().replace(/&quot;/g,"\"");
    	str = str.toString().replace(/&gt;/g,">");
    	str = str.toString().replace(/&lt;/g,"<");
    	str = str.toString().replace(/&#39;/g, "\'");
    	str = str.toString().replace(/&#40;/g, "\(");
    	str = str.toString().replace(/&#41;/g, "\)");
		str = str.toString().replace(/&amp;/g,"&");
    }

	if (str.length > Length)
    {
        str=str.substr(0, Length) + "......";
    }

	if(null != str)
    {
    	str = str.toString().replace(/&/g,"&amp;");
    	str = str.toString().replace(/ /g,"&nbsp;");
    	str = str.toString().replace(/\"/g,"&quot;");
    	str = str.toString().replace(/>/g,"&gt;");
    	str = str.toString().replace(/</g,"&lt;");
    	str = str.toString().replace(/\'/g, "&#39;");
    	str = str.toString().replace(/\(/g, "&#40;");
    	str = str.toString().replace(/\)/g, "&#41;");
    }

    return str;
}

function GetStringContent(str, Length)
{
	if (str.length > Length)
    {
        	str = str.toString().replace(/&nbsp;/g," ");
        	str = str.toString().replace(/&quot;/g,"\"");
        	str = str.toString().replace(/&gt;/g,">");
        	str = str.toString().replace(/&lt;/g,"<");
        	str = str.toString().replace(/&#39;/g, "\'");
        	str = str.toString().replace(/&#40;/g, "\(");
        	str = str.toString().replace(/&#41;/g, "\)");
        	str = str.toString().replace(/&amp;/g,"&");

        	var strNewLength = str.length;
        	if(strNewLength > Length )
            {
            	str=str.substr(0, Length) + "......";
            }
        	else
            {
            	str=str.substr(0, Length);
            }
        	str = str.toString().replace(/&/g,"&amp;");
        	str = str.toString().replace(/>/g,"&gt;");
        	str = str.toString().replace(/</g,"&lt;");
        	str = str.toString().replace(/ /g,"&nbsp;");
        	return str;
    }
	str = str.toString().replace(/ /g,"&nbsp;");
	return str;
}

function stIspWlan(domain, SSID_IDX)
{
    this.domain = domain;
    this.SSID_IDX = SSID_IDX;
}

var IspWlanInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.X_HW_WLANForISP.{i}, SSID_IDX, stIspWlan, EXTEND);%>;

function getWlanInstFromDomain(domain)
{
    var str = parseInt(domain.charAt(52));
    return str;
}

function isSsidForIsp(index)
{
    for (var i = 0; i < (IspWlanInfo.length - 1); i++)
    {
        if (IspWlanInfo[i].SSID_IDX == index)
        {
            return 1;
        }
    }
    
    return 0;
}

function stRadio(domain,OperatingFrequencyBand,Enable)
{
    this.domain = domain;
    this.OperatingFrequencyBand = OperatingFrequencyBand;
    this.Enable = Enable;
}

function WlanInfoRefresh()
{
    var ChanInfo = '<%HW_WEB_GetChanInfo();%>';

	if ((1 == DoubleFreqFlag) && (2 == top.changeWlanClick))
    {
    	WlanChannel = ChanInfo.split(',')[1];
    }
    else
    {
        WlanChannel = ChanInfo.split(',')[0];
    }

	if (1 == DoubleFreqFlag)
    {
    	var Radio  = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WiFi.Radio.{i},OperatingFrequencyBand|Enable,stRadio,EXTEND);%>;
    	try{
        	if ((1 == wlanEnbl) && (1 == Radio[top.changeWlanClick - 1].Enable))
            {
            	wlanEnbl = 1;
            }
        	else
            {
            	wlanEnbl = 0;
            }
        }catch(e){ wlanEnbl = 0; }
    }
}

var SingleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_SINGLE_WLAN);%>';
var DoubleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>';
var enbl2G = 0;
var enbl5G = 0;
var node2G = 'InternetGatewayDevice.LANDevice.1.WiFi.Radio.1';
var node5G = 'InternetGatewayDevice.LANDevice.1.WiFi.Radio.2';

var Radio  = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WiFi.Radio.{i},OperatingFrequencyBand|Enable,stRadio,EXTEND);%>;
if(Radio.length <= 1)
{
}
else if(Radio.length == 2)
{
    enbl2G = Radio[0].Enable;   
    enbl5G = Radio[0].Enable;   
    node2G = 'InternetGatewayDevice.LANDevice.1.WiFi.Radio.1';
    node5G = 'InternetGatewayDevice.LANDevice.1.WiFi.Radio.2';
}
else if ('2.4GHz' == Radio[0].OperatingFrequencyBand)
{
    enbl2G = Radio[0].Enable;   
    enbl5G = Radio[1].Enable;   
    node2G = 'InternetGatewayDevice.LANDevice.1.WiFi.Radio.1';
    node5G = 'InternetGatewayDevice.LANDevice.1.WiFi.Radio.2';
}
else if ('5GHz' == Radio[0].OperatingFrequencyBand)
{
    enbl2G = Radio[1].Enable;   
    enbl5G = Radio[0].Enable;   
    node2G = 'InternetGatewayDevice.LANDevice.1.WiFi.Radio.2';
    node5G = 'InternetGatewayDevice.LANDevice.1.WiFi.Radio.1';
}
else
{
}

function isWlanInitFinished(freq, mode, width)
{
    var finishFlag = false;
    
    var country = 'CN';
    
    $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "../common/WlanChannel.asp?&1=1",
            data :"freq="+freq+"&country="+country+"&standard="+mode + "&width="+width,
            success : function(data) {
                if(null != data && '' != data && data.length>2)
                {
                    finishFlag = true;
                }
            }
        });

    if(!finishFlag)
    {
        alert(cfg_wlancfgbasic_language['amp_wlan_not_init']);
    }

    return finishFlag;
}

function stSSIDInfo(domain,name,enable)
{
    this.domain = domain;
    this.name   = name;
    this.enable = enable;
}

var SSIDList = new Array();
for ( var i = 0 ; i < WlanInfo.length - 1 ; i++ )
{
    var length = WlanInfo[i].name.length;

    var wlanInst = getWlanInstFromDomain(WlanInfo[i].domain);
    
    if ( (0 == WlanInfo[i].X_HW_ServiceEnable) || (1 == isSsidForIsp(wlanInst)) )
    {
        continue;
    }
    else if (true == IsRDSGatewayUserSsid(wlanInst))
    {
        continue;
    }
    else
    {
        SSIDList.push(new stSSIDInfo(WlanInfo[i].domain, 'SSID' + wlanInst, WlanInfo[i].enable));
    }
}

SSIDList.sort(function(s1, s2)
    {
        return parseInt(s1.name.charAt(s1.name.length - 1), 10) - parseInt(s2.name.charAt(s2.name.length - 1), 10);
    }
);

function GetSSIDList()
{
    return SSIDList;
}

function GetSSIDNameByDomain(domain)
{
    var SL = GetSSIDList();        
    for(var i in SL)
    {
        if(SL[i].domain == domain)
            return SL[i].name;
    }        
    return '';
}

function GetSSIDDomainByName(name)
{
    var SL = GetSSIDList();        
    for(var i in SL)
    {
        if(SL[i].name == name)
            return SL[i].domain;
    }        
    return '';
}

function GetSSIDStatusByName(name)
{
    var SL = GetSSIDList();        
    for(var i in SL)
    {
        if(SL[i].name == name)
            return SL[i].enable;
    }        
    return '';
}

function IsVisibleSSID(name)
{
    var SL = GetSSIDList();        
    
    for(var i in SL)
    {        
        if(SL[i].name == name)
            return true;
    }        
    return false;
}

function fixIETableScroll(id_div, id_tb)
{
	try{
	if(navigator.appName.indexOf("Internet Explorer") != -1)
    {
    	var divv = $('#' + id_div);
    	var tbb = $('#' + id_tb);
        
    	if(tbb.width() > divv.width())
        {
        	divv.css("padding-bottom", "17px");
        }
    }}catch(e){}
}

function getFirstSSIDPccw(radioId, info)
{
	var wlanInst = (radioId==1)?1:5;
    
	if (1 == isSsidForIsp(wlanInst))
    {
        return null;
    }

    for( var i = 0; i < info.length; i++)
    {
        if (wlanInst != getWlanInstFromDomain(info[i].domain))
        {
            continue;
        }
        
    	if(0 == info[i].X_HW_ServiceEnable)
        	return null;
            
    	info[i].InstId = wlanInst;
        return info[i];
    }

	return null;
}

function getFirstSSIDInst(radioId, info)
{
	if( (radioId < 1) || (radioId > 2) ||
            ((0 == DoubleFreqFlag) && (2 == radioId)))
    {
    	return null;
    }

	try{
    
	if(1 == PccwFlag)
    {
    	return getFirstSSIDPccw(radioId, info);
    }
    
	for( var i = 0; i < info.length; i++)
    {
    	var ssid = info[i].name;
    	if('' == ssid)
        {
        	continue;
        }

    	ssid = parseInt(ssid.charAt(ssid.length - 1), 10);
        
    	if((ssid>3 && radioId==1) || (ssid<=3 && radioId==2))
        {
        	continue;
        }
        
    	var wlanInst = getWlanInstFromDomain(info[i].domain);
    
        if (1 == isSsidForIsp(wlanInst))
        {
            continue;
        }
        
    	info[i].InstId = wlanInst;
        
        return info[i];
        
    }

    }catch(e){ return null; }
    
	return null;
}

function getPsk(wlanInst, info)
{
	try{
	for( var i = 0; i < info.length-1; i++)
    {
    	if(wlanInst == parseInt(info[i].domain.charAt(52), 10))
        {
        	return info[i].value;
        }
        
    }}catch(e){ return ""; }
    
	return "";    
}


function getWep(wlanInst, wepKeyInst, info)
{
	try{
	for( var i = 0; i < info.length-1; i++)
    {
    	if((wlanInst == parseInt(info[i].domain.charAt(52), 10)) &&
            (wepKeyInst == parseInt(info[i].domain.charAt(61), 10)))
        {
        	return info[i].value;
        }
        
    }}catch(e){ return ""; }
    
	return "";    
}

function checkSSIDExist(wlan, info)
{
	try{
	var radioId = 0;
	var cur_ssid = parseInt(wlan.name.charAt(wlan.name.length - 1), 10);
    
	radioId = cur_ssid<4?1:2;

	for( var i = 0; i < info.length-1; i++)
    {
    	var ssid = info[i].name;
    	if('' == ssid)
        {
        	continue;
        }

    	ssid = parseInt(ssid.charAt(ssid.length - 1), 10);

    	if((ssid>3 && radioId==1) || (ssid<=3 && radioId==2))
        {
        	continue;
        }
    
    	if((cur_ssid != ssid)
                && (TextTranslate(info[i].ssid) == wlan.ssid))
        {
        	AlertEx(cfg_wlancfgother_language['amp_ssid_exist']);
        	return true;
        }
        
    }}catch(e){ return false; }
    
	return false;    
}

function CheckSsid(ssid)
{
    if (ssid == '')
    {
        AlertEx(cfg_wlancfgother_language['amp_empty_ssid']);
        return false;
    }

    if (ssid.length > 32)
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_too_loog']);
        return false;
    }

    if (isValidAscii(ssid) != '')
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_invalid'] + isValidAscii(ssid));
        return false;
    }

	return true;
}

function CheckPsk(value)
{	
	if (value == '')
	{
		alert(cfg_wlancfgother_language['amp_empty_para']);
		return false;
	}
	
	if (isValidWPAPskKey(value) == false)
	{
		alert(cfg_wlancfgdetail_language['amp_wpskey_invalid']);
		return false;
	}

	return true;
}

function CheckSsidExist(ssid, WlanArr)
{
    for (i = 1; i < WlanArr.length - 1; i++)
    {
        if (TextTranslate(WlanArr[i].ssid) == ssid)
		{
			AlertEx(cfg_wlancfgother_language['amp_ssid_exist']);
			return false;
		}
        else
        {
            continue;
        }
    }

    return true;
}

function isValidWPAPskKey(val)
{
    var ret = false;
    var len = val.length;
    var maxSize = 64;
    var minSize = 8;
 
    if (isValidAscii(val) != '')
    {
       return false;
    }

    if ( len >= minSize && len < maxSize )
    {
    	ret = true;
    }
    else if ( len == maxSize )
    {
        for ( i = 0; i < maxSize; i++ )
            if ( isHexaDigit(val.charAt(i)) == false )
                break;
        if ( i == maxSize )
            ret = true;
    }
    else
    {
        ret = false;
    }
    
    return ret;
}

var L2WifiFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_L2WIFI);%>';

function IsWlanAvailable()
{
	if(1 == '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>')
	{
		return true;
	}
	else
	{
		return false;
	}
}

var capInfo = '<%HW_WEB_GetSupportAttrMask();%>';

var wepCap = 1;
var fragCap = 1;
var radiusCap = 1;
var wps1Cap = 1;
var wapiCap = 1;
var cap11n = 1;
var cap11a = 1;
var capTkip = 1;
var capWPAPSK = 1;
var capWPAEAP = 1;
var capWPAWPA2PSK = 1;
var capWPAWPA2EAP = 1;

function initWlanCap(freq)
{
    if(null == capInfo || '' == capInfo || capInfo.length < capNum*2)
    {
        return ;
    }

    var capNum = capInfo.length/2;

    var baseIdx = capNum * ((freq=="5G") ? 1 : 0);

    wepCap = parseInt(capInfo.charAt(0 + baseIdx));
    fragCap = parseInt(capInfo.charAt(1 + baseIdx));
    radiusCap = parseInt(capInfo.charAt(2 + baseIdx));
    wps1Cap = parseInt(capInfo.charAt(3 + baseIdx));
    wapiCap = parseInt(capInfo.charAt(4 + baseIdx));
    cap11n = parseInt(capInfo.charAt(5 + baseIdx));
    cap11a = parseInt(capInfo.charAt(6 + baseIdx));
    capTkip = parseInt(capInfo.charAt(7 + baseIdx));
    capWPAPSK = parseInt(capInfo.charAt(8 + baseIdx));
    capWPAEAP = parseInt(capInfo.charAt(9 + baseIdx));
    capWPAWPA2PSK = parseInt(capInfo.charAt(10 + baseIdx));
    capWPAWPA2EAP = parseInt(capInfo.charAt(11 + baseIdx));
}

function getPossibleChannels(freq, country, mode, width)
{
    $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "../common/WlanChannel.asp?&1=1",
            data :"freq="+freq+"&country="+country+"&standard="+mode + "&width="+width,
            success : function(data) {
                possibleChannels = data;
            }
        });
}

function isValidKey(val, size)
{
    var ret = false;
    var len = val.length;
    var dbSize = size * 2;
 
    if (isValidAscii(val) != '')
    { 
        return false;
    }

    if ( len == size )
       ret = true;
    else if ( len == dbSize )
    {
       for ( i = 0; i < dbSize; i++ )
          if ( isHexaDigit(val.charAt(i)) == false )
             break;
       if ( i == dbSize )
          ret = true;
    }
    else
      ret = false;

   return ret;
}

function ltrim(str)
{ 
    return str.toString().replace(/(^\s*)/g,""); 
}

function InitDropDownListWithSelected(id, valueTextPair, selected)
{
	var obj = $('#' + id);
	if(0==obj.length || null==valueTextPair)
	{
		return ;
	}

	var isSelectedValid = false;

	obj.empty();
	
	for(var key in valueTextPair)
	{
		if((1 == valueTextPair[key].length) || (1 == valueTextPair[key][1]))
		{
			obj.append("<option value='" + key + "'>" + valueTextPair[key][0] + "</option>");
			
			if(!isSelectedValid && selected==key)
	        {
	        	isSelectedValid = true;
	        	setSelect(id, selected);
	        }
		}
	}
}


var tdeSpecailChar = ['Á','á','À','à','É','é','Í','í','Ó','ó',
                      'Ú','ú','Â','â','Ê','ê','Î','î','ö','Û',
					  'û','Ü','ü','Ç','ç','Ã','ã','Õ','õ','Ñ',
					  'ñ','€','´','•','¸','Ò','ò','Ù','ù','È',
					  'è','Ì','ì','Ï','ï','ª','¿','º'];
 

function checkSepcailStrValid(val)
{
    var findVar = 0;
	
    for ( var i = 0 ; i < val.length ; i++ )
	{
		var ch = val.charAt(i);
		if (ch >= ' ' && ch <=  '~')
		{
		    continue;
		}		
		else
		{
		    findVar = 0;
		    for (var j = 0; j < tdeSpecailChar.length; j++)
	        {
		        if(ch == tdeSpecailChar[j])
		        {
			        findVar = 1;
			        break;
		        }
	        }
			
			if (1 != findVar)
			{
			    return false;
			}
	        
		}
	}
	return true;
}

function getTDEStringActualLen(val)
{
    var actualLen = 0;
	for( var i = 0; i < val.length; i++ )
	{
	    var ch = val.charAt(i);
		if (ch >= ' ' && ch <=  '~')
		{
		    actualLen = actualLen + 1;
		}
        else
        {
		     if('€' == ch || '•' == ch)
			 {
			     actualLen = actualLen + 3;
			 }
			 else
			 {
			     actualLen = actualLen + 2;
			 }
		} 		
	}
	
	return actualLen;
}

function isValidWPAPskSepcialKey(value)
{
    var len = value.length;
    var maxSize = 63;
    var minSize = 8;
	var i = 0;
	var actualLen = 0;
	var spaceNum = 0;
	
    if (value == '')
    {
        AlertEx(cfg_wlancfgdetail_language['amp_wifipwd_invalid']);
        return false;
    }
	
	if ( len < minSize ||  len > maxSize )
    {
        AlertEx(cfg_wlancfgdetail_language['amp_wifipwd_invalid']);
    	return false;
    }

    if(value.charAt(0)==' ' || value.charAt(len-1)==' ')
    {
        AlertEx(cfg_wlancfgdetail_language['amp_wifipwd_space_invalid']);
    	return false;
    }

    for(i=0, spaceNum=0; (i < value.length) && (spaceNum != 2); i++)
    {
        if(value.charAt(i) == ' ')
        {
            spaceNum++;
        }
        else
        {
            spaceNum = 0;
        }
    }

    if(i != value.length)
    {
        AlertEx(cfg_wlancfgdetail_language['amp_wifipwd_space_invalid']);
    	return false;
    }
	
	if (true != checkSepcailStrValid(value))
    {
        AlertEx(cfg_wlancfgdetail_language['amp_wifipwd_invalid']);
        return false;
    }
	
	actualLen = getTDEStringActualLen(value);
	if( actualLen < minSize  || actualLen > maxSize )
	{
	    AlertEx(cfg_wlancfgdetail_language['amp_wifipwd_invalid']);
	    return false;
	}
	
    return true;
}

function checkHexNumWithLen(val, len)
{
    if(null == val || len != val.length)
        return false;

    for(var i=0; i<len; i++)
    {
        if (isHexaDigit(val.charAt(i)) == false)
        {
            return false;
        }
    }
    
    return true;
}

function isValidRaiusKey(val)
{
   if (isValidAscii(val) != '')
   { 
      return false;
   }
    
   return true;
}


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<title>VOIP User</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(voicedes.html);%>"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="JavaScript" type="text/javascript">
var CfgMode = '<%HW_WEB_GetCfgMode();%>';
var MngtShct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SHCT);%>';
var CUVoiceFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_UNICOM_DIS_VOICE);%>";
var selctIndex = -1;
var selctLindex = 0;
var POTSNum = 2;
var vagIndex = 0;

var vagLastInst = '<%HW_WEB_GetVoiceVagIndex();%>';

function GetVagIndexByInst(vagInst)
{
    for(var i = 0; i < Profile.length-1; i++)
    {
        if(Profile[i].profileid == vagInst)
        {
            return i;
        }
    }
    
    return 0;
}

function stProfile(Domain, HW_DtmfMethod, HW_ServerType, X_HW_PortName, X_HW_Option120PriorityMode)
{
    this.Domain = Domain;
    this.HW_DtmfMethod = HW_DtmfMethod;
    this.HW_ServerType = HW_ServerType;
	this.X_HW_PortName = X_HW_PortName;
	this.X_HW_Option120PriorityMode = X_HW_Option120PriorityMode;
    var temp = Domain.split('.');
    this.profileid = temp[5];
}

var Profile = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i},DTMFMethod|X_HW_ServerType|X_HW_PortName|X_HW_Option120PriorityMode,stProfile);%>;
vagIndex = GetVagIndexByInst(vagLastInst);

function stSIPServer(Domain, UserAgentPort, RegisterExpires, RegisterRetryInterval,X_HW_SessionUpdateTimer,X_HW_URIType,X_HW_PRACKEnable,X_HW_BootDeRegisterEnable, X_HW_TWaitTimeMode, X_HW_OutNumberContainImmediateDialKeyEnable, X_HW_SubscribeEnable,DSCPMark)
{
	this.Domain = Domain;
	this.UserAgentPort = UserAgentPort;
	this.RegisterExpires = RegisterExpires;
	this.RegisterRetryInterval = RegisterRetryInterval;
	this.X_HW_SessionUpdateTimer = X_HW_SessionUpdateTimer;
	this.X_HW_URIType = X_HW_URIType;
	this.X_HW_PRACKEnable = X_HW_PRACKEnable;
	this.X_HW_BootDeRegisterEnable = X_HW_BootDeRegisterEnable;
	this.X_HW_TWaitTimeMode = X_HW_TWaitTimeMode;
	this.X_HW_OutNumberContainImmediateDialKeyEnable = X_HW_OutNumberContainImmediateDialKeyEnable;
	this.X_HW_SubscribeEnable = X_HW_SubscribeEnable;	
	this.DSCPMark = DSCPMark;
}
var AllSIPServer = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.SIP,UserAgentPort|RegisterExpires|RegisterRetryInterval|X_HW_SessionUpdateTimer|X_HW_URIType|X_HW_PRACKEnable|X_HW_BootDeRegisterEnable|X_HW_TWaitTimeMode|X_HW_OutNumberContainImmediateDialKeyEnable|X_HW_SubscribeEnable|DSCPMark,stSIPServer);%>;


function stRtp(Domain, LocalPortMin, LocalPortMax,X_HW_PortName,DSCPMark)
{
    this.Domain = Domain;
    this.LocalPortMin = LocalPortMin;
	this.LocalPortMax = LocalPortMax;
	this.X_HW_PortName = X_HW_PortName;
	this.DSCPMark = DSCPMark;
}
var Rtp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.RTP, LocalPortMin|LocalPortMax|X_HW_PortName|DSCPMark, stRtp);%>;


function stPhyInterface(Domain, InterfaceID )
{
    this.Domain = Domain;
}

var AllPhyInterface = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.PhyInterface.{i},InterfaceID,stPhyInterface);%>;


function stLine(Domain, DirectoryNumber, Enable, PhyReferenceList )
{
    this.Domain = Domain;
    this.DirectoryNumber = DirectoryNumber;
    this.PhyReferenceList = PhyReferenceList;

    if (Enable.toLowerCase() == 'enabled')
    {
        this.Enable = 1;
    }
    else
    {
        this.Enable = 0;
    }
}

var AllLine = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i},DirectoryNumber|Enable|PhyReferenceList,stLine);%>;

var LineList = new Array(new Array(),new Array(),new Array(),new Array());
for (var i = 0; i < AllLine.length-1; i++)
{
    var temp = AllLine[i].Domain.split('.');
    var index = GetVagIndexByInst(temp[5]);
    LineList[index].push(AllLine[i]);
}

function stAuth(Domain, URI, AuthUserName)
{
    this.Domain = Domain;
    this.URI = URI;
    this.AuthUserName = AuthUserName;
}

var AllAuth = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.SIP,URI|AuthUserName,stAuth);%>;

var AuthList = new Array(new Array(),new Array(),new Array(),new Array());
for (var i = 0; i < AllAuth.length-1; i++)
{
    var temp = AllAuth[i].Domain.split('.');
    var index = GetVagIndexByInst(temp[5]);
    AuthList[index].push(AllAuth[i]);
}

var recordDirectoryNumber;

function SelectLineRecord(recordId)
{
    var temp = recordId.split('_');    
    selctLindex = temp[1];
    selectLine(recordId);
    setPhyList("PhyList");
    setPhyInterfaceParams();
    setDspTemplatePara();
}

function stSIPExtend(Domain, HW_ShareUserMode, HW_MultiHomeMode, SoftwareParameters)
{
    this.Domain = Domain;
    this.HW_ShareUserMode = HW_ShareUserMode;
    this.HW_MultiHomeMode = HW_MultiHomeMode;
    this.SoftwareParameters = SoftwareParameters;
}
var SIPExtend = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.SIP.X_HW_SIPExtend,SharedUserMode|MultiHomeMode|SoftwareParameters,stSIPExtend);%>;

function stRfc2833PT(Domain, HW_Rfc2833PT)
{
    this.Domain = Domain;
    this.HW_Rfc2833PT = HW_Rfc2833PT;
}
var VoiceRfc2833PT = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.RTP,TelephoneEventPayloadType,stRfc2833PT);%>;

function stProfileBody(Domain, X_HW_SIPProfile_Body)
{
    this.Domain = Domain;
    this.X_HW_SIPProfile_Body = X_HW_SIPProfile_Body;
}
var ProfileBody= <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.SIP.X_HW_SIPProfile,ProfileBody, stProfileBody);%>;

function stEchoCancellation(Domain, X_HW_RTPExtend_EchoCancellationEnable, X_HW_RTPExtend_SilenceSuppression, OffhookDtasAckInterval)
{
    this.Domain = Domain;
    this.X_HW_RTPExtend_EchoCancellationEnable = X_HW_RTPExtend_EchoCancellationEnable;
	this.X_HW_RTPExtend_SilenceSuppression = X_HW_RTPExtend_SilenceSuppression;
	this.OffhookDtasAckInterval = OffhookDtasAckInterval;
}
var EchoCancellation= <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.RTP.X_HW_Extend,EchoCancellationEnable|SilenceSuppression|OffhookDtasAckInterval, stEchoCancellation);%>;


function stCodec(Domain, EntryID, Codecs, PacketizationPeriod, Priority, Enable)
{
    this.Domain = Domain;
    this.EntryID = EntryID;
    this.Codecs = Codecs;
    this.PacketizationPeriod = PacketizationPeriod;
    this.Priority = Priority;
    this.Enable = Enable;        
    var temp = Domain.split('.');
    this.key = '.' + temp[7] + '.';
}

var AllCodec = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.Codec.List.{i}, EntryID|Codecs|PacketizationPeriod|Priority|Enable, stCodec);%>;
var CodecList = new Array(new Array(),new Array(),new Array(),new Array());
for (var i = 0; i < AllCodec.length-1; i++)
{
    var temp = AllCodec[i].Domain.split('.');
    var index = GetVagIndexByInst(temp[5]);
    CodecList[index].push(AllCodec[i]);
}

function stDspGain(Domain, TransmitGain, ReceiveGain)
{
    this.Domain = Domain;
	this.TransmitGain = TransmitGain;
    this.ReceiveGain = ReceiveGain;
}	
	
var AllDspGain = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.VoiceProcessing, TransmitGain|ReceiveGain, stDspGain);%>;

var DspGainList = new Array(new Array(),new Array(),new Array(),new Array());
for (var i = 0; i < AllDspGain.length-1; i++)
{
    var temp = AllDspGain[i].Domain.split('.');
    var index = GetVagIndexByInst(temp[5]);
    DspGainList[index].push(AllDspGain[i]);
}

function stHotLine(Domain, X_HW_HotlineEnable, X_HW_HotlineNumber, X_HW_HotlineTimer, CallWaitingEnable, CallForwardUnconditionalEnable, CallForwardUnconditionalNumber, CallForwardOnBusyEnable, CallForwardOnBusyNumber, CallForwardOnNoAnswerEnable, CallForwardOnNoAnswerNumber, MWIEnable, X_HW_3WayEnable, X_HW_CallHoldEnable, X_HW_MCIDEnable, X_HW_CLIPEnable, CallerIDEnable)
{
    this.Domain = Domain;
    this.X_HW_HotlineEnable = X_HW_HotlineEnable;
    this.X_HW_HotlineNumber = X_HW_HotlineNumber;
    this.X_HW_HotlineTimer  = X_HW_HotlineTimer;
    this.CallWaitingEnable  = CallWaitingEnable;
    this.CallForwardUnconditionalEnable = CallForwardUnconditionalEnable;
    this.CallForwardUnconditionalNumber = CallForwardUnconditionalNumber;
    this.CallForwardOnBusyEnable  = CallForwardOnBusyEnable;
    this.CallForwardOnBusyNumber  = CallForwardOnBusyNumber;
    this.CallForwardOnNoAnswerEnable = CallForwardOnNoAnswerEnable;
    this.CallForwardOnNoAnswerNumber = CallForwardOnNoAnswerNumber;
    this.MWIEnable  = MWIEnable;
    this.X_HW_3WayEnable  = X_HW_3WayEnable;
    this.X_HW_CallHoldEnable = X_HW_CallHoldEnable;
    this.X_HW_MCIDEnable = X_HW_MCIDEnable;
    this.X_HW_CLIPEnable  = X_HW_CLIPEnable;
    if(0 == CallerIDEnable)
    {
        this.CallerIDEnable = 1;
    }
    else
    {
        this.CallerIDEnable = 0;
    }
}    
    
var AllLineFeature = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.CallingFeatures, X_HW_HotlineEnable|X_HW_HotlineNumber|X_HW_HotlineTimer|CallWaitingEnable|CallForwardUnconditionalEnable|CallForwardUnconditionalNumber|CallForwardOnBusyEnable|CallForwardOnBusyNumber|CallForwardOnNoAnswerEnable|CallForwardOnNoAnswerNumber|MWIEnable|X_HW_3WayEnable|X_HW_CallHoldEnable|X_HW_MCIDEnable|X_HW_CLIPEnable|CallerIDEnable, stHotLine);%>;

var LineFeatureList = new Array(new Array(),new Array(),new Array(),new Array());
for (var i = 0; i < AllLineFeature.length-1; i++)
{
    var temp = AllLineFeature[i].Domain.split('.');
    var index = GetVagIndexByInst(temp[5]);
    LineFeatureList[index].push(AllLineFeature[i]);
}

function stPhyInterfaceParam(Domain,HookFlashDownTime,HookFlashUpTime,OnhookConfirmTime,Impedance,Current,RingFrequency,RingVoltage,SendGain,ReceiveGain,FskTime,ClipTransWhen,ClipFormat,RingDCVoltageOverlapped,UserDefineRingVoltage,ReversePoleOnAnswer,ClipSendDateTime,DspHighPassFilterEnable,DspTemplateName,ClipForceSendFsk)
{
   this.Domain = Domain;
   this.HookFlashDownTime = HookFlashDownTime;
   this.HookFlashUpTime = HookFlashUpTime;
   this.OnhookConfirmTime = OnhookConfirmTime;
   this.Impedance = Impedance;
   this.Current = Current;
   this.RingFrequency = RingFrequency;
   this.RingVoltage = RingVoltage;
   this.SendGain = SendGain;
   this.ReceiveGain = ReceiveGain;
   this.FskTime = FskTime;
   this.ClipTransWhen = ClipTransWhen;
   this.ClipFormat = ClipFormat;
   this.RingDCVoltageOverlapped = RingDCVoltageOverlapped;
   this.UserDefineRingVoltage = UserDefineRingVoltage;
   this.ReversePoleOnAnswer = ReversePoleOnAnswer;
   this.ClipSendDateTime = ClipSendDateTime;
   this.DspHighPassFilterEnable = DspHighPassFilterEnable;
   this.DspTemplateName = DspTemplateName;
   this.ClipForceSendFsk = ClipForceSendFsk;
}

var PhyInterfaceParams = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.PhyInterface.{i}.X_HW_Extend,HookFlashDownTime|HookFlashUpTime|OnhookConfirmTime|Impedance|Current|RingFrequency|RingVoltage|SendGain|ReceiveGain|FskTime|ClipTransWhen|ClipFormat|RingDCVoltageOverlapped|UserDefineRingVoltage|ReversePoleOnAnswer|ClipSendDateTime|DspHighPassFilterEnable|DspTemplateName|ClipForceSendFsk, stPhyInterfaceParam);%>;

function stDspTemplateParam(Domain,Enable,EchoCancellationEnable,SilenceSuppression,JbMode,NLP,WorkMode)
{
   this.Domain = Domain;
   this.Enable = Enable;
   this.EchoCancellationEnable = EchoCancellationEnable;
   this.SilenceSuppression = SilenceSuppression;
   this.JbMode = JbMode;
   this.NLP = NLP;
   this.WorkMode = WorkMode;
}
var DspTemplateParams = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.PhyInterface.{i}.X_HW_DspTemplate,Enable|EchoCancellationEnable|SilenceSuppression|JbMode|NLP|WorkMode,stDspTemplateParam); %>;

function setVagInfo()
{
    if(Profile[0] == null)
    {
        return;
    }
       
    setSelect('HW_ShareUserMode', SIPExtend[vagIndex].HW_ShareUserMode);
    setSelect('HW_MultiHomeMode', SIPExtend[vagIndex].HW_MultiHomeMode);
    setText('X_HW_SIPProfile_Body', ProfileBody[vagIndex].X_HW_SIPProfile_Body);
    setSelect('DTMFMethod_select', Profile[vagIndex].HW_DtmfMethod);
	setSelect('Option120Priority_select', Profile[vagIndex].X_HW_Option120PriorityMode);
    setText('HW_Rfc2833PT', VoiceRfc2833PT[vagIndex].HW_Rfc2833PT);
    setText('X_HW_SIPExtend_SoftwarePara', SIPExtend[vagIndex].SoftwareParameters);
    setCheck('EchoCancelEnable_checkbox', EchoCancellation[vagIndex].X_HW_RTPExtend_EchoCancellationEnable);
	setCheck('VadCngEnable_checkbox', EchoCancellation[vagIndex].X_HW_RTPExtend_SilenceSuppression);
	setText('OffhookDtasAckInterval', EchoCancellation[vagIndex].OffhookDtasAckInterval);
	setText('SipLocalPort_text', AllSIPServer[vagIndex].UserAgentPort);
	setText('SipDSCPMark_text', AllSIPServer[vagIndex].DSCPMark);
	setText('RegisterExpires_text', AllSIPServer[vagIndex].RegisterExpires);
	setText('RegisterRetryInterval_text', AllSIPServer[vagIndex].RegisterRetryInterval);
	setText('SessionExpires_text', AllSIPServer[vagIndex].X_HW_SessionUpdateTimer);
	setCheck('PRACKEnable_checkbox', AllSIPServer[vagIndex].X_HW_PRACKEnable);
	setCheck('SubscribeEnable_checkbox', AllSIPServer[vagIndex].X_HW_SubscribeEnable);
	if(Profile[vagIndex].HW_ServerType == 1)
	{
		setDisable('SubscribeEnable_checkbox',1);
	}
	else
	{
		setDisable('SubscribeEnable_checkbox',0);
	}
	
	if( 0 == AllSIPServer[vagIndex].X_HW_BootDeRegisterEnable)
	{
		setCheck("BootDeRegisterEnable_checkbox", 0);
		setDisable('TrBootDeRegVal',0);
	}
	else
	{
		setCheck("BootDeRegisterEnable_checkbox", 1);
		setSelect('BootDeRegVal', AllSIPServer[vagIndex].X_HW_BootDeRegisterEnable);
		setDisplay("TrBootDeRegVal",1);
	}
	
	setSelect('URIType_select', AllSIPServer[vagIndex].X_HW_URIType);
	setText('RtpDSCPMark_text', Rtp[vagIndex].DSCPMark);
	setText('RtpPortStart_text', Rtp[vagIndex].LocalPortMin);
	setText('RtpPortEnd_text', Rtp[vagIndex].LocalPortMax);
	
	
    if(SIPExtend[vagIndex].SoftwareParameters == '')
    {   
       setSelect("SelectSoftwarePara",0);
       setDisplay("X_HW_SIPExtend_SoftwarePara",0);
    }
    else
    {   
       setSelect("SelectSoftwarePara",1);
       setDisplay("X_HW_SIPExtend_SoftwarePara",1);
    }
	
	var wanSigValue;
	for (k = 0; k < WanInfo.length; k++ )
	{
		if ( MakeVoipWanName(WanInfo[k]) ==  Profile[vagIndex].X_HW_PortName)
		{
			wanSigValue = domainTowanname(WanInfo[k].domain);
			break;
		}		
	}
	if (k == WanInfo.length)
	{
		wanSigValue = Profile[vagIndex].X_HW_PortName;
	}
	setSelect('X_HW_PortName', wanSigValue);

	var wanRtpValue;
	for (k = 0; k < WanInfo.length; k++ )
	{
		if ( MakeVoipWanName(WanInfo[k]) == Rtp[vagIndex].X_HW_PortName)
		{
			wanRtpValue = domainTowanname(WanInfo[k].domain);
			break;
		}
	}
	if (k == WanInfo.length)
	{
		wanRtpValue = Rtp[vagIndex].X_HW_PortName;
	}
	setSelect('MediaPortName', wanRtpValue);

}

function initLineList()
{
    selctLindex = 0;
    var html = '<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="voipUserTable" style="table-layout:fixed;word-break:break-all">';
    html += '<tr class="head_title">';
    html += '<td class="width_12p" BindText="vspa_seq"></td>';
    html += '<td class="width_17p">电话号码</td>';
    
    html += '<td class="width_30p">用户名</td>';
    html += '<td class="width_16p" BindText="vspa_assopots"></td>';
    html += '</tr>';
    if (LineList[vagIndex].length == 0)
    {
        html += '<tr id="record_no" class="trTabContent" onclick="selectLine(this.id);">';
        html += '<td class="align_center">--</td>';
        
        html += '<td class="align_center">--</td>';
        html += '<td class="align_center">--</td>';
        html += '<td class="align_center">--</td>';
        html += '</tr>';
    }
    else
    {
        for (var i = 0; i < LineList[vagIndex].length; i++)
        {                                     
            if(i%2 == 0)
            {                        
                 html += '<tr id="record_' + i + '" class="tabal_01" '
                 +'onclick="SelectLineRecord(this.id);">';
            }
            else
            {
                 html += '<tr id="record_' + i + '" class="tabal_02" '
                 +'onclick="SelectLineRecord(this.id);">';                        
            }                    
                                                 
            html += '<td class="align_left">' + (i+1) + '</td>';
            
            if (AuthList[vagIndex][i].URI == "")
            {
                 html += '<td class="align_center">' + '--' + '&nbsp;</td>';
            }
            else
            {
                 html += '<td class="align_left" style="word-wrap:break-word; overflow:hidden;">' + AuthList[vagIndex][i].URI + '&nbsp;</td>';
            }
            

            if (AuthList[vagIndex][i].AuthUserName == "")
            {
                 html += '<td class="align_center">' + '--' + '&nbsp;</td>' ;      
            }
            else
            {
                 html += '<td class="align_left" style="word-wrap:break-word; overflow:hidden;">' + AuthList[vagIndex][i].AuthUserName + '&nbsp;</td>';      
            }   
            if (LineList[vagIndex][i].PhyReferenceList == "")  
            {
                 html += '<td class="align_center">' + '--' + '&nbsp;</td>' ;   
            }     
            else
            {
                html += '<td class="align_left">' + LineList[vagIndex][i].PhyReferenceList + '&nbsp;</td>';
            }                                                
            html += '</tr>';                                     
        }
    }
    html += '</table>';
    document.getElementById('line_list').innerHTML = html;
}

function LoadFrame()
{
    var X_HW_RTPExtend_EchoCancellationEnable=document.getElementById('EchoCancelEnable_checkbox');
	var X_HW_RTPExtend_SilenceSuppression=document.getElementById('VadCngEnable_checkbox');
    var HW_ShareUserMode=document.getElementById('HW_ShareUserMode');
    var HW_MultiHomeMode=document.getElementById('HW_MultiHomeMode');
    var X_HW_SIPProfile_Body=document.getElementById('X_HW_SIPProfile_Body');
    var SoftwareParameters=document.getElementById('SoftwareParameters');
	var OffhookDtasAckInterval=document.getElementById('OffhookDtasAckInterval');
    var ProfileBody_exp = sipuser['vspa_pfhint'];
    var Software_exp = sipuser['vspa_softhint'];
    var objTR = getElementByName('vag_tr');
    if(objTR!= null)
    {
        for(var i = 0; i < objTR.length; i++)
        {
            objTR[i].value = sipinterface['vspa_profile'] + Profile[i].profileid;
            if(i == vagIndex)
            {
                objTR[i].style.background = '#B4B4B4';
                objTR[i].style.color = '#990000';
                objTR[i].style.fontWeight='bold';
            }
            else
            {
                objTR[i].style.background = '#C3C3C3';
                objTR[i].style.color = '#505050';
                objTR[i].style.fontWeight='normal';
            }
        }
    }

    initLineList();	
	
	if(AllPhyInterface.length > POTSNum)
	{
		setDisplay('line_list', 1);	
		setDisplay('DivPHYdisplay', 1);	
	}
	else
	{
		setDisplay('line_list', 0);	
		setDisplay('DivPHYdisplay', 0);	
	}	
    document.getElementById('X_HW_SIPProfile_Body').title = ProfileBody_exp;
    document.getElementById('X_HW_SIPExtend_SoftwarePara').title = Software_exp;

    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length ; i++) 
    {
        var b = all[i];
        if(b.getAttribute("BindText") == null)
        {
            continue;
        }
        b.innerHTML = sipuser[b.getAttribute("BindText")];
    }
    
    if (LineList[vagIndex].length > 0)
    {
        selectLine('record_0'); 
        setDisplay('ConfigForm1', 1);
    }    
    else
    {
        selectLine('record_no');
        setDisplay('ConfigForm1', 0);
    }

    setVagInfo();
    if (CodecList[vagIndex].length > selctLindex*4)
    {
        setText('G711uRtpPackageInterval_text', CodecList[vagIndex][selctLindex*4 + 0].PacketizationPeriod);
        setText('G711aRtpPackageInterval_text', CodecList[vagIndex][selctLindex*4 + 1].PacketizationPeriod);
        setText('G729RtpPackageInterval_text', CodecList[vagIndex][selctLindex*4 + 2].PacketizationPeriod);
        setText('G722RtpPackageInterval_text', CodecList[vagIndex][selctLindex*4 + 3].PacketizationPeriod);

        setText('G711uPriority_text',CodecList[vagIndex][selctLindex *4 + 0].Priority);
        setText('G711aPriority_text',CodecList[vagIndex][selctLindex *4 + 1].Priority);
        setText('G729Priority_text',CodecList[vagIndex][selctLindex *4 + 2].Priority);
        setText('G722Priority_text',CodecList[vagIndex][selctLindex *4 + 3].Priority);
        
        setCheck('G711uEnable_checkbox', CodecList[vagIndex][selctLindex*4 + 0].Enable);
        setCheck('G711aEnable_checkbox', CodecList[vagIndex][selctLindex*4 + 1].Enable);
        setCheck('G729Enable_checkbox', CodecList[vagIndex][selctLindex*4 + 2].Enable);
        setCheck('G722Enable_checkbox', CodecList[vagIndex][selctLindex*4 + 3].Enable);
    }

    setPhyList("PhyList");
    setPhyInterfaceParams();
    setDspTemplatePara();
}



function CheckForm1()
{ 
    var ProfileBody_ex=document.getElementById('X_HW_SIPProfile_Body');
    var SoftwarePara_ex=document.getElementById('X_HW_SIPExtend_SoftwarePara');
    var HW_ShareUserMode=document.getElementById('HW_ShareUserMode');
    var HW_MultiHomeMode=document.getElementById('HW_MultiHomeMode');
    var HW_DtmfPtValue = document.getElementById('HW_Rfc2833PT');
	var UserAgentPort = getValue('SipLocalPort_text');
	var DSCPMark = getValue('SipDSCPMark_text');
	var RtpDSCPMark = getValue('RtpDSCPMark_text');
	var RegisterExpires = getValue('RegisterExpires_text');
	var RegisterRetryInterval = getValue('RegisterRetryInterval_text');
	var X_HW_SessionUpdateTimer = getValue('SessionExpires_text');
	var LocalPortMin = getValue('RtpPortStart_text');
	var LocalPortMax = getValue('RtpPortEnd_text');
	var PacketizationPeriod1 = getValue('G711uRtpPackageInterval_text');
	var PacketizationPeriod2 = getValue('G711aRtpPackageInterval_text');
	var PacketizationPeriod3 = getValue('G729RtpPackageInterval_text');
	var PacketizationPeriod4 = getValue('G722RtpPackageInterval_text');
	var Priority1= getValue('G729Priority_text');
	var Priority2= getValue('G711aPriority_text');
	var Priority3= getValue('G711uPriority_text');
	var Priority4= getValue('G722Priority_text');
	var OffhookDtasAckInterval = getValue('OffhookDtasAckInterval');

	
	if((Priority1 >100 || Priority1< 1)||(Priority2 >100 || Priority2< 1)||(Priority3 >100 || Priority3< 1)||(Priority4 >100 || Priority4< 1))
	{
		AlertEx(sipuser['vspa_priinva']);
		return false;		
	}

	if((getValue('Priority1') == "") || (getValue('Priority2') == "") || (getValue('Priority3') == "") || (getValue('Priority4') == ""))
	{
		AlertEx(sipuser['vspa_priinva']);
		return false;
	}
	
	if ((PacketizationPeriod1 != 10) && (PacketizationPeriod1 != 20) && (PacketizationPeriod1 != 30))
	{
		AlertEx("RTP打包间隔配置只支持10、20、30，请重新设置。");
		return false;
	}
	
	if ((PacketizationPeriod2 != 10) && (PacketizationPeriod2 != 20) && (PacketizationPeriod2 != 30))
	{
		AlertEx("RTP打包间隔配置只支持10、20、30，请重新设置。");
		return false;
	}		
	
	if ((PacketizationPeriod3 != 10) && (PacketizationPeriod3 != 20) && (PacketizationPeriod3 != 30))
	{
		AlertEx("RTP打包间隔配置只支持10、20、30，请重新设置。");
		return false;
	}		
	
	if ((PacketizationPeriod4 != 10) && (PacketizationPeriod4 != 20) && (PacketizationPeriod4 != 30))
	{
		AlertEx("RTP打包间隔配置只支持10、20、30，请重新设置。");
		return false;
	}	

    if ((UserAgentPort < 1025)||(UserAgentPort > 65535))
	{
		AlertEx("SIP本地端口号不合法，请重新设置(范围1025-65535)");
		return false;
	}
	
	if ((DSCPMark < 0)||(DSCPMark > 63))
	{
		AlertEx("SIP DSCP Mark不合法，请重新设置(范围0-63)");
		return false;
	}
	
	if ((RtpDSCPMark < 0)||(RtpDSCPMark > 63))
	{
		AlertEx("RTP DSCP Mark不合法，请重新设置(范围0-63)");
		return false;
	}
	
	if ((RegisterExpires < 20)||(RegisterExpires > 65535))
	{
		AlertEx("注册过期时间不合法，请重新设置(范围20-65535)");
		return false;
	}	
	
	if ((RegisterExpires != AllSIPServer[vagIndex].RegisterExpires) && (RegisterExpires <= 90))
	{
		if(!ConfirmEx(sipuser['vspa_regperiodshortcn']))
		{
			return false;
		}
	}	
	
	if ((RegisterRetryInterval < 1)||(RegisterRetryInterval > 65535))
	{
		AlertEx("注册失败重注册时间不合法，请重新设置(范围1-65535)");
		return false;
	}
	
	if ((X_HW_SessionUpdateTimer < 2)||(X_HW_SessionUpdateTimer > 60))
	{
		AlertEx("会话过期时间不合法，请重新设置(范围2-60)");
		return false;
	}
	
	if ((LocalPortMin < 1026)||(LocalPortMin > 65494))
	{
		AlertEx("本地RTP端口最小值不合法，请重新设置(范围1026-65494)");
		return false;
	}	
	
	if ((LocalPortMax < 1032)||(LocalPortMax > 65500))
	{
		AlertEx("本地RTP端口最大值不合法，请重新设置(范围1032-65500)");
		return false;
	}	
    if (HW_ShareUserMode.value > 2)
    {
        return false;
    }
    
    if (HW_MultiHomeMode.value > 5)
    {
        return false;
    }

    if (ProfileBody_ex.value.length > 8194)
    {
        AlertEx(sipuser['vspa_probodylong']);
        return false;
    }

    if (SoftwarePara_ex.value.length > 8194)
    {
        AlertEx(sipuser['vspa_softparalong']);
        return false;
    }

    if (HW_DtmfPtValue.value < 96 || HW_DtmfPtValue.value > 127)
    {
        AlertEx(sipuser['vspa_2833ptinvalid']);
        return false;
    }
	
	if (parseInt(OffhookDtasAckInterval) < 0 || parseInt(OffhookDtasAckInterval) > 1000 || (getValue('OffhookDtasAckInterval') == ""))
    {
        AlertEx(sipuser['vspa_dtasinva']);
        return false;
    }
    return true;
}

function onChangeSoftware()
{
   var index = getSelectVal("SelectSoftwarePara");
   if(index == 0)
   { 
       setDisplay("X_HW_SIPExtend_SoftwarePara",0);
   }
   else
   {
       setDisplay("X_HW_SIPExtend_SoftwarePara",1);
   }
}


function AddSubmitParam(Form,type)
{    
    var domain;
    
    if(Profile[0] == null)
    {
        return false;
    }
    
    var PhyListLength = getElement('PhyList').options.length;
    Form.addParameter('z.ProfileBody',getValue('X_HW_SIPProfile_Body'));
    Form.addParameter('a.SharedUserMode',getValue('HW_ShareUserMode'));
    Form.addParameter('a.MultiHomeMode',getValue('HW_MultiHomeMode'));
    if(getSelectVal("SelectSoftwarePara") == 0)
    {
        Form.addParameter('a.SoftwareParameters',"");
    }
    else
    {
        Form.addParameter('a.SoftwareParameters',getValue('X_HW_SIPExtend_SoftwarePara'));
    }

    Form.addParameter('b.EchoCancellationEnable',getCheckVal('EchoCancelEnable_checkbox'));
	Form.addParameter('b.SilenceSuppression',getCheckVal('VadCngEnable_checkbox'));
    Form.addParameter('b.OffhookDtasAckInterval',getValue('OffhookDtasAckInterval'));
	
    Form.addParameter('m.DTMFMethod',getValue('DTMFMethod_select'));
	Form.addParameter('m.X_HW_Option120PriorityMode',getValue('Option120Priority_select'));
    Form.addParameter('n.TelephoneEventPayloadType',getValue('HW_Rfc2833PT'));
	Form.addParameter('n.DSCPMark',getValue('RtpDSCPMark_text'));
	Form.addParameter('n.LocalPortMin',getValue('RtpPortStart_text'));
	Form.addParameter('n.LocalPortMax',getValue('RtpPortEnd_text'));
	
	Form.addParameter('p.UserAgentPort',parseInt(getValue('SipLocalPort_text'),10)); 
	Form.addParameter('p.RegisterExpires',getValue('RegisterExpires_text')); 
	Form.addParameter('p.RegisterRetryInterval',getValue('RegisterRetryInterval_text')); 
	Form.addParameter('p.X_HW_SessionUpdateTimer',getValue('SessionExpires_text')); 

	Form.addParameter('p.X_HW_URIType',getSelectVal('URIType_select')); 
	Form.addParameter('p.X_HW_PRACKEnable',getCheckVal('PRACKEnable_checkbox')); 
	Form.addParameter('p.X_HW_BootDeRegisterEnable',getCheckVal('BootDeRegisterEnable_checkbox')); 
	Form.addParameter('p.X_HW_SubscribeEnable',getCheckVal('SubscribeEnable_checkbox')); 
	Form.addParameter('p.DSCPMark',getValue('SipDSCPMark_text'));
    Form.addParameter('m.X_HW_PortName',getValue('X_HW_PortName'));
	Form.addParameter('n.X_HW_PortName',getValue('MediaPortName')); 
	
    var Checkboxvalue = getCheckVal("BootDeRegisterEnable_checkbox");
    if( 1 == Checkboxvalue )
    {
        Form.addParameter('p.X_HW_BootDeRegisterEnable', getSelectVal('BootDeRegVal'));
    }
    else
    {
        Form.addParameter('p.X_HW_BootDeRegisterEnable',0);
    }
	domain ='x=' + Profile[vagIndex].Domain + '.FaxT38'
         + '&y=' + Profile[vagIndex].Domain + '.X_HW_FaxModem'
		 
         + '&z=' + Profile[vagIndex].Domain + '.SIP'+ '.X_HW_SIPProfile'
         + '&a=' + Profile[vagIndex].Domain + '.SIP'+ '.X_HW_SIPExtend'
         + '&b=' + Profile[vagIndex].Domain + '.RTP'+ '.X_HW_Extend'
		 + '&p=' + Profile[vagIndex].Domain + '.SIP'
         + '&m=' + Profile[vagIndex].Domain
         + '&n=' + Profile[vagIndex].Domain + '.RTP';
                    
    if(LineList[vagIndex].length > 0)
    {
        Form.addParameter('d.PacketizationPeriod',getSelectVal('G711uRtpPackageInterval_text'));     
        Form.addParameter('e.PacketizationPeriod',getSelectVal('G711aRtpPackageInterval_text'));   
        Form.addParameter('f.PacketizationPeriod',getSelectVal('G729RtpPackageInterval_text'));   
        Form.addParameter('g.PacketizationPeriod',getSelectVal('G722RtpPackageInterval_text'));   
                              
        Form.addParameter('d.Priority',getSelectVal('G711uPriority_text'));
        Form.addParameter('e.Priority',getSelectVal('G711aPriority_text'));
        Form.addParameter('f.Priority',getSelectVal('G729Priority_text'));
        Form.addParameter('g.Priority',getSelectVal('G722Priority_text'));
        
        Form.addParameter('d.Enable',getCheckVal('G711uEnable_checkbox'));   
        Form.addParameter('e.Enable',getCheckVal('G711aEnable_checkbox'));   
        Form.addParameter('f.Enable',getCheckVal('G729Enable_checkbox'));   
        Form.addParameter('g.Enable',getCheckVal('G722Enable_checkbox'));
		 
 		Form.addParameter('i.TransmitGain',getSelectVal('DSPTXGain_text'));
		Form.addParameter('i.ReceiveGain',getSelectVal('DSPRXGain_text'));
		
        if (CodecList[vagIndex].length > selctLindex*4)
        {
            domain += '&d=' + CodecList[vagIndex][selctLindex *4  + 0].Domain
                    + '&e=' + CodecList[vagIndex][selctLindex *4  + 1].Domain
                    + '&f=' + CodecList[vagIndex][selctLindex *4  + 2].Domain
                    + '&g=' + CodecList[vagIndex][selctLindex *4  + 3].Domain;
        }
		
        if (DspGainList[vagIndex].length > selctLindex)
        {
            domain += '&i='+ DspGainList[vagIndex][selctLindex].Domain;
        }    
		
        if (LineFeatureList[vagIndex].length > selctLindex)
        {
            domain += '&h='+ LineFeatureList[vagIndex][selctLindex].Domain;
        }
		

    }
    
    if(PhyListLength > 0)
    {
        
        Form.addParameter('j.RingDCVoltageOverlapped',getValue('RingDCVoltageOverlapped'));
        Form.addParameter('j.UserDefineRingVoltage',getValue('RingVoltage_text'));
		var RingVoltageconfig = getValue('RingVoltage_text');
		if (74 == RingVoltageconfig)
		{
			Form.addParameter('j.RingVoltage',0);
		}
		else if(65 == RingVoltageconfig)
		{
			Form.addParameter('j.RingVoltage',1);
		}
		else if(50 == RingVoltageconfig)
		{
			Form.addParameter('j.RingVoltage',2);
		}
		else
		{
			Form.addParameter('j.RingVoltage',3);
		}

        Form.addParameter('j.SendGain',getSelectVal('SendGain'));
        Form.addParameter('j.ReceiveGain',getSelectVal('ReceiveGain'));
        Form.addParameter('j.HookFlashDownTime',getValue('FlashMin_text'));
        Form.addParameter('j.HookFlashUpTime',getValue('FlashMax_text'));    
        Form.addParameter('j.OnhookConfirmTime',getValue('OnhookConfirmTime')); 
        Form.addParameter('j.Impedance',getSelectVal('Impedance')); 
        Form.addParameter('j.Current',getValue('Current'));
        Form.addParameter('j.FskTime',getValue('FskTime'));
        Form.addParameter('j.ClipTransWhen',getSelectVal('ClipTransWhen'));
        Form.addParameter('j.DspHighPassFilterEnable', getCheckVal('DspHighPassFilterEnable'));
        Form.addParameter('k.Enable',getCheckVal('EnableDspTemplate'));
		Form.addParameter('j.DspTemplateName',getValue('DspTemplateName')); 
		Form.addParameter('j.ClipForceSendFsk',getCheckVal('ClipForceSendFsk')); 
        Form.addParameter('k.WorkMode',getSelectVal('WorkMode'));
   
        domain += '&j='+ PhyInterfaceParams[parseInt(getSelectVal('PhyList'))-1].Domain
                + '&k='+ DspTemplateParams[parseInt(getSelectVal('PhyList'))-1].Domain;
                    
    }
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));   
    Form.setAction('set.cgi?' + domain + '&RequestFile=html/voip/cnvoipuser/cnvoipuser.asp');
    setDisable('SaveApply_button',1);
    setDisable('Cancel_button',1);
}

function stDftRoute(domain,autoenable,wandomain)
{
        this.domain     = domain;
        this.autoenable = autoenable;
        this.wandomain  = wandomain;
}

function stWanInfo(domain,Enable,CntType,Name, ConnectionStatus,NATEnabled,DefaultGateway,ServiceList,ExServiceList,vlanid,MacId,submask)
{
    this.domain = domain;
    this.Enable = Enable;
    this.CntType = CntType; 
	this.Name =  Name;
    this.ConnectionStatus = ConnectionStatus;
    this.NATEnabled = NATEnabled;
    this.DefaultGateway = DefaultGateway;
	this.ServiceList = (ExServiceList.length == 0)?ServiceList:ExServiceList;
    this.vlanid = vlanid;
	this.MacId = MacId;
    this.submask = submask;
}

    var WanIPInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i},Enable|ConnectionType|Name|ConnectionStatus|NATEnabled|DefaultGateway|X_HW_SERVICELIST|X_HW_ExServiceList|X_HW_VLAN|X_HW_MacId|SubnetMask,stWanInfo);%>;  

    var WanPPPInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},Enable|ConnectionType|Name|ConnectionStatus|NATEnabled|DefaultGateway|X_HW_SERVICELIST|X_HW_ExServiceList|X_HW_VLAN|X_HW_MacId,stWanInfo);%>;  

    var dftRoutes = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Layer3Forwarding,X_HW_AutoDefaultGatewayEnable|DefaultConnectionService,stDftRoute);%>;


var dftRoute = dftRoutes[0];

var WanInfo = new Array();

for(i=0, j=0;WanIPInfo.length > 0 && i < WanIPInfo.length -1;i++ )
{
    WanIPInfo[i].ServiceList = WanIPInfo[i].ServiceList.toUpperCase();

    if ( (true == WanIPInfo[i].Enable)
	     && (WanIPInfo[i].ServiceList.indexOf("VOIP") >= 0) 
	     )
    {
        WanInfo[j] = WanIPInfo[i];
        j++;
    }
}

for(i=0; WanPPPInfo.length > 0 && i < WanPPPInfo.length - 1;i++)
{
    WanPPPInfo[i].ServiceList = WanPPPInfo[i].ServiceList.toUpperCase();

    if ( (true == WanPPPInfo[i].Enable)
	    &&(WanPPPInfo[i].ServiceList.indexOf("VOIP") >= 0) 
		)
    {
        WanInfo[j] = WanPPPInfo[i];
        j++;
    }
}

function MakeWanName(wan)
{
    var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var currentWanName = ''; 

    if('&nbsp;'!= wan)
    {
        wanInst = wan.MacId;
        wanServiceList  = wan.ServiceList;
        wanMode         = (wan.CntType  ==  'IP_Bridged' ) ? "B" : "R";
        vlanId          = wan.vlanid;

		switch(wanServiceList)
		{
		    case "VOIP":
		    	wanServiceList = "VOICE";
		    	break;
		    case "TR069_VOIP":
		    	wanServiceList = "TR069_VOICE";
		    	break;
		    case "VOIP_INTERNET":
		    	wanServiceList = "VOICE_INTERNET";
		    	break;
		    case "TR069_VOIP_INTERNET":
		    	wanServiceList = "TR069_VOICE_INTERNET";
		    	break;
			case "VOIP_IPTV":
		    	wanServiceList = "VOICE_IPTV";
		    	break;
		    case "TR069_VOIP_IPTV":
		    	wanServiceList = "TR069_VOICE_IPTV";
		    	break;
		    default:
		    	break;
		}
        
	    if (0 != parseInt(vlanId))
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_" + vlanId;
	    }
        else
        {
            currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_";
        }

         
        return currentWanName;
    }
    else
    {
        
        return '&nbsp;';
    }  
}
function MakeVoipWanName(wan)
{
    var wanInst = 0;
    var wanServiceList = '';
    var currentWanName = '';       

    DomainElement = wan.domain.split(".");
    wanInst = DomainElement[4];
       
    wanServiceList  = wan.ServiceList;
    
    currentWanName = "wan"+wanInst;
    return currentWanName;    
}


function setCtlDisplay(record)
{
    if (CodecList[vagIndex].length > selctLindex*4)
    {
        setText('codec1',CodecList[vagIndex][selctLindex*4 + 0].Codecs);
        setText('codec2',CodecList[vagIndex][selctLindex*4 + 1].Codecs);
        setText('codec3',CodecList[vagIndex][selctLindex*4 + 2].Codecs);
        setText('codec4',CodecList[vagIndex][selctLindex*4 + 3].Codecs);
            
        setText('G711uRtpPackageInterval_text',CodecList[vagIndex][selctLindex *4 + 0].PacketizationPeriod);
        setText('G711aRtpPackageInterval_text',CodecList[vagIndex][selctLindex *4 + 1].PacketizationPeriod);
        setText('G729RtpPackageInterval_text',CodecList[vagIndex][selctLindex *4 + 2].PacketizationPeriod);
        setText('G722RtpPackageInterval_text',CodecList[vagIndex][selctLindex *4 + 3].PacketizationPeriod);
        
        setText('G711uPriority_text',CodecList[vagIndex][selctLindex *4 + 0].Priority);
        setText('G711aPriority_text',CodecList[vagIndex][selctLindex *4 + 1].Priority);
        setText('G729Priority_text',CodecList[vagIndex][selctLindex *4 + 2].Priority);
        setText('G722Priority_text',CodecList[vagIndex][selctLindex *4 + 3].Priority);
        
        setCheck('G711uEnable_checkbox',CodecList[vagIndex][selctLindex *4 + 0].Enable);
        setCheck('G711aEnable_checkbox',CodecList[vagIndex][selctLindex *4 + 1].Enable);
        setCheck('G729Enable_checkbox',CodecList[vagIndex][selctLindex *4 + 2].Enable);
        setCheck('G722Enable_checkbox',CodecList[vagIndex][selctLindex *4 + 3].Enable);
    }

    if (DspGainList[vagIndex].length > selctLindex)
    {
		setText('DSPTXGain_text',DspGainList[vagIndex][selctLindex].TransmitGain);	
		setText('DSPRXGain_text',DspGainList[vagIndex][selctLindex].ReceiveGain);
    }	
}

var g_Index = -1;

function setControl(index)
{  
    var record;
    selctIndex = index;

    if (index == -1)
    {   
        if(Line.length >= ((PhyInterfaceParams.length - 1) * 17))
        {
            setDisplay('ConfigForm1', 0);
            AlertEx(sipuser['vspa_manyusers']);
            return false;
        }   
        
        record = new stLine("","","Enabled","");
        setDisplay('ConfigForm1', 1);
        setCtlDisplay(record);
    }
    else if (index == -2)
    {
        setDisplay('ConfigForm1', 0);
    }
    else
    {
        if(LineList[vagIndex].length > index)
        {
            record = LineList[vagIndex][index];
            setDisplay('ConfigForm1', 1);
            setCtlDisplay(record);
        }
    }
    g_Index = index;
}

function clickRemove() 
{
    if (Line.length == 0)
    {
        AlertEx(sipuser['vspa_delunexistusers']);
        return;
    }
    
    if (selctIndex == -1)
    {
        AlertEx(sipuser['vspa_newuserdel']);
        return;
    }
    var rml = getElement('rml');
    var noChooseFlag = true;
    if ( rml.length > 0)
    {
         for (var i = 0; i < rml.length; i++)
         {
             if (rml[i].checked == true)
             {   
                 noChooseFlag = false;
             }
         }
    }
    else if (rml.checked == true)
    {
        noChooseFlag = false;
    }
    if ( noChooseFlag )
    {
        AlertEx(sipuser['vspa_chooseuser']);
        return ;
    }
        
    if (ConfirmEx(sipuser['vspa_confirmdeluser']) == false)
    {
        return;
    }
    setDisable('btnApplySipUser',1);
    setDisable('cancelValue',1);
    removeInst('html/cnvoipuser/cnvoipuser.asp');     
}  

function vspaisValidCfgStr(cfgName, val, len)
{
    if (isValidAscii(val) != '')         
    {  
        AlertEx(cfgName + sipinterface['vspa_hasvalidch'] + isValidAscii(val) + sipinterface['vspa_end']);          
        return false;       
    }
    if (val.length > len)
    {
        AlertEx(cfgName + sipinterface['vspa_cantexceed']  + len  + sipinterface['vspa_characters']);
        return false;
    }        
}

function CheckForm(type)
{
    var ulret = CheckForm1();    
    if (ulret != true )
    {
        return false;
    }
    
    var PhyList = document.getElementById('PhyList');
    var EnableCodec1=document.getElementById('G711uEnable_checkbox').checked;
    var EnableCodec2=document.getElementById('G711aEnable_checkbox').checked;
    var EnableCodec3=document.getElementById('G729Enable_checkbox').checked;
    var EnableCodec4=document.getElementById('G722Enable_checkbox').checked;
    var RingDCVoltageOverlapped = getValue('RingDCVoltageOverlapped');
    var UserDefineRingVoltage = getValue('RingVoltage_text');
    var HookFlashDownTime = getValue('FlashMin_text');
    var HookFlashUpTime = getValue('FlashMax_text');
    var OnhookConfirmTime = getValue('OnhookConfirmTime');
    var Current = getValue('Current');
    var FskTime = getValue('FskTime');
	var dspsendgain = getValue('DSPTXGain_text');
	var dspreceivegain = getValue('DSPRXGain_text');
	

    for (var i = 1; i < 5; i++)
    {
        if (getValue('Priority' + i ) > 100 ) 
        {
            AlertEx(sipuser['vspa_priinva']);
            return false;
        }
    }

    if(PhyList.options.length == 0)
    {
        return true;
    }
    
    if(parseInt(RingDCVoltageOverlapped) < 0 || RingDCVoltageOverlapped > 25)
    {
        AlertEx(sipuser['vspa_dcbias']);
        return false;
    }

    if(parseInt(UserDefineRingVoltage) < 0 || parseInt(UserDefineRingVoltage) > 74)
    {
        AlertEx(sipuser['vspa_usrdefinva']);
        return false;
    }

    if(parseInt(HookFlashDownTime) < 0 || parseInt(HookFlashDownTime) > 1400)
    {
        AlertEx("拍叉最短时间不合法，请重新设置(范围0-1400)");
        return false;
    }

    if(parseInt(HookFlashUpTime) < 0 || parseInt(HookFlashUpTime) > 1400)
    {
        AlertEx("拍叉最长时间不合法，请重新设置(范围0-1400)");
        return false;
    }

    if(parseInt(OnhookConfirmTime) < 0 || parseInt(OnhookConfirmTime) > 1400)
    {
        AlertEx(sipuser['vspa_onhookconinva']);
        return false;
    }

    if((parseInt(HookFlashUpTime) <= parseInt(HookFlashDownTime)) || ((parseInt(OnhookConfirmTime) <= parseInt(HookFlashUpTime)) && (parseInt(OnhookConfirmTime) != 0)))
    {
        AlertEx("拍叉最长时间必须大于拍叉最短时间，挂机确认时间必须大于拍叉最长时间");
        return false;
    }
    
    if(parseInt(Current) < 16 || parseInt(Current) > 49)
    {
        AlertEx(sipuser['vspa_curinva']);
        return false;
    }

    if(parseInt(FskTime) < 0 || parseInt(FskTime) > 2000)
    {
        AlertEx(sipuser['vspa_intervalbef']);
        return false;
    }
    
	if(parseInt(dspsendgain) < -100 || parseInt(dspsendgain) > 50)
	{
		AlertEx(sipuser['vspa_dspsendgaininva']);
		return false;
	}
	
	if(parseInt(dspreceivegain) < -100 || parseInt(dspreceivegain) > 100)
	{
		AlertEx(sipuser['vspa_dspreceivegaininva']);
		return false;
	}
    return true;
}

function CancelConfig()
{
    setVagInfo();
    if (selctIndex == -1)
    {
        var tableRow = getElement("voipUserTable");
        
        if (tableRow.rows.length == 1)
        {
            selectLine('record_no');
        }
        else if (tableRow.rows.length == 2)
        {
            addNullInst('VOIP User');
        }
        else
        {
            tableRow.deleteRow(tableRow.rows.length-1);
            selectLine('record_0');
        }
    }
    else
    {
        if(LineList[vagIndex].length > selctIndex)
        {
            var record = LineList[vagIndex][selctIndex];
            setCtlDisplay(record);
            setPhyInterfaceParams();
        }
    }
}

function setPhyList(objname)
{
    var PhyPortList = "";
    var selectObj = getElement(objname);
    var tempList;

    removeAllOption(objname);
    
    if(LineList[vagIndex].length > selctLindex)
    {
        PhyPortList = LineList[vagIndex][selctLindex].PhyReferenceList;
    }

    if(PhyPortList.length == 0)
    {
        setDisplay("DivPhyParameter",0);
        return;
    }
    
    tempList = PhyPortList.split(',');
    if(tempList.length > 1)
    {
        setDisable('PhyList',0);
    }
    else
    {
        setDisable('PhyList',1);
    }
    setDisplay("DivPhyParameter",1);
    if(selectObj != null)
    {
        for(var i=0;i< tempList.length;i++)
        {
            var opt = document.createElement("option");
            opt.setAttribute("value",tempList[i]);
            opt.innerHTML = tempList[i];
            selectObj.appendChild(opt);
        }
    }

    if(selectObj.options.length > 0)
    {
        try
        {
            selectObj.options[vagIndex].selected = true;
        }
        catch(ex)
        {
            
        }
    }

}


function setDspTemplatePara()
{
    var PhyID;
    var selectObj = getElement("PhyList");
    if(selectObj.options.length == 0)
    {
        return;
    }
    PhyID = parseInt((getSelectVal("PhyList")-1));
    if(1 == getCheckVal("EnableDspTemplate"))
    {
        setDisplay("TrWorkMode",1);
    }
    else
    {
        setDisplay("TrWorkMode",0);
    }
    setSelect("WorkMode",DspTemplateParams[PhyID].WorkMode);
}


function setBootDeRegPara()
{
    if(1 == getCheckVal("BootDeRegisterEnable_checkbox"))
    {
        setDisplay("TrBootDeRegVal",1);
    }
    else
    {
        setDisplay("TrBootDeRegVal",0);
    }

}


function setFskClipPara()
{
	var PhyID;
	PhyID = parseInt(getSelectVal("PhyList"))-1;

	var clipFormat = PhyInterfaceParams[PhyID].ClipFormat;

    if(("Sdmf-fsk" == clipFormat) || ("Mdmf-fsk" == clipFormat))
    {
        setDisplay("TrFskTime",1);
    }
    else
    {
        setDisplay("TrFskTime",0);
    }
}

function setPhyInterfaceParams()
{
    var PhyID;
    var selectObj = getElement("PhyList");
    if(selectObj.options.length == 0)
    {
        return;
    }

    PhyID = parseInt(getSelectVal("PhyList"))-1;
	
	var RingVoltage = PhyInterfaceParams[PhyID].RingVoltage;
	var showRingVol = 74;
	
	if (0 == RingVoltage)
	{
		showRingVol = 74;
	}
	else if (1 == RingVoltage)
	{
		showRingVol = 65;
	}
	else if (2 == RingVoltage)
	{
		showRingVol = 50;
	}
	else
	{
		showRingVol = PhyInterfaceParams[PhyID].UserDefineRingVoltage;
	}
	
	setText("RingVoltage_text",showRingVol);
    setText("RingDCVoltageOverlapped",PhyInterfaceParams[PhyID].RingDCVoltageOverlapped);
    setSelect("SendGain",PhyInterfaceParams[PhyID].SendGain);
    setSelect("ReceiveGain",PhyInterfaceParams[PhyID].ReceiveGain);
    setText("FlashMin_text",PhyInterfaceParams[PhyID].HookFlashDownTime);
    setText("FlashMax_text",PhyInterfaceParams[PhyID].HookFlashUpTime);
    setText("OnhookConfirmTime",PhyInterfaceParams[PhyID].OnhookConfirmTime);
    setSelect("Impedance",PhyInterfaceParams[PhyID].Impedance);
    setText("Current",PhyInterfaceParams[PhyID].Current);
    setSelect("ClipFormat",PhyInterfaceParams[PhyID].ClipFormat);
    setText("FskTime",PhyInterfaceParams[PhyID].FskTime);
    setSelect("ClipTransWhen",PhyInterfaceParams[PhyID].ClipTransWhen);
    setCheck("EnableDspTemplate",DspTemplateParams[PhyID].Enable);
    setDspTemplatePara();
    setFskClipPara();
    setCheck("EnablePotsReversePole",PhyInterfaceParams[PhyID].ReversePoleOnAnswer);
    setCheck("ClipSendDateTime", PhyInterfaceParams[PhyID].ClipSendDateTime);
	setCheck("DspHighPassFilterEnable", PhyInterfaceParams[PhyID].DspHighPassFilterEnable);
	setText("DspTemplateName",PhyInterfaceParams[PhyID].DspTemplateName);
	setCheck("ClipForceSendFsk",PhyInterfaceParams[PhyID].ClipForceSendFsk);
}

function SubmitGetProfile(vagInst)
{    
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('SetVoiceVagIndex.cgi?vagIndex=' + vagInst);
    Form.setTarget('disableIframe');
    Form.submit();
    
    vagIndex = GetVagIndexByInst(vagInst);
    LoadFrame();
}
</script>
</head>
<body class="mainbody" onload="LoadFrame();">

<script type="text/javascript">
if(Profile.length > 2)
{
    document.write('<iframe name="disableIframe" style="display:none"></iframe>');
    document.write('<table border="0" cellpadding="0" cellspacing="0">');
    document.write('<tr>');
    var html = '';
    
    for(var i = 0; i < Profile.length-1; i++)
    {
        var vagInst = parseInt(i)+1;
        html += '<td><input id="vag_' + i + '" name="vag_tr" onfocus="this.blur()" type="button" class="submit" style="cursor:pointer;background:#C3C3C3;font-size: 12px;height: 25px;width: 110px;border: 0px;" onClick="SubmitGetProfile(' +Profile[i].profileid+ ');"/>';
        html += '</td>';
    }
    
    document.write(html);
    document.write('</tr>');
    document.write('</table>');
}
</script>

<table>
    <tr> 
        <td class="tabal_head" colspan="11" BindText='vspa_interfaceadv'></td>
    </tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="1" >
 	<tr>
        <td class="width_per25 table_title" BindText='vspa_URItype'></td>
        <td width="80%" class="table_right" colspan="10" > 
            <select name="URIType_select" id="URIType_select" size="1" class="width_150px"/>
            <option value="SIP"><script>document.write(sipuser['vspa_urisip']);</script></option>
            <option value="TEL"><script>document.write(sipuser['vspa_uritel']);</script></option>
            </select>
        </td>
    </tr> 
	
	<tr>
        <td class="width_per25 table_title">二次拨号模式：</td>
        <td width="80%" class="table_right" colspan="10" > 
            <select name="DTMFMethod_select" id="DTMFMethod_select" size="1" class="width_150px"/>
            <option value="RFC2833"><script>document.write(sipuser['vspa_rfc']);</script></option>
            <option value="InBand"><script>document.write(sipuser['vspa_inband']);</script></option>
			<option value="SIPInfo"><script>document.write(sipuser['vspa_sipinfo']);</script></option>
            </select>
        </td>
    </tr> 

	<tr>
        <td class="table_title width_per25" BindText='vspa_siplocport'>
        </td>
        <td width="80%" class="table_right" colspan="10" >
             <input type="text" id="SipLocalPort_text" class="width_123px"/>
             <span class="gray"><script>document.write(sipuser['vspa_siplocportlen']); </script></span></td>
        </td>
    </tr>	
	<tr>
        <td class="table_title width_per25" BindText='vspa_sipdscpmark'>
        </td>
        <td width="80%" class="table_right" colspan="10" >
             <input type="text" id="SipDSCPMark_text" class="width_123px"/>
             <span class="gray"><script>document.write(sipuser['vspa_dscpmarklen']); </script></span></td>
        </td>
    </tr>	
	
	<tr>
        <td class="table_title width_per25" BindText='vspa_rtpdscpmark'>
        </td>
        <td width="80%" class="table_right" colspan="10" >
             <input type="text" id="RtpDSCPMark_text" class="width_123px"/>
             <span class="gray"><script>document.write(sipuser['vspa_dscpmarklen']); </script></span></td>
        </td>
    </tr>
	
	<tr>
        <td class="table_title width_per25" BindText='vspa_regexprie'>
        </td>
        <td width="80%" class="table_right" colspan="10" >
             <input type="text" id="RegisterExpires_text" class="width_123px"/>
             <span class="gray"><script>document.write(sipuser['vspa_regexprielen']); </script></span></td>
        </td>
    </tr>
	
	<tr>
        <td class="table_title width_per25" BindText='vspa_regrery'>
        </td>
        <td width="80%" class="table_right" colspan="10" >
             <input type="text" id="RegisterRetryInterval_text" class="width_123px"/>
             <span class="gray"><script>document.write(sipuser['vspa_regrerylen']); </script></span></td>
        </td>
    </tr>	
	
	<tr>
        <td class="table_title width_per25" BindText='vspa_sessionexprie'>
        </td>
        <td width="80%" class="table_right" colspan="10" >
             <input type="text" id="SessionExpires_text" class="width_123px"/>
             <span class="gray"><script>document.write(sipuser['vspa_sessionelen']); </script></span></td>
        </td>
    </tr>		
	
	<tr>
        <td class="table_title width_per25" BindText='vspa_rtpstart'>
        </td>
        <td width="80%" class="table_right" colspan="10" >
             <input type="text" id="RtpPortStart_text" class="width_123px"/>
             <span class="gray"><script>document.write(sipuser['vspa_rtpstartlen']); </script></span></td>
        </td>
    </tr>
	
	<tr>
        <td class="table_title width_per25" BindText='vspa_rtpend'>
        </td>
        <td width="80%" class="table_right" colspan="10" >
             <input type="text" id="RtpPortEnd_text" class="width_123px"/>
             <span class="gray"><script>document.write(sipuser['vspa_rtpendlen']); </script></span></td>
        </td>
    </tr>
	
	<tr> 
        <td class="width_per25 table_title" BindText='vspa_prackenable'></td>   
        <td width="80%" class="table_right" colspan="10"> 
        <input name='PRACKEnable_checkbox' type='checkbox' id='PRACKEnable_checkbox' value='1' />
        </td>
    </tr>
	<tr> 
        <td class="width_per25 table_title" BindText='vspa_bootreg'></td>   
        <td width="80%" class="table_right" colspan="10"> 
        <input name='BootDeRegisterEnable_checkbox' type='checkbox' id='BootDeRegisterEnable_checkbox'  onclick="setBootDeRegPara()"/>
        </td>

        <tr id="TrBootDeRegVal" style="display:none;">
        <td class="width_per20 table_title" BindText='vspa_bootReg_condition'></td> 
        <td class="table_right" colspan="3">
            <select id="BootDeRegVal" class="wid_160px">
                <option value="1" selected="selected"><script>document.write(sipuser['vspa_DeReg_403']);</script></option>
                <option value="2"><script>document.write(sipuser['vspa_DeReg_Init']);</script></option>
                <option value="3"><script>document.write(sipuser['vspa_DeReg_All']);</script></option>
            </select>
        </td>
    	</tr>
    </tr>
	<tr> 
        <td class="width_per25 table_title" BindText='vspa_subscribeenable'></td>   
        <td width="80%" class="table_right" colspan="10"> 
        <input name='SubscribeEnable_checkbox' type='checkbox' id='SubscribeEnable_checkbox' value='1' />
        </td>
    </tr>	
	<tr> 
        <td class="width_per25 table_title">回声抑制：</td>   
        <td width="80%" class="table_right" colspan="10"> 
        <input name='EchoCancelEnable_checkbox' type='checkbox' id='EchoCancelEnable_checkbox' value='1' />
        </td>
    </tr>
	
	<tr> 
        <td class="width_per25 table_title">静音检测：</td>   
        <td width="80%" class="table_right" colspan="10"> 
        <input name='VadCngEnable_checkbox' type='checkbox' id='VadCngEnable_checkbox' value='1' />
        </td>
    </tr>

	<tr>
        <td class="table_title width_per25" BindText='vspa_Rfc2833PT'>
        </td>
        <td width="80%" class="table_right" colspan="10" >
             <input type="text" id="HW_Rfc2833PT" class="width_123px"/>
             <span class="gray"><script>document.write(sipuser['vspa_2833len']); </script></span></td>
        </td>
    </tr>
	
	

    <tr>
        <td class="width_per25 table_title" BindText='vspa_profilebody'></td>
        <td width="80%" class="table_right" colspan="10" >
            <textarea name="X_HW_SIPProfile_Body" id = "X_HW_SIPProfile_Body" cols="67" rows="3" class="wid_383px"/>0=0;1=2;2=1;3=0;4=0;5=0;6=0;7=0;8=0;9=0;10=0;11=1;12=0;13=0;14=0;15=0;16=0;17=0;18=0;19=0;20=0;21=0;22=0;23=0;24=0;25=0;26=0;27=0;28=0;29=0;30=0;31=0;32=0;33=0;34=0;35=0;36=0;37=0;38=0;39=0;40=1;41=4;42=0;43=0;44=0;45=0;46=0;47=2000;48=0;49=60;50=0;51=0;52=0;53=0;54=0;55=1;56=1;57=7;58=3;59=0;60=0;61=0;62=0;63=0;64=4;65=400;66=1;67=400;68=1;69=400;70=1;71=400;72=1;73=400;74=0;75=20;76=0;77=0;78=0;79=1;80=1;81=0;82=0;83=0;84=1;85=0;86=180;87=2;88=0;89=0;90=0;91=0;92=0;93=1;94=1;95=40;96=1;97=2;98=0;99=0;100=0;101=0;102=2000;103=0;104=60;105=60;106=0;107=0;108=0;109=0;110=500;111=0;112=0;113=1;114=0;115=0;116=0;117=65534;118=65534;119=65534;
            </textarea>
        </td>
    </tr>
    <tr>
        <td class="table_title width_per25" BindText='vspa_softpara'></td>
        <td width="80%" class="table_right" colspan="10" >
            <select name="SelectSoftwarePara" id = "SelectSoftwarePara" onchange="onChangeSoftware()" class="width_150px"/>
                <option value="0"><script>document.write(sipuser['vspa_default']);</script></option>
                <option value="1"><script>document.write(sipuser['vspa_userdefine']);</script></option>
            </select> 
            <input type="text" name="X_HW_SIPExtend_SoftwarePara" id = "X_HW_SIPExtend_SoftwarePara" class="wid_280px"/>
        </td>
    </tr>
    
    <tr>
        <td class="width_per25 table_title" BindText='vspa_shareusermode'></td>
        <td width="80%" class="table_right" colspan="10" > 
            <select name="HW_ShareUserMode" id="HW_ShareUserMode" size="1" class="width_150px"/>
            <option value="Disabled" selected="selected"><script>document.write(sipuser['vspa_disabled']);</script></option>
            <option value="RingParallel"><script>document.write(sipuser['vspa_ringparall']);</script></option>
            </select>
        </td>
    </tr>

    <tr>
        <td class="width_per25 table_title" BindText='vspa_multihomemode'></td>
        <td width="80%" class="width_80p table_right" colspan="10" > 
            <select name="HW_MultiHomeMode" id="HW_MultiHomeMode" size="1" class="width_150px"/>
            <option value="" selected="selected">
            <option value="Disabled"><script>document.write(sipuser['vspa_disabled']);</script></option>
            <option value="DualHome"><script>document.write(sipuser['vspa_dualhome']);</script></option>
            <option value="DualHomeAutoSwitchOver"><script>document.write(sipuser['vspa_dualhomeswitch']);</script></option>
            <option value="LoadSharing"><script>document.write(sipuser['vspa_dualhomeauto']);</script></option>
            </select>
        </td>
    </tr>

	<tr>
		<td class="width_per25 table_title">信令端口：</td>	
		<td width="80%" class="table_right" colspan="10"> 
		<select name="X_HW_PortName" id="X_HW_PortName" maxlength="30">
			  <script language="JavaScript" type="text/javascript">
			  document.write('<option value=' + " " + ' >'+ '<\/option>');	
				document.write('<option value=' + "br0" + ' id="br0">'
									   + "br0"+ '<\/option>'); 
				for (i = 0; i < WanInfo.length; i++)
				{

					document.write('<option id="wan_' + i + '" value="' + domainTowanname(WanInfo[i].domain) + '">' + MakeWanName(WanInfo[i]) + '<\/option>');


				}
			  </script>
	   </select><span class="gray">(语音信令WAN端口名)</td>
	</tr>
	<tr>
	     	<td class="table_title align_left width_per25">媒体端口：</td>
	     	<td width="80%" class="table_right" colspan="10"> 
		 	<select name="MediaPortName" id = "MediaPortName" maxlength="30" >
                        <script language="JavaScript" type="text/javascript">
                            document.write('<option value="" id="null">'
                                              + ''+ '<\/option>'); 
                            document.write('<option value=' + "br0" + ' id="br0">'
                                                  + "br0"+ '<\/option>'); 
                                        for (i = 0; i < WanInfo.length; i++)
                    {
							document.write('<option id="wan_' + i + '" value="' + domainTowanname(WanInfo[i].domain) + '">' + MakeWanName(WanInfo[i]) + '<\/option>');
                    }
                </script>
                        </select>
      		<span class="gray">(语音媒体WAN端口名，为空表示与信令端口名相同)</td>
  			</tr>
			
	<tr>
        <td class="table_title width_per25" BindText='vspa_DtasAck'>
        </td>
        <td width="80%" class="table_right" colspan="10" >
             <input type="text" id="OffhookDtasAckInterval" class="width_123px"/>
			 <span class="gray"><script>document.write(sipuser['vspa_uintms']); </script></span>
		     <span class="gray"><script>document.write(sipuser['vspa_DtasAcklen']); </script></span>
        </td>
    </tr>	
	
	<tr>
		<td class="width_per25 table_title" BindText='vspa_Option120Priority'></td>
        <td width="80%" class="table_right" colspan="10" > 
            <select name="Option120Priority_select" id="Option120Priority_select" size="1" class="width_150px"/>
            <option value="0"><script>document.write(sipuser['vspa_Option120Ignore']);</script></option>
			<option value="1"><script>document.write(sipuser['vspa_Option120PriorityHighest']);</script></option>
			<option value="2"><script>document.write(sipuser['vspa_Option120PriorityLowest']);</script></option>
            </select>
        </td>
    </tr> 
</table>
<table>
    <tr> 
        <td class="tabal_head"> <font face="Arial"><script>document.write(sipuser['vspa_useradvpara']);</script></font></td>
    </tr>
</table>
<div id="line_list"></div>



<table width="100%" height="15" border="0" cellpadding="0" cellspacing="0">
</table> 
<div id="ConfigForm1">

<table width="100%" border="0" cellpadding="0" cellspacing="1"  id="CodecInfo" >

<script type="text/javascript">
    { 
    document.write(
	'<tr class="table_title">'    
    +'<td class="align_right">G.722<input id="G722Enable_checkbox" name="G722Enable_checkbox"  value="1" type="checkbox" onclick=""/></td>'
    );
    document.write(
	'<td class="align_center">编码优先级：<input type="text" name="G722Priority_text" id="G722Priority_text" maxlength="256" value="" class="wid_50px"/> <span class="gray" style="font-weight:normal">(1-100)</span></td>'    
    +'<td class="align_center">RTP打包间隔：<input type="text" name="G722RtpPackageInterval_text" id="G722RtpPackageInterval_text" maxlength="256" value="" class="wid_70px"/><span class="gray" style="font-weight:normal">(毫秒)</span></td>'
    +'</tr>'
	
	+'<tr class="table_title">'
    +'<td class="align_right" >G.711A<input id="G711aEnable_checkbox" name="G711aEnable_checkbox" value="1" type="checkbox" onclick="" /></td>'
    );
    document.write(
	'<td class="align_center">编码优先级：<input type="text" name="G711aPriority_text" id="G711aPriority_text" maxlength="256" value="" class="wid_50px"/> <span class="gray" style="font-weight:normal">(1-100)</span></td>'
    +'<td class="align_center">RTP打包间隔：<input type="text" name="G711aRtpPackageInterval_text" id="G711aRtpPackageInterval_text" maxlength="256" value=""  class="wid_70px"/><span class="gray" style="font-weight:normal">(毫秒)</span></td>'
    +'</tr> '
	

    +'<tr class="align_left table_title">'
    +'<td class="align_right" >G.711U<input id="G711uEnable_checkbox" name="G711uEnable_checkbox" value="1" type="checkbox" onclick="" /></td>');
    document.write(
	'<td class="align_center">编码优先级：<input type="text" name="G711uPriority_text" id="G711uPriority_text" maxlength="256" value=""  class="wid_50px"/> <span class="gray" style="font-weight:normal">(1-100)</span></td>'
    +'<td class="align_center">RTP打包间隔：<input type="text" name="G711uRtpPackageInterval_text" id="G711uRtpPackageInterval_text" maxlength="256" value=""  class="wid_70px"/><span class="gray" style="font-weight:normal">(毫秒)</span></td>'
    +'</tr>'
	

    +'<tr class="table_title">'
    +'<td class="align_right">G.729<input id="G729Enable_checkbox" name="G729Enable_checkbox" value="1" type="checkbox" onclick="" /></td>'
    );
    document.write(
	'<td class="align_center">编码优先级：<input type="text" name="G729Priority_text" id="G729Priority_text" maxlength="256" value="" class="wid_50px"/> <span class="gray" style="font-weight:normal">(1-100)</span></td>'
    +'<td class="align_center">RTP打包间隔：<input type="text" name="G729RtpPackageInterval_text" id="G729RtpPackageInterval_text" maxlength="256" value=""  class="wid_70px"/><span class="gray" style="font-weight:normal">(毫秒)</span></td>'   
    +'</tr>'
	
	

    );
} 
   
        
</script>   
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="1" >
<tr>
        <td class="table_title width_per20">DSP接收增益值：</td>
        <td class="table_right" colspan="3">
            <input type="text" class="width_123px" id="DSPRXGain_text" />
			<span class="gray"><script>document.write(sipuser['vspa_dspreceivegainrange']);</script></span>
		</td>
    </tr>
    <tr>
        <td class="table_title width_per20">DSP发送增益值：</td>
        <td class="table_right" colspan="3">
            <input type="text" class="width_123px" id="DSPTXGain_text" />
			<span class="gray"><script>document.write(sipuser['vspa_dspsendgainrange']);</script></span>
        </td>
    </tr>
    
</table>


<table width="100%" border="0" cellpadding="0" cellspacing="1" >
</table>

    <div id="DivPhyParameter">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
</table>
    <table>
    <tr>
        <td colspan="4" class="tabal_head"><script>document.write(sipuser['vspa_phy']);</script></td>
    </tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="1" >
<tr id="DivPHYdisplay">
        <td class="table_title width_per20" BindText='vspa_portindex'>
        </td>
        <td class="table_right" colspan="3">
            <select id="PhyList" class="width_123px"></select>
        </td>
    </tr>
	<tr>
        <td class="table_title width_per20">拍叉最短时间：</td>
        <td class="table_right" colspan="3">
            <input type="text" class="width_123px" id="FlashMin_text" />
			<span class="gray"><script>document.write(sipuser['vspa_uintms']);</script></span>
        </td>
    </tr>
    <tr>
        <td class="table_title width_per20">拍叉最长时间：</td>
        <td class="table_right" colspan="3">
            <input type="text" class="width_123px" id="FlashMax_text" />
			<span class="gray"><script>document.write(sipuser['vspa_uintms']);</script></span>
		</td>
    </tr>
	
    <tr>
        <td class="table_title width_per20" BindText='vspa_ringvol'>
        </td>
        <td class="table_right" colspan="3">
           <input type="text" class="width_123px" id="RingVoltage_text" />
			<span class="gray"><script>document.write(sipuser['vspa_uintvrms']);</script></span>
        </td>
    </tr>

    <tr>
        <td class="table_title width_per20" BindText='vspa_uintvdc'>
        </td>
        <td class="table_right" colspan="3">
            <input type="text" class="width_123px" id="RingDCVoltageOverlapped" />
			<span class="gray"><script>document.write(sipuser['vspa_uintv']);</script></span>
        </td>
    </tr>
    <tr>
        <td class="table_title width_per20" BindText='vspa_sendgain'>
        </td>
        <td class="table_right" colspan="3">
            <select id="SendGain" class="width_123px">
                <option value="-6db">-6 db</option>
                <option value="-5.5db">-5.5 db</option>
                <option value="-5db">-5 db</option>
                <option value="-4.5db">-4.5 db</option>
                <option value="-4db">-4 db</option>
                <option value="-3.5db">-3.5 db</option>
                <option value="-3db">-3 db</option>
                <option value="-2.5db">-2.5 db</option>
                <option value="-2db">-2 db</option>
                <option value="-1.5db">-1.5 db</option>
                <option value="-1db">-1 db</option>
                <option value="-0.5db">-0.5 db</option>
                <option value="0db" selected="selected">0 db</option>
                <option value="0.5db">0.5 db</option>
                <option value="1db">1 db</option>
                <option value="1.5db">1.5 db</option>
                <option value="2db">2 db</option>
                <option value="2.5db">2.5 db</option>
                <option value="3db">3 db</option>
                <option value="3.5db">3.5 db</option>
                <option value="4db">4 db</option>
                <option value="4.5db">4.5 db</option>
                <option value="5db">5 db</option>
                <option value="5.5db">5.5 db</option>
                <option value="6db">6 db</option>
            </select>
        </td>
    </tr>
    <tr>
        <td class="table_title width_per20" BindText='vspa_recgain'>
        </td>
        <td class="table_right" colspan="3">
            <select id="ReceiveGain" class="width_123px">
                    <option value="0db">0 db</option>
                    <option value="-0.5db">-0.5 db</option>
                    <option value="-1db">-1 db</option>
                    <option value="-1.5db">-1.5 db</option>
                    <option value="-2db">-2 db</option>
                    <option value="-2.5db">-2.5 db</option>
                    <option value="-3db">-3 db</option>
                    <option value="-3.5db" selected="selected">-3.5 db</option>
                    <option value="-4db">-4 db</option>
                    <option value="-4.5db">-4.5 db</option>
                    <option value="-5db">-5 db</option>
                    <option value="-5.5db">-5.5 db</option>
                    <option value="-6db">-6 db</option>
                    <option value="-6.5db">-6.5 db</option>
                    <option value="-7db">-7 db</option>
                    <option value="-7.5db">-7.5 db</option>
                    <option value="-8db">-8 db</option>
                    <option value="-8.5db">-8.5 db</option>
                    <option value="-9db">-9 db</option>
                    <option value="-9.5db">-9.5 db</option>
                    <option value="-10db">-10 db</option>
                    <option value="-10.5db">-10.5 db</option>
                    <option value="-11db">-11 db</option>
                    <option value="-11.5db">-11.5 db</option>
                    <option value="-12db">-12 db</option>
            </select>
        </td>
    </tr>
    
    <tr>
        <td class="table_title width_per20" BindText='vspa_onhook'>
        </td>
        <td class="table_right" colspan="3">
            <input type="text" class="width_123px" id="OnhookConfirmTime" />
			<span class="gray"><script>document.write(sipuser['vspa_uintms']);</script></span>
        </td>
    </tr>
    <tr>
        <td class="table_title width_per20" BindText='vspa_impedance'>
        </td>
        <td class="table_right" colspan="3">
            <select id="Impedance">
                    <option value="0"><script>document.write(sipuser['vspa_chinatel']);</script></option>
                    <option value="1"><script>document.write(sipuser['vspa_chinauser']);</script></option>
                    <option value="2" selected="selected"><script>document.write(sipuser['vspa_sixhuno']);</script></option>
                    <option value="3"><script>document.write(sipuser['vspa_rus']);</script></option>
                    <option value="4"><script>document.write(sipuser['vspa_115']);</script></option>
                    <option value="5"><script>document.write(sipuser['vspa_120']);</script></option>
                    <option value="6"><script>document.write(sipuser['vspa_ninehuno']);</script></option>
                    <option value="7"><script>document.write(sipuser['vspa_brazil']);</script></option>
                    <option value="8"><script>document.write(sipuser['vspa_bt0']);</script></option>
                    <option value="9"><script>document.write(sipuser['vspa_HKBT3']);</script></option>
                    <option value="10"><script>document.write(sipuser['vspa_HKBT5']);</script></option>
                    <option value="11"><script>document.write(sipuser['vspa_BT1']);</script></option>
                    <option value="12"><script>document.write(sipuser['vspa_BT2']);</script></option>
                    <option value="13"><script>document.write(sipuser['vspa_BT3']);</script></option>
                    <option value="14"><script>document.write(sipuser['vspa_europe']);</script></option>
                    <option value="15"><script>document.write(sipuser['vspa_newzealand']);</script></option>
            </select>
        </td>
    </tr>
    <tr>
        <td class="table_title width_per20" BindText='vspa_current'>
        </td>
        <td class="table_right" colspan="3">
			<input type="text" class="width_123px" id="Current"/>
			<span class="gray"><script>document.write(sipuser['vspa_ma']);</script></span>
        </td>
    </tr>

    <tr id="TrFskTime">
        <td class="table_title width_per20" BindText='vspa_fsk'>
        </td>
        <td class="table_right" colspan="3">
            <input type="text" id="FskTime" class="width_123px"/>
			<span class="gray"><script>document.write(sipuser['vspa_uintms']);</script></span>
        </td>
    </tr>
    <tr>
        <td class="table_title width_per20" BindText='vspa_clipflow'>
        </td>
        <td class="table_right" colspan="3">
            <select id="ClipTransWhen" class="wid_135px">
                <option value="AfterRing"><script>document.write(sipuser['vspa_afterring']);</script></option>
                <option value="BeforeRing"><script>document.write(sipuser['vspa_beforering']);</script></option>
            </select>
        </td>
    </tr>
    <tr>
        <td class="table_title width_per20" BindText='vspa_enabledsptem'>
        </td>
        <td class="table_right" colspan="3">
            <input type="checkbox" id="EnableDspTemplate" onclick="setDspTemplatePara()" />
        </td>
    </tr>
    <tr id="TrWorkMode">
        <td class="table_title width_per20" BindText='vspa_workmode'>
        </td>
        <td class="table_right" colspan="3">
            <select id="WorkMode" class="width_123px">
                <option value="Voice"><script>document.write(sipuser['vspa_workmodevo']);</script></option>
                <option value="Fax"><script>document.write(sipuser['vspa_workmodefax']);</script></option>
                <option value="Modem" selected="selected"><script>document.write(sipuser['vspa_workmodemodem']);</script></option>
            </select>
        </td>
    </tr>

	<tr>
        <td class="table_title width_per20" BindText='vspa_gDspTmpName'>
        </td>
        <td class="table_right" colspan="3">
            <input type="text" name="DspTemplateName" id="DspTemplateName" />
			<span class="gray"><script>document.write(sipuser['vspa_gDspTmpNamehint']);</script></span>
        </td>
    </tr>
	
<td class="table_title width_per20" BindText='vspa_DspHighPass'>:</td>
      <td class="table_right" colspan="3">
        <input type="checkbox" name="DspHighPassFilterEnable" id="DspHighPassFilterEnable" />
      </td>
    </tr>
<tr>	
<td class="table_title width_per20" BindText='vspa_ClipFsk'>:</td>
  <td class="table_right" colspan="3">
	<input type="checkbox" name="ClipForceSendFsk" id="ClipForceSendFsk" />
  </td>
</tr>
    <tr ><td class="height_9p"></td></tr>
    </table>
    </div>
</div>
    <table width="100%" border="0" cellspacing="1" cellpadding="0" class="">
    <tr >
        <td class=" width_per20"></td>
        <td width="80%" class="" colspan="10" align="right">
        <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
        <input name="SaveApply_button" id="SaveApply_button" type="button" class="submit" value="Apply" onClick="Submit();"/> 
          <script type="text/javascript">
            document.getElementsByName('SaveApply_button')[0].value = sipuser['e8cvspa_apply'];    
          </script>
        <input name="Cancel_button" id="Cancel_button" type="button" class="submit" value="Cancel" onClick="CancelConfig();"/> 
          <script type="text/javascript">
            document.getElementsByName('Cancel_button')[0].value = sipuser['vspa_cancel'];    
          </script>            
        </td>
    </tr>
    </table>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr><td class="height10p"></td></tr>
</table>

</body>
</html>

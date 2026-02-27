<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<title>Chinese -- VOIP Status</title>
<script language="JavaScript" src="../../js/<%HW_WEB_CleanCache_Resource(cn_tabinfo.js);%>"></script>
<script language="JavaScript" type="text/javascript">

function stLine(Domain, Status, RegisterError)
{
    this.Domain = Domain;
    this.Status = Status;
    this.RegisterError = RegisterError;
}

function stLineURI(Domain, URI)
{
    this.Domain = Domain;
	if(URI != null)
    {
        this.URI = URI.toString().replace(/&apos;/g,"\'");
    }
    else
    {
        this.URI = URI;
    }  
}

var AllLine = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.{i},Status|X_HW_LastRegisterError,stLine);%>;
var AllLineURI = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.{i}.SIP,URI,stLineURI);%>;

function stAuth(Domain, AuthUserName)
{
    this.Domain = Domain;
    if(AuthUserName != null)
    {
        this.AuthUserName = AuthUserName.toString().replace(/&apos;/g,"\'");
    }
    else
    {
        this.AuthUserName = AuthUserName;
    }  
	
    var temp = Domain.split('.');
    this.key = '.' + temp[7] + '.';
}

var AllAuth = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.{i}.SIP,AuthUserName,stAuth);%>;
var Auth = new Array();
for (var i = 0; i < AllAuth.length-1; i++)
    Auth[i] = AllAuth[i];

var User = new Array();

function stUser(Domain, UserId)
{
    this.Domain = Domain;
    this.UserId = UserId;
}

function stLine1(Domain, LineName)
{
    this.Domain = Domain;
    if(LineName != null)
    {
        this.LineName = LineName.toString().replace(/&apos;/g,"\'");
    }
    else
    {
        this.LineName = LineName;
    }
}
var AllLine1 = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.{i}.X_HW_H248,LineName,stLine1);%>;


for (var i = 0; i < AllLine.length - 1; i++)
{
    User[i] = new stUser();
    User[i].UserId = AllLine1[i].LineName;
}



function LoadFrame()
{
	
}   

</script>

</head>
<body class="mainbody"  onLoad="LoadFrame();">
<table width="100%" height="10%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="prompt">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    
          <td width="100%" class="title_01" style="padding-left:10px;"><label id = "Title_voice_satus_lable">在本页面上，您可以查询语音用户注册状态。</label></td>
                </tr>
            </table>
        </td>
    </tr>
</table> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr ><td height="15px"></td></tr>
</table>
<table  width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr ><td>
<form id="ConfigForm">   
        <div>
    		<table width="100%" height="5" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style="table-layout:fixed;word-break:break-all">
            <tr class="head_title">
                <td width="13%" id="Table_voice_1_1_table">用户编号</td>  
				<td width="18%" id="Table_voice_1_2_table">用户名(电话号码)</td>              
                <td width="31%" id="Table_voice_1_3_table">用户注册状态</td>
                <td width="38%" id="Table_voice_1_4_table">注册错误信息</td>
            </tr>
            <script language="javascript">
            if (AllLine.length - 1 == 0)
            {
                var html = '';
                
                html += '<tr class="table_right">';
                html += '<td align="center">----</td>'
                       + '<td align="center">----</td>'
                       + '<td align="center">----</td>' 
  					   + '<td align="center">----</td>'                       
                html += '</tr>';     
                
                document.write(html);
            }
            else
            {
                for (i = 0; i < AllLine.length - 1; i++)
                {
                    var html = '';
                   
                    html += '<tr class="table_right">';
                    html += '<td align="left" id="Table_voice_2_1_table">' + (i+1) + '</td>';
                     if (User[i].UserId == "")
					{
						 if( Auth[i].AuthUserName.indexOf(":") >= 0)
						 {
						 	var Authpart = Auth[i].AuthUserName.split(':');
						 	var k1 = Authpart[1];
							var k2 = k1.split('@');
							var k3 = k2[0];
						 	html += '<td align="left" id="Table_voice_2_2_table">' + k3 + '</td>'
						 }
						 else
						 {
						 	var Authpart = Auth[i].AuthUserName.split('@');
						 	var k = Authpart[0];
						 	html += '<td align="left" id="Table_voice_2_2_table">' + k + '</td>'
						 }
					}
					else
					{
						 if( User[i].UserId.indexOf(":") >= 0)
						 {
						 	var UserId = User[i].UserId.split(':');
						 	var k1 = UserId[1];
							var k2 = k1.split('@');
							var k3 = k2[0];
						 	html += '<td align="left" id="Table_voice_2_2_table">' + k3 + '</td>'
						 }
						 else
						 {
						 	var UserId = User[i].UserId.split('@');
						 	var k = UserId[0];
						 	html += '<td align="left" id="Table_voice_2_2_table">' + k + '</td>'
						 }
					}    
					
					
					                         
					if ( AllLine[i].Status == 'Up' )
					{
						html += '<td align="left" id="Table_voice_2_3_table">注册成功</td>';
					}
					else if ( AllLine[i].Status == 'Initializing' )
					{
						html += '<td align="left" id="Table_voice_2_3_table">未完成配置</td>';
					}
					else if ( AllLine[i].Status == 'Registering' )
					{
						html += '<td align="left" id="Table_voice_2_3_table">注册中</td>';
					}
					else if ( AllLine[i].Status == 'Unregistering' )
					{
						html += '<td align="left" id="Table_voice_2_3_table">未注册</td>';
					}
					else if ( AllLine[i].Status == 'Quiescent' )
					{
						html += '<td align="left" id="Table_voice_2_3_table">停止的</td>';
					}
					else if ( AllLine[i].Status == 'Disabled' )
					{
						html += '<td align="left" id="Table_voice_2_3_table">未启用</td>';
					}
					else if ( AllLine[i].Status == 'Error' )
					{
						html += '<td align="left" id="Table_voice_2_3_table">故障</td>';
					}
					else if ( AllLine[i].Status == 'Testing' )
					{
						html += '<td align="left" id="Table_voice_2_3_table">测试中</td>';
					}
					else
					{
						html += '<td align="center" id="Table_voice_2_3_table">--</td>';
					}

					if ( AllLine[i].RegisterError == '-' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">--</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_ONU_OFFLINE' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">OLT注册失败</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_WAN_NOT_CONFIGURED' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">无语音通道</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_WAN_IP_NOT_OBTAINED' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">语音通道获取IP地址失败</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_CORENET_ADDRESS_INCORRECT' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">未正确配置MGC地址</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_VOICESERVICE_DISABLED' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">语音业务被关闭</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_USER_NOT_CONFIGURED' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">未配置用户</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_USER_NOT_BOUND_TO_POTS' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">用户未绑定POTS</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_POTS_DISABLED_BY_OLT' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">POTS被OLT禁用</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_USER_DISABLED' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">用户被禁用</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_USER_CONFLICT' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">号码冲突</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_REGISTRATION_AUTH_FAIL' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">注册鉴权失败</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_REGISTRATION_TIMEOUT' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">注册超时</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_ERROR_RESPONSE_RETURNED_BY_CORENET' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">MGC返回错误响应</td>';
					}
					else if ( AllLine[i].RegisterError == 'ERROR_UNKNOWN' )
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">未知错误原因</td>';
					}
					else
					{
						html += '<td class="align_left" id="Table_voice_2_4_table">--</td>';
					}   								                   

					                   
                    html += '</tr>';     
                    
                    document.write(html);
                }
            }
            </script>
    </table>
    </div>

</form>
</td></tr>
</table>
</body>
</html>

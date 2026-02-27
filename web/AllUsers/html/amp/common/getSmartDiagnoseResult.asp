function getResult()
{
	var wifiPwdSecurity = '';
	
	var flag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';
	if(flag == 1)
	{
		wifiPwdSecurity = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.WifiPwdSecurity.Security);%>';
	}
	else
	{
		wifiPwdSecurity = 'high';
	}
	
	
	var opticInfo = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic.RxPower);%>';
	
	var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
	var gponStatus = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT.State);%>';
	var eponStatus = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.OAM.ONT.State);%>';
	var regStatus = '';
	
	if(opticInfo == "--" || opticInfo == "")
	{ 
		opticInfo = "nok";
	}
	else
	{
		opticInfo = "ok";
	}
	
	if (ontPonMode.toUpperCase() == 'GPON')
	{
		if (gponStatus.toUpperCase() == 'O5')
		{
			regStatus = 'ok';
		}
		else
		{
			regStatus = 'nok';
		}
	}
	else if (ontPonMode.toUpperCase() == 'EPON')
	{
		if (eponStatus.toUpperCase() =="ONLINE" )
		{
			regStatus = 'ok';
		}
		else
		{
			regStatus = 'nok';
		}
	}
	else
	{
		regStatus = 'nok';
	}
	
	var obj = new Object();
	obj.wifiPwdSecurity = wifiPwdSecurity;
	obj.opticInfo = opticInfo;
	obj.regStatus = regStatus;
	
	return obj;
}

getResult();
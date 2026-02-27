<html>
<head>
<title>New Version Available</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="Cuscss/<%HW_WEB_CleanCache_Resource(login.css);%>"  media="all" rel="stylesheet" />
<link href="Cuscss/<%HW_WEB_CleanCache_Resource(frame.css);%>" type='text/css' rel="stylesheet">
<script language="JavaScript" src="/../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" type="text/javascript">

//var br0Ip = '<%HW_WEB_GetBr0IPString();%>';
//var httpport = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_WebServerConfig.ListenInnerPort);%>';
//var path='http://' + br0Ip +':'+ httpport + '/updateConfig.asp';
//var path='updateConfig.asp';

function webSubmitForm(sFormName, DomainNamePrefix)
{
    /*-----------------------internal method------------------------*/
    this.setPrefix = function(Prefix)
    {
	if (Prefix == null)
	{
	    this.DomainNamePrefix = '.';
	}
	else
	{
	    this.DomainNamePrefix = Prefix + '.';
	}
    }
	
    this.getDomainName = function(sName){
	if (this.DomainNamePrefix == '.')
	{
	    return sName;
	}
	else
	{
	    return this.DomainNamePrefix + sName;
	}
    }
	
    this.getNewSubmitForm = function()
    {
	var submitForm = document.createElement("FORM");
	document.body.appendChild(submitForm);
	submitForm.method = "POST";
	return submitForm;
    }
	
    this.createNewFormElement = function (elementName, elementValue){
	var newElement = document.createElement('INPUT');
	newElement.setAttribute('name',elementName);
	newElement.setAttribute('value',elementValue);
	newElement.setAttribute('type','hidden');
	return newElement;
    }
	
    /*---------------------------external method----------------------------*/
    this.addForm = function(sFormName,DomainNamePrefix){
	    this.setPrefix(DomainNamePrefix);
	    var srcForm = getElement(sFormName);
		if (srcForm != null && srcForm.length > 0 && this.oForm != null 
			&& srcForm.style.display != 'none')
		{
			MakeCheckBoxValue(srcForm);
			
			for(i=0; i < srcForm.elements.length; i++)
			{  
			     var type = srcForm.elements[i].type;
			     if (type != 'button' && srcForm.elements[i].disabled == false)
				 {				
					 if (this.DomainNamePrefix != '.')
					 {
						 var ele = this.createNewFormElement(this.DomainNamePrefix 
												              + srcForm.elements[i].name,
												              srcForm.elements[i].value);	
						 this.oForm.appendChild(ele);
					 }	   
					 else
					 {
						var ele = this.createNewFormElement(srcForm.elements[i].name,
												             srcForm.elements[i].value
															  );
						this.oForm.appendChild(ele);
					 }	 
				 }
			 }
		}
		else
		{
			this.status = false;
		}
		
		this.DomainNamePrefix = '.';
	}
    
	this.addDiv = function(sDivName,Prefix)
	{
		if (Prefix == null)
		{
			Prefix = '';
		}
		else
		{
			Prefix += '.';
		}
		
		var srcDiv = getElement(sDivName);	
		if (srcDiv == null)
		{
			debug(sDivName + ' is not existed!')
			return;
		}
		if (srcDiv.style.display == 'none')
		{
			return;
		}

		var eleSelect = srcDiv.getElementsByTagName("select");
		if (eleSelect != null)
	        {
			for (k = 0; k < eleSelect.length; k++)
			{
				if (eleSelect[k].disabled == false)
				{
					this.addParameter(Prefix+eleSelect[k].name,eleSelect[k].value)
				}
			}
		}
		
		MakeCheckBoxValue(srcDiv);
		var eleInput = srcDiv.getElementsByTagName("input");
		if (eleInput != null)
	        {
			for (k = 0; k < eleInput.length; k++)
			{
				if (eleInput[k].type != 'button' && eleInput[k].disabled == false)
				{
				    this.addParameter(Prefix+eleInput[k].name,eleInput[k].value)
				}
			}	
		}
	}
	
	this.addParameter = function(sName, sValue){
		//妫€鏌ユ槸鍚﹀瓨鍦ㄨ繖涓厓绱?
		var DomainName = this.getDomainName(sName);
		
		for(i=0; i < this.oForm.elements.length; i++) 
		{
			if(this.oForm.elements[i].name == DomainName)
			{
				this.oForm.elements[i].value = sValue;
				this.oForm.elements[i].disabled = false;
				return;
			}
		}
	
		//娌℃湁鍙戠幇杩欎釜鍏冪礌
		if(i == this.oForm.elements.length) 
		{	
			var ele = this.createNewFormElement(DomainName,sValue);	
			this.oForm.appendChild(ele);
		}
	}
	
        this.disableElement = function(sName){	
	    var DomainName = this.getDomainName(sName);		
		for(i=0; i < this.oForm.elements.length; i++) 
		{
			if(this.oForm.elements[i].name == DomainName)
			{
				this.oForm.elements[i].disabled = true;
				return;
			}
		}
	}
	
        this.usingPrefix = function(Prefix){
	     this.DomainNamePrefix = Prefix + '.';
	}
	
        this.endPrefix = function(){
	     this.DomainNamePrefix = '.';
	}
	
	this.setMethod = function(sMethod) {
		if(sMethod.toUpperCase() == "GET")
			this.oForm.method = "GET";
		else
			this.oForm.method = "POST";
	};

	this.setAction = function(sUrl) {
		this.oForm.action = sUrl;
	}

	this.setTarget = function(sTarget) {
		this.oForm.target = sTarget;
	};

	this.submit = function(sURL, sMethod) {
		if( sURL != null && sURL != "" ) this.setAction(sURL);
		if( sMethod != null && sMethod!= "" ) this.setMethod(sMethod);
		
		if (this.status == true)
		    this.oForm.submit();
	};
	
	this.status = true;


	/*--------------------------------excute by internal-------------------------*/
	this.setPrefix(DomainNamePrefix);
	this.oForm = this.getNewSubmitForm();
	if (sFormName != null && sFormName != '')
	{
		this.addForm(sFormName,this.DomainNamePrefix);

	}
}

function LoadFrame() 
{

}

function setdisableall()
{	
	document.getElementById('btnApply1').disabled = true;
	document.getElementById('btnApply2').disabled = true;
	document.getElementById('btnApply3').disabled = true;
}

function submitbtn1()
{	
	var Form = new webSubmitForm();
	Form.setAction('agreePopUpgrade.cgi?&RequestFile=updateNote.asp');	
	//Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	setdisableall();
    Form.submit(); 	
}

function submitbtn2()
{
	var Form = new webSubmitForm();
	Form.setAction('refusePopUpgrade.cgi?&RequestFile=updateNote.asp');
	//Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
	setdisableall();
    Form.submit(); 
}
function submitbtn3()
{
	var Form = new webSubmitForm();
	Form.setAction('remindPopUpgrade.cgi?&RequestFile=updateNote.asp');
	//Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	setdisableall();
    Form.submit(); 
}

</script>
</head>
<body onLoad="LoadFrame();">
	
	<div >
	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	<button id="btnApply1" name="btnApply1" type="button" class="submit" onClick="submitbtn1();">Upgrade Now</script></button> 
	<button name="btnApply2" id="btnApply2" class="submit" type="button" onClick="submitbtn2();">Ignore</button> 
	<button name="btnApply3" id="btnApply3" class="submit" type="button" onClick="submitbtn3();">Upgrade Later</button> 
	</div>
		
	<!-- <table width="100%" border="0" cellpadding="0" cellspacing="0" id="tabTest">	
		<tr>温馨提醒：</tr>
		<tr>     升级：网关立即升级，升级期间请勿断电</tr>		
		<tr>  不升级：网关不升级，本次消息不再提醒</tr>		
		<tr>暂不升级：暂时不升级，稍后每周弹窗提醒</tr>
		<tr></tr>
	</table> -->

</body>
</html>

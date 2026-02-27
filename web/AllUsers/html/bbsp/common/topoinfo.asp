function TopoInfoClass(Domain, EthNum, SSIDNum)
{   
    this.Domain = Domain;
    this.EthNum = EthNum;
    this.SSIDNum = SSIDNum;
}

var TopoInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Topo,X_HW_EthNum|X_HW_SsidNum,TopoInfoClass);%>
var TopoInfo = TopoInfoList[0];
if('<%GetLanPortNum();%>' != "" && '<%GetLanPortNum();%>' != null)
{
	TopoInfo.EthNum = '<%GetLanPortNum();%>';
}

function GetTopoInfo()
{
    return TopoInfo;
}
function GetTopoItemValue(Name)
{
    return TopoInfo[Name];
}

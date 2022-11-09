 
<%
/*
 * privilegeedit.jsp
 *
 * Created on April 04, 2002, 11:30 AM
 *
 * @author  ktanjana
 * @version 
 */
%>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ page import = "com.dimata.harisma.form.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_USER_MANAGEMENT, AppObjInfo.OBJ_USER_PRIVILEGE); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
//boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
//boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
//boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
//out.println("privAdd : "+privAdd+" - privUpdate : "+privUpdate+" - privDelete : "+privDelete);
%>
<!-- JSP Block -->
<%!

public String drawListPrivObj(Vector objectClass)
{
	String temp = "";
	String regdatestr = "";

	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("98%");
	ctrlist.setListStyle("listarea"); 
	ctrlist.setTitleStyle("tableheader");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("tableheader");
	ctrlist.addHeader("Module","20%");
	ctrlist.addHeader("Module Group 1","20%");
	ctrlist.addHeader("Module Group 2","20%");	
	ctrlist.addHeader("authorization ","30%");

	ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
	
	Vector lstData = ctrlist.getData();

	Vector lstLinkData 	= ctrlist.getLinkData();					
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	
	for (int i = 0; i < objectClass.size(); i++) {
		 AppPrivilegeObj appPrivObj = (AppPrivilegeObj) objectClass.get(i);

		 Vector rowx = new Vector();
		 rowx.add(AppObjInfo.getTitleObject(appPrivObj.getCode()));
		 rowx.add(AppObjInfo.getTitleGroup1(appPrivObj.getCode()));
		 rowx.add(AppObjInfo.getTitleGroup2(appPrivObj.getCode()));
		 
		 
		 Vector cmdInts = appPrivObj.getCommands();
		 String cmdStr = new String("");
		 for(int ic=0;ic< cmdInts.size() ; ic++){
			cmdStr =cmdStr + AppObjInfo.getStrCommand(((Integer)cmdInts.get(ic)).intValue())+", ";
		 }
		 if(cmdStr.length()>0)
			cmdStr = cmdStr.substring(0, cmdStr.length()-2);
		 
		 rowx.add(cmdStr);
		 
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(appPrivObj.getOID()));
	}						

	return ctrlist.draw();
}

%>
<%
 
/* VARIABLE DECLARATION */

int recordToGet = 10;
String order = " " + PstAppPrivilegeObj.fieldNames[PstAppPrivilegeObj.FLD_CODE];

Vector listAppPrivObj = new Vector(1,1);


/* GET REQUEST FROM HIDDEN TEXT */
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
int listCommand = FRMQueryString.requestInt(request, "list_command");
if(listCommand==Command.NONE)
	listCommand = Command.FIRST;
long appPrivOID = FRMQueryString.requestLong(request,"appriv_oid");
long appPrivObjOID = FRMQueryString.requestLong(request,"apprivobj_oid");

CtrlAppPrivilegeObj ctrlAppPrivObj = new CtrlAppPrivilegeObj(request);
FrmAppPrivilegeObj frmAppPrivObj = ctrlAppPrivObj.getForm();
String cmdIdxString[] = request.getParameterValues("cmd_assigned");

  
/* GET OBJECT */ 
AppPriv appPriv = PstAppPriv.fetch(appPrivOID);
int iErrCode = ctrlAppPrivObj.action(iCommand, appPrivObjOID);
AppPrivilegeObj appPrivObj= ctrlAppPrivObj.getAppPrivObj(); 
int vectSize = PstAppPrivilegeObj.getCountByPrivOID_GroupByObj(appPrivOID); 


/* GET Modules Access */
int appObjG1 = FRMQueryString.requestInt(request,FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G1_IDX]);
int appObjG2 = FRMQueryString.requestInt(request,FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G2_IDX]);
int appObjIdx = FRMQueryString.requestInt(request,FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_OBJ_IDX]);

if(iCommand == Command.EDIT){  
  appObjG1 =(AppObjInfo.getIdxGroup1(appPrivObj.getCode()));
  appObjG2 =(AppObjInfo.getIdxGroup2(appPrivObj.getCode()));
  appObjIdx =(AppObjInfo.getIdxObject(appPrivObj.getCode())); 
   System.out.println(" IDX "+ appObjG1+ " "+ appObjG2+ " "+ appObjIdx +" " + appPrivObj.getCommands());
  appObjG1 = appObjG1<0 ? 0 : appObjG1;
  appObjG2 = appObjG2<0 ? 0 : appObjG2;
  appObjIdx = appObjIdx<0 ? 0 : appObjIdx;
}

String msgString = ctrlAppPrivObj.getMessage();
start=ctrlAppPrivObj.actionList(listCommand,start,vectSize,recordToGet);
order=	PstAppPrivilegeObj.fieldNames[PstAppPrivilegeObj.FLD_CODE];	
listAppPrivObj = PstAppPrivilegeObj.listWithCmd_ByPrivOID_GroupByObj(start,recordToGet, appPrivOID , order);


%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>HARISMA - System Privilege Edit</title>
<script language="JavaScript">
function cmdAdd(){
	document.frmList.command.value="<%=Command.ADD%>"; 
	document.frmList.list_command.value="<%=Command.LIST%>";
	document.frmList.submit();	
}

function cmdEdit(oid){
	document.frmList.command.value="<%=Command.EDIT%>"; 
	document.frmList.apprivobj_oid.value=oid;
	document.frmList.list_command.value="<%=Command.LIST%>";
	document.frmList.submit();	
}

function cmdSave(){
	document.frmEdit.command.value="<%=Command.SAVE%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}

function gotoManagementMenu(){
	document.frmList.action="<%=approot%>/management/main_man.jsp";
	document.frmList.submit();
}


<% if(privDelete) {%>
function cmdCancel(){
	document.frmEdit.command.value="<%=Command.EDIT%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}

function cmdAsk(){
	document.frmEdit.command.value="<%=Command.ASK%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}

function cmdDelete(){
	document.frmEdit.command.value="<%=Command.DELETE%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}
<%}%>
function changeG1(){
	document.frmEdit.command.value="<%=iCommand%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}

function changeG2(){
	document.frmEdit.command.value="<%=iCommand%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}

function changeModule(){
	document.frmEdit.command.value="<%=iCommand%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}


function cmdListFirst(){
	document.frmList.list_command.value="<%=Command.FIRST%>";
	document.frmList.command.value="<%=Command.NONE%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}

function cmdListPrev(){
	document.frmList.list_command.value="<%=Command.PREV%>";
	document.frmList.command.value="<%=Command.NONE%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}

function cmdListNext(){
	document.frmList.list_command.value="<%=Command.NEXT%>";
	document.frmList.command.value="<%=Command.NONE%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}
function cmdListLast(){
	document.frmList.list_command.value="<%=Command.LAST%>";
	document.frmList.command.value="<%=Command.NONE%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}

function goPrivilege(){
	document.frmList.command.value="<%=Command.BACK%>";
	document.frmList.action="privilegelist.jsp";
	document.frmList.submit();
}

function cmdBack(){
	document.frmEdit.command.value="<%=Command.BACK%>";
	document.frmEdit.action="privilegeedit.jsp";
	document.frmEdit.submit();
}
</script>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> 
<!-- #BeginEditable "styles" --> 
<link rel="stylesheet" href="../styles/main.css" type="text/css">
<!-- #EndEditable -->
<!-- #BeginEditable "stylestab" --> 
<link rel="stylesheet" href="../styles/tab.css" type="text/css">
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<SCRIPT language=JavaScript>
<!--
function hideObjectForEmployee(){
    } 
	 
    function hideObjectForLockers(){ 
    }
	
    function hideObjectForCanteen(){
    }
	
    function hideObjectForClinic(){
    }

    function hideObjectForMasterdata(){
    }
	
	function showObjectForMenu(){
    }

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</SCRIPT>
<!-- #EndEditable -->
</head> 

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnNewOn.jpg','<%=approot%>/images/BtnBackOn.jpg')">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
  <tr> 
    <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
      <!-- #BeginEditable "header" --> 
      <%@ include file = "../main/header.jsp" %>
      <!-- #EndEditable --> 
    </td>
  </tr> 
  <tr> 
    <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
      <%@ include file = "../main/mnmain.jsp" %>
      <!-- #EndEditable --> </td> 
  </tr>
  <tr> 
    <td  bgcolor="#9BC1FF" height="10" valign="middle"> 
		
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
			<td align="left"><img src="<%=approot%>/images/harismaMenuLeft1.jpg" width="8" height="8"></td>
          <td align="center" background="<%=approot%>/images/harismaMenuLine1.jpg" width="100%"><img src="<%=approot%>/images/harismaMenuLine1.jpg" width="8" height="8"></td>
			<td align="right"><img src="<%=approot%>/images/harismaMenuRight1.jpg" width="8" height="8"></td>
		  </tr>
		</table>
	</td> 
  </tr>
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="3" cellpadding="2"> 
        <tr> 
          <td width="100%">
      <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr> 
          <td height="20">
		    <font color="#FF6600" face="Arial"><strong>
			  <!-- #BeginEditable "contenttitle" -->User 
                  Management &gt; Privilege &gt; Edit Privilege<!-- #EndEditable --> 
            </strong></font>
	      </td>
        </tr>
        <tr> 
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td class="tablecolor"> 
                  <table width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                    <tr> 
                      <td valign="top"> 
                        <table width="100%" border="0" cellspacing="1" cellpadding="1" class="tabbg">
                          <tr> 
                            <td valign="top">
		    				  <!-- #BeginEditable "content" --> 								  
                                    <div class="bigtitleflash"></div>
                                    <table width="100%">
                                      <tr> 
                                        <td colspan="2" valign="top"> 
                                          <form name="frmList" method="post" action="privilegeedit.jsp">
                                            <table width="100%">
                                              <tr> 
                                                <td width="167" nowrap> Privilege 
                                                  Name </td>
                                                <td width="679" nowrap>&nbsp;<%=appPriv.getPrivName()%> 
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="167">Description </td>
                                                <td width="679" nowrap>&nbsp;<%=appPriv.getDescr()%></td>
                                              </tr>
                                              <% if(listAppPrivObj != null && listAppPrivObj.size()>0){%>
                                              <tr> 
                                                <td colspan="2" class="listtitle">Module 
                                                  Access List</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2"><%=drawListPrivObj(listAppPrivObj)%> 
                                                </td>
                                              </tr>
                                              <% }else{%>
                                              <tr> 
                                                <td colspan="2" class="comment">No 
                                                  Access available </td>
                                              </tr>
                                              <%}%>
                                              <tr> 
                                                <td colspan="2" class="command"> 
                                                  <% ControlLine ctrLine = new ControlLine(); %>
                                                  <%
                                                   ctrLine.setLocationImg(approot+"/images");
												   ctrLine.initDefault();						   					   
											%>
                                                  <%=ctrLine.drawImageListLimit(listCommand,vectSize,start,recordToGet)%> 
                                                </td>
                                              </tr>											  
                                              <tr> 
                                                <td colspan="2" class="command"> 
                                                  <% if(iCommand == Command.LIST || iCommand == Command.SAVE || iCommand == Command.DELETE || iCommand == Command.BACK ||
							 iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST ){%>
                                                  <table width="38%" border="0" cellspacing="1" cellpadding="2">
                                                    <% if(privAdd && privUpdate){%>
                                                    <tr> 
                                                      <td width="9%"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image100111','','<%=approot%>/images/BtnNewOn.jpg',1)"><img name="Image100111" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Add New Privilege"></a></td>
                                                      <td nowrap width="41%"><a href="javascript:cmdAdd()" class="command">Add 
                                                        New Module Access</a></td>
                                                      <td width="7%"><a href="javascript:goPrivilege()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('G2','','<%=approot%>/images/BtnBackOn.jpg',1)"><img name="G2" border="0" src="<%=approot%>/images/BtnBack.jpg" width="24" height="24" alt="Back To Privilege List"></a></td>
                                                      <td class="command" width="43%"><a href="javascript:goPrivilege()">Back 
                                                        To Privilege List</a></td>
                                                    </tr>
                                                    <% }%>
                                                  </table>
                                                  <%}%>
                                                  <input type="hidden" name="appriv_oid" value="<%=appPrivOID%>">
                                                  <input type="hidden" name="apprivobj_oid" value="<%=appPrivObjOID%>">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="list_command" value="<%=listCommand%>">
                                                  <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G1_IDX]%>" value="<%=appObjG1%>">
                                                  <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G2_IDX]%>" value="<%=appObjG2%>">
                                                  <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_OBJ_IDX]%>" value="<%=appObjIdx%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                </td>
                                              </tr>
                                            </table>
                                          </form>
                                        </td>
                                      </tr>
                                      <%if(((iCommand==Command.SAVE)&&(frmAppPrivObj.errorSize()>0))||(iCommand==Command.ADD)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                                      <tr> 
                                        <td colspan="2" valign="top"> 
                                          <form name="frmEdit" method="post" action="">
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="167">Group 1 
                                                  <input type="hidden" name="appriv_oid" value="<%=appPrivOID%>">
                                                  <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_PRIV_ID]%>" value="<%=appPrivOID%>">
                                                  <input type="hidden" name="apprivobj_oid" value="<%=appPrivObjOID%>">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="list_command" value="<%=listCommand%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                </td>
                                                <td width="679" nowrap> 
                                                  <% if (iCommand==Command.ADD) {%>
                                                  <select name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G1_IDX]%>" class="elemenForm" onChange="javascript:changeG1()">
                                                    <% for(int ig1=0;ig1< AppObjInfo.titleG1.length; ig1++){
                        String select = (appObjG1 == ig1) ? "selected" : "";
						  try{
                        %>
                                                    <option value="<%=ig1%>" <%=select%>><%=AppObjInfo.titleG1[ig1]%></option>
                                                    <% 
							  } catch(Exception exc){
							     System.out.println(" CREATE LIST ==> privilegeedit.jsp. G1 exc"+exc);
							  }
							
							}%>
                                                  </select>
                                                  <% } else { %>
                                                  <%=AppObjInfo.titleG1[appObjG1]%> 
                                                  <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G1_IDX]%>" value="<%=appObjG1%>">
                                                  <%}%>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="167">Group 2</td>
                                                <td width="679" nowrap> 
                                                  <% if (iCommand==Command.ADD) {%>
                                                  <select name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G2_IDX]%>" onChange="javascript:changeG2()">
                                                    <% for(int ig2=0;ig2< AppObjInfo.titleG2[appObjG1].length; ig2++){
                        String select = (appObjG2 == ig2) ? "selected" : "";
						  try{
                        %>
                                                    <option value="<%=ig2%>" <%=select%>><%=AppObjInfo.titleG2[appObjG1][ig2]%></option>
                                                    <% 
							  } catch(Exception exc){
							     System.out.println(" CREATE LIST ==> privilegeedit.jsp. G2 exc"+exc);
							  }
							
							}%>
                                                  </select>
                                                  <% } else { %>
                                                  <%=AppObjInfo.titleG2[appObjG1][appObjG2]%> 
                                                  <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G2_IDX]%>" value="<%=appObjG2%>">
                                                  <%}%>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="167"> Module</td>
                                                <td width="679" nowrap> 
                                                  <% if (iCommand==Command.ADD) {%>
                                                  <select name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_OBJ_IDX]%>" onChange="javascript:changeModule()">
                                                    <% for(int iobj=0;iobj< AppObjInfo.objectTitles[appObjG1][appObjG2].length; iobj++){
                        String select = (appObjIdx == iobj) ? "selected" : "";
						  try{
                        %>
                                                    <option value="<%=iobj%>" <%=select%>><%=AppObjInfo.objectTitles[appObjG1][appObjG2][iobj]%></option>
                                                    <%
							  } catch(Exception exc){
							     System.out.println(" CREATE LIST ==> privilegeedit.jsp. Object exc"+exc);
							  }
							 }%>
                                                  </select>
                                                  <% } else { %>
                                                  <%=AppObjInfo.objectTitles[appObjG1][appObjG2][appObjIdx]%> 
                                                  <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_OBJ_IDX]%>" value="<%=appObjIdx%>">
                                                  <%}%>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="167">Authorization</td>
                                                <td width="679" nowrap> 
                                                  <% for(int id=0;id< AppObjInfo.objectCommands[appObjG1][appObjG2][appObjIdx].length; id++){
                            int iCmd= AppObjInfo.objectCommands[appObjG1][appObjG2][appObjIdx][id];
                            String checked = appPrivObj.existCommand(iCmd) ? "checked" : "";
                        %>
                                                  <input type="checkbox" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_COMMANDS]%>" value="<%=iCmd%>" <%=checked%>>
                                                  <%=AppObjInfo.strCommand[iCmd]%> 
                                                  &nbsp;&nbsp;&nbsp;&nbsp; 
                                                  <% }%>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="167">&nbsp;</td>
                                                <td width="679" nowrap>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2"> 
                                                  <%
							ctrLine.setLocationImg(approot+"/images");
							ctrLine.initDefault();
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+appPrivObjOID+"')";
							String sconDelCom = "javascript:cmdDelete('"+appPrivObjOID+"')";
							String scancel = "javascript:cmdCancel('"+appPrivObjOID+"')";
							ctrLine.setBackCaption("Back to Module Access List");
							ctrLine.setCommandStyle("buttonlink");
							ctrLine.setSaveCaption("Save Module Access");
							ctrLine.setDeleteCaption("Delete Module Access");
							ctrLine.setAddCaption("");

							if (privDelete){
								ctrLine.setConfirmDelCommand(sconDelCom);
								ctrLine.setDeleteCommand(scomDel);
								ctrLine.setEditCommand(scancel);
							}else{ 
								ctrLine.setConfirmDelCaption("");
								ctrLine.setDeleteCaption("");
								ctrLine.setEditCaption("");
							}

							if(privAdd == false  && privUpdate == false){
								ctrLine.setSaveCaption("");
							}

							if (privAdd == false){
								ctrLine.setAddCaption("");
							}
							
							%>
                                                  <%= ctrLine.drawImage(iCommand, iErrCode, msgString)%> 
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2"> </td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                            </table>
                                          </form>
                                        </td>
                                      </tr>
                                      <% } %>
                                    </table>									
                                    <!-- #EndEditable -->
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td>&nbsp; </td>
              </tr>
            </table>
		  </td> 
        </tr>
      </table>
		  </td> 
        </tr>
      </table>
    </td> 
  </tr>
  <tr> 
    <td colspan="2" height="20" > <!-- #BeginEditable "footer" --> 
      <%@ include file = "../main/footer.jsp" %>
      <!-- #EndEditable --> </td>
  </tr>
</table>
</body>
<!-- #BeginEditable "script" --><!-- #EndEditable -->
<!-- #EndTemplate --></html>

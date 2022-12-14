
<%@page import="com.dimata.harisma.session.payroll.TaxCalculator"%>
<% 
/* 
 * Page Name  		:  marital.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		: karya 
 * @version  		: 01 
 */

/*******************************************************************
 * Page Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 			: [output ...] 
 *******************************************************************/
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package harisma -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.form.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_EMPLOYEE, AppObjInfo.OBJ_EMPLOYEE_MARITAL); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
//boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
//boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
//boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long maritalId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("60%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setHeaderStyle("listgentitle");
		ctrlist.addHeader("Marital Status","20%");
		ctrlist.addHeader("Marital Code","20%");
		ctrlist.addHeader("Num Of Children","20%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Marital marital = (Marital)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(maritalId == marital.getOID())
				 index = i;

			rowx.add(marital.getMaritalStatus());

			rowx.add(marital.getMaritalCode());

			rowx.add(String.valueOf(marital.getNumOfChildren()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(marital.getOID()));
		}

		//return ctrlist.drawList(index);

		return ctrlist.draw(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidMarital = FRMQueryString.requestLong(request, "hidden_marital_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlMarital ctrlMarital = new CtrlMarital(request);
ControlLine ctrLine = new ControlLine();
Vector listMarital = new Vector(1,1);

/*switch statement */
iErrCode = ctrlMarital.action(iCommand , oidMarital);
/* end switch*/
FrmMarital frmMarital = ctrlMarital.getForm();

/*count list All Marital*/
int vectSize = PstMarital.getCount(whereClause);

Marital marital = ctrlMarital.getMarital();
msgString =  ctrlMarital.getMessage();

/*
System.out.println("start before      : " + start);

// switch list Marital
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstMarital.findLimitStart(marital.getOID(),recordToGet, whereClause);
System.out.println("start 1      : " + start);
*/

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlMarital.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listMarital = PstMarital.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listMarital.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listMarital = PstMarital.list(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>HARISMA - Master Data Marital Status</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmmarital.hidden_marital_id.value="0";
	document.frmmarital.command.value="<%=Command.ADD%>";
	document.frmmarital.prev_command.value="<%=prevCommand%>";
	document.frmmarital.action="marital.jsp";
	document.frmmarital.submit();
}

function cmdAsk(oidMarital){
	document.frmmarital.hidden_marital_id.value=oidMarital;
	document.frmmarital.command.value="<%=Command.ASK%>";
	document.frmmarital.prev_command.value="<%=prevCommand%>";
	document.frmmarital.action="marital.jsp";
	document.frmmarital.submit();
}

function cmdConfirmDelete(oidMarital){
	document.frmmarital.hidden_marital_id.value=oidMarital;
	document.frmmarital.command.value="<%=Command.DELETE%>";
	document.frmmarital.prev_command.value="<%=prevCommand%>";
	document.frmmarital.action="marital.jsp";
	document.frmmarital.submit();
}
function cmdSave(){
	document.frmmarital.command.value="<%=Command.SAVE%>";
	document.frmmarital.prev_command.value="<%=prevCommand%>";
	document.frmmarital.action="marital.jsp";
	document.frmmarital.submit();
	}

function cmdEdit(oidMarital){
	document.frmmarital.hidden_marital_id.value=oidMarital;
	document.frmmarital.command.value="<%=Command.EDIT%>";
	document.frmmarital.prev_command.value="<%=prevCommand%>";
	document.frmmarital.action="marital.jsp";
	document.frmmarital.submit();
	}

function cmdCancel(oidMarital){
	document.frmmarital.hidden_marital_id.value=oidMarital;
	document.frmmarital.command.value="<%=Command.EDIT%>";
	document.frmmarital.prev_command.value="<%=prevCommand%>";
	document.frmmarital.action="marital.jsp";
	document.frmmarital.submit();
}

function cmdBack(){
	document.frmmarital.command.value="<%=Command.BACK%>";
	document.frmmarital.action="marital.jsp";
	document.frmmarital.submit();
	}

function cmdListFirst(){
	document.frmmarital.command.value="<%=Command.FIRST%>";
	document.frmmarital.prev_command.value="<%=Command.FIRST%>";
	document.frmmarital.action="marital.jsp";
	document.frmmarital.submit();
}

function cmdListPrev(){
	document.frmmarital.command.value="<%=Command.PREV%>";
	document.frmmarital.prev_command.value="<%=Command.PREV%>";
	document.frmmarital.action="marital.jsp";
	document.frmmarital.submit();
	}

function cmdListNext(){
	document.frmmarital.command.value="<%=Command.NEXT%>";
	document.frmmarital.prev_command.value="<%=Command.NEXT%>";
	document.frmmarital.action="marital.jsp";
	document.frmmarital.submit();
}

function cmdListLast(){
	document.frmmarital.command.value="<%=Command.LAST%>";
	document.frmmarital.prev_command.value="<%=Command.LAST%>";
	document.frmmarital.action="marital.jsp";
	document.frmmarital.submit();
}

function fnTrapKD(){
	//alert(event.keyCode);
	switch(event.keyCode) {
		case <%=LIST_PREV%>:
			cmdListPrev();
			break;
		case <%=LIST_NEXT%>:
			cmdListNext();
			break;
		case <%=LIST_FIRST%>:
			cmdListFirst();
			break;
		case <%=LIST_LAST%>:
			cmdListLast();
			break;
		default:
			break;
	}
}

//-------------- script control line -------------------
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

</SCRIPT>
<!-- #EndEditable -->
</head> 

<body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnNewOn.jpg')">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
     <%if(headerStyle && !verTemplate.equalsIgnoreCase("0")){%> 
           <%@include file="../styletemplate/template_header.jsp" %>
            <%}else{%>
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
  <%}%>
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="3" cellpadding="2"> 
        <tr> 
          <td width="100%">
      <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr> 
          <td height="20">
		    <font color="#FF6600" face="Arial"><strong>
			  <!-- #BeginEditable "contenttitle" --> 
                  Master Data &gt; Marital<!-- #EndEditable --> 
            </strong></font>
	      </td>
        </tr>
        <tr> 
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td  style="background-color:<%=bgColorContent%>; "> 
                  <table width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                    <tr> 
                      <td valign="top"> 
                        <table style="border:1px solid <%=garisContent%>" width="100%" border="0" cellspacing="1" cellpadding="1" class="tabbg">
                          <tr> 
                            <td valign="top">
		    				  <!-- #BeginEditable "content" --> 
                                    <form name="frmmarital" method ="post" action="">
                                      <input type="hidden" name="command" value="<%=iCommand%>">
                                      <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                      <input type="hidden" name="start" value="<%=start%>">
                                      <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                      <input type="hidden" name="hidden_marital_id" value="<%=oidMarital%>">
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8"  colspan="3"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              
                                              <%
							try{
								if (listMarital != null && listMarital.size()>0){
							%>				<tr align="left" valign="top"> 
                                                <td height="14" valign="middle" colspan="3" class="listtitle">&nbsp;Marital 
                                                  List </td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3"> 
                                                  <%= drawList(listMarital,oidMarital)%> 
                                                </td>
                                              </tr>
                                              <%  }else{ %>
											 <tr align="left" valign="top"> 
                                                <td height="14" valign="middle" colspan="3" class="listtitle">&nbsp;</td>
                                              </tr>
											  <tr align="left" valign="top"> 
                                                <td height="14" valign="middle" colspan="3" class="comment">No Marital 
                                                  available </td>
                                              </tr>
											 <% } 
						  }catch(Exception exc){ 
						  }%>
                                              <tr align="left" valign="top"> 
                                                <td height="8" align="left" colspan="3" class="command"> 
                                                  <span class="command"> 
                                                  <% 
								   int cmd = 0;
									   if ((iCommand == Command.FIRST || iCommand == Command.PREV )|| 
										(iCommand == Command.NEXT || iCommand == Command.LAST))
											cmd =iCommand; 
								   else{
									  if(iCommand == Command.NONE || prevCommand == Command.NONE)
										cmd = Command.FIRST;
									  else 
									  	cmd =prevCommand; 
								   } 
							    %>
                                                  <% ctrLine.setLocationImg(approot+"/images");
							   	ctrLine.initDefault();
								 %>
                                                  <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> 
                                                  </span> </td>
                                              </tr>
											  <%//if((iCommand == Command.NONE || iCommand == Command.DELETE || iCommand ==Command.BACK || iCommand ==Command.SAVE)&& (frmMarital.errorSize()<1)){
                                              if((iCommand != Command.ADD && iCommand != Command.ASK && iCommand != Command.EDIT)&& (frmMarital.errorSize()<1)){

												if(privAdd){%>
                                              <tr align="left" valign="top"> 
											  	<td> 
                                                  <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr> 
                                                      <td>&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="4"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                      <td width="24"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/BtnNewOn.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Add new data"></a></td>
                                                      <td width="6"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                      <td height="22" valign="middle" colspan="3" width="951"> 
                                                        <a href="javascript:cmdAdd()" class="command">Add 
                                                        New Marital</a> </td>
                                                    </tr>
                                                  </table>
												</td>
                                              </tr>
											  <%}
											  }%>
                                            </table>
                                          </td>
                                        </tr>
										<tr>
											<td>&nbsp;
											</td>
										</tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                            <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(frmMarital.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
											<table border="0" cellspacing="2" cellpadding="2" width="100%">
											  <tr>
                                                <td class="listtitle">Marital 
                                                  Editor</td>
											  </tr>
                                              <tr> 
											    <td height="100%"> 
                                                  <table border="0" cellspacing="2" cellpadding="2" width="50%">
                                                    <tr align="left" valign="top"> 
                                                      <td valign="top" width="26%">&nbsp;</td>
                                                      <td width="74%" class="comment" >*) 
                                                        entry required </td>
                                                      <td>&nbsp;</td>
                                                    </tr>
                                                    <tr align="left" valign="top"> 
                                                      <td valign="top" width="26%"> 
                                                        Marital Status </td>
                                                      <td width="74%"> 
                                                        <input type="text" name="<%=frmMarital.fieldNames[FrmMarital.FRM_FIELD_MARITAL_STATUS] %>"  value="<%= marital.getMaritalStatus() %>" class="elemenForm">
                                                        * <%=frmMarital.getErrorMsg(FrmMarital.FRM_FIELD_MARITAL_STATUS)%></td>
                                                      <td>
                                                          
                                                          <% 
                                                          Vector status_emp_str = new Vector();
                                                          Vector status_emp_idx = new Vector();
                                                          Vector status_emp_code = new Vector();
                                                          %>
                                                          <select class="formElemen" name="<%=frmMarital.fieldNames[FrmMarital.FRM_FIELD_MARITAL_STATUS_TAX]%>">
                                                          <%
                                                          for (int i = 0; i < TaxCalculator.STATUS_EMPLOYEE.length; i++) {
                                                              String selected="";
                                                              status_emp_str.add(String.valueOf(TaxCalculator.STATUS_EMPLOYEE_IDX[i]));
                                                              status_emp_idx.add(TaxCalculator.STATUS_EMPLOYEE_LANG[SESS_LANGUAGE][i]);
                                                              status_emp_code.add(TaxCalculator.STATUS_EMPLOYEE_CODE[i]);
                                                              if(marital.getMaritalStatusTax() == TaxCalculator.STATUS_EMPLOYEE_IDX[i]){
                                                                  selected = "selected";
                                                              }
                                                              %>
                                                             
                                                                 <option  <%=selected%> title="<%=TaxCalculator.STATUS_EMPLOYEE_CODE[i]%>" value="<%=TaxCalculator.STATUS_EMPLOYEE_IDX[i]%>"><%=TaxCalculator.STATUS_EMPLOYEE_LANG[SESS_LANGUAGE][i]%></option>       
                                                             
                                                              
                                                              <%
                                                          }
                                                                
                                                        %> 
                                                         </select>
                                                      </td>
                                                    </tr>
                                                    <tr align="left" valign="top"> 
                                                      <td valign="top" width="26%"> 
                                                        Marital Code</td>
                                                      <td width="74%"> 
                                                        <input type="text" name="<%=frmMarital.fieldNames[FrmMarital.FRM_FIELD_MARITAL_CODE] %>"  value="<%= marital.getMaritalCode() %>" class="elemenForm">
                                                        * <%=frmMarital.getErrorMsg(FrmMarital.FRM_FIELD_MARITAL_CODE)%></td>
                                                      <td>&nbsp;</td>
                                                    </tr>
                                                    <tr align="left" valign="top"> 
                                                      <td valign="top" width="26%"> 
                                                        Number Of Children</td>
                                                      <td width="74%"> 
                                                        <input type="text" name="<%=frmMarital.fieldNames[FrmMarital.FRM_FIELD_NUM_OF_CHILDREN] %>"  value="<%= marital.getNumOfChildren() %>" class="elemenForm" size="10">
														<%=frmMarital.getErrorMsg(FrmMarital.FRM_FIELD_NUM_OF_CHILDREN)%>
                                                      </td>
                                                      <td>&nbsp;</td>
                                                    </tr>
                                                  </table>
												</td>
											  </tr>
                                              <tr align="left" valign="top" > 
                                                <td class="command"> 
                                                  <%
									ctrLine.setLocationImg(approot+"/images");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidMarital+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidMarital+"')";
									String scancel = "javascript:cmdEdit('"+oidMarital+"')";
									ctrLine.setBackCaption("Back to List Marital");
									ctrLine.setCommandStyle("buttonlink");
									ctrLine.setAddCaption("Add Marital");
									ctrLine.setSaveCaption("Save Marital");
									ctrLine.setDeleteCaption("Delete Marital");
									ctrLine.setConfirmDelCaption("Delete Marital");

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
									
									if(iCommand == Command.ASK)
										ctrLine.setDeleteQuestion(msgString); 
									%>
                                                  <%= ctrLine.drawImage(iCommand, iErrCode, msgString)%> 
                                                </td>
                                              </tr>
                                            </table>
                                            <%}%>
                                          </td>
                                        </tr>
                                      </table>
                                    </form>
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
   <%if(headerStyle && !verTemplate.equalsIgnoreCase("0")){%>
            <tr>
                            <td valign="bottom">
                               <!-- untuk footer -->
                                <%@include file="../footer.jsp" %>
                            </td>
                            
            </tr>
            <%}else{%>
            <tr> 
                <td colspan="2" height="20" > <!-- #BeginEditable "footer" --> 
      <%@ include file = "../main/footer.jsp" %>
                <!-- #EndEditable --> </td>
            </tr>
            <%}%>
</table>
</body>
<!-- #BeginEditable "script" -->
<script language="JavaScript">
	//var oBody = document.body;
	//var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);
</script>
<!-- #EndEditable -->
<!-- #EndTemplate --></html>

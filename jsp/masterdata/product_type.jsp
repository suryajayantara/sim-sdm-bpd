<%-- 
    Document   : product_type
    Created on : Jul 27, 2022, 2:02:11 PM
    Author     : User
--%>

<%@page import="com.dimata.harisma.entity.project.PstProductType"%>
<%@page import="com.dimata.harisma.form.project.CtrlProductType"%>
<%@page import="com.dimata.harisma.entity.project.ProductType"%>
<%@page import="com.dimata.harisma.form.project.FrmProductType"%>
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
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_EMPLOYEE, AppObjInfo.OBJ_EMPLOYEE_RELIGION); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
//boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
//boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
//boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(int iCommand,FrmProductType frmObject, ProductType objEntity, Vector objectClass,  long productTypeId)

	{
		ControlList ctrlist = new ControlList(); 
		ctrlist.setAreaWidth("20%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setHeaderStyle("listgentitle");
		ctrlist.addHeader("Tipe Produk","100%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			 ProductType productType = (ProductType)objectClass.get(i);
			 rowx = new Vector();
			 if(productTypeId == productType.getOID())
				 index = i; 

			 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmProductType.FRM_FIELD_PRODUCT_TYPE_NAME] +"\" value=\""+productType.getProductTypeName()+"\" class=\"formElemen\" size=\"30\">" );
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(productType.getOID())+"')\">"+productType.getProductTypeName()+"</a>");
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmProductType.FRM_FIELD_PRODUCT_TYPE_NAME] +"\" value=\""+objEntity.getProductTypeName()+"\" class=\"formElemen\" size=\"30\">");

		}

		lstData.add(rowx);

		return ctrlist.draw();
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidProducttype = FRMQueryString.requestLong(request, "hidden_product_type_id");

/*variable declaration*/
int recordToGet = 5;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlProductType ctrlProducttype = new CtrlProductType(request);
ControlLine ctrLine = new ControlLine();
Vector listProductType = new Vector(1,1);

/*switch statement */
iErrCode = ctrlProducttype.action(iCommand , oidProducttype);
/* end switch*/
FrmProductType frmProducttype = ctrlProducttype.getForm();

/*count list All Religion*/
int vectSize = PstProductType.getCount(whereClause);

/*switch list Religion*/
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlProducttype.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

ProductType productType = ctrlProducttype.getProducttype();
msgString =  ctrlProducttype.getMessage();

/* get record to display */
listProductType = PstProductType.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listProductType.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listProductType = PstProductType.list(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>HARISMA - Master Data Product Type</title>
<script language="JavaScript">
<!--



function cmdAdd(){
	document.frmProducttype.hidden_product_type_id.value="0";
	document.frmProducttype.command.value="<%=Command.ADD%>";
	document.frmProducttype.prev_command.value="<%=prevCommand%>";
	document.frmProducttype.action="product_type.jsp";
	document.frmProducttype.submit();
}

function cmdAsk(oidProducttype){
	document.frmProducttype.hidden_product_type_id.value=oidProducttype;
	document.frmProducttype.command.value="<%=Command.ASK%>";
	document.frmProducttype.prev_command.value="<%=prevCommand%>";
	document.frmProducttype.action="product_type.jsp";
	document.frmProducttype.submit();
}

function cmdConfirmDelete(oidProducttype){
	document.frmProducttype.hidden_product_type_id.value=oidProducttype;
	document.frmProducttype.command.value="<%=Command.DELETE%>";
	document.frmProducttype.prev_command.value="<%=prevCommand%>";
	document.frmProducttype.action="product_type.jsp";
	document.frmProducttype.submit();
}

function cmdSave(){
	document.frmProducttype.command.value="<%=Command.SAVE%>";
	document.frmProducttype.prev_command.value="<%=prevCommand%>";
	document.frmProducttype.action="product_type.jsp";
	document.frmProducttype.submit();
}

function cmdEdit(oidProducttype){
	document.frmProducttype.hidden_product_type_id.value=oidProducttype;
	document.frmProducttype.command.value="<%=Command.EDIT%>";
	document.frmProducttype.prev_command.value="<%=prevCommand%>";
	document.frmProducttype.action="product_type.jsp";
	document.frmProducttype.submit();
}

function cmdCancel(oidProducttype){
	document.frmProducttype.hidden_product_type_id.value=oidProducttype;
	document.frmProducttype.command.value="<%=Command.EDIT%>";
	document.frmProducttype.prev_command.value="<%=prevCommand%>";
	document.frmProducttype.action="product_type.jsp";
	document.frmProducttype.submit();
}

function cmdBack(){
	document.frmProducttype.command.value="<%=Command.BACK%>";
	document.frmProducttype.action="product_type.jsp";
	document.frmProducttype.submit();
}

function cmdListFirst(){
	document.frmProducttype.command.value="<%=Command.FIRST%>";
	document.frmProducttype.prev_command.value="<%=Command.FIRST%>";
	document.frmProducttype.action="product_type.jsp";
	document.frmProducttype.submit();
}

function cmdListPrev(){
	document.frmProducttype.command.value="<%=Command.PREV%>";
	document.frmProducttype.prev_command.value="<%=Command.PREV%>";
	document.frmProducttype.action="product_type.jsp";
	document.frmProducttype.submit();
}

function cmdListNext(){
	document.frmProducttype.command.value="<%=Command.NEXT%>";
	document.frmProducttype.prev_command.value="<%=Command.NEXT%>";
	document.frmProducttype.action="product_type.jsp";
	document.frmProducttype.submit();
}

function cmdListLast(){
	document.frmProducttype.command.value="<%=Command.LAST%>";
	document.frmProducttype.prev_command.value="<%=Command.LAST%>";
	document.frmProducttype.action="product_type.jsp";
	document.frmProducttype.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidProducttype){
	document.frmimage.hidden_product_type_id.value=oidProducttype;
	document.frmimage.command.value="<%=Command.POST%>";
	document.frmimage.action="product_type.jsp";
	document.frmimage.submit();
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
//-->
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
                  Master Data > Tipe Produk<!-- #EndEditable --> 
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
                                    <form name="frmProducttype" method ="post" action="">
                                      <input type="hidden" name="command" value="<%=iCommand%>">
                                      <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                      <input type="hidden" name="start" value="<%=start%>">
                                      <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                      <input type="hidden" name="hidden_product_type_id" value="<%=oidProducttype%>">
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8"  colspan="3"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr align="left" valign="top"> 
                                                <td height="8" valign="middle" colspan="3">&nbsp; 
                                                </td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="14" valign="middle" colspan="3" class="listtitle">&nbsp;
                                                  List Tipe Produk </td>
                                              </tr>
                                              <%
							try{
							if((listProductType == null || listProductType.size()<1)&&(iCommand == Command.NONE))
									iCommand = Command.ADD;  
							%>
                                              <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3"> 
                                                  <%= drawList(iCommand,frmProducttype, productType,listProductType,oidProducttype)%> 
                                                </td>
                                              </tr>
                                              <% 
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
											 
						<%//if((iCommand == Command.NONE || iCommand== Command.BACK)&& (privAdd)){
						 if((iCommand != Command.ADD && iCommand != Command.ASK && iCommand != Command.EDIT)&& (frmProducttype.errorSize()<1)){
						if(privAdd){%>
                                              <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3">
                                                  <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr> 
                                                      <td>&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="4"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                      <td width="24"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/BtnNewOn.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Add new data"></a></td>
                                                      <td width="6"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                      <td height="22" valign="middle" colspan="3" width="951"><a href="javascript:cmdAdd()" class="command"> 
                                                        Tambah Tipe Produk</a></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
						<%}}%>
                                            </table> 
                                          </td>
                                        </tr>
					<%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(frmProducttype.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" width="17%">&nbsp;</td>
                                          <td height="8" colspan="2" width="83%">&nbsp; 
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top" > 
                                          <td colspan="3" class="command"> 
                                            <%
									ctrLine.setLocationImg(approot+"/images");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidProducttype+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidProducttype+"')";
									String scancel = "javascript:cmdEdit('"+oidProducttype+"')";
									ctrLine.setBackCaption("Cancel");
									ctrLine.setCommandStyle("buttonlink");
									ctrLine.setAddCaption("Add Product type");
									ctrLine.setSaveCaption("Save Product type");
									ctrLine.setDeleteCaption("Delete Product type");
									ctrLine.setConfirmDelCaption("Yes Delete Product type");
									
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
										<%}%>
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

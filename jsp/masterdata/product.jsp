<%-- 
    Document   : product
    Created on : Jul 21, 2022, 10:08:21 AM
    Author     : User
--%>




<%@page import="com.dimata.harisma.form.project.FrmMasterProduct"%>
<%@page import="com.dimata.harisma.entity.project.MasterProduct"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="com.dimata.harisma.form.project.FrmProduct"%>
<%@page import="com.dimata.harisma.form.project.CtrlProduct"%>
<%@page import="com.dimata.harisma.entity.project.PstProduct"%>
<%@page import="com.dimata.harisma.entity.project.Product"%>
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
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_EMPLOYEE, AppObjInfo.OBJ_EMPLOYEE_EDUCATION); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
//boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
//boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
//boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
//out.println("appObjCode = " + appObjCode + " | add : " + privAdd + " | update : " + privUpdate + " | delete : " + privDelete);
%>
<!-- Jsp Block -->
<%!

            public String drawList(Vector objectClass ,  long Id, I_Dictionary dictionaryD)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("50%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setHeaderStyle("listgentitle");
		ctrlist.addHeader(dictionaryD.getWord("PRODUCT_NAME"),"10%");                
                ctrlist.addHeader(dictionaryD.getWord("PRODUCT_TYPE"), "10%");
		ctrlist.addHeader(dictionaryD.getWord("DESCRIPTION"), "10%");
		
		

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Product product = (Product)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(Id == product.getOID())
				 index = i;

			rowx.add(product.getProductName());
                        rowx.add(product.getProductType());
             
			rowx.add(product.getDescription());
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(product.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidProduct = FRMQueryString.requestLong(request, "hidden_product_id");

    /*variable declaration*/
    int recordToGet = 5;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = ""+PstProduct.fieldNames[PstProduct.FLD_PRODUCT_ID]+" ASC ";

    CtrlProduct ctrlProduct = new CtrlProduct(request);
    ControlLine ctrLine = new ControlLine();
    Vector listProduct = new Vector(1,1);

    /*switch statement */
    iErrCode = ctrlProduct.action(iCommand , oidProduct);
    /* end switch*/
    FrmProduct frmProduct = ctrlProduct.getForm();

    /*count list All Education*/
    int vectSize = PstProduct.getCount(whereClause);

    Product product = ctrlProduct.getProduct();
    msgString =  ctrlProduct.getMessage();

    /*switch list Education*/
	/*
    if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)&& (oidEducation == 0))
            start = PstEducation.findLimitStart(education.getOID(),recordToGet, whereClause, orderClause);
	*/		

    if((iCommand == Command.FIRST || iCommand == Command.PREV )||
      (iCommand == Command.NEXT || iCommand == Command.LAST)){
                    start = ctrlProduct.actionList(iCommand, start, vectSize, recordToGet);
     } 
    /* end switch list*/

    /* get record to display */
    listProduct = PstProduct.listWithJoinMasterProductAndContactList(start,recordToGet, whereClause , orderClause);

    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listProduct.size() < 1 && start > 0)
    {
        if (vectSize - recordToGet > recordToGet)
            start = start - recordToGet;   //go to Command.PREV
        else {
            start = 0 ;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; //go to Command.FIRST
        }
        listProduct = PstProduct.listWithJoinMasterProductAndContactList(start,recordToGet, whereClause , orderClause);
    }
    
    I_Dictionary dictionaryD = userSession.getUserDictionary();
    dictionaryD.loadWord();
%>
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>HARISMA - Master Data Poduct</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmproduct.hidden_product_id.value="0";
	document.frmproduct.command.value="<%=Command.ADD%>";
	document.frmproduct.prev_command.value="<%=prevCommand%>";
	document.frmproduct.action="product.jsp";
	document.frmproduct.submit();
}

function cmdAsk(oidProduct){
	document.frmproduct.hidden_product_id.value=oidProduct;
	document.frmproduct.command.value="<%=Command.ASK%>";
	document.frmproduct.prev_command.value="<%=prevCommand%>";
	document.frmproduct.action="product.jsp";
	document.frmproduct.submit();
}

function cmdConfirmDelete(oidProduct){
	document.frmproduct.hidden_product_id.value=oidProduct;
	document.frmproduct.command.value="<%=Command.DELETE%>";
	document.frmproduct.prev_command.value="<%=prevCommand%>";
	document.frmproduct.action="product.jsp";
	document.frmproduct.submit();
}
function cmdSave(){
	document.frmproduct.command.value="<%=Command.SAVE%>";
	document.frmproduct.prev_command.value="<%=prevCommand%>";
	document.frmproduct.action="product.jsp";
	document.frmproduct.submit();
	}

function cmdEdit(oidProduct){
	document.frmproduct.hidden_product_id.value=oidProduct;
	document.frmproduct.command.value="<%=Command.EDIT%>";
	document.frmproduct.prev_command.value="<%=prevCommand%>";
	document.frmproduct.action="product.jsp";
	document.frmproduct.submit();
	}

function cmdCancel(oidProduct){
	document.frmproduct.hidden_product_id.value=oidProduct;
	document.frmproduct.command.value="<%=Command.EDIT%>";
	document.frmproduct.prev_command.value="<%=prevCommand%>";
	document.frmproduct.action="product.jsp";
	document.frmproduct.submit();
}

function cmdBack(){
	document.frmproduct.command.value="<%=Command.BACK%>";
	document.frmproduct.action="product.jsp";
	document.frmproduct.submit();
	}

function cmdListFirst(){
	document.frmproduct.command.value="<%=Command.FIRST%>";
	document.frmproduct.prev_command.value="<%=Command.FIRST%>";
	document.frmproduct.action="product.jsp";
	document.frmproduct.submit();
}

function cmdListPrev(){
	document.frmproduct.command.value="<%=Command.PREV%>";
	document.frmproduct.prev_command.value="<%=Command.PREV%>";
	document.frmproduct.action="product.jsp";
	document.frmproduct.submit();
	}

function cmdListNext(){
	document.frmproduct.command.value="<%=Command.NEXT%>";
	document.frmproduct.prev_command.value="<%=Command.NEXT%>";
	document.frmproduct.action="product.jsp";
	document.frmproduct.submit();
}

function cmdListLast(){
	document.frmproduct.command.value="<%=Command.LAST%>";
	document.frmproduct.prev_command.value="<%=Command.LAST%>";
	document.frmproduct.action="product.jsp";
	document.frmproduct.submit();
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
<!-- #EndEditable --> <!-- #BeginEditable "stylestab" --> 
<link rel="stylesheet" href="../styles/tab.css" type="text/css">
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
<SCRIPT language=JavaScript>
    function hideObjectForEmployee(){
        //document.frmsrcemployee.<%//=frmSrcEmployee.fieldNames[FrmSrcEmployee.FRM_FIELD_START_COMMENC] + "_mn"%>.style.visibility = 'hidden';
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
        //document.all.<%//=frmSrcEmployee.fieldNames[FrmSrcEmployee.FRM_FIELD_START_COMMENC] + "_mn"%>.style.visibility = "";
    }
</SCRIPT>
<!-- #EndEditable --> 
</head>
<body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
     <%if(headerStyle && !verTemplate.equalsIgnoreCase("0")){%> 
           <%@include file="../styletemplate/template_header.jsp" %>
            <%}else{%>
  <tr> 
    <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
      <!-- #BeginEditable "header" --> 
      <%@ include file = "../main/header.jsp" %>
      <!-- #EndEditable --> </td>
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
                <td height="20"> <font color="#FF6600" face="Arial"><strong> <!-- #BeginEditable "contenttitle" --> 
                  Master Data &gt; Produk &gt; Kelola Produk <!-- #EndEditable --> 
                  </strong></font> </td>
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
                                  <td valign="top"> <!-- #BeginEditable "content" --> 
                                    <form name="frmproduct" method ="post" action="">
                                      <input type="hidden" name="command" value="<%=iCommand%>">
                                      <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                      <input type="hidden" name="start" value="<%=start%>">
                                      <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                      <input type="hidden" name="hidden_product_id" value="<%=oidProduct%>">
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8"  colspan="3"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr align="left" valign="top"> 
                                                <td height="14" valign="middle" colspan="3" class="comment">&nbsp; <%=dictionaryD.getWord("PRODUCT")+" "+dictionaryD.getWord("LIST")%>
                                                   </td>
                                              </tr>
                                              <%
							try{
								if (listProduct.size()>0){
							%>
                                              <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3"> 
                                                  <%= drawList(listProduct,oidProduct,dictionaryD)%> 
                                                </td>
                                              </tr>
                                              <%  } 
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
									  { 
									  	if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE) && (oidProduct == 0))
									  		cmd = PstProduct.findLimitCommand(start,recordToGet,vectSize);
									  	else
									  		cmd = prevCommand;
									  } 
								   } 
							    %>
                                                  <% ctrLine.setLocationImg(approot+"/images");
							   	ctrLine.initDefault();
								 %>
                                                  <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> 
                                                  </span> </td>
                                              </tr>
											  <%//if((iCommand == Command.NONE || iCommand == Command.DELETE || iCommand ==Command.BACK || iCommand ==Command.SAVE)&& (frmEmpCategory.errorSize()<1)){
                                               if((iCommand != Command.ADD && iCommand != Command.ASK && iCommand != Command.EDIT)&& (frmProduct.errorSize()<1)){
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
                                                      <td height="22" valign="middle" colspan="3" width="951"><a href="javascript:cmdAdd()" class="command">
                                                              <%=dictionaryD.getWord(I_Dictionary.ADD_NEW_PRODUCT)%>
                                                          </a> </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
											  <%}
											  }%>
                                           </table>
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                            <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(frmProduct.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                              <tr> 
                                                <td colspan="3" class="listtitle"><%=oidProduct==0?"Add":"Edit"%> 
                                                  Product</td>
                                              </tr>
                                              <tr>
                                                <td colspan="3" class="listtitle">&nbsp;</td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="21" valign="middle" width="1%">&nbsp;</td>
                                                <td height="21" valign="middle" width="7%">&nbsp;</td>
                                                <td height="21" colspan="2" width="92%" class="comment">*)= 
                                                  required</td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="21" valign="top" width="1%">&nbsp;</td>
                                                <td height="21" valign="top" width="7%"><%=dictionaryD.getWord("PRODUCT_NAME")%></td>
                                                <td height="21" colspan="2" width="92%"> 
                                                  <select name="<%=frmProduct.fieldNames[frmProduct.FRM_FIELD_PRODUCT_ID]%>">
                                                      <option value="">=Select=</option>
                                                    <%
                                                        Vector listMasterProduct = new Vector();
                                                        try{
                                                            listMasterProduct = PstProduct.listMasterProduct(0, 0, "", "");
                                                        }catch (Exception e){
                                                            System.out.println("Err List Product : "+e);
                                                        }
                                                        if(listMasterProduct.size()>0){
                                                            for(int xy=0; xy < listMasterProduct.size();xy++){
                                                                MasterProduct objMasterProduct = (MasterProduct) listMasterProduct.get(xy);
                                                    %>
                                                  
                                                    <option 
                                                           value="<%=objMasterProduct.getOID()%>"><%=objMasterProduct.getProductName()%>-<%=objMasterProduct.getProductType()%>
                                                           
                                                    </option>
                           
                                                        
                                                        
                                                            
                                                        
                                                        <%
                                                            }
                                                        }
                                                        %>
                                                </select>
                                                <%= frmProduct.getErrorMsg(FrmProduct.FRM_FIELD_PRODUCT_ID) %>
                                                </td>
                                              </tr>
                                              
                                              
                                              <tr class="form-group">
                                                  <td height="21" valign="top" width="1%">&nbsp;</td>
                                                <td height="21" valign="top" width="7%">Nama Pelanggan</td>
                                                <td height="21" colspan="2" width="92%"> 
                         
                                                <select name="<%=frmProduct.fieldNames[frmProduct.FRM_FIELD_CONTACT_ID]%>">
                                                    <option value="">=Select=</option>
                                                    <%
                                                        Vector listContactList = new Vector();
                                                        try{
                                                            listContactList = PstProduct.listContactList(0, 0, "", "");
                                                        }catch (Exception e){
                                                            System.out.println("Err List Product : "+e);
                                                        }
                                                        if(listProduct.size()>0){
                                                            for(int xy=0; xy < listContactList.size();xy++){
                                                                ContactList objContactList = (ContactList) listContactList.get(xy);
                                                    %>
                                                        <option 
                                                            value="<%=objContactList.getOID()%>"><%=objContactList.getPersonName()%>
                                                        </option>
                                                            
                                                        
                                                        <%
                                                            }
                                                        }
                                                        %>
                                                </select>
                                                <%= frmProduct.getErrorMsg(FrmProduct.FRM_FIELD_CONTACT_ID) %>
                                                </td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="21" valign="top" width="1%">&nbsp;</td>
                                                <td height="21" valign="top" width="7%"><%=dictionaryD.getWord("DESCRIPTION")%></td>
                                                <td height="21" colspan="2" width="92%"> 
                                                    <textarea type="text" name="<%=frmProduct.fieldNames[FrmProduct.FRM_FIELD_DESCRIPTION] %>"  ><%= product.getDescription() %></textarea>
                                                  * <%= frmProduct.getErrorMsg(FrmProduct.FRM_FIELD_DESCRIPTION) %>
                                                  </td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="8" valign="middle" width="1%">&nbsp;</td>
                                                <td height="8" valign="middle" width="7%">&nbsp;</td>
                                                <td height="8" colspan="2" width="92%">&nbsp; 
                                                </td>
                                              </tr>
                                              <tr align="left" valign="top" > 
                                                <td colspan="4" class="command"> 
                                                  <%
									ctrLine.setLocationImg(approot+"/images");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80");
									String scomDel = "javascript:cmdAsk('"+oidProduct+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidProduct+"')";
									String scancel = "javascript:cmdEdit('"+oidProduct+"')";
									ctrLine.setBackCaption("" +dictionaryD.getWord(I_Dictionary.BACK_TO_LIST));
									ctrLine.setCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("" +dictionaryD.getWord(I_Dictionary.DELETE));
										ctrLine.setSaveCaption("" +dictionaryD.getWord(I_Dictionary.SAVE));
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
                                            if(iCommand == Command.ASK)
                                                    ctrLine.setDeleteQuestion(msgString); 
									%>
                                                  <%= ctrLine.drawImage(iCommand, iErrCode, msgString)%> 
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="1%">&nbsp;</td>
                                                <td width="7%">&nbsp;</td>
                                                <td width="92%">&nbsp;</td>
                                              </tr>
                                              <tr align="left" valign="top" > 
                                                <td colspan="4"> 
                                                  <div align="left"></div>
                                                </td>
                                              </tr>
                                            </table>
                                            <%}%>
                                          </td>
                                        </tr>
                                      </table>
                                    </form>
                                    <!-- #EndEditable --> </td>
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
<!-- #EndEditable --> <!-- #EndTemplate -->
</html>

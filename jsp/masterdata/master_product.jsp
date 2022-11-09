
<%@page import="com.dimata.harisma.entity.project.ProductType"%>
<%@page import="com.dimata.harisma.form.project.FrmMasterProduct"%>
<%@page import="com.dimata.harisma.form.project.CtrlMasterProduct"%>
<%@page import="com.dimata.harisma.entity.project.PstMasterProduct"%>
<%@page import="com.dimata.harisma.entity.project.MasterProduct"%>
<% 
/* 
 * Page Name  		:  education.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
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

	public String drawList(Vector objectClass ,  long productId, I_Dictionary dictionaryD)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("70%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setHeaderStyle("listgentitle");
		ctrlist.addHeader(dictionaryD.getWord("PRODUCT_NAME"),"10%");                
                ctrlist.addHeader(dictionaryD.getWord("PRODUCT_TYPE"), "10%");
		ctrlist.addHeader(dictionaryD.getWord("DESCRIPTION"),"10%");
                


		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			MasterProduct masterProduct = (MasterProduct)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(productId == masterProduct.getOID())
				 index = i;

			rowx.add(masterProduct.getProductName());
                        rowx.add(masterProduct.getProductTypeName());
			rowx.add(masterProduct.getProductDesc());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(masterProduct.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidMasterproduct = FRMQueryString.requestLong(request, "hidden_product_id");
    


    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String seachValue = FRMQueryString.requestString(request, "srcValue");
    String listValue = FRMQueryString.requestString(request, "listValue");
    String whereClause = " "+PstMasterProduct.fieldNames[PstMasterProduct.FLD_PRODUCT_NAME]+ " LIKE '%"+seachValue+"%' ";
    String orderClause = ""+PstMasterProduct.fieldNames[PstMasterProduct.FLD_PRODUCT_NAME]+" ASC ";
    String oderBy = " "+PstMasterProduct.fieldNames[PstMasterProduct.FLD_PRODUCT_NAME]+ " ASC ";

    CtrlMasterProduct ctrlMasterproduct = new CtrlMasterProduct(request);
    ControlLine ctrLine = new ControlLine();
    Vector listMasterProduct = new Vector(1,1);

    /*switch statement */
    iErrCode = ctrlMasterproduct.action(iCommand , oidMasterproduct);
    /* end switch*/
    FrmMasterProduct frmMasterproduct = ctrlMasterproduct.getForm();

    /*count list All Education*/
    int vectSize = PstMasterProduct.getCount(whereClause);

    MasterProduct masterProduct = ctrlMasterproduct.getMasterproduct();
    msgString =  ctrlMasterproduct.getMessage();

    /*switch list Education*/
	/*
    if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)&& (oidEducation == 0))
            start = PstEducation.findLimitStart(education.getOID(),recordToGet, whereClause, orderClause);
    	*/		
     try{   
    if(iCommand == Command.LIST){
             listMasterProduct = PstMasterProduct.listWithJoinProductType(0, 0, whereClause, oderBy);
        }else{
            listMasterProduct = PstMasterProduct.listWithJoinProductType(0, 0, "", oderBy);
        } 
    } catch (Exception exc) {
        System.out.println("Error: "+exc);
    }
        
    if((iCommand == Command.FIRST || iCommand == Command.PREV )||
      (iCommand == Command.NEXT || iCommand == Command.LAST)){
                    start = ctrlMasterproduct.actionList(iCommand, start, vectSize, recordToGet);
     } 
    /* end switch list*/

    /* get record to display */
    listMasterProduct = PstMasterProduct.listWithJoinProductType(start,recordToGet, whereClause , orderClause);

    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listMasterProduct.size() < 1 && start > 0)
    {
        if (vectSize - recordToGet > recordToGet)
            start = start - recordToGet;   //go to Command.PREV
        else {
            start = 0 ;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; //go to Command.FIRST
        }
        listMasterProduct = PstMasterProduct.listWithJoinProductType(start,recordToGet, whereClause , orderClause);
    }
    
    I_Dictionary dictionaryD = userSession.getUserDictionary();
    dictionaryD.loadWord();
%>
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>HARISMA - Master Data Product</title>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.js"></script>
	<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css" rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>
<script language="JavaScript">
                                   

function cmdAdd(){
	document.frmMasterproduct.hidden_product_id.value="0";
	document.frmMasterproduct.command.value="<%=Command.ADD%>";
	document.frmMasterproduct.prev_command.value="<%=prevCommand%>";
	document.frmMasterproduct.action="master_product.jsp";
	document.frmMasterproduct.submit();
}

function cmdAsk(oidEducation){
	document.frmMasterproduct.hidden_product_id.value=oidEducation;
	document.frmMasterproduct.command.value="<%=Command.ASK%>";
	document.frmMasterproduct.prev_command.value="<%=prevCommand%>";
	document.frmMasterproduct.action="master_product.jsp";
	document.frmMasterproduct.submit();
}

function cmdConfirmDelete(oidEducation){
	document.frmMasterproduct.hidden_product_id.value=oidEducation;
	document.frmMasterproduct.command.value="<%=Command.DELETE%>";
	document.frmMasterproduct.prev_command.value="<%=prevCommand%>";
	document.frmMasterproduct.action="master_product.jsp";
	document.frmMasterproduct.submit();
}
function cmdSave(){
	document.frmMasterproduct.command.value="<%=Command.SAVE%>";
	document.frmMasterproduct.prev_command.value="<%=prevCommand%>";
	document.frmMasterproduct.action="master_product.jsp";
	document.frmMasterproduct.submit();
	}

function cmdEdit(oidEducation){
	document.frmMasterproduct.hidden_product_id.value=oidEducation;
	document.frmMasterproduct.command.value="<%=Command.EDIT%>";
	document.frmMasterproduct.prev_command.value="<%=prevCommand%>";
	document.frmMasterproduct.action="master_product.jsp";
	document.frmMasterproduct.submit();
	}

function cmdCancel(oidEducation){
	document.frmMasterproduct.hidden_product_id.value=oidEducation;
	document.frmMasterproduct.command.value="<%=Command.EDIT%>";
	document.frmMasterproduct.prev_command.value="<%=prevCommand%>";
	document.frmMasterproduct.action="master_product.jsp";
	document.frmMasterproduct.submit();
}

function cmdBack(){
	document.frmMasterproduct.command.value="<%=Command.BACK%>";
	document.frmMasterproduct.action="master_product.jsp";
	document.frmMasterproduct.submit();
	}

function cmdListFirst(){
	document.frmMasterproduct.command.value="<%=Command.FIRST%>";
	document.frmMasterproduct.prev_command.value="<%=Command.FIRST%>";
	document.frmMasterproduct.action="master_product.jsp";
	document.frmMasterproduct.submit();
}

function cmdListPrev(){
	document.frmMasterproduct.command.value="<%=Command.PREV%>";
	document.frmMasterproduct.prev_command.value="<%=Command.PREV%>";
	document.frmMasterproduct.action="master_product.jsp";
	document.frmMasterproduct.submit();
	}

function cmdListNext(){
	document.frmMasterproduct.command.value="<%=Command.NEXT%>";
	document.frmMasterproduct.prev_command.value="<%=Command.NEXT%>";
	document.frmMasterproduct.action="master_product.jsp";
	document.frmMasterproduct.submit();
}

function cmdListLast(){
	document.frmMasterproduct.command.value="<%=Command.LAST%>";
	document.frmMasterproduct.prev_command.value="<%=Command.LAST%>";
	document.frmMasterproduct.action="master_product.jsp";
	document.frmMasterproduct.submit();
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
                  Master Data &gt; Master Produk &gt; <%=dictionaryD.getWord("PRODUCT")%><!-- #EndEditable --> 
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
                                    <form name="frmMasterproduct" method ="post" action="">
                                      <input type="hidden" name="command" value="<%=iCommand%>">
                                      <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                      <input type="hidden" name="start" value="<%=start%>">
                                      <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                      <input type="hidden" name="hidden_product_id" value="<%=oidMasterproduct%>">
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8"  colspan="3"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr align="left" valign="top"> 
                                                  <div class="input-group">
                                        <input type="text" name="srcValue"  id="searchForm" class="form-control bg-light border-0 small" placeholder="Search for...">
                                        <a class="btn btn-primary btnaddgeneral" href="javascript:search();">
                                        <i class="fa fa-search fa-sm"></i>
                                        </a>
                                        </div>
                                                <td height="14" valign="middle" colspan="3" class="comment">&nbsp;<%=dictionaryD.getWord("PRODUCT")+" "+dictionaryD.getWord("LIST")%> 
                                                   </td>
                                              </tr>
                                              <%
							try{
								if (listMasterProduct.size()>0){
							%>
                                              <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3"> 
                                                  <%= drawList(listMasterProduct,oidMasterproduct,dictionaryD)%> 
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
									  	if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE) && (oidMasterproduct == 0))
									  		cmd = PstMasterProduct.findLimitCommand(start,recordToGet,vectSize);
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
                                               if((iCommand != Command.ADD && iCommand != Command.ASK && iCommand != Command.EDIT)&& (frmMasterproduct.errorSize()<1)){
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
                                            <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(frmMasterproduct.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                              <tr> 
                                                <td colspan="3" class="listtitle"><%=oidMasterproduct==0?"Add":"Edit"%> 
                                                  Education</td>
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
                                                  <input type="text" name="<%=frmMasterproduct.fieldNames[FrmMasterProduct.FRM_FIELD_PRODUCT_NAME] %>"  value="<%= masterProduct.getProductName() %>" placeholder="Masukkan Nama Produk" >
                                                  * <%= frmMasterproduct.getErrorMsg(FrmMasterProduct.FRM_FIELD_PRODUCT_NAME) %>
                                                </td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="21" valign="top" width="1%">&nbsp;</td>
                                                <td height="21" valign="top" width="7%">Tipe Produk</td>
                                                <td height="21" colspan="2" width="92%"> 
                                                 <select name="<%=frmMasterproduct.fieldNames[frmMasterproduct.FRM_FIELD_PRODUCT_TYPE_ID]%>" class="myselect"  >
                                                      <option value="">=Select=</option>
                                                    <%
                                                        Vector listProductType = new Vector();
                                                        try{
                                                            listProductType = PstMasterProduct.listProductType(0, 0, "", "");
                                                        }catch (Exception e){
                                                            System.out.println("Err List Product : "+e);
                                                        }
                                                        if(listProductType.size()>0){
                                                            for(int xy=0; xy < listProductType.size();xy++){
                                                                ProductType objProductType = (ProductType) listProductType.get(xy);
                                                    %>
                                                  
                                                    <option 
                                                         value="<%=objProductType.getProductTypeId()%>"<%= (masterProduct.getProductTypeId()==objProductType.getProductTypeId()) ? "selected" : "" %>><%=objProductType.getProductTypeName()%>
                                                           
                                                           
                                                    </option>
                           
                                                        <%
                                                            }
                                                        }
                                                        %>
                                                </select>
                                                <%= frmMasterproduct.getErrorMsg(FrmMasterProduct.FRM_FIELD_PRODUCT_TYPE_ID) %>
                                                  </td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="21" valign="top" width="1%">&nbsp;</td>
                                                <td height="21" valign="top" width="7%"><%=dictionaryD.getWord("DESCRIPTION")%></td>
                                                <td height="21" colspan="2" width="92%"> 
                                                    <textarea type="text" name="<%=frmMasterproduct.fieldNames[FrmMasterProduct.FRM_FIELD_PRODUCT_DESC] %>"><%= masterProduct.getProductDesc() %></textarea>
                                                  <%= frmMasterproduct.getErrorMsg(FrmMasterProduct.FRM_FIELD_PRODUCT_DESC) %>
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
									String scomDel = "javascript:cmdAsk('"+oidMasterproduct+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidMasterproduct+"')";
									String scancel = "javascript:cmdEdit('"+oidMasterproduct+"')";
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
       <script type="text/javascript">
            $(".myselect").select2();
             
       </script>
       <script>
        function search(){
            document.listMasterproduct.command.value="<%=Command.LIST%>";
            document.listMasterproduct.action="master_product.jsp";
            document.listMasterproduct.submit();
        }
        
        
        
</script>

</body>
<!-- #BeginEditable "script" -->
<!-- #EndEditable --> <!-- #EndTemplate -->
</html>

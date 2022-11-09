<%-- 
    Document   : doc_template
    Created on : Sep 10, 2016, 9:21:49 AM
    Author     : Dimata 007
--%>

<%@taglib prefix="ckeditor" uri="http://www.siberhus.com/taglibs/ckeditor"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlDocMasterTemplate"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmDocMasterTemplate"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_DOKUMEN_SURAT, AppObjInfo.G2_MASTER_DOCUMENT, AppObjInfo.OBJ_DOCUMENT_MASTER); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    long oidDocMasterTemplate = FRMQueryString.requestLong(request, "doc_master_template_oid");
    long oidDocMaster = FRMQueryString.requestLong(request, "doc_master_id");
    
    if ((oidDocMaster != 0) && (oidDocMaster > 0)) {
        session.putValue("SELECTED_DOC_MASTER_ID", oidDocMaster);
    } else {
        try {
            oidDocMaster = ((Long) session.getValue("SELECTED_DOC_MASTER_ID"));
        } catch (Exception e) {
        }
    }
    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = "";
        
        
        
    CtrlDocMasterTemplate ctrlDocMasterTemplate = new CtrlDocMasterTemplate(request);

    Vector listDocMasterTemplate = new Vector(1, 1);
        
        
    /* end switch */
    FrmDocMasterTemplate frmDocMasterTemplate = ctrlDocMasterTemplate.getForm();
        
    long sdocmasterId = FRMQueryString.requestLong(request, FrmDocMasterTemplate.fieldNames[FrmDocMasterTemplate.FRM_FIELD_DOC_MASTER_ID]);
        
    if (oidDocMaster > 0) {
        whereClause = PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_ID] + " = " + oidDocMaster;
    } else {
        whereClause = PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_ID] + " = " + sdocmasterId;
    }
    listDocMasterTemplate = PstDocMasterTemplate.list(start, recordToGet, whereClause, orderClause);
        
    DocMasterTemplate docMasterTemplateObj = new DocMasterTemplate();
    if (listDocMasterTemplate.size() > 0) {
        
        try {
            docMasterTemplateObj = (DocMasterTemplate) listDocMasterTemplate.get(0);
        } catch (Exception e) {
        }
    }
    oidDocMasterTemplate = docMasterTemplateObj.getOID();
    iErrCode = ctrlDocMasterTemplate.action(iCommand, oidDocMasterTemplate, request, emplx.getFullName(), appUserIdSess);
        
    listDocMasterTemplate = PstDocMasterTemplate.list(start, recordToGet, whereClause, orderClause);
        
    if (listDocMasterTemplate.size() > 0) {
        
        try {
            docMasterTemplateObj = (DocMasterTemplate) listDocMasterTemplate.get(0);
        } catch (Exception e) {
        }
    }
        
    /*count list All DocMasterTemplate*/
    int vectSize = PstDocMasterTemplate.getCount(whereClause);
        
    /*switch list DocMasterTemplate*/
    if ((iCommand == Command.FIRST || iCommand == Command.PREV)
            || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
        start = ctrlDocMasterTemplate.actionList(iCommand, start, vectSize, recordToGet);
    }
    /* end switch list*/
        
    DocMasterTemplate docMasterTemplate = ctrlDocMasterTemplate.getdDocMasterTemplate();
    msgString = ctrlDocMasterTemplate.getMessage();
        
    /* get record to display */
        
    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listDocMasterTemplate.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;   //go to Command.PREV
        } else {
            start = 0;
            iCommand = Command.FIRST;
        }
        listDocMasterTemplate = PstDocMasterTemplate.list(start, recordToGet, whereClause, orderClause);
    }
    if (oidDocMaster > 0) {
        docMasterTemplate.setDoc_master_id(oidDocMaster);
    } else {
        docMasterTemplate.setDoc_master_id(sdocmasterId);
    }
session.setAttribute("userId", "2");
						 request.setAttribute("name", docMasterTemplateObj.getText_template());
%>
<!DOCTYPE html>
<html>
    <head>
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Document Template</title>
        <style type="text/css">
            body {
                color:#373737;
                background-color: #EEE;
                font-family: sans-serif;
                font-size: 12px;
            }
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            .header {
                
            }
            .content-main {
                padding: 21px 11px;
                margin: 0px 23px 59px 23px;
            }
            .content {
                background-color: #FFF;
                padding: 17px;
                border: 1px solid #DDD;
            }
            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }
            input, select {
                border: 1px solid #CCC;
                padding: 5px 7px;
                border-radius: 3px;
            }
        </style>
        <script src="../styles/ckeditor/ckeditor.js"></script>
        <script type="text/javascript">
            function cmdSave(){
                document.frmDocMasterTemplate.command.value="<%=Command.SAVE%>";
                document.frmDocMasterTemplate.action="doc_template.jsp";
                document.frmDocMasterTemplate.submit();
            }
            function cmdDelete(){
                document.frmDocMasterTemplate.command.value="<%=Command.DELETE%>";
                document.frmDocMasterTemplate.action="doc_template.jsp";
                document.frmDocMasterTemplate.submit();
            }
			function cmdView(){
				window.open("<%=approot%>/masterdata/formula.jsp");       
			}
        </script>
    </head>
    <body>
        <div id="menu_utama">
            <span id="menu_title">Document <strong style="color:#333;"> / </strong>Template</span>
        </div>
        <div class="content-main">
            <form name="frmDocMasterTemplate" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="doc_master_template_oid" value="<%=oidDocMasterTemplate%>">
                <table>
                    <tr>
                        <td><strong>Template Title</strong></td>
                        <td>
                            <input type="text" name="<%=frmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_TEMPLATE_TITLE]%>"  value="<%= docMasterTemplateObj.getTemplate_title()%>" size="50">
                            *) <%=frmDocMasterTemplate.getErrorMsg(frmDocMasterTemplate.FRM_FIELD_TEMPLATE_TITLE)%>
                        </td>
                    </tr>
                    <tr>
                        <td><strong>Document Master</strong></td>
                        <td>
                            <%
                            Vector docmaster_value = new Vector(1, 1);
                            Vector docmaster_key = new Vector(1, 1);
                            Vector listdocmaster = PstDocMaster.list(0, 0, "", "");
                            docmaster_value.add(""+0);
                            docmaster_key.add("select");
                            for (int i = 0; i < listdocmaster.size(); i++) {
                                DocMaster docMaster = (DocMaster) listdocmaster.get(i);
                                docmaster_key.add(docMaster.getDoc_title());
                                docmaster_value.add(String.valueOf(docMaster.getOID()));
                            }%>
                            <%= ControlCombo.draw(FrmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_DOC_MASTER_ID], "formElemen", null, "" + (docMasterTemplate.getDoc_master_id()!=0?docMasterTemplate.getDoc_master_id():"-"), docmaster_value, docmaster_key, "" )%>
                        </td>
                    </tr>
                </table>
                <div>&nbsp;</div>
                <ckeditor:config height="800px" width="50%" toolbar="Basic"></ckeditor:config>
                <ckeditor:editor id="ckeditor" name="FRM_FIELD_TEXT_TEMPLATE" height="800px" width="100%" toolbar="Full" class="elemenForm">
		${name}</ckeditor:editor>
                
                
                <div>&nbsp;</div>
                <a href="javascript:cmdSave()" class="btn">Save</a>
				<a href="javascript:cmdView()" class="btn">View Documentation</a>
                                <a href="javascript:cmdDelete()" class="btn">Delete</a>
            </form>
        </div>
        <div class="footer-page">
            <table>
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
                <tr>
                    <td valign="bottom"><%@include file="../../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
    </body>
</html>

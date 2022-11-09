<%-- 
    Document   : famRelation
    Created on : Sep 30, 2011, 6:20:16 PM
    Author     : Wiweka
--%>
<%
            /*
             * Page Name  		:  famRelation.jsp
             * Created on 		:  [date] [time] AM/PM
             *
             * @author  		:  Ari_20110930
             * @version  		:  [version]
             */

            /*******************************************************************
             * Page Description 	: [project description ... ]
             * Imput Parameters 	: [input parameter ...]
             * Output 			: [output ...]
             *******************************************************************/
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


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
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_EMPLOYEE, AppObjInfo.OBJ_EMPLOYEE_EDUCATION);%>
<%@ include file = "../main/checkuser.jsp" %>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
//boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
//boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
//boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
//out.println("appObjCode = " + appObjCode + " | add : " + privAdd + " | update : " + privUpdate + " | delete : " + privDelete);
%>
<!-- Jsp Block -->
<%!    public String drawList(Vector objectClass, long famRelationId, I_Dictionary dictionaryD) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("80%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.addHeader(dictionaryD.getWord("FAMILY_RELATIONSHIP"), "10%");
        ctrlist.addHeader(dictionaryD.getWord("TYPE"), "10%");
        ctrlist.addHeader("Tampilkan di CV", "10%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            FamRelation famRelation = (FamRelation) objectClass.get(i);
            Vector rowx = new Vector();
            if (famRelationId == famRelation.getOID()) {
                index = i;
            }

            rowx.add(famRelation.getFamRelation());
            rowx.add(PstFamRelation.typeRelation[famRelation.getFamRelationType()]);
            rowx.add(PstFamRelation.cvNames[famRelation.getShowInCv()]);

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(famRelation.getOID()));
        }

        return ctrlist.draw(index);
    }

%>
<%
            int iCommand = FRMQueryString.requestCommand(request);
            int start = FRMQueryString.requestInt(request, "start");
            int prevCommand = FRMQueryString.requestInt(request, "prev_command");
            long oidFamRelation = FRMQueryString.requestLong(request, "hidden_famRelation_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = FRMMessage.NONE;
            String whereClause = "";
            String orderClause = "" + PstFamRelation.fieldNames[PstFamRelation.FLD_FAMILY_RELATION_ID] + " ASC ";

            CtrlFamRelation ctrlFamRelation = new CtrlFamRelation(request);
            ControlLine ctrLine = new ControlLine();
            Vector listFamRelation = new Vector(1, 1);

            int defaultFamRelationType = 0;

            /*switch statement */
            iErrCode = ctrlFamRelation.action(iCommand, oidFamRelation);
            /* end switch*/
            FrmFamRelation frmFamRelation = ctrlFamRelation.getForm();

            /*count list All FamRelation*/
            int vectSize = PstFamRelation.getCount(whereClause);

            FamRelation famRelation = ctrlFamRelation.getFamRelation();
            msgString = ctrlFamRelation.getMessage();

            /*switch list FamRelation*/
            /*
            if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)&& (oidFamRelation == 0))
            start = PstFamRelation.findLimitStart(famRelation.getOID(),recordToGet, whereClause, orderClause);
             */

            if ((iCommand == Command.FIRST || iCommand == Command.PREV)
                    || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
                start = ctrlFamRelation.actionList(iCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listFamRelation = PstFamRelation.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listFamRelation.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;   //go to Command.PREV
                } else {
                    start = 0;
                    iCommand = Command.FIRST;
                    prevCommand = Command.FIRST; //go to Command.FIRST
                }
                listFamRelation = PstFamRelation.list(start, recordToGet, whereClause, orderClause);
            }
            I_Dictionary dictionaryD = userSession.getUserDictionary();
            dictionaryD.loadWord();
%>
<html>
    <!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>HARISMA - Master Data <%=dictionaryD.getWord("FAMILY")%> <%=dictionaryD.getWord("RELATIONSHIP")%></title>
        <script language="JavaScript">


            function cmdAdd(){
                document.frmfamRelation.hidden_famRelation_id.value="0";
                document.frmfamRelation.command.value="<%=Command.ADD%>";
                document.frmfamRelation.prev_command.value="<%=prevCommand%>";
                document.frmfamRelation.action="famRelation.jsp";
                document.frmfamRelation.submit();
            }

            function cmdAsk(oidFamRelation){
                document.frmfamRelation.hidden_famRelation_id.value=oidFamRelation;
                document.frmfamRelation.command.value="<%=Command.ASK%>";
                document.frmfamRelation.prev_command.value="<%=prevCommand%>";
                document.frmfamRelation.action="famRelation.jsp";
                document.frmfamRelation.submit();
            }

            function cmdConfirmDelete(oidFamRelation){
                document.frmfamRelation.hidden_famRelation_id.value=oidFamRelation;
                document.frmfamRelation.command.value="<%=Command.DELETE%>";
                document.frmfamRelation.prev_command.value="<%=prevCommand%>";
                document.frmfamRelation.action="famRelation.jsp";
                document.frmfamRelation.submit();
            }
            function cmdSave(){
                document.frmfamRelation.command.value="<%=Command.SAVE%>";
                document.frmfamRelation.prev_command.value="<%=prevCommand%>";
                document.frmfamRelation.action="famRelation.jsp";
                document.frmfamRelation.submit();
            }

            function cmdEdit(oidFamRelation){
                document.frmfamRelation.hidden_famRelation_id.value=oidFamRelation;
                document.frmfamRelation.command.value="<%=Command.EDIT%>";
                document.frmfamRelation.prev_command.value="<%=prevCommand%>";
                document.frmfamRelation.action="famRelation.jsp";
                document.frmfamRelation.submit();
            }

            function cmdCancel(oidFamRelation){
                document.frmfamRelation.hidden_famRelation_id.value=oidFamRelation;
                document.frmfamRelation.command.value="<%=Command.EDIT%>";
                document.frmfamRelation.prev_command.value="<%=prevCommand%>";
                document.frmfamRelation.action="famRelation.jsp";
                document.frmfamRelation.submit();
            }

            function cmdBack(){
                document.frmfamRelation.command.value="<%=Command.BACK%>";
                document.frmfamRelation.action="famRelation.jsp";
                document.frmfamRelation.submit();
            }

            function cmdListFirst(){
                document.frmfamRelation.command.value="<%=Command.FIRST%>";
                document.frmfamRelation.prev_command.value="<%=Command.FIRST%>";
                document.frmfamRelation.action="famRelation.jsp";
                document.frmfamRelation.submit();
            }

            function cmdListPrev(){
                document.frmfamRelation.command.value="<%=Command.PREV%>";
                document.frmfamRelation.prev_command.value="<%=Command.PREV%>";
                document.frmfamRelation.action="famRelation.jsp";
                document.frmfamRelation.submit();
            }

            function cmdListNext(){
                document.frmfamRelation.command.value="<%=Command.NEXT%>";
                document.frmfamRelation.prev_command.value="<%=Command.NEXT%>";
                document.frmfamRelation.action="famRelation.jsp";
                document.frmfamRelation.submit();
            }

            function cmdListLast(){
                document.frmfamRelation.command.value="<%=Command.LAST%>";
                document.frmfamRelation.prev_command.value="<%=Command.LAST%>";
                document.frmfamRelation.action="famRelation.jsp";
                document.frmfamRelation.submit();
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
                                                    Master Data &gt; <%=dictionaryD.getWord(I_Dictionary.EMPLOYEE)%> &gt; <%=dictionaryD.getWord(I_Dictionary.FAMILY_RELATIONSHIP)%><!-- #EndEditable -->
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
                                                                                <form name="frmfamRelation" method ="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <input type="hidden" name="hidden_famRelation_id" value="<%=oidFamRelation%>">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8"  colspan="3">
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="14" valign="middle" colspan="3" class="comment">&nbsp;Family Relation List </td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                                try {
                                                                                                                    if (listFamRelation.size() > 0) {
                                                                                                    %>
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="22" valign="middle" colspan="3">
                                                                                                            <%= drawList(listFamRelation, oidFamRelation,dictionaryD)%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%  }
                                                                                                                } catch (Exception exc) {
                                                                                                                }%>
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="8" align="left" colspan="3" class="command">
                                                                                                            <span class="command">
                                                                                                                <%
                                                                                                                            int cmd = 0;
                                                                                                                            if ((iCommand == Command.FIRST || iCommand == Command.PREV)
                                                                                                                                    || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
                                                                                                                                cmd = iCommand;
                                                                                                                            } else {
                                                                                                                                if (iCommand == Command.NONE || prevCommand == Command.NONE) {
                                                                                                                                    cmd = Command.FIRST;
                                                                                                                                } else {
                                                                                                                                    if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE) && (oidFamRelation == 0)) {
                                                                                                                                        cmd = PstFamRelation.findLimitCommand(start, recordToGet, vectSize);
                                                                                                                                    } else {
                                                                                                                                        cmd = prevCommand;
                                                                                                                                    }
                                                                                                                                }
                                                                                                                            }
                                                                                                                %>
                                                                                                                <% ctrLine.setLocationImg(approot + "/images");
                                                                                                                            ctrLine.initDefault();
                                                                                                                %>
                                                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%>
                                                                                                            </span> </td>
                                                                                                    </tr>
                                                                                                    <%//if((iCommand == Command.NONE || iCommand == Command.DELETE || iCommand ==Command.BACK || iCommand ==Command.SAVE)&& (frmEmpCategory.errorSize()<1)){
                                                                                                                if ((iCommand != Command.ADD && iCommand != Command.ASK && iCommand != Command.EDIT) && (frmFamRelation.errorSize() < 1)) {
                                                                                                                    if (privAdd) {%>
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
                                                                                                                    <td height="22" valign="middle" colspan="3" width="951"><a href="javascript:cmdAdd()" class="command">Add
                                                                                                                            New </a> </td>
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
                                                                                                <%if ((iCommand == Command.ADD) || (iCommand == Command.SAVE) && (frmFamRelation.errorSize() > 0) || (iCommand == Command.EDIT) || (iCommand == Command.ASK)) {%>
                                                                                                <table border="0" cellspacing="1" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td colspan="3" class="listtitle"><%=oidFamRelation == 0 ? "Add" : "Edit"%>
                                                                                                            <%=dictionaryD.getWord(I_Dictionary.FAMILY_RELATIONSHIP)%></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="3" class="listtitle">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="21" valign="middle">&nbsp;</td>
                                                                                                        <td height="21" valign="middle">&nbsp;</td>
                                                                                                        <td height="21" colspan="2" class="comment">*)= required</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="21" valign="top">&nbsp;</td>
                                                                                                        <td height="21" valign="top"><%=dictionaryD.getWord(I_Dictionary.FAMILY_RELATIONSHIP)%></td>
                                                                                                        <td height="21" colspan="2">
                                                                                                            <input type="text" name="<%=frmFamRelation.fieldNames[FrmFamRelation.FRM_FIELD_FAMILY_RELATION]%>"  value="<%= famRelation.getFamRelation()%>" class="formElemen">
                                                                                                            * <%= frmFamRelation.getErrorMsg(FrmFamRelation.FRM_FIELD_FAMILY_RELATION)%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="21" valign="top">&nbsp;</td>
                                                                                                        <td height="21" valign="top"><%=dictionaryD.getWord("TYPE")%></td>
                                                                                                        <td height="21" colspan="2">
                                                                                                            <select name="<%=frmFamRelation.fieldNames[FrmFamRelation.FRM_FIELD_FAMILY_RELATION_TYPE]%>">
                                                                                                            <%
                                                                                                                for (int i=0; i<PstFamRelation.typeRelation.length; i++){
                                                                                                                    if (famRelation.getFamRelationType() == i){
                                                                                                                        %>
                                                                                                                        <option selected="selected" value="<%= i %>"><%= PstFamRelation.typeRelation[i] %></option>
                                                                                                                        <%
                                                                                                                    } else {
                                                                                                                        %>
                                                                                                                        <option value="<%= i %>"><%= PstFamRelation.typeRelation[i] %></option>
                                                                                                                        <%
                                                                                                                    }
                                                                                                                }
                                                                                                            %>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="21" valign="top">&nbsp;</td>
                                                                                                        <td height="21" valign="top">Tampilkan di CV</td>
                                                                                                        <td height="21" colspan="2">
                                                                                                            <select name="<%=frmFamRelation.fieldNames[FrmFamRelation.FRM_FIELD_SHOW_IN_CV]%>">
                                                                                                            <%
                                                                                                                for (int i=0; i<PstFamRelation.cvNames.length; i++){
                                                                                                                    if (famRelation.getShowInCv() == i){
                                                                                                                        %>
                                                                                                                        <option selected="selected" value="<%= i %>"><%= PstFamRelation.cvNames[i] %></option>
                                                                                                                        <%
                                                                                                                    } else {
                                                                                                                        %>
                                                                                                                        <option value="<%= i %>"><%= PstFamRelation.cvNames[i] %></option>
                                                                                                                        <%
                                                                                                                    }
                                                                                                                }
                                                                                                            %>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>

                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="8" valign="middle">&nbsp;</td>
                                                                                                        <td height="8" valign="middle">&nbsp;</td>
                                                                                                        <td height="8" colspan="2">&nbsp;
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top" >
                                                                                                        <td colspan="4" class="command">
                                                                                                            <%
                                                                                                                ctrLine.setLocationImg(approot + "/images");
                                                                                                                ctrLine.initDefault();
                                                                                                                ctrLine.setTableWidth("80");
                                                                                                                String scomDel = "javascript:cmdAsk('" + oidFamRelation + "')";
                                                                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidFamRelation + "')";
                                                                                                                String scancel = "javascript:cmdEdit('" + oidFamRelation + "')";
                                                                                                                ctrLine.setBackCaption("Back to List");
                                                                                                                ctrLine.setCommandStyle("buttonlink");
                                                                                                                ctrLine.setDeleteCaption("Delete");
                                                                                                                ctrLine.setSaveCaption("Save");
                                                                                                                ctrLine.setAddCaption("");

                                                                                                                if (privDelete) {
                                                                                                                    ctrLine.setConfirmDelCommand(sconDelCom);
                                                                                                                    ctrLine.setDeleteCommand(scomDel);
                                                                                                                    ctrLine.setEditCommand(scancel);
                                                                                                                } else {
                                                                                                                    ctrLine.setConfirmDelCaption("");
                                                                                                                    ctrLine.setDeleteCaption("");
                                                                                                                    ctrLine.setEditCaption("");
                                                                                                                }

                                                                                                                if (privAdd == false && privUpdate == false) {
                                                                                                                    ctrLine.setSaveCaption("");
                                                                                                                }

                                                                                                                if (privAdd == false) {
                                                                                                                    ctrLine.setAddCaption("");
                                                                                                                }
                                                                                                                if (iCommand == Command.ASK) {
                                                                                                                    ctrLine.setDeleteQuestion(msgString);
                                                                                                                }
                                                                                                            %>
                                                                                                            <%= ctrLine.drawImage(iCommand, iErrCode, msgString)%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td>&nbsp;</td>
                                                                                                        <td>&nbsp;</td>
                                                                                                        <td></td>
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
                                                                                        <% if(iCommand == Command.DELETE){%>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <div><font color="#FF6600" face="Arial" ><%=msgString%></font></div>                                                                                                
                                                                                            </td>
                                                                                        </tr>
                                                                                        <% } %>
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

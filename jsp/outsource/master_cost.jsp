<%-- 
    Document   : company
    Created on : Sep 30, 2011, 3:56:51 PM
    Author     : Wiweka
--%>
<%@page import="com.dimata.harisma.entity.outsource.OutSourceCostMaster"%>
<%@page import="com.dimata.harisma.entity.outsource.PstOutSourceCostMaster"%>
<%@page import="com.dimata.harisma.form.outsource.FrmOutSourceCostMaster"%>
<%@page import="com.dimata.harisma.form.outsource.CtrlOutSourceCostMaster"%>
<%
            /*
             * Page Name  		:  master_cost.jsp
             * Created on 		:  [date] [time] AM/PM
             *
             * @author  		: Ari_20110930
             * @version  		: -
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

<%@ include file = "../main/javainit.jsp" %>

<% // int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_PERFORMANCE_APPRAISAL, AppObjInfo.OBJ_GROUP_RANK); %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_DIVISION);%>
<%@ include file = "../main/checkuser.jsp" %>

<!-- Jsp Block -->
<%!    public String drawList(Vector objectClass, long outId) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("80%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.addHeader("Nomor Urut", "10%");
        ctrlist.addHeader("KODE", "10%");
        ctrlist.addHeader("NAMA", "20%");
        ctrlist.addHeader("JENIS", "20%");
        ctrlist.addHeader("GABUNG BIAYA", "20%");
        ctrlist.addHeader("KETERANGAN", "20%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;
        
        for (int i = 0; i < objectClass.size(); i++) {
            OutSourceCostMaster outSourceCostMaster = (OutSourceCostMaster) objectClass.get(i);
            Vector rowx = new Vector();
            if (outId == outSourceCostMaster.getOID()) {
                index = i;
            }

            rowx.add(""+outSourceCostMaster.getShowIndex());
            rowx.add(""+outSourceCostMaster.getCostCode());
            rowx.add(""+outSourceCostMaster.getCostName());
            
            for(int h = 0; h < PstOutSourceCostMaster.typeValue.length; h++) {
                if(outSourceCostMaster.getType() == PstOutSourceCostMaster.typeValue[h]) {
                    rowx.add(""+PstOutSourceCostMaster.typeKey[h]);
                }
            }
            
            if(outSourceCostMaster.getParentOutSourceCostId() != 0) {
                String nameMasterOut = PstOutSourceCostMaster.getName("OUTSRC_COST_ID="+outSourceCostMaster.getParentOutSourceCostId());

                rowx.add(""+nameMasterOut);
            } else {
                rowx.add("");    
            }
            rowx.add(""+outSourceCostMaster.getNote());
            
            lstData.add(rowx);
            lstLinkData.add(String.valueOf(outSourceCostMaster.getOID()));
        }
        return ctrlist.draw(index);
    }

%>
<%
            int iCommand = FRMQueryString.requestCommand(request);
            int start = FRMQueryString.requestInt(request, "start");
            int prevCommand = FRMQueryString.requestInt(request, "prev_command");
            long oidOutSourceCostMaster = FRMQueryString.requestLong(request, "hidden_sourcecost_id");

            /*variable declaration*/
            int recordToGet = 50;
            String msgString = "";
            int iErrCode = FRMMessage.NONE;
            String whereClause = "";
            String orderClause = "SHOW_INDEX";

            CtrlOutSourceCostMaster ctrlOutSourceCostMaster = new CtrlOutSourceCostMaster(request);
            ControlLine ctrLine = new ControlLine();
            Vector listOutSourceCostMaster = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlOutSourceCostMaster.action(iCommand, oidOutSourceCostMaster);
            /* end switch*/
            FrmOutSourceCostMaster frmOutSourceCostMaster = ctrlOutSourceCostMaster.getForm();

            /*count list All Position*/
            int vectSize = PstOutSourceCostMaster.getCount(whereClause);

            OutSourceCostMaster outSourceCostMaster = ctrlOutSourceCostMaster.getOutSourceCostMaster();
            msgString = ctrlOutSourceCostMaster.getMessage();

            /*switch list Company*/
            if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)) {
                //start = PstCompany.findLimitStart(company.getOID(),recordToGet, whereClause);
                oidOutSourceCostMaster = outSourceCostMaster.getOID();
            }

            if ((iCommand == Command.FIRST || iCommand == Command.PREV)
                    || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
                start = ctrlOutSourceCostMaster.actionList(iCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listOutSourceCostMaster = PstOutSourceCostMaster.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listOutSourceCostMaster.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;   //go to Command.PREV
                } else {
                    start = 0;
                    iCommand = Command.FIRST;
                    prevCommand = Command.FIRST; //go to Command.FIRST
                }
                listOutSourceCostMaster = PstOutSourceCostMaster.list(start, recordToGet, whereClause, orderClause);
            }

                

%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>HARISMA - Master Cost Alih Daya</title>
        <script language="JavaScript">


            function cmdAdd(){
                document.frmoutsource.hidden_sourcecost_id.value="0";
                document.frmoutsource.command.value="<%=Command.ADD%>";
                document.frmoutsource.prev_command.value="<%=prevCommand%>";
                document.frmoutsource.action="master_cost.jsp";
                document.frmoutsource.submit();
            }

            function cmdAsk(oidOutSourceCostMaster){
                document.frmoutsource.hidden_sourcecost_id.value=oidOutSourceCostMaster;
                document.frmoutsource.command.value="<%=Command.ASK%>";
                document.frmoutsource.prev_command.value="<%=prevCommand%>";
                document.frmoutsource.action="master_cost.jsp";
                document.frmoutsource.submit();
            }

            function cmdConfirmDelete(oidOutSourceCostMaster){
                document.frmoutsource.hidden_sourcecost_id.value=oidOutSourceCostMaster;
                document.frmoutsource.command.value="<%=Command.DELETE%>";
                document.frmoutsource.prev_command.value="<%=prevCommand%>";
                document.frmoutsource.action="master_cost.jsp";
                document.frmoutsource.submit();
            }
            function cmdSave(){
                document.frmoutsource.command.value="<%=Command.SAVE%>";
                document.frmoutsource.prev_command.value="<%=prevCommand%>";
                document.frmoutsource.action="master_cost.jsp";
                document.frmoutsource.submit();
            }

            function cmdEdit(oidOutSourceCostMaster){
                document.frmoutsource.hidden_sourcecost_id.value=oidOutSourceCostMaster;
                document.frmoutsource.command.value="<%=Command.EDIT%>";
                document.frmoutsource.prev_command.value="<%=prevCommand%>";
                document.frmoutsource.action="master_cost.jsp";
                document.frmoutsource.submit();
            }

            function cmdCancel(oidOutSourceCostMaster){
                document.frmoutsource.hidden_sourcecost_id.value=oidOutSourceCostMaster;
                document.frmoutsource.command.value="<%=Command.EDIT%>";
                document.frmoutsource.prev_command.value="<%=prevCommand%>";
                document.frmoutsource.action="master_cost.jsp";
                document.frmoutsource.submit();
            }

            function cmdBack(){
                document.frmoutsource.command.value="<%=Command.BACK%>";
                document.frmoutsource.action="master_cost.jsp";
                document.frmoutsource.submit();
            }

            function cmdListFirst(){
                document.frmoutsource.command.value="<%=Command.FIRST%>";
                document.frmoutsource.prev_command.value="<%=Command.FIRST%>";
                document.frmoutsource.action="master_cost.jsp";
                document.frmoutsource.submit();
            }

            function cmdListPrev(){
                document.frmoutsource.command.value="<%=Command.PREV%>";
                document.frmoutsource.prev_command.value="<%=Command.PREV%>";
                document.frmoutsource.action="master_cost.jsp";
                document.frmoutsource.submit();
            }

            function cmdListNext(){
                document.frmoutsource.command.value="<%=Command.NEXT%>";
                document.frmoutsource.prev_command.value="<%=Command.NEXT%>";
                document.frmoutsource.action="master_cost.jsp";
                document.frmoutsource.submit();
            }

            function cmdListLast(){
                document.frmoutsource.command.value="<%=Command.LAST%>";
                document.frmoutsource.prev_command.value="<%=Command.LAST%>";
                document.frmoutsource.action="master_cost.jsp";
                document.frmoutsource.submit();
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
                                                    Laporan &gt; Form Master Cost Alih Daya<!-- #EndEditable -->
                                                </strong></font>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td  style="background-color:<%=bgColorContent%>; "> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" >
                                                            <tr>
                                                                <td valign="top">
                                                                    <table style="border:1px solid <%=garisContent%>" width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                                                                        <tr>
                                                                            <td valign="top">
                                                                                <!-- #BeginEditable "content" -->
                                                                                <form name="frmoutsource" method ="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <input type="hidden" name="hidden_sourcecost_id" value="<%=oidOutSourceCostMaster%>">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8"  colspan="3">
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="14" valign="middle" colspan="3" class="listtitle">&nbsp;Master Cost Alih Daya List </td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                                try {
                                                                                                                    if (listOutSourceCostMaster.size() > 0) {
                                                                                                    %>
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="22" valign="middle" colspan="3">
                                                                                                            <%= drawList(listOutSourceCostMaster, oidOutSourceCostMaster)%>
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
                                                                                                                                    cmd = prevCommand;
                                                                                                                                }
                                                                                                                            }
                                                                                                                %>
                                                                                                                <% ctrLine.setLocationImg(approot + "/images");
                                                                                                                            ctrLine.initDefault();
                                                                                                                %>
                                                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%>
                                                                                                            </span> </td>
                                                                                                    </tr>
                                                                                                  
                                                                                                       <%//if((iCommand == Command.NONE || iCommand == Command.DELETE || iCommand == Command.BACK || iCommand ==Command.SAVE)&& (frmCompany.errorSize()<1)){
                                                                                                    if ((iCommand != Command.ADD && iCommand != Command.ASK && iCommand != Command.EDIT) && (frmOutSourceCostMaster.errorSize() < 1)) {
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
                                                                                                                    <td height="22" valign="middle" colspan="3" width="951">
                                                                                                                        <a href="javascript:cmdAdd()" class="command">Add
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
                                                                                        <tr>
                                                                                            <td>&nbsp;
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" valign="middle" colspan="3">
                                                                                                <%if ((iCommand == Command.ADD) || (iCommand == Command.SAVE) && (frmOutSourceCostMaster.errorSize() > 0) || (iCommand == Command.EDIT) || (iCommand == Command.ASK)) {%>
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                                                                    <tr>
                                                                                                        <td class="listtitle"><%=oidOutSourceCostMaster == 0 ? "Add" : "Edit"%> Company</td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="100%">
                                                                                                            <table border="0" cellspacing="2" cellpadding="2" width="50%">
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" width="17%">&nbsp;</td>
                                                                                                                    <td width="83%" class="comment">*)entry required </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" width="17%">
                                                                                                                        Nomor Urut</td>
                                                                                                                    <td width="83%">
                                                                                                                        <input type="text" name="<%=frmOutSourceCostMaster.fieldNames[FrmOutSourceCostMaster.FRM_FIELD_SHOW_INDEX]%>"  value="<%= outSourceCostMaster.getShowIndex()%>" class="elemenForm" size="30">
                                                                                                                        *<%=frmOutSourceCostMaster.getErrorMsg(FrmOutSourceCostMaster.FRM_FIELD_SHOW_INDEX)%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" width="17%">
                                                                                                                        KODE</td>
                                                                                                                    <td width="83%">
                                                                                                                        <input type="text" name="<%=frmOutSourceCostMaster.fieldNames[FrmOutSourceCostMaster.FRM_FIELD_COST_CODE]%>"  value="<%= outSourceCostMaster.getCostCode()%>" class="elemenForm" size="30">
                                                                                                                        *<%=frmOutSourceCostMaster.getErrorMsg(FrmOutSourceCostMaster.FRM_FIELD_COST_CODE)%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" width="17%">
                                                                                                                        NAMA</td>
                                                                                                                    <td width="83%">
                                                                                                                        <input type="text" name="<%=frmOutSourceCostMaster.fieldNames[FrmOutSourceCostMaster.FRM_FIELD_COST_NAME]%>"  value="<%= outSourceCostMaster.getCostName()%>" class="elemenForm" size="30">
                                                                                                                        *<%=frmOutSourceCostMaster.getErrorMsg(FrmOutSourceCostMaster.FRM_FIELD_COST_NAME)%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" width="17%">
                                                                                                                        JENIS</td>
                                                                                                                    <td width="83%">
                                                                                                                        <select class="form-control" name="<%=frmOutSourceCostMaster.fieldNames[frmOutSourceCostMaster.FRM_FIELD_TYPE] %>">
                                                                                                                            <% for (int i = 0; i < PstOutSourceCostMaster.typeValue.length; i++) {
                                                                                                                                String strType = "";
                                                                                                                                if (outSourceCostMaster.getType() == PstOutSourceCostMaster.typeValue[i]) {
                                                                                                                                    strType = "selected";
                                                                                                                                }
                                                                                                                            %> 
                                                                                                                                <option value="<%="" + PstOutSourceCostMaster.typeValue[i]%>" <%= strType%> >
                                                                                                                                <%=PstOutSourceCostMaster.typeKey[i]%>  
                                                                                                                                </option>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" width="17%">
                                                                                                                        GABUNG BIAYA</td>
                                                                                                                    <td width="83%">
                                                                                                                       
                                                                                                                        <!-- Ar<%
                                                                                                                        Vector masterout_value = new Vector(1, 1);
                                                                                                                        Vector masterout_key = new Vector(1, 1);
                                                                                                                        Vector listMasterout = PstOutSourceCostMaster.list(0, 0, "", " SHOW_INDEX ");
                                                                                                                        masterout_value.add(""+0);
                                                                                                                        masterout_key.add("select");
                                                                                                                        for (int i = 0; i < listMasterout.size(); i++) {
                                                                                                                            OutSourceCostMaster costMaster = (OutSourceCostMaster) listMasterout.get(i);
                                                                                                                            masterout_key.add(costMaster.getCostName());
                                                                                                                            masterout_value.add(String.valueOf(costMaster.getOID()));
                                                                                                                        }

                                                                                                                        %>i_20110903
                                                                                                                            Menambah Link menuju employee_mutation.jsp { -->
                                                                                                                        <%= ControlCombo.draw(frmOutSourceCostMaster.fieldNames[FrmOutSourceCostMaster.FRM_FIELD_PARENT_OUTSRC_COST_ID], "formElemen", null, "" + (outSourceCostMaster.getParentOutSourceCostId()!=0?outSourceCostMaster.getParentOutSourceCostId():"-"), masterout_value, masterout_key,"")%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" width="17%">
                                                                                                                       KETERANGAN</td>
                                                                                                                    <td width="83%">
                                                                                                                       <textarea name="<%=frmOutSourceCostMaster.fieldNames[FrmOutSourceCostMaster.FRM_FIELD_NOTE]%>" class="elemenForm" cols="30" rows="3"><%= outSourceCostMaster.getNote()%></textarea>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table >
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="2">
                                                                                                            <%
                                                                                                                ctrLine.setLocationImg(approot + "/images");
                                                                                                                ctrLine.initDefault();
                                                                                                                ctrLine.setTableWidth("80%");
                                                                                                                String scomDel = "javascript:cmdAsk('" + oidOutSourceCostMaster + "')";
                                                                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidOutSourceCostMaster + "')";
                                                                                                                String scancel = "javascript:cmdEdit('" + oidOutSourceCostMaster + "')";
                                                                                                                ctrLine.setBackCaption("Back to List");
                                                                                                                ctrLine.setCommandStyle("buttonlink");
                                                                                                                ctrLine.setBackCaption("Back to List");
                                                                                                                ctrLine.setSaveCaption("Save");
                                                                                                                ctrLine.setConfirmDelCaption("Yes Delete");
                                                                                                                ctrLine.setDeleteCaption("Delete");

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


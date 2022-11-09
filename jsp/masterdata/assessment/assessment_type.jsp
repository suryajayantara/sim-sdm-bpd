<%-- 
    Document   : assessment_type
    Created on : Mar 9, 2020, 10:53:31 AM
    Author     : gndiw
--%>

<%@page import="com.dimata.gui.jsp.ControlList"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmAssessment"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlAssessment"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_DIVISION);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%!    // drawList(Vector, long); untuk menggambar table
    long pasal_id = 0;
    public String drawList(Vector objectClass, long oidAssessmentType) {

        ControlList ctrlist = new ControlList(); //membuat new class ControlList
        // membuat tampilan dengan controllist
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");
        ctrlist.addHeader("No", "");
        ctrlist.addHeader("Assessment Type", "");
        ctrlist.addHeader("Note", "");
        ctrlist.addHeader("Delete", "");
        /////////\\//\\//\\//\\//\\
        ctrlist.setLinkRow(1); // untuk menge-sett link di kolom pertama atau dikolom yg lain

        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ////////


        ctrlist.reset(); //berfungsi untuk menginisialisasi list menjadi kosong

        int no = 0;

        // objectClass mempunyai tipe data Vector
        // objectClass.size(); mendapatkan banyak record
        for (int i = 0; i < objectClass.size(); i++) {
            // membuat object WarningReprimandAyat berdasarkan objectClass ke-i
            
            Assessment assessment = (Assessment) objectClass.get(i);
            // rowx will be created secara berkesinambungan base on i
            Vector rowx = new Vector();

            no = no + 1;
            rowx.add("" + no);
            rowx.add(assessment.getAssessmentType());
            rowx.add(assessment.getDescription());
            rowx.add("<a href=\"javascript:cmdAsk('"+assessment.getOID()+"')\">&times;&nbsp;Delete</a>");
            lstData.add(rowx);
            // menambah ID ke list LinkData
            lstLinkData.add(String.valueOf(assessment.getOID()));

        }

        return ctrlist.draw(); // mengembalikan data-data control list

    }

%>
<%  
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidAssessmentType = FRMQueryString.requestLong(request, "hidden_ass_type_id");
    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = "";

    
    CtrlAssessment ctrlAssessment = new CtrlAssessment(request);
    ControlLine ctrLine = new ControlLine();
    Vector listAssessment = new Vector(1, 1);

    /*switch statement */
    iErrCode = ctrlAssessment.action(iCommand, oidAssessmentType, 0, "");
    /* end switch*/
    FrmAssessment frmAssessment = ctrlAssessment.getForm();

    /*count list All Position*/
    int vectSize = PstAssessment.getCount(whereClause); //PstWarningReprimandAyat.getCount(whereClause);
    Assessment assessment = ctrlAssessment.getAssessment();
    msgString = ctrlAssessment.getMessage();
    
    if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)) {
        start = PstAssessment.findLimitStart(assessment.getOID(), recordToGet, whereClause, orderClause);
        oidAssessmentType = assessment.getOID();
    }

    if ((iCommand == Command.FIRST || iCommand == Command.PREV)
            || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
        start = ctrlAssessment.actionList(iCommand, start, vectSize, recordToGet);
    }
    /* end switch list*/

    /* get record to display */
    listAssessment = PstAssessment.list(start, recordToGet, whereClause, orderClause);

    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listAssessment.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;   //go to Command.PREV
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; //go to Command.FIRST
        }
        listAssessment = PstAssessment.list(start, recordToGet, whereClause, orderClause);
    }


%>
<html>
    <head>
        <!-- #BeginEditable "doctitle" --> 
        <title>HARISMA - Assessment Type</title>
        <!-- #EndEditable --> 
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <!-- #BeginEditable "styles" --> 
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "stylestab" --> 
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 

        <style type="text/css">
            #menu_utama {color: #0066CC; font-weight: bold; padding: 5px 14px; border-left: 1px solid #0066CC; font-size: 14px; background-color: #F7F7F7;}
            #mn_utama {color: #FF6600; padding: 5px 14px; border-left: 1px solid #999; font-size: 14px; background-color: #F5F5F5;}            
            #btn {
                background: #3498db;
                border: 1px solid #0066CC;
                border-radius: 3px;
                font-family: Arial;
                color: #ffffff;
                font-size: 12px;
                padding: 3px 9px 3px 9px;
            }

            #btn:hover {
                background: #3cb0fd;
                border: 1px solid #3498db;
            }
            #titleTd {background-color: #3cb0fd; color: #FFF; padding: 3px 5px; border-left: 1px solid #0066CC;}
            #subtitle {padding: 2px 7px; font-weight: bold; background-color: #FFF; border-left: 1px solid #3498db;}
            #td1{ padding: 3px;}
            #td2{ padding: 3px 7px 3px 5px;}
            
            .tblStyle {border-collapse: collapse;font-size: 11px;}
            .tblStyle td {padding: 3px 5px; border: 1px solid #CCC;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            
            #btn1 {
              background: #f27979;
              border: 1px solid #d74e4e;
              border-radius: 3px;
              font-family: Arial;
              color: #ffffff;
              font-size: 12px;
              padding: 3px 9px 3px 9px;
            }

            #btn1:hover {
              background: #d22a2a;
              border: 1px solid #c31b1b;
            }
            #confirm {background-color: #fad9d9;border: 1px solid #da8383; color: #bf3c3c; padding: 14px 21px;border-radius: 5px;}
        </style>
        <script language="JavaScript">
            function getCmd(){
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.action = "assessment_type.jsp";
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.submit();
            }
            function cmdAdd() {              
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.command.value="<%=Command.ADD%>";               
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.hidden_ass_type_id.value = "0";
                getCmd();
            }
            function cmdBack() {
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.command.value="<%=Command.BACK%>";               
                getCmd();
            }

            function cmdEdit(oid) {
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.hidden_ass_type_id.value = oid;
                getCmd();
            }

            function cmdSave() {
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.command.value = "<%=Command.SAVE%>";
                getCmd();
            }
            
            function cmdListFirst(){
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.command.value="<%=Command.FIRST%>";
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.prev_command.value="<%=Command.FIRST%>";
                getCmd();
            }

            function cmdListPrev(){
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.command.value="<%=Command.PREV%>";
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.prev_command.value="<%=Command.PREV%>";
                getCmd();
            }

            function cmdListNext(){
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.command.value="<%=Command.NEXT%>";
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.prev_command.value="<%=Command.NEXT%>";
                getCmd();
            }

            function cmdListLast(){
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.command.value="<%=Command.LAST%>";
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.prev_command.value="<%=Command.LAST%>";
                getCmd();
            }
            function cmdAsk(oid){
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.command.value="<%=Command.ASK%>";
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.hidden_ass_type_id.value = oid;
                getCmd();
            }
            function cmdDelete(oid){
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.command.value = "<%=Command.DELETE%>";
                document.<%=FrmAssessment.FRM_NAME_ASSESSMENT%>.hidden_ass_type_id.value = oid;
                getCmd();
            }
        </script>
    </head>
    <body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../../main/mnmain.jsp" %>
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
                    <table width="100%" border="0" cellspacing="3" cellpadding="2" id="tbl0">
                        <tr> 
                            <td width="100%" colspan="3" valign="top"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                        <td height="20"> <div id="menu_utama"> Assessment Type </div> </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td style="background-color:#EEE;">

                                            <table style="padding:9px; border:1px solid #00CCFF;" <%=garisContent%> width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                                                <tr>
                                                    <td>
                                                        <div id="mn_utama">List Assessment Type</div>
                                                        <form name="<%=FrmAssessment.FRM_NAME_ASSESSMENT%>" method="POST" action="">

                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                            <input type="hidden" name="hidden_ass_type_id" value="<%=oidAssessmentType%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">


                                                            </td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp;</td>
                                                            </tr>
                                                            <%
                                                            if (iCommand == Command.ASK){
                                                            %>
                                                            <tr>
                                                                <td>
                                                                    <span id="confirm">
                                                                        <strong>Are you sure to delete item ?</strong> &nbsp;
                                                                        <button id="btn1" onclick="javascript:cmdDelete('<%=oidAssessmentType%>')">Yes</button>
                                                                        &nbsp;<button id="btn1" onclick="javascript:cmdBack()">No</button>
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <%
                                                            }
                                                            %>
                                                            <tr>
                                                                <td>&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <%if (listAssessment != null && listAssessment.size() > 0) {%>
                                                                <td>
                                                                    <!-- untuk drawlist -->
                                                                    <!-- membuat tabel yang ditulis dari method drowList(); -->
                                                                    <%=drawList(listAssessment, oidAssessmentType)%>
                                                                </td>

                                                                <%} else {%>
                                                                <td>
                                                                    record not found
                                                                </td>
                                                                <%}%>
                                                            </tr>
                                                            <tr>
                                                                <td>
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
                                                                                    if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE) && (oidAssessmentType == 0)) {
                                                                                        cmd = PstAssessment.findLimitCommand(start, recordToGet, vectSize);
                                                                                    } else {
                                                                                        cmd = prevCommand;
                                                                                    }
                                                                                }
                                                                            }
                                                                        %>
                                                                        <% 
                                                                            ctrLine.setLocationImg(approot + "/images");
                                                                            ctrLine.initDefault();
                                                                        %>
                                                                        <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> 
                                                                    </span>
                                                                </td>
                                                            </tr>

                                                            <%if (!(iCommand == Command.ADD || iCommand == Command.EDIT)) {%>
                                                            <tr>

                                                                <td>

                                                                    <button id="btn" onclick="cmdAdd()">Add New</button>

                                                                </td>

                                                            </tr>
                                                            <%}%>
                                                            <!-- inputan user -->
                                                            <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>
                                                            <% if (iCommand == Command.ADD){%>
                                                            <tr><td><div id="mn_utama">Add Assessment Type </div></td></tr>
                                                            <% } else { %>
                                                            <tr><td><div id="mn_utama">Edit Assessment Type</div></td></tr>
                                                            <% } %>


                                                            <tr>
                                                                <td>
                                                                    <input type="text" name="<%=frmAssessment.fieldNames[FrmAssessment.FRM_FIELD_ASSESSMENT_TYPE]%>" placeholder="Assessment Type" value="<%=assessment.getAssessmentType()%>" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <textarea name="<%=frmAssessment.fieldNames[FrmAssessment.FRM_FIELD_DESCRIPTION]%>" placeholder="Note"><%=assessment.getDescription()%></textarea>
                                                                </td>
                                                            </tr>

                                                            <tr>

                                                                <td>
                                                                    <button id="btn" onclick="cmdSave()">Save</button>
                                                                    <button id="btn" onclick="cmdBack()">Back</button>
                                                                </td>
                                                            </tr>
                                                            <%}%> 

                                                            <tr>
                                                                <td colspan="3">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp;</td>
                                                            </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table><!---End Tble--->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
            <tr>
                <td valign="bottom">
                    <!-- untuk footer -->
                    <%@include file="../../footer.jsp" %>
                </td>

            </tr>
            <%} else {%>
            <tr> 
                <td colspan="2" height="20" > <!-- #BeginEditable "footer" --> 
                    <%@ include file = "../../main/footer.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <%}%>
        </table>
    </body>
    <!-- #BeginEditable "script" --> <script language="JavaScript">
        var oBody = document.body;
        var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);
    </script>
</html>

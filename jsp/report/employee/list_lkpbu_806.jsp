<%-- 
    Document   : list_lkpbu_806
    Created on : Aug 12, 2015, 11:56:42 AM
    Author     : khirayinnura
--%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.PstLkpbu"%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.Lkpbu"%>
<%@page import="com.dimata.harisma.form.employee.FrmEmployee"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package wihita -->
<%@ page import = "com.dimata.util.*" %>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package harisma -->
<%@ page import = "com.dimata.harisma.entity.search.*" %>
<%@ page import = "com.dimata.harisma.form.search.*" %>
<%@ page import = "com.dimata.harisma.entity.employee.*" %>
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ page import = "com.dimata.harisma.session.employee.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%!    public String drawList(Vector listEmployee) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("listgentitle");

        ctrlist.addHeader("Jenis Pelatihan", "2%", "0", "0");
        ctrlist.addHeader("Jumlah SDM", "2%", "0", "0");

        ctrlist.setLinkRow(-1);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();

        Vector rowx = new Vector(1, 1);
        String code = "";
        int codeAtt = 0;

        for (int i = 0; i < listEmployee.size(); i++) {
            Lkpbu lkpbu = (Lkpbu) listEmployee.get(i);
            rowx = new Vector(1, 1);


            if (i == 0) {
                code = lkpbu.getCode();
                codeAtt = lkpbu.getTrainAteendes();
            }

            if (lkpbu.getCode().equals(code)) {
                codeAtt = codeAtt + lkpbu.getTrainAteendes();

                if (i == (listEmployee.size() - 1)) {
                    rowx.add(code);
                    rowx.add("" + codeAtt);

                    lstData.add(rowx);
                    lstLinkData.add("0");
                }

            } else {
                if (codeAtt != 0) {
                    rowx.add(code);
                    rowx.add("" + codeAtt);

                    lstData.add(rowx);
                    lstLinkData.add("0");
                }
                code = lkpbu.getCode();
                codeAtt = 0;
                i--;
            }
        }

        return ctrlist.drawList();
    }
%>

<%
    int iCommand = FRMQueryString.requestCommand(request);
    int year = FRMQueryString.requestInt(request, "year");

    Vector vListResult = new Vector(1, 1);

    vListResult = PstLkpbu.listTrainingAtt(year);

    session.putValue("listresult", vListResult);

    Vector listKadiv = new Vector(1, 1);

    String sandiPelapor = PstSystemProperty.getValueByName("LKPBU_SANDI_PELAPOR");
    //get value kadiv HRD
    String kadivPositionOid = PstSystemProperty.getValueByName("HR_DIR_POS_ID");
    String whereClauseOidPosition = "POSITION_ID='" + kadivPositionOid + "'";

    listKadiv = PstLkpbu.listPosition(whereClauseOidPosition);
    session.putValue("listkadiv", listKadiv);

%>

<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>HARISMA - LKPBU 806 Report</title>
        <script language="JavaScript">
            <%if (iCommand == Command.PRINT) {%>
                //com.dimata.harisma.report.listRequest	
                window.open("<%=printroot%>.report.listRequest.ListEmpEducationPdf");
            <%}%>

                function cmdAdd(){
                    document.frmemplkpbu806.command.value="<%=Command.ADD%>";
                    document.frmemplkpbu806.action="list_lkpbu_806.jsp";
                    document.frmemplkpbu806.submit();
                }

                function reportPdf(){
                    document.frmemplkpbu806.command.value="<%=Command.PRINT%>";
                    document.frmemplkpbu806.action="list_lkpbu_806.jsp";
                    document.frmemplkpbu806.submit();
                }

                function cmdSearch(){
                    document.frmemplkpbu806.command.value="<%=Command.LIST%>";
                    document.frmemplkpbu806.action="list_lkpbu_806.jsp";
                    document.frmemplkpbu806.submit();
                }

                function cmdSpecialQuery(){
                    document.frmemplkpbu806.action="specialquery.jsp";
                    document.frmemplkpbu806.submit();
                }

                function fnTrapKD(){
                    if (event.keyCode == 13) {
                        document.all.aSearch.focus();
                        cmdSearch();
                    }
                }
                function cmdExportExcel(){
                 
                    var linkPage = "<%=approot%>/report/employee/export_excel/export_excel_list_lkpbu_806.jsp?year="+<%=year%>;    
                    var newWin = window.open(linkPage,"attdReportDaily","height=700,width=990,status=yes,toolbar=yes,menubar=no,resizable=yes,scrollbars=yes,location=yes"); 			
                    newWin.focus();
                }
                
                function cmdView()
                {
                    document.frmemplkpbu806.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frmemplkpbu806.action="list_lkpbu_806.jsp";
                    document.frmemplkpbu806.submit();
                }

                function MM_swapImgRestore() { //v3.0
                    var i,x,a=document.MM_sr; for(i=0;a && i < a.length && (x=a[i]) && x.oSrc;i++) x.src=x.oSrc;
                }

                function MM_preloadImages() { //v3.0
                    var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                        var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i < a.length; i++)
                            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
                    }

                    function MM_findObj(n, d) { //v4.0
                        var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0 && parent.frames.length) {
                            d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                        if(!(x=d[n]) && d.all) x=d.all[n]; for (i=0;!x && i < d.forms.length;i++) x=d.forms[i][n];
                        for(i=0;!x && d.layers && i < d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                        if(!x && document.getElementById) x=document.getElementById(n); return x;
                    }

                    function MM_swapImage() { //v3.0
                        var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                            if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
                    }

                    function cmdUpdateLevp(){
                        document.frmemplkpbu806.command.value="<%=Command.ADD%>";
                        document.frmemplkpbu806.action="list_lkpbu_806.jsp"; 
                        document.frmemplkpbu806.submit();
                    }
        </script>
        <!-- #BeginEditable "styles" --> 
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "stylestab" --> 
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "headerscript" --> 
        <!-- #EndEditable -->
    </head>

    <body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnSearchOn.jpg','<%=approot%>/images/BtnNewOn.jpg')">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
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
                    <table width="100%" border="0" cellspacing="3" cellpadding="2"> 
                        <tr> 
                            <td width="100%">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
                                    <tr> 
                                        <td height="20">
                                            <font color="#FF6600" face="Arial"><strong>
                                                <!-- #BeginEditable "contenttitle" --> 
                                                Report &gt;Employee &gt; LKPBU Form 806 <!-- #EndEditable --> 
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
                                                                                <form name="frmemplkpbu806" method="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <table width="60%" border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr> 
                                                                                            <td width="18%" nowrap> 
                                                                                                <div align="left"></div>
                                                                                            </td>
                                                                                            <td><select name="year">
                                                                                                    <%
                                                                                                        int tahun = Calendar.getInstance().get(Calendar.YEAR);
                                                                                                        for (int i = tahun; 1990 < i; i--) {
                                                                                                    %>

                                                                                                    <option value="<%=i%>"><%=i%></option>

                                                                                                    <%
                                                                                                        }
                                                                                                    %>
                                                                                                </select>
                                                                                            </td>  
                                                                                            <td width="3%">&nbsp;</td>
                                                                                            <td width="78%"> 
                                                                                                <table border="0" cellspacing="0" cellpadding="0" width="197">
                                                                                                    <tr> 
                                                                                                        <td width="24"><a href="javascript:cmdView()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/BtnSearchOn.jpg',1)" id="aSearch"><img name="Image10" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="View Report LKPBU 806"></a></td>
                                                                                                        <td width="10"><img src="<%=approot%>/images/spacer.gif" width="4" height="1"></td>
                                                                                                        <td width="163" class="command" nowrap><a href="javascript:cmdView()">View LKPBU 806 Report</a></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>									  


                                                                                    <%
                                                                                        if (iCommand == Command.LIST) {
                                                                                    %>
                                                                                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr>
                                                                                            <td><hr></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                        <table class="listgen" width="100%">
                                                                                            <tr>
                                                                                                <td class="listgentitle" style="text-align: center">Sandi Pelapor</td>
                                                                                                <td class="listgentitle" style="text-align: center">Jenis Periode Pelaporan</td>
                                                                                                <td class="listgentitle" style="text-align: center">Periode Data Pelaporan</td>
                                                                                                <td class="listgentitle" style="text-align: center">Jenis Laporan</td>
                                                                                                <td class="listgentitle" style="text-align: center">No Form</td>
                                                                                                <td class="listgentitle" style="text-align: center">Jumlah Record Isi</td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="listgensell" style="text-align: center"><%="" + sandiPelapor%></td>
                                                                                                <td class="listgensell" style="text-align: center">A</td>
                                                                                                <td class="listgensell" style="text-align: center"><%=year + "0101"%></td>
                                                                                                <td class="listgensell" style="text-align: center">A</td>
                                                                                                <td class="listgensell" style="text-align: center">806</td>
                                                                                                <td class="listgensell" style="text-align: center"><%=vListResult.size()%></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="listgentitle" style="text-align: center">Jenis Pelatihan</td>
                                                                                                <td class="listgentitle" style="text-align: center" colspan="5">Jumlah SDM</td>
                                                                                            </tr>
                                                                                            <%

                                                                                                for (int i = 0; i < vListResult.size(); i++) {
                                                                                                    Lkpbu lkpbu = (Lkpbu) vListResult.get(i);
                                                                                            %>
                                                                                            <tr>
                                                                                                <td class="listgensell" style="text-align: center"><%=lkpbu.getCode()%></td>    
                                                                                                <td class="listgensell" style="text-align: center" colspan="5"><%=lkpbu.getTrainAteendes()%></td>
                                                                                            </tr>


                                                                                            <%
                                                                                                }

                                                                                            %>        

                                                                                        </table>
                                                                                        </tr>

                                                                                        <%
                                                                                            if (vListResult.size() > 0 && privPrint) {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td class="command">
                                                                                                <table border="0" cellspacing="0" cellpadding="0" width="197">
                                                                                                    <tr>
                                                                                                        <td width="24"><a href="javascript:cmdExportExcel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image110','','<%=approot%>/images/BtnNewOn.jpg',1)" id="aSearch"><img name="Image110" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Print Report"></a></td>
                                                                                                        <td width="10"><img src="<%=approot%>/images/spacer.gif" width="4" height="1"></td>
                                                                                                        <td width="163" class="command" nowrap><a href="javascript:cmdExportExcel()">Export to Excel</a></td>
                                                                                                    </tr>
                                                                                                </table></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }
                                                                                        %>
                                                                                    </table>
                                                                                    <%
                                                                                        }
                                                                                    %>
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
</html>


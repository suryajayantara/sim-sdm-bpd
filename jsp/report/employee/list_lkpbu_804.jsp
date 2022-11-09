<%-- 
    Document   : list_lkpbu_804
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

        ctrlist.addHeader("Kategori Pegawai Berhenti", "2%", "2", "");
        ctrlist.addHeader("Jenis Jabatan", "2%", "2", "");
        ctrlist.addHeader("Jumlah Tenaga Kerja", "2%", "", "2");
        ctrlist.addHeader("Laki-laki", "2%", "0", "0");
        ctrlist.addHeader("Perempuan", "2%", "0", "0");


        ctrlist.setLinkRow(-1);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();

        Vector rowx = new Vector(1, 1);
        String codeCategory = "";
        String codeJabatan = "";
        String newCategory = "";
        String newJabatan = "";
        int totalLaki = 0;
        int totalPerempuan = 0;

        for (int i = 0; i < listEmployee.size(); i++) {
            Lkpbu lkpbu = (Lkpbu) listEmployee.get(i);
            rowx = new Vector(1, 1);

            if (i == 0) {
                codeCategory = lkpbu.getResignCategory();
                if (codeCategory == null) {
                    codeCategory = "";
                }
                codeJabatan = lkpbu.getJenisJabatan();
                if (codeJabatan == null) {
                    codeJabatan = "";
                }
            }

            newCategory = lkpbu.getResignCategory();
            if (newCategory == null) {
                newCategory = "";
            }
            newJabatan = lkpbu.getJenisJabatan();
            if (newJabatan == null) {
                newJabatan = "";
            }

            if (newCategory.equals(codeCategory) && newJabatan.equals(codeJabatan)) {
                if (lkpbu.getEmpSex() == PstEmployee.MALE) {
                    totalLaki++;
                } else {
                    totalPerempuan++;
                }

                if (i == (listEmployee.size() - 1)) {
                    rowx.add(codeCategory);
                    rowx.add(codeJabatan);
                    rowx.add("" + totalLaki);
                    rowx.add("" + totalPerempuan);

                    lstData.add(rowx);
                    lstLinkData.add("0");
                }

            } else {
                rowx.add(codeCategory);
                rowx.add(codeJabatan);
                rowx.add("" + totalLaki);
                rowx.add("" + totalPerempuan);

                codeCategory = lkpbu.getResignCategory();
                codeJabatan = lkpbu.getJenisJabatan();
                totalLaki = 0;
                totalPerempuan = 0;
                i--;

                lstData.add(rowx);
                lstLinkData.add("0");
            }
        }

        return ctrlist.drawList();
    }
%>

<%
    int iCommand = FRMQueryString.requestCommand(request);
    int year = FRMQueryString.requestInt(request, "year");

    String whereClause = PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED_DATE]+" LIKE '%"+year+"%'";
    Vector listEmployee = PstEmployee.list(0, 0, whereClause, "");
    Vector vListResult = new Vector(1, 1);
    Vector listLkpbu = new Vector();
    HashMap<String, Lkpbu> mapLkpbu804= new HashMap<String, Lkpbu>();
    
    if(iCommand == Command.LIST){
    //vListResult = PstLkpbu.lkpbu(year);
    Vector listEmp = PstLkpbu.listEmployeee803(year);
    if (listEmp.size() == 0){
        listEmp = PstLkpbu.listCurrentEmployeee803(year);
    }
     mapLkpbu804 = PstLkpbu.getLkpbu804V2(listEmployee);
    
    session.putValue("listresult", mapLkpbu804);
    }

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>HARISMA - LKPBU 804 Report</title>
        <script language="JavaScript">
            <%if (iCommand == Command.PRINT) {%>
                //com.dimata.harisma.report.listRequest	
                window.open("<%=printroot%>.report.listRequest.ListEmpEducationPdf");
            <%}%>

                function cmdAdd(){
                    document.frmemplkpbu804.command.value="<%=Command.ADD%>";
                    document.frmemplkpbu804.action="list_lkpbu_804.jsp";
                    document.frmemplkpbu804.submit();
                }

                function reportPdf(){
                    document.frmemplkpbu804.command.value="<%=Command.PRINT%>";
                    document.frmemplkpbu804.action="list_lkpbu_804.jsp";
                    document.frmemplkpbu804.submit();
                }

                function cmdSearch(){
                    document.frmemplkpbu804.command.value="<%=Command.LIST%>";
                    document.frmemplkpbu804.action="list_lkpbu_804.jsp";
                    document.frmemplkpbu804.submit();
                }

                function cmdSpecialQuery(){
                    document.frmemplkpbu804.action="specialquery.jsp";
                    document.frmemplkpbu804.submit();
                }

                function fnTrapKD(){
                    if (event.keyCode == 13) {
                        document.all.aSearch.focus();
                        cmdSearch();
                    }
                }
                function cmdExportExcel(){
                 
                    var linkPage = "<%=approot%>/report/employee/export_excel/export_excel_list_lkpbu_804.jsp?year="+<%=year%>;  
                    var newWin = window.open(linkPage,"attdReportDaily","height=700,width=990,status=yes,toolbar=yes,menubar=no,resizable=yes,scrollbars=yes,location=yes"); 			
                    newWin.focus();
                }
                
                function cmdView()
                {
                    document.getElementById('form').removeAttribute('target');
                    document.frmemplkpbu804.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frmemplkpbu804.action="list_lkpbu_804.jsp";
                    document.frmemplkpbu804.submit();
                }
                
                function cmdViewDetail(arrayList, sex){
                    var string = arrayList.replace(/[^\w,]/gi, '');
                    document.getElementById('form').setAttribute('target', '_blank')
                    document.frmemplkpbu804.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frmemplkpbu804.FRM_FIELD_EMPLOYEE_ID.value=string;
                    document.frmemplkpbu804.FRM_FIELD_SEX.value=sex;
                    document.frmemplkpbu804.FRM_FIELD_RESIGNED.value=2;
                    document.frmemplkpbu804.action="<%=approot%>/employee/databank/employee_list.jsp";
                    document.frmemplkpbu804.submit();
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
                        document.frmemplkpbu804.command.value="<%=Command.ADD%>";
                        document.frmemplkpbu804.action="list_lkpbu_804.jsp"; 
                        document.frmemplkpbu804.submit();
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
                                                Report &gt;Employee &gt; LKPBU Form 804 <!-- #EndEditable --> 
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
                                                                                <form name="frmemplkpbu804" id="form" method="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <input type="hidden" name="FRM_FIELD_EMPLOYEE_ID" value="">
                                                                                    <input type="hidden" name="FRM_FIELD_SEX" value="">
                                                                                    <input type="hidden" name="FRM_FIELD_RESIGNED" value="">
                                                                                    <table width="60%" border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr> 
                                                                                            <td width="18%" nowrap> 
                                                                                                <div align="left"></div>
                                                                                            </td>
                                                                                            <td width="3%">&nbsp;</td>
                                                                                            <td width="78%"> 
                                                                                                <table border="0" cellspacing="0" cellpadding="0" width="197">
                                                                                                    <tr>
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
                                                                                                        <td width="24"><a href="javascript:cmdView()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/BtnSearchOn.jpg',1)" id="aSearch"><img name="Image10" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="View Report LKPBU 804"></a></td>
                                                                                                        <td width="10"><img src="<%=approot%>/images/spacer.gif" width="4" height="1"></td>
                                                                                                        <td width="163" class="command" nowrap><a href="javascript:cmdView()">View LKPBU 804 Report</a></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>									  


                                                                                    <%
                                                                                        if (iCommand == Command.LIST && !mapLkpbu804.isEmpty()) {
                                                                                            String sandiPelapor = PstSystemProperty.getValueByName("LKPBU_SANDI_PELAPOR");
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
                                                                                                <td class="listgensell" style="text-align: center">804</td>
                                                                                                <td class="listgensell" style="text-align: center"><%=mapLkpbu804.size()%></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="listgentitle" style="text-align: center" rowspan="2">Kategori Pegawai Berhenti</td>
                                                                                                <td class="listgentitle" style="text-align: center" rowspan="2">Jenis Jabatan</td>
                                                                                                <td class="listgentitle" style="text-align: center" colspan="4">Jumlah Tenaga Kerja</td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="listgentitle" style="text-align: center" colspan="2">Laki-Laki</td>
                                                                                                <td class="listgentitle" style="text-align: center" colspan="2">Perempuan</td>
                                                                                            </tr>
                                                                                            <%
                                                                                                if (!mapLkpbu804.isEmpty()) {

                                                                                                    Lkpbu[] stringArray = new Lkpbu[listLkpbu.size()];
                                                                                                    for (int i = 0; i < listLkpbu.size(); i++) {
                                                                                                        stringArray[i] = (Lkpbu) listLkpbu.get(i);
                                                                                                    }
                                                                                                    Arrays.sort(stringArray, Lkpbu.LkpbuCompare);

                                                                                                    Map<String, Lkpbu> sorted = new TreeMap<String, Lkpbu>(mapLkpbu804);
                                                                                                    for(Lkpbu temp: sorted.values()){


                                                                                                    %>
                                                                                                        <tr>
                                                                                                        <td class="listgensell" style="text-align: center"><%=temp.getResignCategory()%></td>
                                                                                                        <td class="listgensell" style="text-align: center"><%=temp.getJenisJabatan()%></td>
                                                                                                        <td class="listgensell" style="text-align: center" colspan="2"><a href="javascript:cmdViewDetail('<%=temp.getIdLaki()%>',0)"><%=temp.getJumlahLaki()%></a></td>
                                                                                                        <td class="listgensell" style="text-align: center" colspan="2"><a href="javascript:cmdViewDetail('<%=temp.getIdPerempuan()%>',1)"><%=temp.getJumlahPerempuan()%></a></td>
                                                                                                    </tr>
                                                                                                    <%  }
                                                                                            %>
                                                                                            <%

                                                                                                }
                                                                                                if (privPrint) {
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


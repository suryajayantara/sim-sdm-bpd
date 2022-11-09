<%-- 
    Document   : candidate_template
    Created on : Aug 26, 2016, 4:09:36 PM
    Author     : Dimata 007
--%>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_CANDIDATE, AppObjInfo.OBJ_CANDIDATE_SEARCH); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pencarian Kandidat</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            body {
                font-family: sans-serif;
                font-size: 12px;
                color: #474747;
                background-color: #EEE;
                padding: 21px;
            }
            .tblStyle {
                padding: 5px;
            }
            .title_tbl {
                font-weight: bold;
                padding-right: 11px;
            }
            .title {
                background-color: #FFF;
                border-left: 1px solid #007592;
                padding: 11px;
            }
            .tbl-style {border-collapse: collapse; font-size: 12px;}
            .tbl-style td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px;}
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
            .btn-small {
                font-weight: bold;
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 9px; 
                background-color: #FFF; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
                border:1px solid #DDD;
                margin: 5px 0px;
            }
            .btn-small:hover { background-color: #D5D5D5; color: #474747; border:1px solid #CCC;}
            .content-main {
                padding: 21px 11px;
                margin: 0px 23px 59px 23px;
            }
            #item {
                background-color: #DDD;
                color:#575757;
                font-weight: bold;
                padding: 5px 7px;
                border-radius: 3px;
                margin: 1px 0px;
            }
            #close {
                background-color: #EB9898;
                color: #B83916;
                font-weight: bold;
                padding: 5px 7px;
                border-radius: 3px;
                cursor: pointer;
                margin: 1px 5px 1px 2px;
            }
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
        </style>
        <script type="text/javascript">
            function cmdAddResource(){
                document.frm.action="organization_selection.jsp";
                document.frm.submit();
            }
            function cmdAddGrade(){
                newWindow=window.open("grade_data.jsp","GradeData", "height=600,width=500,status=yes,toolbar=no,menubar=no,location=center,scrollbars=yes");
                newWindow.focus();
            }
            function cmdAddTraining(){
                document.frm.action="training_selection.jsp";
                document.frm.submit();
            }
            function cmdAddEducation(){
                document.frm.action="education_selection.jsp";
                document.frm.submit();
            }
            function cmdAddExperience(){
                document.frm.action="experience_selection.jsp";
                document.frm.submit();
            }
            function cmdAddPosition(){
                document.frm.action="position_selection.jsp";
                document.frm.submit();
            }
        </script>
    </head>
    <body>
        <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
            </table>
        </div>
        <div id="menu_utama">
            <span id="menu_title"><strong>Masterdata</strong> <strong style="color:#333;"> / </strong>Document</span>
        </div>
        <div class="content-main">
            <form name="frm" method ="post" action="">
                <input type="hidden" name="command" value="" />
                <h1>Pencarian Kandidat</h1>
                <div class="title">Information dasar</div>
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl">Diminta oleh</td>
                        <td>
                            <input type="hidden" name="requested" value="" />
                            <div id="item">I Nyoman Sudharma</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="title_tbl">Judul dokumen</td>
                        <td> <input type="text" name="title_doc" value="" size="50" /> </td>
                    </tr>
                    <tr>
                        <td class="title_tbl">Tanggal</td>
                        <td> <input type="text" name="tanggal" value="" /> </td>
                    </tr>
                </table>
                <div>&nbsp;</div>
                <a href="javascript:cmdSave()" style="color:#FFF;" class="btn">Simpan dan Lanjutkan</a>
                <div>&nbsp;</div>
                <div class="title">Dilokasikan (optional)</div>
                <div>&nbsp;</div>
                <a href="javascript:cmdAddLocation()" class="btn-small">Tambah Penempatan</a>
                <div>&nbsp;</div>
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td><div id="item">Penilaian Sosial</div></td>
                        <td><div id="close">&times;</div></td>
                        <td>Yakin hapus data? Ya / Tidak</td>
                    </tr>
                    <tr>
                        <td><div id="item">Penilaian Kepribadian</div></td>
                        <td><div id="close">&times;</div></td>
                        <td>Yakin hapus data? Ya / Tidak</td>
                    </tr>
                </table>
                <div>&nbsp;</div>
                <div class="title">Filter pencarian</div>
                <div>&nbsp;</div>
                <a href="javascript:cmdAddGrade()" class="btn-small">Tambah Filter Grade</a>
                <div>&nbsp;</div>
                <div>&nbsp;</div>
                <a href="javascript:cmdAddPenilaian()" class="btn-small">Tambah Filter Penilaian</a>
                <div>&nbsp;</div>
                <div>&nbsp;</div>
                <a href="javascript:cmdAddTraining()" class="btn-small">Tambah Filter Diklat</a>
                <div>&nbsp;</div>
                <div>&nbsp;</div>
                <a href="javascript:cmdAddEducation()" class="btn-small">Tambah Filter Pendidikan</a>
                <div>&nbsp;</div>
                <div>&nbsp;</div>
                <a href="javascript:cmdAddExperience()" class="btn-small">Tambah Filter Pengalaman</a>
                <div>&nbsp;</div>
                <div>&nbsp;</div>
                <a href="javascript:cmdAddPosition()" class="btn-small">Tambah Filter Jabatan</a>
                <div>&nbsp;</div>
                <div>&nbsp;</div>
                <div class="title">Sumber pencarian</div>
                <div>&nbsp;</div>
                <a href="javascript:cmdAddResource()" class="btn-small">Tambah Sumber Pencarian</a>
                <div>&nbsp;</div>
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td><div id="item">Penilaian Sosial</div></td>
                        <td><div id="close">&times;</div></td>
                        <td>Yakin hapus data? Ya / Tidak</td>
                    </tr>
                    <tr>
                        <td><div id="item">Penilaian Kepribadian</div></td>
                        <td><div id="close">&times;</div></td>
                        <td>Yakin hapus data? Ya / Tidak</td>
                    </tr>
                </table>
                <div>&nbsp;</div>
                <div style="border-top:1px solid #CCC;">&nbsp;</div>
                <div>&nbsp;</div>
                <a href="" class="btn">Simpan dan Proses</a>
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

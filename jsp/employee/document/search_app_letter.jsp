<%-- 
    Document   : search_app_letter
    Created on : Nov 8, 2016, 11:16:07 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.recruitment.RecrApplication"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.recruitment.PstRecrApplication"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidEmpDoc = FRMQueryString.requestLong(request,"oid_emp_doc");
    long oidRecrApp = FRMQueryString.requestLong(request, "oid_recr_app");
    String objectName = FRMQueryString.requestString(request,"object_name");
    String name = FRMQueryString.requestString(request, "full_name");
    String position = FRMQueryString.requestString(request, "position");
    String whereClause = "";
    String order = "";
    Vector peopleList = new Vector();
    if (iCommand == Command.SEARCH){
        if (name.length()>0){
            whereClause = PstRecrApplication.fieldNames[PstRecrApplication.FLD_FULL_NAME]+" LIKE '%"+name+"%'";
        } else {
            if (position.length()>0){
                whereClause = PstRecrApplication.fieldNames[PstRecrApplication.FLD_POSITION]+"='"+position+"'"; 
            }
        }
        order = PstRecrApplication.fieldNames[PstRecrApplication.FLD_FULL_NAME];
        peopleList = PstRecrApplication.list(0, 0, whereClause, order); 
    }
    long oidInsert = 0;
    if (iCommand == Command.SAVE){
        EmpDocList empDocList = new EmpDocList();
        empDocList.setEmp_doc_id(oidEmpDoc);
        empDocList.setEmployee_id(oidRecrApp);
        empDocList.setObject_name(objectName);
        try {
            oidInsert = PstEmpDocList.insertExc(empDocList);
        } catch(Exception e){
            System.out.println(e.toString());
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Employee From App Letter</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            body {
                margin: 0;
                padding: 0;
                font-size: 12px;
                font-family: sans-serif;
            }
            
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; background-color: #FFF;}
            
            .header {
                background-color: #EEE;
                padding: 21px;
                border-bottom: 1px solid #DDD;
            }
            .content {
                padding: 21px;
            }
            #caption, .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput, .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
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
            
            .btn-small {
                background-color: #DDD;
                border-radius: 3px;
                font-family: Arial;
                color: #575757;
                font-size: 11px;
                padding: 5px 7px;
                text-decoration: none;
            }

            .btn-small:hover {
                color: #474747;
                background-color: #CCC;
                text-decoration: none;
            }
            
            .item {
                background-color: #EEE;
                padding: 9px;
                margin: 9px 15px;
            }
            .title {
                color: #EEE;
                background-color: #474747;
                padding: 7px 9px;
                border-radius: 3px;
                margin: 5px 0px;
            }
        </style>
<script type="text/javascript">
    function cmdSearch(){
        document.frm.command.value="<%= Command.SEARCH %>";
        document.frm.action="search_app_letter.jsp";
        document.frm.submit();
    }
    function cmdGetIt(oid){
        document.frm.command.value="<%= Command.SAVE %>";
        document.frm.oid_recr_app.value=oid;
        document.frm.action="search_app_letter.jsp";
        document.frm.submit();
    }
</script>
    </head>
    <body>
        <div class="header">
            <h2 style="color:#999">Cari dari Surat Lamaran (Penerimaan)</h2>
            
        </div>
        <div class="content">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="" />
                <input type="hidden" name="oid_emp_doc" value="<%= oidEmpDoc %>" />
                <input type="hidden" name="object_name" value="<%= objectName %>" />
                <input type="hidden" name="oid_recr_app" value="" />
                <div class="caption">Nama</div>
                <div class="divinput">
                    <input type="text" name="full_name" size="50" />
                </div>
                <div class="caption">Jabatan</div>
                <div class="divinput">
                    <select id="position" name="position">
                        <option value="0">-select-</option>
                        <%
                        whereClause = PstPosition.fieldNames[PstPosition.FLD_VALID_STATUS]+"=";
                        whereClause += PstPosition.VALID_ACTIVE;
                        order = PstPosition.fieldNames[PstPosition.FLD_POSITION];
                        Vector listPosition = PstPosition.list(0, 0, whereClause, order);
                        if (listPosition != null && listPosition.size()>0){
                            for(int i=0; i<listPosition.size(); i++){
                                Position jabatan = (Position)listPosition.get(i);
                                %>
                                <option value="<%= jabatan.getPosition() %>"><%= jabatan.getPosition() %></option>
                                <%
                            }
                        }
                        %>
                    </select>
                </div>
                <div>&nbsp;</div>
                <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Search</a>
            </form>
            <div>&nbsp;</div>
            <div class="title">Daftar Pelamar Kerja : <%= oidInsert %></div>
            <table class="tblStyle">
                <tr>
                    <td><strong>Nama</strong></td>
                    <td><strong>Jabatan</strong></td>
                    <td>&nbsp;</td>
                </tr>
                <%
                if (peopleList != null && peopleList.size()>0){
                    for(int i=0; i<peopleList.size(); i++){
                        RecrApplication people = (RecrApplication)peopleList.get(i);
                        %>
                        <tr>
                            <td><%= people.getFullName() %></td>
                            <td><%= people.getPosition() %></td>
                            <td><a href="javascript:cmdGetIt('<%= people.getOID() %>')" class="btn-small" style="color:#575757;">Get it</a></td>
                        </tr>
                        <%
                    }
                }
                %>
            </table>
        </div>
    </body>
</html>

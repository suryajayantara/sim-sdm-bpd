<%-- 
    Document   : document_custom_exps_add
    Created on : Feb 16, 2021, 1:25:16 PM
    Author     : gndiw
--%>

<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlEmpDocListExpense"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<!DOCTYPE html>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidDocExpense = FRMQueryString.requestLong(request, "oid_doc_expense");
    long oidEmpDoc = FRMQueryString.requestLong(request,"oid_emp_doc");
    long employeeId = FRMQueryString.requestLong(request, "employee");
    String objectName = FRMQueryString.requestString(request,"object_name"); 
    String name = FRMQueryString.requestString(request, "nama1");
    String name2 = FRMQueryString.requestString(request, "nama2");
    double nominal = FRMQueryString.requestDouble(request, "nominal");
    long compId = FRMQueryString.requestLong(request, "comp");
    long oidInsert = 0;
    
    if (iCommand == Command.SAVE){
        try {
            EmpDocListExpense empDoc = new EmpDocListExpense();
            empDoc.setEmpDocId(oidEmpDoc);
            empDoc.setEmployeeId(employeeId);
            empDoc.setComponentId(compId);
            empDoc.setCompValue(nominal);
            empDoc.setObjectName(name+";"+name2);
            oidInsert = PstEmpDocListExpense.insertExc(empDoc);
        } catch (Exception exc){}
        iCommand = Command.LIST;
    }
    
    if (iCommand == Command.DELETE){
        try {
            PstEmpDocListExpense.deleteExc(oidDocExpense);
        } catch (Exception exc){}
        iCommand = Command.LIST;
    }
    
    String whereDocExps = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+"="+oidEmpDoc;
    Vector listDocExps = PstEmpDocListExpense.list(0, 0, whereDocExps, "");
    String inEmp = "";
    for (int exp=0; exp < listDocExps.size(); exp++){
        EmpDocListExpense empExps = (EmpDocListExpense) listDocExps.get(exp);
        if (inEmp.length()>0){
            inEmp += ",";
        }
        inEmp += ""+empExps.getEmployeeId();
    }
    
    String whereEmp = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+
            " IN ("+inEmp+")";
    Vector listEmployee = PstEmployee.list(0, 0, whereEmp, "");
    
    String whereExpComp = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+"="+oidEmpDoc
            +" AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]+"="+employeeId;
    Vector listExpComp = PstEmpDocListExpense.list(0, 0, whereExpComp, "");
    String inComp = "";
    for (int exp=0; exp < listExpComp.size(); exp++){
        EmpDocListExpense empExps = (EmpDocListExpense) listExpComp.get(exp);
        if (inComp.length()>0){
            inComp += ",";
        }
        inComp += ""+empExps.getComponentId();
    }
    String whereComp = PstPayComponent.fieldNames[PstPayComponent.FLD_COMPONENT_ID]+
            " IN ("+inComp+")";
    Vector listPayComp = PstPayComponent.list(0, 0, whereComp, "");
    
    
    Vector listEmpDocExpense = new Vector();
    String where = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID] + " = " + oidEmpDoc;
    if (objectName.equals("KELEBIHAN")){
        where += " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME] + " != 'DEBET'";
    } else if (objectName.equals("KEKURANGAN")){
        where += " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME] + " != 'KREDIT'";
    }
    String order = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID];
    listEmpDocExpense = PstEmpDocListExpense.list(0, 0, where, order);
    
    
    
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Document Employee Search</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
         <%@ include file = "../../main/konfigurasi_jquery.jsp" %>    
        <script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <style type="text/css">
            body {
                margin: 0;
                padding: 0;
                font-size: 12px;
                font-family: sans-serif;
            }
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
            
            .item {
                background-color: #EEE;
                padding: 9px;
                margin: 9px 15px;
            }
            
            .btn-small {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
                border: 1px solid #DDD;
            }
            .btn-small:hover { background-color: #DDD; color: #474747;}
            
            .tblStyle {border-collapse: collapse; font-size: 12px;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}
            
            #confirm {
                padding: 5px 7px;
                background-color: #FF6666;
                color: #FFF;
                border-radius: 3px;
                font-size: 12px;
                font-weight: bold;
                margin-bottom: 5px;
            }
            #btn-confirm {
                padding: 3px 5px; border-radius: 2px;
                background-color: #CF5353; color: #FFF; 
                font-size: 11px; cursor: pointer;
            }
        </style>
        <script language="JavaScript">

            function cmdRefresh(){
                    document.frm.command.value="<%=String.valueOf(Command.GOTO)%>";
                    document.frm.action="document_custom_exps_add.jsp";
                    document.frm.submit();
            }
            
            function cmdAdd(){
                document.frm.command.value="<%=String.valueOf(Command.SAVE)%>";
                document.frm.action="document_custom_exps_add.jsp";
                document.frm.submit();
            }

            function cmdAskDelete(oid){
                document.frm.oid_doc_expense.value=oid;
                document.frm.command.value="<%=Command.ASK%>";
                document.frm.action="document_custom_exps_add.jsp";
                document.frm.submit();
            }

            function cmdDelete(oid){
                document.frm.oid_doc_expense.value=oid;
                document.frm.command.value="<%=Command.DELETE%>";
                document.frm.action="document_custom_exps_add.jsp";
                document.frm.submit();
            }
        </script>
    </head>
    <body>
        <div class="header">
            <h2 style="color:#999">Tambah Komponen</h2>
            <%
            if (oidInsert != 0){
                %>
                <div style="padding: 9px; background-color: #DDD;">Data Berhasil disimpan</div>
                <%
            }
            %>
        </div>
        <div class="content">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="oid_emp_doc" value="<%= oidEmpDoc %>" />
                <input type="hidden" name="oid_doc_expense" value="0"/>
                <input type="hidden" name="object_name" value="<%= objectName %>"/>
                <table width="100%">
                    <tr>
                        <td valign="top" width="50%">
                            <div id="caption">Karyawan</div>
                            <div id="divinput">
                                <select id="employee" name="employee" class="chosen-select" onchange="javascript:cmdRefresh()">
                                    <option value="0">-select-</option>
                                    <%
                                    if (listEmployee != null && listEmployee.size()>0){
                                        for(int i=0; i<listEmployee.size(); i++){
                                            Employee emp = (Employee)listEmployee.get(i);
                                            %>
                                            <option value="<%= emp.getOID() %>" <%=(employeeId == emp.getOID() ? "selected" : "")%>>[<%=emp.getEmployeeNum()%>] <%= emp.getFullName()%></option>
                                            <%
                                        }
                                    }
                                    %>
                                </select>
                            </div>
                            <div id="caption">Komponen</div>
                            <div id="divinput">
                                <select id="comp" name="comp" class="chosen-select">
                                    <option value="0">-select-</option>
                                    <%
                                    if (listPayComp != null && listPayComp.size()>0){
                                        for(int i=0; i<listPayComp.size(); i++){
                                            PayComponent payComp = (PayComponent)listPayComp.get(i);
                                            %>
                                            <option value="<%= payComp.getOID() %>"><%= payComp.getCompName() %></option>
                                            <%
                                        }
                                    }
                                    %>
                                </select>
                            </div>
                            <div id="caption">Text 1</div>    
                            <div id="divinput">
                                <textarea name="nama1" id="nama1" value="" ></textarea>
                            </div>
                             <div id="caption">Text 2</div>    
                            <div id="divinput">
                                <textarea name="nama2" id="nama2" value="" ></textarea>
                            </div>
                            <div id="caption">Nominal</div>    
                            <div id="divinput">
                                <input type="text" name="nominal" id="nominal" value=""/>
                            </div>
                            <div>&nbsp;</div>
                            <a class="btn" style="color:#FFF" href="javascript:cmdAdd()">Tambah</a>
                            <div>&nbsp;</div>
                            <% if (iCommand == Command.ASK){ %>
                            <div id="confirm">
                                Are you sure? 
                                <a href="javascript:cmdDelete('<%= oidDocExpense %>')" id="btn-confirm">Yes</a> | 
                                <a href="javascript:cmdNoDelete()" id="btn-confirm">No</a>
                            </div>
                            <div>&nbsp;</div>
                            <% } %>
                            <%
                                    if (listEmpDocExpense.size()>0){
                            %>
                            <table class="tblStyle">
                                <tr>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">NRK</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Nama Karyawan</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Komponen</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Text 1</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Text 2</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Nominal</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Action</td>
                                </tr>
                                <%
                                    Employee emp = new Employee();
                                    PayComponent payCom = new PayComponent();
                                    PayPeriod period = new PayPeriod();
                                    for (int i=0;i < listEmpDocExpense.size(); i++){
                                    EmpDocListExpense docExpense = (EmpDocListExpense) listEmpDocExpense.get(i);
                                    try {
                                        emp = PstEmployee.fetchExc(docExpense.getEmployeeId());
                                    } catch (Exception exc){}
                                    
                                    try {
                                        payCom = PstPayComponent.fetchExc(docExpense.getComponentId());
                                    } catch (Exception exc){}
                                    
                                    String text1 = "";
                                    String text2 = "";
                                    try {
                                        String[] arrTxt = docExpense.getObjectName().split(";");
                                        for (int x = 0; x < arrTxt.length; x++){
                                            if (x==0){ text1 = arrTxt[x];}
                                            if (x==1){ text2 = arrTxt[x];}
                                        }
                                    } catch (Exception exc){}
                                    
                                %>
                                    <tr>
                                        <td style="background-color: #FFF;"><%=i+1%></td>
                                        <td style="background-color: #FFF;"><%=emp.getEmployeeNum()%></td>
                                        <td style="background-color: #FFF;"><%=emp.getFullName()%></td>
                                        <td style="background-color: #FFF;"><%=payCom.getCompName()%></td>
                                        <td style="background-color: #FFF;"><%=text1%></td>
                                        <td style="background-color: #FFF;"><%=text2%></td>
                                        <td style="background-color: #FFF;"><%=Formater.formatNumberMataUang(docExpense.getCompValue(), "Rp")%></td>
                                        <td style="background-color: #FFF;"><a class="btn-small" href="javascript:cmdAskDelete('<%=docExpense.getOID()%>')" style="color: #575757;">Delete</a></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                            </table>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </body>
</html>

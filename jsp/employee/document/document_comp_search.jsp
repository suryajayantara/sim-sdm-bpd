<%-- 
    Document   : document_comp_search
    Created on : 17-Feb-2017, 09:02:02
    Author     : Gunadi
--%>

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
    long oidEmpDoc = FRMQueryString.requestLong(request,"oid_emp_doc");
    String objectName = FRMQueryString.requestString(request,"object_name");
    String empId = FRMQueryString.requestString(request, "oid_emp");
    long oidDocExpense = FRMQueryString.requestLong(request, "oid_doc_expense");
    String empObjectName = FRMQueryString.requestString(request,"emp_object_name");
    long periodId = FRMQueryString.requestLong(request, "period");
    String[] employee = empId.split(",");
    int iCommand = FRMQueryString.requestCommand(request);
    
    long componentId = FRMQueryString.requestLong(request, "comp");
    int dayLength = FRMQueryString.requestInt(request, "day");
    
    
    CtrlEmpDocListExpense ctrlEmpDocListExpense = new CtrlEmpDocListExpense(request);
    int iErrCode = FRMMessage.NONE;
    iErrCode = ctrlEmpDocListExpense.action(iCommand , oidDocExpense);
    
    long oidInsert = 0;
    if (componentId > 0){
        for(int i=0; i<employee.length; i++){
            EmpDocListExpense empDocListExpense = new EmpDocListExpense();
            String whereDoc = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]+"="+employee[i]
                    +" AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+"="+oidEmpDoc
                    +" AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_PERIOD_ID]+"="+periodId
                    +" AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMPONENT_ID]+"="+componentId
                    +" AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+"='"+objectName+"'";
            Vector listExps = PstEmpDocListExpense.list(0, 0, whereDoc, "");
            if (listExps.size()>0){
                empDocListExpense = (EmpDocListExpense) listExps.get(0);
            }
            empDocListExpense.setEmpDocId(oidEmpDoc);
            empDocListExpense.setEmployeeId(Long.valueOf(employee[i]));
            empDocListExpense.setComponentId(componentId);
            empDocListExpense.setDayLength(dayLength);
            empDocListExpense.setObjectName(objectName);
            empDocListExpense.setPeriodeId(periodId);
            try {
                if (listExps.size()>0){
                    oidInsert = PstEmpDocListExpense.updateExc(empDocListExpense);
                } else {
                    oidInsert = PstEmpDocListExpense.insertExc(empDocListExpense);
                }
            } catch(Exception e){
                System.out.println(e.toString());
            }
        }
    }
    
    Vector listEmpDocExpense = new Vector();
    if (iCommand == Command.LIST || iCommand == Command.ASK){
        String where = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID] + " = " + oidEmpDoc;
        String order = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID];
        listEmpDocExpense = PstEmpDocListExpense.list(0, 0, where, order);
    }
               
    
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
<script type="text/javascript">

function check() {
    document.getElementsByClassName("myC").checked = true;
}

function uncheck() {
    document.getElementById("myCheck").checked = false;
}
function cmdAdd(){
    document.frm.action="document_comp_search.jsp";
    document.frm.submit();
}

function cmdView(){
    document.frm.command.value="<%=Command.LIST%>";
    document.frm.submit();
}

function cmdGoToSurat(oidEmpDoc, objectName){
    document.frm.action="search_app_letter.jsp?oid_emp_doc="+oidEmpDoc+"&object_name="+objectName;
    document.frm.submit();
}

function cmdAskDelete(oid){
    document.frm.oid_doc_expense.value=oid;
    document.frm.command.value="<%=Command.ASK%>";
    document.frm.action="document_comp_search.jsp";
    document.frm.submit();
}

function cmdDelete(oid){
    document.frm.oid_doc_expense.value=oid;
    document.frm.command.value="<%=Command.DELETE%>";
    document.frm.action="document_comp_search.jsp";
    document.frm.submit();
}

</script>
    </head>
    <body onload="pageLoad()">
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
                <input type="hidden" name="oid_emp_doc" value="<%= oidEmpDoc %>" />
                <input type="hidden" name="object_name" value="<%= objectName %>" />
                <input type="hidden" name="oid_emp" value="<%= empId %>"/>
                <input type="hidden" name="command" value="<%= Command.SAVE %>"/>
                <input type="hidden" name="oid_doc_expense" value="0"/>
                <table width="100%">
                    <tr>
                        <td valign="top" width="50%">
                            <div id="caption">Periode</div>
                            <div id="divinput">
                                <select id="period" name="period" class="chosen-select">
                                    <option value="0">-select-</option>
                                    <%
                                    String order = PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE]+" DESC";
                                    Vector listPeriod = PstPayPeriod.list(0, 0, "", order);
                                    if (listPeriod != null && listPeriod.size()>0){
                                        for(int i=0; i<listPeriod.size(); i++){
                                            PayPeriod period = (PayPeriod)listPeriod.get(i);
                                            %>
                                            <option value="<%= period.getOID() %>"><%= period.getPeriod()%></option>
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
                                    order = PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_NAME];
                                    Vector listComponent = PstPayComponent.list(0, 0, "", order);
                                    if (listComponent != null && listComponent.size()>0){
                                        for(int i=0; i<listComponent.size(); i++){
                                            PayComponent payComp = (PayComponent)listComponent.get(i);
                                            %>
                                            <option value="<%= payComp.getOID() %>"><%= payComp.getCompName() %></option>
                                            <%
                                        }
                                    }
                                    %>
                                </select>
                            </div>

                            <div id="caption"><%=(objectName.equals("PREVIOUS_BENEFIT") ? "Jumlah Pengali" : "Jumlah Hari")%></div>
                            <div id="divinput">
                                <input type="text" name="day" id="day" value=""/>
                            </div>
                            <div>&nbsp;</div>
                            <a class="btn" style="color:#FFF" href="javascript:cmdAdd()">Tambah</a>
                            <a class="btn" style="color:#FFF" href="javascript:cmdView()">Lihat Komponen</a>
                            <div>&nbsp;</div>
                            <% if (iCommand == Command.ASK){ %>
                            <div id="confirm">
                                Are you sure? 
                                <a href="javascript:cmdDelete('<%= oidDocExpense %>')" id="btn-confirm">Yes</a> | 
                                <a href="javascript:cmdNoDelete()" id="btn-confirm">No</a>
                            </div>
                            <% } %>
                            <%
                                if (iCommand == Command.LIST || iCommand == Command.ASK){
                                    if (listEmpDocExpense.size() >0) {
                            %>
                            <table class="tblStyle">
                                <tr>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">NRK</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Nama Karyawan</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Periode</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Komponen</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Jumlah Hari</td>
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
                                    } catch (Exception exc){
                                        
                                    }
                                    
                                    try {
                                        payCom = PstPayComponent.fetchExc(docExpense.getComponentId());
                                    } catch (Exception exc){
                                        
                                    
                                    }
                                    
                                    try {
                                        period = PstPayPeriod.fetchExc(docExpense.getPeriodeId());
                                    } catch (Exception exc){}
                                %>
                                    <tr>
                                        <td style="background-color: #FFF;"><%=i+1%></td>
                                        <td style="background-color: #FFF;"><%=emp.getEmployeeNum()%></td>
                                        <td style="background-color: #FFF;"><%=emp.getFullName()%></td>
                                        <td style="background-color: #FFF;"><%=period.getPeriod()%></td>
                                        <td style="background-color: #FFF;"><%=payCom.getCompName()%></td>
                                        <td style="background-color: #FFF;"><%=docExpense.getDayLength()%></td>
                                        <td style="background-color: #FFF;"><a class="btn-small" href="javascript:cmdAskDelete('<%=docExpense.getOID()%>')" style="color: #575757;">Delete</a></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                            </table>
                            <%      } else { %>
                                <div id="caption">No Component Avaliable</div>
                            <%
                                        
                                    }
                                }
                            %>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <script type="text/javascript">
                var config = {
                    '.chosen-select'           : {},
                    '.chosen-select-deselect'  : {allow_single_deselect:true},
                    '.chosen-select-no-single' : {disable_search_threshold:10},
                    '.chosen-select-no-results': {no_results_text:'Oops, nothing found!'},
                    '.chosen-select-width'     : {width:"100%"}
                }
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }
        </script>                             
    </body>
</html>

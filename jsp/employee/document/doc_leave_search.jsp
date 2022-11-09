<%-- 
    Document   : doc_leave_search
    Created on : Feb 23, 2021, 2:04:05 PM
    Author     : gndiw
--%>

<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.harisma.entity.leave.SpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.LlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLlStockTaken"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockTaken"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
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
<%!
    public int convertInteger(double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_UP);
        return bDecimal.intValue();
    }
    
    public String[] leaveType = {
        "Cuti Khusus", "Cuti Hamil", "Cuti Penting", "Cuti Tahunan", "Cuti Besar"
    };
    
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    
    long oidEmpDoc = FRMQueryString.requestLong(request,"oid_emp_doc");
    int tahun = FRMQueryString.requestInt(request, "tahun");
    String objectName = FRMQueryString.requestString(request, "object_name");
    long employeeId = FRMQueryString.requestLong(request, "employee_id");
    long leaveId = FRMQueryString.requestLong(request, "leave_id");
    long oidInsert = 0;
    
    Vector valTahun = new Vector();
    Vector keyTahun = new Vector();
    valTahun.add("0");
    keyTahun.add("Select..");
    Calendar calNow = Calendar.getInstance();
    for (int i=calNow.get(Calendar.YEAR) ; i >= 2000 ; i--){
        if (tahun == 0 && i == calNow.get(Calendar.YEAR)){
            tahun = i;
        }
        valTahun.add(""+i);
        keyTahun.add(""+i);
    }  
    
    if (iCommand == Command.SAVE){
        EmpDocList empDocList = new EmpDocList();
        empDocList.setEmp_doc_id(oidEmpDoc);
        empDocList.setEmployee_id(employeeId);
        empDocList.setObject_name(objectName);
        try {
            oidInsert = PstEmpDocList.insertExc(empDocList);
            LeaveApplication leaveApplication = PstLeaveApplication.fetchExc(leaveId);
            leaveApplication.setEmpDocId(oidEmpDoc);
            PstLeaveApplication.updateExc(leaveApplication);
            String whereExpenseAll = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidEmpDoc
                + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+"='PREVIOUS_BENEFIT'";
            Vector listExpenseAll = PstEmpDocListExpense.list(0, 0, whereExpenseAll, "");
            if (listExpenseAll.size()>0){
                EmpDocListExpense exps = (EmpDocListExpense) listExpenseAll.get(0);
                exps.setEmployeeId(employeeId);
                exps.setCompValue(0);
                PstEmpDocListExpense.insertExc(exps);
            }
        } catch(Exception e){
            System.out.println(e.toString());
        }
    }
    
    Vector listLeave = PstLeaveApplication.listAnnualOrLongLeaveNoDoc(tahun);
    
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
        <link rel="stylesheet" href="../../stylesheets/custom.css" >
        <script language="JavaScript">

            function cmdRefresh(){
                    document.frm.command.value="<%=String.valueOf(Command.GOTO)%>";
                    document.frm.action="doc_leave_search.jsp";
                    document.frm.submit();
            }
            
            function cmdAdd(employeeId, leaveId){
                document.frm.employee_id.value=employeeId;
                document.frm.leave_id.value=leaveId;
                document.frm.command.value="<%=String.valueOf(Command.SAVE)%>";
                document.frm.action="doc_leave_search.jsp";
                document.frm.submit();
            }

            function cmdAskDelete(oid){
                document.frm.oid_doc_expense.value=oid;
                document.frm.command.value="<%=Command.ASK%>";
                document.frm.action="doc_leave_search.jsp";
                document.frm.submit();
            }

            function cmdDelete(oid){
                document.frm.oid_doc_expense.value=oid;
                document.frm.command.value="<%=Command.DELETE%>";
                document.frm.action="doc_leave_search.jsp";
                document.frm.submit();
            }
        </script>
    </head>
    <body>
        <div class="header">
            <h2 style="color:#999">Pencarian Cuti</h2>
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
                <input type="hidden" name="object_name" value="<%= objectName %>" />
                <input type="hidden" name="employee_id" value="" />
                <input type="hidden" name="leave_id" value="" />
                <table width="100%">
                    <tr>
                        <td valign="top" width="50%">
                            <div id="caption">Tahun</div>
                            <div id="divinput">
                                <%= ControlCombo.draw("tahun", "chosen-select", null, "" + tahun, valTahun, keyTahun, "style='width : 10%' onchange='javascript:cmdRefresh()'")%> 
                            </div>
                            <div>&nbsp;</div>
                            <%
                                    if (listLeave.size()>0){
                            %>
                            <table class="tblStyle">
                                <tr>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Karyawan</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Tanggal Pengajuan</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Tanggal Cuti</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Tanggal Berakhir</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Lama Hari</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Jenis Cuti</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Keterangan</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Status</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Action</td>
                                </tr>
                                <%
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                if (listLeave != null && listLeave.size()>0){
                                    long scheduleSymbol = 0;
                                    for (int i=0; i<listLeave.size(); i++){
                                        Vector temp = (Vector) listLeave.get(i);
                                        LeaveApplication leave = (LeaveApplication)temp.get(0);
                                        Employee emp = (Employee) temp.get(1);
                                        String startCuti = "";
                                        String endCuti = "";
                                        int qtyCuti = 0;
                                        String where = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leave.getOID();
                                        Vector listALStockTaken = PstAlStockTaken.list(0, 0, where, "");
                                        if (listALStockTaken != null && listALStockTaken.size()>0){
                                            AlStockTaken alStockTaken = (AlStockTaken)listALStockTaken.get(0);
                                            startCuti = sdf.format(alStockTaken.getTakenDate());
                                            endCuti = sdf.format(alStockTaken.getTakenFinnishDate());
                                            qtyCuti = convertInteger(alStockTaken.getTakenQty());
                                        } else {
                                            where = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leave.getOID();
                                            Vector listLlStockTaken = PstLlStockTaken.list(0, 0, where, "");
                                            if (listLlStockTaken != null && listLlStockTaken.size()>0){
                                                LlStockTaken llStockTaken = (LlStockTaken)listLlStockTaken.get(0);
                                                startCuti = sdf.format(llStockTaken.getTakenDate());
                                                endCuti = sdf.format(llStockTaken.getTakenFinnishDate());
                                                qtyCuti = convertInteger(llStockTaken.getTakenQty());
                                            } else {
                                                where = PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_LEAVE_APLICATION_ID]+"="+leave.getOID();
                                                Vector listSlStockTaken = PstSpecialUnpaidLeaveTaken.list(0, 0, where, "");
                                                if (listSlStockTaken != null && listSlStockTaken.size()>0){
                                                    SpecialUnpaidLeaveTaken slStockTaken = (SpecialUnpaidLeaveTaken)listSlStockTaken.get(0);
                                                    scheduleSymbol = slStockTaken.getScheduledId();
                                                    startCuti = sdf.format(slStockTaken.getTakenDate());
                                                    endCuti = sdf.format(slStockTaken.getTakenFinnishDate());
                                                    qtyCuti = convertInteger(slStockTaken.getTakenQty());
                                                }
                                            }
                                        }
                                        %>
                                        <tr>
                                            <td style="background-color: #FFF;"><%= "["+ emp.getEmployeeNum()+"] "+emp.getFullName() %></td>
                                            <td style="background-color: #FFF;"><%= leave.getSubmissionDate() %></td>
                                            <td style="background-color: #FFF;"><%= startCuti %></td>
                                            <td style="background-color: #FFF;"><%= endCuti %></td>
                                            <td style="background-color: #FFF;"><%= qtyCuti %></td>
                                            <%
                                                if (leave.getTypeLeaveCategory() != 0){
                                            %>
                                            <td style="background-color: #FFF;"><%= leaveType[leave.getTypeLeaveCategory()] %></td>
                                            <%
                                                } else {
                                                    ScheduleSymbol symbol = new ScheduleSymbol();
                                                    try {
                                                        symbol = PstScheduleSymbol.fetchExc(scheduleSymbol);
                                                    } catch (Exception exc){

                                                    }
                                            %>
                                            <td style="background-color: #FFF;"><%= symbol.getSchedule() %></td>
                                            <%
                                                }
                                            %>
                                            <td style="background-color: #FFF;"><%= leave.getLeaveReason() %></td>
                                            <td style="background-color: #FFF;"><%= PstLeaveApplication.fieldStatusApplication[leave.getDocStatus()] %></td>
                                            <td style="background-color: #FFF;">
                                                <a class="btn-small" style="color:#FFF" href="javascript:cmdAdd('<%=leave.getEmployeeId()%>','<%=leave.getOID()%>')">Tambah</a>

                                            </td>
                                        </tr>
                                        <%
                                    }

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
</html>

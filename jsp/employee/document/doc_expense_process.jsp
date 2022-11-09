<%-- 
    Document   : doc_expense_process
    Created on : 08-Mar-2017, 08:52:56
    Author     : Gunadi
--%>

<%@page import="com.dimata.harisma.entity.attendance.LlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockTaken"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.ValueMappingProposional"%>
<%@page import="com.dimata.harisma.entity.payroll.PstSalaryLevelDetail"%>
<%@page import="com.dimata.harisma.entity.payroll.SalaryLevelDetail"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlip"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpDocListExpense"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDoc"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpDoc"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDocListExpense"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../../main/javainit.jsp" %>
<!DOCTYPE html>
<%
    int iCommand = FRMQueryString.requestInt(request,"command");
    long oidDoc = FRMQueryString.requestLong(request, "doc_id");
	int expenseType = FRMQueryString.requestInt(request, "expense_type");
    
    EmpDoc empDoc = new EmpDoc();
    try{
        empDoc = PstEmpDoc.fetchExc(oidDoc);
    } catch (Exception exc){}
    
    String whereClause = "'"+empDoc.getDate_of_issue() +"' BETWEEN "+ PstPayPeriod.fieldNames[PstPayPeriod.FLD_START_DATE] + " AND "
                        + "" + PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE];
    Vector listPeriod = PstPayPeriod.list(0, 0, whereClause, "");
    Vector listEmpDocExpense = PstEmpDocListExpense.list(0, 0, ""+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc, "");
   
    
    if (listPeriod.size() > 0){
        PayPeriod payPeriod = (PayPeriod) listPeriod.get(0);
		
		switch(expenseType){
			case 1:
				for (int i= 0; i < listEmpDocExpense.size(); i++){
					EmpDocListExpense docExpense = (EmpDocListExpense) listEmpDocExpense.get(i);
					try{
						PayComponent salaryComp = new PayComponent();
						try {
							salaryComp = PstPayComponent.fetchExc(docExpense.getComponentId());
						} catch (Exception exc){}
					//boolean nilai = getReadyDocComponent(payPeriod.getStartDate(), payPeriod.getEndDate(), employee.getOID(), salaryComp.getComponentId());
					   long totdocDay = PstPaySlip.getDayDocComponent(payPeriod.getStartDate(), payPeriod.getEndDate(), docExpense.getEmployeeId(), salaryComp.getCompCode());

					   String periodFrom = ""+payPeriod.getStartDate();
					   String periodTo = ""+payPeriod.getEndDate();
					   String employeeId = ""+docExpense.getEmployeeId();
					   String salaryComponent = ""+salaryComp.getCompCode();
					   ValueMappingProposional valueMapPro = new ValueMappingProposional();

					   double value = valueMapPro.getValueMappingTotal(periodFrom, periodTo, employeeId, salaryComponent);
					   String whereDoc = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_LIST_EXPENSE_ID] + " = " + docExpense.getOID(); 
					   PstEmpDocListExpense.updateValueComp(value, whereDoc);

					}catch (Exception e){}
				}
				break;
			case 2:
                                LeaveApplication leave = PstLeaveApplication.fetchExc(empDoc.getLeaveId());
                                long oidPeriod = 0;
                                Vector listAl = PstAlStockTaken.getAlTaken(empDoc.getLeaveId(), leave.getEmployeeId());
                                Vector listLl = PstLlStockTaken.getLlTaken(empDoc.getLeaveId(), leave.getEmployeeId());
                                if (listAl.size()>0){
                                    AlStockTaken alStockTaken = (AlStockTaken) listAl.get(0);
                                    oidPeriod = PstPayPeriod.getPayPeriodIdBySelectedDate(alStockTaken.getTakenDate());
                                }
                                if (listLl.size()>0){
                                    LlStockTaken llStockTaken = (LlStockTaken) listLl.get(0);
                                    oidPeriod = PstPayPeriod.getPayPeriodIdBySelectedDate(llStockTaken.getTakenDate());
                                }
				PayPeriod prevPeriod = PstPayPeriod.getPreviousPayPeriod(oidPeriod);
				double compValue = 0.0;
				int pengali = 0;
				for (int i= 0; i < listEmpDocExpense.size(); i++){
					EmpDocListExpense docExpense = (EmpDocListExpense) listEmpDocExpense.get(i);
					try{
						pengali = docExpense.getDayLength();
						try {
							PayComponent payComponent = PstPayComponent.fetchExc(docExpense.getComponentId());
							compValue = PstPaySlip.getCompValue(docExpense.getEmployeeId(), prevPeriod, payComponent.getCompCode());
						} catch (Exception exc){}
					}catch (Exception e){}
					String whereDoc = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_LIST_EXPENSE_ID] + " = " + docExpense.getOID(); 
					double value = docExpense.getDayLength() * compValue;
					PstEmpDocListExpense.updateValueComp(value, whereDoc);
				}
				break;
                        case 3:
                            String whereExpenseAll = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc
                                + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+"='PREVIOUS_BENEFIT'";
                            Vector listExpenseAll = PstEmpDocListExpense.list(0, 0, whereExpenseAll, "");
                            for (int i=0; i < listExpenseAll.size();i++){
                                EmpDocListExpense docExpense = (EmpDocListExpense) listExpenseAll.get(i);
                                compValue = 0.0;
                                try{
                                        pengali = docExpense.getDayLength();
                                        try {
                                                payPeriod = PstPayPeriod.fetchExc(docExpense.getPeriodeId());
                                                PayComponent payComponent = PstPayComponent.fetchExc(docExpense.getComponentId());
                                                compValue = PstPaySlip.getCompValue(docExpense.getEmployeeId(), payPeriod, payComponent.getCompCode());
                                        } catch (Exception exc){}
                                }catch (Exception e){}
                                String whereDoc = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_LIST_EXPENSE_ID] + " = " + docExpense.getOID(); 
                                double value = docExpense.getDayLength() * compValue;
                                PstEmpDocListExpense.updateValueComp(value, whereDoc);
                            }
                            break;
		}
		
        
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Processing</title>
    </head>
    <body>
        <script>
            window.location="<%=approot%>/employee/document/EmpDocumentDetails.jsp?EmpDocument_oid=<%=oidDoc%>";
        </script>
    </body>
</html>


<%@page import="com.dimata.harisma.entity.overtime.PstOvertime"%>
<%@page import="com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "main/javainit.jsp" %>
<!DOCTYPE html>

<%
		String oidSpecialLeave = "";
		String oidUnpaidLeave = "";
		try {
			oidSpecialLeave = String.valueOf(PstSystemProperty.getValueByName("OID_SPECIAL"));
		} catch (Exception E) {
			oidSpecialLeave = "0";
			System.out.println("EXCEPTION SYS PROP OID_SPECIAL : " + E.toString());
		}
		try {
			oidUnpaidLeave = String.valueOf(PstSystemProperty.getValueByName("OID_UNPAID"));
		} catch (Exception E) {
			oidUnpaidLeave = "0";
			System.out.println("EXCEPTION SYS PROP OID_UNPAID : " + E.toString());
		}
		String whereSchedule = "("+PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SCHEDULE_CATEGORY_ID] + " = " + oidSpecialLeave
		+ " OR " + PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SCHEDULE_CATEGORY_ID] + " = " + oidUnpaidLeave+") AND "
		+ PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SHOW_ON_USER_LEAVE]+ " = 1";
		Vector listSchedule = PstScheduleSymbol.list(0, 0, whereSchedule, null);

		for (int i = 0; i < PstLeaveApplication.fieldTypeLeaveCategory.length;i++){
			if (i == PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_SPECIAL){
				if (listSchedule.size() > 0){
					for (int x=0;x<listSchedule.size();x++){
						ScheduleSymbol scheduleSymbol = (ScheduleSymbol) listSchedule.get(x);
						String whereSch = PstSpecialUnpaidLeaveTaken.TBL_SPECIAL_UNPAID_LEAVE_TAKEN+"."+PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_SCHEDULED_ID]+"="+scheduleSymbol.getOID();
						int leaveNotif = PstLeaveApplication.getLeaveNotification(emplx.getOID(), emplx.getDivisionId(), whereSch);
						if (leaveNotif != 0){
						%>
							<div style="padding:9px 0px;"> <a style="color:#FFF; background-color: #CF5353; padding: 5px;" href="javascript:cmdGoToApproval(<%=i%>,'<%=scheduleSymbol.getOID()%>')"><%= leaveNotif %> Orang <%= scheduleSymbol.getSchedule() %></a></div>
						<%     
						}
					}
				}
			} else {
				String whereLv = PstLeaveApplication.TBL_LEAVE_APPLICATION+"."+PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY]+"="+i;
				int leaveNotif = PstLeaveApplication.getLeaveNotification(emplx.getOID(), emplx.getDivisionId(), whereLv);
				if (leaveNotif != 0){
				%>
					<div style="padding:9px 0px;"> <a style="color:#FFF; background-color: #CF5353; padding: 5px;" href="javascript:cmdGoToApproval(<%=i%>,0)"><%= leaveNotif %> Orang <%= PstLeaveApplication.fieldTypeLeaveCategory[i] %></a></div>
				<%     
				}
			}
		}
	%>                          

	<%
		int leaveNotifCancel = PstLeaveApplication.getToBeCancelNotif(emplx.getOID());
		if (leaveNotifCancel != 0){
	%>
		<div style="padding:9px 0px;">Pemberitahuan: <a style="color:#FFF; background-color: #CF5353; padding: 5px;" href="javascript:cmdGoToApproveCancel()"><%= leaveNotifCancel %> Orang Membatalkan Cuti</a></div>
	<%  } %>
	<%
		int ovtNotifCancel = 0;//PstOvertime.getOvertimeNotif(emplx.getOID(), emplx.getDivisionId());
		if (ovtNotifCancel != 0){
			String overtimeNum = PstOvertime.getOvertimeNotifNum(emplx.getOID(), emplx.getDivisionId());
	%>
		<div style="padding:9px 0px;">Pemberitahuan: <a style="color:#FFF; background-color: #CF5353; padding: 5px;" href="javascript:cmdGoToOvertime('<%=overtimeNum%>')"><%= ovtNotifCancel %> Form Lembur</a></div>
	<%  } %>
	<%
		int kpiNotif = PstKpiTarget.getNotification(emplx.getOID(), emplx.getDivisionId(), "");
		if (kpiNotif != 0){
	%>
		<div style="padding:9px 0px;">Pemberitahuan: <a style="color:#FFF; background-color: #CF5353; padding: 5px;" href="javascript:cmdGoToApprovalKpi()"><%= kpiNotif %> Orang Mengajukan KPI</a></div>
	<%  } %>

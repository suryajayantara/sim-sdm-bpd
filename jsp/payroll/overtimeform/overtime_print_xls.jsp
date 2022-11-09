<%-- 
    Document   : overtime_print_xls
    Created on : 31-May-2017, 11:10:49
    Author     : Gunadi
--%>

<%@page import="com.dimata.harisma.entity.masterdata.PublicHolidays"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPublicHolidays"%>
<%@page import="com.dimata.harisma.entity.payroll.PstOvt_Type"%>
<%@page import="com.dimata.system.entity.PstSystemProperty"%>
<%@page import="com.dimata.harisma.session.attendance.PresenceReportDaily"%>
<%@page import="com.dimata.harisma.session.attendance.SessEmpSchedule"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="java.util.Scanner"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.dimata.harisma.entity.overtime.OvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertime"%>
<%@page import="com.dimata.harisma.entity.overtime.Overtime"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%>
<%!
    public String getDiffOut(Date dtParam, Date dtActual, long overToL, int ovtType) {
        String result = "";
        if (dtParam == null || dtActual == null) {
            return result;
        }
      //int schld1stCategory = PstEmpSchedule.getScheduleCategory(INT_FIRST_SCHEDULE, employeeId, presenceDate);
        //mencari schedule yg ada cross day
        Date dtSchedule = new Date(dtParam.getYear(), dtParam.getMonth(), dtParam.getDate(), dtParam.getHours(), dtParam.getMinutes());
        if (dtSchedule != null && dtActual != null) {
            dtSchedule.setSeconds(0);
            dtActual.setSeconds(0);
            long iDuration = dtActual.getTime() / 60000 - dtSchedule.getTime() / 60000;
            long iDurationHour = (iDuration - (iDuration % 60)) / 60;
            long iDurationMin = iDuration % 60;
            if (ovtType == PstOvt_Type.END_OF_YEAR) {
				if (iDurationHour<0){
					result = "0";
				} else {
					result = String.format("%.2f", ((double) iDuration/60));
				}
			} else {
				if (!(iDurationHour == 0 && iDurationMin == 0)) {
					String strDurationHour = "";
					if(iDurationMin >= overToL){
						strDurationHour = ""+ (iDurationHour + 1);
					} else {
						strDurationHour = ""+ (iDurationHour);
					}
					result = strDurationHour;
				}
			}
                    
          
        }
        return result;
    }

    public int getOvertimeType(Date dtParam, long religionId) {
        int result = 0;
        Vector listPH = new Vector();

        listPH = PstPublicHolidays.list(0, 0, "'"+Formater.formatDate(dtParam, "yyyy-MM-dd")+"' BETWEEN  holiday_date AND holiday_date_to", "holiday_status");
        boolean ovtEndOfYear = PstOvertime.endOfYearOvertime(dtParam);

        if (ovtEndOfYear){
            result = PstOvt_Type.END_OF_YEAR;
        }else if(listPH.size() > 0){
            for(int i = 0; i < listPH.size(); i++){
                PublicHolidays pH = (PublicHolidays)listPH.get(i);
                if(pH.getiHolidaySts() == 1 || religionId == pH.getiHolidaySts()){
                    result = PstOvt_Type.HOLIDAY;
                    i = listPH.size();
                }
            }
        } else {
            String[] stDays = {
                "Sunday","Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
            };

            Calendar objCal = Calendar.getInstance();
            objCal.setTime(dtParam);

            String day = stDays[objCal.get(Calendar.DAY_OF_WEEK)-1];
            if(day == stDays[0] || day == stDays[6]){
                result = PstOvt_Type.SCHEDULE_OFF;
            } else {
                result = PstOvt_Type.WORKING_DAY;
            }
        }

            return result;
        }
%>
<%
    response.setHeader("Content-Disposition","attachment; filename=form_lembur.xls ");

    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidOvertime = FRMQueryString.requestLong(request, "overtime_oid");
    long oidEmployee = FRMQueryString.requestLong(request, "employee_oid");
    long oidOvt_Employee = FRMQueryString.requestLong(request, "ovtEmployee_oid");
    
    ChangeValue changeValue = new ChangeValue();
    Overtime ovt = new Overtime();
    try{
        ovt = PstOvertime.fetchExc(oidOvertime);
    } catch (Exception exc){}
    
    String whereClauseOv = PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_OVERTIME_ID] + " = " + oidOvertime;
    Vector listOvertimeDetail = PstOvertimeDetail.listWithEmployee(0, 0, whereClauseOv, "");
        
    Division div = new Division();
    try{
        div = PstDivision.fetchExc(ovt.getDivisionId());
    } catch (Exception exc){}
    
    //OvertimeDetail ovtDet = new OvertimeDetail();
    String ovtDate = "";
    if (listOvertimeDetail.size() > 0){
        OvertimeDetail ovtDet = (OvertimeDetail) listOvertimeDetail.get(0);
        Calendar cal = Calendar.getInstance();
        cal.setTime(ovtDet.getDateFrom());
        Scanner sc =new Scanner(System.in);
        int day = cal.get(Calendar.DAY_OF_MONTH);
        int scDay = cal.get(Calendar.DAY_OF_WEEK);
        int month = cal.get(Calendar.MONTH);
        int year = cal.get(Calendar.YEAR);
        String dayName = "";
        String monthName = "";
        switch(scDay){
            case 1 : dayName = "Minggu"; break;
            case 2 : dayName = "Senin"; break;
            case 3 : dayName = "Selasa"; break;
            case 4 : dayName = "Rabu"; break;
            case 5 : dayName = "Kamis"; break;
            case 6 : dayName = "Jumat"; break;
            case 7 : dayName = "Sabtu"; break;
        }
        
        switch(month){
            case 0 : monthName = "Januari" ; break;
            case 1 : monthName = "Februari" ; break;
            case 2 : monthName = "Maret" ; break;
            case 3 : monthName = "April" ; break;
            case 4 : monthName = "Mei" ; break;
            case 5 : monthName = "Juni" ; break;
            case 6 : monthName = "Juli" ; break;
            case 7 : monthName = "Agustus" ; break;
            case 8 : monthName = "September" ; break;
            case 9 : monthName = "Oktober" ; break;
            case 10 : monthName = "November" ; break;
            case 11 : monthName = "Desember" ; break;
        }
        
        ovtDate = dayName+","+day+" "+monthName+" "+year;
    }                  
    
    int totApprover = 0;
    if (ovt.getApproval6Id() > 0){
        totApprover = 7;
    }
    else if (ovt.getApproval5Id() > 0){
        totApprover = 6;
    }
    else if (ovt.getApproval4Id() > 0){
        totApprover = 5;
    }
    else if (ovt.getApproval3Id() > 0){
        totApprover = 4;
    }
    else if (ovt.getApproval2Id() > 0){
        totApprover = 3;
    }
    else if (ovt.getApproval1Id() > 0){
        totApprover = 2;
    }                
    else if (ovt.getRequestId() > 0){
        totApprover = 1;
    }    

    String overtimeTo = PstSystemProperty.getValueByName("OVERTIME_ROUND_TO");
    long overToL = Long.parseLong(overtimeTo);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Overtime Report</title>
    </head>
    <body>
        <% if (iCommand == Command.LIST) { %>
        <table>
            <tr>
                <td colspan="7" style="text-align: center;">PT BANK PEMBANGUNAN DAERAH BALI</td>
            </tr>
            <tr>
                <td colspan="7" style="text-align: center;">SURAT PERINTAH LEMBUR</td>
            </tr>
            <tr>
                <td colspan="7" style="text-align: center;"><%=div.getDivision()%></td>
            </tr>
            <tr>
                <td colspan="7" style="text-align: center;">Tanggal : <%=ovtDate%></td>
            </tr>
            <tr>
                <td colspan="7">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="7">
            <table border="1">
                <tbody>
                        <tr>
                                <td colspan="1" rowspan="2" style="text-align: center; vertical-align: middle;">No</td>
                                <td colspan="1" rowspan="2" style="text-align: center; vertical-align: middle;">Nama</td>
                                <td colspan="2" rowspan="1" style="text-align: center; vertical-align: middle;">Rencana Lembur</td>
                                <td colspan="3" rowspan="1" style="text-align: center; vertical-align: middle;">Penyelesaian Lembur</td>
                        </tr>
                        <tr>
                                <td style="text-align: center;">Waktu/Jam <br/>....s/d....</td>
                                <td style="text-align: center; vertical-align: middle;">Pekerjaan yang di lembur</td>
                                <td style="text-align: center;">Waktu/Jam <br/>....s/d....</td>
                                <td style="text-align: center; vertical-align: middle;">Klaim Jam Lembur</td>
                                <td style="text-align: center; vertical-align: middle;">Pekerjaan yang telah di selesaikan</td>
                        </tr>
                        <%
                            if (listOvertimeDetail.size() > 0){
                                
                                for (int i=0;i<listOvertimeDetail.size();i++){
                                    OvertimeDetail ovDetail = (OvertimeDetail) listOvertimeDetail.get(i);
                                    
                                    Employee emp = new Employee();
                                    try{
                                        emp = PstEmployee.fetchExc(ovDetail.getEmployeeId());
                                    } catch (Exception exc){}
                                    
                                    DateFormat format = new SimpleDateFormat("HH:mm");
                                    
                                    String fromDateFor = Formater.formatDate(ovDetail.getDateFrom(), "dd-MM-yyyy");
                                    String toDateFor = Formater.formatDate(ovDetail.getDateTo(), "dd-MM-yyyy");
                                    Date fromDateCon = new Date();
                                    Date toDateCon = new Date();
                                    try {
                                        //Date frmDateCon = formatter.parse(fromDateFor);
                                        //Date toDateCon = formatter.parse(toDateFor);
                                        fromDateCon = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss").parse(""+fromDateFor+" 00:00:00");
                                        toDateCon = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss").parse(""+toDateFor+" 23:59:00");

                                    } catch (Exception strE) {
                                        System.out.println("" + strE);
                                    }
                                    
                        %>
                        <tr>
                                <td><%=i+1%></td>
                                <td><%=emp.getFullName()%></td>
                                <td><%=format.format(ovDetail.getDateFrom())%> s/d <%=format.format(ovDetail.getDateTo())%></td>
                                <td><%=ovDetail.getJobDesk()%></td>
                                <%
                                    Vector listAttendanceRecordDailly = SessEmpSchedule.listEmpPresenceDaily(0, fromDateCon, toDateCon, 0, ovDetail.getPayroll(), ovDetail.getName(), "", 0, 0,null,0,"",0,0,0);
                                    if (listAttendanceRecordDailly.size() > 0){
                                        //for (int j = 0; j < listAttendanceRecordDailly.size(); j++) { 
                                            PresenceReportDaily presenceReportDaily = (PresenceReportDaily) listAttendanceRecordDailly.get(0);
											
                                            Date dtActualIn1st = (Date) presenceReportDaily.getActualIn1st();
                                            Date dtActualOut1st = (Date) presenceReportDaily.getActualOut1st();
                                            Date dtSchldOut1st = (Date) presenceReportDaily.getScheduleOut1st();
                                            
                                            double durasi=Formater.formatDurationTime2(ovDetail.getDateFrom(), ovDetail.getDateTo(), true);
                                            String strDiffOut1st = "";
                                            double jmlhDuration = 0;
                                            int overType = 0;
											
                                            overType = getOvertimeType(ovDetail.getDateFrom(), emp.getReligionId());
                                            
                                            String actOut = "-";
                                            String actIn = "-";
                                            if (dtActualOut1st != null && ovDetail.getDateFrom() != null) {
                                                    if (ovDetail.getDateTo().before(dtActualOut1st)){
                                                            dtActualOut1st = ovDetail.getDateTo();
                                                    }
                                                    strDiffOut1st = getDiffOut(ovDetail.getDateFrom(), dtActualOut1st, overToL, overType);
                                                    if(!strDiffOut1st.equals("") && !strDiffOut1st.equals(null)){
                                                            jmlhDuration = Double.valueOf(strDiffOut1st);
                                                    }
                                                    actOut = ""+Formater.formatTimeLocale(dtActualOut1st, "HH:mm");
                                                    
                                            }
                                            
                                            
                                            if (dtActualIn1st != null && ovDetail.getDateFrom() != null) {
                                                if (ovDetail.getDateFrom().before(dtActualIn1st)){
                                                    strDiffOut1st = getDiffOut(dtActualIn1st,dtActualOut1st, overToL, overType);
                                                    if (!strDiffOut1st.equals("") && !strDiffOut1st.equals(null)){
                                                        durasi=Double.valueOf(strDiffOut1st);
                                                        jmlhDuration = Double.valueOf(strDiffOut1st);
                                                    }
                                                    actIn = ""+Formater.formatTimeLocale(dtActualIn1st, "HH:mm");
                                                } else {
                                                    actIn = ""+Formater.formatTimeLocale(ovDetail.getDateFrom(), "HH:mm");
                                                }
                                            }
                                            
                                            if (dtActualIn1st == null || dtActualOut1st == null){
                                                jmlhDuration = 0;
                                            }
                                            
                                            double paidDuration = 0.0;
                                            if (durasi > jmlhDuration){
                                                paidDuration = jmlhDuration - ovDetail.getRestTimeinHr();
                                            } else {
                                                paidDuration = durasi - ovDetail.getRestTimeinHr();
                                            }
                                            
                                            if (dtActualIn1st == null || dtActualOut1st == null){
                                                paidDuration = 0;
                                            }
                                            
                                            double minHolidayDuration = 0.0;
                                            try{        
                                                minHolidayDuration = Double.parseDouble(PstSystemProperty.getValueByName("MIN_HOLIDAY_OVT_DURATION"));
                                            } catch (Exception exc){}

                                            if (overType == PstOvt_Type.HOLIDAY && paidDuration < minHolidayDuration){
                                                overType = PstOvt_Type.SCHEDULE_OFF;
                                            }
                                            //hitung nilai overtime
//                                                        double durKurRest = 0.0;
                                            double maxDuration = 0.0;
                                            if (overType == PstOvt_Type.WORKING_DAY){
                                                maxDuration = 3.0;
                                            } else if (overType == PstOvt_Type.HOLIDAY || overType == PstOvt_Type.END_OF_YEAR){
                                                maxDuration = 5.0;
                                            }

                                            if ((ovDetail.getNormalOvertime() == 0 || overType == PstOvt_Type.END_OF_YEAR) && paidDuration > maxDuration && maxDuration != 0.0){
                                                paidDuration = maxDuration - ovDetail.getRestTimeinHr();
                                            } 
                                            

                                            
                                            %>
                                                <td><%=actIn%> s/d <%=actOut%> </td>
                                                <% if (overType == PstOvt_Type.END_OF_YEAR){ %>
                                                    <td><%=paidDuration%></td>
                                                <% } else { %>
                                                        <td><%=Math.round(paidDuration)%></td>
                                                <% }  %>
                                            <%
                                            
                                        //}
                                    } else {
                                        %>    
                                            <td>- s/d - </td>
                                            <td>0</td>
                                       <%
                                    }
                                
                                %>
                                <td><%=ovDetail.getJobDesk()%></td>
                        </tr>
                        <%      }
                            }
                        %>
                </tbody>
        </table>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td colspan="7" style="text-align: center; vertical-align: middle;">PT BANK PEMBANGUNAN DAERAH BALI</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                %>
                    <td style="text-align: center; vertical-align: middle;">PEJABAT YANG</td>
                <%
                    }
                %>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getApproval1Id() > 0){
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;">PEJABAT YANG</td>
                <%
                    }
                %>
            </tr>

            <tr>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                %>
                    <td style="text-align: center; vertical-align: middle;">MEMERINTAHKAN LEMBUR</td>
                <%
                    }
                %>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getApproval1Id() > 0){
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;">MENGESAHKAN LEMBUR</td>
                <%
                    }
                %>
            </tr> 
            
            <tr>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getRequestId());
                        } catch (Exception exc){}
                %>
                    <td style="text-align: center; vertical-align: middle;"><%=changeValue.getPositionName(emp.getPositionId())%></td>
                <%
                    }
                %>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getRequestId());
                        } catch (Exception exc){}
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;"><%=changeValue.getPositionName(emp.getPositionId())%></td>
                <%
                    }
                %>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getRequestId());
                        } catch (Exception exc){}
                %>
                    <td style="text-align: center; vertical-align: middle;">Approved</td>
                <%
                    }
                %>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getRequestId());
                        } catch (Exception exc){}
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;">Approved</td>
                <%
                    }
                %>
            </tr>
			<tr>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getRequestId());
                        } catch (Exception exc){}
                %>
                    <td style="text-align: center; vertical-align: middle;"><%=Formater.formatDate(ovt.getRequestDate(),"dd MMMM yyyy")%></td>
                <%
                    }
                %>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getRequestId());
                        } catch (Exception exc){}
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;"><%=Formater.formatDate(ovt.getRequestDate(),"dd MMMM yyyy")%></td>
                <%
                    }
                %>
            </tr>
			<tr>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getRequestId());
                        } catch (Exception exc){}
                %>
                    <td style="text-align: center; vertical-align: middle;">By</td>
                <%
                    }
                %>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getRequestId());
                        } catch (Exception exc){}
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;">By</td>
                <%
                    }
                %>
            </tr>
			<tr>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getRequestId());
                        } catch (Exception exc){}
                %>
                    <td style="text-align: center; vertical-align: middle;"><%=changeValue.getEmployeeName(ovt.getRequestId())%></td>
                <%
                    }
                %>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getRequestId());
                        } catch (Exception exc){}
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;"><%=changeValue.getEmployeeName(ovt.getRequestId())%></td>
                <%
                    }
                %>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getRequestId());
                        } catch (Exception exc){}
                %>
                    <td style="text-align: center; vertical-align: middle;">NRK :<%=emp.getEmployeeNum()%></td>
                <%
                    }
                %>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getRequestId());
                        } catch (Exception exc){}
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;">NRK :<%=emp.getEmployeeNum()%></td>
                <%
                    }
                %>
            </tr>
            
            
            <tr>
                <td>&nbsp;</td>
            </tr>
            
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getApproval1Id() > 0){
                %>
                <td colspan="2" style="text-align: center; vertical-align: middle;">PEJABAT YANG</td>
                <%
                    }
                %>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getRequestId() > 0){
                %>
                <td colspan="2" style="text-align: center; vertical-align: middle;">MENYETUJUI LEMBUR</td>
                <%
                    }
                %>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getApproval1Id() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getApproval1Id());
                        } catch (Exception exc){}
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;"><%=changeValue.getPositionName(emp.getPositionId())%></td>
                <%
                    }
                %>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getApproval1Id() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getApproval1Id());
                        } catch (Exception exc){}
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;">Approved</td>
                <%
                    }
                %>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getApproval1Id() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getApproval1Id());
                        } catch (Exception exc){}
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;"><%=Formater.formatDate(ovt.getTimeApproval1(),"dd MMMM yyyy")%></td>
                <%
                    }
                %>
            </tr>
			<tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getApproval1Id() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getApproval1Id());
                        } catch (Exception exc){}
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;">By</td>
                <%
                    }
                %>
            </tr>
			<tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getApproval1Id() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getApproval1Id());
                        } catch (Exception exc){}
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;"><%=changeValue.getEmployeeName(ovt.getApproval1Id())%></td>
                <%
                    }
                %>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <%
                    if (ovt.getApproval1Id() > 0){
                        Employee emp = new Employee();
                        try{
                            emp = PstEmployee.fetchExc(ovt.getApproval1Id());
                        } catch (Exception exc){}
                %>
                    <td colspan="2" style="text-align: center; vertical-align: middle;">NRK : <%=emp.getEmployeeNum()%></td>
                <%
                    }
                %>
            </tr>
            
    </table>
        <% } %>
    </body>
</html>

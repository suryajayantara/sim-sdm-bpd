<%-- 
    Document   : overtime_report
    Created on : 19-May-2017, 16:16:13
    Author     : Gunadi
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.entity.masterdata.Section"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstSection"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDepartment"%>
<%@page import="com.dimata.harisma.entity.masterdata.Department"%>
<%@page import="com.dimata.harisma.entity.payroll.PaySlipComp"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlipComp"%>
<%@page import="com.dimata.harisma.entity.payroll.PaySlip"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlip"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.system.entity.PstSystemProperty"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstLevel"%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.harisma.entity.masterdata.Level"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.dimata.harisma.entity.masterdata.PublicHolidays"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPublicHolidays"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Date"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertime"%>
<%@page import="com.dimata.harisma.entity.payroll.PstOvt_Type"%>
<%@page import="com.dimata.harisma.entity.overtime.OvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertimeDetail"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%>

<%!
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
    response.setHeader("Content-Disposition","attachment; filename=laporan_lembur.xls ");
    
    int iCommand = FRMQueryString.requestCommand(request);
    long oidComp = FRMQueryString.requestLong(request, "company_id");
    String empNumber = FRMQueryString.requestString(request, "emp_number");
    String empName = FRMQueryString.requestString(request, "full_name");
    String[] oidDiv = FRMQueryString.requestStringValues(request, "division_id");
    String[] oidDept = FRMQueryString.requestStringValues(request, "department");
    String[] oidSec = FRMQueryString.requestStringValues(request, "section");
    String dateFrom = FRMQueryString.requestString(request, "date_from");
    String dateTo = FRMQueryString.requestString(request, "date_to");
    int type = FRMQueryString.requestInt(request, "type");
    int periodType = FRMQueryString.requestInt(request, "period_type");
    
    Vector<String> whereCollect = new Vector<String>();
    String whereClauseEmp = "";
    
    if(!empNumber.equals("")){
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+" = '"+empNumber+"'";
        whereCollect.add(whereClauseEmp);
    }
    if(!empName.equals("")){
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+" = '"+empName+"'";
        whereCollect.add(whereClauseEmp);
    }
    if (oidComp != 0){
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+" ="+oidComp;
        whereCollect.add(whereClauseEmp);
    }
    if (oidDiv != null){
        String inDiv = "";
        for (int i=0; i < oidDiv.length; i++){
			try {
				Division div = PstDivision.fetchExc(Long.valueOf(oidDiv[i]));
				inDiv = inDiv + ", '"+ div.getDivision()+"'";
			} catch (Exception exc){
				
			}
        }
        inDiv = inDiv.substring(1);
        whereClauseEmp = " ps."+PstPaySlip.fieldNames[PstPaySlip.FLD_DIVISION]+" IN("+inDiv+")";
        whereCollect.add(whereClauseEmp);
    }
    if (oidDept != null){
        String inDept = "";
        for (int i=0; i < oidDept.length; i++){
			try {
				Department dept = PstDepartment.fetchExc(Long.valueOf(oidDept[i]));
				inDept = inDept + ", '"+ dept.getDepartment()+"'";
			} catch (Exception exc){
				
			}
        }
        inDept = inDept.substring(1);
        whereClauseEmp = " ps."+PstPaySlip.fieldNames[PstPaySlip.FLD_DEPARTMENT]+" IN ("+inDept+")";
        whereCollect.add(whereClauseEmp);
    }
    if (oidSec != null){
        String inSec = "";
        for (int i=0; i < oidSec.length; i++){
			try {
				Section sec = PstSection.fetchExc(Long.valueOf(oidSec[i]));
				inSec = inSec + ", '"+ sec.getSection()+"'";
			} catch (Exception exc){
				
			}
        }
        inSec = inSec.substring(1);
        whereClauseEmp = " ps."+PstPaySlip.fieldNames[PstPaySlip.FLD_SECTION]+" IN ("+inSec+")";
        whereCollect.add(whereClauseEmp);
    }
    if (!dateFrom.equals("") && !dateTo.equals("")){
        whereClauseEmp = " odt."+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_DATE_FROM]+" BETWEEN "
        + "'" +dateFrom+" 00:00:00' AND '"+dateTo+" 23:59:00'" ;
        whereCollect.add(whereClauseEmp);
    }
	
	long oidPeriod = 0;
	try {
		Date date=new SimpleDateFormat("yyyy-MM-dd").parse(dateTo);  
                if (periodType == 0){
                    PayPeriod payPeriod1 = PstPayPeriod.getNextPayPeriodBySelectedDate(date);
                    oidPeriod = payPeriod1.getOID();
                } else {
		PayPeriod payPeriod1 = PstPayPeriod.getPayPeriodBySelectedDate(date);
		oidPeriod = payPeriod1.getOID();
                }
	} catch (Exception exc){}
	
    
    whereCollect.add(" odt."+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_STATUS]+"= 4");
    
    if (whereCollect != null && whereCollect.size()>0){
        whereClauseEmp = "";
        for (int i=0; i<whereCollect.size(); i++){
            String where = (String)whereCollect.get(i);
            whereClauseEmp += where;
            if (i < (whereCollect.size()-1)){
                 whereClauseEmp += " AND ";
            }
        }
    }
    
    String listEmpTime = PstOvertimeDetail.listEmpReport(0, 0, whereClauseEmp, "", oidPeriod);
    String [] arrayEmp = listEmpTime.split(",");
    
    String brutoCompCode = PstSystemProperty.getValueByName("BRUTO_COMP_CODE_FOR_OVERTIME");
    double brutoPercentage = 0;
    try {
        brutoPercentage = Double.parseDouble(PstSystemProperty.getValueByName("BRUTO_PERCENTAGE_FOR_OVERTIME"));
    } catch (Exception exc){
        
    }
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
<% if (iCommand == Command.LIST && arrayEmp != null) {
 %>
<h4 id="title"><strong>Laporan Lembur <%= dateFrom %> - <%= dateTo %></strong></h4>
        <table class="tblStyle" border="1" id="table">
            <tr>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">No</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">NRK</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">Nama</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">Jabatan</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">Divisi</td>
                <% if (type == 0) {%>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="2">Hari Biasa</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="3">Hari Sabtu/Minggu</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">Lembur Istimewa Hari Raya / Libur Nasional</td>
                <% } else { %>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">Lembur Akhir Tahun</td>
                <% } %>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="2">Lembur</td>
            </tr>
            <tr>
                <% if (type == 0) {%>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Satu Jam Pertama</td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Diatas Satu Jam</td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Delapan Jam Pertama</td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Jam Kesembilan</td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Jam Kesepuluh Keatas</td>
                <% }%>
                <td class="title_tbl" style="text-align:center; vertical-align:middle">Rek. Simpeda</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle">Uang Lembur (Rp)</td>
            </tr>
            <%
                double total = 0.0;
                int No = 0;
                for (int i=0; i< arrayEmp.length; i++){
                    Employee emp = new Employee();
                    try {
                        emp = PstEmployee.fetchExc(Long.valueOf(arrayEmp[i]));
                    } catch (Exception exc){}
                    
                    Level lvl = new Level();
                    try {
                        lvl = PstLevel.fetchExc(emp.getLevelId());
                    } catch (Exception exc){}
                    
                    Division div = new Division();
                    try{
                        div = PstDivision.fetchExc(emp.getDivisionId());
                    } catch (Exception exc){}
                    
                    String bgColor = "";
                    if((i%2)==0){
                        bgColor = "#FFF";
                    } else {
                        bgColor = "#F9F9F9";
                    }
                    
                    
                    double durasi = 0.0;
                    double paidDuration = 0.0;
                    double totIdxWD = 0.0;
                    double totIdxH = 0.0;
                    double totIdxSO = 0.0;

                    double durasiWD = 0.0;
                    double JamWDP = 0.0;
                    double JamWDK = 0.0;

                    double durasiH = 0.0;
                    double durasiEoY = 0.0;

                    double durasiSO = 0.0;
                    double jamVIIISO = 0.0;
                    double jamIXSO = 0.0;
                    double jamXSO = 0.0;

                    int overType = 0;
                    String noRek = "";
                    double allowance = 0.0;
                    double allowanceEoY = 0.0;
                    
                    String whereClause = "emp."+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_EMPLOYEE_ID]+ " = " + emp.getOID() + " AND odt."+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_DATE_FROM]+" BETWEEN "
                                        + "'" +dateFrom+" 00:00:00' AND '"+dateTo+" 23:59:00' AND odt."+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_STATUS]+"=4" ;
                    Vector listOvt = PstOvertimeDetail.list3(0, 0, whereClause, "");
                    String division = "-";
					
					if (oidPeriod != 0){
						String wherePaySlip = PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]+"="+oidPeriod
										+ " AND " + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]+"="+emp.getOID();
						Vector listPayslip = PstPaySlip.list(0, 0, wherePaySlip, "");
						if (listPayslip.size()>0){
							PaySlip paySlip = (PaySlip) listPayslip.get(0);
							division = paySlip.getDivision();
						}
					}
                    for(int j=0; j<listOvt.size(); j++){
                        OvertimeDetail empTime2 = (OvertimeDetail) listOvt.get(j);

                        durasi = empTime2.getTotDuration();

                        overType = getOvertimeType(empTime2.getDateFrom(), emp.getReligionId());
                        
                        double minHolidayDuration = 0.0;
                        try{        
                            minHolidayDuration = Double.parseDouble(PstSystemProperty.getValueByName("MIN_HOLIDAY_OVT_DURATION"));
                        } catch (Exception exc){}

                        if (overType == PstOvt_Type.HOLIDAY && durasi < minHolidayDuration){
                            overType = PstOvt_Type.SCHEDULE_OFF;
                        }

                        if(overType == PstOvt_Type.WORKING_DAY){
                            //durasiWD = durasiWD + durasi;
                            if(durasi > 1){
                                JamWDK = JamWDK + (durasi-1);
                                JamWDP = JamWDP + 1;
                            } 
                            if(durasi == 1){
                                JamWDP = JamWDP + 1;
                            }
                            //durasiWD = 0;
                        } else if(overType == PstOvt_Type.SCHEDULE_OFF){
                            //durasiSO = durasiSO + durasi;
                            if(durasi > 9){
                                jamVIIISO = jamVIIISO + 8;
                                jamIXSO = jamIXSO + 1;
                                jamXSO = jamXSO + (durasi-9);
                            } 
                            if(durasi == 9){
                                jamVIIISO = jamVIIISO + 8;
                                jamIXSO = jamIXSO + 1;
                            } 
                            if(durasi <= 8){
                                jamVIIISO = jamVIIISO + durasi;
                            }
                            //durasiSO = 0;
                        } else if(overType == PstOvt_Type.HOLIDAY){
                            durasiH = durasiH + durasi;
                            // durasiH = 0;
                        } else if(overType == PstOvt_Type.END_OF_YEAR) {
                            durasiEoY = durasiEoY + durasi;
                        }
                        
                        if (overType == PstOvt_Type.END_OF_YEAR){
                            allowanceEoY = allowanceEoY + empTime2.getTot_Idx();
                        } else {
                            allowance = allowance + empTime2.getTot_Idx();
                        }
                        
                        

                        // ini cek apa uang lemburnya lebih banyak dari gaji bruto
                        String wherePeriod = "'"+dateFrom+"' BETWEEN "+PstPayPeriod.fieldNames[PstPayPeriod.FLD_START_DATE]
                                        + " AND " +PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE];
                        Vector listPayPeriod = PstPayPeriod.list(0, 0, wherePeriod, "");
                        if (listPayPeriod.size()>0){
                            PayPeriod period = (PayPeriod) listPayPeriod.get(0);
                            String wherePaySlip = PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]+"="+period.getOID()
                                            + " AND " + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]+"="+emp.getOID();
                            Vector listPayslip = PstPaySlip.list(0, 0, wherePaySlip, "");
                            if (listPayslip.size()>0){
                                PaySlip paySlip = (PaySlip) listPayslip.get(0);
                                String whereSlipComp = PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]+"='"+brutoCompCode+"' AND "
                                                    + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]+"="+paySlip.getOID();
                                Vector listSlipComp = PstPaySlipComp.list(0, 0, whereSlipComp, "");
                                if (listSlipComp.size()>0){
                                    PaySlipComp slipComp = (PaySlipComp) listSlipComp.get(0);
                                    double maxValue = slipComp.getCompValue() * (brutoPercentage / 100);
                                    if (overType == PstOvt_Type.END_OF_YEAR){
                                        if (allowanceEoY > maxValue){
                                            allowanceEoY = maxValue;
                                        }
                                    } else {
                                        if (allowance > maxValue){
                                            allowance = maxValue;
                                        }
                                    }
                                }
                            }
                        }
                       // totIdx = getOvIdx(emp.getOID(), durasi, overType);
                    }
                    
            if (allowance != 0.0 && type==0){ 
                total = total + allowance;                      
            %>
            <tr>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=No+1%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle" >="<%=emp.getEmployeeNum()%>"</td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=emp.getFullName()%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=lvl.getLevel()%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=division%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(JamWDP),"#,###.##"))%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(JamWDK),"#,###.##"))%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(jamVIIISO),"#,###.##"))%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(jamIXSO),"#,###.##"))%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(jamXSO),"#,###.##"))%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(durasiH),"#,###.##"))%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=emp.getNoRekening()%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle">="<%=Formater.formatNumber(allowance,"#,###.##")%>"</td>
            </tr>
            <%
                No++;
                       } else if (allowanceEoY != 0.0 && type == 1){
                           total = total + allowanceEoY;
                         %>
                        <tr>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=No+1%></td>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle" >="<%=emp.getEmployeeNum()%>"</td>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=emp.getFullName()%></td>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=lvl.getLevel()%></td>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=division%></td>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(durasiEoY),"#,###.##"))%></td>
							<td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=emp.getNoRekening()%></td>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle">="<%=Formater.formatNumber(allowanceEoY,"#,###.##")%>"</td>                
                        </tr>
                        <%  
                        No++;
                       }
                }
                
                try{
                    String ovtComp = PstSystemProperty.getValueByName("OVERTIME_INJECT_COMPONENT");
                    String ovtDuration = PstSystemProperty.getValueByName("OVERTIME_INJECT_DURATION");
                    String wherePeriod ="'"+ dateTo +"' BETWEEN "+PstPayPeriod.fieldNames[PstPayPeriod.FLD_START_DATE]+" AND "+PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE];
                    Vector listPeriod = PstPayPeriod.list(0, 0, wherePeriod, "");
                    if (listPeriod.size() > 0){
                          PayPeriod payPeriod = (PayPeriod) listPeriod.get(0);                         
                          Vector listPaySlip = PstPaySlip.srcPaySlipByComp(payPeriod.getOID(), ovtComp);
                          if (listPaySlip.size() > 0){
                              for (int x=0; x < listPaySlip.size(); x++){
                                PaySlip paySlip = (PaySlip) listPaySlip.get(x);
                                Employee emp = new Employee();
                                try {
                                    emp = PstEmployee.fetchExc(paySlip.getEmployeeId());
                                } catch (Exception exc){

                                }

                                Level lvl = new Level();
                                  try {
                                      lvl = PstLevel.fetchExc(emp.getLevelId());
                                  } catch (Exception exc){}

                                  Division div = new Division();
                                  try{
                                      div = PstDivision.fetchExc(emp.getDivisionId());
                                  } catch (Exception exc){}

                                  String bgColor = "";
                                  if((x%2)==0){
                                      bgColor = "#FFF";
                                  } else {
                                      bgColor = "#F9F9F9";
                                  }


                                Double duration = 0.0;
                                Double allowance = 0.0;                               
                                String whereDur = PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]+ " = "+paySlip.getOID()+ " AND "
                                                  + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE] + " = '"+ovtDuration+"'";
                                Vector listDur = PstPaySlipComp.list(0, 0, whereDur, "");
                                if (listDur.size()>0){
                                    PaySlipComp paySlipComp = (PaySlipComp) listDur.get(0);
                                    duration = duration + paySlipComp.getCompValue();
                                }  

                                String whereComp = PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]+ " = "+paySlip.getOID()+ " AND "
                                                  + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE] + " = '"+ovtComp+"'";
                                Vector listComp = PstPaySlipComp.list(0,0,whereComp,"");
                                if (listComp.size()>0 && type == 0){
                                    PaySlipComp paySlipComp = (PaySlipComp) listComp.get(0);
                                    allowance = allowance + paySlipComp.getCompValue();
                                    total = total + allowance;
                                    %>
                                    <tr>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=No+1%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle" ><%=emp.getEmployeeNum()%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=emp.getFullName()%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=lvl.getLevel()%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=div.getDivision()%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle">0</td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle">0</td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle">0</td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle">0</td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle">0</td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(duration),"#,###.##"))%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=emp.getNoRekening()%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=Formater.formatNumber(allowance,"#,###.##")%></td>
                                    </tr>
                                    <%
                                    No++;
                                }



                            }
                        }
                    }
                } catch (Exception exc){

                }
                
            %>
            <tr>
                    <%
						if (type == 0){ 
					%>
						<td colspan="12" rowspan="1">&nbsp;</td>
					<%
						} else {
					%>
						<td colspan="7" rowspan="1">&nbsp;</td>
					<%
						}
					%>
                    <td><%=Formater.formatNumber(total,"#,###.##")%></td>
            </tr>
        </table>
<%              
            }
         
%>
    </body>
</html>



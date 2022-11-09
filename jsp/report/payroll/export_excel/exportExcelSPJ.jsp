<%-- 
    Document   : exportExcelSPJ
    Created on : 01-Jun-2017, 17:35:34
    Author     : GUSWIK
--%>

<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDocListExpense"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstGradeLevel"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDocField"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDocList"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpDocSpj"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpCategory"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.system.entity.PstSystemProperty"%>
<%@page import="com.dimata.qdep.form.FRMMessage"%>
<%@page import="com.dimata.harisma.session.attendance.rekapitulasiabsensi.RekapitulasiAbsensi"%>
<%@page import="com.dimata.qdep.form.FRMHandler"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPeriod"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDoc"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="java.util.Vector"%>
<!DOCTYPE html>
<%@page contentType="application/x-msexcel" pageEncoding="UTF-8"%>
<%



    String source = FRMQueryString.requestString(request, "source");
    long periodId = FRMQueryString.requestLong(request, "periodId");
    String[] stsEmpCategory = null;
    int sizeCategory = PstEmpCategory.listAll() != null ? PstEmpCategory.listAll().size() : 0;
    stsEmpCategory = new String[sizeCategory];
    String stsEmpCategorySel = "";
    int maxEmpCat = 0;
    for (int j = 0; j < sizeCategory; j++) {
        String name = "EMP_CAT_" + j;
        String val = FRMQueryString.requestString(request, name);
        stsEmpCategory[j] = val;
        if (val != null && val.length() > 0) {
            //stsEmpCategorySel.add(""+val); 
            stsEmpCategorySel = stsEmpCategorySel + val + ",";
        }
        maxEmpCat++;
    }

    PayPeriod period = new PayPeriod();
    try {
        period = PstPayPeriod.fetchExc(periodId);
    } catch (Exception exc) {
    }


    //    OID_DAILYWORKER
    long Dw = 0;
    try {
        String sDw = PstSystemProperty.getValueByName("OID_DAILYWORKER");
        Dw = Integer.parseInt(sDw);
    } catch (Exception ex) {
        System.out.println("VALUE_DAILYWORKER NOT Be SET" + ex);
    }
    
    
    String oidDocSpjKurang40 = "";
    try {
        oidDocSpjKurang40 = PstSystemProperty.getValueByName("OID_SPJKR40_DOC");
    } catch (Exception ex) {
        System.out.println("OID_SPJKR40_DOC NOT Be SET" + ex);
    }
    
    String oidDocSpjLebih40 = "";
    try {
        oidDocSpjLebih40 = PstSystemProperty.getValueByName("OID_SPJLB40_DOC");
    } catch (Exception ex) {
        System.out.println("OID_SPJLB40_DOC NOT Be SET" + ex);
    }
    
    int iCommand = FRMQueryString.requestCommand(request);
    int iErrCode = FRMMessage.NONE;
    int start = FRMQueryString.requestInt(request, "start");

    RekapitulasiAbsensi rekapitulasiAbsensi = new RekapitulasiAbsensi();
    rekapitulasiAbsensi.setCompanyId(FRMQueryString.requestLong(request, "company_id"));
    //rekapitulasiAbsensi.setDeptId(FRMQueryString.requestLong(request, "department"));
    rekapitulasiAbsensi.addArrDivision(FRMHandler.getParamsStringValuesStatic(request, "division_id"));
    rekapitulasiAbsensi.addArrDepartment(FRMHandler.getParamsStringValuesStatic(request, "department"));
    rekapitulasiAbsensi.addArrSection(FRMHandler.getParamsStringValuesStatic(request, "section"));
    rekapitulasiAbsensi.addArrPosition(FRMHandler.getParamsStringValuesStatic(request, "position"));

    //rekapitulasiAbsensi.setSectionId(FRMQueryString.requestLong(request, "section"));
    //rekapitulasiAbsensi.setDivisionId(FRMQueryString.requestLong(request, "division_id"));

    rekapitulasiAbsensi.setSourceTYpe(FRMQueryString.requestInt(request, "source_type"));
    rekapitulasiAbsensi.setPeriodId(FRMQueryString.requestLong(request, "periodId"));
    rekapitulasiAbsensi.setDtFrom(period.getStartDate());
    rekapitulasiAbsensi.setDtTo(period.getEndDate());

    if (rekapitulasiAbsensi.getSourceTYpe() == 1 && rekapitulasiAbsensi.getPeriodId() != 0) {
        PayPeriod payPeriod = new PayPeriod();
        try {
            payPeriod = PstPayPeriod.fetchExc(rekapitulasiAbsensi.getPeriodId());
        } catch (Exception e) {
        }
        rekapitulasiAbsensi.setDtFrom(payPeriod.getStartDate());
        rekapitulasiAbsensi.setDtTo(payPeriod.getEndDate());
    }

    rekapitulasiAbsensi.setEmpCategory(stsEmpCategorySel);
    rekapitulasiAbsensi.setFullName(FRMQueryString.requestString(request, "full_name"));
    rekapitulasiAbsensi.setPayrollNumber(FRMQueryString.requestString(request, "emp_number"));
    rekapitulasiAbsensi.setResignSts(FRMQueryString.requestInt(request, "statusResign"));
    rekapitulasiAbsensi.setViewschedule(FRMQueryString.requestInt(request, "viewschedule"));
    int viewschedule = FRMQueryString.requestInt(request, "viewschedule");
    int OnlyDw = FRMQueryString.requestInt(request, "OnlyDw");
    if (OnlyDw != 0 && OnlyDw == 1) {
        rekapitulasiAbsensi.setEmpCategory(Dw + ",");
    }

    String whereClausePeriod = "";
    if (rekapitulasiAbsensi.getDtTo() != null && rekapitulasiAbsensi.getDtFrom() != null) {
        whereClausePeriod = "\"" + Formater.formatDate(rekapitulasiAbsensi.getDtTo(), "yyyy-MM-dd HH:mm:ss") + "\" >="
                + PstPeriod.fieldNames[PstPeriod.FLD_START_DATE] + " AND "
                + PstPeriod.fieldNames[PstPeriod.FLD_END_DATE] + " >= \"" + Formater.formatDate(rekapitulasiAbsensi.getDtFrom(), "yyyy-MM-dd HH:mm:ss") + "\"";
    }

Vector listEmployee = new Vector();
    if (iCommand == Command.LIST){
        listEmployee  = PstEmpDoc.listSpj(rekapitulasiAbsensi);
    }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Export SPJ</title>
    </head>
    <body>
        <div class="content-main">
            
                                
                <% if (iCommand == Command.LIST) {
                    if (listEmployee.size() > 0) {
          
                        
                %>
                <div class="formstyle">
                <h4><strong>Laporan SPJ Karyawan <%=period.getPeriod()%></strong></h4>
                <table class="tblStyle" border="1" width="80%" >
                    <tr>
                        <td width="1%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="1%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="4%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="4%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="4%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="4%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="4%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="5%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="5%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="7%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="5%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="5%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="7%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="4%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="4%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="4%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="4%" bgcolor="#FFFF33" align="center" valign="middle"><strong> </strong></td>
                        <td width="4%" colspan="6" bgcolor="#FFFF33" align="center" valign="middle"><strong>Pengikut    internal</strong></td>
                        <td width="4%" bgcolor="#FFFF33" align="center" valign="middle"><strong>Pengikut External</strong></td>
                        <td width="4%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Total Biaya</strong></td>
                    </tr>
                    <tr>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>No</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Nomor SPJ</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>TIPE SPJ</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Tanggal SPJ</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Tanggal Berangkat</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Tanggal Kembali</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>NRK / NKK</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Nama Petugas</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Grade Petugas</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Jabatan Petugas</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Divisi/Cabang Petugas</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Tempat Tujuan</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Keperluan</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>angkutan</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Nama TTD</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Jabatan TTD</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>BIAYA</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>NRK / NKK</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Nama</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Grade</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Jabatan</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Divisi/Cabang</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Biaya</strong></td>
                        <td bgcolor="#FFFF33" align="center" valign="middle"><strong>Nama</strong></td>
                    </tr>
                    
                    <% for (int x=0; x<listEmployee.size(); x++){
                       EmpDocSpj empDocSpj = (EmpDocSpj) listEmployee.get(x);
                       
                       Employee employee = new Employee();
                       try {
                           employee = PstEmployee.fetchExc(empDocSpj.getEmployeeId());
                       }catch (Exception e){
                           System.out.println(" error out : "+e);
                       }
                       
                       Employee employeeTTD = new Employee();
                       try {
                           
                           long empId = PstEmpDocList.getEmployeeIdByObjectnameEmpDocId("TRAINNER3", empDocSpj.getEmpDocId());
                           employeeTTD = PstEmployee.fetchExc(empId);
                       }catch (Exception e){
                           System.out.println(" error out : "+e);
                       }
                       
                        Vector listpengikut = new Vector();
                       try {
                           String listpengikutS = PstEmpDocList.listEmployeeId(empDocSpj.getEmpDocId(), "TRAINNERLISTLINE");
                           listpengikut = PstEmployee.list(0, 0, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " IN ("+listpengikutS+")" , "");
                       }catch (Exception e){
                           System.out.println(" error out : "+e);
                       }
                        
                        double totalValue = PstEmpDocListExpense.getTotalExpensesEmployee(empDocSpj.getEmpDocId(), employee.getOID());
                        double totalSpj = PstEmpDocListExpense.getTotalExpenses(empDocSpj.getEmpDocId());
                        DecimalFormat kurs = (DecimalFormat) DecimalFormat.getCurrencyInstance();
                        DecimalFormatSymbols formatRp = new DecimalFormatSymbols();

                        formatRp.setCurrencySymbol("Rp. ");
                        formatRp.setMonetaryDecimalSeparator(',');
                        formatRp.setGroupingSeparator('.');

                        kurs.setDecimalFormatSymbols(formatRp);
                       
                    %>
                    
                    <tr>
                        <td rowspan="<%=listpengikut.size()%>"><%=(x+1)%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=empDocSpj.getDocNumber()%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=(oidDocSpjLebih40.contains(""+empDocSpj.getDocMasterId())?"SPJ > 40KM":"SPJ < 40KM" )%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=empDocSpj.getRequestDate()%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=PstEmpDocField.getvalueByObjectnameEmpDocId("TGL_BERANGKAT", empDocSpj.getEmpDocId())%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=PstEmpDocField.getvalueByObjectnameEmpDocId("TGL_KEMBALI", empDocSpj.getEmpDocId())%></td>
                        <td rowspan="<%=listpengikut.size()%>">="<%=employee.getEmployeeNum()%>"</td>
                        <td rowspan="<%=listpengikut.size()%>"><%=empDocSpj.getFullName()%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=PstGradeLevel.getGradeLevelName(""+employee.getGradeLevelId())%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=PstPosition.getPositionName(""+empDocSpj.getPositionId())%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=PstDivision.getDivisionName(employee.getDivisionId())%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=PstEmpDocField.getvalueByObjectnameEmpDocId("TUJUAN", empDocSpj.getEmpDocId())%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=PstEmpDocField.getvalueByObjectnameEmpDocId("KEPERLUAN", empDocSpj.getEmpDocId())%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=PstEmpDocField.getvalueByObjectnameEmpDocId("ANGKUTAN", empDocSpj.getEmpDocId())%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=employeeTTD.getFullName()%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=PstPosition.getPositionName(""+employeeTTD.getPositionId())%></td>
                        <td rowspan="<%=listpengikut.size()%>"><%=kurs.format(totalValue)%></td>
                       
                        <%
                        Employee employeeFirst = new Employee();
                        try{
                            employeeFirst = (Employee) listpengikut.get(0);
                        }catch(Exception e){
                            System.out.println(" exc : "+e);
                        }
                        
                        double totalValueFirst = PstEmpDocListExpense.getTotalExpensesEmployee(empDocSpj.getEmpDocId(), employeeFirst.getOID());
                        
                        formatRp.setCurrencySymbol("Rp. ");
                        formatRp.setMonetaryDecimalSeparator(',');
                        formatRp.setGroupingSeparator('.');
                        
                        %>
                        <td>="<%=employeeFirst.getEmployeeNum()%>"</td>
                        <td><%=employeeFirst.getFullName()%></td>
                        <td><%=PstGradeLevel.getGradeLevelName(""+employeeFirst.getGradeLevelId())%></td>
                        <td><%=PstPosition.getPositionName(""+employeeFirst.getPositionId())%></td>
                        <td><%=PstDivision.getDivisionName(employeeFirst.getDivisionId())%></td>
                        <td><%=kurs.format(totalValueFirst)%></td>
                        <td>-</td>
                        <td rowspan="<%=listpengikut.size()%>"><%=kurs.format(totalSpj)%></td>
                    </tr>
                    
                    <%
                    if (listpengikut.size()>1){
                        
                        for (int i=1; i<listpengikut.size(); i++){
                            Employee employeeList = (Employee) listpengikut.get(i);
                            double totalValueList = PstEmpDocListExpense.getTotalExpensesEmployee(empDocSpj.getEmpDocId(), employeeList.getOID());

                            formatRp.setCurrencySymbol("Rp. ");
                            formatRp.setMonetaryDecimalSeparator(',');
                            formatRp.setGroupingSeparator('.');
                        
                    %>
                     <tr>
                        <td>="<%=employeeList.getEmployeeNum()%>"</td>
                        <td><%=employeeList.getFullName()%></td>
                        <td><%=PstGradeLevel.getGradeLevelName(""+employeeList.getGradeLevelId())%></td>
                        <td><%=PstPosition.getPositionName(""+employeeList.getPositionId())%></td>
                        <td><%=PstDivision.getDivisionName(employeeList.getDivisionId())%></td>
                        <td><%=kurs.format(totalValueList)%></td>
                        <td>-</td>
                    </tr>
                    <%
                        }
                    }
                    %>
                    
                   
                    <% } %>
                </table>

                <%
                } else {
                %>
                <h6><strong>Tidak ada data</strong></h6>
                <%     }
                    }
                %>
                </div>
        </div>
    </body>
</html>

<%-- 
    Document   : warning_ajax_valid_until
    Created on : Nov 5, 2021, 3:27:01 PM
    Author     : keys
--%>

<%@page import="com.dimata.harisma.entity.employee.PstEmpWarning"%>
<%@page import="com.dimata.harisma.entity.employee.EmpWarning"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.Catch"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstWarning"%>
<%@page import="com.dimata.harisma.entity.masterdata.Warning"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.form.employee.FrmEmpWarning"%>
<%@page import="com.dimata.gui.jsp.ControlDate"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    
    int iCommand = FRMQueryString.requestInt(request, "iCommand");
    long oidWarningLevel = Long.valueOf(FRMQueryString.requestString(request, "oidWarningLevel"));
    long oidWarning = Long.valueOf(FRMQueryString.requestString(request, "oidWarning"));
    String sWarningDate = FRMQueryString.requestString(request, "warningDate");
    String type = FRMQueryString.requestString(request, "type");
    
    try{
        Warning objWarningLevel = new Warning();
        EmpWarning objEmpWarning = new EmpWarning();
        Date warningDate =  new SimpleDateFormat("yyyy-MM-dd").parse(sWarningDate);  
        if(oidWarningLevel  != 0 ){
            objWarningLevel = PstWarning.fetchExc(oidWarningLevel);
        }
        if(oidWarning != 0){
            objEmpWarning = PstEmpWarning.fetchExc(oidWarning);
        }
    
    if(iCommand == Command.ADD) {
    
       Calendar cal = new GregorianCalendar();
       cal.setTime(warningDate);
       if(objWarningLevel.getSatuanValidUntil() == PstWarning.SATUAN_VALID_UNTIL_BULANAN){
           cal.add(Calendar.MONTH, objWarningLevel.getValidUntil());
       }else{
           cal.add(Calendar.DATE, objWarningLevel.getValidUntil());
       }
       
       Date date = new Date(cal.get(Calendar.YEAR) - 1900, cal.get(Calendar.MONTH), cal.get(Calendar.DATE));
       out.println(ControlDate.drawDateWithStyle(FrmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_VALID_DATE], date, 2, -30, "formElemen", "style='display: none'"));
       out.println(ControlDate.drawDateWithStyle(FrmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_VALID_DATE]+"SHOW", date, 2, -30, "formElemen", "disabled =\"disabled\""));
    }else{
        if(type.equals("load")){
                out.println(ControlDate.drawDateWithStyle(FrmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_VALID_DATE], objEmpWarning.getValidityDate(), 2, -30,"formElemen", "style='display: none'")); 
                out.println(ControlDate.drawDateWithStyle(FrmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_VALID_DATE]+"SHOW", objEmpWarning.getValidityDate(), 2, -30, "formElemen", "disabled =\"disabled\""));
        }else{
                Calendar cal = new GregorianCalendar();
                cal.setTime(warningDate);
                if(objWarningLevel.getSatuanValidUntil() == PstWarning.SATUAN_VALID_UNTIL_BULANAN){
                    cal.add(Calendar.MONTH, objWarningLevel.getValidUntil());
                }else{
                    cal.add(Calendar.DATE, objWarningLevel.getValidUntil());
                }

                Date date = new Date(cal.get(Calendar.YEAR) - 1900, cal.get(Calendar.MONTH), cal.get(Calendar.DATE));
                out.println(ControlDate.drawDateWithStyle(FrmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_VALID_DATE], date, 2, -30, "formElemen", "style='display: none'"));
                out.println(ControlDate.drawDateWithStyle(FrmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_VALID_DATE]+"SHOW", date, 2, -30, "formElemen", "disabled =\"disabled\""));   
        }
    }
    
    }catch(Exception exc){
    System.out.println("Error : "+exc);
    }
   
%>

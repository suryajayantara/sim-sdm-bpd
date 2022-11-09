<%-- 
    Document   : reprimand_ajax_valid_until
    Created on : Nov 5, 2021, 5:27:19 PM
    Author     : keys
--%>
<%@page import="com.dimata.harisma.form.employee.FrmEmpReprimand"%>
<%@page import="com.dimata.gui.jsp.ControlDate"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmpReprimand"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstReprimand"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.dimata.harisma.entity.employee.EmpReprimand"%>
<%@page import="com.dimata.harisma.entity.masterdata.Reprimand"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%
      
    int iCommand = FRMQueryString.requestInt(request, "iCommand");
    long oidReprimandLevel = Long.valueOf(FRMQueryString.requestString(request, "oidReprimandLevel"));
    long oidReprimand = Long.valueOf(FRMQueryString.requestString(request, "oidReprimand"));
    String sReprimandDate = FRMQueryString.requestString(request, "reprimandDate");
    String type = FRMQueryString.requestString(request, "type");
    
    try{
        Reprimand objReprimandLevel = new Reprimand();
        EmpReprimand objEmpReprimand = new EmpReprimand();
        Date warningDate =  new SimpleDateFormat("yyyy-MM-dd").parse(sReprimandDate);  
        if(oidReprimandLevel  != 0 ){
            objReprimandLevel = PstReprimand.fetchExc(oidReprimandLevel);
        }
        if(oidReprimand != 0){
            objEmpReprimand = PstEmpReprimand.fetchExc(oidReprimand);
        }
    
    if(iCommand == Command.ADD) {
    
       Calendar cal = new GregorianCalendar();
       cal.setTime(warningDate);
       if(objReprimandLevel.getSatuanValidUntil() == PstReprimand.SATUAN_VALID_UNTIL_BULANAN){
           cal.add(Calendar.MONTH, objReprimandLevel.getValidUntil());
       }else{
           cal.add(Calendar.DATE, objReprimandLevel.getValidUntil());
       }
       
       Date date = new Date(cal.get(Calendar.YEAR) - 1900, cal.get(Calendar.MONTH), cal.get(Calendar.DATE));
       out.println(ControlDate.drawDateWithStyle(FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_VALID_UNTIL], date, 2, -30, "formElemen", "style='display: none'"));
        out.println(ControlDate.drawDateWithStyle(FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_VALID_UNTIL]+"SHOW", date, 2, -30, "formElemen", "disabled =\"disabled\""));
    }else{
       if(type.equals("load")){
                out.println(ControlDate.drawDateWithStyle(FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_VALID_UNTIL], objEmpReprimand.getValidityDate(), 2, -30, "formElemen", "style='display: none'")); 
                out.println(ControlDate.drawDateWithStyle(FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_VALID_UNTIL], objEmpReprimand.getValidityDate(), 2, -30, "formElemen", "disabled =\"disabled\"")); 
       }else{
                Calendar cal = new GregorianCalendar();
                cal.setTime(warningDate);
                if(objReprimandLevel.getSatuanValidUntil() == PstReprimand.SATUAN_VALID_UNTIL_BULANAN){
                    cal.add(Calendar.MONTH, objReprimandLevel.getValidUntil());
                }else{
                    cal.add(Calendar.DATE, objReprimandLevel.getValidUntil());
                }

                Date date = new Date(cal.get(Calendar.YEAR) - 1900, cal.get(Calendar.MONTH), cal.get(Calendar.DATE));
                out.println(ControlDate.drawDateWithStyle(FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_VALID_UNTIL], date, 2, -30, "formElemen", "style='display: none'"));
                out.println(ControlDate.drawDateWithStyle(FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_VALID_UNTIL]+"SHOW", date, 2, -30, "formElemen", "disabled =\"disabled\""));
       }
    }
    
    }catch(Exception exc){
    System.out.println("Error : "+exc);
    }

%>
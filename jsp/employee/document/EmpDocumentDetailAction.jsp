<%-- 
    Document   : Doc Master Action
    Created on : Sep 12, 2015, 3:56:51 PM
    Author     : Priska Suryana
--%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlipComp"%>
<%@page import="com.dimata.harisma.entity.payroll.PaySlipComp"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlip"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.session.attendance.SessEmpSchedule"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.harisma.entity.recruitment.PstRecrApplication"%>
<%@page import="com.dimata.harisma.entity.recruitment.RecrApplication"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayEmpLevel"%>
<%@page import="com.dimata.harisma.entity.payroll.PayEmpLevel"%>
<%@page import="com.dimata.harisma.entity.payroll.PstSalaryLevel"%>
<%@page import="com.dimata.harisma.entity.payroll.SalaryLevel"%>
<%@page import="com.dimata.qdep.db.DBException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="javax.print.DocFlavor.STRING"%>
<%@page import="org.apache.poi.ss.formula.functions.Hlookup"%>
<%@page import="com.dimata.harisma.entity.attendance.I_Atendance"%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package harisma -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.form.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_DIVISION);%>
<%@ include file = "../../main/checkuser.jsp" %>


<%
    int iCommand = FRMQueryString.requestCommand(request);
    boolean status = false;
    int iErrCode = FRMMessage.ERR_NONE;
    String msgString = "";
    String msgStringAll = "";
    long oidEmpDoc = FRMQueryString.requestLong(request, "oidEmpDoc");
    long oidEmpDocAction = FRMQueryString.requestLong(request, "oidEmpDocAction");
    int saveType = FRMQueryString.requestInt(request, "saveType");
    long oidDocAction = FRMQueryString.requestLong(request, "oidDocAction");
    /* add field by hendra putu | 2016-11-13 */
    int typeAction = FRMQueryString.requestInt(request, "type_action");
    ChangeValue changeValue = new ChangeValue();

    long oidCustomFieldSkNumber = 504404604604804494l;
    long oidCustomFieldSkDate = 504404604604883215l;
    long oidCustomFieldEmpNum = 504404615079209747l;

    EmpDoc empDocX = new EmpDoc();
    try {
        empDocX = PstEmpDoc.fetchExc(oidEmpDoc);
    } catch (Exception e) {
    }

    String testData = "";

    CtrlEmpDocAction ctrlEmpDocAction = new CtrlEmpDocAction(request);
    ControlLine ctrLine = new ControlLine();
    /*switch statement */

    /* end switch*/
    //FrmEmpDocAction frmEmpDocAction = ctrlEmpDocAction.getForm();
    //EmpDocAction empDocAction = ctrlEmpDocAction.getdEmpDocAction();
    msgString = ctrlEmpDocAction.getMessage();

    //untuk mengambil list param
    DocMasterAction docMasterAction = new DocMasterAction();
    try {
        docMasterAction = PstDocMasterAction.fetchExc(oidDocAction);
    } catch (Exception e) {
        System.out.println("docMasterAction"+e.toString());
    }

    Hashtable hDocMasterAction = new Hashtable();
    if (docMasterAction != null) {
        String whereClause = PstDocMasterActionParam.fieldNames[PstDocMasterActionParam.FLD_DOC_ACTION_ID] + " = " + docMasterAction.getOID();
        hDocMasterAction = PstDocMasterActionParam.hList(0, 0, whereClause, "");


    }

    //untuk employee Mutation
    DocMasterActionParam docMasterActionParam1 = new DocMasterActionParam();
    Vector listEmp = new Vector();

    //untuk mutasi
    String newCompanyS = "";
    String newDivisionS = "";
    String newDepartmentS = "";
    String newEmpCatS = "";
    String newLevelS = "";
    String newPositionS = "";
    String newSectionS = "";
    String workFromS = "";

    //untuk upsalary
    String newSalaryLevel = "";

	//untuk approval replacement
	String divisionRep = "";
	String upPositionRep = "";
	String downPositionRep = "";
	String startDateRep = "";
	String endDateRep = "";


    boolean valid = true;

    if (docMasterAction.getActionName().equals(DocMasterActionClass.actionKey[0])) {
        docMasterActionParam1 = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][0]);


        String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + docMasterActionParam1.getObjectName() + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
        listEmp = PstEmpDocList.list(0, 0, whereC, ""); //ini daftar orangnya 

        CareerPath careerPathTemp = new CareerPath();

        DocMasterActionParam docMasterActionParamForCompany = new DocMasterActionParam();
        docMasterActionParamForCompany = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][1]);
        String newObjectNameForCompany = (String) docMasterActionParamForCompany.getObjectName();
        String newValueForCompany = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForCompany, oidEmpDoc);
        String getClassNameForCompany = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForCompany, oidEmpDoc);
        if (getClassNameForCompany.equals("COMPANY")) {
            long newValuetoLong = Long.parseLong(newValueForCompany);
            careerPathTemp.setCompanyId(newValuetoLong);
            try {
                Company company = PstCompany.fetchExc(newValuetoLong);
                newCompanyS = company.getCompany();
                careerPathTemp.setCompany(company.getCompany());
            } catch (Exception e) {
            }

        }



        //cari tahu ini untuk perubahan apa Divisi
        DocMasterActionParam docMasterActionParamForDivision = new DocMasterActionParam();
        docMasterActionParamForDivision = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][2]);
        String newObjectNameForDivision = (String) docMasterActionParamForDivision.getObjectName();
        String newValueForDivision = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForDivision, oidEmpDoc);
        String getClassNameForDivision = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForDivision, oidEmpDoc);
        if (getClassNameForDivision.equals("DIVISION")) {
            long newValuetoLong = Long.parseLong(newValueForDivision);
            careerPathTemp.setDivisionId(newValuetoLong);
            try {
                Division division = PstDivision.fetchExc(newValuetoLong);
                newDivisionS = division.getDivision();
                careerPathTemp.setDivision(division.getDivision());
            } catch (Exception e) {
            }

        }


        //cari tahu ini untuk perubahan apa
        DocMasterActionParam docMasterActionParamForDepartment = new DocMasterActionParam();
        docMasterActionParamForDepartment = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][3]);
        String newObjectNameForDepartment = (String) docMasterActionParamForDepartment.getObjectName();
        String newValueForDepartment = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForDepartment, oidEmpDoc);
        String getClassNameForDepartment = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForDepartment, oidEmpDoc);
        if (getClassNameForDepartment.equals("DEPARTMENT")) {
            long newValuetoLong = Long.parseLong(newValueForDepartment);
            careerPathTemp.setDepartmentId(newValuetoLong);
            try {
                Department department = PstDepartment.fetchExc(newValuetoLong);
                newDepartmentS = department.getDepartment();
                careerPathTemp.setDepartment(department.getDepartment());
            } catch (Exception e) {
            }

        }

        //cari tahu ini untuk perubahan apa 
        DocMasterActionParam docMasterActionParamForEmpCat = new DocMasterActionParam();
        docMasterActionParamForEmpCat = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][4]);
        String newObjectNameForEmpCat = (String) docMasterActionParamForEmpCat.getObjectName();
        String newValueForEmpCat = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForEmpCat, oidEmpDoc);
        String getClassNameForEmpCat = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForEmpCat, oidEmpDoc);
        if (getClassNameForEmpCat.equals("EMPCAT")) {
            long newValuetoLong = Long.parseLong(newValueForEmpCat);
            careerPathTemp.setEmpCategoryId(newValuetoLong);
            try {
                EmpCategory empCategory = PstEmpCategory.fetchExc(newValuetoLong);
                newEmpCatS = empCategory.getEmpCategory();
                careerPathTemp.setEmpCategoryId(newValuetoLong);
            } catch (Exception e) {
            }

        }

        //cari tahu ini untuk perubahan apa 
        DocMasterActionParam docMasterActionParamForLevel = new DocMasterActionParam();
        docMasterActionParamForLevel = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][5]);
        String newObjectNameForLevel = (String) docMasterActionParamForLevel.getObjectName();
        String newValueForLevel = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForLevel, oidEmpDoc);
        String getClassNameForLevel = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForLevel, oidEmpDoc);
        if (getClassNameForLevel.equals("LEVEL")) {
            long newValuetoLong = Long.parseLong(newValueForLevel);
            careerPathTemp.setLevelId(newValuetoLong);
            try {
                Level level = PstLevel.fetchExc(newValuetoLong);
                newLevelS = level.getLevel();
                careerPathTemp.setLevel(level.getLevel());
            } catch (Exception e) {
            }

        }


        //cari tahu ini untuk perubahan apa
        DocMasterActionParam docMasterActionParamForPosition = new DocMasterActionParam();
        docMasterActionParamForPosition = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][6]);
        String newObjectNameForPosition = (String) docMasterActionParamForPosition.getObjectName();
        String newValueForPosition = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForPosition, oidEmpDoc);
        String getClassNameForPosition = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForPosition, oidEmpDoc);
        if (getClassNameForPosition.equals("POSITION")) {
            long newValuetoLong = Long.parseLong(newValueForPosition);
            careerPathTemp.setPositionId(newValuetoLong);
            try {
                Position position = PstPosition.fetchExc(newValuetoLong);
                newPositionS = position.getPosition();
                careerPathTemp.setPosition(position.getPosition());
            } catch (Exception e) {
            }

        }

        DocMasterActionParam docMasterActionParamForSection = new DocMasterActionParam();
        docMasterActionParamForSection = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][7]);
        String newObjectNameForSection = (String) docMasterActionParamForSection.getObjectName();
        String newValueForSection = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForSection, oidEmpDoc);
        String getClassNameForSection = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForSection, oidEmpDoc);
        if (getClassNameForSection.equals("SECTION")) {
            long newValuetoLong = Long.parseLong(newValueForSection);
            careerPathTemp.setSectionId(newValuetoLong);
            try {
                Section section = PstSection.fetchExc(newValuetoLong);
                newSectionS = section.getSection();
                careerPathTemp.setSection(section.getSection());
            } catch (Exception e) {
            }
        }

        DocMasterActionParam docMasterActionParamForWorkTo = new DocMasterActionParam();
        docMasterActionParamForWorkTo = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][8]);
        String newObjectNameForWorkTo = (String) docMasterActionParamForWorkTo.getObjectName();
        String newValueForWorkTo = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForWorkTo, oidEmpDoc);
        //String getClassNameForWorkTo = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForWorkTo, oidEmpDoc);
        Date dateF = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        try {
            dateF = formatter.parse(newValueForWorkTo);
            careerPathTemp.setWorkFrom(dateF);
            workFromS = "" + dateF;
        } catch (Exception e) {
        }




        if (iCommand == Command.SAVE) {
            for (int list = 0; list < listEmp.size(); list++) {

                EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                Employee employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                Hashtable HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());

                CareerPath careerPath = new CareerPath();

                careerPath.setCompanyId(employeeFetch.getCompanyId());
                try {
                    Company company = PstCompany.fetchExc(employeeFetch.getCompanyId());
                    careerPath.setCompany(company.getCompany());
                } catch (Exception e) {
                }

                careerPath.setDivisionId(employeeFetch.getDivisionId());
                try {
                    Division division = PstDivision.fetchExc(employeeFetch.getDivisionId());
                    careerPath.setDivision(division.getDivision());
                } catch (Exception e) {
                }

                careerPath.setDepartmentId(employeeFetch.getDepartmentId());
                try {
                    Department department = PstDepartment.fetchExc(employeeFetch.getDepartmentId());
                    careerPath.setDepartment(department.getDepartment());
                } catch (Exception e) {
                }

                careerPath.setSectionId(employeeFetch.getSectionId());
                try {
                    Department department = PstDepartment.fetchExc(employeeFetch.getSectionId());
                    careerPath.setDepartment(department.getDepartment());
                } catch (Exception e) {
                }

                careerPath.setEmpCategoryId(employeeFetch.getEmpCategoryId());
                try {
                    EmpCategory empCategory = PstEmpCategory.fetchExc(employeeFetch.getEmpCategoryId());
                    careerPath.setEmpCategory(empCategory.getEmpCategory());
                } catch (Exception e) {
                }

                careerPath.setPositionId(employeeFetch.getPositionId());
                try {
                    Position position = PstPosition.fetchExc(employeeFetch.getPositionId());
                    careerPath.setPosition(position.getPosition());
                } catch (Exception e) {
                }

                careerPath.setLevelId(employeeFetch.getLevelId());
                try {
                    Level level = PstLevel.fetchExc(employeeFetch.getLevelId());
                    careerPath.setLevel(level.getLevel());
                } catch (Exception e) {
                }


//mencari work from
                String whereClause = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID] + " = " + employeeFetch.getOID();
                String orderClause = PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM];
                Vector objectClass = PstCareerPath.list(0, 0, whereClause, orderClause);
                CareerPath careerPath1 = new CareerPath();
                if (objectClass.size() > 0) {
                    careerPath1 = (CareerPath) objectClass.get(objectClass.size() - 1);
                    Date fromWork = careerPath1.getWorkTo();
                    fromWork.setDate(fromWork.getDate() + 1);
                    String str_dt_WorkFrom = "";
                    try {
                        Date dt_WorkFrom = fromWork;
                        if (dt_WorkFrom == null) {
                            dt_WorkFrom = new Date();
                        }
                        careerPath.setWorkFrom(dt_WorkFrom);
                        // str_dt_WorkFrom = Formater.formatDate(dt_WorkFrom, "dd MMMM yyyy");
                    } catch (Exception e) {
                        //str_dt_WorkFrom = "";
                    }



                } else {
                    careerPath.setWorkFrom(employeeFetch.getCommencingDate());
                    //rowx.add(""+employee.getCommencingDate());
                }

                careerPath.setEmployeeId(employeeFetch.getOID());
                if (careerPath.getWorkFrom() != null) {
                    Date careerDateWorkTo = careerPath.getWorkFrom();
                    careerDateWorkTo.setDate(careerDateWorkTo.getDate() - 1);
                    careerPath.setWorkTo(careerDateWorkTo);
                } else {
                    careerPath.setWorkTo(new Date());
                }

                careerPath.setEmployeeId(employeeFetch.getOID());


                long oidCareerPath = 0;

                Vector data = new Vector();
                int cheked = 0;
                try {
                    cheked = FRMQueryString.requestInt(request, "userSelect" + employeeFetch.getOID());
                } catch (Exception e) {
                }
                if ((employeeFetch.getOID() != 0) && (cheked > 0)) {
                    long oidEmp = employeeFetch.getOID();
                    data = PstCareerPath.dateCareerPath(oidEmp);

                    if (data != null && data.size() > 0) {
                        for (int i = 0; i < data.size(); i++) {
                            CareerPath care = (CareerPath) data.get(i);
                            if (careerPath != null && care != null && care.getWorkFrom() != null && care.getWorkTo() != null && careerPath.getWorkFrom() != null && careerPath.getWorkTo() != null) {
                                java.util.Date newStartDate = care.getWorkFrom();
                                java.util.Date newEndDate = care.getWorkTo();
                                java.util.Date startDate = careerPath.getWorkFrom();
                                java.util.Date endDate = careerPath.getWorkTo();
                                String sTanggalTo = Formater.formatDate(newStartDate, "dd-MM-yyyy");
                                String sTanggalFrom = Formater.formatDate(newEndDate, "dd-MM-yyyy");
                                String Error = "" + sTanggalTo + " TO " + sTanggalFrom;
                                if ((oidCareerPath != 0 ? (care.getOID() == oidCareerPath ? false : true) : care.getOID() != oidCareerPath) && newStartDate.after(careerPath.getWorkFrom()) && newStartDate.before(careerPath.getWorkTo())) {
                                    valid = false;
                                    msgString = "Tanggal yang diinputkan sudah ada" + " please check other Career Path form on the same range:" + " <a href=\"javascript:openLeaveOverlap(\'" + care.getOID() + "\');\">" + Error + "</a> ; ";
                                } else if ((oidCareerPath != 0 ? (care.getOID() == oidCareerPath ? false : true) : care.getOID() != oidCareerPath) && newEndDate.after(startDate) && newEndDate.before(endDate)) {
                                    valid = false;
                                    msgString = "Tanggal yang diinputkan sudah ada" + " please check other Career Path form on the same range:" + " <a href=\"javascript:openLeaveOverlap(\'" + care.getOID() + "\');\">" + Error + "</a> ; ";
                                } else if ((oidCareerPath != 0 ? (care.getOID() == oidCareerPath ? false : true) : care.getOID() != oidCareerPath) && startDate.after(newStartDate) && startDate.before(newEndDate)) {
                                    valid = false;
                                    msgString = "Tanggal yang diinputkan sudah ada" + " please check other Career Path form on the same range:" + " <a href=\"javascript:openLeaveOverlap(\'" + care.getOID() + "\');\">" + Error + "</a> ; ";
                                } else if ((oidCareerPath != 0 ? (care.getOID() == oidCareerPath ? false : true) : care.getOID() != oidCareerPath) && endDate.after(newStartDate) && endDate.before(newEndDate)) {
                                    valid = false;
                                    msgString = "Tanggal yang diinputkan sudah ada" + " please check other Career Path form on the same range:" + " <a href=\"javascript:openLeaveOverlap(\'" + care.getOID() + "\');\">" + Error + "</a> ; ";
                                } else if ((oidCareerPath != 0 ? (care.getOID() == oidCareerPath ? false : true) : care.getOID() != oidCareerPath) && newStartDate.equals(startDate) && newEndDate.equals(endDate)) {
                                    valid = false;
                                    msgString = "Tanggal yang diinputkan sudah ada" + " please check other Career Path form on the same range:" + " <a href=\"javascript:openLeaveOverlap(\'" + care.getOID() + "\');\">" + Error + "</a> ; ";
                                }


                            }
                        }
                    }

                    if (valid) {
                        try {
                            long oid = PstCareerPath.insertExc(careerPath);
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                        } catch (DBException dbexc) {
                        }
                    }
                    employeeFetch.setCompanyId(careerPathTemp.getCompanyId());
                    employeeFetch.setDivisionId(careerPathTemp.getDivisionId());
                    employeeFetch.setDepartmentId(careerPathTemp.getDepartmentId());
                    employeeFetch.setSectionId(careerPathTemp.getSectionId());
                    employeeFetch.setEmpCategoryId(careerPathTemp.getEmpCategoryId());
                    employeeFetch.setLevelId(careerPathTemp.getLevelId());
                    employeeFetch.setPositionId(careerPathTemp.getPositionId());


                    if (valid) {
                        try {
                            long oid = PstEmployee.updateExc(employeeFetch);
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                        } catch (DBException dbexc) {
                        }
                    }
                }


            }
        }
    } else if (docMasterAction.getActionName().equals(DocMasterActionClass.actionKey[1])) {

        docMasterActionParam1 = (DocMasterActionParam) hDocMasterAction.get("Employee to Update Salary Level");


        String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + docMasterActionParam1.getObjectName() + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
        listEmp = PstEmpDocList.list(0, 0, whereC, ""); //ini daftar orangnya                      

        long newsalevel = 0;
        String levelCode = "";
        //cari tahu ini untuk perubahan apa
        DocMasterActionParam docMasterActionParamForSalaryLevel = new DocMasterActionParam();
        docMasterActionParamForSalaryLevel = (DocMasterActionParam) hDocMasterAction.get("New Salary Level");
        String newObjectNameForSalaryLevel = (String) docMasterActionParamForSalaryLevel.getObjectName();
        String newValueForSalaryLevel = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForSalaryLevel, oidEmpDoc);
        String getClassNameForSalaryLevel = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForSalaryLevel, oidEmpDoc);
        if (getClassNameForSalaryLevel.equals("SALARYLEVEL")) {
            long newValuetoLong = Long.parseLong(newValueForSalaryLevel);
            newsalevel = newValuetoLong;
            try {
                SalaryLevel salaryLevel = PstSalaryLevel.fetchExc(newValuetoLong);
                newSalaryLevel = salaryLevel.getLevelName();
                levelCode = salaryLevel.getLevelCode();
            } catch (Exception e) {
            }

        }

        //new start date salary level
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        DocMasterActionParam docMasterActionParamForStartDateSalaryLevel = new DocMasterActionParam();
        docMasterActionParamForStartDateSalaryLevel = (DocMasterActionParam) hDocMasterAction.get("Start Date Salary Level");
        String newObjectNameForStartDateSalaryLevel = (String) docMasterActionParamForStartDateSalaryLevel.getObjectName();
        String newValueForStartDateSalaryLevel = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForStartDateSalaryLevel, oidEmpDoc);
        Date dateStartDateSalaryLevel = new Date();

        try {
            dateStartDateSalaryLevel = formatter.parse(newValueForStartDateSalaryLevel);
        } catch (Exception e) {
        }

        //end date salary level
        DocMasterActionParam docMasterActionParamForEndDateSalaryLevel = new DocMasterActionParam();
        docMasterActionParamForEndDateSalaryLevel = (DocMasterActionParam) hDocMasterAction.get("Start Date Salary Level");
        String newObjectNameForEndDateSalaryLevel = (String) docMasterActionParamForEndDateSalaryLevel.getObjectName();
        String newValueForEndDateSalaryLevel = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForEndDateSalaryLevel, oidEmpDoc);
        Date dateEndDateSalaryLevel = new Date();

        try {
            dateEndDateSalaryLevel = formatter.parse(newValueForEndDateSalaryLevel);
        } catch (Exception e) {
        }


        if (iCommand == Command.SAVE) {

            for (int list = 0; list < listEmp.size(); list++) {

                EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                Employee employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                Hashtable HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());
                PayEmpLevel payEmpLevel = new PayEmpLevel();

                String whereLevel1 = PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_EMPLOYEE_ID] + " = '" + (employeeFetch.getOID()) + "'";
                String orderDate1 = PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_START_DATE] + " DESC ";
                Vector listEmpLevelByEmployeeId1 = PstPayEmpLevel.list(0, 0, whereLevel1, orderDate1);
                if (listEmpLevelByEmployeeId1.size() > 0) {
                    try {
                        payEmpLevel = (PayEmpLevel) listEmpLevelByEmployeeId1.get(0);
                    } catch (Exception e) {
                    }
                }


                //out.println("payEmpLevelId  "+payEmpLevelId);
                // cari apakah id employee sudah ada di tabel atau belum untuk melakukan update status
                PayEmpLevel objPayEmp = new PayEmpLevel();
                String whereLevel = PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_EMPLOYEE_ID] + " = '" + (employeeFetch.getOID()) + "'";
                Vector listEmpLevelByEmployeeId = PstPayEmpLevel.list(0, 0, whereLevel, "");
                if (listEmpLevelByEmployeeId.size() > 0) {
                    objPayEmp = (PayEmpLevel) listEmpLevelByEmployeeId.get(0);
                    Date obj_start_date = objPayEmp.getStartDate();
                    Date date = new Date();
                    String s_date = Formater.formatDate(date, "yyyy-MM-dd");
                    Date dateInput = Formater.formatDate(s_date, "yyyy-MM-dd");
                    long duration = DateCalc.timeDifference(obj_start_date, dateInput);
                    if (duration > 0) {
                        PstPayEmpLevel.UpdateStatus(employeeFetch.getOID());
                    }
                }
                //PstPayEmpLevel.setupEmployee(Long.parseLong(employee_id[i]), s_salary_level,s_date, Long.parseLong(bank_name[i]),s_bank_acc,s_pos_for_tax,Integer.parseInt(period_begin[i]),Integer.parseInt(period_end[i]),s_com_status,s_prev_income,Integer.parseInt(prev_tax_paid[i] ));
                //PayEmpLevel payEmpLevel = new PayEmpLevel();
                payEmpLevel.setEmployeeId(employeeFetch.getOID());
                payEmpLevel.setLevelCode(levelCode);
                payEmpLevel.setStartDate(dateStartDateSalaryLevel);
                payEmpLevel.setEndDate(dateEndDateSalaryLevel);
                //payEmpLevel.setBankId(Long.parseLong(bank_name[i]));
                //payEmpLevel.setBankAccNr(s_bank_acc);
                //payEmpLevel.setPosForTax(s_pos_for_tax);
                //payEmpLevel.setPayPerBegin(Integer.parseInt(period_begin[i]));
                //payEmpLevel.setPayPerEnd(Integer.parseInt(period_end[i]));
                //payEmpLevel.setCommencingSt(Integer.parseInt(s_com_status));
                //payEmpLevel.setPrevIncome(Double.parseDouble(s_prev_income));
                //payEmpLevel.setPrevTaxPaid(Integer.parseInt(prev_tax_paid[i]));
                payEmpLevel.setStatusData(PstPayEmpLevel.CURRENT);
                //payEmpLevel.setMealAllowance(Integer.parseInt(meal_allowance[i]));
                //payEmpLevel.setOvtIdxType(Integer.parseInt(ovt_idx_type[i]));
                try {
                    PstPayEmpLevel.insertExc(payEmpLevel);
                } catch (Exception e) {
                }

            }
        }

    } else if (docMasterAction.getActionName().equals(DocMasterActionClass.actionKey[2])) {
        docMasterActionParam1 = (DocMasterActionParam) hDocMasterAction.get("Employee to Update Databank");


        String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + docMasterActionParam1.getObjectName() + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
        listEmp = PstEmpDocList.list(0, 0, whereC, ""); //ini daftar orangnya 

        Employee employee = new Employee();

        DocMasterActionParam docMasterActionParamForCompany = new DocMasterActionParam();
        docMasterActionParamForCompany = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][1]);
        String newObjectNameForCompany = (String) docMasterActionParamForCompany.getObjectName();
        String newValueForCompany = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForCompany, oidEmpDoc);
        String getClassNameForCompany = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForCompany, oidEmpDoc);
        if (getClassNameForCompany.equals("COMPANY")) {
            long newValuetoLong = Long.parseLong(newValueForCompany);
            employee.setCompanyId(newValuetoLong);

        }



        //cari tahu ini untuk perubahan apa Divisi
        DocMasterActionParam docMasterActionParamForDivision = new DocMasterActionParam();
        docMasterActionParamForDivision = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][2]);
        String newObjectNameForDivision = (String) docMasterActionParamForDivision.getObjectName();
        String newValueForDivision = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForDivision, oidEmpDoc);
        String getClassNameForDivision = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForDivision, oidEmpDoc);
        if (getClassNameForDivision.equals("DIVISION")) {
            long newValuetoLong = Long.parseLong(newValueForDivision);
            employee.setDivisionId(newValuetoLong);

        }


        //cari tahu ini untuk perubahan apa
        DocMasterActionParam docMasterActionParamForDepartment = new DocMasterActionParam();
        docMasterActionParamForDepartment = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][3]);
        String newObjectNameForDepartment = (String) docMasterActionParamForDepartment.getObjectName();
        String newValueForDepartment = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForDepartment, oidEmpDoc);
        String getClassNameForDepartment = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForDepartment, oidEmpDoc);
        if (getClassNameForDepartment.equals("DEPARTMENT")) {
            long newValuetoLong = Long.parseLong(newValueForDepartment);
            employee.setDepartmentId(newValuetoLong);

        }

        //cari tahu ini untuk perubahan apa 
        DocMasterActionParam docMasterActionParamForEmpCat = new DocMasterActionParam();
        docMasterActionParamForEmpCat = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][4]);
        String newObjectNameForEmpCat = (String) docMasterActionParamForEmpCat.getObjectName();
        String newValueForEmpCat = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForEmpCat, oidEmpDoc);
        String getClassNameForEmpCat = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForEmpCat, oidEmpDoc);
        if (getClassNameForEmpCat.equals("EMPCAT")) {
            long newValuetoLong = Long.parseLong(newValueForEmpCat);
            employee.setEmpCategoryId(newValuetoLong);

        }

        //cari tahu ini untuk perubahan apa 
        DocMasterActionParam docMasterActionParamForLevel = new DocMasterActionParam();
        docMasterActionParamForLevel = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][5]);
        String newObjectNameForLevel = (String) docMasterActionParamForLevel.getObjectName();
        String newValueForLevel = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForLevel, oidEmpDoc);
        String getClassNameForLevel = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForLevel, oidEmpDoc);
        if (getClassNameForLevel.equals("LEVEL")) {
            long newValuetoLong = Long.parseLong(newValueForLevel);
            employee.setLevelId(newValuetoLong);

        }


        //cari tahu ini untuk perubahan apa
        DocMasterActionParam docMasterActionParamForPosition = new DocMasterActionParam();
        docMasterActionParamForPosition = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][6]);
        String newObjectNameForPosition = (String) docMasterActionParamForPosition.getObjectName();
        String newValueForPosition = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForPosition, oidEmpDoc);
        String getClassNameForPosition = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForPosition, oidEmpDoc);
        if (getClassNameForPosition.equals("POSITION")) {
            long newValuetoLong = Long.parseLong(newValueForPosition);
            employee.setPositionId(newValuetoLong);

        }

        DocMasterActionParam docMasterActionParamForSection = new DocMasterActionParam();
        docMasterActionParamForSection = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][7]);
        String newObjectNameForSection = (String) docMasterActionParamForSection.getObjectName();
        String newValueForSection = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForSection, oidEmpDoc);
        String getClassNameForSection = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForSection, oidEmpDoc);
        if (getClassNameForSection.equals("SECTION")) {
            long newValuetoLong = Long.parseLong(newValueForSection);
            employee.setSectionId(newValuetoLong);

        }

        DocMasterActionParam docMasterActionParamForWorkTo = new DocMasterActionParam();
        docMasterActionParamForWorkTo = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][8]);
        String newObjectNameForWorkTo = (String) docMasterActionParamForWorkTo.getObjectName();
        String newValueForWorkTo = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForWorkTo, oidEmpDoc);
        //String getClassNameForWorkTo = PstEmpDocField.getClassNameByObjectnameEmpDocId(newObjectNameForWorkTo, oidEmpDoc);
        Date dateF = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        try {
            dateF = formatter.parse(newValueForWorkTo);
            employee.setResignedDate(dateF);
        } catch (Exception e) {
        }

    } else if (docMasterAction.getActionName().equals(DocMasterActionClass.actionKey[3])) {
        if (typeAction == 0) {
        docMasterActionParam1 = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][0]);

        String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + docMasterActionParam1.getObjectName() + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
        listEmp = PstEmpDocList.list(0, 0, whereC, "");
        
        if (iCommand == Command.SAVE) {
            if (listEmp != null && listEmp.size()>0){
                for (int i = 0; i < listEmp.size(); i++) {
                    EmpDocList empDocList = (EmpDocList) listEmp.get(i);
                    Employee employee = new Employee();
                    EmpDoc empDoc = new EmpDoc();
                    EmpDocListMutation empDocListMutation = new EmpDocListMutation();
                    CareerPath careerPath = new CareerPath();
                    CareerPath careerGrade = new CareerPath();
                    try {
                        employee = PstEmployee.fetchExc(empDocList.getEmployee_id());
                        empDoc = PstEmpDoc.fetchExc(empDocList.getEmp_doc_id());
                        empDocListMutation = PstEmpDocListMutation.getNewEmpDocListMutation(oidEmpDoc, employee.getOID(), docMasterActionParam1.getObjectName());
                    } catch (Exception e) {
                        System.out.println(""+e.toString());
                    }
                    
                    /* Check apakah ada history grade yang overlap */
                    boolean isOverlapGrade = false;
                    String whereInsert = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID] + " = "
                            + empDocListMutation.getEmployeeId() + " AND " + PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO] + " >= '"
                            + empDocListMutation.getWorkFrom() + "' AND " + PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE] + " = "
                            + empDocListMutation.getHistoryType() + " AND " + PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP] + " = 1";

                    Vector listCpCheck = PstCareerPath.list(0, 0, whereInsert, "");
                    CareerPath cpCheckGrade = new CareerPath();
                    if (listCpCheck.size() > 0){
                        for (int x = 0; x < listCpCheck.size(); x++){
                            CareerPath cp = (CareerPath) listCpCheck.get(x);
                            if (cp.getHistoryGroup() == 1){
                                cpCheckGrade = cp;
                                isOverlapGrade = true;
                            }
                        }
                    }
                    
                    /* Prepare of CareerPath */
                    careerPath.setEmployee(employee);
                    careerPath.setEmployeeId(employee.getOID());
                    careerPath.setCompanyId(employee.getCompanyId());
                    careerPath.setCompany(changeValue.getCompanyName(employee.getCompanyId()));
                    careerPath.setDivisionId(employee.getDivisionId());
                    careerPath.setDivision(changeValue.getDivisionName(employee.getDivisionId()));
                    careerPath.setDepartmentId(employee.getDepartmentId());
                    careerPath.setDepartment(changeValue.getDepartmentName(employee.getDepartmentId()));
                    careerPath.setSectionId(employee.getSectionId());
                    careerPath.setSection(changeValue.getSectionName(employee.getSectionId()));
                    careerPath.setPositionId(employee.getPositionId());
                    careerPath.setPosition(changeValue.getPositionName(employee.getPositionId()));
                    careerPath.setLevelId(employee.getLevelId());
                    careerPath.setLevel(changeValue.getLevelName(employee.getLevelId()));
                    careerPath.setEmpCategoryId(employee.getEmpCategoryId());
                    careerPath.setEmpCategory(changeValue.getEmpCategory(employee.getEmpCategoryId()));
                    
                    if (!isOverlapGrade){
                        /* Prepare of Career (Grade) */
                        careerGrade.setEmployee(employee);
                        careerGrade.setEmployeeId(employee.getOID());
                        careerGrade.setCompanyId(employee.getCompanyId());
                        careerGrade.setCompany(changeValue.getCompanyName(employee.getCompanyId()));
                        careerGrade.setDivisionId(employee.getDivisionId());
                        careerGrade.setDivision(changeValue.getDivisionName(employee.getDivisionId()));
                        careerGrade.setDepartmentId(employee.getDepartmentId());
                        careerGrade.setDepartment(changeValue.getDepartmentName(employee.getDepartmentId()));
                        careerGrade.setSectionId(employee.getSectionId());
                        careerGrade.setSection(changeValue.getSectionName(employee.getSectionId()));
                        careerGrade.setPositionId(employee.getPositionId());
                        careerGrade.setPosition(changeValue.getPositionName(employee.getPositionId()));
                        careerGrade.setLevelId(employee.getLevelId());
                        careerGrade.setLevel(changeValue.getLevelName(employee.getLevelId()));
                        careerGrade.setEmpCategoryId(employee.getEmpCategoryId());
                        careerGrade.setEmpCategory(changeValue.getEmpCategory(employee.getEmpCategoryId()));
                    } else {
                        /* Prepare of Career (Grade) */
                        careerGrade.setEmployee(employee);
                        careerGrade.setEmployeeId(employee.getOID());
                        careerGrade.setCompanyId(empDocListMutation.getCompanyId());
                        careerGrade.setCompany(changeValue.getCompanyName(empDocListMutation.getCompanyId()));
                        careerGrade.setDivisionId(empDocListMutation.getDivisionId());
                        careerGrade.setDivision(changeValue.getDivisionName(empDocListMutation.getDivisionId()));
                        careerGrade.setDepartmentId(empDocListMutation.getDepartmentId());
                        careerGrade.setDepartment(changeValue.getDepartmentName(empDocListMutation.getDepartmentId()));
                        careerGrade.setSectionId(empDocListMutation.getSectionId());
                        careerGrade.setSection(changeValue.getSectionName(empDocListMutation.getSectionId()));
                        careerGrade.setPositionId(empDocListMutation.getPositionId());
                        careerGrade.setPosition(changeValue.getPositionName(empDocListMutation.getPositionId()));
                        careerGrade.setLevelId(empDocListMutation.getLevelId());
                        careerGrade.setLevel(changeValue.getLevelName(empDocListMutation.getLevelId()));
                        careerGrade.setEmpCategoryId(empDocListMutation.getEmpCatId());
                        careerGrade.setEmpCategory(changeValue.getEmpCategory(empDocListMutation.getEmpCatId()));
                    }
                    /* CASE 1
                    Mutation Type : Penerimaan 
                    History Group : Riwayat Jabatan  dan Grade
                    History Type : Career
                    */
                    /* CASE 2
                    Mutation Type : Pengangkatan 
                    History Group : Riwayat Jabatan  dan Grade
                    History Type : Career
                    */
                    if (empDocListMutation.getTipeDoc() == PstEmpDocListMutation.PENGANGKATAN){
                        /* historikan karir yg sedang berlangsung, dan input data emp doc ke personal data */
                        /* Proses meng-historikan karir sekarang */
                        Date datePrevious = PstCareerPath.getLastDateCareerVersi2(employee.getOID());
                        String whereCheck = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employee.getOID()+" AND ";
                        whereCheck += ""+ PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+"="+PstCareerPath.RIWAYAT_JABATAN+ " ";
                        //whereCheck += PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+"="+PstCareerPath.RIWAYAT_CAREER_N_GRADE+")";
                        Vector listCheckCareer = PstCareerPath.list(0, 0, whereCheck, "");
                        if (listCheckCareer != null && listCheckCareer.size()>0){
                            careerPath.setWorkFrom(PstCareerPath.getPrevOrNextDate(datePrevious, 1));
                        } else {
                            careerPath.setWorkFrom(employee.getCommencingDate());
                        }

                        careerPath.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));
                        /*
 *                      * Cek riwayat yg mempunyai History Group = RIWAYAT_CAREER_N_GRADE,
 *                      * Jika tidak ada maka pakai history commencing
                        */

                        careerPath.setHistoryGroup(PstCareerPath.RIWAYAT_JABATAN);
                        careerPath.setHistoryType(employee.getHistoryType());
                        careerPath.setGradeLevelId(employee.getGradeLevelId());
                        careerPath.setTanggalSk(employee.getSkTanggal());
                        careerPath.setNomorSk(employee.getSkNomor());
                        careerPath.setEmpDocId(employee.getEmpDocId());
                        /* Career untuk List Riwayat Grade */                        
                        /////
                        Date datePrevious1 = PstCareerPath.getLastDateCareerVersi3(employee.getOID());
                        String whereCheck1 = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employee.getOID()+" AND ";
                        whereCheck1 += ""+ PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+"="+PstCareerPath.RIWAYAT_GRADE+ " ";
                        //whereCheck1 += PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+"="+PstCareerPath.RIWAYAT_CAREER_N_GRADE+")";
                        Vector listCheckCareer1 = PstCareerPath.list(0, 0, whereCheck1, "");
                            if (listCheckCareer1 != null && listCheckCareer1.size()>0){
                                careerGrade.setWorkFrom(PstCareerPath.getPrevOrNextDate(datePrevious1, 1));
                            } else {
                                careerGrade.setWorkFrom(employee.getCommencingDate());
                            }
                        
                        
                            careerGrade.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));
                            careerGrade.setHistoryGroup(PstCareerPath.RIWAYAT_GRADE);
                            careerGrade.setHistoryType(employee.getHistoryType());
                            careerGrade.setGradeLevelId(employee.getGradeLevelId());
                            careerGrade.setTanggalSk(employee.getSkTanggalGrade());
                            careerGrade.setNomorSk(employee.getSkNomorGrade());
                            careerGrade.setEmpDocId(employee.getEmpDocIdGrade());
                        
                        
                        /* Set data employee update */
                        String dataSet = "";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";
                        
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";
                        
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+"="+empDocListMutation.getLevelId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID]+"="+empDocListMutation.getEmpCatId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_GRADE_LEVEL_ID]+"="+empDocListMutation.getGradeLevelId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_GROUP]+"="+PstCareerPath.RIWAYAT_CAREER_N_GRADE+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_TYPE]+"="+PstCareerPath.CAREER_TYPE+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID]+"="+empDoc.getOID()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID_GRADE]+"="+empDoc.getOID()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_STATUS_PENSIUN_PROGRAM]+"="+PstEmployee.STATUS_PENSIUN_PROGRAM_INCLUDE+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_START_DATE_PENSIUN]+"='"+empDocListMutation.getWorkFrom()+"', ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_END_CONTRACT]+"='0000-00-00', "; //
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+"='"+empDocListMutation.getEmpNum()+"', ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR]+"='"+empDoc.getDoc_number()+"', ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL]+"='"+empDoc.getRequest_date()+"', ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_NKK]+"='"+employee.getEmployeeNum()+"', ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR_GRADE]+"='"+empDoc.getDoc_number()+"', ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL_GRADE]+"='"+empDoc.getRequest_date()+"' ";
                        /*
                        * Update Custom Field In progress... //
                        */
                        try {
                            PstCareerPath.insertExc(careerPath);
                            PstCareerPath.insertExc(careerGrade);
                            PstEmployee.updateEmployeeParsial(dataSet, employee.getOID());
                        } catch (Exception e){
                            System.out.println(e.toString());
                        }
                        
                    }
                    
                    if (empDocListMutation.getTipeDoc() == PstEmpDocListMutation.MUTASIDANPROMOSI ||
                            empDocListMutation.getTipeDoc() == PstEmpDocListMutation.REPLACEMENT){
                        if (empDocListMutation.getTipeDoc() == PstEmpDocListMutation.REPLACEMENT){
                            
                            long oidLeaveMapping = 0;
                            try {
                                oidLeaveMapping = Long.valueOf(PstSystemProperty.getValueByName("LEAVE_APPROVAL_MAPPING_ID"));
                                MappingPosition mappingPosition = new MappingPosition();
                                mappingPosition.setDivisionId(empDocListMutation.getDivisionId());
                                mappingPosition.setDownPositionId(empDocListMutation.getPositionId());
                                mappingPosition.setUpPositionId(employee.getPositionId());
                                mappingPosition.setStartDate(empDocListMutation.getWorkFrom());
                                mappingPosition.setEndDate(empDocListMutation.getWorkTo());
                                mappingPosition.setTypeOfLink(PstMappingPosition.REPLACEMENT);
                                mappingPosition.setVerticalLine(0);
                                mappingPosition.setTemplateId(oidLeaveMapping);
                                try {
                                    PstMappingPosition.insertExc(mappingPosition);
                                } catch (Exception exc){
                                    System.out.println(exc.toString());
                                }
                            } catch (Exception exc){
                                System.out.println(exc.toString());
                            }
                        }
                        if (empDocListMutation.getHistoryGroup() == PstCareerPath.RIWAYAT_JABATAN){
                            /* CASE 3 dan CASE 4 //
                            Mutation Type : Mutasi dan Promosi 
                            History Group : Riwayat Jabatan
                            */
                            
                            careerPath.setEmpCategory(changeValue.getEmpCategory(empDocListMutation.getEmpCatId()));
                            if (empDocListMutation.getHistoryType() == PstCareerPath.DETASIR_TYPE || empDocListMutation.getHistoryType() == PstCareerPath.PELAKSANA_TUGAS_TYPE){                
                                careerPath.setEmployee(employee);
                                careerPath.setEmployeeId(employee.getOID());
                                careerPath.setCompanyId(empDocListMutation.getCompanyId());
                                careerPath.setCompany(changeValue.getCompanyName(empDocListMutation.getCompanyId()));
                                careerPath.setDivisionId(empDocListMutation.getDivisionId());
                                careerPath.setDivision(changeValue.getDivisionName(empDocListMutation.getDivisionId()));
                                careerPath.setDepartmentId(empDocListMutation.getDepartmentId());
                                careerPath.setDepartment(changeValue.getDepartmentName(empDocListMutation.getDepartmentId()));
                                careerPath.setSectionId(empDocListMutation.getSectionId());
                                careerPath.setSection(changeValue.getSectionName(empDocListMutation.getSectionId()));
                                careerPath.setPositionId(empDocListMutation.getPositionId());
                                careerPath.setPosition(changeValue.getPositionName(empDocListMutation.getPositionId()));
                                careerPath.setLevelId(empDocListMutation.getLevelId());
                                careerPath.setLevel(changeValue.getLevelName(empDocListMutation.getLevelId()));
                                careerPath.setEmpCategoryId(empDocListMutation.getEmpCatId());
                                careerPath.setEmpCategory(changeValue.getEmpCategory(empDocListMutation.getEmpCatId()));
                                
                                careerPath.setWorkFrom(empDocListMutation.getWorkFrom());
                                careerPath.setWorkTo(empDocListMutation.getWorkTo());
                                /* CASE 3
                                Mutation Type : Mutasi dan Promosi 
                                History Group : Riwayat Jabatan
                                History Type : Detasir
                                */
                                careerPath.setHistoryGroup(PstCareerPath.RIWAYAT_JABATAN);
                                if (empDocListMutation.getHistoryType() == PstCareerPath.DETASIR_TYPE){
                                    careerPath.setHistoryType(PstCareerPath.DETASIR_TYPE);
                                }
                                /* CASE 4
                                Mutation Type : Mutasi dan Promosi 
                                History Group : Riwayat Jabatan
                                History Type : Pelaksana Tugas
                                */
                                if (empDocListMutation.getHistoryType() == PstCareerPath.PELAKSANA_TUGAS_TYPE){
                                    careerPath.setHistoryType(PstCareerPath.PELAKSANA_TUGAS_TYPE);
                                }
                                
                                careerPath.setGradeLevelId(employee.getGradeLevelId());
                                careerPath.setTanggalSk(empDoc.getRequest_date());
                                careerPath.setNomorSk(empDoc.getDoc_number());
                                careerPath.setEmpDocId(empDocListMutation.getEmpDocId());
                                try {
                                    PstCareerPath.insertExc(careerPath);
                                } catch (Exception e){
                                    System.out.println(e.toString());
                                }
                            }
                            
                            /* CASE 5
                            Mutation Type : Mutasi dan Promosi 
                            History Group : Riwayat Jabatan
                            History Type : Pejabat Sementara
                            */
                            if (empDocListMutation.getHistoryType() == PstCareerPath.PEJABAT_SEMENTARA_TYPE){
                                /* insert ke career path dan update employee */
                                
                                
                                /* historikan karir yg sedang berlangsung, dan input data emp doc ke personal data */
                                /* Proses meng-historikan karir sekarang */
                                String historyGroupCondition = PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                                historyGroupCondition += "="+PstCareerPath.RIWAYAT_JABATAN;
                                Date datePrevious = PstCareerPath.getLastDateCareer(employee.getOID(), historyGroupCondition);
                                careerPath.setWorkFrom(PstCareerPath.getPrevOrNextDate(datePrevious, 1));
                                careerPath.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));
                                //////
                                careerPath.setHistoryGroup(empDocListMutation.getHistoryGroup());
                                careerPath.setHistoryType(employee.getHistoryType());
                                careerPath.setGradeLevelId(employee.getGradeLevelId());
                                careerPath.setTanggalSk(employee.getSkTanggal());
                                careerPath.setNomorSk(employee.getSkNomor());
                                careerPath.setEmpDocId(employee.getEmpDocId());
                                /* Set data employee update */
                                String dataSet = "";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";

                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";

                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+"="+empDocListMutation.getLevelId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID]+"="+empDocListMutation.getEmpCatId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_GRADE_LEVEL_ID]+"="+empDocListMutation.getGradeLevelId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_GROUP]+"="+PstCareerPath.RIWAYAT_JABATAN+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_TYPE]+"="+PstCareerPath.PEJABAT_SEMENTARA_TYPE+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID]+"="+empDocListMutation.getEmpDocId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR]+"='"+empDoc.getDoc_number()+"', ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL]+"='"+empDoc.getRequest_date()+"' ";
                                /*
                                * Update Custom Field In progress... 
                                */
                                try {
                                    PstCareerPath.insertExc(careerPath);
                                    PstEmployee.updateEmployeeParsial(dataSet, employee.getOID());
                                } catch (Exception e){
                                    System.out.println(e.toString());
                                }
                                
                            }
                            
							if (empDocListMutation.getHistoryType() == PstCareerPath.OJT_TYPE){
                                /* insert ke career path dan update employee */
                                
                                
                                /* historikan karir yg sedang berlangsung, dan input data emp doc ke personal data */
                                /* Proses meng-historikan karir sekarang */
                                String historyGroupCondition = PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                                historyGroupCondition += "="+PstCareerPath.RIWAYAT_JABATAN;
                                Date datePrevious = PstCareerPath.getLastDateCareer(employee.getOID(), historyGroupCondition);
                                careerPath.setWorkFrom(PstCareerPath.getPrevOrNextDate(datePrevious, 1));
                                careerPath.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));
                                //////
                                careerPath.setHistoryGroup(empDocListMutation.getHistoryGroup());
                                careerPath.setHistoryType(employee.getHistoryType());
                                careerPath.setGradeLevelId(employee.getGradeLevelId());
                                careerPath.setTanggalSk(employee.getSkTanggal());
                                careerPath.setNomorSk(employee.getSkNomor());
                                careerPath.setEmpDocId(employee.getEmpDocId());
                                /* Set data employee update */
                                String dataSet = "";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";

                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";

                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+"="+empDocListMutation.getLevelId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID]+"="+empDocListMutation.getEmpCatId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_GRADE_LEVEL_ID]+"="+empDocListMutation.getGradeLevelId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_GROUP]+"="+PstCareerPath.RIWAYAT_JABATAN+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_TYPE]+"="+PstCareerPath.OJT_TYPE+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID]+"="+empDocListMutation.getEmpDocId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR]+"='"+empDoc.getDoc_number()+"', ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL]+"='"+empDoc.getRequest_date()+"' ";
                                /*
                                * Update Custom Field In progress... 
                                */
                                try {
                                    PstCareerPath.insertExc(careerPath);
                                    PstEmployee.updateEmployeeParsial(dataSet, employee.getOID());
                                } catch (Exception e){
                                    System.out.println(e.toString());
                                }
                                
                            }
                            
                            if (empDocListMutation.getHistoryType() == PstCareerPath.CAREER_TYPE){
                                /* insert ke career path dan update employee */   
                                /* historikan karir yg sedang berlangsung, dan input data emp doc ke personal data */
                                /* Proses meng-historikan karir sekarang */
                                String historyGroupCondition = "("+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                                historyGroupCondition += "="+PstCareerPath.RIWAYAT_CAREER_N_GRADE;
                                historyGroupCondition += " OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                                historyGroupCondition += "="+PstCareerPath.RIWAYAT_JABATAN+")";
                                Date datePrevious = PstCareerPath.getLastDateCareer(employee.getOID(), historyGroupCondition);
                                String whereCheck = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employee.getOID();
                                Vector listCheckCareer = PstCareerPath.list(0, 0, whereCheck, "");
                                
                                if (listCheckCareer != null && listCheckCareer.size()>0){
                                    careerPath.setWorkFrom(PstCareerPath.getPrevOrNextDate(datePrevious, 1));
                                } else {
                                    careerPath.setWorkFrom(employee.getCommencingDate());
                                }
                                careerPath.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));
                                //////
                                if (empDocListMutation.getHistoryGroup()==PstCareerPath.RIWAYAT_CAREER_N_GRADE ){
                                    careerPath.setHistoryGroup(PstCareerPath.RIWAYAT_CAREER_N_GRADE);
                                } 
                                if (empDocListMutation.getHistoryGroup()==PstCareerPath.RIWAYAT_JABATAN){
                                    careerPath.setHistoryGroup(PstCareerPath.RIWAYAT_JABATAN);
                                }
                                if (empDocListMutation.getHistoryGroup()==PstCareerPath.RIWAYAT_GRADE){
                                    careerPath.setHistoryGroup(PstCareerPath.RIWAYAT_GRADE);
                                }
                                ///careerPath.setHistoryGroup(employee.getHistoryGroup()); /* before PstCareerPath.RIWAYAT_JABATAN */
                                careerPath.setHistoryType(employee.getHistoryType());
                                careerPath.setGradeLevelId(employee.getGradeLevelId());
                                careerPath.setTanggalSk(employee.getSkTanggal());
                                careerPath.setNomorSk(employee.getSkNomor());//
                                careerPath.setEmpDocId(employee.getEmpDocId());
                                
                                /* Set data employee update */
                                String dataSet = "";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";

                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";

                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+"="+empDocListMutation.getLevelId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID]+"="+empDocListMutation.getEmpCatId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_GRADE_LEVEL_ID]+"="+empDocListMutation.getGradeLevelId()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_GROUP]+"="+empDocListMutation.getHistoryGroup()+", ";
                                dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_TYPE]+"="+PstCareerPath.CAREER_TYPE+", ";
                                
                                
                                if (empDocListMutation.getHistoryGroup()==PstCareerPath.RIWAYAT_CAREER_N_GRADE ){
                                    dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID]+"="+empDocListMutation.getEmpDocId()+", ";
                                    dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR]+"='"+empDoc.getDoc_number()+"', ";
                                    dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL]+"='"+empDoc.getRequest_date()+"', ";
                                    dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID_GRADE]+"="+empDocListMutation.getEmpDocId()+", ";
                                    dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR_GRADE]+"='"+empDoc.getDoc_number()+"', ";
                                    dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL_GRADE]+"='"+empDoc.getRequest_date()+"' ";
                                } 
                                if (empDocListMutation.getHistoryGroup()==PstCareerPath.RIWAYAT_JABATAN){
                                    dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID]+"="+empDocListMutation.getEmpDocId()+", ";
                                    dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR]+"='"+empDoc.getDoc_number()+"', ";
                                    dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL]+"='"+empDoc.getRequest_date()+"' ";
                                }
                                if (empDocListMutation.getHistoryGroup()==PstCareerPath.RIWAYAT_GRADE){
                                    dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID_GRADE]+"="+empDocListMutation.getEmpDocId()+", ";
                                    dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR_GRADE]+"='"+empDoc.getDoc_number()+"', ";
                                    dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL_GRADE]+"='"+empDoc.getRequest_date()+"' ";
                                }
                                /*
                                * Update Custom Field In progress... 
                                */
                                try {
                                    PstCareerPath.insertExc(careerPath);
                                    PstEmployee.updateEmployeeParsial(dataSet, employee.getOID());
                                } catch (Exception e){
                                    System.out.println(e.toString());
                                }
                                
                            }
                        }
                        
                        
                        /* CASE 6
                        Mutation Type : Mutasi dan Promosi 
                        History Group : Riwayat Jabatan dan Grade
                        History Type : Career
                        */
                        if (empDocListMutation.getHistoryGroup() == PstCareerPath.RIWAYAT_CAREER_N_GRADE){
                            /* Proses meng-historikan karir sekarang */
                            String historyGroupCondition = "("+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                            historyGroupCondition += "="+PstCareerPath.RIWAYAT_CAREER_N_GRADE;
                            historyGroupCondition += " OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                            historyGroupCondition += "="+PstCareerPath.RIWAYAT_JABATAN+")";
                            Date dateLast = PstCareerPath.getLastDateCareer(employee.getOID(), historyGroupCondition);
                            careerPath.setWorkFrom(PstCareerPath.getPrevOrNextDate(dateLast, 1));
                            careerPath.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));

                            careerPath.setHistoryGroup(PstCareerPath.RIWAYAT_JABATAN);
                            careerPath.setHistoryType(employee.getHistoryType());
                            careerPath.setGradeLevelId(employee.getGradeLevelId());
                            careerPath.setTanggalSk(employee.getSkTanggal());
                            careerPath.setNomorSk(employee.getSkNomor());
                            careerPath.setEmpDocId(employee.getEmpDocId());
                            
                            /* Career Path untuk Grade */
                            historyGroupCondition = "("+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                            historyGroupCondition += "="+PstCareerPath.RIWAYAT_CAREER_N_GRADE;
                            historyGroupCondition += " OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                            historyGroupCondition += "="+PstCareerPath.RIWAYAT_GRADE+")";
                            dateLast = PstCareerPath.getLastDateCareer(employee.getOID(), historyGroupCondition);
                            
                            String whereCheck = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employee.getOID();
                            whereCheck += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+"=";
                            whereCheck += PstCareerPath.RIWAYAT_GRADE;
                            Vector listCheckCareer = PstCareerPath.list(0, 0, whereCheck, "");
                            if (listCheckCareer != null && listCheckCareer.size()>0){
                                careerGrade.setWorkFrom(PstCareerPath.getPrevOrNextDate(dateLast, 1));
                            } else {
                                careerGrade.setWorkFrom(employee.getCommencingDate());
                            }
                            careerGrade.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));
                            
                            careerGrade.setHistoryGroup(PstCareerPath.RIWAYAT_GRADE);
                            careerGrade.setHistoryType(PstCareerPath.CAREER_TYPE);
                            careerGrade.setGradeLevelId(employee.getGradeLevelId());
                            careerGrade.setTanggalSk(employee.getSkTanggalGrade());
                            careerGrade.setNomorSk(employee.getSkNomorGrade());
                            careerGrade.setEmpDocId(employee.getEmpDocIdGrade());
                            
                            /* Set data employee update */
                            String dataSet = "";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";

                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";

                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+"="+empDocListMutation.getLevelId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID]+"="+empDocListMutation.getEmpCatId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_GRADE_LEVEL_ID]+"="+empDocListMutation.getGradeLevelId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_GROUP]+"="+PstCareerPath.RIWAYAT_CAREER_N_GRADE+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_TYPE]+"="+PstCareerPath.CAREER_TYPE+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID]+"="+empDocListMutation.getEmpDocId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID_GRADE]+"="+empDocListMutation.getEmpDocId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR]+"='"+empDoc.getDoc_number()+"', ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL]+"='"+empDoc.getRequest_date()+"', ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR_GRADE]+"='"+empDoc.getDoc_number()+"', ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL_GRADE]+"='"+empDoc.getRequest_date()+"' ";
                            
                            try {
                                PstCareerPath.insertExc(careerPath);
                                PstCareerPath.insertExc(careerGrade);
                                PstEmployee.updateEmployeeParsial(dataSet, employee.getOID());
                            } catch (Exception e){
                                System.out.println(e.toString());
                            }
                        }
                        /* CASE 7
                        Mutation Type : Mutasi dan Promosi 
                        History Group : Riwayat Grade
                        History Type : Career
                        */
                        if (empDocListMutation.getHistoryGroup() == PstCareerPath.RIWAYAT_GRADE){
                            String historyGroupCondition = "("+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                            historyGroupCondition += "="+PstCareerPath.RIWAYAT_CAREER_N_GRADE;
                            historyGroupCondition += " OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                            historyGroupCondition += "="+PstCareerPath.RIWAYAT_GRADE+")";
                            Date dateLast = PstCareerPath.getLastDateCareer(employee.getOID(), historyGroupCondition);
                            
                            String whereCheck = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employee.getOID();
                            whereCheck += " AND ("+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+"=";
                            whereCheck += PstCareerPath.RIWAYAT_GRADE+" OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+"=";
                            whereCheck += PstCareerPath.RIWAYAT_CAREER_N_GRADE+")";
                            Vector listCheckCareer = PstCareerPath.list(0, 0, whereCheck, "");
                            if (!isOverlapGrade){
                                if (listCheckCareer != null && listCheckCareer.size()>0){
                                    careerGrade.setWorkFrom(PstCareerPath.getPrevOrNextDate(dateLast, 1));
                                } else {
                                    careerGrade.setWorkFrom(employee.getCommencingDate());
                                }
                                careerGrade.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));

                                careerGrade.setHistoryGroup(PstCareerPath.RIWAYAT_GRADE);
                                careerGrade.setHistoryType(PstCareerPath.CAREER_TYPE);
                                careerGrade.setGradeLevelId(employee.getGradeLevelId());
                                careerGrade.setTanggalSk(employee.getSkTanggalGrade());
                                careerGrade.setNomorSk(employee.getSkNomorGrade());
                                careerGrade.setEmpDocId(employee.getEmpDocIdGrade());
                            } else {
                                careerGrade.setWorkFrom(empDocListMutation.getWorkFrom());
                                careerGrade.setWorkTo(cpCheckGrade.getWorkTo());

                                careerGrade.setHistoryGroup(PstCareerPath.RIWAYAT_GRADE);
                                careerGrade.setHistoryType(PstCareerPath.CAREER_TYPE);
                                careerGrade.setGradeLevelId(empDocListMutation.getGradeLevelId());
                                careerGrade.setTanggalSk(empDoc.getReal_date_from());
                                careerGrade.setNomorSk(empDoc.getDoc_number());
                                careerGrade.setEmpDocId(empDocListMutation.getEmpDocId());
                                cpCheckGrade.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));
                            }
                            /* set employee */
                            String dataSet = "";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_GRADE_LEVEL_ID]+"="+empDocListMutation.getGradeLevelId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_GROUP]+"="+PstCareerPath.RIWAYAT_GRADE+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_TYPE]+"="+PstCareerPath.CAREER_TYPE+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID_GRADE]+"="+empDocListMutation.getEmpDocId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR_GRADE]+"='"+empDoc.getDoc_number()+"', ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL_GRADE]+"='"+empDoc.getRequest_date()+"' ";

                            try {
                                PstCareerPath.insertExc(careerGrade);
                                if (!isOverlapGrade){
                                    PstEmployee.updateEmployeeParsial(dataSet, employee.getOID());
                                } else {
                                    PstCareerPath.updateExc(cpCheckGrade);
                                }
                            } catch (Exception e){
                                System.out.println(e.toString());
                            }
                        }
                    }
                    /* CASE 8
                    *  Mutation Type : RESIGN
                    */
                    if (empDocListMutation.getTipeDoc() == PstEmpDocListMutation.RESIGN){      
                        /* Proses meng-historikan karir sekarang */
                        String historyGroupCondition = "";
                        if (empDocListMutation.getHistoryGroup() == PstCareerPath.RIWAYAT_JABATAN){
                            historyGroupCondition = PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                            historyGroupCondition += "="+PstCareerPath.RIWAYAT_JABATAN;
                            careerPath.setHistoryGroup(PstCareerPath.RIWAYAT_JABATAN);
                            careerPath.setTanggalSk(employee.getSkTanggal());
                            careerPath.setNomorSk(employee.getSkNomor());
                            careerPath.setEmpDocId(employee.getEmpDocId());
                        }
                        if (empDocListMutation.getHistoryGroup() == PstCareerPath.RIWAYAT_GRADE){
                            historyGroupCondition = PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                            historyGroupCondition += "="+PstCareerPath.RIWAYAT_GRADE;
                            careerPath.setHistoryGroup(PstCareerPath.RIWAYAT_GRADE);
                            careerPath.setTanggalSk(employee.getSkTanggalGrade());
                            careerPath.setNomorSk(employee.getSkNomorGrade());
                            careerPath.setEmpDocId(employee.getEmpDocIdGrade());
                        }
                        Date dateLast = PstCareerPath.getLastDateCareer(employee.getOID(), historyGroupCondition);
                        careerPath.setWorkFrom(PstCareerPath.getPrevOrNextDate(dateLast, 1));
                        careerPath.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));
                        careerPath.setHistoryType(employee.getHistoryType());
                        careerPath.setGradeLevelId(employee.getGradeLevelId());
                            
                        if (empDocListMutation.getHistoryGroup() == PstCareerPath.RIWAYAT_CAREER_N_GRADE){
                            historyGroupCondition = PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                            historyGroupCondition += "="+PstCareerPath.RIWAYAT_JABATAN;
                            dateLast = PstCareerPath.getLastDateCareer(employee.getOID(), historyGroupCondition);
                            careerPath.setWorkFrom(PstCareerPath.getPrevOrNextDate(dateLast, 1));
                            careerPath.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));
                            careerPath.setHistoryType(employee.getHistoryType());
                            careerPath.setGradeLevelId(employee.getGradeLevelId());
                            careerPath.setHistoryGroup(PstCareerPath.RIWAYAT_JABATAN);
                            careerPath.setTanggalSk(employee.getSkTanggal());
                            careerPath.setNomorSk(employee.getSkNomor());
                            careerPath.setEmpDocId(employee.getEmpDocId());
                            
                            /* Career Path untuk Grade */
                            historyGroupCondition = "("+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                            historyGroupCondition += "="+PstCareerPath.RIWAYAT_CAREER_N_GRADE;
                            historyGroupCondition += " OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                            historyGroupCondition += "="+PstCareerPath.RIWAYAT_GRADE+")";
                            dateLast = PstCareerPath.getLastDateCareer(employee.getOID(), historyGroupCondition);

                            String whereCheck = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employee.getOID();
                            whereCheck += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+"=";
                            whereCheck += PstCareerPath.RIWAYAT_GRADE;
                            Vector listCheckCareer = PstCareerPath.list(0, 0, whereCheck, "");
                            if (listCheckCareer != null && listCheckCareer.size()>0){
                                careerGrade.setWorkFrom(PstCareerPath.getPrevOrNextDate(dateLast, 1));
                            } else {
                                careerGrade.setWorkFrom(employee.getCommencingDate());
                            }
                            careerGrade.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));

                            careerGrade.setHistoryGroup(PstCareerPath.RIWAYAT_GRADE);
                            careerGrade.setHistoryType(PstCareerPath.CAREER_TYPE);
                            careerGrade.setGradeLevelId(employee.getGradeLevelId());
                            careerGrade.setTanggalSk(employee.getSkTanggalGrade());
                            careerGrade.setNomorSk(employee.getSkNomorGrade());
                            careerGrade.setEmpDocId(employee.getEmpDocIdGrade());
                        }
                        
                        String dataSet = "";
                        
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";

                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";

                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+"="+empDocListMutation.getLevelId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID]+"="+empDocListMutation.getEmpCatId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_GRADE_LEVEL_ID]+"="+empDocListMutation.getGradeLevelId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_GROUP]+"="+empDocListMutation.getHistoryGroup()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_TYPE]+"="+empDocListMutation.getHistoryType()+", ";
                        if (empDocListMutation.getHistoryGroup() == PstCareerPath.RIWAYAT_JABATAN){
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID]+"="+empDocListMutation.getEmpDocId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR]+"='"+empDoc.getDoc_number()+"', ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL]+"='"+empDoc.getRequest_date()+"', ";
                        }
                        if (empDocListMutation.getHistoryGroup() == PstCareerPath.RIWAYAT_GRADE){
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID_GRADE]+"="+empDocListMutation.getEmpDocId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR_GRADE]+"='"+empDoc.getDoc_number()+"', ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL_GRADE]+"='"+empDoc.getRequest_date()+"', ";
                        }
                        if (empDocListMutation.getHistoryGroup() == PstCareerPath.RIWAYAT_CAREER_N_GRADE){
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID]+"="+empDocListMutation.getEmpDocId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR]+"='"+empDoc.getDoc_number()+"', ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL]+"='"+empDoc.getRequest_date()+"', ";

                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID_GRADE]+"="+empDocListMutation.getEmpDocId()+", ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR_GRADE]+"='"+empDoc.getDoc_number()+"', ";
                            dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL_GRADE]+"='"+empDoc.getRequest_date()+"', ";
                        }
                        
                        
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_MEMBER_OF_KESEHATAN]+"=0, ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_MEMBER_OF_KETENAGAKERJAAN]+"=0, ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_STATUS_PENSIUN_PROGRAM]+"="+PstEmployee.STATUS_PENSIUN_PROGRAM_NOT_INCLUDE+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DANA_PENDIDIKAN]+"=0, ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+"=1, ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED_DATE]+"='"+empDocListMutation.getWorkFrom()+"', ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED_REASON_ID]+"="+empDocListMutation.getResignReason()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED_DESC]+"='"+empDocListMutation.getResignDesc()+"' ";
                        /*
                        * Update Custom Field In progress... 
                        */
                        try {
                            PstCareerPath.insertExc(careerPath);
                            if (empDocListMutation.getHistoryGroup() == PstCareerPath.RIWAYAT_CAREER_N_GRADE){
                                PstCareerPath.insertExc(careerGrade);
                            }
                            PstEmployee.updateEmployeeParsial(dataSet, employee.getOID());
                        } catch (Exception e){
                            System.out.println(e.toString());
                        }
                    }
                    
                    if (empDocListMutation.getTipeDoc() == PstEmpDocListMutation.PERPANJANGAN_KONTRAK){
                        String historyGroupCondition = "";
                        
                        historyGroupCondition = PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP];
                        historyGroupCondition += "="+PstCareerPath.RIWAYAT_JABATAN;
                        careerPath.setHistoryGroup(PstCareerPath.RIWAYAT_JABATAN);
                        careerPath.setTanggalSk(employee.getSkTanggal());
                        careerPath.setNomorSk(employee.getSkNomor());
                        careerPath.setEmpDocId(employee.getEmpDocId());
                        Date dateLast = PstCareerPath.getLastDateCareer(employee.getOID(), historyGroupCondition);
                        careerPath.setWorkFrom(PstCareerPath.getPrevOrNextDate(dateLast, 1));
                        careerPath.setWorkTo(PstCareerPath.getPrevOrNextDate(empDocListMutation.getWorkFrom(), -1));
                        careerPath.setHistoryType(employee.getHistoryType());
                        careerPath.setGradeLevelId(employee.getGradeLevelId());
                        
                        String dataSet = "";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";

                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_COMPANY_ID]+"="+empDocListMutation.getCompanyId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DIVISION_ID]+"="+empDocListMutation.getDivisionId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DEPARTMENT_ID]+"="+empDocListMutation.getDepartmentId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_SECTION_ID]+"="+empDocListMutation.getSectionId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_POSITION_ID]+"="+empDocListMutation.getPositionId()+", ";

                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+"="+empDocListMutation.getLevelId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID]+"="+empDocListMutation.getEmpCatId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_GRADE_LEVEL_ID]+"="+empDocListMutation.getGradeLevelId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_GROUP]+"="+PstCareerPath.RIWAYAT_JABATAN+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_TYPE]+"="+PstCareerPath.CAREER_TYPE+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_END_CONTRACT]+"='"+empDocListMutation.getWorkTo()+"', ";  /* New */ 
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID]+"="+empDocListMutation.getEmpDocId()+", ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_NOMOR]+"='"+empDoc.getDoc_number()+"', ";
                        dataSet += " "+PstEmployee.fieldNames[PstEmployee.FLD_SK_TANGGAL]+"='"+empDoc.getRequest_date()+"' ";
                        try {
                            PstCareerPath.insertExc(careerPath);//
                            PstEmployee.updateEmployeeParsial(dataSet, employee.getOID());
                        } catch (Exception e){
                            System.out.println(e.toString());
                        }
                    }
                }
            }
        }
        } else { // end if type action == 0
            docMasterActionParam1 = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[0][0]);
            String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + docMasterActionParam1.getObjectName() + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
            listEmp = PstEmpDocList.list(0, 0, whereC, "");
            if (iCommand == Command.SAVE) {
                Vector vmarital = PstMarital.list(0, 0, "", "");
                long maritalId = 0;
                if (vmarital != null && vmarital.size()>0){
                    Marital marital = (Marital)vmarital.get(0);
                    maritalId = marital.getOID();
				}
                if (listEmp != null && listEmp.size() > 0) {
                    for (int i = 0; i < listEmp.size(); i++) {
                        EmpDocList empDocList = (EmpDocList) listEmp.get(i);
                        EmpDocListMutation empDocListMutation = new EmpDocListMutation();
                        try {
                            empDocListMutation = PstEmpDocListMutation.getNewEmpDocListMutation(oidEmpDoc, empDocList.getEmployee_id(), docMasterActionParam1.getObjectName());
                            RecrApplication appLetter = PstRecrApplication.fetchExc(empDocList.getEmployee_id());
                            Employee employee = new Employee();

                            employee.setFullName(appLetter.getFullName());
                            employee.setCompanyId(empDocListMutation.getCompanyId());
                            employee.setDivisionId(empDocListMutation.getDivisionId());
                            employee.setDepartmentId(empDocListMutation.getDepartmentId());
                            employee.setSectionId(empDocListMutation.getSectionId());
                            employee.setLevelId(empDocListMutation.getLevelId());
                            employee.setEmpCategoryId(empDocListMutation.getEmpCatId());
                            String sqlString = "";
                            sqlString  = " INSERT INTO "+PstEmployee.TBL_HR_EMPLOYEE+" (";
                            sqlString += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+",";
                            sqlString += " "+PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+",";
                            sqlString += " "+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+",";
                            sqlString += " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+",";
                            sqlString += " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+",";
                            sqlString += " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+",";
                            sqlString += " "+PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+",";
                            sqlString += " "+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+",";
                            sqlString += " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID]+",";
                            sqlString += " "+PstEmployee.fieldNames[PstEmployee.FLD_MARITAL_ID]+")";
                            sqlString += " VALUES (";
                            sqlString += appLetter.getOID()+", ";
                            sqlString += "'"+appLetter.getFullName()+"', ";
                            sqlString += empDocListMutation.getCompanyId()+", ";
                            sqlString += empDocListMutation.getDivisionId()+", ";
                            sqlString += empDocListMutation.getDepartmentId()+", ";
                            sqlString += empDocListMutation.getSectionId()+", ";
                            sqlString += empDocListMutation.getLevelId()+", ";
                            sqlString += empDocListMutation.getPositionId()+", ";
                            sqlString += empDocListMutation.getEmpCatId()+", ";
                            sqlString += maritalId+")";
                            DBHandler.execSqlInsert(sqlString);
                        } catch (Exception e) {
                            System.out.println(""+e.toString());
                        }
                    }
                }
            }
        }
    } else if (docMasterAction.getActionName().equals(DocMasterActionClass.actionKey[5])) {
		DocMasterActionParam docMasterActionParamForUpPosition = new DocMasterActionParam();
		docMasterActionParamForUpPosition = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[5][0]);
		String newObjectNameForUpPosition = (String) docMasterActionParamForUpPosition.getObjectName();
		long empUpPosition = PstEmpDocList.getEmployeeIdByObjectnameEmpDocId(newObjectNameForUpPosition, oidEmpDoc);
		Employee empUp = new Employee();
		if (empUpPosition > 0){
			try {
				empUp = PstEmployee.fetchExc(empUpPosition);
				upPositionRep = PstEmployee.getPositionName(empUp.getPositionId());
			} catch (Exception exc){
				
			}
		}
		
		DocMasterActionParam docMasterActionParamForDownPosition = new DocMasterActionParam();
		docMasterActionParamForDownPosition = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[5][1]);
		String newObjectNameForDownPosition = (String) docMasterActionParamForDownPosition.getObjectName();
		long empDownPosition = PstEmpDocList.getEmployeeIdByObjectnameEmpDocId(newObjectNameForDownPosition, oidEmpDoc);
		Employee empDown = new Employee();
        if (empDownPosition > 0){
			try {
				empDown = PstEmployee.fetchExc(empDownPosition);
				downPositionRep = PstEmployee.getPositionName(empDown.getPositionId());
				divisionRep = PstEmployee.getDivisionName(empDown.getDivisionId());
			} catch (Exception exc){
				
			}
		}
		
		startDateRep = Formater.formatDate(empDocX.getDate_of_issue(), "yyyy-MM-dd");
		
		DocMasterActionParam docMasterActionParamEndDate = new DocMasterActionParam();
		docMasterActionParamEndDate = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[5][3]);
		String newObjectNameForEndDate = (String) docMasterActionParamEndDate.getObjectName();
		endDateRep = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForEndDate, oidEmpDoc);
		
		if (iCommand == Command.SAVE){
			try {
				long oidLeaveAppMap = 0;
				try {
					oidLeaveAppMap = Long.valueOf(PstSystemProperty.getValueByNameWithStringNull("LEAVE_APPROVAL_MAPPING_ID"));
				} catch (Exception exc){}
				long oidOvertimeAppMap = 0;
				try {
					oidOvertimeAppMap = Long.valueOf(PstSystemProperty.getValueByNameWithStringNull("OVERTIME_APPROVAL_MAPPING_ID"));
				} catch (Exception exc){}
				MappingPosition mapPosition = new MappingPosition();
				mapPosition.setDivisionId(empDown.getDivisionId());
				mapPosition.setDownPositionId(empDown.getPositionId());
				mapPosition.setUpPositionId(empUp.getPositionId());
				mapPosition.setStartDate(empDocX.getDate_of_issue());
				mapPosition.setEndDate(new SimpleDateFormat("yyyy-MM-dd").parse(endDateRep));
				mapPosition.setTypeOfLink(PstMappingPosition.REPLACEMENT);
				if (oidLeaveAppMap>0){
					mapPosition.setTemplateId(oidLeaveAppMap);
					PstMappingPosition.insertExc(mapPosition);
				}
				if (oidOvertimeAppMap>0){
					mapPosition.setTemplateId(oidOvertimeAppMap);
					PstMappingPosition.insertExc(mapPosition);
				}
			} catch (Exception exc){
				
			}
		}
		
	} else if (docMasterAction.getActionName().equals(DocMasterActionClass.actionKey[6])) {
		
		long scheduleId = FRMQueryString.requestLong(request, "schedule_id");
		DocMasterActionParam docMasterActionParamForUpPosition = new DocMasterActionParam();
		docMasterActionParamForUpPosition = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[6][0]);
		String newObjectNameForUpPosition = (String) docMasterActionParamForUpPosition.getObjectName();
		long emp = PstEmpDocList.getEmployeeIdByObjectnameEmpDocId(newObjectNameForUpPosition, oidEmpDoc);
		
		startDateRep = Formater.formatDate(empDocX.getDate_of_issue(), "yyyy-MM-dd");
		
		DocMasterActionParam docMasterActionParamEndDate = new DocMasterActionParam();
		docMasterActionParamEndDate = (DocMasterActionParam) hDocMasterAction.get(DocMasterActionClass.actionListParameterKey[6][2]);
		String newObjectNameForEndDate = (String) docMasterActionParamEndDate.getObjectName();
		endDateRep = PstEmpDocField.getvalueByObjectnameEmpDocId(newObjectNameForEndDate, oidEmpDoc);
		
		if (iCommand == Command.SAVE){
			try {
				
				Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(endDateRep);
				Date strtDate = empDocX.getDate_of_issue();
				
				Calendar start = Calendar.getInstance();
				start.setTime(empDocX.getDate_of_issue());
				Calendar end = Calendar.getInstance();
				end.setTime(endDate);

				for (Date date = start.getTime(); start.before(end); start.add(Calendar.DATE, 1), date = start.getTime()) {

					
					long schId = SessEmpSchedule.getSchId(emp, strtDate);
					
					int statusUpdate = SessEmpSchedule.updateSchedule(strtDate, schId, ""+scheduleId);
					long tmpDate = strtDate.getTime() + (24 * 60 * 60 * 1000);
					Date newDate = new Date(tmpDate);
					strtDate = newDate;
				}
				
				long schId = SessEmpSchedule.getSchId(emp, endDate);
					
				int statusUpdate = SessEmpSchedule.updateSchedule(strtDate, schId, ""+scheduleId);
			} catch (Exception exc){
				
			}
		}
		
	} else if (docMasterAction.getActionName().equals(DocMasterActionClass.actionKey[7])) {
            if (iCommand == Command.SAVE){
                String where = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID] + " = " + oidEmpDoc
                        +" AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME] + " IN ('DEBET','KREDIT')";
                Vector listData = PstEmpDocListExpense.list(0, 0, where, "");
                for (int i=0 ; i < listData.size(); i++){
                    EmpDocListExpense empDoc = (EmpDocListExpense) listData.get(i);
                    

                    long paySlipId = PstPaySlip.getPaySlipId(empDoc.getPeriodeId(), empDoc.getEmployeeId());
                    PayComponent payCom = new PayComponent();
                    try {
                        payCom = PstPayComponent.fetchExc(empDoc.getComponentId());
                    } catch (Exception exc){}

                    PstPaySlipComp.updateCompValue(paySlipId, payCom.getCompCode(), empDoc.getCompValue());
                }
            }
        }
    iErrCode = ctrlEmpDocAction.action(iCommand, oidEmpDocAction, oidDocAction, oidEmpDoc, saveType);
    //cek action yang sudah dilakukan
    int count = PstEmpDocAction.getCount("" + PstEmpDocAction.fieldNames[PstEmpDocAction.FLD_EMP_DOC_ID] + "=" + oidEmpDoc + " AND " + PstEmpDocAction.fieldNames[PstEmpDocAction.FLD_ACTION_NAME] + "=\"" + docMasterAction.getActionName() + "\"" + " AND " + PstEmpDocAction.fieldNames[PstEmpDocAction.FLD_ACTION_TITLE] + "=\"" + docMasterAction.getActionTitle() + "\"");

%>



<html>
    <head>
        <title>Action Document</title>
        <script language="JavaScript">
            function cmdSave(){
                document.frmEmpDocField.command.value="<%=String.valueOf(Command.SAVE)%>";
                document.frmEmpDocField.action="EmpDocumentDetailAction.jsp";
                document.frmEmpDocField.submit();
   
            } 
            function cmdSaveUpSalary(){
                document.frmEmpDocField.command.value="<%=String.valueOf(Command.SAVE)%>";
                document.frmEmpDocField.action="EmpDocumentDetailAction.jsp";
                document.frmEmpDocField.submit();
   
            } 
            function cmdProses(){
                document.frmEmpDocField.command.value="<%=String.valueOf(Command.POST)%>";
                document.frmEmpDocField.action="EmpDocumentDetailAction.jsp";
                document.frmEmpDocField.submit();
   
            } 
            function cmdSaveMutation(){
                document.frmEmpDocField.command.value="<%=String.valueOf(Command.SAVE)%>";
                document.frmEmpDocField.action="EmpDocumentDetailAction.jsp?saveType="+0;
                document.frmEmpDocField.submit();
   
            }    
			function cmdSaveApproval(){
                document.frmEmpDocField.command.value="<%=String.valueOf(Command.SAVE)%>";
                document.frmEmpDocField.action="EmpDocumentDetailAction.jsp";
                document.frmEmpDocField.submit();
            }
        </script>
        <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <!-- #BeginEditable "styles" -->
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "stylestab" -->
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            .tblStyleDoc {border-collapse: collapse; font-size: 12px; text-align: center;}
            .tblStyleDoc td {padding: 5px 7px; font-size: 12px; background-color: #FFF;}
            
            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}
            
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {background-color: #EEE;}
            .header {
                
            }
            .content-main {
                padding: 21px 11px;
                margin: 0px 23px 59px 23px;
            }
            .content-info {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
            }
            .content-title {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
                margin-bottom: 5px;
            }
            .content {
                padding: 21px;
            }
            .box {
                padding: 9px 11px;
                margin: 5px 11px 5px 0px;
                background-color: #F5F5F5;
                border:1px solid #DDD;
                border-radius: 4px;
                color:#575757;
            }
            #box_title {
                padding:21px; 
                font-size: 14px; 
                color: #007fba;
                border-top: 1px solid #28A7D1;
                border-bottom: 1px solid #EEE;
            }
            #box_content {
                padding:21px; 
                font-size: 12px;
                color: #575757;
            }
            .box-info {
                padding:21px 43px; 
                background-color: #F7F7F7;
                border-bottom: 1px solid #CCC;
                -webkit-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                 -moz-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
            }
            .info {
                padding:9px 12px; 
                background-color: #EAFABE;
                color:#687D2D;
                border-radius: 3px;
                font-size: 12px;
            }
            #box-item {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #575757;
                background-color: #EEE;
                border:1px solid #DDD;
                border-right: none;
            }
            #box-times {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #EEE;
                border:1px solid #DDD;
                cursor: pointer;
            }
            #box-times:hover {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #FFD9D9;
                border:1px solid #D9B8B8;
            }
            #title-info-name {
                padding: 11px 15px;
                font-size: 35px;
                color: #535353;
            }
            #title-info-desc {
                padding: 7px 15px;
                font-size: 21px;
                color: #676767;
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
            
            .btn-small {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #676767; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small:hover { background-color: #474747; color: #FFF;}
            
            .btn-small-1 {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-1:hover { background-color: #DDD; color: #474747;}
            
            .tbl-main {border-collapse: collapse; font-size: 11px; background-color: #FFF; margin: 0px;}
            .tbl-main td {padding: 4px 7px; border: 1px solid #DDD; }
            #tbl-title {font-weight: bold; background-color: #F5F5F5; color: #575757;}
            
            .tbl-small {border-collapse: collapse; font-size: 11px; background-color: #FFF;}
            .tbl-small td {padding: 2px 3px; border: 1px solid #DDD; }
            
            #caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }
            
            .mydate {
                font-weight: bold;
                color: #474747;
            }
            
            #level_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #category_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #position_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #div_item_sch {
                background-color: #EEE;
                color: #575757;
                padding: 5px 7px;
            }
            
            #record_count{
                font-size: 12px;
                font-weight: bold;
                padding-bottom: 9px;
            }
            #box-form {
                background-color: #EEE; 
                border-radius: 5px;
            }
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .form-title {
                padding: 11px 21px;
                text-align: left;
                border-bottom: 1px solid #DDD;
                background-color: #FFF;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                text-align: left;
                padding: 21px;
                background-color: #DDD;
            }
            .form-footer {
                border-top: 1px solid #DDD;
                padding: 11px 21px;
                background-color: #FFF;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }
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
            .footer-page {
                font-size: 12px; 
            }
            h2 {
                padding: 7px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
        </style>
        <!-- #EndEditable -->
    </head>

   <body>
        <div id="menu_utama">
            <span id="menu_title">Document <strong style="color:#333;"> / </strong><%=docMasterAction.getActionName()%></span>
        </div>
       <div class="content-main">
           <form name="frmEmpDocField" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="oidEmpDoc" value="<%=oidEmpDoc%>">
                <input type="hidden" name="oidEmpDocAction" value="<%=oidEmpDocAction%>">
                <input type="hidden" name="oidDocAction" value="<%=oidDocAction%>">
                <input type="hidden" name="type_action" value="<%= typeAction %>">
                
                <% if ((docMasterAction.getActionName().equals("Mutation"))) {%>
                <%=valid%> test
                <%=msgStringAll%>
                <table style="border:1px solid ; border-color: #0084ff; border-style: groove;" width="80%" border="1" cellspacing="1" cellpadding="1" class="tablecolor">

                    <tr>
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            EMP NUM
                        </td>
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            NAME
                        </td>
                        <!-- <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                             COMPANY CURRENT
                         </td>-->
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            COMPANY AFTER
                        </td>
                        <!--<td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            DIVISION CURRENT
                        </td>-->
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            DIVISION AFTER
                        </td>
                        <!--<td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            DEPARTMENT CURRENT
                        </td>-->
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            DEPARTMENT AFTER
                        </td>
                        <!--<td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            EMP CAT CURRENT
                        </td>-->
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            EMP CAT AFTER
                        </td>
                        <!--<td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            LEVEL CURRENT
                        </td>-->
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            LEVEL AFTER
                        </td>
                        <!--<td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            POSITION CURRENT
                        </td>-->
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            POSITION AFTER
                        </td>
                        <!-- <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                             SECTION CURRENT
                         </td> -->
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            SECTION AFTER
                        </td>
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            WORK TO AFTER
                        </td>
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            SELECT ALL
                        </td>

                    </tr>


                    <%
                        for (int list = 0; list < listEmp.size(); list++) {

                            EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                            Employee employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                            Hashtable HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());

                    %>

                    <tr>
                        <td  style="background-color: #ffffff; text-align: center;">
                            <%=employeeFetch.getEmployeeNum()%>
                        </td>
                        <td  style="background-color: #ffffff; text-align: center;">
                            <%=employeeFetch.getFullName()%>
                        </td>
                        <!--<td  style="background-color: #ffffff; text-align: center;">
                        <%//=employeeFetch.getCompanyId()%>
                    </td>-->
                        <td  style="background-color: #ffffff; text-align: center;">
                            <%=newCompanyS%>
                        </td>
                        <!-- <td  style="background-color: #ffffff; text-align: center;">
                        <%//=employeeFetch.getDivisionId()%>
                    </td>-->
                        <td  style="background-color: #ffffff; text-align: center;">
                            <%=newDivisionS%>
                        </td>
                        <!--<td  style="background-color: #ffffff; text-align: center;">
                        <%//=employeeFetch.getDepartmentId()%>
                    </td>-->
                        <td  style="background-color: #ffffff; text-align: center;">
                            <%=newDepartmentS%>
                        </td>
                        <!--<td  style="background-color: #ffffff; text-align: center;">
                        <%//=employeeFetch.getEmpCategoryId()%>
                    </td> -->
                        <td  style="background-color: #ffffff; text-align: center;">
                            <%=newEmpCatS%>
                        </td>
                        <!--<td  style="background-color: #ffffff; text-align: center;">
                        <%//=employeeFetch.getLevelId()%>
                    </td> -->
                        <td  style="background-color: #ffffff; text-align: center;">
                            <%=newLevelS%>
                        </td>
                        <!-- <td  style="background-color: #ffffff; text-align: center;">
                        <%//=employeeFetch.getPositionId()%>
                    </td> -->
                        <td  style="background-color: #ffffff; text-align: center;">
                            <%=newPositionS%>
                        </td>
                        <!--<td  style="background-color: #ffffff; text-align: center;">
                        <%//=employeeFetch.getSectionId()%>
                    </td> -->
                        <td  style="background-color: #ffffff; text-align: center;">
                            <%=newSectionS%>
                        </td>
                        <td  style="background-color: #ffffff; text-align: center;">
                            <%=workFromS%>
                        </td>
                        <td  style="background-color: #ffffff; text-align: center;">
                            <input type="checkbox" name="userSelect<%=employeeFetch.getOID()%>" id="userSelect<%=employeeFetch.getOID()%>" value="1" >
                        </td>
                    </tr>

                    <% }%>
                </table>
                <% if (count == 0) {%>
                <tr>
                    <td colspan="2">
                        <button class="btn" onclick="cmdSaveMutation()">RUN</button>
                    </td>
                </tr>
                <% } else {%>
                <tr>
                    <td colspan="2">
                        Action sudah dilakukan
                    </td>
                </tr>
                <% }%>
                <% } else if (docMasterAction.getActionName().equals("Mutation to All")) {%>
                <!-- valid -->
                <% 
                if (listEmp != null && listEmp.size()>0){ 
                    if (typeAction == 0){
                %>
                <!--
                <table>
                    <tr>
                        <td>Tipe Surat</td>
                        <td>Tipe Surat</td>
                    </tr>
                </table>-->
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl">Emp. Number</td>
                        <td class="title_tbl">Nama Karyawan</td>
                        <td class="title_tbl">Sekarang</td>
                        <td class="title_tbl">Perubahan</td>
                    </tr>

                    <%
                        for (int list = 0; list < listEmp.size(); list++) {
                            EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                            Employee employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                            //Hashtable HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());
                            Employee dataEmpNow = new Employee();
                            try {
                                dataEmpNow = PstEmployee.fetchExc(empDocList.getEmployee_id());
                            } catch(Exception e){
                                System.out.println("emp data now=>"+e.toString());
                            }
                            Vector dataChanged = PstEmpDocListMutation.getNewPositionVersi1(oidEmpDoc, employeeFetch.getOID(), docMasterActionParam1.getObjectName());
                            long[] arrData = new long[10];
                            if (dataChanged != null && dataChanged.size()>0 ){
                                arrData = (long[])dataChanged.get(0);
                            }
                            //String value = (String) HashtableEmp.get("NOW_POSITION");
                            //String newposition = PstEmpDocListMutation.getNewPosition(oidEmpDoc, employeeFetch.getOID(), docMasterActionParam1.getObjectName());
                    %>

                    <tr>
                        <td valign="top" style="background-color: #FFF;">
                            <%=employeeFetch.getEmployeeNum()%>
                        </td>
                        <td valign="top" style="background-color: #FFF;">
                            <%=employeeFetch.getFullName()%>
                        </td>
                        <td valign="top" style="background-color: #FFF;">
                            <table>
                                <tr>
                                    <td><strong>Perusahaan</strong></td>
                                    <td><%= changeValue.getCompanyName(dataEmpNow.getCompanyId()) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Satuan Kerja</strong></td>
                                    <td><%= changeValue.getDivisionName(dataEmpNow.getDivisionId()) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Unit</strong></td>
                                    <td><%= changeValue.getDepartmentName(dataEmpNow.getDepartmentId()) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Sub Unit</strong></td>
                                    <td><%= changeValue.getSectionName(dataEmpNow.getSectionId()) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Jabatan</strong></td>
                                    <td><%= changeValue.getPositionName(dataEmpNow.getPositionId()) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Level</strong></td>
                                    <td><%= changeValue.getLevelName(dataEmpNow.getLevelId()) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Kategori</strong></td>
                                    <td><%= changeValue.getEmpCategory(dataEmpNow.getEmpCategoryId()) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Grade</strong></td>
                                    <td><%= changeValue.getGradeLevelName(dataEmpNow.getGradeLevelId()) %></td>
                                </tr>
                                <tr>
                                    <td><strong>History Group</strong></td>
                                    <td><%= PstCareerPath.historyGroup[dataEmpNow.getHistoryGroup()] %></td>
                                </tr>
                                <tr>
                                    <td><strong>History Type</strong></td>
                                    <td><%= PstCareerPath.historyType[dataEmpNow.getHistoryType()] %></td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top" style="background-color: #FFF;">
                            <% if (dataChanged != null && dataChanged.size()>0 ){ %>
                            <table>
                                <tr>
                                    <td><strong>Perusahaan</strong></td>
                                    <td><%= changeValue.getCompanyName(arrData[0]) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Satuan Kerja</strong></td>
                                    <td><%= changeValue.getDivisionName(arrData[1]) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Unit</strong></td>
                                    <td><%= changeValue.getDepartmentName(arrData[2]) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Sub Unit</strong></td>
                                    <td><%= changeValue.getSectionName(arrData[3]) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Jabatan</strong></td>
                                    <td><%= changeValue.getPositionName(arrData[4]) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Level</strong></td>
                                    <td><%= changeValue.getLevelName(arrData[5]) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Kategori</strong></td>
                                    <td><%= changeValue.getEmpCategory(arrData[6]) %></td>
                                </tr>
                                <tr>
                                    <td><strong>Grade</strong></td>
                                    <td><%= changeValue.getGradeLevelName(arrData[7]) %></td>
                                </tr>
                                <tr>
                                    <td><strong>History Group</strong></td>
                                    <% int dataHisG = Integer.valueOf(""+arrData[8]) ; %>
                                    <td><%= PstCareerPath.historyGroup[dataHisG] %></td>
                                </tr>
                                <tr>
                                    <td><strong>History Type</strong></td>
                                    <% int dataHisT = Integer.valueOf(""+arrData[9]); %>
                                    <td><%= PstCareerPath.historyType[dataHisT] %></td>
                                </tr>
                            </table>
                            <% } else { %>
                            <strong>Tidak Ada Perubahan</strong>
                            <% } %>
                        </td>
                    </tr>

                    <%
                        }
                    %>
                </table>
                <%  } else {

                        for (int list = 0; list < listEmp.size(); list++) {
                            EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                            Vector dataChanged = PstEmpDocListMutation.getNewPositionVersi1(oidEmpDoc, empDocList.getEmployee_id(), docMasterActionParam1.getObjectName());
                            String nama = "-";
                            try {
                                RecrApplication appLetter = PstRecrApplication.fetchExc(empDocList.getEmployee_id());
                                nama = appLetter.getFullName();
                            } catch(Exception e){
                                System.out.println(e.toString());
                            }
                            long[] arrData = new long[10];
                            if (dataChanged != null && dataChanged.size()>0 ){
                                arrData = (long[])dataChanged.get(0);
                            }
                            %>
                            <div style="padding: 9px; margin: 5px; border: 1px solid #DDD; border-radius: 3px; ">
                                <table class="tblStyle">
                                    <tr>
                                        <td>Nama</td>
                                        <td><%= nama %></td>
                                    </tr>
                                    <tr>
                                        <td>Perusahaan</td>
                                        <td><%= changeValue.getCompanyName(arrData[0]) %></td>
                                    </tr>
                                    <tr>
                                        <td>Satuan Kerja</td>
                                        <td><%= changeValue.getDivisionName(arrData[1]) %></td>
                                    </tr>
                                    <tr>
                                        <td>Unit</td>
                                        <td><%= changeValue.getDepartmentName(arrData[2]) %></td>
                                    </tr>
                                    <tr>
                                        <td>Sub Unit</td>
                                        <td><%= changeValue.getSectionName(arrData[3]) %></td>
                                    </tr>
                                    <tr>
                                        <td>Jabatan</td>
                                        <td><%= changeValue.getPositionName(arrData[4]) %></td>
                                    </tr>
                                    <tr>
                                        <td>Level</td>
                                        <td><%= changeValue.getLevelName(arrData[5]) %></td>
                                    </tr>
                                </table>
                            </div>
                            <%
                        }

                    }
                %>
                <% } // end if (listEmp != null && listEmp.size()>0) %>
                <% if (count == 0) {%>
                <tr>
                    <td colspan="2">
                        <div>&nbsp;</div>
                        <a class="btn" style="color:#FFF;" href="javascript:cmdSaveMutation()">Run</a>
                        <div>&nbsp;</div>
                    </td>
                </tr>
                <% } else {%>
                <tr>
                    <td colspan="2">
                        <div>&nbsp;</div>
                        <div class="info">Action sudah dilakukan</div>
                        <div>&nbsp;</div>
                    </td>
                </tr>  
                <% }%>
                <% } else if (docMasterAction.getActionName().equals("Update Gaji Employee")) {%>

                <%=valid%>
                <table style="border:1px solid ; border-color: #0084ff; border-style: groove;" width="80%" border="1" cellspacing="1" cellpadding="1" class="tablecolor">

                    <tr>
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            EMP NUM
                        </td>
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            NAME
                        </td>
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            SALARY LEVEL CURRENT
                        </td>
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            NEW SALARY LEVEL
                        </td>
                        <td style="background: #9e9e9e; text-align: center; font-size: 15; ">
                            SELECT
                        </td>

                    </tr>


                    <%
                        for (int list = 0; list < listEmp.size(); list++) {

                            EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                            Employee employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                            Hashtable HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());
                            String whereLevel1 = PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_EMPLOYEE_ID] + " = '" + (employeeFetch.getOID()) + "'";
                            String orderDate1 = PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_START_DATE] + " DESC ";
                            Vector listEmpLevelByEmployeeId1 = PstPayEmpLevel.list(0, 0, whereLevel1, orderDate1);
                            PayEmpLevel payEmpLevel = new PayEmpLevel();
                            String salaryLevelName = "";
                            if (listEmpLevelByEmployeeId1.size() > 0) {

                                try {
                                    payEmpLevel = (PayEmpLevel) listEmpLevelByEmployeeId1.get(0);
                                } catch (Exception e) {
                                }

                                salaryLevelName = PstSalaryLevel.getSalaryName(payEmpLevel.getLevelCode());
                            }
                    %>

                    <tr>
                        <td>
                            <%=employeeFetch.getEmployeeNum()%>
                        </td>
                        <td>
                            <%=employeeFetch.getFullName()%>
                        </td>
                        <td>
                            <%=salaryLevelName%>
                        </td>
                        <td>
                            <%=newSalaryLevel%>
                        </td>
                        <td>
                            <input type="checkbox" name="userSelect<%=employeeFetch.getOID()%>" id="userSelect<%=employeeFetch.getOID()%>" value="1" >
                        </td>
                    </tr>

                    <% }%>
                </table>
                <% if ((count == 0) && (!empDocX.getDetails().equals(""))) {%>
                <tr>
                    <td colspan="2">
                        <button class="btn" onclick="cmdSaveMutation()">RUN</button> Sebelum melakukan action, Mohon dicek apakah document ini sudah disave atau belum..
                    </td>
                </tr>
                <% } else {%>
                <tr>
                    <td colspan="2">
                        Action sudah dilakukan || document belum disimpan
                    </td>
                </tr>
                <% }%>
                <% } else if (docMasterAction.getActionName().equals("Approval Replacement")) {%>
				<table style="border:1px solid ; border-color: #0084ff;" width="80%" border="1">
					<tr style="text-align: center;">
						<td>Satuan Kerja</td>
						<td>Up Position</td>
						<td>Down Position</td>
						<td>Start Date</td>
						<td>End Date</td>
					</tr>
					<tr>
						<td><%=divisionRep%></td>
						<td><%=upPositionRep%></td>
						<td><%=downPositionRep%></td>
						<td><%=startDateRep%></td>
						<td><%=endDateRep%></td>
					</tr>
				</table>
				<% if (count == 0) {%>
					<tr>
						<td colspan="2">
							<button class="btn" onclick="cmdSaveApproval()">RUN</button>
						</td>
					</tr>
				<% } else {%>
					<tr>
						<td colspan="2">
							Action sudah dilakukan
						</td>
					</tr>
                <% }%>
				<% } else if (docMasterAction.getActionName().equals(DocMasterActionClass.actionKey[6])) {%>
					<table style="border:1px solid ; border-color: #0084ff;" width="80%" border="1">
						<tr style="text-align: center;">
							<td>Schedule</td>
							<td>Start Date</td>
							<td>End Date</td>
						</tr>
						<tr>
							<td>
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
										+ " OR " + PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SCHEDULE_CATEGORY_ID] + " = " + oidUnpaidLeave+") ";
										Vector listSchedule = PstScheduleSymbol.list(0, 0, whereSchedule, null);
								%>
								<select name="schedule_id">
									<%
									if (listSchedule != null && listSchedule.size()>0){
                                        for (int i=0; i<listSchedule.size(); i++){
                                            ScheduleSymbol scheduleSymbol = (ScheduleSymbol) listSchedule.get(i);
                                            %><option value="<%= scheduleSymbol.getOID() %>"><%= scheduleSymbol.getSchedule() %></option><%
										}
									}	
									%>
								</select>
							</td>
							<td><%=startDateRep%></td>
							<td><%=endDateRep%></td>
						</tr>
					</table>
				<% if (count == 0) {%>
					<tr>
						<td colspan="2">
							<button class="btn" onclick="cmdSaveApproval()">RUN</button>
						</td>
					</tr>
				<% } else {%>
					<tr>
						<td colspan="2">
							Action sudah dilakukan
						</td>
					</tr>
                <% }%>
                <% } else if (docMasterAction.getActionName().equals(DocMasterActionClass.actionKey[7])) {%>
                    <%
                        String where = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID] + " = " + oidEmpDoc
                                +" AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME] + " IN ('DEBET','KREDIT')";
                        Vector listData = PstEmpDocListExpense.list(0, 0, where, "");
                        String jenis = "";
                        for (int i=0 ; i < listData.size(); i++){
                            EmpDocListExpense empDoc = (EmpDocListExpense) listData.get(i);
                            if (empDoc.getObjectName().equals("DEBET")){
                                jenis = "Kelebihan";
                            } else if (empDoc.getObjectName().equals("KREDIT")){
                                jenis = "Kekurangan";
                            }
                        }
                    %>
                    <table style="border:1px solid ; border-color: #0084ff;" width="80%" border="1">
                        <tr style="text-align: center;">
                            <td>NRK</td>
                            <td>Nama Lengkap</td>
                            <td>Periode</td>
                            <td>Komponen</td>
                            <td>Nilai</td>
                        </tr>
                        <%
                            for (int x=0 ; x < listData.size(); x++){
                                EmpDocListExpense docExpense = (EmpDocListExpense) listData.get(x);

                                Employee emp = new Employee();
                                PayComponent payCom = new PayComponent();
                                PayPeriod period = new PayPeriod();
                                try {
                                    emp = PstEmployee.fetchExc(docExpense.getEmployeeId());
                                } catch (Exception exc){}

                                try {
                                    payCom = PstPayComponent.fetchExc(docExpense.getComponentId());
                                } catch (Exception exc){}

                                try {
                                    period = PstPayPeriod.fetchExc(docExpense.getPeriodeId());
                                } catch (Exception exc){}
                            
                        %>
                        <tr>
                            <td><%=emp.getEmployeeNum()%></td>
                            <td><%=emp.getFullName()%></td>
                            <td><%=period.getPeriod()%></td>
                            <td><%=payCom.getCompName()%></td>
                            <td><%=Formater.formatNumberMataUang(docExpense.getCompValue(), "Rp")%></td>
                        </tr>
                        <%
                            }
                        %>
                    </table>
                    <br>
                    <% if (count == 0) {%>
                            <tr>
                                <td colspan="2">
                                        <button class="btn" onclick="cmdSaveApproval()">RUN</button>
                                </td>
                            </tr>
                    <% } else {%>
                            <tr>
                                <td colspan="2">
                                        Action sudah dilakukan
                                </td>
                            </tr>
                    <% }%>
                <% } %>
                <%=msgString%>
            </form>
       </div>
                              
                                                                                
       <div class="footer-page">
            <table>
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
                <tr>
                    <td valign="bottom"><%@include file="../../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
    </body>
</html>
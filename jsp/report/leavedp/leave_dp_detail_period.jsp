
<%@page import="com.dimata.harisma.entity.payroll.PayGeneral"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayGeneral"%>
<%-- 
    Document   : leave_dp_detail_period
    Created on : Sep 13, 2010, 11:13:02 AM
    Author     : roy ajus
--%>

<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package wihita -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package harisma -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.leave.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ page import = "com.dimata.harisma.entity.search.*" %>
<%@ page import = "com.dimata.harisma.form.search.*" %>
<%@ page import = "com.dimata.harisma.session.leave.*" %>
<%@ page import = "com.dimata.harisma.session.*" %>
<%@ page import = "com.dimata.harisma.entity.attendance.*"%>

<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_LEAVE_REPORT, AppObjInfo.OBJ_LEAVE_DP_DETAIL);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%!    public String drawList(int objectClass, long oidCompany, long oidDivision, long oidDepartment, long oidSection, int radio, long oidPeriod, String empNum, String fullName, long empCat) {

        String result = "";
        int useDP = 1;
        try {
            useDP = Integer.parseInt(PstSystemProperty.getValueByName("USE_DP"));
        } catch (Exception exc) {
            System.out.println("Execption USE_DP " + exc);
            useDP = 1;
        }

        if ((objectClass != 0 && objectClass > 0)) {

            ControlList ctrlist = new ControlList();
            ctrlist.setAreaWidth("100%");
            ctrlist.setListStyle("listgen");
            ctrlist.setTitleStyle("listgentitle");
            ctrlist.setCellStyle("listgensell");
            ctrlist.setHeaderStyle("listgentitle");

            ctrlist.addHeader("<center>NO</center>", "2%", "2", "0");
            ctrlist.addHeader("<center>DEPT</center>", "30%", "2", "0");
            ctrlist.addHeader("<center>" + dictionaryD.getWord(I_Dictionary.PAYROLL) + "</center>", "8%", "2", "0");
            ctrlist.addHeader("<center>NAME</center>", "30%", "2", "0");

            if (useDP == 1) {
                ctrlist.addHeader("DP", "35%", "0", "7");
            }
            ctrlist.addHeader("AL", "25%", "0", "6");
            ctrlist.addHeader("LL", "35%", "0", "7");

            if (useDP == 1) {
                /* DP */
                ctrlist.addHeader("PREV.", "5%", "0", "0");
                ctrlist.addHeader("TKN PREV.", "5%", "0", "0");
                ctrlist.addHeader("EXP PREV.", "5%", "0", "0");
                ctrlist.addHeader("QTY.", "5%", "0", "0");
                ctrlist.addHeader("TAKEN", "5%", "0", "0");
                ctrlist.addHeader("EXP", "5%", "0", "0");
                ctrlist.addHeader("BAL.", "5%", "0", "0");
            }
            /* AL */
            ctrlist.addHeader("PREV.", "5%", "0", "0");
            ctrlist.addHeader("TAKEN PREV.", "5%", "0", "0");
            ctrlist.addHeader("QTY.", "5%", "0", "0");
            ctrlist.addHeader("TAKEN", "5%", "0", "0");
            ctrlist.addHeader("TO BE TAKEN", "5%", "0", "0");
            ctrlist.addHeader("BAL.", "5%", "0", "0");

            /* LL */
            ctrlist.addHeader("PREV.", "5%", "0", "0");
            ctrlist.addHeader("TAKEN PREV.", "5%", "0", "0");
            ctrlist.addHeader("EXP PREV.", "5%", "0", "0");
            ctrlist.addHeader("QTY", "5%", "0", "0");
            ctrlist.addHeader("TAKEN", "5%", "0", "0");
            ctrlist.addHeader("EXP", "5%", "0", "0");
            ctrlist.addHeader("BAL.", "5%", "0", "0");

            ctrlist.setLinkRow(-1);
            ctrlist.setLinkSufix("");
            Vector lstData = ctrlist.getData();
            Vector lstLinkData = ctrlist.getLinkData();
            ctrlist.setLinkPrefix("javascript:cmdEdit('");
            ctrlist.setLinkSufix("')");
            ctrlist.reset();

            int no = 1;
            int valueSection = 0;

            int sumEmp = 0;
            float dpQtyBeforeStartPeriod = 0;
            float dpTknBeforeStartPeriod = 0;
            float dpTknExpBeforeStartPeriod = 0;
            float dpQtyCurrentPeriod = 0;
            float dpTknCurrentPeriod = 0;
            float dpTknExpiredCurrentPeriod = 0;
            float db_balance = 0;

            float alQtyBeforeStartPeriod = 0;
            float alTknBeforeStartPeriod = 0;
            float alQtyCurrentPeriod = 0;
            float alTknCurrentPeriod = 0;
            //UPDATE by devin 2104-04-03
            float alToBeTaken = 0;
            float al_balance = 0;

            float llQtyBeforeStartPeriod = 0;
            float llTknBeforeStartPeriod = 0;
            float llTknExpBeforeStartPeriod = 0;
            float llQtyCurrentPeriod = 0;
            float llTknCurrentPeriod = 0;
            float llTknExpiredCurrentPeriod = 0;
            float ll_balance = 0;

            long dep_id = 0;
            long sec_id = 0;
            //update by devin 2014-04-15
            String wereClause = "";
            String wereClauseDivsion = "";
            String wereClauseDepartment = "";
            String wereClauseSection = "";
            long oidDivisionByEmp = 0;
            long oidDepartmentByEmp = 0;
            long oidSectionByEmp = 0;
            Vector listDivision = new Vector();
            if (oidCompany != 0) {
                wereClause = PstPayGeneral.fieldNames[PstPayGeneral.FLD_GEN_ID] + "=" + oidCompany;
            }
            if ((empNum != null && empNum.length() > 0) || (fullName != null && fullName.length() > 0)) {
                String whereEmpNum = "";
                if ((empNum != null && empNum.length() > 0) && (fullName == "" && fullName.length() == 0)) {
                    whereEmpNum = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + "=" + empNum;
                } else if ((empNum == "" && empNum.length() == 0) && (fullName != null && fullName.length() > 0)) {
                    whereEmpNum = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + "=" + fullName;
                } else if ((empNum != null && empNum.length() > 0) && (fullName != null && fullName.length() > 0)) {
                    whereEmpNum = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + "=" + empNum + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + "=" + fullName;
                }

                Vector listEmpNum = PstEmployee.list(0, 0, whereEmpNum, "");
                if (listEmpNum != null && listEmpNum.size() > 0) {
                    for (int emp = 0; emp < listEmpNum.size(); emp++) {
                        Employee employee = (Employee) listEmpNum.get(emp);
                        wereClause = PstPayGeneral.fieldNames[PstPayGeneral.FLD_GEN_ID] + "=" + employee.getCompanyId();
                        if (employee.getDivisionId() > 0) {
                            oidDivisionByEmp = employee.getDivisionId();
                        }
                        if (employee.getDepartmentId() > 0) {
                            oidDepartmentByEmp = employee.getDepartmentId();
                        }
                        if (employee.getSectionId() > 0) {
                            oidSectionByEmp = employee.getSectionId();
                        }

                    }
                }

            }
            /*if(oidDivision!=0){ 
             wereClauseDivsion=PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID]+"="+oidCompany+" AND "+PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]+"="+oidDivision;
             }*/
            Vector listCompany = PstPayGeneral.list(0, 0, wereClause, "");
            /*if(oidDivision!=0){
             listDivision=PstDivision.list(0, 0, wereClauseDivsion, "");
             }*/
            if (listCompany != null && listCompany.size() > 0) {
                for (int x = 0; x < listCompany.size(); x++) {
                    no = 1;
                    PayGeneral payGeneral = (PayGeneral) listCompany.get(x);
                    Vector rowxCompany = new Vector();
                    rowxCompany.add("");
                    rowxCompany.add("" + "<b>" + payGeneral.getCompanyName() + "</b>");
                    int col = 0;
                    if (useDP == 1) {
                        col = 22;
                    } else {
                        col = 15;
                    }
                    for (int cmp = 0; cmp < col; cmp++) {
                        rowxCompany.add("");
                    }
                    lstData.add(rowxCompany);
                    if (oidDivision == 0 || oidDivision != 0) {
                        String whereDivision = "";
                        if (oidCompany != 0 && oidDivision != 0) {
                            whereDivision = PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + "=" + oidDivision;
                        } else if (oidCompany != 0 && oidDivision == 0) {
                            whereDivision = PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID] + "=" + oidCompany;
                        } else if (oidCompany == 0 && oidDivision == 0) {
                            whereDivision = PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID] + "=" + payGeneral.getOID();
                        }
                        //update by devin 2014-04-18
                        if (oidDivisionByEmp != 0 && oidDivisionByEmp > 0) {
                            whereDivision = PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + "=" + oidDivisionByEmp;
                        }
                        Vector listDiv = PstDivision.list(0, 0, whereDivision, "");
                        for (int div = 0; div < listDiv.size(); div++) {
                            Division division = (Division) listDiv.get(div);
                            Vector rowxDivision = new Vector();
                            rowxDivision.add("" + no);
                            rowxDivision.add("" + "&nbsp;&nbsp;<b>" + division.getDivision() + "</b>");
                            col = 0;
                            if (useDP == 1) {
                                col = 22;
                            } else {
                                col = 15;
                            }
                            for (int vDiv = 0; vDiv < col; vDiv++) {
                                rowxDivision.add("");
                            }
                            lstData.add(rowxDivision);
                            String whereDept = "";
                            if (oidDivision != 0 && oidDepartment != 0) {
                                whereDept = PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID] + "=" + oidDepartment;
                            } else if (oidDivision != 0 && oidDepartment == 0) {
                                whereDept = PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + "=" + oidDivision;
                            } else if (oidDivision == 0 && oidDepartment == 0) {
                                whereDept = PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + "=" + division.getOID();
                            }
                            //update by devin 2014-04-18
                            if (oidDepartmentByEmp != 0 && oidDepartmentByEmp > 0) {
                                whereDept = PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID] + "=" + oidDepartmentByEmp;
                            }
                            Vector listDataDepartment = PstDepartment.list(0, 0, whereDept, "");
                            for (int vDept = 0; vDept < listDataDepartment.size(); vDept++) {
                                valueSection = 0;
                                Department departmentt = (Department) listDataDepartment.get(vDept);
                                //update by devin 2014-04-16
                                String whereSection = "";
                                Vector checkSection = new Vector();
                                if (oidSection != 0) {
                                    whereSection = PstSection.fieldNames[PstSection.FLD_SECTION_ID] + "=" + oidSection;
                                    checkSection = PstSection.list(0, 0, whereSection, "");
                                } else {
                                    whereSection = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + "=" + departmentt.getOID();
                                    checkSection = PstSection.list(0, 0, whereSection, "");
                                }

                                SrcLeaveManagement srcLeaveManagement = new SrcLeaveManagement();
                                if (oidCompany != 0) {
                                    srcLeaveManagement.setCompanyId(oidCompany);
                                } else {
                                    srcLeaveManagement.setCompanyId(payGeneral.getOID());
                                }
                                if (oidDivision != 0) {
                                    srcLeaveManagement.setDivisionId(oidDivision);
                                } else {
                                    srcLeaveManagement.setDivisionId(division.getOID());
                                }
                                if (oidDepartment != 0) {
                                    srcLeaveManagement.setEmpDeptId(oidDepartment);
                                } else {
                                    srcLeaveManagement.setEmpDeptId(departmentt.getOID());
                                }
                                if (oidSection != 0) {
                                    srcLeaveManagement.setEmpSectionId(oidSection);
                                }
                                if (empNum != null && empNum.length() > 0) {
                                    srcLeaveManagement.setEmpNum(empNum);
                                }
                                if (fullName != null && fullName.length() > 0) {
                                    srcLeaveManagement.setEmpName(fullName);
                                }
                                if (empCat != 0 && empCat > 0) {
                                    srcLeaveManagement.setEmpCatId(empCat);
                                }
                                srcLeaveManagement.setTime(radio);
                                srcLeaveManagement.setPeriodId(oidPeriod);

                                Vector listData = SessLeaveApplication.leave_Detail(srcLeaveManagement, checkSection, valueSection);
                                     //update by devin 2014-04-17

                                if (listData == null || listData.size() == 0) {
                                    Vector rowxDept = new Vector();
                                    rowxDept.add("");
                                    rowxDept.add("" + "&nbsp;&nbsp;&nbsp;<b>" + departmentt.getDepartment() + "</b>");
                                    col = 0;
                                    if (useDP == 1) {
                                        col = 22;
                                    } else {
                                        col = 15;
                                    }
                                    for (int vDepartementt = 0; vDepartementt < col; vDepartementt++) {
                                        rowxDept.add("");
                                    }
                                    lstData.add(rowxDept);
                                }
                                if (listData != null && listData.size() > 0) {
                                    for (int idx = 0; idx < listData.size(); idx++) {

                                        float bal_dp = 0;
                                        float bal_al = 0;
                                        float bal_ll = 0;
                                        Vector rowx = new Vector();

                                        RepLevDepartment repLevDepartment = new RepLevDepartment();

                                        repLevDepartment = (RepLevDepartment) listData.get(idx);

                                        Department department = new Department();

                                        String nameDepartment = "";

                                        if (dep_id != repLevDepartment.getDepartmentId()) {

                                            try {

                                                department = PstDepartment.fetchExc(repLevDepartment.getDepartmentId());
                                                nameDepartment = department.getDepartment();

                                            } catch (Exception e) {
                                                System.out.println("[exception] " + e.toString());
                                            }
                                            dep_id = repLevDepartment.getDepartmentId();
                                        }

                                        rowx.add("");

                                        rowx.add("" + "&nbsp;&nbsp;&nbsp;<b>" + nameDepartment + "</b>");
                                        rowx.add("" + repLevDepartment.getEmp_num());
                                        rowx.add("" + repLevDepartment.getFull_name());

                                        sumEmp = sumEmp + repLevDepartment.getCountEmployee();

                                        if (useDP == 1) {
                                            rowx.add("" + repLevDepartment.getDpQtyBeforeStartPeriod());
                                            rowx.add("" + repLevDepartment.getDpTknBeforeStartPeriod());
                                            rowx.add("" + repLevDepartment.getDpTknExpBeforeStartPeriod());
                                            rowx.add("" + repLevDepartment.getDpQtyCurrentPeriod());
                                            rowx.add("" + repLevDepartment.getDpTknCurrentPeriod());
                                            rowx.add("" + repLevDepartment.getDpTknExpiredCurrentPeriod());

                                            dpQtyBeforeStartPeriod = dpQtyBeforeStartPeriod + repLevDepartment.getDpQtyBeforeStartPeriod();
                                            dpTknBeforeStartPeriod = dpTknBeforeStartPeriod + repLevDepartment.getDpTknBeforeStartPeriod();
                                            dpTknExpBeforeStartPeriod = dpTknExpBeforeStartPeriod + repLevDepartment.getDpTknExpBeforeStartPeriod();
                                            dpQtyCurrentPeriod = dpQtyCurrentPeriod + repLevDepartment.getDpQtyCurrentPeriod();
                                            dpTknCurrentPeriod = dpTknCurrentPeriod + repLevDepartment.getDpTknCurrentPeriod();
                                            dpTknExpiredCurrentPeriod = dpTknExpiredCurrentPeriod + repLevDepartment.getDpTknExpiredCurrentPeriod();

                                            bal_dp = repLevDepartment.getDpQtyBeforeStartPeriod()
                                                    - repLevDepartment.getDpTknBeforeStartPeriod()
                                                    - repLevDepartment.getDpTknExpBeforeStartPeriod()
                                                    + repLevDepartment.getDpQtyCurrentPeriod()
                                                    - repLevDepartment.getDpTknCurrentPeriod()
                                                    - repLevDepartment.getDpTknExpiredCurrentPeriod();

                                            rowx.add("" + bal_dp);
                                            db_balance = db_balance + bal_dp;
                                        }
                                        rowx.add("" + repLevDepartment.getAlQtyBeforeStartPeriod());
                                        rowx.add("" + repLevDepartment.getAlTknBeforeStartPeriod());
                                        rowx.add("" + repLevDepartment.getAlQtyCurrentPeriod());
                                        rowx.add("" + repLevDepartment.getAlTknCurrentPeriod());
                                        rowx.add("" + repLevDepartment.getAlToBeTaken());

                                        bal_al = repLevDepartment.getAlQtyBeforeStartPeriod()
                                                - repLevDepartment.getAlTknBeforeStartPeriod()
                                                + repLevDepartment.getAlQtyCurrentPeriod()
                                                - repLevDepartment.getAlTknCurrentPeriod() - repLevDepartment.getAlToBeTaken();
                                        rowx.add("" + bal_al);

                                        alQtyBeforeStartPeriod = alQtyBeforeStartPeriod + repLevDepartment.getAlQtyBeforeStartPeriod();
                                        alTknBeforeStartPeriod = alTknBeforeStartPeriod + repLevDepartment.getAlTknBeforeStartPeriod();
                                        alQtyCurrentPeriod = alQtyCurrentPeriod + repLevDepartment.getAlQtyCurrentPeriod();
                                        alTknCurrentPeriod = alTknCurrentPeriod + repLevDepartment.getAlTknCurrentPeriod();
                                        alToBeTaken = alToBeTaken + repLevDepartment.getAlToBeTaken();
                //UPDATE by devin 2104-04-03

                                        al_balance = al_balance + bal_al;

                                        rowx.add("" + repLevDepartment.getLLQtyBeforeStartPeriod());
                                        rowx.add("" + repLevDepartment.getLLTknBeforeStartPeriod());
                                        rowx.add("" + repLevDepartment.getLLTknExpBeforeStartPeriod());
                                        rowx.add("" + repLevDepartment.getLLQtyCurrentPeriod());
                                        rowx.add("" + repLevDepartment.getLLTknCurrentPeriod());
                                        rowx.add("" + repLevDepartment.getLLTknExpiredCurrentPeriod());

                                        bal_ll = repLevDepartment.getLLQtyBeforeStartPeriod()
                                                - repLevDepartment.getLLTknBeforeStartPeriod()
                                                - repLevDepartment.getLLTknExpBeforeStartPeriod()
                                                + repLevDepartment.getLLQtyCurrentPeriod()
                                                - repLevDepartment.getLLTknCurrentPeriod()
                                                - repLevDepartment.getLLTknExpiredCurrentPeriod();
                                        rowx.add("" + bal_ll);

                                        llQtyBeforeStartPeriod = llQtyBeforeStartPeriod + repLevDepartment.getLLQtyBeforeStartPeriod();
                                        llTknBeforeStartPeriod = llTknBeforeStartPeriod + repLevDepartment.getLLTknBeforeStartPeriod();
                                        llTknExpBeforeStartPeriod = llTknExpBeforeStartPeriod + repLevDepartment.getLLTknExpBeforeStartPeriod();
                                        llQtyCurrentPeriod = llQtyCurrentPeriod + repLevDepartment.getLLQtyCurrentPeriod();
                                        llTknCurrentPeriod = llTknCurrentPeriod + repLevDepartment.getLLTknCurrentPeriod();
                                        llTknExpiredCurrentPeriod = llTknExpiredCurrentPeriod + repLevDepartment.getLLTknExpiredCurrentPeriod();

                                        ll_balance = ll_balance + bal_ll;

                                        lstData.add(rowx);
                                        lstLinkData.add("0");
                                    }
                                }
                                //update by devin 2014-04-16
                                if (checkSection != null && checkSection.size() > 0) {
                                    for (int vSection = 0; vSection < checkSection.size(); vSection++) {
                                        Section dtSection = new Section();
                                        valueSection = 1;
                                        dtSection = (Section) checkSection.get(vSection);
                                        if (oidSection == 0) {
                                            srcLeaveManagement.setEmpSectionId(dtSection.getOID());
                                        }
                                        Vector listDataSection = SessLeaveApplication.leave_Detail(srcLeaveManagement, checkSection, valueSection);
                                        if (listDataSection != null && listDataSection.size() > 0) {
                                            for (int idx = 0; idx < listDataSection.size(); idx++) {

                                                float bal_dp = 0;
                                                float bal_al = 0;
                                                float bal_ll = 0;
                                                Vector rowxSec = new Vector();

                                                RepLevDepartment repLevDepartment = new RepLevDepartment();

                                                repLevDepartment = (RepLevDepartment) listDataSection.get(idx);

                                                Section objSection = new Section();

                                                String nameSection = "";

                                                if (sec_id != dtSection.getOID()) {

                                                    try {

                                                        objSection = PstSection.fetchExc(dtSection.getOID());
                                                        nameSection = objSection.getSection();

                                                    } catch (Exception e) {
                                                        System.out.println("[exception] " + e.toString());
                                                    }
                                                    sec_id = dtSection.getOID();
                                                }

                                                rowxSec.add("");

                                                rowxSec.add("" + "&nbsp;&nbsp;&nbsp;" + nameSection + "");
                                                rowxSec.add("" + repLevDepartment.getEmp_num());
                                                rowxSec.add("" + repLevDepartment.getFull_name());

                                                sumEmp = sumEmp + repLevDepartment.getCountEmployee();
                                                if (useDP == 1) {
                                                    rowxSec.add("" + repLevDepartment.getDpQtyBeforeStartPeriod());
                                                    rowxSec.add("" + repLevDepartment.getDpTknBeforeStartPeriod());
                                                    rowxSec.add("" + repLevDepartment.getDpTknExpBeforeStartPeriod());
                                                    rowxSec.add("" + repLevDepartment.getDpQtyCurrentPeriod());
                                                    rowxSec.add("" + repLevDepartment.getDpTknCurrentPeriod());
                                                    rowxSec.add("" + repLevDepartment.getDpTknExpiredCurrentPeriod());

                                                    dpQtyBeforeStartPeriod = dpQtyBeforeStartPeriod + repLevDepartment.getDpQtyBeforeStartPeriod();
                                                    dpTknBeforeStartPeriod = dpTknBeforeStartPeriod + repLevDepartment.getDpTknBeforeStartPeriod();
                                                    dpTknExpBeforeStartPeriod = dpTknExpBeforeStartPeriod + repLevDepartment.getDpTknExpBeforeStartPeriod();
                                                    dpQtyCurrentPeriod = dpQtyCurrentPeriod + repLevDepartment.getDpQtyCurrentPeriod();
                                                    dpTknCurrentPeriod = dpTknCurrentPeriod + repLevDepartment.getDpTknCurrentPeriod();
                                                    dpTknExpiredCurrentPeriod = dpTknExpiredCurrentPeriod + repLevDepartment.getDpTknExpiredCurrentPeriod();

                                                    bal_dp = repLevDepartment.getDpQtyBeforeStartPeriod()
                                                            - repLevDepartment.getDpTknBeforeStartPeriod()
                                                            - repLevDepartment.getDpTknExpBeforeStartPeriod()
                                                            + repLevDepartment.getDpQtyCurrentPeriod()
                                                            - repLevDepartment.getDpTknCurrentPeriod()
                                                            - repLevDepartment.getDpTknExpiredCurrentPeriod();

                                                    rowxSec.add("" + bal_dp);
                                                    db_balance = db_balance + bal_dp;
                                                }
                                                rowxSec.add("" + repLevDepartment.getAlQtyBeforeStartPeriod());
                                                rowxSec.add("" + repLevDepartment.getAlTknBeforeStartPeriod());
                                                rowxSec.add("" + repLevDepartment.getAlQtyCurrentPeriod());
                                                rowxSec.add("" + repLevDepartment.getAlTknCurrentPeriod());
                                                rowxSec.add("" + repLevDepartment.getAlToBeTaken());

                                                bal_al = repLevDepartment.getAlQtyBeforeStartPeriod()
                                                        - repLevDepartment.getAlTknBeforeStartPeriod()
                                                        + repLevDepartment.getAlQtyCurrentPeriod()
                                                        - repLevDepartment.getAlTknCurrentPeriod() - repLevDepartment.getAlToBeTaken();
                                                rowxSec.add("" + bal_al);

                                                alQtyBeforeStartPeriod = alQtyBeforeStartPeriod + repLevDepartment.getAlQtyBeforeStartPeriod();
                                                alTknBeforeStartPeriod = alTknBeforeStartPeriod + repLevDepartment.getAlTknBeforeStartPeriod();
                                                alQtyCurrentPeriod = alQtyCurrentPeriod + repLevDepartment.getAlQtyCurrentPeriod();
                                                alTknCurrentPeriod = alTknCurrentPeriod + repLevDepartment.getAlTknCurrentPeriod();
                                                alToBeTaken = alToBeTaken + repLevDepartment.getAlToBeTaken();
                //UPDATE by devin 2104-04-03

                                                al_balance = al_balance + bal_al;

                                                rowxSec.add("" + repLevDepartment.getLLQtyBeforeStartPeriod());
                                                rowxSec.add("" + repLevDepartment.getLLTknBeforeStartPeriod());
                                                rowxSec.add("" + repLevDepartment.getLLTknExpBeforeStartPeriod());
                                                rowxSec.add("" + repLevDepartment.getLLQtyCurrentPeriod());
                                                rowxSec.add("" + repLevDepartment.getLLTknCurrentPeriod());
                                                rowxSec.add("" + repLevDepartment.getLLTknExpiredCurrentPeriod());

                                                bal_ll = repLevDepartment.getLLQtyBeforeStartPeriod()
                                                        - repLevDepartment.getLLTknBeforeStartPeriod()
                                                        - repLevDepartment.getLLTknExpBeforeStartPeriod()
                                                        + repLevDepartment.getLLQtyCurrentPeriod()
                                                        - repLevDepartment.getLLTknCurrentPeriod()
                                                        - repLevDepartment.getLLTknExpiredCurrentPeriod();
                                                rowxSec.add("" + bal_ll);

                                                llQtyBeforeStartPeriod = llQtyBeforeStartPeriod + repLevDepartment.getLLQtyBeforeStartPeriod();
                                                llTknBeforeStartPeriod = llTknBeforeStartPeriod + repLevDepartment.getLLTknBeforeStartPeriod();
                                                llTknExpBeforeStartPeriod = llTknExpBeforeStartPeriod + repLevDepartment.getLLTknExpBeforeStartPeriod();
                                                llQtyCurrentPeriod = llQtyCurrentPeriod + repLevDepartment.getLLQtyCurrentPeriod();
                                                llTknCurrentPeriod = llTknCurrentPeriod + repLevDepartment.getLLTknCurrentPeriod();
                                                llTknExpiredCurrentPeriod = llTknExpiredCurrentPeriod + repLevDepartment.getLLTknExpiredCurrentPeriod();

                                                ll_balance = ll_balance + bal_ll;

                                                lstData.add(rowxSec);
                                                lstLinkData.add("0");
                                            }
                                        }
                                    }
                                }

                            }
                            no++;
                        }

                    }

                }
            }
            /*for(int idx = 0 ; idx< objectClass.size() ; idx++)
             {
            
             float bal_dp = 0;
             float bal_al = 0;
             float bal_ll = 0;
             Vector rowx = new Vector();
                
             RepLevDepartment repLevDepartment = new RepLevDepartment();
                
             repLevDepartment = (RepLevDepartment)objectClass.get(idx);
                
             Department department = new Department();
                
             String nameDepartment = "";
                
             if(dep_id != repLevDepartment.getDepartmentId()){
                    
             try{
                        
             department = PstDepartment.fetchExc(repLevDepartment.getDepartmentId());
             nameDepartment = department.getDepartment();
                        
             }catch(Exception e){
             System.out.println("[exception] "+e.toString());
             }
             dep_id = repLevDepartment.getDepartmentId();
             }
                
             rowx.add(""+no);
                
             rowx.add(""+nameDepartment);
             rowx.add(""+repLevDepartment.getEmp_num());
             rowx.add(""+repLevDepartment.getFull_name());
                
             sumEmp = sumEmp + repLevDepartment.getCountEmployee();
                
             rowx.add(""+repLevDepartment.getDpQtyBeforeStartPeriod());
             rowx.add(""+repLevDepartment.getDpTknBeforeStartPeriod());
             rowx.add(""+repLevDepartment.getDpTknExpBeforeStartPeriod());
             rowx.add(""+repLevDepartment.getDpQtyCurrentPeriod());
             rowx.add(""+repLevDepartment.getDpTknCurrentPeriod());
             rowx.add(""+repLevDepartment.getDpTknExpiredCurrentPeriod());
                
             dpQtyBeforeStartPeriod = dpQtyBeforeStartPeriod + repLevDepartment.getDpQtyBeforeStartPeriod();
             dpTknBeforeStartPeriod = dpTknBeforeStartPeriod + repLevDepartment.getDpTknBeforeStartPeriod();
             dpTknExpBeforeStartPeriod = dpTknExpBeforeStartPeriod + repLevDepartment.getDpTknExpBeforeStartPeriod();
             dpQtyCurrentPeriod = dpQtyCurrentPeriod + repLevDepartment.getDpQtyCurrentPeriod();
             dpTknCurrentPeriod = dpTknCurrentPeriod + repLevDepartment.getDpTknCurrentPeriod();
             dpTknExpiredCurrentPeriod = dpTknExpiredCurrentPeriod + repLevDepartment.getDpTknExpiredCurrentPeriod();
                                        
             bal_dp =  repLevDepartment.getDpQtyBeforeStartPeriod() - 
             repLevDepartment.getDpTknBeforeStartPeriod() -
             repLevDepartment.getDpTknExpBeforeStartPeriod() +
             repLevDepartment.getDpQtyCurrentPeriod() - 
             repLevDepartment.getDpTknCurrentPeriod() - 
             repLevDepartment.getDpTknExpiredCurrentPeriod();
                
             rowx.add(""+bal_dp);
             db_balance = db_balance + bal_dp;                
                
             rowx.add(""+repLevDepartment.getAlQtyBeforeStartPeriod());
             rowx.add(""+repLevDepartment.getAlTknBeforeStartPeriod());
             rowx.add(""+repLevDepartment.getAlQtyCurrentPeriod());
             rowx.add(""+repLevDepartment.getAlTknCurrentPeriod());
             rowx.add(""+repLevDepartment.getAlToBeTaken()); 
                
             bal_al = repLevDepartment.getAlQtyBeforeStartPeriod() -
             repLevDepartment.getAlTknBeforeStartPeriod() +
             repLevDepartment.getAlQtyCurrentPeriod() - 
             repLevDepartment.getAlTknCurrentPeriod()-repLevDepartment.getAlToBeTaken();
             rowx.add(""+bal_al);
                
             alQtyBeforeStartPeriod = alQtyBeforeStartPeriod + repLevDepartment.getAlQtyBeforeStartPeriod();
             alTknBeforeStartPeriod = alTknBeforeStartPeriod + repLevDepartment.getAlTknBeforeStartPeriod();
             alQtyCurrentPeriod = alQtyCurrentPeriod + repLevDepartment.getAlQtyCurrentPeriod();
             alTknCurrentPeriod = alTknCurrentPeriod + repLevDepartment.getAlTknCurrentPeriod();
             alToBeTaken = alToBeTaken + repLevDepartment.getAlToBeTaken();
             //UPDATE by devin 2104-04-03
              
             al_balance = al_balance + bal_al;                
                
             rowx.add(""+repLevDepartment.getLLQtyBeforeStartPeriod());
             rowx.add(""+repLevDepartment.getLLTknBeforeStartPeriod());
             rowx.add(""+repLevDepartment.getLLTknExpBeforeStartPeriod());
             rowx.add(""+repLevDepartment.getLLQtyCurrentPeriod());
             rowx.add(""+repLevDepartment.getLLTknCurrentPeriod());
             rowx.add(""+repLevDepartment.getLLTknExpiredCurrentPeriod());
                
             bal_ll =  repLevDepartment.getLLQtyBeforeStartPeriod() - 
             repLevDepartment.getLLTknBeforeStartPeriod() -
             repLevDepartment.getLLTknExpBeforeStartPeriod() +
             repLevDepartment.getLLQtyCurrentPeriod() - 
             repLevDepartment.getLLTknCurrentPeriod() - 
             repLevDepartment.getLLTknExpiredCurrentPeriod();
             rowx.add(""+bal_ll);
                
             llQtyBeforeStartPeriod = llQtyBeforeStartPeriod + repLevDepartment.getLLQtyBeforeStartPeriod();
             llTknBeforeStartPeriod = llTknBeforeStartPeriod + repLevDepartment.getLLTknBeforeStartPeriod();
             llTknExpBeforeStartPeriod = llTknExpBeforeStartPeriod + repLevDepartment.getLLTknExpBeforeStartPeriod();
             llQtyCurrentPeriod = llQtyCurrentPeriod + repLevDepartment.getLLQtyCurrentPeriod();
             llTknCurrentPeriod = llTknCurrentPeriod + repLevDepartment.getLLTknCurrentPeriod();
             llTknExpiredCurrentPeriod = llTknExpiredCurrentPeriod + repLevDepartment.getLLTknExpiredCurrentPeriod();
                
             ll_balance = ll_balance + bal_ll;
                
             no++;
             lstData.add(rowx);
             lstLinkData.add("0");         
             }*/

            Vector rowx = new Vector(1, 1);
            rowx.add("");
            rowx.add("TOTAL");
            rowx.add("");
            rowx.add("");

            if (useDP == 1) {
                rowx.add("" + dpQtyBeforeStartPeriod);
                rowx.add("" + dpTknBeforeStartPeriod);
                rowx.add("" + dpTknExpBeforeStartPeriod);
                rowx.add("" + dpQtyCurrentPeriod);
                rowx.add("" + dpTknCurrentPeriod);
                rowx.add("" + dpTknExpiredCurrentPeriod);
                rowx.add("" + db_balance);
            }
            rowx.add("" + alQtyBeforeStartPeriod);
            rowx.add("" + alTknBeforeStartPeriod);
            rowx.add("" + alQtyCurrentPeriod);
            rowx.add("" + alTknCurrentPeriod);
            //UPDATE by devin 2104-04-03
            rowx.add("" + alToBeTaken);
            rowx.add("" + al_balance);

            rowx.add("" + llQtyBeforeStartPeriod);
            rowx.add("" + llTknBeforeStartPeriod);
            rowx.add("" + llTknExpBeforeStartPeriod);
            rowx.add("" + llQtyCurrentPeriod);
            rowx.add("" + llTknCurrentPeriod);
            rowx.add("" + llTknExpiredCurrentPeriod);
            rowx.add("" + ll_balance);

            lstData.add(rowx);
            lstLinkData.add("0");

            result = ctrlist.drawList();

        } else {

            result += "<div class=\"msginfo\">&nbsp;&nbsp;Detail Leave Stock Data Found found ...</div>";

        }

        return result;

    }
%>

<%    long hrdDepartmentOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = hrdDepartmentOid == departmentOid ? true : false;
    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;
    int iCommand = FRMQueryString.requestCommand(request);
    long oidSection = FRMQueryString.requestLong(request, FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_SECTION]);
    long oidDepartment = FRMQueryString.requestLong(request, FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_DEPARTMENT]);
    long oidCompany = FRMQueryString.requestLong(request, FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_COMPANY]);
    long oidDivision = FRMQueryString.requestLong(request, FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_DIVISION]);
    String fullName = FRMQueryString.requestString(request, FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_FULL_NAME]);
    String empNum = FRMQueryString.requestString(request, FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_EMP_NUMBER]);
    SrcLeaveManagement objsrcLeaveManagement = new SrcLeaveManagement();
    FrmSrcLeaveManagement frmSrcLeaveManagement = new FrmSrcLeaveManagement();
//Vector listSp = new Vector(1,1);
    int listSp = 0;
    frmSrcLeaveManagement = new FrmSrcLeaveManagement(request, objsrcLeaveManagement);

    if (iCommand == Command.GOTO) {

        frmSrcLeaveManagement.requestEntityObject(objsrcLeaveManagement);
    }

//if(iCommand != Command.NONE)
    if (iCommand == Command.VIEW) {
        frmSrcLeaveManagement.requestEntityObject(objsrcLeaveManagement);
        //Vector vsection=new Vector();
        //int section=1;

        // listSp = SessLeaveApplication.leave_Detail(srcLeaveManagement,vsection,section);
        listSp = 1;

        try {
            session.removeValue("DETAIL_LEAVE_DP_PERIOD_REPORT");
        } catch (Exception e) {
            System.out.println("Exc when remove from session(\"DETAIL_LEAVE_DP_PERIOD_REPORT\") : " + e.toString());
        }

        try {
            session.putValue("DETAIL_LEAVE_DP_PERIOD_REPORT", objsrcLeaveManagement);

        } catch (Exception e) {
            System.out.println("Exc when put to session(\"DETAIL_LEAVE_DP_PERIOD_REPORT\") : " + e.toString());
        }
    }
%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" --> 
        <title>HARISMA - Report Leave & Dp Detail Period</title>
        <script language="JavaScript">
<!--

            function cmdUpdateDep() {
                getStartDate();
                getEndDate();
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.command.value = "<%=String.valueOf(Command.GOTO)%>";
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.action = "leave_dp_detail_period.jsp";
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.submit();
            }

            function cmdPrintXLS() {
                pathUrl = "<%=approot%>/servlet/com.dimata.harisma.report.leave.LeaveDetailReportXls";
                window.open(pathUrl);
            }

            function cmdViewReport() {
                getStartDate();
                getEndDate();
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.command.value = "<%=String.valueOf(Command.VIEW)%>";
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.action = "leave_dp_detail_period.jsp";
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.submit();
            }
            function cmdUpdateDiv() {
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.command.value = "<%=String.valueOf(Command.GOTO)%>";
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.action = "leave_dp_detail_period.jsp";
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.submit();
            }
            function cmdUpdateDep() {
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.command.value = "<%=String.valueOf(Command.GOTO)%>";
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.action = "leave_dp_detail_period.jsp";
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.submit();
            }
            function cmdUpdatePos() {
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.command.value = "<%=String.valueOf(Command.GOTO)%>";
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.action = "leave_dp_detail_period.jsp";
                document.<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>.submit();
            }

            function getThn() {
            }

            function hideObjectForDate(index) {
            }

            function showObjectForDate() {
            }

            function getStartDate() {
            <%=ControlDatePopup.writeDateCaller(FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT, FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_START_DATE])%>
            }

            function getEndDate() {
            <%=ControlDatePopup.writeDateCaller(FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT, FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_END_DATE])%>
            }

            function fnTrapKD() {
                if (event.keyCode == 13) {
                    document.all.aSearch.focus();
                    cmdSearch();
                }
            }

            function MM_swapImgRestore() { //v3.0
                var i, x, a = document.MM_sr;
                for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++)
                    x.src = x.oSrc;
            }

            function MM_preloadImages() { //v3.0
                var d = document;
                if (d.images) {
                    if (!d.MM_p)
                        d.MM_p = new Array();
                    var i, j = d.MM_p.length, a = MM_preloadImages.arguments;
                    for (i = 0; i < a.length; i++)
                        if (a[i].indexOf("#") != 0) {
                            d.MM_p[j] = new Image;
                            d.MM_p[j++].src = a[i];
                        }
                }
            }

            function MM_findObj(n, d) { //v4.0
                var p, i, x;
                if (!d)
                    d = document;
                if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
                    d = parent.frames[n.substring(p + 1)].document;
                    n = n.substring(0, p);
                }
                if (!(x = d[n]) && d.all)
                    x = d.all[n];
                for (i = 0; !x && i < d.forms.length; i++)
                    x = d.forms[i][n];
                for (i = 0; !x && d.layers && i < d.layers.length; i++)
                    x = MM_findObj(n, d.layers[i].document);
                if (!x && document.getElementById)
                    x = document.getElementById(n);
                return x;
            }

            function MM_swapImage() { //v3.0
                var i, j = 0, x, a = MM_swapImage.arguments;
                document.MM_sr = new Array;
                for (i = 0; i < (a.length - 2); i += 3)
                    if ((x = MM_findObj(a[i])) != null) {
                        document.MM_sr[j++] = x;
                        if (!x.oSrc)
                            x.oSrc = x.src;
                        x.src = a[i + 2];
                    }
            }
            //-->
        </script>
        <!-- #EndEditable --> 
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> 
        <!-- #BeginEditable "styles" --> 
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "stylestab" --> 
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #EndEditable -->
        <link rel="stylesheet" href="<%=approot%>/styles/calendar.css" type="text/css">
        <!-- #BeginEditable "stylestab" -->  
    </head> 

    <body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnSearchOn.jpg', '<%=approot%>/images/BtnNewOn.jpg')">

        <!-- Untuk Calendar-->
        <%=ControlDatePopup.writeTable(approot)%>
        <!-- End Calendar-->


        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr> 
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../../main/mnmain.jsp" %>
                    <!-- #EndEditable --> </td> 
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="10" valign="middle"> 

                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td align="left"><img src="<%=approot%>/images/harismaMenuLeft1.jpg" width="8" height="8"></td>
                            <td align="center" background="<%=approot%>/images/harismaMenuLine1.jpg" width="100%"><img src="<%=approot%>/images/harismaMenuLine1.jpg" width="8" height="8"></td>
                            <td align="right"><img src="<%=approot%>/images/harismaMenuRight1.jpg" width="8" height="8"></td>
                        </tr>
                    </table>
                </td> 
            </tr>
            <%}%>
            <tr> 
                <td width="88%" valign="top" align="left"> 
                    <table width="100%" border="0" cellspacing="3" cellpadding="2"> 
                        <tr> 
                            <td width="100%">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
                                    <tr> 
                                        <td height="20"> <font color="#FF6600" face="Arial"><strong> <!-- #BeginEditable "contenttitle" --> 
                                                Employee &gt; Leave &gt; Leave Report Specian & Unpaid Leave<!-- #EndEditable --> 
                                            </strong></font> </td>
                                    </tr>
                                    <tr> 
                                        <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td  style="background-color:<%=bgColorContent%>; "> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" >
                                                            <tr> 
                                                                <td valign="top"> 
                                                                    <table style="border:1px solid <%=garisContent%>" width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                                                                        <tr> 
                                                                            <td valign="top">
                                                                                <!-- #BeginEditable "content" --> 
                                                                                <form name="<%=FrmSrcLeaveManagement.FRM_NAME_SRCDAYOFPAYMENT%>" method="post" action="">
                                                                                    <!--<input type="hidden" name="command" value="">-->
                                                                                    <input type="hidden" name="command" value="<%=String.valueOf(iCommand)%>">                                          
                                                                                    <table border="0" cellspacing="2" cellpadding="2" width="100%" > 
                                                                                        <tr> 
                                                                                            <td width="13%">&nbsp;</td>
                                                                                            <td nowrap width="2%">&nbsp;</td>
                                                                                            <td nowrap width="85%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <!-- update by satrya 2012-07-16 -->
                                                                                        <tr> 
                                                                                            <td width="6%" nowrap="nowrap"> <div align="left">Payrol Num </div></td>
                                                                                            <td width="30%" nowrap="nowrap">:
                                                                                                <input type="text" size="40" name="<%=FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_EMP_NUMBER]%>"  value="<%= objsrcLeaveManagement.getEmpNum()%>"  title="You can Input Payroll Number more than one, ex-sample : 1111,2222" class="elemenForm" onKeyDown="javascript:fnTrapKD()"> </td>

                                                                                            <td width="5%" nowrap="nowrap"> Full Name :

                                                                                                <input type="text" size="50" name="<%=FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_FULL_NAME]%>"  value="<%= objsrcLeaveManagement.getEmpName()%>"  title="You can Input Full Name more than one, ex-sample : saya,kamu" class="elemenForm" onKeyDown="javascript:fnTrapKD()">
                                                                                            </td>

                                                                                        </tr>
                                                                                        <tr>                                           
                                                                                            <td width="6%" nowrap="nowrap"> <div align="left">Company </div></td>
                                                                                            <td width="30%" nowrap="nowrap">:

                                                                                                <% /* update by satrya 2014-01-20 Vector comp_value = new Vector(1, 1);
                                                                                                     Vector comp_key = new Vector(1, 1);
                                                                                                     String whereCompany="";
                                                                                                     if (!(isHRDLogin || isEdpLogin || isGeneralManager || isDirector)){
                                                                                                     whereCompany = PstCompany.fieldNames[PstCompany.FLD_COMPANY_ID]+"='"+ emplx.getCompanyId()+"'";
                                                                                                     } else{
                                                                                                     comp_value.add("0");
                                                                                                     comp_key.add("select ...");                                            
                                                                                                     }
                                                                                                     Vector listComp = PstCompany.list(0, 0, whereCompany, " COMPANY ");
                                                                                                     for (int i = 0; i < listComp.size(); i++) {
                                                                                                     Company comp = (Company) listComp.get(i);
                                                                                                     comp_key.add(comp.getCompany());
                                                                                                     comp_value.add(String.valueOf(comp.getOID()));
                                                                                                     }
                                                                                                     //update by satrya 2013-08-13
                                                                                                     //jika user memilih select kembali
                                                                                                     if(oidCompany==0){
                                                                                                     oidDivision =0;oidDepartment=0;oidSection=0; 
                                                                                                     }*/
                                                                                                %> <%/*= update by satrya 2014-01-20 ControlCombo.draw("company_id", "formElemen", null, "" + oidCompany, comp_value, comp_key, "onChange=\"javascript:cmdUpdateDiv()\"")*/%>  
                                                                                                <%

                                                                                                    Vector comp_value = new Vector(1, 1);
                                                                                                    Vector comp_key = new Vector(1, 1);
                                                                                                    String whereComp = "";
                                                                                                    /*if(srcOvertime!=null && srcOvertime.getCompanyId()!=0){
                                                                                                     whereComp = PstCompany.fieldNames[PstCompany.FLD_COMPANY_ID] +"="+srcOvertime.getCompanyId();
                                                                                                     }*/
                                                                                                    Vector div_value = new Vector(1, 1);
                                                                                                    Vector div_key = new Vector(1, 1);

                                                                                                    Vector dept_value = new Vector(1, 1);
                                                                                                    Vector dept_key = new Vector(1, 1);
                                                                                                    if (processDependOnUserDept) {
                                                                                                        if (emplx.getOID() > 0) {
                                                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager || isDirector) {
                                                                                                                //keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, "", true);
                                                                                                                comp_value.add("0");
                                                                                                                comp_key.add("select ...");

                                                                                                                div_value.add("0");
                                                                                                                div_key.add("select ...");

                                                                                                                dept_value.add("0");
                                                                                                                dept_key.add("select ...");
                                                                                                            } else {
                                                                                                                Position position = null;
                                                                                                                try {
                                                                                                                    position = PstPosition.fetchExc(emplx.getPositionId());
                                                                                                                } catch (Exception exc) {
                                                                                                                }
                                                                                                                if (position != null & position.getDisabedAppDivisionScope() == 0 & position.getPositionLevel() >= PstPosition.LEVEL_MANAGER) {
                                                                                                                    String whereDiv = " d." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + "=" + emplx.getDivisionId() + "";
                                                                                                                    //keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, whereDiv, true);
                                                                                                                    // comp_value.add("0");
                                                                                                                    // comp_key.add("select ...");

                                                                                                                       //div_value.add("0");
                                                                                                                    //div_key.add("select ...");
                                                                                                                    dept_value.add("0");
                                                                                                                    dept_key.add("select ...");

                                                                                                                    whereComp = whereComp != null && whereComp.length() > 0 ? whereComp + " AND (" + whereDiv + ")" : whereDiv;

                                                                                                                } else {

                                                                                                                    String whereClsDep = "(" + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID] + " = " + departmentOid
                                                                                                                            + ") OR (" + PstDepartment.fieldNames[PstDepartment.FLD_JOIN_TO_DEPARTMENT_ID] + " = " + departmentOid + ") ";
                                                                                                                    try {
                                                                                                                        String joinDept = PstSystemProperty.getValueByName("JOIN_DEPARMENT");
                                                                                                                        Vector depGroup = com.dimata.util.StringParser.parseGroup(joinDept);

                                                                                                                        int grpIdx = -1;
                                                                                                                        int maxGrp = depGroup == null ? 0 : depGroup.size();
                                                                                                                        int countIdx = 0;
                                                                                                                        int MAX_LOOP = 10;
                                                                                                                        int curr_loop = 0;
                                                                                                                        do { // find group department belonging to curretn user base in departmentOid
                                                                                                                            curr_loop++;
                                                                                                                            String[] grp = (String[]) depGroup.get(countIdx);
                                                                                                                            for (int g = 0; g < grp.length; g++) {
                                                                                                                                String comp = grp[g];
                                                                                                                                if (comp.trim().compareToIgnoreCase("" + departmentOid) == 0) {
                                                                                                                                    grpIdx = countIdx;   // A ha .. found here 
                                                                                                                                }
                                                                                                                            }
                                                                                                                            countIdx++;
                                                                                                                        } while ((grpIdx < 0) && (countIdx < maxGrp) && (curr_loop < MAX_LOOP)); // if found then exit

                                                                                                                        // compose where clause
                                                                                                                        if (grpIdx >= 0) {
                                                                                                                            String[] grp = (String[]) depGroup.get(grpIdx);
                                                                                                                            for (int g = 0; g < grp.length; g++) {
                                                                                                                                String comp = grp[g];
                                                                                                                                whereClsDep = whereClsDep + " OR (DEPARTMENT_ID = " + comp + ")";
                                                                                                                            }
                                                                                                                        }
                                                                                                                    } catch (Exception exc) {
                                                                                                                        System.out.println(" Parsing Join Dept" + exc);

                                                                                                                    }
                                                                                                                    //keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, whereClsDep, false);

                                                                                                                    whereComp = whereComp != null && whereComp.length() > 0 ? whereComp + " AND (" + whereClsDep + ")" : whereClsDep;

                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    } else {
                                                                                                        comp_value.add("0");
                                                                                                        comp_key.add("select ...");

                                                                                                        div_value.add("0");
                                                                                                        div_key.add("select ...");

                                                                                                        dept_value.add("0");
                                                                                                        dept_key.add("select ...");
                                                                                                    }
                                                                                                    Vector listCostDept = PstDepartment.listWithCompanyDiv(0, 0, whereComp);
                                                                                                    String prevCompany = "";
                                                                                                    String prevDivision = "";

                                                                                                    long prevCompanyTmp = 0;
                                                                                                    for (int i = 0; i < listCostDept.size(); i++) {
                                                                                                        Department dept = (Department) listCostDept.get(i);
                                                                                                        if (prevCompany.equals(dept.getCompany())) {
                                                                                                            if (prevDivision.equals(dept.getDivision())) {
                                                                                                                //if(srcOvertime!=null && srcOvertime.getCompanyId()!=0){
                                                                                                                dept_key.add(dept.getDepartment());
                                                                                                                dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                //}
                                                                                                            } else {
                                                                                                                div_key.add(dept.getDivision());
                                                                                                                div_value.add("" + dept.getDivisionId());
                                                                                                                if (dept_key != null && dept_key.size() == 0) {
                                                                                                                    dept_key.add(dept.getDepartment());
                                                                                                                    dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                }
                                                                                                                prevDivision = dept.getDivision();
                                                                                                            }
                                                                                                        } else {
                                                                                                            String chkAdaDiv = "";
                                                                                                            if (div_key != null && div_key.size() > 0) {
                                                                                                                chkAdaDiv = (String) div_key.get(0);
                                                                                                            }
                                                                                                            if ((div_key != null && div_key.size() == 0) || (chkAdaDiv.equalsIgnoreCase("select ..."))) {
                                                                                                                if (prevCompanyTmp != dept.getCompanyId()) {
                                                                                                                    comp_key.add(dept.getCompany());
                                                                                                                    comp_value.add("" + dept.getCompanyId());
                                                                                                                    prevCompanyTmp = dept.getCompanyId();
                                                                                                                }
                                                                                                             //untuk karyawan admin yg hanya bisa akses departement tertentu (ketika di awal)
                                                                                                                ////update
                                                                                                                if (processDependOnUserDept) {
                                                                                                                    if (emplx.getOID() > 0) {
                                                                                                                        if (isHRDLogin || isEdpLogin || isGeneralManager || isDirector) {
                                                                                                                            if (oidCompany != 0) {
                                                                                                                                div_key.add(dept.getDivision());
                                                                                                                                div_value.add("" + dept.getDivisionId());

                                                                                                                                dept_key.add(dept.getDepartment());
                                                                                                                                dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                                prevCompany = dept.getCompany();
                                                                                                                                prevDivision = dept.getDivision();
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            Position position = null;
                                                                                                                            try {
                                                                                                                                position = PstPosition.fetchExc(emplx.getPositionId());
                                                                                                                            } catch (Exception exc) {
                                                                                                                            }
                                                                                                                            if (position != null & position.getDisabedAppDivisionScope() == 0 & position.getPositionLevel() >= PstPosition.LEVEL_MANAGER) {
                                                                                                                                if (oidCompany != 0) {
                                                                                                                                    div_key.add(dept.getDivision());
                                                                                                                                    div_value.add("" + dept.getDivisionId());

                                                                                                                                    dept_key.add(dept.getDepartment());
                                                                                                                                    dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                                    prevCompany = dept.getCompany();
                                                                                                                                    prevDivision = dept.getDivision();
                                                                                                                                } //update by satrya 2013-09-19
                                                                                                                                else if ((div_key != null && div_key.size() == 0) || (chkAdaDiv.equalsIgnoreCase("select ..."))) {
                                                                                                                                    div_key.add(dept.getDivision());
                                                                                                                                    div_value.add("" + dept.getDivisionId());

                                                                                                                                    //update by satrya 2013-09-19
                                                                                                                                    dept_key.add(dept.getDepartment());
                                                                                                                                    dept_value.add(String.valueOf(dept.getOID()));

                                                                                                                                    prevCompany = dept.getCompany();
                                                                                                                                    prevDivision = dept.getDivision();
                                                                                                                                }

                                                                                                                            } else {

                                                                                                                                div_key.add(dept.getDivision());
                                                                                                                                div_value.add("" + dept.getDivisionId());

                                                                                                                                dept_key.add(dept.getDepartment());
                                                                                                                                dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                                prevCompany = dept.getCompany();
                                                                                                                                prevDivision = dept.getDivision();
                                                                                                                            }
                                                                                                                        }
                                                                                                                    }
                                                                                                                } else {
                                                                                                                    if (oidCompany != 0) {
                                                                                                                        div_key.add(dept.getDivision());
                                                                                                                        div_value.add("" + dept.getDivisionId());

                                                                                                                        dept_key.add(dept.getDepartment());
                                                                                                                        dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                        prevCompany = dept.getCompany();
                                                                                                                        prevDivision = dept.getDivision();
                                                                                                                    }
                                                                                                                }

                                                                                                            } else {
                                                                                                                if (prevCompanyTmp != dept.getCompanyId()) {
                                                                                                                    comp_key.add(dept.getCompany());
                                                                                                                    comp_value.add("" + dept.getCompanyId());
                                                                                                                    prevCompanyTmp = dept.getCompanyId();
                                                                                                                }

                                                                                                            }

                                                                                                        }
                                                                                                    }
                                                                                                %>
                                                                                                <%= ControlCombo.draw(FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_COMPANY], "formElemen", null, "" + oidCompany, comp_value, comp_key, "onChange=\"javascript:cmdUpdateDiv()\"")%>
                                                                                            </td>

                                                                                            <td width="5%" nowrap="nowrap"> Division  &nbsp;&nbsp;&nbsp;&nbsp;:
                                                                                                <%/*  // update by satrya 2014-01-20 
                                                                                                     Vector div_value = new Vector(1, 1);
                                                                                                     Vector div_key = new Vector(1, 1);
                                                                                                     String whereDivision ="";
                                                                                                     if (!(isHRDLogin || isEdpLogin || isGeneralManager || isDirector)){
                                                                                                     whereDivision = PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]+"='"+ emplx.getDivisionId()+"'";
                                                                                                     oidDivision = emplx.getDivisionId();
                                                                                                     } else{
                                                                                                     div_value.add("0");
                                                                                                     div_key.add("select ...");                                            
                                                                                                     }
                                                                                                     Vector listDiv = PstDivision.list(0, 0, whereDivision, " DIVISION ");
                                                                                                     for (int i = 0; i < listDiv.size(); i++) {
                                                                                                     Division div = (Division) listDiv.get(i);
                                                                                                     div_key.add(div.getDivision());
                                                                                                     div_value.add(String.valueOf(div.getOID()));
                                                                                                     }
                                                                                                     //update by satrya 2013-08-13
                                                                                                     //jika user memilih select kembali
                                                                                                     if(oidDivision==0){
                                                                                                     oidDepartment=0;
                                                                                                     }*/
                                                                                                %> <%/*= update by satrya 2014-01-20 ControlCombo.draw("division_id", "formElemen", null, "" + oidDivision, div_value, div_key, "onChange=\"javascript:cmdUpdateDep()\"")*/%>
                                                                                                <%

                                           //update by satrya 2013-08-13
                                                                                                    //jika user memilih select kembali
                                                                                                    if (oidCompany == 0) {
                                                                                                        oidDivision = 0;
                                                                                                    }

                                                                                                    if (oidCompany != 0) {
                                                                                                        whereComp = "(" + (whereComp != null && whereComp.length() == 0 ? "1=1" : whereComp) + ") AND " + PstCompany.fieldNames[PstCompany.FLD_COMPANY_ID] + "=" + oidCompany + " AND d." + PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] + " = 1";
                                                                                                        listCostDept = PstDepartment.listWithCompanyDiv(0, 0, whereComp);
                                                                                                        prevCompany = "";
                                                                                                        prevDivision = "";

                                                                                                        div_value = new Vector(1, 1);
                                                                                                        div_key = new Vector(1, 1);

                                                                                                        dept_value = new Vector(1, 1);
                                                                                                        dept_key = new Vector(1, 1);

                                                                                                        prevCompanyTmp = 0;
                                                                                                        long tmpFirstDiv = 0;

                                                                                                        if (processDependOnUserDept) {
                                                                                                            if (emplx.getOID() > 0) {
                                                                                                                if (isHRDLogin || isEdpLogin || isGeneralManager || isDirector) {
                                                                                                                    //keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, "", true);
                                                                                                                    comp_value.add("0");
                                                                                                                    comp_key.add("select ...");

                                                                                                                    div_value.add("0");
                                                                                                                    div_key.add("select ...");

                                                                                                                    dept_value.add("0");
                                                                                                                    dept_key.add("select ...");
                                                                                                                } else {
                                                                                                                    Position position = null;
                                                                                                                    try {
                                                                                                                        position = PstPosition.fetchExc(emplx.getPositionId());
                                                                                                                    } catch (Exception exc) {
                                                                                                                    }
                                                                                                                    if (position != null & position.getDisabedAppDivisionScope() == 0 & position.getPositionLevel() >= PstPosition.LEVEL_MANAGER) {
                               //div_value.add("0");
                                                                                                                        //div_key.add("select ...");

                                                                                                                        dept_value.add("0");
                                                                                                                        dept_key.add("select ...");

                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        } else {
                                                                                                            comp_value.add("0");
                                                                                                            comp_key.add("select ...");

                                                                                                            div_value.add("0");
                                                                                                            div_key.add("select ...");

                                                                                                            dept_value.add("0");
                                                                                                            dept_key.add("select ...");
                                                                                                        }
                                                                                                        long prevDivTmp = 0;
                                                                                                        for (int i = 0; i < listCostDept.size(); i++) {
                                                                                                            Department dept = (Department) listCostDept.get(i);
                                                                                                            if (prevCompany.equals(dept.getCompany())) {
                                                                                                                if (prevDivision.equals(dept.getDivision())) {
                                                                                                                    //update
                                                                                                                    if (oidDivision != 0) {
                                                                                                                        dept_key.add(dept.getDepartment());
                                                                                                                        dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                    }
                        //lama
                        /*
                                                                                                                     dept_key.add(dept.getDepartment());
                                                                                                                     dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                     */

                                                                                                                } else {
                                                                                                                    div_key.add(dept.getDivision());
                                                                                                                    div_value.add("" + dept.getDivisionId());
                                                                                                                    if (dept_key != null && dept_key.size() == 0) {
                                                                                                                        dept_key.add(dept.getDepartment());
                                                                                                                        dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                    }
                                                                                                                    prevDivision = dept.getDivision();
                                                                                                                }
                                                                                                            } else {
                                                                                                                String chkAdaDiv = "";
                                                                                                                if (div_key != null && div_key.size() > 0) {
                                                                                                                    chkAdaDiv = (String) div_key.get(0);
                                                                                                                }
                                                                                                                if ((div_key != null && div_key.size() == 0) || (chkAdaDiv.equalsIgnoreCase("select ..."))) {
                     //comp_key.add(dept.getCompany());
                                                                                                                    //comp_value.add(""+dept.getCompanyId());

                                                                                                                    if (prevDivTmp != dept.getDivisionId()) {
                                                                                                                        div_key.add(dept.getDivision());
                                                                                                                        div_value.add("" + dept.getDivisionId());
                                                                                                                        prevDivTmp = dept.getDivisionId();
                                                                                                                    }

                                                                                                                    tmpFirstDiv = dept.getDivisionId();

                           // dept_key.add(dept.getDepartment());
                                                                                                                    //   dept_value.add(String.valueOf(dept.getOID()));           
                                                                                                                    prevCompany = dept.getCompany();
                                                                                                                    prevDivision = dept.getDivision();
                                                                                                                }
                                                                                                                /*else{
                                                                                                                 if(prevCompanyTmp!=dept.getCompanyId()){
                                                                                                                 comp_key.add(dept.getCompany());
                                                                                                                 comp_value.add(""+dept.getCompanyId());
                                                                                                                 prevCompanyTmp=dept.getCompanyId();
                                                                                                                 }
              
                                                                                                                 }*/
                                                                                                                String chkAdaDpt = "";
                                                                                                                if (whereComp != null && whereComp.length() > 0) {
                                                                                                                    chkAdaDpt = "(" + (whereComp != null && whereComp.length() == 0 ? "1=1" : whereComp) + ") AND d." + PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + "=" + oidDivision;
                                                                                                                }
                                                                                                                Vector listCheckAdaDept = PstDepartment.listWithCompanyDiv(0, 0, chkAdaDpt);
                                                                                                                if ((listCheckAdaDept == null || listCheckAdaDept.size() == 0)) {

                                                                                                                    if (processDependOnUserDept) {
                                                                                                                        if (emplx.getOID() > 0) {
                                                                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager || isDirector) {

                                                                                                                            } else {
                                                                                                                                Position position = null;
                                                                                                                                try {
                                                                                                                                    position = PstPosition.fetchExc(emplx.getPositionId());
                                                                                                                                } catch (Exception exc) {
                                                                                                                                }

                                                                                                                                oidDivision = tmpFirstDiv;

                                                                                                                            }
                                                                                                                        }
                                                                                                                    } else {
                                                                                                                        oidDivision = tmpFirstDiv;

                                                                                                                    }

                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                %>
                                                                                                <%= ControlCombo.draw(FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_DIVISION], "formElemen", null, "" + oidDivision, div_value, div_key, "onChange=\"javascript:cmdUpdateDep()\"")%> 

                                                                                            </td>

                                                                                        </tr>


                                                                                        <tr>                                           
                                                                                            <td width="6%" align="right" nowrap> 
                                                                                                <div align="left"><%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%></div>                                                                                            </td>
                                                                                            <td width="30%" nowrap="nowrap"> : 
                                                                                                <%

                                                                                                    /*  Vector dept_value = new Vector(1, 1);
                                                                                                     Vector dept_key = new Vector(1, 1);
                                                                                                     //Vector listDept = new Vector(1, 1);
                                                                                                     DepartmentIDnNameList keyList = new DepartmentIDnNameList();

                                                                                                     if (processDependOnUserDept) {
                                                                                                     if (emplx.getOID() > 0) {
                                                                                                     if (isHRDLogin || isEdpLogin || isGeneralManager) {
                                                                                                     keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, "", true);
                                                                                                     //listDept = PstDepartment.list(0, 0, "", "DEPARTMENT");
                                                                                                     } else {
                                                                                                     Position position = null;
                                                                                                     try {
                                                                                                     position = PstPosition.fetchExc(emplx.getPositionId());
                                                                                                     } catch (Exception exc) {
                                                                                                     }
                                                                                                     if (position != null & position.getDisabedAppDivisionScope() == 0 & position.getPositionLevel() >= PstPosition.LEVEL_MANAGER) {
                                                                                                     String whereDiv = " d." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + "=" + emplx.getDivisionId() + "";
                                                                                                     keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, whereDiv, true);
                                                                                                     } else {

                                                                                                     String whereClsDep = "(" + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID] + " = " + departmentOid
                                                                                                     + ") OR (" + PstDepartment.fieldNames[PstDepartment.FLD_JOIN_TO_DEPARTMENT_ID] + " = " + departmentOid + ") ";
                                                                                                     try {
                                                                                                     String joinDept = PstSystemProperty.getValueByName("JOIN_DEPARMENT");
                                                                                                     Vector depGroup = com.dimata.util.StringParser.parseGroup(joinDept);

                                                                                                     int grpIdx = -1;
                                                                                                     int maxGrp = depGroup == null ? 0 : depGroup.size();
                                                                                                     int countIdx = 0;
                                                                                                     int MAX_LOOP = 10;
                                                                                                     int curr_loop = 0;
                                                                                                     do { // find group department belonging to curretn user base in departmentOid
                                                                                                     curr_loop++;
                                                                                                     String[] grp = (String[]) depGroup.get(countIdx);
                                                                                                     for (int g = 0; g < grp.length; g++) {
                                                                                                     String comp = grp[g];
                                                                                                     if (comp.trim().compareToIgnoreCase("" + departmentOid) == 0) {
                                                                                                     grpIdx = countIdx;   // A ha .. found here 
                                                                                                     }
                                                                                                     }
                                                                                                     countIdx++;
                                                                                                     } while ((grpIdx < 0) && (countIdx < maxGrp) && (curr_loop < MAX_LOOP)); // if found then exit

                                                                                                     // compose where clause
                                                                                                     if (grpIdx >= 0) {
                                                                                                     String[] grp = (String[]) depGroup.get(grpIdx);
                                                                                                     for (int g = 0; g < grp.length; g++) {
                                                                                                     String comp = grp[g];
                                                                                                     whereClsDep = whereClsDep + " OR (DEPARTMENT_ID = " + comp + ")";
                                                                                                     }
                                                                                                     }
                                                                                                     } catch (Exception exc) {
                                                                                                     System.out.println(" Parsing Join Dept" + exc);
                                                                                                                         
                                                                                                     }
                                                                                                     keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, whereClsDep, false);
                                                                                                     //listDept = PstDepartment.list(0, 0,whereClsDep, "");
                                                                                                     }
                                                                                                     }
                                                                                                     } else {
                                                                                                     //dept_value.add("0");
                                                                                                     //dept_key.add("select ...");
                                                                                                     keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, "", true);
                                                                                                     //listDept = PstDepartment.list(0, 0, "", "DEPARTMENT");
                                                                                                     }
                                                                                                     } else {
                                                                                                     //dept_value.add("0");
                                                                                                     //dept_key.add("select ...");
                                                                                                     keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, "", true);
                                                                                                     //listDept = PstDepartment.list(0, 0, "", "DEPARTMENT");
                                                                                                     }
                                                                                                     dept_value = keyList.getDepIDs();
                                                                                                     dept_key = keyList.getDepNames();

                                                                                                     /*for (int i = 0; i < listDept.size(); i++) {
                                                                                                     Department dept = (Department) listDept.get(i);
                                                                                                     dept_key.add(dept.getDepartment());
                                                                                                     dept_value.add(String.valueOf(dept.getOID()));
                                                                                                     } */
                                                /*   String selectValueDepartment = "" + oidDepartment;//+objSrcLeaveApp.getDepartmentId();

                                                 */%>
                                                                                                <%//=ControlCombo.draw("department", "elementForm", null, selectValueDepartment, dept_value, dept_key, " onkeydown=\"javascript:fnTrapKD()\"")%>

                                                                                                <%/*=ControlCombo.draw("department", "elementForm", null, selectValueDepartment, dept_value, dept_key, " onChange=\"javascript:cmdUpdateDep()\"")*/%>
                                                                                                <%
                                                                                                    dept_value = new Vector(1, 1);
                                                                                                    dept_key = new Vector(1, 1);
                                            //dept_value.add("0");
                                                                                                    //dept_key.add("select ...");
                                                                                                    //String strWhere = PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + "=" + oidDivision;
                                                                                                    Vector listDept = new Vector(); //PstDepartment.list(0, 0, strWhere, PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT]);
                                            /*for (int i = 0; i < listDept.size(); i++) {
                                                                                                     Department dept = (Department) listDept.get(i);
                                                                                                     dept_key.add(dept.getDepartment());
                                                                                                     dept_value.add(String.valueOf(dept.getOID()));
                                                                                                     }*/

                                                                                                    if (processDependOnUserDept) {
                                                                                                        if (emplx.getOID() > 0) {

                                                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager || isDirector) {
                                                                                                                String strWhere = PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + "=" + oidDivision + " AND " + PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] + " = 1";
                                                                                                                dept_value.add("0");
                                                                                                                dept_key.add("select ...");
                                                                                                                listDept = PstDepartment.list(0, 0, strWhere, "DEPARTMENT");

                                                                                                            } else {
                                                                                                                Position position = new Position();
                                                                                                                try {
                                                                                                                    position = PstPosition.fetchExc(emplx.getPositionId());
                                                                                                                } catch (Exception exc) {

                                                                                                                }

                                                                                                                String whereClsDep = "(((hr_department.DEPARTMENT_ID = " + departmentOid + ") "
                                                                                                                        + "AND hr_department." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + "=" + oidDivision + ") OR "
                                                                                                                        + "(hr_department." + PstDepartment.fieldNames[PstDepartment.FLD_JOIN_TO_DEPARTMENT_ID] + "=" + departmentOid + "))";

                                                                                                                if (position.getOID() != 0 && position.getDisabedAppDivisionScope() == 0) {
                                                                                                                    whereClsDep = " ( hr_department." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + "=" + oidDivision + ") ";
                                                                                                                }

                                                                                                                Vector SectionList = new Vector();
                                                                                                                try {
                                                                                                                    String joinDept = PstSystemProperty.getValueByName("JOIN_DEPARMENT");
                                                                                                                    Vector depGroup = com.dimata.util.StringParser.parseGroup(joinDept);

                                                                                                                    String joinDeptSection = PstSystemProperty.getValueByName("JOIN_DEPARTMENT_SECTION");
                                                                                                                    Vector depSecGroup = com.dimata.util.StringParser.parseGroup(joinDeptSection);

                                                                                                                    int grpIdx = -1;
                                                                                                                    int maxGrp = depGroup == null ? 0 : depGroup.size();

                                                                                                                    int grpSecIdx = -1;
                                                                                                                    int maxGrpSec = depSecGroup == null ? 0 : depSecGroup.size();

                                                                                                                    int countIdx = 0;
                                                                                                                    int MAX_LOOP = 10;
                                                                                                                    int curr_loop = 0;

                                                                                                                    int countIdxSec = 0;
                                                                                                                    int MAX_LOOPSec = 10;
                                                                                                                    int curr_loopSec = 0;

                                                                                                                    do { // find group department belonging to curretn user base in departmentOid
                                                                                                                        curr_loop++;
                                                                                                                        String[] grp = (String[]) depGroup.get(countIdx);
                                                                                                                        for (int g = 0; g < grp.length; g++) {
                                                                                                                            String comp = grp[g];
                                                                                                                            if (comp.trim().compareToIgnoreCase("" + departmentOid) == 0) {
                                                                                                                                grpIdx = countIdx;   // A ha .. found here 
                                                                                                                            }
                                                                                                                        }
                                                                                                                        countIdx++;
                                                                                                                    } while ((grpIdx < 0) && (countIdx < maxGrp) && (curr_loop < MAX_LOOP)); // if found then exit

                                                                                                                    Vector idxSecGroup = new Vector();

                                                                                                                    for (int x = 0; x < maxGrpSec; x++) {

                                                                                                                        String[] grp = (String[]) depSecGroup.get(x);
                                                                                                                        for (int j = 0; j < 1; j++) {

                                                                                                                            String comp = grp[j];
                                                                                                                            if (comp.trim().compareToIgnoreCase("" + departmentOid) == 0) {
                                                                                                                                Counter counter = new Counter();
                                                                                                                                counter.setCounter(x);
                                                                                                                                idxSecGroup.add(counter);
                                                                                                                            }
                                                                                                                        }
                                                                                                                    }

                                                                                                                    for (int s = 0; s < idxSecGroup.size(); s++) {

                                                                                                                        Counter counter = (Counter) idxSecGroup.get(s);

                                                                                                                        String[] grp = (String[]) depSecGroup.get(counter.getCounter());

                                                                                                                        Section sec = new Section();
                                                                                                                        sec.setDepartmentId(Long.parseLong(grp[0]));
                                                                                                                        sec.setOID(Long.parseLong(grp[2]));
                                                                                                                        SectionList.add(sec);

                                                                                                                    }

                                                                                                                    // compose where clause
                                                                                                                    if (grpIdx >= 0) {
                                                                                                                        String[] grp = (String[]) depGroup.get(grpIdx);
                                                                                                                        for (int g = 0; g < grp.length; g++) {
                                                                                                                            String comp = grp[g];
                                                                                                                            whereClsDep = whereClsDep + " OR (j.DEPARTMENT_ID = " + comp + ")";
                                                                                                                        }
                                                                                                                    }
                                                                                                                    whereClsDep = " (" + whereClsDep + ") AND hr_department." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + "=" + oidDivision;
                                                                                                                } catch (Exception exc) {
                                                                                                                    System.out.println(" Parsing Join Dept" + exc);
                                                                                                                }

                                                            //dept_value.add("0");
                                                                                                                //dept_key.add("select ...");
                                                                                                                listDept = PstDepartment.list(0, 0, whereClsDep, "");

                                                                                                                for (int idx = 0; idx < SectionList.size(); idx++) {

                                                                                                                    Section sect = (Section) SectionList.get(idx);

                                                                                                                    long sectionOid = 0;

                                                                                                                    for (int z = 0; z < listDept.size(); z++) {

                                                                                                                        Department dep = new Department();

                                                                                                                        dep = (Department) listDept.get(z);

                                                                                                                        if (sect.getDepartmentId() == dep.getOID()) {

                                                                                                                            sectionOid = sect.getOID();

                                                                                                                        }
                                                                                                                    }

                                                                                                                    if (sectionOid != 0) {

                                                                                                                        Section lstSection = new Section();
                                                                                                                        Department lstDepartment = new Department();

                                                                                                                        try {
                                                                                                                            lstSection = PstSection.fetchExc(sectionOid);
                                                                                                                        } catch (Exception e) {
                                                                                                                            System.out.println("Exception " + e.toString());
                                                                                                                        }

                                                                                                                        try {
                                                                                                                            lstDepartment = PstDepartment.fetchExc(lstSection.getDepartmentId());
                                                                                                                        } catch (Exception e) {
                                                                                                                            System.out.println("Exception " + e.toString());
                                                                                                                        }

                                                                                                                        listDept.add(lstDepartment);

                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        } else {
                                                                                                            dept_value.add("0");
                                                                                                            dept_key.add("select ...");
                                                                                                            listDept = PstDepartment.list(0, 0, (PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + "=" + oidDivision), "DEPARTMENT");
                                                                                                        }
                                                                                                    } else {
                                                                                                        dept_value.add("0");
                                                                                                        dept_key.add("select ...");
                                                                                                        listDept = PstDepartment.list(0, 0, (PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + "=" + oidDivision), "DEPARTMENT");
                                                                                                    }

                                                                                                    for (int i = 0; i < listDept.size(); i++) {
                                                                                                        Department dept = (Department) listDept.get(i);
                                                                                                        dept_key.add(dept.getDepartment());
                                                                                                        dept_value.add(String.valueOf(dept.getOID()));
                                                                                                    }

                                                //update by satrya 2013-08-13
                                                                                                    //jika user memilih select kembali
                                                                                                    if (oidDepartment == 0) {
                                                                                                        oidSection = 0;
                                                                                                    }
                                                                                                %> <%= ControlCombo.draw(FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_DEPARTMENT], "formElemen", null, "" + oidDepartment, dept_value, dept_key, "onChange=\"javascript:cmdUpdatePos()\"")%>
                                                                                            </td>
                                                                                            <td width="5%" align="left" nowrap valign="top">Section &nbsp;&nbsp;&nbsp;&nbsp; :
                                                                                                <%
                                                                                                    /*
                                                                                                     Vector sec_value = new Vector(1, 1);
                                                                                                     Vector sec_key = new Vector(1, 1);
                                                                                                     sec_value.add("0");
                                                                                                     sec_key.add("select ...");
											
                                                                                                     //String sWhereClause = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + sSelectedDepartment;                                                       
                                                                                                     //Vector listSec = PstSection.list(0, 0, sWhereClause, " SECTION ");
                                                                                                     String secWhere = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + "=" + oidDepartment;
                                                                                                     Vector listSec = PstSection.list(0, 0, secWhere, " SECTION ");
                                                                                                     for (int i = 0; i < listSec.size(); i++) {
                                                                                                     Section sec = (Section) listSec.get(i);
                                                                                                     sec_key.add(sec.getSection());
                                                                                                     sec_value.add(String.valueOf(sec.getOID()));
                                                                                                     }*/
                                                                                                %>
                                                                                                <%/*=ControlCombo.draw("section", null, "" + oidSection, sec_value, sec_key)*/%>     
                                                                                                <%

                                                                                                    Vector sec_value = new Vector(1, 1);
                                                                                                    Vector sec_key = new Vector(1, 1);
                                                                                                    sec_value.add("0");
                                                                                                    sec_key.add("select ...");

                                              //String sWhereClause = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + sSelectedDepartment;                                                       
                                                                                                    //Vector listSec = PstSection.list(0, 0, sWhereClause, " SECTION ");
                                                                                                    String secWhere = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + "=" + oidDepartment + " AND " + PstSection.fieldNames[PstSection.FLD_VALID_STATUS] + " = 1";
                                                                                                    Vector listSec = PstSection.list(0, 0, secWhere, " SECTION ");
                                                                                                    for (int i = 0; i < listSec.size(); i++) {
                                                                                                        Section sec = (Section) listSec.get(i);
                                                                                                        sec_key.add(sec.getSection());
                                                                                                        sec_value.add(String.valueOf(sec.getOID()));
                                                                                                    }
                                                                                                %>                                                                                 
                                                                                                <%=ControlCombo.draw(FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_SECTION], null, "" + oidSection, sec_value, sec_key)%>
                                                                                            </td>


                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="6%" nowrap="nowrap"> <div align="left"><%=dictionaryD.getWord(I_Dictionary.CATEGORY)%></div></td>
                                                                                            <td width="30%" nowrap="nowrap">:
                                                                                                <%
                                                                                                    Vector cat_value = new Vector(1, 1);
                                                                                                    Vector cat_key = new Vector(1, 1);
                                                                                                    cat_value.add("0");
                                                                                                    cat_key.add("all category ...");
                                                                                                    Vector listCat = PstEmpCategory.list(0, 0, "", " EMP_CATEGORY ");
                                                                                                    for (int i = 0; i < listCat.size(); i++) {
                                                                                                        EmpCategory cat = (EmpCategory) listCat.get(i);
                                                                                                        cat_key.add(cat.getEmpCategory());
                                                                                                        cat_value.add(String.valueOf(cat.getOID()));
                                                                                                    }
                                                                                                %>                                                                                 
                                                                                                <%= ControlCombo.draw(FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_CATEGORY], "formElemen", null, String.valueOf(objsrcLeaveManagement.getEmpCatId()), cat_value, cat_key, "")%> </td>
                                                                                        </tr>                                        
                                                                                        <tr> 
                                                                                            <td width="6%" nowrap="nowrap"> <div align="left">Period </div></td>
                                                                                            <td width="30%" nowrap="nowrap">:
                                                                                                <%
                                                                                                    if (objsrcLeaveManagement.getTime() == 0) {
                                                                                                %>
                                                                                                <input type="radio" name="<%=FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_TIME]%>" value="0" checked>   
                                                                                                <%
                                                                                                } else {
                                                                                                %>
                                                                                                <input type="radio" name="<%=FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_TIME]%>" value="0">   
                                                                                                <%
                                                                                                    }
                                                                                                %>  

                                                                                                <%
                                                                                                    String selectValuePeriod = "" + objsrcLeaveManagement.getPeriodId();

                                                                                                    Vector period_value = new Vector(1, 1);
                                                                                                    Vector period_key = new Vector(1, 1);

                                                                                                    period_value.add("0");
                                                                                                    period_key.add("select...");
                                                                                                    Vector listPeriod = new Vector(1, 1);

                                                                                                    listPeriod = PstPeriod.list(0, 0, "", PstPeriod.fieldNames[PstPeriod.FLD_START_DATE] + " DESC");
                                                                                                    for (int i = 0; i < listPeriod.size(); i++) {
                                                                                                        Period period = (Period) listPeriod.get(i);
                                                                                                        period_key.add(period.getPeriod());
                                                                                                        period_value.add(String.valueOf(period.getOID()));
                                                                                                    }
                                                                                                %>
                                                                                                <%= ControlCombo.draw(FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_PERIOD_MAN], null, selectValuePeriod, period_value, period_key, " onkeydown=\"javascript:fnTrapKD()\"")%> 

                                                                                                &nbsp;OR&nbsp; 
                                                                                                <%
                                                                                                    if (objsrcLeaveManagement.getTime() == 1) {
                                                                                                %>
                                                                                                <input type="radio" name="<%=FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_TIME]%>" value="1" checked>   
                                                                                                <%
                                                                                                } else {
                                                                                                %>
                                                                                                <input type="radio" name="<%=FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_TIME]%>" value="1">   
                                                                                                <%
                                                                                                    }
                                                                                                %>
                                                                                                <%=ControlDatePopup.writeDate(FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_START_DATE], objsrcLeaveManagement.getStartDate() == null ? new Date() : objsrcLeaveManagement.getStartDate(), "getStartDate()")%> To
                                                                                                <%=ControlDatePopup.writeDate(FrmSrcLeaveManagement.fieldNames[FrmSrcLeaveManagement.FRM_FIELD_END_DATE], objsrcLeaveManagement.getEndDate() == null ? new Date() : objsrcLeaveManagement.getEndDate(), "getEndDate()")%>                                                                                                                              
                                                                                            </td>
                                                                                        </tr>                                        
                                                                                        <tr> 
                                                                                            <td width="13%">&nbsp;</td>
                                                                                            <td nowrap width="2%">&nbsp;</td>
                                                                                            <td nowrap width="85%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="13%">&nbsp;</td>
                                                                                            <td nowrap width="2%">&nbsp;</td>
                                                                                            <td nowrap width="85%"> 
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr> 
                                                                                                        <td width="25px" ></td>
                                                                                                        <td width="5px"></td>
                                                                                                        <td width="30px" class="command" nowrap align="left"><a href="javascript:cmdViewReport()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10', '', '<%=approot%>/images/BtnSearchOn.jpg', 1)" id="aSearch"><img name="Image10" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="Search closing employee" ></a></td>  
                                                                                                        <td width="100px"><a href="javascript:cmdViewReport()">View Report</a></td>
                                                                                                        <td width="30px"></td>  
                                                                                                        <td width="100px"></td>                                                
                                                                                                        <td width="25px"></td>
                                                                                                        <td width="15px"></td>
                                                                                                        <td width="100px"></td>                                                                                                     
                                                                                                    </tr>                                              
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="13%">&nbsp;</td>
                                                                                            <td nowrap width="2%">&nbsp;</td>
                                                                                            <td nowrap width="85%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="3">
                                                                                                <%
                                                                                                    //if(listSp != null && listSp.size() > 0) {  
                                                                                                    if (listSp != 0 && listSp > 0) {
                                                                                                %>        
                                                                                                <%=drawList(listSp, oidCompany, oidDivision, oidDepartment, oidSection, objsrcLeaveManagement.getTime(), objsrcLeaveManagement.getPeriodId(), empNum, fullName, objsrcLeaveManagement.getEmpCatId())%>     
                                                                                            </td>
                                                                                        </tr> 
                                                                                        <tr>
                                                                                            <td colspan="3">
                                                                                                &nbsp;
                                                                                            </td>
                                                                                        </tr> 
                                                                                        <tr> 
                                                                                            <td width="13%">&nbsp;</td>
                                                                                            <td nowrap width="2%">&nbsp;</td>
                                                                                            <td nowrap width="85%"> 
                                                                                                <table border="0" cellpadding="0" cellspacing="0" width="225">
                                                                                                    <tr> 
                                                                                                        <td width="25px" ><a href="javascript:cmdPrint()" onMouseOut="MM_swapImgRestore()" onMouseOut="MM_swapImgRestore()" ><img name="Image300" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Close Period" ></a></td>
                                                                                                        <td width="5px"></td>
                                                                                                        <td width="30px" class="command" nowrap><a href="javascript:cmdPrintXLS()">Print XLS</a></td>                                                                                                                                                      
                                                                                                        <td width="15px"></td>
                                                                                                        <td width="30px" ></td>
                                                                                                        <td width="10px"></td>
                                                                                                        <td width="10px"></td>                                                                                                     
                                                                                                    </tr>                                                   
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }
                                                                                        %>
                                                                                    </table>
                                                                                </form>
                                                                                <!-- #EndEditable -->
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td>&nbsp; </td>
                                                </tr>
                                            </table>
                                        </td> 
                                    </tr>
                                </table>
                            </td> 
                        </tr>
                    </table>
                </td> 
            </tr>
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
            <tr>
                <td valign="bottom">
                    <!-- untuk footer -->
                    <%@include file="../../footer.jsp" %>
                </td>

            </tr>
            <%} else {%>
            <tr> 
                <td colspan="2" height="20" <%=bgFooterLama%>> <!-- #BeginEditable "footer" --> 
                    <%@ include file = "../../main/footer.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <%}%>
        </table>
    </body>
</html>

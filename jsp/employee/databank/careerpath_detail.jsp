<%-- 
    Document   : careerpath_detail
    Created on : Oct 27, 2015, 10:41:26 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="com.dimata.util.lang.I_Dictionary"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    long oidCareerPath = FRMQueryString.requestLong(request, "oid");
    int EmployeNow = FRMQueryString.requestInt(request, "now");
    int rGroup = FRMQueryString.requestInt(request, "rg");
    Employee empData = new Employee();
    long empId = 0;
    int historyGroupSelect = 0;
    CareerPath careerPath = new CareerPath();
    if (oidCareerPath != 0) {
        try {
            careerPath = PstCareerPath.fetchExc(oidCareerPath);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
    if (EmployeNow == 1) {
        Employee employeeFetch = new Employee();
        try {

            employeeFetch = PstEmployee.fetchExc(oidCareerPath);
            empId = employeeFetch.getOID();
            empData = PstEmployee.fetchExc(empId);
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

            careerPath.setHistoryGroup(employeeFetch.getHistoryGroup());
            careerPath.setHistoryType(employeeFetch.getHistoryType());

            //mencari work from
            careerPath.setGradeLevelId(employeeFetch.getGradeLevelId());
            EmpDoc empDocXXX = new EmpDoc();
            try {
                empDocXXX = PstEmpDoc.fetchExc(employeeFetch.getEmpDocId());
                //String SkNumber = PstEmpCustomField.getNoSK(employeeFetch.getOID(), empDocX.getDoc_number(), oidCustomFieldSkNumber);
                careerPath.setNomorSk(empDocXXX.getDoc_number());
                //Date SkTanggal = PstEmpCustomField.getTglSk(employeeFetch.getOID(), empDocX.getDoc_number(), oidCustomFieldSkDate);
                careerPath.setTanggalSk(empDocXXX.getRequest_date());
            } catch (Exception ex) {
            }

            careerPath.setEmpDocId(employeeFetch.getEmpDocId());
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Career Detail</title>
        <style type="text/css">
            body {
                font-family: sans-serif;
                font-size: 11px;
                margin: 0; padding: 0;
                background-color: #FFF;
                color: #474747;
            }
            #header-title {
                font-size: 24px; 
                color: #575757; 
                text-align: center;
            }
            .header {
                margin: 0;
                background-color: #FFF;
                border-bottom: 1px solid #CCC;
            }
            .content-main{
                margin: 0;
                padding: 12px;
                background-color: #EEE;
            }
            .content-box {
                background-color: #FFF;
                padding: 15px;
                margin: 15px 9px;
                border-radius: 3px;
            }
            .item {margin: 7px 0px;}
            #caption {font-weight: bold; padding-top: 5px;}
            #value {padding-top: 2px; padding-bottom: 5px;}
        </style>
    </head>
    <body>
        <div class="header">
            <p id="header-title"><%=dictionaryD.getWord(I_Dictionary.VIEW)%> Career Detail</p>
        </div>
        <div class="content-main">
            <table cellpadding="0" cellspacing="0" width="100%" style="font-size: 12px">
                <tr>
                    <td valign="top">
                        <div class="content-box">
                            <div class="item">
                                <div id="caption"><%=dictionaryD.getWord(I_Dictionary.COMPANY)%></div>
                                <div id="value"><%= careerPath.getCompany() %></div>
                            </div>
                            <div class="item">
                                <div id="caption"><%=dictionaryD.getWord(I_Dictionary.DIVISION)%></div>
                                <div id="value"><%= careerPath.getDivision() %></div>
                            </div>
                            <div class="item">
                                <div id="caption"><%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%></div>
                                <div id="value"><%= careerPath.getDepartment() %></div>
                            </div>
                            <div class="item">
                                <div id="caption"><%=dictionaryD.getWord("SECTION")%></div>
                                <div id="value"><%= careerPath.getSection() %></div>
                            </div>
                            <div class="item">
                                <div id="caption"><%=dictionaryD.getWord(I_Dictionary.POSITION)%></div>
                                <div id="value"><%= careerPath.getPosition() %></div>
                            </div>
                                <div class="item">
                                <div id="caption"><%=dictionaryD.getWord("LEVEL")%></div>
                                <div id="value"><%= careerPath.getLevel() %></div>
                            </div>
                            <div class="item">
                                <div id="caption"><%=dictionaryD.getWord("CATEGORY")%></div>
                                <div id="value"><%= careerPath.getEmpCategory() %></div>
                            </div>  
                        </div>
                            <div class="content-box">
                                <div class="item">
                                    <div id="caption"><%=dictionaryD.getWord(I_Dictionary.HISTORY)%> <%=dictionaryD.getWord(I_Dictionary.FORM)%></div>
                                    <div id="value"><%= Formater.formatDate(careerPath.getWorkFrom(), "dd MMMM yyyy") %></div>
                                </div>
                                <div class="item">
                                    <div id="caption">History to</div>
                                    <div id="value">
                                        <% if (EmployeNow == 1) { %>
                                        NOW
                                        <% } else { %>
                                        <%= Formater.formatDate(careerPath.getWorkTo(), "dd MMMM yyyy") %>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                    </td>
                    <td valign="top">
                        <div class="content-box">
                            <div class="item">
                                <%
                                String gradeLevel = "-";
                                try {
                                    GradeLevel gLevel = PstGradeLevel.fetchExc(careerPath.getGradeLevelId());
                                    gradeLevel = gLevel.getCodeLevel();
                                } catch(Exception e){
                                    System.out.print("=>"+e.toString());
                                }
                                %>
                                <div id="caption"><%=dictionaryD.getWord(I_Dictionary.GRADE)%> <%=dictionaryD.getWord(I_Dictionary.LEVEL)%></div>
                                <div id="value"><%= gradeLevel %></div>
                            </div>
                            <div class="item">
                                <div id="caption"><%=dictionaryD.getWord(I_Dictionary.DESCRIPTION)%></div>
                                <div id="value"><%= careerPath.getDescription() %></div>
                            </div>
                        </div>
                        <div class="content-box">
                            <div class="item">
                                <div id="caption"><%=dictionaryD.getWord(I_Dictionary.HISTORY)%> <%=dictionaryD.getWord(I_Dictionary.TYPE)%></div>
                                <div id="value"><%= PstCareerPath.historyType[careerPath.getHistoryType()] %></div>
                            </div>
                            <div class="item">
                                <div id="caption"><%=dictionaryD.getWord(I_Dictionary.HISTORY)%> <%=dictionaryD.getWord(I_Dictionary.GROUP)%></div>
                                <div id="value"><%= PstCareerPath.historyGroup[careerPath.getHistoryGroup()] %></div>
                            </div>
                            <div class="item">
                                <div id="caption"><%=dictionaryD.getWord(I_Dictionary.PROVIDER)%></div>
                                <%
                                ContactList contact = new ContactList();
                                String provider = "-";
                                try {
                                    contact = PstContactList.fetchExc(careerPath.getProviderID());
                                    provider = contact.getCompName();
                                } catch (Exception e){
                                    System.out.println(e.toString());
                                }
                                %>
                                <div id="value"><%= provider %></div>
                            </div>
                            <%
                                String nomorSK = "";
                                Date dateSK = new Date();
                                
                                try{
                                    String whereSK = "b.FIELD_NAME LIKE '%SK%' AND a.EMPLOYEE_ID='"+ empId +"'";
                                    Vector nowSK = PstEmpCustomField.listJoinCustomFieldMaster(whereSK);

                                    for(int i = 0; i < nowSK.size(); i++){
                                        EmpCustomField empCustField = (EmpCustomField)nowSK.get(i);

                                        String fieldName = empCustField.getFieldName();
                                        String[] splits = fieldName.split(" ");

                                        if(splits[0].equals("Nomor")){
                                            nomorSK = empCustField.getDataText();
                                        } else if(splits[0].equals("Tanggal")){
                                            dateSK = empCustField.getDataDate();
                                        } else {

                                        }
                                    }
                                } catch(Exception ex) {
                                }
                            %>
                            <% if (EmployeNow ==1 ){ %>
                            <% if (rGroup == 1){ %>
                            <div class="item">
                                <div id="caption">Nomor SK</div>
                                <div id="value"><%= ""+empData.getSkNomor() %></div>
                            </div>
                            <div class="item">
                                <div id="caption">Tanggal SK</div>
                                <div id="value"><%= ""+empData.getSkTanggal() %></div>
                            </div>
                            <% } %>
                            <% if (rGroup == 2){ %>
                            <div class="item">
                                <div id="caption">Nomor SK</div>
                                <div id="value"><%= ""+empData.getSkNomorGrade() %></div>
                            </div>
                            <div class="item">
                                <div id="caption">Tanggal SK</div>
                                <div id="value"><%= ""+empData.getSkTanggalGrade() %></div>
                            </div>
                            <% } %>
                            <% } else { %>
                            <div class="item">
                                <div id="caption">Nomor SK</div>
                                <div id="value"><%= ""+careerPath.getNomorSk()%></div>
                            </div>
                            <div class="item">
                                <div id="caption">Tanggal SK</div>
                                <div id="value"><%= ""+careerPath.getTanggalSk() %></div>
                            </div>
                            <% } %>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        
    </body>
</html>

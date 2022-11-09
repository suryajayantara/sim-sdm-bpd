<%-- 
    Document   : list_emp_training
    Created on : Jun 13, 2016, 4:05:12 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.employee.TrainingHistory"%>
<%@page import="com.dimata.harisma.entity.employee.PstTrainingHistory"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.masterdata.Level"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstLevel"%>
<%@page import="com.dimata.harisma.entity.masterdata.TrainType"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstTrainType"%>
<%@page import="com.dimata.harisma.entity.masterdata.Training"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstTraining"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
/* value of structure */
long companyId = FRMQueryString.requestLong(request, "company_id");
long divisionId = FRMQueryString.requestLong(request, "division_id");
long departmentId = FRMQueryString.requestLong(request, "department_id");
long sectionId = FRMQueryString.requestLong(request, "section_id");

long positionId = FRMQueryString.requestLong(request, "position_id");
String multi_positionId = FRMQueryString.requestString(request, "position_id");
long levelId = FRMQueryString.requestLong(request, "level_id");
long trainType = FRMQueryString.requestLong(request, "train_type");
long trainProg = FRMQueryString.requestLong(request, "train_program");
int searchCategory = FRMQueryString.requestInt(request, "search_category");

int program = FRMQueryString.requestInt(request, "program");
int tipe = FRMQueryString.requestInt(request, "tipe");
int trainer = FRMQueryString.requestInt(request, "trainer");
int tanggal = FRMQueryString.requestInt(request, "tanggal");
int catatan = FRMQueryString.requestInt(request, "catatan");
int durasi = FRMQueryString.requestInt(request, "durasi");
int poin = FRMQueryString.requestInt(request, "poin");
int nomer_sk = FRMQueryString.requestInt(request, "nomer_sk");
int tanggal_sk = FRMQueryString.requestInt(request, "tanggal_sk");

String dateFrom = FRMQueryString.requestString(request, "date_from");
String dateTo = FRMQueryString.requestString(request, "date_to");


Vector listTrainingHaveBeen = new Vector();
Vector listEmpNotTrain = new Vector();
Vector listTrainingHistory = new Vector();
String whereClauseEmp = "";
String whereTrain = "";
String whereClause = "";
String orderBy = PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID];
Vector<String> whereCollect = new Vector<String>();
Vector<String> whereCollectNotYet = new Vector<String>();
ChangeValue changeValue = new ChangeValue();

if (companyId != 0){
    whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
    whereCollect.add(whereClauseEmp);
}
if (divisionId != 0){
    whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionId;
    whereCollect.add(whereClauseEmp);
}
if (departmentId != 0){
    whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+departmentId;
    whereCollect.add(whereClauseEmp);
}
if (sectionId != 0){
    whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+sectionId;
    whereCollect.add(whereClauseEmp);
}
//if (positionId != 0){
//    whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+positionId;
//    whereCollect.add(whereClauseEmp);
//}
if (!multi_positionId.equals("null")){
    whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+" IN (" + multi_positionId + ")";
    whereCollect.add(whereClauseEmp);
}
if (levelId != 0){
    whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+"="+levelId;
    whereCollect.add(whereClauseEmp);
}
if (trainType != 0){
    whereClauseEmp = " (TR.TYPE="+trainType+" OR TR2.TYPE="+trainType+") ";
    whereCollect.add(whereClauseEmp);
}
if (trainProg != 0){
    whereClauseEmp = " (TRH.TRAINING_ID="+trainProg+" OR TR2.TRAINING_ID="+trainProg+")";
    whereCollect.add(whereClauseEmp);
}
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
if (dateFrom.length()>0 && dateTo.length()>0){
    whereClauseEmp += " AND TRH.START_DATE BETWEEN '"+dateFrom+" 00:00:00' AND '"+dateTo+" 23:59:00' ";
    whereCollect.add(whereClauseEmp);
}
if (whereClauseEmp.length() > 0){
    listTrainingHaveBeen = PstTrainingHistory.listEmployeeHaveBeenTrained1(0, 0, whereClauseEmp, orderBy);
}

if (searchCategory == 1){
    if (companyId != 0){
    whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
    whereCollectNotYet.add(whereClause);
    }
    if (divisionId != 0){
        whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionId;
        whereCollectNotYet.add(whereClause);
    }
    if (departmentId != 0){
        whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+departmentId;
        whereCollectNotYet.add(whereClause);
    }
    if (sectionId != 0){
        whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+sectionId;
        whereCollectNotYet.add(whereClause);
    }
//    if (positionId != 0){
//        whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+positionId;
//        whereCollectNotYet.add(whereClause);
//    }
	if (!multi_positionId.equals("null")){
		whereClauseEmp = PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+" IN (" + multi_positionId + ")";
		whereCollect.add(whereClauseEmp);
	}
    if (levelId != 0){
        whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+"="+levelId;
        whereCollectNotYet.add(whereClause);
    }

    if (whereCollectNotYet != null && whereCollectNotYet.size()>0){
        whereClause = "";
        for (int i=0; i<whereCollectNotYet.size(); i++){
            String where = (String)whereCollectNotYet.get(i);
            whereClause += where;
            if (i < (whereCollectNotYet.size()-1)){
                 whereClause += " AND ";
            }
        }
    }
    
    if (whereClause.length() == 0){
        whereClause = " 1=1";
    }
    
    String whereNotYet = "employee_id NOT IN (SELECT TRH.employee_id FROM `hr_training_history`";
            whereNotYet += " TRH INNER JOIN hr_employee EMP ON TRH.`EMPLOYEE_ID` = EMP.`EMPLOYEE_ID`";
            whereNotYet += " INNER JOIN hr_training TR ON TRH.`TRAINING_ID` = TR.`TRAINING_ID`";
            whereNotYet += " LEFT JOIN `hr_training_activity_mapping` map ";
            whereNotYet += " ON map.`TRAINING_ACTIVITY_PLAN_ID` = TRH.`TRAINING_ACTIVITY_PLAN_ID` ";
            whereNotYet += " LEFT JOIN hr_training AS TR2 ";
            whereNotYet += " ON map.`TRAINING_ID` = TR2.`TRAINING_ID` ";
            whereNotYet +=  " WHERE "+ whereClauseEmp +") AND" + whereClause;
    String orderEmp = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM];        
           
    listEmpNotTrain = PstEmployee.list(0, 0, whereNotYet, orderEmp);
    
    if(listEmpNotTrain != null && listEmpNotTrain.size()>0){
       %>
        <table class="tblStyle">
        <tr>
            <td class="title_tbl">No</td>
            <td class="title_tbl">Emp. num</td>
            <td class="title_tbl">Nama Karyawan</td>
            <td class="title_tbl">Position</td>
            <td class="title_tbl">Level</td>
        <% if (trainProg != 0) {%>     
            <td class="title_tbl">Program Pelatihan</td>
        <% } %>    
            <td class="title_tbl">Training Type</td>
            
            
        </tr>
        <%
        for(int i=0; i<listEmpNotTrain.size(); i++){
            Employee employee = (Employee)listEmpNotTrain.get(i);
            
            Position position = new Position();
            Level level = new Level();
            TrainType type = new TrainType();
            Training trn = new Training();
            
            String empPosition = "";
            String empLevel = "";
            String trnProgram = "";
            String trType = "";
            
            Vector listTrainProgram = new Vector();
            
            if (trainProg == 0){
                String whereClauseTrain = PstTraining.fieldNames[PstTraining.FLD_TYPE] + " = " + trainType;
                listTrainProgram = PstTraining.list(0, 0, whereClauseTrain, "");
            }
            try{
                position = PstPosition.fetchExc(employee.getPositionId());
                empPosition = position.getPosition();
                level = PstLevel.fetchExc(employee.getLevelId());
                empLevel = level.getLevel();
                
                if (trainProg == 0 && listTrainProgram.size() != 0){
                    for ( int x = 0; x < listTrainProgram.size(); x++){
                        Training training = (Training) listTrainProgram.get(x);
                        type = PstTrainType.fetchExc(training.getType());
                        trType = type.getTypeName();
                    }
                } else {

                    trn = PstTraining.fetchExc(trainProg);
                    trnProgram = trn.getName();
                    type = PstTrainType.fetchExc(trn.getType());
                    trType = type.getTypeName();
                }
            } catch (Exception exc){
                System.out.println("error"+exc);
            }
            %>
            <tr>
                <td><%= (i+1) %></td>
                <td><%= employee.getEmployeeNum() %></td>
                <td><%= employee.getFullName() %></td>
                <td><%= empPosition %></td>
                <td><%= empLevel %></td>
            <% if (trainProg != 0) {%>    
                <td><%= trnProgram %></td>
            <% } %>    
                <td><%= trType %></td>
            </tr>
            <%
        }
        %>
        </table>
        <% 
    } else {%><h5>No Data Available</h5><%}
}

if (searchCategory == 0){
    if (listTrainingHaveBeen != null && listTrainingHaveBeen.size()>0){
        %>
        <table class="tblStyle">
        <tr>
            <td class="title_tbl">No</td>
            <td class="title_tbl">Emp. num</td>
            <td class="title_tbl">Nama Karyawan</td>
            <td class="title_tbl">Position</td>
            <td class="title_tbl">Level</td>
            <td class="title_tbl">Judul Pelatihan</td>
        <% if (program == 1) {%>     
            <td class="title_tbl">Program Pelatihan</td>
        <% } %> 
        <% if (tipe == 1) {%>  
            <td class="title_tbl">Training Type</td>
        <% } %>
        <% if (trainer == 1) {%>  
            <td class="title_tbl">Trainer</td>
        <% } %>
        <% if (tanggal == 1) {%>  
            <td class="title_tbl">tanggal</td>
        <% } %>
        <% if (catatan == 1) {%>  
            <td class="title_tbl">Catatan</td>
        <% } %>
        <% if (durasi == 1) {%>  
            <td class="title_tbl">Durasi</td>
        <% } %>
        <% if (poin == 1) {%>  
            <td class="title_tbl">Poin</td>
        <% } %>
        <% if (nomer_sk == 1) {%>  
            <td class="title_tbl">Nomer SK</td>
        <% } %>
        <% if (tanggal_sk == 1) {%>  
            <td class="title_tbl">Tanggal SK</td>
        <% } %>
        </tr>
        <%
        for(int i=0; i<listTrainingHaveBeen.size(); i++){
            TrainingHistory trainingHistory = (TrainingHistory)listTrainingHaveBeen.get(i);
            
            Employee employee = new Employee();
            Position position = new Position();
            Level level = new Level();
            TrainType type = new TrainType();
            Training trn = new Training();
            
            String empNum = "";
            String empName = "";
            String empPosition = "";
            String empLevel = "";
            String trType = "";
            
            try{
                employee = PstEmployee.fetchExc(trainingHistory.getEmployeeId());
                empNum = employee.getEmployeeNum();
                empName = employee.getFullName();
                position = PstPosition.fetchExc(employee.getPositionId());
                empPosition = position.getPosition();
                level = PstLevel.fetchExc(employee.getLevelId());
                empLevel = level.getLevel();
                trn = PstTraining.fetchExc(trainingHistory.getTrainingId());
                type = PstTrainType.fetchExc(trn.getType());
                trType = type.getTypeName();
                
            } catch (Exception exc){
                System.out.println("error"+exc);
            }
            %>
            <tr>
                <td><%= (i+1) %></td>
                <td><%= empNum %></td>
                <td><%= empName %></td>
                <td><%= empPosition %></td>
                <td><%= empLevel %></td>
                <td><%= trainingHistory.getTrainingTitle() %></td>
                
                <% if (program == 1) {%>    
                <td><%= trainingHistory.getTrainingProgram() %></td>
            <% } %>    
                <% if (tipe == 1) {%>  
                <td><%= trType %></td>
                <% } %>
                <% if (trainer == 1) {%>  
                    <td><%=trainingHistory.getTrainer()%></td>
                <% } %>
                <% if (tanggal == 1) {%>  
                    <td><%="From :</br>"+trainingHistory.getStartDate()+"</br>To :</br>"+trainingHistory.getEndDate()%></td>
                <% } %>
                <% if (catatan == 1) {%>  
                    <td><%=trainingHistory.getRemark()%></td>
                <% } %>
                <% if (durasi == 1) {%>  
                    <td><%=trainingHistory.getDuration()%></td>
                <% } %>
                <% if (poin == 1) {%>  
                    <td><%=trainingHistory.getPoint()%></td>
                <% } %>
                <% if (nomer_sk == 1) {%>  
                    <td><%=trainingHistory.getNomorSk()%></td>
                <% } %>
                <% if (tanggal_sk == 1) {%>  
                    <td><%= trainingHistory.getTanggalSk() != null ? trainingHistory.getTanggalSk() : "" %></td>
                <% } %>
            </tr>
            <%
        }
        %>
        </table>
        <%
    } else {%><h5>No Data Available</h5><% }
} 
%>

<%-- 
    Document   : training-program-ajax
    Created on : Dec 28, 2015, 5:03:55 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmTrainingBudget"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlTraining"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstTrainType"%>
<%@page import="com.dimata.harisma.entity.masterdata.TrainType"%>
<%@page import="com.dimata.harisma.entity.masterdata.Training"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstTraining"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_TRAINING, AppObjInfo.G2_TRAINING_PROGRAM, AppObjInfo.OBJ_MENU_TRAINING_PROGRAM);%>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String trainingName = FRMQueryString.requestString(request, "training_name");
    String typeName = FRMQueryString.requestString(request, "type_name");
    String thn = FRMQueryString.requestString(request, "training_thn");
    String data = FRMQueryString.requestString(request, "data");
    int iCommand = FRMQueryString.requestInt(request, "command");
    int start = FRMQueryString.requestInt(request, "start");
    String whereClause = "";
    String order = "";
    String alert = "";
    Vector listTraining = new Vector();
    Vector listTrainBudget = new Vector();
    CtrlTraining ctrTraining = new CtrlTraining(request);
    TrainingBudget trainBud = new TrainingBudget();
    
    int recordToGet = 200;
    int vectSize = 0;
    vectSize = PstTraining.getCount("");
    if ((iCommand == Command.FIRST) || (iCommand == Command.NEXT) || (iCommand == Command.PREV)
            || (iCommand == Command.LAST) || (iCommand == Command.LIST)) {
        start = ctrTraining.actionList(iCommand, start, vectSize, recordToGet);
    }

    if(iCommand == Command.LIST || iCommand == Command.ADD){
        if (!(trainingName.equals("0"))){
            if (typeName.equals("0")){
                whereClause = "tr."+PstTraining.fieldNames[PstTraining.FLD_NAME]+" LIKE '%"+trainingName+"%'";
                order = "tr."+PstTraining.fieldNames[PstTraining.FLD_NAME];
                listTrainBudget = PstTrainingBudget.listJoin(0, 0, whereClause, order);
                vectSize = listTrainBudget.size();
            } else {
                whereClause = "tr."+PstTraining.fieldNames[PstTraining.FLD_TYPE]+"="+typeName;
                listTrainBudget = PstTrainingBudget.listJoin(0, 0, whereClause, "tr."+PstTraining.fieldNames[PstTraining.FLD_TYPE]);
                vectSize = listTrainBudget.size();
            }
        } else {
            vectSize = PstTraining.getCount("");
            order = PstTraining.fieldNames[PstTraining.FLD_TYPE];
            listTraining = PstTraining.list(start, recordToGet, "", order);
            if(iCommand == Command.ADD){
                for(int i=0; i < listTraining.size(); i++){
                    Training training = (Training)listTraining.get(i);
                    try{
                        trainBud.setTrainingId(training.getOID());
                        trainBud.setTrainingBudgetYear(thn);
                        PstTrainingBudget.insertExc(trainBud);
                    }catch(Exception tB){
                        alert = "Error: "+tB;
                    }

                }
            }
            
            if(!(thn.equals(""))){
                 
                order = "tt.type_id, tr.TRAINING_ID";
                String whereCount = PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_BUDGET_YEAR]+" = '"+thn+"'";
                whereClause = "tb."+PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_BUDGET_YEAR]+" = '"+thn+"'";
                vectSize = PstTrainingBudget.getCount(whereCount);
                listTrainBudget = PstTrainingBudget.listJoin(0, 0, whereClause, order);
                if(listTrainBudget.size() > 0){

                } else {
                    alert = "Tidak ada data.";
                }
            }
        }
    }
    
    if(iCommand == Command.SAVE){
        try {
            String allData = data;
            String[] splits = allData.split(",");
            
            trainBud.setOID(Long.parseLong(splits[0]));
            trainBud.setTrainingBudgetYear(splits[1]);
            trainBud.setTrainingId(Long.parseLong(splits[2]));
            trainBud.setTrainingBudgetDuration(Double.valueOf(splits[3]));
            trainBud.setTrainingBudgetFrequency(Double.valueOf(splits[4]));
            trainBud.setTrainingBudgetBatch(Double.valueOf(splits[5]));
            trainBud.setTrainingBudgetAmount(Double.valueOf(splits[6]));
            trainBud.setTrainingBudgetCostBatch(Double.valueOf(splits[7]));
            trainBud.setTrainingBudgetTotal(Double.valueOf(splits[8]));
            trainBud.setTrainingLocationTypeId(Long.parseLong(splits[9]));
            trainBud.setTrainingAreaId(Long.parseLong(splits[10]));
            trainBud.setTrainingBudgetDesc(splits[11]);
            //oid+","+year+","+trainId+","+duration+","+freq+","+bacth+","+amount+","+costBatch+","+tot+","+locTypeId+","+areaId+","+desc;
            long oid = PstTrainingBudget.updateExc(trainBud);
        } catch (Exception eData) {
            
        }
    }
    
    if (listTrainBudget != null && listTrainBudget.size()>0){
        %>
        <table class="tblStyle">
            <tr>
                <td class="title_tbl" style="background-color: #DDD;">NO</td>
                <td class="title_tbl" style="background-color: #DDD;">KODE</td>
                <td class="title_tbl" style="background-color: #DDD;" colspan="2">PENDIDIKAN DAN LATIHAN</td>
                <td class="title_tbl" style="background-color: #DDD;">DURASI</td>
                <td class="title_tbl" style="background-color: #DDD;">FREK. (kali)</td>
                <td class="title_tbl" style="background-color: #DDD;">PESERTA/BATCH</td>
                <td class="title_tbl" style="background-color: #DDD;">Jumlah</td>
                <td class="title_tbl" style="background-color: #DDD;">BIAYA PER PESERTA</td>
                <td class="title_tbl" style="background-color: #DDD;">TOTAL ANGGARAN</td>
                <td class="title_tbl" style="background-color: #DDD;">TEMPAT</td>
                <td class="title_tbl" style="background-color: #DDD;">BIDANG</td>
                <td class="title_tbl" style="background-color: #DDD;">KETERANGAN</td>
                
                
            </tr>
        <%
        long typeOidNow = 0;
        int no = 0;
        int noN = 0;
        for(int i=0; i<listTrainBudget.size(); i++){
            trainBud = (TrainingBudget)listTrainBudget.get(i);
            Training training = new Training();
            TrainType type = new TrainType();
            
            try {
                training = PstTraining.fetchExc(trainBud.getTrainingId());
            } catch(Exception e) {
                System.out.println(""+e.toString());
                training = new Training();
            }
                                  
            try {
                type = PstTrainType.fetchExc(training.getType());
            } catch(Exception e) {
                System.out.println(""+e.toString());
                type = new TrainType();
            }
            
            if(typeOidNow != training.getType()){
            %>
            <tr>
                <td><%= no = no+1 %></td>
                <td colspan="12"><%= type.getTypeName() %></td>
            </tr>
            <%
                typeOidNow = training.getType();
                noN = 0;
            }
            %>
            <tr>
                <td></td>
                <td><%=training.getKodeAnggaran()%></td>
                <td><%= noN = noN+1 %></td>
                <td><input id="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_ID]+"_"+i%>" type="hidden" style="padding:6px 7px" name="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_ID]%>_<%=i%>" value="<%= trainBud.getOID() %>" size="2" />
                    <input id="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_YEAR]+"_"+i%>" type="hidden" style="padding:6px 7px" name="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_YEAR]%>_<%=i%>" value="<%= trainBud.getTrainingBudgetYear() %>" size="2" />
                    <input id="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_ID]+"_"+i%>" type="hidden" style="padding:6px 7px" name="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_ID]%>_<%=i%>" value="<%= trainBud.getTrainingId() %>" size="2" />
                    <%= training.getName() %></td>
                <td><input id="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_DURATION]+"_"+i%>" type="text" style="padding:6px 7px" name="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_DURATION]%>_<%=i%>" value="<%= trainBud.getTrainingBudgetDuration() %>" onkeyup="javascript:cmdShowSave()" size="2" />  hari</td>
                <td><input id="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_FREQUENCY]+"_"+i%>" type="text" style="padding:6px 7px" name="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_FREQUENCY]%>_<%=i%>" value="<%= trainBud.getTrainingBudgetFrequency() %>" size="10" /></td>
                <td><input id="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_BATCH]+"_"+i%>" type="text" style="padding:6px 7px" name="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_BATCH]%>_<%=i%>" value="<%= trainBud.getTrainingBudgetBatch() %>" size="10" /></td>
                <td><input id="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_AMOUNT]+"_"+i%>" type="text" style="padding:6px 7px" name="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_AMOUNT]%>_<%=i%>" value="<%= (trainBud.getTrainingBudgetFrequency()*trainBud.getTrainingBudgetBatch()) %>" size="10" disabled /></td>
                <td><input id="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_COST_BATCH]+"_"+i%>" type="text" style="padding:6px 7px" name="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_COST_BATCH]%>_<%=i%>" value="<%= Formater.formatNumber(trainBud.getTrainingBudgetCostBatch(),"####") %>" size="10" /></td>
                <td><input id="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_TOTAL]+"_"+i%>" type="text" style="padding:6px 7px" name="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_TOTAL]%>_<%=i%>" value="<%= Formater.formatNumber(trainBud.getTrainingBudgetCostBatch()*(trainBud.getTrainingBudgetFrequency()*trainBud.getTrainingBudgetBatch()), "####") %>" size="10" disabled /></td>
                <td>
                    <select id="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_LOCATION_TYPE_ID]+"_"+i%>" name="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_LOCATION_TYPE_ID]%>_<%=i%>" style="padding:4px 7px">
                
                        <option value="0">-SELECT-</option>
                        <%
                        Vector listLocType = PstTrainingLocationType.list(0, 0, "", PstTrainingLocationType.fieldNames[PstTrainingLocationType.FLD_LOCATION_NAME]);
                        if (listLocType != null && listLocType.size()>0){
                            for(int j=0; j<listLocType.size(); j++){
                                TrainingLocationType trainingLocationType = (TrainingLocationType)listLocType.get(j);
                                if(trainingLocationType.getOID() == trainBud.getTrainingLocationTypeId()){
                                %>
                                <option value="<%=trainingLocationType.getOID()%>" selected="selected"><%= trainingLocationType.getLocationName() %></option>
                                <%
                                } else {
                                %>
                                <option value="<%=trainingLocationType.getOID()%>"><%= trainingLocationType.getLocationName() %></option>
                                <%
                                }
                            }
                        }
                        %>
                    </select>
                </td>
                <td>
                     <select id="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_AREA_ID]+"_"+i%>" name="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_AREA_ID]%>_<%=i%>" style="padding:4px 7px">
                
                        <option value="0">-SELECT-</option>
                        <%
                        Vector listArea = PstTrainingArea.list(0, 0, "", PstTrainingArea.fieldNames[PstTrainingArea.FLD_AREA_NAME]);
                        if (listArea != null && listArea.size()>0){
                            for(int j=0; j<listArea.size(); j++){
                                TrainingArea trainingArea = (TrainingArea)listArea.get(j);
                                if(trainingArea.getOID() == trainBud.getTrainingAreaId()){
                                    %>
                                    <option value="<%=trainingArea.getOID()%>" selected="selected"><%= trainingArea.getAreaName() %></option>
                                    <%    
                                }else{
                                %>
                                <option value="<%=trainingArea.getOID()%>"><%= trainingArea.getAreaName() %></option>
                                <%
                                }
                            }
                        }
                        %>
                    </select>
                </td>
                <td>
                    <textarea id="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_DESC]+"_"+i%>" name="<%=FrmTrainingBudget.fieldNames[FrmTrainingBudget.FRM_FIELD_TRAINING_BUDGET_DESC] %>_<%=i%>" class="formElemen" cols="37" rows="3"><%= trainBud.getTrainingBudgetDesc() %></textarea>
                </td>
            </tr>
            <%
        }
        %>
        </table>
        <div>&nbsp;</div>
        <div id="record_count">
            <%
            if (vectSize >= recordToGet){
                %>
                List : <%=start%> &HorizontalLine; <%= (start+recordToGet) %> | 
                <%
            }
            %>
            Total : <%= vectSize %>
            <input id="vectSize" type="hidden" style="padding:6px 7px" value="<%= vectSize %>" size="2" />
        </div>
        <div class="pagging">
            <a style="color:#F5F5F5" href="javascript:cmdListFirst('<%=start%>')" class="btn-small">First</a>
            <a style="color:#F5F5F5" href="javascript:cmdListPrev('<%=start%>')" class="btn-small">Previous</a>
            <a style="color:#F5F5F5" href="javascript:cmdListNext('<%=start%>')" class="btn-small">Next</a>
            <a style="color:#F5F5F5" href="javascript:cmdListLast('<%=start%>')" class="btn-small">Last</a>
        </div>
        <%
    } else {
        %>
        <div><%= alert %></div>
        <%
    }
        
%>
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

import com.dimata.harisma.entity.masterdata.Competency;
import com.dimata.harisma.entity.masterdata.Education;
import com.dimata.harisma.entity.masterdata.EmployeeCompetency;
import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PositionCompetencyRequired;
import com.dimata.harisma.entity.masterdata.PositionEducationRequired;
import com.dimata.harisma.entity.masterdata.PositionExperienceRequired;
import com.dimata.harisma.entity.masterdata.PositionTrainingRequired;
import com.dimata.harisma.entity.masterdata.PstCompetency;
import com.dimata.harisma.entity.masterdata.PstEducation;
import com.dimata.harisma.entity.masterdata.PstEmployeeCompetency;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.harisma.entity.masterdata.PstPositionCompetencyRequired;
import com.dimata.harisma.entity.masterdata.PstPositionEducationRequired;
import com.dimata.harisma.entity.masterdata.PstPositionExperienceRequired;
import com.dimata.harisma.entity.masterdata.PstPositionTrainingRequired;
import com.dimata.harisma.entity.masterdata.PstTraining;
import com.dimata.harisma.entity.masterdata.Training;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Dimata 007
 */
public class ViewGapEmployee {
    
    public String getCompetencyName(long oid){
        String str = "-";
        try {
            Competency comp = PstCompetency.fetchExc(oid);
            str = comp.getCompetencyName();
        } catch(Exception e){
            System.out.println("getCompetency = "+e.toString());
        }
        return str;
    }
    
    public String getTrainingName(long oid){
        String str = "-";
        try {
            Training training = PstTraining.fetchExc(oid);
            str = training.getName();
        } catch(Exception e){
            System.out.println("getTrainingName = "+e.toString());
        }
        return str;
    }
    
    public String getEducationName(long oid){
        String str = "-";
        try {
            Education edu = PstEducation.fetchExc(oid);
            str = edu.getEducation();
        } catch(Exception e){
            System.out.println("getEducationName = "+e.toString());
        }
        return str;
    }
    
    public String getPositionName(long oid){
        String str = "-";
        try {
            Position pos = PstPosition.fetchExc(oid);
            str = pos.getPosition();
        } catch(Exception e){
            System.out.println("getPositionName = "+e.toString());
        }
        return str;
    }
    
    
    public String drawGapEmployee(long employeeId){
        String html = "";
        String tempHtml = "";
        String whereClause = "";
        Employee employee = new Employee();
        Position position = new Position();
        if (employeeId != 0){
            try {
                /* Get Employee Data */
                employee = PstEmployee.fetchExc(employeeId);
                /* Get Position Data */
                position = PstPosition.fetchExc(employee.getPositionId());
                whereClause = PstPositionCompetencyRequired.fieldNames[PstPositionCompetencyRequired.FLD_POSITION_ID]+"="+employee.getPositionId();
                Vector listCompetency = PstPositionCompetencyRequired.list(0, 0, whereClause, "");
                whereClause = PstPositionTrainingRequired.fieldNames[PstPositionTrainingRequired.FLD_POSITION_ID]+"="+employee.getPositionId();
                Vector listTraining = PstPositionTrainingRequired.list(0, 0, whereClause, "");
                whereClause = PstPositionEducationRequired.fieldNames[PstPositionEducationRequired.FLD_POSITION_ID]+"="+employee.getPositionId();
                Vector listEducation = PstPositionEducationRequired.list(0, 0, whereClause, "");
                whereClause = PstPositionExperienceRequired.fieldNames[PstPositionExperienceRequired.FLD_POSITION_ID]+"="+employee.getPositionId();
                Vector listExperience = PstPositionExperienceRequired.list(0, 0, whereClause, "");
                whereClause = PstEmployeeCompetency.fieldNames[PstEmployeeCompetency.FLD_EMPLOYEE_ID]+"="+employeeId;
                Vector listEmpCompetency = PstEmployeeCompetency.list(0, 0, whereClause, "");
                whereClause = PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID]+"="+employeeId;
                Vector listEmpTraining = PstTrainingHistory.list(0, 0, whereClause, "");
                whereClause = PstEmpEducation.fieldNames[PstEmpEducation.FLD_EMPLOYEE_ID]+"="+employeeId;
                Vector listEmpEducation = PstEmpEducation.list(0, 0, whereClause, "");
                whereClause = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employeeId +" AND " + PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP] +"= 0";
                Vector listEmpExperience = PstCareerPath.list(0, 0, whereClause, "");
                
                html += "<h2>"+position.getPosition()+"</h2>";
                html += "<div class=\"title-part\">Competency</div>";
                html += "<table class=\"tblStyle\">";
                html += "<tr>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\" colspan=\"2\">Competency Required</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\" colspan=\"2\">Competency Employee</td>";
                html += "</tr>";
                html += "<tr>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Title</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Required</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Score</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Gap</td>";
                html += "</tr>";
                if (listCompetency != null && listCompetency.size()>0){
                    for (int i=0; i<listCompetency.size(); i++){
                        PositionCompetencyRequired posComp = (PositionCompetencyRequired)listCompetency.get(i);
                        html += "<tr>";
                        html += "<td>"+getCompetencyName(posComp.getCompetencyId())+"</td>";
                        html += "<td>"+posComp.getScoreReqRecommended()+"</td>";
                        if (listEmpCompetency != null && listEmpCompetency.size()>0){
                            for (int j=0; j<listEmpCompetency.size(); j++){
                                EmployeeCompetency empComp = (EmployeeCompetency)listEmpCompetency.get(j);
                                if (posComp.getCompetencyId()==empComp.getOID()){
                                    tempHtml  = "<td>"+empComp.getLevelValue()+"</td>";
                                    if (empComp.getLevelValue() >= posComp.getScoreReqRecommended()){
                                        tempHtml += "<td> 1 </td>";
                                    } else {
                                        tempHtml += "<td> 0 </td>";
                                    }

                                }
                            }
                            if (tempHtml.equals("")){
                                html += "<td>0</td>";
                                html += "<td>0</td>";
                            } else {
                                html += tempHtml;
                                tempHtml = "";
                            }
                        } else {
                            html += "<td>0</td>";
                            html += "<td>0</td>";
                        }

                        html += "</tr>";
                    }
                }
                html += "</table>";
                
                html += "<div class=\"title-part\">Training</div>";
                html += "<table class=\"tblStyle\">";
                html += "<tr>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\" colspan=\"2\">Training Required</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\" colspan=\"2\">Training Employee</td>";
                html += "</tr>";
                html += "<tr>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Title</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Required</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Score</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Gap</td>";
                html += "</tr>";
                if (listTraining != null && listTraining.size()>0){
                    for (int i=0; i<listTraining.size(); i++){
                        PositionTrainingRequired posTrain = (PositionTrainingRequired)listTraining.get(i);
                        html += "<tr>";
                        html += "<td>"+getTrainingName(posTrain.getTrainingId())+"</td>";
                        html += "<td>"+posTrain.getPointRecommended()+"</td>";
                        if (listEmpTraining != null && listEmpTraining.size()>0){
                            for (int j=0; j<listEmpTraining.size(); j++){
                                TrainingHistory empTrain = (TrainingHistory)listEmpTraining.get(j);
                                if (posTrain.getTrainingId()==empTrain.getTrainingId()){
                                    tempHtml  = "<td>"+empTrain.getPoint()+"</td>";
                                    if (empTrain.getPoint()>= posTrain.getPointRecommended()){
                                        tempHtml += "<td> 1 </td>";
                                    } else {
                                        tempHtml += "<td> 0 </td>";
                                    }
                                }
                            }
                            if (tempHtml.equals("")){
                                html += "<td>0</td>";
                                html += "<td>0</td>";
                            } else {
                                html += tempHtml;
                                tempHtml = "";
                            }
                        } else {
                            html += "<td>0</td>";
                            html += "<td>0</td>";
                        }

                        html += "</tr>";
                    }
                }
                html += "</table>";
                
                html += "<div class=\"title-part\">Education</div>";
                html += "<table class=\"tblStyle\">";
                html += "<tr>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\" colspan=\"2\">Education Required</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\" colspan=\"2\">Education Employee</td>";
                html += "</tr>";
                html += "<tr>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Title</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Required</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Score</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Gap</td>";
                html += "</tr>";
                if (listEducation != null && listEducation.size()>0){
                    for (int i=0; i<listEducation.size(); i++){
                        PositionEducationRequired posEdu = (PositionEducationRequired)listEducation.get(i);
                        html += "<tr>";
                        html += "<td>"+ getEducationName(posEdu.getEducationId()) +"</td>";
                        html += "<td>"+ posEdu.getPointRecommended() +"</td>";
                        if (listEmpEducation != null && listEmpEducation.size()>0){
                            for (int j=0; j<listEmpEducation.size(); j++){
                                EmpEducation empEdu = (EmpEducation)listEmpEducation.get(j);
                                if (posEdu.getEducationId()==empEdu.getEducationId()){
                                    tempHtml  = "<td>"+empEdu.getPoint()+"</td>";
                                    if (empEdu.getPoint()>= posEdu.getPointRecommended()){
                                        tempHtml += "<td> 1 </td>";
                                    } else {
                                        tempHtml += "<td> 0 </td>";
                                    }
                                    
                                }
                            }
                            if (tempHtml.equals("")){
                                html += "<td>0</td>";
                                html += "<td>0</td>";
                            } else {
                                html += tempHtml;
                                tempHtml = "";
                            }
                        } else {
                            html += "<td>0</td>";
                            html += "<td>0</td>";
                        }

                        html += "</tr>";
                    }
                }
                html += "</table>";
                
                html += "<div class=\"title-part\">Experience</div>";
                html += "<table class=\"tblStyle\">";
                html += "<tr>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\" colspan=\"2\">Experience Required</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\" colspan=\"2\">Experience Employee</td>";
                html += "</tr>";
                html += "<tr>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Title</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Required</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Duration</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Gap</td>";
                html += "</tr>";
                if (listExperience != null && listExperience.size()>0){
                    for (int i=0; i<listEducation.size(); i++){
                        PositionExperienceRequired posExp = (PositionExperienceRequired) listExperience.get(i);
                        html += "<tr>";
                        html += "<td>"+ getPositionName(posExp.getExperienceId()) +"</td>";
                        html += "<td>"+ posExp.getDurationRecommended()+" Tahun</td>";
                        if (listEmpExperience != null && listEmpExperience.size()>0){
                            Calendar calendar1 = Calendar.getInstance();
                            Calendar calendar2 = Calendar.getInstance();
                            double diffInYears = 0;
                            for (int j=0; j<listEmpExperience.size(); j++){
                                CareerPath cp = (CareerPath) listEmpExperience.get(j);
                                if (posExp.getExperienceId()==cp.getPositionId()){
                                Date workFrom =  cp.getWorkFrom();
                                Date workTo = cp.getWorkTo();
                                
                                calendar1.setTime(workFrom);
                                calendar2.setTime(workTo);
                                
                                long miliSecondForDate1 = calendar1.getTimeInMillis();
                                long miliSecondForDate2 = calendar2.getTimeInMillis();
                                
                                long diffInMilis = miliSecondForDate2 - miliSecondForDate1;
                                
                                double diffInDays = diffInMilis / (24 * 60 * 60 * 1000);
                                double diffInMonth = diffInDays / 30;
                                diffInYears = diffInYears + (diffInMonth /12);
                                }
                                
                            } if (diffInYears > 0){
                                double years = Math.round( diffInYears * 100.0 ) / 100.0;
                                tempHtml  = "<td>"+years+" Tahun</td>";
                                if (years >= posExp.getDurationRecommended()){
                                    tempHtml += "<td> 1 </td>";
                                } else {
                                    tempHtml += "<td> 0 </td>";
                                }
                            }
                            if (tempHtml.equals("")){
                                html += "<td>0</td>";
                                html += "<td>0</td>";
                            } else {
                                html += tempHtml;
                                tempHtml = "";
                            }
                            
                        } else {
                            html += "<td>0</td>";
                            html += "<td>0</td>";
                        }

                        html += "</tr>";
                    }
                    
                }
                
                html += "</table>";
            } catch(Exception e){
                System.out.println("Cant view employee gap :"+e.toString());
            }
        }
        
        return html;
    }
    
    public String drawGapTraining(long employeeId){
        String html = "";
        String tempHtml = "";
        String whereClause = "";
        Employee employee = new Employee();
        Position position = new Position();
        if (employeeId != 0){
            try {
                /* Get Employee Data */
                employee = PstEmployee.fetchExc(employeeId);
                /* Get Position Data */
                position = PstPosition.fetchExc(employee.getPositionId());
                whereClause = PstPositionCompetencyRequired.fieldNames[PstPositionCompetencyRequired.FLD_POSITION_ID]+"="+employee.getPositionId();
                Vector listCompetency = PstPositionCompetencyRequired.list(0, 0, whereClause, "");
                whereClause = PstPositionTrainingRequired.fieldNames[PstPositionTrainingRequired.FLD_POSITION_ID]+"="+employee.getPositionId();
                Vector listTraining = PstPositionTrainingRequired.list(0, 0, whereClause, "");
                whereClause = PstPositionEducationRequired.fieldNames[PstPositionEducationRequired.FLD_POSITION_ID]+"="+employee.getPositionId();
                Vector listEmpTraining = PstTrainingHistory.list(0, 0, whereClause, "");
                whereClause = PstEmpEducation.fieldNames[PstEmpEducation.FLD_EMPLOYEE_ID]+"="+employeeId;
                
                
                html += "<div class=\"title-part\">Training</div>";
                html += "<table class=\"tblStyle\">";
                html += "<tr>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\" colspan=\"2\">Training Required</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\" colspan=\"2\">Training Employee</td>";
                html += "</tr>";
                html += "<tr>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Title</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Required</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Score</td>";
                html += "<td class=\"title_tbl\" style=\"background-color:#DDD;\">Gap</td>";
                html += "</tr>";
                if (listTraining != null && listTraining.size()>0){
                    for (int i=0; i<listTraining.size(); i++){
                        PositionTrainingRequired posTrain = (PositionTrainingRequired)listTraining.get(i);
                        html += "<tr>";
                        html += "<td>"+getTrainingName(posTrain.getTrainingId())+"</td>";
                        html += "<td>"+posTrain.getPointRecommended()+"</td>";
                        if (listEmpTraining != null && listEmpTraining.size()>0){
                            for (int j=0; j<listEmpTraining.size(); j++){
                                TrainingHistory empTrain = (TrainingHistory)listEmpTraining.get(j);
                                if (posTrain.getTrainingId()==empTrain.getTrainingId()){
                                    tempHtml  = "<td>"+empTrain.getPoint()+"</td>";
                                    if (empTrain.getPoint()>= posTrain.getPointRecommended()){
                                        tempHtml += "<td> 1 </td>";
                                    } else {
                                        tempHtml += "<td> 0 </td>";
                                    }
                                }
                            }
                            if (tempHtml.equals("")){
                                html += "<td>-</td>";
                                html += "<td>0</td>";
                            } else {
                                html += tempHtml;
                                tempHtml = "";
                            }
                        } else {
                            html += "<td>-</td>";
                            html += "<td>0</td>";
                        }

                        html += "</tr>";
                    }
                }
                html += "</table>";
                
                
            } catch(Exception e){
                System.out.println("Cant view employee gap :"+e.toString());
            }
        }
        
        return html;
    }
}

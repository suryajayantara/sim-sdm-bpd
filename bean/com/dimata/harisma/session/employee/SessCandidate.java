/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.session.employee;

import com.dimata.harisma.entity.employee.CandidateGradeRequired;
import com.dimata.harisma.entity.employee.CandidateLocation;
import com.dimata.harisma.entity.employee.CandidatePositionAssessment;
import com.dimata.harisma.entity.employee.CandidatePositionCompetency;
import com.dimata.harisma.entity.employee.CandidatePositionEducation;
import com.dimata.harisma.entity.employee.CandidatePositionExperience;
import com.dimata.harisma.entity.employee.CandidatePositionTraining;
import com.dimata.harisma.entity.employee.EmpAssessment;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstCandidateGradeRequired;
import com.dimata.harisma.entity.employee.PstCandidateLocation;
import com.dimata.harisma.entity.employee.PstCandidateMain;
import com.dimata.harisma.entity.employee.PstCandidatePositionAssessment;
import com.dimata.harisma.entity.employee.PstCandidatePositionCompetency;
import com.dimata.harisma.entity.employee.PstCandidatePositionEducation;
import com.dimata.harisma.entity.employee.PstCandidatePositionExperience;
import com.dimata.harisma.entity.employee.PstCandidatePositionTraining;
import com.dimata.harisma.entity.employee.PstEmpAssessment;
import com.dimata.harisma.entity.employee.PstEmpEducation;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.employee.PstTrainingHistory;
import com.dimata.harisma.entity.masterdata.EmployeeCompetency;
import com.dimata.harisma.entity.masterdata.PstEmployeeCompetency;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author Kartika
 */
public class SessCandidate {
    public static int MBT_DAYS = 365;
    public static Vector<EmployeeCandidate> getCandidate(long oidCandidate, long positionId) {
        Vector candidateList = new Vector();
        String whereClause = "";
        String whereTraining = "";
        String whereEducation = "";
        String whereCompetency = "";
        String whereExperience = "";
		

        /* Experience List */
        whereClause = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector listExperiences = PstCandidatePositionExperience.list(0, 0, whereClause, "");
        if (listExperiences != null && listExperiences.size() > 0) {
            for (int i = 0; i < listExperiences.size(); i++) {
                CandidatePositionExperience experience = (CandidatePositionExperience) listExperiences.get(i);
                whereExperience = whereExperience + experience.getExperienceId() + ",";
            }
            whereExperience = whereExperience.substring(0, whereExperience.length() - 1);
        }

        /* Competency List */
        whereClause = PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector listCompetency = PstCandidatePositionCompetency.list(0, 0, whereClause, "");
        if (listCompetency != null && listCompetency.size() > 0) {
            for (int i = 0; i < listCompetency.size(); i++) {
                CandidatePositionCompetency competency = (CandidatePositionCompetency) listCompetency.get(i);
                whereCompetency = whereCompetency + competency.getCompetencyId() + ",";
            }
            whereCompetency = whereCompetency.substring(0, whereCompetency.length() - 1);
        }

        /* Training List */
        whereClause = PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector listTraining = PstCandidatePositionTraining.list(0, 0, whereClause, "");
        if (listTraining != null && listTraining.size() > 0) {
            for (int i = 0; i < listTraining.size(); i++) {
                CandidatePositionTraining train = (CandidatePositionTraining) listTraining.get(i);
                whereTraining = whereTraining + train.getTrainingId() + ",";
            }
            whereTraining = whereTraining.substring(0, whereTraining.length() - 1);
        }
        /* Education List */
        whereClause = PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector listEducation = PstCandidatePositionEducation.list(0, 0, whereClause, "");
        if (listEducation != null && listEducation.size() > 0) {
            for (int i = 0; i < listEducation.size(); i++) {
                CandidatePositionEducation education = (CandidatePositionEducation) listEducation.get(i);
                whereEducation = whereEducation + education.getEducationId() + ",";
            }
            whereEducation = whereEducation.substring(0, whereEducation.length() - 1);
        }
        /* Key Performa Indicator */
        /* Sumber Pencarian */
        /*
         * code = 0 (candidate location)
         * code = 1 (sumber pencarian)
         */
        whereClause = PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        whereClause += " AND " + PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CODE] + "=1";
        Vector candidateLocList = PstCandidateLocation.list(0, 0, whereClause, "");
        String whereLocation = "";
        if (candidateLocList != null && candidateLocList.size() > 0) {
            for (int i = 0; i < candidateLocList.size(); i++) {
                CandidateLocation location = (CandidateLocation) candidateLocList.get(i);
                whereLocation = whereLocation + location.getDivisionId() + ",";
            }
            whereLocation = whereLocation.substring(0, whereLocation.length() - 1);
        } else {
            whereClause = "";
        }
        Vector empTraining = new Vector();
        Vector employeeList = PstEmployee.list(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
        String whereEmployee = "";
        /* mencari employee di databank */
        if (employeeList != null && employeeList.size() > 0) {
            for (int i = 0; i < employeeList.size(); i++) {
                Employee emp = (Employee) employeeList.get(i);
                whereEmployee = whereEmployee + emp.getOID() + ",";
            }
            whereEmployee = whereEmployee.substring(0, whereEmployee.length() - 1);
            whereClause = PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID] + " IN (" + whereEmployee + ")";
            whereClause += " AND " + PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_ID] + " IN (" + whereTraining + ")";
            empTraining = PstTrainingHistory.listDistinct(0, 0, whereClause, "");
        }
        Vector empFilterEdu = new Vector();
        whereEmployee = "";
        if (empTraining != null && empTraining.size() > 0) {
            for (int i = 0; i < empTraining.size(); i++) {
                Long empTrain = (Long) empTraining.get(i);
                whereEmployee = whereEmployee + empTrain + ",";
            }
            whereEmployee = whereEmployee.substring(0, whereEmployee.length() - 1);
            whereClause = PstEmpEducation.fieldNames[PstEmpEducation.FLD_EMPLOYEE_ID] + " IN (" + whereEmployee + ")";
            whereClause += " AND " + PstEmpEducation.fieldNames[PstEmpEducation.FLD_EDUCATION_ID] + " IN (" + whereEducation + ")";
            empFilterEdu = PstEmpEducation.listDistinct(0, 0, whereClause, "");
        }

        return candidateList;

    }

    public static Vector<EmployeeCandidate> queryCandidate(long oidCandidate, long positionId, SessCandidateParam parameters) {
        String whereClause = "";
        //String whereTraining = "";
        String whereEducation = "";
        //String whereCompetency = "";
        String whereAssessment = "";
        String whereExperience = "";
        String whereExperienceLevel = "";
        String whereGradeReq = "";
        String whereEmployeeStatus = "";
        
		/* Get Total Pembobotan untuk kompetensi */
		int totalBobotCompetency = PstCandidatePositionCompetency.getTotalBobot(oidCandidate);
                int totalBobotAssessment = PstCandidatePositionAssessment.getTotalBobot(oidCandidate);
		
        if(parameters!=null ) { 
          if(parameters.isEmployeeStatusActiv())  
            whereEmployeeStatus =  " (" + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = 0 ) " ;
          
          if(parameters.isEmployeeStatusResigned())  
            whereEmployeeStatus =  ( ( whereEmployeeStatus.length() > 0  ) ? " OR " : "" ) + " (" + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = 1) " ;
          
          if(parameters.isEmployeeStatusMBT())  
            whereEmployeeStatus =  ( ( whereEmployeeStatus.length() > 0  ) ? " OR " : "" ) + " ( (" + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = 0) AND ( DATEDIFF( NOW(),"
                 + PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE] + ") < " +  MBT_DAYS + " ) ) "    ;
          
          
        }
        
        
        /* Grade Level List */
        whereClause = PstCandidateGradeRequired.fieldNames[PstCandidateGradeRequired.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector listGradeRequired = PstCandidateGradeRequired.listInnerJoin(whereClause);
        if (listGradeRequired != null && listGradeRequired.size() > 0) {
            whereGradeReq = "( ";
            for (int i = 0; i < listGradeRequired.size(); i++) {
                CandidateGradeRequired grade = (CandidateGradeRequired) listGradeRequired.get(i);
                whereGradeReq = whereGradeReq + "( gl.GRADE_RANK >=" + grade.getGradeMinimum().getGradeRank()
                        + " AND gl.GRADE_RANK <= " + grade.getGradeMaximum().getGradeRank() + " ) "
                        + ((i + 1) < listGradeRequired.size() ? " OR " : " )");
            }
        }

        /* Experience List */
		double experienceMin = 0.0;
        whereClause = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate
					+" AND "+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]+"=0";
        Vector listExperiences = PstCandidatePositionExperience.list(0, 0, whereClause, "");
        if (listExperiences != null && listExperiences.size() > 0) {
            for (int i = 0; i < listExperiences.size(); i++) {
                CandidatePositionExperience experience = (CandidatePositionExperience) listExperiences.get(i);
                whereExperience = whereExperience + experience.getExperienceId() + ",";
				experienceMin = experienceMin + experience.getDurationMin();
            }
			whereExperience = whereExperience.substring(0, whereExperience.length() - 1);
        }
		
		/* Experience Level List */
		double experienceLevelMin = 0.0;
        whereClause = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate
					+" AND "+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]+"=1";
        Vector listExperiencesLevel = PstCandidatePositionExperience.list(0, 0, whereClause, "");
        if (listExperiencesLevel != null && listExperiencesLevel.size() > 0) {
            for (int i = 0; i < listExperiencesLevel.size(); i++) {
                CandidatePositionExperience experience = (CandidatePositionExperience) listExperiencesLevel.get(i);
                whereExperienceLevel = whereExperienceLevel + experience.getExperienceId() + ",";
				experienceLevelMin = experienceLevelMin + experience.getDurationMin();
            }
			whereExperienceLevel = whereExperienceLevel.substring(0, whereExperienceLevel.length() - 1);
        }

        /* Competency List */
        /*whereClause = PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector listCompetency = PstCandidatePositionCompetency.list(0, 0, whereClause, "");
        if (listCompetency != null && listCompetency.size() > 0) {
            for (int i = 0; i < listCompetency.size(); i++) {
                CandidatePositionCompetency competency = (CandidatePositionCompetency) listCompetency.get(i);
                whereCompetency = whereCompetency + competency.getCompetencyId() + ",";
            }
            whereCompetency = whereCompetency.substring(0, whereCompetency.length() - 1);
        }*/
        
        /* Assessment List */
        whereClause = PstCandidatePositionAssessment.fieldNames[PstCandidatePositionCompetency.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector listAssessment = PstCandidatePositionAssessment.list(0, 0, whereClause, "");
        String whereHc = "";
        if (listAssessment != null && listAssessment.size() > 0) {
            for (int i = 0; i < listAssessment.size(); i++) {
                CandidatePositionAssessment assessment = (CandidatePositionAssessment) listAssessment.get(i);
                if (i == 0){
                    whereAssessment += " ((hr_emp_assessment.ASSESSMENT_ID = '"+assessment.getAssessmentId()+"' AND hr_emp_assessment.DATE_OF_ASSESSMENT LIKE '%"+assessment.getTahun()+"%') ";
                    whereHc += " ((hc.ASSESSMENT_ID = '"+assessment.getAssessmentId()+"' AND hc.DATE_OF_ASSESSMENT LIKE '%"+assessment.getTahun()+"%') ";
                } else {
                    whereAssessment += " OR (hr_emp_assessment.ASSESSMENT_ID = '"+assessment.getAssessmentId()+"' AND hr_emp_assessment.DATE_OF_ASSESSMENT LIKE '%"+assessment.getTahun()+"%') ";
                    whereHc += " OR (hc.ASSESSMENT_ID = '"+assessment.getAssessmentId()+"' AND hc.DATE_OF_ASSESSMENT LIKE '%"+assessment.getTahun()+"%') ";
                }
            }
            whereAssessment += ")";
            whereHc += ")";
        }

        /* Training List */
        /*whereClause = PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector listTraining = PstCandidatePositionTraining.list(0, 0, whereClause, "");
        if (listTraining != null && listTraining.size() > 0) {
            for (int i = 0; i < listTraining.size(); i++) {
                CandidatePositionTraining train = (CandidatePositionTraining) listTraining.get(i);
                whereTraining = whereTraining + train.getTrainingId() + ",";
            }
            whereTraining = whereTraining.substring(0, whereTraining.length() - 1);
        }*/
        /* Education List */
        whereClause = PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector listEducation = PstCandidatePositionEducation.list(0, 0, whereClause, "");
        if (listEducation != null && listEducation.size() > 0) {
            for (int i = 0; i < listEducation.size(); i++) {
                CandidatePositionEducation education = (CandidatePositionEducation) listEducation.get(i);
                whereEducation = whereEducation + education.getEducationId() + ",";
            }
            whereEducation = whereEducation.substring(0, whereEducation.length() - 1);
        }
        /* Key Performa Indicator */
        /* Sumber Pencarian */
        /*
         * code = 0 (candidate location)
         * code = 1 (sumber pencarian)
         */
        whereClause = PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        whereClause += " AND " + PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CODE] + "=1";
        Vector candidateLocList = PstCandidateLocation.list(0, 0, whereClause, "");
        String whereLocation = "";
        if (candidateLocList != null && candidateLocList.size() > 0) {
            for (int i = 0; i < candidateLocList.size(); i++) {
                CandidateLocation location = (CandidateLocation) candidateLocList.get(i);
                whereLocation = whereLocation + location.getDivisionId() + ",";
            }
            whereLocation = whereLocation.substring(0, whereLocation.length() - 1);
        } else {
            whereClause = "";
        }

        /*
         String whereEmployee = "";
         Vector empTraining = new Vector();
         Vector employeeList = PstEmployee.list(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
         // mencari employee di databank
         if (employeeList != null && employeeList.size() > 0) {
         for (int i = 0; i < employeeList.size(); i++) {
         Employee emp = (Employee) employeeList.get(i);
         whereEmployee = whereEmployee + emp.getOID() + ",";
         }
         whereEmployee = whereEmployee.substring(0, whereEmployee.length()-1);
         whereClause = PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID] +" IN ("+whereEmployee+")";
         whereClause += " AND "+PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_ID]+" IN ("+whereTraining+")";
         empTraining = PstTrainingHistory.listDistinct(0, 0, whereClause, "");
         }
    
         Vector empFilterEdu = new Vector();
         whereEmployee = "";
         if (empTraining != null && empTraining.size()>0){
         for (int i=0; i<empTraining .size(); i++){
         Long empTrain = (Long)empTraining .get(i);
         whereEmployee = whereEmployee + empTrain + ",";
         }
         whereEmployee = whereEmployee.substring(0, whereEmployee.length()-1);
         whereClause = PstEmpEducation.fieldNames[PstEmpEducation.FLD_EMPLOYEE_ID]+" IN ("+whereEmployee+")";
         whereClause += " AND "+PstEmpEducation.fieldNames[PstEmpEducation.FLD_EDUCATION_ID]+" IN ("+whereEducation+")";
         empFilterEdu = PstEmpEducation.listDistinct(0, 0, whereClause, "");
         }
         */
        /*Hashtable<String, Float> listEmpComp = null;
        if(whereCompetency != null && whereCompetency.length() > 0) {
            String sqlEmp = " SELECT he.employee_id FROM hr_employee he inner join hr_grade_level gl "
                    + " on gl.GRADE_LEVEL_ID = he.GRADE_LEVEL_ID where "
                    + ((whereLocation != null && whereLocation.length() > 0) ? ("he.DIVISION_ID IN(" + whereLocation + ") ") : "(1=1) ")
                    + ((whereGradeReq != null && whereGradeReq.length() > 0) ? " AND (" + whereGradeReq + " ) " : " AND (1=1) ");

            listEmpComp = PstEmployeeCompetency.listSumEmpCompetency(0, 10000, "hr_view_emp_competency."
                    + PstEmployeeCompetency.fieldNames[PstEmployeeCompetency.FLD_COMPETENCY_ID] + " IN (" + whereCompetency + ") "
                    + " AND REQ." + PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_POSITION_ID] + "=" + positionId
                    + " AND employee_id IN (" + sqlEmp + " ) ", " SUM_COMP DESC  ");
        }*/
        
        /*Hashtable<String, Float> listEmpAss = null;
        if(whereAssessment != null && whereAssessment.length() > 0) {
            String sqlEmp = " SELECT he.employee_id FROM hr_employee he inner join hr_grade_level gl "
                    + " on gl.GRADE_LEVEL_ID = he.GRADE_LEVEL_ID where "
                    + ((whereLocation != null && whereLocation.length() > 0) ? ("he.DIVISION_ID IN(" + whereLocation + ") ") : "(1=1) ")
                    + ((whereGradeReq != null && whereGradeReq.length() > 0) ? " AND (" + whereGradeReq + " ) " : " AND (1=1) ");

            listEmpAss = PstEmpAssessment.listSumEmpAssessment(0, 10000, "hr_view_emp_assessment."
                    + PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_ASSESSMENT_ID] + " IN (" + whereAssessment + ") "
                    + " AND REQ." + PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_POSITION_ID] + "=" + positionId
                    + " AND employee_id IN (" + sqlEmp + " ) ", " SUM_ASS DESC  ");
        }*/
        
        Vector<EmployeeCandidate> lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql
                    = " select he.company_id, cp.COMPANY, he.employee_id,he.EMPLOYEE_NUM, he.FULL_NAME, he.COMMENCING_DATE, dv.division_id,  dv.DIVISION, "
                    + " dep.department_id, dep.DEPARTMENT, sec.SECTION , he.SECTION_ID , "
                    + " he.POSITION_ID, ps.POSITION, gl.GRADE_CODE, gl.GRADE_RANK, "
					+ "((DATEDIFF(CURRENT_DATE() , he.COMMENCING_DATE))/30 ) AS LOS ,"
					+ "  (((DATEDIFF(CURRENT_DATE() , he.COMMENCING_DATE))/30 ) - (DATEDIFF(CURRENT_DATE(),vwh.MAX_HIS_WT)/30 )) AS WORKHIS , ";
					if (whereExperience != null && whereExperience.length() > 0){
						sql+= " (SELECT SUM(DATEDIFF(WORK_TO, WORK_FROM) / 30) "
									+ "FROM hr_view_work_history_now WHERE (HISTORY_GROUP = 0 OR WORK_HISTORY_NOW_ID = 0) "
									+ "AND employee_id = he.EMPLOYEE_ID AND position_id IN ("+whereExperience+")) AS CURPOSITION, ";
					} else {
						sql += " 0 AS CURPOSITION,";
					}
					if (totalBobotAssessment>0){
						if (whereExperienceLevel != null && whereExperienceLevel.length() > 0){
							sql+= " ((SELECT SUM(DATEDIFF(WORK_TO, WORK_FROM) / 30) "
									+ "FROM hr_view_work_history_now WHERE (HISTORY_GROUP = 0 OR WORK_HISTORY_NOW_ID = 0) "
									+ "AND employee_id = he.EMPLOYEE_ID AND level_id IN ("+whereExperienceLevel+")) * ("+(100-totalBobotAssessment)+"/100)) AS CURPOS, ";
						} else if (whereExperience != null && whereExperience.length() > 0){
							sql+= " ((SELECT SUM(DATEDIFF(WORK_TO, WORK_FROM) / 30) "
									+ "FROM hr_view_work_history_now WHERE (HISTORY_GROUP = 0 OR WORK_HISTORY_NOW_ID = 0) "
									+ "AND employee_id = he.EMPLOYEE_ID AND position_id IN ("+whereExperience+")) * ("+(100-totalBobotAssessment)+"/100)) AS CURPOS, ";
						} else {
								sql += " 0 AS CURPOS,";
						}
					} else {
						if (whereExperienceLevel != null && whereExperienceLevel.length() > 0){
							sql+= " (SELECT SUM(DATEDIFF(WORK_TO, WORK_FROM) / 30) "
									+ "FROM hr_view_work_history_now WHERE (HISTORY_GROUP = 0 OR WORK_HISTORY_NOW_ID = 0) "
									+ "AND employee_id = he.EMPLOYEE_ID AND level_id IN ("+whereExperienceLevel+")) AS CURPOS, ";
						} else if (whereExperience != null && whereExperience.length() > 0){
							//sql+= " (DATEDIFF(CURRENT_DATE(),vwh.MAX_HIS_WT)/30 ) AS CURPOS, ";
							sql+= " (SELECT SUM(DATEDIFF(WORK_TO, WORK_FROM) / 30) "
									+ "FROM hr_view_work_history_now WHERE (HISTORY_GROUP = 0 OR WORK_HISTORY_NOW_ID = 0) "
									+ "AND employee_id = he.EMPLOYEE_ID AND position_id IN ("+whereExperience+")) AS CURPOS, ";
						} else {
								sql += " 0 AS CURPOS,";
						}
					}
					
					if (whereExperienceLevel != null && whereExperienceLevel.length() > 0){
							sql+=  "(SELECT SUM(DATEDIFF(WORK_TO, WORK_FROM) / 30) "
									+ "FROM hr_view_work_history_now WHERE (HISTORY_GROUP = 0 OR WORK_HISTORY_NOW_ID = 0) "
									+ "AND employee_id = he.EMPLOYEE_ID AND level_id IN ("+whereExperienceLevel+")) AS CURPOSORIGIN, ";
						} else {
							sql+= "(DATEDIFF(CURRENT_DATE(),vwh.MAX_HIS_WT)/30 ) * ("+(100-totalBobotAssessment)+"/100) AS CURPOSORIGIN,";
						}
							
					/*if (whereCompetency != null && whereCompetency.length() > 0){
							sql+= "(SELECT SUM(IF(req.BOBOT > 0, ( req.BOBOT / 100 ) * LEVEL_VALUE , LEVEL_VALUE)) AS SUM_COMPTCY_SCORE FROM hr_view_emp_competency "
						+ "LEFT JOIN hr_candidate_position_competency req "
						+ "ON hr_view_emp_competency.COMPETENCY_ID = req.COMPETENCY_ID "
						+ " WHERE hr_view_emp_competency.COMPETENCY_ID IN ("+whereCompetency+") "
						+ " AND hr_view_emp_competency.LEVEL_VALUE >= req.SCORE_MIN "
						+ " AND req.POSITION_ID = "+positionId
						+ " AND req.CANDIDATE_MAIN_ID = "+oidCandidate
						+" AND employee_id = he.employee_id) AS SUM_COMPTCY_SCORE, ";
					} else {
						sql+= " 0 AS SUM_COMPTCY_SCORE,";
					}*/
                                        
                                        if (whereAssessment != null && whereAssessment.length() > 0){
							sql+= "(SELECT SUM(IF(req.BOBOT > 0, ( req.BOBOT / 100 ) * SCORE , SCORE)) AS SUM_ASS_SCORE FROM hr_emp_assessment "
						+ "LEFT JOIN hr_candidate_position_assessment req "
						+ "ON hr_emp_assessment.ASSESSMENT_ID = req.ASSESSMENT_ID "
						+ " WHERE "+whereAssessment+" "
						+ " AND hr_emp_assessment.SCORE >= req.SCORE_MIN "
						+ " AND req.POSITION_ID = "+positionId
						+ " AND req.CANDIDATE_MAIN_ID = "+oidCandidate
						+" AND employee_id = he.employee_id) AS SUM_ASS_SCORE, ";
					} else {
						sql+= " 0 AS SUM_ASS_SCORE,";
					}
							
							
					if (whereEducation != null && whereEducation.length()>0){
						sql+= "(SELECT SUM(SCORE) FROM view_employee_edu_score WHERE employee_id = he.employee_id AND education_id IN ("+whereEducation+")) AS EDUSCORE,"
						//+ " SUM(hc.LEVEL_VALUE) AS SUM_COMPTCY_SCORE, "
						+ " escr.EDUCATION , "
						//+ "escr.SCORE AS EDUSCORE, "
						+ "MAX(escr.EDULEVEL) as EDULEVEL,  ";
					} else {
						sql += " 0 EDUSCORE, escr.EDUCATION , MAX(escr.EDULEVEL) as EDULEVEL, ";
					}
					
					/*if (whereCompetency != null && whereCompetency.length() > 0){
						sql += "("
						+ "(SELECT SUM(IF(req.BOBOT > 0, ( req.BOBOT / 100 ) * LEVEL_VALUE , LEVEL_VALUE)) AS SUM_COMPTCY_SCORE FROM hr_view_emp_competency "
						+ "LEFT JOIN hr_candidate_position_competency req "
						+ "ON hr_view_emp_competency.COMPETENCY_ID = req.COMPETENCY_ID "
						+ " WHERE hr_view_emp_competency.COMPETENCY_ID IN ("+whereCompetency+") "
						+ " AND hr_view_emp_competency.LEVEL_VALUE >= req.SCORE_MIN "
						+ "AND req.POSITION_ID = "+positionId
						+ " AND req.CANDIDATE_MAIN_ID = "+oidCandidate
						+" AND employee_id = he.employee_id)";
					} else {
						sql += " 0 ";
					}*/
                                        
                                        
                                        if (whereAssessment != null && whereAssessment.length() > 0){
						sql += "("
						+ "(SELECT SUM(IF(req.BOBOT > 0, ( req.BOBOT / 100 ) * SCORE , SCORE)) AS SUM_ASS_SCORE FROM hr_emp_assessment "
						+ "LEFT JOIN hr_candidate_position_assessment req "
						+ "ON hr_emp_assessment.ASSESSMENT_ID = req.ASSESSMENT_ID "
						+ " WHERE "+whereAssessment+" "
						+ " AND hr_emp_assessment.SCORE >= req.SCORE_MIN "
						+ "AND req.POSITION_ID = "+positionId
						+ " AND req.CANDIDATE_MAIN_ID = "+oidCandidate
						+" AND employee_id = he.employee_id)";
					} else {
						sql += " 0 ";
					}
					
					
					sql += " + ";
					
					if (whereEducation != null && whereEducation.length()>0){
						sql += "(SELECT SUM(SCORE) FROM view_employee_edu_score WHERE employee_id = he.employee_id AND education_id IN ("+whereEducation+")) ";
					} else {
						sql += " 0 ";
					}
					
					sql += " + ";
					
					if (totalBobotAssessment>0){
						if (whereExperienceLevel != null && whereExperienceLevel.length() > 0){
							sql+= " ((SELECT SUM(DATEDIFF(WORK_TO, WORK_FROM) / 30) "
									+ "FROM hr_view_work_history_now WHERE (HISTORY_GROUP = 0 OR WORK_HISTORY_NOW_ID = 0) "
									+ "AND employee_id = he.EMPLOYEE_ID AND level_id IN ("+whereExperienceLevel+")) * ("+(100-totalBobotAssessment)+"/100)) )";
						} else {
							//sql+= " ((DATEDIFF(CURRENT_DATE(),vwh.MAX_HIS_WT)/30 ) * ("+(100-totalBobotAssessment)+"/100)) ";
							sql+= " ((SELECT SUM(DATEDIFF(WORK_TO, WORK_FROM) / 30) "
									+ "FROM hr_view_work_history_now WHERE (HISTORY_GROUP = 0 OR WORK_HISTORY_NOW_ID = 0) "
									+ "AND employee_id = he.EMPLOYEE_ID AND position_id IN ("+whereExperience+")) * ("+(100-totalBobotAssessment)+"/100)) )";
						}
					} else {
						sql += " 0 )";
					}
							
							
                    sql += " AS TOTAL  from hr_employee he "
                    + " inner join pay_general cp on cp.GEN_ID = he.COMPANY_ID "
                    + " inner join hr_division dv on dv.DIVISION_ID = he.DIVISION_ID "
                    + " inner join hr_department dep on dep.DEPARTMENT_ID = he.DEPARTMENT_ID "
                    + " LEFT join hr_section sec on sec.SECTION_ID = he.SECTION_ID  "
                    + " inner join hr_position ps on ps.POSITION_ID= he.POSITION_ID "
                    + " inner join hr_work_history_now wh on wh.EMPLOYEE_ID =  he.EMPLOYEE_ID  "
                    + " LEFT JOIN hr_view_max_emp_work_history vwh ON vwh.EMPLOYEE_ID = he.EMPLOYEE_ID "
                    + " inner join hr_training_history th on th.EMPLOYEE_ID =  he.EMPLOYEE_ID  "
                    + " inner join hr_emp_assessment hc on hc.EMPLOYEE_ID =  he.EMPLOYEE_ID  "
                    + " inner join hr_emp_education ed on ed.EMPLOYEE_ID =  he.EMPLOYEE_ID  "
                    + " inner join hr_grade_level gl on gl.GRADE_LEVEL_ID = he.GRADE_LEVEL_ID "
                    + " inner join view_employee_edu_score escr ON escr.EMPLOYEE_ID =   he.EMPLOYEE_ID  "
                    + " where " + ((whereLocation != null && whereLocation.length() > 0) ? ("he.DIVISION_ID IN(" + whereLocation + ") ") : "(1=1) ")
                    + ((whereGradeReq != null && whereGradeReq.length() > 0) ? " AND (" +whereGradeReq + " ) " : " AND (1=1) ") + ((whereEmployeeStatus != null && whereEmployeeStatus.length() > 0) ? " AND (" +whereEmployeeStatus + " ) " : " AND (1=1) ")  
                    + (whereExperience != null && whereExperience.length() > 0 ? " AND ( /* experiency  or current position*/ wh.POSITION_ID IN ( " + whereExperience + " ) OR he.POSITION_ID IN (" + whereExperience + ") )  " : " AND (1=1) ")
					//+ (whereTraining != null && whereTraining.length() > 0 ? " AND th.TRAINING_ID IN (/* training */ " + whereTraining + ") " : " AND (1=1) ")
					+ (whereExperienceLevel != null && whereExperienceLevel.length() > 0 ? " AND ( /* experiency  or current level*/ wh.LEVEL_ID IN ( " + whereExperienceLevel + " ) OR he.LEVEL_ID IN (" + whereExperienceLevel + ") )  " : " AND (1=1) ")
                    + (whereHc != null && whereHc.length() > 0 ? (" AND " + whereHc +" ") : " AND (1=1) ")
                    + (whereEducation != null && whereEducation.length() > 0 ? (" AND ed.EDUCATION_ID IN  /*education */ ("+whereEducation+")   ") : " AND (1=1)")
                    + (parameters.getEmployeePositionType()> 0 ? " AND ps.`POSITION_TYPE_ID` = " + parameters.getEmployeePositionType(): "")
                    + " GROUP BY he.EMPLOYEE_ID, escr.EDULEVEL  "
                    + "ORDER BY TOTAL DESC, gl.GRADE_RANK DESC, ((DATEDIFF(CURRENT_DATE() , he.COMMENCING_DATE))/30 ) DESC,  escr.EDULEVEL DESC, escr.SCORE DESC ";
            Hashtable<String, EmployeeCandidate > tblList = new Hashtable(); 
            Hashtable<String, Integer> tblIndex = new Hashtable();             
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            long prevEmployeeId = 0;
            while (rs.next()) {
                EmployeeCandidate candidate = new EmployeeCandidate();
                long emplOid = rs.getLong("employee_id");
                if(tblList != null){
                    EmployeeCandidate tempCandidate = tblList.get(""+emplOid);
                    if( tempCandidate!=null) {
                        int newEduLevel = rs.getInt("EDULEVEL");
                        if(newEduLevel < tempCandidate.getEducationLevel()){
                            continue;
                        } else{
                            tempCandidate.setEmployeeId(0);
                        }
                    }
                }
                if (prevEmployeeId != emplOid) { // get only most highgest level ojf employee
					
					double currPosOrigin = rs.getFloat("CURPOSORIGIN");
					
                    candidate.setCompanyId(rs.getLong("company_id"));
                    candidate.setCompany(rs.getString("COMPANY"));
                    candidate.setEmployeeId(rs.getLong("employee_id"));
                    candidate.setFullName(rs.getString("FULL_NAME"));
                    candidate.setPayrollNumber(rs.getString("EMPLOYEE_NUM"));
                    candidate.setCommecingDate(rs.getDate("COMMENCING_DATE"));
                    candidate.setDivisionId(rs.getLong("division_id"));
                    candidate.setDivision(rs.getString("DIVISION"));
                    candidate.setDepartmentId(rs.getLong("department_id"));
                    candidate.setDepartment(rs.getString("DEPARTMENT"));
                    candidate.setSectionId(rs.getLong("SECTION_ID"));
                    candidate.setSection(rs.getString("SECTION"));
                    candidate.setCurrPositionId(rs.getLong("POSITION_ID"));
                    candidate.setCurrPosition(rs.getString("POSITION"));
                    candidate.setGradeCode(rs.getString("GRADE_CODE"));
                    candidate.setGradeRank(rs.getInt("GRADE_RANK"));
                    candidate.setLengthOfService(rs.getFloat("LOS"));
                    candidate.setWorkHistoryLength(rs.getFloat("WORKHIS"));
                    candidate.setCurrentPosLength(rs.getFloat("CURPOS"));
					candidate.setPositionLength(rs.getFloat("CURPOSITION"));
                    candidate.setSumCompetencyScore(rs.getFloat("SUM_ASS_SCORE"));
                    candidate.setEducationCode(rs.getString("EDUCATION"));
                    candidate.setEducationScore(rs.getFloat("EDUSCORE"));
                    candidate.setEducationLevel(rs.getInt("EDULEVEL"));
					candidate.setTotal(rs.getFloat("TOTAL"));
					if (whereAssessment != null && whereAssessment.length() > 0 ){
						if (listAssessment != null && listAssessment.size() > 0) {
							boolean isTrue = false;
							for (int i = 0; i < listAssessment.size(); i++) {
								CandidatePositionAssessment assessment = (CandidatePositionAssessment) listAssessment.get(i);
								double assEmpVal = getAssessmentEmp(candidate.getEmployeeId(), assessment.getAssessmentId());
								double skorReq = assessment.getScoreMin();
								if (assEmpVal < skorReq){
									isTrue = true;
								}
							}
							if (isTrue){
								continue;
							}
						}
					}
					if (whereExperienceLevel != null && whereExperienceLevel.length() > 0){
						if (currPosOrigin < experienceLevelMin){
							continue;
						}
					}
					if (whereExperience != null && whereExperience.length() > 0){
						if (candidate.getPositionLength()< experienceMin){
							continue;
						}
					}
                    lists.add(candidate); 
                    tblList.put(""+candidate.getEmployeeId(), candidate);
                    tblIndex.put(""+candidate.getEmployeeId(), new Integer (lists.size()-1));
                    prevEmployeeId = emplOid;
                }
            }
            rs.close();
            
            if(lists!=null && lists.size()>0){
                for(int idx =0 ; idx < lists.size();idx++){
                    EmployeeCandidate candidate = lists.get(idx);
                    if(candidate.getEmployeeId()== 0){ 
                        lists.remove(idx);
                        idx=idx-1;
                    }
                }
            }
            
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }

        return lists;

    }
    
    public static Vector<EmployeeCandidate> queryCandidateV2(long oidCandidate, long positionId, SessCandidateParam parameters) {
        String whereClause = "";
        //String whereTraining = "";
        String whereEducation = "";
        //String whereCompetency = "";
        String whereAssessment = "";
        String whereExperience = "";
        String whereExperienceLevel = "";
        String whereGradeReq = "";
        String whereEmployeeStatus = "";
        
        /* Get Total Pembobotan untuk kompetensi */
        int totalBobotCompetency = PstCandidatePositionCompetency.getTotalBobot(oidCandidate);
        int totalBobotAssessment = PstCandidatePositionAssessment.getTotalBobot(oidCandidate);
		
        if(parameters!=null ) { 
          if(parameters.isEmployeeStatusActiv())  
            whereEmployeeStatus =  " (" + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = 0 ) " ;
          
          if(parameters.isEmployeeStatusResigned())  
            whereEmployeeStatus =  ( ( whereEmployeeStatus.length() > 0  ) ? " OR " : "" ) + " (" + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = 1) " ;
          
          if(parameters.isEmployeeStatusMBT())  
            whereEmployeeStatus =  ( ( whereEmployeeStatus.length() > 0  ) ? " OR " : "" ) + " ( (" + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = 0) AND ( DATEDIFF( NOW(),"
                 + PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE] + ") < " +  MBT_DAYS + " ) ) "    ;
          
          
        }
        
        
        whereClause = PstCandidateGradeRequired.fieldNames[PstCandidateGradeRequired.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector listGradeRequired = PstCandidateGradeRequired.listInnerJoin(whereClause);
        if (listGradeRequired != null && listGradeRequired.size() > 0) {
            whereGradeReq = "( ";
            for (int i = 0; i < listGradeRequired.size(); i++) {
                CandidateGradeRequired grade = (CandidateGradeRequired) listGradeRequired.get(i);
                whereGradeReq = whereGradeReq + "( gl.GRADE_RANK >=" + grade.getGradeMinimum().getGradeRank()
                        + " AND gl.GRADE_RANK <= " + grade.getGradeMaximum().getGradeRank() + " ) "
                        + ((i + 1) < listGradeRequired.size() ? " OR " : " )");
            }
        }
        
        /* Grade Level List */
        String whereClauseGradeAnd = PstCandidateGradeRequired.fieldNames[PstCandidateGradeRequired.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate
                +" AND "+PstCandidateGradeRequired.fieldNames[PstCandidateGradeRequired.FLD_KONDISI]+"="+PstCandidateMain.KONDISI_AND;
        String whereClauseGradeOr = PstCandidateGradeRequired.fieldNames[PstCandidateGradeRequired.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate
                +" AND "+PstCandidateGradeRequired.fieldNames[PstCandidateGradeRequired.FLD_KONDISI]+"="+PstCandidateMain.KONDISI_OR;
        Vector listGradeRequiredAnd = PstCandidateGradeRequired.list(0, 0, whereClauseGradeAnd, "");
        Vector listGradeRequiredOr = PstCandidateGradeRequired.list(0, 0, whereClauseGradeOr, "");
        String[] joinGradeReqAnd = new String[listGradeRequiredAnd.size()];
        String joinGradeReqOr = "";
        if (listGradeRequiredAnd != null && listGradeRequiredAnd.size() > 0) {
            for (int i = 0; i < listGradeRequiredAnd.size(); i++) {
                CandidateGradeRequired grade = (CandidateGradeRequired) listGradeRequiredAnd.get(i);
                joinGradeReqAnd[i] = "( SELECT EMPLOYEE_ID FROM hr_view_work_history_now AS his INNER JOIN hr_grade_level AS lvl ON his.GRADE_LEVEL_ID = lvl.GRADE_LEVEL_ID WHERE lvl.GRADE_RANK BETWEEN "
                        +grade.getGradeMinimum() +" AND "+grade.getGradeMaximum()+")";
            }
        }
        if (listGradeRequiredOr != null && listGradeRequiredOr.size() > 0) {
            String whereOr = "";
            for (int i = 0; i < listGradeRequiredOr.size(); i++) {
                CandidateGradeRequired grade = (CandidateGradeRequired) listGradeRequiredOr.get(i);
                if (i>0){
                    whereOr += " OR ";
                }
                whereOr += " ( lvl.GRADE_RANK BETWEEN  "+grade.getGradeMinimum() +" AND "+grade.getGradeMaximum()+")";
            }
            joinGradeReqOr = "( SELECT EMPLOYEE_ID FROM hr_view_work_history_now AS his INNER JOIN hr_grade_level AS lvl ON his.GRADE_LEVEL_ID = lvl.GRADE_LEVEL_ID WHERE "+whereOr+")";
        }

        /* Experience List */
        String whereClauseExpAnd = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate
                +" AND "+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]+"=0"
                +" AND "+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_KONDISI]+"="+PstCandidateMain.KONDISI_AND;
        String whereClauseExpOr = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate
                +" AND "+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]+"=0"
                +" AND "+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_KONDISI]+"="+PstCandidateMain.KONDISI_OR;
        Vector listExpAnd = PstCandidatePositionExperience.list(0, 0, whereClauseExpAnd, "");
        Vector listExpOr = PstCandidatePositionExperience.list(0, 0, whereClauseExpOr, "");
        String[] joinExpAnd = new String[listExpAnd.size()];
        String joinExpOr = "";
        if (listExpAnd != null && listExpAnd.size() > 0) {
            for (int i = 0; i < listExpAnd.size(); i++) {
                CandidatePositionExperience pos = (CandidatePositionExperience) listExpAnd.get(i);
                joinExpAnd[i] = "( SELECT EMPLOYEE_ID, (DATEDIFF(WORK_TO, WORK_FROM) / 30) AS DURATION_POS FROM hr_view_work_history_now WHERE (HISTORY_GROUP = 0 OR WORK_HISTORY_NOW_ID = 0) AND (DATEDIFF(WORK_TO, WORK_FROM) / 30) >= "
                        +pos.getDurationMin()+" AND POSITION_ID =  "+pos.getPositionId();
            }
        }
        if (listExpOr != null && listExpOr.size() > 0) {
            String whereOr = "";
            for (int i = 0; i < listExpOr.size(); i++) {
                CandidatePositionExperience pos = (CandidatePositionExperience) listExpOr.get(i);
                if (i>0){
                    whereOr += " OR ";
                }
                whereOr += "  ( POSITION_ID = "+pos.getPositionId()+" AND (DATEDIFF(WORK_TO, WORK_FROM) / 30) >= "+pos.getDurationMin()+")";
            }
            joinExpOr = "( SELECT EMPLOYEE_ID, SUM(DATEDIFF(WORK_TO, WORK_FROM) / 30) AS DURATION_POS FROM hr_view_work_history_now WHERE (HISTORY_GROUP = 0 OR WORK_HISTORY_NOW_ID = 0) AND ("+whereOr+") ";
        }
		
        /* Experience Level List */
        String whereClauseExpLvlAnd = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate
                +" AND "+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]+"=1"
                +" AND "+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_KONDISI]+"="+PstCandidateMain.KONDISI_AND;
        String whereClauseExpLvlOr = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate
                +" AND "+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]+"=1"
                +" AND "+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_KONDISI]+"="+PstCandidateMain.KONDISI_OR;
        Vector listExpLvlAnd = PstCandidatePositionExperience.list(0, 0, whereClauseExpLvlAnd, "");
        Vector listExpLvlOr = PstCandidatePositionExperience.list(0, 0, whereClauseExpLvlOr, "");
        String[] joinExpLvlAnd = new String[listGradeRequiredAnd.size()];
        String joinExpLvlOr = "";
        if (listExpLvlAnd != null && listExpLvlAnd.size() > 0) {
            for (int i = 0; i < listExpLvlAnd.size(); i++) {
                CandidatePositionExperience pos = (CandidatePositionExperience) listExpLvlAnd.get(i);
                joinExpLvlAnd[i] = "( SELECT EMPLOYEE_ID, (DATEDIFF(WORK_TO, WORK_FROM) / 30) AS DURATION_LVL FROM hr_view_work_history_now WHERE (HISTORY_GROUP = 0 OR WORK_HISTORY_NOW_ID = 0) AND (DATEDIFF(WORK_TO, WORK_FROM) / 30) >= "
                        +pos.getDurationMin()+" AND LEVEL_ID =  "+pos.getExperienceId();
            }
        }
        if (listExpLvlOr != null && listExpLvlOr.size() > 0) {
            String whereOr = "";
            for (int i = 0; i < listExpLvlOr.size(); i++) {
                CandidatePositionExperience pos = (CandidatePositionExperience) listExpLvlOr.get(i);
                if (i>0){
                    whereOr += " OR ";
                }
                whereOr += "  ( LEVEL_ID = "+pos.getExperienceId()+" AND (DATEDIFF(WORK_TO, WORK_FROM) / 30) >= "+pos.getDurationMin()+")";
            }
            joinExpLvlOr = "( SELECT EMPLOYEE_ID, SUM(DATEDIFF(WORK_TO, WORK_FROM) / 30) AS DURATION_LVL FROM hr_view_work_history_now WHERE (HISTORY_GROUP = 0 OR WORK_HISTORY_NOW_ID = 0) AND ("+whereOr+") ";
        }
        
        /* Assessment List */
        String whereClauseAssAnd = PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate
                +" AND "+PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_KONDISI]+"="+PstCandidateMain.KONDISI_AND;
        String whereClauseAssOr = PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate
                +" AND "+PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_KONDISI]+"="+PstCandidateMain.KONDISI_OR;
        Vector listAssAnd = PstCandidatePositionAssessment.list(0, 0, whereClauseAssAnd, "");
        Vector listAssOr = PstCandidatePositionAssessment.list(0, 0, whereClauseAssOr, "");
        String[] joinAssAnd = new String[listAssAnd.size()];
        String joinAssOr = "";
        if (listAssAnd != null && listAssAnd.size() > 0) {
            for (int i = 0; i < listAssAnd.size(); i++) {
                CandidatePositionAssessment pos = (CandidatePositionAssessment) listAssAnd.get(i);
                joinAssAnd[i] = "( SELECT EMPLOYEE_ID, IF(req.BOBOT > 0, ( req.BOBOT / 100 ) * SCORE , SCORE) AS SCORE FROM hr_emp_assessment AS ass "
                        + "LEFT JOIN hr_candidate_position_assessment req ON ass.ASSESSMENT_ID = req.ASSESSMENT_ID  WHERE ass.ASSESSMENT_ID = '"+pos.getAssessmentId()+"' AND SCORE >= "+pos.getScoreMin()+" AND YEAR(DATE_OF_ASSESSMENT) =  "+pos.getTahun()+")";
            }
        }
        if (listAssOr != null && listAssOr.size() > 0) {
            String whereOr = "";
            for (int i = 0; i < listAssOr.size(); i++) {
                CandidatePositionAssessment pos = (CandidatePositionAssessment) listAssOr.get(i);
                if (i>0){
                    whereOr += " OR ";
                }
                whereOr += "  ( ass.ASSESSMENT_ID = '"+pos.getAssessmentId()+"' AND SCORE >= "+pos.getScoreMin()+" AND YEAR(DATE_OF_ASSESSMENT) =  "+pos.getTahun()+")";
            }
            joinAssOr = "( SELECT EMPLOYEE_ID, SUM(IF(req.BOBOT > 0, ( req.BOBOT / 100 ) * SCORE , SCORE)) AS SCORE FROM hr_emp_assessment AS ass "
                    + "LEFT JOIN hr_candidate_position_assessment req ON ass.ASSESSMENT_ID = req.ASSESSMENT_ID  WHERE req.CANDIDATE_MAIN_ID = "+oidCandidate+" AND ("+whereOr+") GROUP BY EMPLOYEE_ID) ";
        }
        
        /* Education List */
        whereClause = PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector listEducation = PstCandidatePositionEducation.list(0, 0, whereClause, "");
        if (listEducation != null && listEducation.size() > 0) {
            for (int i = 0; i < listEducation.size(); i++) {
                CandidatePositionEducation education = (CandidatePositionEducation) listEducation.get(i);
                whereEducation = whereEducation + education.getEducationId() + ",";
            }
            whereEducation = whereEducation.substring(0, whereEducation.length() - 1);
        }
        
        
        /* Key Performa Indicator */
        /* Sumber Pencarian */
        /*
         * code = 0 (candidate location)
         * code = 1 (sumber pencarian)
         */
        whereClause = PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        whereClause += " AND " + PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CODE] + "=1";
        Vector candidateLocList = PstCandidateLocation.list(0, 0, whereClause, "");
        String whereLocation = "";
        if (candidateLocList != null && candidateLocList.size() > 0) {
            for (int i = 0; i < candidateLocList.size(); i++) {
                CandidateLocation location = (CandidateLocation) candidateLocList.get(i);
                whereLocation = whereLocation + location.getDivisionId() + ",";
            }
            whereLocation = whereLocation.substring(0, whereLocation.length() - 1);
        } else {
            whereClause = "";
        }

        /*
         String whereEmployee = "";
         Vector empTraining = new Vector();
         Vector employeeList = PstEmployee.list(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
         // mencari employee di databank
         if (employeeList != null && employeeList.size() > 0) {
         for (int i = 0; i < employeeList.size(); i++) {
         Employee emp = (Employee) employeeList.get(i);
         whereEmployee = whereEmployee + emp.getOID() + ",";
         }
         whereEmployee = whereEmployee.substring(0, whereEmployee.length()-1);
         whereClause = PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID] +" IN ("+whereEmployee+")";
         whereClause += " AND "+PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_ID]+" IN ("+whereTraining+")";
         empTraining = PstTrainingHistory.listDistinct(0, 0, whereClause, "");
         }
    
         Vector empFilterEdu = new Vector();
         whereEmployee = "";
         if (empTraining != null && empTraining.size()>0){
         for (int i=0; i<empTraining .size(); i++){
         Long empTrain = (Long)empTraining .get(i);
         whereEmployee = whereEmployee + empTrain + ",";
         }
         whereEmployee = whereEmployee.substring(0, whereEmployee.length()-1);
         whereClause = PstEmpEducation.fieldNames[PstEmpEducation.FLD_EMPLOYEE_ID]+" IN ("+whereEmployee+")";
         whereClause += " AND "+PstEmpEducation.fieldNames[PstEmpEducation.FLD_EDUCATION_ID]+" IN ("+whereEducation+")";
         empFilterEdu = PstEmpEducation.listDistinct(0, 0, whereClause, "");
         }
         */
        /*Hashtable<String, Float> listEmpComp = null;
        if(whereCompetency != null && whereCompetency.length() > 0) {
            String sqlEmp = " SELECT he.employee_id FROM hr_employee he inner join hr_grade_level gl "
                    + " on gl.GRADE_LEVEL_ID = he.GRADE_LEVEL_ID where "
                    + ((whereLocation != null && whereLocation.length() > 0) ? ("he.DIVISION_ID IN(" + whereLocation + ") ") : "(1=1) ")
                    + ((whereGradeReq != null && whereGradeReq.length() > 0) ? " AND (" + whereGradeReq + " ) " : " AND (1=1) ");

            listEmpComp = PstEmployeeCompetency.listSumEmpCompetency(0, 10000, "hr_view_emp_competency."
                    + PstEmployeeCompetency.fieldNames[PstEmployeeCompetency.FLD_COMPETENCY_ID] + " IN (" + whereCompetency + ") "
                    + " AND REQ." + PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_POSITION_ID] + "=" + positionId
                    + " AND employee_id IN (" + sqlEmp + " ) ", " SUM_COMP DESC  ");
        }*/
        
        /*Hashtable<String, Float> listEmpAss = null;
        if(whereAssessment != null && whereAssessment.length() > 0) {
            String sqlEmp = " SELECT he.employee_id FROM hr_employee he inner join hr_grade_level gl "
                    + " on gl.GRADE_LEVEL_ID = he.GRADE_LEVEL_ID where "
                    + ((whereLocation != null && whereLocation.length() > 0) ? ("he.DIVISION_ID IN(" + whereLocation + ") ") : "(1=1) ")
                    + ((whereGradeReq != null && whereGradeReq.length() > 0) ? " AND (" + whereGradeReq + " ) " : " AND (1=1) ");

            listEmpAss = PstEmpAssessment.listSumEmpAssessment(0, 10000, "hr_view_emp_assessment."
                    + PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_ASSESSMENT_ID] + " IN (" + whereAssessment + ") "
                    + " AND REQ." + PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_POSITION_ID] + "=" + positionId
                    + " AND employee_id IN (" + sqlEmp + " ) ", " SUM_ASS DESC  ");
        }*/
        
        Vector<EmployeeCandidate> lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql
                    = " SELECT"
                    + " he.COMPANY_ID"
                    + ", cp.COMPANY"
                    + ", he.EMPLOYEE_ID"
                    + ", he.EMPLOYEE_NUM"
                    + ", he.FULL_NAME"
                    + ", he.COMMENCING_DATE"
                    + ", dv.DIVISION_ID"
                    + ", dv.DIVISION"
                    + ", dep.DEPARTMENT_ID"
                    + ", dep.DEPARTMENT"
                    + ", sec.SECTION "
                    + ", he.SECTION_ID "
                    + ", he.POSITION_ID"
                    + ", ps.POSITION"
                    + ", gl.GRADE_CODE"
                    + ", gl.GRADE_RANK "
                    + ", ((DATEDIFF(CURRENT_DATE() , he.COMMENCING_DATE))/30 ) AS LOS "
                    + ", (((DATEDIFF(CURRENT_DATE() , he.COMMENCING_DATE))/30 ) - (DATEDIFF(CURRENT_DATE(),vwh.MAX_HIS_WT)/30 )) AS WORKHIS  ";
                    if (joinExpAnd.length>0){
                        sql += ",(";
                        for (int i = 0; i < joinExpAnd.length; i++){
                            if (i > 0){
                                sql += " + ";
                            }
                            sql += "expAnd"+i+".DURATION_POS";
                        }
                        if (joinExpOr.length()>0){
                            sql += " + expOr.DURATION_POS";
                        }
                        sql += ") AS CURPOSITION";
                    } else if (joinExpOr.length()>0){
                        sql += ",expOr.DURATION_POS AS CURPOSITION";
                    } else {
                        sql += ", 0 AS CURPOSITION";
                    }
                    
                    if (joinExpLvlAnd.length>0){
                        sql += ",(";
                        for (int i = 0; i < joinExpLvlAnd.length; i++){
                            if (i > 0){
                                sql += " + ";
                            }
                            sql += "expLvlAnd"+i+".DURATION_LVL";
                        }
                        if (joinExpOr.length()>0){
                            sql += " + expLvlOr.DURATION_LVL";
                        }
                        sql += ") "+(totalBobotAssessment > 0 ? "* ("+(100-totalBobotAssessment)+"/100)": "")+" AS CURPOS";
                    } else if (joinExpOr.length()>0){
                        sql += ",expLvlOr.DURATION_LVL "+(totalBobotAssessment > 0 ? "* ("+(100-totalBobotAssessment)+"/100)": "")+" AS CURPOS";
                    } else {
                        sql += ", 0 AS CURPOS";
                    }
                    
                    if (joinExpLvlAnd.length>0){
                        sql += ",(";
                        for (int i = 0; i < joinExpLvlAnd.length; i++){
                            if (i > 0){
                                sql += " + ";
                            }
                            sql += "expLvlAnd"+i+".DURATION_LVL";
                        }
                        if (joinExpOr.length()>0){
                            sql += " + expLvlOr.DURATION_LVL";
                        }
                        sql += ") AS CURPOSORIGIN";
                    } else if (joinExpOr.length()>0){
                        sql += ",expLvlOr.DURATION_LVL AS CURPOSORIGIN";
                    } else {
                        sql += ", 0 AS CURPOSORIGIN";
                    }
                    if (joinAssAnd.length>0){
                        sql += ",(";
                        for (int i = 0; i < joinAssAnd.length; i++){
                            if (i > 0){
                                sql += " + ";
                            }
                            sql += "assAnd"+i+".SCORE";
                        }
                        if (joinAssOr.length()>0){
                            sql += " + assOr.SCORE";
                        }
                        sql += ") AS SUM_ASS_SCORE";
                    } else if (joinAssOr.length()>0){
                        sql += ",assOr.SCORE AS SUM_ASS_SCORE";
                    } else {
                        sql += ", 0 AS SUM_ASS_SCORE";
                    }
                    if (whereEducation != null && whereEducation.length()>0){
                        sql+= ",(SELECT SUM(SCORE) FROM view_employee_edu_score WHERE employee_id = he.employee_id AND education_id IN ("+whereEducation+")) AS EDUSCORE,"
                        //+ " SUM(hc.LEVEL_VALUE) AS SUM_COMPTCY_SCORE, "
                        + " escr.EDUCATION , "
                        //+ "escr.SCORE AS EDUSCORE, "
                        + "MAX(escr.EDULEVEL) as EDULEVEL  ";
                    } else {
                        sql += ", 0 EDUSCORE, escr.EDUCATION , MAX(escr.EDULEVEL) as EDULEVEL ";
                    }
							
                    sql += " from hr_employee he "
                    + " inner join pay_general cp on cp.GEN_ID = he.COMPANY_ID "
                    + " inner join hr_division dv on dv.DIVISION_ID = he.DIVISION_ID "
                    + " inner join hr_department dep on dep.DEPARTMENT_ID = he.DEPARTMENT_ID "
                    + " LEFT join hr_section sec on sec.SECTION_ID = he.SECTION_ID  "
                    + " inner join hr_position ps on ps.POSITION_ID= he.POSITION_ID "
                    + " LEFT JOIN hr_view_max_emp_work_history vwh ON vwh.EMPLOYEE_ID = he.EMPLOYEE_ID "
                    + " inner join hr_grade_level gl on gl.GRADE_LEVEL_ID = he.GRADE_LEVEL_ID "
                    + " inner join view_employee_edu_score escr ON escr.EMPLOYEE_ID =   he.EMPLOYEE_ID  ";
                    
                    if (joinExpAnd.length>0){
                        for (int i = 0; i < joinExpAnd.length; i++){
                            sql+= " INNER JOIN "+joinExpAnd[i]+" AS expAnd"+i+" ON he.EMPLOYEE_ID = expAnd"+i+".EMPLOYEE_ID ";
                        }
                        if (joinExpOr.length()>0){
                            sql += " LEFT JOIN "+joinExpOr+" AS expOr ON he.EMPLOYEE_ID = expOr.EMPLOYEE_ID ";
                        }
                    } else if (joinExpOr.length()>0){
                        sql += " INNER JOIN "+joinExpOr+" AS expOr ON he.EMPLOYEE_ID = expOr.EMPLOYEE_ID";
                    }
                    if (joinExpLvlAnd.length>0){
                        for (int i = 0; i < joinExpLvlAnd.length; i++){
                            sql+= " INNER JOIN "+joinExpLvlAnd[i]+" AS expLvlAnd"+i+" ON he.EMPLOYEE_ID = expLvlAnd"+i+".EMPLOYEE_ID ";
                        }
                        if (joinExpLvlOr.length()>0){
                            sql += " LEFT JOIN "+joinExpLvlOr+" AS expLvlOr ON he.EMPLOYEE_ID = expLvlOr.EMPLOYEE_ID";
                        }
                    } else if (joinExpLvlOr.length()>0){
                        sql += " INNER JOIN "+joinExpLvlOr+" AS expLvlOr ON he.EMPLOYEE_ID = expLvlOr.EMPLOYEE_ID";
                    }
                    if (joinAssAnd.length>0){
                        for (int i = 0; i < joinAssAnd.length; i++){
                            sql+= " INNER JOIN "+joinAssAnd[i]+" AS assAnd"+i+" ON he.EMPLOYEE_ID = assAnd"+i+".EMPLOYEE_ID ";
                        }
                        if (joinAssOr.length()>0){
                            sql += " LEFT JOIN "+joinAssOr+" AS assOr ON he.EMPLOYEE_ID = assOr.EMPLOYEE_ID";
                        }
                    } else if (joinAssOr.length()>0){
                        sql += " INNER JOIN "+joinAssOr+" AS assOr ON he.EMPLOYEE_ID = assOr.EMPLOYEE_ID";
                    }
                    sql += " where " + ((whereLocation != null && whereLocation.length() > 0) ? ("he.DIVISION_ID IN(" + whereLocation + ") ") : "(1=1) ")
                    + ((whereGradeReq != null && whereGradeReq.length() > 0) ? " AND (" +whereGradeReq + " ) " : " AND (1=1) ") + ((whereEmployeeStatus != null && whereEmployeeStatus.length() > 0) ? " AND (" +whereEmployeeStatus + " ) " : " AND (1=1) ")  
                    + (parameters.getEmployeePositionType()> 0 ? " AND ps.`POSITION_TYPE_ID` = " + parameters.getEmployeePositionType(): "")
                    + " GROUP BY he.EMPLOYEE_ID, escr.EDULEVEL  "
                    + " ORDER BY ps.`POSITION_TYPE_ID`, (CURPOS+`SUM_ASS_SCORE`+EDUSCORE) DESC, gl.GRADE_RANK DESC, ((DATEDIFF(CURRENT_DATE() , he.COMMENCING_DATE))/30 ) DESC,  EDULEVEL DESC, EDUSCORE DESC ";
            Hashtable<String, EmployeeCandidate > tblList = new Hashtable(); 
            Hashtable<String, Integer> tblIndex = new Hashtable();             
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            long prevEmployeeId = 0;
            while (rs.next()) {
                EmployeeCandidate candidate = new EmployeeCandidate();
                long emplOid = rs.getLong("employee_id");
                if(tblList != null){
                    EmployeeCandidate tempCandidate = tblList.get(""+emplOid);
                    if( tempCandidate!=null) {
                        int newEduLevel = rs.getInt("EDULEVEL");
                        if(newEduLevel < tempCandidate.getEducationLevel()){
                            continue;
                        } else{
                            tempCandidate.setEmployeeId(0);
                        }
                    }
                }
                if (prevEmployeeId != emplOid) { // get only most highgest level ojf employee
					
                    double currPosOrigin = rs.getFloat("CURPOSORIGIN");
					
                    candidate.setCompanyId(rs.getLong("company_id"));
                    candidate.setCompany(rs.getString("COMPANY"));
                    candidate.setEmployeeId(rs.getLong("employee_id"));
                    candidate.setFullName(rs.getString("FULL_NAME"));
                    candidate.setPayrollNumber(rs.getString("EMPLOYEE_NUM"));
                    candidate.setCommecingDate(rs.getDate("COMMENCING_DATE"));
                    candidate.setDivisionId(rs.getLong("division_id"));
                    candidate.setDivision(rs.getString("DIVISION"));
                    candidate.setDepartmentId(rs.getLong("department_id"));
                    candidate.setDepartment(rs.getString("DEPARTMENT"));
                    candidate.setSectionId(rs.getLong("SECTION_ID"));
                    candidate.setSection(rs.getString("SECTION"));
                    candidate.setCurrPositionId(rs.getLong("POSITION_ID"));
                    candidate.setCurrPosition(rs.getString("POSITION"));
                    candidate.setGradeCode(rs.getString("GRADE_CODE"));
                    candidate.setGradeRank(rs.getInt("GRADE_RANK"));
                    candidate.setLengthOfService(rs.getFloat("LOS"));
                    candidate.setWorkHistoryLength(rs.getFloat("WORKHIS"));
                    candidate.setCurrentPosLength(rs.getFloat("CURPOS"));
                    candidate.setPositionLength(rs.getFloat("CURPOSITION"));
                    candidate.setSumCompetencyScore(rs.getFloat("SUM_ASS_SCORE"));
                    candidate.setEducationCode(rs.getString("EDUCATION"));
                    candidate.setEducationScore(rs.getFloat("EDUSCORE"));
                    candidate.setEducationLevel(rs.getInt("EDULEVEL"));
                    candidate.setTotal(candidate.getCurrentPosLength()+candidate.getSumCompetencyScore()+candidate.getEducationLevel());
                    lists.add(candidate); 
                    tblList.put(""+candidate.getEmployeeId(), candidate);
                    tblIndex.put(""+candidate.getEmployeeId(), new Integer (lists.size()-1));
                    prevEmployeeId = emplOid;
                }
            }
            rs.close();
            
            if(lists!=null && lists.size()>0){
                for(int idx =0 ; idx < lists.size();idx++){
                    EmployeeCandidate candidate = lists.get(idx);
                    if(candidate.getEmployeeId()== 0){ 
                        lists.remove(idx);
                        idx=idx-1;
                    }
                }
            }
            
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }

        return lists;

    }
	
    public static float getCompetencyEmp(long oidEmp, long oidComp){
        float result = 0;
        Vector compEmpList = new Vector();
        String whereClause = PstEmployeeCompetency.fieldNames[PstEmployeeCompetency.FLD_COMPETENCY_ID]+"="+oidComp;
        whereClause += " AND "+PstEmployeeCompetency.fieldNames[PstEmployeeCompetency.FLD_EMPLOYEE_ID]+"="+oidEmp;
        compEmpList = PstEmployeeCompetency.list(0, 0, whereClause, PstEmployeeCompetency.fieldNames[PstEmployeeCompetency.FLD_DATE_OF_ACHVMT]+" DESC");
        if (compEmpList != null && compEmpList.size()>0){
            EmployeeCompetency empComp = (EmployeeCompetency)compEmpList.get(0);
            result = empComp.getLevelValue();
        }
        return result;
    }
    
    public static double getAssessmentEmp(long oidEmp, long oidAss){
        double result = 0;
        Vector assEmpList = new Vector();
        String whereClause = PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_ASSESSMENT_ID]+"="+oidAss;
        whereClause += " AND "+PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_EMPLOYEE_ID]+"="+oidEmp;
        assEmpList = PstEmpAssessment.list(0, 0, whereClause, PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_DATE_OF_ASSESSMENT]+" DESC");
        if (assEmpList != null && assEmpList.size()>0){
            EmpAssessment empAss = (EmpAssessment)assEmpList.get(0);
            result = empAss.getScore();
        }
        return result;
    }
    
    public static double getLOS(Date commencingDate){
        double los = 0;
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT((DATEDIFF(CURRENT_DATE() , '"+commencingDate+"'))/30 ) AS LOS";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                los = rs.getDouble(1);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return los;
    }

}

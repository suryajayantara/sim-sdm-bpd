/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;
import com.dimata.harisma.entity.masterdata.EmployeeCompetency;
import com.dimata.harisma.entity.masterdata.PstEmployeeCompetency;
import com.dimata.qdep.entity.Entity;
import java.util.Vector;

/**
 *
 * @author keys
 */
public class TrainingCompetencyMappingDetail extends Entity{




    private long trainingCompetencyMappingDetailId = 0;
    private long trainingActivityActualId = 0;
    private long competencyId = 0;
    private double score = 0;
    private long employeeId = 0;
    private long trainingAttId = 0;
    private long trainingCompetencyMappingId = 0;
    private long trainingHistoryId = 0;
    
    public long getTrainingCompetencyMappingDetailId() {
        return trainingCompetencyMappingDetailId;
    }

    public void setTrainingCompetencyMappingDetailId(long trainingCompetencyMappingId) {
        this.trainingCompetencyMappingDetailId = trainingCompetencyMappingId;
    }

    public long getTrainingActivityActualId() {
        return trainingActivityActualId;
    }

    public void setTrainingActivityActualId(long trainingActivityActualId) {
        this.trainingActivityActualId = trainingActivityActualId;
    }

    public long getCompetencyId() {
        return competencyId;
    }

    public void setCompetencyId(long competencyId) {
        this.competencyId = competencyId;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }
     /**
     * @return the employeeId
     */
    public long getEmployeeId() {
        return employeeId;
    }

    /**
     * @param employeeId the employeeId to set
     */
    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }
    
    
    /**
     * @return the trainingAttId
     */
    public long getTrainingAttId() {
        return trainingAttId;
    }

    /**
     * @param trainingAttId the trainingAttId to set
     */
    public void setTrainingAttId(long trainingAttId) {
        this.trainingAttId = trainingAttId;
    }
    
        /**
     * @return the trainingCompetencyMappingId
     */
    public long getTrainingCompetencyMappingId() {
        return trainingCompetencyMappingId;
    }

    /**
     * @param trainingCompetencyMappingId the trainingCompetencyMappingId to set
     */
    public void setTrainingCompetencyMappingId(long trainingCompetencyMappingId) {
        this.trainingCompetencyMappingId = trainingCompetencyMappingId;
    }
    
        /**
     * @return the trainingHistoryId
     */
    public long getTrainingHistoryId() {
        return trainingHistoryId;
    }

    /**
     * @param trainingHistoryId the trainingHistoryId to set
     */
    public void setTrainingHistoryId(long trainingHistoryId) {
        this.trainingHistoryId = trainingHistoryId;
    }

    
    public static void generateEmployeeCompetency(long oidTrainingActivityActual){
                TrainingActivityActual objTrainingActivityActual = new TrainingActivityActual();
                try{
                    objTrainingActivityActual = PstTrainingActivityActual.fetchExc(oidTrainingActivityActual);
                }catch(Exception exc){
                    System.out.println("err :"+exc);
                }
                String whereComMapDetail = ""+PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_ACTIVITY_ACTUAL_ID]+" = "+objTrainingActivityActual.getOID();
                String whereDelEmpCom = ""+PstEmployeeCompetency.fieldNames[PstEmployeeCompetency.FLD_TRAINING_ACTIVITY_ACTUAL_ID]+" = "+objTrainingActivityActual.getOID();
                Vector listTrainingCompMapDetail = PstTrainingCompetencyMappingDetail.list(0, 0, whereComMapDetail, "");
                Vector listHrEmployeeCompetency = PstEmployeeCompetency.list(0, 0, whereDelEmpCom, "");
                
                //proses delete semua competencynya dulu
                for(int xx = 0 ;xx < listHrEmployeeCompetency.size();xx++){
                    EmployeeCompetency objEmployeeCompetency = (EmployeeCompetency) listHrEmployeeCompetency.get(xx);
                    try{
                    PstEmployeeCompetency.deleteExc(objEmployeeCompetency.getOID());
                    }catch(Exception exc){
                        System.out.println("exc : "+exc);
                    }
                }
                
                //baru kemudian di insert
                for(int xy = 0 ; xy < listTrainingCompMapDetail.size();xy++){
                    TrainingCompetencyMappingDetail objTrainingCompetencyMappingDetail = (TrainingCompetencyMappingDetail)listTrainingCompMapDetail.get(xy);
                    
                    EmployeeCompetency objEmployeeCompetency = new EmployeeCompetency();
                    objEmployeeCompetency.setTrainingActivityActualId(oidTrainingActivityActual);
                    objEmployeeCompetency.setTrainingCompetencyMappingDetailId(objTrainingCompetencyMappingDetail.getOID());
                    objEmployeeCompetency.setEmployeeId(objTrainingCompetencyMappingDetail.getEmployeeId());
                    objEmployeeCompetency.setLevelValue(Float.parseFloat(""+objTrainingCompetencyMappingDetail.getScore()));
                    objEmployeeCompetency.setCompetencyId(objTrainingCompetencyMappingDetail.getCompetencyId());
                    objEmployeeCompetency.setDateOfAchvmt(objTrainingActivityActual.getTrainEndDate());
                    try{
                    long oidEmployeeCompetency = PstEmployeeCompetency.insertExc(objEmployeeCompetency);
                    }catch(Exception exc){
                        System.out.println("err: "+exc);
                    }
                }
                
    }
    
    public static void generateMapCompetencyDetail(long oidTrainingActivityActual, long oidTrainingAttId,long oidTrainingHistory){
        if(oidTrainingActivityActual != 0){
            String whereClauseListComp= ""+PstTrainingCompetencyMapping.fieldNames[PstTrainingCompetencyMapping.FLD_TRAINING_ACTIVITY_ACTUAL_ID]+" = "+oidTrainingActivityActual;
                Vector listComMap = PstTrainingCompetencyMapping.list(0, 0, whereClauseListComp, "");

                String whereClause= ""+PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_ATTENDANCE_ID]+" = "+oidTrainingAttId;
                if(oidTrainingAttId == 0){
                    whereClause= ""+PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_HISTORY_ID]+" = "+oidTrainingHistory;
                }
                Vector listComMapDetail = PstTrainingCompetencyMappingDetail.list(0, 0, whereClause, "");
                if(listComMapDetail.size() == 0){
                    try{
                       TrainingAttendancePlan objTrainingAttendancePlan  = new TrainingAttendancePlan();
                       TrainingHistory objTrainingHistory = new TrainingHistory();
                        if(oidTrainingAttId != 0){
                         objTrainingAttendancePlan = PstTrainingAttendancePlan.fetchExc(oidTrainingAttId);
                        }
                        if(oidTrainingHistory != 0){
                           objTrainingHistory = PstTrainingHistory.fetchExc(oidTrainingHistory); 
                        }
                     
                    for(int xy = 0 ; xy < listComMap.size();xy++){
                        TrainingCompetencyMappingDetail objTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
                        TrainingCompetencyMapping objTrainingCompetencyMapping = (TrainingCompetencyMapping) listComMap.get(xy);
                        if(objTrainingAttendancePlan.getOID() != 0){
                            objTrainingCompetencyMappingDetail.setEmployeeId(objTrainingAttendancePlan.getEmployeeId());
                            
                            
                        }
                        if(objTrainingHistory.getOID() != 0){
                           if(objTrainingCompetencyMappingDetail.getEmployeeId() == 0){
                           objTrainingCompetencyMappingDetail.setEmployeeId(objTrainingHistory.getEmployeeId());
                           }
                        }
                        objTrainingCompetencyMappingDetail.setTrainingAttId(objTrainingAttendancePlan.getOID());
                        objTrainingCompetencyMappingDetail.setTrainingHistoryId(objTrainingHistory.getOID());
                        objTrainingCompetencyMappingDetail.setScore(objTrainingCompetencyMapping.getScore());
                        objTrainingCompetencyMappingDetail.setCompetencyId(objTrainingCompetencyMapping.getCompetencyId());
                        objTrainingCompetencyMappingDetail.setTrainingActivityActualId(oidTrainingActivityActual);
                        objTrainingCompetencyMappingDetail.setTrainingCompetencyMappingId(objTrainingCompetencyMapping.getOID());
                        objTrainingCompetencyMappingDetail.setTrainingHistoryId(oidTrainingHistory);
                        long oidMapDetail = 0;
                        try{
                            oidMapDetail = PstTrainingCompetencyMappingDetail.insertExc(objTrainingCompetencyMappingDetail);
                            //untuk insert competensi ke hr_employe_competency 
                            objTrainingCompetencyMappingDetail.generateEmployeeCompetency(oidTrainingActivityActual);
                        }catch(Exception exc){

                        }
                    }

                     }catch(Exception exc){
                        System.out.println("Error: "+exc);
                    }
                }
        }
      }
    
    public static void autoInsertComptencyMapDetail(long oidTrainingActivityActual){
        try{
                Vector listTrainingCompMap = PstTrainingCompetencyMapping.listTrainingCompetencyMapByOidActual(oidTrainingActivityActual);
                Vector vctEmpTrainingList = PstTrainingHistory.listEmployeeTrainingByActivity(oidTrainingActivityActual);
                
                for(int xy = 0 ; xy < vctEmpTrainingList.size();xy++){
                    TrainingHistory objTrainingHistory = (TrainingHistory) vctEmpTrainingList.get(xy);
                    for(int yy = 0 ; yy < listTrainingCompMap.size();yy++){
                        TrainingCompetencyMapping objTrainingCompetencyMapping = (TrainingCompetencyMapping) listTrainingCompMap.get(yy);
                        Vector listTrainingCompetencyMapDetail = PstTrainingCompetencyMappingDetail.listByCompetencyMappingIdAndEmployeeId(objTrainingCompetencyMapping.getOID(), objTrainingHistory.getEmployeeId());
                        if(listTrainingCompetencyMapDetail.size() > 1){
                            for(int xx = 0 ; xx < listTrainingCompetencyMapDetail.size();xx++){
                                TrainingCompetencyMappingDetail objTrainingCompetencyMappingDetail = (TrainingCompetencyMappingDetail)listTrainingCompetencyMapDetail.get(xx);
                                PstTrainingCompetencyMappingDetail.deleteExc(objTrainingCompetencyMappingDetail.getOID());
                            }
                            //otomatis insert ke mapping detail kompotensin per Employee klo beluma terinsert
                                TrainingCompetencyMappingDetail objTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
                                     objTrainingCompetencyMappingDetail.setEmployeeId(objTrainingHistory.getEmployeeId());
                                     objTrainingCompetencyMappingDetail.setTrainingHistoryId(objTrainingHistory.getOID());
                                     objTrainingCompetencyMappingDetail.setScore(objTrainingCompetencyMapping.getScore());
                                     objTrainingCompetencyMappingDetail.setCompetencyId(objTrainingCompetencyMapping.getCompetencyId());
                                     objTrainingCompetencyMappingDetail.setTrainingActivityActualId(oidTrainingActivityActual);
                                     objTrainingCompetencyMappingDetail.setTrainingCompetencyMappingId(objTrainingCompetencyMapping.getOID());
                                     PstTrainingCompetencyMappingDetail.insertExc(objTrainingCompetencyMappingDetail);
                        }else if (listTrainingCompetencyMapDetail.size() == 0){
                              //otomatis insert ke mapping detail kompotensin per Employee klo beluma terinsert
                                TrainingCompetencyMappingDetail objTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
                                     objTrainingCompetencyMappingDetail.setEmployeeId(objTrainingHistory.getEmployeeId());
                                     objTrainingCompetencyMappingDetail.setTrainingHistoryId(objTrainingHistory.getOID());
                                     objTrainingCompetencyMappingDetail.setScore(objTrainingCompetencyMapping.getScore());
                                     objTrainingCompetencyMappingDetail.setCompetencyId(objTrainingCompetencyMapping.getCompetencyId());
                                     objTrainingCompetencyMappingDetail.setTrainingActivityActualId(oidTrainingActivityActual);
                                     objTrainingCompetencyMappingDetail.setTrainingCompetencyMappingId(objTrainingCompetencyMapping.getOID());
                                     PstTrainingCompetencyMappingDetail.insertExc(objTrainingCompetencyMappingDetail);
                        }
                    }
                }
                
                if(vctEmpTrainingList.size() == 0){
                    TrainingActivityActual objTrainingActivityActual = (TrainingActivityActual)PstTrainingActivityActual.fetchExc(oidTrainingActivityActual);
                    vctEmpTrainingList = PstTrainingAttendancePlan.getAttendanceByPlan(objTrainingActivityActual.getTrainingActivityPlanId());
                    for(int uu = 0 ; uu < vctEmpTrainingList.size();uu++){
                       TrainingAttendancePlan objTrainingAttendancePlan = (TrainingAttendancePlan) vctEmpTrainingList.get(uu);
                       for(int ut = 0 ; ut < listTrainingCompMap.size();ut++){
                           TrainingCompetencyMapping objTrainingCompetencyMapping = (TrainingCompetencyMapping) listTrainingCompMap.get(ut);
                           Vector listTrainingCompetencyMapDetail = PstTrainingCompetencyMappingDetail.listByCompetencyMappingIdAndEmployeeId(objTrainingCompetencyMapping.getOID(), objTrainingAttendancePlan.getEmployeeId());
                           if(listTrainingCompetencyMapDetail.size() > 1){
                               for(int xx = 0 ; xx < listTrainingCompetencyMapDetail.size();xx++){
                                   TrainingCompetencyMappingDetail objTrainingCompetencyMappingDetail = (TrainingCompetencyMappingDetail)listTrainingCompetencyMapDetail.get(xx);
                                   PstTrainingCompetencyMappingDetail.deleteExc(objTrainingCompetencyMappingDetail.getOID());
                               }
                               //otomatis insert ke mapping detail kompotensin per Employee klo beluma terinsert
                                   TrainingCompetencyMappingDetail objTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
                                        objTrainingCompetencyMappingDetail.setEmployeeId(objTrainingAttendancePlan.getEmployeeId());
                                        objTrainingCompetencyMappingDetail.setTrainingAttId(objTrainingAttendancePlan.getOID());
                                        objTrainingCompetencyMappingDetail.setScore(objTrainingCompetencyMapping.getScore());
                                        objTrainingCompetencyMappingDetail.setCompetencyId(objTrainingCompetencyMapping.getCompetencyId());
                                        objTrainingCompetencyMappingDetail.setTrainingActivityActualId(oidTrainingActivityActual);
                                        objTrainingCompetencyMappingDetail.setTrainingCompetencyMappingId(objTrainingCompetencyMapping.getOID());
                                        PstTrainingCompetencyMappingDetail.insertExc(objTrainingCompetencyMappingDetail);
                           }else if (listTrainingCompetencyMapDetail.size() == 0){
                                 //otomatis insert ke mapping detail kompotensin per Employee klo beluma terinsert
                                   TrainingCompetencyMappingDetail objTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
                                        objTrainingCompetencyMappingDetail.setEmployeeId(objTrainingAttendancePlan.getEmployeeId());
                                        objTrainingCompetencyMappingDetail.setTrainingAttId(objTrainingAttendancePlan.getOID());
                                        objTrainingCompetencyMappingDetail.setScore(objTrainingCompetencyMapping.getScore());
                                        objTrainingCompetencyMappingDetail.setCompetencyId(objTrainingCompetencyMapping.getCompetencyId());
                                        objTrainingCompetencyMappingDetail.setTrainingActivityActualId(oidTrainingActivityActual);
                                        objTrainingCompetencyMappingDetail.setTrainingCompetencyMappingId(objTrainingCompetencyMapping.getOID());
                                        PstTrainingCompetencyMappingDetail.insertExc(objTrainingCompetencyMappingDetail);
                           }
                       }
                   }
                }
        }catch(Exception exc){
            System.out.println("Error :"+exc);
        }
   
    }
    
    public static void delTrainngCompMapDetail(long oidTrainingActivityActual, long oidEmployee){
        try{
                Vector listTrainingCompetencyMapDetail = PstTrainingCompetencyMappingDetail.listByEmployeeIdAndActualId(oidTrainingActivityActual, oidEmployee);
                        if(listTrainingCompetencyMapDetail.size() > 0){
                            for(int xx = 0 ; xx < listTrainingCompetencyMapDetail.size();xx++){
                                TrainingCompetencyMappingDetail objTrainingCompetencyMappingDetail = (TrainingCompetencyMappingDetail)  listTrainingCompetencyMapDetail.get(xx);
                                PstTrainingCompetencyMappingDetail.deleteExc(objTrainingCompetencyMappingDetail.getOID());
                            }
                            
                        }
        }catch(Exception exc){
            System.out.println("Error :"+exc);
        }
   
    }
}
    


/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.session.employee;

import com.dimata.harisma.entity.masterdata.CompetencyGroup;
import com.dimata.harisma.entity.masterdata.CompetencyType;
import com.dimata.harisma.entity.masterdata.PstCompetencyGroup;
import com.dimata.harisma.entity.masterdata.PstCompetencyType;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import java.sql.ResultSet;
import java.util.Vector;
import org.json.JSONObject;

/**
 *
 * @author gndiw
 */
public class SessRptCompetency {

 
    
    private String typeName;
    private String groupName;
    private String competencyName;
    private int minReq;
    private int maxReq;
    private long competencyId;
    
    public static double getPencapaianKompetensiBelumDinilai(long employeeId, long positionId, long levelId, int dvLevel, int depLvl, int secLvl){
        double pencapaian = 0.0;
        
        DBResultSet dbrs = null;
        int count = 0;
        try {
            double pctType = 0.0;
            int cntType = 0;
            Vector listType = PstCompetencyType.list(0, 0, PstCompetencyType.fieldNames[PstCompetencyType.FLD_ACCUMULATE_IN_ACHIEVMENT]+"=1", "");
            for (int i = 0; i < listType.size(); i++){
                CompetencyType comType = (CompetencyType) listType.get(i);
                boolean checkType = isMappingType(comType.getOID(), positionId, levelId, dvLevel, depLvl, secLvl);
                if (checkType) {
                    cntType++;
                    double pctGroup =0.0;
                    int cntGrp = 0;
                    Vector listGroup = PstCompetencyGroup.list(0, 0, PstCompetencyGroup.fieldNames[PstCompetencyGroup.FLD_COMPETENCY_TYPE_ID]+"="+comType.getOID(), "");
                    for (int x=0; x < listGroup.size(); x++){
                        CompetencyGroup grp = (CompetencyGroup) listGroup.get(x);
                        boolean checkGroup = isMappingGroup(grp.getOID(), positionId, levelId, dvLevel, depLvl, secLvl);
                         cntGrp++;
                        if (checkGroup) {
                           
                            pctGroup += getPencapaianKompetensiGroupBelumDinilai(employeeId, positionId, grp.getGroupName(), levelId, dvLevel, depLvl, secLvl);
                        }
                    }
                    pctType += Math.round(pctGroup / cntGrp);
                }
                
            }
            if (cntType>0){
                pencapaian = Math.round( pctType / cntType);
            }
        } catch (Exception ex) {
            return 0;
        }
        
        return pencapaian;
    }
    
    public static double getPencapaianKompetensiSudahDinilai(long employeeId, long positionId, long levelId, int dvLevel, int depLvl, int secLvl){
        double pencapaian = 0.0;
        
        DBResultSet dbrs = null;
        int count = 0;
        try {
            double pctType = 0.0;
            int cntType = 0;
            Vector listType = PstCompetencyType.list(0, 0, PstCompetencyType.fieldNames[PstCompetencyType.FLD_ACCUMULATE_IN_ACHIEVMENT]+"=1", "");
            for (int i = 0; i < listType.size(); i++){
                CompetencyType comType = (CompetencyType) listType.get(i);
                boolean checkType = isMappingType(comType.getOID(), positionId, levelId, dvLevel, depLvl, secLvl);
                if (checkType) {
                    cntType++;
                    double pctGroup =0.0;
                    int cntGrp = 0;
                    Vector listGroup = PstCompetencyGroup.list(0, 0, PstCompetencyGroup.fieldNames[PstCompetencyGroup.FLD_COMPETENCY_TYPE_ID]+"="+comType.getOID(), "");
                    for (int x=0; x < listGroup.size(); x++){
                        CompetencyGroup grp = (CompetencyGroup) listGroup.get(x);
                        boolean checkGroup = isMappingGroup(grp.getOID(), positionId, levelId, dvLevel, depLvl, secLvl);
                        if (checkGroup) {
                            cntGrp++;
                            pctGroup += getPencapaianKompetensiGroupSudahDinilai(employeeId, positionId, grp.getGroupName(), levelId, dvLevel, depLvl, secLvl);
                        }
                    }
                    pctType += Math.round(pctGroup / cntGrp);
                }
                
            }
            if (cntType>0){
                pencapaian = Math.round( pctType / cntType);
            }
        } catch (Exception ex) {
            return 0;
        }
        
        return pencapaian;
    }
    
    public static double getPencapaianKompetensi(long employeeId, long positionId, long levelId, int dvLevel, int depLvl, int secLvl){
        double pencapaian = 0.0;
        
        DBResultSet dbrs = null;
        int count = 0;
        try {
            double pctType = 0.0;
            int cntType = 0;
            Vector listType = PstCompetencyType.list(0, 0, PstCompetencyType.fieldNames[PstCompetencyType.FLD_ACCUMULATE_IN_ACHIEVMENT]+"=1", "");
            for (int i = 0; i < listType.size(); i++){
                CompetencyType comType = (CompetencyType) listType.get(i);
                boolean checkType = isMappingType(comType.getOID(), positionId, levelId, dvLevel, depLvl, secLvl);
                if (checkType) {
                    cntType++;
                    double pctGroup =0.0;
                    int cntGrp = 0;
                    Vector listGroup = PstCompetencyGroup.list(0, 0, PstCompetencyGroup.fieldNames[PstCompetencyGroup.FLD_COMPETENCY_TYPE_ID]+"="+comType.getOID(), "");
                    for (int x=0; x < listGroup.size(); x++){
                        CompetencyGroup grp = (CompetencyGroup) listGroup.get(x);
                        boolean checkGroup = isMappingGroup(grp.getOID(), positionId, levelId, dvLevel, depLvl, secLvl);
                        cntGrp++;
                        if (checkGroup) {
                            pctGroup += getPencapaianKompetensiGroup(employeeId, positionId, grp.getGroupName(), levelId, dvLevel, depLvl, secLvl, 1);
                        }
                    }
                    pctType += Math.round(pctGroup / cntGrp);
                }
                
            }
            if (cntType>0){
                pencapaian = Math.round( pctType / cntType);
            }
        } catch (Exception ex) {
            return 0;
        }
        
        return pencapaian;
    }
    
    public static double getPencapaianKompetensiType(long employeeId, long positionId, long typeId, long levelId, int dvLevel, int depLvl, int secLvl, int type){
        double pencapaian = 0.0;
        
        DBResultSet dbrs = null;
        int count = 0;

        
        try {
            double pctType = 0.0;
            Vector listType = PstCompetencyType.list(0, 0, PstCompetencyType.fieldNames[PstCompetencyType.FLD_COMPETENCY_TYPE_ID]+"="+typeId, "");
            for (int i = 0; i < listType.size(); i++){
                CompetencyType comType = (CompetencyType) listType.get(i);
                double pctGroup =0.0;
                Vector listGroup = PstCompetencyGroup.list(0, 0, PstCompetencyGroup.fieldNames[PstCompetencyGroup.FLD_COMPETENCY_TYPE_ID]+"="+comType.getOID(), "");
                for (int x=0; x < listGroup.size(); x++){
                    CompetencyGroup grp = (CompetencyGroup) listGroup.get(x);
                    pctGroup += getPencapaianKompetensiGroup(employeeId, positionId, grp.getGroupName(), levelId, dvLevel, depLvl, secLvl, type);
                }
                pctType += Math.round(pctGroup / listGroup.size());
            }
            pencapaian = Math.round( pctType / listType.size() );
        } catch (Exception ex) {
            return 0;
        }
        
        return pencapaian;
    }
    
    public static double getPencapaianKompetensiTypeBelum(long employeeId, long positionId, long typeId, long levelId, int dvLevel, int depLvl, int secLvl){
        double pencapaian = 0.0;
        
        DBResultSet dbrs = null;
        int count = 0;

        
        try {
            double pctType = 0.0;
            Vector listType = PstCompetencyType.list(0, 0, PstCompetencyType.fieldNames[PstCompetencyType.FLD_COMPETENCY_TYPE_ID]+"="+typeId, "");
            for (int i = 0; i < listType.size(); i++){
                CompetencyType comType = (CompetencyType) listType.get(i);
                double pctGroup =0.0;
                Vector listGroup = PstCompetencyGroup.list(0, 0, PstCompetencyGroup.fieldNames[PstCompetencyGroup.FLD_COMPETENCY_TYPE_ID]+"="+comType.getOID(), "");
                for (int x=0; x < listGroup.size(); x++){
                    CompetencyGroup grp = (CompetencyGroup) listGroup.get(x);
                    pctGroup += getPencapaianKompetensiGroupBelumDinilai(employeeId, positionId, grp.getGroupName(), levelId, dvLevel, depLvl, secLvl);
                }
                pctType += Math.round(pctGroup / listGroup.size());
            }
            pencapaian = Math.round( pctType / listType.size() );
        } catch (Exception ex) {
            return 0;
        }
        
        return pencapaian;
    }
    
    public static int getGapKompetensiType(long employeeId, long positionId, long typeId, long levelId, int dvLevel, int depLvl, int secLvl, int type){
        int gap = 0;
        
        DBResultSet dbrs = null;
        int count = 0;

        
        try {
            double pctType = 0.0;
            Vector listType = PstCompetencyType.list(0, 0, PstCompetencyType.fieldNames[PstCompetencyType.FLD_COMPETENCY_TYPE_ID]+"="+typeId, "");
            for (int i = 0; i < listType.size(); i++){
                CompetencyType comType = (CompetencyType) listType.get(i);
                Vector listGroup = PstCompetencyGroup.list(0, 0, PstCompetencyGroup.fieldNames[PstCompetencyGroup.FLD_COMPETENCY_TYPE_ID]+"="+comType.getOID(), "");
                for (int x=0; x < listGroup.size(); x++){
                    CompetencyGroup grp = (CompetencyGroup) listGroup.get(x);
                    gap += getTotalGapGroup(employeeId, positionId, grp.getGroupName(), levelId, dvLevel, depLvl, secLvl, type);
                }
            }
        } catch (Exception ex) {
            return 0;
        }
        
        return gap;
    }
    
    public static boolean isMappingType(long typeId, long positionId, long levelId, int dvLevel, int depLvl, int secLvl) {
        boolean isTrue = false;
        
        DBResultSet dbrs = null;
        double count = 0;
        double pct = 0;
        try {
            String sql = "SELECT * "
                    + "FROM  `hr_view_position_competency_list` "
                    + "WHERE `POSITION_ID` = '"+positionId+"' "
                    + "AND `COMPETENCY_TYPE_ID` = '"+typeId+"' "
                    + "AND COMPETENCY_LEVEL_ID = '"+levelId+"'";;
            //System.out.println("sql jumlah ::::::::::::::::::::::"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                isTrue = true;
                int lvlDiv = rs.getInt("LEVEL_DIVISION");
                int lvlDept = rs.getInt("LEVEL_DEPARTMENT");
                int lvlSec = rs.getInt("LEVEL_SECTION");
                if (lvlDiv > 0) {
                    if (lvlDiv != dvLevel) {
                        isTrue = false;
                    }
                }
                if (lvlDept > 0) {
                    if (lvlDept != depLvl) {
                        isTrue = false;
                    }
                }
                if (lvlSec > 0) {
                    if (lvlSec != secLvl) {
                        isTrue = false;
                    }
                }
                if (isTrue){
                    break;
                }
            }
            
            rs.close();

        } catch (Exception ex) {
            return false;
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return isTrue;
    }
    
    public static boolean isMappingGroup(long groupId, long positionId, long levelId, int dvLevel, int depLvl, int secLvl) {
        boolean isTrue = false;
        
        DBResultSet dbrs = null;
        double count = 0;
        double pct = 0;
        try {
            String sql = "SELECT * "
                    + "FROM  `hr_view_position_competency_list` "
                    + "WHERE `POSITION_ID` = '"+positionId+"' "
                    + "AND `COMPETENCY_GROUP_ID` = '"+groupId+"' "
                    + "AND COMPETENCY_LEVEL_ID = '"+levelId+"'";
            //System.out.println("sql jumlah ::::::::::::::::::::::"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                isTrue = true;
                int lvlDiv = rs.getInt("LEVEL_DIVISION");
                int lvlDept = rs.getInt("LEVEL_DEPARTMENT");
                int lvlSec = rs.getInt("LEVEL_SECTION");
                if (lvlDiv > 0) {
                    if (lvlDiv != dvLevel) {
                        isTrue = false;
                    }
                }
                if (lvlDept > 0) {
                    if (lvlDept != depLvl) {
                        isTrue = false;
                    }
                }
                if (lvlSec > 0) {
                    if (lvlSec != secLvl) {
                        isTrue = false;
                    }
                }
                if (isTrue){
                    break;
                }
            }
            
            rs.close();

        } catch (Exception ex) {
            return false;
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return isTrue;
    }
    
    public static double getPencapaianKompetensiGroup(long employeeId, long positionId, String groupName, long levelId, int dvLevel, int depLvl, int secLvl, int type){
        double pencapaian = 0.0;
        
        DBResultSet dbrs = null;
        double count = 0;
        double pct = 0;
        try {
            String sql = "SELECT com.*, "
                    + "IFNULL(ecom.`LEVEL_VALUE`,0) AS LEVEL_VALUE "
                    + "FROM  `hr_view_position_competency_list` com "
                    + "INNER JOIN hr_employee emp "
                    + "ON com.`POSITION_ID` = emp.`POSITION_ID` "
                    + "LEFT JOIN hr_emp_competency ecom "
                    + "ON ecom.`EMPLOYEE_ID` = emp.`EMPLOYEE_ID` "
                    + "AND ecom.`COMPETENCY_ID` = com.`COMPETENCY_ID` "
                    + "WHERE com.`POSITION_ID` = '"+positionId+"' AND emp.employee_id = '"+employeeId+"' "
                    + "AND com.`GROUP_NAME` = '"+groupName+"' AND com.COMPETENCY_LEVEL_ID = '"+levelId+"' ";
                    
            //System.out.println("sql jumlah ::::::::::::::::::::::"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                boolean isTrue = true;
                int lvlDiv = rs.getInt("LEVEL_DIVISION");
                int lvlDept = rs.getInt("LEVEL_DEPARTMENT");
                int lvlSec = rs.getInt("LEVEL_SECTION");
                if (lvlDiv > 0) {
                    if (lvlDiv != dvLevel) {
                        isTrue = false;
                    }
                }
                if (lvlDept > 0) {
                    if (lvlDept != depLvl) {
                        isTrue = false;
                    }
                }
                if (lvlSec > 0) {
                    if (lvlSec != secLvl) {
                        isTrue = false;
                    }
                }
                if (isTrue) {
                    count++;
                    double scoreReq = rs.getDouble("SCORE_REQ_MIN");
                    double scoreAcv = rs.getDouble("LEVEL_VALUE");
                    double pcts = (scoreAcv / scoreReq) * 100.0;
                    if (type == 1 && pcts > 100){
                        pct += 100.0;
                    } else {
                        pct += pcts;
                    }
                    
                }
            }
            if(count != 0){
            pencapaian = pct / count;
            }
            rs.close();

        } catch (Exception ex) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return pencapaian;
    }
    
    
    public static double getPencapaianKompetensiGroupBelumDinilai(long employeeId, long positionId, String groupName, long levelId, int dvLevel, int depLvl, int secLvl){
        double pencapaian = 0.0;
         JSONObject empScore = SessRptCompetency.getEmpCompetency(employeeId);
        DBResultSet dbrs = null;
        double count = 0;
        double pct = 0;
        try {
            String sql = "SELECT com.*, "
                    + "IFNULL(ecom.`LEVEL_VALUE`,0) AS LEVEL_VALUE "
                    + "FROM  `hr_view_position_competency_list` com "
                    + "INNER JOIN hr_employee emp "
                    + "ON com.`POSITION_ID` = emp.`POSITION_ID` "
                    + "LEFT JOIN hr_emp_competency ecom "
                    + "ON ecom.`EMPLOYEE_ID` = emp.`EMPLOYEE_ID` "
                    + "AND ecom.`COMPETENCY_ID` = com.`COMPETENCY_ID` "
                    + "WHERE com.`POSITION_ID` = '"+positionId+"' AND emp.employee_id = '"+employeeId+"' "
                    + "AND com.`GROUP_NAME` = '"+groupName+"' AND com.COMPETENCY_LEVEL_ID = '"+levelId+"' ";
                    
            //System.out.println("sql jumlah ::::::::::::::::::::::"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {  
                boolean isTrue = true;
                int lvlDiv = rs.getInt("LEVEL_DIVISION");
                int lvlDept = rs.getInt("LEVEL_DEPARTMENT");
                int lvlSec = rs.getInt("LEVEL_SECTION");
                double scoreReq = rs.getDouble("SCORE_REQ_MIN");
                double scoreAcv = rs.getDouble("LEVEL_VALUE");
                if (lvlDiv > 0) {
                    if (lvlDiv != dvLevel) {
                        isTrue = false;
                    }
                }
                if (lvlDept > 0) {
                    if (lvlDept != depLvl) {
                        isTrue = false;
                    }
                }
                if (lvlSec > 0) {
                    if (lvlSec != secLvl) {
                        isTrue = false;
                    }
                }
                if (isTrue) {
                    String yesNoD = empScore.optString(""+rs.getLong("COMPETENCY_ID"),null);
                    count++;
                        if(yesNoD == null){
                            pct +=  0.0;
                        }else if (yesNoD != null){
                            pct +=  100.0;
                        }
                }
                
                
            }
            if (count > 0) {
                pencapaian = pct / count;
            }
            
            rs.close();

        } catch (Exception ex) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return pencapaian;
    }
    
    public static double getPencapaianKompetensiGroupSudahDinilai(long employeeId, long positionId, String groupName, long levelId, int dvLevel, int depLvl, int secLvl){
        double pencapaian = 0.0;
        
        DBResultSet dbrs = null;
        double count = 0;
        double pct = 0;
        try {
            String sql = "SELECT com.*, "
                    + "IFNULL(ecom.`LEVEL_VALUE`,0) AS LEVEL_VALUE "
                    + "FROM  `hr_view_position_competency_list` com "
                    + "INNER JOIN hr_employee emp "
                    + "ON com.`POSITION_ID` = emp.`POSITION_ID` "
                    + "LEFT JOIN hr_emp_competency ecom "
                    + "ON ecom.`EMPLOYEE_ID` = emp.`EMPLOYEE_ID` "
                    + "AND ecom.`COMPETENCY_ID` = com.`COMPETENCY_ID` "
                    + "WHERE com.`POSITION_ID` = '"+positionId+"' AND emp.employee_id = '"+employeeId+"' "
                    + "AND com.`GROUP_NAME` = '"+groupName+"' AND com.COMPETENCY_LEVEL_ID = '"+levelId+"' ";
                    
            //System.out.println("sql jumlah ::::::::::::::::::::::"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                boolean isTrue = true;
                int lvlDiv = rs.getInt("LEVEL_DIVISION");
                int lvlDept = rs.getInt("LEVEL_DEPARTMENT");
                int lvlSec = rs.getInt("LEVEL_SECTION");
                double scoreReq = rs.getDouble("SCORE_REQ_MIN");
                double scoreAcv = rs.getDouble("LEVEL_VALUE");
                if (lvlDiv > 0) {
                    if (lvlDiv != dvLevel) {
                        isTrue = false;
                    }
                }
                if (lvlDept > 0) {
                    if (lvlDept != depLvl) {
                        isTrue = false;
                    }
                }
                if (lvlSec > 0) {
                    if (lvlSec != secLvl) {
                        isTrue = false;
                    }
                }
                if (isTrue && scoreAcv > 0) {
                    count++;
                    pct += (scoreAcv / scoreReq) * 100.0;
                }
            }
            if (count > 0){
                pencapaian = pct / count;
            }
            
            rs.close();

        } catch (Exception ex) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return pencapaian;
    }
    
    public static int getTotalGapGroup(long employeeId, long positionId, String groupName, long levelId, int dvLevel, int depLvl, int secLvl, int type){
        double pencapaian = 0.0;
        JSONObject empScore = SessRptCompetency.getEmpCompetency(employeeId);
        JSONObject posScore = SessRptCompetency.getPosCompetency(positionId, levelId, dvLevel, depLvl, secLvl);
        DBResultSet dbrs = null;
        int gap = 0;
        try {
            String sql = "SELECT com.*, "
                    + "IFNULL(ecom.`LEVEL_VALUE`,0) AS LEVEL_VALUE "
                    + "FROM  `hr_view_position_competency_list` com "
                    + "INNER JOIN hr_employee emp "
                    + "ON com.`POSITION_ID` = emp.`POSITION_ID` "
                    + "LEFT JOIN hr_emp_competency ecom "
                    + "ON ecom.`EMPLOYEE_ID` = emp.`EMPLOYEE_ID` "
                    + "AND ecom.`COMPETENCY_ID` = com.`COMPETENCY_ID` "
                    + "WHERE com.`POSITION_ID` = '"+positionId+"' AND emp.employee_id = '"+employeeId+"' "
                    + "AND com.`GROUP_NAME` = '"+groupName+"' AND com.COMPETENCY_LEVEL_ID = '"+levelId+"' ";
                    
            //System.out.println("sql jumlah ::::::::::::::::::::::"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                boolean isTrue = true;
                int lvlDiv = rs.getInt("LEVEL_DIVISION");
                int lvlDept = rs.getInt("LEVEL_DEPARTMENT");
                int lvlSec = rs.getInt("LEVEL_SECTION");
                long comId = rs.getLong("COMPETENCY_ID");
                double scoreMin = rs.getDouble("SCORE_REQ_MIN");
                double req = posScore.optDouble(""+comId, 0.0);
                double score = empScore.optDouble(""+comId, 0.0);
                String yesNoD = empScore.optString(""+comId,null);
                if (lvlDiv > 0 || dvLevel != 0) {
                    if (lvlDiv != dvLevel) {
                        isTrue = false;
                    }
                }
                if (lvlDept > 0 || depLvl != 0) {
                    if (lvlDept != depLvl) {
                        isTrue = false;
                    }
                }
                if (lvlSec > 0 || secLvl != 0) {
                    if (lvlSec != secLvl) {
                        isTrue = false;
                    }
                }
                if (isTrue) {
                    if (req > 0){
                        if (type == 1){
                                    if(yesNoD == null){
                                         gap += (int) -1;
                                    }
                        } else {
                            if (score < req) {
                            gap += (int) (score-req);
                            }
                        }
                    }
                }
            }
            
            rs.close();

        } catch (Exception ex) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return gap;
    }
    
    public static int getTotalGapGroupAll(long employeeId, long positionId, long levelId, int dvLevel, int depLvl, int secLvl, int type){
        double pencapaian = 0.0;
        JSONObject empScore = SessRptCompetency.getEmpCompetency(employeeId);
        JSONObject posScore = SessRptCompetency.getPosCompetency(positionId, levelId, dvLevel, depLvl, secLvl);
        DBResultSet dbrs = null;
        int gap = 0;
        try {
            String sql = "SELECT com.*, "
                    + "IFNULL(ecom.`LEVEL_VALUE`,0) AS LEVEL_VALUE "
                    + "FROM  `hr_view_position_competency_list` com "
                    + "INNER JOIN hr_employee emp "
                    + "ON com.`POSITION_ID` = emp.`POSITION_ID` "
                    + "LEFT JOIN hr_emp_competency ecom "
                    + "ON ecom.`EMPLOYEE_ID` = emp.`EMPLOYEE_ID` "
                    + "AND ecom.`COMPETENCY_ID` = com.`COMPETENCY_ID` "
                    + "WHERE com.`POSITION_ID` = '"+positionId+"' AND emp.employee_id = '"+employeeId+"' "
                    + "AND com.COMPETENCY_LEVEL_ID = '"+levelId+"' ";
                    
            //System.out.println("sql jumlah ::::::::::::::::::::::"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                boolean isTrue = true;
                int lvlDiv = rs.getInt("LEVEL_DIVISION");
                int lvlDept = rs.getInt("LEVEL_DEPARTMENT");
                int lvlSec = rs.getInt("LEVEL_SECTION");
                long comId = rs.getLong("COMPETENCY_ID");
                double scoreMin = rs.getDouble("SCORE_REQ_MIN");
                double req = posScore.optDouble(""+comId, 0.0);
                double score = empScore.optDouble(""+comId, 0.0);
                String yesNoD = empScore.optString(""+comId,null);
                if (lvlDiv > 0 || dvLevel != 0) {
                    if (lvlDiv != dvLevel) {
                        isTrue = false;
                    }
                }
                if (lvlDept > 0 || depLvl != 0) {
                    if (lvlDept != depLvl) {
                        isTrue = false;
                    }
                }
                if (lvlSec > 0 || secLvl != 0 ) {
                    if (lvlSec != secLvl) {
                        isTrue = false;
                    }
                }
                if (isTrue) {
                    if (req > 0){
                        if (type == 1){
                                    if(yesNoD == null){
                                         gap += (int) -1;
                                    }
                        } else {
                            if (score < req) {
                            gap += (int) (score-req);
                            }
                        }
                    }
                }
            }
          
            rs.close();

        } catch (Exception ex) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return gap;
    }
    
    public static JSONObject getEmpCompetency(long employeeId){
        JSONObject obj = new JSONObject();
        
        DBResultSet dbrs = null;
        double count = 0;
        double pct = 0;
        try {
            String sql = "SELECT * "
                    + "FROM hr_emp_competency "
                    + "WHERE employee_id = "+employeeId;
            //System.out.println("sql jumlah ::::::::::::::::::::::"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                long compId = rs.getLong("COMPETENCY_ID");
                double levelValue = rs.getDouble("LEVEL_VALUE");
                obj.put(""+compId, levelValue);
            }
            
            rs.close();

        } catch (Exception ex) {
            return obj;
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return obj;
    }
    
    public static JSONObject getPosCompetency(long positionId, long levelId, int dvLevel, int depLvl, int secLvl) {
        JSONObject obj = new JSONObject();
        
        DBResultSet dbrs = null;
        double count = 0;
        double pct = 0;
        try {
            String sql = "SELECT * "
                    + "FROM hr_view_position_competency_list "
                    + "WHERE position_id = "+positionId+" AND competency_level_id = "+levelId;
            //System.out.println("sql jumlah ::::::::::::::::::::::"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                long compId = rs.getLong("COMPETENCY_ID");
                double scoreMin = rs.getDouble("SCORE_REQ_MIN");
                double scoreMax = rs.getDouble("SCORE_REQ_RECOMMENDED");
                boolean isTrue = true;
                int lvlDiv = rs.getInt("LEVEL_DIVISION");
                int lvlDept = rs.getInt("LEVEL_DEPARTMENT");
                int lvlSec = rs.getInt("LEVEL_SECTION");
                if (lvlDiv > 0) {
                    if (lvlDiv != dvLevel) {
                        isTrue = false;
                    }
                }
                if (lvlDept > 0) {
                    if (lvlDept != depLvl) {
                        isTrue = false;
                    }
                }
                if (lvlSec > 0) {
                    if (lvlSec != secLvl) {
                        isTrue = false;
                    }
                }
                if (isTrue) {
                    obj.put(""+compId, scoreMin);
                }
            }
            
            rs.close();

        } catch (Exception ex) {
            return obj;
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return obj;
    }

    /**
     * @return the typeName
     */
    public String getTypeName() {
        return typeName;
    }

    /**
     * @param typeName the typeName to set
     */
    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    /**
     * @return the groupName
     */
    public String getGroupName() {
        return groupName;
    }

    /**
     * @param groupName the groupName to set
     */
    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    /**
     * @return the competencyName
     */
    public String getCompetencyName() {
        return competencyName;
    }

    /**
     * @param competencyName the competencyName to set
     */
    public void setCompetencyName(String competencyName) {
        this.competencyName = competencyName;
    }

    /**
     * @return the minReq
     */
    public int getMinReq() {
        return minReq;
    }

    /**
     * @param minReq the minReq to set
     */
    public void setMinReq(int minReq) {
        this.minReq = minReq;
    }

    /**
     * @return the maxReq
     */
    public int getMaxReq() {
        return maxReq;
    }

    /**
     * @param maxReq the maxReq to set
     */
    public void setMaxReq(int maxReq) {
        this.maxReq = maxReq;
    }
       /**
     * @return the competencyId
     */
    public long getCompetencyId() {
        return competencyId;
    }

    /**
     * @param competencyId the competencyId to set
     */
    public void setCompetencyId(long competencyId) {
        this.competencyId = competencyId;
    }
}

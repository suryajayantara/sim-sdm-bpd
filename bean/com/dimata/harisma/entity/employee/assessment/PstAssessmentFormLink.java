
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.harisma.entity.employee.assessment; 

/* package java */ 
import com.dimata.harisma.entity.employee.*;
import java.io.*
;
import java.sql.*
;import java.util.*
;import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.util.*;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;

/* package harisma */
//import com.dimata.harisma.db.DBHandler;
//import com.dimata.harisma.db.DBException;
//import com.dimata.harisma.db.DBLogger;
import com.dimata.harisma.entity.employee.*; 
import com.dimata.harisma.entity.employee.appraisal.PstAppraisalMain;
import com.dimata.harisma.entity.masterdata.PstGroupRank;
import com.dimata.harisma.form.employee.appraisal.FrmAppraisalMain;

public class PstAssessmentFormLink extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language { 

	public static final  String TBL_HR_ASS_FORM_LINK = "hr_ass_form_link";

	public static final  int FLD_HR_ASS_FORM_LINK_ID   = 0;
	public static final  int FLD_HR_ASS_FORM_MAIN_ID_PARENT   = 1;
	public static final  int FLD_HR_ASS_FORM_MAIN_ID_CHILD   = 2;

	public static final  String[] fieldNames = {
            "HR_ASS_FORM_LINK_ID",
            "HR_ASS_FORM_MAIN_ID_PARENT",
            "HR_ASS_FORM_MAIN_ID_CHILD",
	 }; 

	public static final  int[] fieldTypes = {
            TYPE_LONG + TYPE_PK + TYPE_ID,
            TYPE_LONG,
            TYPE_LONG
	};

	public PstAssessmentFormLink(){
	}

	public PstAssessmentFormLink(int i) throws DBException { 
		super(new PstAssessmentFormLink()); 
	}

	public PstAssessmentFormLink(String sOid) throws DBException { 
		super(new PstAssessmentFormLink(0)); 
		if(!locate(sOid)) 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public PstAssessmentFormLink(long lOid) throws DBException { 
		super(new PstAssessmentFormLink(0)); 
		String sOid = "0"; 
		try { 
			sOid = String.valueOf(lOid); 
		}catch(Exception e) { 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		} 
		if(!locate(sOid)) 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		else 
			return; 
	} 

	public int getFieldSize(){ 
		return fieldNames.length; 
	}

	public String getTableName(){ 
		return TBL_HR_ASS_FORM_LINK;
	}

	public String[] getFieldNames(){ 
		return fieldNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new PstAssessmentFormLink().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		AssessmentFormLink assessmentFormLink = fetchExc(ent.getOID()); 
		ent = (Entity)assessmentFormLink; 
		return assessmentFormLink.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((AssessmentFormLink) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((AssessmentFormLink) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static AssessmentFormLink fetchExc(long oid) throws DBException{ 
		try{ 
			AssessmentFormLink assessmentFormLink = new AssessmentFormLink();
			PstAssessmentFormLink pstAssessmentFormLink = new PstAssessmentFormLink(oid); 
			assessmentFormLink.setOID(oid);

			assessmentFormLink.setHrAssFormMainIdParent(pstAssessmentFormLink.getLong(FLD_HR_ASS_FORM_MAIN_ID_PARENT));
			assessmentFormLink.setHrAssFormMainIdChild(pstAssessmentFormLink.getLong(FLD_HR_ASS_FORM_MAIN_ID_CHILD));
			return assessmentFormLink; 
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstAssessmentFormLink(0),DBException.UNKNOWN); 
		} 
	}

        public static AssessmentFormLink fetch(long oid) throws DBException{ 
		try{ 
                    
			AssessmentFormLink assessmentFormLink = new AssessmentFormLink();
			PstAssessmentFormLink pstAssessmentFormLink = new PstAssessmentFormLink(oid); 
			assessmentFormLink.setOID(oid);

			assessmentFormLink.setHrAssFormMainIdParent(pstAssessmentFormLink.getLong(FLD_HR_ASS_FORM_MAIN_ID_PARENT));
			assessmentFormLink.setHrAssFormMainIdChild(pstAssessmentFormLink.getLong(FLD_HR_ASS_FORM_MAIN_ID_CHILD));
			return assessmentFormLink; 
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstAssessmentFormLink(0),DBException.UNKNOWN); 
		} 
	}
	public static long insertExc(AssessmentFormLink assessmentFormLink) throws DBException{ 
		try{ 
			PstAssessmentFormLink pstAssessmentFormLink = new PstAssessmentFormLink(0);

			pstAssessmentFormLink.setLong(FLD_HR_ASS_FORM_MAIN_ID_PARENT, assessmentFormLink.getHrAssFormMainIdParent());
			pstAssessmentFormLink.setLong(FLD_HR_ASS_FORM_MAIN_ID_CHILD, assessmentFormLink.getHrAssFormMainIdChild());

			pstAssessmentFormLink.insert(); 
			assessmentFormLink.setOID(pstAssessmentFormLink.getlong(FLD_HR_ASS_FORM_LINK_ID));
                        
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstAssessmentFormLink(0),DBException.UNKNOWN); 
		}
		return assessmentFormLink.getOID();
	}
        
        public static long insert(AssessmentFormLink assessmentFormLink) throws DBException{ 
		try{ 
			PstAssessmentFormLink pstAssessmentFormLink = new PstAssessmentFormLink(0);

			pstAssessmentFormLink.setLong(FLD_HR_ASS_FORM_MAIN_ID_PARENT, assessmentFormLink.getHrAssFormMainIdParent());
			pstAssessmentFormLink.setLong(FLD_HR_ASS_FORM_MAIN_ID_CHILD, assessmentFormLink.getHrAssFormMainIdChild());

			pstAssessmentFormLink.insert(); 
			assessmentFormLink.setOID(pstAssessmentFormLink.getlong(FLD_HR_ASS_FORM_LINK_ID));
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstAssessmentFormLink(0),DBException.UNKNOWN); 
		}
		return assessmentFormLink.getOID();
	}

	public static long updateExc(AssessmentFormLink assessmentFormLink) throws DBException{ 
		try{ 
                    if(assessmentFormLink.getOID() != 0){ 
                        PstAssessmentFormLink pstAssessmentFormMain = new PstAssessmentFormLink(assessmentFormLink.getOID());

                        pstAssessmentFormMain.setLong(FLD_HR_ASS_FORM_MAIN_ID_PARENT, assessmentFormLink.getHrAssFormMainIdParent());
                        pstAssessmentFormMain.setLong(FLD_HR_ASS_FORM_MAIN_ID_CHILD, assessmentFormLink.getHrAssFormMainIdChild());
                        pstAssessmentFormMain.update(); 
                        return assessmentFormLink.getOID();
                    }
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstAssessmentFormLink(0),DBException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws DBException{ 
		try{ 
			PstAssessmentFormLink pstAssessmentFormLink = new PstAssessmentFormLink(oid);
			pstAssessmentFormLink.delete();
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstAssessmentFormLink(0),DBException.UNKNOWN); 
		}
		return oid;
	}

	public static Vector listAll(){ 
		return list(0, 500, "",""); 
	}

        
        public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector(); 
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + TBL_HR_ASS_FORM_LINK; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				AssessmentFormLink assessmentFormLink = new AssessmentFormLink();
				resultToObject(rs, assessmentFormLink);
				lists.add(assessmentFormLink);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e);
		}finally {
			DBResultSet.close(dbrs);
		}
			return new Vector();
	}
        /**
         * Keterangan: mencari list detail
         * @param limitStart
         * @param recordToGet
         * @param whereClause
         * @param order
         * @return 
         */     

	public static void resultToObject(ResultSet rs, AssessmentFormLink assessmentFormLink){
		try{
                    assessmentFormLink.setOID(rs.getLong(PstAssessmentFormLink.fieldNames[PstAssessmentFormLink.FLD_HR_ASS_FORM_LINK_ID]));
                    assessmentFormLink.setHrAssFormMainIdParent(rs.getLong(PstAssessmentFormLink.fieldNames[PstAssessmentFormLink.FLD_HR_ASS_FORM_MAIN_ID_PARENT]));
                    assessmentFormLink.setHrAssFormMainIdChild(rs.getLong(PstAssessmentFormLink.fieldNames[PstAssessmentFormLink.FLD_HR_ASS_FORM_MAIN_ID_CHILD]));
		}catch(Exception e){ }
	}

	public static boolean checkOID(long assessmentFormLinkId){
		DBResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + TBL_HR_ASS_FORM_LINK + " WHERE " + 
                                PstAssessmentFormLink.fieldNames[PstAssessmentFormLink.FLD_HR_ASS_FORM_LINK_ID] 
                                + " = " + assessmentFormLinkId;

			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			while(rs.next()) { result = true; }
			rs.close();
		}catch(Exception e){
			System.out.println("err : "+e.toString());
		}finally{
			DBResultSet.close(dbrs);
			return result;
		}
	}

	public static int getCount(String whereClause){
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ PstAssessmentFormLink.fieldNames[PstAssessmentFormLink.FLD_HR_ASS_FORM_LINK_ID] 
                                + ") FROM " + TBL_HR_ASS_FORM_LINK;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt(1); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			DBResultSet.close(dbrs);
		}
	}


	/* This method used to find current data */
	public static int findLimitStart( long oid, int recordToGet, String whereClause, String orderClause){
		int size = getCount(whereClause);
		int start = 0;
		boolean found =false;
		for(int i=0; (i < size) && !found ; i=i+recordToGet){
			 Vector list =  list(i,recordToGet, whereClause, orderClause); 
			 start = i;
			 if(list.size()>0){
			  for(int ls=0;ls<list.size();ls++){ 
			  	   AssessmentFormMain assessmentFormMain = (AssessmentFormMain)list.get(ls);
				   if(oid == assessmentFormMain.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	/* This method used to find command where current data */
	public static int findLimitCommand(int start, int recordToGet, int vectSize){
		 int cmd = Command.LIST;
		 int mdl = vectSize % recordToGet;
		 vectSize = vectSize + (recordToGet - mdl);
		 if(start == 0)
			 cmd =  Command.FIRST;
		 else{
			 if(start == (vectSize-recordToGet))
				 cmd = Command.LAST;
			 else{
				 start = start + recordToGet;
				 if(start <= (vectSize - recordToGet)){
					 cmd = Command.NEXT;
				 }else{
					 start = start - recordToGet;
					 if(start > 0){
						 cmd = Command.PREV;  
					 } 
				 }
			 } 
		 }
 
		 return cmd;
	}
        

        public static long deleteByAssFormMainId(long oid_ass_form_main)
        { 
           DBResultSet dbrs = null;
           try {
                String sql = "DELETE FROM " + PstAssessmentFormLink.TBL_HR_ASS_FORM_LINK+
                             " WHERE " + PstAssessmentFormLink.fieldNames[PstAssessmentFormLink.FLD_HR_ASS_FORM_MAIN_ID_PARENT] +
                             " = '" + oid_ass_form_main +"'";

                int status = DBHandler.execUpdate(sql);
                return status;            
           }catch(Exception e) {
                System.out.println(e);            
            }
            finally{
                DBResultSet.close(dbrs);
            }

            return 0;
        }
        
}

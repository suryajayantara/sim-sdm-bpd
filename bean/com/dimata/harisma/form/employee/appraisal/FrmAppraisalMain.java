/* 
 * Form Name  	:  FrmAppraisalMain.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	: karya 
 * @version  	: 01 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.harisma.form.employee.appraisal;

/* java package */ 
import com.dimata.harisma.entity.employee.appraisal.AppraisalMain;
import javax.servlet.http.HttpServletRequest;

/* qdep package */ 
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;

/* project package */


public class FrmAppraisalMain extends FRMHandler implements I_FRMInterface, I_FRMType 
{
	private AppraisalMain appraisalMain;

	public static final String FRM_APPRAISAL_MAIN   =  "FRM_APPRAISAL_MAIN" ;

	public static final  int FRM_FIELD_APP_MAIN_ID        = 0;
	public static final  int FRM_FIELD_EMPLOYEE_ID        = 1;
	public static final  int FRM_FIELD_EMP_POSITION_ID    = 2;
	public static final  int FRM_FIELD_EMP_DEPARTMENT_ID  = 3;
	public static final  int FRM_FIELD_EMP_LEVEL_ID       = 4;
	public static final  int FRM_FIELD_ASSESSOR_ID        = 5;
	public static final  int FRM_FIELD_ASS_POSITION_ID    = 6;
	public static final  int FRM_FIELD_DATE_ASS_POSITION  = 7;
	public static final  int FRM_FIELD_DATE_OF_ASS        = 8;
	public static final  int FRM_FIELD_DATE_OF_LAST_ASS   = 9;
	public static final  int FRM_FIELD_DATE_OF_NEXT_ASS   = 10;
	public static final  int FRM_FIELD_DATE_JOINED_HOTEL  = 11;
	public static final  int FRM_FIELD_TOTAL_ASSESSMENT   = 12;
	public static final  int FRM_FIELD_TOTAL_SCORE        = 13;
	public static final  int FRM_FIELD_SCORE_AVERAGE      = 14;
	public static final  int FRM_FIELD_DIVISION_HEAD_ID   = 15;
	public static final  int FRM_FIELD_EMP_SIGN_DATE      = 16;
	public static final  int FRM_FIELD_ASS_SIGN_DATE      = 17;
	public static final  int FRM_FIELD_DIV_HEAD_SIGN_DATE = 18;

        public static final int FRM_FIELD_APPROVAL_1_ID       = 19;
        public static final int FRM_FIELD_TIME_APPROVAL_1     = 20;   
        public static final int FRM_FIELD_APPROVAL_2_ID       = 21;
        public static final int FRM_FIELD_TIME_APPROVAL_2     = 22;   
        public static final int FRM_FIELD_APPROVAL_3_ID       = 23;
        public static final int FRM_FIELD_TIME_APPROVAL_3     = 24;   
        public static final int FRM_FIELD_APPROVAL_4_ID       = 25;
        public static final int FRM_FIELD_TIME_APPROVAL_4     = 26;   
        public static final int FRM_FIELD_APPROVAL_5_ID       = 27;
        public static final int FRM_FIELD_TIME_APPROVAL_5     = 28;   
        public static final int FRM_FIELD_APPROVAL_6_ID       = 29;
        public static final int FRM_FIELD_TIME_APPROVAL_6     = 30;   
        
        public static final int FRM_FIELD_DATA_PERIOD_FROM    = 31;
        public static final int FRM_FIELD_DATA_PERIOD_TO      = 32;
	public static String[] fieldNames = {
		"FRM_FIELD_HR_APP_MAIN_ID",
		"FRM_FIELD_EMPLOYEE_ID",
		"FRM_FIELD_EMP_POSITION_ID",
		"FRM_FIELD_EMP_DEPARTMENT_ID",
		"FRM_FIELD_LEVEL_ID",
		"FRM_FIELD_ASSESSOR_ID",
		"FRM_FIELD_ASS_POSITION_ID",
		"FRM_FIELD_DATE_ASSUMED_POSITION",
		"FRM_FIELD_DATE_OF_ASSESSMENT",
		"FRM_FIELD_DATE_OF_LAST_ASSESSMENT",
		"FRM_FIELD_DATE_OF_NEXT_ASSESSMENT",
		"FRM_FIELD_DATE_JOINED_HOTEL",
		"FRM_FIELD_TOTAL_ASSESSMENT",
		"FRM_FIELD_TOTAL_SCORE",
		"FRM_FIELD_SCORE_AVERAGE",
		"FRM_FIELD_DIVISION_HEAD",
		"FRM_FIELD_EMP_SIGN_DATE",
		"FRM_FIELD_ASS_SIGN_DATE",
		"FRM_FIELD_DIV_SIGN_DATE",
                "FRM_FIELD_APPROVAL_1_ID",
                "FRM_FIELD_TIME_APPROVAL_1",
                "FRM_FIELD_APPROVAL_2_ID",
                "FRM_FIELD_TIME_APPROVAL_2",
                "FRM_FIELD_APPROVAL_3_ID",
                "FRM_FIELD_TIME_APPROVAL_3",
                "FRM_FIELD_APPROVAL_4_ID",
                "FRM_FIELD_TIME_APPROVAL_4",
                "FRM_FIELD_APPROVAL_5_ID",
                "FRM_FIELD_TIME_APPROVAL_5",
                "FRM_FIELD_APPROVAL_6_ID",
                "FRM_FIELD_TIME_APPROVAL_6",
                "FRM_FIELD_DATA_PERIOD_FROM",
                "FRM_FIELD_DATA_PERIOD_TO"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_FLOAT,
                TYPE_LONG,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_DATE,
                TYPE_LONG,
                TYPE_DATE,
                TYPE_LONG,
                TYPE_DATE,
                TYPE_LONG,
                TYPE_DATE,
                TYPE_LONG,
                TYPE_DATE,
                TYPE_LONG,
                TYPE_DATE,
                TYPE_LONG,
                TYPE_DATE,
                TYPE_DATE,
                TYPE_DATE
	} ;

	public FrmAppraisalMain(){
	}
	public FrmAppraisalMain(AppraisalMain appraisalMain){
		this.appraisalMain = appraisalMain;
	}

	public FrmAppraisalMain(HttpServletRequest request, AppraisalMain appraisalMain){
		super(new FrmAppraisalMain(appraisalMain), request);
		this.appraisalMain = appraisalMain;
	}

	public String getFormName() { return FRM_APPRAISAL_MAIN; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public AppraisalMain getEntityObject(){ return appraisalMain; }

	public void requestEntityObject(AppraisalMain appraisalMain) {
		try{
			this.requestParam();
			appraisalMain.setAssesorId(getLong(FRM_FIELD_ASSESSOR_ID));
			appraisalMain.setAssesorPositionId(getLong(FRM_FIELD_ASS_POSITION_ID));
			appraisalMain.setDateAssumedPosition(getDate(FRM_FIELD_DATE_ASS_POSITION));
			appraisalMain.setDateOfAssessment(getDate(FRM_FIELD_DATE_OF_ASS));
			appraisalMain.setDateOfLastAssessment(getDate(FRM_FIELD_DATE_OF_LAST_ASS));
			appraisalMain.setDateOfNextAssessment(getDate(FRM_FIELD_DATE_OF_NEXT_ASS));
			appraisalMain.setEmpDepartmentId(getLong(FRM_FIELD_EMP_DEPARTMENT_ID));
			appraisalMain.setEmpLevelId(getLong(FRM_FIELD_EMP_LEVEL_ID));
			appraisalMain.setEmpPositionId(getLong(FRM_FIELD_EMP_POSITION_ID));
			appraisalMain.setEmployeeId(getLong(FRM_FIELD_EMPLOYEE_ID));
			appraisalMain.setDateJoinedHotel(getDate(FRM_FIELD_DATE_JOINED_HOTEL));
			appraisalMain.setTotalAssessment(getInt(FRM_FIELD_TOTAL_ASSESSMENT));
			appraisalMain.setTotalScore(getDouble(FRM_FIELD_TOTAL_SCORE));
			appraisalMain.setScoreAverage(getDouble(FRM_FIELD_SCORE_AVERAGE));
			appraisalMain.setDivisionHeadId(getLong(FRM_FIELD_DIVISION_HEAD_ID));
			appraisalMain.setEmployeeSignDate(getDate(FRM_FIELD_EMP_SIGN_DATE));
			appraisalMain.setAssessorSignDate(getDate(FRM_FIELD_ASS_SIGN_DATE));
			appraisalMain.setDivisionHeadSignDate(getDate(FRM_FIELD_DIV_HEAD_SIGN_DATE));
                        
                        appraisalMain.setApproval1Id(getLong(FRM_FIELD_APPROVAL_1_ID));
                        appraisalMain.setTimeApproval1(getDate(FRM_FIELD_TIME_APPROVAL_1));
                        appraisalMain.setApproval2Id(getLong(FRM_FIELD_APPROVAL_2_ID));
                        appraisalMain.setTimeApproval2(getDate(FRM_FIELD_TIME_APPROVAL_2));
                        appraisalMain.setApproval3Id(getLong(FRM_FIELD_APPROVAL_3_ID));
                        appraisalMain.setTimeApproval3(getDate(FRM_FIELD_TIME_APPROVAL_3));
                        appraisalMain.setApproval4Id(getLong(FRM_FIELD_APPROVAL_4_ID));
                        appraisalMain.setTimeApproval4(getDate(FRM_FIELD_TIME_APPROVAL_4));
                        appraisalMain.setApproval1Id(getLong(FRM_FIELD_APPROVAL_5_ID));
                        appraisalMain.setTimeApproval1(getDate(FRM_FIELD_TIME_APPROVAL_5));
                        appraisalMain.setApproval1Id(getLong(FRM_FIELD_APPROVAL_6_ID));
                        appraisalMain.setTimeApproval1(getDate(FRM_FIELD_TIME_APPROVAL_6));
                        appraisalMain.setDataPeriodFrom(getDate(FRM_FIELD_DATA_PERIOD_FROM));
                        appraisalMain.setDataPeriodTo(getDate(FRM_FIELD_DATA_PERIOD_TO));                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}

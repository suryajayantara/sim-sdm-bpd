/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.search;

/**
 *
 * @author Gunadi
 */

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 

/* qdep package */ 
import com.dimata.qdep.form.*;

/* project package */
import com.dimata.harisma.entity.search.*;

public class FrmSrcPeriodicalComp extends FRMHandler implements I_FRMInterface, I_FRMType{
    
    private SrcPeriodicalComp srcPeriodicalComp;
    
    public static final String FRM_NAME_PERIODICAL_COMP_REPORT = "FRM_NAME_PERIODICAL_COMP_REPORT";
    
    public static final int FRM_FIELD_EMP_NUMBER        =  0 ;
    public static final int FRM_FIELD_FULLNAME          =  1 ;
    public static final int FRM_FIELD_PERIOD_FROM       =  2 ;
    public static final int FRM_FIELD_PERIOD_TO         =  3 ;
    public static final int FRM_FIELD_ARR_COMPANY       =  4 ;
    public static final int FRM_FIELD_ARR_DIVISION      =  5 ;
    public static final int FRM_FIELD_ARR_DEPARTMENT    =  6 ;
    public static final int FRM_FIELD_ARR_SECTION       =  7 ;
    public static final int FRM_FIELD_ARR_POSITION      =  8 ;
    public static final int FRM_FIELD_COMPONENT_ID      =  9 ;
    public static final int FRM_FIELD_RESIGN_STATUS     = 10 ;
    public static final int FRM_FIELD_COMPARE_COMP_ID   = 11 ;
    public static final int FRM_FIELD_ARR_COMPONENT     = 12 ;
    
    public static String[] fieldNames = 
    {
            "FRM_FIELD_EMP_NUMBER",  
            "FRM_FIELD_FULLNAME",
            "FRM_FIELD_PERIOD_FROM",  
            "FRM_FIELD_PERIOD_TO",
            "FRM_FIELD_ARR_COMPANY",
            "FRM_FIELD_ARR_DIVISION",
            "FRM_FIELD_ARR_DEPARTMENT",
            "FRM_FIELD_ARR_SECTION",
            "FRM_FIELD_ARR_POSITION",
            "FRM_FIELD_COMPONENT_ID",
            "FRM_FIELD_RESIGN_STATUS",
            "FRM_FIELD_COMPARE_COMP_ID",
            "FRM_FIELD_ARR_COMPONENT"
    } ;
    
    public static int[] fieldTypes = {
		TYPE_STRING,  
                TYPE_STRING,
		TYPE_LONG,  
                TYPE_LONG,
		TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_LONG,
                TYPE_INT,
                TYPE_LONG,
                TYPE_STRING
	} ;
    
    public FrmSrcPeriodicalComp(){}
       
       public FrmSrcPeriodicalComp(SrcPeriodicalComp srcPeriodicalComp){
            this.srcPeriodicalComp = srcPeriodicalComp;
       }
       
       public FrmSrcPeriodicalComp(HttpServletRequest request, SrcPeriodicalComp srcPeriodicalComp){
		super(new FrmSrcPeriodicalComp(srcPeriodicalComp), request);
		this.srcPeriodicalComp = srcPeriodicalComp;
       }
       
       public String getFormName() { return FRM_NAME_PERIODICAL_COMP_REPORT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public SrcPeriodicalComp getEntityObject(){ return srcPeriodicalComp; }

	public void requestEntityObject(SrcPeriodicalComp srcPeriodicalComp) 
        {
		try
                {
			this.requestParam();
			srcPeriodicalComp.setEmpNum(getString(FRM_FIELD_EMP_NUMBER));
			srcPeriodicalComp.setFullName(getString(FRM_FIELD_FULLNAME));
			srcPeriodicalComp.setPeriodFrom(getLong(FRM_FIELD_PERIOD_FROM));
			srcPeriodicalComp.setPeriodTo(getLong(FRM_FIELD_PERIOD_TO));
                        srcPeriodicalComp.addArrCompany(getParamsStringValues(fieldNames[FRM_FIELD_ARR_COMPANY]));
			srcPeriodicalComp.addArrDivision(getParamsStringValues(fieldNames[FRM_FIELD_ARR_DIVISION]));
                        srcPeriodicalComp.addArrDepartment(getParamsStringValues(fieldNames[FRM_FIELD_ARR_DEPARTMENT]));
                        srcPeriodicalComp.addArrSection(getParamsStringValues(fieldNames[FRM_FIELD_ARR_SECTION]));
                        srcPeriodicalComp.addArrPosition(getParamsStringValues(fieldNames[FRM_FIELD_ARR_POSITION]));
                        srcPeriodicalComp.setComponentId(getLong(FRM_FIELD_COMPONENT_ID));
                        srcPeriodicalComp.setStatusResign(getInt(FRM_FIELD_RESIGN_STATUS));
                        srcPeriodicalComp.setCompareCompId(getLong(FRM_FIELD_COMPARE_COMP_ID));
                        srcPeriodicalComp.addArrComponent(getParamsStringValues(fieldNames[FRM_FIELD_ARR_COMPONENT]));
		}
                catch(Exception e)
                {
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}     
    
}

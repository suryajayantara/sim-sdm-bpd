/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.payroll;

import com.dimata.harisma.entity.employee.CareerPath;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstCareerPath;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.util.Formater;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;

/**
 * Date : 2016-03-07
 *
 * @author Dimata 007 | Hendra Putu
 */
public class ValueMappingProposional {

    private String fieldKey = "";
    private String valueKey = "";

    public double convertDouble(String val){
        BigDecimal bDecimal = new BigDecimal(Double.valueOf(val));
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_UP);
        return bDecimal.doubleValue();
    }
    /* Convert int */
    public int convertInteger(int scale, double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(scale, RoundingMode.HALF_UP);
        return bDecimal.intValue();
    }
    /* Decimal Format */
    public double customFormat(String pattern, double value ) {
        double outDouble = 0;
        DecimalFormat myFormatter = new DecimalFormat(pattern);
        String output = myFormatter.format(value);
        outDouble = Double.valueOf(output);
        return outDouble;
   }
    
    public String getDigit(int val) {
        String str = "";
        String nilai = String.valueOf(val);
        if (nilai.length() == 1) {
            str = "0" + nilai;
        } else {
            str = nilai;
        }
        return str;
    }

    /**
     * getRangeOfDate : mencari rentangan tanggal dari start date to end date.
     * misal : start date = 2015-09-09 To 2015-09-13, maka hasilnya::
     * 2015-09-09, 2015-09-10, 2015-09-11, 2015-09-12, 2015-09-13
     */
    public Vector<String> getRangeOfDate(String startDate, String endDate) {
        Vector<String> rangeDate = new Vector<String>();
        String[] arrStart = startDate.split("-");
        String[] arrEnd = endDate.split("-");

        int yearStart = Integer.valueOf(arrStart[0]);
        int monthStart = Integer.valueOf(arrStart[1]);
        int dayStart = Integer.valueOf(arrStart[2]);

        int yearEnd = Integer.valueOf(arrEnd[0]);
        int monthEnd = Integer.valueOf(arrEnd[1]);
        int dayEnd = Integer.valueOf(arrEnd[2]);

        String tanggal = "";
        if (yearStart != yearEnd) {
            for (int y = yearStart; y <= yearEnd; y++) {
                if (y < yearEnd) { // 2014-01-01 AND 2016-01-01 (2014-01-01, 2015-01-01, 2016-05-01)
                    if (monthStart == 1) {
                        for (int m = 1; m <= 12; m++) {
                            if (dayStart == 1) {
                                for (int d = 1; d <= 31; d++) {
                                    tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                    rangeDate.add(tanggal);
                                }
                            } else {
                                for (int d = dayStart; d <= 31; d++) {
                                    tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                    rangeDate.add(tanggal);
                                }
                                dayStart = 1;
                            }
                        }
                    } else {
                        for (int m = monthStart; m <= 12; m++) {
                            if (dayStart == 1) {
                                for (int d = 1; d <= 31; d++) {
                                    tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                    rangeDate.add(tanggal);
                                }
                            } else {
                                for (int d = dayStart; d <= 31; d++) {
                                    tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                    rangeDate.add(tanggal);
                                }
                                dayStart = 1;
                            }
                        }
                        monthStart = 1;
                    }
                } else {
                    if (monthStart == monthEnd) {
                        if (dayStart == dayEnd) {
                            tanggal = y + "-" + getDigit(monthStart) + "-" + getDigit(dayStart);
                            rangeDate.add(tanggal);
                        } else {
                            if (dayStart < dayEnd) {
                                for (int d = dayStart; d <= dayEnd; d++) {
                                    tanggal = y + "-" + getDigit(monthStart) + "-" + getDigit(d);
                                    rangeDate.add(tanggal);
                                }
                            }
                        }
                    } else {
                        if (monthStart < monthEnd) { // 2015-01-01 AND 2015-02-05
                            for (int m = monthStart; m <= monthEnd; m++) {
                                if (m < monthEnd) {
                                    if (dayStart == 1) {
                                        for (int d = 1; d <= 31; d++) {
                                            tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                            rangeDate.add(tanggal);
                                        }
                                    } else {
                                        if (dayStart > 1) {
                                            for (int d = dayStart; d <= 31; d++) {
                                                tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                                rangeDate.add(tanggal);
                                            }
                                        }
                                    }
                                } else {
                                    for (int d = 1; d <= dayEnd; d++) {
                                        tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                        rangeDate.add(tanggal);
                                    }
                                }

                            }
                        }
                    }
                }
            }
        } else {
            if (monthStart == monthEnd) {
                if (dayStart == dayEnd) {
                    tanggal = yearStart + "-" + getDigit(monthStart) + "-" + getDigit(dayStart);
                    rangeDate.add(tanggal);
                } else {
                    if (dayStart < dayEnd) {
                        for (int d = dayStart; d <= dayEnd; d++) {
                            tanggal = yearStart + "-" + getDigit(monthStart) + "-" + getDigit(d);
                            rangeDate.add(tanggal);
                        }
                    }
                }
            } else {
                if (monthStart < monthEnd) { // 2015-01-01 AND 2015-02-05
                    for (int m = monthStart; m <= monthEnd; m++) {
                        if (m < monthEnd) {
                            if (dayStart == 1) {
                                for (int d = 1; d <= 31; d++) {
                                    tanggal = yearStart + "-" + getDigit(m) + "-" + getDigit(d);
                                    rangeDate.add(tanggal);
                                }
                            } else {
                                if (dayStart > 1) {
                                    for (int d = dayStart; d <= 31; d++) {
                                        tanggal = yearStart + "-" + getDigit(m) + "-" + getDigit(d);
                                        rangeDate.add(tanggal);
                                    }
                                }
                            }
                        } else {
                            for (int d = 1; d <= dayEnd; d++) {
                                tanggal = yearStart + "-" + getDigit(m) + "-" + getDigit(d);
                                rangeDate.add(tanggal);
                            }
                        }

                    }
                }
            }
        }

        return rangeDate;
    }

    public double getValuemapping(String fromdate, String todate, String employeeId, String salaryComp, int useProposional) {
        DBResultSet dbrs = null;
        double nilai = 0;
        String test = "";
         Employee employee = new Employee(); 
        CareerPath careerPath = new CareerPath();
        String whereClause = " WHERE "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employeeId;
        Vector careerList = PstCareerPath.listCareerUnionDatabank(whereClause);
        int intPeriodFrom = PstCareerPath.getConvertDateToInt(fromdate);
        int intPeriodTo = PstCareerPath.getConvertDateToInt(todate);
        int intWorkFrom = 0;
        int intWorkTo = 0;
        int intCommencing = 0;
        boolean newEmployee = false;
        String dtNowStr = Formater.formatDate(new Date(), "yyyy-MM-dd");
        int intDtNow = PstCareerPath.getConvertDateToInt(dtNowStr);
        
        try {
            employee = PstEmployee.fetchExc(Long.valueOf(employeeId));
        } catch (Exception e) {
        }
        Calendar calComm = Calendar.getInstance();
        calComm.setTime(employee.getCommencingDate());
        intCommencing = PstCareerPath.getConvertDateToInt(""+employee.getCommencingDate());
        if (careerList != null && careerList.size()>0){
            if (intPeriodFrom > intDtNow){
                CareerPath career = (CareerPath)careerList.get(careerList.size()-1);
                careerPath = career;
            } else {
                for (int i=0; i<careerList.size(); i++){
                    CareerPath career = (CareerPath)careerList.get(i);
                    String workFrom = ""+career.getWorkFrom();
                    if (workFrom.equals("null")){
                        workFrom = ""+employee.getCommencingDate();
                    }
                    String workTo = ""+career.getWorkTo();
                    intWorkFrom = PstCareerPath.getConvertDateToInt(workFrom);
                    intWorkTo = PstCareerPath.getConvertDateToInt(workTo);
                    boolean ketemu = PstCareerPath.checkDataByPeriod(intWorkFrom, intWorkTo, intPeriodFrom, intPeriodTo);
                    if (ketemu){
                        try {
                            careerPath = career;
                        } catch (Exception exc){
                        }

                        try{
                            if (employee.getCommencingDate().getMonth() == career.getWorkFrom().getMonth() 
                                    && employee.getCommencingDate().getMonth() == career.getWorkTo().getMonth() 
                                    && employee.getCommencingDate().getYear() == career.getWorkFrom().getYear()){
                                newEmployee = true;
                            } else {
                                newEmployee = false;
                            }
                        } catch (Exception exc){

                        }
                    }
                }
            }
        }
        
        
        try {
            String sql = " SELECT * FROM " + PstValue_Mapping.TBL_VALUE_MAPPING + " WHERE "
                    + PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMP_CODE] + " = \"" + salaryComp + "\" "
                    + " AND ((" + PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_END_DATE]
                    + " >= \"" + fromdate + " 00:00:00" + "\" AND " + PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_START_DATE]
                    + " <= \"" + todate + " 00:00:00" + "\" "
                    + ") OR (END_DATE = \"0000-00-00  00:00:00\")  OR ( END_DATE IS NULL ) )";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                // Employee employee = PstEmployee.fetchExc(employeeId);

                long VmCompanyId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMPANY_ID]);
                long VmDivisionId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DIVISION_ID]);
                long VmDepartmentId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DEPARTMENT_ID]);
                long VmSectionId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_SECTION_ID]);
                long VmLevelId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_LEVEL_ID]);
                long VmMaritalId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_MARITAL_ID]);
                double VmLengthOfService = rs.getDouble(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_LENGTH_OF_SERVICE]);
                long VmEmpCategoryId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_EMPLOYEE_CATEGORY]);
                long VmPositionId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_POSITION_ID]);
                long VmEmployeeId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_EMPLOYEE_ID]);
                double VmValue = rs.getDouble(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_VALUE]);
                long VmGradeId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_GRADE]);
                int VmSex = rs.getInt(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_SEX]);

                java.util.Date today = new java.util.Date();
                boolean nilaitf = true;
                /* melakukan perbandingan ke object Employee */
                if ((VmCompanyId != 0) && (VmCompanyId > 0)) {
                    if (VmCompanyId != careerPath.getCompanyId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMPANY_ID]);
                        setValueKey("" + VmCompanyId);
                    }
                }

                if ((VmDivisionId != 0) && (VmDivisionId > 0)) {
                    if (VmDivisionId != careerPath.getDivisionId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DIVISION_ID]);
                        setValueKey("" + VmDivisionId);
                    }
                }
                if ((VmDepartmentId != 0) && (VmDepartmentId > 0)) {
                    if (VmDepartmentId != careerPath.getDepartmentId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DEPARTMENT_ID]);
                        setValueKey("" + VmDepartmentId);
                    }
                }
                if ((VmSectionId != 0) && (VmSectionId > 0)) {
                    if (VmSectionId != careerPath.getSectionId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_SECTION_ID]);
                        setValueKey("" + VmSectionId);
                    }
                }
                if ((VmPositionId != 0) && (VmPositionId > 0)) {
                    if (VmPositionId != careerPath.getPositionId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_POSITION_ID]);
                        setValueKey("" + VmPositionId);
                    }
                }
                if ((VmGradeId != 0) && (VmGradeId > 0)) {
                    if (VmGradeId != careerPath.getGradeLevelId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_GRADE]);
                        setValueKey("" + VmGradeId);
                    }
                }
                if ((VmEmpCategoryId != 0) && (VmEmpCategoryId > 0)) {
                    if (VmEmpCategoryId != careerPath.getEmpCategoryId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_EMPLOYEE_CATEGORY]);
                        setValueKey("" + VmEmpCategoryId);
                    }
                }
                if ((VmLevelId != 0) && (VmLevelId > 0)) {
                    if (VmLevelId != careerPath.getLevelId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_LEVEL_ID]);
                        setValueKey("" + VmLevelId);
                    }
                }
                if ((VmMaritalId != 0) && (VmMaritalId > 0)) {
                    if (VmMaritalId != employee.getMaritalId()) {
                        nilaitf = false;
                    }
                }
                if ((VmEmployeeId != 0) && (VmEmployeeId > 0)) {
                    if (VmEmployeeId != careerPath.getEmployeeId()) {
                        nilaitf = false;
                    }
                }

                if ((VmSex != -1) && (VmSex > -1)) {
                    if (VmSex != employee.getSex()) {
                        nilaitf = false;
                    }
                }

                if ((VmLengthOfService != 0) && (VmLengthOfService > 0)) {
                    double diff = today.getTime() - employee.getCommencingDate().getTime();
                    double yeardiff = diff / (1000 * 60 * 60 * 24 * 365);
                    if ((yeardiff != VmLengthOfService) || (yeardiff < VmLengthOfService)) {
                        nilaitf = false;
                    }
                }
                /* End melakukan perbandingan ke object Employee */
                if (nilaitf) {
                    if (intPeriodFrom < intWorkFrom && intWorkFrom < intPeriodTo && ( careerList.size() == 1 || newEmployee ) && useProposional != 0){
                        int rangeDate = 30 - calComm.get(Calendar.DATE) + 1;
                        nilai = (VmValue / 30) * rangeDate;
                    } else {
                        nilai = VmValue;
                    }
                }
            }
            //rs.close();
            return nilai;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return 0;
    }

    public double getValueMappingTotal(String periodFrom, String periodTo, String employeeId, String salaryComp) {
        Vector listRangeDate = new Vector();
        Vector listVMCareer = new Vector();
        String whereClause = "";
        int typeOfDecimalFormat = 0;
        int useProposional = 0;
        CareerPath careerPath = new CareerPath();
        Employee employee = new Employee();
        int rangeStart = -1;
        int rangeEnd = -1;
        whereClause = PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]+"='"+salaryComp+"'";
        Vector listComponent = PstPayComponent.list(0, 1, whereClause, "");
        if (listComponent != null && listComponent.size()>0){
            PayComponent payComp = (PayComponent)listComponent.get(0);
            typeOfDecimalFormat = payComp.getDecimalFormat();
            useProposional = payComp.getProporsionalCalculate();
        }
        // dapatkan value mapping current
        double valueCurrent = getValuemapping(periodFrom, periodTo, employeeId, salaryComp, useProposional);
        double valuePrevious = 0;
        double proporsionalCurr = 0;
        double proporsionalPrev = 0;
        double totalValue = 0;
        int amountPrev = 0;
        int amountCurr = 0;
        long oidCareerPath = 0;

        oidCareerPath = getCareerOid(periodFrom, employeeId);
        if (oidCareerPath != 0) {
            try {
                careerPath = PstCareerPath.fetchExc(oidCareerPath);
                employee = PstEmployee.fetchExc(careerPath.getEmployeeId());
            } catch (Exception e) {
                System.out.println("" + e.toString());
            }
            /* Get Range of Date from Career Path */
            if (careerPath != null) {
                listRangeDate = getRangeOfDate("" + careerPath.getWorkFrom(), "" + careerPath.getWorkTo());
                if (listRangeDate != null && listRangeDate.size() > 0) {
                    for (int r = 0; r < listRangeDate.size(); r++) {
                        String rDate = (String) listRangeDate.get(r);
                        if (rDate.equals(periodFrom)) {
                            rangeStart = r;
                        }
                        if (rDate.equals(periodTo)) {
                            rangeEnd = r;
                        }
                    }
                }
                if (rangeStart == -1) {
                    rangeStart = listRangeDate.size();
                }
                if (rangeEnd == -1) {
                    rangeEnd = listRangeDate.size();
                }

                amountPrev = rangeEnd - rangeStart;
                amountCurr = 30 - amountPrev;
            }
        } else {
            amountPrev = 0;
            amountCurr = 30;
        }
        

        if (valueCurrent != 0) {
            proporsionalCurr = (valueCurrent / 30) * amountCurr;
        } else {
            proporsionalCurr = valueCurrent;
        }
        /* Foccuss on valuePrevious */
        
        
        SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd");
        String resignDate = "0";
        int intResignDate = 0;
        if (employee.getResignedDate() != null){
            resignDate = sdf.format(employee.getResignedDate());
            intResignDate = PstCareerPath.getConvertDateToInt(resignDate);
        }
        int intPeriodFrom = PstCareerPath.getConvertDateToInt(periodFrom);
        
        
        
        
        if (oidCareerPath != 0 && (intResignDate >= intPeriodFrom || intResignDate == 0)) {
            whereClause = PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMP_CODE] + "='" + salaryComp + "' ";
            whereClause += " AND '" + periodFrom  + "' <= " + PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_END_DATE] + "";
            whereClause += " AND '" + periodFrom  + "' >= " + PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_START_DATE] + "";
            double nilaiVM = 0;
            listVMCareer = PstValue_Mapping.list(0, 0, whereClause, "");
            if (listVMCareer != null && listVMCareer.size() > 0) {
                for (int i = 0; i < listVMCareer.size(); i++) {
                    Value_Mapping valueMapping = (Value_Mapping) listVMCareer.get(i);
                    boolean perbandingan = true;
                    /* melakukan perbandingan ke object career path */
                    if (valueMapping.getCompany_id() != 0) {
                        if (valueMapping.getCompany_id() != careerPath.getCompanyId()) {
                            perbandingan = false;
                        }
                    }
                    if (valueMapping.getDivision_id() != 0) {
                        if (valueMapping.getDivision_id() != careerPath.getDivisionId()) {
                            perbandingan = false;
                        }
                    }
                    if (valueMapping.getDepartment_id() != 0) {
                        if (valueMapping.getDepartment_id() != careerPath.getDepartmentId()) {
                            perbandingan = false;
                        }
                    }
                    if (valueMapping.getSection_id() != 0) {
                        if (valueMapping.getSection_id() != careerPath.getSectionId()) {
                            perbandingan = false;
                        }
                    }
                    if (valueMapping.getLevel_id() != 0) {
                        if (valueMapping.getLevel_id() != careerPath.getLevelId()) {
                            perbandingan = false;
                        }
                    }
                    if (valueMapping.getEmployee_category() != 0) {
                        if (valueMapping.getEmployee_category() != careerPath.getEmpCategoryId()) {
                            perbandingan = false;
                        }
                    }
                    if (valueMapping.getPosition_id() != 0) {
                        if (valueMapping.getPosition_id() != careerPath.getPositionId()) {
                            perbandingan = false;
                        }
                    }
                    if (valueMapping.getGrade() != 0) {
                        if (valueMapping.getGrade() != careerPath.getGradeLevelId()) {
                            perbandingan = false;
                        }
                    } else {
                        //perbandingan = false; /* ? */
                    }
                    if (valueMapping.getEmployee_id() != 0){
                        if(valueMapping.getEmployee_id() != careerPath.getEmployeeId()) {
                            perbandingan = false;
                        }
                    }
                    if (perbandingan == true) {
                        nilaiVM = valueMapping.getValue();
                    }
                }

                valuePrevious = nilaiVM;
                proporsionalPrev = (valuePrevious / 30) * amountPrev;
            }
        } else {
            proporsionalPrev = valuePrevious;
        }
        /* do decimal format */
        switch(typeOfDecimalFormat){
            case 0:
                break;
            case 1:
                proporsionalPrev = customFormat("###.#", proporsionalPrev);
                proporsionalCurr = customFormat("###.#", proporsionalCurr);
                break;
            case 2:
                proporsionalPrev = customFormat("###.##", proporsionalPrev);
                proporsionalCurr = customFormat("###.##", proporsionalCurr);
                break; 
            case 3:
                proporsionalPrev = customFormat("###.###", proporsionalPrev);
                proporsionalCurr = customFormat("###.###", proporsionalCurr);
                break;
            case 4:
                proporsionalPrev = convertInteger(0, proporsionalPrev);
                proporsionalCurr = convertInteger(0, proporsionalCurr);
                break;
            case 5:
                proporsionalPrev = convertInteger(-1, proporsionalPrev);
                proporsionalCurr = convertInteger(-1, proporsionalCurr);
                break;
            case 6:
                proporsionalPrev = convertInteger(-2, proporsionalPrev);
                proporsionalCurr = convertInteger(-2, proporsionalCurr);
                break; 
            case 7:
                proporsionalPrev = convertInteger(-3, proporsionalPrev);
                proporsionalCurr = convertInteger(-3, proporsionalCurr);
                break;
        }
        if(useProposional == 0){
            totalValue = valueCurrent;
        } else {
            totalValue = proporsionalPrev + proporsionalCurr;
        }    
        return totalValue;
    }
    
    public double getValuemappingByCareerPath(String fromdate, String todate, long oidCareer, String salaryComp, int useProposional) {
        DBResultSet dbrs = null;
        double nilai = 0;
        String test = "";
        Employee employee = new Employee(); 
        CareerPath careerPath = new CareerPath();
        
        try {
            careerPath = PstCareerPath.fetchExc(oidCareer);
        } catch (Exception exc){
            System.out.println(exc.toString());
        }
 
        try {
            String sql = " SELECT * FROM " + PstValue_Mapping.TBL_VALUE_MAPPING + " WHERE "
                    + PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMP_CODE] + " = \"" + salaryComp + "\" "
                    + " AND ((" + PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_END_DATE]
                    + " >= \"" + fromdate + " 00:00:00" + "\" AND " + PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_START_DATE]
                    + " <= \"" + todate + " 00:00:00" + "\" "
                    + ") OR (END_DATE = \"0000-00-00  00:00:00\")  OR ( END_DATE IS NULL ) )";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                // Employee employee = PstEmployee.fetchExc(employeeId);

                long VmCompanyId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMPANY_ID]);
                long VmDivisionId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DIVISION_ID]);
                long VmDepartmentId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DEPARTMENT_ID]);
                long VmSectionId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_SECTION_ID]);
                long VmLevelId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_LEVEL_ID]);
                long VmMaritalId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_MARITAL_ID]);
                double VmLengthOfService = rs.getDouble(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_LENGTH_OF_SERVICE]);
                long VmEmpCategoryId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_EMPLOYEE_CATEGORY]);
                long VmPositionId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_POSITION_ID]);
                long VmEmployeeId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_EMPLOYEE_ID]);
                double VmValue = rs.getDouble(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_VALUE]);
                long VmGradeId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_GRADE]);
                int VmSex = rs.getInt(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_SEX]);

                java.util.Date today = new java.util.Date();
                boolean nilaitf = true;
                /* melakukan perbandingan ke object Employee */
                if ((VmCompanyId != 0) && (VmCompanyId > 0)) {
                    if (VmCompanyId != careerPath.getCompanyId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMPANY_ID]);
                        setValueKey("" + VmCompanyId);
                    }
                }

                if ((VmDivisionId != 0) && (VmDivisionId > 0)) {
                    if (VmDivisionId != careerPath.getDivisionId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DIVISION_ID]);
                        setValueKey("" + VmDivisionId);
                    }
                }
                if ((VmDepartmentId != 0) && (VmDepartmentId > 0)) {
                    if (VmDepartmentId != careerPath.getDepartmentId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DEPARTMENT_ID]);
                        setValueKey("" + VmDepartmentId);
                    }
                }
                if ((VmSectionId != 0) && (VmSectionId > 0)) {
                    if (VmSectionId != careerPath.getSectionId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_SECTION_ID]);
                        setValueKey("" + VmSectionId);
                    }
                }
                if ((VmPositionId != 0) && (VmPositionId > 0)) {
                    if (VmPositionId != careerPath.getPositionId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_POSITION_ID]);
                        setValueKey("" + VmPositionId);
                    }
                }
                if ((VmGradeId != 0) && (VmGradeId > 0)) {
                    if (VmGradeId != careerPath.getGradeLevelId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_GRADE]);
                        setValueKey("" + VmGradeId);
                    }
                }
                if ((VmEmpCategoryId != 0) && (VmEmpCategoryId > 0)) {
                    if (VmEmpCategoryId != careerPath.getEmpCategoryId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_EMPLOYEE_CATEGORY]);
                        setValueKey("" + VmEmpCategoryId);
                    }
                }
                if ((VmLevelId != 0) && (VmLevelId > 0)) {
                    if (VmLevelId != careerPath.getLevelId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_LEVEL_ID]);
                        setValueKey("" + VmLevelId);
                    }
                }
                if ((VmMaritalId != 0) && (VmMaritalId > 0)) {
                    if (VmMaritalId != employee.getMaritalId()) {
                        nilaitf = false;
                    }
                }
                if ((VmEmployeeId != 0) && (VmEmployeeId > 0)) {
                    if (VmEmployeeId != careerPath.getEmployeeId()) {
                        nilaitf = false;
                    }
                }

                if ((VmSex != -1) && (VmSex > -1)) {
                    if (VmSex != employee.getSex()) {
                        nilaitf = false;
                    }
                }

                if ((VmLengthOfService != 0) && (VmLengthOfService > 0)) {
                    double diff = today.getTime() - employee.getCommencingDate().getTime();
                    double yeardiff = diff / (1000 * 60 * 60 * 24 * 365);
                    if ((yeardiff != VmLengthOfService) || (yeardiff < VmLengthOfService)) {
                        nilaitf = false;
                    }
                }
                /* End melakukan perbandingan ke object Employee */
                if (nilaitf) {
                    nilai = VmValue;
                }
            }
            //rs.close();
            return nilai;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return 0;
    }    
    
    public long getCareerOid(String periodFrom, String employeeId){
        long oidCareer = 0;
        String whereClause = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employeeId+ " AND "
                            + ""+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE] + " IN ("+PstCareerPath.CAREER_TYPE+","+PstCareerPath.PEJABAT_SEMENTARA_TYPE+") AND "
                            + ""+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP] + " != 1" ;
        Vector listCareer = PstCareerPath.list(0, 0, whereClause, "");
        if (listCareer != null && listCareer.size()>0){
            for(int i=0; i<listCareer.size(); i++){
                CareerPath career = (CareerPath)listCareer.get(i);
                Vector listRangeDate = getRangeOfDate("" + career.getWorkFrom(), "" + career.getWorkTo());
                if (listRangeDate != null && listRangeDate.size() > 0) {
                    for (int r = 0; r < listRangeDate.size(); r++) {
                        String rDate = (String) listRangeDate.get(r);
                        if (rDate.equals(periodFrom)) {
                            oidCareer = career.getOID();
                        }
                    }
                }
            }
        }
        return oidCareer;
    }
    
    public double getRapelValMap(long employeeId, String payComp, long periodNow){
        double value = 0.0;
        
        if (periodNow != 0){
            PayPeriod period = new PayPeriod();
            try{
                period = PstPayPeriod.fetchExc(periodNow);
            } catch (Exception exc){
                System.out.println("Exception on PstPayslip getRapelValMap :"+exc.toString());
            }
            
            double currentValue = PstPaySlip.getCompValue(employeeId, period, payComp);
            String periodFrom = ""+period.getStartDate();
            String periodTo = ""+period.getEndDate();
            double newValue = getValuemapping(periodFrom, periodTo, ""+employeeId, payComp, 0);
            
            if (currentValue < newValue){
                value = newValue - currentValue;
            }
            
        }
        
        return value;
    }
    
    public double getRapel(long employeeId, String payComp, long periodNow){
        double rapel = 0.0;
        
        if (periodNow != 0){
            
            PayPeriod period = new PayPeriod();
            
            try {
                period = PstPayPeriod.fetchExc(periodNow);
            } catch (Exception exc){}
            
            Calendar cPeriod = Calendar.getInstance();
            cPeriod.setTime(period.getStartDate());
            int year = cPeriod.get(Calendar.YEAR);
            Vector lastCareer = PstCareerPath.getLastGradeHistory(employeeId, year);

            if (lastCareer.size() == 1){
                //double compValue = PstPaySlipComp.getCompValueEmployeeDouble(employeeId, periodNow, payComp);
                
                String periodFrom = "";
                String periodTo = "";
                
                try {
                    periodFrom = ""+period.getStartDate();
                    periodTo = ""+period.getEndDate();
                } catch (Exception exc){
                    System.out.println(exc.toString()+ " on getRapel() getting period ");
                }
                
                //if (compValue == 0){
                   double compValue = getValuemapping(periodFrom, periodTo, ""+employeeId, payComp, 0);
                //}
                
                CareerPath career = (CareerPath) lastCareer.get(0);
                Date workTo = career.getWorkTo();
                Calendar c = Calendar.getInstance();
                c.setTime(workTo);
                c.add(Calendar.DATE, 1);
                
                String wherePeriod = PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE] +
                                    " BETWEEN '"+ Formater.formatDate(c.getTime(), "yyyy-MM-dd")+"' AND '"
                                    + Formater.formatDate(period.getStartDate(), "yyyy-MM-dd")+"'" ;
                //String wherePeriod = PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE] + "> '"+ Formater.formatDate(workTo, "yyyy-MM-dd")+"'";
                Vector listPeriod = PstPayPeriod.list(0, 0, wherePeriod, "");
                if (listPeriod.size() > 0){
                    for (int i=0; i < listPeriod.size(); i++){
                        PayPeriod payPeriod = (PayPeriod) listPeriod.get(i);
                        
                        
                        double currentValue = getValuemappingByCareerPath(""+payPeriod.getStartDate(),""+payPeriod.getEndDate(),career.getOID(), payComp,0);

                        if (currentValue < compValue){
                            rapel = rapel + compValue - currentValue;
                        }
                    }
                }
            } else if (lastCareer.size() > 1){
                CareerPath careerPrev = (CareerPath) lastCareer.get(0);
                CareerPath careerNow = (CareerPath) lastCareer.get(lastCareer.size()-1);
                /* Begin mencari value gaji sekarang */
                long periodCareerNow = 0;
                try {
                    periodCareerNow = PstPayPeriod.getPayPeriodeIdBetween(careerNow.getWorkTo());
                } catch (Exception exc){
                    System.out.println("exception on getting Career Now PeriodId :"+exc.toString());
                }
                
                //double compValue = PstPaySlipComp.getCompValueEmployeeDouble(employeeId, periodCareerNow, payComp);
                
                PayPeriod payPeriodNow = new PayPeriod();
                
                String periodFrom = "";
                String periodTo = "";
                
                try {
                    payPeriodNow = PstPayPeriod.fetchExc(periodCareerNow);
                    periodFrom = ""+payPeriodNow.getStartDate();
                    periodTo = ""+payPeriodNow.getEndDate();
                } catch (Exception exc){
                    System.out.println(exc.toString()+ " on getRapel() getting period ");
                }
                
                //if (compValue == 0){
                  double compValue = getValuemappingByCareerPath(periodFrom, periodTo, careerNow.getOID(), payComp, 0);
                //}
                /* End mencari value gaji sekarang  */
                
                /* Start perhitungan selisih */
                Date workTo = careerPrev.getWorkTo();
                Calendar c = Calendar.getInstance();
                c.setTime(workTo);
                c.add(Calendar.DATE, 1);
                
                String wherePeriod = PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE] +
                                    " BETWEEN '"+ Formater.formatDate(c.getTime(), "yyyy-MM-dd")+"' AND '"
                                    + Formater.formatDate(payPeriodNow.getStartDate(), "yyyy-MM-dd")+"'" ;
                //String wherePeriod = PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE] + "> '"+ Formater.formatDate(workTo, "yyyy-MM-dd")+"'";
                Vector listPeriod = PstPayPeriod.list(0, 0, wherePeriod, "");
                if (listPeriod.size() > 0){
                    for (int i=0; i < listPeriod.size(); i++){
                        PayPeriod payPeriod = (PayPeriod) listPeriod.get(i);
                        
                        
                        double currentValue = getValuemappingByCareerPath(""+payPeriod.getStartDate(),""+payPeriod.getEndDate(),careerPrev.getOID(), payComp,0);

                        if (currentValue < compValue){
                            rapel = rapel + compValue - currentValue;
                        }
                    }
                }
                /* End perhitungan selisih */
            }
        }
        
        return rapel;
    }

    /**
     * @return the fieldKey
     */
    public String getFieldKey() {
        return fieldKey;
    }

    /**
     * @param fieldKey the fieldKey to set
     */
    public void setFieldKey(String fieldKey) {
        this.fieldKey = fieldKey;
    }

    /**
     * @return the valueKey
     */
    public String getValueKey() {
        return valueKey;
    }

    /**
     * @param valueKey the valueKey to set
     */
    public void setValueKey(String valueKey) {
        this.valueKey = valueKey;
    }
}

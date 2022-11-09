/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author Dimata 007
 */
import com.dimata.qdep.entity.Entity;

public class EmpDocSeries extends Entity {

    private long companyId = 0;
    private long divisionId = 0;
    private long departmentId = 0;
    private long sectionId = 0;
    private String nomorDocSeries = "";

    public long getCompanyId() {
        return companyId;
    }

    public void setCompanyId(long companyId) {
        this.companyId = companyId;
    }

    public long getDivisionId() {
        return divisionId;
    }

    public void setDivisionId(long divisionId) {
        this.divisionId = divisionId;
    }

    public long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
    }

    public long getSectionId() {
        return sectionId;
    }

    public void setSectionId(long sectionId) {
        this.sectionId = sectionId;
    }

    public String getNomorDocSeries() {
        return nomorDocSeries;
    }

    public void setNomorDocSeries(String nomorDocSeries) {
        this.nomorDocSeries = nomorDocSeries;
    }
}
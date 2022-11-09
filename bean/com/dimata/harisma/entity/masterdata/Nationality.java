/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author khirayinnura
 */
public class Nationality extends Entity {
    private long nationalityId = 0;
    private String nationalityCode = "";
    private String nationalityName = "";
    private int nationalityType = 0;

    /**
     * @return the nationalityId
     */
    public long getNationalityId(){
        return nationalityId;
    }

    /**
     * @param nationalityId the nationalityId to set
     */
    public void setNationalityId(long nationalityId) {
        this.nationalityId = nationalityId;
    }

    /**
     * @return the nationalityCode
     */
    public String getNationalityCode() {
        return nationalityCode;
    }

    /**
     * @param nationalityCode the nationalityCode to set
     */
    public void setNationalityCode(String nationalityCode) {
        this.nationalityCode = nationalityCode;
    }

    /**
     * @return the nationalityName
     */
    public String getNationalityName() {
        return nationalityName;
    }

    /**
     * @param nationalityName the nationalityName to set
     */
    public void setNationalityName(String nationalityName) {
        this.nationalityName = nationalityName;
    }

    /**
     * @return the nationalityType
     */
    public int getNationalityType() {
        return nationalityType;
    }

    /**
     * @param nationalityType the nationalityType to set
     */
    public void setNationalityType(int nationalityType) {
        this.nationalityType = nationalityType;
    }
}

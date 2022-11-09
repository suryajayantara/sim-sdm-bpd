/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author gndiw
 */

import com.dimata.qdep.entity.Entity;

public class DivisionGroupMapJv extends Entity {
 
    private long divisionGroupCodeId = 0;
    private long divisionCodeId = 0;
    private String accountName = "";
    private String accountNumber = "";

    /**
     * @return the divisionGroupCodeId
     */
    public long getDivisionGroupCodeId() {
        return divisionGroupCodeId;
    }

    /**
     * @param divisionGroupCodeId the divisionGroupCodeId to set
     */
    public void setDivisionGroupCodeId(long divisionGroupCodeId) {
        this.divisionGroupCodeId = divisionGroupCodeId;
    }

    /**
     * @return the divisionCodeId
     */
    public long getDivisionCodeId() {
        return divisionCodeId;
    }

    /**
     * @param divisionCodeId the divisionCodeId to set
     */
    public void setDivisionCodeId(long divisionCodeId) {
        this.divisionCodeId = divisionCodeId;
    }

    /**
     * @return the accountName
     */
    public String getAccountName() {
        return accountName;
    }

    /**
     * @param accountName the accountName to set
     */
    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    /**
     * @return the accountNumber
     */
    public String getAccountNumber() {
        return accountNumber;
    }

    /**
     * @param accountNumber the accountNumber to set
     */
    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }
    
}

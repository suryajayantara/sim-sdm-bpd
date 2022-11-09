/*
 * PaySlipComp.java
 *
 * Created on April 26, 2007, 2:33 PM
 */
package com.dimata.harisma.entity.payroll;

/* package java */
import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

/**
 *
 * @author yunny
 */
/**
 * Creates a new instance of PaySlipComp
 */
public class PaySlipComp extends Entity {

    private long paySlipId = 0;
    private String compCode = "";
    private double compValue = 0;

    /*
     public long getPaySlipId(){ 
     return this.getOID(0); 
     } 

     public void setPaySlipId(long paySlipId){ 
     this.setOID(0, paySlipId); 
     } 
     */
    /**
     * @return the paySlipId
     */
    public long getPaySlipId() {
        return paySlipId;
    }

    /**
     * @param paySlipId the paySlipId to set
     */
    public void setPaySlipId(long paySlipId) {
        this.paySlipId = paySlipId;
    }

    /**
     * Getter for property compCode.
     *
     * @return Value of property compCode.
     */
    public String getCompCode() {
        return compCode;
    }

    /**
     * Setter for property compCode.
     *
     * @param compCode New value of property compCode.
     */
    public void setCompCode(String compCode) {
        this.compCode = compCode;
    }

    /**
     * Getter for property compValue.
     *
     * @return Value of property compValue.
     */
    public double getCompValue() {
        return compValue;
    }

    /**
     * Setter for property compValue.
     *
     * @param compValue New value of property compValue.
     */
    public void setCompValue(double compValue) {
        this.compValue = compValue;
    }
}

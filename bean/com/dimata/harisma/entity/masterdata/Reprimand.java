/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.harisma.entity.masterdata;

import java.util.Date;
import com.dimata.qdep.entity.*;
/**
 *
 * @author Wiweka
 */
public class Reprimand extends Entity{

    /**
     * @return the showInCV
     */
    public int getShowInCV() {
        return showInCV;
    }

    /**
     * @param showInCV the showInCV to set
     */
    public void setShowInCV(int showInCV) {
        this.showInCV = showInCV;
    }

    private String reprimandDesc = "";
    private int reprimandPoint=0;
    private int validUntil=0;
    private int satuanValidUntil=0;
    private int showInCV=0;

    
    /**
     * @return the reprimandPoint
     */
    public int getReprimandPoint() {
        return reprimandPoint;
    }

    /**
     * @param reprimandPoint the reprimandPoint to set
     */
    public void setReprimandPoint(int reprimandPoint) {
        this.reprimandPoint = reprimandPoint;
    }

    /**
     * @return the reprimandDesc
     */
    public String getReprimandDesc() {
        return reprimandDesc;
    }

    /**
     * @param reprimandDesc the reprimandDesc to set
     */
    public void setReprimandDesc(String reprimandDesc) {
        this.reprimandDesc = reprimandDesc;
    }

    
   
    /**
     * @return the validUntil
     */
    public int getValidUntil() {
        return validUntil;
    }

    /**
     * @param validUntil the validUntil to set
     */
    public void setValidUntil(int validUntil) {
        this.validUntil = validUntil;
    }

    /**
     * @return the satuanValidUntil
     */
    public int getSatuanValidUntil() {
        return satuanValidUntil;
    }

    /**
     * @param satuanValidUntil the satuanValidUntil to set
     */
    public void setSatuanValidUntil(int satuanValidUntil) {
        this.satuanValidUntil = satuanValidUntil;
    }

}

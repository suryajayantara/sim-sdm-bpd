/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author Dimata 007
 */
public class CompetencyType  extends Entity {
    private String typeName = "";
    private String note = "";
    private int accumulate = 0;

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
     * @return the note
     */
    public String getNote() {
        return note;
    }

    /**
     * @param note the note to set
     */
    public void setNote(String note) {
        this.note = note;
    }

    /**
     * @return the accumulate
     */
    public int getAccumulate() {
        return accumulate;
    }

    /**
     * @param accumulate the accumulate to set
     */
    public void setAccumulate(int accumulate) {
        this.accumulate = accumulate;
    }
}

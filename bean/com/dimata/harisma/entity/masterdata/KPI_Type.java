/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author GUSWIK
 */
    public class KPI_Type extends Entity {

    private long kpi_type_id;
    private String type_name = "";
    private String description = "";
    private int indexing = 0;
    private long kpi_setting_type_id = 0;

    public long getKpi_type_id() {
        return kpi_type_id;
    }

    public void setKpi_type_id(long kpi_type_id) {
        this.kpi_type_id = kpi_type_id;
    }

    public String getType_name() {
        return type_name;
    }

    public void setType_name(String type_name) {
        this.type_name = type_name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getIndexing() {
        return indexing;
    }

    public void setIndexing(int indexing) {
        this.indexing = indexing;
    }
    
    public long getKpiSettingTypeId() {
        return kpi_setting_type_id;
    }

    public void setKpiSettingTypeId(long kpi_setting_type_id) {
        this.kpi_setting_type_id = kpi_setting_type_id;
    }

}

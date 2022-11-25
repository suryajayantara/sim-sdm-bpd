/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author GUSWIK
 */
public class KPI_List extends Entity {



    private long kpi_list_id;
    private long company_id;
    private String kpi_title = "";
    private String description = "";
    private Date valid_from;
    private Date valid_to;
    private String value_type;
    private int inputType = 0;
    private long parentId;
    private Vector<Long> arrkpigroup = new Vector();
    private Vector<Long> arrkpiposition = new Vector();
    private int korelasi = 0;
    private float rangeStart = 0;
    private float rangeEnd = 0;
    private long kpiDistributionId;

    /**
     * @return the kpi_list_id
     */
    public long getKpi_list_id() {
        return kpi_list_id;
    }

    /**
     * @param kpi_list_id the kpi_list_id to set
     */
    public void setKpi_list_id(long kpi_list_id) {
        this.kpi_list_id = kpi_list_id;
    }

    /**
     * @return the company_id
     */
    public long getCompany_id() {
        return company_id;
    }

    /**
     * @param company_id the company_id to set
     */
    public void setCompany_id(long company_id) {
        this.company_id = company_id;
    }

    /**
     * @return the kpi_title
     */
    public String getKpi_title() {
        return kpi_title;
    }

    /**
     * @param kpi_title the kpi_title to set
     */
    public void setKpi_title(String kpi_title) {
        this.kpi_title = kpi_title;
    }

    /**
     * @return the description
     */
    public String getDescription() {
        return description;
    }

    /**
     * @param description the description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * @return the valid_from
     */
    public Date getValid_from() {
        return valid_from;
    }

    /**
     * @param valid_from the valid_from to set
     */
    public void setValid_from(Date valid_from) {
        this.valid_from = valid_from;
    }

    /**
     * @return the valid_to
     */
    public Date getValid_to() {
        return valid_to;
    }

    /**
     * @param valid_to the valid_to to set
     */
    public void setValid_to(Date valid_to) {
        this.valid_to = valid_to;
    }

    /**
     * @return the value_type
     */
    public String getValue_type() {
        return value_type;
    }

    /**
     * @param value_type the value_type to set
     */
    public void setValue_type(String value_type) {
        this.value_type = value_type;
    }

    public int getArrkpigroupSize() {
        return arrkpigroup == null ? 0 : arrkpigroup.size();
    }

    /**
     * @return the arrMaritalId
     */
    public Long getArrkpigroup(int idx) {
        //return arrMaritalId;

        if ((arrkpigroup == null) || (idx >= arrkpigroup.size())) {
            return null;
        }
        return arrkpigroup.get(idx);
    }

    /**
     * @param arrMaritalId the arrMaritalId to set
     */
    public void addArrkpigroup(String[] arrkpigroup) {
        //this.arrMaritalId = arrMaritalId;
        if (arrkpigroup != null) {
            for (int i = 0; i < arrkpigroup.length; i++) {
                try {
                    this.arrkpigroup.add(new Long(arrkpigroup[i]));
                } catch (Exception e) {

                }
            }

        }
    }

    public int getArrkpipositionSize() {
        return arrkpiposition == null ? 0 : arrkpiposition.size();
    }

    /**
     * @return the arrMaritalId
     */
    public Long getArrkpiposition(int idx) {
        //return arrMaritalId;

        if ((arrkpiposition == null) || (idx >= arrkpiposition.size())) {
            return null;
        }
        return arrkpiposition.get(idx);
    }

    /**
     * @param arrMaritalId the arrMaritalId to set
     */
    public void addArrkpiposition(String[] arrkpiposition) {
        //this.arrMaritalId = arrMaritalId;
        if (arrkpiposition != null) {
            for (int i = 0; i < arrkpiposition.length; i++) {
                try {
                    this.arrkpiposition.add(new Long(arrkpiposition[i]));
                } catch (Exception e) {

                }
            }

        }
    }

    /**
     * @return the inputType
     */
    public int getInputType() {
        return inputType;
    }

    /**
     * @param inputType the inputType to set
     */
    public void setInputType(int inputType) {
        this.inputType = inputType;
    }

    /**
     * @return the parentId
     */
    public long getParentId() {
        return parentId;
    }

    /**
     * @param parentId the parentId to set
     */
    public void setParentId(long parentId) {
        this.parentId = parentId;
    }

    /**
     * @return the korelasi
     */
    public int getKorelasi() {
        return korelasi;
    }

    /**
     * @param korelasi the korelasi to set
     */
    public void setKorelasi(int korelasi) {
        this.korelasi = korelasi;
    }

    /**
     * @return the rangeStart
     */
    public float getRangeStart() {
        return rangeStart;
    }

    /**
     * @param rangeStart the rangeStart to set
     */
    public void setRangeStart(float rangeStart) {
        this.rangeStart = rangeStart;
    }

    /**
     * @return the rangeEnd
     */
    public float getRangeEnd() {
        return rangeEnd;
    }

    /**
     * @param rangeEnd the rangeEnd to set
     */
    public void setRangeEnd(float rangeEnd) {
        this.rangeEnd = rangeEnd;
    }
    
        /**
     * @return the kpiDistributionId
     */
    public long getKpiDistributionId() {
        return kpiDistributionId;
    }

    /**
     * @param kpiDistributionId the kpiDistributionId to set
     */
    public void setKpiDistributionId(long kpiDistributionId) {
        this.kpiDistributionId = kpiDistributionId;
    }
}

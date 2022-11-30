/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;
import java.util.Date;

/**
 *
 * @author IanRizky
 */
public class KpiTargetDetail extends Entity {

	private long kpiTargetId = 0;
	private long kpiGroupId = 0;
	private long kpiId = 0;
	private int period = 0;
	private Date dateFrom = null;
	private Date dateTo = null;
	private double amount = 0;
	private double weightValue = 0;
	private long kpiSettingListId = 0;

	public long getKpiTargetId() {
		return kpiTargetId;
	}

	public void setKpiTargetId(long kpiTargetId) {
		this.kpiTargetId = kpiTargetId;
	}

	public long getKpiId() {
		return kpiId;
	}

	public void setKpiId(long kpiId) {
		this.kpiId = kpiId;
	}

	public int getPeriod() {
		return period;
	}

	public void setPeriod(int period) {
		this.period = period;
	}

	public Date getDateFrom() {
		return dateFrom;
	}

	public void setDateFrom(Date dateFrom) {
		this.dateFrom = dateFrom;
	}

	public Date getDateTo() {
		return dateTo;
	}

	public void setDateTo(Date dateTo) {
		this.dateTo = dateTo;
	}

	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	/**
	 * @return the kpiGroupId
	 */
	public long getKpiGroupId() {
		return kpiGroupId;
	}

	/**
	 * @param kpiGroupId the kpiGroupId to set
	 */
	public void setKpiGroupId(long kpiGroupId) {
		this.kpiGroupId = kpiGroupId;
	}

	/**
	 * @return the weightValue
	 */
	public double getWeightValue() {
		return weightValue;
	}

	/**
	 * @param weightValue the weightValue to set
	 */
	public void setWeightValue(double weightValue) {
		this.weightValue = weightValue;
	}
        
        public long getKpiSettingListId() {
		return kpiSettingListId;
	}

	public void setKpiSettingListId(long kpiSettingListId) {
		this.kpiSettingListId = kpiSettingListId;
	}
}
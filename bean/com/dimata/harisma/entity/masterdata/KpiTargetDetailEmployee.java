/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author IanRizky
 */
public class KpiTargetDetailEmployee extends Entity {

	private long kpiTargetDetailId = 0;
	private long employeeId = 0;
        private double bobot = 0;

	public long getKpiTargetDetailId() {
		return kpiTargetDetailId;
	}

	public void setKpiTargetDetailId(long kpiTargetDetailId) {
		this.kpiTargetDetailId = kpiTargetDetailId;
	}

	public long getEmployeeId() {
		return employeeId;
	}

	public void setEmployeeId(long employeeId) {
		this.employeeId = employeeId;
	}

    /**
     * @return the bobot
     */
    public double getBobot() {
        return bobot;
    }

    /**
     * @param bobot the bobot to set
     */
    public void setBobot(double bobot) {
        this.bobot = bobot;
    }

}
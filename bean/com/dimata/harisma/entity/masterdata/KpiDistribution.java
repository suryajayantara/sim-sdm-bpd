/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author User
 */
import com.dimata.qdep.entity.Entity;

public class KpiDistribution extends Entity {

private long kpiDistributionId = 0;
private String distribution = "";

public long getKpiDistributionId(){
return kpiDistributionId;
}

public void setKpiDistributionId(long kpiDistributionId){
this.kpiDistributionId = kpiDistributionId;
}

public String getDistribution(){
return distribution;
}

public void setDistribution(String distribution){
this.distribution = distribution;
}

}

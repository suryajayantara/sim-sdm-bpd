
package com.dimata.harisma.entity.masterdata; 

// package qdep 
import com.dimata.qdep.entity.*;


public class Training extends Entity { 


        private String name         =   "";
	private String description  =   "";        
        // added for Hard Rock
        private long type           =   0;
        //Arys 20160819
        private String code            =   "";
        private String kodeAnggaran    =   "";
        private int masaBerlaku = 0;
        
        
        public Training() {            
        }
        
        
	public String getName(){ 
            return name; 
	} 

	public void setName(String name){ 
            if(name == null) {
                name = ""; 
            } 
            this.name = name; 
	} 

	public String getDescription(){ 
            return description; 
	} 

	public void setDescription(String description){ 
            if(description == null) {
                description = ""; 
            } 
            this.description = description; 
	} 
        
        
        // added for Hard Rock
        public long getType() {
            return type;
        }
        
        public void setType(long type) {
            this.type = type;
        }

    /**
     * @return the code
     */
    public String getCode() {
        return code;
}

    /**
     * @param code the code to set
     */
    public void setCode(String code) {
        this.code = code;
    }

    /**
     * @return the kodeAnggaran
     */
    public String getKodeAnggaran() {
        return kodeAnggaran;
    }

    /**
     * @param kodeAnggaran the kodeAnggaran to set
     */
    public void setKodeAnggaran(String kodeAnggaran) {
        this.kodeAnggaran = kodeAnggaran;
    }
    
    
    /**
     * @return the masaBerlaku
     */
    public int getMasaBerlaku() {
        return masaBerlaku;
    }

    /**
     * @param masaBerlaku the masaBerlaku to set
     */
    public void setMasaBerlaku(int masaBerlaku) {
        this.masaBerlaku = masaBerlaku;
    }

    
}



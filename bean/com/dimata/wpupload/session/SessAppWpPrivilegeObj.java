/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.wpupload.session;

import java.util.Vector;

/**
 *
 * @author Ardiadi
 */
public class SessAppWpPrivilegeObj {
    /** Creates new SessAppPrivilegeObj */
    public SessAppWpPrivilegeObj() {
    }

    public static boolean existCode(Vector codes, int code){
        System.out.println("codes..= "+codes.size());
        if((codes==null) || (codes.size()<1))
            return false;

        for(int i=0; i<codes.size();i++){
            if(code== ( (Integer) codes.get(i)).intValue() )
                return true;
        }
        
        return false;
        
    }    
}

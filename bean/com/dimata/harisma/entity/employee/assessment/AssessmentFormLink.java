/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.harisma.entity.employee.assessment;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author Artha
 */
public class AssessmentFormLink extends Entity{
    private long hrAssFormMainIdParent;
    private long hrAssFormMainIdChild;

    public long getHrAssFormMainIdParent() {
        return hrAssFormMainIdParent;
    }

    public void setHrAssFormMainIdParent(long hrAssFormMainIdParent) {
        this.hrAssFormMainIdParent = hrAssFormMainIdParent;
    }
    
    public long getHrAssFormMainIdChild() {
        return hrAssFormMainIdChild;
    }

    public void setHrAssFormMainIdChild(long hrAssFormMainIdChild) {
        this.hrAssFormMainIdChild = hrAssFormMainIdChild;
    }
}

/* Generated by Together */

package com.dimata.qdep.form;

public interface I_FRMType {
    
    // filter field
    public static final int FILTER_TYPE      = 0x0000000F;
    public static final int FILTER_FORMAT    = 0x000000F0;
    public static final int FILTER_ENTRY     = 0x00000F00;
    

    // data type 0x0000000# ;
    public static final int TYPE_INT        = 0x00000000;
    public static final int TYPE_STRING     = 0x00000001;
    public static final int TYPE_FLOAT      = 0x00000002;
    public static final int TYPE_DATE       = 0x00000003;
    public static final int TYPE_BOOL       = 0x00000004;
    public static final int TYPE_BLOB       = 0x00000005;
    public static final int TYPE_LONG       = 0x00000006;
    public static final int TYPE_NUMERIC    = 0x00000007;
    public static final int TYPE_COLLECTION = 0x00000008;
    public static final int TYPE_SPECIALSTRING = 0x00000009;
    
    public static final int TYPE_VECTOR_STRING= 0x0000000A; //add by Kartika 2015-09-08
    public static final int TYPE_VECTOR_INT   = 0x0000000B; //add by Kartika 2015-09-08
    public static final int TYPE_VECTOR_FLOAT = 0x0000000C; //add by Kartika 2015-09-08
    public static final int TYPE_VECTOR_LONG  = 0x0000000D; // add by Kartika 2015-09-08
    
    // data format 0x000000#0
    public static final int FORMAT_TEXT       = 0x00000000;
    public static final int FORMAT_EMAIL      = 0x00000010;
    public static final int FORMAT_CURENCY    = 0x00000020;
    
    // required options  0x00000#00
    public static final int ENTRY_OPTIONAL   = 0x00000000;
    public static final int ENTRY_REQUIRED   = 0x00000100;
    public static final int ENTRY_CONDITIONAL= 0x00000200;
       
    

} // end of FRMTYpe

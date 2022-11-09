/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.report.lkpbu;

import com.dimata.qdep.entity.Entity;
import com.dimata.util.Formater;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author khirayinnura
 */
public class Lkpbu extends Entity implements Comparable<Lkpbu>{
    
    private String empCategoryNameCode;
    private String empEduCode;
    private Date empBirthDate;
    private String empLevelCode;
    private String empResignCode;
    private int empSex;
    private Date empCommencingDate;
    private int empResign;
    private int year;
    private int trainAteendes;
    private String code;
    private Date date;
    private String resignCategory;
    
    private String empNumTtd;
    private String nameTtd;
    private String companyTtd;
    private String divisiTtd;
    private String levelTtd;
    
    //lkpbu 801
    private long lkpbu801Id = 0;
    private long employeeId = 0;
    private String noSuratPelaporan = "";
    private String tanggalSuratPelaporan = "";
    private String noSK = "";
    private String tanggalSK = "";
    private String noSKPemberhentian = "";
    private String tanggalSKPemberhentian = "";
    private String keterangan = "";
    private long periodId = 0;
    private String positionName = "";
    
    // lkpbu 803
    private String statusPegawai = "";
    private String jenisUsia = "";
    private String jenisJabatan = "";
    private String jenisPendidikan = "";
    private String jenisPekerjaan = "";
    private String empCategory = "";
    private String codeUsia = "";
    private int empUmur = 0;
    private int jumlahPerempuan = 0;
    private int jumlahLaki = 0;
    private int jumlahKaryawan = 0;
    private ArrayList<Long> idPerempuan = new ArrayList<Long>();
    private ArrayList<Long> idLaki = new ArrayList<Long>();
    private ArrayList<Long> idKaryawan = new ArrayList<Long>();
    
    
    public static String getCodeUsia(Date birthDate, int checkDate) {
        
        String date=Formater.formatDate(birthDate,"yyyy");
        int ageInt = Integer.parseInt(date);
        int age = checkDate - ageInt;

        if(age < 20 && age > 0) {
            return "01";
        } else if(age < 25) {
            return "02";
        } else if(age < 30) {
            return "03";
        } else if(age < 35) {
            return "04";
        } else if(age < 40) {
            return "05";
        } else if(age < 45) {
            return "06";
        } else if(age < 50) {
            return "07";
        } else if(age < 55) {
            return "08";
        } else if(age < 60) {
            return "09";
        } else {
            return "99";
        }
        
    }
    
    public static int getUsia(Date birthDate, int checkDate) {
        
        String date=Formater.formatDate(birthDate,"yyyy");
        int ageInt = Integer.parseInt(date);
        int age = checkDate - ageInt;
        
        return age;
    }
    
    public static String getCodeUsiaV2(Date birthDate, Date checkDate) {
        
        int years = 0;
        int months = 0;
        int days = 0;
        
        Calendar birthDay = Calendar.getInstance();
        birthDay.setTimeInMillis(birthDate.getTime());
        
        long currentTime = System.currentTimeMillis();
        Calendar now = Calendar.getInstance();
        now.setTimeInMillis(checkDate.getTime());

        years = now.get(Calendar.YEAR) - birthDay.get(Calendar.YEAR);
        int currMonth = now.get(Calendar.MONTH) + 1;
        int birthMonth = birthDay.get(Calendar.MONTH) + 1;
        
        months = currMonth - birthMonth;
        
        if (months < 0)
        {
           years--;
           months = 12 - birthMonth + currMonth;
           if (now.get(Calendar.DATE) < birthDay.get(Calendar.DATE))
              months--;
        } else if (months == 0 && now.get(Calendar.DATE) < birthDay.get(Calendar.DATE))
        {
           years--;
           months = 11;
        }
        //Calculate the days
        if (now.get(Calendar.DATE) > birthDay.get(Calendar.DATE))
           days = now.get(Calendar.DATE) - birthDay.get(Calendar.DATE);
        else if (now.get(Calendar.DATE) < birthDay.get(Calendar.DATE))
        {
           int today = now.get(Calendar.DAY_OF_MONTH);
           now.add(Calendar.MONTH, -1);
           days = now.getActualMaximum(Calendar.DAY_OF_MONTH) - birthDay.get(Calendar.DAY_OF_MONTH) + today;
        } else
        {
           days = 0;
           if (months == 12)
           {
              years++;
              months = 0;
           }
        }
        
        if(years < 20 && years > 0) {
            return "01";
        } else if(years < 25) {
            return "02";
        } else if(years < 30) {
            return "03";
        } else if(years < 35) {
            return "04";
        } else if(years < 40) {
            return "05";
        } else if(years < 45) {
            return "06";
        } else if(years < 50) {
            return "07";
        } else if(years < 55) {
            return "08";
        } else if(years < 60) {
            return "09";
        } else {
            return "99";
        }
        
    }

    /**
     * @return the empBirthDate
     */
    public Date getEmpBirthDate() {
        return empBirthDate;
    }

    /**
     * @param empBirthDate the empBirthDate to set
     */
    public void setEmpBirthDate(Date empBirthDate) {
        this.empBirthDate = empBirthDate;
    }

    /**
     * @return the empSex
     */
    public int getEmpSex() {
        return empSex;
    }

    /**
     * @param empSex the empSex to set
     */
    public void setEmpSex(int empSex) {
        this.empSex = empSex;
    }

    /**
     * @return the empLevelCode
     */
    public String getEmpLevelCode() {
        return empLevelCode;
    }

    /**
     * @param empLevelCode the empLevelCode to set
     */
    public void setEmpLevelCode(String empLevelCode) {
        this.empLevelCode = empLevelCode;
    }

    /**
     * @return the empCategoryNameCode
     */
    public String getEmpCategoryNameCode() {
        return empCategoryNameCode;
    }

    /**
     * @param empCategoryNameCode the empCategoryNameCode to set
     */
    public void setEmpCategoryNameCode(String empCategoryNameCode) {
        this.empCategoryNameCode = empCategoryNameCode;
    }

    /**
     * @return the empEduCode
     */
    public String getEmpEduCode() {
        return empEduCode;
    }

    /**
     * @param empEduCode the empEduCode to set
     */
    public void setEmpEduCode(String empEduCode) {
        this.empEduCode = empEduCode;
    }

    /**
     * @return the year
     */
    public int getYear() {
        return year;
    }

    /**
     * @param year the year to set
     */
    public void setYear(int year) {
        this.year = year;
    }

    /**
     * @return the trainAteendes
     */
    public int getTrainAteendes() {
        return trainAteendes;
    }

    /**
     * @param trainAteendes the trainAteendes to set
     */
    public void setTrainAteendes(int trainAteendes) {
        this.trainAteendes = trainAteendes;
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
     * @return the date
     */
    public Date getDate() {
        return date;
    }

    /**
     * @param date the date to set
     */
    public void setDate(Date date) {
        this.date = date;
    }

    /**
     * @return the empResignCode
     */
    public String getEmpResignCode() {
        return empResignCode;
    }

    /**
     * @param empResignCode the empResignCode to set
     */
    public void setEmpResignCode(String empResignCode) {
        this.empResignCode = empResignCode;
    }

    /**
     * @return the resignCategory
     */
    public String getResignCategory() {
        return resignCategory;
    }

    /**
     * @param resignCategory the resignCategory to set
     */
    public void setResignCategory(String resignCategory) {
        this.resignCategory = resignCategory;
    }

    /**
     * @return the empNumTtd
     */
    public String getEmpNumTtd() {
        return empNumTtd;
    }

    /**
     * @param empNumTtd the empNumTtd to set
     */
    public void setEmpNumTtd(String empNumTtd) {
        this.empNumTtd = empNumTtd;
    }

    /**
     * @return the nameTtd
     */
    public String getNameTtd() {
        return nameTtd;
    }

    /**
     * @param nameTtd the nameTtd to set
     */
    public void setNameTtd(String nameTtd) {
        this.nameTtd = nameTtd;
    }

    /**
     * @return the companyTtd
     */
    public String getCompanyTtd() {
        return companyTtd;
    }

    /**
     * @param companyTtd the companyTtd to set
     */
    public void setCompanyTtd(String companyTtd) {
        this.companyTtd = companyTtd;
    }

    /**
     * @return the divisiTtd
     */
    public String getDivisiTtd() {
        return divisiTtd;
    }

    /**
     * @param divisiTtd the divisiTtd to set
     */
    public void setDivisiTtd(String divisiTtd) {
        this.divisiTtd = divisiTtd;
    }

    /**
     * @return the levelTtd
     */
    public String getLevelTtd() {
        return levelTtd;
    }

    /**
     * @param levelTtd the levelTtd to set
     */
    public void setLevelTtd(String levelTtd) {
        this.levelTtd = levelTtd;
    }

    /**
     * @return the empCommencingDate
     */
    public Date getEmpCommencingDate() {
        return empCommencingDate;
    }

    /**
     * @param empCommencingDate the empCommencingDate to set
     */
    public void setEmpCommencingDate(Date empCommencingDate) {
        this.empCommencingDate = empCommencingDate;
    }

    /**
     * @return the empResign
     */
    public int getEmpResign() {
        return empResign;
    }

    /**
     * @param empResign the empResign to set
     */
    public void setEmpResign(int empResign) {
        this.empResign = empResign;
    }

    /**
     * @return the empUmur
     */
    public int getEmpUmur() {
        return empUmur;
    }

    /**
     * @param empUmur the empUmur to set
     */
    public void setEmpUmur(int empUmur) {
        this.empUmur = empUmur;
    }
//tess

    /**
     * @return the statusPegawai
     */
    public String getStatusPegawai() {
        return statusPegawai;
    }

    /**
     * @param statusPegawai the statusPegawai to set
     */
    public void setStatusPegawai(String statusPegawai) {
        this.statusPegawai = statusPegawai;
    }

    /**
     * @return the jenisUsia
     */
    public String getJenisUsia() {
        return jenisUsia;
    }

    /**
     * @param jenisUsia the jenisUsia to set
     */
    public void setJenisUsia(String jenisUsia) {
        this.jenisUsia = jenisUsia;
    }

    /**
     * @return the jenisJabatan
     */
    public String getJenisJabatan() {
        return jenisJabatan;
    }

    /**
     * @param jenisJabatan the jenisJabatan to set
     */
    public void setJenisJabatan(String jenisJabatan) {
        this.jenisJabatan = jenisJabatan;
    }

    /**
     * @return the jenisPendidikan
     */
    public String getJenisPendidikan() {
        return jenisPendidikan;
    }

    /**
     * @param jenisPendidikan the jenisPendidikan to set
     */
    public void setJenisPendidikan(String jenisPendidikan) {
        this.jenisPendidikan = jenisPendidikan;
    }

    /**
     * @return the jenisPekerjaan
     */
    public String getJenisPekerjaan() {
        return jenisPekerjaan;
    }

    /**
     * @param jenisPekerjaan the jenisPekerjaan to set
     */
    public void setJenisPekerjaan(String jenisPekerjaan) {
        this.jenisPekerjaan = jenisPekerjaan;
    }

    /**
     * @return the empCategory
     */
    public String getEmpCategory() {
        return empCategory;
    }

    /**
     * @param empCategory the empCategory to set
     */
    public void setEmpCategory(String empCategory) {
        this.empCategory = empCategory;
    }

    /**
     * @return the codeUsia
     */
    public String getCodeUsia() {
        return codeUsia;
    }

    /**
     * @param codeUsia the codeUsia to set
     */
    public void setCodeUsia(String codeUsia) {
        this.codeUsia = codeUsia;
    }

    /**
     * @return the employeeId
     */
    public long getEmployeeId() {
        return employeeId;
    }

    /**
     * @param employeeId the employeeId to set
     */
    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    /**
     * @return the jumlahPerempuan
     */
    public int getJumlahPerempuan() {
        return jumlahPerempuan;
    }

    /**
     * @param jumlahPerempuan the jumlahPerempuan to set
     */
    public void setJumlahPerempuan(int jumlahPerempuan) {
        this.jumlahPerempuan = jumlahPerempuan;
    }

    /**
     * @return the jumlahLaki
     */
    public int getJumlahLaki() {
        return jumlahLaki;
    }

    /**
     * @param jumlahLaki the jumlahLaki to set
     */
    public void setJumlahLaki(int jumlahLaki) {
        this.jumlahLaki = jumlahLaki;
    }

    public static Comparator<Lkpbu> LkpbuCompare
                          = new Comparator<Lkpbu>() {

	    public int compare(Lkpbu lkpbu1, Lkpbu lkpbu2) {

	      String code1 = lkpbu1.getCode().toUpperCase();
	      String code2 = lkpbu2.getCode().toUpperCase();

	      //ascending order
	      return code1.compareTo(code2);

	      //descending order
	      //return fruitName2.compareTo(fruitName1);
	    }

	};

    public int compareTo(Lkpbu t) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

   

    /**
     * @return the periodId
     */
    public long getPeriodId() {
        return periodId;
    }

    /**
     * @param periodId the periodId to set
     */
    public void setPeriodId(long periodId) {
        this.periodId = periodId;
    }

    /**
     * @return the lkpbu801Id
     */
    public long getLkpbu801Id() {
        return lkpbu801Id;
    }

    /**
     * @param lkpbu801Id the lkpbu801Id to set
     */
    public void setLkpbu801Id(long lkpbu801Id) {
        this.lkpbu801Id = lkpbu801Id;
    }

    /**
     * @return the positionName
     */
    public String getPositionName() {
        return positionName;
    }

    /**
     * @param positionName the positionName to set
     */
    public void setPositionName(String positionName) {
        this.positionName = positionName;
    }

    /**
     * @return the noSuratPelaporan
     */
    public String getNoSuratPelaporan() {
        return noSuratPelaporan;
    }

    /**
     * @param noSuratPelaporan the noSuratPelaporan to set
     */
    public void setNoSuratPelaporan(String noSuratPelaporan) {
        this.noSuratPelaporan = noSuratPelaporan;
    }

    /**
     * @return the tanggalSuratPelaporan
     */
    public String getTanggalSuratPelaporan() {
        return tanggalSuratPelaporan;
    }

    /**
     * @param tanggalSuratPelaporan the tanggalSuratPelaporan to set
     */
    public void setTanggalSuratPelaporan(String tanggalSuratPelaporan) {
        this.tanggalSuratPelaporan = tanggalSuratPelaporan;
    }

    /**
     * @return the noSK
     */
    public String getNoSK() {
        return noSK;
    }

    /**
     * @param noSK the noSK to set
     */
    public void setNoSK(String noSK) {
        this.noSK = noSK;
    }

    /**
     * @return the tanggalSK
     */
    public String getTanggalSK() {
        return tanggalSK;
    }

    /**
     * @param tanggalSK the tanggalSK to set
     */
    public void setTanggalSK(String tanggalSK) {
        this.tanggalSK = tanggalSK;
    }

    /**
     * @return the noSKPemberhentian
     */
    public String getNoSKPemberhentian() {
        return noSKPemberhentian;
    }

    /**
     * @param noSKPemberhentian the noSKPemberhentian to set
     */
    public void setNoSKPemberhentian(String noSKPemberhentian) {
        this.noSKPemberhentian = noSKPemberhentian;
    }

    /**
     * @return the tanggalSKPemberhentian
     */
    public String getTanggalSKPemberhentian() {
        return tanggalSKPemberhentian;
    }

    /**
     * @param tanggalSKPemberhentian the tanggalSKPemberhentian to set
     */
    public void setTanggalSKPemberhentian(String tanggalSKPemberhentian) {
        this.tanggalSKPemberhentian = tanggalSKPemberhentian;
    }

    /**
     * @return the keterangan
     */
    public String getKeterangan() {
        return keterangan;
    }

    /**
     * @param keterangan the keterangan to set
     */
    public void setKeterangan(String keterangan) {
        this.keterangan = keterangan;
    }

    /**
     * @return the idPerempuan
     */
    public ArrayList<Long> getIdPerempuan() {
        return idPerempuan;
    }

    /**
     * @param idPerempuan the idPerempuan to set
     */
    public void setIdPerempuan(ArrayList<Long> idPerempuan) {
        this.idPerempuan = idPerempuan;
    }

    /**
     * @return the idLaki
     */
    public ArrayList<Long> getIdLaki() {
        return idLaki;
    }

    /**
     * @param idLaki the idLaki to set
     */
    public void setIdLaki(ArrayList<Long> idLaki) {
        this.idLaki = idLaki;
    }

    /**
     * @return the jumlahKaryawan
     */
    public int getJumlahKaryawan() {
        return jumlahKaryawan;
    }

    /**
     * @param jumlahKaryawan the jumlahKaryawan to set
     */
    public void setJumlahKaryawan(int jumlahKaryawan) {
        this.jumlahKaryawan = jumlahKaryawan;
    }
    
    /**
     * @return the idKaryawan
     */
    public ArrayList<Long> getIdKaryawan() {
        return idKaryawan;
    }

    /**
     * @param idKaryawan the idLaki to set
     */
    public void setIdKaryawan(ArrayList<Long> idKaryawan) {
        this.idKaryawan = idKaryawan;
    }
}

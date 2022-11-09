/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author Acer
 */
public class AnggaranTraining extends Entity {

    private long trainingId = 0;
    private int durasi = 0;
    private int frek = 0;
    private int peserta = 0;
    private int jumlah = 0;
    private int biaya = 0;
    private int anggaran = 0;
    private long tempatId = 0;
    private int bidang = 0;
    private String keterangan = "";

    public long getTrainingId() {
        return trainingId;
    }

    public void setTrainingId(long trainingId) {
        this.trainingId = trainingId;
    }

    public int getDurasi() {
        return durasi;
    }

    public void setDurasi(int durasi) {
        this.durasi = durasi;
    }

    public int getFrek() {
        return frek;
    }

    public void setFrek(int frek) {
        this.frek = frek;
    }

    public int getPeserta() {
        return peserta;
    }

    public void setPeserta(int peserta) {
        this.peserta = peserta;
    }

    public int getJumlah() {
        return jumlah;
    }

    public void setJumlah(int jumlah) {
        this.jumlah = jumlah;
    }

    public double getBiaya() {
        return biaya;
    }

    public void setBiaya(int biaya) {
        this.biaya = biaya;
    }

    public double getAnggaran() {
        return anggaran;
    }

    public void setAnggaran(int anggaran) {
        this.anggaran = anggaran;
    }

    public long getTempatId() {
        return tempatId;
    }

    public void setTempatId(long tempatId) {
        this.tempatId = tempatId;
    }

    public long getBidang() {
        return bidang;
    }

    public void setBidang(int bidang) {
        this.bidang = bidang;
    }

    public String getKeterangan() {
        return keterangan;
    }

    public void setKeterangan(String keterangan) {
        this.keterangan = keterangan;
    }

}

<%-- 
    Document   : formula
    Created on : Sep 19, 2016, 9:28:24 AM
    Author     : khirayinnura
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Document</title>
        <style type="text/css">
            body {
                color:#373737; 
                background-color: #EEE;
            }
            .tblStyle {border-collapse: collapse; font-size: 12px; background-color: #FFF;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px; }
            .tblStyle1 {border-collapse: collapse; background-color: #FFF;}
            .tblStyle1 td {color:#575757; text-align: center; font-size: 11px; padding: 3px 0px; }
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3; }
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}
            
            .active {
                background-color: #0b71d0;
                border-bottom: 1px solid #033a6d;
            }
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            .header {
                
            }
            .content-main {
                padding: 13px 17px;
                margin: 50px 50px 50px 50px;
                background-color: #FFF;
            }
            .content-info {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
            }
            .content-title {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
                margin-bottom: 5px;
            }
            #title-large {
                color: #575757;
                font-size: 16px;
                font-weight: bold;
            }
            #title-small {
                color:#797979;
                font-size: 11px;
            }
            .content {
                padding: 21px;
            }
            
            #photo {
                padding: 3px; 
                background-color: #FFF; 
                border: 1px solid #DDD;
            }

            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }
            
            .btn-small {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #676767; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small:hover { background-color: #474747; color: #FFF;}
            
            .btn-small-1 {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-1:hover { background-color: #DDD; color: #474747;}
            
            .tbl-main {border-collapse: collapse; font-size: 11px; background-color: #FFF; margin: 0px;}
            .tbl-main td {padding: 4px 7px; border: 1px solid #DDD; }
            #tbl-title {font-weight: bold; background-color: #F5F5F5; color: #575757;}
            
            .tbl-small {border-collapse: collapse; font-size: 11px; background-color: #FFF;}
            .tbl-small td {padding: 2px 3px; border: 1px solid #DDD; }
            
            #caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }

        </style>
    </head>
    <body>
        <div class="content-main">
            <b>1. Formula Untuk Memanggil Employee</b>
            <p>
                Contoh :<br>
                $ { TRAINNER2-LIST-EMPLOYEE-START }  Digunakan sebagai pembuka list, dimana :<br>
                <table>
                    <tr><td>TRAINNER2</td><td>=</td><td>merupakan nama object (Jika memanggil beberapa Object, TRAINNER2 dapat diganti menjadi TRAINNER3,TRAINNER4 dst)</td></tr>
                    <tr><td>LIST</td><td>=</td><td>merupakan Jenis Tipe (LIST untuk memanggil daftar karyawan, SINGLE untuk memanggil  satu karyawan)</td></tr>
                    <tr><td>EMPLOYEE</td><td>=</td><td>merupakan nama Tabel yang ingin diambil (disini yang digunakan merupakan employee)</td></tr>
                    <tr><td>START</td><td>=</td><td>merupakan nama Field (disini yang digunakan merupakan employee field)</td></tr>
                </table>
            </p>
            <table class="tblStyle1" width="100%" border="1">
                <tr>
                    <th>
                        NRK
                    </th>
                    <th>
                        NAMA    
                    </th>
                    <th>
                        ALAMAT
                    </th>
                </tr>
                <tr>
                    <td>
                        $ { TRAINNER2-LIST-EMPLOYEE-EMPLOYEE_NUM }
                    </td>
                    <td>
                        $ { TRAINNER2-LIST-EMPLOYEE-FULL_NAME }
                    </td>
                    <td>
                        $ { TRAINNER2-LIST-EMPLOYEE-ADDRESS }
                    </td>
                </tr>
            </table>
            <p>
                $ { TRAINNER2-LIST-EMPLOYEE-END } ( "END" digunakan sebagai Penutup list)
            </p>
            <p>
                untuk isi didalam tabel bisa disesuaikan misal : $ { TRAINNER2-LIST-EMPLOYEE-FULL_NAME } (menampilkan nama dari employee) diganti menjadi $ { TRAINNER2-LIST-EMPLOYEE-RELIGION_ID } (menampilkan agama)
            </p>
            <p>
                Berikut list field yang bisa digunakan untuk memanggil data pada employee :
            </p>
            <table class="tblStyle1" border="1">
                <tr><td>DIVISION_ID</td><td>Satuan Kerja</td></tr>
                <tr><td>DEPARTMENT_ID</td><td>Unit</td></tr>
                <tr><td>SECTION_ID</td><td>Sub Unit</td></tr>
                <tr><td>POSITION_ID</td><td>Jabatan</td></tr>
                <tr><td>EMPLOYEE_NUM</td><td>NRK</td></tr>
                <tr><td>EMP_CATEGORY_ID</td><td>Kategori</td></tr>
                <tr><td>LEVEL_ID</td><td>Level</td></tr>
                <tr><td>GRADE_LEVEL_ID</td><td>Grade</td></tr>
                <tr><td>FULL_NAME</td><td>Nama Lengkap</td></tr>
                <tr><td>ADDRESS</td><td>Alamat</td></tr>
                <tr><td>PHONE</td><td>Nomor Telepon</td></tr>
                <tr><td>HANDPHONE</td><td>Nomor Handphone</td></tr>
                <tr><td>BIRTH_PLACE</td><td>Tempat Lahir</td></tr>
                <tr><td>RELIGION_ID</td><td>Agama</td></tr>
                <tr><td>BLOOD_TYPE</td><td>Golongan Darah</td></tr>
                <tr><td>ASTEK_NUM</td><td>No Jamsostek</td></tr>
                <tr><td>INDENT_CARD_NR</td><td>Nomor Identitas</td></tr>
                <tr><td>INDENT_CARD_VALID_TO</td><td>Masa Berlaku Kartu Identitas</td></tr>
                <tr><td>EMAIL_ADDRESS</td><td>Alamat Email</td></tr>
                <tr><td>ADDRESS_PERMANENT</td><td>Alamat Tetap</td></tr>
                <tr><td>PHONE_EMERGENCY</td><td>Nomor Telepon Darurat</td></tr>
                <tr><td>COMPANY_ID</td><td>Nama Perusahaan</td></tr>
                <tr><td>FATHER</td><td>Nama Ayah</td></tr>
                <tr><td>MOTHER</td><td>Nama Ibu</td></tr>
                <tr><td>PARENTS_ADDRESS</td><td>Alamat Orang Tua</td></tr>
                <tr><td>NAME_EMG</td><td>Nama Darurat</td></tr>
                <tr><td>NO_REKENING</td><td>Nomor Rekening</td></tr>
                <tr><td>ID_CARD_TYPE</td><td>Jenis Identitas</td></tr>
                <tr><td>NPWP</td><td>NPWP</td></tr>
                <tr><td>BPJS_NO</td><td>Nomor BPJS</td></tr>
                <tr><td>BPJS_DATE</td><td>Tanggal BPJS</td></tr>
                <tr><td>SHIO</td><td>Shio</td></tr>
                <tr><td>ELEMEN</td><td>Elemen</td></tr>
                <tr><td>IQ</td><td>IQ</td></tr>
                <tr><td>EQ</td><td>EQ</td></tr>
                <tr><td>PROVIDER_ID</td><td>Penyedia</td></tr>
                <tr><td>HISTORY_GROUP</td><td>History Group</td></tr>
                <tr><td>HISTORY_TYPE</td><td>History Type</td></tr>
                <tr><td>SK_NOMOR</td><td>Nomor SK</td></tr>
                <tr><td>SK_TANGGAL</td><td>Tanggal SK</td></tr>
                <tr><td>NKK</td><td>NKK</td></tr>
                <tr><td>SK_NOMOR_GRADE</td><td>Nomor SK Grade</td></tr>
                <tr><td>SK_TANGGAL_GRADE</td><td>Tanggal SK Grade</td></tr>
                <tr><td>NAME_ON_CARD</td><td>Nama Pada KTP</td></tr>
            </table>
            <br>
            <b>2. Formula Untuk Membuat Field</b><br>
            <p>
                Contoh :<br>
                $ { ANGKUTAN-FIELD-ALLFIELD-TEXT }  dimana :<br>
                <table>
                    <tr><td>ANGKUTAN</td><td>=</td><td>Nama Field</td></tr>
                    <tr><td>FIELD</td><td>=</td><td>Deklarasi yang ditampilkan adalah field</td></tr>
                    <tr><td>ALLFIELD</td><td>=</td><td>Deklarasi pemanggilan seluruh field</td></tr>
                    <tr><td>TEXT</td><td>=</td><td>Jenis Field yang akan dipanggil (TEXT / DATE)</td></tr>
                </table>
            </p>
            <b>3. Formula Untuk Mengambil Data Dokumen</b><br>
            <p>
                Contoh :<br>
                $ { OBJECT1-FIELD-EMPDOCFIELD-DOC_NUMBER }<br>
                <table>
                    <tr><td>OBJECT1</td><td>=</td><td>Nama Object</td></tr>
                    <tr><td>FIELD</td><td>=</td><td>Jenis tipe pemanggilan</td></tr>
                    <tr><td>EMPDOCFIELD</td><td>=</td><td>Nama Tabel</td></tr>
                    <tr><td>DOC_NUMBER</td><td>=</td><td>Nama Field</td></tr>
                </table>
            </p>
            <p>Berikut list field yang bisa digunakan untuk memanggil data dokumen :</p>
            <table class="tblStyle1" align="left" width="50%" border="1">
                <tr>
                    <td>DOC_TITLE</td>
                    <td>Judul Dokumen</td>
                </tr>
                <tr>
                    <td>DOC_NUMBER</td>
                    <td>Nomor Dokumen</td>
                </tr>
                <tr>
                    <td>REQUEST_DATE</td>
                    <td>Tanggal Dokumen</td>
                </tr>
                <tr>
                    <td>DATE_OF_ISSUE</td>
                    <td>Tanggal Berlaku</td>
                </tr>
            </table>
            <br><br><br><br><br>
        </div>
    </body>
</html>

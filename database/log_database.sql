/*
  
  Membuat tabel hr_kpi_type_group

  desc :
  tabel ini digunakan untuk membuat relasi many to many antara tabel hr_kpi_type dengan tabel 
  hr_kpi_group. 

*/

CREATE TABLE `hr_kpi_type_group`(  
  `KPI_TYPE_GROUP_ID` BIGINT(20) NOT NULL,
  `KPI_TYPE_ID` BIGINT(20),
  `KPI_GROUP_ID` BIGINT(20),
  PRIMARY KEY (`KPI_TYPE_GROUP_ID`)
);

/*
  
  Membuat relasi foreign key tabel one to many hr_kpi_group dengan hr_kpi_type_group

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_group dengan hr_kpi_type_group
  atau sebagai penghubung foreign key pada tabel hr_kpi_type_group dengan primary key hr_kpi_group. 

*/

ALTER TABLE `hr_kpi_type_group`  
  ADD CONSTRAINT `FK_KPI_GROUP_ID` 
  FOREIGN KEY (`KPI_GROUP_ID`) 
  REFERENCES `hr_kpi_group`(`KPI_GROUP_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*
  
  Membuat relasi foreign key tabel one to many hr_kpi_type dengan hr_kpi_type_group

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_type dengan hr_kpi_type_group
  atau sebagai penghubung foreign key pada tabel hr_kpi_type_group dengan primary key hr_kpi_type. 

*/

ALTER TABLE `hr_kpi_type_group`  
  ADD CONSTRAINT `FK_KPI_TYPE_ID` 
  FOREIGN KEY (`KPI_TYPE_ID`) 
  REFERENCES `hr_kpi_type`(`KPI_TYPE_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*
  
  Membuat Column pada tabel hr_kpi_type

  desc :
  penambahan column COMPANY dengan tipe data string dan NUMBER_INDEX dengan tipe data int. 

*/

ALTER TABLE `hr_kpi_type`   
  ADD COLUMN `COMPANY` VARCHAR(256) NULL AFTER `DESCRIPTION`,
  ADD COLUMN `NUMBER_INDEX` INT(3) NULL AFTER `COMPANY`;

/*

 Mengubah engine pada tabel pay_general

 desc :
 mengubah engine tabel pay_general dari awalnya menggunakan MyISAM menjadi INNODB
 dan menghapus default pada column REG_TAX_DATE agar dapat mengganti engine pada tabel
 pay_general

*/

ALTER TABLE `pay_general` ALTER `REG_TAX_DATE` DROP DEFAULT;
ALTER TABLE `pay_general`  
  ENGINE=INNODB;

/*

  Membuat relasi foreign key tabel one to many hr_kpi_type dengan hr_kpi_type_company

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_type dengan hr_kpi_type_company
  atau sebagai penghubung foreign key pada tabel hr_kpi_type_company dengan primary key hr_kpi_type. 

  note : 
  1. apababila terjadi error maka perlu melakukan backup tabel hr_kpi_type_company lalu hapus datanya
  dan jalankan query tersebut. setelah itu import kembali data tabel yang sudah dibackup lalu tanda centang 
  abort error dihilangkan karena ada beberapa data tidak terimput karena ada data yang tidak memiliki relasi
  2. membuat relasi querynya lsng pada coding 

*/

ALTER TABLE `hr_kpi_type_company`
  ADD CONSTRAINT `FK_KPITYPE_ID` 
  FOREIGN KEY (`KPI_TYPE_ID`)
   REFERENCES `hr_kpi_type` (`KPI_TYPE_ID`) ON UPDATE CASCADE ON DELETE CASCADE;

/*

  Conditional database

  Membuat relasi foreign key tabel one to many pay_general dengan hr_kpi_type_company

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel pay_general dengan hr_kpi_type_company
  atau sebagai penghubung foreign key pada tabel hr_kpi_type_company dengan primary key pay_general. 

  note : 
  1. apababila terjadi error maka perlu melakukan backup tabel hr_kpi_type_company lalu hapus datanya
  dan jalankan query tersebut. setelah itu import kembali data tabel yang sudah dibackup lalu tanda centang 
  abort error dihilangkan karena ada beberapa data tidak terimput karena ada data yang tidak memiliki relasi
  2. membuat relasi querynya lsng pada coding
  3. saran dari pak tut mengupdate data pda tabel hr_kpi_type_company sesuai dengan data primary key dari tabel pay_general

*/

ALTER TABLE `hr_kpi_type_company`  
  ADD CONSTRAINT `FK_COMPANY_ID` 
  FOREIGN KEY (`COMPANY_ID`) 
  REFERENCES `pay_general`(`GEN_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

  Membuat relasi foreign key tabel one to many hr_kpi_group dengan hr_kpi_list_group

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_group dengan hr_kpi_list_group
  atau sebagai penghubung foreign key pada tabel hr_kpi_list_group dengan primary key hr_kpi_group. 

*/

ALTER TABLE `hr_kpi_list_group`  
  ADD CONSTRAINT `FK_HR_KPI_GROUP_ID` 
  FOREIGN KEY (`KPI_GROUP_ID`) 
  REFERENCES `hr_kpi_group`(`KPI_GROUP_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

  Membuat relasi foreign key tabel one to many hr_kpi_list dengan hr_kpi_list_group

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_list dengan hr_kpi_list_group
  atau sebagai penghubung foreign key pada tabel hr_kpi_list_group dengan primary key hr_kpi_list. 

*/

ALTER TABLE `hr_kpi_list_group`  
  ADD CONSTRAINT `FK_HR_KPI_LIST_ID` 
  FOREIGN KEY (`KPI_LIST_ID`) 
  REFERENCES `hr_kpi_list`(`KPI_LIST_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

 Membuat column index pada tabel hr_kpi_group dan hr_kpi_list

 desc :
 membuat column NUMBER_INDEX dengan tipe data int pada tabel hr_kpi_group dan hr_kpi_list

*/

ALTER TABLE `hr_kpi_group`   
  DROP COLUMN `NUMBER_INDEX`, 
  ADD COLUMN `NUMBER_INDEX` INT(3) 
  NULL AFTER `DESCRIPTION`;

ALTER TABLE `hr_kpi_list`   
  ADD COLUMN `NUMBER_INDEX` INT(3) 
  NULL AFTER `RANGE_END`;

/*

 Menghapus column position id pada hr_kpi_setting

 desc :
 Menghapus column POSITION_ID tipe data long pada hr_kpi_setting

*/

ALTER TABLE `hr_kpi_setting`   
  DROP COLUMN `POSITION_ID`;

/*

 mengubah nama column pada tabel hr_kpi_setting_list

 desc :
 mengubah nama column KPI_IIST_ID menjadi KPI_LIST_ID tipe data long pada tabel hr_kpi_setting_list

*/

ALTER TABLE `hr_kpi_setting_list`   
  CHANGE `KPI_IIST_ID` `KPI_LIST_ID` BIGINT(20) NULL;

/*

  Membuat relasi foreign key tabel one to many hr_kpi_setting dengan hr_kpi_setting_list

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_setting dengan hr_kpi_setting_list
  atau sebagai penghubung foreign key pada tabel hr_kpi_setting_list dengan primary key hr_kpi_setting. 

*/

ALTER TABLE `hr_kpi_setting_list`  
  ADD CONSTRAINT `FK_KPI_SETTING_ID` 
  FOREIGN KEY (`KPI_SETTING_ID`) 
  REFERENCES `hr_kpi_setting`(`KPI_SETTING_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

  Membuat relasi foreign key tabel one to many hr_kpi_list dengan hr_kpi_setting_list

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_list dengan hr_kpi_setting_list
  atau sebagai penghubung foreign key pada tabel hr_kpi_setting_list dengan primary key hr_kpi_list. 

*/

ALTER TABLE `hr_kpi_setting_list`  
  ADD CONSTRAINT `FK_KPI_LIST_ID` 
  FOREIGN KEY (`KPI_LIST_ID`) 
  REFERENCES `hr_kpi_list`(`KPI_LIST_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

 membuat tabel kpi distribution

 desc :
 membuat tabel hr_kpi_distribution pada database 

*/

CREATE TABLE `hr_kpi_distribution`(  
  `KPI_DISTRIBUTION_ID` BIGINT(20) NOT NULL,
  `DISTRIBUTION` VARCHAR(256),
  PRIMARY KEY (`KPI_DISTRIBUTION_ID`)
);

/*

  Membuat relasi foreign key tabel one to many hr_kpi_distribution dengan hr_kpi_setting_list

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_distribution dengan hr_kpi_setting_list
  atau sebagai penghubung foreign key pada tabel hr_kpi_setting_list dengan primary key hr_kpi_distribution. 

*/

ALTER TABLE `hr_kpi_setting_list`  
  ADD CONSTRAINT `FK_KPI_DISTRIBUTION_ID` 
  FOREIGN KEY (`KPI_DISTRIBUTION_ID`) 
  REFERENCES `hr_kpi_distribution`(`KPI_DISTRIBUTION_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

  Membuat relasi foreign key tabel one to many hr_kpi_setting dengan hr_kpi_setting_company

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_setting dengan hr_kpi_setting_company
  atau sebagai penghubung foreign key pada tabel hr_kpi_setting_company dengan primary key hr_kpi_setting.

*/

ALTER TABLE `hr_kpi_setting_company`  
  ADD CONSTRAINT `FK_KPI_SETTING` 
  FOREIGN KEY (`KPI_SETTING_ID`) 
  REFERENCES `hr_kpi_setting`(`KPI_SETTING_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

  Membuat relasi foreign key tabel one to many pay_general dengan hr_kpi_setting_company

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel pay_general dengan hr_kpi_setting_company
  atau sebagai penghubung foreign key pada tabel hr_kpi_setting_company dengan primary key pay_general.

*/

ALTER TABLE `hr_kpi_setting_company`  
  ADD CONSTRAINT `FK_COMPANY` 
  FOREIGN KEY (`COMPANY_ID`) 
  REFERENCES `pay_general`(`GEN_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

  Membuat relasi foreign key tabel one to many pay_general dengan hr_kpi_setting_group

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_setting dengan hr_kpi_setting_group
  atau sebagai penghubung foreign key pada tabel hr_kpi_setting_group dengan primary key hr_kpi_setting.

*/

ALTER TABLE `hr_kpi_setting_group`  
  ADD CONSTRAINT `FK_HR_KPI_SETTING` 
  FOREIGN KEY (`KPI_SETTING_ID`) 
  REFERENCES `hr_kpi_setting`(`KPI_SETTING_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

  Membuat relasi foreign key tabel one to many hr_kpi_group dengan hr_kpi_setting_group

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_group dengan hr_kpi_setting_group
  atau sebagai penghubung foreign key pada tabel hr_kpi_setting_group dengan primary key hr_kpi_group.

*/

ALTER TABLE `hr_kpi_setting_group`  
  ADD CONSTRAINT `FK_HR_KPI_GROUP` 
  FOREIGN KEY (`KPI_GROUP_ID`) 
  REFERENCES `hr_kpi_group`(`KPI_GROUP_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

 mengedit dan membuta column pada hr_kpi_target_detail

 desc :
 menambah data KPI_SETTING_LIST_ID dengan tipe data long dan mengedit KPI_TARGET_DETAIL_ID menjadi
 PRIMARY KEY pada tabel hr_kpi_target_detail

*/

ALTER TABLE `hr_kpi_target_detail`   
  CHANGE `KPI_TARGET_DETAIL_ID` `KPI_TARGET_DETAIL_ID` BIGINT(25) NOT NULL,
  ADD COLUMN `KPI_SETTING_LIST_ID` BIGINT(20) NULL AFTER `WEIGHT_VALUE`, 
  ADD PRIMARY KEY (`KPI_TARGET_DETAIL_ID`);

/*

  Membuat relasi foreign key tabel one to many hr_kpi_setting_list dengan hr_kpi_target_detail

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_setting_list dengan hr_kpi_target_detail
  atau sebagai penghubung foreign key pada tabel hr_kpi_target_detail dengan primary key hr_kpi_setting_list.

*/

ALTER TABLE `hr_kpi_target_detail`  
  ADD CONSTRAINT `FK_KPI_SETTING_LIST_ID` 
  FOREIGN KEY (`KPI_SETTING_LIST_ID`) 
  REFERENCES `hr_kpi_setting_list`(`KPI_SETTING_LIST_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

  Membuat relasi foreign key tabel one to many hr_kpi_target dengan hr_kpi_target_detail

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_target dengan hr_kpi_target_detail
  atau sebagai penghubung foreign key pada tabel hr_kpi_target_detail dengan primary key hr_kpi_target.

*/

ALTER TABLE `hr_kpi_target_detail`  
  ADD CONSTRAINT `FK_KPI_TARGET_ID` 
  FOREIGN KEY (`KPI_TARGET_ID`) 
  REFERENCES `hr_kpi_target`(`KPI_TARGET_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

 conditional databases

 Membuat relasi foreign key tabel one to many hr_kpi_group dengan hr_kpi_target_detail

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_group dengan hr_kpi_target_detail
  atau sebagai penghubung foreign key pada tabel hr_kpi_target_detail dengan primary key hr_kpi_group. 

  note : 
  1. apababila terjadi error maka perlu melakukan backup tabel hr_kpi_target_detail lalu hapus datanya
  dan jalankan query tersebut. setelah itu import kembali data tabel yang sudah dibackup lalu tanda centang 
  abort error dihilangkan karena ada beberapa data tidak terimput karena ada data yang tidak memiliki relasi
  2. membuat relasi querynya lsng pada coding
  3. saran dari pak tut mengupdate data pda tabel hr_kpi_target_detail sesuai dengan data primary key dari tabel hr_kpi_group

*/

ALTER TABLE `hr_kpi_target_detail`  
  ADD CONSTRAINT `FK_HR_KPI_GROUPID` 
  FOREIGN KEY (`KPI_GROUP_ID`) 
  REFERENCES `hr_kpi_group`(`KPI_GROUP_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;


/*

  Membuat relasi foreign key tabel one to many hr_kpi_target_detail dengan hr_kpi_target_detail_employee

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_target_detail dengan hr_kpi_target_detail_employee
  atau sebagai penghubung foreign key pada tabel hr_kpi_target_detail_employee dengan primary key hr_kpi_target_detail.

*/

ALTER TABLE `hr_kpi_target_detail_employee`  
  ADD CONSTRAINT `FK_KPI_TARGET_DETAIL_ID` 
  FOREIGN KEY (`KPI_TARGET_DETAIL_ID`) 
  REFERENCES `hr_kpi_target_detail`(`KPI_TARGET_DETAIL_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;

/*

  Conditionl database

  Membuat relasi foreign key tabel one to many hr_kpi_list dengan hr_kpi_target_detail

  desc :
  relasi foreign key ini digunakan untuk membuat relasi one to many tabel hr_kpi_list dengan hr_kpi_target_detail
  atau sebagai penghubung foreign key pada tabel hr_kpi_target_detail dengan primary key hr_kpi_list. 

  note : 
  1. apababila terjadi error maka perlu melakukan backup tabel hr_kpi_target_detail lalu hapus datanya
  dan jalankan query tersebut. setelah itu import kembali data tabel yang sudah dibackup lalu tanda centang 
  abort error dihilangkan karena ada beberapa data tidak terimput karena ada data yang tidak memiliki relasi
  2. membuat relasi querynya lsng pada coding
  3. saran dari pak tut mengupdate data pda tabel hr_kpi_target_detail sesuai dengan data primary key dari tabel hr_kpi_list

*/

ALTER TABLE `hr_kpi_target_detail`  
  ADD CONSTRAINT `FK_KPI_LIST` 
  FOREIGN KEY (`KPI_ID`) 
  REFERENCES `hr_kpi_list`(`KPI_LIST_ID`) 
  ON UPDATE CASCADE ON DELETE CASCADE;



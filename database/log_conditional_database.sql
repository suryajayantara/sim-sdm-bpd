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
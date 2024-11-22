create database General_Hospital
use General_Hospital 
create table Drug ( Drug_Code_Number int primary key 
, Dosage int )

Create table Consaltent (Consultent_ID int primary key 
,Name varchar(20) not null )

create table Drug_Brand_Name (Brand_Name varchar(20)
,Drug_Code_Number int not null foreign key references Drug(Drug_Code_Number))

Create table Ward(Ward_ID int primary key 
,Name varchar(20))

Create table Nurse (Number int primary key 
, Name varchar(20) not null 
,Adress varchar(20) not null 
,Ward_ID int not null foreign key references Ward(Ward_ID))

alter table Ward add Number int not null foreign key references Nurse(Number)
create table Patient (Patient_ID int primary key
,Name varchar(20) not null 
,Date_Of_Birth Date not null
,Ward_ID int not null foreign key references Ward(Ward_ID)
,Consultent_ID int not null foreign key references Consaltent(Consultent_ID))

Create table Examined (Patient_ID int not null references Patient(Patient_ID)
, Consultent_ID int not null foreign key references Consaltent(Consultent_ID))

create table Record ( Number int not null foreign key references Nurse(Number) 
,Patient_ID int not null foreign key references Patient(Patient_ID)
,Drug_Code_Number int not null foreign key references Drug(Drug_Code_Number))
alter table Record add Dosage int , Date date , Time time 

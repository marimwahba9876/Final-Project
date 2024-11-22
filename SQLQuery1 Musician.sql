create database Musicana_records
use Musicana_records
create table musician ( Musician_ID_number int primary key
,phone_number int not null , name varchar(20) not null
,street varchar(40) , city varchar(40))
create table Album ( Albume_ID int primary key , copyright_Date Date 
,Unique_Title varchar(20) , Musician_ID_number int not null foreign key references musician(Musician_ID_number)) 

create table Song (Song_Unique_Title varchar(20) primary key , Author varchar(20) not null
,Album_ID int not null foreign key references Album(Albume_ID))

create table Perform ( Musician_ID_number int not null foreign key references musician(Musician_ID_number) 
,Song_Unique_Title varchar(20) not null references Song(Song_Unique_Title)) 

create table Instrument ( Instrument_Unique_Name varchar(20) primary key
, Musical_Key char(20))

create table Play ( Musician_ID_number int not null foreign key references musician(Musician_ID_number)
,Instrument_Unique_Name varchar(20) not null references Instrument(Instrument_Unique_Name)) 

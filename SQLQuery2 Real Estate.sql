create database  Real_estate
use Real_estate

create table Owners (Owner_ID int primary key 
, Owner_Name varchar(20) not null)
create table property (Property_ID int primary key 
, state varchar(20) not null 
, zip_code int not null 
,city varchar(30))
create table Sales_Office (Office_Number int primary key 
,Location varchar(30) not null )
alter table property add Office_Number int not null foreign key references Sales_Office(Office_Number)
create table Employee (Employee_ID int primary key 
,Employee_Name varchar(20) not null 
,Office_Number int not null foreign key references Sales_Office(Office_Number))
alter table Sales_Office add Employee_ID int not null foreign key references Employee(Employee_ID)
create table Own (Owner_ID int not null foreign key references Owners(Owner_ID)
, Property_ID int not null foreign key references property(Property_ID))
alter table Own add Percent_Owned int

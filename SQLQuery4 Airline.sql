create database Airlines_Companies
use Airlines_Companies 
create table Airline (Airlines_ID int primary key 
, Name varchar(20) 
, Address varchar(30) 
,Name_of_contact varchar(20) )



Create table Airline_Phones (Airlines_ID int foreign key references Airline(Airlines_ID))

create table Employee (Employee_ID int primary key 
, Name varchar(20) 
,Address varchar(30) 
,Position varchar(10) 
,Gender varchar(7) 
,Day tinyint
, Month tinyint
, Year int 
,Airline_ID int foreign key references Airline(Airlines_ID))

create table Employee_Qulifications(Employee_ID int foreign key references Employee(Employee_ID))

create table Aircraft( Aircraft_ID int primary key 
,Model varchar 
, Capacity int )

create table Has( Airlines_ID int foreign key references Airline(Airlines_ID) 
, Aircraft_ID int foreign key references Aircraft(Aircraft_ID))

create table Transactions(Transaction_ID int primary key 
, Date Date 
, Description varchar 
, Amount_of_Money int 
, Airlines_ID int foreign key references Airline(Airlines_ID))

create table Crew(Major_pilot varchar(20) primary key
, Aircraft_ID int foreign key references Aircraft(Aircraft_ID)
,Assistant_Pilot varchar(20) )


create table Crew_hostesses(Major_pilot varchar(20) foreign key references Crew(Major_pilot)
, Aircraft_ID int foreign key references Aircraft(Aircraft_ID)) 
drop table crew 


create table Crew(Major_pilot varchar(20) 
, Aircraft_ID int foreign key references Aircraft(Aircraft_ID) , primary key(Major_pilot , Aircraft_ID)
,Assistant_Pilot varchar(20))

create table Crew_hostesses(Major_pilot varchar(20) 
, Aircraft_ID int 
,foreign key(Major_pilot , Aircraft_ID) references  Crew(Major_pilot , Aircraft_ID)) 
drop table Crew_hostesses

create table Crew_hostesses(Major_pilot varchar(20) not null
, Aircraft_ID int not null
,foreign key(Major_pilot , Aircraft_ID) references  Crew(Major_pilot , Aircraft_ID))

create table Route (Route_ID INT not null primary key 
, Origin varchar(20) 
,Destination varchar(20) not null
, Distance int not null
,Classification varchar(8) not null)

create table Assigned(Aircraft_ID int not null foreign key references Aircraft(Aircraft_ID)
,Route_ID int not null foreign key references Route(Route_ID)
,Number_of_Passengers INT NOT NULL
,Price_per_Passenger  int not null
,Departure_Date_Time  datetime not null
,Arrival_Date_Time datetime not null
,Spent_Time time not null)




















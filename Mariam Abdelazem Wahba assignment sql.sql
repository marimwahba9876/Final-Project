select * from departments
select * from employee
select * from dependent
select * from project
select * from works_for


/*Q1 Get the employees names , b_date ,address ,department name , manager_id 
,only the employees who their salaries is higher than (the overall salaries avg)*/

select fname + ' ' + lname as full_name , Bdate , address , Dname , MGRSSN ,salary
from Employee e left join Departments d
on e.Dno=d.Dnum
where Salary > (select AVG(salary) from employee )
order by salary desc


/*Q2 Get the count of the dependents for each employee*/

select fname , count(ESSN) as count_dependent
from employee e left join dependent d
on e.ssn=d.essn
group by fname
order by count(ESSN) desc


/*Q3 get the count of employee for each supervisor with full details for the supervisors*/

select s.fname+' ' +s.Lname as full_name ,s.Ssn ,count(e.SSN) count_emp , s.Address , s.bdate , s.salary , s.sex , s.dno 
from Employee s join employee e
on s.ssn = e.Superssn
group by s.fname+' ' +s.Lname ,s.Ssn , s.Address , s.bdate , s.Salary , s.sex , s.dno 
order by s.Salary desc



/*Q4 Get the total worked hours for each project and how many employees worked for each project , with fullproject details (name , location , city)*/

select  p.pname ,p.plocation ,p.city , count(w.ESSn) as count_emp  , sum(w.hours) total_hours
from project p join works_for w 
on p.pnumber=w.pno
group by  p.pname , p.plocation ,p.city 
order by total_hours desc



/*Q5 get the top 1 project based on the working hours with full project details like the location , city and project name*/

select top 1  p.pname , p.plocation , p.city , sum( w.Hours) as totale_hours
from project p join Works_for w
on p.pnumber = w.pno
group by p.pname , p.plocation , p.city
order by totale_hours desc



/*Q6 how many employess in each department and how much the amount of salaries for each department */

select  dno , count(e.ssn) as count_emp , sum(salary) total_salary 
from employee e join Departments d
on e.dno=d.dnum
group by dno


/*Q7 get the department with full detailswhich it's total salaries higher than the average salary based on the department*/
create view  department_details as
select top 3 d.Dname, d.Dnum, d.MGRSSN , d.[MGRStart Date] , sum(e.salary) as total_salary
from Departments d join employee e
on d.Dnum = e.Dno
group by d.Dname, d.Dnum , d.Dnum, d.MGRSSN , d.[MGRStart Date] 
having sum(e.salary)> ( select avg(e.salary))

select dname , total_salary
from department_details
where total_salary >(select AVG(total_salary) from department_details)
 


/*Q8 get the full details for the departments managers and what is the oldest department in the company */

select e.fname+' '+lname as full_name ,e.sex , e.ssn , e.bdate , e.address , e.salary , d.Dnum ,d.[MGRStart Date]
from employee e join Departments d
on d.MGRSSN = e.ssn
order by d.[MGRStart Date]


/*Q9 how many males and females in the company for only the employees*/

select sex, count(ssn) as no_employee
from employee
group by Sex

--Q10
 select fname+' '+lname full_name , bdate , address , sex , salary ,ssn
 from employee 
 where ssn in (select distinct superssn from employee where Superssn is not null)
 union
 select e.fname+' '+lname full_name ,  e.bdate , e.address , e.sex , e.salary  ,e.SSN
 from employee e join departments d
 on d.mgrssn = e.ssn
 where ssn in (select mgrssn from Departments where MGRSSN is not null)
 order by salary desc



--Q11
select fname +' '+ lname as full_name ,ssn , bdate , address , sex ,salary ,(salary +salary *0.25) as new_salary , superssn , dno 
from employee
order by salary desc


/*Q13 update the new Dnum 40 with the next data: 
Dname is DP4 , MGRSSN is 101029 and insert the data that will be considered as the start of the dep (6/30/2024)*/

insert into Departments values ('DP4' , 40 ,101029 ,'6-30-2024')



/*Q12 insert a new employee tp DP 40 with ID 101029 his name is adel ibrahim 
and bdate 10-1-1990 his address is 75 fifth settlement.cario 
his salary is 2k and his super Id is 321654*/

insert into Employee values ('Adel' , 'Ibrahim' , 101029 , '10-1-1990 ' ,'75 Fifth settlement.Cairo' ,'M' , 2000 , 321654 , 40)




--Q14

create view top_3_employee as
select full_name ,  e.Dname , e.MGRSSN , e.project_per_emp , e.comp_hours_per_emp
, dp.count_of_dependent 
from
(select e.fname +' '+ e.Lname as full_name , d.Dname , d.MGRSSN ,count(distinct w.pno) project_per_emp  , sum( w.hours) comp_hours_per_emp  , e.SSN
from employee e join Works_for w
on e.ssn = w.essn
join Departments d 
on D.Dnum=e.Dno
group by fname +' '+ Lname , d.Dname , d.MGRSSN , e.ssn) e
left join
(select e.ssn , count(distinct dp.Dependent_name) as count_of_dependent
from employee e join Dependent dp
on e.SSN = dp.ESSN
group by e.ssn ) dp
on e.SSN = dp.SSN

select *
from top_3_employee
order by comp_hours_per_emp desc

--OR
select e.fname+' ' +lname full_name , e.SSN ,d.dname , d.mgrssn , count(distinct w.pno) projects_per_emp  , sum( w.hours) comp_hours_per_emp  
, (select count(sex) from dependent where e.ssn=ESSN) no_dependents
from employee e join Works_for w 
on e.ssn = w.ESSn
join departments d
on e.Dno=d.Dnum
group by e.fname+' ' +lname , d.dname , d.mgrssn ,  e.SSN 


--Q15
select e.fname+ ' ' + e.lname as emp_full_name , s.fname+ ' ' + s.lname as super_full_name ,s.SSN
from employee e join employee s
on s.SSN=e.Superssn
where s.Fname +' '+ s.lname like '%kamel mohamed'


--Q16
create view Completed_Projects as
select w.Pno , p.Pname , p.Plocation , sum(w.hours) total_hours
from project p join Works_for w
on p.Pnumber=w.Pno
group by w.Pno , p.Pname , p.Plocation
having sum(w.hours)  > 40

select Pname , total_hours 
from Completed_Projects





select fname , salary , count(pno) no_of_projects
, salary+salary*0.25 as annual_inc 
, salary+salary*0.25 - Salary as difference_salary 
,format(salary*0.25  /salary , 'p') ,
case
when salary+salary*0.25 >= 2500 then (salary+salary*0.25)*0
when salary+salary*0.25 >=2000 then (salary+salary*0.25)*0
when salary+salary*0.25 >=1500 then (salary+salary*0.25)*0.20
else  (salary+salary*0.25)*0.35
end as bonus  
,
case 
when count(pno) >= 4 then salary+salary*0.50
when count(pno) >= 3 then salary+salary*0.25
else salary+salary*0.15
end as project_bonus
from employee e join Works_for w 
on w.ESSn=e.SSN
group by fname , salary
order by annual_inc, no_of_projects


select fname , lname , ssn , dno , mgrssn, salary , sum(salary) over (partition by dno  ) as salary_per_dep , rank() over (order by dno) ranks_deps
, ROW_NUMBER() over (order by dno asc) row_no , DENSE_RANK () over (order by dno) denserank , ntile(5) over (order by salary) ntilesalary
from Employee e join Departments d 
on e.Dno=d.Dnum
order by ntilesalary asc 


select salary , dno 
, nth_value (salary ,2 ) over (partition by dno order by salary) 
from Employee


select fname , dno , salary 
from employee 
where dno %2= 0
order by dno asc





create function dbo.full_name_and_sex (@ssn int)
returns varchar (100)
as
begin
     declare @full_name_and_sex varchar(100)
	 select @full_name_and_sex = fname+ ' ' +lname + ' ' + sex 
	 from employee
	 where ssn = @ssn;
	 return @full_name_and_sex;

end;
select dbo.full_name_and_sex(123456)




create or alter function dbo.fullnameandsex (@ssn int ,@dno int )
returns varchar(100)
as
begin
     declare @fullnameandsex varchar(100);
	 select @fullnameandsex = 
	 fname+ ' ' +lname + ' ' + sex  
	 from employee
	 where (@ssn is not null and ssn = @ssn )
	 or 
	 (@dno is not null and dno=@dno)
	 return @fullnameandsex;
end;

select dbo.fullnameandsex(123456,null) as full_name_and_sex
select dbo.fullnameandsex(null,40) as full_name_and_sex



create or alter function total_hours_and_salary_and_dep ()
returns table 
as 
return 
select fname+' ' +lname full_name , sum(hours) as total_hours , dependent_name , ssn , salary
, (select count(sex) from dependent where e.ssn=ESSN) no_dependents , dep.sex sex
from employee e join works_for w 
on e.ssn=w.essn
join dependent dep
on e.ssn = dep.essn
group by fname+' ' +lname  , dependent_name ,e.ssn , dep.sex , ssn , salary 

select full_name , ssn , sex , salary ,
case 
when salary >2000 then salary*0 .5
when salary >1500 then salary *0.3
else salary *0.2
end as bonus
from total_hours_and_salary_and_dep ()
group by full_name , ssn , sex , Salary



select fname
from employee 
where fname like 'n___'




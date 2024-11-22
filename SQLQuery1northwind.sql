select * from Customers
select * from Categories
select * from Employees
select * from Orders
select * from [Order Details]
select * from Products
select * from Region
select * from Shippers
select * from Suppliers
select * from Territories
select * from EmployeeTerritories


select avg(datediff(day,orderdate,shippeddate)) avg_days_to_ship
from Orders

select Discontinued 
from Products
where Discontinued<>0

select orderid,ProductID, UnitPrice, Quantity,discount  
from [Order Details]
order by ProductID

select productid , sum((UnitPrice *Quantity)-(1-Discount))
from [Order Details]
where ProductID = 38
group by productid

select shipcountry, sum((UnitPrice *Quantity)-(1-Discount)) net_sales
from orders o
join 
[Order Details] od
on o.OrderID=od.OrderID
group by shipcountry
order by net_sales desc


update orders
set ShippedDate= dateadd(day,8,orderdate)
where shippeddate is null

select *
from orders
--where shipregion is null

select distinct top 3 shipregion , COUNT(shipregion) most_frequent
from Orders
where shipregion is not null
group by shipregion
order by most_frequent desc


select  firstname+ ' ' + lastname emplyee_name, count (distinct (customerid )) no_of_customers
from Employees e join orders d 
on e.EmployeeID= d.EmployeeID
group by firstname+ ' ' + lastname


select sum(freight)
from Orders


create view net_sales1 as
select od.orderid,customerid,ProductID ,sum((UnitPrice*Quantity)-(Discount*UnitPrice*Quantity)) net_sales
,sum(Discount*UnitPrice*Quantity) total_discount
from [Order Details] od
join Orders o
on  od.OrderID=o.OrderID
group by od.orderid,customerid,ProductID


----------------------------1---------------- KPIs
--a--Net_sales
select sum(net_sales) net_sales
from net_sales1

--b-- count of customers
select count(customerid) as total_customers
from Customers

--c-- count of orders
select count (distinct orderid) count_of_orders
from Orders

--d-- avg days
select avg(datediff(day, orderdate,shippeddate)) avg_days_to_ship
from orders

select orderid, avg(datediff(day, orderdate,shippeddate)) shipping_days_per_order
from orders
group by orderid

--chart
--a--Net sales  over the time (months ) 
select FORMAT(OrderDate, 'yyyy-MM') AS YearMonth,sum(net_sales) net_sales
from net_sales1 v
join 
orders o
on v.OrderID=o.OrderID
group by FORMAT(OrderDate, 'yyyy-MM') 
order by yearmonth 


--Top 5 customers by net sales 
select top 5 customerid, sum(net_sales) total_sales
from net_sales1
group by customerid
order by total_sales desc


--Top 5 products by net sales 
select top 5 v.productid, productname , sum(net_sales) net_sales
from net_sales1 v
join 
Products p
on v.ProductID=p.ProductID
group by v.productid , productname
order by net_sales desc


--Net sales by countries 
select shipcountry, sum(net_sales) net_sales
from Orders o
join net_sales1 v
on v.OrderID=o.OrderID
group by shipcountry
order by net_sales desc


----------------------------------2-----------Revenue Report
--a--Net profit 
Select sum((net_sales)*0.07) net_profit
from net_sales1 v
join 
orders o
on v.OrderID=o.OrderID

--b--Total Discounts
select sum(UnitPrice* Quantity*Discount) total_discount
from [Order Details]

--c--Shipping Cost 
create view  shippingcost as 
select sum(freight) shipping_cost
from Orders

--chart
--top 5 countries by net sales
select top 5 c.Country, sum(net_sales) net_sales
from Customers c
join 
net_sales1 v
on v.customerid= c.CustomerID
group by c.Country
order by net_sales desc


--Net sales , profits and discounts over the time 
SELECT 
   year(o.orderdate) as years,
    month(o.orderdate) as months, 
    SUM(net_sales) as net_sales,
    (SUM(net_sales))*0.07 as net_profit,
    SUM(total_discount) as total_discount
FROM 
    net_sales1 n
JOIN 
    Orders o ON n.OrderID = o.OrderID
GROUP BY 
    year(o.orderdate),
    month(o.orderdate)  
ORDER BY 
     Months,years asc

--Top 5 countries by discounts 
select top 5 ShipCountry , sum(distinct od.UnitPrice * od.Quantity * od.Discount) total_discount
from Orders o
join 
[Order Details] od
on o.OrderID = od.OrderID
group by ShipCountry
order by total_discount desc

-----------------------------3-------------  Customers Report :
--a--avg net sales  per customer 
select sum((UnitPrice*Quantity)-(Discount*UnitPrice*Quantity))/count(distinct c.customerid) avgnetsales
from
[Order Details] od
join
orders o
on o.orderid=od.orderid
join
Customers c
on c.CustomerID=o.CustomerID


--b-- avg profit per customer 
select avg(net_profit) avg_profitpercustomer 
from (select n.customerid
          ,sum(net_sales)*0.07 net_profit
		  from net_sales1 n
		  join 
		  Orders o
		  on o.orderID=n.orderid
		  group by n.customerid) customerprofits


--c--avg shipping cost per customer 
select SUM(freight)/count(distinct customerid) shipping_cost
from orders


--chart
--Count of customers over the time 
select  year(orderdate) years, count(distinct CustomerID) number_of_customers
from Orders
group by year(orderdate)
order by years

--Count of customers by countries 
 select ShipCountry,count(distinct customerid) no_customer_per_countries
 from orders
 group by ShipCountry

--Count of new customers and repeated customers 
--( new customers :  who have not any purchases in 1996 or 1997 only in 1998  and they will be considered as new customers at that  case )
create view new_customers1 as
select distinct o.CustomerID , 'new_customer' as customer_type
from orders o
where year(OrderDate)='1998'
and o.customerid not in (select distinct customerid from orders od where year(orderdate)<>'1998')
group by o.customerid

create view type_of_customers as
select n.customerid , 'new_customer' as customer_type
from new_customers1 n
union
select distinct o1.customerid as repeated_customers, 'repeated_customers' as customer_type 
from orders o1
where year(o1.orderdate)='1998'
and 
o1.CustomerID not in( select customerid from new_customers1)


----------------------------------4---- Products report : 
--a-- net profit per order
select od.orderid, sum(net_sales)*0.07 net_profit
from Orders od
join
net_sales1 nv
on nv.orderid=od.OrderID
group by od.orderid
order by od.orderid

select sum(net_sales)*0.07 totalnet_profit
from
net_sales1 nv


--b--Shipping cost per order 
select orderid,sum(freight) cost_of_shipping
from orders
group by orderid

select sum(freight) totalcost_of_shipping
from orders


--c--Net sales per order 
select orderid, sum(net_sales) net_sales
from net_sales1
group by orderid

select sum(net_sales) net_sales
from net_sales1



--d--count of products 
select count(productid) no_of_products
from Products

--e--count of categories 
select count(CategoryID) no_of_category
from Categories

--f--percentage of discontinued products and products are selling 
select 
format((count(case when Discontinued = 1 then 1 end)* 100) / COUNT(Discontinued),'00') + '%' AS PercentageDiscontinued,
format((count(case when Discontinued =0 then 0 end)*100)/count(Discontinued),'00')+'%' as PercentageSelling
from products

--charts
--a--Top 5 products  by net sales 
select top 5 n.ProductID, productname,sum(net_sales) net_sales
from net_sales1 n
join 
products p
on n.ProductID=p.ProductID
group by n.ProductID,productname
order by net_sales desc

--b--Net sales and profits by categories 
select c.categoryid,c.CategoryName,sum(net_sales) net_sales, sum(net_sales)*0.07 net_profit
from net_sales1 n
join 
orders d
on d.OrderID=n.orderid
join
Products p
on p.ProductID=n.ProductID
join 
Categories c
on c.CategoryID=p.CategoryID
group by c.categoryid,c.CategoryName
order by CategoryName



--5--Employee Report 
--a-net sales per employee  or avg
select o.employeeid,FirstName+' '+LastName employees ,sum(net_sales) netsales_per_emp,avg(net_sales) avgnetsales_per_emp
from net_sales1 n
join
Orders o
on o.OrderID=n.orderid
join 
Employees e
on e.EmployeeID=o.EmployeeID
group by o.employeeid ,FirstName+' '+LastName 


--b--count Orders per employee  or avg 
select e.employeeid,FirstName+' '+LastName employees, count(distinct orderid) no_of_orders
from Orders o
join
Employees e
on o.EmployeeID=e.EmployeeID
group by e.employeeid ,FirstName+' '+LastName

--c--count of employees  
select count(distinct employeeid) no_of_employess
from Orders

--d--count ofsupervisors
select count(distinct ReportsTo) no_supervisors
from Employees
WHERE ReportsTo IS NOT NULL


--chart
--a--Monthly  Net sales by employees 
select o.employeeid,FirstName+' '+lastname emp_name ,sum(net_sales) net_sales,YEAR(O.OrderDate) AS SalesYear, MONTH(O.OrderDate) AS SalesMonth
from Orders o
join 
net_sales1 n
on o.orderid=n.orderid
join 
employees e
on e.EmployeeID=o.EmployeeID
group by o.employeeid,FirstName+' '+lastname ,YEAR(O.OrderDate),MONTH(O.OrderDate)

--b--Count of the orders and net sales by the employees  (employee performance )
select o.EmployeeID,FirstName+' '+LastName emp_name,count(distinct o.OrderID) no_of_orders,sum(n.net_sales) net_sales
from net_sales1 n
join 
Orders o
on o.OrderID=n.orderid
join 
employees e
on e.EmployeeID=o.EmployeeID
group by o.EmployeeID, FirstName+' '+LastName


--c--Delayed orders and on time orders by employees 
select orderid,e.firstname, 
case
when
datediff(day, orderdate,shippeddate)>datediff(day, orderdate,requireddate )
then 'Delayed'
Else
'On Time'
end as orderstime
from Orders o
join
Employees e
on e.EmployeeID=o.EmployeeID


--6--Shippers Report 
--a--Shipping cost by order 
select sum(freight) shipping_cost
from Orders

--b--Avg days to ship 
select avg(datediff(day, orderdate,shippeddate)) avg_days_to_ship
from orders


--chart
--a--Shipping cost by the shippers  
select companyname , sum(freight) shippin_cost
from Orders o
join
Shippers s
on o.ShipVia=s.ShipperID
group by companyname

--b--On time  vs delayed  orders 
create view ordersperformance as
select companyname,
case
when
datediff(day, orderdate,shippeddate)>datediff(day, orderdate,requireddate )
then 'Delayed'
Else
'On Time'
end as orderstime
from Orders o
join
Shippers s
on s.ShipperID=o.ShipVia

select s.companyname, sum(case when orderstime ='On Time' then 1 else 0 end) on_time_orders,
sum(case when orderstime = 'delayed' then 1 else 0 end) delayed
from ordersperformance op
join 
shippers s
on s.CompanyName=op.CompanyName
group by s.companyname

--c--Shipping cost by the countries and shippers 
select s.companyname, o.ShipCountry, sum(o.freight) shipping_cost
from orders o
join 
Shippers s
on s.ShipperID=o.ShipVia
group by s.companyname, o.ShipCountry 





select sum(net_sales) netsales
from Products p
join
net_sales1 n
on n.ProductID=p.ProductID
order by netsales desc

SELECT 
    SUM((od.UnitPrice*Quantity)-(Discount*od.UnitPrice*Quantity)) AS NetSalesLY
FROM 
    Orders O
JOIN 
    [Order Details] OD ON O.OrderID = OD.OrderID
JOIN 
    Products P ON OD.ProductID = P.ProductID
WHERE 
    O.OrderDate in ('1998','1997','1996')
ORDER BY 
    NetSalesLY DESC;

SELECT 
 --   P.ProductID, 
 --   P.ProductName, 
    SUM((od.UnitPrice*Quantity)-(Discount*od.UnitPrice*Quantity)) AS NetSalesLY
FROM 
    Orders O
JOIN 
    [Order Details] OD 
	ON O.OrderID = OD.OrderID
WHERE 
    YEAR(O.OrderDate) in (1998,1997,1996) -- The Last Year (LY) in this case
--GROUP BY 
--    P.ProductID, P.ProductName
ORDER BY 
    NetSalesLY DESC;


























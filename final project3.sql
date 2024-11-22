select * from cleaned_data2
-- Total Sales
select round(sum(sales),2) Total_sales
from cleaned_data2
--Avg Shipping Days
select avg(datediff(day,[order date] , [ship date])) Average_days_to_Ship
from cleaned_data2
--No of orders
select COUNT([order id]) Total_number_of_orders
from cleaned_data2




select [customer id],count([order id])
from cleaned_data2
group by [customer id]

select count([order id])/count( distinct [customer id])
from cleaned_data2



--2-- Sales by Product Category

Select top 3 [Product Name] , sum(sales) Total_Sales
from cleaned_data2
group by [Product Name]
order by Total_Sales desc





--1--which product categories are the most profitable?


select category 
       , round(sum(sales),2) Total_Sales
from cleaned_data2
group by category 
order by Total_Sales desc






--2--what are the best selling sub categories within each product category
	WITH RankedSales AS (
SELECT   Category, [Sub-Category], ROUND(SUM(sales), 2) AS total_sales,
ROW_NUMBER() OVER (PARTITION BY Category ORDER BY SUM(sales) DESC) AS sales_rank
    FROM  cleaned_data2
    GROUP BY Category, [Sub-Category])
SELECT   Category, [Sub-Category], total_sales
FROM RankedSales
WHERE sales_rank = 1
ORDER BY total_sales DESC


--3--how do product categories perform across different region
select Region
       ,Category
	   ,round(sum(sales),2) Total_Sales
	   ,DENSE_RANK() over(partition by Region order by round(sum(sales),2) desc) as Sales_Rank
from cleaned_data2
group by Region
         ,Category
order by Region , Sales_Rank


--4--Are there any notable sales spikes during specific months for certain products
WITH MonthlySales AS (
    SELECT 
        Category,
        YEAR([Order Date]) AS OrderYear,
        MONTH([Order Date]) AS OrderMonth,
        SUM(Sales) AS TotalSales
    FROM 
        cleaned_data2
    GROUP BY 
        YEAR([Order Date]), MONTH([Order Date]), Category
),
RankedSales AS (
    SELECT 
        Category,
        OrderYear,
        OrderMonth,
        TotalSales,
        RANK() OVER (PARTITION BY OrderYear, Category ORDER BY TotalSales DESC) AS SalesRank
    FROM 
        MonthlySales
)

SELECT 
    Category,
    OrderYear,
    OrderMonth,
    TotalSales
FROM 
    RankedSales
WHERE 
    SalesRank <= 3
ORDER BY 
    OrderYear, Category, TotalSales DESC;



--5--How do average sales per order vary by product category
 SELECT Category, ROUND(SUM(sales) / COUNT(DISTINCT [Order ID]), 2) AS avg_sales_per_order
 FROM cleaned_data2
 GROUP BY  Category
 ORDER BY  avg_sales_per_order DESC




--4-- sales by customer segment

Select top 3 [Customer Name] , sum(sales) Total_Sales
from cleaned_data2
group by [Customer Name]
order by Total_Sales desc




--1--which customer segment contributrs the most to revenue

select Segment , round(sum(sales),2) Total_Sales
from cleaned_data2
group by segment
order by Total_Sales Desc

--2--what is the average order size by customer segment
select Segment 
       , round(Sum(sales)/COUNT(distinct [order id]),2) average_order_size
from cleaned_data2
group by segment
order by average_order_size desc

--3--number of orders for each segment
select  Segment, COUNT([Order ID]) as number_of_orders
from cleaned_data2
group by Segment


--4--What is the Proportion of Loyal and Regular Customers Relative to Total Orders?
 SELECT 
    [Customer Type],
    COUNT(*) AS Customer_Count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM cleaned_data2 )), 2) AS Percentage
FROM 
    cleaned_data2 
GROUP BY  
   [Customer Type]







--5--Do certain customer segments prefer specific shipping methods?

select Segment ,[ship mode],count([order id]) order_count, sum(sales) total_sales
from cleaned_data2
group by Segment ,[ship mode]
order by Segment , order_count desc




--6-- How do customer segments behave during seasonal sales periods
 
 WITH MonthlySales AS (
    SELECT 
	    Segment,
        YEAR([Order Date]) AS OrderYear,
        MONTH([Order Date]) AS OrderMonth,
        SUM(Sales) AS TotalSales
    FROM 
        cleaned_data2
    GROUP BY 
        YEAR([Order Date]), MONTH([Order Date]) ,Segment
),
RankedSales AS (
    SELECT 
        Segment,
		OrderYear,
        OrderMonth,
        TotalSales,
        RANK() OVER (PARTITION BY OrderYear,Segment ORDER BY TotalSales DESC) AS SalesRank
    FROM 
        MonthlySales
)
SELECT 
    Segment,
	OrderYear,
    OrderMonth,
    TotalSales
FROM 
    RankedSales
WHERE 
    SalesRank <= 3
ORDER BY 
    OrderYear, Segment,TotalSales desc




--7--Which sub-categories have the highest sales among each customer segment

WITH RankedSubCategories AS (
    SELECT 
        Segment,
        [Sub-Category],
        SUM(Sales) AS Total_Sales,
        ROW_NUMBER() OVER (PARTITION BY Segment ORDER BY SUM(Sales) DESC) AS Rank
    FROM  cleaned_data2
        
    GROUP BY 
        Segment, 
        [Sub-Category]
)
SELECT 
    Segment,
    [Sub-Category],
    Total_Sales
FROM 
    RankedSubCategories
WHERE 
    Rank = 1;


SELECT 
   Segment, YEAR([Order Date]) AS OrderYear, MONTH([Order Date]) AS OrderMonth,
    COUNT([Order ID]) AS NumberOfOrders, SUM(Sales) AS TotalSales,
    AVG(Sales) AS AverageOrderValue
FROM cleaned_data2
GROUP BY  YEAR([Order Date]), MONTH([Order Date]), Segment
ORDER BY  OrderYear, OrderMonth, TotalSales DESC;


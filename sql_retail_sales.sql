select *
from retail_sales;

select 	*
from retail_sales
where quantity is null;


select *
from retail_sales
where transactions_id is null or
	sale_date is null or
	sale_time is null or
	customer_id is null or
	gender is null or
	category is null or
	quantity is null or
	price_per_unit is null or
	cogs is null or
	total_sale is null;



delete from retail_sales
where transactions_id is null or
	sale_date is null or
	sale_time is null or
	customer_id is null or
	gender is null or
	category is null or
	quantity is null or
	price_per_unit is null or
	cogs is null or
	total_sale is null;



select count(*)
from retail_sales;



-- data exploration
select count(*)
from retail_sales;


-- select how many unique costomers in the customer_id column
select count(distinct customer_id)
from retail_sales;


select distinct category
from retail_sales;



-- business-analytics and findings
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select *
from retail_sales 
where sale_date in ('2022-11-05');


-- Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022

select *
from retail_sales
where category in ('Clothing') and quantity > 4 and to_char(sale_date,'yyyy-mm')='2022-11';


-- Write a SQL query to calculate the total sales (total_sale) for each category.:
select category, sum(total_sale) as total_sales, count(*) as total_orders
from retail_sales
group by category;



-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select round(avg(age)) as average_age
from retail_sales
where category in ('Beauty');



-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select *
from retail_sales
where total_sale > 1000;




-- Write a SQL query to find the total number of transactions (transaction_id)
-- made by each gender in each category.:

select category,gender,count(transactions_id)
from retail_sales
group by category, gender
order by category;



-- Write a SQL query to calculate the average sale for each month. 
-- Find out best selling month in each year:
select year,month,avg_sale
from(select extract(year from sale_date) as year,
			extract(month from sale_date) as month,
			avg(total_sale) as avg_sale,
			rank() over(partition by extract(year from sale_date) order by avg(total_sale)desc) as rank
from retail_sales
group by 1,2
) as t1
where rank = 1



-- Write a SQL query to find the top 5 customers based on the highest total sales:
select customer_id, sum(total_sale)
from retail_sales
group by 1
order by 2 desc
limit 5;



-- Write a SQL query to find the number of unique customers 
-- who purchased items from each category.:
select category, count(distinct customer_id) as unique_custmer
from retail_sales
group by category;



-- Write a SQL query to create each shift and number of orders (Example Morning <12, 
-- Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
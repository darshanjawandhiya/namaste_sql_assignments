-- SQL Filters Continue and aggregation
select * from orders;

-- setting some values as null
update orders
set city = null
where order_id IN ('US-2019-108966','CA-2019-117415'); -- 6 rows affected

select * from orders where order_id IN ('US-2019-108966','CA-2019-117415'); -- cross-checking results

-- filter data and check for records where city value is not available

select * from orders where city = null; -- this will not work as null is a special keyword and null !=null and also '' != null 

-- NOTE : In SQL two null values are NEVER THE SAME!

-- To get desired result where we get records with city having null value we make use of IS keyword 

select * from orders where city is null;

-- Result: It gives all records where city is null

 -- Note: 'IS' is a special keyword which is used to handle null values

select * from orders where city is not null;


-- aggregation
select 
count(*) as 'count',
sum(sales) as 'sum',
max(sales) as 'max_sales',
min(profit) as 'min_profit',
avg(profit) as 'avg_profit'  
from orders;

select * from orders order by sales desc limit 1;

-- group by region
select 
region,count(*) as 'count',
sum(sales) as 'sum',
max(sales) as 'max_sales',
min(profit) as 'min_profit',
avg(profit) as 'avg_profit'  
from orders
group by region;


select 
region from orders
group by region;
-- similar to
select distinct (region) from orders;

-- NOTE : advantage of group by is you can use aggregate values with it. 

-- subcategories where sales >100000
select sub_category,sum(sales) as 'total_sales' from orders
group by sub_category
having sum(sales)>100000
order by total_sales desc;

-- NOTE:
-- for row level filter : we use where clause
-- for filter on aggregated value : we use having clause

-- count ()
select count(*) from orders; 
select count(1) from orders;
select count(category) from orders;
select count(distinct category) from orders;

select count(distinct region),count(*),count(city) from orders;
-- count() does not counts null values

-- you need to solve the questions only with the concepts that have been discussed so far.

-- 1- write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909

update orders
set city = null
where order_id IN('CA-2020-161389' , 'US-2021-156909');

-- select * from orders where order_id IN('CA-2020-161389' , 'US-2021-156909');

-- 2- write a query to find orders where city is null (2 rows)

select * from orders where city is null;

-- 3- write a query to get total profit, first order date and latest order date for each category

select category,round(sum(profit),2) as 'total_profit',min(order_date) as 'first_order_date' ,max(order_date) as 'latest_order_date'  
from orders group by category ;

-- 4- write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category

select sub_category from orders group by sub_category
having avg(profit)> max(profit)/2;

-- 5- create the exams table with below script;
create table exams (student_id int, subject varchar(20), marks int);

insert into exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79);

-- write a query to find students who have got same marks in Physics and Chemistry.

select student_id,marks from exams where subject in ('Physics','Chemistry')
group by student_id,marks having count(*) = 2;

-- 6- write a query to find total number of products in each category.

select category,count(distinct(product_id)) as 'total_products' from orders group by category;

-- 7- write a query to find top 5 sub categories in west region by total quantity sold

select sub_category,sum(quantity) as 'total_quantity' from orders where region='West'
group by sub_category order by total_quantity desc limit 5;

-- 8- write a query to find total sales for each region and ship mode combination for orders in year 2020

select region,ship_mode,sum(sales) as 'total_sales' from orders where year(order_date) = 2020
group by region,ship_mode 
order by region;

-- OR
select region,ship_mode ,sum(sales) as total_sales
from orders
where order_date between '2020-01-01' and '2020-12-31'
group by region,ship_mode 
order by region;











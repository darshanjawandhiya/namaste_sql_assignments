SELECT * FROM marks;

select avg(marks) from marks;

select *,avg(marks) OVER() from marks;

select *,avg(marks) OVER(partition by branch) from marks;

select *, avg(marks) OVER(),
min(marks) OVER (),
max(marks) OVER (),
min(marks) OVER (partition by branch),
max(marks) OVER (partition by branch)
from marks
order by student_id;

-- Aggregate Function with OVER()

-- 1. Find all the students who have marks higher than the avg marks of their respective branch
select * from 
(select *,avg(marks) OVER(partition by branch) as 'branch_avg' from marks) t1
where t1.marks >t1.branch_avg;

-- RANK/DENSE_RANK/ROW_NUMBER

-- applying rank on whole data based on marks in desc order

select *,
RANK() OVER(order by marks desc) 
from marks;

-- applying rank on whole data partitioning by branch based on marks in desc order

select *,
RANK() OVER(partition by branch order by marks desc),
DENSE_RANK() OVER(partition by branch order by marks desc),
ROW_NUMBER() OVER(partition by branch order by marks desc)
from marks;

-- using concat function with over clause 

select *,
concat(branch,'-',row_number() over(partition by branch)) 
from marks;

-- 2. Find top 2 most paying customers of each month

SELECT *
FROM (
    SELECT 
        monthname(date) AS 'month',
        user_id,
        SUM(amount) AS 'total', 
        RANK() OVER(PARTITION BY monthname(date) ORDER BY SUM(amount) DESC) AS 'month_rank'
    FROM orders 
    GROUP BY monthname(date), user_id
) t
WHERE t.month_rank < 3
ORDER BY t.month desc, t.month_rank;

-- 3. Create roll no from branch and marks

select *,concat(branch,'-',ROW_NUMBER() OVER(partition by branch)) as 'roll_no'
from marks;


-- FIRST_VALUE/LAST VALUE/NTH_VALUE

-- FIRST_VALUE
select *,FIRST_VALUE(name) OVER(order by marks desc) from marks;

-- LAST_VALUE
select *,LAST_VALUE(name) OVER(order by marks desc) from marks; -- not works as expected due to default frame : unbounded preceding to current row
select *,LAST_VALUE(name) OVER(order by marks desc) from marks; -- not works as expected due to default frame : unbounded preceding to current row

-- 4. using FRAME Clause to get desired result while using last_value() - unbounded preceding to current row
select *,LAST_VALUE(marks) OVER(PARTITION BY branch order by marks desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) from marks;

-- NTH_VALUE

select *,NTH_VALUE(name ,2) OVER(PARTITION BY branch order by marks desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) from marks;

-- 5. Find the branch toppers
select name,branch,marks from (select *,first_value(name) OVER(partition by branch order by marks desc) as 'topper_name',
first_value(marks) OVER(partition by branch order by marks desc) as 'topper_branch'
from marks) t
where t.name=t.topper_name and t.marks=t.marks;

-- 6. Find the last guy of each branch

select name,branch,marks from (select *,
last_value(name) OVER(partition by branch order by marks desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as 'topper_name',
last_value(marks) OVER(partition by branch order by marks desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as 'topper_branch'
from marks) t
where t.name=t.topper_name and t.marks=t.marks;

-- 7. Alternate way of writing Window functions

select name,branch,marks from (select *,
last_value(name) OVER w as 'topper_name',
last_value(marks) OVER w as 'topper_marks'
from marks
WINDOW w AS (partition by branch order by marks desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) t
where t.name=t.topper_name and t.marks=t.topper_marks;

-- 8. Find the 2nd last guy of each branch

select name,branch,marks from (select *,
NTH_VALUE(name ,2) OVER w as 'sec_last_guy'
 from marks
WINDOW W AS (PARTITION BY branch order by marks  
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) t
where t.name=t.sec_last_guy;

-- 9. 5th topper of each branch

select *,
NTH_VALUE(name ,5) OVER w as 'fifth_topper'
 from marks
WINDOW W AS (PARTITION BY branch order by marks desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ;

-- LEAD & LAG 
-- on overall data
select *,
lag(marks) over (order by student_id),
lead(marks) over (order by student_id)
from marks;

-- lead and lag partitioned by branch

select *,
lag(marks) over (partition by branch order by student_id),
lead(marks) over (partition by branch order by student_id)
from marks;

-- Find the MoM revenue growth of Zomato

select monthname(date),sum(amount),
sum(amount)-lag(sum(amount)) OVER (order by month(date)) as 'MoM_Revenue',
((sum(amount)-lag(sum(amount)) OVER (order by month(date)))/lag(sum(amount)) OVER (order by month(date)))*100 as 'MoM_Revenue_%'
from orders group by monthname(date) 
order by month(date);




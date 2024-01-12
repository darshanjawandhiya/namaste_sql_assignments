select count(*) from orders;

select * from orders order by order_date desc limit 5;

-- to get distinct value of a column
select distinct(ship_mode) from orders;

-- filters in sql
select * from orders where ship_mode = 'First Class';

select distinct ship_mode from orders
where ship_mode > 'First Class'; -- here comparison of string is done based on ASCII value.It gives results where ASCII value is greater than 'F'

select distinct ship_mode from orders
where ship_mode > 'Second Class'; -- o/p : Standard Class , logic : ASCII comparison --> S vs S is same, next e>t -- We have only one value which matches this condn in our table : Standard Class. Hence we get it as final o/p.

select * from orders 
where ship_mode = 'First Class' or ship_mode= 'Same Day'; -- OR filter will always increase no. of rows 

select * from orders
where quantity>5 and order_date < '2020-11-08'; -- AND filter will always decrease no. of rows

-- example of using CAST function (type conversion function : used to convert one data type to another)
select *,cast(order_date as date) as order_date_new from orders
where cast(order_date as date)='2020-11-20';

SELECT CAST(order_date AS DATE) AS order_date_new, orders.* -- to include a column created using the CAST function as the first column followed by all the remaining columns in a SELECT query, we can explicitly list the casted column first and then use the wildcard (*) to select all other columns.
FROM orders;

-- creating new columns in table using existing columns
select *,round((profit/sales),2) as ratio,profit+sales as total
from orders;

select orders.*,NOW() as 'current_date' from orders; -- NOW() is used to get current date and time 
select orders.*,CURRENT_TIMESTAMP() as 'current_date' from orders; -- CURRENT_TIMESTAMP() is also used to get current date and time 

-- pattern matching using like operator

-- all customers whose name starts with 'C'
select order_id,order_date,customer_name from orders
where customer_name like 'C%'; -- % means after C we can have any number of characters

-- all customers whose name starts with 'Chris'
select order_id,order_date,customer_name from orders
where customer_name like 'Chris%';

-- all customers whose name ending with 'Schild'
select order_id,order_date,customer_name from orders
where customer_name like '%Schild';  -- adding % first followed by Schild means string can start with anything but needs to end with Schild

-- all customers whose name end with 't'
select order_id,order_date,customer_name from orders
where customer_name like '%t';

-- all customers whose name have 'ven' in between
select order_id,order_date,customer_name from orders
where customer_name like '%ven%'; -- in this way we can get strings with name starting and ending with anything but have 'ven' in between

-- all customers whose name start and end with 'a'
select order_id,order_date,customer_name from orders
where customer_name like 'A%a';

-- all customers whose name start and end with 'a'
select order_id,order_date,customer_name from orders
where customer_name like 'a%a';  -- SQL is by default case-insensitive

-- NOTE : SQL is by default case-insensitive. So, A=a.

-- how to make data in a cloumn uniform? If you have combination of upper case or lowercase strings and need a uniform string column, use upper or lower keyword
select order_id,order_date,upper(customer_name) as name_upper from orders
where upper(customer_name) like 'A%A';

-- NOTE :  _ (underscore) in pattern matching signifies that there should be at least one character

-- to find name where third character is 'e'
select order_id,order_date,upper(customer_name) as name_upper from orders
where upper(customer_name) like '__E%'; -- there are 2 underscore means any 2 characters and then 'E' : as we want 3rd character as E after that % means string can end with anything

select order_id,order_date,upper(customer_name) as name_upper from orders
where upper(customer_name) like '%l%'; -- this signifies we can have any no of characters in string but string should contain character 'l' .

select order_id,order_date,upper(customer_name) as name_upper from orders
where upper(customer_name) like '_l%'; -- here a single _ signifies that in a string there should be only one character and then it should have 'l' character at second place.

-- CONCLUSION : % -> 0 or more any characters, _ -> one character

-- use of []
-- query to return cust_name where name starts with C and has a or l as second character
select order_id,order_date,customer_name from orders
where customer_name like '%C[al]%'; -- returns cust_name where name starts with C and has a or l as second character
-- This [] is not supported in MySQL

-- Easy Walkaround for [] which works in MySQL
SELECT customer_name
FROM orders
WHERE customer_name REGEXP '^C[al]'; -- returns cust_name where name starts with C and has a or l as second character

-- Another Walkaround for [] 
SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'C%' AND (customer_name LIKE 'Ca%' OR customer_name LIKE 'Cl%'); -- returns cust_name where name starts with C and has a or l as second character

-- query to return cust_name where name starts with C and does not has a or l as second character
SELECT customer_name
FROM orders
WHERE customer_name REGEXP '^C[^al]'; -- returns cust_name where name starts with C and does not has a or l as second character

-- Conclusion of using ^ operator :
-- In the context of the regular expression used in the MySQL query, the ^ character is used in two different ways:

-- Outside Square Brackets: Anchoring to the Beginning of the String

-- When used at the beginning of the regular expression pattern (^C), it acts as an anchor, asserting that the pattern must occur at the start of the string.
-- Example: ^C matches if the string starts with 'C'.
-- Inside Square Brackets: Negating a Character Class

-- When used inside square brackets ([^al]), it negates the character class, indicating that the pattern should match any single character that is not 'a' or 'l'.
-- Example: [^al] matches any character except 'a' or 'l'.
-- So, in the overall context of the query, ^ serves two distinct purposes:

-- Anchoring to the Beginning: Ensures that the pattern 'C[^al]' must occur at the start of the string.
-- Negating a Character Class: Specifies that the second character must not be 'a' or 'l'.
-- This combination ensures that the customer_name must start with 'C' and the second character is not 'a' or 'l'.

-- passing range of characters as wildcard using REGEX (as REGEX is supported in MySQL for pattern matching)

-- query to return cust_name which starts with C and has second character as a,b,c,d,e,f,g or h
SELECT customer_name
FROM orders
WHERE customer_name REGEXP '^C[a-h]'; -- returns cust_name which starts with C and has second character as a,b,c,d,e,f,g or h

-- Assignment 
-- Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.

-- 1- write a sql to get all the orders where customers name has "a" as second character and "d" as fourth character (58 rows)

select * from orders where customer_name like '_a_d%';

-- 2- write a sql to get all the orders placed in the month of dec 2020 (352 rows) 

select * from orders where order_date between '2020-12-01' and '2020-12-31'; -- we need to give dates and string in single quotes.

-- 3- write a query to get all the orders where ship_mode is neither in 'Standard Class' nor in 'First Class' and ship_date is after nov 2020 (944 rows)

SELECT * FROM orders WHERE ship_mode != 'Standard Class' AND ship_mode != 'First Class' AND ship_date > '2020-11-30';

SELECT * FROM orders WHERE ship_mode NOT IN ('Standard Class', 'First Class') AND ship_date > '2020-11-30';

SELECT * FROM orders WHERE ship_mode <> 'Standard Class' AND ship_mode <> 'First Class' AND ship_date > '2020-11-30'; -- <> = NOT IN OPERATOR

-- 4- write a query to get all the orders where customer name neither start with "A" and nor ends with "n" (9815 rows)

 select * from orders where customer_name not like 'A%n';

-- 5- write a query to get all the orders where profit is negative (1871 rows)

select * from orders where profit <  0;

-- 6- write a query to get all the orders where either quantity is less than 3 or profit is 0 (3348)

select * from orders where quantity < 3 or profit =0;

-- 7- your manager handles the sales for South region and he wants you to create a report of all the orders in his region where some discount is provided to the customers (815 rows)

select * from orders where region = 'South' and discount >0;

-- 8- write a query to find top 5 orders with highest sales in furniture category 

select * from orders where category ='Furniture' order by sales desc limit 5; -- for single value we can use = operator

-- 9- write a query to find all the records in technology and furniture category for the orders placed in the year 2020 only (1021 rows)

select * from orders where category in('technology','furniture') and year(order_date)=2020;  -- for multiple values we can use IN keyword

-- 10-write a query to find all the orders where order date is in year 2020 but ship date is in 2021 (33 rows)

select * from orders where year(order_date) = 2020 and year(ship_date) = 2021; 

select * from orders where order_date between '2020-01-01' and '2020-12-31' and ship_date between '2021-01-01' and '2021-12-31'
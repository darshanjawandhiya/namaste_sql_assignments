create table amazon_orders
(
order_id integer,
order_date date,
product_name varchar(100),
total_price decimal(6,2),
payment_method varchar(20)
);

select * from amazon_orders;  

-- change data type of a column
alter table amazon_orders modify column order_date datetime; -- DDL
alter table amazon_orders modify column order_date datetime; -- wrong. This does not works : datatype should be compatible 
alter table amazon_orders modify column product_name varchar(20); -- datatype should be compatible, in this case we are not loosing any data by reducing size of varchar to 20. So, size is updated without giving an error

-- if table is empty we can change from any data type to any other data type 

insert into amazon_orders values(5,'2022-10-01 12:05:12','Shoes',132.5,'UPI');
insert into amazon_orders values(6,'2022-10-01 12:05:12',null,132.5,'UPI','Darshan');
insert into amazon_orders values(7,'2022-10-01 12:05:12',null,132.5,'UPI','Rahul');

-- add a column in an existing table
alter table amazon_orders add column user_name varchar(20);
alter table amazon_orders add column category varchar(20);

-- delete/drop a column from an existing table
alter table amazon_orders drop column category;

-- constraints 
drop table a_orders;
create table a_orders
(
order_id integer NOT NULL UNIQUE, -- not null constraint,unique constraint
order_date date, 
product_name varchar(100),
total_price decimal(6,2),
payment_method varchar(20) CHECK (payment_method in ('UPI','CREDIT CARD')) default 'UPI', -- check constraint,default constraint 
discount integer check (discount<=20),-- check constraint 
category varchar(20) default ('Mens Wear') -- default constraint
); 

insert into a_orders values(null ,'2022-10-01','Shoes',132.5,'UPI'); -- Error: Column 'order_id' cannot be null
insert into a_orders values(1 ,'2022-10-01','Shoes',132.5,'internet banking'); -- Error: Check constraint 'a_orders_chk_1' is violated.
insert into a_orders values(1 ,'2022-10-01','Shoes',132.5,'UPI');
insert into a_orders values(1 ,'2022-10-01','Shoes',132.5,'UPI',1); -- works
insert into a_orders values(1 ,'2022-10-01','Shoes',132.5,'UPI',21); -- Error: Check constraint 'a_orders_chk_2' is violated.
insert into a_orders values(1 ,'2022-10-01','Shoes',132.5,'UPI',20); -- works
insert into a_orders values(1 ,'2022-10-01','Shirts',132.5,'UPI',20); -- Error: UNIQUE constaint voilated.Duplicate entry '1' for key 'a_orders.order_id'
insert into a_orders values(1 ,'2022-10-01','Shirts',132.5,'UPI',20,''); -- default value Mens Wear does not come by putting '' this will store an empty string 

-- walkaround which works and inserts default value : it will work only when we pass columns and then values as if we don't pass columns then it is expecting values for all columns which are present in the table.
insert into a_orders(order_id,order_date,product_name,total_price,payment_method,discount) 
values(2,'2022-10-01','Shirts',132.5,'UPI',20); -- now default value of mens wear is inserted
insert into a_orders(order_date,order_id,product_name,total_price,payment_method,discount) -- we can change sequence of columns also and put values in similar order
values('2022-10-01',3,'Pants',132.5,'UPI',20); 

insert into a_orders(order_date,order_id,product_name,total_price,payment_method) -- we can change sequence of columns also and pt values in similar order
values('2022-10-01',4,'Pants',132.5,'UPI'); -- as there is no default value assigned for discount col, NULL will be inserted.

insert into a_orders(order_id,order_date,product_name,total_price)
values(1,'2022-10-01','Pants',132.5); -- default values in payment_method and category column gets added automatically

insert into a_orders(order_id,order_date,product_name,total_price,payment_method)
values(2,'2022-10-01','Shoes',132.5,default); -- if we add the default constraint column and in values pass default,it automatically takes the default value, UPI in this case.


select * from a_orders;  

-- UNIQUE VS PRIMARY KEY CONSTRAINT 
-- Primary key is similar to unique key.
-- Unique key and primary key both cannot contain duplicates but,
-- In Unique key we can have null values whereas primary key does not contain null values.
-- We can have multiple unique key columns in a table but only one primary key (order_id) or one combination of (order_id_product_name) primary key columns in a table.

-- UNIQUE KEY example
create table a_orders
(
order_id integer UNIQUE, -- unique constraint 
order_date date, 
product_name varchar(100),
total_price decimal(6,2),
payment_method varchar(20) CHECK (payment_method in ('UPI','CREDIT CARD')) default 'UPI', -- check constraint,default constraint 
discount integer check (discount<=20),-- check constraint 
category varchar(20) default ('Mens Wear') -- default constraint
); 

insert into a_orders(order_id,order_date,product_name,total_price,payment_method)
values(null,'2022-10-01','Shoes',132.5,default); -- null value inserted in order_id column successfully

-- trying to insert null value in order_id column again
insert into a_orders(order_id,order_date,product_name,total_price,payment_method)
values(null,'2022-10-01','Shoes',132.5,default); -- works

-- PRIMARY KEY EXAMPLE
create table a_orders
(
order_id integer,   
order_date date, 
product_name varchar(100),
total_price decimal(6,2),
payment_method varchar(20) CHECK (payment_method in ('UPI','CREDIT CARD')) default 'UPI', -- check constraint,default constraint 
discount integer check (discount<=20),-- check constraint 
category varchar(20) default ('Mens Wear'), -- default constraint
primary key (order_id,product_name)
); 

insert into a_orders(order_id,order_date,product_name,total_price,payment_method)
values(null,'2022-10-01','Shoes',132.5,default); -- does not works Error: Column 'order_id' cannot be null

insert into a_orders(order_id,order_date,product_name,total_price,payment_method)
values(1,'2022-10-01','Shoes',132.5,default);

insert into a_orders(order_id,order_date,product_name,total_price,payment_method)
values(1,'2022-10-01','Jeans',132.5,default); -- we are able to insert it as primary key is combination of order_id and product_name

-- if i try to insert record again with order_id 1 and product_name Jeans, it will not work due to primary_key violation as it does not allows duplicates
insert into a_orders(order_id,order_date,product_name,total_price,payment_method)
values(1,'2022-10-01','Jeans',132.5,default); -- Error: Duplicate entry '1-Jeans' for key 'a_orders.PRIMARY'

-- NOTE : Primary key is unique constraint + NOT NULL constraint (together)

-- delete command
delete from a_orders; -- deletes all records from the table
select * from a_orders;

-- delete with a filter condition
delete from a_orders where order_id = 2; -- deletes selected record where order_id=2 
delete from a_orders where product_name = 'jeans'; -- deletes selected record where product_name='jeans'

-- update command (DML)
update a_orders
set discount=10;  -- updates all records and set discount = 10

update a_orders
set discount=20 where product_name ='shoes'; -- updates selected record where product_name = 'shoes' 

update a_orders
set product_name='jeans2' , payment_method='CREDIT CARD'
where  product_name='jeans';

select * from a_orders;




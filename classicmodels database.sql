use classicmodels;
#Q1. SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)
#a.	Fetch the employee number, first name and last name of those employees who are working as Sales Rep reporting to employee with employeenumber 1102 (Refer employee table)

select * from employees;
select employeeNumber,firstName,lastName from employees where jobTitle='Sales Rep' and reportsTo=1102;

	

#b. Show the unique productline values containing the word cars at the end from the products table.
select * from productlines;
select productline from productlines where productline like'%Cars';


#Q2. CASE STATEMENTS for Segmentation
#. a. Using a CASE statement, segment customers into three categories based on their country:(Refer Customers table) "North America" for customers from USA or Canada
#"Europe" for customers from UK, France, or Germany "Other" for all remaining countries Select the customerNumber, customerName, and the assigned region as "CustomerSegment".

  
select * from customers;
Select customerNumber, customerName, case when country in('USA','Canada') THEN 'NORTH AMERICA' when country in('UK','France','Germany') Then 'Europe' else 'others' end  as "CustomerSegment" from customers ;


# Q3 .Group By with Aggregation functions and Having clause, Date and Time functions
#a.	Using the OrderDetails table, identify the top 10 products (by productCode) with the highest total order quantity across all orders.


use classicmodels;
select * from orderdetails;	
select productcode,sum(quantityordered) as total_ordered from orderdetails group by productcode order by total_ordered desc limit 10;



#b.	Company wants to analyse payment frequency by month. Extract the month name from the payment date to count the total number of payments for each month and include only those months with a payment count exceeding 20. Sort the results by total number of payments in descending order.  (Refer Payments table). 


select * from payments;
select date_format(paymentdate,'%M') as payment_month,count(paymentdate) as num_payments from payments group by payment_month having num_payments>20 order by num_payments desc;


#Q4. CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default

#4 a.
create database Customers_Orders; 
use Customers_Orders ;
create table customers(customer_id integer primary key auto_increment,first_name varchar(50) not null,last_name varchar(50) not null,email varchar(255) unique,phone_number varchar(20));

#4 b.
create table orders(order_id integer primary key auto_increment,customer_id integer, foreign key(customer_id) references customers(customer_id),order_date date,total_amount decimal(10,2) check(total_amount>0));


#Q5. JOINS 
#a. List the top 5 countries (by order count) that Classic Models ships to. (Use the Customers and Orders tables)

use classicmodels;
select * from customers;
select * from orders;
select c.country,count(ordernumber) as order_count from customers as c left join orders as o on c.customernumber=o.customernumber  group by country order by order_count desc limit 5;


#Q6. SELF JOIN  	
create table project(employeeID integer primary key auto_increment,fullName varchar(50) not null,Gender varchar(6) check(Gender in("Male","Female")),ManagerID integer);
insert into project(fullName,Gender,ManagerID)values('pranaya','Male',3),('priyanka','Female',1),('preety','Female',null),('Anurag','Male',1),('Sambit','male',1),('Rajesh','Male',3),('Hina','Female',3);
select * from project;
select m.fullName as Manager_Name,e.fullName as Emp_Name from project as m left join project as e on m.employeeID=e.ManagerID  where e.fullName is not null order by m.fullName,e.fullname;


#Q7. DDL Commands: Create, Alter, Rename
create table facility(Facility_id integer,name varchar(50),state varchar(50),country varchar(50));
desc facility;
alter table facility modify column Facility_id integer auto_increment primary key;
alter table facility add column city varchar(255) not null after name ;


#Q8. Views in SQL

select * from products;	
select * from orders;
select * from orderdetails;
select * from productlines;
#create view product_category_sales as 
select pl.productline,(sum(od.quantityordered)*sum(od.priceeach)) as total_sales,count(distinct o.ordernumber) as  number_of_orders from productlines as pl left join products p on pl.productline= p.productline left join  orderdetails as od on p.productcode=od.productcode left join orders as o on od.ordernumber=o.ordernumber group by pl.productline;


#Q9. Stored Procedures in SQL with parameters

 select * from customers;
 select * from payments;
 call Get_country_payments(2003,'France');
 
 
 #Q10. Window functions - Rank, dense_rank, lead and lag
 
 #a. 
 
select * from customers;
select * from orders;
SELECT customerName,COUNT(orderNumber) AS Order_count,RANK() OVER (ORDER BY COUNT(orderNumber) DESC) AS order_frequency_rank
FROM customers c JOIN orders o ON c.customerNumber = o.customerNumber GROUP BY customerName;


#b wrong

SET SESSION sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));


select * from orders;
select distinct  year(orderdate) as year,date_format(orderdate,'%M')as month,count(ordernumber) as order_count,
concat(round(100*(count(ordernumber) / NULLIF(LAG(count(ordernumber), 1) OVER
(ORDER BY year(orderdate),month(orderdate)),0) - 1),0),'%') as order_frequency_rnk  from orders group by year(orderdate),month(orderdate) order by year,month(orderdate);



#Q11.Subqueries and their applications

select * from products;
select productline,count(buyprice) as Total from products where buyprice>(select avg(buyprice) from products) group by productline order by Total desc;

#Q12. ERROR HANDLING in SQL

create table Emp_EH(EmpID integer primary key,EmpName varchar(255),EmailAddress varchar(255));
call Emp_eh_proc(1,'akku','ekjdkd@gmail.com');
select * from Emp_EH;
call Emp_eh_proc(2,'achu','achu@gmail.com');
call Emp_eh_proc(1,'jiju','jiju@gmail.com');


#13 triggers
Create table Emp_BIT(name varchar(255),occupation varchar(255),working_date date,working_hours integer);
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

select * from Emp_BIT;
INSERT INTO Emp_BIT VALUES
('tinu', 'Analyst', '2026-6-05', -12);  
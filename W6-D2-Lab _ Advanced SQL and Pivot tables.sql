# Lab | Advanced SQL and Pivot tables
	# In this lab, you will be using the Sakila database of movie rentals.

use sakila;
-- set sql_safe_updates=0;
-- SET sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

### Instructions
	# Write the SQL queries to answer the following questions:

	-- 1. Select the first name, last name, and email address of all the customers who have rented a movie.
select first_name, last_name, email from sakila.customer;

		-- Checking amount of customers.
		select count(distinct(customer_id)) from sakila.customer;
		-- Checking amount of customers who have rented a film.
		select count(distinct(customer_id)) from sakila.payment;

	-- 2. What is the average payment made by each customer (display the *customer id*, *customer name* (concatenated), and the *average payment made*).
select a.customer_id, concat(b.first_name, ' ', b.last_name) as customer_name, avg(a.amount) as avg_payment from sakila.payment as a
join sakila.customer as b on b.customer_id = a.customer_id
group by customer_id;

	-- 3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
		    -- 3.1. Write the query using multiple join statements.
            select concat(first_name, ' ', last_name) as customer_name, email from sakila.customer;
            
select distinct(concat(a.first_name, ' ', a.last_name)) as customer_name, a.email, e.name as category from sakila.customer as a
join sakila.rental as b on b.customer_id = a.customer_id
join sakila.inventory as c on c.inventory_id = b.inventory_id
join sakila.film_category as d on d.film_id = c.film_id
join sakila.category as e on e.category_id = d.category_id
where e.name = 'ACTION'
order by customer_name;
    
			-- 3.2 Write the query using sub queries with multiple WHERE clause and `IN` condition.
			select concat(first_name, ' ', last_name) as customer_name, email from sakila.customer;
            select * from sakila.inventory;
            select * from film_category;
            select * from sakila.category;
            
            select name as category from sakila.category
            where name in ('ACTION');
            
            
            
			select i.inventory_id from sakila.film_category as fc
			inner join sakila.inventory as i on fc.film_id = i.film_id
			where category_id=1;

			select customer_id from sakila.rental
			where inventory_id in (select i.inventory_id from sakila.film_category as fc
			inner join sakila.inventory as i on fc.film_id = i.film_id
			where category_id=1);

select concat(first_name, ' ', last_name) as customer_name, email from sakila.customer 
where customer_id in (select customer_id from sakila.rental
where inventory_id in (select i.inventory_id from sakila.film_category as fc
inner join sakila.inventory as i on fc.film_id = i.film_id
where category_id=1))
order by customer_name;

			-- 3.3 Verify if the above two queries produce the same results or not.
    

	-- 7. Use the case statement to create a new column classifying existing columns as either low, medium or high value transactions based on the amount of payment. 
    -- If the amount is between 0 and 2, label should be `low` and if the amount is between 2 and 4, the label should be `medium`, and if it is more than 4, then it should be `high`.
			select * from sakila.payment;
        
select *,
case 
	when amount <= 1.99 then 'low'
    when amount >= 2 and amount <= 3.99 then 'medium'
    when amount >= 4 then 'high' 
end as value_based_on_amount
from sakila.payment;
    
    
    
    
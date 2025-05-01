-- Database
use OnlineShoppingDB;

-- PART 2

-- QUES 2: 
/*  Write a query that returns the names and countries of customers who made orders with
a total amount between £500 and £1000.   */
Select c.name,c.country
	from Customers as c inner join Orders as o on c.customer_id=o.customer_id 
		inner join Order_items as oi on o.order_id=oi.order_id
	group by c.name,c.country,oi.Total_amount
	having  500< oi.Total_amount and oi.Total_amount<1000 order by oi.Total_amount;

-- QUES 3:
/*    Get the total amount paid by customers belonging to UK who bought at least more than
three products in an order.      */
Select c.customer_id,c.name,sum(p.amount_paid) as Total_amount_paid
	from Customers c inner join Orders o on c.customer_id=o.customer_id
		inner join Order_items oi on o.order_id=oi.order_id
		inner join Payments p on oi.order_id=p.order_id 
	where c.country='UK' 
	group by c.customer_id,c.name 
	having sum(oi.quantity)>3;


-- QUES 4:
/*   Write a query that returns the highest and second highest amount_paid from UK or
Australia – this is calculated after applying VAT as 12.2% multiplied by the amount_paid.
Some of the results are not integer values and your client has asked you to round the
result to the nearest integer value.   */
Select top 2 p.order_id, round((sum(p.Amount_paid)*1.122),0) as Total_amount_paid
	from Customers c join Orders o on o.customer_id=c.customer_id
		inner join Payments p on o.order_id=p.order_id
	where c.country in ('UK','Australia' )
	group by o.customer_id,p.order_id
	order by Total_amount_paid desc

-- QUES 5:
/*    Write a query that returns a list of the distinct product_name and the total quantity
purchased for each product called as total_quantity. Sort by total_quantity.   */
Select  p.product_name, sum(oi.quantity) as total_quantity
	from Products p inner join Order_items oi on p.product_id=oi.product_id
	group by  p.product_name,p.product_id
	order by total_quantity

-- QUES 6:
/*   Write a stored procedure for the query given as: Update the amount_paid of customers
who purchased either laptop or smartphone as products and amount_paid>=£17000 of
all orders to the discount of 5%.    */

-- Creating a backup table if it doesn't exist (preventing data loss)
If not exists (select * from INFORMATION_SCHEMA.TABLES 
		where TABLE_NAME = 'Payments_Backup')
Begin
    Select * into Payments_Backup FROM Payments;
End

-- checking columns
SELECT p.order_id,SUM(p.amount_paid) as total_amount,
		(sum(p.Amount_paid)*0.95) as discounted_amount
		FROM Payments p JOIN Orders o ON p.order_id = o.order_id
		WHERE p.order_id IN (
			SELECT DISTINCT oi.order_id
			FROM Order_Items oi
			JOIN Products pr ON oi.product_id = pr.product_id
			WHERE pr.product_name IN ('Laptop', 'Smartphone') )
		GROUP BY p.order_id,p.Amount_paid
		HAVING SUM(p.amount_paid) >= 17000 order by p.order_id

-- Creating procedure for discount
Create procedure ApplyDiscount
As 
Begin
	update Payments
	set Amount_paid=Amount_paid*0.95
	where order_id in (
			SELECT oi.order_id FROM Order_Items oi 
				JOIN Products pr ON oi.product_id = pr.product_id
			WHERE pr.product_name IN ('Laptop', 'Smartphone') 
			GROUP BY oi.order_id
			HAVING (
				select SUM(p.amount_paid) from Payments p where p.order_id=oi.order_id)
				>= 17000)
end

exec ApplyDiscount


-- QUES 7: Extra ques

-- USING PAYMENTS_BACKUP FOR ORIGINAL DATA 
-- 1. Find the total amount_paid per payment method
Select payment_method,sum(Amount_paid) as total_amount_paid from Payments_Backup
	group by payment_method order by total_amount_paid desc

-- 2. Customers who ordered from at least 1 category 
Select c.customer_id,c.[name] ,c.email,c.country
	from Customers c 
	where exists (
		select 1,p.product_name from Orders o join Order_items oi on o.order_id=oi.order_id
			join Products p on oi.product_id=p.product_id
			where c.customer_id=o.customer_id)

-- 3. Find customers who paid more than average in their country
Select c.customer_id,c.name,c.country,sum(p.Amount_paid) as amount_paid,
	(select round(avg(p1.Amount_paid),2)
			from Payments p1 join Orders o1 on p1.order_id=o1.order_id
			join Customers c1 on c1.customer_id=o1.customer_id
			where c1.country=c.country) as Average_by_country
	from Customers c join Orders o on c.customer_id=o.customer_id
	join Payments p on o.order_id=p.order_id
	group by c.customer_id,c.name,c.country
	having sum(p.Amount_paid)>
		(select avg(p1.Amount_paid) 
			from Payments p1 join Orders o1 on p1.order_id=o1.order_id
			join Customers c1 on c1.customer_id=o1.customer_id
			where c1.country=c.country)

-- 4. Find Customer and mask their emails
Select customer_id,[name],country,
	replace(email,substring(email,2,charindex('@',email)-3),'*****') as masked_email
	from Customers

-- 5. Calculate the Difference in Days Between Order and Payment Date (Date Functions)
Select p.payment_id, p.order_id, o.order_date, p.payment_date, 
    DATEDIFF(day, o.order_date, p.payment_date) as days_to_payment
	from Orders o JOIN Payments p on o.order_id = p.order_id;

-- 6. Find customers who haven't made any payments
Select c.customer_id, c.name from Customers c
	where not exists (
		select 1 from Orders o 
			join Payments p on o.order_id = p.order_id
			where o.customer_id = c.customer_id);

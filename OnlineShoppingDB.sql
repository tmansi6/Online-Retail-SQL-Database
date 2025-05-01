-- PART 1

-- Creating Database
Create database OnlineShoppingDB;

-- Using Database
Use OnlineShoppingDB;

-- Creating Tables
Create table Customers(
		customer_id int Primary key identity(1,1),
		name nvarchar(200) not null,
		email nvarchar(200) not null,
		phone nvarchar(50) not null,
		country nvarchar(100) not null);

Create table Products(
		product_id int primary key identity(1,1),
		product_name nvarchar(50) not null,
		category nvarchar(50) not null,
		price decimal(10,2));

Create table Orders(
		order_id int Primary key not null,
		customer_id int foreign key(customer_id) references Customers(customer_id),
		order_date date not null);

Create table Order_items(
		order_item_id int Primary key not null,
		order_id int foreign key(order_id) references Orders(order_id),
		product_id int foreign key(product_id) references Products(product_id),
		quantity int not null,
		price_each decimal(10,2),
		Total_price decimal(10,2),
		Total_amount decimal(10,2));

Create table Payments(
		payment_id int Primary key not null,
		order_id int foreign key(order_id) references Orders(order_id),
		payment_date date not null,
		payment_method nvarchar(50) not null,
		Amount_paid decimal(10,2));

-- Inserting Record From Csv Files
Insert into Customers(name,email,phone,country)
	select name, email, phone,country  from dbo.Customer;

Insert into Orders(order_id,customer_id,order_date) 
	select order_id, customer_id,order_date from dbo.[Order];

Insert into Order_items(
	order_item_id,order_id,product_id,quantity,price_each,Total_price,Total_amount) 
	select order_item_id,order_id,product_id,quantity,price_each,Total_price,Total_amount 
	from dbo.Order_item;

Insert into Products(product_name,category,price)
	select product_name,category,price from dbo.[Product];

Insert into Payments(payment_id,payment_date,order_id,payment_method,Amount_paid)
	select payment_id,payment_date,order_id,payment_method,Amount_paid from dbo.Payment;

-- Confirming uploaded data
select *from Customers;
select *from Order_items;
select *from Orders;
select *from Payments;
select *from Products;

-- Dropping unwanted tables 
drop table Customer;
drop table Order_item;
drop table [Order];
drop table [Product];
drop table Payment;




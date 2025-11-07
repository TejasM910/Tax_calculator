create database practice;
use practice;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    City VARCHAR(50)
);
 
 
-- Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2)
);
  
-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    OrderDate DATE,
    Quantity INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
-- 1 List all orders with customer names and product names.
select c.CustomerName,p.ProductName,o.OrderID 
from Orders o
join Products p on p.ProductID=o.ProductId 
join customers c on c.customerid=o.customerid;

-- 2 Find all customers who placed an order for "Product_14".
select c.CustomerName,p.ProductName,o.OrderID 
from Orders o 
join Products p on p.ProductID=o.ProductId 
join customers c on c.customerid=o.customerid 
where productname="Product_14";

-- 3 Show total quantity ordered per customer.
select c.customername,sum(o.quantity) as totalquantity 
from orders o 
join customers c on c.customerid=o.customerid 
group by customername 
order by totalquantity desc;

-- 4 List customers who have never placed an order.
select c.customername 
from customers c 
left join orders o on c.customerid=o.customerid 
where o.orderid is null;

-- 5 Show total revenue per product (Price × Quantity).
select p.productname,sum(p.price*o.quantity) as totalquantity 
from orders o 
join products p on p.productid=o.productid 
group by productname 
order by totalquantity desc;

-- 6 Find products that have never been ordered.
select p.Productname 
from products p 
left join orders o on p.productid=o.productid
where o.productid is null;

-- 7 List orders placed in the last 90 days with customer and product details.
select p.productname,c.customername,o.orderid,o.orderdate,o.quantity 
from orders o join customers c on o.customerid=c.customerid 
join products p on p.productid=o.productid 
where o.orderdate>=date_sub(curdate(),interval 90 day);

-- 8 Find the most frequently ordered product.
select p.productname,count(p.productid)as abs 
from products p 
join orders o on p.productid=o.productid 
group by p.productid 
order by abs desc limit 1  ;

-- 9 Show customers who ordered more than 3 different products.
select c.customername,count(distinct o.productid)as productcount 
from customers c join orders o on c.customerid=o.customerid
 group by customername having count(distinct o.productid)>3 
 order by productcount desc;

-- 10 List cities with total number of orders placed.
select c.city, sum(o.orderid) as totalorders 
from customers c 
join orders o on c.customerid=o.customerid 
group by c.city order by totalorders desc ; 

-- 11 Find customers who ordered products priced above 50.
select distinct c.customername 
from customers c join orders o on c.customerid=o.customerid 
join products p on p.productid=o.productid 
where p.price>50 group by customername;

-- 12 Show products ordered by customers from "Chicago".
select p.productname 
from products p 
join orders o on o.productid=p.productid 
join customers c on c.customerid=o.customerid 
where  c.city="chicago";

-- 13 List customers who ordered the same product more than once.
select c.customername,p.productname,count(*) as orders 
from orders o join products p on p.productid=o.productid 
join customers c on o.customerid=c.customerid 
group by customername,productname 
having count(*)>1;

-- 14 Find the top 3 customers by total spending.
select c.customername,sum(p.price*o.quantity) as totalspending
from customers c join orders o on c.customerid=o.customerid 
join products p  on p.productid=o.productid 
group by customername
order by totalspending 
desc limit 3;

-- 15 Show the latest order date for each customer.
select c.customername,max(o.orderdate)as latestorder 
from orders o 
join customers c 
on c.customerid=o.customerid 
group by customername ;

-- 16 List products ordered by more than 5 different customers.
select p.productname , count(distinct o.customerid) as customerid 
from orders o 
join products p on p.productid=o.productid 
group by productname 
having count(distinct o.customerid)>5;

-- 17 Show average quantity ordered per product.
select avg(o.quantity) as avgquantity,p.productname from orders o join products p on p.productid=o.productid group by productname;

-- 18 Find customers who ordered both "Product_1" and "Product_25".
SELECT c.CustomerID, c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Products p ON p.ProductID = o.ProductID
WHERE p.ProductName IN ('Product_1', 'Product_25')
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(DISTINCT p.ProductName) = 2;
  
  -- 19 List all orders with product price and total cost.
  select o.orderid,p.productname,p.price ,sum(p.price*o.quantity) as totalcost 
  from orders o 
  join products p 
  on o.productid=p.productid 
  group by productname,orderid,price;
  
  -- 20 Show customers who ordered products from multiple cities (if product location is added later).
SELECT c.CustomerID, c.CustomerName, COUNT(DISTINCT p.ProductCity) AS CitiesOrdered
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(DISTINCT p.ProductCity) > 1;

-- 21 Find customers who placed the highest quantity order.
select customername from customers 
where customerid 
in(select customerid from orders 
where quantity=(select max(quantity) from orders));

-- 21 List products with price above the average product price.
select productname,price from products where price>(select avg(price) from products);

-- 22 Find the most expensive product ordered.
select productname,price from products where price=(select max(price) from products where productid in(select productid from orders));

-- 23 List customers who ordered the cheapest product.
SELECT CustomerID, CustomerName FROM Customers WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE ProductID = (
        SELECT ProductID 
        FROM Products
        WHERE Price = (SELECT MIN(Price) FROM Products)
    )
);

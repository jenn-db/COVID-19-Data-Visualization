/* List all the products in the Northwinds database showing productid, productname,
quantity per unit, unitprice, and unitsinstock */
SELECT Productid, productid, productname, quantityperunit, unitprice, unitsinstock
FROM "alanparadise/nw". "products";

/* For all employees at Northwinds, list the first name and last name concatenated together with a blank space in-between, and the YEAR when they were hired.*/
SELECT CONCAT(firstname, ' ', lastname) as Name, date_part('year',hiredate)
FROM "alanparadise/nw". "employees";

/* For all products in the Northwinds database, list the productname,
unitprice, unitsinstock,  and the total value of the inventory of that product  as “Total Value”.  (HINT:  total value = unitsinstock * unitprice.)*/

SELECT productname, unitprice, unitsinstock, unitsinstock * unitprice AS "total value"
FROM "alanparadise/nw". "products";

/* For all employees at Northwinds, list the first name and last name concatenated together with a blank space in-between with a column header “Name”, and the name of the month (spelled out) for each employee’s birthday.*/
SELECT firstname ||' '|| lastname as "Name", to_char(birthdate, 'month')
FROM "alanparadise/nw". "employees";

/* List the customerid, companyname,
and country for all customers NOT in the U.S.A.*/
SELECT customerid, companyname, country
FROM "alanparadise/nw"."customers"
WHERE NOT country = 'U.S.A';

/* For all products in the Northwinds database,
list the productname, unitprice, unitsinstock, and the total value
of the inventory of that product as “Total Value” for all products
with a Total Value greater than $1000. (HINT: total value = unitsinstock * unitprice) */
SELECT productname, unitprice, unitsinstock, unitsinstock * unitprice AS "Total Value"
FROM "alanparadise/nw"."products"
WHERE (unitprice * unitsinstock) > 1000;

/* List the productid, productname, and quantityperunit for all products that come in bottles. */
SELECT productid, productname, quantityperunit
FROM "alanparadise/nw"."products"
WHERE quantityperunit LIKE '%bottles%';

/* List the productid, productname, and unitprice for all products whose
categoryid is an ODD number. (HINT: categoryid is a one digit integer less than 9 …) */
SELECT productid, productname, unitprice
FROM "alanparadise/nw"."products"
where categoryid in (1, 3, 5, 7);

/* List the orderid, customerid, and shippeddate for
orders that shipped to Canada in December 1996 through the end of January 1997.*/

SELECT orderid, customerid, shippeddate
FROM "alanparadise/nw"."orders"
WHERE shipcountry = 'Canada'
AND shippeddate between '1996-12-01' and '1997-01-31';

/* List the employeeid, firstname + lastname concatenated as
‘employee’, and the age of the employee when they were hired.*/

SELECT employeeid, firstname ||' '|| lastname AS "employee",
cast (age(HireDate, BirthDate)as text) AS HIRE_AGE
FROM "alanparadise/nw". "employees";

/* Run a query to calculate your age as of today. */
SELECT CAST(age(current_date, '1998-09-06') as text);

/* List the customerid, companyname and country
for all customers whose region is NULL. */
SELECT customerid, companyname, country
FROM "alanparadise/nw". "customers"
WHERE region is NULL;

/* List the total (unitprice * quantity) as “Total Value”
by orderid for the top 5 orders.  (That is, the five orders with the highest Total Value.)*/
SELECT orderid, SUM(unitprice * quantity) as "Total Value"
FROM "alanparadise/nw". "orderdetails"
GROUP BY orderid
ORDER BY SUM(unitprice * quantity) DESC LIMIT 5;

/* How many products does Northwinds have in inventory?*/
SELECT count(productid)
FROM "alanparadise/nw"."products"
Where unitsinstock > 0;

/* How many products are out of stock?*/
SELECT count(productid)
FROM "alanparadise/nw"."products"
Where unitsinstock = 0;

/*From which supplier(s) does Northwinds carry the fewest products?*/
SELECT supplierid, SUM(unitsinstock)
FROM "alanparadise/nw"."products"
GROUP BY supplierid
ORDER BY 2 LIMIT 5;

/* Which Northwinds employees (just show their employeeid) had over 100 orders ?*/
SELECT employeeid, COUNT(orderid)
FROM "alanparadise/nw". "orders"
GROUP BY employeeid
HAVING COUNT(orderid)>100;

/* List the productid, productname, unitprice of the lowest priced product Northwinds sells.*/
SELECT productid, productname, unitprice
From "alanparadise/nw". "products"
WHERE unitprice = (
SELECT MIN(unitprice)
FROM "alanparadise/nw". "products");

/*How many orders in the orders table have a
bad customerID (either missing or not on file in the customers table.)*/
SELECT count(orderid)
FROM "alanparadise/nw"."orders"
WHERE customerid NOT IN (
SELECT customerID FROM "alanparadise/nw"."customers");

/*List each order and its Total Value (unitprice * quantity) for all orders
shipping into France in descending Total Value order.*/
SELECT O.orderid, SUM(unitprice * quantity) AS "Total value"
From "alanparadise/nw"."orders" O
JOIN "alanparadise/nw"."orderdetails" D
ON O.orderid = D.orderid
WHERE Shipcountry = 'France'
GROUP BY O.orderid;

/*Create a Suppliers List showing Supplier CompanyName,
and names of all the products sold by each supplier located in Japan.*/
SELECT companyname, productname
From "alanparadise/nw"."suppliers" S
JOIN "alanparadise/nw"."products" P
on S.supplierid = P.supplierid
WHERE country = 'Japan';

/*Create a “Low Performers” list showing the employees who have less
than $100,000 in total sales.  List the employee’s LastName,
FirstName followed by their total sales volume (the total dollar value of their orders.)*/
SELECT LastName, Firstname, sum(unitprice * quantity) as "Total Sales"
from "alanparadise/nw"."employees" E
JOIN
"alanparadise/nw"."orders" O
ON E.employeeid  =  O.employeeid
JOIN
"alanparadise/nw"."orderdetails" D
ON O.orderid  =  D.orderid
GROUP BY LastName, FirstName
HAVING  sum(unitprice * quantity) < 100000;

-- Are there any Northwinds employees that have no orders?
SELECT lastname, firstname, COUNT(orderid)
FROM "alanparadise/nw". "employees" E LEFT OUTER JOIN
"alanparadise/nw". "orders" O
ON o.employeeid = e.employeeid
GROUP by lastname, firstname;


-- Are there any Northwinds customers that have no orders?
SELECT C.customerid, companyname, count(orderid)
FROM "alanparadise/nw"."customers" C LEFT OUTER JOIN
"alanparadise/nw"."orders" O ON
C.customerid = O.customerid
GROUP BY C.customerid, companyname
HAVING count(orderid) = 0;

-- Are there any Northwinds orders that have bad (not on file) customer numbers?
SELECT DISTINCT O.customerid, count(orderid)
FROM "alanparadise/nw"."orders" O LEFT OUTER JOIN
"alanparadise/nw"."customers" C on
C.customerid = O.customerid
WHERE C.customerid is NULL
GROUP BY O.customerid;

-- Are there any Shippers that have shipped no Northwinds orders?
SELECT S.shipperid, companyname, count(orderid)
FROM "alanparadise/nw"."shippers" S LEFT OUTER JOIN
"alanparadise/nw"."orders" O ON
S.shipperid = O.shipvia
GROUP BY S.shipperid, companyname;

DROP VIEW "your_bit.io_account/demo_repo"."TopCustomers"
create view "your_bit.io_account/demo_repo"."TopCustomers" as 
SELECT companyname, sum(unitprice * quantity) as "Total Sales",
  CASE  
        WHEN sum(unitprice * quantity) < 60000 THEN 'NeedsFocus'
      WHEN sum(unitprice * quantity) < 110000 THEN 'Average'
        ELSE 'Outstanding'
  END  Assessment
  
  FROM "alanparadise/nw"."customers" C JOIN
    "alanparadise/nw"."orders" O ON C.customerid  =  O.customerid JOIN 
          "alanparadise/nw"."orderdetails" D ON O.orderid  =  D.orderid
GROUP BY companyname 
Order By 2 desc LIMIT 5;

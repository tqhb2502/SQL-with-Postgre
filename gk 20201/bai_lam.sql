-- 1.
select p.*
from products as p join categories as c using(category)
where categoryname = 'Comedy'
	and price < 10
	and title like '%AIRPORT%';
	
-- 2.
select *
from customers
where gender = 'F'
	and income >= 50000;
	
-- 3.
select p.title, p.actor, p.price, sum(ol.quantity)
from products as p left join orderlines as ol using(prod_id)
where date_part('year', ol.orderdate) = 2004
	and date_part('month', ol.orderdate) > 9
group by p.prod_id;

-- 4.
select firstname, lastname, phone, creditcardexpiration
from customers
where creditcardexpiration like date_part('year', current_date)||'%';

-- 5.
select *
from orders
where orderdate = current_date;

-- 6.
select c.*
from categories as c left join products as p using(category)
where prod_id not in (select prod_id
					from orderlines
					where date_part('year', orderdate) = 2011
						and date_part('month', orderdate) = 11);
-- 7.
select c.customerid, c.firstname, c.lastname, c.address1, c.address2, count(o.orderid)
from customers as c join orders as o using(customerid)
group by c.customerid
having count(o.orderid) >= 5
order by count(o.orderid) desc
limit 10;

--
select * from customers;
select * from orders;
select * from orderlines;
select * from categories;
select * from products;
select * from inventory;
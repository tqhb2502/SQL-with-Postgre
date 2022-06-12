-- 3.Đưa ra danh sách loại sản phẩm mà không có mặt hàng nào được đặt mua.
select *
from categories
where category not in (select distinct p.category
					from orderlines as ol join products as p on ol.prod_id = p.prod_id);
--
drop index idx_products_prod_id;
create index idx_products_prod_id on products (prod_id);

drop index idx_orderlines_prod_id;
create index idx_orderlines_prod_id on orderlines (prod_id);

-- 8.Đưa ra danh sách các khách hàng (mã khách hàng, họ và tên) đã mua cả hai sản phẩm có title "AIRPORT ROBBERS"
-- và "AGENT ORDER" (không phân biệt chữ hoa, chữ thường).
	select c.customerid, c.firstname, c.lastname
	from orders as o join customers as c on o.customerid = c.customerid
		join orderlines as ol on o.orderid = ol.orderid
		join products as p on ol.prod_id = p.prod_id
	where upper(p.title) = upper('AIRPORT ROBBERS')
intersect
	select c.customerid, c.firstname, c.lastname
	from orders as o join customers as c on o.customerid = c.customerid
		join orderlines as ol on o.orderid = ol.orderid
		join products as p on ol.prod_id = p.prod_id
	where upper(p.title) = upper('AGENT ORDER');

-- 9.Đưa ra thông tin chi tiết về sản phẩm trong hóa đơn có mã số 942.
-- Thông tin chi tiết: orderlineid, prod_id, product title, quantiy, price, amount.
select ol.orderlineid, p.prod_id, p.title, ol.quantity, p.price, o.netamount, o.totalamount
from orders as o join orderlines as ol on o.orderid = ol.orderid
	join products as p on ol.prod_id = p.prod_id
where o.orderid = 942;

-- 11.Đưa ra thống kê theo giới tính về số lượt khách hàng mua cho mỗi loại sản phẩm (category).
-- Sắp xếp giảm dần theo số lượt mua của loại sản phẩm.
-- C1:
select male_tmp.category, male_tmp.categoryname, number_of_male, number_of_female
from
		(select c.category, c.categoryname, count(cus.customerid) as number_of_male
		from products p join orderlines ol on p.prod_id = ol.prod_id
			join orders o on ol.orderid = o.orderid
			join customers cus on o.customerid = cus.customerid
			right join categories c on p.category = c.category
		where gender = 'M'
		group by c.category) as male_tmp
	join
		(select c.category, c.categoryname, count(cus.customerid) as number_of_female
		from products p join orderlines ol on p.prod_id = ol.prod_id
			join orders o on ol.orderid = o.orderid
			join customers cus on o.customerid = cus.customerid
			right join categories c on p.category = c.category
		where gender = 'F'
		group by c.category) as female_tmp
	using (category)
order by number_of_male + number_of_female desc;
-- C2:
select c.category, c.categoryname,
	count(cus.customerid) filter (where gender = 'M') as number_of_male,
	count(cus.customerid) filter (where gender = 'F') as number_of_female
from products p join orderlines ol on p.prod_id = ol.prod_id
	join orders o on ol.orderid = o.orderid
	join customers cus on o.customerid = cus.customerid
	right join categories c on p.category = c.category
group by c.category;

-- 15. Đưa ra danh sách sản phẩm (prod_id, title, số lượng đã bán) bán chạy nhất (sản phẩm được bán
-- với số lượng lớn nhất) trong tháng 12/2004.
-- C1:
select p.prod_id, p.title, sum(ol.quantity) as sales_quantity
from orderlines as ol join products as p on ol.prod_id = p.prod_id
where date_part('year', ol.orderdate) = 2004
	and date_part('month', ol.orderdate) = 12
group by p.prod_id
having sum(ol.quantity) = (select sum(quantity)
							from orderlines
							where date_part('year', orderdate) = 2004
								and date_part('month', orderdate) = 12
							group by prod_id
							order by sum(quantity) desc
							limit 1);
-- C1 nhưng dùng đc index ở trường orderdate							
select p.prod_id, p.title, sum(ol.quantity) as sales_quantity
from orderlines as ol join products as p on ol.prod_id = p.prod_id
where ol.orderdate >= '2004-12-01' and ol.orderdate <= '2004-12-31'
group by p.prod_id
having sum(ol.quantity) = (select sum(quantity)
							from orderlines
							where orderdate >= '2004-12-01' and orderdate <= '2004-12-31'
							group by prod_id
							order by sum(quantity) desc
							limit 1);

create index idx_orderlines_orderdate on orderlines (orderdate);

-- C2: dùng mệnh đề with

--
select current_date;
select * from customers;
select * from orders;
select * from orderlines;
select * from categories;
select * from products;
select * from inventory;
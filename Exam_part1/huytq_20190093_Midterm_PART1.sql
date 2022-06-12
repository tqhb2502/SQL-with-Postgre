-- 1.Đưa ra danh sách các sản phẩm (prod_id, title) thuộc loại (category) "Documentary".
select p.prod_id, p.title
from products as p join categories as c using(category)
where categoryname = 'Documentary';

-- 2.Đưa ra danh sách các sản phẩm mà tiêu đề (title) có chứa "Apollo" (không quan trọng chữ hoa, chữ thường)
-- và có giá ít hơn 10$.
select *
from products
where upper(title) like upper('%Apollo%')
	and price < 10;
	
-- 3.Đưa ra danh sách loại sản phẩm mà không có mặt hàng nào được đặt mua.
select *
from categories
where category not in (select distinct p.category
					from orderlines as ol join products as p on ol.prod_id = p.prod_id);
						
-- 4.Đưa ra danh sách tên các nước có khách hàng đã đặt hàng. Sắp xếp theo thứ tự alphabet.
select distinct c.country
from orders as o join customers as c using(customerid)
order by c.country;

-- 5.Cho biết có bao nhiêu khách hàng từ "Germany"?
select count(customerid)
from customers
where country = 'Germany';

-- 6.Hãy cho biết có bao nhiêu khách hàng khác nhau đã từng mua ít nhất 1 sản phẩm.
select count(distinct customerid)
from orders;

-- 7.Đưa ra danh sách tên nước, số lượng khách hàng và số lượt khách hàng đã mua hàng đến từ mỗi nước.
select c.country, count(distinct c.customerid) as number_of_customers, count(o.orderid) as number_of_orders
from customers as c left join orders as o using(customerid)
group by c.country;
-- ! số lượng khách hàng CẢ MUA CẢ KHÔNG MUA, số lượt khách hàng ĐÃ MUA.

select c.country, count(distinct c.customerid) as number_of_customers, count(o.orderid) as number_of_orders
from customers as c join orders as o using(customerid)
group by c.country;
-- ! số lượng khách hàng ĐÃ MUA, số lượt khách hàng ĐÃ MUA.

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

-- 10.Hiển thị ra tổng tiền (totalamount) lớn nhất, nhỏ nhất, và trung bình trên hóa đơn.
select max(totalamount), min(totalamount), avg(totalamount)
from orders;

-- 11.Đưa ra thống kê theo giới tính về số lượt khách hàng mua cho mỗi loại sản phẩm (category).
-- Sắp xếp giảm dần theo số lượt mua của loại sản phẩm.
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

-- 12.Đưa ra danh sách khách hàng đã có tổng hóa đơn mua hàng vượt quá 2.000.
select c.*
from customers as c join orders as o using(customerid)
group by c.customerid
having sum(o.totalamount) > 2000;

-- 13.Lập danh sách các sản phẩm đã được mua trong ngày (orderdate) (ngày lập danh sách).
select p.*
from orderlines as ol join products as p using(prod_id)
where ol.orderdate = current_date;
	
-- 14.Đưa ra danh sách tên các mặt hàng và số lượng tồn của các mặt hàng không có người mua trong tháng 12/2004.
select p.title, i.quan_in_stock
from products as p join inventory as i using(prod_id)
where p.prod_id not in (select distinct prod_id
					from orderlines
					where date_part('year', orderdate) = 2004
						and date_part('month', orderdate) = 12);

-- 15. Đưa ra danh sách sản phẩm (prod_id, title, số lượng đã bán) bán chạy nhất (sản phẩm được bán
-- với số lượng lớn nhất) trong tháng 12/2004.
select p.prod_id, p.title, sum(ol.quantity) as sales_quantity
from orders as o join orderlines as ol on o.orderid = ol.orderid
	join products as p on ol.prod_id = p.prod_id
where date_part('year', o.orderdate) = 2004
	and date_part('month', o.orderdate) = 12
group by p.prod_id
having sum(ol.quantity) = (select sum(ol.quantity)
							from orders as o join orderlines as ol using(orderid)
							where date_part('year', o.orderdate) = 2004
								and date_part('month', o.orderdate) = 12
							group by ol.prod_id
							order by sum(ol.quantity) desc
							limit 1);

-- 16. Hãy tạo ra 1 view chưa thông tin khách hàng thường xuyên của cửa hàng: thông tin gồm mã số
-- khách hàng, họ tên, địa chỉ, thu nhập (income), giới tính (gender). Khách hàng thường xuyên là
-- khách hàng có số lần mua nhiều hơn 2 lần và lần mua gần nhất là trong năm hiện tại.
create or replace view loyal_customers as
		select c.customerid, c.firstname, c.lastname, c.address1, c.address2, c.income, c.gender
		from customers as c join orders as o using(customerid)
		group by c.customerid
		having count(o.orderid) > 2
	intersect
		select c.customerid, c.firstname, c.lastname, c.address1, c.address2, c.income, c.gender
		from customers as c join orders as o using(customerid)
		where date_part('year', orderdate) = date_part('year', current_date);

select * from loyal_customers;

--
select current_date;
select * from customers;
select * from orders;
select * from orderlines;
select * from categories;
select * from products;
select * from inventory;
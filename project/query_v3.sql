-- 1. 8 đầu sách được mượn nhiều nhất trong tháng.
select t.title_id, t.name, count(br.borrow_id) as number_of_borrow_times
from title as t
	join book as b on t.title_id = b.title_id
	join borrow as br on b.book_id = br.book_id
where br.note in ('B', 'R')
	and date_part('month', borrow_date) = date_part('month', current_date)
group by t.title_id
order by count(br.borrow_id) desc
limit 8;

-- 2. 8 đầu sách mới nhất.
select title_id, name, publish_date
from title
order by publish_date desc
limit 8;

-- 3. 8 tác giả có nhiều đầu sách nhất.
select a.*, count(t.title_id) as number_of_title
from author as a join title as t using(author_id)
group by a.author_id
order by count(t.title_id) desc
limit 8;

-- 4. Đưa ra các đầu sách mà tên có chứa "toán" (không phân biệt chữ hoa chữ thường) và
-- thuộc thể loại "Đại cương" (không phân biệt chữ hoa chữ thường).
select t.title_id, t.name
from title as t join type as ty using(type_id)
where upper(t.name) like upper('%toán%')
	and upper(ty.name) = upper('Đại cương');

-- 5. Đưa ra các đầu sách được xuất bản trong 10 năm trở lại đây của các PGS.TS.
select t.title_id, t.name, t.publish_date, a.last_name||' '||a.first_name as author_name
from title as t join author as a using(author_id)
where (case when publish_date = '' then 0 else publish_date::integer end) >= date_part('year', current_date) - 10
	and upper(last_name) like '%PGS.TS%';

-- 6. Đưa ra các đầu sách có tổng số lượng ít nhất 20 quyển và đang không được ai mượn.
-- Cách 1:
	select title_id, name
	from title
	where quantity >= 20
except
	select distinct t.title_id, t.name
	from title as t
		join book as b on t.title_id = b.title_id
		join borrow as br on b.book_id = br.book_id
	where br.note = 'B';
-- Cách 2:
select title_id, name
from title
where quantity >= 20
	and quantity = quan_in_lib;

-- 7. Đưa ra danh sách địa chỉ của các người dùng đang mượn sách.
select u.user_id, u.first_name, u.last_name, u.address
from users as u join borrow as br using(user_id)
where br.note = 'B';

-- 8. Đưa ra số lượng người dùng trên 18 tuổi theo giới tính.
select count(user_id) filter (where gender = 'M') as male,
		count(user_id) filter (where gender = 'F') as female
from users
where date_part('year', age(dob)) >= 18;

-- 9. 10 người dùng có số lượt mượn nhiều nhất. (sắp xếp từ cao đến thấp)
select u.user_id, u.first_name, u.last_name, count(br.borrow_id) as number_of_borrow_times
from users as u join borrow as br using(user_id)
where br.note in ('B', 'R')
group by u.user_id
order by count(br.borrow_id) desc
limit 10;

-- 10. Đưa ra danh sách người dùng đã mượn sách trong tháng hiện tại.
select u.*
from users as u join borrow as br using(user_id)
where br.note in ('B', 'R')
	and date_part('month', borrow_date) = date_part('month', current_date);

-- 11. Đưa ra danh sách người dùng chưa trả sách. (giống câu 7 -> loại)
-- 11. Đưa ra các yêu cầu mượn sách đang chờ phê duyệt
select u.user_id, u.first_name, u.last_name, t.title_id, t.name, b.book_id
from borrow as br
	join users as u on br.user_id = u.user_id
	join book as b on br.book_id = b.book_id
	join title as t on b.title_id = t.title_id
where br.note = 'W';

-- 12. Đưa ra tên và tổng số lượt mượn của mỗi thể loại. (sắp xếp từ cao đến thấp)
select ty.*, count(br.borrow_id) filter (where br.note in ('B', 'R')) as number_of_borrow_times
from type as ty
	left join title as t on ty.type_id = t.type_id
	left join book as b on t.title_id = b.title_id
	left join borrow as br on b.book_id = br.book_id
group by ty.type_id
order by count(br.borrow_id) filter (where br.note in ('B', 'R')) desc;

-- 13. 3 ngôn ngữ được dùng để viết sách nhiều nhất.
select l.*, count(t.title_id) as number_of_title
from language as l join title as t using(language_id)
group by l.language_id
order by count(t.title_id) desc
limit 3;

-- 14. Viết hàm nhập vào mã đầu sách, in ra vị trí của đầu sách đó.
create or replace function find_position(in cur_title_id char(8))
returns varchar(600) as
$$
begin
	return (select p.area||' '||p.shelf
			from title as t, position as p
			where t.position_id = p.position_id
				and t.title_id = cur_title_id);
end;
$$
language plpgsql;

drop function find_position;

select find_position('00000014');

-- 15. Viết hàm nhập vào mã NXB, in ra danh sách các đầu sách của NXB đó.
create or replace function publisher_title(in cur_publisher_id char(8))
returns table(like title) as
$$
begin
	return query (select t.*
					from publisher as p join title as t using(publisher_id)
					where p.publisher_id = cur_publisher_id);
end;
$$
language plpgsql;

drop function publisher_title;

select * from publisher_title('00000022');

-- 16. Đưa ra danh sách người dùng đã mượn cả 2 thể loại "Đại cương" và "Thiếu nhi".
select u.*
from users as u
	join borrow as br on u.user_id = br.user_id
	join book as b on br.book_id = b.book_id
	join title as t on b.title_id = t.title_id
	join type as ty on t.type_id = ty.type_id
where br.note in ('B', 'R')
	and (ty.name = 'Đại cương'
		 or ty.name = 'Thiếu nhi')
group by u.user_id
having count(distinct ty.type_id) = 2;

-- 17. Đưa ra danh sách người dùng đã mượn ít nhất 2 thể loại khác nhau (bất kỳ).
select u.*
from users as u
	join borrow as br on u.user_id = br.user_id
	join book as b on br.book_id = b.book_id
	join title as t on b.title_id = t.title_id
	join type as ty on t.type_id = ty.type_id
where br.note in ('B', 'R')
group by u.user_id
having count(distinct ty.type_id) >= 2;

-- 18. Tác giả viết sách sử dụng ít nhất 2 ngôn ngữ khác nhau (bất kỳ).
select a.*
from author as a
	join title as t on a.author_id = t.author_id
	join language as l on t.language_id = l.language_id
group by a.author_id
having count(distinct l.language_id) >= 2;

-- 19. Danh sách người dùng mượn ít nhất 2 quyển khác nhau trong cùng 1 đầu sách bất kỳ.
select distinct u.*
from users as u
	join borrow as br on u.user_id = br.user_id
	join book as b on br.book_id = b.book_id
	join title as t on b.title_id = t.title_id
where br.note in ('B', 'R')
group by u.user_id, t.title_id
having count(distinct b.book_id) >= 2;

-- 20. Danh sách người dùng đã từng mượn sách quá hạn (in ra mã người dùng, tên, số lần mượn sách quá hạn).
select u.user_id, u.first_name, u.last_name, count(br.borrow_id) as times
from users as u join borrow as br using(user_id)
where br.return_date > br.due_date
	or (br.return_date is null
		and current_date > br.due_date)
group by u.user_id;

-- 21. Danh sách người dùng chưa bao giờ sử dụng dịch vụ mượn sách.
select u.*
from users as u left join borrow as br using(user_id)
where br.borrow_id is null;

-- 22. Đưa ra các đầu sách chưa bao giờ được mượn.
select *
from title
where title_id not in (select b.title_id
					   from book as b join borrow as br using(book_id)
					   where br.note in ('B', 'R'));

-- 23. Đưa ra thể loại được mượn nhiều nhất.
select ty.*, count(br.borrow_id) as number_of_borrow_times
from type as ty
	join title as t on ty.type_id = t.type_id
	join book as b on t.title_id = b.title_id
	join borrow as br on b.book_id = br.book_id
where br.note in ('B', 'R')
group by ty.type_id
order by count(br.borrow_id) desc
limit 1;

-- 24. Viết hàm đưa ra thể loại mà mỗi tác giả viết nhiều nhất.
create or replace function fav_type_of_author()
returns table(author_id char(8),
			  author_first_name varchar(255),
			  author_last_name varchar(255),
			  type_id char(8),
			  type_name varchar(255)) as
$$
declare author_record author%rowtype;
begin
	for author_record in (select * from author) loop
		select into author_id, author_first_name, author_last_name, type_id, type_name a.*, ty.*
		from author as a
			join title as t on a.author_id = t.author_id
			join type as ty on t.type_id = ty.type_id
		where a.author_id = author_record.author_id
		group by a.author_id, ty.type_id
		order by count(t.title_id) desc
		limit 1;
		return next;
	end loop;
end;
$$
language plpgsql;

drop function fav_type_of_author;

select * from fav_type_of_author();

-- 25. Danh sách các đầu sách được mượn trong ngày hiện tại.
select t.title_id, t.name
from title as t
	join book as b on t.title_id = b.title_id
	join borrow as br on b.book_id = br.book_id
where br.note in ('B', 'R')
	and date_part('year', borrow_date) = date_part('year', current_date)
	and date_part('month', borrow_date) = date_part('month', current_date)
	and date_part('day', borrow_date) = date_part('day', current_date);

-- 26. Đưa ra thống kê theo độ tuổi về số lượt người dùng mượn cho mỗi loại sách.
-- < 11, 11 - 18, 19 - 40, 41 - 65, > 65
select ty.*,
	count(br.borrow_id) filter (where br.note in ('B', 'R') and date_part('year', age(u.dob)) < 11)
		as nho_hon_11,
	count(br.borrow_id) filter (where br.note in ('B', 'R') and date_part('year', age(u.dob)) between 11 and 18)
		as tu_11_den_18,
	count(br.borrow_id) filter (where br.note in ('B', 'R') and date_part('year', age(u.dob)) between 19 and 40)
		as tu_19_den_40,
	count(br.borrow_id) filter (where br.note in ('B', 'R') and date_part('year', age(u.dob)) between 41 and 65)
		as tu_41_den_65,
	count(br.borrow_id) filter (where br.note in ('B', 'R') and date_part('year', age(u.dob)) > 65)
		as lon_hon_65
from type as ty
	left join title as t on ty.type_id = t.type_id
	left join book as b on t.title_id = b.title_id
	left join borrow as br on b.book_id = br.book_id
	left join users as u on br.user_id = u.user_id
group by ty.type_id;

-- 27. Có bao nhiêu người dùng có địa chỉ ở Hà Nội.
select *
from users
where upper(address) like upper('%Hà Nội%');

-- 28. Đưa ra các đầu sách thuộc loại "Đại cương" và hiện đang có ít hơn 20 quyển trong thư viện.
select t.title_id, t.name, t.quan_in_lib
from title as t join type as ty using(type_id)
where ty.name = 'Đại cương'
	and t.quan_in_lib < 20;

-- 29. Đưa ra các đầu sách chưa được mượn trong tháng hiện tại.
	select title_id, name
	from title
except
	select t.title_id, t.name
	from title as t
		join book as b on t.title_id = b.title_id
		join borrow as br on b.book_id = br.book_id
	where br.note in ('B', 'R')
		and date_part('month', borrow_date) = date_part('month', current_date);

-- 30. Đưa ra danh sách thủ thư.
select *
from users
where role = 'thuthu';

--
select * from author;
select * from book;
select * from borrow;
select * from language;
select * from news;
select * from position;
select * from publisher;
select * from title;
select * from type;
select * from users;
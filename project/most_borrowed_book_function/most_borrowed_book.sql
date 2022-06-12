-- 6 đầu sách được mượn nhiều nhất trong tháng
-- drop function most_borrowed_book;
create or replace function most_borrowed_book()
returns table(title_id char(8), name varchar(30), quantity integer, publish_date date, summary text,
			  author_id char(8), publisher_id char(8), language_id char(8), position_id char(8),
			  type_id char(8), quan_in_lib integer, url varchar, number_of_borrow_time integer) as
$$
begin
	return query (select t.*, count(br.borrow_id)::integer as number_of_borrow_time
				from borrow as br join book as b on br.book_id = b.book_id
					join title as t on b.title_id = t.title_id
				where date_part('year', borrow_date) = date_part('year', current_date)
				  	and date_part('month', borrow_date) = date_part('month', current_date)
				group by t.title_id
				order by count(br.borrow_id) desc
				limit 6);
end;
$$
language plpgsql;
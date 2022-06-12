-- create borrow_infos view
create or replace view borrow_infos as
	select u.user_id, u.first_name||' '||u.last_name as user_name,
			t.title_id, t.name as title_name, b.book_id,
			br.borrow_date, br.return_date,
			t.quan_in_lib
	from borrow as br join book as b on br.book_id = b.book_id
		join title as t on b.title_id = t.title_id
		join users as u on u.user_id = br.user_id;
		
-- select * from users;
-- select * from borrow;
-- select * from book;
-- select * from title;

-- select * from borrow_infos;
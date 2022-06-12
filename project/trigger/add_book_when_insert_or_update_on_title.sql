-- function add_book: thêm sách vào bảng book theo trường quantity của bảng title
-- drop function add_book;
create or replace function add_book()
returns trigger as
$$
declare number_of_book integer;
		cur_quantity integer;
		next_book_id char(8);
begin
	number_of_book := (select count(book_id)
						from book
						where title_id = new.title_id);
	cur_quantity := (select quantity
					from title
					where title_id = new.title_id);
	while number_of_book < cur_quantity loop
		next_book_id := (select book_id
						from book
						order by book_id desc
						limit 1);
		next_book_id := next_id(next_book_id);
		insert into book values (next_book_id, null, new.title_id);
		number_of_book := number_of_book + 1;
	end loop;
	
	return new;
end;
$$
language plpgsql;

-- trigger tự động thêm sách vào bảng book sau khi insert đầu sách mới vào bảng title
-- drop trigger tg_add_book_when_insert_into_title on title;
create trigger tg_add_book_when_insert_into_title
after insert on title
for each row
when (new.quantity > 0)
execute procedure add_book();

-- trigger tự động thêm sách vào bảng book sau khi update đầu sách trong bảng title
create trigger tg_add_book_when_update_title
after update on title
for each row
when (new.quantity > old.quantity)
execute procedure add_book();
-- test trigger for insert
insert into title_infos (title_name, quantity, publish_date, summary, quan_in_lib, url, author_first_name,
						author_last_name, publisher_name, publisher_address, language_name, area, shelf,
						type_name)
			values ('sach cua Huy', 20, '2022-01-09', null, 10, null, 'Quang Huy', 'Tran', 'Huy Publisher',
				   'Viet Tri, Phu Tho', 'Tieng Viet', '00000001', '00000003', 'vui ve');

insert into title_infos (title_name, quantity, publish_date, summary, quan_in_lib, url, author_id, publisher_id,
						language_name, area, shelf, type_name)
			values ('sach cua Huy 2', 20, '2022-01-09', null, 10, null, '00000000', '00000000',
					'Tieng Nhat', '00000001', '00000003', 'hi hi');

-- test trigger for delete
delete from title_infos
where title_id = '00000000';

delete from title_infos
where title_id = '00000001';

-- test trigger for update
update title_infos
set title_name = 'sach cua Huy 10', quantity = 30, quan_in_lib = 20, url = 'abc.com',
	language_id = null, language_name = 'Tieng Anh', position_id = '00000000',
	type_id = '00000000'
where title_id = '00000001';

update title_infos
set type_id = '00000001', type_name = 'haha'
where title_id = '00000001';

update title_infos
set language_id = '00000000'
where title_id = '00000001';

update title_infos
set author_id = null, author_first_name = 'Tuan Minh', author_last_name = 'Tran'
where title_id = '00000001';

--
select * from title_infos;

select * from book;

select * from author;
select * from publisher;
select * from language;
select * from position;
select * from type;
select * from title;
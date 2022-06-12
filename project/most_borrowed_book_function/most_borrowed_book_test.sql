select * from most_borrowed_book();

select * from title;
select * from book;
select * from users;
select * from borrow;

insert into users values ('00000000', 'Quang Huy', 'Tran', '2001-02-25', 'M', 'Phu Tho', '0123456789',
						  'tqh@email.com', 'abc', 'S');
						  
insert into borrow values ('00000000', '00000000', '2020-01-01', null, null, null, '00000000');
insert into borrow values ('00000020', '00000000', '2020-01-01', null, null, null, '00000001');
insert into borrow values ('00000021', '00000000', '2020-01-01', null, null, null, '00000002');

insert into borrow values ('00000001', '00000000', '2022-01-10', null, null, null, '00000003');
insert into borrow values ('00000002', '00000000', '2022-01-10', null, null, null, '00000004');
insert into borrow values ('00000003', '00000000', '2022-01-10', null, null, null, '00000005');
insert into borrow values ('00000022', '00000000', '2020-01-11', null, null, null, '00000006');
insert into borrow values ('00000023', '00000000', '2020-01-11', null, null, null, '00000007');

update borrow set borrow_date = '2022-01-11' where borrow_id = '00000006' or borrow_id = '00000007';

insert into borrow values ('00000024', '00000000', '2020-01-11', null, null, null, '00000008');
insert into borrow values ('00000025', '00000000', '2020-01-11', null, null, null, '00000009');

update borrow set borrow_date = '2022-01-11' where borrow_id = '00000008' or borrow_id = '00000009';
-- 3. Create a view from eduDB, named class_infos, this view contains:
-- class_id, class name, number of students in this class.

create view class_infos as
	select c.clazz_id, c.name, count(s.student_id) as number_of_students
	from clazz as c left join student as s using(clazz_id)
	group by c.clazz_id;

-- 3.1. Display all records from this view.
select * from class_infos;

-- 3.2. Try to insert/update/delete a record into/from class_infos
insert into class_infos values ('20200001', 'CSDL', 0);
update class_infos set name = 'Thuc hanh CSDL' where clazz_id = '20170000';
delete from class_infos where clazz_id = '20170000';
delete from class_infos where name = 'CNTT1.02-K61';
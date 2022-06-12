select * from student;
select * from clazz;

-- 1. Create a view from eduDB, named student_shortinfos, this view
-- contains some information from student table: student_id, firstname,
-- lastname, gender, dob, clazz_id

create view student_shortinfos as
	select student_id, first_name, last_name, gender, dob, clazz_id
	from student;

-- 1.1. Display all records from this view

select * from student_shortinfos;

-- 1.2. Try to insert/update/delete a record from student_shortinfos
-- ➔ Check if this record is inserted/updated/deleted from student table

insert into student_shortinfos values ('20200000', 'Tuan Minh', 'Tran', 'M', '2001/11/13', '20170000');
update student_shortinfos set last_name = 'Tran' where student_id = '20190011';
delete from student_shortinfos where student_id = '20190011';

-- 1.3. Suppose you do not have permission to access student table, but you can
-- access to student_shortinfos view and clazz table, write SQL statements to display

-- a. A list of students: student id, fullname, gender and class name.

select student_id, last_name||' '||first_name as full_name, gender, c.name
from student_shortinfos as ss left join clazz as c on ss.clazz_id = c.clazz_id;

-- b. A list of class (class id, class name) and the number of students in each class.

select c.clazz_id, c.name, count(ss.student_id) as number_of_students
from clazz as c left join student_shortinfos as ss on c.clazz_id = ss.clazz_id
group by c.clazz_id;

-- 1.4. Set address attribute of student table to NOT NULL ➔ then try insert a new
-- record into student_shortinfos view: check if the record is insert into student table

update student set address = '' where address is null;

alter table student
	alter column address
		set not null;

alter table student
	alter column address
		drop not null;

alter table student alter column address set default '';

insert into student_shortinfos values ('20200002', 'Van B', 'Nguyen', 'M', '2001-12-21', '20170000');

-- 1.5. Please change dob of a student and check if this infos is also updated in
-- student_shortinfos view.

update student set dob = '1999-02-25' where student_id = '20190093';

-- 1.6. Please insert a new record into student table and then check whether you can
-- see the new student on student_shortinfos view ?

insert into student (student_id, first_name, last_name, dob, gender, address, clazz_id)
	values ('20200001', 'Thi A', 'Nguyen', '2001-12-12', 'F', 'Ha Noi', '20170000');
-- If data on student table is changed, the number of students in
-- clazz table is always correct.
-- (delete a student, change student class)

-- trigger function for tg_number_students_af_insert_student
create or replace function tf_number_students_af_insert_student() returns trigger as
$$
begin
	update clazz set number_students = number_students + 1
	where clazz_id = new.clazz_id;
	
	raise notice 'old value: %', old;
	raise notice 'new value: %', new;
	
	return null;
end;
$$
language plpgsql;

-- trigger for insert student
create trigger tg_number_students_af_insert_student
after insert on student
for each row
when (new.clazz_id is not null)
execute procedure tf_number_students_af_insert_student();

-- test insert student
delete from student
where student_id = '20211220' or student_id = '20211221';

insert into student(student_id, first_name, last_name, dob, gender, clazz_id)
values ('20211220', 'Quang Vinh', 'Tran', '2000-01-01', 'M', '20162101');

insert into student(student_id, first_name, last_name, dob, gender, clazz_id)
values ('20211221', 'Quang Vinh 1', 'Tran 1', '2000-01-01', 'M', '20170000');

select * from student;
select * from clazz;

-- trigger function for tg_number_students_af_delete_student
create or replace function tf_number_students_af_delete_student() returns trigger as
$$
begin
	update clazz set number_students = number_students - 1
	where clazz_id = old.clazz_id;
	
	raise notice 'old value: %', old;
	raise notice 'new value: %', new;
	
	return null;
end;
$$
language plpgsql;

-- trigger for delete student
create trigger tg_number_students_af_delete_student
after delete on student
for each row
when (old.clazz_id is not null)
execute procedure tf_number_students_af_delete_student();

-- test delete student
delete from student where student_id = '20211220';
delete from student where student_id = '20211221';

select * from clazz;

-- trigger function for tg_number_students_af_update_student
create or replace function tf_number_students_af_update_student() returns trigger as
$$
begin
	update clazz set number_students = number_students + 1
	where clazz_id = new.clazz_id;
	update clazz set number_students = number_students - 1
	where clazz_id = old.clazz_id;
	
	raise notice 'old value: %', old;
	raise notice 'new value: %', new;
	
	return null;
end;
$$
language plpgsql;

-- trigger for update student
create trigger tg_number_students_af_update_student
after update of clazz_id on student
for each row
execute procedure tf_number_students_af_update_student();

-- test update student
update student set clazz_id = '20172201'
where student_id = '20160001';

update student set clazz_id = '20162101'
where student_id = '20160001';

select * from student;
select * from clazz;

-- Assuming that the number of students enrolled in a subject per
-- semester does not exceed 200, write a trigger that guarantees
-- this constraint.
-- (insert, update event on enrolment table)

-- trigger function
drop function tf_check_enrollment;

create or replace function tf_check_enrollment() returns trigger as
$$
declare tmp integer;
begin
	raise notice 'old value: %', old;
	raise notice 'new value: %', new;
	
	tmp := (select count(student_id)
			from enrollment
			where semester = new.semester
				and subject_id = new.subject_id);
				
	if tmp = 7 then
		raise notice 'số lượng sinh viên đăng kí vượt quá giới hạn!';
		return null;
	else
		raise notice 'đăng kí thành công!';
		return new;
	end if;
end;
$$
language plpgsql;

-- trigger
drop trigger tg_check_enrollment on enrollment;

create trigger tg_check_enrollment
before insert or update on enrollment
for each row
execute procedure tf_check_enrollment();

-- test
insert into enrollment(student_id, subject_id, semester)
	values ('20190093', 'IT1110', '20171');
insert into enrollment(student_id, subject_id, semester)
	values ('20200000', 'IT1110', '20171');
insert into enrollment(student_id, subject_id, semester)
	values ('20200001', 'IT1110', '20171');
insert into enrollment(student_id, subject_id, semester)
	values ('20200002', 'IT1110', '20171');
delete from enrollment where student_id = '20190093';
delete from enrollment where student_id = '20200000';
delete from enrollment where student_id = '20200001';

update enrollment
set semester = '20172', subject_id = 'IT3080'
where student_id = '20190093'
	and subject_id = 'IT1110'
	and semester = '20171';
	
update enrollment
set semester = '20172', subject_id = 'IT3080'
where student_id = '20200000'
	and subject_id = 'IT1110'
	and semester = '20171';
	
update enrollment
set semester = '20172', subject_id = 'IT3080'
where student_id = '20200001'
	and subject_id = 'IT1110'
	and semester = '20171';

select * from student;
select * from clazz;
select * from enrollment;
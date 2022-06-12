select * from clazz;
select * from student;

-- 1.
drop function number_of_students;

create function number_of_students(in given_id char(8), out result int) as
$$
	begin
		result := (select count(s.student_id)
		from clazz as c left join student as s using(clazz_id)
		where c.clazz_id = given_id);
	end;
$$
language plpgsql
immutable
returns null on null input
security invoker;

select number_of_students('20162101');

grant execute on function number_of_students to joe;
grant select on table clazz to joe;
grant select on table student to joe;

--
create function number_of_students_2(in given_id char(8)) returns int as
$$
	begin
		return (select count(s.student_id)
		from clazz as c left join student as s using(clazz_id)
		where c.clazz_id = given_id);
	end;
$$
language plpgsql
immutable
returns null on null input
security invoker;

select number_of_students_2('20162102');

-- 2.
alter table clazz
	add column number_students int;
	
create or replace function update_number_students() returns void as
$$
	declare clazz_i clazz%rowtype;
	begin
		for clazz_i in (select * from clazz) loop
			update clazz
				set number_students = number_of_students(clazz_id)
				where clazz_id = clazz_i.clazz_id;
		end loop;
	end;
$$
language plpgsql
security invoker;

select update_number_students();

select * from clazz;

-- 3.
drop table student_results;

create table student_results(
	student_id char(8) not null,
	semester char(5) not null,
	GPA float,
	CPA float,
	constraint student_results_pk primary key (student_id, semester)
);

alter table student_results
	add constraint student_results_2_student_fk foreign key (student_id) references student(student_id);

create or replace function updateGPA_student(in student_id char(8), in semester char(5)) returns void as
$$
begin
	
end;
$$
language plpgsql;

select * from enrollment;
select * from subject;
select * from student;
select * from student_results;
select * from student_shortinfos;

-- trigger function for tg_insteadof_insert_view
create or replace function tf_insert_view() returns trigger as
$$
begin
	insert into student(student_id, first_name, last_name, gender, dob)
		values (new.student_id, new.first_name, new.last_name, new.gender, new.dob);
	return new;
end;
$$
language plpgsql;

-- instead of trigger for view
create trigger tg_insteadof_insert_view
instead of insert on student_shortinfos
for each row
execute procedure tf_insert_view();

-- test
select * from student_shortinfos;
insert into student_shortinfos values ('20210101', 'Van A', 'Nguyen', 'M', '2001-01-01', null);
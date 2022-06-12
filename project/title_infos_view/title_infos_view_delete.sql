-- tf_for_delete_from_title_infos function
create or replace function tf_for_delete_from_title_infos()
returns trigger as
$$
begin
	delete from title
	where title_id = old.title_id;
	
	return old;
end;
$$
language plpgsql;

-- trigger for delete from title_infos
create trigger tg_delete_from_title_infos
instead of delete on title_infos
for each row
execute procedure tf_for_delete_from_title_infos();
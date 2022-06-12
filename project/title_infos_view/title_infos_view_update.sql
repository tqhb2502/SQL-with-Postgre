-- tf_for_update_title_infos function
create or replace function tf_for_update_title_infos()
returns trigger as
$$
declare cur_author_id char(8); cur_publisher_id char(8); cur_language_id char(8);
		cur_position_id char(8); cur_type_id char(8);
begin
	--raise notice 'old: %', old;
	--raise notice 'new: %', new;
	if (new.author_id is null) or (old.author_id != new.author_id) then
		cur_author_id := insert_into_author(new.author_id, new.author_first_name, new.author_last_name);
		
		update title
		set author_id = cur_author_id
		where title_id = new.title_id;
	end if;
	
	if (new.publisher_id is null) or (old.publisher_id != new.publisher_id) then
		cur_publisher_id := insert_into_publisher(new.publisher_id, new.publisher_name, new.publisher_address);
		
		update title
		set publisher_id = cur_publisher_id
		where title_id = new.title_id;
	end if;
	
	if (new.language_id is null) or (old.language_id != new.language_id) then
		cur_language_id := insert_into_language(new.language_id, new.language_name);
		
		update title
		set language_id = cur_language_id
		where title_id = new.title_id;
	end if;
	
	if (new.position_id is null) or (old.position_id != new.position_id) then
		cur_position_id := insert_into_position(new.position_id, new.area, new.shelf);
		
		update title
		set position_id = cur_position_id
		where title_id = new.title_id;
	end if;
	
	if (new.type_id is null) or (old.type_id != new.type_id) then
		cur_type_id := insert_into_type(new.type_id, new.type_name);
		
		update title
		set type_id = cur_type_id
		where title_id = new.title_id;
	end if;
	
	update title
	set name = new.title_name, quantity = new.quantity, publish_date = new.publish_date, summary = new.summary,
		quan_in_lib = new.quan_in_lib, url = new.url
	where title_id = new.title_id;
	
	return new;
end;
$$
language plpgsql;

-- trigger for update title_infos

-- drop trigger tg_update_title_infos on title_infos;

create trigger tg_update_title_infos
instead of update on title_infos
for each row
execute procedure tf_for_update_title_infos();
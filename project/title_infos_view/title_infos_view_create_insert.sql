-- create view
create or replace view title_infos as
	select t.title_id, t.name as title_name, t.quantity, t.publish_date, t.summary, t.quan_in_lib, t.url,
		a.author_id, a.first_name as author_first_name, a.last_name as author_last_name,
		p.publisher_id, p.name as publisher_name, p.address as publisher_address,
		l.language_id, l.name as language_name,
		pos.position_id, pos.area, pos.shelf,
		ty.type_id, ty.name as type_name
	from title as t, author as a, publisher as p, language as l, position as pos, type as ty
	where t.author_id = a.author_id
		and t.publisher_id = p.publisher_id
		and t.language_id = l.language_id
		and t.position_id = pos.position_id
		and t.type_id = ty.type_id;
		
-- drop function next_id;
-- drop function insert_into_author;
-- drop function insert_into_publisher;
-- drop function insert_into_language;
-- drop function insert_into_position;
-- drop function insert_into_type;
-- drop function insert_into_title;

-- next_id function
create or replace function next_id(in cur_id char(8))
returns char(8) as
$$
declare tmp integer; result_id char(8);
begin
	if cur_id is null then
		result_id := cast(0 as char(8));
	else
		tmp := cast(cur_id as integer);
		tmp := tmp + 1;
		result_id := cast(tmp as char(8));
	end if;
	
	while char_length(result_id) < 8 loop
		result_id := '0' || result_id;
	end loop;
	
	return result_id;
end;
$$
language plpgsql;

-- insert_into_author function
create or replace function insert_into_author(in cur_author_id char(8), in cur_first_name varchar(20),
											  in cur_last_name varchar(20))
returns char(8) as
$$
begin
	if cur_author_id is null then
		cur_author_id := (select author_id
						from author
						order by author_id desc
						limit 1);
		cur_author_id := next_id(cur_author_id);
		insert into author values (cur_author_id, cur_first_name, cur_last_name);
	end if;
	
	return cur_author_id;
end;
$$
language plpgsql;

-- insert_into_publisher function
create or replace function insert_into_publisher(in cur_publisher_id char(8), in cur_name varchar(30),
												 in cur_address varchar(30))
returns char(8) as
$$
begin
	if cur_publisher_id is null then
		cur_publisher_id := (select publisher_id
							from publisher
							order by publisher_id desc
							limit 1);
		cur_publisher_id := next_id(cur_publisher_id);
		insert into publisher values (cur_publisher_id, cur_name, cur_address);
	end if;
	
	return cur_publisher_id;
end;
$$
language plpgsql;

-- insert_into_language function
create or replace function insert_into_language(in cur_language_id char(8), in cur_name varchar(30))
returns char(8) as
$$
begin
	if cur_language_id is null then
		cur_language_id := (select language_id
							from language
							order by language_id desc
							limit 1);
		cur_language_id := next_id(cur_language_id);
		insert into language values (cur_language_id, cur_name);
	end if;
	
	return cur_language_id;
end;
$$
language plpgsql;

-- insert_into_position function
create or replace function insert_into_position(in cur_position_id char(8), in cur_area char(8),
												in cur_shelf char(8))
returns char(8) as
$$
begin
	if cur_position_id is null then
		cur_position_id := (select position_id
							from position
							order by position_id desc
							limit 1);
		cur_position_id := next_id(cur_position_id);
		insert into position values (cur_position_id, cur_area, cur_shelf);
	end if;
	
	return cur_position_id;
end;
$$
language plpgsql;

-- insert_into_type function
create or replace function insert_into_type(in cur_type_id char(8), in cur_name varchar(30))
returns char(8) as
$$
begin
	if cur_type_id is null then
		cur_type_id := (select type_id
						from type
						order by type_id desc
						limit 1);
		cur_type_id := next_id(cur_type_id);
		insert into type values (cur_type_id, cur_name);
	end if;
	
	return cur_type_id;
end;
$$
language plpgsql;

-- insert_into_title function
create or replace function insert_into_title(in cur_title_id char(8), in cur_name varchar(30),
											 in cur_quantity integer, in cur_publish_date date,
											 in cur_summary text, in cur_quan_in_lib integer,
											 in cur_url varchar, in cur_author_id char(8),
											 in cur_publisher_id char(8), in cur_language_id char(8),
											 in cur_position_id char(8), in cur_type_id char(8))
returns void as
$$
begin
	cur_title_id := (select title_id
					from title
					order by title_id desc
					limit 1);
	cur_title_id := next_id(cur_title_id);
	
	insert into title values (cur_title_id, cur_name, cur_quantity, cur_publish_date, cur_summary,
							  cur_author_id, cur_publisher_id, cur_language_id, cur_position_id,
							  cur_type_id, cur_quan_in_lib, cur_url);
end;
$$
language plpgsql;

-- tf_for_insert_into_title_infos function
create or replace function tf_for_insert_into_title_infos() returns trigger as
$$
declare cur_author_id char(8); cur_publisher_id char(8); cur_language_id char(8);
		cur_position_id char(8); cur_type_id char(8);
begin
	cur_author_id := insert_into_author(new.author_id, new.author_first_name, new.author_last_name);
	cur_publisher_id := insert_into_publisher(new.publisher_id, new.publisher_name, new.publisher_address);
	cur_language_id := insert_into_language(new.language_id, new.language_name);
	cur_position_id := insert_into_position(new.position_id, new.area, new.shelf);
	cur_type_id := insert_into_type(new.type_id, new.type_name);
	perform insert_into_title(new.title_id, new.title_name, new.quantity, new.publish_date, new.summary,
							  new.quan_in_lib, new.url, cur_author_id, cur_publisher_id, cur_language_id,
							  cur_position_id, cur_type_id);
	return new;
end;
$$
language plpgsql;

-- create trigger for insert into view

-- drop trigger tg_insert_into_title_infos on title_infos;

create trigger tg_insert_into_title_infos
instead of insert on title_infos
for each row
execute procedure tf_for_insert_into_title_infos();
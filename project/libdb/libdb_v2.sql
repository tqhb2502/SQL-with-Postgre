	-- drop table if exists author cascade;
-- drop table if exists publisher cascade;
-- drop table if exists language cascade;
-- drop table if exists position cascade;
-- drop table if exists type cascade;
-- drop table if exists users cascade;
-- drop table if exists title cascade;
-- drop table if exists book cascade;
-- drop table if exists borrow cascade;

-- CREATE TABLE

create table author(
	author_id char(8) not null,
	first_name varchar(20) not null,
	last_name varchar(20) not null,
	constraint author_pk primary key(author_id)
);

create table publisher(
	publisher_id char(8) not null,
	name varchar(30) not null,
	address varchar(30),
	constraint publisher_pk primary key(publisher_id)
);

create table language(
	language_id char(8) not null,
	name varchar(30) not null,
	constraint language_pk primary key(language_id)
);

create table position(
	position_id char(8) not null,
	area char(8) not null,
	shelf char(8) not null,
	constraint position_pk primary key(position_id)
);

create table type(
	type_id char(8) not null,
	name varchar(30) not null,
	constraint type_pk primary key(type_id)
);

create table users(
	user_id char(8) not null,
	first_name varchar(20) not null,
	last_name varchar(20) not null,
	dob date not null,
	gender char(1),
	address varchar(30),
	phone_number char(10) not null,
	email varchar(30) not null,
	password varchar not null,
	role char(1) not null,
	constraint user_pk primary key(user_id)
);

create table title(
	title_id char(8) not null,
	name varchar(30) not null,
	quantity integer not null,
	publish_date date,
	summary text,
	author_id char(8),
	publisher_id char(8),
	language_id char(8),
	position_id char(8),
	type_id char(8),
	constraint title_pk primary key(title_id)
);

create table book(
	book_id char(8) not null,
	note text,
	title_id char(8) not null,
	constraint book_pk primary key(book_id)
);

create table borrow(
	book_id char(8) not null,
	user_id char(8) not null,
	borrow_date date not null,
	due_date date,
	return_date date,
	note text,
	constraint borrow_pk primary key(book_id, user_id)
);

alter table title
	add constraint title_author_fk foreign key(author_id) references author(author_id);

alter table title
	add constraint title_publisher_fk foreign key(publisher_id) references publisher(publisher_id);

alter table title
	add constraint title_language_fk foreign key(language_id) references language(language_id);

alter table title
	add constraint title_position_fk foreign key(position_id) references position(position_id);

alter table title
	add constraint title_type_fk foreign key(type_id) references type(type_id);

alter table book
	add constraint book_title_fk foreign key(title_id) references title(title_id);
	
alter table borrow
	add constraint borrow_book_fk foreign key(book_id) references book(book_id);
	
alter table borrow
	add constraint borrow_user_fk foreign key(user_id) references users(user_id);
	
alter table title
	add column quan_in_lib integer;
	
alter table title
	add column url varchar;
	
alter table borrow
	add column borrow_id char(8) not null;
	
alter table borrow
	drop constraint borrow_pk;
	
alter table borrow
	add constraint borrow_pk primary key (borrow_id);
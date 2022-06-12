--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

-- Started on 2022-02-05 20:13:21

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 235 (class 1255 OID 49600)
-- Name: add_book(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_book() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare number_of_book integer;
		cur_quantity integer;
		next_book_id char(8);
begin
	number_of_book := (select count(book_id)
						from book
						where title_id = new.title_id);
	cur_quantity := (select quantity
					from title
					where title_id = new.title_id);
	while number_of_book < cur_quantity loop
		next_book_id := (select book_id
						from book
						order by book_id desc
						limit 1);
		next_book_id := next_id(next_book_id);
		insert into book values (next_book_id, null, new.title_id);
		number_of_book := number_of_book + 1;
	end loop;
	
	return new;
end;
$$;


ALTER FUNCTION public.add_book() OWNER TO postgres;

--
-- TOC entry 222 (class 1255 OID 49744)
-- Name: insert_into_author(character, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_into_author(cur_author_id character, cur_first_name character varying, cur_last_name character varying) RETURNS character
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.insert_into_author(cur_author_id character, cur_first_name character varying, cur_last_name character varying) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 49746)
-- Name: insert_into_language(character, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_into_language(cur_language_id character, cur_name character varying) RETURNS character
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.insert_into_language(cur_language_id character, cur_name character varying) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 49747)
-- Name: insert_into_position(character, character, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_into_position(cur_position_id character, cur_area character, cur_shelf character) RETURNS character
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.insert_into_position(cur_position_id character, cur_area character, cur_shelf character) OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 49745)
-- Name: insert_into_publisher(character, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_into_publisher(cur_publisher_id character, cur_name character varying, cur_address character varying) RETURNS character
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.insert_into_publisher(cur_publisher_id character, cur_name character varying, cur_address character varying) OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 49749)
-- Name: insert_into_title(character, character varying, integer, date, text, integer, character varying, character, character, character, character, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_into_title(cur_title_id character, cur_name character varying, cur_quantity integer, cur_publish_date date, cur_summary text, cur_quan_in_lib integer, cur_url character varying, cur_author_id character, cur_publisher_id character, cur_language_id character, cur_position_id character, cur_type_id character) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.insert_into_title(cur_title_id character, cur_name character varying, cur_quantity integer, cur_publish_date date, cur_summary text, cur_quan_in_lib integer, cur_url character varying, cur_author_id character, cur_publisher_id character, cur_language_id character, cur_position_id character, cur_type_id character) OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 49755)
-- Name: insert_into_title(character, character varying, integer, character varying, text, integer, character varying, character, character, character, character, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_into_title(cur_title_id character, cur_name character varying, cur_quantity integer, cur_publish_date character varying, cur_summary text, cur_quan_in_lib integer, cur_url character varying, cur_author_id character, cur_publisher_id character, cur_language_id character, cur_position_id character, cur_type_id character) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	cur_title_id := (select title_id
					from title
					order by title_id desc
					limit 1);
	cur_title_id := next_id(cur_title_id);
	
	insert into title values (cur_title_id, cur_name, cur_quantity, cur_publish_date, cur_summary,
							  cur_author_id, cur_publisher_id, cur_language_id, cur_position_id,
							  cur_type_id, cur_url,cur_quan_in_lib);
end;
$$;


ALTER FUNCTION public.insert_into_title(cur_title_id character, cur_name character varying, cur_quantity integer, cur_publish_date character varying, cur_summary text, cur_quan_in_lib integer, cur_url character varying, cur_author_id character, cur_publisher_id character, cur_language_id character, cur_position_id character, cur_type_id character) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 49748)
-- Name: insert_into_type(character, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_into_type(cur_type_id character, cur_name character varying) RETURNS character
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.insert_into_type(cur_type_id character, cur_name character varying) OWNER TO postgres;

--
-- TOC entry 223 (class 1255 OID 49379)
-- Name: next_id(character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.next_id(cur_id character) RETURNS character
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.next_id(cur_id character) OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 49752)
-- Name: tf_for_insert_into_title_infos(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.tf_for_insert_into_title_infos() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.tf_for_insert_into_title_infos() OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 50031)
-- Name: tf_for_update_title_infos(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.tf_for_update_title_infos() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.tf_for_update_title_infos() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 17870)
-- Name: author; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.author (
    author_id character(8) NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL
);


ALTER TABLE public.author OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 49446)
-- Name: book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book (
    book_id character(8) NOT NULL,
    note text,
    title_id character(8) NOT NULL
);


ALTER TABLE public.book OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 45315)
-- Name: borrow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.borrow (
    book_id character(8) NOT NULL,
    user_id character(8) NOT NULL,
    borrow_date timestamp with time zone NOT NULL,
    due_date character varying(255) DEFAULT '3 tháng'::character varying,
    return_date timestamp with time zone,
    note character varying(1) DEFAULT 'W'::character varying,
    borrow_id character(8) NOT NULL
);


ALTER TABLE public.borrow OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 17902)
-- Name: title; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.title (
    title_id character(8) NOT NULL,
    name character varying(255) NOT NULL,
    quantity integer,
    publish_date character varying(255),
    summary text,
    author_id character varying(255),
    publisher_id character varying(255),
    language_id character varying(255),
    position_id character varying(255),
    type_id character varying(255),
    url character varying(255),
    quan_in_lib integer
);


ALTER TABLE public.title OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 17895)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id character(8) NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    dob timestamp with time zone,
    gender character varying(255),
    address character varying(255),
    phone_number character varying(255),
    email character varying(255),
    password character varying(255),
    role character varying(255) DEFAULT 'user'::character varying,
    "MSSV" character varying(255),
    favorite character varying(255)[]
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 53464)
-- Name: borrow_infos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.borrow_infos AS
 SELECT u.user_id,
    (((u.first_name)::text || ' '::text) || (u.last_name)::text) AS user_name,
    t.title_id,
    t.name AS title_name,
    b.book_id,
    br.borrow_date,
    br.return_date,
    br.borrow_id,
    br.note,
    t.quan_in_lib
   FROM (((public.borrow br
     JOIN public.book b ON ((br.book_id = b.book_id)))
     JOIN public.title t ON ((b.title_id = t.title_id)))
     JOIN public.users u ON ((u.user_id = br.user_id)));


ALTER TABLE public.borrow_infos OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 17880)
-- Name: language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language (
    language_id character(8) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.language OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 47628)
-- Name: news; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.news (
    new_id integer NOT NULL,
    content text,
    url character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    title character varying(255) NOT NULL
);


ALTER TABLE public.news OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 47627)
-- Name: news_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.news_new_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.news_new_id_seq OWNER TO postgres;

--
-- TOC entry 3412 (class 0 OID 0)
-- Dependencies: 217
-- Name: news_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.news_new_id_seq OWNED BY public.news.new_id;


--
-- TOC entry 212 (class 1259 OID 17885)
-- Name: position; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."position" (
    position_id character(8) NOT NULL,
    area character varying(255) NOT NULL,
    shelf character varying(255) NOT NULL
);


ALTER TABLE public."position" OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 17875)
-- Name: publisher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publisher (
    publisher_id character(8) NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255)
);


ALTER TABLE public.publisher OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 17890)
-- Name: type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type (
    type_id character(8) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.type OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 49655)
-- Name: title_infos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.title_infos AS
 SELECT t.title_id,
    t.name AS title_name,
    t.quantity,
    t.publish_date,
    t.summary,
    t.quan_in_lib,
    t.url,
    a.author_id,
    a.first_name AS author_first_name,
    a.last_name AS author_last_name,
    p.publisher_id,
    p.name AS publisher_name,
    p.address AS publisher_address,
    l.language_id,
    l.name AS language_name,
    pos.position_id,
    pos.area,
    pos.shelf,
    ty.type_id,
    ty.name AS type_name
   FROM public.title t,
    public.author a,
    public.publisher p,
    public.language l,
    public."position" pos,
    public.type ty
  WHERE (((t.author_id)::bpchar = a.author_id) AND ((t.publisher_id)::bpchar = p.publisher_id) AND ((t.language_id)::bpchar = l.language_id) AND ((t.position_id)::bpchar = pos.position_id) AND ((t.type_id)::bpchar = ty.type_id));


ALTER TABLE public.title_infos OWNER TO postgres;

--
-- TOC entry 3222 (class 2604 OID 47631)
-- Name: news new_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.news ALTER COLUMN new_id SET DEFAULT nextval('public.news_new_id_seq'::regclass);


--
-- TOC entry 3396 (class 0 OID 17870)
-- Dependencies: 209
-- Data for Name: author; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.author (author_id, first_name, last_name) FROM stdin;
00000000	Đức Nghĩa	Nguyễn
00000001	Đình Trí	Nguyễn
00000002	Phạm Đức Cường	PSG.TS
00000003	Trần Đức Thức	TS
00000004	Phạm Hồng Liên	PGS.TS
00000005	Darwin	Charles
00000006	Hawking	 Stephen
00000007	Fernando Alvarez	Martin Fridson,
00000008	Duyên Bình	Lương
00000009	 Ngô Tuấn Nghĩa	 PGS.TS.
00000010	Khoo	Adam 
00000011	Carnegie	Dale 
00000012	Tiếu Hằng	Trương 
00000013	An	Tuệ
00000014	Quốc Việt	Dương
00000015	Bằng Giang	Nguyễn
00000016	Đào Tạo	Bộ Giáo Dục Và 
00000017	Khải Đoàn	Hoàng
00000018	Clear	James
00000019	Duhigg	 Charles 
00000020	tác giả	Nhóm 
00000021	Ju Yung	Chung 
00000022	S.Clason	George 
00000023	Peter Lynch	John Rothchild, 
00000024	Kế Dũng	Lý 
00000025	Tampke	Ilka 
00000026	JERRY HICKS	ESTHER & 
\.


--
-- TOC entry 3406 (class 0 OID 49446)
-- Dependencies: 219
-- Data for Name: book; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book (book_id, note, title_id) FROM stdin;
00000030	\N	00000003
00000031	\N	00000003
00000032	\N	00000003
00000033	\N	00000003
00000034	\N	00000003
00000035	\N	00000004
00000036	\N	00000004
00000037	\N	00000004
00000038	\N	00000004
00000039	\N	00000004
00000040	\N	00000004
00000041	\N	00000004
00000042	\N	00000004
00000043	\N	00000004
00000044	\N	00000004
00000045	\N	00000005
00000046	\N	00000005
00000047	\N	00000005
00000048	\N	00000005
00000049	\N	00000005
00000050	\N	00000006
00000051	\N	00000006
00000052	\N	00000006
00000053	\N	00000006
00000054	\N	00000006
00000055	\N	00000006
00000056	\N	00000006
00000057	\N	00000006
00000058	\N	00000006
00000059	\N	00000006
00000060	\N	00000007
00000061	\N	00000007
00000062	\N	00000007
00000063	\N	00000007
00000064	\N	00000007
00000065	\N	00000008
00000066	\N	00000008
00000067	\N	00000008
00000068	\N	00000008
00000069	\N	00000008
00000070	\N	00000008
00000071	\N	00000008
00000072	\N	00000008
00000073	\N	00000008
00000074	\N	00000008
00000075	\N	00000009
00000076	\N	00000009
00000077	\N	00000009
00000078	\N	00000009
00000079	\N	00000009
00000000	\N	00000001
00000001	\N	00000001
00000002	\N	00000001
00000003	\N	00000001
00000004	\N	00000001
00000005	\N	00000001
00000006	\N	00000001
00000007	\N	00000001
00000008	\N	00000001
00000009	\N	00000001
00000010	\N	00000002
00000011	\N	00000002
00000012	\N	00000002
00000013	\N	00000002
00000014	\N	00000002
00000015	\N	00000002
00000016	\N	00000002
00000017	\N	00000002
00000018	\N	00000002
00000019	\N	00000002
00000020	\N	00000002
00000021	\N	00000002
00000022	\N	00000002
00000023	\N	00000002
00000024	\N	00000002
00000025	\N	00000002
00000026	\N	00000002
00000027	\N	00000002
00000028	\N	00000002
00000029	\N	00000002
00000080	\N	00000009
00000081	\N	00000009
00000082	\N	00000009
00000083	\N	00000009
00000084	\N	00000009
00000085	\N	00000010
00000086	\N	00000010
00000087	\N	00000010
00000088	\N	00000010
00000089	\N	00000010
00000090	\N	00000010
00000091	\N	00000010
00000092	\N	00000010
00000093	\N	00000010
00000094	\N	00000010
00000095	\N	00000011
00000096	\N	00000011
00000097	\N	00000011
00000098	\N	00000011
00000099	\N	00000011
00000100	\N	00000011
00000101	\N	00000011
00000102	\N	00000011
00000103	\N	00000011
00000104	\N	00000011
00000105	\N	00000012
00000106	\N	00000012
00000107	\N	00000012
00000108	\N	00000012
00000109	\N	00000012
00000110	\N	00000012
00000111	\N	00000012
00000112	\N	00000012
00000113	\N	00000012
00000114	\N	00000012
00000115	\N	00000012
00000116	\N	00000012
00000117	\N	00000012
00000118	\N	00000012
00000119	\N	00000012
00000120	\N	00000012
00000121	\N	00000012
00000122	\N	00000012
00000123	\N	00000012
00000124	\N	00000012
00000125	\N	00000013
00000126	\N	00000013
00000127	\N	00000013
00000128	\N	00000013
00000129	\N	00000013
00000130	\N	00000013
00000131	\N	00000013
00000132	\N	00000013
00000133	\N	00000013
00000134	\N	00000013
00000135	\N	00000013
00000136	\N	00000013
00000137	\N	00000013
00000138	\N	00000013
00000139	\N	00000013
00000140	\N	00000013
00000141	\N	00000013
00000142	\N	00000013
00000143	\N	00000013
00000144	\N	00000013
00000145	\N	00000014
00000146	\N	00000014
00000147	\N	00000014
00000148	\N	00000014
00000149	\N	00000014
00000150	\N	00000014
00000151	\N	00000014
00000152	\N	00000014
00000153	\N	00000014
00000154	\N	00000014
00000155	\N	00000015
00000156	\N	00000015
00000157	\N	00000015
00000158	\N	00000015
00000159	\N	00000015
00000160	\N	00000015
00000161	\N	00000015
00000162	\N	00000015
00000163	\N	00000015
00000164	\N	00000015
00000165	\N	00000016
00000166	\N	00000016
00000167	\N	00000016
00000168	\N	00000016
00000169	\N	00000016
00000170	\N	00000016
00000171	\N	00000016
00000172	\N	00000016
00000173	\N	00000016
00000174	\N	00000016
00000175	\N	00000016
00000176	\N	00000016
00000177	\N	00000016
00000178	\N	00000016
00000179	\N	00000016
00000180	\N	00000016
00000181	\N	00000016
00000182	\N	00000016
00000183	\N	00000016
00000184	\N	00000016
00000185	\N	00000017
00000186	\N	00000017
00000187	\N	00000017
00000188	\N	00000017
00000189	\N	00000017
00000190	\N	00000017
00000191	\N	00000017
00000192	\N	00000017
00000193	\N	00000017
00000194	\N	00000017
00000195	\N	00000018
00000196	\N	00000018
00000197	\N	00000018
00000198	\N	00000018
00000199	\N	00000018
00000200	\N	00000018
00000201	\N	00000018
00000202	\N	00000018
00000203	\N	00000018
00000204	\N	00000018
00000205	\N	00000018
00000206	\N	00000018
00000207	\N	00000018
00000208	\N	00000018
00000209	\N	00000018
00000210	\N	00000018
00000211	\N	00000018
00000212	\N	00000018
00000213	\N	00000018
00000214	\N	00000018
00000215	\N	00000019
00000216	\N	00000019
00000217	\N	00000019
00000218	\N	00000019
00000219	\N	00000019
00000220	\N	00000019
00000221	\N	00000019
00000222	\N	00000019
00000223	\N	00000019
00000224	\N	00000019
00000225	\N	00000020
00000226	\N	00000020
00000227	\N	00000020
00000228	\N	00000020
00000229	\N	00000020
00000230	\N	00000020
00000231	\N	00000020
00000232	\N	00000020
00000233	\N	00000020
00000234	\N	00000020
00000235	\N	00000020
00000236	\N	00000020
00000237	\N	00000020
00000238	\N	00000020
00000239	\N	00000020
00000240	\N	00000020
00000241	\N	00000020
00000242	\N	00000020
00000243	\N	00000020
00000244	\N	00000020
00000245	\N	00000021
00000246	\N	00000021
00000247	\N	00000021
00000248	\N	00000021
00000249	\N	00000021
00000250	\N	00000021
00000251	\N	00000021
00000252	\N	00000021
00000253	\N	00000021
00000254	\N	00000021
00000255	\N	00000021
00000256	\N	00000021
00000257	\N	00000021
00000258	\N	00000021
00000259	\N	00000021
00000260	\N	00000021
00000261	\N	00000021
00000262	\N	00000021
00000263	\N	00000021
00000264	\N	00000021
00000265	\N	00000021
00000266	\N	00000021
00000267	\N	00000021
00000268	\N	00000021
00000269	\N	00000021
00000270	\N	00000021
00000271	\N	00000021
00000272	\N	00000021
00000273	\N	00000021
00000274	\N	00000021
00000275	\N	00000021
00000276	\N	00000021
00000277	\N	00000021
00000278	\N	00000021
00000279	\N	00000021
00000280	\N	00000021
00000281	\N	00000021
00000282	\N	00000021
00000283	\N	00000021
00000284	\N	00000021
00000285	\N	00000021
00000286	\N	00000021
00000287	\N	00000021
00000288	\N	00000021
00000289	\N	00000021
00000290	\N	00000021
00000291	\N	00000021
00000292	\N	00000021
00000293	\N	00000021
00000294	\N	00000021
00000295	\N	00000022
00000296	\N	00000022
00000297	\N	00000022
00000298	\N	00000022
00000299	\N	00000022
00000300	\N	00000022
00000301	\N	00000022
00000302	\N	00000022
00000303	\N	00000022
00000304	\N	00000022
00000305	\N	00000022
00000306	\N	00000022
00000307	\N	00000022
00000308	\N	00000022
00000309	\N	00000022
00000310	\N	00000022
00000311	\N	00000022
00000312	\N	00000022
00000313	\N	00000022
00000314	\N	00000022
00000315	\N	00000023
00000316	\N	00000023
00000317	\N	00000023
00000318	\N	00000023
00000319	\N	00000023
00000320	\N	00000023
00000321	\N	00000023
00000322	\N	00000023
00000323	\N	00000023
00000324	\N	00000023
00000325	\N	00000024
00000326	\N	00000024
00000327	\N	00000024
00000328	\N	00000024
00000329	\N	00000024
00000330	\N	00000024
00000331	\N	00000024
00000332	\N	00000024
00000333	\N	00000024
00000334	\N	00000024
00000335	\N	00000025
00000336	\N	00000025
00000337	\N	00000025
00000338	\N	00000025
00000339	\N	00000025
00000340	\N	00000025
00000341	\N	00000025
00000342	\N	00000025
00000343	\N	00000025
00000344	\N	00000025
00000345	\N	00000026
00000346	\N	00000026
00000347	\N	00000026
00000348	\N	00000026
00000349	\N	00000026
00000350	\N	00000026
00000351	\N	00000026
00000352	\N	00000026
00000353	\N	00000026
00000354	\N	00000026
00000355	\N	00000026
00000356	\N	00000026
00000357	\N	00000026
00000358	\N	00000026
00000359	\N	00000026
00000360	\N	00000026
00000361	\N	00000026
00000362	\N	00000026
00000363	\N	00000026
00000364	\N	00000026
00000365	\N	00000027
00000366	\N	00000027
00000367	\N	00000027
00000368	\N	00000027
00000369	\N	00000027
00000370	\N	00000027
00000371	\N	00000027
00000372	\N	00000027
00000373	\N	00000027
00000374	\N	00000027
00000375	\N	00000027
00000376	\N	00000027
00000377	\N	00000027
00000378	\N	00000027
00000379	\N	00000027
00000380	\N	00000027
00000381	\N	00000027
00000382	\N	00000027
00000383	\N	00000027
00000384	\N	00000027
00000385	\N	00000028
00000386	\N	00000028
00000387	\N	00000028
00000388	\N	00000028
00000389	\N	00000028
00000390	\N	00000028
00000391	\N	00000028
00000392	\N	00000028
00000393	\N	00000028
00000394	\N	00000028
00000395	\N	00000029
00000396	\N	00000029
00000397	\N	00000029
00000398	\N	00000029
00000399	\N	00000029
00000400	\N	00000029
00000401	\N	00000029
00000402	\N	00000029
00000403	\N	00000029
00000404	\N	00000029
00000405	\N	00000030
00000406	\N	00000030
00000407	\N	00000030
00000408	\N	00000030
00000409	\N	00000030
00000410	\N	00000030
00000411	\N	00000030
00000412	\N	00000030
00000413	\N	00000030
00000414	\N	00000030
00000415	\N	00000031
00000416	\N	00000031
00000417	\N	00000031
00000418	\N	00000031
00000419	\N	00000031
00000420	\N	00000031
00000421	\N	00000031
00000422	\N	00000031
00000423	\N	00000031
00000424	\N	00000031
00000425	\N	00000032
00000426	\N	00000032
00000427	\N	00000032
00000428	\N	00000032
00000429	\N	00000032
00000430	\N	00000032
00000431	\N	00000032
00000432	\N	00000032
00000433	\N	00000032
00000434	\N	00000032
\.


--
-- TOC entry 3403 (class 0 OID 45315)
-- Dependencies: 216
-- Data for Name: borrow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.borrow (book_id, user_id, borrow_date, due_date, return_date, note, borrow_id) FROM stdin;
00000217	34ea9566	2022-01-19 00:00:00+07	3 tháng	2022-04-19 00:00:00+07	R	00000007
00000010	34ea9566	2022-01-18 00:00:00+07	3 tháng	2022-04-18 00:00:00+07	R	00000004
00000000	9a2932bb	2022-01-17 00:00:00+07	3 tháng	2022-04-17 00:00:00+07	R	00000001
00000125	9a2932bb	2022-01-17 00:00:00+07	3 tháng	2022-04-17 00:00:00+07	R	00000002
00000155	9a2932bb	2022-01-17 00:00:00+07	3 tháng	2022-04-17 00:00:00+07	R	00000003
00000195	9a2932bb	2022-01-19 00:00:00+07	3 tháng	2022-04-19 00:00:00+07	B	00000008
00000225	47cb6b1b	2022-02-04 00:00:00+07	3 tháng	2022-05-04 00:00:00+07	B	00000009
00000216	34ea9566	2022-01-19 00:00:00+07	3 tháng	2022-04-19 00:00:00+07	R	00000006
00000215	34ea9566	2022-01-19 00:00:00+07	3 tháng	2022-04-19 00:00:00+07	R	00000005
\.


--
-- TOC entry 3398 (class 0 OID 17880)
-- Dependencies: 211
-- Data for Name: language; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language (language_id, name) FROM stdin;
00000001	Tiếng Anh
00000002	Tiếng Trung
00000003	Tiếng Việt
00000004	Tiếng Hàn
00000005	Tiếng Pháp
00000006	Tiếng Nhật
00000007	Tiếng Lào
\.


--
-- TOC entry 3405 (class 0 OID 47628)
-- Dependencies: 218
-- Data for Name: news; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.news (new_id, content, url, "createdAt", "updatedAt", title) FROM stdin;
2	\N	https://png.pngtree.com/png-clipart/20200225/original/pngtree-calendar-date-event-release-schedule-flat-color-icon-vector-png-image_5265413.jpg	2022-01-10 16:44:37.653+07	2022-01-10 16:44:37.653+07	Nhớ tra lịch hoạt động 
1	Thư viện sẽ nghỉ lễ Tết Dương trong 3 ngày 1/1,2/1, 3/1 năm 2022. Chúc mừng năm mới !	https://png.pngtree.com/png-clipart/20191123/original/pngtree-happy-new-year-text-png-image_5195001.jpg	2022-01-10 16:18:16.979+07	2022-01-10 16:18:16.979+07	Nghỉ lễ tết
3	Nghỉ 2 tháng	https://png.pngtree.com/png-clipart/20211017/original/pngtree-happy-new-year-2022-png-image_6859272.png	2022-01-16 20:52:30.094+07	2022-01-16 20:52:30.094+07	Thông báo nghỉ tết Âm lịch
4	Thư viện bắt đầu mở cửa từ ngày 7/2/2022 	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScV7wON1P_xQSwjJqq58Rv3Stf5euJ0Ic7OA&usqp=CAU	2022-02-04 21:50:43.507+07	2022-02-04 21:50:43.507+07	Lịch hoạt động sau tết
\.


--
-- TOC entry 3399 (class 0 OID 17885)
-- Dependencies: 212
-- Data for Name: position; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."position" (position_id, area, shelf) FROM stdin;
PO000001	Lầu 1	Dãy 1
PO000002	Lầu 1	Dãy 2
PO000003	Lầu 3	Dãy 1
PO000004	Lầu 4	Dãy 1
\.


--
-- TOC entry 3397 (class 0 OID 17875)
-- Dependencies: 210
-- Data for Name: publisher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publisher (publisher_id, name, address) FROM stdin;
00000000	Nhà xuất bản Nam Định	15A Trường Chinh, Q.Đống Đa, HN
00000001	Nhà xuất bản tuổi trẻ	Q. Hai Bà Trưng, HN
00000002	Nhà xuất bản Đại học Bách Khoa	Số 1, Đại Cồ Việt, Q, Hai Bà Trưng, HN
00000003	Nhà xuất bản giáo dục Việt Nam	\N
00000005	Nhà xuất bản Khoa học và Kĩ thuật	\N
00000006	Nhà xuất bản tri thức	\N
00000007	Nhà xuất bản trẻ	\N
00000008	Nhà xuất bản Kinh tế TP Hồ Chí Minh	\N
00000009	Nhà Xuất Bản Chính Trị Quốc Gia Sự Thật	\N
00000010	TGM Books	\N
00000011	First News - Trí Việt	\N
00000012	1980 Books	\N
00000013	Nhà Xuất Bản Hồng Đức	\N
00000014	Nhà Xuất Bản Đại Học Sư Phạm	\N
00000015	NXB Xây Dựng	\N
00000004	Nhà xuất bản Tài Chính	Hải Phòng
00000016	Nhà xuất bản thanh niên	\N
00000017	Nhà Xuất Bản Lao Động Xã Hội	\N
00000018	Công Ty Cổ Phần Văn Hóa Đông A	\N
00000019	Nhà xuất bản văn học	\N
00000020	Nhà xuất bản Mỹ thuật	\N
00000021	Nhà xuất bản Phụ nữ	\N
00000022	Nhã Nam	\N
\.


--
-- TOC entry 3402 (class 0 OID 17902)
-- Dependencies: 215
-- Data for Name: title; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.title (title_id, name, quantity, publish_date, summary, author_id, publisher_id, language_id, position_id, type_id, url, quan_in_lib) FROM stdin;
00000014	Nói Chuyện Là Bản Năng, Giữ Miệng Là Tu Dưỡng, Im Lặng Là Trí Tuệ	10		Tuân Tử nói: “Nói năng hợp lý, đó gọi là hiểu biết; im lặng đúng lúc, đó cũng là hiểu biết”. Ngôn ngữ là thứ có thể thể hiện rõ nhất mức độ tu dưỡng của một người, nói năng hợp lý là một loại trí tuệ, mà im lặng đúng lúc cũng là một loại trí tuệ. Nếu một người không biết giữ miệng, nói mà không suy nghĩ, nghĩ gì nói nấy, tất nhiên rất dễ khiến người khác chán ghét.	00000012	00000012	00000003	PO000004	00000004	https://salt.tikicdn.com/cache/400x400/ts/product/53/ec/b6/e67dfef8643496ef9abe6e5430b1a630.jpg.webp	10
00000016	 Bài Tập Cơ Sở Đại Số Hiện Đại	20		Nội dung gồm có:\r\nI. Tóm tắt lí thuyết và đề bài\r\n1. Tập hợp - Logic - Quan hệ - Ánh xạ\r\n2. Nữa nhóm và Nhóm\r\n3. Vành và Trường\r\n4. Một vài chủ điểm về nhóm\r\n5. Một vài lớp vành đặc biệt\r\n6. Đa thức\r\n7. Module và Đại số\r\n8. Dàn và Đại số Boole\r\n9. Phạm trù và Hàm tử	00000014	00000014	00000003	PO000001	00000003	https://salt.tikicdn.com/cache/400x400/ts/product/53/c2/c9/a2df48149884704463dd930a04b77415.jpg.webp	20
00000010	Vật Lí Đại Cương Tập 2 	10	2005	Giáo trình "Vật Lý Đại Cương" được biên soạn theo khung chương trình của Bộ Giáo Dục - Đào Tạo, có chú ý đến nội dung đào tạo của khối các trường kỹ thuật.	00000008	00000003	00000003	PO000001	00000003	https://salt.tikicdn.com/cache/400x400/ts/product/e2/6a/3d/f9faa56bc3d0b05ac90c79f1fa446f68.jpg.webp	10
00000001	Thuật toán nâng cao	10	2011		00000000	00000000	00000003	PO000002	00000002	https://img1.baza.vn/upload/files/products-ulScViFl/fummB84V.jpg?v=635436969317019442	10
00000004	Báo cáo tài chính	10	2016		00000002	00000004	00000003	PO000001	00000006	https://salt.tikicdn.com/cache/400x400/ts/product/b6/90/7b/ef30ab49c180ac79bc5d4418f9d767cf.jpg.webp	10
00000003	Bài tập toán cao cấp	5	2007		00000001	00000003	00000003	PO000001	00000003	https://salt.tikicdn.com/cache/400x400/ts/product/43/e3/0b/7a6f571a156d0dd4fcf79b9243f6378e.jpg.webp	5
00000013	Đắc Nhân Tâm (Khổ Nhỏ) - Tái Bản 2020	20	2020	Đắc nhân tâm của Dale Carnegie là quyển sách nổi tiếng nhất, bán chạy nhất và có tầm ảnh hưởng nhất của mọi thời đại. Tác phẩm đã được chuyển ngữ sang hầu hết các thứ tiếng trên thế giới và có mặt ở hàng trăm quốc gia. Đây là quyển sách duy nhất về thể loại self-help liên tục đứng đầu danh mục sách bán chạy nhất (best-selling Books) do báo The New York Times bình chọn suốt 10 năm liền.	00000011	00000011	00000003	PO000004	00000004	https://salt.tikicdn.com/cache/400x400/ts/product/c4/1f/23/c13d1ad6270dab748fa37e1b84fe5c43.jpg.webp	20
00000002	Toán cao cấp	20	2007		00000001	00000003	00000003	PO000001	00000003	https://salt.tikicdn.com/cache/400x400/ts/product/78/ac/77/f33feea6316e9a2d04a3c074adee170a.jpg.webp	20
00000005	Quản trị học	5	2010		00000003	00000004	00000003	PO000001	00000002	https://salt.tikicdn.com/cache/400x400/ts/product/ca/0b/49/8e5b83f5888736520dff950052f676db.jpg.webp	5
00000006	Tuyển Tập Test Vật Lý Đại Cương	10			00000004	00000005	00000003	PO000001	00000003	https://salt.tikicdn.com/cache/400x400/ts/product/91/7c/64/a241a4f673e9d89c6aa4431046e1ae09.jpg.webp	10
00000007	Nguồn Gốc Các Loài	5			00000005	00000006	00000003	PO000002	00000008	https://salt.tikicdn.com/cache/400x400/media/catalog/product/4/-/4-nguon-goc-cac-loai.u5168.d20170710.t135447.262055.jpg.webp	5
00000008	Sách-Lỗ Đen Các Bài Thuyết Giảng Trên Đài	10		Sách tập hợp hai bài nói chuyện của nhà vật lý vĩ đại Stephen Hawking trên BBC vào đầu năm 2016. Trong loạt bài giảng trên BBC này, tác giả đã dựng lên thách đố phải tóm lược câu chuyện cả một đời bên trong lỗ đen chỉ trong hai cuộc trò chuyện mười lăm phút.	00000006	00000007	00000003	PO000002	00000006	https://salt.tikicdn.com/cache/400x400/ts/product/b2/5e/92/63ecee066611f0be842154dad49cfc98.jpg.webp	10
00000009	Phân Tích Báo Cáo Tài Chính - Hướng Dẫn Thực Hành	10		Phân Tích Báo Cáo Tài Chính là một kỹ năng cơ bản của những ai liên quan đến quản lý đầu tư, tài chính doanh nghiệp, tín dụng thương mại và gia hạn tín dụng. Nhiều năm qua, nó trở thành một nỗ lực ngày càng phức tạp vì báo cáo tài chính doanh nghiệp ngày càng trở nên khó giải mã. Nhưng với quyền Phân tích báo cáo tài chính ấn bản lần thứ tư này, bạn đọc sẽ học cách thức xử lý những thách thức mà là một phần của doanh nghiệp trong thực tiễn.	00000007	00000008	00000003	PO000002	00000006	https://salt.tikicdn.com/cache/400x400/ts/product/35/a5/a4/4084eb4a8e768c29f06ed2b7adb52807.jpg.webp	10
00000011	Giáo Trình Kinh Tế Chính Trị Mác – Lênin	10	2021	Giáo trình do PGS.TS. Ngô Tuấn Nghĩa chủ biên, cùng tập thể tác giả là những nhà nghiên cứu, nhà giáo dục có nhiều kinh nghiệm tổ chức biên soạn.\r\nGiáo trình gồm 6 chương	00000009	00000009	00000003	PO000001	00000003	https://salt.tikicdn.com/cache/400x400/ts/product/d4/51/60/6a5c49d0e64b233150faad9bd3386b73.jpg.webp	10
00000012	Tôi Tài Giỏi - Bạn Cũng Thế	20		Khi bạn cầm trên tay quyển sách này, có nghĩa là bạn đã có chiếc chìa khóa đến sự thành công cùng bảng hướng dẫn sử dụng.\r\n\r\nTrong chúng ta, bất kỳ ai cũng muốn chính bản thân mình trở thành người tài giỏi, có thể giải quyết mọi vấn đề một cách hiệu quả nhất. Và để có được những điều đó quyển sách này sẽ giúp bạn bằng những hướng dẫn học tập chi tiết nhất.	00000010	00000010	00000003	PO000004	00000004	https://salt.tikicdn.com/cache/400x400/media/catalog/product/t/o/toi-tai-gioi.jpg.webp	20
00000015	90 Ngày Thực Hành Biết Ơn - Chinh Phục Hạnh Phúc Tập 1 	10	2020		00000013	00000013	00000002	PO000004	00000004	https://salt.tikicdn.com/cache/400x400/ts/product/8e/93/5c/aef260c14fe83e5d64aa6d7b7fbd5f14.png.webp	10
00000017	Bài Tập Giải Tích II	10	2019	Trong từng chương của mỗi cuốn sách đều có kiến thức trọng tâm và ví dụ minh họa, sau đó là phần các dạng toán thi và bài tập tự luyện với gợi ý vắn tắt và đáp số. Đồng thời có sáu đề tự luyện giúp các em học sinh tự luyện tập.	00000015	00000015	00000003	PO000001	00000003	https://salt.tikicdn.com/cache/400x400/ts/product/52/fa/73/f247d93008b64fd8abdc657d41d9e489.jpg.webp	10
00000024	Bách Khoa Cho Trẻ Em - Bách Khoa Tự Nhiên	10	2015	Bộ sách Bách khoa cho trẻ em mang đến những thông tin thú vị về thế giới tự nhiên, con người, động vật... Mỗi chủ đề được trình bày một cách khoa học, súc tích và hấp dẫn, kích thích sự tò mò, ham hiểu biết của trẻ. Cuối mỗi trang đều có một câu hỏi để giúp các em củng cố và ghi nhớ kiến thức.	00000020	00000018	00000003	PO000003	00000006	https://salt.tikicdn.com/cache/400x400/media/catalog/product/i/m/img631_10.jpg.webp	10
00000021	Atomic Habits	50	2015		00000018	00000005	00000001	PO000004	00000004	https://salt.tikicdn.com/cache/400x400/ts/product/dd/a3/6f/f292b4239fd2ae4e78c2a2507f19d9ed.jpg.webp	50
00000022	Sức Mạnh Của Thói Quen (Tái Bản 2019)	20	2019	Chìa khoá quan trọng nhất để mở cánh cửa thành công chính là sự kết hợp nhuần nhuyễn những thói quen tốt với nhau.\r\nCâu hỏi đặt ra là làm thế nào để phân biệt thói quen tốt và thói quen xấu? Thói quen có nằm trong tầm kiểm soát của chúng ta hay không?\r\nVới ba phần khá đầy đặn, Sức mạnh của thói quen cho bạn cái nhìn toàn diện không chỉ về thói quen cá nhân, của tổ chức mà còn là của toàn xã hội, cùng với lời khuyên để vận dụng các thói quen đó.	00000019	00000017	00000003	PO000004	00000004	https://salt.tikicdn.com/cache/400x400/ts/product/70/7c/29/3af7976db9e25ab6de1f3f678c52d788.PNG.webp	20
00000023	Bách Khoa Cho Trẻ Em - Bách Khoa Vũ Trụ	10	2015	Bộ sách Bách khoa cho trẻ em mang đến những thông tin thú vị về thế giới tự nhiên, con người, động vật... Mỗi chủ đề được trình bày một cách khoa học, súc tích và hấp dẫn, kích thích sự tò mò, ham hiểu biết của trẻ. Cuối mỗi trang đều có một câu hỏi để giúp các em củng cố và ghi nhớ kiến thức.	00000020	00000018	00000003	PO000003	00000006	https://salt.tikicdn.com/cache/400x400/media/catalog/product/i/m/img630_1_5.jpg.webp	10
00000025	Bách Khoa Cho Trẻ Em - Bách Khoa Khoa Học	10	2015	Bộ sách Bách khoa cho trẻ em mang đến những thông tin thú vị về thế giới tự nhiên, con người, động vật... Mỗi chủ đề được trình bày một cách khoa học, súc tích và hấp dẫn, kích thích sự tò mò, ham hiểu biết của trẻ. Cuối mỗi trang đều có một câu hỏi để giúp các em củng cố và ghi nhớ kiến thức.	00000020	00000018	00000003	PO000003	00000006	https://salt.tikicdn.com/cache/400x400/ts/product/82/f7/02/ebadab45cf6f69c8b515dfb45508b9f2.jpg.webp	10
00000026	Không Bao Giờ Là Thất Bại - Tất Cả Là Thử Thách	20	2021	Tự truyện nổi tiếng của gã khổng lồ trong nền kinh tế Hàn Quốc - cố Chủ tịch tập đoàn Hyundai Chung Ju-yung\r\nThất bại xảy ra là để con người nhận ra sức mạnh nội tại của bản thân, bởi không ai sống mà chỉ trải qua những thành công trong suốt cuộc đời. Tuy vậy, ta vẫn luôn băn khoăn tự hỏi bản thân rằng bao nhiêu lần thất bại mới đủ để thành công?	00000021	00000011	00000003	PO000004	00000004	https://salt.tikicdn.com/cache/400x400/ts/product/b9/bb/cf/b9c3cb0e86596f31e2bd7ab37174a226.jpg.webp	20
00000019	Quẳng Gánh Lo Đi Và Vui Sống	10		Bất kỳ ai đang sống đều sẽ có những lo lắng thường trực về học hành, công việc, những hoá đơn, chuyện nhà cửa,… Cuộc sống không dễ dàng giải thoát bạn khỏi căng thẳng, ngược lại, nếu quá lo lắng, bạn có thể mắc bệnh trầm cảm. Quẳng Gánh Lo Đi Và Vui Sống khuyên bạn hãy khóa chặt dĩ vãng và tương lai lại để sống trong cái phòng kín mít của ngày hôm nay. Mọi vấn đề đều có thể được giải quyết, chỉ cần bạn bình tĩnh và xác định đúng hành động cần làm vào đúng thời điểm.\r\n\r\n	00000011	00000011	00000003	PO000004	00000004	https://salt.tikicdn.com/cache/400x400/ts/product/57/bc/e3/b4472834c2982dce3160ae856f3bf1aa.jpg.webp	10
00000027	Người Giàu Nhất Thành Babylon	20	2019	Một cuốn sách hấp dẫn, giới thiệu về cách tiết kiệm, buôn bán làm giàu của người dân cổ xưa Babylon và vẫn hữu ích với giới kinh doanh ngày nay.\r\nBằng cách lồng ghép vào trong những câu chuyện có tính chất ngụ ngôn đầy lý thú, tác giả đã đề cập đến các nội dung cơ bản, sâu sắc và bổ ích về tài chính. Đây là một món quà đầy ý nghĩa cho những ai đã bước vào thế giới kinh doanh, hoặc cho nhiều người còn hoang mang, do dự trong cách sử dụng tiền bạc.	00000022	00000019	00000001	PO000004	00000004	https://salt.tikicdn.com/cache/400x400/ts/product/e3/04/94/6a9fe11ca71de08954b40dbc980a221f.jpg.webp	20
00000028	Trên Đỉnh Phố Wall (Tái bản 2021)	10	2021	Peter Lynch là nhà quản lý tài chính số 1 ở Mỹ. Quan điểm của ông là: Tất cả các nhà đầu tư trung bình đều có thể trở thành những chuyên gia hàng đầu trong lĩnh vực của họ và họ có thể chọn được những cổ phiếu hời nhất không kém gì các chuyên gia đầu tư trên Phố Wall chỉ bằng việc thực hiện một cuộc điều tra nhỏ.	00000023	00000017	00000003	PO000004	00000006	https://salt.tikicdn.com/cache/400x400/ts/product/01/8b/26/50309bf39284ada0939361cf4131916b.jpg.webp	10
00000018	Giáo Trình Triết Học Mác – Lênin	20	2020	Giáo trình do Ban biên soạn gồm các tác giả là nhà nghiên cứu, nhà giáo dục thuộc Viện Triết học - Học viện Chính trị quốc gia Hồ Chí Minh, các học viện, trường đại học, Viện Triết học - Viện Hàn lâm Khoa học xã hội Việt Nam, tổ chức biên soạn trên cơ sở kế thừa những kết quả nghiên cứu trước đây, đồng thời bổ sung nhiều nội dung, kiến thức, kết quả nghiên cứu mới, gắn với công cuộc đổi mới ở Việt Nam, nhất là những thành tựu trong 35 năm đổi mới đất nước.	00000016	00000009	00000003	PO000001	00000003	https://salt.tikicdn.com/cache/400x400/ts/product/3c/eb/61/5fdb072b133a648d92ac640aae78656a.jpg.webp	19
00000029	Bách Khoa Toàn Thư - Tìm Hiểu Về Trái Đất - Khám Phá Đại Dương	10	2020	Dưới đại dương là một thế giới mà nhân loại chúng ta không thể nào tưởng tượng ra . Ngoài kích thước cơ thể lớn bé , màu sắc hoa văn , tập tính khác nhau của các loài cá ra , bản thân chúng ta còn là một quần thể vô cùng cá tính . Trong khi chúng ta không thể nhìn xuyên qua nước , hàng ngàn hàng vạn tập tính khác nhau của các loài các vẫn diễn ra sôi nổi từng ngày .	00000024	00000020	00000003	PO000003	00000006	https://salt.tikicdn.com/cache/400x400/ts/product/90/06/ba/2b4ec2c58c28f64e9a1e811ceadcca3b.jpg.webp	10
00000030	Science Encyclopedia - Bách Khoa Thư Về Khoa Học - Trái Đất Và Vũ Trụ	10	2020	Các bạn hãy khám phá Trái Đất - nơi có những đại dương mênh mông, những lục địa đang chuyển động, sự tồn tại của các sinh vật sống và vũ trụ - khoảng không gian vô cùng tận ẩn chứa bao điều bí mật ở trong cuốn sách tuyệt vời này nhé! Những hình ảnh, bản đồ, sơ đồ được minh họa sống động, trực quan chắc chắn sẽ thu hút trí tưởng tượng phong phú của các bạn. Không chỉ vậy, cuốn sách còn là tài liệu ôn tập hữu ích với:	00000020	00000016	00000003	PO000003	00000006	https://salt.tikicdn.com/cache/400x400/ts/product/6a/a9/d5/5c36c0cf8fae44071535384777bcb928.jpg.webp	10
00000031	Linh Tộc	10	2017	Linh Tộc là tác phẩm đầu tay xuất sắc mà trong đó có sự hiện diện của pháp thuật huyền bí đầy lôi cuốn, vượt qua ranh giới thể loại thông thường. Đặt trong bối cảnh một thời kỳ nhiều biến động của lịch sử Anh quốc, Linh Tộc kết hợp giữa phép kể chuyện sử thi với cốt truyện độc đáo, ấn tượng, một câu chuyện ly kỳ, mê hoặc và đẫm máu, về sự xung đột giữa hai thế giới và một phụ nữ bị giằng xé giữa hai người đàn ông.	00000025	00000021	00000003	PO000002	00000010	https://salt.tikicdn.com/cache/400x400/ts/product/0b/02/b9/15397ac6ef6a1513085d4dcc60114182.jpg.webp	10
00000020	Thay Đổi Một Suy Nghĩ Thay Đổi cả Cuộc Đời	20		Trong cuốn sách này, tác giả đã tổng kết ra những trường hợp điển hình, thông qua đào sâu phân tích và thảo luận để dẫn mọi người cùng tìm kiếm và “nhìn thấy" mô thức sống hiện nay của họ. Những đau khổ của cuộc đời có muôn hình vạn trạng, nhưng mô thức nội tại thì gần như đều giống nhau, ví dụ mô thức bi quan, mô thức đấu tranh nội tâm, mô thức đau khổ, mô thức giả vờ bận rộn, mô thức tự cao tự đại, mô thức chỉ trích, mô thức làm nạn nhân, mô thức thao túng, mô thức sợ hãi, mô thức la â Trong những trường hợp sinh động này, bạn có thể nhìn thấy bóng dáng của mình, đồng thời phát hiện ra mô thức sống mà mình đang vận hành.  \r\nChỉ khi nhìn thấy mô thức sống của chính mình, con người mới tự nhiên thay đổi. Tác giả gọi quá trình thay đổi này là “nâng cấp sinh mệnh". \r\nBản thân tác giả cũng đã từng trải nghiệm việc đi trên con đường ấy, vì vậy, có lẽ tác giả biết còn rất nhiều tâm hồn khác nhau đang trải qua những đau khổ vô minh giống như ông và cần được đánh thức! Thông qua cuốn sách này, có thể giúp cuộc đời của bạn đọc trở nên tốt đẹp hơn. \r\nCuộc đời của mỗi chúng ta đều có thể vô cùng đẹp đẽ, và cũng có thể tầm thường vô vị, mấu chốt là ở chỗ chúng ta có thể nhìn thấy và cảm nhận mô thức sống của mình đồng thời không ngừng nỗ lực để theo đuổi một cuộc đời tốt đẹp hơn hay không. Vì vậy, khi bạn đang than thở cuộc đời không như ý, oán trách bất công, hãy tự hỏi bản thân rằng: Mình đã tạo ra tất cả mọi thứ ngày hôm nay như thế nào? Loại mô thức nội tại nào của mình khiến thế giới đối xử với mình như vậy.  \r\nHãy mở cuốn sách này ra, có lẽ trong đây có câu trả lời mà bạn cần! 	00000017	00000016	00000003	PO000004	00000004	https://salt.tikicdn.com/cache/400x400/ts/product/30/6d/79/f0a0987374682f36305e027b8c0cfdeb.jpg.webp	19
00000032	Luật Hấp Dẫn (Tái Bản)	10	2018	CHÚNG TA THƯỜNG NGHE RẰNG:"Những gì ta muốn, muốn ta", hay "Niềm tin mang đến đều ta mong muốn", nhưng cốt lõi của những điều ấy chỉ lần đầu tiên được lý giải rõ ràng và giản dị trong cuốn sách bestseller mới nhất này của ESTHER & JERRY HICKS, rằng mọi sự trong cuộc đời ta, cả những điều như ý ta hay trái ý, đều được đưa đến với ta bởi Luật quyền năng nhất Vũ Trụ: Luật Hấp Dẫn	00000026	00000022	00000003	PO000004	00000006	https://salt.tikicdn.com/cache/400x400/ts/product/20/e6/13/5167a6f3962041dcb27cf7bc0e13b7b9.jpg.webp	10
\.


--
-- TOC entry 3400 (class 0 OID 17890)
-- Dependencies: 213
-- Data for Name: type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type (type_id, name) FROM stdin;
00000001	Bài giảng
00000002	Chuyên ngành
00000003	Đại cương
00000004	E-Book
00000005	Chính trị - Pháp luật
00000006	Khoa học công nghệ- Kinh tế
00000007	Văn học nghệ thuật
00000008	Văn hóa xa hội - lịch sử
00000009	Giáo trình
00000010	Truyện, tiểu thuyết
00000011	Tâm lý, tâm linh,tôn giáo
00000012	Thiếu nhi
00000013	Các thể loại khác
\.


--
-- TOC entry 3401 (class 0 OID 17895)
-- Dependencies: 214
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, first_name, last_name, dob, gender, address, phone_number, email, password, role, "MSSV", favorite) FROM stdin;
cf2453fd	Minh Phúc	Bùi	2017-06-14 07:00:00+07	F	Hải Dương	0965744074	phuc@gmail.com	000000	user	201922000	\N
03996a1e	Hồng Thúy	Nguyễn	2022-01-18 07:00:00+07	\N	Hải Dương	0936000000	thuy@gmail.com	000000	user	20194609	\N
US0001  	Đức Mạnh	Đỗ	2001-02-23 07:00:00+07	M	Hải Phòng	0965744074	ddm.bb@gmail.com	000000	admin		{EB000002,EB000001}
9a2932bb	Thị Linh	Hà	2001-01-11 07:00:00+07	F	Thanh Hóa	0936360000	linhha@gmail.com	000000	user	20194444	\N
8d20b6be	Quang Huy	Trần	2001-02-25 07:00:00+07	M	Phú Thọ	0936666666	huy@gmail.com	huydeptrai	user	20190093	\N
34ea9566	Cao Minh	Trần	2022-01-12 07:00:00+07	F	Nam Định	0936000000	minh@gmail.com	00000000	thuthu	20194600	{EB000002,PH000002}
47cb6b1b	Tuấn Anh	Nguyễn	2001-02-11 07:00:00+07	M	Hà Nội	0965001563	tuananh@gmail.com	00000000	user	20194400	{00000020}
\.


--
-- TOC entry 3413 (class 0 OID 0)
-- Dependencies: 217
-- Name: news_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.news_new_id_seq', 4, true);


--
-- TOC entry 3224 (class 2606 OID 17874)
-- Name: author author_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author
    ADD CONSTRAINT author_pk PRIMARY KEY (author_id);


--
-- TOC entry 3242 (class 2606 OID 49452)
-- Name: book book_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pk PRIMARY KEY (book_id);


--
-- TOC entry 3238 (class 2606 OID 53266)
-- Name: borrow borrow_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrow
    ADD CONSTRAINT borrow_pk PRIMARY KEY (borrow_id);


--
-- TOC entry 3228 (class 2606 OID 17884)
-- Name: language language_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language
    ADD CONSTRAINT language_pk PRIMARY KEY (language_id);


--
-- TOC entry 3240 (class 2606 OID 47635)
-- Name: news news_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.news
    ADD CONSTRAINT news_pkey PRIMARY KEY (new_id);


--
-- TOC entry 3230 (class 2606 OID 17889)
-- Name: position position_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."position"
    ADD CONSTRAINT position_pk PRIMARY KEY (position_id);


--
-- TOC entry 3226 (class 2606 OID 17879)
-- Name: publisher publisher_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publisher
    ADD CONSTRAINT publisher_pk PRIMARY KEY (publisher_id);


--
-- TOC entry 3236 (class 2606 OID 17908)
-- Name: title title_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.title
    ADD CONSTRAINT title_pk PRIMARY KEY (title_id);


--
-- TOC entry 3232 (class 2606 OID 17894)
-- Name: type type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type
    ADD CONSTRAINT type_pk PRIMARY KEY (type_id);


--
-- TOC entry 3234 (class 2606 OID 17901)
-- Name: users user_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_pk PRIMARY KEY (user_id);


--
-- TOC entry 3251 (class 2620 OID 49633)
-- Name: title tg_add_book_when_insert_into_title; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tg_add_book_when_insert_into_title AFTER INSERT ON public.title FOR EACH ROW WHEN ((new.quantity > 0)) EXECUTE FUNCTION public.add_book();


--
-- TOC entry 3252 (class 2620 OID 49646)
-- Name: title tg_add_book_when_update_title; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tg_add_book_when_update_title AFTER UPDATE ON public.title FOR EACH ROW WHEN ((new.quantity > old.quantity)) EXECUTE FUNCTION public.add_book();


--
-- TOC entry 3253 (class 2620 OID 49754)
-- Name: title_infos tg_insert_into_title_infos; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tg_insert_into_title_infos INSTEAD OF INSERT ON public.title_infos FOR EACH ROW EXECUTE FUNCTION public.tf_for_insert_into_title_infos();


--
-- TOC entry 3254 (class 2620 OID 50032)
-- Name: title_infos tg_update_title_infos; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tg_update_title_infos INSTEAD OF UPDATE ON public.title_infos FOR EACH ROW EXECUTE FUNCTION public.tf_for_update_title_infos();


--
-- TOC entry 3250 (class 2606 OID 54975)
-- Name: book book_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_title_id_fkey FOREIGN KEY (title_id) REFERENCES public.title(title_id) ON UPDATE CASCADE;


--
-- TOC entry 3249 (class 2606 OID 53319)
-- Name: borrow borrow_book_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrow
    ADD CONSTRAINT borrow_book_fk FOREIGN KEY (book_id) REFERENCES public.book(book_id) NOT VALID;


--
-- TOC entry 3248 (class 2606 OID 45327)
-- Name: borrow borrow_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrow
    ADD CONSTRAINT borrow_user_fk FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 3243 (class 2606 OID 49606)
-- Name: title title_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.title
    ADD CONSTRAINT title_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.author(author_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3245 (class 2606 OID 49618)
-- Name: title title_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.title
    ADD CONSTRAINT title_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.language(language_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3246 (class 2606 OID 49623)
-- Name: title title_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.title
    ADD CONSTRAINT title_position_id_fkey FOREIGN KEY (position_id) REFERENCES public."position"(position_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3244 (class 2606 OID 49613)
-- Name: title title_publisher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.title
    ADD CONSTRAINT title_publisher_id_fkey FOREIGN KEY (publisher_id) REFERENCES public.publisher(publisher_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3247 (class 2606 OID 49628)
-- Name: title title_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.title
    ADD CONSTRAINT title_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.type(type_id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2022-02-05 20:13:22

--
-- PostgreSQL database dump complete
--


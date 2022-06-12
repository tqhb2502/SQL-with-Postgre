CREATE DATABASE education;
\c education

CREATE SCHEMA store;

CREATE TABLE store.student(
	student_id CHARACTER(8) NOT NULL,
	first_name CHARACTER VARYING(20) NOT NULL,
	last_name CHARACTER VARYING(20) NOT NULL,
	dob DATE NOT NULL,
	gender CHARACTER(1),
	address CHARACTER VARYING(30),
	note TEXT,
	clazz_id CHARACTER(8),
	CONSTRAINT student_pk PRIMARY KEY(student_id),
	CONSTRAINT student_gender_chk CHECK(gender = 'F' OR gender = 'M')
);

CREATE TABLE store.subject(
	subject_id CHARACTER(6) NOT NULL,
	name CHARACTER VARYING(30) NOT NULL,
	credit INTEGER NOT NULL,
	percentage_final_exam INTEGER NOT NULL,
	CONSTRAINT subject_pk PRIMARY KEY(subject_id),
	CONSTRAINT subject_credit_chk CHECK(1 <= credit AND credit <= 5),
	CONSTRAINT subject_percentage_chk CHECK(0 <= percentage_final_exam AND percentage_final_exam <= 100)
);

CREATE TABLE store.lecturer(
	lecturer_id CHARACTER(5) NOT NULL,
	first_name CHARACTER VARYING(20) NOT NULL,
	last_name CHARACTER VARYING(20) NOT NULL,
	dob DATE NOT NULL,
	gender CHARACTER(1),
	address CHARACTER VARYING(30),
	email CHARACTER VARYING(40),
	CONSTRAINT lecturer_pk PRIMARY KEY(lecturer_id),
	CONSTRAINT lecturer_gender_chk CHECK(gender = 'F' OR gender = 'M')
);

CREATE TABLE store.teaching(
	subject_id CHARACTER(6) NOT NULL,
	lecturer_id CHARACTER(5) NOT NULL,
	CONSTRAINT teaching_pk PRIMARY KEY(subject_id, lecturer_id)
);

CREATE TABLE store.clazz(
	clazz_id CHARACTER(8) NOT NULL,
	name CHARACTER VARYING(20),
	lecturer_id CHARACTER(5),
	monitor_id CHARACTER(8),
	CONSTRAINT clazz_pk PRIMARY KEY(clazz_id)
);

CREATE TABLE store.enrollment(
	student_id CHARACTER(8) NOT NULL,
	subject_id CHARACTER(6) NOT NULL,
	semester CHARACTER(5) NOT NULL,
	midterm_score FLOAT,
	final_score FLOAT,
	CONSTRAINT enrollment_pk PRIMARY KEY(student_id, subject_id, semester),
	CONSTRAINT enrollment_midterm_chk CHECK(0 <= midterm_score AND  midterm_score <= 10),
	CONSTRAINT enrollment_final_chk CHECK(0 <= final_score AND final_score <= 10)
);

ALTER TABLE store.student
ADD CONSTRAINT student_clazz_fk FOREIGN KEY(clazz_id) REFERENCES store.clazz(clazz_id);

ALTER TABLE store.teaching
ADD CONSTRAINT teaching_subject_fk FOREIGN KEY(subject_id) REFERENCES store.subject(subject_id);

ALTER TABLE store.teaching
ADD CONSTRAINT teaching_lecturer_fk FOREIGN KEY(lecturer_id) REFERENCES store.lecturer(lecturer_id);

ALTER TABLE store.clazz
ADD CONSTRAINT clazz_lecturer_fk FOREIGN KEY(lecturer_id) REFERENCES store.lecturer(lecturer_id);

ALTER TABLE store.clazz
ADD CONSTRAINT clazz_monitor_fk FOREIGN KEY(monitor_id) REFERENCES store.student(student_id);

ALTER TABLE store.enrollment
ADD CONSTRAINT enrollment_student_fk FOREIGN KEY(student_id) REFERENCES store.student(student_id);

ALTER TABLE store.enrollment
ADD CONSTRAINT enrollment_subject_fk FOREIGN KEY(subject_id) REFERENCES store.subject(subject_id);

ALTER TABLE store.student
ADD CONSTRAINT student_dob_chk CHECK(
	16 <= DATE_PART('year', CURRENT_DATE) - DATE_PART('year', dob)
	AND
	DATE_PART('year', CURRENT_DATE) - DATE_PART('year', dob) <= 35
);

ALTER TABLE store.lecturer
ADD CONSTRAINT lecturer_dob_chk CHECK(
	22 <= DATE_PART('year', CURRENT_DATE) - DATE_PART('year', dob)
	AND
	DATE_PART('year', CURRENT_DATE) - DATE_PART('year', dob) <= 65
);

INSERT INTO store.lecturer VALUES ('02001', 'Việt Trung', 'Trần', '1984/6/2', 'M', '147 Linh Đàm, HN', 'trungtv@soict.hust.edu.vn');
INSERT INTO store.lecturer VALUES ('02002', 'Tuyết Trinh', 'Vũ', '1975/10/1', 'F', NULL, 'trinhvt@soict.hust.edu.vn');
INSERT INTO store.lecturer VALUES ('02003', 'Linh', 'Trương', '1976/9/8', 'F', 'Hà Nội', NULL);
INSERT INTO store.lecturer VALUES ('02004', 'Quang Khoát', 'Thân', '1982/10/8', 'M', 'Hà Nội', 'khoattq@soict.hust.edu.vn');
INSERT INTO store.lecturer VALUES ('02005', 'Oanh', 'Nguyễn', '1978/2/18', 'F', 'HBT, HN', 'oanhnt@soict.hust.edu.vn');
INSERT INTO store.lecturer VALUES ('02006', 'Nhật Quang', 'Nguyễn', '1976/4/16', 'M', 'HBT, HN', 'quangnn@gmail.com');
INSERT INTO store.lecturer VALUES ('02007', 'Hồng Phương', 'Nguyễn', '1984/3/12', 'M', '17A Tạ Quang Bửu, HBT, HN', 'phuongnh@gmail.com');

INSERT INTO store.clazz VALUES ('20162101', 'CNTT1.01-K61', NULL, NULL);
INSERT INTO store.clazz VALUES ('20162102', 'CNTT1.02-K61', NULL, NULL);
INSERT INTO store.clazz VALUES ('20172201', 'CNTT2.01-K62', NULL, NULL);
INSERT INTO store.clazz VALUES ('20172202', 'CNTT2.02-K62', NULL, NULL);

INSERT INTO store.student VALUES ('20160001', 'Ngọc An', 'Bùi', '1987/3/18', 'M', '15 Lương Định Của, Đ.Đa, HN', NULL, NULL);
INSERT INTO store.student VALUES ('20160002', 'Anh', 'Hoàng', '1987/5/20', 'M', '513 B8 KTX BKHN', NULL, '20162101');
INSERT INTO store.student VALUES ('20160003', 'Thu Hồng', 'Trần', '1987/6/6', 'F', '15 Trần Đại Nghĩa, HBT, Hà Nội', NULL, '20162101');
INSERT INTO store.student VALUES ('20160004', 'Minh Anh', 'Nguyễn', '1987/5/20', 'F', '513 TT Phương Mai, Đ.Đa, HN', NULL, '20162101');
INSERT INTO store.student VALUES ('20170001', 'Nhật Ánh', 'Nguyễn', '1988/5/15', 'F', '214 B6 KTX BKHN', NULL, '20172201');

UPDATE store.clazz SET lecturer_id = '02001', monitor_id = '20160003' WHERE clazz_id = '20162101';
UPDATE store.clazz SET lecturer_id = '02002', monitor_id = '20170001' WHERE clazz_id = '20172201';

SELECT * FROM store.lecturer;
SELECT * FROM store.student;
SELECT * FROM store.clazz;


select * from clazz;
select * from enrollment;
select * from grade;
select * from lecturer;
select * from student;
select * from subject;
select * from teaching;

-- 1. Danh sách môn học có từ 3 tín chỉ trở lên
select *
from subject
where credit >= 3;

-- 2. Danh sách học sinh trong lớp có tên CNTT1.01-K61
select *
from student
where clazz_id = (select clazz_id from clazz where name = 'CNTT1.01-K61');

-- 3. Danh sách học sinh trong các lớp mà tên có chứa CNTT
select *
from student
where clazz_id in (select clazz_id from clazz where name like '%CNTT%');

-- 4. Danh sách sinh viên đăng kí cả 2 môn Cơ sở dữ liệu và Mạng máy tính.
select s.student_id, s.first_name, s.last_name
from student as s inner join enrollment as e on s.student_id = e.student_id
where subject_id = (select subject_id from subject where name = 'Cơ sở dữ liệu')
intersect
select s.student_id, s.first_name, s.last_name
from student as s inner join enrollment as e on s.student_id = e.student_id
where subject_id = (select subject_id from subject where name = 'Mạng máy tính')
order by student_id;

-- 5. Danh sách sinh viên đăng kí cả 2 môn Cơ sở dữ liệu hoặc Tin học đại cương.
select s.student_id, s.first_name, s.last_name
from student as s inner join enrollment as e on s.student_id = e.student_id
where subject_id = (select subject_id from subject where name = 'Cơ sở dữ liệu')
union
select s.student_id, s.first_name, s.last_name
from student as s inner join enrollment as e on s.student_id = e.student_id
where subject_id = (select subject_id from subject where name = 'Tin học đại cương')
order by student_id;

-- 6. Danh sách môn học không được học sinh nào đăng kí
select subject_id, name
from subject
where subject_id not in (select s.subject_id
	from subject as s inner join enrollment as e on s.subject_id = e.subject_id);

select subject_id, name
from subject
where subject_id not in (select subject_id from enrollment);
	
select s.subject_id, s.name
from subject as s left join enrollment as e on s.subject_id = e.subject_id
group by s.subject_id
having count(student_id) = 0;

-- 7. Danh sách các môn học (tên môn, số tín chỉ) mà học sinh Bùi Ngọc An đăng kí trong học kỳ 20171.
select sj.name, sj.credit
from (select student_id from student as s where s.first_name = 'Ngọc An' and s.last_name = 'Bùi') as tmp
	inner join enrollment as e on tmp.student_id = e.student_id
	inner join subject as sj on e.subject_id = sj.subject_id
where semester = '20171';

-- 8. Danh sách học sinh đăng kí môn Cơ sở dữ liệu trong học kỳ 20172 (student_id, student name, midterm score,
-- final exam score, subject score)
select s.student_id, s.first_name, s.last_name, e.midterm_score, e.final_score, e.midterm_score *
(100 - percentage_final_exam) / 100 + e.final_score * percentage_final_exam / 100 as subject_score
from (select * from subject where name = 'Cơ sở dữ liệu') as tmp
	inner join enrollment as e on tmp.subject_id = e.subject_id
	inner join student as s on s.student_id = e.student_id
where semester = '20172';

-- 9. Danh sách học sinh (student_id) trượt môn có mã IT1110 trong học kỳ 20171
select st.student_id
from (select * from subject where subject_id = 'IT1110') as sj
	inner join enrollment as e on e.subject_id = sj.subject_id
	inner join student as st on e.student_id = st.student_id
where semester = '20171' and (midterm_score < 3 or final_score < 3 or (midterm_score *
	(100 - percentage_final_exam) / 100 + final_score * percentage_final_exam / 100) < 4);

-- 10. Danh sách học sinh cùng với tên lớp và tên lớp trưởng
select st.student_id, st.first_name, st.last_name, cl.name, st2.last_name||' '||st2.first_name as monitor_name
from student as st
	left join clazz as cl on st.clazz_id = cl.clazz_id
	left join student as st2 on cl.monitor_id = st2.student_id;


-- 1.
SELECT department_name "학과 명",  category 계열
FROM tb_department;

-- 2.
SELECT department_name || '의 정원은' AS "학과별 정원" , capacity || '입니다.'
FROM tb_department;

-- 3.
SELECT student_name
FROM tb_student
JOIN tb_department USING(department_no)
WHERE ABSENCE_YN = 'Y' AND department_name = '국어국문학과' AND tb_student.student_ssn LIKE '_______2%';

-- 4.
SELECT student_name, student_no
FROM tb_student
WHERE student_no LIKE 'A513%'
ORDER BY student_name DESC;

-- 5.
SELECT department_name "학과 명",  category 계열
FROM tb_department
WHERE capacity BETWEEN 20 AND 30;

-- 6.
SELECT professor_name
FROM tb_professor 

WHERE department_no IS NULL;

-- 7.
SELECT student_name
FROM tb_student
WHERE department_no IS NULL;

-- 8.
SELECT class_no
FROM tb_class
WHERE tb_class.preattending_class_no IS NOT NULL;

-- 9.
SELECT DISTINCT category
FROM tb_department;

-- 10.
SELECT student_no, student_name, SUBSTR(student_ssn,9 ,2)
FROM tb_student
WHERE entrance_date LIKE '02/%%/%%' AND ABSENCE_YN = 'N' AND student_address LIKE '%전주%'
ORDER BY student_name;

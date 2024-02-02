-- 1.
SELECT
    student_no                           학번,
    student_name                         이름,
    to_char(entrance_date, 'rrrr-mm-dd') 입학년도
FROM
    tb_student
WHERE
    department_no = '002'
ORDER BY
    입학년도;

-- 2.
SELECT
    professor_name,
    professor_ssn
FROM
    tb_professor
--WHERE professor_name LIKE '__' OR professor_name LIke '____';
WHERE
    professor_name NOT LIKE '___';

-- 3 
SELECT
    professor_name
FROM
    tb_professor
WHERE
    professor_ssn LIKE '_______1%'
ORDER BY
    professor_ssn DESC;
 
-- 4
SELECT
    substr(professor_name, 2) 이름
FROM
    tb_professor;
    
-- 5
SELECT
    student_no,
    student_name,
    TO_NUMBER(substr(student_ssn, 1, 2)) + 1900                           태어남,
    TO_NUMBER(to_char(entrance_date, 'RRRR'))                             입합,
    to_char(entrance_date, 'RRRR') - ( substr(student_ssn, 1, 2) + 1900 ) 입학태어남
FROM
    tb_student
WHERE
    to_char(entrance_date, 'RRRR') - ( substr(student_ssn, 1, 2) + 1900 ) > 19
ORDER BY
    student_no;

-- 6
SELECT
    to_char(TO_DATE('20/12/25'),
            'day')
FROM
    dual;

-- 7.
SELECT
    to_char(TO_DATE('99/10/11', 'YY/MM/DD'), 'yyyy"년"mm"월"dd"일"'),
    to_char(TO_DATE('49/10/11', 'YY/MM/DD'), 'yyyy"년"mm"월"dd"일"'),
    to_char(TO_DATE('99/10/11', 'YY/MM/DD'), 'yyyy"년"mm"월"dd"일"'),
    to_char(TO_DATE('49/10/11', 'YY/MM/DD'), 'yyyy"년"mm"월"dd"일"')
FROM
    dual;
    
-- 8.
SELECT
    student_no,
    student_name
FROM
    tb_student
WHERE
    student_no NOT LIKE 'A%'
ORDER BY
    1;

-- 9.
SELECT
    round(AVG(point),
          1)
FROM
         tb_student
    JOIN tb_grade USING ( student_no )
WHERE
    student_name = '한아름';
    
-- 10
SELECT
    department_no 학과번호,
    COUNT(department_no)
FROM
    tb_student
GROUP BY
    department_no
ORDER BY
    학과번호;

-- 11
SELECT
    COUNT(*)
FROM
    tb_student
WHERE
    coach_professor_no IS NULL;
    
-- 12
SELECT
    substr(term_no, 1, 4) "년도",
    ROUND(AVG(point), 1)            "년도 별 평점"
FROM
    tb_grade
WHERE
    student_no LIKE 'A112113'
GROUP BY
    substr(term_no, 1, 4)
ORDER BY
    년도;

-- 13
SELECT
    department_no AS 학과코드명,
    COUNT(CASE WHEN absence_yn = 'Y' THEN 1 ELSE NULL END) AS 결석횟수
FROM
    tb_student
GROUP BY
    department_no
ORDER BY
    학과코드명;

-- 14
SELECT
    student_name  동일이름,
    COUNT(student_name) 동명인수
FROM
    tb_student
GROUP BY
    student_name
HAVING
    COUNT(student_name) > 1
ORDER BY
    student_name;

-- 15
SELECT
    substr(term_no, 1, 4) 년도,
    substr(term_no, 5, 2) 학기,    
    ROUND(AVG(point), 1)           평점
FROM
    tb_grade
WHERE
    student_no LIKE 'A112113'
GROUP BY
    ROLLUP(substr(term_no, 1, 4)), ROLLUP(substr(term_no, 5, 2))
ORDER BY
    년도, 학기;

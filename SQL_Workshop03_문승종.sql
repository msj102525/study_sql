-- 1.
SELECT
    student_name,
    student_address
FROM
    tb_student
ORDER BY
    student_name;
    
-- 2.
SELECT
    student_name,
    student_ssn
FROM
    tb_student
WHERE
    absence_yn = 'Y'
ORDER BY
    trunc((months_between(sysdate,
                          TO_DATE(substr(student_ssn, 1, 4),
                                  'rrmm')) / 12));

-- 3
SELECT
    student_name    �л��̸�,
    student_no      �й�,
    student_address �������ּ�
FROM
    tb_student
WHERE
    student_address LIKE ( '������%' )
    OR student_address LIKE ( '��⵵%' )
    AND student_no NOT LIKE 'A%';

-- 4
SELECT
    professor_name,
    professor_ssn
FROM
    tb_professor
WHERE
    department_no = '005'
ORDER BY
    professor_ssn;

-- 5
SELECT
    student_no,
    point
FROM
    tb_grade
WHERE
    class_no LIKE 'C3118100'
    AND term_no LIKE '200402'
ORDER BY
    point DESC;

-- 6
SELECT
    student_no,
    student_name,
    department_name
FROM
    tb_student
    LEFT JOIN tb_department USING ( department_no )
ORDER BY
    student_name;
   
-- 7
SELECT
    class_name,
    department_name
FROM
    tb_department
    LEFT JOIN tb_class USING ( department_no )
ORDER BY
    department_name;

-- 8
SELECT
    class_name,
    professor_name
FROM
         tb_class
    JOIN tb_class_professor USING ( class_no )
    JOIN tb_professor USING ( professor_no );

-- 9
SELECT
    c.class_name,
    p.professor_name
FROM
         tb_class c
    JOIN tb_class_professor cp ON c.class_no = cp.class_no
    JOIN tb_professor       p ON cp.professor_no = p.professor_no
    JOIN tb_department      d ON c.department_no = d.department_no
WHERE
    d.category = '�ι���ȸ';

-- 10
SELECT
    s.student_no �й�,
    s.student_name "�л� �̸�",
    ROUND(AVG(g.point), 1) "��ü ���",
    d.department_name
FROM
         tb_student s
    JOIN tb_grade      g ON g.student_no = s.student_no
    JOIN tb_department d ON s.department_no = d.department_no
WHERE
    department_name LIKE '�����а�'
GROUP BY
    s.student_no,
    s.student_name,
    d.department_name
ORDER BY
    "��ü ���" DESC;
    
-- 11
SELECT
    d.department_name �а��̸�,
    s.student_name �л��̸�,
--    s.coach_professor_no ����������ȣ,
    p.professor_name ���������̸�
FROM tb_student s
JOIN tb_department d ON d.department_no =  s.department_no
JOIN tb_professor p ON p.professor_no = s.coach_professor_no
WHERE
    s.student_no LIKE 'A313047';
    
-- 12
SELECT
    s.student_name,
    g.term_no
FROM
    tb_student s
JOIN tb_grade g ON g.student_no = s.student_no
JOIN tb_class c ON c.class_no = g.class_no
WHERE c.class_name = '�ΰ������'
    AND substr(term_no,1,4) LIKE '2007%'
ORDER BY
    student_name;
    
--13
SELECT
    c.class_name,
    d.department_name
FROM
    tb_class c
JOIN tb_department d ON d.department_no = c.department_no
LEFT JOIN tb_class_professor cp ON c.class_no = cp.class_no
LEFT JOIN tb_professor p ON cp.professor_no = p.professor_no
WHERE
    d.category LIKE '��ü��'
    AND p.professor_name IS NULL;



    
    
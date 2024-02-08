-- 14.
SELECT
    student_name,
    nvl(professor_name, '�������� ������')
FROM
    tb_student   s
    LEFT JOIN tb_professor p ON s.coach_professor_no = p.professor_no
--JOIN department d ON USING (dept_id)
WHERE
    s.department_no = (
        SELECT
            department_no
        FROM
            tb_department
        WHERE
            department_name = '���ݾƾ��а�'
    );
            
-- 15
SELECT
    s.student_no      �й�,
    s.student_name    �̸�,
    d.department_name "�а� �̸�",
    AVG(g.point)      ����
FROM
         tb_student s
    JOIN tb_grade      g ON g.student_no = s.student_no
    JOIN tb_department d ON d.department_no = s.department_no
WHERE
    s.absence_yn = 'N'
GROUP BY
    s.student_no,
    s.student_name,
    d.department_name
HAVING
    4 <= AVG(g.point)
ORDER BY
    s.student_name;

-- 16
SELECT
    c.class_no,
    c.class_name,
    AVG(g.point)
FROM
         tb_class c
    JOIN tb_grade g ON c.class_no = g.class_no
WHERE
        c.department_no = (
            SELECT
                department_no
            FROM
                tb_department
            WHERE
                department_name = 'ȯ�������а�'
        )
    AND c.class_type = '��������'
GROUP BY
    c.class_no,
    c.class_name;

-- 17
SELECT
    student_name,
    student_address
FROM
         tb_student s
    JOIN tb_department d ON s.department_no = d.department_no
WHERE
    s.department_no = (
        SELECT
            department_no
        FROM
            tb_student
        WHERE
            student_name = '�ְ���'
    );
 
-- 18
SELECT
    s.student_no,
    s.student_name
FROM
    tb_student s
JOIN tb_grade g ON g.student_no = s.student_no
JOIN tb_department d ON d.department_no = s.department_no
WHERE d.department_name = '������а�' 
GROUP BY
    s.student_no, s.student_name,d.department_name
ORDER BY ��� DESC
FETCH FIRST 1 ROWS ONLY;

-- 19
SELECT
    d.department_name,
    TRUNC(AVG(g.point),1)
FROM
    tb_department d
JOIN tb_class c ON d.department_no = c.department_no
JOIN tb_grade g ON g.class_no = c.class_no
WHERE 
    d.category IN (
        SELECT
            d.category
        FROM tb_class c
        JOIN tb_department d ON d.department_no = c.department_no
        WHERE d.department_name = 'ȯ�������а�'
    ) AND c.class_type = '��������'
GROUP BY
    d.department_name;
    


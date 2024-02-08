-- 7_SELECT_06(HAVING).sql

-- SELECT���� ": HAVING �� ------------------------------------------------------
-- �����ġ : GROUP BY �� ������ �ۼ���
-- �ۼ� ���� : HAVING �׷��Լ�(��꿡 ����� �÷���) �񱳿����� �񱳰�
-- �׷캰�� �׷��Լ� ������� ������ ������ �����ϴ� �׷��� ���
-- ��� �׷�� ������� SELECT ���� ǥ����

-- �μ��� �޿��հ� �� ���� ū �� ��ȸ
SELECT
    MAX(SUM(salary)) -- 1�� : 18100000
FROM
    employee
GROUP BY
    dept_id;

-- �μ��ڵ嵵 �Բ� ��ȸ�ϰ� �Ѵٸ�
SELECT
    dept_id,
    MAX(SUM(salary)) -- 1�� : 18100000
FROM
    employee
GROUP BY
    dept_id;

SELECT
    dept_id, -- 7��, err
    MAX(SUM(salary)) -- 1�� , err : 2���� �簢�� ���̺��� �ƴ�
FROM
    employee
GROUP BY
    dept_id;

-- �μ��� �޿��հ� �� ���� ū���� ���� �μ��ڵ�� �޿��հ踦 ��ȸ
SELECT
    dept_id,
    SUM(salary)
FROM
    employee
GROUP BY
    dept_id
HAVING
--    SUM(salary) = 18100000;
    SUM(salary) = (
        SELECT
            MAX(SUM(salary))
        FROM
            employee
        GROUP BY
            dept_id
    );
    
-- �м��Լ� (������ �Լ���� ��) --------------------------------------
-- �Ϲ��Լ��� ��������� �ٸ�

-- RANK() �Լ�
-- ����(���) ��ȯ

-- 1. ��ü �÷����� ���� ���� �ű��
-- RANK() OVER (ORDER BY �����ű� �÷��� ���Ĺ��)

-- �޿��� ���� �޴� ������ ������ �ű�ٸ� (ū���� 1�� : ��������)
SELECT
    emp_name,
    salary,
    RANK()
    OVER(
        ORDER BY
            salary DESC
    ) ����
FROM
    employee
ORDER BY
    ����;
    
-- 2. �����ϴ� �÷����� ������ Ȯ���ϴ� �뵵�� ���
-- RANK(������ �˰��� �ϴ� ��) WHITHIN GROUP (ORDER BY �����ű��÷��� ���Ĺ��)

-- �޿� 230���� ��ü �޿��� �����? (�޿� �������������� ���)
SELECT
    RANK(2300000) WITHIN GROUP(ORDER BY salary DESC)
FROM
    employee;

-- ROWID
-- ���̺� ������ �����(�� �߰���, INSERT��) �������� �ٿ���
-- DBMS�� �ڵ����� ����, ���� �� ��, ��ȸ�� �� �� ����
SELECT
    emp_id,
    ROWID
FROM
    employee;

-- ROWNUM
-- ROWID�� �ٸ�
-- ROWNUM�� SELECT�� ����� ����࿡ �ο��Ǵ� �������. ( 1���� ����)
-- �ζ��κ�(FROM ���� ���� ���������� �����)�� ����ϸ� ROWNUM�� Ȯ�� �Ǵ� ����� ���� ����
SELECT
    *
FROM
    (
        SELECT
            ROWNUM rnum,
            emp_id,
            job_id
        FROM
            employee
        WHERE
            job_id = 'J5'
    )
WHERE
    rnum > 2;
    
-- ******************************************************************************************************
-- ����( JOIN)
-- ���� ���� ���̺���� �ϳ��� ���ļ� ū ���̺��� ����� ��
-- ������ ��� ���̺��� ���ϴ� �÷��� ������
-- ����Ŭ ���� ������ ANSI ǥ�� �������� ������ �� ����
-- ���� �⺻ EQUAL JOIN �� (���� ������ ������)
-- => EQUAL�� �ƴ� ���� ���� ���� ���ο��� ���ܵ�
-- �� ���̺��� FOREIGN KEY (�ܷ�Ű | �ܺ�Ű)�� ����� �÷������� ��ġ�ϴ� ����� ����Ǵ� ������

-- ����Ŭ ���� ���� : ����Ŭ������ �����
-- FROM ���� ������(��ĥ) ���̺���� ������
-- WHERE ���� ��ĥ �÷��� ���� ������ �����
-- ���� : �Ϲ� ���ǰ� ���� >> WHERE ���� ��������

SELECT
    *
FROM
    employee,
    department
WHERE
    employee.dept_id = department.dept_id;
-- ����� : 20�� : EMPLOYEE�� DEPT_ID�� NULL�� ���� 2�� ���� ��
-- EQUAL INNER JOIN �̶�� ��

-- ���νÿ� ���̺� ��Ī(ALIAS)�� ���� �� ����
SELECT
    *
FROM
    employee   e,
    department d
WHERE
    e.dept_id = d.dept_id;

-- �����̸�, �μ��ڵ�, �μ��� ��ȸ
SELECT
    e.emp_name,
    e.dept_id,
    d.dept_name
FROM
    employee   e,
    department d
WHERE
    e.dept_id = d.dept_id;

SELECT
    emp_name,
    e.dept_id,
    dept_name
FROM
    employee   e,
    department d
WHERE
    e.dept_id = d.dept_id;

-- ASSI ǥ�� ����
-- ��� DBMS�� �������� ����ϴ� ǥ�ر�����
-- ���� ó���� ���� ������ ������ �ۼ��� => FROM ���� JOIN Ű���带 �߰��ؼ�
-- ���� ������ WHERE ������ �и���

SELECT
    *
FROM
         employee
    JOIN department USING ( dept_id );

SELECT
    emp_id,
    dept_id,
    dept_name
FROM
         employee
--    JOIN department USING ( dept_id );
    INNER JOIN department USING ( dept_id ); -- INNER �����ص� ��
-- ���ο� ���� �÷�(DEPT_ID)�� �Ѱ� ������, �� �տ� ù��°�� ǥ�õ� : ����Ŭ ���뱸���� �ٸ�����

-- ������ �⺻�� EQUAL INNER JOIN ��
-- �� ���̺��� �����ϴ� �÷��� ���� EQUAL �� ����� �����Ű�鼭 �����ϴ� ����
-- INNER JOIN �� EQUAL�� �ƴ� ���� ���ܵ�

-- ���νÿ� ���Ǵ� �� ���̺��� �÷����� ������ USING �����
-- ���� ���� ������ �÷��� �ٸ��� ON �����

-- USING ��� �� :
SELECT
    emp_name,
    dept_name
FROM
         employee
    JOIN department USING ( dept_id )
WHERE
    job_id = 'J6'
ORDER BY
    dept_name DESC;

-- ON ��� ��
SELECT
    *
FROM
         department
    JOIN location ON ( loc_id = location_id );

-- ���� ������ ����Ŭ ���뱸������ �ٲ۴ٸ�
SELECT
    *
FROM
    department d,
    location   l
WHERE
    d.loc_id = l.location_id;
    
-- ���, �̸�, ���޸� ��ȸ : ��Ī
-- ����Ŭ ���� ����
SELECT
    emp_id,
    emp_name,
    job_title
FROM
    employee e,
    job      j
WHERE
    e.job_id = j.job_id;
    
-- ANSI ǥ�� ����
SELECT
    emp_id,
    emp_name,
    job_title
FROM
         employee
    JOIN job USING ( job_id );

-- OUTER JOIN
-- �⺻�� EQUAL INNER JOIN + ���� ��ġ���� �ʴ� �൵ ���Խ�Ű�� ����
-- OUTER JOIN�� EQUAL JOIN �� => ���� ���� �ִ� ���̺� ���� �߰���

-- EMPLOYEE ���̺��� �� ������ ������ ���� ����� ���Խ�Ű���� �Ѵٸ�
-- ����Ŭ ���뱸�� : ���� ���� ���̺� ���� �߰��ϴ� ����� => (+)
SELECT
    *
FROM
    employee   e,
    department d
WHERE
    e.dept_id = d.dept_id (+);

-- ANSI ǥ�ر���
SELECT
    *
FROM
    employee
--LEFT OUTER JOIN department USING (dept_id);
    LEFT JOIN department USING ( dept_id );

-- DEPARTMENT ���̺��� ���� ��� ���� ���ο� ���Խ�Ű����
-- ����Ŭ ���뱸��
SELECT
    *
FROM
    employee   e,
    department d
WHERE
    e.dept_id (+) = d.dept_id;

-- ANSI ǥ�ر���
SELECT
    *
FROM
    employee e
    RIGHT JOIN department USING ( dept_id );
    
-- �� ���̺��� ��ġ���� �ʴ� ���� ��� �� ���ο� ���Խ�Ű����
-- FULL OUTER JOIN �̶�� ��

-- ����Ŭ ���뱸������ FULL OUTER JOIN �� �������� ����
SELECT
    *
FROM
    employee   e,
    department d
WHERE
    e.dept_id (+) = d.dept_id (+); -- ERROR
    
-- ANSI ǥ�ر���
SELECT
    *
FROM
         employee
--    FULL OUTER JOIN department USING ( dept_id ); -- 23��
          full
    JOIN department USING ( dept_id ); -- 23��
    
-- CROSS JOIN ------------------------------------------------------
-- �� ���̺��� ������ �÷��� ���� �� ���
-- ���̺�1 N�� * ���̺�2 M��

-- ANSI
SELECT
    *
FROM
         location
    CROSS JOIN country;

-- ����Ŭ ���뱸��
SELECT
    *
FROM
    location,
    country;

-- NATURAL JOIN ----------------------------------------------------
-- ���̺��� ���� PRIMARY KEY �÷��� �̿��ؼ� ������ ��
SELECT
    *
FROM
         employee
    NATURAL JOIN department; -- PRIMARY KEY �÷��� DEPT_ID ����
-- JOIN DEPARTMENT USING (DEPT_ID); �� ����� ����

-- NON EQUI JOIN
-- �����ϴ� �÷��� ���� ��ġ�ϴ� ��찡 �ƴ� ���� ������ �ش��ϴ� ����� �����ϴ� ����� ������
-- JOIN ON �����

SELECT
    *
FROM
         employee
    JOIN sal_grade ON ( salary BETWEEN lowest AND highest );

SELECT
    emp_name,
    salary,
    slevel
FROM
         employee
    JOIN sal_grade ON ( salary BETWEEN lowest AND highest );

-- SELF JOIN
-- ���� ���̺��� �����ϴ� ���
-- ���� ���̺� �ȿ� �ٸ� �÷��� �����ϴ� �ܷ�Ű(FOREIGN KEY)�� ���� �� �����
-- EMP_ID : ������ ��� => MGR_ID : ������ ��� - EMP_ID �÷��� ������ �翵(����)�ϴ� �÷�
-- ������ : ���� �߿��� �������� ������ �����Ѵ��� �ǹ���

-- �����ڰ� ������ ������ ��ܰ� �������� ���� ���� ��ȸ
-- ANSI ǥ�ر��� : SELF JOIN �� ���̺� ��Ī ����ؾ� ��. ON �����
SELECT
    *
FROM
         employee e
    JOIN employee m ON ( e.mgr_id = m.emp_id ); -- 15��

SELECT
    e.emp_name,
    m.emp_id
FROM
         employee e
    JOIN employee m ON ( e.mgr_id = m.emp_id );

-- �������� ���� ���
SELECT DISTINCT
    m.emp_name
FROM
         employee e
    JOIN employee m ON ( e.mgr_id = m.emp_id );

-- ����Ŭ ���뱸��
SELECT
    *
FROM
    employee e,
    employee m
WHERE
    e.mgr_id = m.emp_id;

SELECT
    e.emp_name ����,
    m.emp_name ������
FROM
    employee e,
    employee m
WHERE
    e.mgr_id = m.emp_id;

-- �������� ���� ���
SELECT DISTINCT
    m.emp_name ������
FROM
    employee e,
    employee m
WHERE
    e.mgr_id = m.emp_id;

-- N���� ���̺� ����
-- ���� ������ �߿���
-- ù��° ���̺�� �ι�° ���̺��� ���εǰ� ����, �� ����� ����° ���̺��� ���ε�

SELECT
    emp_name,
    job_title,
    dept_name
FROM
    employee
    LEFT JOIN job USING ( job_id )
    LEFT JOIN department USING ( dept_id );

SELECT
    *
FROM
    employee
    LEFT JOIN location ON ( location_id = loc_id )
    LEFT JOIN department USING ( dept_id ); -- ERROR

SELECT
    *
FROM
    employee
    LEFT JOIN department USING ( dept_id )
    LEFT JOIN location ON ( location_id = loc_id );
    
-- �����̸�, ���޸�, �μ���, ������, ������ ��ȸ
-- ���� ��ü ��ȸ��
-- ANSI ǥ�ر���
SELECT
    emp_name,
    job_title,
    dept_name,
    loc_describe,
    country_name
FROM
    employee
    LEFT JOIN job USING ( job_id )
    LEFT JOIN department USING ( dept_id )
    LEFT JOIN location ON ( location_id = loc_id )
    LEFT JOIN country USING ( country_id );

-- ����Ŭ ���뱸��
SELECT
    emp_name,
    job_title,
    dept_name,
    loc_describe,
    country_name
FROM
    employee   e,
    job        j,
    department d,
    location   l,
    country    c
WHERE
        e.job_id = j.job_id (+)
    AND e.dept_id = d.dept_id (+)
    AND d.loc_id = l.location_id (+)
    AND l.country_id = c.country_id (+);

-- ***********************************************************

--JOIN ��������
--1. 2020�� 12�� 25���� ���� �������� ��ȸ�Ͻÿ�.
SELECT
    to_char(TO_DATE('20/12/25'),
            'day')
FROM
    dual;
    
--2. �ֹι�ȣ�� 60��� ���̸鼭 ������ �����̰�, ���� �达�� �������� 
--�����, �ֹι�ȣ, �μ���, ���޸��� ��ȸ�Ͻÿ�.
-- ANSI
SELECT
    emp_name  �����,
    emp_no    �ֹι�ȣ,
    dept_name �μ���,
    job_title ���޸�
FROM
         employee
    JOIN department USING ( dept_id )
    JOIN job USING ( job_id )
WHERE
    substr(emp_no, 8, 1) IN ( 2, 4 )
    AND substr(emp_no, 1, 2) BETWEEN 60 AND 69
    AND emp_name LIKE '��%';

-- ����Ŭ
SELECT
    emp_name  �����,
    emp_no    �ֹι�ȣ,
    dept_name �μ���,
    job_title ���޸�
FROM
    employee   e,
    department d,
    job        j
WHERE
        d.dept_id = e.dept_id
    AND j.job_id = e.job_id
    AND substr(emp_no, 8, 1) IN ( 2, 4 )
    AND substr(emp_no, 1, 2) BETWEEN 60 AND 69
    AND emp_name LIKE '��%';
    
--3. ���� ���̰� ���� ������ ���, �����, ����, �μ���, ���޸��� ��ȸ�Ͻÿ�.
-- ANSI
SELECT
    emp_id               ���,
    emp_name             �����,
    dept_name            �μ���,
    job_title            ���޸�,
    substr(emp_no, 1, 2) "�ֹι�ȣ �� ���ڸ�"
FROM
         employee
    JOIN department USING ( dept_id )
    JOIN job USING ( job_id )
WHERE
    substr(emp_no, 1, 2) = (
        SELECT
            MAX(substr(emp_no, 1, 2))
        FROM
            employee
    );

-- ���� ���ϱ�
SELECT MIN(trunc((months_between(sysdate, to_date(substr(emp_no, 1, 4), 'rrmm')) / 12))) ����
from employee;

    

-- ����Ŭ
SELECT
    emp_id               ���,
    emp_name             �����,
    dept_name            �μ���,
    job_title            ���޸�,
    substr(emp_no, 1, 2) "�ֹι�ȣ �� ���ڸ�"
FROM
    employee   e,
    department d,
    job        j
WHERE
        e.dept_id = d.dept_id
    AND e.job_id = j.job_id
    AND substr(emp_no, 1, 2) = (
        SELECT
            MAX(substr(emp_no, 1, 2))
        FROM
            employee
    );
    
--4. �̸��� '��'�ڰ� ���� �������� ���, �����, �μ����� ��ȸ�Ͻÿ�.
-- ANSI ����
SELECT
    emp_no    ���,
    emp_name  �����,
    dept_name �μ���
FROM
         employee
    NATURAL JOIN department
WHERE
    emp_name LIKE '%��%';

-- ����Ŭ
SELECT
    emp_no    ���,
    emp_name  �����,
    dept_name �μ���
FROM
    employee   e,
    department d
WHERE
        e.dept_id = d.dept_id
    AND emp_name LIKE '%��%';

--5. �ؿܿ������� �ٹ��ϴ� �����, ���޸�, �μ��ڵ�, �μ����� ��ȸ�Ͻÿ�.
-- ANSI
SELECT
    emp_name  �����,
    dept_name ���޸�,
    dept_id   �μ��ڵ�,
    dept_name �μ���
FROM
         employee
    NATURAL JOIN department d
    JOIN location   l ON l.location_id = d.loc_id
    NATURAL JOIN country
WHERE
    d.dept_name LIKE '�ؿ�%'
GROUP BY
    emp_name,
    dept_name,
    dept_id,
    dept_name
ORDER BY
    �μ���;
    
-- ����Ŭ
SELECT
    emp_name  �����,
    dept_name ���޸�,
    e.dept_id �μ��ڵ�,
    dept_name �μ���
FROM
    employee   e,
    department d,
    location   l,
    country    c
WHERE
        e.dept_id = d.dept_id
    AND d.loc_id = l.location_id
    AND l.country_id = c.country_id
    AND d.dept_name LIKE '�ؿ�%'
ORDER BY
    �μ���;

--6. ���ʽ�����Ʈ�� �޴� �������� �����, ���ʽ�����Ʈ, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
-- ANSI
SELECT
    emp_name �����,
    bonus_pct ���ʽ�����Ʈ,
    dept_name �μ���,
    loc_describe �ٹ�������
FROM
    employee e
LEFt JOIN department d ON d.dept_id = e.dept_id
LEFT JOIN location l ON l.location_id = d.loc_id
WHERE bonus_pct IS NOT NULL
ORDER BY
    �ٹ�������;

-- ����Ŭ
SELECT
    emp_name �����,
    bonus_pct ���ʽ�����Ʈ,
    dept_name �μ���,
    loc_describe �ٹ�������
FROM
    employee e,
    department d,
    location l
WHERE 
    e.dept_id = d.dept_id
    AND d.loc_id = l.location_id
    AND bonus_pct IS NOT NULL
ORDER BY
    �ٹ�������;

--7. �μ��ڵ尡 20�� �������� �����, ���޸�, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
-- ANSI
SELECT
    emp_name �����,
    job_title ���޸�,
    dept_name �μ���,
    loc_describe �ٹ�������
FROM
    employee
JOIN department d USING (dept_id)
JOIN job USING (job_id)
JOIN location l ON l.location_id = d.loc_id
WHERE dept_id LIKE '20';

-- ����Ŭ
SELECT
    emp_name �����,
    job_title ���޸�,
    dept_name �μ���,
    loc_describe �ٹ�������
FROM
    employee e,
    department d,
    job j,
    location l
WHERE 
    e.dept_id = d.dept_id
    AND e.job_id = j.job_id
    AND d.loc_id = l.location_id
    AND d.dept_id LIKE '20';

-- 8. ���޺� ������ �ּұ޿�(MIN_SAL)���� ���� �޴� ��������
-- �����, ���޸�, �޿�, ������ ��ȸ�Ͻÿ�.
-- ������ ���ʽ�����Ʈ�� �����Ͻÿ�.
-- ANSI
SELECT EMP_NAME, JOB_TITLE, SALARY, 
       (SALARY + NVL(BONUS_PCT, 0) * SALARY) * 12 ����
FROM EMPLOYEE
JOIN JOB USING (JOB_ID)       
WHERE (SALARY + NVL(BONUS_PCT, 0) * SALARY) * 12 
      > MIN_SAL;

-- ORACLE
SELECT EMP_NAME, JOB_TITLE, SALARY, 
       (SALARY + NVL(BONUS_PCT, 0) * SALARY) * 12 ����
FROM EMPLOYEE E, JOB J
WHERE E.JOB_ID = J.JOB_ID     
AND (SALARY + NVL(BONUS_PCT, 0) * SALARY) * 12 > MIN_SAL;

-- 9 . �ѱ�(KO)�� �Ϻ�(JP)�� �ٹ��ϴ� �������� 
-- �����(emp_name), �μ���(dept_name), ������(loc_describe),
--  ������(country_name)�� ��ȸ�Ͻÿ�.
-- ANSI
SELECT EMP_NAME �����, DEPT_NAME �μ���,
       LOC_DESCRIBE ������, COUNTRY_NAME ������
FROM EMPLOYEE
JOIN DEPARTMENT USING (DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOC_ID)
JOIN COUNTRY USING (COUNTRY_ID)       
WHERE COUNTRY_ID IN ('KO', 'JP');

-- ORACLE
SELECT EMP_NAME �����, DEPT_NAME �μ���,
       LOC_DESCRIBE ������, COUNTRY_NAME ������
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, COUNTRY C
WHERE E.DEPT_ID = D.DEPT_ID
AND D.LOC_ID = L.LOCATION_ID
AND L.COUNTRY_ID = C.COUNTRY_ID      
AND L.COUNTRY_ID IN ('KO', 'JP');

-- 10. ���� �μ��� �ٹ��ϴ� �������� 
-- �����, �μ��ڵ�, �����̸�, �μ��ڵ带 ��ȸ�Ͻÿ�.
-- self join ���
-- ORACLE
SELECT E.EMP_NAME �����, E.DEPT_ID �μ��ڵ�, 
       C.EMP_NAME �����̸�, C.DEPT_ID �μ��ڵ�
FROM EMPLOYEE E, EMPLOYEE C
WHERE E.EMP_NAME <> C.EMP_NAME
AND E.DEPT_ID = C.DEPT_ID
ORDER BY E.EMP_NAME;

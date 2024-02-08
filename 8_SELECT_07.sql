-- 8_SELECT07(SET).sql

-- SELECT : ����(SET) ������ ********************************************************

-- ���� ������ (SET OPERATOR)
-- UNION, UNION ALL, INTERESCT, MINIUS
-- �� �� �̻��� SELECT ������ ���(RESULT SET)���� �ϳ��� ǥ���ϱ� ���� �����
-- ���η� ������� ������ : 
--  ù��° SELECT ���� ����� ���ʿ�, �ι�° SELECT ���� ����� �Ʒ��ʿ�  ��ġ��
-- ������ : UNION, UNION ALL
--          �� SELECT ���� ����� �ϳ��� ��ħ
-- UNION : �� SELECT ����� ������ �ߺ�(��ġ)�Ǵ� ���� 1���� ������
-- UNION ALL : �� SELECT ����� ������ �ߺ�(��ġ)�Ǵ� ���� ���ܽ�Ű�� �ʰ� ��� ������
-- ������ : INTERSECT
--          �� SLECT ����� �ߺ��ุ ����
-- ������ : MINUS
--          ù��° SELECT ������� �ι�° SELECT �� �ߺ��Ǵ� ���� ������(��)

/*
������� : 
        SELECT ��
        ���տ�����
        SELECT ��
        ���տ�����
        SELECT ��
        ORDER BY ���� ���Ĺ��;
        
���ǻ��� : ������ �����ͺ��̽��� 2���� �簢�� ���̺� ������.
        1. ��� SELECT ���� SELECT ���� �÷� ������ ���ƾ� ��
                => �÷� ������ �ٸ��� DUMMY COLUMN(NULL �÷�)�� �߰��ؼ� ���� ������
        2. SELECT ���� ������ �÷��� �ڷ����� ���ƾ� ��
*/

-- �������� ����� ������ ��ȸ
-- EMPLOYEE_ROLE �� ROLE_HISTORY���� ���� ��ȸ�ؼ� �ϳ��� ��ħ
SELECT
    emp_id,
    role_name
FROM
    employee_role -- 22��
UNION -- 25 �� : �ߺ��� '104 SE' �� 1�� ���ܵ�
SELECT
    emp_id,
    role_name
FROM
    role_history; -- 4��

SELECT
    emp_id,
    role_name
FROM
    employee_role -- 22��
UNION ALL -- 26 �� : �ߺ��� '104 SE' �� 1�� ���ܵ�
SELECT
    emp_id,
    role_name
FROM
    role_history;

SELECT
    emp_id,
    role_name
FROM
    employee_role -- 22��
INTERSECT -- 1 �� : �ߺ��� '104 SE' �� 1�� ���ܵ�
SELECT
    emp_id,
    role_name
FROM
    role_history;

SELECT
    emp_id,
    role_name
FROM
    employee_role -- 22��
MINUS -- 21 �� : �ߺ��� '104 SE' �� 
SELECT
    emp_id,
    role_name
FROM
    role_history;

-- SET ������ ���� ���ǻ��� Ȯ�� :
-- 1. �� SELECT ���� �÷����� ���ƾ� ��
SELECT
    emp_name,
    job_id,
    hire_date
FROM
    employee
WHERE
    dept_id = '20' -- 3��
UNION
SELECT
    dept_name, -- �����Ǵ� �÷��� �ڷ����� ���ƾ� ��
    dept_id,
    NULL -- DUMMY COLUM
FROM
    department
WHERE
    dept_id = '20';

-- Ȱ�� : ROLLUP() �Լ��� �߰����� ��ġ�� ���ϴ� ����ó�� �� ��
-- �ذ����� ���� �������� Ȱ���� �� ����
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    dept_id = '20' -- 3��
UNION
SELECT
    dept_name,
    '�޿��հ�',
    SUM(salary)
FROM
         department
    JOIN employee USING ( dept_id )
WHERE
    dept_id = '20'
GROUP BY
    dept_name;
    
-- �� �� �̻��� SELECT ���� ������� ��ĥ ���� ����
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    dept_id = '10' -- 3��
UNION ALL
SELECT
    dept_name,
    '�޿��հ�',
    SUM(salary)
FROM
         department
    JOIN employee USING ( dept_id )
WHERE
    dept_id = '10'
GROUP BY
    dept_name
UNION ALL
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    dept_id = '20' -- 3��
UNION ALL
SELECT
    dept_name,
    '�޿��հ�',
    SUM(salary)
FROM
         department
    JOIN employee USING ( dept_id )
WHERE
    dept_id = '20'
GROUP BY
    dept_name
UNION ALL
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    dept_id = '30' -- 3��
UNION
SELECT
    dept_name,
    '�޿��հ�',
    SUM(salary)
FROM
         department
    JOIN employee USING ( dept_id )
WHERE
    dept_id = '30'
GROUP BY
    dept_name
UNION ALL
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    dept_id = '50' -- 3��
UNION ALL
SELECT
    dept_name,
    '�޿��հ�',
    SUM(salary)
FROM
         department
    JOIN employee USING ( dept_id )
WHERE
    dept_id = '50'
GROUP BY
    dept_name
UNION ALL
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    dept_id = '90' -- 3��
UNION ALL
SELECT
    dept_name,
    '�޿��հ�',
    SUM(salary)
FROM
         department
    JOIN employee USING ( dept_id )
WHERE
    dept_id = '90'
GROUP BY
    dept_name
UNION ALL
SELECT
    '������',
    '�޿�����',
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL
UNION ALL
SELECT
    '�μ��̹���',
    '�޿��հ�',
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL;
    
-- �ݺ��Ǵ� �������� �ʹ� ����� => ��ȣ���� ���������� �̿��ϰų�, ���ν��� ���
-- ���ν��� : SQL ������ ���α׷����� �����ϴ� ��ü��
    
-- 50�� �μ��� �Ҽӵ� ���� �� �����ڿ� �Ϲ������� ���� ��ȸ�ؼ� �ϳ��� ���Ķ�.
-- Ȯ�� : 50�� �μ��� �������� ��ȸ
SELECT
    *
FROM
    employee
WHERE
    dept_id = '50';

SELECT
    emp_id,
    emp_name,
    '������' ����
FROM
    employee
WHERE
        emp_id = '141'
    AND dept_id = '50'
UNION
SELECT
    emp_id,
    emp_name,
    '����' ����
FROM
    employee
WHERE
        emp_id != '141'
    AND dept_id = '50'
ORDER BY
    3,
    1; -- SELECT ���� ���������� �����

-- ���� ������ ���� ��Ī(ALIAS)�� ù��° SELECT ������ �����
SELECT
    'SQL�� �����ϰ� �ֽ��ϴ�.' ����,
    3                 ����
FROM
    dual
UNION
SELECT
    '�츮�� ����',
    1
FROM
    dual
UNION
SELECT
    '���� ����ְ�',
    2
FROM
    dual
ORDER BY
    2;

-- SET �����ڿ� JOIN�� ����
SELECT
    emp_id,
    role_name
FROM employee_role
INTERSECT
SELECT
    emp_id, role_name
FROM role_history;

-- �� �������� SELECT ���� ������ �÷����� ������ ��쿡�� �������� �ٲ� �� ����
-- USING (EMP_ID, ROLE_NAME) == INTERSECT
-- (104 SE) = (104 SE) : ���� �� ��ȸ => EQUAL INNER JOIN ��
-- (104 SE-ANLY) != (104 SE) : �ٸ���, ���ο��� ���ܵ�

-- ���� ������ �������� �ٲ۴ٸ�
SELECT
    emp_id,
    role_name
FROM
    employee_role
JOIN role_history USING (emp_id, role_name);

-- SET �����ڿ� IN �������� ���� : 
-- UNION�� IN�� ���� ����� ���� �� ����
-- SELECT ���� ���õ� �÷����� ����, ��ȸ�ϴ� ���̺� ���� 
-- WHERE ���� �񱳰��� �ٸ� ��쿡 IN���� �ٲټ� ����

-- ������ �븮 �Ǵ� ����� ������ �̸�, ���޸� ��ȸ
-- ���޼� ������������, ���� ������ �̸��� ������������ ó����

SELECT
    emp_name,
    job_title
FROM
    employee
JOIN job USING (job_id)
WHERE job_title IN ('�븮', '���')
ORDER BY 2, 1;

-- UNION �������� �ٲ۴ٸ�
SELECT
    emp_name,
    job_title
FROM
    employee
JOIN job USING (job_id)
WHERE job_title = '�븮'
UNION
SELECT
    emp_name,
    job_title
FROM
    employee
JOIN job USING (job_id)
WHERE job_title = '���'
ORDER BY 2, 1;

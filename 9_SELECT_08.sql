-- 9_SELECT_08(��������).sql

-- SELECT : �������� (SUB QUERY) ------------------------------------
-- SELECT �� �ȿ� ���Ǵ� SELECT�� => ���� ������� ��
-- �ٱ� SELECT ���� �ܺ� ���� (���� ����, MAIN QUERY)��� ��
/*
�ٱ��Լ�(��ȯ���� �ִ� �Լ�())
        => ���� �Լ��� ���� ����Ǹ鼭, ��ȯ�� ���� �ٱ� �Լ��� �����
        
���� �������� �÷��� �񱳿����� �񱳰�   <-- �񱳰� �˾Ƴ��� ���� SELECT ���� �� ��ſ� �ٷ� ����� �� ����
                    �÷��� �񱳿����� (�񱳰� ��ȸ�ϴ� SELECT ��)   <-- ����(����)������� ��
*/

-- ���¿��� ���� �μ��� �ٹ��ϴ� ���� ��� ��ȸ
-- 1. ���¿��� �μ��ڵ� ��ȸ
SELECT
    dept_id
FROM
    employee
WHERE
    emp_name = '���¿�';

-- 2. ��ȸ�� �μ��ڵ�� ������� ��ȸ
SELECT
    emp_name
FROM
    employee
WHERE
    dept_id = '50';

-- �������� ���� :
SELECT
    emp_name
FROM
    employee
WHERE
    dept_id = (
        SELECT
            dept_id
        FROM
            employee
        WHERE
            emp_name = '���¿�'
    );

-- �������� ���� (����)
-- ���������� ����� ������� ������ ���� ����
-- �������� �տ� ���Ǵ� �����ڰ� �޶���
-- ������ �������� : SELECT �� ������� 1���� �������� 
--                          => �Ϲ� �񱳿�����(=, !=, <>, ^=, >, >=, <= ��� ������
-- ������ [���Ͽ�] �������� : SELECT �� ������� ���� ���� �������� (������� ���� ��)
--          => �Ϲ� �񱳿�����(�񱳰� 1��) ��� �� ��, IN, ANY, ALL �� ����ؾ� ��
-- �� �� ���� : ���߿� ��������
-- ���߿�  [������] �������� : �������� ������� 1��, ������ �÷��� ���� ���� ���
--          ���������� (�÷�1, �÷�2, ...) �񱳿����� (SELECT �÷�1, �÷�2, ... FROM ....)
-- ������ ���߿� �������� : �������� ����� ���� ��, SELECT �� �÷� ���� ���� ���
--          ���������� (�÷�1, �÷�2, ...) IN, ANY, ALL (SELECT �÷�1, �÷�2, ... FROM ...)

-- ��[ȣ��]�� �������� : ���������� �÷����� �����ٰ� ���������� ����ϴ� ������
-- ��Į�� �������� : ������ + ��ȣ���� ��������

-- ������ �������� (SINGLE ROW SUBQUERY)
-- ���������� ������� 1���� ���
-- ������ �������� �տ��� �Ϲ� �񱳿����� ����� �� ����

-- �� : ���¿��� ������ �����鼭, ���¿����� �޿��� ���� �޴� ���� ��ȸ
-- 1. ���¿� ���� ��ȸ
SELECT
    job_id
FROM
    employee
WHERE
    emp_name = '���¿�'; -- 'J5'

-- 2. ���¿� �޿� ��ȸ
SELECT
    salary
FROM
    employee
WHERE
    emp_name = '���¿�';   -- 2300000

-- 3. ���� ��ȸ
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
        job_id = 'J5'
    AND salary > 2300000;
    
-- �������� ���� :
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
        job_id = (
            SELECT
                job_id
            FROM
                employee
            WHERE
                emp_name = '���¿�' -- 'J5' : ������ ��������
        )
    AND salary > (
        SELECT
            salary
        FROM
            employee
        WHERE
            emp_name = '���¿�' -- 2300000 : ������ ��������
    );

-- ���� �߿��� ��ü �޿��� ���� ���� �޿�(���� ���� ��)�� �޴� ��� ��ȸ
-- WHERE ������ �׷��Լ� ��� �� �� => ���������� �ذ�
SELECT
    MIN(salary)
FROM
    employee; -- 1500000

SELECT
    emp_id,
    emp_name,
    salary
FROM
    employee
--WHERE salary = MIN(salry); -- err
--WHERE salary = 1500000;    
WHERE
    salary = (
        SELECT
            MIN(salary)
        FROM
            employee
    ); -- 1500000 : �� 1�� (������ ��������)
        
-- HAVING �������� �������� ����� �� ����
-- �� : �μ��� �޿��հ� �� ����ū ���� ���� �μ���� �޿��հ� ��ȸ

-- �μ��� �޿��հ��� ���� ū�� ��ȸ
SELECT
    MAX(SUM(salary))
FROM
    employee
GROUP BY
    dept_id; -- 1�� : 18100000

-- �μ��ڵ�� �޿��հ� �Բ� ��ȸ
SELECT
    dept_name,
    SUM(salary)
FROM
    employee
    LEFT JOIN department USING ( dept_id )
GROUP BY
    dept_name
--HAVING SUM(salary) = 18100000;
HAVING
    SUM(salary) = (
        SELECT
            MAX(SUM(salary))
        FROM
            employee
        GROUP BY
            dept_id
    );

-- ���������� SELECT ���� ��� ������ ����� �� ����
-- �ַ� SELECT ��, FROM ��, WHERE ��, HAVING ���� �����

-- ���߿� (MULTI COLUMN) [������] �������� ---------------------------
-- ���������� ���� ������� 1��, SELECT ���� �÷��� ���� ���� ���
-- ������� 1���̸�, �Ϲݺ񱳿����� ��� ������
-- ���� : ���������� �÷� ������ ���缭 ���� �÷����� ��� ���ؾ� ��
-- (���� �÷�1, ���� �÷�2) �񱳿����� (SELECT �÷�1, �÷�2 FROM ....)

-- ���¿��� ���ް� �޿��� ���� ���� ��ȸ
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    ( job_id,
      salary ) = (
        SELECT
            job_id,
            salary
        FROM
            employee
        WHERE
            emp_name = '���¿�'-- ���߿� ������ ��������
    );

-- ������ (MULTI ROWS) [���Ͽ�] �������� ------------------------------
-- ���������� ���� �����(�����)�� ���� ���� ���
-- ������ �������� �տ��� �Ϲ� �񱳿�����(�񱳰� 1���� ����) ��� �� �� : ������
-- ���� ���� ���� ���� �� �ִ� ������ ����ؾ� �� : IN, ANY, ALL

-- �� : �� �μ����� �޿��� ���� ���� ���� ���� ��ȸ
SELECT
    MIN(salary) -- 7��
FROM
    employee
GROUP BY
    dept_id;

SELECT
    emp_id,
    emp_name,
    dept_id,
    salary
FROM
    employee
WHERE
    salary = (
        SELECT
            MIN(salary) -- 7�� : ������ ��������
        FROM
            employee
        GROUP BY
            dept_id
    ); -- err : �Ϲ� �񱳿����� ��� �� ��
    
-- ����
SELECT
    emp_id,
    emp_name,
    dept_id,
    salary
FROM
    employee
WHERE
    salary IN (
        SELECT
            MIN(salary) -- 7�� : ������ ��������
        FROM
            employee
        GROUP BY
            dept_id
    );

-- �÷��� IN (�������� ���� | ������ ��������)
-- �÷��� = �񱳰�1 OR �÷��� = �񱳰�2 OR �÷��� = �񱳰�3 OR....
-- �÷��� ���� ���� �񱳰��� ��ġ�ϴ� ���� ������ �����϶�� �ǹ�

-- �÷��� NOT IN (�������� ���� | ������ ��������)
-- NOT �÷��� IN (�������� ���� | ������ ��������) �� ����
-- NOT (�÷��� = �񱳰�1 OR �÷��� = �񱳰�2 OR �÷��� = �񱳰�3 OR....)
-- �÷��� ���� ���� �񱳰��� ��ġ���� �ʴ� ���� ������ �����϶�� �ǹ���

-- �� : �������� ������ �����ڰ� �ƴ� ������ ������ ��ȸ�ؼ� ���Ķ�.
-- 1. �������� ���� ��ȸ
SELECT DISTINCT
    mgr_id -- 6��
FROM
    employee
WHERE
    mgr_id IS NOT NULL;
    
-- 2. ���� �������� �����ڸ� ��ȸ
SELECT
    emp_id,
    emp_name,
    '������' ����
FROM
    employee
WHERE
    emp_id IN (
        SELECT DISTINCT
            mgr_id -- 6��
        FROM
            employee
        WHERE
            mgr_id IS NOT NULL
    )
UNION
SELECT
    emp_id,
    emp_name,
    '����' ����
FROM
    employee
WHERE
    emp_id NOT IN (
        SELECT DISTINCT
            mgr_id -- 6��
        FROM
            employee
        WHERE
            mgr_id IS NOT NULL
    )
ORDER BY
    3,
    1;
    
-- SELECT �������� �������� ����� �� ����
-- �ַ� �Լ��� �ȿ��� ���������� ����

-- ���� ������ �����Ѵٸ�
SELECT
    emp_id,
    emp_name,
    CASE
        WHEN emp_id IN (
            SELECT DISTINCT
                mgr_id -- 6��
            FROM
                employee
            WHERE
                mgr_id IS NOT NULL
        ) THEN
            '������'
        ELSE
            '����'
    END ����
FROM
    employee
ORDER BY
    3,
    1;
    
-- �÷��� > ANY (������ ��������) : ������ ���������� ���� ������� �� ���� ���� ������ ū �� ����
-- �÷��� < ANY (������ ��������) : ������ ���������� ���� ������� �� ���� ū ������ ���� �� ����
-- ���� ���� ��� ������ �ּ� �ϳ��� ������ ������ �����
-- = ANY : IN�� �����ڰ� ����

-- �� : �븮 ������ ���� �߿��� ���� ������ �ּұ޿����� ���� �޴� �븮 ��ȸ
SELECT
    emp_id,
    emp_name,
    job_title,
    salary
FROM
         employee
    JOIN job USING ( job_id )
WHERE
    salary > ANY (
        SELECT -- ������ ��������
            salary
        FROM
                 employee
            JOIN job USING ( job_id )
        WHERE
            job_title = '����'
    )
    AND job_title = '�븮';

-- �÷��� > ALL (������ ��������) : ���� ū ������ ū
-- �÷��� < ALL (������ ��������) : ���� ���� ������ ����

-- �� : ��� ������� �޿����� �� ���� �޿��� �޴� �븮 ���� ��ȸ
SELECT
    emp_id,
    emp_name,
    job_title,
    salary
FROM
         employee
    JOIN job USING ( job_id )
WHERE
    salary > ALL (
        SELECT -- ������ ��������
            salary
        FROM
                 employee
            JOIN job USING ( job_id )
        WHERE
            job_title = '����'
    )
    AND job_title = '�븮';

-- ���������� ��� ��ġ : 
-- SELECT ���� SELECT ��, FROM ��, WHERE ��, GROUP BY ��, HAVING ��, ORDER BY ��
-- ��� ������ �������� ����� �� ����
-- DML �� : INSERT��, UPDATE��
-- DDL �� : CREATE TABLE ��, CREATE VIEW ��

-- ���߿� ������ �������� -----------------------------
-- �ڱ� ������ ��� �޿��� �޴� ���� ��ȸ
-- 1. ���޺��޿� ��� ��ȸ
SELECT
    job_id,
    trunc(AVG(salary),
          - 5)
FROM
    employee
GROUP BY
    job_id;
-- ���� ��ϵ� �޿����� ��հ��� �ڸ��� ���߱Ⱑ �ʿ���

-- 2. ����
SELECT
    emp_name,
    job_title,
    salary
FROM
    employee
    LEFT JOIN job USING ( job_id )
WHERE
    ( job_id, salary ) IN (
        SELECT
            job_id, trunc(AVG(salary),
                          - 5)
        FROM
            employee
        GROUP BY
            job_id
    );
    
-- FROM �������� �������� ����� �� ���� => ���������� ����並 ���̺� ��ſ� �����
-- FROM (��������) ��Ī => ��Ī�� ���̺���� �����
-- �ζ��� ���� ��

-- ���� : 
-- ����Ŭ ���뱸���� FROM ���� ������ ���̺�� ���� ��Ī�� ������ �� ����
-- ���̺� ��Ī�� ���̺�� ��ſ� �����
-- ANSI ǥ�ر��� USING ���ÿ��� ���̺� ��Ī ����� �� ����
-- ANSI ǥ�ر������� ���̺� ���� ����Ϸ���, ON ����ϸ� ��

-- �ڱ� ������ ��ձ޿��� �޴� ���� ��ȸ
-- �ζ��� �並 ����Ѵٸ� : 
SELECT
    emp_name,
    job_title,
    salary
FROM
         (
        SELECT
            job_id,
            trunc(AVG(salary),
                  - 5) jobavg
        FROM
            employee
        GROUP BY
            job_id
    ) v -- �ζ��� ��
    JOIN employee e ON ( v.jobavg = e.salary
                         AND v.job_id = e.job_id )
    JOIN job      j ON ( e.job_id = j.job_id )
ORDER BY
    3,
    1;
    
 -- ��[ȣ��]�� �������� (CORRELATE SUBQUERY)
 -- ��κ��� ���������� ���������� ���� ����� ���������� ����ϴ� ������
 -- ���������� ���� �����ؼ� ����� Ȯ���� �� ����
 -- ��ȣ���� ���������� ���������� ���������� ���� �����ٰ� ����� ����
 -- ��, ���������� ���� �ٲ�� ���������� ����� �޶����� ��
 
 -- �ڱ� ������ ��� �޿��� �޴� ���� ��ȸ : ��ȣ���� �������� �ۼ��Ѵٸ�
SELECT
    emp_name,
    job_title,
    salary
FROM
    employee e
    LEFT JOIN job      j ON ( e.job_id = j.job_id )
-- WHERE SALARY = (�� ������ ��ձ޿� ���)
WHERE
    salary = (
        SELECT
            trunc(AVG(salary),
                  - 5)
        FROM
            employee
        WHERE
            nvl(job_id, ' ') = nvl(e.job_id, ' ')
    );

-- EXISTS / NOT EXISTS
-- ��ȣ���� �������� �տ��� ����ϴ� ��������
-- ���깹���� ���� ����� �����ϴ��� ��� �� EXISTS �����
-- �� ������ ���ÿ��� ���� �÷��� ����ϸ� �ȵ�
-- �÷��� ������ (��������) ==> EXISTS (��ȣ���� ��������)
-- ���������� ����� �ִ���? ������? �� ����� ��������
-- �������� SELECT ���� NULL�� ������ : �÷� ���� ����

-- �� : �������� ���� ��ȸ
SELECT
    emp_id,
    emp_name,
    '������' ����
FROM
    employee e
WHERE
    EXISTS (
        SELECT
            NULL
        FROM
            employee
        WHERE
            e.emp_id = mgr_id
    );
-- ��ȣ���� ���������� ����� �����ϸ�, �ش� ���� ���� ���� ���

-- NOT EXISTS : ��ȣ���� ���������� ����� �������� �ʴ���
-- �� : �����ڰ� �ƴ� ���� ��ȸ
SELECT
    emp_id,
    emp_name,
    '������' ����
FROM
    employee e
WHERE
    NOT EXISTS (
        SELECT
            NULL
        FROM
            employee
        WHERE
            e.emp_id = mgr_id
    );
-- ��ȣ���� ���������� ����� �������� ������, �ش� ���� ���� ���� ��� 

-- ��Į�� �������� -----------------------------------
-- ������ + ��ȣ���� ��������

-- �� : �̸�, �μ��ڵ�, �޿�, �ش� ������ �Ҽӵ� �μ��� ���޿� ��ȸ
SELECT
    emp_name,
    dept_id,
    salary,
    (
        SELECT
            trunc(AVG(salary),
                  - 5)
        FROM
            employee
        WHERE
            e.dept_id = dept_id
    ) "�ҼӺμ��� �޿����"
FROM
    employee e;
    
-- ORDER BY ������ ��Į�� �������� ����� �� ����
-- ������ �Ҽӵ� �μ��� �μ����� ū ������ ���ĵ� ���� ���� ��ȸ
SELECT
    emp_id,
    emp_name,
    dept_id,
    hire_date
FROM
    employee e
ORDER BY
    (
        SELECT
            dept_name
        FROM
            department
        WHERE
            dept_id = e.dept_id
    ) DESC NULLS LAST;
                
-- TOP-N �м� ---------------------------------
-- ���� �� ��, ���� �� ���� ��ȸ�ϴ� ��
-- ��� 1 : �ζ��κ�� RANK() �Լ��� �̿�
-- ��� 2 : �ζ��κ�� ROWNUM �̿�

-- ��� 1 : �ζ��κ�� RANK() �Լ��� �̿�
-- ���� �������� �޿��� ���� ���� �޴� ���� 5�� ��ȸ
-- �̸�, �޿�, ����
SELECT
    *
FROM
    (
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
    )
WHERE ���� <= 5;

-- ��� 2 : �ζ��κ�� ROWNUM �� �ο��ǰ� ��
-- ROWNUM : ���ȣ, WHERE �� �۵� �Ŀ� �ڵ����� �ο���

-- Ȯ��
SELECT
    ROWNUM,
    emp_id,
    emp_name,
    salary
FROM
    employee -- ROWNUM ������
ORDER BY
    salary DESC;

-- �޿� ���� �޴� ���� 5�� ��ȸ : �ζ��κ� ������� ���� ���
SELECT
    ROWNUM,
    emp_id,
    emp_name,
    salary
FROM
    employee
WHERE
    ROWNUM <= 5 -- ����ó���� ������ ���� ROWNUM ������
ORDER BY salary DESC;

-- �ذ� : �����ϰ� ���� ROWNUM�� �ο��ǰԲ� ���� �ۼ���
-- �ζ��κ� �����
SELECT
    ROWNUM,
    emp_name, salary
FROM (
    SELECT
        *
    FROM
        employee
    ORDER BY salary DESC
    )
WHERE
    ROWNUM <= 5;


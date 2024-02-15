-- 14_DML_TCL.sql

-- INSERT �� -----------------------------------------------------------------------------------
-- ���̺� ���ο� �����͸� ��� ������ �� ����� : �� ������ �þ

/*
INSERT INTO ���̺�� (��������÷���, �÷���, ..........)
VALUES (����� ��, ��, DEFAULT, NULL, ......);

VALUES ��ſ� �������� ����ص� ��, (��������) ��ȣ ���� ������
INSERT INTO ���̺��
(SELECT ��������);

���� :
1. ������ �÷��� ��ϰ��� ������ �ڷ��� ������ ��ġ�ؾ� ��
2. �÷� ������ �����Ǹ�, ���̺��� ��� �÷��� ���� ����Ѵٴ� �ǹ���
        => ���̺��� �÷����� ������ ���缭 �� ����ؾ� ��
3. ��ϰ��� �������� ������� �ʴ� �� ����� ��
4. �÷��� ��ϰ��� ������ ���� ������ �� (EMP_NO �� �����̸� ��� ��)
*/

CREATE TABLE dept (
    deptid   CHAR(2),
    deptname VARCHAR(20)
);

SELECT
    *
FROM
    dept;

SELECT
    COUNT(*)
FROM
    dept; -- 0

INSERT INTO dept (
    deptid,
    deptname
) VALUES (
    '10',
    'ȸ����'
);

SELECT
    *
FROM
    dept;

SELECT
    COUNT(*)
FROM
    dept; -- 1

INSERT INTO dept VALUES (
    '20',
    '�λ���'
);

SELECT
    *
FROM
    dept;

SELECT
    COUNT(*)
FROM
    dept; -- 2

-- ���� ����� DML ��ɹ��� �޸��� ���ۻ󿡼� �۵��Ǿ���
-- ���̺� �߰�/����/������ ������ ����� ��ũ���� �����ͺ��̽� ���Ͻý������� ����(�ݿ�)���Ѿ� ��
-- Ʈ����� ��ɾ�(TCL : Transaction Control Language, Ʈ����� �����) : COMMIT, ROLLBACK
COMMIT;

-- ���̺��� ���� ��� �÷��� �� ��Ͻÿ��� �÷��� ������ �� ����
-- INSERT�ÿ� ��ϰ� ��ſ� DEFAULT, NULL ����ص� ��
SELECT
    *
FROM
    emp_copy; -- 22��
DESC emp_copy;

INSERT INTO emp_copy (
    emp_id,
    emp_name,
    emp_no,
    email,
    phone,
    hire_date,
    job_id,
    salary,
    bonus_pct,
    marriage,
    mgr_id,
    dept_id
) VALUES (
    '900',
    'ȫ�浿',
    '980711-1022222',
    'doorwinbell@test.org',
    '010123456',
    '2012-06-20',
    'J6',
    4500000,
    0.05, DEFAULT,
    '176',
    NULL
);

SELECT
    *
FROM
    emp_copy; --23��
SELECT
    *
FROM
    emp_copy
WHERE
    emp_id = '900'; -- ��ȸ Ȯ��

COMMIT;

INSERT INTO emp_copy (
    emp_id,
    emp_name,
    emp_no,
    email,
    phone,
    hire_date,
    job_id,
    salary,
    bonus_pct,
    marriage,
    mgr_id,
    dept_id
) VALUES (
    '840',
    '���ؼ�',
    '980711-2022222',
    'hajSU@test.org',
    '0101234543',
    '90/12/3',
    'J7',
    4540000,
    0.1,
    'Y',
    '141',
    '30'
);

SELECT
    *
FROM
    emp_copy; --24��
COMMIT;

SELECT
    *
FROM
    emp_copy
WHERE
    emp_id = '840'; -- ��ȸ Ȯ��

-- INSERT �ÿ� �÷��� �����Ǹ�, �ش� �÷��� NULL ó����
-- DEFAULT�� �������� ���� �÷��� DEFAULT ����ϸ� NULL ó����
INSERT INTO emp_copy (
    emp_id,
    emp_name,
    emp_no,
    salary,
    marriage
) VALUES (
    '888',
    '�ſ���',
    '891212-1234567', DEFAULT, DEFAULT
);

SELECT
    *
FROM
    emp_copy
WHERE
    emp_id = '888';

-- INSERT�� �������� ���
-- VALUES ��ſ� �����
CREATE TABLE emp (
    emp_id    CHAR(3),
    emp_name  VARCHAR2(20),
    dept_name VARCHAR2(20)
);

SELECT
    *
FROM
    emp;

INSERT INTO emp
    (
        SELECT
            emp_id,
            emp_name,
            dept_name
        FROM
            employee
            LEFT JOIN department USING ( dept_id )
    );

COMMIT;

-- �� ��Ͻ� �������� ������� �ʴ� ���̾�� ��
ALTER TABLE emp_copy
-- ADD PRIMARY KEY (emp_id);
-- ADD CONSTRAINT FK_MID_ECOPY FOREIGN KEY (mgr_id) REFERENCES emp_copy (emp_id); 
-- ADD CONSTRAINT fk_jid_ecopy FOREIGN KEY ( job_id ) REFERENCES job;
--ADD UNIQUE (emp_no);
ADD CONSTRAINT CHK_MRIG_ECOPY CHECK (MARRIAGE IN ('Y', 'N'));

-- DEFAULT ���� ����
ALTER TABLE emp_copy MODIFY (
    hire_date DEFAULT sysdate
);

-- �������� ���� ���� Ȯ��
INSERT INTO emp_copy (emp_id, emp_name, emp_no)
VALUES (NULL, '������', '980711-1234567'); -- emp_id�� PRIMARY KEY ���� ����, NULL��� ����

INSERT INTO emp_copy (emp_id, emp_name, emp_no)
VALUES (777, '������', '980711-1234567'); -- emp_id�� PRIMARY KEY ���� ����, ���� �� �ι� ��� �� ��

INSERT INTO emp_copy (emp_id, emp_name, emp_no)
VALUES ( 777, NULL, '980711-1234567'); -- emp_name�� PRIMARY KEY ���� ����, NULL��� ����

INSERT INTO emp_copy (emp_id, emp_name, emp_no)
VALUES ( 777, '������', NULL); -- emp_no�� PRIMARY KEY ���� ����, NULL��� ����

INSERT INTO emp_copy (emp_id, emp_name, emp_no)
VALUES (777, '������', '980711-1234567'); -- emp_no�� UNIQUE ���� ����, ���� �� �ι� ��� ����

INSERT INTO emp_copy (emp_id, emp_name, emp_no, marriage)
VALUES (777, '������2', '980712-1234567', 'y'); -- marriage�� CHECK �������� �����

-- DELETE �� -----------------------------------------------------------------------------
-- ���� �����ϴ� ������, ���̺��� �� ���� �پ��
-- ROLLBACK ������ (DELETE ������ ����� �� ����)

/*
DELETE FROM ���̺��
WHERE �÷��� ������ �񱳰�;

���� :
1. FOREIGN KEY ������������ ����(REFERENCE)�ǰ� �ִ� ���̺��� �����÷��� ���� �Ұ�����(�⺻)
    => �ܷ�Ű �������� ������ ������(SET NULL, CASCADE)�� ������ ���� ���� ������
2.  WHERE ���� �����Ǹ� ���̺��� ��� ���� ������ (���� ������)

���̺��� ��� ���� �����ϴ� ��ɱ������� TRUNCATAE �� ����
TRUNCATE TABLE ���̺��;
=> �ѹ� �ȵ� (���� �Ұ���)
*/

SELECT * FROM dcopy;

-- WHERE �� ����
DELETE FROM dcopy;

ROLLBACK; -- ��� ���� DML ������ ���� �����

TRUNCATE TABLE dcopy;
SELECT * FROM dcopy;
ROLLBACK; -- �ѹ� �ȵ�

-- �ٸ� ���̺��� FOREIGN KEY(�ܷ�Ű)�� �����ϰ� �ִ� ��(����ϰ� �ִ� ��)�� ���� �� ��
DELETE FROM department
WHERE dept_id = '90'; -- EMPLOYEE�� dept_id���� ����ϰ� �ִ� ����

-- ��밪 Ȯ�� 
SELECT * FROM department
ORDER BY dept_id;

-- ��밪 Ȯ��
SELECT DISTINCT dept_id
FROM employee
ORDER BY 1 NULLS LAST;

-- ������ ���� ���� ������ �� ����
UPDATE emp_copy
SET dept_id = NULL
WHERE emp_id = '840';

COMMIT;

DELETE FROM department
WHERE dept_id = '30';

SELECT * FROM department ORDER BY 1;

ROLLBACK;

-- TCL (Transaction Control Language : Ʈ����� �����) -----------------------------------
-- ��ɾ� : COMMIT, ROLLBACK, SAVEPOINT
-- DML ��ɱ��� ���� �ʿ���

-- Ʈ������� ���� :
-- ���� Ʈ������� ����ǰ� ����, ù��° DML(INSERT, UPDATE, DELETE) ��ɱ����� ����� ��
-- DDL(CREATE, ALTER, DROP) ������ ����� �� : ���� Ʈ������� AUTO COMMIT ��

-- Ʈ������� ���� : 
-- COMMIT(���� �ݿ�), ROLLBACK(��ɱ����� ���) ����
-- �ڵ� ���� : ���ο� DDL ��ɱ����� ����� ��

-- DDL ���� : ������ ���������� ��Ȱ��ȭ��Ŵ => Ʈ����� ����
ALTER TABLE employee
--DISABLE CONSTRAINT FK_MGRID;
DROP CONSTRAINT FK_MGRID;
-- ���ο� Ʈ����� ����
SELECT TABLE_NAME, CONSTRAINT_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TESTFK';

SAVEPOINT S0;

INSERT INTO department
VALUES ('40', '��ȹ������', 'A1');
-- Ȯ��
SELECT * FROM department ORDER BY 1;

SAVEPOINT S1;

UPDATE EMPLOYEE
SET dept_id = '40'
WHERE dept_id IS NULL;
-- Ȯ��
SELECT * FROM employee
WHERE dept_id = '40';

SAVEPOINT S2;

DELETE FROM employee;
-- Ȯ��
SELECT COUNT(*) FROM employee;

-- ROLLBACK; -- Ʈ����� ���� DML ��� ��ü ���

-- S2 ���� �ѹ� : 
ROLLBACK TO S2;

-- Ȯ��
SELECT * FROM employee;
SELECT COUNT(*) FROM employee;

-- S1 ���� �ѹ� : 
ROLLBACK TO S1; -- UPDATE ���

-- Ȯ��
SELECT * FROM employee
WHERE dept_id = '40';

SELECT * FROM employee
where dept_id IS NULL;

-- S0���� �ѹ� : 
ROLLBACK TO S0; -- INSERT ���

-- Ȯ��
SELECT * FROM department ORDER BY 1;

-- ���ü� ���� : ���
-- ���� ��������
-- ���� ����ڰ� ������ �� ���
-- ����(SESSION)�� ���� ��
SELECT emp_name, marriage
FROM employee
WHERE emp_id = '143';

UPDATE employee
SET marriage = 'N'
WHERE emp_id = '143';

COMMIT;



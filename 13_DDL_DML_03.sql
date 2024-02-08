-- 13_DDL_DML_03.sql

-- DDL (������ ���Ǿ�)
-- �����ͺ��̽� ��ü�� ����(CREATE), ����(ALTER), ����(DROP)�� ����ϴ� ����

-- ���̺� ���� ---------------------------------
-- �÷� �߰�/����, �ڷ��� ����, �⺻��(DEFAULT) ����
-- �������� �߰�/����
-- �̸� ���� : ���̺�, �÷�, ��������

-- �÷� �߰�
-- ���̺� ���� �� �÷� ������ �����ϰ� �ۼ��ϸ� ��
CREATE TABLE dcopy
AS
SELECT * FROM department;

SELECT * FROM dcopy;

ALTER TABLE dcopy ADD (
    lname VARCHAR2(40)
);

DESC dcopy;

ALTER TABLE dcopy ADD(
    cname VARCHAR2(30) DEFAULT '�ѱ�'
);

-- �������� �߰�
CREATE TABLE emp2
AS
SELECT * FROM employee;

ALTER TABLE emp2 
ADD PRIMARY KEY (emp_id);

ALTER TABLE emp2
ADD CONSTRAINT e2_uneno UNIQUE (emp_no);

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMP2';

-- NOT NULL �� ADD�� �߰��ϴ� ���� �ƴ϶�, NULL���� NOT NULL�� �����ϴ� ����
ALTER TABLE emp2
ADD NOT NULL (hire_date); -- ERROR

ALTER TABLE emp2
MODIFY (hire_date NOT NULL);

ALTER TABLE emp2
MODIFY (hire_date NULL);

-- �÷� �ڷ��� ����
CREATE TABLE emp4
AS
SELECT emp_id, emp_name, hire_date
FROM employee;

DESC emp4;

ALTER TABLE emp4
MODIFY (emp_id VARCHAR2(20), 
             emp_name char(20) );

-- DEFAULT �� ����
CREATE TABLE emp5 (
    emp_id char(3),
    emp_name VARCHAR2(20),
    addr1 VARCHAR2(20)   DEFAULT '����',
    addr2 VARCHAR2(100)
);

INSERT INTO EMP5 VALUES ('A10', '������', DEFAULT, 'û�� 134');
INSERT INTO EMP5 VALUES ('B10', '�̺���', DEFAULT, '�д籸 ���ڵ� 77');
INSERT INTO EMP5 VALUES ('C10', '�̺���', DEFAULT, '�д籸 ���ڵ� 77');

SELECT * FROM emp5;

ALTER TABLE emp5
MODIFY (addr1 DEFAULT '���');

--UPDATE emp5 SET addr1= '����'
--WHERE emp_id = 'B10';

-- ���� ���Ŀ� DEFAULT ���� �ٲ۰� �����
ALTER TABLE dcopy
DROP COLUMN cname;

DESC dcopy;

ALTER TABLE dcopy
drop (loc_id, lname); -- �÷� ���� �� ������ ���

-- ���̺��� �÷��� ��� ������ �� ����
-- ���̺��� �ּ� �� ���� �÷��� �־�� �� => �÷� ���� �� ���̺� ���� �� ��
CREATE TABLE tco(); -- ERROR

ALTER TABLE dcopy
DROP (did, dname); -- ERROR

-- �ܷ�Ű(FOREIGN KEY) �����������������Ǵ� �÷�(�θ�Ű)�� ���� �� ����
ALTER TABLE department
DROP (dept_id); -- ERROR 

ALTER TABLE department
--DROP (dept_id); -- ERROR 
DROP (dept_id) CASCADE CONSTRAINTS; -- OK

-- ���������� ������ �÷��� ������ �� ����
CREATE TABLE tb1(
    pk NUMBER PRIMARY KEY,
    fk NUMBER REFERENCES tb1,
    COL1 NUMBER,
    -- ���̺���
    CHECK (pk > 0 AND col1 > 0)
);

ALTER TABLE tb1
DROP (pk); -- ERROR

ALTER TABLE tb1
DROP (col1); -- ERROR

-- �������ǵ� �Բ� �����ϸ� �� : CASCADE CONSTRAINTS
ALTER TABLE tb1
DROP (pk) CASCADE CONSTRAINTS; 

ALTER TABLE tb1
DROP (col1) CASCADE CONSTRAINTS;

DESC tb1;

-- �������� ���� --------------------

-- �������� ������ ��ųʸ����� Ȯ��
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'CONSTRAINT_EMP';

-- �������� 1�� ����
ALTER TABLE CONSTRAINT_EMP
DROP CONSTRAINT CHK;

-- �������� ���� �� ����
ALTER TABLE CONSTRAINT_EMP
DROP CONSTRAINT FKJID
DROP CONSTRAINT FKMID
DROP CONSTRAINT NENAME;

-- NOT NULL �������� ������ MODIFY�� NULL�� �ٲ�
ALTER TABLE CONSTRAINT_EMP
MODIFY (eno null);

-- ���̺��� �÷��� �����ϴ� ������ ��ųʸ� : USER_TAB_COLS
SELECT * FROM USER_TAB_COLS;
DESC USER_TAB_COLS;

-- �÷��� ���������� �����ϴ� ������ ��ųʸ� : USER_CONS_COLUMNS
CREATE TABLE tb_exam (
    col1 char(3) PRIMARY KEY,
    ename VARCHAR2(20),
    FOREIGN KEY (col1) REFERENCES employee
);

-- ��ųʸ��� Ȯ��
SELECT CONSTRAINT_NAME �̸�,
            CONSTRAINT_TYPE ����,
            COLUMN_NAME �÷�,
            R_CONSTRAINT_NAME ����,
            DELETE_RULE ������Ģ
FROM USER_CONSTRAINTS
JOIN USER_CONS_COLUMNS USING (CONSTRAINT_NAME, TABLE_NAME)
WHERE TABLE_NAME = 'TB_EXAM';

-- �̸� �ٲٱ� -----------------
-- ���̺��, �÷���, �������� �̸�

-- �÷��� �ٲٱ�
ALTER TABLE TB_EXAM
RENAME COLUMN col1 to empid;

DESC tb_exam;

-- �������� �̸� �ٲٱ�
ALTER TABLE TB_EXAM
RENAME CONSTRAINT SYS_C007614 TO pk_eid;

ALTER TABLE TB_EXAM
RENAME CONSTRAINT SYS_C007615 TO fd_eid;

-- ���̺�� �ٲٱ�
ALTER TABLE TB_EXAM RENAME TO TB_SAMPLE1;
-- �Ǵ�
RENAME TB_SAMPLE1 TO TB_SAMPLE;

-- ���̺� �����ϱ� -----------------------------
-- DROP TABLE ���̺�� [CASCADE CONSTRAINTS];
CREATE TABLE dept (
    did CHAR(2) PRIMARY KEY,
    dname VARCHAR2(10)
);

CREATE TABLE emp6 (
    eid CHAR(3) PRIMARY KEY,
    ename VARCHAR2(10),
    did CHAR(2) REFERENCES dept
);

-- �����Ǵ� ���̺�(�θ� ���̺�)�� ���� �� ��
DROP TABLE dept; -- ERROR
DROP TABLE dept CASCADE CONSTRAINTS;
-- dept�� ���� REFERENCES �������ǵ� �Բ� ������

DESC emp6;

CREATE TABLE dept2 (
    did CHAR(2) PRIMARY KEY,
    dname VARCHAR2(10)
);

INSERT INTO dept2 VALUES ('77', '������');

SELECT * FROM dept2;

CREATE TABLE emp66 (
    eid CHAR(3) PRIMARY KEY,
    ename VARCHAR2(10),
    did CHAR(2) REFERENCES dept2 ON DELETE CASCADE
);
-- ON DELETE CASCADE : �θ�Ű ���� �����Ǹ�, �ڽ� ���ڵ�(��) �Բ� ������

INSERT INTO emp66 VALUES ('111', 'ȫ�浿', '77');

SELECT * FROM emp66;

-- ����� : DML�� DELETE ��
DELETE FROM dept2
WHERE did = '77';

SELECT * FROM dept2;
SELECT * FROM emp66;

DROP TABLE dept2 CASCADE CONSTRAINTS;

-- **********************************************************
-- DML (Data Manipulation Language : ������ ���۾�)
-- ��ɱ��� : INSERT, UPDATE, DELETE
-- ���̺� �����͸� �߰� ����ϰų�(����, INSERT), ��ϵ� �����͸� ����(UPDATE)�ϰų�,
-- �����Ͱ� ��ϵ� ���� ����(DELETE)�� �� �����
-- CRUD (C: INSERT, R: SELECT, U: UPDATE, D: DELETE)
-- INSERT �� : ���� �߰���
-- UPDATE �� : �� ���� ������� 
-- DELETE �� : �� ���� �پ�� (������)
-- TRUNCATE �� : ���̺��� ��� ���� ������ (���� �� ��)

SELECT * FROM employee;

-- UPDATE �� ---------------------------------------------
/*
������ ��ϵ� ������ ���� ����(����)�ϴ� ����
�ۼ����� :
UPDATE ���̺��
SET ���ٲ��÷��� = �ٲܰ�, ���ٲ��÷��� = DEFAULT, �÷��� = (��������)
WHERE �÷��� ������ �񱳰� | (��������)

���� :
�ٲ� ���� �ش� �÷��� �������ǿ� ������� �ʾƾ� ��
*/

SELECT * FROM dcopy
ORDER BY dept_id;

UPDATE dcopy
SET dept_name = '�λ���';
--WHERE ���� �����Ǹ�, �÷� ��ü ���� ������

-- ��� ����� DML ������ ���� ��� ������
ROLLBACK;

UPDATE dcopy
SET dept_name = '�λ���'
WHERE dept_id = '10';

UPDATE dcopy
SET dept_name = 'ȫ����'
WHERE dept_id = '30';

-- UPDATE �� SET ���� �ٲ� �� ��ſ� �������� ����ص� ��
-- WHERE ���� �񱳰� ��ſ� �������� ����ص� ��
SELECT * FROM emp_copy;

-- ���ϱ� ������ �����ڵ�� �޿���
-- ������ ������ �����ڵ�� �޿��� ����
SELECT job_id
FROM emp_copy
WHERE emp_name IN ('���ϱ�', '���ر�');

UPDATE emp_copy
SET job_id = (SELECT job_id
                    FROM emp_copy
                    WHERE emp_name = '���ر�'),                    
    salary = (SELECT salary
                    FROM emp_copy
                    WHERE emp_name = '���ر�')
WHERE emp_name = '���ϱ�';

-- UPDATE �� Ȯ��
SELECT emp_name, job_id, salary
FROM emp_copy
WHERE emp_name IN ('���ϱ�', '���ر�');

-- ���߿� ������ �������� ���� :
UPDATE emp_copy
SET (job_id, salary) = (SELECT job_id, salary
                            FROM emp_copy
                            WHERE emp_name = '���ر�')
WHERE emp_name = '���ϱ�';

-- SET ���� �ٲ� ���� DEFAULT ����ص� ��
-- �ٲ� �÷��� DEFUALT�� �����Ǿ� ������ �⺻������ �����
-- DEFAULT�� ���� �ȵ� �÷��� DEFAULT ����ϸ� NULL�� ó����
ALTER TABLE emp_copy
MODIFY (marriage DEFAULT 'N');

-- ������ Ȯ��
SELECT emp_name, marriage
FROm emp_copy
WHERE emp_id = '210';

-- ������ Ȯ��
UPDATE emp_copy
SET marriage = DEFAULT
WHERE emp_id = '210';

-- UPDATE �� WHERE ������ �������� ���� ����
-- �ؿܿ���2�� �������� ���ʽ�����Ʈ�� ��� 0.3���� ����

UPDATE emp_copy
SET bonus_pct = 0.3
WHERE dept_id = (SELECT dept_id
                            FROM department
                            WHERE dept_name = '�ؿܿ���2��'
                            );

-- Ȯ��
SELECT emp_name, bonus_pct, dept_id
FROM emp_copy
WHERE dept_id = (SELECT dept_id
                            FROM department
                            WHERE dept_name = '�ؿܿ���2��'
                            );
ROLLBACK;                            
   
-- SET ���� ���氪�� �������� ������� �ʴ� ���̾�� �Ѵ�
ALTER TABLE emp_copy
ADD CONSTRAINT fk_did_ecopy FOREIGN KEY (dept_id) REFERENCES department;

-- �����÷��� �� Ȯ��
SELECT dept_id
FROM department;

UPDATE emp_copy
SET dept_id = '65'
WHERE dept_id IS NULL; -- ������� �ʴ� ���� : ERROR

UPDATE emp_copy
SET emp_no = NULL -- NOT NULL ���������� ���� : ERROR
WHERE emp_id = '100';

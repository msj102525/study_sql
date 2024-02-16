-- 17_DDL_INDEX.sql

-- �ε��� (INDEX)
-- SQL ���� (SELECT, DML)�� ó�� �ӵ��� ����Ű�� ���� �÷��� ���� �����ϴ� �����ͺ��̽� ��ü��
-- �ε��� ���� ������ B* Ʈ��(����Ž��Ʈ�� : BST, Binary Search Tree)��
-- �ε��� ��ü�� �����ϴµ� �ð��� �ʿ��ϰ�, ������ �ʿ��� => �ݵ�� ���� ���� �ƴ�
-- �ε��� ���� �Ŀ� DML �۾��� �����ϸ�, �ε����� ����� �÷���(Ű����)�� ����ǹǷ� B*Ʈ�� ���� ������
-- �ٽ� ������ �Ǿ�� ������(�ڵ�) DML �۾��� �ξ� ���ſ����� ��

-- ����
-- �˻� �ӵ��� ����
-- �ý��ۿ� �ɸ��� ���ϸ� �ٿ��� �ý��� ��ü ������ ����Ŵ

-- ����
-- �ε����� ���� �߰����� ������ �ʿ���
-- �ε����� �����ϴ� �� �ð��� �ɸ�
-- ���̺� DML(INSERT, UPDATE, DELETE) �� ���� �߻��ϴ� ���, �ε��� Ʈ�� �籸�� �ڵ� ����ǹǷ�
-- ������ ������ ���ϵ�

-- �ε��� ���� ����
/*
CREATE [UNIQUE] INDEX �ε����̸�
ON ���̺�� (�÷���[, �÷���, ....] | �Լ�����);
*/

-- �ε��� ���� : NONUNIQUE INDEX, UNIQUE INDEX

-- UNIQUE INDEX : 
-- �÷��� UNIQUE �������� ������ �Ͱ� ���� => ���� �� �ι� ��� ���� (�ߺ� �˻�)
-- PRIMARY KEY ���������� ������ �÷��� ���� �ڵ����� UNIQUE INDEX �� ������

-- NONUNIQUE INDEX :
-- ����ϰ� ����ϴ� �Ϲ� �÷��� �����ϴ� �ε�����
-- ���� ����� ���� ����

SELECT * FROM USER_OBJECTS;

-- UNIQUE INDEX ����� :
CREATE UNIQUE INDEX IDX_DNM
ON DEPARTMENT (dept_name);

-- �ε��� �ڵ����� ����� �� : 
-- SELECT, UPDATE, DELETE ���� ���� ����
-- WHERE ��, JOIN �÷� ����

-- �ε��� ���� �ǽ� ---------------------------------------

-- 1. EMPLOYEE ���̺��� EMP_NAME �÷���
-- 'IDX_ENM' �̸��� UNIQUE INDEX ����

CREATE UNIQUE INDEX IDX_ENM
ON employee (emp_name);

-- 2. �Ʒ��� ���� ���ο� �����͸� �Է��� ����, ���������� ������ ����
CREATE SEQUENCE SEQ_EID
START WITH 400
NOMAXVALUE
NOCYCLE NOCACHE;

INSERT INTO employee (emp_id, emp_no, emp_name)
VALUES (SEQ_EID.NEXTVAL, '990909-1234567', '���켷');

-- �������� :
-- employee�� emp_name �÷��� '���켷' �̸��� �̹� �Ǥ�����
-- UNIQUE INDEX�� UNIQUE ���� ������ ����� ������ => ���� �� �� �� ��� ���ϰ� ��

-- 3. EMPLOYEE ���̺��� DEPT_ID �÷���
-- 'IDX_DID' �̸��� UNIQUE INDEX�� ������ ����
-- ���� ������ �����ϰ� �ۼ�
CREATE UNIQUE INDEX IDX_DID
ON employee (dept_id);

-- ���� ���� : 
-- dept_id �÷��� �̹� �ߺ����� ���� �� ����ϰ� �ִ� �÷���
-- UNIQUE INDEX ���� �� ��

-- �ε��� ������ ���� : ALTER INDEX ����

-- �ε��� ���� ---------------------------------------------------------
-- ���̺��� �����Ǹ�, �ε����� �Բ� �ڵ� ������
-- DROP INDEX �ε����̸�;
DROP INDEX IDX_ENM;

-- �ε��� ���� ��ųʸ� ���� Ȯ��
DESC USER_INDEXES;
DESC USER_IND_COLUMNS;

SELECT INDEX_NAME, COLUMN_NAME, TABLE_NAME, INDEX_TYPE, UNIQUENESS
FROM USER_INDEXES
JOIN USER_IND_COLUMNS USING (INDEX_NAME, TABLE_NAME)
WHERE TABLE_NAME = 'EMPLOYEE';

-- �˻� �ӵ� ���� ����
-- EMPLOYEE ���̺��� ��� ������ �������� ����ؼ� ������ EMP01, EMPL02 ���̺� ����
-- EMPL01 �� EMP_ID �÷��� ���� UNIQUE INDEX ����� : IDX_EID
-- �˻� �ӵ� �񱳸� ���� SELECT �������� EMP_ID �÷����� ��ȸ�� ���� : ��� 141 �� ������ȸ
CREATE TABLE EMP01
AS
SELECT * FROM employee;

CREATE TABLE EMP02
AS
SELECT * FROM employee;

CREATE UNIQUE INDEX IDX_EID
ON EMP01(emp_id);

SELECT * FROM EMP01
WHERE emp_id = '141';  -- 0.005

SELECT * FROM EMP02
WHERE emp_id = '141'; -- 0.007

-- ���� �ε��� ----------------------
-- ���� �ε��� : �� ���� �÷����� ������ �ε���
-- ���� �ε��� : �� ���̻��� �÷����� ������ �ε���
CREATE TABLE DEPT01
AS
SELECT * FROM department;

-- �μ���ȣ�� �μ����� �����ؼ� �ε��� �����
CREATE INDEX IDX_DEPT01_COMP
ON DEPT01 (dept_id, dept_name);


-- ������ ��ųʸ����� Ȯ�� : 
SELECT INDEX_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'DEPT01';

-- �Լ� ��� �ε��� ---------------------------------
-- SELECT ���̳� WHERE ���� ��������̳� �Լ����� ����ϴ� ���
-- ������ �ε����� ������ ���� �ʴ´�. (�ε����� ����� �������� ����)
-- ��� ������� Ű����� �ؼ� �˻� Ʈ���� ������ �� ����
-- �������� �˻��ϴ� ��찡 ���ٸ�, �����̳� �Լ����� �ε����� ����

CREATE TABLE EMPL03
AS
SELECT * FROM EMPLOYEE;

CREATE INDEX IDX_EMPL03_SALCALC
ON EMPL03 ((salary + (salary * NVL(bonus_pct, 0)) * 12));

-- ������ ��ųʸ����� Ȯ�� : 
SELECT INDEX_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'EMPL03';

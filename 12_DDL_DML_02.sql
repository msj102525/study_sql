-- 12_DDL_DML_02

-- DDL : CREATE TABLE - ��������(CONSTRAINT) : FOREIGN KEY �������� --------------------
-- �ٸ� ���̺�(�θ� ���̺�)���� �����ϴ� ��(�����÷�)�� ����ϴ� �÷�(�ڽ� ���ڵ�) ������ �� �̿��ϴ� ��������
-- �÷����� : [CONSTRAINT �̸�] REFERENCES �������̺�� [(�����÷���)]
-- ���̺��� : [CONSTRAINT �̸�] FOREIGN KEY (�������÷���) REFERENCES �������̺�� [(�����÷���)}
-- �����÷��� �ݵ�� PRIMARY KEY �Ǵ� UNIQUE ���������� ������ �÷��̾�� ��
-- (�����÷���)�� �����Ǹ� �������̺��� PRIMARY KEY �÷��� ����Ѵٴ� �ǹ���
-- ������� : �θ� �����ϴ� ���� ����� �� �ִ�. �������� �ʴ� �� ����ϸ� ���� �߻���
-- NULL �� ��� ������

CREATE TABLE testfk (
    emp_id CHAR(3) REFERENCES employee -- PRIMARY KEY �÷��� �����
    , dept_id CHAR(2) CONSTRAINT tfk_did REFERENCES department (dept_id)
    , job_id CHAR(2)
    -- ���̺���
    , CONSTRAINT tfk_jid FOREIGN KEY (job_id) REFERENCES job (job_id)
);
DROP table testfk;
desc testfk;

-- ���� ���̺�(�θ� ���̺�)�� �����÷��� �ִ� ���� ��Ͽ� ����� �� �ִٴ� ����������
INSERT INTO testfk VALUES ('300', NULL, NULL); -- ERROR �������� �ʴ� �� ���
INSERT INTO testfk VALUES ('100', NULL, NULL);
INSERT INTO testfk VALUES('200', '70', NULL); -- ERROR : ���� �μ��ڵ� �� ���
INSERT INTO testfk VALUES('200', '90', NULL);
INSERT INTO testfk VALUES ('200', '80', 'j7'); -- ERROR : ��ҹ��� Ʋ��, ���� �����ڵ���
INSERT INTO testfk VALUES ('200', '80', 'J7');

SELECT * FROM testfk;

-- ���� ���̺�(�θ� ���̺�)�� �����÷�(�θ�Ű)�� �� �߿���, �ڽķ��ڵ尡 ����ϰ� �ִ� �� ���� �� ��
-- �� : �μ� ���̺��� 90�� �μ��� ���� (�� ����)
-- DML �� DELETE �� ���
/*
DELETE FROM ���̺��
WHERE �÷��� = �����Ұ�; -- ������ ���� �ִ� ���� ã�Ƽ� �����ض�.
*/
DELETE FROM department
WHERE dept_id = '90'; -- ERROR : �ڽ� ���ڵ尡 �����ϸ�(���� ������̸�) ���� �� ��

-- FOREIGN KEY �������� ������ ���� �ɼ��� �߰��� �� ����
-- ���� �ɼ�(DELETION OPTION) :
-- RESTRICTED (���� �� ��, �⺻), SET NULL(�ڽķ��ڵ� NULL�� �ٲ�), CASCADE(�Բ� ����)

-- ON DELETE SET NULL -----------------
-- �θ�Ű �� ������ �ڽ� ���ڵ��� �÷����� NULL�� �ٲ�

-- �θ�Ű ���� ���̺� : 
CREATE TABLE product_state (
    pstate char(1) PRIMARY KEY,
    pcomment VARCHAR2(10)
);

INSERT INTO product_state VALUES ('A', '�ְ��');
INSERT INTO product_state VALUES ('B', '����');
INSERT INTO product_state VALUES ('C', '������');

SELECT * FROM product_state;

-- �ܷ�Ű(FOREIGN KEY) ���� ���̺� :
CREATE TABLE product (
    pname VARCHAR2 (20) PRIMARY KEY,
    pprice NUMBER CHECK (pprice > 0),
    pstate CHAR(1) REFERENCES product_state ON DELETE SET NULL
);

INSERT INTO product VALUES ('������', 654000, 'A');
INSERT INTO product VALUES ('G9', 874500, 'B');
INSERT INTO product VALUES ('�ƺ�', 2500000, 'C');

SELECT * FROM product;

SELECT *
FROM product
NATURAL JOIN product_state;

-- �θ�Ű �� ���� Ȯ��
DELETE FROM product_state
WHERE pstate = 'A'; -- �����, ���� �� ��

-- �ڽķ��ڵ� �� Ȯ�� : NULL �� �ٲ� �� Ȯ��
SELECT * FROM product;

-- ON DELETE CASCADE -------------------------
-- �θ�Ű �� ������ �ڽ� ���ڵ� �൵ �Բ� ������

-- �ڽ� ���ڵ�� ���̺� :
CREATE TABLE product2 (
    pname VARCHAR2 (20) PRIMARY KEY,
    pprice NUMBER CHECK (pprice > 0),
    pstate CHAR(1) REFERENCES product_state ON DELETE CASCADE
);

INSERT INTO product2 VALUES ('G9', 874500, 'B');
INSERT INTO product2 VALUES ('�ƺ�', 2500000, 'C');

SELECT * FROM product2;

-- �θ�Ű �� ���� :
DELETE FROM product_state
WHERE pstate = 'B';

-- �ڽ� ���ڵ� Ȯ��; ���� �Բ� ������ �� Ȯ��
SELECT * FROM product2;

CREATE TABLE constraint_emp (
    eid CHAR(3) CONSTRAINT pkeid PRIMARY KEY,
    ename VARCHAR2(20) CONSTRAINT nename NOT NULL,
    eno CHAR(14) CONSTRAINT neno NOT NULL CONSTRAINT ueno UNIQUE,
    email VARCHAR2(25) CONSTRAINT uemail UNIQUE,
    phone VARCHAR2(12),
    hire_date DATE DEFAULT SYSDATE,
    jid CHAR(2) CONSTRAINT fkjid REFERENCES job ON DELETE SET NULL,
    salary NUMBER,
    bonus_pct number,
    marriage CHAR(1) DEFAULT 'N' CONSTRAINT chk CHECK (MARRIAGE IN ('Y', 'N')),
    mid CHAR(3) CONSTRAINT fkmid REFERENCES constraint_emp ON DELETE SET NULL,
    did CHAR(2),
    CONSTRAINT fkdid FOREIGN KEY (did) REFERENCES department ON DELETE CASCADE
    );
    
-- ���������� ����ؼ� �� ���̺� ����� -----------------------------
-- ���� ��� �Ǵ� SELECT �� ����� ���̺�� �����ϴ� �뵵��
-- CREATE TABLE ���̺�� AS ��������;

CREATE TABLE emp_copy90
AS
SELECT * FROM employee
WHERE dept_id = '90';

SELECT * FROM emp_copy90;

-- ���̺� ���� Ȯ�� : DESCRIBE ��� ���
DESC emp_copy90;

-- ���̺� ���纻 �����
CREATE TABLE emp_copy
AS
SELECT * FROM employee;

SELECT * FROM emp_copy;
-- ���������� �̿��ؼ� ���� ���̺��� ������ ���
-- �÷���, �ڷ���, NOT NULL ��������, ��(DATA)�� �״�� �����
-- ������ �������ǵ��� ���� �ȵ�, DEFAULT ������ ���� �ȵ�

-- �ǽ� : 1
-- ��� �������� ���, �̸�, �޿�, ���޸�, �μ���, �ٹ�������, �Ҽӱ����� ��ȸ�� �����
-- EMP_LIST ���̺� ����
CREATE TABLE emp_list
AS
SELECT
    emp_no,
    emp_name,
    salary,
    dept_name,
    loc_describe,
    country_name
FROM employee e
LEFT JOIN department d USING(dept_id)
LEFT JOIN location l ON l.location_id = d.loc_id
LEFT JOIN country c USING(country_Id);
SELECT * FROM emp_list;

-- �ǽ� 2 :
-- EMPLOYEE ���̺��� ���� ���� ������ ��󳻼�, EMP_MAN ���̺� ����
-- �÷��� ��� ����
CREATE TABLE emp_man
AS
SELECT *
FROM employee
WHERE SUBSTR(emp_no, 8,1) IN (1, 3);
SELECT * FROM emp_man;

-- �ǽ� 3:
-- ���� �������� ������ ��󳻼�, emp_femail ���̺� ����
-- �÷��� ��� ����
CREATE TABLE emp_femail
AS
SELECT *
FROM employee
WHERE SUBSTR(emp_no, 8,1) IN (2, 4);
SELECT * FROM emp_femail;

-- �ǽ� 4:
-- �μ����� ���ĵ� �������� ����� PART_LIST ���̺� ����
-- DEPT_NAME, JOB_TITLE, EMP_NAME, EMP_ID ������ �÷� ����
-- PART_LIST�� �÷� ���� �߰��� : �μ��̸�, �����̸�, �����̸�, ���
CREATE TABLE part_list
AS
SELECT
    d.dept_name,
    j.job_title,
    e.emp_name,
    e.emp_id 
FROM
    employee e
LEFT JOIN department d ON d.dept_id = e.dept_id
LEFT JOIN job j ON j.job_id = e.job_id
ORDER BY dept_name;

COMMENT ON COLUMN part_list.dept_name IS '�μ��̸�';
COMMENT ON COLUMN part_list.job_title IS '�����̸�';
COMMENT ON COLUMN part_list.emp_name IS '�����̸�';
COMMENT ON COLUMN part_list.emp_id IS '���';
SELECT * FROM part_list;
DESC part_list;

-- �ǽ� : ���������� ������ ���̺� �����
-- ���̺�� : PHONEBOOK
-- �÷��� :  ID  CHAR(3) �⺻Ű(�����̸� : PK_PBID)
--         PNAME      VARCHAR2(20)  �� ������.
--                                 (NN_PBNAME) 
--         PHONE      VARCHAR2(15)  �� ������
--                                 (NN_PBPHONE)
--                                 �ߺ��� �Է¸���
--                                 (UN_PBPHONE)
--         ADDRESS    VARCHAR2(100) �⺻�� ������
--                                 '����� ���α�'

-- NOT NULL�� �����ϰ�, ��� ���̺� �������� �������� ������.

CREATE TABLE phonebook(
    id CHAR(3) CONSTRAINT pk_pbid PRIMARY KEY,
    pname VARCHAR2(20) CONSTRAINT nn_pbname NOT NULL,
    phone VARCHAR2(14) CONSTRAINT nn_pbphone NOT NULL CONSTRAINT un_pbphone UNIQUE,
    address VARCHAR2(100) DEFAULT '����� ���α�'
);

DESC phonebook;

INSERT INTO phonebook
VALUES ('A01', 'ȫ�浿', '010-1234-5678', DEFAULT);

SELECT * FROM phonebook;

-- ���������� �� ���̺� ���� ��,
-- ���������� SELECT �� �÷����� ������� �ʰ�, �� ���̺��� �÷����� �ٲ� ���� ����
CREATE TABLE job_copy
AS
SELECT * FROM job;

SELECT * FROM job_copy;
DESC job_copy;

-- ���̺� ���� : DROP TABLE ���̺��;
DROP TABLE job_copy;

CREATE TABLE job_copy (�����ڵ�, ���޸�, �����޿�, �ְ�޿�) -- ��ü �÷��� ����
AS
SELECT * FROM job;

SELECT * FROM job_copy;
DESC job_copy;

-- �Ϻ� �׸� ��� �÷����� �ٲٰ��� �Ѵٸ�
CREATE TABLE dcopy (did, dname) -- �������� SELECT ���� �׸�� ������ �ٸ�, ERROR
AS
SELECT dept_id, dept_name, loc_id
FROM department;

-- �ذ�
CREATE TABLE dcopy -- �������� SELECT ���� �׸�� ������ �ٸ�, ERROR
AS
SELECT dept_id did, dept_name dname, loc_id
FROM department;

DESC dcopy;

-- ���������� �� ���̺� ���� ��, �÷��� �ٲٸ鼭 �������ǵ� �߰��� �� ����
-- ��, �ܷ�Ű(FOREIGN KEY) ���������� �߰��� �� ����
DROP TABLE tbl_subquery;

CREATE TABLE tbl_subquery (
    eid PRIMARY KEY,
    ename,
    sal CHECK (sal > 2000000), -- ���� : �������� ����� 2�鸸���� ���� ���� ������
    dname,
--    did  REFERENCES deapartment, -- �ܷ�Ű ���������� �߰��� �� ����
    jtitle NOT NULL) -- ���� : �������� ��� �÷��� NULL�� ������
AS
SELECT emp_id, emp_name, salary, dept_name, -- dept_id 
            -- �ذ� : NULL�� �ٸ� ������ �ٲٴ� ���
            NVL(job_title, '������')
FROM employee
LEFT JOIN job USING (job_id)
LEFT JOIN department USING (dept_id)
-- �ذ� : ���ǰ��� �ش�Ǵ� ���� ��ϵǰ� ���� ó����
WHERE salary > 2000000;

DESC tbl_subquery;
SELECT * FROM tbl_subquery;


-- ������ ��ųʸ� (������ ����) ------------------------------------
-- ����ڰ� ������ ��� ��ü�������� ���̺� ���·� DBMS�� �ڵ� ���� ������
-- ��, ����ڰ� ������ �������ǵ� �ڵ� ����ǰ� ���� >>  USER_CONSTRAINTS
-- ����� ������ ��ȸ�� �� �� ����
-- ��ųʸ��� ����ڰ� ���� �Ǵ� ������ �� ���� (DBMS�� �ڵ����� ������)

DESC USER_CONSTRAINTS;

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'PHONEBOOK';

-- CONSTRAINT_TYPE
-- P : PRIMARY KEY
-- U : UNIQUE
-- R : FOREIGN KEY
-- C : CHECK, NOT NULL

-- ����ڰ� ���� ���̺� ���� : USER_TABLES, USER_CATEGORY, USER_OBJECTS
DESC USER_TABLES;

SELECT * FROM USER_TABLES;

-- ����ڰ� ���� ������ ��ü
SELECT * FROM USER_SEQUENCES;

-- ����ڰ� ���� �� ��ü
SELECT * FROM USER_VIEWS;

-- ���� ����ڰ� ������ �� �ִ� ��� ���̺���� ��ȸ
SELECT * FROM ALL_TABLES;

-- DBA (DataBase Administrator : �����ͺ��̽� ������)�� ������ �� �ִ� ���̺� ��ȸ
-- DBA_TABLES
SELECT * FROM DBA_TABLES; -- �����ڰ������� Ȯ���ؾ� ��



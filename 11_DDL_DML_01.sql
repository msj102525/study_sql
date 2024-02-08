-- 11_DDL_DML_01.sql

-- DDL (Data Definition Language : ������ ���Ǿ�)
-- ��ɾ� : CREATE, ALTER, DROP
-- �����ͺ��̽� ��ü�� ����, ����, �����ϴ� ������
-- ���̺� ��ü : CREATE TABLE, ALTER TABLE, DROP TABLE
-- �� ��ü : CREATE VIEW, DROP VIEW
-- ������ ��ü : CREATE SEQUENCE, ALTER SEQUENCE, DROP SEQUENCE
-- ����� ��ü : CREATE USER, ALTER USER, DROP USER

-- ���̺� �����
/*
CREATE TABLE ���̺�� (
    �÷���   �����ڷ���,
    �÷���   �����ڷ���(����� �ִ� ����Ʈ ũ��),
    �÷���   ��¥�ڷ���
);

���̺��� �ּ� 1���� �÷��� ������ �� => �÷����� �� ���̺� ���� �� ����
*/

DROP TABLE TEST;

CREATE TABLE TEST (
    ID      NUMBER,
    NAME    VARCHAR2(20),
    ADDRESS VARCHAR2(100),
    ENROLL_DATE   DATE DEFAULT SYSDATE
);

CREATE TABLE TEST2 ();  -- ERROR, �÷� ����

-- ���̺� ���� Ȯ�� ��ɾ� : DESCRIBE ���̺��;
DESCRIBE TEST;
-- ���Ӹ� ��� ���� : DESC ���̺��;
DESC TEST;

-- ���̺� ���� �ǽ� : 
CREATE TABLE ORDERS (
    ORDERNO     CHAR(4),
    CUSTNO      CHAR(4),
    ORDERDATE   DATE    DEFAULT SYSDATE,
    SHIPDATE    DATE,
    SHIPADDRESS VARCHAR2(40),
    QUANTITY    NUMBER
);

DESC ORDERS;

-- �÷��� ���� �߰� : 
-- COMMENT ON COLUMN ���̺��.�÷��� IS '����';
COMMENT ON COLUMN ORDERS.ORDERNO IS '�ֹ���ȣ';
COMMENT ON COLUMN ORDERS.CUSTNO IS '����ȣ';
COMMENT ON COLUMN ORDERS.ORDERDATE IS '�ֹ�����';
COMMENT ON COLUMN ORDERS.SHIPDATE IS '�������';
COMMENT ON COLUMN ORDERS.SHIPADDRESS IS '����ּ�';
COMMENT ON COLUMN ORDERS.QUANTITY IS '�ֹ�����';

-- ******************************************************
-- ���Ἲ �������ǵ� (CONSTRAINTS)
-- NOT NULL, UNIQUE, PRIMARY KEY, CHECK, FOREIGN KEY

-- 1. NOT NULL ��������
-- �÷��� �ݵ�� ���� ����ؾ� �� (�ʼ� �Է��׸��� ����)
-- �÷��� NULL ��� �� �Ѵٴ� ����������
-- NULL �� ���Ǹ� ���� �߻���
-- ���� : �÷����������� ������ �� ���� (���̺� �������� ���� �� ��)
-- �÷����� : �÷��� �ڷ��� [DEFAULT �⺻��] NOT NULL

CREATE TABLE TESTNN (
    NID     NUMBER(5)   NOT NULL,  -- �÷� ����
    N_NAME  VARCHAR2(30)
);

-- ���̺� ������ ��� Ȯ��
-- DML �� INSERT ��ɹ� �����
INSERT INTO TESTNN (NID, N_NAME)
VALUES (1, '�׽���');

INSERT INTO TESTNN (NID, N_NAME)
VALUES (NULL, '�׽���2');  -- ERROR

INSERT INTO TESTNN (NID, N_NAME)
VALUES (2, NULL);  -- OK

SELECT * FROM TESTNN;

-- ���������� DBMS �� �̸����� ������
-- �������� ������ �̸��� �������� ������, �ڵ����� SYS_C....... �������� �ο���
CREATE TABLE TESTNN2 (
    N_ID   NUMBER(5) CONSTRAINT T2_NID NOT NULL,  -- �÷�����
    N_NAME  VARCHAR2(20CHAR)
    -- ���̺������� ���������� ������ �� ����
    -- ������������(������ �÷���)
    -- CONSTRAINT �������̸� ������������(�������÷���)
    --, CONSTRAINT T2_NNAME NOT NULL(N_NAME)  -- ERROR
);


-- 2. UNIQUE �������� -------------------------------------------
-- ���� �÷��� �ߺ���(���� �� �ι� ���) �Է��� �˻��ϴ� ����������
-- ���� ���� �ι� ��� ���ϴ� �÷��� ��
-- NULL �� ����� �� ����
-- ����Ű(���� ���� �÷��� ����)�� ������ ���� ����

CREATE TABLE TESTUN (
    U_ID    CHAR(3)   UNIQUE,
    U_NAME  VARCHAR2(10)  NOT NULL
);

INSERT INTO TESTUN (U_ID, U_NAME) VALUES ('AAA', '����Ŭ');
INSERT INTO TESTUN (U_ID, U_NAME) VALUES ('AAA', '�ڹ�');  -- ����
INSERT INTO TESTUN (U_ID, U_NAME) VALUES ('AAB', '�ڹ�'); 
INSERT INTO TESTUN (U_ID, U_NAME) VALUES (NULL, '�ڹ�'); -- NULL ��� ����

SELECT * FROM TESTUN;

-- �������� ������ �̸� �ο���
-- �÷����� : CONSTRAINT �̸� ������������
-- ���̺��� : CONSTRAINT �̸� ������������ (�������÷���)
CREATE TABLE TESTUN2 (
    UN_ID  CHAR(3)   CONSTRAINT T2_UID UNIQUE
    , UN_NAME  VARCHAR2(10)  CONSTRAINT T2_UNAME NOT NULL
);

-- ���̺��� ����
CREATE TABLE TESTUN3 (
    UN_ID  CHAR(3)   
    , UN_NAME  VARCHAR2(10)  CONSTRAINT T3_UNAME NOT NULL
    -- ���̺���
    , CONSTRAINT T3_UID UNIQUE (UN_ID)
);


-- 3. PRIMARY KEY ��������  ---------------------------------
-- NOT NULL + UNIQUE
-- ���̺��� �� ���� ������ ã�� ���� �̿��� �� �ִ� �ĺ���(IDENTIFIER) ������ ����ϴ� ����������
-- ����Ű(���� ���� �÷��� ����)�� ������ �� ����
-- �� ���̺� �ѹ��� ����� �� ����

CREATE TABLE TESTPK (
    P_ID   NUMBER  PRIMARY KEY,
    P_NAME  VARCHAR2(10)  NOT NULL,
    P_DATE  DATE  DEFAULT SYSDATE
);

INSERT INTO TESTPK (P_ID, P_NAME) VALUES (1, 'ȫ�浿');
INSERT INTO TESTPK VALUES (2, '�ڹ���', SYSDATE);
-- INSERT �� �÷��� �����ϸ�, ���̺��� ��� �÷��� ���� ����Ѵٴ� �ǹ���
INSERT INTO TESTPK VALUES (NULL, '�ڹ���', DEFAULT);  -- ERROR : NULL ��� �� ��
INSERT INTO TESTPK VALUES (2, 'ȫ�浿', DEFAULT);  -- ERROR : �ߺ��� ��� �� ��
INSERT INTO TESTPK VALUES (3, '�̼���', DEFAULT);

SELECT * FROM TESTPK;

CREATE TABLE TESTPK2 (
    PID  NUMBER  PRIMARY KEY,
    PNAME  VARCHAR2(10)  PRIMARY KEY
);  -- ERROR : �� ���̺� �⺻Ű(PRIMARY KEY)�� �Ѱ��� ����� �� ����

-- �÷�����
CREATE TABLE TESTPK2 (
    PID NUMBER CONSTRAINT T2_PID PRIMARY KEY
    , PNAME VARCHAR2(15)
    , PDATE DATE
);

-- ���̺���
CREATE TABLE TESTPK3 (
    PID NUMBER 
    , PNAME VARCHAR2(15)
    , PDATE DATE
    -- ���̺���
    , CONSTRAINT T3_PID PRIMARY KEY (PID)
);


-- 4. CHECK �������� --------------------------------
-- �÷��� ��ϵǴ� ���� ���� ���� �����ϴ� ����������
-- CHECK (�÷��� ������ ���ǰ�)
-- ���� : ���ǰ��� �ٲ�� ���� ����� �� ���� (SYSDATE ����)

CREATE TABLE TESTCHK (
    C_NAME  VARCHAR2(15)  CONSTRAINT TCK_NAME NOT NULL
    , C_PRICE  NUMBER(5)  CHECK (C_PRICE BETWEEN 1 AND 99999)
    , C_LEVEL  CHAR(1)  CHECK (C_LEVEL IN ('A', 'B', 'C'))
);

INSERT INTO TESTCHK VALUES ('������S22', 54000, 'A');
INSERT INTO TESTCHK VALUES ('LG G9', 125000, 'A');  -- ERROR : C_PRICE CHECK �������� �����
INSERT INTO TESTCHK VALUES ('LG G9', 0, 'A');   -- ERROR : C_PRICE CHECK �������� �����
INSERT INTO TESTCHK VALUES ('LG G9', 65000, 'D');  -- ERROR : C_LEVEL CHECK �������� �����

SELECT * FROM TESTCHK;

CREATE TABLE TESTCHK2 (
    C_NAME VARCHAR2(15 CHAR) PRIMARY KEY
    , C_PRICE  NUMBER(5)  CHECK (C_PRICE >= 1 AND C_PRICE <= 99999)
    , C_LEVEL  CHAR(1)  CHECK (C_LEVEL = 'A' OR C_LEVEL = 'B' OR C_LEVEL = 'C')
    --, C_DATE  DATE  CHECK (C_DATE < SYSDATE)  -- ERROR : ���� �ٲ�� �� ���� �� ��
    -- , C_DATE  DATE  CHECK (C_DATE < TO_DATE('24/12/31'))  -- ERROR : BUG
    -- , C_DATE  DATE  CHECK (C_DATE < TO_DATE('24/12/31', 'RR/MM/DD'))  -- ERROR : BUG
    , C_DATE  DATE  CHECK (C_DATE < TO_DATE('24/12/31', 'YYYY/MM/DD'))  -- BUG
);








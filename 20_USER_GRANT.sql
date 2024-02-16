-- 20_USER_GRANT.sql

-- ����� ����
-- ����� ������ ��ȣ ����, ���� �ο� / ���� ȸ��

/*
* ����Ŭ �����ͺ��̽��� ��ġ�ϸ�, �⺻������ �����Ǵ� ������
    SYS
    SYSTEM (XE ��⿡���� ������ ������)
    SYSDAB
    HR (���� ���� : ó������ LOCK ������, 10g������ ������)
    SCOTT (������ ���� ���� : ������ ���� LOCK ������ �� ����)

* �����ͺ��̽� ������ (DBA) ���ȼ��� : 
    - ����ڰ� �����ͺ��̽��� ��ü (���̺�, �� ��)�� ���� Ư�� ���� ������
      ���� �� �ְ� ������
    - �ټ��� ����ڰ� �����ϴ� �����ͺ��̽� ������ ���� ���� ������
    - �����ͺ��̽��� �����ϴ� ����ڸ��� ���� �ٸ� ���Ѱ� ���� �ο���

* ���� : 
    ����ڰ� Ư�� ���̺� ������ �� �ֵ��� �ϰų�,
    �ش� ���̺� SQL(SELECT, INSERT, UPDATE, DELETE)����
    ����� �� �ֵ��� ������ �δ� ��
    
    - �ý��� ���� : 
        �����ͺ��̽� �����ڰ� ������ �ִ� ����
        CREATE USER (����� ���� �����)
        DROP USER (����� ���� ����)
        DROP ANY TABLE (������ ���̺� ����)
        QUERY REWRITE (�Լ� ��� �ε��� ����)
        BACKUP ANY TABLE (���̺� ���)
    
    - �ý��� �����ڰ� ����ڿ��� �ο��ϴ� ����
        CREATE SESSION (�����ͺ��̽��� ����)
        CREATE TABLE (���̺� ����)
        CREATE VIEW (�� ����)
        CREATE SEQUENCE (������ ����)
        CREATE PROCEDURE (���ν��� ����)
    
    - ��ü ���� :
        ��ü�� ������ �� �ִ� ����    
*/

-- ����� ���� ���� :
-- �����ͺ��̽��� ������ �� �ִ� ���̵�� ��ȣ �����
-- �ۼ����� : 
-- CREATE USER ���̵� IDENTIFIED BY ��ȣ;

-- �ý��۰����� ����
-- SQL> conn system/��ġ�� ������ ��ȣ

-- ������ ���� Ȯ��
-- SQL> show user

-- ���ο� ����� ������ ��ȣ ����� : 
-- ����Ŭ Ŭ���� ���������� ������ 'C##' + ���̵� �� �ۼ���
CREATE USER C##USER01 IDENTIFIED BY PASS01;

-- ���� ���� �������� ���� Ȯ�� : ���� �߻�
-- �����ͺ��̽� ���� ������ ����
CONNECT C##USER01/PASS01

-- ���� �ο��ϱ� : GRANT ��ɾ� ���
-- ������� : 
-- GRANT ��������, .... TO ����ھ��̵� [WITH ADMIN OPTION];

-- ����ھ��̵� ��ſ� PUBLIC �� ����ص� ��
-- GRANT ��������, .... TO PUBLIC [WITH ADMIN OPTION];
-- �ش� ������ ��� ����ڿ��� �ο��Ѵٴ� �ǹ���

-- WITH ADMIN OPTION : 
-- �ش� ���ѿ� ���� �ý���(������)������ �ο��Ѵٴ� �ǹ���
-- �ش� ����ڰ� �ٸ� ����ڿ��� ������ ������ �ο��� �� �ְ� ��

-- �α��� ���� �ο��ϱ� : 
GRANT CREATE SESSION TO C##USER01;

-- SQL> CONN C##USER01/PASS01
-- SQL> SHOW USER

-- C##USER01 ���� ���̺� ���� : 

CREATE TABLE EMP01 (
    ENO  NUMBER(4),
    ENAME VARCHAR2(20),
    JOB VARCHAR2(10),
    DPTNO  NUMBER(2)
);

-- ���� ����� ���� �߻���
-- �ý��۰������� CREATE TABLE ���� �ο���
GRANT CREATE TABLE TO C##USER01;

-- C##USER01 ���� ���̺� ���� Ȯ��
-- ����, ������ �ο��ߴµ��� ���̺� ������ �ȵǰ�, TABLE SPACE ���� ������
-- ǥ�õǸ� USERS �� ���̺����̽� ����(QUOTA)�� ������ ��� ��

-- ���̺����̽�(TABLESPACE) : 
-- ���̺�, ��, �׹��� �����ͺ��̽� ��ü���� ����Ǵ� ��ũ ���� ���
-- ����Ŭ ��ġ�� USERS ��� ���̺����̽��� �������
-- �Ϲ� ����ڴ� USERS �ȿ� ������ �Ҵ�޾Ƽ� �����

-- �ý��� �������� �ش� ����ڰ����� ���̺� �����̽� Ȯ��
SELECT USERNAME, DEFAULT_TABLESPACE
FROM DBA_USERS
WHERE USERNAME = 'C##USER01';

-- ���̺����̽� ���� �Ҵ��ϱ� : 
ALTER USER C##USER01
--QUOTA 2M ON SYSTEM;
QUOTA 2M ON USERS;
-- QUOTA �� : 10M, 5M, UNLIMITED �� �����

/*
[����] ----------------------------------------------------------------
	����ڸ� : C##USER007
	�� ȣ : PASS007
	���̺����̽� : 3M (USERS�� �Ҵ�)
	�� �� : DB ����, ���̺� ���� �����
	=> ���� Ȯ���� ��
------------------------------------------------------------------------
*/
CREATE USER C##USER007 IDENTIFIED BY PASS007;

ALTER USER C##USER007
QUOTA 3M ON USERS;

GRANT CREATE SESSION, CREATE TABLE TO C##USER007;


-- ��ü ���� ----------------------------------
-- ���̺�, ��, ������, �Լ� �� �� ��ü���� DML ���� ����� �� �ִ� ������
-- �����ϴ� ��
/*
�ۼ����� : 
GRANT �������� [(�÷���)] | ALL
ON ��ü�� | ROLE �̸� | PUBLIC
TO ����ڸ�;

* ��������          ��� ��ü
ALTER   :       TABLE, SEQUENCE
DELETE  :       TABLE, VIEW
EXECUTE :       PROCEDURE
INDEX   :       TABLE
INSERT  :       TABLE, VIEW
REFERENCES  :   TABLE
SELECT  :       TABLE, VIEW, SEQUENCE
UPDATE  :       TABLE, VIEW

*/

-- C##USER01 �� ���� : -----------------------
-- ���̺� Ȯ��
SELECT * FROM EMP01;
DESCRIBE EMP01;

-- C##USER007 ����ڰ� C##USER01 �� ���� EMP01 ���̺��� 
-- SELECT �� �� �ִ� ������ �ο��� ��
GRANT SELECT
ON EMP01
TO C##USER007;

-- C##USER007 �� ���� : 
-- C##USER01 �� EMP01 ���̺��� SELECT �� ��
SELECT * FROM C##USER01.EMP01;

-- ����ڿ��� �ο��� ���� ��ȸ�ϱ�
-- ����� ���Ѱ� ���õ� ������ ��ųʸ� :
-- �ڽſ��� �ο��� ������ �˰��� �� �� USER_TAB_PRIVS_RECD
-- C##USER007 ���� Ȯ�� : 
SELECT * FROM USER_TAB_PRIVS_RECD;

-- ���� ����ڰ� �ٸ� ����ڿ��� �ο��� ������ �˰��� �� ��
--  USER_TAB_PRIVS_MADE
-- C##USER01 ���� Ȯ�� : 
SELECT * FROM USER_TAB_PRIVS_RECD;

-- ���� öȸ -----------------------------
-- REVOKE ��� ���
/*
������� : 
REVOKE �������� | ALL
ON ��ü��
FROM ����ڸ� | PUBLIC | ROLE �̸�;
*/

-- C##USER01 �α���
-- �ش� ����ڰ� ������ ���� Ȯ����
SELECT * FROM USER_TAB_PRIVS_MADE;

-- ���� ������
REVOKE SELECT ON EMP01 FROM C##USER007;

-- ������ ��ųʸ����� ���� Ȯ����
SELECT * FROM USER_TAB_PRIVS_MADE;

-- WITH GRANT OPTION -------------------------------
-- ����ڰ� �ش� ��ü�� ������ �� �ִ� ������ �ο������鼭
-- �� ������ �ٸ� ����ڿ��� �ٽ� �ο��� �� �ְ� ��

-- C##USER01 �α���
GRANT SELECT ON C##USER01.EMP01 TO C##USER007
WITH GRANT OPTION;

-- C##USER007 �α���
GRANT SELECT ON C##USER01.EMP01 TO C##STUDENT;
-- ���� ������ �ٸ� ����ڿ��� �ٽ� �ο��� �� ����






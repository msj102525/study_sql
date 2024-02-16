-- 19_DDL_ROLE_����.sql

-- �����ͺ��̽� ��(ROLE)
-- ����ڸ��� ������ �ϳ��� ������ �ο��ϴ� ���� ���ŷο�
-- �����ϰ� ������ �ο��� �� �ִ� ������� ROLE �� ������
-- ROLE : 
-- ���� ���� ������ ���� ���� �����ͺ��̽� ��ü��
-- ����� ���� ������ ���� �����ϰ� ȿ�������� �� �� �ְ� ��
-- �ټ��� ����ڿ��� �������� �ʿ��� ���ѵ��� �ѿ� �ϳ��� �׷����� ����ΰ�,
--    ����ڸ��� Ư�� �ѿ� ���� ������ �ο��� �� �ֵ��� ��

-- ����ڿ��� �ο��� ������ �����ϰ��� �� ���� ������ ����ڸ��� ���� �������� �ʰ�
-- �Ѹ� �����ϸ� �ش� �ѷ� ������ �ο����� ����ڵ��� ������ �ڵ� ������

-- ���� Ȱ��ȭ�ϰų�(���� �ο�) ��Ȱ��ȭ(���� öȸ)�Ͽ� �Ͻ������� ���� ���� ������

-- ���� ���� : 
-- ���� ���ǵ� �� (�����Ǵ� ��)
-- ����ڰ� ������ ��

/*
* ���� ���ǵ� ROLE : 
    ����Ŭ ��ġ�� �ý��ۿ��� �⺻������ ������
    
    - CONNECT �� : 
        ����ڰ� �����ͺ��̽��� ������ �� �ֵ��� �ý��� ���� 8������ ������
        CREATE SESSION, ALTER SESSION,
        CRTEATE TABLE, CREATE VIEW, CREATE SYNONYM,
        CREATE SEQUENCE, CREATE CLUSTER, 
        CREATE DATABASE LINK
        
    - RESOURCE �� : 
        ����ڰ� ��ü�� ������ �� �ֵ��� �ϴ� ������ ���� ����
        CREATE CLUSTER, CREATE PROCEDURE, CREATE SEQUENCE,
        CREATE TABLE, CREATE TRIGGER
        
    - DBA �� :    
        ����ڰ� ������ �����ͺ��̽� ��ü�� �����ϰ�
        ����ڰ��� ����� �����ϰ� ������ �� �ִ� ��� ������ ����
        �ý��� ������ �ο��ϴ� ������ ����        
*/

-- �ý��۰��� �α��� : 
-- �� ����ڰ��� �����
CREATE USER C##USER33 IDENTIFIED BY PASS33;

-- ���� �õ��� ���� : ���� ���� ����
CONNECT C##USER33/PASS33  -- ERROR

-- ���� �ο�
GRANT CONNECT TO C##USER33;
GRANT RESOURCE TO C##USER33;
-- �Ǵ�
GRANT CONNECT, RESOURCE TO C##USER33;

-- �α����� ��
CONNECT C##USER33/PASS33

-- �� ���� ������ ��ųʸ�
-- ���� Ȯ���ϱ� ���� ��ųʸ��� ���� ����
SELECT * FROM DICT
WHERE TABLE_NAME LIKE '%ROLE%';

-- ����ڵ鿡�� �ο��� �� Ȯ���ϱ� : USER_ROLE_PRIVS
-- C##USER33 �α��� : 
SELECT * FROM USER_ROLE_PRIVS;

-- ROLE_SYS_PRIVS (�ѿ� �ο��� �ý��� ���� ����)
-- ROLE_TAB_PRIVS (�ѿ� �ο��� ���̺� ���� ���� ����)
-- USER_ROLE_PRIVS (���� ������/����� �� ����)
-- USER_TAB_PRIVS_MADE (�ش� ����� ������ ��ü ���� ����)
-- USER_TAB_PRIVS_RECD (����ڿ��� �ο��� ��ü ���� ����)
-- USER_COL_PRIVS_MADE (�ش� ����� ������ �÷� ��ü ���� ����)
-- USER_COL_PRIVS_RECD (����ڿ��� �ο��� Ư�� �÷��� ���� ��ü ���� ����)

-- ����� ���� �� ����� : 
-- CREATE ROLE ������� ������
-- �� ������ �ݵ�� DBA ������ �ִ� ����ڸ� �� �� ����
/*
�ۼ����� : 
CREATE ROLE ���̸�;        -- 1. �� ����
GRANT �������� TO ���̸�;    -- 2. ������ �ѿ� ���� �ο�

�ѻ�� : 
GRANT ���̸� TO ����ڰ���;   -- 3. ����ڿ��� �ѷ� ���� �ο�
*/

-- �ý��۰��� �α����ϰ� �� ���� : 
-- ����Ŭ 12c���ʹ� ��������տ� c## ���̵��� ���̹� ��Ģ�� �ٲ����
-- ���̸����� C## ����
-- 1.
CREATE ROLE C##MYROLE;
-- 2.
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO C##MYROLE;
-- 3.
CREATE USER C##MYMY IDENTIFIED BY PASS;
GRANT C##MYROLE TO C##MYMY;

-- �α��� Ȯ��
CONNECT C##MYMY/PASS
SHOW USER
-- ����ڿ��� �ο��� ���� Ȯ��
SELECT * FROM USER_ROLE_PRIVS;

/*
[����] --------------------------------------------------------------------
	�α��� : system
	���̸� : C##MYROLE02
	�ѿ� �ο��� ��ü ���� : C##STUDENT.EMPLOYEE ���̺� ���� SELECT 
	�� �ο��� ����� : C##MYMY
	=> C##MYMY �α����ؼ� EMPLOYEE ���̺� ���� SELECT ���� Ȯ��
	---------------------------------------------------------------------------
*/
-- 1.
CREATE ROLE C##MYROLE02;
-- 2.
GRANT SELECT ON C##STUDENT.EMPLOYEE TO C##MYROLE02;
-- 3.
GRANT C##MYROLE02 TO C##MYMY;

-- C##MYMY �α��� :
-- ���̺� ��ȸ Ȯ��
SELECT * FROM C##STUDENT.EMPLOYEE;

-- �� ȸ�� -----------------------------------------------
-- REVOKE ���̸� FROM ����ڰ���;

-- C##MYMY �α��� : 
-- ���� ����ڿ��� �ο��� �� ���� Ȯ��
SELECT * FROM USER_ROLE_PRIVS;

-- �ý��۰������� �� ȸ����
REVOKE C##MYROLE02 FROM C##MYMY;

-- C##MYMY ���� �� ���� �ٽ� Ȯ��
SELECT * FROM USER_ROLE_PRIVS;

-- �� ���� ------------------------------
-- DROP ROLE ���̸�;
DROP ROLE C##MYROLE02;


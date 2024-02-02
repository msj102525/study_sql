-- ������(system) �������� ����� �����ϱ�

/*
11g ������ ����Ŭ ��ġ�� ���͵� ���� ������ ������ �Ǿ���
scott/tiger, hr/hr => ���� ���̺�� �����͵��� ������ ��
18c ���ʹ� ������ �� ��
*/

-- ���� ���ӵ� ����� ���� ����
show user;
SHOW USER;

-- ������ ���� ���� �����
-- create user ���̵�� identified by ��ȣ;
-- 12c ���ʹ� ����ڰ���(���̵�) ���� �� ���̵� ���� �տ� �ݵ�� c##�� �ٿ��� ��
-- ��ȣ�� ������� ���ص� ��
-- �����ͺ��̽� ��� ������ ��ҹ��� ���� �� �� (����Ǵ� �� == �����ʹ� ��ҹ��� ������)
-- ���̵�� ��ȣ�� ��ҹ��� ������

-- ����� ����
--create user c##student IDENTIFIED BY student;
--create user c##scott IDENTIFIED by tiger;

--������ ����
--create user c##homework IDENTIFIED by homework;

--���� �򰡿� ����
--create user c##test IDENTIFIED by test;

-- �����ͺ��̽��� ����� ������ ��ȣ ���� �Ŀ� ������ �ο��ؾ� ��
-- ���� �ο��ÿ� ���Ǵ� ��� ���� : GRANT ���� ����, ��������, ... BY ����ڰ���;
-- �������� : CREATE SESSTION (�α׿� ����), CREATE TABLE, INSERT INTO, UPDATE, DELETE, SELECT ���� ���
-- ���� ���ѵ��� ��� ���� ��ü�� �̿��� �� ���� : ��(ROLE)�̶�� ��
-- ����Ŭ�� �����ϴ� ���� �̿��� �� ���� : CONNECT��, RESOURCE�� �� : GRANT ���̸�, ���̸�, ... TO ����ڰ���;
-- ����ڰ� ���� ���� ����� ���� ����

--GRANT CONNECT, RESOURCE TO c##student
--GRANT CONNECT, RESOURCE TO c##scott;
--GRANT CONNECT, RESOURCE TO c##homework;
--GRANT CONNECT, RESOURCE TO c##test;

-- ����Ŭ 12c ������ ����(grant)�� �ο��ϸ� ���̺� ������ �� �־���, ������ ���嵵 �Ǿ���
-- 18c ���ʹ� ���� �ο� �Ŀ� ���̺� �����̽�(Table Space)�� �Ҵ�޾ƾ� ���̺� ������ ������ ���� ������
-- TABLESPACE �Ҵ��� ����� ������ �����Ͽ� ������
-- ALTER USER c##student QUOTA 1024M ON USERS;
-- ALTER USER c##scott QUOTA 1024M ON USERS;
-- ALTER USER c##homework QUOTA 1024M ON USERS;
-- ALTER USER c##test QUOTA 1024M ON USERS;

-- ���� : ���� �����ͺ��̽��� ����ڰ����� c## �ݵ�� ǥ���ؾ� ��
--  OCI(Oracle Cloud Infrastructure)�� ��ġ�� ����Ŭ db���� c## ������ �ʰ� ���� �������

-- ����ڰ��� �����ϱ�
-- ����ڰ��� ������ ���� ��, �����ϰ� �ٽ� �������
-- DROP USER ����� ���� [CASCADE];

CREATE USER c##ttt IDENTIFIED BY ttt;
DROP USER c##ttt;
DROP USER c##ttt CASCADE;

-- �����ͺ��̽� ���ӽ� ���� �Ǵ� ��ȣ�� ��Ÿ�� ��� ������ �߻���Ű�� ���� ���(LOCK)
-- ��� ����ڰ����� LOCK�� �����Ϸ��� UNLOCK ó����
--ALTER USER c##���� IDENTIFIED BY ��ȣ ACCOUNT UNLOCK;

-- ����ڰ��� ��ױ� (LOCK)
--ALTER USER c##student IDENTIFIED BY student ACCOUNT LOCK;
--ALTER USER c##student IDENTIFIED BY student ACCOUNT UNLOCK;

-- ��ȣ ����
-- ALTER USER c##����ڰ��� IDENTIFIED BY �ٲܾ�ȣ;

 ALTER USER c##student IDENTIFIED BY student;





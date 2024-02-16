-- 18_DDL_SYNONYM.sql

-- ���Ǿ� (SYNONYM)
-- �ٸ� ����ڰ����� �ִ� ��ü�� ���� ALIAS (��Ī, ���Ӹ�)��
-- ���� ����ڰ� ���̺��� ������ ���, �ٸ� ����ڰ� ���̺� ������ �� ����ڸ�.���̺�� ���� ǥ����
-- �� �� ���Ǿ �����ϸ� �����ϰ� ����� �� �ְ� ��

-- �ۼ����� : 
-- CREATE SYNONYM ���Ӹ� FOR ����ڸ�.��ü��;
-- �� :
CREATE SYNONYM EP FOR C##STUDENT.EMPLOYEE;

SELECT * FROM C##STUDENT.EMPLOYEE; -- �ڱ� ���� �ȿ����� ����ڸ� ������
SELECT * FROM EMPLOYEE;
SELECT * FROM EP;

-- �� :
SELECT * FROM SYS.DUAL;
SELECT * FROM DUAL;
SELECT * FROM C##SCOTT.EMP; -- �ٸ� ������ ��ü�� ����

-- ���Ǿ�� ��� ����ڰ� ����� �� �ִ� ����(PUBLIC) ���Ǿ��
-- ���� ����ڰ� ����ϴ� ����� ���Ǿ ����
/*
�ۼ����� :
CREATE [PUBLIC] SYNONYM ���Ǿ� FOR ����ڰ���.��ü��;
*/

-- �����ڰ����� �ִ� SYSTBL ���̺��� ��ȸ Ȯ��
SELECT * FROM SYSTEM.SYSTBL;

-- ���Ǿ� �����
CREATE SYNONYM STB FOR SYSTEM.SYSTBL;

-- ���Ǿ�� ��ȸ Ȯ��
SELECT * FROM STB;

-- ���Ǿ� �����ϱ�
-- ����� ���Ǿ� : �ش� ����ڰ������� ������
-- ���� : DROP SYNONYM ���Ӹ�;

DROP SYNONYM EP;
DROP SYNONYM STB;

-- ���� ���Ǿ� : SYSTEM �������� ������
-- ���� : DROP PUBLIC SYNONYM �������Ǿ�;




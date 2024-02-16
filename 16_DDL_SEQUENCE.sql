-- 16_DDL_SEQUENCE.sql

-- ������ (SEQUENCE)
-- �ڵ� ����(����) �߻��ϴ� ��ü
-- ���������� �������� �ڵ����� �߻���
/*
�ۼ����� :
CREATE SEQUENCE �������̸�
[START WITH ���ۼ���] -- �����Ǹ� �⺻ 1 ����
[INCREMENT BY �������Ҽ���] -- �����Ǹ� ��� 1 ������
[MAXVALUE ������ | NOMAXVALUE] - NOMAXVALUE �̸� 10�� 27�±��� ���� �߻���
[MINVALUE �ּҰ� | NOMINVALUE]
[CYCLE | NOCYCLE] -- ���������� ���� ��ȯ�Ǹ� ������ 1���� ������
[CACHE ���尹�� | NOCACHE] -- ĳ�� �޸𸮿� �̸� �߻����� ������ ���� ���� ���� (���尹�� 2 ~ 20)
;
*/

-- ������ ����� 1 : 
CREATE SEQUENCE SEQ_EMPID
START WITH 300 -- 300 ���� ����
INCREMENT BY 5 -- 5�� ����
MAXVALUE 310 -- 310 ���� ���� �߻�
NOCYCLE -- 310���� ���� �� ���̻� ���� ���� �ȵ�
NOCACHE;  -- �̸� �޸𸮿� ���� ���� ���� �� ��

-- ������ ���� ������ ��ųʸ� Ȯ��
DESC USER_SEQUENCES;

SELECT * FROM USER_SEQUENCES;

SELECT SEQUENCE_NAME, CACHE_SIZE, LAST_NUMBER
FROM USER_SEQUENCES;
-- LAST_NUMBER : ���� �߻����� �ǹ���

-- ������ ��� : �������̸�.NEXTVAL �Ӽ� ������� �� �߻���Ŵ
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;
-- NOCYCLE �̱� ������ ������ 310 ���� �� �߻���Ű�� ������ �߻�

-- ������ ����� 2 :
CREATE SEQUENCE SEQ2_EMPID
START WITH 5
INCREMENT BY 5
MAXVALUE 15
CYCLE
NOCACHE;

-- ��� : 
SELECT SEQ2_EMPID.NEXTVAL FROM DUAL;
-- 5, 10, 15, 1, 6, 11, 1, 6, .............. �ݺ���

-- ������ ��� �Ӽ� : 
-- �������̸�.NEXTVAL
-- ���ο� ���� ���ڸ� �߻���Ű�� �Ӽ���
-- �������̸�.CURRVAL
-- �������� ���������� �߻��� �� Ȯ���ϴ� �Ӽ���
-- ���� : ������ ��ü �����, NEXTVAL ���� �����ϰ� ���� ����ؾ� ��
--          NEXTVAL �������� �ʰ� ����ϸ� ���� �߻���

CREATE SEQUENCE SEQ3_EMPID
INCREMENT BY 5
START WITH 300
MAXVALUE 310
NOCYCLE  NOCACHE;

-- ������ ��ü ����� �ٷ� CURRVAL ���
SELECT SEQ3_EMPID.CURRVAL FROM DUAL; -- ���� �߻�

SELECT SEQ3_EMPID.NEXTVAL FROM DUAL; -- 300 �߻�
SELECT SEQ3_EMPID.CURRVAL FROM DUAL;  -- ������ �߻��� 300 Ȯ��

-- ������ ��ü�� �ַ� INSERT ������ ���� ��Ͽ����� �����
CREATE SEQUENCE SEQID
START WITH 300
INCREMENT BY 1 -- �⺻�� 1��, �����ص� ��
 MAXVALUE 310
 NOCYCLE NOCACHE;
 
 INSERT INTO emp_copy (emp_id, emp_name, emp_no)
 VALUES (SEQID.NEXTVAL, '�迵��', '977777-1234567');
 
 INSERT INTO emp_copy (emp_id, emp_name, emp_no)
 VALUES (TO_CHAR(SEQID.NEXTVAL), '������', '877777-1234567');
 
 SELECT * FROM emp_copy;
 
 -- ������ ���� ----------------------------------------
 /*
 ���� : START WITH �� ���� �� ��
        ������ ���ϸ� ������ �����ϰ� ���� ����� ��
        
�ۼ����� :
ALTER SEQUENCE ������ �̸�
[INCREMENT BY N]
[MAXVALUE N | NOMAXVALUE]
[MINVALUE N | NOMINVALUE]
[CYCLE | NOCYCLE]
[CACHE N | COCACHE]
;

������ ���Ŀ� �ٷ� ����ϸ�, ������ ������ �����
 */

-- ������ ���� �� :
CREATE SEQUENCE SEQID2
START WITH 300
INCREMENT BY 1
MAXVALUE 310
NOCYCLE NOCACHE;

SELECT SEQID2.NEXTVAL FROM DUAL; --300
SELECT SEQID2.NEXTVAL FROM DUAL; --301

ALTER SEQUENCE SEQID2
INCREMENT BY 5;

-- Ȯ��
SELECT SEQID2.NEXTVAL FROM DUAL; --306

-- ������ ���� -------------------------------------------------
-- DROP SEQUENCE �������̸�;
DROP SEQUENCE SEQID2;




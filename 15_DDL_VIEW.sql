-- 15_DDL_VIEW.sql

-- VIEW (��) --------------------------------------------------------------
-- STORED QUERY : SELECT ������ �����ϴ� ��ü
-- VIRTUAL TABLE : ����� SELECT �������� ������ �Ǹ� ����並 ������
-- ������ : 
-- 1. ���ȿ� ���� : �������� ������ �ʰ� �ϰ�, ��� �丸 ���̰� ��
-- 2. �����ϰ� �� ������ ���� �������� �ʰ�, ����� �������� ������
--      => ���� �ӵ��� ����, ���౸���� ������
-- ��ɱ��� : CREATE VIEW, DROP VIEW
--              ALTER VIEW ����, ALTER VIEW ��ſ� CREATE OR REPLACE VIEW �� �����
-- �ۼ� ���� : 
/*
CREATE [OR REPLACE] [FORCE] VIEW ���̸�
AS
��������
[WITH READ ONLY CONSTRAINT �����̸�];
[WITH CHECK OPTION CONSTRAINT �����̸�];
*/

CREATE VIEW V_EMP
AS
SELECT * FROM employee; -- ���� ����� ���� �߻�

-- �����ڰ���(SYSTEM/ORACLE)���� ���� �ο��� ������ ����ؾ� ��
--GRANT CREATE VIEW TO C##STUDENT;

CREATE VIEW V_EMP_DEPT90
AS
SELECT emp_name, dept_name, job_title, salary
FROM employee
LEFT JOIN JOB USING (job_id)
LEFT JOIN department USING (dept_id)
WHERE dept_id = '90';

-- �� ��� : ���̺� ��� ���
SELECT * FROM v_emp_dept90;

-- �� ���� ��ųʸ� : USER_VIEWS, USER_CATALOGS, USER_OBJECTS
DESC user_views;

SELECT view_name, text_length, TEXT
FROM USER_VIEWS;

-- �ǽ� :
-- ���޸��� '���'�� ��� �������� �����, �μ���, ���޸��� ��ȸ�ϴ� ������ ��� �����Ͻÿ�
-- ���̸��� : V_EMP_DEPT_JOB

CREATE OR REPLACE VIEW v_emp_dept_job
AS
SELECT emp_name, dept_name, job_title
FROM employee 
LEFT JOIN job USING(job_id)
LEFT JOIN department USING(dept_id)
WHERE job_title LIKE '���';

-- Ȯ��
SELECT * FROM v_emp_dept_job;

-- ��ųʸ� Ȯ�� : 
-- �䰴ü�� ���̺� ��üó�� ��ȸ�� ���� ����
SELECT column_name, data_type, nullable
FROM user_tab_cols
WHERE table_name = 'V_EMP_DEPT_JOB';

-- �� ������ �������� SELECT �׸��� �÷� ��Ī�� ���� ������ ���� ����
-- SELECT �׸� ���� �� ��Ī ó���ؾ� ��
CREATE OR REPLACE VIEW v_emp_dept_job (ename, dname, jtitle)
AS
SELECT emp_name, dept_name, job_title
FROM employee 
LEFT JOIN job USING(job_id)
LEFT JOIN department USING(dept_id)
WHERE job_title LIKE '���';

SELECT * FROM v_emp_dept_job;

-- �������� �κп��� ��Ī �����ص� ��
CREATE OR REPLACE VIEW v_emp_dept_job
AS
SELECT emp_name enm, dept_name dnm, job_title
FROM employee 
LEFT JOIN job USING(job_id)
LEFT JOIN department USING(dept_id)
WHERE job_title LIKE '���';

-- ���� :
-- �������� SELECT ���� �Լ������� ����� ��Ī �ٿ��� ��
CREATE OR REPLACE VIEW v_emp ("Ename", "Gender", "Years")
AS
SELECT emp_name,
            DECODE(SUBSTR(emp_no, 8, 1), '1', '����', '3', '����', '����') ����,
            ROUND(MONTHS_BETWEEN(sysdate, hire_date) / 12) �ٹ����
FROM employee;

SELECT column_name, data_type, nullable
FROM user_tab_cols
WHERE table_name = 'v_emp';

-- �� �������� ------------------------------------------------------
-- WITH READ ONLY : �並 �̿��� DML �۾��� ���� (�б����� ��)
-- WITH CHECK OPTION : �並 ���̺�ó�� ����ؼ� DML ������ �� ����
--                                  ���̽����̺��� 1���� ���������� ������
--                                  ���̽����̺� DML �� ����� => DELETE ���� ��� ���Ѿ���
--                                  => �������� ������ �����ؼ� ���ѵ� DML(INSERT, UPDATE) ����
-- �� �������ǵ� CONSTRAINT �̸����� ������ �� ����

-- WITH READ ONLY : 
CREATE OR REPLACE VIEW v_emp
AS
SELECT * FROM EMPLOYEE
WITH READ ONLY;

-- DML ��� Ȯ�� :
INSERT INTO v_emp (emp_id, emp_name, emp_no)
VALUES ('666', '�׽���', '901223-1234567'); -- ERROR

DELETE FROM v_emp; -- ERROR

SELECT * FROM v_emp;

-- WITH CHECK OPTION :
-- DELETE ���� ���Ѿ��� ��� ������
-- INSERT, UPDATE�� ���ǿ� ���� �۾��� ���ѵǾ� ����� �� ����
CREATE OR REPLACE VIEW v_emp
AS
SELECT emp_id, emp_name, emp_no, marriage
FROM employee
WHERE marriage = 'N'
WITH CHECK OPTION; -- DML ��� ����

SELECT * FROM v_emp;

INSERT INTO v_emp (emp_id, emp_name, emp_no, marriage)
VALUES ('666', '�׽���', '991123-1234567', 'Y'); -- ERROR
-- ���������� ���ǰ� ��ġ�ϴ� ���� ����� �� ����

UPDATE v_emp
SET marriage = 'Y'; -- ERROR

INSERT INTO v_emp (emp_id, emp_name, emp_no, marriage)
VALUES ('666', '�׽���', '991123-1234567', 'N'); -- ���̽����̺� �߰� ��ϵ�

SELECT * FROM employee;
SELECT * FROM v_emp;

-- �信 �������� �÷�(�׸�)�� ���ؼ��� UPDATE ������ �� ����
UPDATE v_emp
SET emp_id = '777'
WHERE emp_id = '666';

ROLLBACK;

-- ����� �䰴ü�� �ٸ� SELECT ������ FROM ���� �ζ��κ� ����� �� ����
-- �ζ��κ� : FROM ���� ���� ���������� ����並 ����
-- FROM (��������) �亰Ī  => FROM ���̸�

-- �ζ��κ� ��� �� 1 : 
CREATE OR REPLACE VIEW v_emp_info
AS
SELECT emp_name, dept_name, job_title
FROM employee
LEFT JOIN JOB USING (job_id)
LEFT JOIN department USING (dept_id);

-- �� ��ü�� ���̺� ��ſ� �����
SELECT emp_name
FROM v_emp_info -- ���̺� ��� �� ���
WHERE dept_name = '�ؿܿ���1��'
AND job_title = '���';

-- �ζ��κ� ��� �� 2 :
CREATE OR REPLACE VIEW v_dept_sal ("Did", "Dname", "Davg")
AS
SELECT NVL(dept_id, '00'),
            NVL(dept_name, 'NONAME'),
            ROUND(AVG(salary), -3)
FROM department
RIGHT JOIN employee USING(dept_id)
GROUP BY dept_id, dept_name;

-- ""��� ���� ��Ī�� ���ÿ��� "" ��� ǥ���ؾ� ��
SELECT "Dname", "Davg"
FROM v_dept_sal
WHERE "Davg" > 3000000;

SELECT Dname, Davg
FROM v_dept_sal
WHERE Davg > 3000000; -- "" ǥ������ ������ ����

-- �� ���� ���� ������ ����
-- ALTER VIEW ���̸� ����
-- �� ������ ���ϸ�, ���� �並 �����ϰ� �ٽ� �������
-- �Ǵ� CREATE OR REPLACE VIEW �����

-- �� ����
-- DROP VIEW ���̸�;
DROP VIEW v_emp;

-- FORCE �ɼ� :
-- ��������(����Ǵ� ������)�� ���� ���̺��� �������� �ʾƵ� �並 ������ ��
-- SELECT ���� ���� �뵵�θ� ���� �̿���

 CREATE OR REPLACE NOFORCE VIEW v_emp
 AS
 SELECT tcode, tname, tcontent
 FROM ttt; -- ���̺��� �������� ������ ������

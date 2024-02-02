-- 2_SELECT_01.sql

-- ����Ŭ ���� ���� Ȯ���ϱ�
SELECT * FROM v$nls_parameters;
-- NLS_LANGUAGE : KOREAN
-- NLS_DATE_FORMAT : RR/MM/DD
-- NLS_CHARACTERSET : AL32UTF8
-- �ʿ�� ������ �� ����

-- ********************************************************************
-- SELECT ����
-- ������ �����ͺ��̽�(RDB)�� �����͸� ���̺� �����Ѵ�.
-- �������� �׸�(�Ӽ�, Attribute)�� �÷�(Column)�̶�� ��
-- SELECT���� ���̺� ��� ����� �����͸� �˻�(��ȸ : ã�Ƴ��� ����)�ϱ� ���� ���Ǵ� SQL������
-- DQL(Data Quary Language : ������ ��ȸ��)��� ��

/*
SELECT ���� �⺻ �ۼ��� :
SELECT * | �÷���, �÷���, �Լ���, ����
FROM ��ȸ�� ���̺��

* : ���̺��� ���� ��� �÷��� �����͸� ��ȸ�Ѵٴ� �ǹ��� (���̺� ��ü ��ȸ)
*/
SELECT * FROM EMPLOYEE;

-- �μ�(DEPARTMMENT) ���̺� ��ü ��ȸ
SELECT * FROM DEPARTMENT;

-- ����(JOB) ���̺� ��ü ��ȸ
SELECT * FROM JOB;

-- ���̺��� Ư¡ �÷��� ��ϵ� ������ ��ȸ�Ϸ��� (ch03, pdf 3page)
-- �� : ���� ���̺��� ���(EMP_ID), �̸�(EMP_NAME), �ֹι�ȣ(EMP_NO) ��ȸ
SELECT EMP_ID as id, EMP_NAME, EMP_NO
FROM EMPLOYEE;

-- ���� ���̺��� ���, �̸�, �޿�, ���ʽ�����Ʈ ��ȸ
SELECT EMP_ID, EMP_NAME, SALARY, BONUS_PCT
FROM EMPLOYEE;

-- ���� ���̺��� ���, �̸�, �����ڵ�, �Ի���, �μ��ڵ� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_ID, HIRE_DATE, DEPT_ID
FROM EMPLOYEE;

-- SELECT���� ���� ����� ���� ����
-- �÷��� ��ϵ� ���� ��꿡 ����� ����� �����
-- �� : ���� ���̺��� ���, �̸�, �޿�, ����(�޿�* 12) ��ȸ
SELECT EMP_ID, EMP_NAME, SALARY, SALARY *12 
FROM EMPLOYEE;

-- SELECT���� �Լ��� ����� ���� ����
-- �����Ǵ� �Լ��� �ľ��ϰ� ���� Ȯ���ϰ� �����
-- �Լ��� �÷��� ��ϵ� ���� �о �Լ��� ó���� ����� ��ȯ��
-- �� : �������̺��� ���, �̸�, �ֹι�ȣ �� 6�ڸ����� ��ȸ
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 1,6)
FROM EMPLOYEE;

-- ��ȸ���� 2 : Ư�� ��(ROW, ���� �� ��)���� ��ȸ
-- ������ �����ϴ� ����� ��� ����, ���ϴ� �÷����� �����ϴ� �����
-- �������� ����� : WHERE �÷��� �񱳿����� �񱳰�
-- WHERE ���� FROM �� ������ ��ġ��
-- �� : ���� �������� ��ȥ����(��ȥ��) �����鸸 ��ȸ
SELECT *
FROM employee
--WHERE marriage = 'Y'; -- ���� ��ġ�ϴ� ��(��)�� ���
WHERE marriage = 'y'; -- ��ϵ� ���� ��ҹ��� ������

-- ��ȥ�� ���� ���� ��ȸ
SELECT *
FROM employee
WHERE marriage = 'N';

-- ��ȸ���� 3 :
-- ������ �����ϴ� ����� ��� => ���ϴ� �÷��� �����ϴ� ��ȸ��
-- �� : ���� �������� ���� �ڵ尡 'J4'�� �������� ���, �̸�, �����ڵ�, �޿� ��ȸ
SELECT emp_id, emp_name, job_id, salary
FROM employee
WHERE job_id = 'J4';

-- �����ڵ尡 'J4'�� ���� ���޸� ��ȸ�Ѵٸ�
SELECT job_title
FROM job
WHERE job_id = 'J4';

-- ��ȸ���� 4 :
-- ���� �������� '90'�� �μ��� �ٹ��ϴ� �������� ���, �̸�, �μ��ڵ�, �����ڻ�� ��ȸ
SELECT emp_id, emp_name, dept_id, mgr_id
FROM employee
WHERE dept_id = '90';

-- 90�� �μ��� �μ�����?
SELECT dept_id, dept_name
FROM department
WHERE dept_id = '90';

-- SELECT ������ �⺻ 1���� ���̺� ���� ��ȸ��
-- �ʿ��� ��� ���� ���� ���̺��� �ϳ��� ���ļ�(����, JOIN) ���ϴ� �÷��� ��ȸ�� ���� ����
SELECT emp_id, emp_name, dept_id, dept_name
FROM employee
JOIN department USING(dept_id)
WHERE dept_id= '90';

-- ������ '����'�� ���� ���� ��ȸ
-- ���, �̸�, �����ڵ�, ���޸�, �޿�, ���ʽ�����Ʈ

SELECT emp_id, emp_name, job_id, job_title, salary, bonus_pct
FROM employee
JOIN job USING(job_id)
WHERE job_title = '����';

SELECT e.emp_id, e.emp_name, e.job_id, j.job_title, e.salary, e.bonus_pct
FROM employee e
JOIN job j
ON e.job_id = j.job_id
WHERE job_title = '����';


-- DATE �ڷ���
-- ��¥�� �ð��� ����ϴ� �÷��� ����
-- ��¥�� �ð��� ����� �� ����
-- ��� ����(����)�� 'RR/MM/DD' �� �����Ǿ� ����

SELECT SYSDATE, SYSTIMESTAMP
FROM DUAL;
-- DUAL : DUMMY TABLE(��¥ ���̺�)

SELECT SYSDATE + 1000 -- ���ú��� 1000�� �� ��¥ (DATE)
FROM DUAL;

SELECT STSDATE - 100 -- ���� ���� 100�� �� ��¥(DATE)
FROM DUAL;

SELECT SYSDATE + 100/24 -- ���� �ð����� 100�ð� �� ��¥(DATE)
FROM DUAL;

-- ���� �������� �Ի��Ϻ��� ���ñ��� �ٹ��ϼ��� ��ȸ
SELECT emp_id, emp_name, hire_date, FLOOR(SYSDATE - hire_date) -- �ٹ��ϼ�
FROM employee;

-- �ѱ��� �⺻ �ѱ��ڰ� 2����Ʈ��
-- ����Ŭ XE������ �ѱ� 1���ڰ� 3����Ʈ�� (������ ��)
SELECT emp_name, LENGTH(emp_name) ���ڰ���, LENGTHB(emp_name) ����Ʈ��
FROM employee;

-- ���� �������� ���, �̸�, �޿�, ���ʽ�����Ʈ, ���ʽ�����Ʈ�� ����� ���� ��ȸ
SELECT emp_id, emp_name, salary, bonus_pct,
            (salary + (salary * bonus_pct)) * 12
FROM employee;
-- �����ͺ��̽������� ����� ���� NULL�̸� ����� NULL��
-- ����� ���� NULL�̸�, ������� ������ �Ϸ��� NULL�� �ٸ� ������ �ٲٸ� ��
-- ���� �Լ� �̿��� : NVL(�÷���, NULL�϶� �ٲܰ�)

SELECT emp_id, emp_name, salary, bonus_pct,
            (salary + (salary * NVL(bonus_pct, 0))) * 12
FROM employee;

-- ��Ī (ALIAS)
SELECT emp_id AS ���, emp_name AS �̸�, salary AS �޿�, bonus_pct AS ���ʽ�����Ʈ,
            (salary + (salary * NVL(bonus_pct, 0))) * 12 ���ʽ����뿬��
FROM employee;

/*
SELECT ���� �ۼ� ���� : 
�������
5 : SELECT & | �÷��� [AS] ��Ī, ����, ���� [AS] ��Ī
1 : FROM ��ȸ�� ����� ���̺� ��
2 : WHERE �÷��� �񱳿����� �񱳰� (������� ���)
3 : GROUP BY �÷��� | ����
4 : HAVING �׷��Լ� �񱳿����� �񱳰� (������ �����ϴ� �׷��� ���)
6 : ORDER BY �÷��� ���ı���, SELECT���� ������ ���� ���ı���, ��Ī [ASC] | [DESC] ;
*/

-- SELECT ���� �÷��� | ���� �ڿ� ��Ī(ALIAS)�� ����� �� ����
-- �÷��� AS ��Ī, ���� AS ��Ī
-- AS�� �����ص� �� => �÷��� ��Ī, ���� ��Ī
-- ���ǻ��� : 
-- ��Ī�� ����, ����, ��ȣ�� ���ԵǸ� �ݵ�� ""�� ����� ��, "��Ī"
-- ��Ī ���ڼ� ���Ѿ���
-- ���� ��Ī�� �⺻ �빮�ڷ� ǥ�õ� => "�ҹ���", "��ҹ���ȥ��" ����ǥ �����

SELECT emp_id AS ���, emp_name �̸�, salary "�޿�(��)",
            bonus_pct "���ʽ� ����Ʈ",
            (salary + (salary * NVL(bonus_pct, 0))) * 12 "1�� �ҵ�"
FROM employee;

-- ���ͷ� (LITERAL) : ���ڿ���
-- SLECT ���� ���ͷ�(���ڿ���) ����� �� ����
SELECT emp_id ���, emp_name �̸�, '����' �ٹ�����
FROM employee;

-- DISTINCT
-- SELCT ���� �÷��� �տ� �����
-- DISTINCT �÷���
-- SELECT ���� �ѹ��� ����� �� ����
-- �÷��� �ߺ� ��ϵ� ���� �Ѱ��� �����϶�� �ǹ���

-- �÷��� ��ϵ� ���� ������ �ľ��� �� ����ϸ� ����
SELECT DISTINCT marriage
FROM employee;

SELECT DISTINCT dept_id
FROM employee
ORDER BY 1 ASC;

-- DISTINCT : 1���� �����
SELECT DISTINCT dept_id, DISTINCT job_id -- ERROR
FROM employee;

SELECT DISTINCT dept_id, job_id -- �� �÷����� ��� �ϳ��� ������ ���� �ߺ� �Ǵ�
FROM employee;

-- ���� �߿��� �������� �����鸸 ��ȸ
SELECT DISTINCT mgr_id
FROM employee
WHERE mgr_id IS NOT NULL
ORDER BY 1 ASC;

-- WHERE �� ********************************************************************
/*
�۵����� : 
FROM ���� �۵��ǰ� ���� WHERE���� �۵���
=> ���̺��� �F�Ƽ�, ���̺� ����� ���� �߿� ������ �����ϴ� ���� �ִ� ���� ���
WHERE �÷��� �񱳿����� �񱳰�
- �������̶�� ��
- �񱳿����� : > (ũ��, �ʰ�), < (������, �̸�), >= (ũ�ų� ������, �̻�), <= (�۰ų� ������, ����)
                    = (������), != (���� �ʴ���, ^=, <>)
                    IN, NOT IN, LIKE , NOT LIKE, BETWEEN AND, NOT BETWEEN AND
- �������� : AND, OR
*/

-- ���� ���̺��� �μ��ڵ尡 '90'�� ���� ���� ��ȸ
-- ��� �׸� ��ȸ
SELECT *
FROM employee
WHERE dept_id = '90'; -- ���ǰ� ��ġ�ϴ� ���� ��ϵ� ��(ROW)���� ���

-- �����ڵ尡 'J7'�� ���� ���� ��ȸ
SELECT *
FROM employee
--WHERE job_id = 'J7';
WHERE job_id = 'j7'; -- ��ϰ��� ��ҹ��� ������, ������� �״�� ����

-- ���� �� �޿��� 4�鸸���� ���� �޴� (4�鸸�� �ʰ��ϴ�) ���� ��� ��ȸ
SELECT emp_id ���, emp_name �̸�, salary �޿�
FROM employee
WHERE salary > 4000000;

-- 90�� �μ��� �ٹ��ϴ� ���� �� �޿��� 2�鸸�� �ʰ��ϴ� ���� ���� ��ȸ
-- ���, �̸�, �޿�, �μ��ڵ� : ��Ī ����
SELECT emp_id ���, emp_name �̸�, salary �޿� , dept_id �μ��ڵ�
FROM employee
WHERE dept_id = '90'
AND salary > 2000000; -- ����� : 3��

-- 90�� �Ǵ� 20�� �μ��� �ٹ��ϴ� ���� ��ȸ
-- ���, �̸�, �ֹι�ȣ, �μ��ڵ� : ��Ī ����
-- �μ��ڵ�� �������� ���� ó����
SELECT emp_id ���, emp_name �̸�, emp_no �ֹι�ȣ, dept_id 
FROM employee
WHERE dept_id= '90' OR dept_id = '20'
ORDER BY dept_id ASC;

-- ���� 1 :
-- �޿��� 2�鸸�̻� 4�鸸������ ���� ��ȸ
-- ���, �̸�, �޿�, �����ڵ�, �μ��ڵ� : ��Ī���� -- ����� : 16��

SELECT emp_id ���, emp_name �̸�, salary �޿�, job_id �����ڵ�, dept_id �μ��ڵ�
FROM employee
WHERE salary > 2000000 AND salary < 4000000;

-- ���� 2 :
-- �Ի����� 1995�� 1�� 1�� ���� 2000�� 12 �� 31�� ���̿� �Ի��� ���� ��ȸ
-- ���, �̸�, �Ի���, �μ��ڵ� : ��Ī
-- ��¥ �����ʹ� ��ϵ� ��¥ ���˰� ��ġ�ǰ� �ۼ���
-- ��¥ �����ʹ� ���� ����ǥ�� ��� ǥ���� : '1995/01/01' �Ǵ� '95/01/01' -- ����� : 7��

SELECT emp_id ���, emp_name �̸�, hire_date �Ի���, dept_id �μ��ڵ�
FROM employee
--WHERE hire_date >= '95/1/1' AND hire_date <= '00/12/31';
WHERE hire_date >= '1995/1/1' AND hire_date <= '2000/12/31';

-- ���� ������ : ||
-- �ڹٿ����� "HELLO" + " WORLD " => "HELLO WORLD"
-- SELECT ������ ��ȸ�� �÷������� ���� ó���� �ϳ��� ������ ���� �� ����� �� ����
-- WHERE ������ �񱳰� ���� ���� �Ѱ��� ������ ���� �� ����ϱ⵵ ��
SELECT emp_name || '�� ���� �޿��� ' || salary || '�� �Դϴ�' AS �޿�����
FROM employee
WHERE dept_id = '90';

-- ���� 3 :
-- 2000�� 1�� 1�� ���Ŀ� �Ի��� ��ȥ�� ���� ��ȸ
-- �̸�, �Ի���, �����ڵ�, �μ��ڵ�, �޿�, ��ȥ���� (��Ī ó��)
-- �Ի糯¥ �ڿ� '�Ի�' ���� ���� �����
-- �޿��� �ڿ��� '(��)' ���� ���� �����
-- ��ȥ���δ� ���ͷ� ����� : '��ȥ'���� ä��

SELECT emp_name �̸�, hire_date || '�Ի�', job_id �����ڵ�, dept_id �μ��ڵ�, salary  || '(��)',  '��ȥ' ��ȥ����
FROM employee
WHERE hire_date > '00/1/1' AND marriage = 'Y';





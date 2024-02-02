-- 4_SELECT_04(�Լ�).sql

-- ����Ŭ���� �����ϴ� �Լ�(function)
-- �ٸ� DBMS ������ ����� ����ϰų� ����

-- �Լ�(FUNCTION)
-- �÷��� ��ϵ� ���� �о �Լ��� ó���� ����� �����ϴ� ������
-- ��� : �Լ���(�÷���)

-- ������ �Լ��� �׷� �Լ� ���е� => ������� ������ �ٸ�
-- ������ �Լ� (SINGLE ROW FUNCTION) : 
-- ������ �÷��� ���� N���̸�, �Լ��� ó���� ������� N���� ���ϵ�
-- ��, �� ��(�� ��)�� �ٷ�� �Լ�

-- �׷� �Լ� (GROUP FUNCTION) :
-- ���� ���� N���̸�, �����ϴ� ������� 1����

-- ���� �����ͺ��̽��� ������ �����ͺ��̽�(RDB)��
-- �����͸� 2���� ���̺�(�ݵ�� �簢��)�� => ��, �簢���� �ƴ� ����� ��� �� ��

-- ������ �Լ��� �׷� �Լ��� �����ؾ� �Ǵ� ���� :
-- SELECT ���� �������Լ��� �׷��Լ� �Բ� ��� �� �� => ������
-- WHERE ���� �׷��Լ� ��� �� �� => ������

SELECT email, 
            UPPER(email) -- 22 �� : ������ �Լ�
FROM employee;

SELECT SUM(salary) -- 1�� : �׷��Լ�
FROM employee;

-- SELECT ������ �׷��Լ��� �������Լ��� ���� ��� �� ��
SELECT UPPER(email), SUM(salary) -- ������� ������ �ٸ�
FROM employee;

-- ������ �߿��� ���� ��ü �޿��� ��պ��� ���� �޴� ���� ��ȸ
SELECT *
FROM employee
WHERE salary > AVG(salary); -- �� �྿ �˻��ϴ� ��������, ����

SELECT AVG(salary)
FROM employee; -- �޿��� ��� ����

SELECT *
FROM employee
WHERE salary > 2961818.18181818181818181818181818181818;

SELECT *
FROM employee
WHERE salary > (Select AVG(salary)
                        FROM employee);

-- �׷� �Լ� *************************************************************************
-- SUM(), AVG(), MIN(), MAX(), COUNT()

-- SUM(�÷���) | SUM(DISTINCT �÷���)
-- �հ踦 ���ؼ� ����

-- �Ҽ� �μ��� 50 �̰ų� �μ��� �������� ���� �������� �޿� �հ� ��ȸ
SELECT SUM(salary) �޿��հ�,
            SUM(DISTINCT salary) "�ߺ��� ������ �޿� �հ�"
FROM employee
WHERE dept_id = '50' OR dept_id IS NULL;

-- ���� ���� Ȯ��
SELECT dept_id, salary
FROM employee
WHERE dept_id = '50' OR dept_id IS NULL; -- 8��

-- AVG(�÷���) | AVG(DISTINCT �÷���)
-- ����� ���ؼ� ����

-- �ҼӺμ��� 50 �Ǵ� 90 �Ǵ� NULL�� �������� ���ʽ�����Ʈ ��� ��ȸ
SELECT AVG(bonus_pct), -- /4
            AVG(DISTINCT bonus_pct) -- /3
            , AVG(NVL(bonus_pct, 0)) -- /11
FROM employee
WHERE dept_id IN('50', '90') OR dept_id IS NULL;

-- ���� �� Ȯ��
SELECT dept_id, bonus_pct
FROM employee
WHERE dept_id IN('50', '90') OR dept_id IS NULL
ORDER BY 2;

-- MAX(�÷���) | MAX(DISTINCT �÷���)
-- ���� ū �� ���� (����, ��¥, ���� ��� ó����)

-- MIN(�÷���) | MIN(DISTINCT �÷���)
-- ���� ���� �� ���� (����, ��¥, ���� ��� ó����)
-- ����Ŭ DATA TYPE : ���̺��� �÷��� ������
-- ������(CHAR, VARCHAR2, LONG, CLOB), ������(NUMBER), ��¥��(DATE)

-- �μ��ڵ尡 50 �Ǵ� 90�� ��������
-- �����ڵ�(CHAR)�� �ִ밪, �ּҰ�
-- �Ի���(DATE)�� �ִ밪, �ּҰ�
-- �޿�(NUMBER)�� �ִ밪, �ּҰ�
SELECT MAX(job_id), MIN(job_id),
            MAX(hire_date), MIN(hire_date),
            MAX(salary), MIN(salary)
FROM employee
WHERE dept_id IN ('50', '90');

-- COUNT(*) | COUNT(�÷���) | COUNT(DISTINCT �÷���)        
-- COUNT(*) : NULL�� ������ ��ü �� ��
-- COUNT(�÷���) : NULL�� ������ �� ��

-- 50�� �μ� �Ǵ� �μ��ڵ尡 NULL�� ���� ��ȸ
SELECT dept_id
FROM employee
WHERE dept_id = '50' OR dept_id IS NULL; -- 8��
        
SELECT COUNT(*), -- ��ü �� ���� (NULL ����)
            COUNT(dept_id), -- NULL ���ܵ� �� ����
            COUNT(DISTINCT dept_id) -- �ߺ��� ������ �� ����
FROM employee
WHERE dept_id = '50' OR dept_id IS NULL; -- 8��

-- ������ �Լ�***************************************************

-- ���� ó�� �Լ� ------------------------------------
-- LENGTH('���ڸ��ͷ�') | LENGTH(���ڰ� ��ϵ� �÷���)
-- ���� ���� ����

SELECT LENGTH('ORACLE'), LENGTH('����Ŭ')
FROM dual;

SELECT email, LENGTH(email)
FROM employee;
                        
 -- LENGTHB('���ڸ��ͷ�') | LENGTHB(���ڰ� ��ϵ� �÷���)
 -- ������ ����Ʈ ���� ����
 
 SELECT LENGTHB('ORACLE'), LENGTHB('����Ŭ')
FROM dual;

SELECT email, LENGTHB(email)
FROM employee;
                        
-- INSTR('���ڿ����ͷ�' | ���ڰ� ��ϵ� �÷���, ã������, ã�� ������ġ, ���°����)
-- ã�� ������ ��ġ ���� (�տ��� ������ ����)
-- �����ͺ��̽��� ���۰��� ������ 1������ (0�� �ƴ�)

-- �̸��Ͽ��� '@' ������ ��ġ ��ȸ
SELECT email, INSTR(email, '@')
FROM employee;

-- �̸��Ͽ��� '@' ���� �ٷ� �ڿ� �ִ� 'k' ������ ��ġ�� ��ȸ
-- ��, �ڿ��� ���� �˻���
SELECT email, INSTR(email, '@') + 1, INSTR(email, 'k', -1, 3)
FROM employee;

-- �Լ� ��ø ��� ����
-- �̸��Ͽ��� '.' ���� �ٷ� �ڿ� �ִ� 'c'�� ��ġ�� ��ȸ
-- �� '.' ���� �ٷ� �ձ��ں��� �˻��� �����ϵ��� ��
SELECT email, INSTR(email, 'c', INSTR(email, '.') -1)
FROM employee;

-- LPAD('���ڸ��ͷ�' | ���ڰ� ��ϵ� �÷���, ����� �ʺ����Ʈ, ���� ������ ä�﹮��)
-- ä�� ���ڰ� �����Ǹ� �⺻���� ' ' (���鹮��)
-- LPAD() : ���� ä���, RPAD() : ������ ä���

SELECT email, LENGTH(email) ��������,
            LPAD(email, 20, '*') ����ä�����,
            LENGTH(LPAD(email, 20, '*')) �������
FROM employee;

SELECT email, LENGTH(email) ��������,
            RPAD(email, 20, '*') ����ä�����,
            LENGTH(RPAD(email, 20, '*')) �������
FROM employee;

-- LTRIM('���ڸ��ͷ�' | '���ڰ� ��ϵ� �÷���, '������ ���ڵ� ����')
-- ���ʿ� �ִ� ���ڵ��� ������ ����� ����
-- RTRIM() : �����ʿ� �ִ� ���ڵ��� ������ ��� ���ڿ��� ����
SELECT '       123xyORACLExxyzz567   ',
            LTRIM('       123xyORACLExxyzz567   '),
            LTRIM('       123xyORACLExxyzz567   ', '  '),
            LTRIM('       123xyORACLExxyzz567   ', ' 0123456789'),
            LTRIM('       123xyORACLExxyzz567   ', ' xyz1234567')
FROM DUAL;

SELECT '       123xyORACLExxyzz567   ',
            RTRIM('       123xyORACLExxyzz567   '),
            RTRIM('       123xyORACLExxyzz567   ', '  '),
            RTRIM('       123xyORACLExxyzz567   ', ' 0123456789'),
            RTRIM('       123xyORACLExxyzz567   ', ' xyz1234567')
FROM DUAL;

-- TRIM(LENGTH | TRAILING | BOTH '�����ҹ���' FROM '���ڸ��ͷ�' | ���ڰ� ��ϵ� �÷���)
-- �⺻�� BOTH (�յ� ��� ����)
-- ������ ���� ������ �⺻ ' '(���鹮��)
SELECT 'aaORACLEaa',
            TRIM('a' FROM 'aaORACLEaa'),
            TRIM(LEADING 'a' FROM 'aaORACLEaa'),
            TRIM(TRAILING 'a' FROM 'aaORACLEaa'),
            TRIM(BOTH 'a' FROM 'aaORACLEaa')
FROM DUAL;

-- SUBSTR('���ڸ��ͷ�' | ���ڰ� ��ϵ� �÷���, ������ ������ġ, ������ ���� ����)
-- ������ ������ġ : ���(�տ��������� ��ġ), ���� (�ڿ��������� ��ġ)
-- ������ ���ڰ��� : �����Ǹ� �� ���ڱ����� �ǹ���

SELECT 'ORACLE 18C',
            SUBSTR('ORACLE 18C', 5),
            SUBSTR('ORACLE 18C', 8, 2),
            SUBSTR('ORACLE 18C', -7, 3)            
FROM DUAL;

-- ���� ������ �ֹι�ȣ���� ����, ����, ����, ���� �и� ��ȸ
SELECT emp_no �ֹι�ȣ,
        SUBSTR(emp_no, 1, 2) ����,
        SUBSTR(emp_no, 3, 2) ����,
        SUBSTR(emp_no, 5, 2) ����        
FROM employee;

-- ��¥ ǥ��ÿ� ����ó�� '��¥'�� ǥ���ؾ� ��
-- '24/02/01' ǥ����
-- SUBSTR() �� ��¥ �����Ϳ��� ����� �� ����

-- �������� �Ի��Ͽ��� �Ի�⵵, �Ի��, �Ի����� �и� ��ȸ
SELECT hire_date �Ի���,
        SUBSTR(hire_date, 1, 2) �Ի�⵵,
        SUBSTR(hire_date, 4, 2) �Ի��,
        SUBSTR(hire_date, 7, 2) �Ի���        
FROM employee;

-- SUBSTRB('���ڸ��ͷ� | ���ڰ� ��ϵ� �÷���, �����ҹ���Ʈ��ġ, ������ ����Ʈ ũ��)
SELECT 'ORACLE',
            SUBSTR('ORACLE', 3, 2), SUBSTRB('ORACLE', 3, 2),
            '����Ŭ',
            SUBSTR('����Ŭ', 2, 2), SUBSTR('����Ŭ', 4, 6)
FROM DUAL;

-- UPPER('�������ͷ�' | �����ڰ� ��ϵ� �÷���) : �빮�ڷ� �ٲٴ� �Լ�
-- LOWER('�������ͷ�' | �����ڰ� ��ϵ� �÷���) : �ҹ��ڷ� �ٲٴ� �Լ�
-- INITCAP('�������ͷ�' | �����ڰ� ��ϵ� �÷���) : ù���ڸ� �빮�ڷ� �ٲٴ��Լ�

SELECT UPPER('ORACLE'), UPPER('oracle'), UPPER('Oracle'),
            LOWER('ORACLE'), LOWER('oracle'), LOWER('Oracle'),
            INITCAP('ORACLE'), INITCAP('oracle'), INITCAP('Oracle')
FROM DUAL;

-- �Լ� ��ø ��� : �Լ� �ȿ� �� ��ſ� �ٸ� �Լ��� ����� �� ����
-- ���� �Լ��� ������ ���� �ٱ� �Լ��� ����Ѵٴ� �ǹ���

-- �� : ���� �������� ���, �̸�, ���̵� ��ȸ
-- ���̵�� �̸��Ͽ��� �и� ������
SELECT emp_id ���, emp_name �̸�, email �̸���,
        SUBSTR(email,1, INSTR(email, '@') - 1) ���̵�
FROM employee;

-- �� : ���� ���̺��� ���, �̸�, �ֹι�ȣ ��ȸ
-- �ֹι�ȣ�� ������ϸ� ���̰� �ϰ� ���ڸ��� '*' ó���� : 891225-*******

SELECT emp_id ���, emp_name �̸�,
            RPAD(SUBSTR(emp_no, 1, 7), 14, '*') �ֹι�ȣ
FROM employee;


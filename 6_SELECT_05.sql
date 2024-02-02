-- 6_SELECT_05(����ȯ).sql

-- Ÿ��(�ڷ���) ��ȯ �Լ� ---------------------------------------------------------
-- ������(CHAR, VARCHAR2, LONG, CLOB), ������(NUMBER), ��¥��(DATE)

-- �ڵ�����ȯ (�Ͻ��� ����ȯ) �Ǵ� ���
-- ��ǻ�� ���� ��Ģ : ���� ������ �������� ����� �� �ִ�.
SELECT
    25 + '10' -- NUMBER + CHARACTER => NUMBER + NUMBER
FROM        -- CHARACTER �� �ڵ� NUMBER�� �ٲ�
    dual;

SELECT
    *
FROM
    employee
WHERE
    emp_id = 100; -- CHAR = NUMBER => CHAR = CHAR : �ڵ� ����ȯ��
                        -- 100 => '100' �� ��ȯ�Ǿ �� �����

SELECT
    months_between(sysdate, '00/12/31')
FROM                    -- DATE - CHARACTER => �ڵ�����ȯ��, DATE - DATE 
    dual; 

-- �ڵ�����ȯ�� �� �Ǵ� ��찡 ����
SELECT
    sysdate - '15/03/25'
FROM
    dual;

-- ����� ����ȯ �ʿ��� => ����ȯ �Լ� �����
SELECT
    sysdate - TO_DATE('15/03/25')
FROM
    dual;

-- TO_CHAR() �Լ� -----------------------------------------------
-- NUMBER(���� : ����, �Ǽ�)�� DATE(��¥, �ð�)�� ���� ��� ����(FORMAT)�� �����ϴ� �Լ�
-- ������ ����� ���ڿ�(CHARACTER)�� ���ϵ�
-- TO_CHAR(NUMBER, '������ ����')
-- TO_CHAR(DATE, '������ ����')
-- FORMAT�� ��� ���¸� ���ϴ� ����� ������� ���ϸ� ��

-- ���ڿ� ���� ����
-- TO_CHAR(���� | ���ڰ� ��ϵ� �÷��� | ����, '������ ���˹��ڵ�')
-- �ַ� ��ȭ���� ǥ��(L), õ���� ������ ǥ��(,), �Ҽ��� �ڸ��� ����(.), ������ ǥ��(EEEE) ��
SELECT
    emp_name                       �̸�,
    to_char(salary, 'L99,999,999') �޿�,
    to_char(nvl(bonus_pct, 0),
            '90.00')               ���ʽ�����Ʈ
FROM
    employee;
    
-- ��¥�� ���� ����
-- TO_CHAR(TO_DATE('��¥���ڿ�') | ��¥�� ��ϵ� �÷��� | DATE ��ȯ�Լ�, '������ ���˹��ڵ�')
-- ����� �ú��� ���� �б� ���� ��� �������� ������ �� ����

-- �⵵ ��� ����
SELECT
    sysdate, -- NLS_DATE_FORMAT : 'RR/MM/DD'
    to_char(sysdate, 'yyyy'),
    to_char(sysdate, 'rrrr'),
    to_char(sysdate, 'yy'),
    to_char(sysdate, 'rr'),
    to_char(sysdate, 'year'),
    to_char(sysdate, 'rrrr"��"')
FROM
    dual;
    
    -- �� ��� ����
SELECT
    sysdate, -- NLS_DATE_FORMAT : 'RR/MM/DD'
    to_char(sysdate, 'mm'),
    to_char(sysdate, 'rm'),
    to_char(sysdate, 'month'),
    to_char(sysdate, 'mon'),
    to_char(sysdate, 'yyyy"��" fmmm"��"'),
    to_char(sysdate, 'rrrr"��" mm"��"')
FROM
    dual;
    
-- ��¥ ��� ����
SELECT
    sysdate, -- NLS_DATE_FORMAT : 'RR/MM/DD'
    to_char(sysdate, '"1�� ����" ddd'),
    to_char(sysdate, '"�� ����" dd'),
    to_char(sysdate, '"�� ����" d'),
    to_char(sysdate, 'fmdd')
FROM
    dual;

-- �б�, ���� ����
SELECT
    sysdate, -- NLS_DATE_FORMAT : 'RR/MM/DD'
    to_char(sysdate, 'q "��б�"'),
    to_char(sysdate, 'day'),
    to_char(sysdate, 'dy')
FROM
    dual;

-- �ú��� ���� | ���� ����
SELECT
    sysdate, -- NLS_DATE_FORMAT : 'RR/MM/DD'
    to_char(sysdate, 'hh24"��" mi"��" ss"��"'),
    to_char(sysdate, 'am hh:mi:ss'),
    to_char(sysdate, 'pm hh24:mi:ss')
FROM
    dual;
    
-- ���� �������� �̸�, �Ի��� ��ȸ
-- �Ի��Ͽ� ���� ���� : 2024�� 2�� 2��(��) �Ի�
SELECT
    emp_name                                                �̸�,
    to_char(hire_date, 'yyyy"��" fmmm"��" fmdd"�� ("dy") �Ի�"') �Ի���,
    to_char(hire_date, 'RRRR"��" mon fmdd"�� ("dy") �Ի�"')     �Ի���
FROM
    employee;

-- ��¥ ������ �񱳿���� ���ǻ��� :
-- ��¥�� ���� �����Ϳ� �ð��� ���� ������ �񱳽�, �� �����ʹ� equal �� �ƴ�
-- '24/02/02' = '24/02/02 14:29:30' : false
-- Ȯ��
SELECT
    emp_name                                     �̸�,
    to_char(hire_date, 'yyyy-mm-dd am hh:mi:ss') �Ի���,
    to_char(hire_date, 'yyyy-mm-dd hh24:mi:ss')  �Ի���
FROM
    employee;
-- �Ѽ��⸸ �ð� �����͸� ������ ����. �ٸ� �������� �ð� �����Ͱ� ����

-- ��¥�� �ð��� ���� ��ϵǾ� �ִ� ���� �񱳿���� ��¥�� ���� �� ����
SELECT
    emp_name,
    hire_date
FROM
    employee
WHERE
    hire_date = '90/04/01'; -- 0��
-- '2090-04-01 13:30:30' = '2090-04-01' " ���� �ʴ�.

-- �ذ� ��� 1 : ��¥�����Ϳ� ������ ����
SELECT
    emp_name,
    hire_date
FROM
    employee
WHERE
    to_char(hire_date, 'rr/mm/dd') = '90/04/01';

-- �ذ� ��� 2 : LIKE ������ ���
SELECT
    emp_name,
    hire_date
FROM
    employee
WHERE
    hire_date LIKE '90/04/01';

-- �ذ� ��� 3 : substr ���
SELECT
    emp_name,
    hire_date
FROM
    employee
WHERE
    substr(hire_date, 1, 8) = '90/04/01';

-- �ذ� ��� 4 : ��¥ ���� ���� ���
SELECT
    emp_name,
    hire_date
FROM
    employee
WHERE
    floor(hire_date - TO_DATE('2090/04/01')) = 0;

SELECT
    floor(hire_date - TO_DATE('90/04/01'))
FROM
    employee;
    
-- �ذ� ��� 5: �񱳰� ��¥�����͸� �ٲ�
SELECT
    emp_name,
    hire_date
FROM
    employee
WHERE
    hire_date = TO_DATE('90/04/01 13:30:30', 'yy/mm/dd hh24:mi:ss');

-- TO_DATE() �Լ� ----------------------------------------------------
-- TO_DATE('���ڸ��ͷ�' | ���ڰ� ��ϵ� �÷���, '�����ڿ� ��Ī�� ���˵�')
-- ���� ���ڼ��� ���˹��ڼ��� �ݵ�� ���ƾ� ��
-- to_char()�� ���˰� �ǹ̰� �ٸ�

SELECT
    TO_DATE('20161225', 'rrrrmmdd'),
    to_char(TO_DATE('20161225', 'rrrrmmdd'), 'dy')
FROM
    dual;

-- RR �� YY�� ����
-- ���ڸ� �⵵�� ���ڸ� �⵵�� �ٲ� ��
-- ���� �⵵�� (24 : 50���� ����) �� ��
-- �ٲ� �⵵�� 50�̸��̸� ���� ����(2000)�� ���� : '14'�̸� 'RRRR' => 2014�� ��
-- �ٲ� �⵵�� 50�̻��̸� ���� ����(1900)�� ���� : '90'�̸� 'RRRR' => 1990�� ��

SELECT
    hire_date,  -- �⵵ ���ڸ�
    to_char(hire_date, 'rrrr'),
    to_char(hire_date, 'yyyy')
FROM
    employee; -- �⵵�� 2�ڸ����� ���ڸ��� �ٲ� �� Y, R �ƹ��ų� ���

-- ���� �⵵(24��)�� �ٲ� �⵵�� �� �� 50�̸��̸�, y | r �ƹ��ų� ����ص� ��
SELECT
    TO_DATE('160505', 'yymmdd'),
    to_char(TO_DATE('160505', 'yymmdd'), 'yyyy-mm-dd'),
    to_char(TO_DATE('160505', 'rrmmdd'), 'rrrr-mm-dd'),
    to_char(TO_DATE('160505', 'rrmmdd'), 'yyyy-mm-dd'),
    to_char(TO_DATE('160505', 'yymmdd'), 'rrrr-mm-dd')
FROM
    dual;
    
-- ���� �⵵�� 50�̸��̰�, �ٲ� �⵵�� 50�̻��� ��
-- ���ڸ� ��¥�� �ٲ� �� �⵵�� y ��� : ���� ����(2000) �����
-- r ���� : ���� ����(1900) ���� ��
SELECT
    TO_DATE('970320', 'yymmdd'),
    to_char(TO_DATE('970320', 'yymmdd'), 'yyyy-mm-dd'), -- 2097
    to_char(TO_DATE('970320', 'rrmmdd'), 'rrrr-mm-dd'), -- 1997
    to_char(TO_DATE('970320', 'rrmmdd'), 'yyyy-mm-dd'), -- 1997
    to_char(TO_DATE('970320', 'yymmdd'), 'rrrr-mm-dd') -- 2097
FROM
    dual;
    
-- ��� : ���ڸ� to_date() �Լ��� ��¥�� �ٲ� �� �⵵�� 'R' ����ϸ� ��
-- �⵵ 2�ڸ��� 4�ڸ��� �ٲ� ���� Y, R �ƹ��ų� ����ص� ��

-- ��Ÿ �Լ� --------------------------------------------------------------

-- NVL() �Լ�
-- ������� : NVL(�÷���, �÷����� NULL �� �� �ٲ� ��)
SELECT
    emp_name,
    bonus_pct,
    dept_id,
    job_id
FROM
    employee;

SELECT
    emp_name,
    nvl(bonus_pct, 0.0),
    nvl(dept_id, '00'),
    nvl(job_id, 'J0')
FROM
    employee;

-- NVL2() �Լ�
-- ������� : NVL2(�÷���, �ٲܰ�1, �ٲܰ�2)
-- �ش� �÷��� ���� ������ �ٲܰ� 1�� �ٲٰ�, NULL�̸� �ٲܰ�2�� ������

-- ���� �������� ���ʽ�����Ʈ�� 0.2�̸��̰ų� NULL�� ������ ��ȸ
-- ���, �̸�, ���ʽ�����Ʈ, ���溸�ʽ�����Ʈ : ��Ī ó��
-- ���溸�ʽ� ����Ʈ : ���ʽ�����Ʈ���� ������ 0.15�� �ٲٰ�, NULL�̸� 0.05�� �ٲ�

SELECT
    emp_id                      ���,
    emp_name                    �̸�,
    bonus_pct                   ���ʽ�����Ʈ,
    nvl2(bonus_pct, 0.15, 0.05) ���溸�ʽ�����Ʈ
FROM
    employee
WHERE
    bonus_pct < 0.2
    OR bonus_pct IS NULL;

-- DECODE �Լ�
/*
������� : 
DECODE(���� | �÷���, ������, ���� ������ ������ ��, ..., ������N, ���ð�N)
�Ǵ�
DECODE(���� | �÷���, ������, ���� ������ ������ ��, ..., ������N, ���ð�N, ��簪�� �ƴҶ� �����Ұ�)

�ڹ��� SWITCH ���� ���۱����� ������ �Լ���
*/

-- 50�� �μ��� �ٹ��ϴ� �������� �̸��� ���� ��ȸ
-- ���� ���� : �ֹι�ȣ 8��° ���� 1 | 3�̸� ����, 2 | 4 �̸� ����
-- ���� ���� : �������������ϰ�, ���� ������ �̸� ���� �������� ���� ��
SELECT
    emp_name     �̸�,
    decode(substr(emp_no, 8, 1),
           '1',
           '����',
           '3',
           '����',
           '2',
           '����',
           '4',
           '����') ����
FROM
    employee
WHERE
    dept_id = '50'
ORDER BY
    ����,
    �̸�;

SELECT
    emp_name     �̸�,
    decode(substr(emp_no, 8, 1),
           '1',
           '����',
           '3',
           '����',
           '����') ����
FROM
    employee
WHERE
    dept_id = '50'
ORDER BY
    2,
    1; -- SELECT ���� �������׸��� ���� �Ǵ� ��Ī�� ����ص� ��
    
-- ���� �̸��� ������ ��� ��ȸ
SELECT
    emp_name,
    mgr_id
FROM
    employee;

-- �����ڻ���� NULL�̸� '000'���� �ٲ�
-- 1. NVL() ���
SELECT
    emp_name,
    mgr_id,
    nvl(mgr_id, '000')
FROM
    employee;

-- 2. DECODE() ���
SELECT
    emp_name,
    mgr_id,
    decode(mgr_id, NULL, '000', mgr_id)
FROM
    employee;
    
-- ���޺� �޿� �λ���� �ٸ� ��
-- 1. DECODE() ����� ���
SELECT
    emp_name,
    job_id,
    to_char(salary, 'L99,999,999'),
    to_char(decode(job_id, 'J7', salary * 1.1, 'J6', salary * 1.15,
                   'J5', salary * 1.2, salary * 1.05),
            'L99,999,999') �λ�޿�
FROM
    employee;
    
-- 2. CASE() ǥ�ǽ� ����� ��� : ���� IF���� ���� ���� ������ ����
SELECT
    emp_name,
    job_id,
    to_char(salary, 'L99,999,999'),
    to_char(
        CASE job_id
            WHEN 'J7' THEN
                salary * 1.1
            WHEN 'J6' THEN
                salary * 1.15
            WHEN 'J5' THEN
                salary * 1.2
            ELSE
                salary * 1.05
        END, 'L99,999,999') �λ�޿�
FROM
    employee;

-- CASE ǥ���� ��� 2 :
-- ������ �޿��� ����� �Űܼ� ���� ó��
SELECT
    emp_id,
    emp_name,
    salary,
    CASE
        WHEN salary <= 3000000 THEN
            '�ʱ�'
        WHEN salary <= 4000000 THEN
            '�߱�'
        ELSE
            '���'
    END ����
FROM
    employee
ORDER BY
    ����;

-- ********************************************************************************************
-- OREDER BY ��
/*
������� : 
        ORDER BY ���ı��� ���Ĺ��, ���ı���2 ���Ĺ��, .......
�����ġ : SELECT ���� ���� �������� �ۼ���
������� : ���� �������� �۵���

���ı��� : SELECT ���� �÷���, ��Ī, SELECT ���� ������ �׸��� ����(1, 2, 3, ..)
���Ĺ�� : ASC(��������) | DESC
        - ASCending : ������������, DESCending : ������������
*/

-- ���� �������� �μ��ڵ尡 50 �Ǵ� NULL�� �������� ��ȸ
-- �̸�, �޿�
-- �޿����� �������������ϰ�, ���� �޿��� �̸����� ������������ ó����
SELECT
    emp_name �̸�,
    salary   �޿�
FROM
    employee
WHERE
    dept_id = '50'
    OR dept_id IS NULL
--ORDER BY salary DESC, emp_name;
--ORDER BY �޿�, �̸�;
ORDER BY
    2 DESC,
    1;

-- 2003�� 1�� 1�� ���� �Ի��� ���� ��� ��ȸ
-- ��, �ش� ��¥�� ������
-- �̸�, �Ի��� ,�μ��ڵ�, �޿� : ��Ī
-- �μ��ڵ� ���� �������������ϰ�, ���� �μ��ڵ忡 ���ؼ��� �Ի��� ���� �������������ϰ�,
-- �Ի��ϵ� ������ �̸� ���� ������������ ó����
SELECT
    emp_name  �̸�,
    hire_date �Ի���,
    dept_id   �μ��ڵ�,
    salary    �޿�
FROM
    employee
WHERE
    hire_date > TO_DATE('20030101', 'rrrrmmdd')
--ORDER BY dept_id DESC NULLS LAST, hire_date;
--ORDER BY �μ��ڵ� DESC NULLS LAST, �Ի���, �̸�;
ORDER BY
    3 DESC NULLS LAST,
    2,
    1;

-- ORDER BY ���� NULL ��ġ ���� ���� :
-- ORDER BY ���ı��� ���Ĺ�� NULLS LAST : NULL�� �Ʒ��ʿ� ��ġ��
-- ORDER BY ���ı��� ���Ĺ�� NULLS FIRST : NULL�� ���ʿ� ��ġ��(�⺻)

-- GROUP BY �� --------------------------------------------------------------
-- ���� ������ ���� �� ��ϵ� �÷��� ������ ���� ������ �׷����� ������
-- GROUP BY �÷��� | �÷��� ���� ����
-- ���� ������ �׷����� ��� �׷��Լ��� �����
-- SELECT ���� GRUOP BY �� ���� �׷캰 �׷��Լ� ��� ������ �ۼ���

SELECT DISTINCT
    dept_id
FROM
    employee
ORDER BY
    1;

-- �μ��� �޿��� �հ� ��ȸ
SELECT
    dept_id,
    SUM(salary)
FROM
    employee
GROUP BY
    dept_id;

SELECT
    dept_id,
    SUM(salary)        �μ����޿��հ�,
    floor(AVG(salary)) �μ����޿����,
    COUNT(salary)      �μ���������,
    MAX(salary)        �μ����޿�ū��,
    MIN(salary)        �μ����޿�������
FROM
    employee
GROUP BY
    dept_id
ORDER BY
    1 DESC NULLS LAST;
    
-- GROUP BY ������ �׷����� �������� ������ ����� ���� ����'
-- ���� �������� ������ �޿��հ�, �޿����(õ�������� �ݿø���), ������ ��ȸ
-- ������ ��������������
SELECT
    decode(substr(emp_no, 8 ,1), '1', '��', '3', '��', '��') ����,
    sum(salary) �޿��հ�,
    ROUND(AVG(salary), -4) �޿����,
    count(*) ������
FROM
    employee
GROUP BY
    decode(substr(emp_no, 8 ,1), '1', '��', '3', '��', '��')
ORDER BY ����;

-- GROUP BY ���� �Լ� ------------------------------------------

-- ROLLUP() �Լ�
-- GROUP BY ������ ����
-- �׷캰�� ��� ����� ����� ���� ����� �����踦 ǥ���ϴ� �Լ�
-- ������ �κ��հ� ����. �Ұ� ó��

-- Ȯ��
SELECT
    dept_id,
    SUM(salary)
FROM
    employee
GROUP BY
    dept_id;

-- NULL ����
SELECT
    dept_id,
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL
GROUP BY
    dept_id;

-- ROLLUP()
SELECT
    dept_id,
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL
GROUP BY
    ROLLUP(dept_id);

-- ������ Ȯ��
SELECT
    dept_id,
    SUM(salary),
    FLOOR(AVG(salary)),
    COUNT(salary),
    MIN(salary),
    MAX(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL
GROUP BY
    ROLLUP(dept_id);

-- ���� : �μ��ڵ�� �����ڵ带 �Բ� �׷��� ����, �޿��� �հ踦 ����
-- NULL�� ������, ROLLUP() ���
SELECT
    dept_id,
    job_id,
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL AND job_id IS NOT NULL
GROUP BY
    dept_id, job_id
ORDER BY
    1 desc;

SELECT
    dept_id,
    job_id,
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL AND job_id IS NOT NULL
GROUP BY
    ROLLUP(dept_id, job_id)
ORDER BY
    1 desc;

SELECT
    dept_id,
    job_id,
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL AND job_id IS NOT NULL
GROUP BY
    ROLLUP(dept_id), ROLLUP(job_id)
ORDER BY
    1 desc;
    
SELECT
    dept_id,
    job_id,
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL AND job_id IS NOT NULL
GROUP BY
    ROLLUP(job_id), ROLLUP(dept_id)
ORDER BY
    1 desc;

-- CUBE() �Լ�
SELECT
    dept_id,
    job_id,
    SUM(salary)    
FROM
    employee
WHERE
    dept_id IS NOT NULL AND job_id IS NOT NULL
GROUP BY
    CUBE(dept_id, job_id)
ORDER BY
    1 desc;
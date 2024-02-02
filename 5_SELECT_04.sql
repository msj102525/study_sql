-- 5_SELECT_04.sql

-- ���� ó�� �Լ� ---------------------------------------------
-- ROUND(), TRUNC(), FLOOR(), ABS(), MOD()

-- ROUND(���� | ���ڰ� ��ϵ� �÷��� | ����, �ݿø��� �ڸ���)
-- �������� ���� 6�̻��̸� �ڵ� �ݿø���
-- �ݿø��� �ڸ����� ����̸�, �Ҽ��� �Ʒ� ǥ��(���)�� �ڸ��� �ǹ���
-- �ݿø��� �ڸ����� �����̸�, �Ҽ��� ��(������) �ø��� �ڸ��� �ǹ���

SELECT
    123.456,
    round(123.456), -- 123 : �ڸ��� �����Ǹ� �⺻�� 0 �� (�Ҽ��� ��ġ��)
    round(123.456, 0), -- 123
    round(123.456, 1), -- 123.5
    round(123.456, - 1) -- 120
FROM
    dual;

-- ���� �������� ���, �̸�, �޿�, ���ʽ�����Ʈ, ���ʽ�����Ʈ ���� ����
-- ������ ��Ī ó�� : 1��޿�
-- ������ õ�������� �ݿø� ó����
SELECT
    emp_id     ���,
    emp_name   �̸�,
    salary     �޿�,
    bonus_pct  ���ʽ�����Ʈ,
    round(((salary +(salary * nvl(bonus_pct, 0))) * 12),
          - 4) "1��޿�"
FROM
    employee;
    
-- TRUNC(���� | ���ڰ� ��ϵ� �÷��� | ����, �ڸ� �ڸ���)
-- ������ �ڸ� �Ʒ��� ���� ����, ���� �Լ�, �ݿø� ����
SELECT
    145.678,
    trunc(145.678), -- 145
    trunc(145.567, 0), -- 145
    trunc(145.678, 1), -- 145.6
    trunc(145.678, - 1), -- 140
    trunc(145.678, - 3) -- 0
FROM
    dual;

-- ���� �������� �޿��� ����� ��ȸ
-- 10�������� ������
SELECT
    AVG(salary),
    trunc(AVG(salary),
          - 2)
FROM
    employee;

-- FLOOR(���� | ���ڰ� ��ϵ� �÷��� | ����)
-- ���� ����� �Լ� (�Ҽ��� �Ʒ��� ����)
SELECT
    round(123.5),
    trunc(123.5),
    floor(123.5)
FROM
    dual;
    
-- ABS(���� | ���ڱ� ��ϵ� �÷��� | ����)
-- ���밪 ����(���, 0 : �� �״��, ���� : ����� �ٲ�)
SELECT
    abs(23),
    abs(- 23)
FROM
    dual;
    
-- ���� �������� �Ի��� - ����, ���� - �Ի��� ��ȸ
-- ��Ī : �ٹ��ϼ�
-- ���� ��¥ ��ȸ �Լ� : SYSDATE
-- �ٹ��ϼ��� ��� ����� ó����
SELECT
    emp_name,
    hire_date - sysdate,
    sysdate - hire_date,
    abs(floor(hire_date - sysdate)) �ٹ��ϼ�,
    floor(abs(sysdate - hire_date)) �ٹ��ϼ�
FROM
    employee;
    
-- MOD(���� ��, ���� ��)    
-- �������� �������� ������
-- �����ͺ��̽������� % (MOD) ������ ��� �� ��
SELECT
    floor(25 / 7) ��,
    mod(25, 7)    ������
FROM
    dual;
    
-- ���� �������� ����� Ȧ���� ���� ��ȸ
-- ���, �̸�
SELECT
    emp_id   ���,
    emp_name �̸�
FROM
    c##student.employee -- ���� ǥ�� : ����ڰ���.���̺�ü�� => ����ڰ����� ���� ����
WHERE
    mod(emp_id, 2) = 1;
-- '101' => ���� 101 �ڵ�����ȯ�Ǿ ���Ǿ���

-- ��¥ ó�� �Լ� ------------------------------------------------------------------------

-- SYSDATE �Լ�
-- �ý������� ���� ���� ��¥�� �ð��� ��ȸ�� �� ���
SELECT
    sysdate
FROM
    dual; -- ��µǴ� ��¥ ����(FORMAT) : 24/02/02 (RR/MM/DD)
    
-- ����Ŭ������ ȯ�漳��, ��ü ���� �������� ��� ���� �����ϰ� ����
-- ������ ��ųʸ� (������ ����) ���·� �����ϰ� ����
-- ������ ��ųʸ� ������ ���̺� ���·� �� �������� ���� �����ϰ� ����
-- ������ ��ųʸ��� DB �ý����� ������. ����ڴ� �մ� �� ����
-- ����� ������ ��ȸ�� �� ���� ����

-- ��, ȯ�漳���� ���õ� PARAMETER(����) ������ �Ϻ� ������ ���� ����
SELECT
    *
FROM
    sys.nls_session_parameters;

-- ��¥ ���˰� ���õ� ���� ���� ��ȸ�Ѵٸ�
SELECT
    value
FROM
    sys.nls_session_parameters
WHERE
    parameter = 'NLS_DATE_FORMAT';

-- ��¥ ������ �����Ѵٸ�
ALTER SESSION SET nls_date_format = 'DD-MON-RR';

-- Ȯ��
SELECT
    sysdate
FROM
    dual;

-- ���� �������� ����
ALTER SESSION SET nls_date_format = 'RR/MM/DD';

-- ADD_MONTHS('��¥' | ��¥�� ��ϵ� �÷���, ���� ������)
-- ���� �������� ���� ��¥�� ���ϵ�

-- ���� ��¥���� 6���� �� ��¥��?
SELECT
    add_months(sysdate, 6)
FROM
    dual;
    
-- ���� �������� �Ի��Ϸ� ���� 20��� ��¥ ��ȸ
-- ���, �̸�, �Ի���, 20��� ��¥ (��Ī)
SELECT
    emp_id    ���,
    emp_name  �̸�,
    hire_date �Ի���,
    add_months(hire_date, 240)
FROM
    employee;

-- ������ �Լ��� WHERE ������ ����� �� ����
-- ������ �߿��� �ٹ������ 20���̻�� ���� ��� ��ȸ
-- ���, �̸�, �μ��ڵ�, �����ڵ�, �Ի���, �ٹ���� (��Ī)
-- �ٹ���� ���� ������������ ó����
SELECT
    emp_id                             ���,
    emp_name                           �̸�,
    dept_id                            �μ��ڵ�,
    job_id                             �����ڵ�,
    hire_date                          �Ի���,
    floor((sysdate - hire_date) / 365) �ٹ����
FROM
    employee
WHERE
    add_months(hire_date, 240) <= sysdate
ORDER BY
    �ٹ���� DESC;
    
-- MONTHS_BETWEEN(DATE1, DATE2)
-- '��¥' | ��¥�� ��ϵ� �÷��� | ��¥�Լ� ����� �� ����
-- �� ��¥�� ���̳��� �������� ������

-- �������� �̸�, �Ի���, ��������� �ٹ��ϼ�, �ٹ�������, �ٹ���� ��ȸ
-- ���������� ��� ó����
SELECT
    emp_name                                       �̸�,
    hire_date                                      �Ի���,
    floor(sysdate - hire_date)                     �ٹ��ϼ�,
    floor(months_between(sysdate, hire_date))      �ٹ�������,
    floor(months_between(sysdate, hire_date) / 12) �ٹ����
FROM
    employee;
    
-- NEXT_DAY('��¥' | ��¥�� ��ϵ� �÷���, '�����̸�')
-- ������ ��¥ ���� ��¥���� ���� ����� ���� ������ ��¥�� ������
-- ���� DBMS�� ��� �� 'KOREAN' �̹Ƿ�, �����̸��� �ѱ۷� ��� ��
-- ���� �����̸� ����ϸ� ������
SELECT
    sysdate,
    next_day(sysdate, '�Ͽ���')
FROM
    dual;

SELECT
    sysdate,
    next_day(sysdate, 'SUNDAY') -- ���� �����̸� ���� ���� �߻���
FROM
    dual;

-- ȯ�漳�� ������ �� ������ ��
ALTER SESSION SET nls_language = american;

-- ���� ������
ALTER SESSION SET nls_language = korean;

-- LAST_DAY('��¥' | ��¥�� ��ϵ� �÷���)
-- ������ ��¥�� ���� ���� ���� ��¥�� ������
SELECT
    sysdate,
    last_day(sysdate),
    '24/07/01',
    last_day('24/07/01')
FROM
    dual;
    
-- ���� �������� �̸�, �Ի���, �Ի��� ���� �ٹ��ϼ� ��ȸ
-- �ָ� ���� �ϼ�
SELECT
    emp_name                        �̸�,
    hire_date                       �Ի���,
    last_day(hire_date) - hire_date "�Ի� ù�� �ٹ��ϼ�"
FROM
    employee;
    
-- ���� ��¥�� �ð��� ��ȸ�Ϸ��� 
SELECT
    sysdate,
    systimestamp,
    current_date,
    current_timestamp
FROM
    dual;

-- EXTRACT(������ ���� FROM ��¥)
-- ��¥ �����Ϳ��� ���ϴ� ������ ������
-- ������ ���� : YEAR, MONTH, DAY, HOUR, MINUTE, SECOND

-- ���� ��¥���� ��, ��, �� ���� ����
SELECT
    sysdate,
    EXTRACT(YEAR FROM sysdate),
    EXTRACT(MONTH FROM sysdate),
    EXTRACT(DAY FROM sysdate)
FROM
    dual;
    
-- �������� �̸�, �Ի���, �ٹ���� ��ȸ
SELECT
    emp_name �̸�,
    hire_date �Ի���,
    EXTRACT(YEAR FROM sysdate) - EXTRACT(YEAR FROM hire_date) �ٹ����
FROM
    employee;
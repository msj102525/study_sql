-- 3_ SELECT_02.sql

-- �񱳿����� ***************************************************

-- BETWEEN AND ������
-- WHERE �÷��� BETWEEN ������ AND ū��
-- �÷��� ��ϵ� ���� ���� �� �̻��̸鼭 ū �� ������ ���̶�� �ǹ���
-- WHERE �÷��� >= ���� �� AND �÷��� <= ū ���� ����

-- ���� �߿��� �޿��� 2�鸸 �̻� 4�鸸 ���� ���� ���� �޿��� �޴� ���� ��ȸ
-- ���, �̸�, �޿�, �����ڵ�, �μ��ڵ� : ��Ī -- 16��
SELECT emp_id ���, emp_name �̸�, salary �޿�, job_id �����ڵ�, dept_id �μ��ڵ�
FROM employee
--WHERE salary >= 2000000 AND salary <= 4000000;
WHERE salary BETWEEN 2000000 AND 4000000;

-- ��¥ �����Ϳ��� ����� �� ����
-- ������ �Ի����� 95�� 1�� 1�Ϻ��� 2000�� 12�� 31�� ������ �ش�Ǵ� ���� ���� ��ȸ
-- ���, �̸�, �Ի���, �μ��ڵ� : ��Ī
SELECT emp_id ���, emp_name �̸�, hire_date �Ի���, dept_id �μ��ڵ�
FROM employee
--WHERE hire_date BETWEEN '95/01/01' AND '00/12/31';
WHERE hire_date >= '95/01/01' AND hire_date <= '00/12/01';


-- LIKE ������
-- ���ϵ�ī�� ����(%, _)�� �̿��ؼ� ���������� ������
-- �÷��� ��ϵ� ���� ���õ� �������ϰ� ��ġ�ϴ� ������ ��� �� �����
-- WHERE �÷��� LIKE '��������'
-- % : 0�� �̻��� ���ڵ�, _ : ���� ���ڸ�

-- ���� '��'���� ���� ��ȸ
-- ���, �̸�, ��ȭ��ȣ, �̸��� : ��Ī -- 3��
SELECT emp_id ���, emp_name, phone ��ȭ��ȣ, email �̸���
FROM employee
WHERE emp_name LIKE '��%';

-- ���� '��'���� �ƴ� ���� ��ȸ -- 19��
SELECT emp_id ���, emp_name, phone ��ȭ��ȣ, email �̸���
FROM employee
--WHERE emp_name NOT LIKE '��%';
WHERE NOT emp_name LIKE '��%';

-- �������� �̸��� '��'�ڰ� ����ִ� ���� ��ȸ -- 1��
SELECT emp_id ���, emp_name, phone ��ȭ��ȣ, email �̸���
FROM employee
WHERE emp_name LIKE '%��%';

-- ��ȭ��ȣ�� ������ 4�ڸ��̸鼭 9�� �����ϴ� ��ȣ�� ���� ���� ��ȸ
-- �̸�, ��ȭ��ȣ
SELECT emp_name, phone ��ȭ��ȣ
FROM employee
--WHERE phone LIKE '___9_______'; -- 2��
WHERE phone LIKE '___9%'; -- 3�� : ������ ���۰��� 9�� ��ȭ��ȣ�� ��

-- ������ ������ ���� ��ȸ
-- ���, �̸�, �ֹι�ȣ, ��ȭ��ȣ : ��Ī
-- �ֹι�ȣ 8��° ���ڰ� 1�̸� ����, 2�̸� ������
SELECT emp_id ���, emp_name �̸�, emp_no �ֹι�ȣ, phone ��ȭ��ȣ
FROM employee
WHERE emp_no LIKE '_______2%'; -- 8��

-- ���� ���� ��ȸ
SELECT emp_id ���, emp_name �̸�, emp_no �ֹι�ȣ, phone ��ȭ��ȣ
FROM employee
--WHERE emp_no NOT LIKE '_______2%'; -- 14��
WHERE emp_no LIKE '_______1%'; -- 14��

-- LIKE ���� ���ÿ� �÷��� ��ϵ� ��ȣ����(_, %)�� ���ϵ�ī�� ���ڸ� ������ �ʿ䰡 �ִ� ��찡 ����
-- �� : �̸��Ͽ� ���̵� ���� '_' ���ڰ� ���ԵǾ� ����
-- ESCAPE OPTION�� ����ؼ� ��ϵ� ��ȣ���ڸ� ������ ��
-- �����ڷ� ����� ��ȣ�� ���Ǵ�� ���ϸ� ��
-- ��ϵ� ���� �ٷ� �տ� ǥ����

-- �̸��Ͽ��� ��ϵ� '_' ���� �ձ��ڰ� 3������ ���� ��ȸ
SELECT emp_name, email
FROM employee
WHERE email LIKE '___+_%' ESCAPE '+'; -- 1��

-- IS NULL / IS NOT NULL
-- WHERE �÷��� IS NULL : �÷� ĭ�� ��� �ִ°�
-- WHERE �÷��� IS NOT NULL : �÷� ĭ�� ��� ���� �ʴ°� (���� �ִ°�)
-- ���� : �÷��� = NULL ������

-- �μ��� ���޵� �������� ���� ���� ��ȸ
-- ���, �̸�, �����ڵ�, �μ��ڵ�
SELECT emp_id, emp_name, job_id, dept_id
FROM employee
WHERE dept_id IS NULL
AND job_id IS NULL; -- 1��

-- ���ʽ�����Ʈ�� ���� ���� ��ȸ
-- ���, �̸�, �μ��ڵ�, ���ʽ�����Ʈ
SELECT emp_id, emp_name, dept_id, bonus_pct
FROM employee
WHERE bonus_pct IS NULL -- 14��
OR bonus_pct = 0.0; -- 14��

-- ���ʽ��� �޴� ����
SELECT emp_id, emp_name, dept_id, bonus_pct
FROM employee
WHERE bonus_pct IS NOT NULL -- 8��
AND bonus_pct != 0.0; -- 8��

-- �μ��� �������� �ʾҴµ�, �����ڰ� �ִ� ���� ��ȸ
-- ���, �̸�, �����ڻ��, �μ��ڵ�
SELECT emp_id, emp_name, mgr_id, dept_id
FROM employee
WHERE dept_id IS NULL
AND mgr_id IS NOT NULL; -- 0��

-- �μ��� ���� �����ڵ� ���� ���� ��ȸ
SELECT emp_id, emp_name, mgr_id, dept_id
FROM employee
WHERE dept_id IS NULL
AND mgr_id IS NULL;

-- �μ��� ���µ�, ���ʽ�����Ʈ �޴� ���� ��ȸ
-- ���, �̸�, ���ʽ�����Ʈ, �μ��ڵ�
SELECT emp_id, emp_name, bonus_pct, dept_id
FROM employee
WHERE dept_id IS NULL AND bonus_pct IS NOT NULL;

-- IN ������
-- WHERE �÷��� IN (�񱳰�, �񱳰�, ...)
-- WHERE �÷��� = �񱳰�1 OR �÷��� = �񱳰�2 OR .....

-- 20�� �μ� �Ǵ� 90�� �μ��� �ٹ��ϴ� ���� ��ȸ
SELECT *
FROM employee
--WHERE dept_id = '20' OR dept_id = '90'; -- 6��
WHERE dept_id IN ('20', '90'); -- 6��

-- ������ �켱 ������ ���� ���� ����� �����
-- 60, 90�� �μ��� �Ҽӵ� ������ �߿��� �޿並 3�鸸���� ���� �޴� ���� ��ȸ
SELECT emp_id, dept_id, salary
FROM employee
WHERE dept_id = '60' OR dept_id = '90' AND salary >= 3000000; -- 6��
-- AND�� OR ���� �켱 ������ ����

-- �ذ�1 : ���� ����� �κ��� ()�� ����
SELECT emp_id, dept_id, salary
FROM employee
WHERE (dept_id = '60' OR dept_id = '90') AND salary >= 3000000; -- 5��

-- �ذ�2 : IN ������ ���
SELECT emp_id, dept_id, salary
FROM employee
WHERE dept_id IN ('60', '90') AND salary >= 3000000; -- 5��

--SELECT �������� ***********************************************************************

--1. �μ��ڵ尡 90�̸鼭, �����ڵ尡 J2�� �������� ���, �̸�, �μ��ڵ�, �����ڵ�, �޿� ��ȸ�� ��Ī ������
SELECT emp_id ���, emp_name �̸�, dept_id �μ��ڵ�, job_id �����ڵ�, salary �޿�
FROM employee
WHERE dept_id = '90' AND job_id = 'J2';

--2. �Ի����� '1982-01-01' �����̰ų�, �����ڵ尡 J3 �� �������� ���, �̸�, ������ ���, ���ʽ�����Ʈ ��ȸ��
SELECT emp_id, emp_name, dept_id, bonus_pct
FROM employee
WHERE hire_date > '82/01/01' OR job_id = 'J3';


--3. �����ڵ尡 J4�� �ƴ� �������� �޿��� ���ʽ�����Ʈ�� ����� ������ ��ȸ��.
--  ��Ī ������, ���, �����, �����ڵ�, ����(��)
--  ��, ���ʽ�����Ʈ�� null �� ���� 0���� �ٲپ� ����ϵ��� ��.
SELECT emp_id ���, emp_name �̸�, job_id �����ڵ�, salary, 
            (salary + (salary * NVL(bonus_pct, 0))) * 12 || ' (��)' "����(��)"
FROM employee
WHERE job_id != 'J4';

--4. ���ʽ�����Ʈ�� 0.1 �̻� 0.2 ������ �������� ���, �����, �̸���, �޿�, ���ʽ�����Ʈ ��ȸ��
SELECT emp_id, emp_name, email, salary, bonus_pct
FROM employee
WHERE bonus_pct BETWEEN 0.1 AND 0.2;

--5. ���ʽ�����Ʈ�� 0.1 ���� �۰ų�(�̸�), 0.2 ���� ����(�ʰ�) �������� ���, �����, ���ʽ�����Ʈ, �޿�, �Ի��� ��ȸ��
SELECT emp_id, emp_name, email, salary, bonus_pct
FROM employee
WHERE bonus_pct NOT BETWEEN 0.1 AND 0.2;

--6. '1982-01-01' ���Ŀ� �Ի��� �������� �����, ���ʽ�����Ʈ, �޿� ��ȸ��
SELECT emp_name, bonus_pct, salary -- , hire_date
FROM employee
WHERE hire_date > '82/01/01';

--7. ���ʽ�����Ʈ�� 0.1, 0.2 �� �������� ���, �����, ���ʽ�����Ʈ, ��ȭ��ȣ ��ȸ��
SELECT emp_id, emp_name, bonus_pct, phone
FROM employee
WHERE bonus_pct IN (0.1, 0.2); -- 5��

--8. ���ʽ�����Ʈ�� 0.1�� 0.2�� �ƴ� �������� ���, �����, ���ʽ�����Ʈ, �ֹι�ȣ ��ȸ��
SELECT emp_id, emp_name, bonus_pct
FROM employee
WHERE bonus_pct NOT IN(0.1, 0.2);

--9. ���� '��'���� �������� ���, �����, �Ի��� ��ȸ��
--  ��, �Ի��� ���� �������� ������
SELECT emp_id, emp_name, hire_date
FROM employee
WHERE emp_name LIKE '��%'
ORDER BY hire_date;

--10. �ֹι�ȣ 8��° ���� '2'�� ������ ���, �����, �ֹι�ȣ, �޿��� ��ȸ��
--  ��, �޿� ���� �������� ������

SELECT emp_id, emp_name, emp_no, salary
FROM employee
WHERE emp_no LIKE  '_______2%'
ORDER BY salary DESC;


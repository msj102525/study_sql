-- 10_SELECT_09(�м��Լ�).sql

/*
WITH �̸� AS (����������)
SELECT * FROM �̸�;
=> ������������ �̸��� �ٿ��ְ�, SELECT �������� ������������ �ʿ�� �̸��� ��� �����
=> ���� ���������� ���� �� ���� ���, SELECT �������� ���������� �ߺ� ����� ���� �� ����
=> ���� �ӵ��� ������ : �̸� ������ �Ǿ���
=> �ζ��κ�� ���� ���������� �ַ� ����
*/

SELECT *
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT;
-- DEPARTMENT �� PRIMARY KEY �� ������ �÷�(DEPT_ID)�� �ڵ����� ���� �÷����� ����
-- EQUAL INNER JOIN �� ����� ����

-- �μ��� �޿��� �հ谡 ��ü �޿� ������ 20% ���� ���� �μ��� �޿��հ谪�� ���� �μ� ��ȸ
-- �μ���, �μ��� �޿��հ� ��ȸ
-- �Ϲ� SQL �� : 
SELECT DEPT_NAME, SUM(SALARY)
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT
GROUP BY DEPT_NAME
HAVING SUM(SALARY) > (SELECT SUM(SALARY) * 0.2
                        FROM EMPLOYEE);

-- WITH ��� SQL�� : 
WITH TOTAL_SAL AS (SELECT DEPT_NAME, SUM(SALARY) DSAL
                    FROM EMPLOYEE
                    NATURAL JOIN DEPARTMENT
                    GROUP BY DEPT_NAME)
SELECT DEPT_NAME, DSAL
FROM TOTAL_SAL  -- �ζ��κ�
WHERE DSAL > (SELECT SUM(SALARY) * 0.2
                FROM EMPLOYEE);

-- �޿� ���� �޴� ���� 3�� ��ȸ  
-- ROWNUM, �̸�, �޿�
-- ROWNUM ��� �Ϲ� SQL �� : 
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY SALARY DESC)
WHERE ROWNUM < 4;

-- ROWNUM ��� WITH SQL �� : 
WITH SAL_DESC AS (SELECT *
                    FROM EMPLOYEE
                    ORDER BY SALARY DESC)
SELECT ROWNUM, EMP_NAME, SALARY
FROM SAL_DESC
WHERE ROWNUM < 4;

-- RANK() ��� �Ϲ� SQL �� : 
SELECT EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY,
               RANK() OVER (ORDER BY SALARY DESC) ����
        FROM EMPLOYEE)
WHERE ���� < 4;

-- RANK() ��� WITH SQL �� : 
WITH SAL_RANK AS (SELECT EMP_NAME, SALARY,
                           RANK() OVER (ORDER BY SALARY DESC) ����
                    FROM EMPLOYEE)
SELECT EMP_NAME, SALARY
FROM SAL_RANK
WHERE ���� < 4;

-- *************************************************************
-- �м��Լ�
/*
�м��Լ��� ���� : 
����Ŭ �м��Լ��� �����͸� �м��ϴ� �Լ��̴�.
�м��Լ��� ����ϸ�, ���� ������ ����� RESULT SET�� ������� ��ü �׷��� �ƴ�
�ұ׷캰�� �� �࿡ ���� �м� ����� �����Ѵ�.

�Ϲ� �׷��Լ���� �ٸ� ���� �м��Լ��� �м��Լ��� �׷��� ������ �����ؼ� �� �׷��� ������� ����� ������
�м��Լ��� �׷��� ����Ŭ������ ������(Window)��� �θ�
�м��Լ� == �������Լ� ��� ��

������� : 
�м��Լ���([��������1, ��������2, ��������3]) OVER ([���� PARTITION ��]
                                          [ORDER BY ��]
                                          [WINDOW ��])
* �м��Լ� : SUM, AVG, COUNT, MAX, MIN, RANK ��
* �������� : �м��Լ��� ���� 0 ~ 3������ �� ���
* ���� PARTITION �� : PARTITION BY ǥ����
            PARTITION BY �� �����ϸ�, ǥ���Ŀ� ���� �׷캰�� ���� ������� �и��ϴ� ������ ��
            ��, �м��Լ��� �м� ��� �׷��� ������
* ORDER BY �� : PARTITION BY �� �ڿ� ��ġ�ϸ�, ��� ��� �׷쿡 ���� ���� �����۾��� ������
* WINDOW �� : �м��Լ��� ����� �Ǵ� �����͸� ���������(���ι�������) �������� �� ���������� ������
            PARTITION BY �� ���� �������� �׷쿡 ���� �� �ٸ� �ұ׷��� ����
*/

-- RANK() : ��� �ű�� �Լ�
-- ���� ����� �������� ���� ����� �ǳʶ�
-- �� : 1, 2, 2, 4

-- �޿��� ������ �ű�ٸ�
SELECT EMP_ID, EMP_NAME, SALARY,
        RANK() OVER (ORDER BY SALARY DESC) ����
FROM EMPLOYEE;

-- Ư�� ���� ������ ��ȸ�� ��
-- �޿� 230���� ��ü �޿� �����������Ľ��� ������?
SELECT RANK(2300000) WITHIN GROUP (ORDER BY SALARY DESC) ����
FROM EMPLOYEE;

-- DENSE_RANK() : ���� �ű�� �Լ�
-- ���� ������ �־ ���� ������ �ǳʶ��� ����
-- �� : 1, 2, 2, 3
SELECT EMP_NAME, DEPT_ID, SALARY,
        RANK() OVER (ORDER BY SALARY DESC) "����1",
        DENSE_RANK() OVER (ORDER BY SALARY DESC) "����2",
        DENSE_RANK() OVER (PARTITION BY DEPT_ID
                             ORDER BY SALARY DESC) "����3"
FROM EMPLOYEE
ORDER BY 2 DESC NULLS LAST;

-- RANK() | DENSE_RANK() �� �̿��� TOP-N �м�
-- �޿� ���� ������ ���� 5�� ��ȸ
-- RANK() : 
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK() OVER (ORDER BY SALARY DESC) ����
        FROM EMPLOYEE)
WHERE ���� <= 5;

-- DENSE_RANK() : 
SELECT *
FROM (SELECT EMP_NAME, SALARY, DENSE_RANK() OVER (ORDER BY SALARY DESC) ����
        FROM EMPLOYEE)
WHERE ���� <= 5;

-- �޿� ���� ������ 11������ �ش�Ǵ� ���� ���� ��ȸ
-- RANK() : ���� ����� ���� �� ������ ���� ����� �ǳʶ�
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK() OVER (ORDER BY SALARY DESC) ����
        FROM EMPLOYEE)
WHERE ���� = 11;

-- DENSE_RANK() : ���� ����� ���� �� �־ ���� ����� �̾���
SELECT *
FROM (SELECT EMP_NAME, SALARY, DENSE_RANK() OVER (ORDER BY SALARY DESC) ����
        FROM EMPLOYEE)
WHERE ���� = 11;

-- CUME_DIST() : CUMulativE_DISTribution ----------------------------------------
-- PARTITION BY �� ���� �������� �׷캰�� �� ���� ORDER BY ���� ��õ� ������ ������ �Ŀ�
-- �׷캰�� ������ �л�����(������� ��ġ)�� ���ϴ� �Լ�
-- �л�����(������� ��ġ)�� ���ϰ��� �ϴ� ������ �۰ų� ���� ���� ���� �హ���� �׷� ���� �� ����� ��������
-- 0 < �л����� <= 1 ������ ���� ��

-- �μ��ڵ尡 '50'�� �������� �̸�, �޿�, �μ������� �޿��� ���� �����л� ��ȸ
SELECT EMP_NAME, SALARY, 
        ROUND(CUME_DIST() OVER (ORDER BY SALARY), 1) �����л�
FROM EMPLOYEE
WHERE DEPT_ID = '50';

-- NTILE() ------------------------------------------
/*
PARTITION �� BUCKET �̶� �Ҹ��� �׷캰�� ������, PARTITION ���� �� ���� BUCKET�� ��ġ�ϴ� �Լ�
���� ���, PARTITION �ȿ� 100���� ���� �ִٸ�  BUCKET �� 4���� �ϸ�,
1���� BUCKET �� 25���� ���� ����� ��
��Ȯ�ϰ� �й���� ���� ���� �ٻ�ġ�� ����� �� ���� �࿡ ���ؼ��� ���� BUCKET ���� �Ѱ��� ��е�
*/

-- ���� ��ü �޿��� 4������� �з�
SELECT EMP_NAME, SALARY, NTILE(4) OVER (ORDER BY SALARY) ���
FROM EMPLOYEE;


-- ROW_NUMBER() -------------------------------------------------
-- ROWNUM �� �������
-- �� PARTITION ���� ������ ORDER BY ���� ���� ������ ��, ������� ������ �ο���

-- ���, �̸�, �޿�, �Ի���, ���� ��ȸ
-- ��, ������ �޿� ���� ������, ���� �޿��� �Ի����� ���� ������� ���� �ο���
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE, 
        ROW_NUMBER() OVER (ORDER BY SALARY DESC, HIRE_DATE ASC) ����
FROM EMPLOYEE;

-- �����Լ� ----------------------------------------
-- SUM, AVG, COUNT, MAX, MIN

-- ���� ���̺��� �μ��ڵ尡 '60'�� ��������
-- ���, �޿�, �ش� �μ��׷�(�������� ��)�� ����� �������������ϰ�
-- �޿��� �հ踦 �׷� ���� ù����� ����������� ���ؼ� "win1" �� ��Ī ó����
-- �޿��� �հ踦 �׷� ���� ù����� ���� ����� ���ؼ� "win2 �� ��Ī ó����
-- �޿��� �հ踦 �׷� ���� ���� �࿡�� ����������� ���ؼ� "win3" �� ��Ī ó����
SELECT EMP_ID, SALARY, 
        SUM(SALARY) OVER (PARTITION BY DEPT_ID
                            ORDER BY EMP_ID ASC
                            ROWS BETWEEN UNBOUNDED PRECEDING 
                            AND UNBOUNDED FOLLOWING) "win1", 
        SUM(SALARY) OVER (PARTITION BY DEPT_ID
                            ORDER BY EMP_ID ASC
                            ROWS BETWEEN UNBOUNDED PRECEDING 
                            AND CURRENT ROW) "win2", 
        SUM(SALARY) OVER (PARTITION BY DEPT_ID
                            ORDER BY EMP_ID ASC
                            ROWS BETWEEN CURRENT ROW 
                            AND UNBOUNDED FOLLOWING) "win3"
FROM EMPLOYEE
WHERE DEPT_ID = '60';
-- ROWS : �κ� �׷��� �������� ũ�⸦ �������� ������ �������� ������ ����
-- UNBOUNDED PRECEDING : �������� ù��
-- UNBOUNDED FOLLOWING : �������� ��������
-- CURRENT ROW : ��갪�� �ִ� ���� ��


-- ���� ���̺��� �μ��ڵ尡 '60'�� ��������
-- ���, �޿�, �ش� �μ��׷�(�������� ��)�� ����� �������������ϰ�
-- �׷� ���� ���� ���� �������� ������� �������� �޿��հ踦 ���ؼ� "win1" �� ��Ī ó����
-- 1 PRECEDING : 1�� ������
-- 1 FOLLOWING : 1�� ������
-- �׷� ���� ���� ���� �������� ������� �������� �޿��հ踦 ���ؼ�  "win2 �� ��Ī ó����
-- �׷� ���� ���� ���� �������� ������� �������� �޿��հ踦 ���ؼ� "win3" �� ��Ī ó����
SELECT EMP_ID, SALARY, 
        SUM(SALARY) OVER (PARTITION BY DEPT_ID
                            ORDER BY EMP_ID ASC
                            ROWS BETWEEN 1 PRECEDING 
                            AND 1 FOLLOWING) "win1", 
        SUM(SALARY) OVER (PARTITION BY DEPT_ID
                            ORDER BY EMP_ID ASC
                            ROWS BETWEEN 1 PRECEDING 
                            AND CURRENT ROW) "win2", 
        SUM(SALARY) OVER (PARTITION BY DEPT_ID
                            ORDER BY EMP_ID ASC
                            ROWS BETWEEN CURRENT ROW 
                            AND 1 FOLLOWING) "win3"
FROM EMPLOYEE
WHERE DEPT_ID = '60';


-- RATIO_TO_REPORT() -----------------------------------
-- �ش� �������� �����ϴ� ������ �����ϴ� �Լ�

-- �������� �ѱ޿��� 2õ���� ������ų ��, ���� �޿������� �����ؼ� �� �������� �ްԵ� �޿� ��������?
SELECT EMP_NAME, SALARY,
        LPAD(TRUNC(RATIO_TO_REPORT(SALARY) OVER () * 100, 0), 5) || '%' "����",
        TO_CHAR(TRUNC(RATIO_TO_REPORT(SALARY) OVER () * 20000000, 0), 'L99,999,999') "�߰��� �ްԵ� �޿�"
FROM EMPLOYEE;


-- LAG() �Լ� -----------------------------------------------
-- LAG(��ȸ�� ����, ������ġ, ���� ������ġ)
-- �����ϴ� �÷��� ���� ���� �������� ���� ��(����)�� ���� ��ȸ��
SELECT EMP_NAME, DEPT_ID, SALARY,
        LAG(SALARY, 1, 0) OVER (ORDER BY SALARY ASC)  "������ ��ȸ",
        LAG(SALARY, 1, SALARY) OVER (ORDER BY SALARY ASC)  "��ȸ2",
        LAG(SALARY, 1, SALARY) OVER (PARTITION BY DEPT_ID
                                        ORDER BY SALARY ASC)  "��ȸ3"
FROM EMPLOYEE
--ORDER BY DEPT_ID NULLS LAST
;
-- 1 : 1ĭ ���� �ప, 0 : ���� ���� ������ 0 ó����
-- �÷��� : �������� ���ٸ� ���� �ప���� ó����

-- LEAD() �Լ� -----------------------------------------------
-- LEAD(��ȸ�� ����, �������, 0 �Ǵ� �÷���)
-- �����ϴ� �÷��� ���� ���� �������� ���� ��(�Ʒ���)�� ���� ��ȸ��
SELECT EMP_NAME, DEPT_ID, SALARY,
        LEAD(SALARY, 1, 0) OVER (ORDER BY SALARY ASC)  "������ ��ȸ",
        LEAD(SALARY, 1, SALARY) OVER (ORDER BY SALARY ASC)  "��ȸ2",
        LEAD(SALARY, 1, SALARY) OVER (PARTITION BY DEPT_ID
                                        ORDER BY SALARY ASC)  "��ȸ3"
FROM EMPLOYEE
ORDER BY DEPT_ID NULLS LAST
;







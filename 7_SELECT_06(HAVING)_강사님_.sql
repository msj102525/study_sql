-- 7_SELECT_06(HAVING).sql

-- SELECT ���� : HAVING �� ---------------------------------------------------------
-- �����ġ : GROUP BY �� ������ �ۼ���
-- �ۼ����� : HAVING �׷��Լ�(��꿡 ����� �÷���) �񱳿����� �񱳰�
-- �׷캰�� �׷��Լ� ������� ������ ������ �����ϴ� �׷��� ���
-- ��� �׷�� ������� SELECT ���� ǥ����

-- �μ��� �޿��հ� �� ���� ū �� ��ȸ
SELECT MAX(SUM(SALARY))  -- 1�� : 18100000
FROM EMPLOYEE
GROUP BY DEPT_ID;

-- �μ��ڵ嵵 �Բ� ��ȸ�ϰ� �Ѵٸ�
SELECT DEPT_ID, MAX(SUM(SALARY)) -- 7��, 1�� : 2���� �簢�� ���̺��� �ƴ� => ����
FROM EMPLOYEE
GROUP BY DEPT_ID;

SELECT DEPT_ID  -- 7��
FROM EMPLOYEE
GROUP BY DEPT_ID;

-- �μ��� �޿��հ� �� ���� ū���� ���� �μ��ڵ�� �޿��հ踦 ��ȸ
SELECT DEPT_ID, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_ID
--HAVING SUM(SALARY) = 18100000;
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))  -- 1�� : 18100000
                        FROM EMPLOYEE
                        GROUP BY DEPT_ID);


-- �м��Լ� (������ �Լ���� ��) -------------------------------------------
-- �Ϲ��Լ��� ��������� �ٸ�

-- RANK() �Լ�
-- ����(���) ��ȯ

-- 1. ��ü �÷����� ���� ���� �ű��
-- RANK() OVER (ORDER BY �����ű� �÷��� ���Ĺ��)

-- �޿��� ���� �޴� ������ ������ �ű�ٸ� (ū���� 1�� : ��������)
SELECT EMP_NAME, SALARY,
        RANK() OVER (ORDER BY SALARY DESC) ����
FROM EMPLOYEE
ORDER BY ����;

-- 2. �����ϴ� �÷����� ������ Ȯ���ϴ� �뵵�� ���
-- RANK(������ �˰��� �ϴ� ��) WITHIN GROUP (ORDER BY �����ű��÷��� ���Ĺ��)

-- �޿� 230���� ��ü �޿��� �� ����? (�޿� �������������� ���)
SELECT RANK(2300000) WITHIN GROUP (ORDER BY SALARY DESC)
FROM EMPLOYEE;

-- ROWID
-- ���̺� ������ �����(�� �߰���, INSERT��) �ڵ����� �ٿ���
-- DBMS �� �ڵ����� ����, ���� �� ��, ��ȸ�� �� �� ����
SELECT EMP_ID, ROWID
FROM EMPLOYEE;

-- ROWNUM
-- ROWID �� �ٸ�
-- ROWNUM �� SELECT �� ����� ����࿡ �ο��Ǵ� �������. (1���� ����)
-- �ζ��κ�(FROM ���� ���� ���������� �����)�� ����ϸ� ROWNUM �� Ȯ�� �Ǵ� ����� ���� ����
SELECT *
FROM (SELECT ROWNUM RNUM, EMP_ID, JOB_ID
        FROM EMPLOYEE
        WHERE JOB_ID = 'J5')
WHERE RNUM > 2;


-- ****************************************************************
-- ���� (JOIN)
-- ���� ���� ���̺���� �ϳ��� ���ļ� ū ���̺��� ����� ��
-- ������ ��� ���̺��� ���ϴ� �÷��� ������
-- ����Ŭ ���� ������ ANSI ǥ�� �������� �ۼ��� �� ����
-- ������ �⺻ EQUAL JOIN �� (���� ������ ������)
--  => EQUAL �� �ƴ� ���� ���� ���� ���ο��� ���ܵ�
-- �� ���̺��� FOREIGN KEY (�ܷ�Ű | �ܺ�Ű)�� ����� �÷������� ��ġ�ϴ� ����� ����Ǵ� ������

-- ����Ŭ ���� ���� : ����Ŭ������ �����
-- FROM ���� ������(��ĥ) ���̺���� ������
-- WHERE ���� ��ĥ �÷��� ���� ������ �����
-- ���� : �Ϲ� ���ǰ� ���� >> WHERE ���� ��������

SELECT *
FROM EMPLOYEE, DEPARTMENT
WHERE EMPLOYEE.DEPT_ID = DEPARTMENT.DEPT_ID;
-- ����� : 20��, EMPLOYEE�� DEPT_ID�� NULL �� ���� 2�� ���ܵ�
-- EQUAL INNER JOIN �̶�� ��

-- ���νÿ� ���̺� ��Ī(ALIAS)�� ���� �� ����
SELECT *
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID = D.DEPT_ID;

-- �����̸�, �μ��ڵ�, �μ��� ��ȸ
SELECT E.EMP_NAME, E.DEPT_ID, D.DEPT_NAME
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID = D.DEPT_ID;

SELECT EMP_NAME, E.DEPT_ID, DEPT_NAME
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID = D.DEPT_ID;

-- ANSI ǥ�� ����
-- ��� DBMS�� �������� ����ϴ� ǥ�ر�����
-- ���� ó���� ���� ������ ������ �ۼ��� => FROM ���� JOIN Ű���带 �߰��ؼ� �ۼ���
-- ���� ������ WHERE ������ �и���

SELECT *
FROM EMPLOYEE JOIN DEPARTMENT USING (DEPT_ID);

SELECT EMP_NAME, DEPT_ID, DEPT_NAME
FROM EMPLOYEE 
--JOIN DEPARTMENT USING (DEPT_ID);
INNER JOIN DEPARTMENT USING (DEPT_ID);  -- INNER �����ص� ��
-- ���ο� ���� �÷�(DEPT_ID)�� �Ѱ� ������, �� �տ� ù��°�� ǥ�õ� : ����Ŭ ���뱸���� �ٸ�����

-- ������ �⺻�� EQUAL INNER JOIN ��
-- �� ���̺��� �����ϴ� �÷��� ���� EQUAL �� ����� �����Ű�鼭 �����ϴ� ����
-- INNER JOIN �� EQUAL �� �ƴ� ���� ���ܵ�

-- ���νÿ� ���Ǵ� �� ���̺��� �÷����� ������ USING �����
-- ���� ���� ������ �÷��� �ٸ��� ON �����

-- USING ��� �� : 
SELECT EMP_NAME, DEPT_NAME
FROM EMPLOYEE JOIN DEPARTMENT USING (DEPT_ID)
WHERE JOB_ID = 'J6'
ORDER BY DEPT_NAME DESC;

-- ON ��� �� : 
SELECT *
FROM DEPARTMENT
JOIN LOCATION ON (LOC_ID = LOCATION_ID);

-- ���� ������ ����Ŭ ���뱸������ �ٲ۴ٸ�
SELECT *
FROM DEPARTMENT D, LOCATION L
WHERE D.LOC_ID = L.LOCATION_ID;

-- ���, �̸�, ���޸� ��ȸ : ��Ī
-- ����Ŭ ���� ����
SELECT EMP_ID ���, EMP_NAME �̸�, JOB_TITLE ���޸�
FROM EMPLOYEE E, JOB J
WHERE E.JOB_ID = J.JOB_ID;   -- 21��
-- �⺻ INNER JOIN �� => EMPLOYEE �� JOB_ID �� NULL �� �� ���ܵ�

-- ANSI ǥ�� ����
SELECT EMP_ID ���, EMP_NAME �̸�, JOB_TITLE ���޸�
FROM EMPLOYEE JOIN JOB USING (JOB_ID);  -- 21��

-- OUTER JOIN
-- �⺻�� EQUAL INNER JOIN  + ���� ��ġ���� �ʴ� �൵ ���Խ�Ű�� ����
-- OUTER JOIN �� EQUAL JOIN �� => ���� ���� �ִ� ���̺� ���� �߰���

-- EMPLOYEE ���̺��� �� ������ ������ ���� ����� ���Խ�Ű���� �Ѵٸ�
-- ����Ŭ ���뱸�� : ���� ���� ���̺� ���� �߰��ϴ� ����� => (+) ǥ����
SELECT *
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID = D.DEPT_ID(+);

-- ANSI ǥ�ر���
SELECT *
--FROM EMPLOYEE LEFT OUTER JOIN DEPARTMENT USING (DEPT_ID);
FROM EMPLOYEE LEFT JOIN DEPARTMENT USING (DEPT_ID);

-- DEPARTMENT ���̺��� ���� ��� ���� ���ο� ���Խ�Ű����
-- ����Ŭ ���뱸��
SELECT * 
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID(+) = D.DEPT_ID;

-- ANSI ǥ�ر���
SELECT *
--FROM EMPLOYEE RIGHT OUTER JOIN DEPARTMENT USING (DEPT_ID);
FROM EMPLOYEE RIGHT JOIN DEPARTMENT USING (DEPT_ID);

-- �� ���̺��� ��ġ���� �ʴ� ���� ��� �� ���ο� ���Խ�Ű����
-- FULL OUTER JOIN �̶�� ��

-- ����Ŭ ���뱸������ FULL OUTER JOIN �� �������� ����.
SELECT *
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID(+) = D.DEPT_ID(+);  -- ERROR

-- ANSI ǥ�ر���
SELECT *
--FROM EMPLOYEE FULL OUTER JOIN DEPARTMENT USING (DEPT_ID);  -- 23��
FROM EMPLOYEE FULL JOIN DEPARTMENT USING (DEPT_ID);  -- OUTER �����ص� ��

-- CROSS JOIN -------------------------------------------------------------------
-- �� ���̺��� ������ �÷��� ���� �� ���
-- ���̺�1 N�� * ���̺�2 M��

-- ANSI
SELECT *
FROM LOCATION CROSS JOIN COUNTRY;

-- ����Ŭ ���뱸��
SELECT *
FROM LOCATION, COUNTRY;

-- NATURAL JOIN ------------------------------------------------------------
-- ���̺��� ���� PRIMARY KEY �÷��� �̿��ؼ� ������ ��
SELECT *
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT;  --  PRIMARY KEY �÷��� DEPT_ID ����
-- JOIN DEPARTMENT USING (DEPT_ID); �� ����� ����

-- NON EQUI JOIN -----------------------------------------
-- �����ϴ� �÷��� ���� ��ġ�ϴ� ��찡 �ƴ� ���� ������ �ش��ϴ� ����� �����ϴ� ����� ������
-- JOIN ON �����

SELECT *
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY BETWEEN LOWEST AND HIGHEST);

SELECT EMP_NAME, SALARY, SLEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY BETWEEN LOWEST AND HIGHEST);

-- SELF JOIN ------------------------------------------
-- ���� ���̺��� �����ϴ� ���
-- ���� ���̺� �ȿ� �ٸ� �÷��� �����ϴ� �ܷ�Ű(FOREIGN KEY)�� ���� �� �����
-- EMP_ID : ������ ��� ---> MGR_ID : ������ ��� - EMP_ID �÷��� ������ ���(����)�ϴ� �÷�
-- ������ : ���� �߿��� �������� ������ �����Ѵ��� �ǹ���

-- �����ڰ� ������ ������ ��ܰ� �������� ���� ��� ��ȸ
-- ANSI ǥ�ر��� : SELF JOIN �� ���̺� ��Ī ����ؾ� ��. ON �����
SELECT *
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MGR_ID = M.EMP_ID);  -- 15��

SELECT E.EMP_NAME ����, M.EMP_NAME ������
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MGR_ID = M.EMP_ID); 

-- �������� ���� ���
SELECT DISTINCT M.EMP_NAME ������  -- 6��
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MGR_ID = M.EMP_ID); 

-- ����Ŭ ���뱸��
SELECT *
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MGR_ID = M.EMP_ID; -- 15��

SELECT E.EMP_NAME ����, M.EMP_NAME ������
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MGR_ID = M.EMP_ID;

-- �������� ���� ���
SELECT DISTINCT M.EMP_NAME ������  -- 6��
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MGR_ID = M.EMP_ID;


-- N���� ���̺� ����
-- ���� ������ �߿���
-- ù��° ���̺�� �ι�° ���̺��� ���εǰ� ����, �� ����� ����° ���̺��� ���ε�

SELECT EMP_NAME, JOB_TITLE, DEPT_NAME
FROM EMPLOYEE 
LEFT JOIN JOB USING (JOB_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID);

SELECT *
FROM EMPLOYEE
LEFT JOIN LOCATION ON (LOCATION_ID = LOC_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID);  -- ERROR : ���� ���� Ʋ��

SELECT *
FROM EMPLOYEE
LEFT JOIN DEPARTMENT USING (DEPT_ID)
LEFT JOIN LOCATION ON (LOCATION_ID = LOC_ID);  -- �ذ�

-- �����̸�, ���޸�, �μ���, ������, ������ ��ȸ
-- ���� ��ü ��ȸ��
-- ANSI ǥ�ر���
SELECT EMP_NAME �����̸�, JOB_TITLE ���޸�, DEPT_NAME �μ���, LOC_DESCRIBE ������, 
        COUNTRY_NAME ������
FROM EMPLOYEE
LEFT JOIN JOB USING (JOB_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID)
LEFT JOIN LOCATION ON (LOC_ID = LOCATION_ID)
LEFT JOIN COUNTRY USING (COUNTRY_ID);

-- ����Ŭ ���뱸��
SELECT EMP_NAME �����̸�, JOB_TITLE ���޸�, DEPT_NAME �μ���, LOC_DESCRIBE ������, 
        COUNTRY_NAME ������
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L, COUNTRY C
WHERE E.JOB_ID = J.JOB_ID(+)
AND E.DEPT_ID = D.DEPT_ID(+)
AND D.LOC_ID = L.LOCATION_ID(+)
AND L.COUNTRY_ID = C.COUNTRY_ID(+);

-- ********************************************************************
--JOIN ��������
--
--1. 2020�� 12�� 25���� ���� �������� ��ȸ�Ͻÿ�.
SELECT TO_CHAR(TO_DATE('20201225', 'RRRRMMDD'), 'DAY') 
FROM DUAL;

--2. �ֹι�ȣ�� 60��� ���̸鼭 ������ �����̰�, ���� �达�� �������� 
--�����, �ֹι�ȣ, �μ���, ���޸��� ��ȸ�Ͻÿ�.
-- ANSI
SELECT EMP_NAME, EMP_NO, DEPT_NAME, JOB_TITLE
FROM EMPLOYEE
LEFT JOIN JOB USING (JOB_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID)
WHERE EMP_NO LIKE '6%'
AND SUBSTR(EMP_NO, 8, 1) IN ('2', '4')
AND EMP_NAME LIKE '��%';

-- ORACLE
SELECT EMP_NAME, EMP_NO, DEPT_NAME, JOB_TITLE
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_ID = J.JOB_ID(+)
AND E.DEPT_ID = D.DEPT_ID(+)
AND EMP_NO LIKE '6%'
AND SUBSTR(EMP_NO, 8, 1) IN ('2', '4')
AND EMP_NAME LIKE '��%';

--3. ���� ���̰� ���� ������ ���, �����, ����, �μ���, ���޸��� ��ȸ�Ͻÿ�.

--������ �ּҰ� ��ȸ
SELECT MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) ���� 
FROM EMPLOYEE;  

-- ��ȸ�� ������ �ּҰ��� �̿��� ������ ���� ��ȸ��
-- outer join �ʿ���.
SELECT EMP_ID, EMP_NAME, 
       MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) ���� ,
       DEPT_NAME, JOB_TITLE
FROM EMPLOYEE
LEFT JOIN JOB USING (JOB_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID)
GROUP BY EMP_ID, EMP_NAME, DEPT_NAME, JOB_TITLE
HAVING MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) = 34;

- ���������� ����� ��� *****************************
-- ANSI
SELECT EMP_ID, EMP_NAME, 
       MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(
       SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) ���� ,
       DEPT_NAME, JOB_TITLE
FROM EMPLOYEE
LEFT JOIN JOB USING (JOB_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID)
GROUP BY EMP_ID, EMP_NAME, DEPT_NAME, JOB_TITLE
HAVING MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(
        SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) = (SELECT MIN(TRUNC((MONTHS_BETWEEN
                                                  (SYSDATE, 
                                                  TO_DATE(SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) ���� 
                                                  FROM EMPLOYEE);

-- ORACLE
SELECT EMP_ID, EMP_NAME, 
       MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(
       SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) ���� ,
       DEPT_NAME, JOB_TITLE
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_ID = J.JOB_ID(+)
AND E.DEPT_ID = D.DEPT_ID(+)
GROUP BY EMP_ID, EMP_NAME, DEPT_NAME, JOB_TITLE
HAVING MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(
        SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) = (SELECT MIN(TRUNC((MONTHS_BETWEEN
                                                  (SYSDATE, 
                                                  TO_DATE(SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) ���� 
                                                  FROM EMPLOYEE);



-- 4. �̸��� '��'�ڰ� ���� �������� 
-- ���, �����, �μ����� ��ȸ�Ͻÿ�.
-- ANSI
SELECT EMP_ID, EMP_NAME, DEPT_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT USING (DEPT_ID)
WHERE EMP_NAME LIKE '%��%';

-- ORACLE
SELECT EMP_ID, EMP_NAME, DEPT_NAME
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID = D.DEPT_ID(+)
AND EMP_NAME LIKE '%��%';

-- 5. �ؿܿ������� �ٹ��ϴ� 
-- �����, ���޸�, �μ��ڵ�, �μ����� ��ȸ�Ͻÿ�.
-- ANSI
SELECT EMP_NAME, JOB_TITLE, DEPT_ID, DEPT_NAME
FROM EMPLOYEE
LEFT JOIN JOB USING (JOB_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID)
WHERE DEPT_NAME LIKE '�ؿܿ���%'
ORDER BY 4;

-- ORACLE
SELECT EMP_NAME, JOB_TITLE, E.DEPT_ID, DEPT_NAME
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_ID = J.JOB_ID
AND E.DEPT_ID = D.DEPT_ID
AND DEPT_NAME LIKE '�ؿܿ���%'
ORDER BY 4;

-- 6. ���ʽ�����Ʈ�� �޴� �������� 
-- �����, ���ʽ�����Ʈ, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
-- ANSI
SELECT EMP_NAME, BONUS_PCT, DEPT_NAME, LOC_DESCRIBE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT USING (DEPT_ID)
LEFT JOIN LOCATION ON (LOCATION_ID = LOC_ID)
WHERE BONUS_PCT IS NOT NULL
AND BONUS_PCT <> 0.0;

-- ORACLE
SELECT EMP_NAME, BONUS_PCT, DEPT_NAME, LOC_DESCRIBE
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_ID = D.DEPT_ID
AND D.LOC_ID = L.LOCATION_ID
AND BONUS_PCT IS NOT NULL
AND BONUS_PCT <> 0.0;

-- 7. �μ��ڵ尡 20�� �������� 
-- �����, ���޸�, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
-- ANSI
SELECT EMP_NAME, JOB_TITLE, DEPT_NAME, LOC_DESCRIBE
FROM EMPLOYEE
JOIN JOB USING (JOB_ID)
JOIN DEPARTMENT USING (DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOC_ID)
WHERE DEPT_ID = '20';

-- ORACLE
SELECT EMP_NAME, JOB_TITLE, DEPT_NAME, LOC_DESCRIBE
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE E.JOB_ID = J.JOB_ID
AND E.DEPT_ID = D.DEPT_ID
AND D.LOC_ID = L.LOCATION_ID
AND E.DEPT_ID = '20';

-- 8. ���޺� ������ �ּұ޿�(MIN_SAL)���� ���� �޴� ��������
-- �����, ���޸�, �޿�, ������ ��ȸ�Ͻÿ�.
-- ������ ���ʽ�����Ʈ�� �����Ͻÿ�.
-- ANSI
SELECT EMP_NAME, JOB_TITLE, SALARY, 
       (SALARY + NVL(BONUS_PCT, 0) * SALARY) * 12 ����
FROM EMPLOYEE
JOIN JOB USING (JOB_ID)       
WHERE (SALARY + NVL(BONUS_PCT, 0) * SALARY) * 12 
      > MIN_SAL;

-- ORACLE
SELECT EMP_NAME, JOB_TITLE, SALARY, 
       (SALARY + NVL(BONUS_PCT, 0) * SALARY) * 12 ����
FROM EMPLOYEE E, JOB J
WHERE E.JOB_ID = J.JOB_ID     
AND (SALARY + NVL(BONUS_PCT, 0) * SALARY) * 12 > MIN_SAL;

-- 9 . �ѱ�(KO)�� �Ϻ�(JP)�� �ٹ��ϴ� �������� 
-- �����(emp_name), �μ���(dept_name), ������(loc_describe),
--  ������(country_name)�� ��ȸ�Ͻÿ�.
-- ANSI
SELECT EMP_NAME �����, DEPT_NAME �μ���,
       LOC_DESCRIBE ������, COUNTRY_NAME ������
FROM EMPLOYEE
JOIN DEPARTMENT USING (DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOC_ID)
JOIN COUNTRY USING (COUNTRY_ID)       
WHERE COUNTRY_ID IN ('KO', 'JP');

-- ORACLE
SELECT EMP_NAME �����, DEPT_NAME �μ���,
       LOC_DESCRIBE ������, COUNTRY_NAME ������
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, COUNTRY C
WHERE E.DEPT_ID = D.DEPT_ID
AND D.LOC_ID = L.LOCATION_ID
AND L.COUNTRY_ID = C.COUNTRY_ID      
AND L.COUNTRY_ID IN ('KO', 'JP');

-- 10. ���� �μ��� �ٹ��ϴ� �������� 
-- �����, �μ��ڵ�, �����̸�, �μ��ڵ带 ��ȸ�Ͻÿ�.
-- self join ���
-- ORACLE
SELECT E.EMP_NAME �����, E.DEPT_ID �μ��ڵ�, 
       C.EMP_NAME �����̸�, C.DEPT_ID �μ��ڵ�
FROM EMPLOYEE E, EMPLOYEE C
WHERE E.EMP_NAME <> C.EMP_NAME
AND E.DEPT_ID = C.DEPT_ID
ORDER BY E.EMP_NAME;

-- ANSI
SELECT E.EMP_NAME �����, E.DEPT_ID �μ��ڵ�, 
       C.EMP_NAME �����̸�, C.DEPT_ID �μ��ڵ�
FROM EMPLOYEE E
JOIN EMPLOYEE C ON (E.DEPT_ID = C.DEPT_ID)
WHERE E.EMP_NAME <> C.EMP_NAME
ORDER BY E.EMP_NAME;



-- 11. ���ʽ�����Ʈ�� ���� ������ �߿��� 
-- �����ڵ尡 J4�� J7�� �������� �����, ���޸�, �޿��� ��ȸ�Ͻÿ�.

-- ��, join�� IN ���
-- ANSI
SELECT EMP_NAME, JOB_TITLE, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_ID)
WHERE JOB_ID IN ('J4', 'J7') 
AND BONUS_PCT IS NULL OR BONUS_PCT = 0.0;

-- ORACLE
SELECT EMP_NAME, JOB_TITLE, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_ID = J.JOB_ID
AND E.JOB_ID IN ('J4', 'J7') 
AND BONUS_PCT IS NULL OR BONUS_PCT = 0.0;

-- ��, join�� set operator ���
SELECT EMP_NAME, JOB_TITLE, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_ID)
WHERE JOB_ID = 'J4' AND BONUS_PCT IS NULL
UNION  -- �� SELECT �� ����� ��Ĩ
SELECT EMP_NAME, JOB_TITLE, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_ID)
WHERE JOB_ID = 'J7' AND BONUS_PCT IS NULL;



-- 12. �ҼӺμ��� 50 �Ǵ� 90�� ������ 
-- ��ȥ�� ������ ��ȥ�� ������ ���� ��ȸ�Ͻÿ�.
SELECT DECODE(MARRIAGE, 'Y', '��ȥ', 'N', '��ȥ') ��ȥ����, 
       COUNT(*) ������
FROM EMPLOYEE
WHERE DEPT_ID IN ('50', '90')
GROUP BY DECODE(MARRIAGE, 'Y', '��ȥ', 'N', '��ȥ')
ORDER BY 1;









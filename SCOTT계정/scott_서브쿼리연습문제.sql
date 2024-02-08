-- SCOTT���� �������� ��������


-- 1. ���� ���̺��� BLAKE ���� �޿��� ���� �������� ���, �̸�, �޿��� ��ȸ�Ͻÿ�.
SELECT
    empno,
    ename,
    sal
FROM
    emp
WHERE
    sal > (
        SELECT
            sal
        FROM
            emp
        WHERE
            ename LIKE 'BLAKE'
    );

-- 2. ���� ���̺��� MILLER ���� �ʰ� �Ի��� ������ ���, �̸�, �Ի����� ��ȸ�Ͻÿ�
SELECT
    empno,
    ename,
    hiredate
FROM
    emp
WHERE
    hiredate > (
        SELECT
            hiredate
        FROM
            emp
        WHERE
            ename = 'MILLER'
    );



-- 3. ���� ���̺��� ���� ��ü�� ��ձ޿����� �޿��� ���� �������� 
-- ���, �̸�, �޿��� ��ȸ�Ͻÿ�.


SELECT
    empno,
    ename,
    sal
FROM
    emp
WHERE
    sal > (
        SELECT
            round(AVG(sal))
        FROM
            emp
    );



-- 4. ���� ���̺��� �μ��� �ִ� �޿��� �޴� �������� 
-- ���, �̸�, �μ��ڵ�, �޿��� ��ȸ�Ͻÿ�.
SELECT
    e.empno,
    e.ename,
    e.deptno,
    e.sal
FROM
         emp e
    JOIN dept d ON e.deptno = d.deptno
GROUP BY
    e.empno,
    e.ename,
    e.deptno,
    e.sal
HAVING
    e.sal IN (
        SELECT
            MAX(sal)
        FROM
            emp
        GROUP BY
            deptno
    );

-- 5. Salgrade�� 2����� �������� ��ձ޿����� �޿��� ���� �޴� 
-- ������ ��� ������ ��ȸ�Ͻÿ�.

-- ����Ŭ : 
SELECT
    *
FROM
    emp e
WHERE
    e.sal < (
        SELECT
            AVG(sal)
        FROM
            emp,
            salgrade
        WHERE
            sal BETWEEN losal AND hisal
            AND grade = 2
    );
-- ANSI : 
SELECT
    *
FROM
    emp e
WHERE
    e.sal < (
        SELECT
            AVG(sal)
        FROM
                 emp
            JOIN salgrade ON ( sal BETWEEN losal AND hisal )
        WHERE
            grade = 2
    );

-- 6. �Ҽӵ� �μ��� ��ձ޿����� �޿��� ���� �޴� ������ ���� ��ȸ
-- �μ���ȣ, �����̸�, �޿� ���
-- ��ȣ���� �������� ����� ��
SELECT
    e.deptno,
    e.ename,
    e.sal
FROM
    emp e
WHERE
    e.sal > (
        SELECT
            round(AVG(sal))
        FROM
            emp e2
        WHERE
            e.deptno = e2.deptno
        GROUP BY
            deptno
    );

        


-- 7. 30�� �μ��� ���� �ֱ� �Ի��Ϻ��� ���� �Ի��� 30�� �μ����� �ƴ� �������� ���� ��ȸ
-- �̸�, �Ի���, �μ���ȣ, �޿�

-- ������ �������� ���
SELECT
    e.ename,
    e.hiredate,
    e.deptno,
    e.sal
FROM
    emp e
WHERE
    e.hiredate > (
        SELECT
            MAX(hiredate)
        FROM
            emp
        WHERE
            deptno = 30
    );
      

-- ������ �������� ���
SELECT
    e.ename,
    e.hiredate,
    e.deptno,
    e.sal
FROM
    emp e
WHERE
    e.hiredate > ANY (
        SELECT
            hiredate
        FROM
            emp
        WHERE
            deptno = 30
    );

-- 8 job�� analyst�� ��� ������� �޿��� ���� �޴� Ÿ ������ ����� ��� 
-- (��, ������ clerk�� ����� ����)

-- ������ �������� ���
SELECT
    *
FROM
    emp
WHERE
        job != 'CLERK'
    AND sal > ALL (
        SELECT
            sal
        FROM
            emp
        WHERE
            job = 'ANALYST'
    );
 
 

-- ������ �������� ���

SELECT
    *
FROM
    emp
WHERE
        job != 'CLERK'
    AND sal > ALL (
        SELECT
            MAX(sal)
        FROM
            emp
        WHERE
            job = 'ANALYST'
    );
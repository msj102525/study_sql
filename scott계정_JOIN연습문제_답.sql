-- SCOTT ���� : JOIN ��������
-- ����Ŭ ���뱸���� ANSI ǥ�ر��� �� ������ �ۼ��Ͻÿ�.

-- 1. �μ� ���̺�� ���� ���̺��� ���, �����, �μ��ڵ�, �μ����� ��ȸ�Ͻÿ�. 
-- ����� ���� �������� ���� ó����

-- ����Ŭ : 
SELECT EMPNO, ENAME, EMP.DEPTNO, DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
ORDER BY ENAME;

-- ANSI : 
SELECT EMPNO, ENAME, DEPTNO, DNAME
FROM EMP
JOIN DEPT USING (DEPTNO)
ORDER BY ENAME;

-- 2. �μ� ���̺�� ���� ���̺��� �޿��� 2000 �̻��� ����� ���Ͽ�
-- ���, �����, �޿�, �μ����� ��ȸ�Ͻÿ�. 
-- ��, �޿��������� �������� ���� ó����

-- ����Ŭ : 
SELECT EMPNO, ENAME, SAL, DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND SAL > 2000
ORDER BY SAL DESC;

-- ANSI : 
SELECT EMPNO, ENAME, SAL, DNAME
FROM EMP
JOIN DEPT USING (DEPTNO)
WHERE SAL > 2000
ORDER BY SAL DESC;


-- 3. �μ� ���̺�� ���� ���̺��� ������ Manager�̰� �޿��� 2500 �̻��� ������
-- ���, �����, ������, �޿�, �μ����� ��ȸ�Ͻÿ�. 
-- ��, ����� �������� �������� ���� ó����. 

-- ����Ŭ : 
SELECT EMPNO, ENAME, JOB, SAL, DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND JOB = 'MANAGER'
AND SAL >= 2500
ORDER BY EMPNO;

-- ANSI : 
SELECT EMPNO, ENAME, JOB, SAL, DNAME
FROM EMP
JOIN DEPT USING (DEPTNO)
WHERE JOB = 'MANAGER'
AND SAL >= 2500
ORDER BY EMPNO;


-- 4. ���� ���̺�� �޿� ��� ���̺��� 
-- �޿��� ���Ѱ��� ���Ѱ� ������ ���Եǰ� ����� 4�� ��������
-- ���, �����, �޿�, ����� ��ȸ�Ͻÿ�. 
-- ��, �޿��� �������� �������� ���� ó����

-- ����Ŭ : 
SELECT EMPNO, ENAME, SAL, GRADE
FROM EMP, SALGRADE
WHERE SAL BETWEEN LOSAL AND HISAL
AND GRADE = 4
ORDER BY SAL DESC;

-- ANSI : 
SELECT EMPNO, ENAME, SAL, GRADE
FROM EMP
JOIN SALGRADE ON (SAL BETWEEN LOSAL AND HISAL)
WHERE GRADE = 4
ORDER BY SAL DESC;

-- 5. �μ� ���̺�, ���� ���̺�, �޿���� ���̺��� 
-- �޿��� ���Ѱ��� ���Ѱ� ������ ���ԵǴ� ����� �����Ͽ�
-- ���, �����, �μ���, �޿�, ����� ��ȸ�Ͻÿ�. 
-- ��, ����� �������� �������� ���� ó����

-- ����Ŭ : 
SELECT EMPNO, ENAME, DNAME, SAL, GRADE
FROM EMP E, DEPT D, SALGRADE
WHERE SAL BETWEEN LOSAL AND HISAL
AND E.DEPTNO = D.DEPTNO
ORDER BY GRADE DESC;

-- ANSI : 
SELECT EMPNO, ENAME, DNAME, SAL, GRADE
FROM EMP
JOIN DEPT USING (DEPTNO)
JOIN SALGRADE ON (SAL BETWEEN LOSAL AND HISAL)
ORDER BY GRADE DESC;

 
-- 6. ���� ���̺��� ������ �ش� ����� �����ڸ��� ��ȸ�Ͻÿ�

-- ����Ŭ : 
SELECT E.ENAME ����, M.ENAME ������
FROM EMP E, EMP M
WHERE E.EMPNO = M.MGR;

-- ANSI : 
SELECT E.ENAME ����, M.ENAME ������
FROM EMP E
JOIN EMP M ON (E.EMPNO = M.MGR);


-- 7. ���� ���̺��� 
-- �����, �ش� ����� �����ڸ�, �ش� ����� �������� �����ڸ��� ��ȸ�Ͻÿ�

-- ����Ŭ : 
SELECT E.ENAME �����, M.ENAME ������, C.ENAME ����������
FROM EMP E, EMP M, EMP C
WHERE E.MGR = M.EMPNO
AND M.MGR = C.EMPNO;

-- ANSI : 
SELECT E.ENAME �����, M.ENAME ������, C.ENAME ����������
FROM EMP E
JOIN EMP M ON (E.MGR = M.EMPNO)
JOIN EMP C ON (M.MGR = C.EMPNO);


-- 8. 7�� ������� �����ڿ� ���� �����ڰ� ���� ��� ������ ������ ��µǵ��� �����Ͻÿ�.

-- ����Ŭ : 
SELECT E.ENAME �����, M.ENAME ������, C.ENAME ����������
FROM EMP E, EMP M, EMP C
WHERE E.MGR = M.EMPNO(+)
AND M.MGR = C.EMPNO(+);

-- ANSI : 
SELECT E.ENAME �����, M.ENAME ������, C.ENAME ����������
FROM EMP E
LEFT JOIN EMP M ON (E.MGR = M.EMPNO)
LEFT JOIN EMP C ON (M.MGR = C.EMPNO);


-- 9. 20�� �μ��� �̸��� �� �μ��� �ٹ��ϴ� ������ �̸��� ��ȸ�Ͻÿ�.

-- ����Ŭ : 
SELECT DNAME, ENAME
FROM DEPT D, EMP E
WHERE D.DEPTNO = E.DEPTNO
AND E.DEPTNO = 20;

-- ANSI : 
SELECT DNAME, ENAME
FROM DEPT 
JOIN EMP USING (DEPTNO)
WHERE DEPTNO = 20;


-- 10. Ŀ�̼��� �޴� ������ �̸�, Ŀ�̼�, �μ��̸��� ��ȸ�Ͻÿ�.

-- ����Ŭ : 
SELECT ENAME, COMM, DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND COMM IS NOT NULL 
AND COMM != 0;

-- ANSI : 
SELECT ENAME, COMM, DNAME
FROM EMP 
JOIN DEPT USING (DEPTNO)
WHERE COMM IS NOT NULL 
AND COMM != 0;


-- 11. �̸��� ��A�� �� ���� �������� �̸��� �μ����� ��ȸ�Ͻÿ�.

-- ����Ŭ : 
SELECT ENAME, DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND ENAME LIKE '%A%';

-- ANSI : 
SELECT ENAME, DNAME
FROM EMP 
JOIN DEPT USING (DEPTNO)
WHERE ENAME LIKE '%A%';


-- 12. DALLAS�� �ٹ��ϴ� ���� �� �޿��� 1500 �̻��� 
-- ����� �̸�, �޿�, �Ի���, ���ʽ�(comm)�� ��ȸ�Ͻÿ�.
-- �޿� ���� �������� ���� ó����

-- ����Ŭ : 
SELECT ENAME, SAL, HIREDATE, COMM
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND LOC = 'DALLAS'
AND SAL >= 1500
ORDER BY SAL DESC;

-- ANSI : 
SELECT ENAME, SAL, HIREDATE, COMM
FROM EMP 
JOIN DEPT USING (DEPTNO)
WHERE LOC = 'DALLAS'
AND SAL >= 1500
ORDER BY SAL DESC;


-- 13. �ڽ��� ������ ���� ����(sal)�� ���� �޴� 
-- ������ �̸��� ������ ��ȸ�Ͻÿ�.

-- ����Ŭ : 
SELECT E.ENAME, E.SAL
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO
AND E.SAL > M.SAL;

-- ANSI : 
SELECT E.ENAME, E.SAL
FROM EMP E
JOIN EMP M ON (E.MGR = M.EMPNO)
WHERE E.SAL > M.SAL;


-- 14. ���� �� ����ð� �������� �ٹ����� ���� 
-- 30���� �ʰ��� ������ �̸�, �޿�, �Ի���, �μ����� ��ȸ�Ͻÿ�

-- ����Ŭ : 
SELECT ENAME, SAL, HIREDATE, DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND MONTHS_BETWEEN(SYSDATE, HIREDATE) > 360;

-- ANSI : 
SELECT ENAME, SAL, HIREDATE, DNAME
FROM EMP 
JOIN DEPT USING (DEPTNO)
WHERE MONTHS_BETWEEN(SYSDATE, HIREDATE) > 360;


-- 15. �� �μ����� 1982�� ������ �Ի��� �������� �ο����� ��ȸ�Ͻÿ�.
-- �μ���ȣ �������� �������� ���� ó����

-- ����Ŭ : 
SELECT E.DEPTNO �μ���ȣ, COUNT(ENAME) ������
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND EXTRACT(YEAR FROM HIREDATE) <= 1982
GROUP BY E.DEPTNO
ORDER BY 1;

-- ANSI : 
SELECT DEPTNO �μ���ȣ, COUNT(ENAME) ������
FROM EMP 
JOIN DEPT USING (DEPTNO)
WHERE EXTRACT(YEAR FROM HIREDATE) <= 1982
GROUP BY DEPTNO
ORDER BY DEPTNO;








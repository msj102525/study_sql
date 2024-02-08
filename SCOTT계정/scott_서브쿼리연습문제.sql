-- SCOTT계정 서브쿼리 연습문제


-- 1. 직원 테이블에서 BLAKE 보다 급여가 많은 직원들의 사번, 이름, 급여를 조회하시오.
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

-- 2. 직원 테이블에서 MILLER 보다 늦게 입사한 직원의 사번, 이름, 입사일을 조회하시오
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



-- 3. 직원 테이블에서 직원 전체의 평균급여보다 급여가 많은 직원들의 
-- 사번, 이름, 급여를 조회하시오.


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



-- 4. 직원 테이블에서 부서별 최대 급여를 받는 직원들의 
-- 사번, 이름, 부서코드, 급여를 조회하시오.
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

-- 5. Salgrade가 2등급인 직원들의 평균급여보다 급여를 적게 받는 
-- 직원의 모든 정보를 조회하시오.

-- 오라클 : 
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

-- 6. 소속된 부서의 평균급여보다 급여를 많이 받는 직원의 정보 조회
-- 부서번호, 직원이름, 급여 출력
-- 상호연관 서브쿼리 사용할 것
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

        


-- 7. 30번 부서의 가장 최근 입사일보다 먼저 입사한 30번 부서원이 아닌 직원들의 정보 조회
-- 이름, 입사일, 부서번호, 급여

-- 단일행 서브쿼리 사용
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
      

-- 다중행 서브쿼리 사용
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

-- 8 job이 analyst인 모든 사원보다 급여를 많이 받는 타 업무의 사원을 출력 
-- (단, 업무가 clerk인 사원은 제외)

-- 다중행 서브쿼리 사용
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
 
 

-- 단일행 서브쿼리 사용

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
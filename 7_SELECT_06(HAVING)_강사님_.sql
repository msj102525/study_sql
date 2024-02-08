-- 7_SELECT_06(HAVING).sql

-- SELECT 구문 : HAVING 절 ---------------------------------------------------------
-- 사용위치 : GROUP BY 절 다음에 작성함
-- 작성형식 : HAVING 그룹함수(계산에 사용할 컬럼명) 비교연산자 비교값
-- 그룹별로 그룹함수 계산결과를 가지고 조건을 만족하는 그룹을 골라냄
-- 골라낸 그룹과 결과값을 SELECT 절에 표시함

-- 부서별 급여합계 중 가장 큰 값 조회
SELECT MAX(SUM(SALARY))  -- 1행 : 18100000
FROM EMPLOYEE
GROUP BY DEPT_ID;

-- 부서코드도 함께 조회하게 한다면
SELECT DEPT_ID, MAX(SUM(SALARY)) -- 7행, 1행 : 2차원 사각형 테이블이 아님 => 에러
FROM EMPLOYEE
GROUP BY DEPT_ID;

SELECT DEPT_ID  -- 7행
FROM EMPLOYEE
GROUP BY DEPT_ID;

-- 부서별 급여합계 중 가장 큰값에 대한 부서코드와 급여합계를 조회
SELECT DEPT_ID, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_ID
--HAVING SUM(SALARY) = 18100000;
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))  -- 1행 : 18100000
                        FROM EMPLOYEE
                        GROUP BY DEPT_ID);


-- 분석함수 (윈도우 함수라고도 함) -------------------------------------------
-- 일반함수와 사용형식이 다름

-- RANK() 함수
-- 순위(등수) 반환

-- 1. 전체 컬럼값에 대한 순위 매기기
-- RANK() OVER (ORDER BY 순위매길 컬럼명 정렬방식)

-- 급여를 많이 받는 순으로 순위를 매긴다명 (큰값이 1등 : 내림차순)
SELECT EMP_NAME, SALARY,
        RANK() OVER (ORDER BY SALARY DESC) 순위
FROM EMPLOYEE
ORDER BY 순위;

-- 2. 지정하는 컬럼값의 순위를 확인하는 용도로 사용
-- RANK(순위를 알고자 하는 값) WITHIN GROUP (ORDER BY 순위매길컬럼명 정렬방식)

-- 급여 230만이 전체 급여중 몇 순위? (급여 내림차순정렬의 경우)
SELECT RANK(2300000) WITHIN GROUP (ORDER BY SALARY DESC)
FROM EMPLOYEE;

-- ROWID
-- 테이블에 데이터 저장시(행 추가시, INSERT문) 자동으로 붙여짐
-- DBMS 가 자동으로 붙임, 수정 못 함, 조회만 할 수 있음
SELECT EMP_ID, ROWID
FROM EMPLOYEE;

-- ROWNUM
-- ROWID 와 다름
-- ROWNUM 은 SELECT 문 실행시 결과행에 부여되는 행순번임. (1부터 시작)
-- 인라인뷰(FROM 절에 사용된 서브쿼리의 결과뷰)을 사용하면 ROWNUM 을 확인 또는 사용할 수도 있음
SELECT *
FROM (SELECT ROWNUM RNUM, EMP_ID, JOB_ID
        FROM EMPLOYEE
        WHERE JOB_ID = 'J5')
WHERE RNUM > 2;


-- ****************************************************************
-- 조인 (JOIN)
-- 여러 개의 테이블들을 하나로 합쳐서 큰 테이블을 만드는 것
-- 조인한 결과 테이블에서 원하는 컬럼을 선택함
-- 오라클 전용 구문과 ANSI 표준 구문으로 작성할 수 있음
-- 조인은 기본 EQUAL JOIN 임 (같은 값끼리 연결함)
--  => EQUAL 이 아닌 값에 대한 행은 조인에서 제외됨
-- 두 테이블의 FOREIGN KEY (외래키 | 외부키)로 연결된 컬럼값들이 일치하는 행들이 연결되는 구조임

-- 오라클 전용 구문 : 오라클에서만 사용함
-- FROM 절에 조인할(합칠) 테이블들을 나열함
-- WHERE 절에 합칠 컬럼에 대한 조건을 명시함
-- 단점 : 일반 조건과 섞임 >> WHERE 절이 복잡해짐

SELECT *
FROM EMPLOYEE, DEPARTMENT
WHERE EMPLOYEE.DEPT_ID = DEPARTMENT.DEPT_ID;
-- 결과행 : 20행, EMPLOYEE의 DEPT_ID가 NULL 인 직원 2명 제외됨
-- EQUAL INNER JOIN 이라고 함

-- 조인시에 테이블에 별칭(ALIAS)을 붙일 수 있음
SELECT *
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID = D.DEPT_ID;

-- 직원이름, 부서코드, 부서명 조회
SELECT E.EMP_NAME, E.DEPT_ID, D.DEPT_NAME
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID = D.DEPT_ID;

SELECT EMP_NAME, E.DEPT_ID, DEPT_NAME
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID = D.DEPT_ID;

-- ANSI 표준 구문
-- 모든 DBMS가 공통으로 사용하는 표준구문임
-- 조인 처리를 위한 별도의 구문을 작성함 => FROM 절에 JOIN 키워드를 추가해서 작성함
-- 조인 조건을 WHERE 절에서 분리함

SELECT *
FROM EMPLOYEE JOIN DEPARTMENT USING (DEPT_ID);

SELECT EMP_NAME, DEPT_ID, DEPT_NAME
FROM EMPLOYEE 
--JOIN DEPARTMENT USING (DEPT_ID);
INNER JOIN DEPARTMENT USING (DEPT_ID);  -- INNER 생략해도 됨
-- 조인에 사용된 컬럼(DEPT_ID)이 한개 존재함, 맨 앞에 첫번째로 표시됨 : 오라클 전용구문과 다른점임

-- 조인은 기본이 EQUAL INNER JOIN 임
-- 두 테이블이 지정하는 컬럼의 값이 EQUAL 인 행들을 연결시키면서 조인하는 것임
-- INNER JOIN 은 EQUAL 이 아닌 행은 제외됨

-- 조인시에 사용되는 두 테이블의 컬럼명이 같으면 USING 사용함
-- 사용된 값은 같은데 컬럼명만 다르면 ON 사용함

-- USING 사용 예 : 
SELECT EMP_NAME, DEPT_NAME
FROM EMPLOYEE JOIN DEPARTMENT USING (DEPT_ID)
WHERE JOB_ID = 'J6'
ORDER BY DEPT_NAME DESC;

-- ON 사용 예 : 
SELECT *
FROM DEPARTMENT
JOIN LOCATION ON (LOC_ID = LOCATION_ID);

-- 위의 조인을 오라클 전용구문으로 바꾼다면
SELECT *
FROM DEPARTMENT D, LOCATION L
WHERE D.LOC_ID = L.LOCATION_ID;

-- 사번, 이름, 직급명 조회 : 별칭
-- 오라클 전용 구문
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_TITLE 직급명
FROM EMPLOYEE E, JOB J
WHERE E.JOB_ID = J.JOB_ID;   -- 21행
-- 기본 INNER JOIN 임 => EMPLOYEE 의 JOB_ID 가 NULL 인 행 제외됨

-- ANSI 표준 구문
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_TITLE 직급명
FROM EMPLOYEE JOIN JOB USING (JOB_ID);  -- 21행

-- OUTER JOIN
-- 기본은 EQUAL INNER JOIN  + 값이 일치하지 않는 행도 포함시키는 조인
-- OUTER JOIN 도 EQUAL JOIN 임 => 없는 값이 있는 테이블에 값을 추가함

-- EMPLOYEE 테이블의 전 직원의 정보를 조인 결과에 포함시키고자 한다면
-- 오라클 전용구문 : 값이 없는 테이블에 행을 추가하는 방식임 => (+) 표시함
SELECT *
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID = D.DEPT_ID(+);

-- ANSI 표준구문
SELECT *
--FROM EMPLOYEE LEFT OUTER JOIN DEPARTMENT USING (DEPT_ID);
FROM EMPLOYEE LEFT JOIN DEPARTMENT USING (DEPT_ID);

-- DEPARTMENT 테이블이 가진 모든 행을 조인에 포함시키려면
-- 오라클 전용구문
SELECT * 
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID(+) = D.DEPT_ID;

-- ANSI 표준구문
SELECT *
--FROM EMPLOYEE RIGHT OUTER JOIN DEPARTMENT USING (DEPT_ID);
FROM EMPLOYEE RIGHT JOIN DEPARTMENT USING (DEPT_ID);

-- 두 테이블의 일치하지 않는 행을 모두 다 조인에 포함시키려면
-- FULL OUTER JOIN 이라고 함

-- 오라클 전용구문에는 FULL OUTER JOIN 이 제공되지 않음.
SELECT *
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID(+) = D.DEPT_ID(+);  -- ERROR

-- ANSI 표준구문
SELECT *
--FROM EMPLOYEE FULL OUTER JOIN DEPARTMENT USING (DEPT_ID);  -- 23행
FROM EMPLOYEE FULL JOIN DEPARTMENT USING (DEPT_ID);  -- OUTER 생략해도 됨

-- CROSS JOIN -------------------------------------------------------------------
-- 두 테이블을 연결할 컬럼이 없을 때 사용
-- 테이블1 N행 * 테이블2 M행

-- ANSI
SELECT *
FROM LOCATION CROSS JOIN COUNTRY;

-- 오라클 전용구문
SELECT *
FROM LOCATION, COUNTRY;

-- NATURAL JOIN ------------------------------------------------------------
-- 테이블이 가진 PRIMARY KEY 컬럼을 이용해서 조인이 됨
SELECT *
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT;  --  PRIMARY KEY 컬럼이 DEPT_ID 사용됨
-- JOIN DEPARTMENT USING (DEPT_ID); 와 결과가 같음

-- NON EQUI JOIN -----------------------------------------
-- 지정하는 컬럼의 값이 일치하는 경우가 아닌 값의 범위에 해당하는 행들을 연결하는 방식의 조인임
-- JOIN ON 사용함

SELECT *
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY BETWEEN LOWEST AND HIGHEST);

SELECT EMP_NAME, SALARY, SLEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY BETWEEN LOWEST AND HIGHEST);

-- SELF JOIN ------------------------------------------
-- 같은 테이블을 조인하는 경우
-- 같은 테이블 안에 다른 컬럼을 참조하는 외래키(FOREIGN KEY)가 있을 때 사용함
-- EMP_ID : 직원의 사번 ---> MGR_ID : 관리자 사번 - EMP_ID 컬럼값 가져다 사용(참조)하는 컬럼
-- 관리자 : 직원 중에서 관리자인 직원이 존재한다의 의미임

-- 관리자가 배정된 직원의 명단과 관리자인 직원 명단 조회
-- ANSI 표준구문 : SELF JOIN 은 테이블 별칭 사용해야 함. ON 사용함
SELECT *
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MGR_ID = M.EMP_ID);  -- 15행

SELECT E.EMP_NAME 직원, M.EMP_NAME 관리자
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MGR_ID = M.EMP_ID); 

-- 관리자인 직원 명단
SELECT DISTINCT M.EMP_NAME 관리자  -- 6행
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MGR_ID = M.EMP_ID); 

-- 오라클 전용구문
SELECT *
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MGR_ID = M.EMP_ID; -- 15행

SELECT E.EMP_NAME 직원, M.EMP_NAME 관리자
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MGR_ID = M.EMP_ID;

-- 관리자인 직원 명단
SELECT DISTINCT M.EMP_NAME 관리자  -- 6행
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MGR_ID = M.EMP_ID;


-- N개의 테이블 조인
-- 조인 순서가 중요함
-- 첫번째 테이블과 두번째 테이블이 조인되고 나서, 그 결과에 세번째 테이블이 조인됨

SELECT EMP_NAME, JOB_TITLE, DEPT_NAME
FROM EMPLOYEE 
LEFT JOIN JOB USING (JOB_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID);

SELECT *
FROM EMPLOYEE
LEFT JOIN LOCATION ON (LOCATION_ID = LOC_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID);  -- ERROR : 조인 순서 틀림

SELECT *
FROM EMPLOYEE
LEFT JOIN DEPARTMENT USING (DEPT_ID)
LEFT JOIN LOCATION ON (LOCATION_ID = LOC_ID);  -- 해결

-- 직원이름, 직급명, 부서명, 지역명, 국가명 조회
-- 직원 전체 조회임
-- ANSI 표준구문
SELECT EMP_NAME 직원이름, JOB_TITLE 직급명, DEPT_NAME 부서명, LOC_DESCRIBE 지역명, 
        COUNTRY_NAME 국가명
FROM EMPLOYEE
LEFT JOIN JOB USING (JOB_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID)
LEFT JOIN LOCATION ON (LOC_ID = LOCATION_ID)
LEFT JOIN COUNTRY USING (COUNTRY_ID);

-- 오라클 전용구문
SELECT EMP_NAME 직원이름, JOB_TITLE 직급명, DEPT_NAME 부서명, LOC_DESCRIBE 지역명, 
        COUNTRY_NAME 국가명
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L, COUNTRY C
WHERE E.JOB_ID = J.JOB_ID(+)
AND E.DEPT_ID = D.DEPT_ID(+)
AND D.LOC_ID = L.LOCATION_ID(+)
AND L.COUNTRY_ID = C.COUNTRY_ID(+);

-- ********************************************************************
--JOIN 연습문제
--
--1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
SELECT TO_CHAR(TO_DATE('20201225', 'RRRRMMDD'), 'DAY') 
FROM DUAL;

--2. 주민번호가 60년대 생이면서 성별이 여자이고, 성이 김씨인 직원들의 
--사원명, 주민번호, 부서명, 직급명을 조회하시오.
-- ANSI
SELECT EMP_NAME, EMP_NO, DEPT_NAME, JOB_TITLE
FROM EMPLOYEE
LEFT JOIN JOB USING (JOB_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID)
WHERE EMP_NO LIKE '6%'
AND SUBSTR(EMP_NO, 8, 1) IN ('2', '4')
AND EMP_NAME LIKE '김%';

-- ORACLE
SELECT EMP_NAME, EMP_NO, DEPT_NAME, JOB_TITLE
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_ID = J.JOB_ID(+)
AND E.DEPT_ID = D.DEPT_ID(+)
AND EMP_NO LIKE '6%'
AND SUBSTR(EMP_NO, 8, 1) IN ('2', '4')
AND EMP_NAME LIKE '김%';

--3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.

--나이의 최소값 조회
SELECT MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) 나이 
FROM EMPLOYEE;  

-- 조회한 나이의 최소값을 이용해 직원의 정보 조회함
-- outer join 필요함.
SELECT EMP_ID, EMP_NAME, 
       MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) 나이 ,
       DEPT_NAME, JOB_TITLE
FROM EMPLOYEE
LEFT JOIN JOB USING (JOB_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID)
GROUP BY EMP_ID, EMP_NAME, DEPT_NAME, JOB_TITLE
HAVING MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) = 34;

- 서브쿼리를 사용할 경우 *****************************
-- ANSI
SELECT EMP_ID, EMP_NAME, 
       MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(
       SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) 나이 ,
       DEPT_NAME, JOB_TITLE
FROM EMPLOYEE
LEFT JOIN JOB USING (JOB_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID)
GROUP BY EMP_ID, EMP_NAME, DEPT_NAME, JOB_TITLE
HAVING MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(
        SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) = (SELECT MIN(TRUNC((MONTHS_BETWEEN
                                                  (SYSDATE, 
                                                  TO_DATE(SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) 나이 
                                                  FROM EMPLOYEE);

-- ORACLE
SELECT EMP_ID, EMP_NAME, 
       MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(
       SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) 나이 ,
       DEPT_NAME, JOB_TITLE
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_ID = J.JOB_ID(+)
AND E.DEPT_ID = D.DEPT_ID(+)
GROUP BY EMP_ID, EMP_NAME, DEPT_NAME, JOB_TITLE
HAVING MIN(TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE(
        SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) = (SELECT MIN(TRUNC((MONTHS_BETWEEN
                                                  (SYSDATE, 
                                                  TO_DATE(SUBSTR(EMP_NO, 1, 4), 'RRMM')) / 12))) 나이 
                                                  FROM EMPLOYEE);



-- 4. 이름에 '성'자가 들어가는 직원들의 
-- 사번, 사원명, 부서명을 조회하시오.
-- ANSI
SELECT EMP_ID, EMP_NAME, DEPT_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT USING (DEPT_ID)
WHERE EMP_NAME LIKE '%성%';

-- ORACLE
SELECT EMP_ID, EMP_NAME, DEPT_NAME
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID = D.DEPT_ID(+)
AND EMP_NAME LIKE '%성%';

-- 5. 해외영업팀에 근무하는 
-- 사원명, 직급명, 부서코드, 부서명을 조회하시오.
-- ANSI
SELECT EMP_NAME, JOB_TITLE, DEPT_ID, DEPT_NAME
FROM EMPLOYEE
LEFT JOIN JOB USING (JOB_ID)
LEFT JOIN DEPARTMENT USING (DEPT_ID)
WHERE DEPT_NAME LIKE '해외영업%'
ORDER BY 4;

-- ORACLE
SELECT EMP_NAME, JOB_TITLE, E.DEPT_ID, DEPT_NAME
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_ID = J.JOB_ID
AND E.DEPT_ID = D.DEPT_ID
AND DEPT_NAME LIKE '해외영업%'
ORDER BY 4;

-- 6. 보너스포인트를 받는 직원들의 
-- 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
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

-- 7. 부서코드가 20인 직원들의 
-- 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
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

-- 8. 직급별 연봉의 최소급여(MIN_SAL)보다 많이 받는 직원들의
-- 사원명, 직급명, 급여, 연봉을 조회하시오.
-- 연봉은 보너스포인트를 적용하시오.
-- ANSI
SELECT EMP_NAME, JOB_TITLE, SALARY, 
       (SALARY + NVL(BONUS_PCT, 0) * SALARY) * 12 연봉
FROM EMPLOYEE
JOIN JOB USING (JOB_ID)       
WHERE (SALARY + NVL(BONUS_PCT, 0) * SALARY) * 12 
      > MIN_SAL;

-- ORACLE
SELECT EMP_NAME, JOB_TITLE, SALARY, 
       (SALARY + NVL(BONUS_PCT, 0) * SALARY) * 12 연봉
FROM EMPLOYEE E, JOB J
WHERE E.JOB_ID = J.JOB_ID     
AND (SALARY + NVL(BONUS_PCT, 0) * SALARY) * 12 > MIN_SAL;

-- 9 . 한국(KO)과 일본(JP)에 근무하는 직원들의 
-- 사원명(emp_name), 부서명(dept_name), 지역명(loc_describe),
--  국가명(country_name)을 조회하시오.
-- ANSI
SELECT EMP_NAME 사원명, DEPT_NAME 부서명,
       LOC_DESCRIBE 지역명, COUNTRY_NAME 국가명
FROM EMPLOYEE
JOIN DEPARTMENT USING (DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOC_ID)
JOIN COUNTRY USING (COUNTRY_ID)       
WHERE COUNTRY_ID IN ('KO', 'JP');

-- ORACLE
SELECT EMP_NAME 사원명, DEPT_NAME 부서명,
       LOC_DESCRIBE 지역명, COUNTRY_NAME 국가명
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, COUNTRY C
WHERE E.DEPT_ID = D.DEPT_ID
AND D.LOC_ID = L.LOCATION_ID
AND L.COUNTRY_ID = C.COUNTRY_ID      
AND L.COUNTRY_ID IN ('KO', 'JP');

-- 10. 같은 부서에 근무하는 직원들의 
-- 사원명, 부서코드, 동료이름, 부서코드를 조회하시오.
-- self join 사용
-- ORACLE
SELECT E.EMP_NAME 사원명, E.DEPT_ID 부서코드, 
       C.EMP_NAME 동료이름, C.DEPT_ID 부서코드
FROM EMPLOYEE E, EMPLOYEE C
WHERE E.EMP_NAME <> C.EMP_NAME
AND E.DEPT_ID = C.DEPT_ID
ORDER BY E.EMP_NAME;

-- ANSI
SELECT E.EMP_NAME 사원명, E.DEPT_ID 부서코드, 
       C.EMP_NAME 동료이름, C.DEPT_ID 부서코드
FROM EMPLOYEE E
JOIN EMPLOYEE C ON (E.DEPT_ID = C.DEPT_ID)
WHERE E.EMP_NAME <> C.EMP_NAME
ORDER BY E.EMP_NAME;



-- 11. 보너스포인트가 없는 직원들 중에서 
-- 직급코드가 J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하시오.

-- 단, join과 IN 사용
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

-- 단, join과 set operator 사용
SELECT EMP_NAME, JOB_TITLE, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_ID)
WHERE JOB_ID = 'J4' AND BONUS_PCT IS NULL
UNION  -- 두 SELECT 의 결과를 합칩
SELECT EMP_NAME, JOB_TITLE, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_ID)
WHERE JOB_ID = 'J7' AND BONUS_PCT IS NULL;



-- 12. 소속부서가 50 또는 90인 직원중 
-- 기혼인 직원과 미혼인 직원의 수를 조회하시오.
SELECT DECODE(MARRIAGE, 'Y', '기혼', 'N', '미혼') 결혼유무, 
       COUNT(*) 직원수
FROM EMPLOYEE
WHERE DEPT_ID IN ('50', '90')
GROUP BY DECODE(MARRIAGE, 'Y', '기혼', 'N', '미혼')
ORDER BY 1;









-- 7_SELECT_06(HAVING).sql

-- SELECT구문 ": HAVING 절 ------------------------------------------------------
-- 사용위치 : GROUP BY 절 다음에 작성함
-- 작성 형식 : HAVING 그룹함수(계산에 사용할 컬럼명) 비교연산자 비교값
-- 그룹별로 그룹함수 계산결과를 가지고 조건을 만족하는 그룹을 골라냄
-- 골라낸 그룹과 결과값을 SELECT 절에 표시함

-- 부서별 급여합계 중 가장 큰 값 조회
SELECT
    MAX(SUM(salary)) -- 1행 : 18100000
FROM
    employee
GROUP BY
    dept_id;

-- 부서코드도 함께 조회하게 한다면
SELECT
    dept_id,
    MAX(SUM(salary)) -- 1행 : 18100000
FROM
    employee
GROUP BY
    dept_id;

SELECT
    dept_id, -- 7행, err
    MAX(SUM(salary)) -- 1행 , err : 2차원 사각형 테이블이 아님
FROM
    employee
GROUP BY
    dept_id;

-- 부서별 급여합계 중 가장 큰값에 대한 부서코드와 급여합계를 조회
SELECT
    dept_id,
    SUM(salary)
FROM
    employee
GROUP BY
    dept_id
HAVING
--    SUM(salary) = 18100000;
    SUM(salary) = (
        SELECT
            MAX(SUM(salary))
        FROM
            employee
        GROUP BY
            dept_id
    );
    
-- 분석함수 (윈도우 함수라고도 함) --------------------------------------
-- 일반함수와 사용형식이 다름

-- RANK() 함수
-- 순위(등수) 반환

-- 1. 전체 컬럼값에 대한 순위 매기기
-- RANK() OVER (ORDER BY 순위매길 컬럼명 정렬방식)

-- 급여를 많이 받는 순으로 순위를 매긴다면 (큰값이 1등 : 내림차순)
SELECT
    emp_name,
    salary,
    RANK()
    OVER(
        ORDER BY
            salary DESC
    ) 순위
FROM
    employee
ORDER BY
    순위;
    
-- 2. 지정하는 컬럼값의 순위를 확인하는 용도로 사용
-- RANK(순위를 알고자 하는 값) WHITHIN GROUP (ORDER BY 순위매길컬럼명 정렬방식)

-- 급여 230만이 전체 급여중 몇순위? (급여 내림차순정렬의 경우)
SELECT
    RANK(2300000) WITHIN GROUP(ORDER BY salary DESC)
FROM
    employee;

-- ROWID
-- 테이블에 데이터 저장시(행 추가시, INSERT문) 지덩으로 붙여짐
-- DBMS가 자동으로 붙임, 수정 못 함, 조회만 할 수 있음
SELECT
    emp_id,
    ROWID
FROM
    employee;

-- ROWNUM
-- ROWID와 다름
-- ROWNUM은 SELECT문 실행시 결과행에 부여되는 행순번임. ( 1부터 시작)
-- 인라인뷰(FROM 절에 사용된 서브쿼리의 결과뷰)를 사용하면 ROWNUM을 확인 또는 사용할 수도 있음
SELECT
    *
FROM
    (
        SELECT
            ROWNUM rnum,
            emp_id,
            job_id
        FROM
            employee
        WHERE
            job_id = 'J5'
    )
WHERE
    rnum > 2;
    
-- ******************************************************************************************************
-- 조인( JOIN)
-- 여러 개의 테이블들을 하나로 합쳐서 큰 테이블을 만드는 것
-- 조인한 결과 테이블에서 원하는 컬럼을 선택함
-- 오라클 전용 구문과 ANSI 표준 구문으로 적성할 수 있음
-- 조인 기본 EQUAL JOIN 임 (같은 값끼리 연결함)
-- => EQUAL이 아닌 값에 대한 행은 조인에서 제외됨
-- 두 테이블의 FOREIGN KEY (외래키 | 외부키)로 연결된 컬럼값들이 일치하는 행들이 연결되는 구조임

-- 오라클 전용 구문 : 오라클에서만 사용함
-- FROM 절에 조인할(합칠) 테이블들을 나열함
-- WHERE 절에 합칠 컬럼에 대한 조건을 명시함
-- 단점 : 일반 조건과 섞임 >> WHERE 절이 복잡해짐

SELECT
    *
FROM
    employee,
    department
WHERE
    employee.dept_id = department.dept_id;
-- 결과행 : 20행 : EMPLOYEE의 DEPT_ID가 NULL인 직원 2명 제외 됨
-- EQUAL INNER JOIN 이라고 함

-- 조인시에 테이블에 별칭(ALIAS)을 붙일 수 있음
SELECT
    *
FROM
    employee   e,
    department d
WHERE
    e.dept_id = d.dept_id;

-- 직원이름, 부서코드, 부서명 조회
SELECT
    e.emp_name,
    e.dept_id,
    d.dept_name
FROM
    employee   e,
    department d
WHERE
    e.dept_id = d.dept_id;

SELECT
    emp_name,
    e.dept_id,
    dept_name
FROM
    employee   e,
    department d
WHERE
    e.dept_id = d.dept_id;

-- ASSI 표준 구문
-- 모든 DBMS가 공통으로 사용하는 표준구문임
-- 조인 처리를 위한 별도으 구문을 작성함 => FROM 절에 JOIN 키워드를 추가해서
-- 조인 조건을 WHERE 절에서 분리함

SELECT
    *
FROM
         employee
    JOIN department USING ( dept_id );

SELECT
    emp_id,
    dept_id,
    dept_name
FROM
         employee
--    JOIN department USING ( dept_id );
    INNER JOIN department USING ( dept_id ); -- INNER 생략해도 됨
-- 조인에 사용된 컬럼(DEPT_ID)이 한개 존재함, 맨 앞에 첫번째로 표시됨 : 오라클 전용구문과 다른점임

-- 조인은 기본이 EQUAL INNER JOIN 임
-- 두 테이블이 지정하는 컬럼의 값이 EQUAL 인 행들을 연결시키면서 조인하는 것임
-- INNER JOIN 은 EQUAL이 아닌 행은 제외됨

-- 조인시에 사용되는 두 테이블의 컬럼명이 같으면 USING 사용함
-- 사용된 값은 같은데 컬럼명만 다르면 ON 사용함

-- USING 사용 예 :
SELECT
    emp_name,
    dept_name
FROM
         employee
    JOIN department USING ( dept_id )
WHERE
    job_id = 'J6'
ORDER BY
    dept_name DESC;

-- ON 사용 예
SELECT
    *
FROM
         department
    JOIN location ON ( loc_id = location_id );

-- 위의 조인을 오라클 전용구문으로 바꾼다면
SELECT
    *
FROM
    department d,
    location   l
WHERE
    d.loc_id = l.location_id;
    
-- 사번, 이름, 직급명 조회 : 별칭
-- 오라클 전용 구문
SELECT
    emp_id,
    emp_name,
    job_title
FROM
    employee e,
    job      j
WHERE
    e.job_id = j.job_id;
    
-- ANSI 표준 구문
SELECT
    emp_id,
    emp_name,
    job_title
FROM
         employee
    JOIN job USING ( job_id );

-- OUTER JOIN
-- 기본은 EQUAL INNER JOIN + 값이 일치하지 않는 행도 포함시키는 조인
-- OUTER JOIN도 EQUAL JOIN 임 => 없는 값이 있는 테이블에 값으 추가함

-- EMPLOYEE 테이블의 전 직원의 정보를 조인 결과에 포함시키고자 한다면
-- 오라클 전용구문 : 값이 없는 테이블에 행을 추가하는 방식임 => (+)
SELECT
    *
FROM
    employee   e,
    department d
WHERE
    e.dept_id = d.dept_id (+);

-- ANSI 표준구문
SELECT
    *
FROM
    employee
--LEFT OUTER JOIN department USING (dept_id);
    LEFT JOIN department USING ( dept_id );

-- DEPARTMENT 테이블이 가진 모든 행을 조인에 포함시키려면
-- 오라클 전용구문
SELECT
    *
FROM
    employee   e,
    department d
WHERE
    e.dept_id (+) = d.dept_id;

-- ANSI 표준구문
SELECT
    *
FROM
    employee e
    RIGHT JOIN department USING ( dept_id );
    
-- 두 테이블의 일치하지 않는 행을 모두 다 조인에 포함시키려면
-- FULL OUTER JOIN 이라고 함

-- 오라클 전용구문에는 FULL OUTER JOIN 이 제공되지 않음
SELECT
    *
FROM
    employee   e,
    department d
WHERE
    e.dept_id (+) = d.dept_id (+); -- ERROR
    
-- ANSI 표준구문
SELECT
    *
FROM
         employee
--    FULL OUTER JOIN department USING ( dept_id ); -- 23행
          full
    JOIN department USING ( dept_id ); -- 23행
    
-- CROSS JOIN ------------------------------------------------------
-- 두 테이블을 연결할 컬럼이 없을 때 사용
-- 테이블1 N행 * 테이블2 M행

-- ANSI
SELECT
    *
FROM
         location
    CROSS JOIN country;

-- 오라클 전용구문
SELECT
    *
FROM
    location,
    country;

-- NATURAL JOIN ----------------------------------------------------
-- 테이블이 가진 PRIMARY KEY 컬럼을 이용해서 조인이 됨
SELECT
    *
FROM
         employee
    NATURAL JOIN department; -- PRIMARY KEY 컬럼이 DEPT_ID 사용됨
-- JOIN DEPARTMENT USING (DEPT_ID); 와 결과가 같음

-- NON EQUI JOIN
-- 지정하는 컬럼의 값이 일치하는 경우가 아닌 값의 범위에 해당하는 행들을 연결하는 방식의 조인임
-- JOIN ON 사용함

SELECT
    *
FROM
         employee
    JOIN sal_grade ON ( salary BETWEEN lowest AND highest );

SELECT
    emp_name,
    salary,
    slevel
FROM
         employee
    JOIN sal_grade ON ( salary BETWEEN lowest AND highest );

-- SELF JOIN
-- 같은 테이블을 조인하는 경우
-- 같은 테이블 안에 다른 컬럼을 참조하는 외래키(FOREIGN KEY)가 있을 때 사용함
-- EMP_ID : 직원의 사번 => MGR_ID : 관리자 사번 - EMP_ID 컬럼값 가져다 사영(참조)하는 컬럼
-- 관리자 : 직원 중에서 관리자인 직원이 존재한다의 의미임

-- 관리자가 배정된 직원의 명단과 관리자인 직원 명잔 조회
-- ANSI 표준구문 : SELF JOIN 은 테이블 별칭 사용해야 함. ON 사용함
SELECT
    *
FROM
         employee e
    JOIN employee m ON ( e.mgr_id = m.emp_id ); -- 15행

SELECT
    e.emp_name,
    m.emp_id
FROM
         employee e
    JOIN employee m ON ( e.mgr_id = m.emp_id );

-- 관리자인 직원 명단
SELECT DISTINCT
    m.emp_name
FROM
         employee e
    JOIN employee m ON ( e.mgr_id = m.emp_id );

-- 오라클 전용구문
SELECT
    *
FROM
    employee e,
    employee m
WHERE
    e.mgr_id = m.emp_id;

SELECT
    e.emp_name 직원,
    m.emp_name 관리자
FROM
    employee e,
    employee m
WHERE
    e.mgr_id = m.emp_id;

-- 관리자인 직원 명단
SELECT DISTINCT
    m.emp_name 관리자
FROM
    employee e,
    employee m
WHERE
    e.mgr_id = m.emp_id;

-- N개의 테이블 조인
-- 조인 순서가 중요함
-- 첫번째 테이블과 두번째 테이블이 조인되고 나서, 그 결과에 세번째 테이블이 조인됨

SELECT
    emp_name,
    job_title,
    dept_name
FROM
    employee
    LEFT JOIN job USING ( job_id )
    LEFT JOIN department USING ( dept_id );

SELECT
    *
FROM
    employee
    LEFT JOIN location ON ( location_id = loc_id )
    LEFT JOIN department USING ( dept_id ); -- ERROR

SELECT
    *
FROM
    employee
    LEFT JOIN department USING ( dept_id )
    LEFT JOIN location ON ( location_id = loc_id );
    
-- 직원이름, 직급명, 부서명, 지역명, 국가명 조회
-- 직원 전체 조회임
-- ANSI 표준구문
SELECT
    emp_name,
    job_title,
    dept_name,
    loc_describe,
    country_name
FROM
    employee
    LEFT JOIN job USING ( job_id )
    LEFT JOIN department USING ( dept_id )
    LEFT JOIN location ON ( location_id = loc_id )
    LEFT JOIN country USING ( country_id );

-- 오라클 전용구문
SELECT
    emp_name,
    job_title,
    dept_name,
    loc_describe,
    country_name
FROM
    employee   e,
    job        j,
    department d,
    location   l,
    country    c
WHERE
        e.job_id = j.job_id (+)
    AND e.dept_id = d.dept_id (+)
    AND d.loc_id = l.location_id (+)
    AND l.country_id = c.country_id (+);

-- ***********************************************************

--JOIN 연습문제
--1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
SELECT
    to_char(TO_DATE('20/12/25'),
            'day')
FROM
    dual;
    
--2. 주민번호가 60년대 생이면서 성별이 여자이고, 성이 김씨인 직원들의 
--사원명, 주민번호, 부서명, 직급명을 조회하시오.
-- ANSI
SELECT
    emp_name  사원명,
    emp_no    주민번호,
    dept_name 부서명,
    job_title 직급명
FROM
         employee
    JOIN department USING ( dept_id )
    JOIN job USING ( job_id )
WHERE
    substr(emp_no, 8, 1) IN ( 2, 4 )
    AND substr(emp_no, 1, 2) BETWEEN 60 AND 69
    AND emp_name LIKE '김%';

-- 오라클
SELECT
    emp_name  사원명,
    emp_no    주민번호,
    dept_name 부서명,
    job_title 직급명
FROM
    employee   e,
    department d,
    job        j
WHERE
        d.dept_id = e.dept_id
    AND j.job_id = e.job_id
    AND substr(emp_no, 8, 1) IN ( 2, 4 )
    AND substr(emp_no, 1, 2) BETWEEN 60 AND 69
    AND emp_name LIKE '김%';
    
--3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.
-- ANSI
SELECT
    emp_id               사번,
    emp_name             사원명,
    dept_name            부서명,
    job_title            직급명,
    substr(emp_no, 1, 2) "주민번호 앞 두자리"
FROM
         employee
    JOIN department USING ( dept_id )
    JOIN job USING ( job_id )
WHERE
    substr(emp_no, 1, 2) = (
        SELECT
            MAX(substr(emp_no, 1, 2))
        FROM
            employee
    );

-- 나이 구하기
SELECT MIN(trunc((months_between(sysdate, to_date(substr(emp_no, 1, 4), 'rrmm')) / 12))) 나이
from employee;

    

-- 오라클
SELECT
    emp_id               사번,
    emp_name             사원명,
    dept_name            부서명,
    job_title            직급명,
    substr(emp_no, 1, 2) "주민번호 앞 두자리"
FROM
    employee   e,
    department d,
    job        j
WHERE
        e.dept_id = d.dept_id
    AND e.job_id = j.job_id
    AND substr(emp_no, 1, 2) = (
        SELECT
            MAX(substr(emp_no, 1, 2))
        FROM
            employee
    );
    
--4. 이름에 '성'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
-- ANSI 구문
SELECT
    emp_no    사번,
    emp_name  사원명,
    dept_name 부서명
FROM
         employee
    NATURAL JOIN department
WHERE
    emp_name LIKE '%성%';

-- 오라클
SELECT
    emp_no    사번,
    emp_name  사원명,
    dept_name 부서명
FROM
    employee   e,
    department d
WHERE
        e.dept_id = d.dept_id
    AND emp_name LIKE '%성%';

--5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
-- ANSI
SELECT
    emp_name  사원명,
    dept_name 직급명,
    dept_id   부서코드,
    dept_name 부서명
FROM
         employee
    NATURAL JOIN department d
    JOIN location   l ON l.location_id = d.loc_id
    NATURAL JOIN country
WHERE
    d.dept_name LIKE '해외%'
GROUP BY
    emp_name,
    dept_name,
    dept_id,
    dept_name
ORDER BY
    부서명;
    
-- 오라클
SELECT
    emp_name  사원명,
    dept_name 직급명,
    e.dept_id 부서코드,
    dept_name 부서명
FROM
    employee   e,
    department d,
    location   l,
    country    c
WHERE
        e.dept_id = d.dept_id
    AND d.loc_id = l.location_id
    AND l.country_id = c.country_id
    AND d.dept_name LIKE '해외%'
ORDER BY
    부서명;

--6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
-- ANSI
SELECT
    emp_name 사원명,
    bonus_pct 보너스포인트,
    dept_name 부서명,
    loc_describe 근무지역명
FROM
    employee e
LEFt JOIN department d ON d.dept_id = e.dept_id
LEFT JOIN location l ON l.location_id = d.loc_id
WHERE bonus_pct IS NOT NULL
ORDER BY
    근무지역명;

-- 오라클
SELECT
    emp_name 사원명,
    bonus_pct 보너스포인트,
    dept_name 부서명,
    loc_describe 근무지역명
FROM
    employee e,
    department d,
    location l
WHERE 
    e.dept_id = d.dept_id
    AND d.loc_id = l.location_id
    AND bonus_pct IS NOT NULL
ORDER BY
    근무지역명;

--7. 부서코드가 20인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
-- ANSI
SELECT
    emp_name 사원명,
    job_title 직급명,
    dept_name 부서명,
    loc_describe 근무지역명
FROM
    employee
JOIN department d USING (dept_id)
JOIN job USING (job_id)
JOIN location l ON l.location_id = d.loc_id
WHERE dept_id LIKE '20';

-- 오라클
SELECT
    emp_name 사원명,
    job_title 직급명,
    dept_name 부서명,
    loc_describe 근무지역명
FROM
    employee e,
    department d,
    job j,
    location l
WHERE 
    e.dept_id = d.dept_id
    AND e.job_id = j.job_id
    AND d.loc_id = l.location_id
    AND d.dept_id LIKE '20';

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

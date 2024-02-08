-- 8_SELECT07(SET).sql

-- SELECT : 집합(SET) 연산자 ********************************************************

-- 집합 연산자 (SET OPERATOR)
-- UNION, UNION ALL, INTERESCT, MINIUS
-- 두 개 이상의 SELECT 문들의 결과(RESULT SET)들을 하나로 표현하기 위해 사용함
-- 세로로 결과들이 합쳐짐 : 
--  첫번째 SELECT 문의 결과가 위쪽에, 두번째 SELECT 문의 결과가 아래쪽에  배치됨
-- 합집합 : UNION, UNION ALL
--          두 SELECT 문의 결과를 하나로 합침
-- UNION : 두 SELECT 결과의 값들이 중복(일치)되는 행은 1개만 선택함
-- UNION ALL : 두 SELECT 결과의 값들이 중복(일치)되는 행은 제외시키지 않고 모두 선택함
-- 교집합 : INTERSECT
--          두 SLECT 결과의 중복행만 선택
-- 차집합 : MINUS
--          첫번째 SELECT 결과에서 두번째 SELECT 와 중복되는 행을 제외함(뺌)

/*
사용형식 : 
        SELECT 문
        집합연산자
        SELECT 문
        집합연산자
        SELECT 문
        ORDER BY 순번 정렬방식;
        
주의사항 : 관계형 데이터베이스는 2차원 사각형 테이블 구조다.
        1. 모든 SELECT 문의 SELECT 절의 컬럼 갯수가 같아야 함
                => 컬럼 갯수가 다르면 DUMMY COLUMN(NULL 컬럼)을 추가해서 갯수 맞춰줌
        2. SELECT 절에 나열된 컬럼별 자료형도 같아야 함
*/

-- 직원들의 사번과 직무명 조회
-- EMPLOYEE_ROLE 과 ROLE_HISTORY에서 각각 조회해서 하나로 합침
SELECT
    emp_id,
    role_name
FROM
    employee_role -- 22행
UNION -- 25 행 : 중복행 '104 SE' 가 1개 제외됨
SELECT
    emp_id,
    role_name
FROM
    role_history; -- 4행

SELECT
    emp_id,
    role_name
FROM
    employee_role -- 22행
UNION ALL -- 26 행 : 중복행 '104 SE' 가 1개 제외됨
SELECT
    emp_id,
    role_name
FROM
    role_history;

SELECT
    emp_id,
    role_name
FROM
    employee_role -- 22행
INTERSECT -- 1 행 : 중복행 '104 SE' 가 1개 제외됨
SELECT
    emp_id,
    role_name
FROM
    role_history;

SELECT
    emp_id,
    role_name
FROM
    employee_role -- 22행
MINUS -- 21 행 : 중복행 '104 SE' 가 
SELECT
    emp_id,
    role_name
FROM
    role_history;

-- SET 연산자 사용시 주의사항 확인 :
-- 1. 두 SELECT 문의 컬럼갯수 같아야 함
SELECT
    emp_name,
    job_id,
    hire_date
FROM
    employee
WHERE
    dept_id = '20' -- 3행
UNION
SELECT
    dept_name, -- 나열되는 컬럼의 자료형도 같아야 함
    dept_id,
    NULL -- DUMMY COLUM
FROM
    department
WHERE
    dept_id = '20';

-- 활용 : ROLLUP() 함수의 중간집계 위치에 원하는 문자처리 못 함
-- 해결방법은 집합 연산자응 활용할 수 있음
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    dept_id = '20' -- 3행
UNION
SELECT
    dept_name,
    '급여합계',
    SUM(salary)
FROM
         department
    JOIN employee USING ( dept_id )
WHERE
    dept_id = '20'
GROUP BY
    dept_name;
    
-- 두 개 이상의 SELECT 문의 결과들을 합칠 수도 있음
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    dept_id = '10' -- 3행
UNION ALL
SELECT
    dept_name,
    '급여합계',
    SUM(salary)
FROM
         department
    JOIN employee USING ( dept_id )
WHERE
    dept_id = '10'
GROUP BY
    dept_name
UNION ALL
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    dept_id = '20' -- 3행
UNION ALL
SELECT
    dept_name,
    '급여합계',
    SUM(salary)
FROM
         department
    JOIN employee USING ( dept_id )
WHERE
    dept_id = '20'
GROUP BY
    dept_name
UNION ALL
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    dept_id = '30' -- 3행
UNION
SELECT
    dept_name,
    '급여합계',
    SUM(salary)
FROM
         department
    JOIN employee USING ( dept_id )
WHERE
    dept_id = '30'
GROUP BY
    dept_name
UNION ALL
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    dept_id = '50' -- 3행
UNION ALL
SELECT
    dept_name,
    '급여합계',
    SUM(salary)
FROM
         department
    JOIN employee USING ( dept_id )
WHERE
    dept_id = '50'
GROUP BY
    dept_name
UNION ALL
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    dept_id = '90' -- 3행
UNION ALL
SELECT
    dept_name,
    '급여합계',
    SUM(salary)
FROM
         department
    JOIN employee USING ( dept_id )
WHERE
    dept_id = '90'
GROUP BY
    dept_name
UNION ALL
SELECT
    '전직원',
    '급여총합',
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL
UNION ALL
SELECT
    '부서미배정',
    '급여합계',
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL;
    
-- 반복되는 쿼리문이 너무 길어짐 => 상호연관 서브쿼리를 이용하거나, 프로시저 사용
-- 프로시저 : SQL 구문에 프로그래밍을 적용하는 객체임
    
-- 50번 부서에 소속된 직원 중 관리자와 일반직원을 따로 조회해서 하나로 합쳐라.
-- 확인 : 50번 부서의 직원정보 조회
SELECT
    *
FROM
    employee
WHERE
    dept_id = '50';

SELECT
    emp_id,
    emp_name,
    '관리자' 구분
FROM
    employee
WHERE
        emp_id = '141'
    AND dept_id = '50'
UNION
SELECT
    emp_id,
    emp_name,
    '직원' 구분
FROM
    employee
WHERE
        emp_id != '141'
    AND dept_id = '50'
ORDER BY
    3,
    1; -- SELECT 절의 나열순번만 사용함

-- 집합 연산자 사용시 별칭(ALIAS)는 첫번째 SELECT 구문에 사용함
SELECT
    'SQL을 공부하고 있습니다.' 문장,
    3                 순서
FROM
    dual
UNION
SELECT
    '우리는 지금',
    1
FROM
    dual
UNION
SELECT
    '아주 재미있게',
    2
FROM
    dual
ORDER BY
    2;

-- SET 연산자와 JOIN의 관계
SELECT
    emp_id,
    role_name
FROM employee_role
INTERSECT
SELECT
    emp_id, role_name
FROM role_history;

-- 각 쿼리문의 SELECT 절에 선택한 컬럼명이 동일한 경우에는 조인으로 바꿀 수 있음
-- USING (EMP_ID, ROLE_NAME) == INTERSECT
-- (104 SE) = (104 SE) : 같은 행 조회 => EQUAL INNER JOIN 임
-- (104 SE-ANLY) != (104 SE) : 다르다, 조인에서 제외됨

-- 위의 구문을 조인으로 바꾼다면
SELECT
    emp_id,
    role_name
FROM
    employee_role
JOIN role_history USING (emp_id, role_name);

-- SET 연산자와 IN 연산자의 관계 : 
-- UNION과 IN은 같은 결과를 만들 수 있음
-- SELECT 절에 선택된 컬럼명이 같고, 조회하는 테이블도 같고 
-- WHERE 절에 비교값만 다른 경우에 IN으로 바꾸수 있음

-- 직급이 대리 또는 사원인 직원의 이름, 직급명 조회
-- 직급순 오름차순정렬, 같은 직급은 이름순 오름차순정렬 처리함

SELECT
    emp_name,
    job_title
FROM
    employee
JOIN job USING (job_id)
WHERE job_title IN ('대리', '사원')
ORDER BY 2, 1;

-- UNION 구문으로 바꾼다면
SELECT
    emp_name,
    job_title
FROM
    employee
JOIN job USING (job_id)
WHERE job_title = '대리'
UNION
SELECT
    emp_name,
    job_title
FROM
    employee
JOIN job USING (job_id)
WHERE job_title = '사원'
ORDER BY 2, 1;

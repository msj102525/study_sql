-- 9_SELECT_08(서브쿼리).sql

-- SELECT : 서브쿼리 (SUB QUERY) ------------------------------------
-- SELECT 문 안에 사용되는 SELECT문 => 내부 쿼리라고도 함
-- 바깥 SELECT 문을 외부 쿼리 (메인 쿼리, MAIN QUERY)라고 함
/*
바깥함수(반환값이 있는 함수())
        => 안쪽 함수가 먼저 실행되면서, 반환한 값을 바깥 함수가 사용함
        
조건 구문에서 컬럼명 비교연산자 비교값   <-- 비교값 알아내기 위한 SELECT 문을 값 대신에 바로 사용할 수 있음
                    컬럼명 비교연산자 (비교값 조회하는 SELECT 문)   <-- 내부(서브)쿼리라고 함
*/

-- 나승원과 같은 부서에 근무하는 직원 명단 조회
-- 1. 나승원의 부서코드 조회
SELECT
    dept_id
FROM
    employee
WHERE
    emp_name = '나승원';

-- 2. 조회된 부서코드로 직원명단 조회
SELECT
    emp_name
FROM
    employee
WHERE
    dept_id = '50';

-- 서브쿼리 구문 :
SELECT
    emp_name
FROM
    employee
WHERE
    dept_id = (
        SELECT
            dept_id
        FROM
            employee
        WHERE
            emp_name = '나승원'
    );

-- 서브쿼리 유형 (종류)
-- 서브쿼리가 만드는 결과값의 갯수에 따라 구분
-- 서브쿼리 앞에 사용되는 연산자가 달라짐
-- 단일행 서브쿼리 : SELECT 한 결과값이 1개인 서브쿼리 
--                          => 일반 비교연산자(=, !=, <>, ^=, >, >=, <= 사용 가능함
-- 다중행 [단일열] 서브쿼리 : SELECT 한 결과행이 여러 개인 서브쿼리 (결과값이 여러 개)
--          => 일반 비교연산자(비교값 1개) 사용 못 함, IN, ANY, ALL 을 사용해야 함
-- 그 외 유형 : 다중열 서브쿼리
-- 다중열  [단일행] 서브쿼리 : 서브쿼리 결과행은 1개, 선택한 컬럼이 여러 개인 경우
--          조건절에서 (컬럼1, 컬럼2, ...) 비교연산자 (SELECT 컬럼1, 컬럼2, ... FROM ....)
-- 다중행 다중열 서브쿼리 : 서브쿼리 결과행 여러 개, SELECT 절 컬럼 여러 개인 경우
--          조건절에서 (컬럼1, 컬럼2, ...) IN, ANY, ALL (SELECT 컬럼1, 컬럼2, ... FROM ...)

-- 상[호연]관 서브쿼리 : 메인쿼리의 컬럼값으 가져다가 서브쿼리가 사용하는 구조임
-- 스칼라 서브쿼리 : 단일행 + 상호연관 서브쿼리

-- 단일행 서브쿼리 (SINGLE ROW SUBQUERY)
-- 서브쿼리의 결과값이 1개인 경우
-- 단일행 서브쿼리 앞에는 일반 비교연산자 사용할 수 있음

-- 예 : 나승원과 직급이 같으면서, 나승원보다 급여를 많이 받는 직원 조회
-- 1. 나승원 직급 조회
SELECT
    job_id
FROM
    employee
WHERE
    emp_name = '나승원'; -- 'J5'

-- 2. 나승원 급여 조회
SELECT
    salary
FROM
    employee
WHERE
    emp_name = '나승원';   -- 2300000

-- 3. 직원 조회
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
        job_id = 'J5'
    AND salary > 2300000;
    
-- 서브쿼리 구문 :
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
        job_id = (
            SELECT
                job_id
            FROM
                employee
            WHERE
                emp_name = '나승원' -- 'J5' : 단일행 서브쿼리
        )
    AND salary > (
        SELECT
            salary
        FROM
            employee
        WHERE
            emp_name = '나승원' -- 2300000 : 단일행 서브쿼리
    );

-- 직원 중에서 전체 급여에 대해 최저 급여(가장 작은 값)를 받는 명단 조회
-- WHERE 절에는 그룹함수 사용 못 함 => 서브쿼리로 해결
SELECT
    MIN(salary)
FROM
    employee; -- 1500000

SELECT
    emp_id,
    emp_name,
    salary
FROM
    employee
--WHERE salary = MIN(salry); -- err
--WHERE salary = 1500000;    
WHERE
    salary = (
        SELECT
            MIN(salary)
        FROM
            employee
    ); -- 1500000 : 값 1개 (단일행 서브쿼리)
        
-- HAVING 절에서도 서브쿼리 사용할 수 있음
-- 예 : 부서별 급여합계 중 가장큰 값에 대한 부서명과 급여합계 조회

-- 부서별 급여합계중 가장 큰값 조회
SELECT
    MAX(SUM(salary))
FROM
    employee
GROUP BY
    dept_id; -- 1행 : 18100000

-- 부서코드와 급여합계 함께 조회
SELECT
    dept_name,
    SUM(salary)
FROM
    employee
    LEFT JOIN department USING ( dept_id )
GROUP BY
    dept_name
--HAVING SUM(salary) = 18100000;
HAVING
    SUM(salary) = (
        SELECT
            MAX(SUM(salary))
        FROM
            employee
        GROUP BY
            dept_id
    );

-- 서브쿼리는 SELECT 구문 모든 절에서 사용할 수 있음
-- 주로 SELECT 절, FROM 절, WHERE 절, HAVING 절에 사용함

-- 다중열 (MULTI COLUMN) [단일행] 서브쿼리 ---------------------------
-- 서브쿼리가 만든 결과행은 1개, SELECT 절에 컬럼이 여러 개인 경우
-- 결과행이 1개이면, 일반비교연산자 사용 가능함
-- 주의 : 서브쿼리의 컬럼 갯수와 맞춰서 비교할 컬럼들을 묶어서 비교해야 함
-- (비교할 컬럼1, 비교할 컬럼2) 비교연산자 (SELECT 컬럼1, 컬럼2 FROM ....)

-- 나승원과 직급과 급여가 같은 직원 조회
SELECT
    emp_name,
    job_id,
    salary
FROM
    employee
WHERE
    ( job_id,
      salary ) = (
        SELECT
            job_id,
            salary
        FROM
            employee
        WHERE
            emp_name = '나승원'-- 다중열 단일행 서브쿼리
    );

-- 다중행 (MULTI ROWS) [단일열] 서브쿼리 ------------------------------
-- 서브쿼리가 만든 결과행(결과값)이 여러 개인 경우
-- 다중행 서브쿼리 앞에는 일반 비교연산자(비교값 1개와 비교함) 사용 못 함 : 에러남
-- 여러 개의 값을 비교할 수 있는 연산자 사용해야 함 : IN, ANY, ALL

-- 예 : 각 부서별로 급여가 가장 작은 직원 정보 조회
SELECT
    MIN(salary) -- 7행
FROM
    employee
GROUP BY
    dept_id;

SELECT
    emp_id,
    emp_name,
    dept_id,
    salary
FROM
    employee
WHERE
    salary = (
        SELECT
            MIN(salary) -- 7행 : 다중행 서브쿼리
        FROM
            employee
        GROUP BY
            dept_id
    ); -- err : 일반 비교연산자 사용 못 함
    
-- 수정
SELECT
    emp_id,
    emp_name,
    dept_id,
    salary
FROM
    employee
WHERE
    salary IN (
        SELECT
            MIN(salary) -- 7행 : 다중행 서브쿼리
        FROM
            employee
        GROUP BY
            dept_id
    );

-- 컬럼명 IN (여러개의 값들 | 다중행 서브쿼리)
-- 컬럼명 = 비교값1 OR 컬럼명 = 비교값2 OR 컬럼명 = 비교값3 OR....
-- 컬럼에 여러 개의 비교값과 일치하는 값이 있으면 선택하라는 의미

-- 컬럼명 NOT IN (여러개의 값들 | 다중행 서브쿼리)
-- NOT 컬럼명 IN (여러개의 값들 | 다중행 서브쿼리) 과 같음
-- NOT (컬럼명 = 비교값1 OR 컬럼명 = 비교값2 OR 컬럼명 = 비교값3 OR....)
-- 컬럼에 여러 개의 비교값과 일치하지 않는 값이 있으면 선택하라는 의미임

-- 예 : 관리자인 직원과 관리자가 아닌 직원을 별도로 조회해서 합쳐라.
-- 1. 관리자인 직원 조회
SELECT DISTINCT
    mgr_id -- 6행
FROM
    employee
WHERE
    mgr_id IS NOT NULL;
    
-- 2. 직원 정보에서 관리자만 조회
SELECT
    emp_id,
    emp_name,
    '관리자' 구분
FROM
    employee
WHERE
    emp_id IN (
        SELECT DISTINCT
            mgr_id -- 6행
        FROM
            employee
        WHERE
            mgr_id IS NOT NULL
    )
UNION
SELECT
    emp_id,
    emp_name,
    '직원' 구분
FROM
    employee
WHERE
    emp_id NOT IN (
        SELECT DISTINCT
            mgr_id -- 6행
        FROM
            employee
        WHERE
            mgr_id IS NOT NULL
    )
ORDER BY
    3,
    1;
    
-- SELECT 절에서도 서브쿼리 사용할 수 있음
-- 주로 함수식 안에서 서브쿼리가 사용됨

-- 위의 구문을 변경한다면
SELECT
    emp_id,
    emp_name,
    CASE
        WHEN emp_id IN (
            SELECT DISTINCT
                mgr_id -- 6행
            FROM
                employee
            WHERE
                mgr_id IS NOT NULL
        ) THEN
            '관리자'
        ELSE
            '직원'
    END 구분
FROM
    employee
ORDER BY
    3,
    1;
    
-- 컬럼명 > ANY (다중행 서브쿼리) : 다중행 서브쿼리가 만든 결과값들 중 가장 작은 값보자 큰 값 선택
-- 컬럼명 < ANY (다중행 서브쿼리) : 다중행 서브쿼리가 만든 결과값들 중 가장 큰 값보다 작은 값 선택
-- 여러 개의 결과 값들중 최소 하나만 조건을 만족할 경우임
-- = ANY : IN과 연산자가 같음

-- 예 : 대리 직급의 직원 중에서 과장 직급의 최소급여보다 많이 받는 대리 조회
SELECT
    emp_id,
    emp_name,
    job_title,
    salary
FROM
         employee
    JOIN job USING ( job_id )
WHERE
    salary > ANY (
        SELECT -- 다중행 서브쿼리
            salary
        FROM
                 employee
            JOIN job USING ( job_id )
        WHERE
            job_title = '과장'
    )
    AND job_title = '대리';

-- 컬럼명 > ALL (다중행 서브쿼리) : 가장 큰 값보다 큰
-- 컬럼명 < ALL (다중행 서브쿼리) : 가장 작은 값보다 작은

-- 예 : 모든 과장들의 급여보다 더 많은 급여를 받는 대리 직원 조회
SELECT
    emp_id,
    emp_name,
    job_title,
    salary
FROM
         employee
    JOIN job USING ( job_id )
WHERE
    salary > ALL (
        SELECT -- 다중행 서브쿼리
            salary
        FROM
                 employee
            JOIN job USING ( job_id )
        WHERE
            job_title = '과장'
    )
    AND job_title = '대리';

-- 서브쿼리의 사용 위치 : 
-- SELECT 문의 SELECT 절, FROM 절, WHERE 절, GROUP BY 절, HAVING 절, ORDER BY 절
-- 모든 절에서 서브쿼리 사용할 수 있음
-- DML 문 : INSERT문, UPDATE문
-- DDL 문 : CREATE TABLE 문, CREATE VIEW 문

-- 다중열 다중행 서브쿼리 -----------------------------
-- 자기 직급의 평균 급여를 받는 직원 조회
-- 1. 직급별급여 평균 조회
SELECT
    job_id,
    trunc(AVG(salary),
          - 5)
FROM
    employee
GROUP BY
    job_id;
-- 실제 기록된 급여값과 평균값의 자릿수 맞추기가 필요함

-- 2. 적용
SELECT
    emp_name,
    job_title,
    salary
FROM
    employee
    LEFT JOIN job USING ( job_id )
WHERE
    ( job_id, salary ) IN (
        SELECT
            job_id, trunc(AVG(salary),
                          - 5)
        FROM
            employee
        GROUP BY
            job_id
    );
    
-- FROM 절에서도 서브쿼리 사용할 수 있음 => 서브쿼리의 결과뷰를 테이블 대신에 사용함
-- FROM (서브쿼리) 별칭 => 별칭이 테이블명을 대신함
-- 인라인 뷰라고 함

-- 참고 : 
-- 오라클 전용구문은 FROM 절에 조인할 테이블명 옆에 별칭을 지정할 수 있음
-- 테이블 별칭을 테이블명 대신에 사용함
-- ANSI 표준구문 USING 사용시에는 테이블 별칭 사용할 수 없음
-- ANSI 표준구문에서 테이블 별팅 사용하려면, ON 사용하면 됨

-- 자기 직읍의 평균급여를 받는 직원 조회
-- 인라인 뷰를 사용한다면 : 
SELECT
    emp_name,
    job_title,
    salary
FROM
         (
        SELECT
            job_id,
            trunc(AVG(salary),
                  - 5) jobavg
        FROM
            employee
        GROUP BY
            job_id
    ) v -- 인라인 뷰
    JOIN employee e ON ( v.jobavg = e.salary
                         AND v.job_id = e.job_id )
    JOIN job      j ON ( e.job_id = j.job_id )
ORDER BY
    3,
    1;
    
 -- 상[호연]관 서브쿼리 (CORRELATE SUBQUERY)
 -- 대부분의 서브쿼리는 서브쿼리가 만든 결과를 메인쿼리가 사용하는 구조임
 -- 서브쿼리만 따로 실행해서 결과를 확인할 수 있음
 -- 상호연관 서브쿼리는 서브쿼리가 메인쿼리의 값을 가져다가 결과를 만듦
 -- 즉, 메인쿼리의 값이 바뀌면 서브쿼리의 결과도 달라지게 됨
 
 -- 자기 직급의 평균 급여를 받는 직원 조회 : 상호연관 서브쿼리 작성한다면
SELECT
    emp_name,
    job_title,
    salary
FROM
    employee e
    LEFT JOIN job      j ON ( e.job_id = j.job_id )
-- WHERE SALARY = (각 직원의 평균급여 계산)
WHERE
    salary = (
        SELECT
            trunc(AVG(salary),
                  - 5)
        FROM
            employee
        WHERE
            nvl(job_id, ' ') = nvl(e.job_id, ' ')
    );

-- EXISTS / NOT EXISTS
-- 상호연관 서브쿼리 앞에만 사용하는 연산자임
-- 서브뭐리가 만든 결과가 존재하는지 물어볼 때 EXISTS 사용함
-- 이 연산자 사용시에는 비교할 컬럼명 사용하면 안됨
-- 컬럼면 연산자 (서브쿼리) ==> EXISTS (상호연관 서브쿼리)
-- 서브쿼리의 결과가 있느냐? 없느냐? 를 물어보는 연산자임
-- 서브쿼리 SELECT 절에 NULL만 선언함 : 컬럼 선택 안함

-- 예 : 관리자인 직원 조회
SELECT
    emp_id,
    emp_name,
    '관리자' 구분
FROM
    employee e
WHERE
    EXISTS (
        SELECT
            NULL
        FROM
            employee
        WHERE
            e.emp_id = mgr_id
    );
-- 상호연관 서브쿼리의 결과가 존재하면, 해당 값에 대한 행을 골라냄

-- NOT EXISTS : 상호연관 서브쿼리에 결과가 존재하지 않느냐
-- 예 : 관리자가 아닌 직원 조회
SELECT
    emp_id,
    emp_name,
    '관리자' 구분
FROM
    employee e
WHERE
    NOT EXISTS (
        SELECT
            NULL
        FROM
            employee
        WHERE
            e.emp_id = mgr_id
    );
-- 상호연관 서브쿼리의 결과가 존재하지 않으면, 해당 값에 대한 행을 골라냄 

-- 스칼라 서브쿼리 -----------------------------------
-- 단일행 + 상호연관 서브쿼리

-- 예 : 이름, 부서코드, 급여, 해당 직원이 소속된 부서의 평듄급여 조회
SELECT
    emp_name,
    dept_id,
    salary,
    (
        SELECT
            trunc(AVG(salary),
                  - 5)
        FROM
            employee
        WHERE
            e.dept_id = dept_id
    ) "소속부서의 급여평균"
FROM
    employee e;
    
-- ORDER BY 절에서 스칼라 서브쿼리 사용할 수 있음
-- 직원이 소속된 부서의 부서명이 큰 값부터 정렬된 직원 정보 조회
SELECT
    emp_id,
    emp_name,
    dept_id,
    hire_date
FROM
    employee e
ORDER BY
    (
        SELECT
            dept_name
        FROM
            department
        WHERE
            dept_id = e.dept_id
    ) DESC NULLS LAST;
                
-- TOP-N 분석 ---------------------------------
-- 상위 몇 개, 하위 몇 개를 조회하는 것
-- 방법 1 : 인라인뷰와 RANK() 함수를 이용
-- 방법 2 : 인라인뷰와 ROWNUM 이용

-- 방법 1 : 인라인뷰와 RANK() 함수를 이용
-- 직원 정보에서 급여를 가장 많이 받는 직원 5명 조회
-- 이름, 급여, 순위
SELECT
    *
FROM
    (
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
    )
WHERE 순위 <= 5;

-- 방법 2 : 인라인뷰와 ROWNUM 이 부여되게 함
-- ROWNUM : 행번호, WHERE 절 작동 후에 자동으로 부여됨

-- 확인
SELECT
    ROWNUM,
    emp_id,
    emp_name,
    salary
FROM
    employee -- ROWNUM 지정됨
ORDER BY
    salary DESC;

-- 급여 많이 받는 직원 5명 조회 : 인라인뷰 사용하지 않은 경우
SELECT
    ROWNUM,
    emp_id,
    emp_name,
    salary
FROM
    employee
WHERE
    ROWNUM <= 5 -- 조건처리가 끝나고 나서 ROWNUM 지정됨
ORDER BY salary DESC;

-- 해결 : 정렬하고 나서 ROWNUM이 부여되게끔 구문 작성함
-- 인라인뷰 사용함
SELECT
    ROWNUM,
    emp_name, salary
FROM (
    SELECT
        *
    FROM
        employee
    ORDER BY salary DESC
    )
WHERE
    ROWNUM <= 5;


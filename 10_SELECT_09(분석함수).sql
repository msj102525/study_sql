-- 10_SELECT_09(분석함수).sql

/*
WITH 이름 AS (서브쿼리문)
SELECT * FROM 이름;
=> 서브쿼리문에 이름을 붙여주고, SELECT 구문에서 서브쿼리문이 필요시 이름을 대신 사용함
=> 같은 서브쿼리가 여러 번 사용될 경우, SELECT 구문에서 서브쿼리문 중복 사용을 줄일 수 있음
=> 실행 속도도 빨라짐 : 미리 컴파일 되었음
=> 인라인뷰로 사용될 서브쿼리에 주로 사용됨
*/

SELECT *
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT;
-- DEPARTMENT 의 PRIMARY KEY 로 지정된 컬럼(DEPT_ID)가 자동으로 조인 컬럼으로 사용됨
-- EQUAL INNER JOIN 과 결과가 같음

-- 부서별 급여의 합계가 전체 급여 총합의 20% 보다 많은 부서별 급여합계값을 가진 부서 조회
-- 부서명, 부서별 급여합계 조회
-- 일반 SQL 문 : 
SELECT DEPT_NAME, SUM(SALARY)
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT
GROUP BY DEPT_NAME
HAVING SUM(SALARY) > (SELECT SUM(SALARY) * 0.2
                        FROM EMPLOYEE);

-- WITH 사용 SQL문 : 
WITH TOTAL_SAL AS (SELECT DEPT_NAME, SUM(SALARY) DSAL
                    FROM EMPLOYEE
                    NATURAL JOIN DEPARTMENT
                    GROUP BY DEPT_NAME)
SELECT DEPT_NAME, DSAL
FROM TOTAL_SAL  -- 인라인뷰
WHERE DSAL > (SELECT SUM(SALARY) * 0.2
                FROM EMPLOYEE);

-- 급여 많이 받는 직원 3명 조회  
-- ROWNUM, 이름, 급여
-- ROWNUM 사용 일반 SQL 문 : 
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY SALARY DESC)
WHERE ROWNUM < 4;

-- ROWNUM 사용 WITH SQL 문 : 
WITH SAL_DESC AS (SELECT *
                    FROM EMPLOYEE
                    ORDER BY SALARY DESC)
SELECT ROWNUM, EMP_NAME, SALARY
FROM SAL_DESC
WHERE ROWNUM < 4;

-- RANK() 사용 일반 SQL 문 : 
SELECT EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY,
               RANK() OVER (ORDER BY SALARY DESC) 순위
        FROM EMPLOYEE)
WHERE 순위 < 4;

-- RANK() 사용 WITH SQL 문 : 
WITH SAL_RANK AS (SELECT EMP_NAME, SALARY,
                           RANK() OVER (ORDER BY SALARY DESC) 순위
                    FROM EMPLOYEE)
SELECT EMP_NAME, SALARY
FROM SAL_RANK
WHERE 순위 < 4;

-- *************************************************************
-- 분석함수
/*
분석함수의 정의 : 
오라클 분석함수는 데이터를 분석하는 함수이다.
분석함수를 사용하면, 쿼리 실행의 결과인 RESULT SET을 대상으로 전체 그룹이 아닌
소그룹별로 각 행에 대한 분석 결과를 리턴한다.

일반 그룹함수들과 다른 점은 분석함수는 분석함수용 그룹을 별도로 지정해서 그 그룹을 대상으로 계산을 수행함
분석함수용 그룹을 오라클에서는 윈도우(Window)라고 부름
분석함수 == 윈도우함수 라고도 함

사용형식 : 
분석함수명([전달인자1, 전달인자2, 전달인자3]) OVER ([쿼리 PARTITION 절]
                                          [ORDER BY 절]
                                          [WINDOW 절])
* 분석함수 : SUM, AVG, COUNT, MAX, MIN, RANK 등
* 전달인자 : 분석함수에 따라서 0 ~ 3개까지 값 사용
* 쿼리 PARTITION 절 : PARTITION BY 표현식
            PARTITION BY 로 시작하며, 표현식에 따라 그룹별로 단일 결과셋을 분리하는 역할을 함
            즉, 분석함수의 분석 대상 그룹을 지정함
* ORDER BY 절 : PARTITION BY 절 뒤에 위치하며, 계산 대상 그룹에 대해 각각 정렬작업을 수행함
* WINDOW 절 : 분석함수의 대상이 되는 데이터를 행기준으로(세로방향으로) 계산범위를 더 세부적으로 정의함
            PARTITION BY 에 의해 나누어진 그룹에 대해 또 다른 소그룹을 만듦
*/

-- RANK() : 등수 매기는 함수
-- 같은 등수가 있을때는 다음 등수가 건너뜀
-- 예 : 1, 2, 2, 4

-- 급여에 순위를 매긴다면
SELECT EMP_ID, EMP_NAME, SALARY,
        RANK() OVER (ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

-- 특정 값의 순위를 조회할 때
-- 급여 230만이 전체 급여 내림차순정렬시의 순위는?
SELECT RANK(2300000) WITHIN GROUP (ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

-- DENSE_RANK() : 순위 매기는 함수
-- 같은 순위가 있어도 다음 순위를 건너뛰지 않음
-- 예 : 1, 2, 2, 3
SELECT EMP_NAME, DEPT_ID, SALARY,
        RANK() OVER (ORDER BY SALARY DESC) "순위1",
        DENSE_RANK() OVER (ORDER BY SALARY DESC) "순위2",
        DENSE_RANK() OVER (PARTITION BY DEPT_ID
                             ORDER BY SALARY DESC) "순위3"
FROM EMPLOYEE
ORDER BY 2 DESC NULLS LAST;

-- RANK() | DENSE_RANK() 를 이용한 TOP-N 분석
-- 급여 많은 순으로 상위 5명 조회
-- RANK() : 
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK() OVER (ORDER BY SALARY DESC) 순위
        FROM EMPLOYEE)
WHERE 순위 <= 5;

-- DENSE_RANK() : 
SELECT *
FROM (SELECT EMP_NAME, SALARY, DENSE_RANK() OVER (ORDER BY SALARY DESC) 순위
        FROM EMPLOYEE)
WHERE 순위 <= 5;

-- 급여 많은 순으로 11순위에 해당되는 직원 정보 조회
-- RANK() : 같은 등수가 여러 개 있으면 다음 등수가 건너뜀
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK() OVER (ORDER BY SALARY DESC) 순위
        FROM EMPLOYEE)
WHERE 순위 = 11;

-- DENSE_RANK() : 같은 등수가 여러 개 있어도 다음 등수가 이어짐
SELECT *
FROM (SELECT EMP_NAME, SALARY, DENSE_RANK() OVER (ORDER BY SALARY DESC) 순위
        FROM EMPLOYEE)
WHERE 순위 = 11;

-- CUME_DIST() : CUMulativE_DISTribution ----------------------------------------
-- PARTITION BY 에 의해 나누어진 그룹별로 각 행을 ORDER BY 절에 명시된 순서로 정렬한 후에
-- 그룹별로 누적된 분산정도(상대적인 위치)를 구하는 함수
-- 분산정도(상대적인 위치)는 구하고자 하는 값보다 작거나 같은 값을 가진 행갯수를 그룹 내의 총 행수로 나눈것임
-- 0 < 분산정도 <= 1 범위의 값이 됨

-- 부서코드가 '50'인 직원들의 이름, 급여, 부서원들의 급여에 대한 누적분산 조회
SELECT EMP_NAME, SALARY, 
        ROUND(CUME_DIST() OVER (ORDER BY SALARY), 1) 누적분산
FROM EMPLOYEE
WHERE DEPT_ID = '50';

-- NTILE() ------------------------------------------
/*
PARTITION 을 BUCKET 이라 불리는 그룹별로 나누고, PARTITION 내의 각 행을 BUCKET에 배치하는 함수
예를 들어, PARTITION 안에 100개의 행이 있다면  BUCKET 을 4개로 하면,
1개의 BUCKET 당 25개의 행이 배분이 됨
정확하게 분배되지 않을 때는 근사치로 배분한 후 남는 행에 대해서는 최초 BUCKET 부터 한개씩 배분됨
*/

-- 직원 전체 급여를 4등급으로 분류
SELECT EMP_NAME, SALARY, NTILE(4) OVER (ORDER BY SALARY) 등급
FROM EMPLOYEE;


-- ROW_NUMBER() -------------------------------------------------
-- ROWNUM 과 관계없음
-- 각 PARTITION 내의 값들을 ORDER BY 절에 의해 정렬한 후, 순서대로 순번을 부여함

-- 사번, 이름, 급여, 입사일, 순번 조회
-- 단, 순번은 급여 많은 순으로, 같은 급여는 입사일이 빠른 사람부터 순번 부여함
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE, 
        ROW_NUMBER() OVER (ORDER BY SALARY DESC, HIRE_DATE ASC) 순번
FROM EMPLOYEE;

-- 집계함수 ----------------------------------------
-- SUM, AVG, COUNT, MAX, MIN

-- 직원 테이블에서 부서코드가 '60'인 직원들의
-- 사번, 급여, 해당 부서그룹(윈도우라고 함)의 사번을 오름차순정렬하고
-- 급여의 합계를 그룹 안의 첫행부터 마지막행까지 구해서 "win1" 로 별칭 처리함
-- 급여의 합계를 그룹 안의 첫행부터 현재 행까지 구해서 "win2 로 별칭 처리함
-- 급여의 합계를 그룹 안의 현재 행에서 마지막행까지 구해서 "win3" 로 별칭 처리함
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
-- ROWS : 부분 그룹인 윈도우의 크기를 물리적인 단위로 행집합을 지정한 것임
-- UNBOUNDED PRECEDING : 윈도우의 첫행
-- UNBOUNDED FOLLOWING : 윈도우의 마지막행
-- CURRENT ROW : 계산값이 있는 현재 행


-- 직원 테이블에서 부서코드가 '60'인 직원들의
-- 사번, 급여, 해당 부서그룹(윈도우라고 함)의 사번을 오름차순정렬하고
-- 그룹 안의 현재 행을 기준으로 이전행과 다음행의 급여합계를 구해서 "win1" 로 별칭 처리함
-- 1 PRECEDING : 1개 이전행
-- 1 FOLLOWING : 1개 다음행
-- 그룹 안의 현재 행을 기준으로 이전행과 현재행의 급여합계를 구해서  "win2 로 별칭 처리함
-- 그룹 안의 현재 행을 기준으로 현재행과 다음행의 급여합계를 구해서 "win3" 로 별칭 처리함
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
-- 해당 구간에서 차지하는 비율을 리턴하는 함수

-- 직원들의 총급여를 2천만원 증가시킬 때, 기존 급여비율을 적용해서 각 직원들이 받게될 급여 증가액은?
SELECT EMP_NAME, SALARY,
        LPAD(TRUNC(RATIO_TO_REPORT(SALARY) OVER () * 100, 0), 5) || '%' "비율",
        TO_CHAR(TRUNC(RATIO_TO_REPORT(SALARY) OVER () * 20000000, 0), 'L99,999,999') "추가로 받게될 급여"
FROM EMPLOYEE;


-- LAG() 함수 -----------------------------------------------
-- LAG(조회할 범위, 이전위치, 기준 현재위치)
-- 지정하는 컬럼의 현재 행을 기준으로 이전 행(위쪽)의 값을 조회함
SELECT EMP_NAME, DEPT_ID, SALARY,
        LAG(SALARY, 1, 0) OVER (ORDER BY SALARY ASC)  "이전값 조회",
        LAG(SALARY, 1, SALARY) OVER (ORDER BY SALARY ASC)  "조회2",
        LAG(SALARY, 1, SALARY) OVER (PARTITION BY DEPT_ID
                                        ORDER BY SALARY ASC)  "조회3"
FROM EMPLOYEE
--ORDER BY DEPT_ID NULLS LAST
;
-- 1 : 1칸 위의 행값, 0 : 이전 행이 없으면 0 처리함
-- 컬럼명 : 이전행이 없다면 현재 행값으로 처리함

-- LEAD() 함수 -----------------------------------------------
-- LEAD(조회할 범위, 다음행수, 0 또는 컬럼명)
-- 지정하는 컬럼의 현재 행을 기준으로 다음 행(아래쪽)의 값을 조회함
SELECT EMP_NAME, DEPT_ID, SALARY,
        LEAD(SALARY, 1, 0) OVER (ORDER BY SALARY ASC)  "다음값 조회",
        LEAD(SALARY, 1, SALARY) OVER (ORDER BY SALARY ASC)  "조회2",
        LEAD(SALARY, 1, SALARY) OVER (PARTITION BY DEPT_ID
                                        ORDER BY SALARY ASC)  "조회3"
FROM EMPLOYEE
ORDER BY DEPT_ID NULLS LAST
;







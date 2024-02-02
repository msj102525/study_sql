-- 2_SELECT_01.sql

-- 오라클 셋팅 정보 확인하기
SELECT * FROM v$nls_parameters;
-- NLS_LANGUAGE : KOREAN
-- NLS_DATE_FORMAT : RR/MM/DD
-- NLS_CHARACTERSET : AL32UTF8
-- 필요시 변경할 수 있음

-- ********************************************************************
-- SELECT 구문
-- 관계형 데이터베이스(RDB)는 데이터를 테이블에 저장한다.
-- 데이터의 항목(속성, Attribute)은 컬럼(Column)이라고 함
-- SELECT문은 테이블에 기록 저장된 데이터를 검색(조회 : 찾아내기 위한)하기 위해 사용되는 SQL구문임
-- DQL(Data Quary Language : 데이터 조회어)라고도 함

/*
SELECT 구문 기본 작성법 :
SELECT * | 컬럼명, 컬럼명, 함수식, 계산식
FROM 조회할 테이블명

* : 테이블이 가진 모든 컬럼의 데이터를 조회한다는 의미임 (테이블 전체 조회)
*/
SELECT * FROM EMPLOYEE;

-- 부서(DEPARTMMENT) 테이블 전체 조회
SELECT * FROM DEPARTMENT;

-- 직급(JOB) 테이블 전체 조회
SELECT * FROM JOB;

-- 테이블의 특징 컬럼에 기록된 값들을 조회하려면 (ch03, pdf 3page)
-- 예 : 직원 테이블에서 사번(EMP_ID), 이름(EMP_NAME), 주민번호(EMP_NO) 조회
SELECT EMP_ID as id, EMP_NAME, EMP_NO
FROM EMPLOYEE;

-- 직원 테이블에서 사번, 이름, 급여, 보너스포인트 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS_PCT
FROM EMPLOYEE;

-- 직원 테이블에서 사번, 이름, 직급코드, 입사일, 부서코드 조회
SELECT EMP_ID, EMP_NAME, JOB_ID, HIRE_DATE, DEPT_ID
FROM EMPLOYEE;

-- SELECT절에 계산식 사용할 수도 있음
-- 컬럼에 기록된 값을 계산에 사용한 결과를 출력함
-- 예 : 직원 테이블에서 사번, 이름, 급여, 연벙(급여* 12) 조회
SELECT EMP_ID, EMP_NAME, SALARY, SALARY *12 
FROM EMPLOYEE;

-- SELECT절에 함수를 사용할 수도 있음
-- 제공되는 함수를 파악하고 사용법 확인하고 사용함
-- 함수는 컬럼에 기록된 값을 읽어서 함수로 처리한 결과를 반환함
-- 예 : 직원테이블에서 사번, 이름, 주민번호 앞 6자리값만 조회
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 1,6)
FROM EMPLOYEE;

-- 조회형태 2 : 특정 행(ROW, 가로 한 줄)들을 조회
-- 조건을 만족하는 행들을 골라낸 다음, 원하는 컬럼값을 선택하는 방식임
-- 조건절을 사용함 : WHERE 컬럼명 비교연산자 비교값
-- WHERE 절은 FROM 절 다음에 위치함
-- 예 : 직원 정보에서 기혼자인(결혼한) 직원들만 조회
SELECT *
FROM employee
--WHERE marriage = 'Y'; -- 값이 일치하는 행(줄)을 골라냄
WHERE marriage = 'y'; -- 기록된 값은 대소문자 구분함

-- 미혼인 직원 정보 조회
SELECT *
FROM employee
WHERE marriage = 'N';

-- 조회형태 3 :
-- 조건을 만족하는 행들을 골라냄 => 원하는 컬럼을 선택하는 조회임
-- 예 : 직원 정보에서 직급 코드가 'J4'인 직원들의 사번, 이름, 직급코드, 급여 조회
SELECT emp_id, emp_name, job_id, salary
FROM employee
WHERE job_id = 'J4';

-- 직급코드가 'J4'에 대한 직급명 조회한다면
SELECT job_title
FROM job
WHERE job_id = 'J4';

-- 조회형태 4 :
-- 직원 정보에서 '90'번 부서에 근무하는 직원들의 사번, 이름, 부서코드, 관리자사번 조회
SELECT emp_id, emp_name, dept_id, mgr_id
FROM employee
WHERE dept_id = '90';

-- 90번 부서의 부서명은?
SELECT dept_id, dept_name
FROM department
WHERE dept_id = '90';

-- SELECT 구문은 기본 1개의 테이블에 대한 조회임
-- 필요할 경우 여러 개의 테이블을 하나로 합쳐서(조인, JOIN) 원하는 컬럼을 조회할 수도 있음
SELECT emp_id, emp_name, dept_id, dept_name
FROM employee
JOIN department USING(dept_id)
WHERE dept_id= '90';

-- 직급이 '과장'인 직원 정보 조회
-- 사번, 이름, 직급코드, 직급명, 급여, 보너스포인트

SELECT emp_id, emp_name, job_id, job_title, salary, bonus_pct
FROM employee
JOIN job USING(job_id)
WHERE job_title = '과장';

SELECT e.emp_id, e.emp_name, e.job_id, j.job_title, e.salary, e.bonus_pct
FROM employee e
JOIN job j
ON e.job_id = j.job_id
WHERE job_title = '과장';


-- DATE 자료형
-- 날짜와 시간을 기록하는 컬럼에 적용
-- 날짜와 시간은 계산할 수 있음
-- 출력 형식(포멧)은 'RR/MM/DD' 로 지정되어 있음

SELECT SYSDATE, SYSTIMESTAMP
FROM DUAL;
-- DUAL : DUMMY TABLE(가짜 테이블)

SELECT SYSDATE + 1000 -- 오늘부터 1000일 뒤 날짜 (DATE)
FROM DUAL;

SELECT STSDATE - 100 -- 오늘 기준 100일 전 날짜(DATE)
FROM DUAL;

SELECT SYSDATE + 100/24 -- 현재 시간부터 100시간 뒤 날짜(DATE)
FROM DUAL;

-- 직원 정보에서 입사일부터 오늘까지 근무일수를 조회
SELECT emp_id, emp_name, hire_date, FLOOR(SYSDATE - hire_date) -- 근무일수
FROM employee;

-- 한굴은 기본 한글자가 2바이트임
-- 오라클 XE에서는 한글 1글자가 3바이트임 (참고할 것)
SELECT emp_name, LENGTH(emp_name) 글자갯수, LENGTHB(emp_name) 바이트수
FROM employee;

-- 직원 정보에서 사번, 이름, 급여, 보너스포인트, 보너스포인트가 적용된 연봉 조회
SELECT emp_id, emp_name, salary, bonus_pct,
            (salary + (salary * bonus_pct)) * 12
FROM employee;
-- 데이터베이스에서는 계산할 값이 NULL이면 결과도 NULL임
-- 계산할 값이 NULL이면, 결과값이 나오게 하려면 NULL을 다른 값으로 바꾸면 됨
-- 관련 함수 이용함 : NVL(컬럼명, NULL일때 바꿀값)

SELECT emp_id, emp_name, salary, bonus_pct,
            (salary + (salary * NVL(bonus_pct, 0))) * 12
FROM employee;

-- 별칭 (ALIAS)
SELECT emp_id AS 사번, emp_name AS 이름, salary AS 급여, bonus_pct AS 보너스포인트,
            (salary + (salary * NVL(bonus_pct, 0))) * 12 보너스적용연봉
FROM employee;

/*
SELECT 구문 작성 형식 : 
실행순서
5 : SELECT & | 컬럼명 [AS] 별칭, 계산식, 계산식 [AS] 별칭
1 : FROM 조회에 사용할 테이블 명
2 : WHERE 컬럼명 비교연산자 비교값 (행단위로 골라냄)
3 : GROUP BY 컬럼명 | 계산식
4 : HAVING 그룹함수 비교연산자 비교값 (조건을 만족하는 그룹을 골라냄)
6 : ORDER BY 컬럼명 정렬기준, SELECT절의 나열된 순번 정렬기준, 별칭 [ASC] | [DESC] ;
*/

-- SELECT 절의 컬럼명 | 계산식 뒤에 별칭(ALIAS)를 사용할 수 있음
-- 컬럼명 AS 별칭, 계산식 AS 별칭
-- AS는 생략해도 됨 => 컬럼명 별칭, 계산식 별칭
-- 주의사항 : 
-- 별칭에 숫자, 공백, 기호가 포함되면 반드시 ""로 묶어야 함, "별칭"
-- 별칭 글자수 제한없음
-- 영어 별칭은 기본 대문자로 표시됨 => "소문자", "대소문자혼합" 따옴표 사용함

SELECT emp_id AS 사번, emp_name 이름, salary "급여(원)",
            bonus_pct "보너스 포인트",
            (salary + (salary * NVL(bonus_pct, 0))) * 12 "1년 소득"
FROM employee;

-- 리터럴 (LITERAL) : 문자열값
-- SLECT 절에 리터럴(문자열값) 사용할 수 있음
SELECT emp_id 사번, emp_name 이름, '재직' 근무상태
FROM employee;

-- DISTINCT
-- SELCT 절에 컬럼명 앞에 사용함
-- DISTINCT 컬럼면
-- SELECT 절에 한번만 사용할 수 있음
-- 컬럼에 중복 기록된 값을 한개만 선택하라는 의미임

-- 컬럼에 기록된 값의 종류를 파악할 때 사용하면 편리함
SELECT DISTINCT marriage
FROM employee;

SELECT DISTINCT dept_id
FROM employee
ORDER BY 1 ASC;

-- DISTINCT : 1번만 사용함
SELECT DISTINCT dept_id, DISTINCT job_id -- ERROR
FROM employee;

SELECT DISTINCT dept_id, job_id -- 두 컬럼값을 묶어서 하나의 값으로 보고 중복 판단
FROM employee;

-- 직원 중에서 관리자인 직원들만 조회
SELECT DISTINCT mgr_id
FROM employee
WHERE mgr_id IS NOT NULL
ORDER BY 1 ASC;

-- WHERE 절 ********************************************************************
/*
작동순서 : 
FROM 절이 작동되고 나서 WHERE절이 작동됨
=> 테이블을 찯아서, 테이블에 저장된 값들 중에 조건을 만족하는 값이 있는 행을 골라냄
WHERE 컬럼명 비교연산자 비교값
- 조건절이라고 함
- 비교연산자 : > (크냐, 초과), < (작으냐, 미만), >= (크거나 같으냐, 이상), <= (작거나 같으냐, 이하)
                    = (같으냐), != (같지 않느냐, ^=, <>)
                    IN, NOT IN, LIKE , NOT LIKE, BETWEEN AND, NOT BETWEEN AND
- 논리연산자 : AND, OR
*/

-- 직원 테이블에서 부서코드가 '90'인 직원 정보 조회
-- 모든 항목 조회
SELECT *
FROM employee
WHERE dept_id = '90'; -- 조건과 일치하는 값이 기록된 행(ROW)들을 골라냄

-- 직급코드가 'J7'인 직원 정보 조회
SELECT *
FROM employee
--WHERE job_id = 'J7';
WHERE job_id = 'j7'; -- 기록값은 대소문자 구분함, 기록형태 그대로 비교함

-- 직원 중 급여를 4백만보다 많이 받는 (4백만을 초과하는) 직원 명단 조회
SELECT emp_id 사번, emp_name 이름, salary 급여
FROM employee
WHERE salary > 4000000;

-- 90번 부서에 근무하는 직원 중 급여가 2백만을 초과하는 직원 정보 조회
-- 사번, 이름, 급여, 부서코드 : 별칭 정리
SELECT emp_id 사번, emp_name 이름, salary 급여 , dept_id 부서코드
FROM employee
WHERE dept_id = '90'
AND salary > 2000000; -- 결과행 : 3행

-- 90번 또는 20번 부서에 근무하는 직원 조회
-- 사번, 이름, 주민번호, 부서코드 : 별칭 정리
-- 부서코드로 오름차순 정렬 처리함
SELECT emp_id 사번, emp_name 이름, emp_no 주민번호, dept_id 
FROM employee
WHERE dept_id= '90' OR dept_id = '20'
ORDER BY dept_id ASC;

-- 연습 1 :
-- 급여가 2백만이상 4백만이하인 직원 조회
-- 사번, 이름, 급여, 직급코드, 부서코드 : 별칭정리 -- 결과행 : 16행

SELECT emp_id 사번, emp_name 이름, salary 급여, job_id 직급코드, dept_id 부서코드
FROM employee
WHERE salary > 2000000 AND salary < 4000000;

-- 연습 2 :
-- 입사일이 1995년 1월 1일 부터 2000년 12 월 31일 사이에 입사한 직원 조회
-- 사번, 이름, 입사일, 부서코드 : 별칭
-- 날짜 데이터는 기록된 날짜 포맷과 일치되게 작성함
-- 날짜 데이터는 작은 따옴표로 묶어서 표기함 : '1995/01/01' 또는 '95/01/01' -- 결과행 : 7행

SELECT emp_id 사번, emp_name 이름, hire_date 입사일, dept_id 부서코드
FROM employee
--WHERE hire_date >= '95/1/1' AND hire_date <= '00/12/31';
WHERE hire_date >= '1995/1/1' AND hire_date <= '2000/12/31';

-- 연결 연산자 : ||
-- 자바에서의 "HELLO" + " WORLD " => "HELLO WORLD"
-- SELECT 절에서 조회한 컬럼값들을 연결 처리로 하나의 문장을 만들 때 사용할 수 있음
-- WHERE 절에서 비교값 여러 개를 한개의 값으로 만들 때 사용하기도 함
SELECT emp_name || '의 직원 급여는 ' || salary || '원 입니다' AS 급여정보
FROM employee
WHERE dept_id = '90';

-- 연습 3 :
-- 2000년 1월 1일 이후에 입사한 기혼인 직원 조회
-- 이름, 입사일, 직급코드, 부서코드, 급여, 결혼여부 (별칭 처리)
-- 입사날짜 뒤에 '입사' 문자 연결 출력함
-- 급여값 뒤에는 '(원)' 문자 연결 출력함
-- 결혼여부는 리터럴 사용함 : '기혼'으로 채움

SELECT emp_name 이름, hire_date || '입사', job_id 직급코드, dept_id 부서코드, salary  || '(원)',  '기혼' 결혼여부
FROM employee
WHERE hire_date > '00/1/1' AND marriage = 'Y';





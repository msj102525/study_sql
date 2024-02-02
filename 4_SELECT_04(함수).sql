-- 4_SELECT_04(함수).sql

-- 오라클에서 제공하는 함수(function)
-- 다른 DBMS 에서도 사용이 비슷하거나 같음

-- 함수(FUNCTION)
-- 컬럼에 기록된 값을 읽어서 함수가 처리한 결과를 리턴하는 형태임
-- 사용 : 함수명(컬럼명)

-- 단일행 함수와 그룹 함수 구분됨 => 결과행의 갯수가 다름
-- 단일행 함수 (SINGLE ROW FUNCTION) : 
-- 지정한 컬럼의 값이 N개이면, 함수가 처리한 결과값도 N개가 리턴됨
-- 즉, 한 행(한 개)씩 다루는 함수

-- 그룹 함수 (GROUP FUNCTION) :
-- 읽은 값이 N개이면, 리턴하는 결과값은 1개임

-- 현재 데이터베이스는 관계형 데이터베이스(RDB)임
-- 데이터를 2차원 테이블(반드시 사각형)임 => 즉, 사각형이 아닌 결과는 출력 못 함

-- 단일행 함수와 그룹 함수를 구분해야 되는 이유 :
-- SELECT 절에 단일행함수와 그룹함수 함께 사용 못 함 => 에러남
-- WHERE 절에 그룹함수 사용 못 함 => 에러남

SELECT email, 
            UPPER(email) -- 22 행 : 단일행 함수
FROM employee;

SELECT SUM(salary) -- 1행 : 그룹함수
FROM employee;

-- SELECT 절에서 그룹함수와 단일행함수는 같이 사용 못 함
SELECT UPPER(email), SUM(salary) -- 결과행의 갯수가 다름
FROM employee;

-- 직원들 중에서 직원 전체 급여의 평균보다 많이 받는 직원 조회
SELECT *
FROM employee
WHERE salary > AVG(salary); -- 한 행씩 검사하는 조건절임, 에러

SELECT AVG(salary)
FROM employee; -- 급여의 평균 구함

SELECT *
FROM employee
WHERE salary > 2961818.18181818181818181818181818181818;

SELECT *
FROM employee
WHERE salary > (Select AVG(salary)
                        FROM employee);

-- 그룹 함수 *************************************************************************
-- SUM(), AVG(), MIN(), MAX(), COUNT()

-- SUM(컬럼명) | SUM(DISTINCT 컬럼명)
-- 합계를 구해서 리턴

-- 소속 부서가 50 이거나 부서가 배정되지 않은 직원들의 급여 합계 조회
SELECT SUM(salary) 급여합계,
            SUM(DISTINCT salary) "중복값 제외한 급여 합계"
FROM employee
WHERE dept_id = '50' OR dept_id IS NULL;

-- 사용된 값들 확인
SELECT dept_id, salary
FROM employee
WHERE dept_id = '50' OR dept_id IS NULL; -- 8행

-- AVG(컬럼명) | AVG(DISTINCT 컬럼명)
-- 평균을 구해서 리턴

-- 소속부서가 50 또는 90 또는 NULL인 직원들의 보너스포인트 평균 조회
SELECT AVG(bonus_pct), -- /4
            AVG(DISTINCT bonus_pct) -- /3
            , AVG(NVL(bonus_pct, 0)) -- /11
FROM employee
WHERE dept_id IN('50', '90') OR dept_id IS NULL;

-- 사용된 값 확인
SELECT dept_id, bonus_pct
FROM employee
WHERE dept_id IN('50', '90') OR dept_id IS NULL
ORDER BY 2;

-- MAX(컬럼명) | MAX(DISTINCT 컬럼명)
-- 가장 큰 값 리턴 (숫자, 날짜, 문자 모두 처리함)

-- MIN(컬럼명) | MIN(DISTINCT 컬럼명)
-- 가장 작은 값 리턴 (숫자, 날짜, 문자 모두 처리함)
-- 오라클 DATA TYPE : 테이블의 컬럼에 지정함
-- 문자형(CHAR, VARCHAR2, LONG, CLOB), 숫자형(NUMBER), 날짜형(DATE)

-- 부서코드가 50 또는 90인 직원들의
-- 직급코드(CHAR)의 최대값, 최소값
-- 입사일(DATE)의 최대값, 최소값
-- 급여(NUMBER)의 최대값, 최소값
SELECT MAX(job_id), MIN(job_id),
            MAX(hire_date), MIN(hire_date),
            MAX(salary), MIN(salary)
FROM employee
WHERE dept_id IN ('50', '90');

-- COUNT(*) | COUNT(컬럼명) | COUNT(DISTINCT 컬럼명)        
-- COUNT(*) : NULL을 포함한 전체 행 수
-- COUNT(컬럼명) : NULL을 제외한 행 수

-- 50번 부서 또는 부서코드가 NULL인 직원 조회
SELECT dept_id
FROM employee
WHERE dept_id = '50' OR dept_id IS NULL; -- 8행
        
SELECT COUNT(*), -- 전체 행 갯수 (NULL 포함)
            COUNT(dept_id), -- NULL 제외된 행 갯수
            COUNT(DISTINCT dept_id) -- 중복값 제외한 행 갯수
FROM employee
WHERE dept_id = '50' OR dept_id IS NULL; -- 8행

-- 단일행 함수***************************************************

-- 문자 처리 함수 ------------------------------------
-- LENGTH('문자리터럴') | LENGTH(문자가 기록된 컬럼명)
-- 글자 갯수 리턴

SELECT LENGTH('ORACLE'), LENGTH('오라클')
FROM dual;

SELECT email, LENGTH(email)
FROM employee;
                        
 -- LENGTHB('문자리터럴') | LENGTHB(문자가 기록된 컬럼명)
 -- 글자으 바이트 수를 리턴
 
 SELECT LENGTHB('ORACLE'), LENGTHB('오라클')
FROM dual;

SELECT email, LENGTHB(email)
FROM employee;
                        
-- INSTR('문자열리터럴' | 문자가 기록된 컬럼명, 찾을문자, 찾을 시작위치, 몇번째문자)
-- 찾을 문자의 위치 리턴 (앞에서 부터의 순번)
-- 데이터베이스는 시작값이 무조건 1부터임 (0이 아님)

-- 이메일에서 '@' 문자의 위치 조회
SELECT email, INSTR(email, '@')
FROM employee;

-- 이메일에서 '@' 문자 바로 뒤에 있는 'k' 문자의 위치를 조회
-- 단, 뒤에서 부터 검색함
SELECT email, INSTR(email, '@') + 1, INSTR(email, 'k', -1, 3)
FROM employee;

-- 함수 중첩 사용 가능
-- 이메일에서 '.' 문자 바로 뒤에 있는 'c'의 위치를 조회
-- 단 '.' 문자 바로 앞글자부터 검색을 시작하도록 함
SELECT email, INSTR(email, 'c', INSTR(email, '.') -1)
FROM employee;

-- LPAD('문자리터럴' | 문자가 기록된 컬럼명, 출력할 너비바이트, 남는 영역의 채울문자)
-- 채울 문자가 생락되면 기본값은 ' ' (공백문자)
-- LPAD() : 왼쪽 채우기, RPAD() : 오른쪽 채우기

SELECT email, LENGTH(email) 원본길이,
            LPAD(email, 20, '*') 왼쪽채우기결과,
            LENGTH(LPAD(email, 20, '*')) 결과길이
FROM employee;

SELECT email, LENGTH(email) 원본길이,
            RPAD(email, 20, '*') 왼쪽채우기결과,
            LENGTH(RPAD(email, 20, '*')) 결과길이
FROM employee;

-- LTRIM('문자리터럴' | '문자가 기록돈 컬럼명, '제거할 문자들 나열')
-- 왼쪽에 있는 문자들을 제거한 결과를 리턴
-- RTRIM() : 오른쪽에 있는 문자들을 제거한 결과 문자열을 리턴
SELECT '       123xyORACLExxyzz567   ',
            LTRIM('       123xyORACLExxyzz567   '),
            LTRIM('       123xyORACLExxyzz567   ', '  '),
            LTRIM('       123xyORACLExxyzz567   ', ' 0123456789'),
            LTRIM('       123xyORACLExxyzz567   ', ' xyz1234567')
FROM DUAL;

SELECT '       123xyORACLExxyzz567   ',
            RTRIM('       123xyORACLExxyzz567   '),
            RTRIM('       123xyORACLExxyzz567   ', '  '),
            RTRIM('       123xyORACLExxyzz567   ', ' 0123456789'),
            RTRIM('       123xyORACLExxyzz567   ', ' xyz1234567')
FROM DUAL;

-- TRIM(LENGTH | TRAILING | BOTH '제거할문자' FROM '문자리터럴' | 문자가 기록된 컬럼명)
-- 기본은 BOTH (앞뒤 모두 제거)
-- 제거할 문자 생략은 기본 ' '(공백문자)
SELECT 'aaORACLEaa',
            TRIM('a' FROM 'aaORACLEaa'),
            TRIM(LEADING 'a' FROM 'aaORACLEaa'),
            TRIM(TRAILING 'a' FROM 'aaORACLEaa'),
            TRIM(BOTH 'a' FROM 'aaORACLEaa')
FROM DUAL;

-- SUBSTR('문자리터럴' | 문자가 기록된 컬럼명, 추출할 시작위치, 추출할 글자 갯수)
-- 추출할 시작위치 : 양수(앞에서부터의 위치), 음수 (뒤에서부터의 위치)
-- 추추할 글자갯수 : 생략되면 끝 글자까지를 의미함

SELECT 'ORACLE 18C',
            SUBSTR('ORACLE 18C', 5),
            SUBSTR('ORACLE 18C', 8, 2),
            SUBSTR('ORACLE 18C', -7, 3)            
FROM DUAL;

-- 직원 정보의 주민번호에서 생년, 생월, 생일, 각각 분리 조회
SELECT emp_no 주민번호,
        SUBSTR(emp_no, 1, 2) 생년,
        SUBSTR(emp_no, 3, 2) 생월,
        SUBSTR(emp_no, 5, 2) 생일        
FROM employee;

-- 날짜 표기시에 문자처럼 '날짜'로 표기해야 함
-- '24/02/01' 표기함
-- SUBSTR() 은 날짜 데이터에도 사용할 수 있음

-- 직원들의 입사일에서 입사년도, 입사월, 입사일을 분리 조회
SELECT hire_date 입사일,
        SUBSTR(hire_date, 1, 2) 입사년도,
        SUBSTR(hire_date, 4, 2) 입사월,
        SUBSTR(hire_date, 7, 2) 입사일        
FROM employee;

-- SUBSTRB('문자리터럴 | 문자가 기록된 컬럼명, 추출할바이트위치, 추출할 바이트 크기)
SELECT 'ORACLE',
            SUBSTR('ORACLE', 3, 2), SUBSTRB('ORACLE', 3, 2),
            '오라클',
            SUBSTR('오라클', 2, 2), SUBSTR('오라클', 4, 6)
FROM DUAL;

-- UPPER('영문리터럴' | 영문자가 기록된 컬럼명) : 대문자로 바꾸는 함수
-- LOWER('영문리터럴' | 영문자가 기록된 컬럼명) : 소문자로 바꾸는 함수
-- INITCAP('영문리터럴' | 영문자가 기록된 컬럼명) : 첫글자만 대문자로 바꾸는함수

SELECT UPPER('ORACLE'), UPPER('oracle'), UPPER('Oracle'),
            LOWER('ORACLE'), LOWER('oracle'), LOWER('Oracle'),
            INITCAP('ORACLE'), INITCAP('oracle'), INITCAP('Oracle')
FROM DUAL;

-- 함수 중첩 사용 : 함수 안에 값 대신에 다른 함수를 사용할 수 있음
-- 안쪽 함수가 리턴한 값을 바깥 함수가 사용한다는 의미임

-- 예 : 직원 정보에서 사번, 이름, 아이디 조회
-- 아이디는 이메일에서 분리 추출함
SELECT emp_id 사번, emp_name 이름, email 이메일,
        SUBSTR(email,1, INSTR(email, '@') - 1) 아이디
FROM employee;

-- 예 : 직원 테이블에서 사번, 이름, 주민번호 조회
-- 주민번호는 생년월일만 보이게 하고 뒷자리는 '*' 처리함 : 891225-*******

SELECT emp_id 사번, emp_name 이름,
            RPAD(SUBSTR(emp_no, 1, 7), 14, '*') 주민번호
FROM employee;


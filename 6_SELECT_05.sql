-- 6_SELECT_05(형변환).sql

-- 타입(자료형) 변환 함수 ---------------------------------------------------------
-- 문자형(CHAR, VARCHAR2, LONG, CLOB), 숫자형(NUMBER), 날짜형(DATE)

-- 자동형변환 (암시적 형변환) 되는 경우
-- 컴퓨터 연산 원칙 : 같은 종류의 값끼리만 계산할 수 있다.
SELECT
    25 + '10' -- NUMBER + CHARACTER => NUMBER + NUMBER
FROM        -- CHARACTER 가 자동 NUMBER로 바뀜
    dual;

SELECT
    *
FROM
    employee
WHERE
    emp_id = 100; -- CHAR = NUMBER => CHAR = CHAR : 자동 형변환됨
                        -- 100 => '100' 로 변환되어서 비교 연산됨

SELECT
    months_between(sysdate, '00/12/31')
FROM                    -- DATE - CHARACTER => 자동형변환됨, DATE - DATE 
    dual; 

-- 자동형변환이 안 되는 경우가 있음
SELECT
    sysdate - '15/03/25'
FROM
    dual;

-- 명시적 형변환 필요함 => 형변환 함수 사용함
SELECT
    sysdate - TO_DATE('15/03/25')
FROM
    dual;

-- TO_CHAR() 함수 -----------------------------------------------
-- NUMBER(숫자 : 정수, 실수)나 DATE(날짜, 시간)에 대해 출력 포맷(FORMAT)을 설정하는 함수
-- 포맷이 적용된 문자열(CHARACTER)이 리턴됨
-- TO_CHAR(NUMBER, '적용할 포맷')
-- TO_CHAR(DATE, '적용할 포맷')
-- FORMAT은 출력 형태를 원하는 모양대로 마음대로 정하면 됨

-- 숫자에 포맷 적용
-- TO_CHAR(숫자 | 숫자가 기록된 컬럼명 | 계산식, '적용할 포맷문자들')
-- 주로 통화단위 표시(L), 천단위 구분자 표시(,), 소숫점 자릿수 지정(.), 지수형 표시(EEEE) 등
SELECT
    emp_name                       이름,
    to_char(salary, 'L99,999,999') 급여,
    to_char(nvl(bonus_pct, 0),
            '90.00')               보너스포인트
FROM
    employee;
    
-- 날짜에 포맷 적용
-- TO_CHAR(TO_DATE('날짜문자열') | 날짜가 기록된 컬럼명 | DATE 반환함수, '적용할 포맷문자들')
-- 년월일 시분초 요일 분기 등을 출력 형식으로 지정할 수 있음

-- 년도 출력 포맷
SELECT
    sysdate, -- NLS_DATE_FORMAT : 'RR/MM/DD'
    to_char(sysdate, 'yyyy'),
    to_char(sysdate, 'rrrr'),
    to_char(sysdate, 'yy'),
    to_char(sysdate, 'rr'),
    to_char(sysdate, 'year'),
    to_char(sysdate, 'rrrr"년"')
FROM
    dual;
    
    -- 월 출력 포맷
SELECT
    sysdate, -- NLS_DATE_FORMAT : 'RR/MM/DD'
    to_char(sysdate, 'mm'),
    to_char(sysdate, 'rm'),
    to_char(sysdate, 'month'),
    to_char(sysdate, 'mon'),
    to_char(sysdate, 'yyyy"년" fmmm"월"'),
    to_char(sysdate, 'rrrr"년" mm"월"')
FROM
    dual;
    
-- 날짜 출력 포맷
SELECT
    sysdate, -- NLS_DATE_FORMAT : 'RR/MM/DD'
    to_char(sysdate, '"1년 기준" ddd'),
    to_char(sysdate, '"월 기준" dd'),
    to_char(sysdate, '"주 기준" d'),
    to_char(sysdate, 'fmdd')
FROM
    dual;

-- 분기, 요일 포맷
SELECT
    sysdate, -- NLS_DATE_FORMAT : 'RR/MM/DD'
    to_char(sysdate, 'q "사분기"'),
    to_char(sysdate, 'day'),
    to_char(sysdate, 'dy')
FROM
    dual;

-- 시분초 오전 | 오후 포맷
SELECT
    sysdate, -- NLS_DATE_FORMAT : 'RR/MM/DD'
    to_char(sysdate, 'hh24"시" mi"분" ss"초"'),
    to_char(sysdate, 'am hh:mi:ss'),
    to_char(sysdate, 'pm hh24:mi:ss')
FROM
    dual;
    
-- 직원 정보에서 이름, 입사일 조회
-- 입사일에 포멧 적용 : 2024년 2월 2일(금) 입사
SELECT
    emp_name                                                이름,
    to_char(hire_date, 'yyyy"년" fmmm"월" fmdd"일 ("dy") 입사"') 입사일,
    to_char(hire_date, 'RRRR"년" mon fmdd"일 ("dy") 입사"')     입사일
FROM
    employee;

-- 날짜 데이터 비교연산시 주의사항 :
-- 날짜만 가진 데이터와 시간을 가진 데이터 비교시, 두 데이터는 equal 이 아님
-- '24/02/02' = '24/02/02 14:29:30' : false
-- 확인
SELECT
    emp_name                                     이름,
    to_char(hire_date, 'yyyy-mm-dd am hh:mi:ss') 입사일,
    to_char(hire_date, 'yyyy-mm-dd hh24:mi:ss')  입사일
FROM
    employee;
-- 한선기만 시간 데이터를 가지고 있음. 다른 직원들은 시간 데이터가 없음

-- 날짜와 시간이 같이 기록되어 있는 경우는 비교연산시 날짜만 비교할 수 없음
SELECT
    emp_name,
    hire_date
FROM
    employee
WHERE
    hire_date = '90/04/01'; -- 0행
-- '2090-04-01 13:30:30' = '2090-04-01' " 같지 않다.

-- 해결 방법 1 : 날짜데이터에 포맷을 적영
SELECT
    emp_name,
    hire_date
FROM
    employee
WHERE
    to_char(hire_date, 'rr/mm/dd') = '90/04/01';

-- 해결 방법 2 : LIKE 연산자 사용
SELECT
    emp_name,
    hire_date
FROM
    employee
WHERE
    hire_date LIKE '90/04/01';

-- 해결 방법 3 : substr 사용
SELECT
    emp_name,
    hire_date
FROM
    employee
WHERE
    substr(hire_date, 1, 8) = '90/04/01';

-- 해결 방법 4 : 날짜 뺴기 연산 사용
SELECT
    emp_name,
    hire_date
FROM
    employee
WHERE
    floor(hire_date - TO_DATE('2090/04/01')) = 0;

SELECT
    floor(hire_date - TO_DATE('90/04/01'))
FROM
    employee;
    
-- 해결 방법 5: 비교값 날짜데이터를 바꿈
SELECT
    emp_name,
    hire_date
FROM
    employee
WHERE
    hire_date = TO_DATE('90/04/01 13:30:30', 'yy/mm/dd hh24:mi:ss');

-- TO_DATE() 함수 ----------------------------------------------------
-- TO_DATE('문자리터럴' | 문자가 기록된 컬럼명, '각문자와 매칭할 포맷들')
-- 문자 글자수와 포맷문자수가 반드시 같아야 함
-- to_char()의 포맷과 의미가 다름

SELECT
    TO_DATE('20161225', 'rrrrmmdd'),
    to_char(TO_DATE('20161225', 'rrrrmmdd'), 'dy')
FROM
    dual;

-- RR 와 YY의 차이
-- 두자리 년도를 네자리 년도로 바꿀 때
-- 현재 년도가 (24 : 50보다 작음) 일 때
-- 바꿀 년도가 50미만이면 현재 세기(2000)가 적용 : '14'이면 'RRRR' => 2014가 됨
-- 바꿀 년도가 50이상이면 이전 세기(1900)가 적영 : '90'이면 'RRRR' => 1990이 됨

SELECT
    hire_date,  -- 년도 두자리
    to_char(hire_date, 'rrrr'),
    to_char(hire_date, 'yyyy')
FROM
    employee; -- 년도를 2자리에서 네자리로 바꿀 때 Y, R 아무거나 사용

-- 현재 년도(24년)와 바꿀 년도가 둘 다 50미만이면, y | r 아무거나 사용해도 됨
SELECT
    TO_DATE('160505', 'yymmdd'),
    to_char(TO_DATE('160505', 'yymmdd'), 'yyyy-mm-dd'),
    to_char(TO_DATE('160505', 'rrmmdd'), 'rrrr-mm-dd'),
    to_char(TO_DATE('160505', 'rrmmdd'), 'yyyy-mm-dd'),
    to_char(TO_DATE('160505', 'yymmdd'), 'rrrr-mm-dd')
FROM
    dual;
    
-- 현재 년도가 50미만이고, 바꿀 년도가 50이사일 때
-- 문자를 날짜로 바꿀 때 년도를 y 사용 : 현재 세기(2000) 적용됨
-- r 사용시 : 이전 세기(1900) 적용 됨
SELECT
    TO_DATE('970320', 'yymmdd'),
    to_char(TO_DATE('970320', 'yymmdd'), 'yyyy-mm-dd'), -- 2097
    to_char(TO_DATE('970320', 'rrmmdd'), 'rrrr-mm-dd'), -- 1997
    to_char(TO_DATE('970320', 'rrmmdd'), 'yyyy-mm-dd'), -- 1997
    to_char(TO_DATE('970320', 'yymmdd'), 'rrrr-mm-dd') -- 2097
FROM
    dual;
    
-- 결론 : 문자를 to_date() 함수로 날짜로 바꿀 때 년도에 'R' 사용하면 됨
-- 년도 2자리를 4자리로 바꿀 때는 Y, R 아무거나 사용해도 됨

-- 기타 함수 --------------------------------------------------------------

-- NVL() 함수
-- 사용형식 : NVL(컬럼명, 컬럼값이 NULL 일 때 바꿀 값)
SELECT
    emp_name,
    bonus_pct,
    dept_id,
    job_id
FROM
    employee;

SELECT
    emp_name,
    nvl(bonus_pct, 0.0),
    nvl(dept_id, '00'),
    nvl(job_id, 'J0')
FROM
    employee;

-- NVL2() 함수
-- 사용형식 : NVL2(컬럼명, 바꿀값1, 바꿀값2)
-- 해당 컬럼에 값이 있으면 바꿀값 1로 바꾸고, NULL이면 바꿀값2로 변경함

-- 직원 정보에서 보너스포인트가 0.2미만이거나 NULL인 직원들 조회
-- 사번, 이름, 보너스포인트, 변경보너스포인트 : 별칭 처리
-- 변경보너스 포인트 : 보너스포인트값이 있으면 0.15로 바꾸고, NULL이면 0.05로 바꿈

SELECT
    emp_id                      사번,
    emp_name                    이름,
    bonus_pct                   보너스포인트,
    nvl2(bonus_pct, 0.15, 0.05) 변경보너스포인트
FROM
    employee
WHERE
    bonus_pct < 0.2
    OR bonus_pct IS NULL;

-- DECODE 함수
/*
사용형식 : 
DECODE(계산식 | 컬럼명, 값제시, 값이 맞으면 선택할 값, ..., 값제시N, 선택값N)
또는
DECODE(계산식 | 컬럼명, 값제시, 값이 맞으면 선택할 값, ..., 값제시N, 선택값N, 모든값이 아닐때 선택할값)

자바의 SWITCH 문의 동작구조를 가지는 함수임
*/

-- 50번 부서에 근무하는 직원들의 이름과 성별 조회
-- 성별 기준 : 주민번호 8번째 값이 1 | 3이면 남자, 2 | 4 이면 여자
-- 성별 기준 : 오름차순정렬하고, 같은 성별은 이름 기준 오름차순 정렬 함
SELECT
    emp_name     이름,
    decode(substr(emp_no, 8, 1),
           '1',
           '남자',
           '3',
           '남자',
           '2',
           '여자',
           '4',
           '여자') 성별
FROM
    employee
WHERE
    dept_id = '50'
ORDER BY
    성별,
    이름;

SELECT
    emp_name     이름,
    decode(substr(emp_no, 8, 1),
           '1',
           '남자',
           '3',
           '남자',
           '여자') 성별
FROM
    employee
WHERE
    dept_id = '50'
ORDER BY
    2,
    1; -- SELECT 절에 나열된항목의 순번 또는 별칭을 사용해도 됨
    
-- 직원 이름과 관리자 사번 조회
SELECT
    emp_name,
    mgr_id
FROM
    employee;

-- 관리자사번이 NULL이면 '000'으로 바꿈
-- 1. NVL() 사용
SELECT
    emp_name,
    mgr_id,
    nvl(mgr_id, '000')
FROM
    employee;

-- 2. DECODE() 사용
SELECT
    emp_name,
    mgr_id,
    decode(mgr_id, NULL, '000', mgr_id)
FROM
    employee;
    
-- 직급별 급여 인상분이 다를 때
-- 1. DECODE() 사용한 경우
SELECT
    emp_name,
    job_id,
    to_char(salary, 'L99,999,999'),
    to_char(decode(job_id, 'J7', salary * 1.1, 'J6', salary * 1.15,
                   'J5', salary * 1.2, salary * 1.05),
            'L99,999,999') 인상급여
FROM
    employee;
    
-- 2. CASE() 표션식 사용한 경우 : 다중 IF문과 같은 동작 구조를 가짐
SELECT
    emp_name,
    job_id,
    to_char(salary, 'L99,999,999'),
    to_char(
        CASE job_id
            WHEN 'J7' THEN
                salary * 1.1
            WHEN 'J6' THEN
                salary * 1.15
            WHEN 'J5' THEN
                salary * 1.2
            ELSE
                salary * 1.05
        END, 'L99,999,999') 인상급여
FROM
    employee;

-- CASE 표현식 사용 2 :
-- 직원의 급여를 등급을 매겨서 구분 처리
SELECT
    emp_id,
    emp_name,
    salary,
    CASE
        WHEN salary <= 3000000 THEN
            '초급'
        WHEN salary <= 4000000 THEN
            '중급'
        ELSE
            '고급'
    END 구분
FROM
    employee
ORDER BY
    구분;

-- ********************************************************************************************
-- OREDER BY 절
/*
사용형식 : 
        ORDER BY 정렬기준 정렬방식, 정렬기준2 정렬방식, .......
사용위치 : SELECT 구문 가장 마지막에 작성함
실행순서 : 가장 마지막에 작동됨

정렬기준 : SELECT 절의 컬럼명, 별칭, SELECT 절에 나열된 항목의 순번(1, 2, 3, ..)
정렬방식 : ASC(생략가능) | DESC
        - ASCending : 오름차순정렬, DESCending : 내림차순정렬
*/

-- 직원 정보에서 부서코드가 50 또는 NULL인 직원들을 조회
-- 이름, 급여
-- 급여기준 내림차순정렬하고, 같은 급여는 이름기준 오름차순정렬 처리함
SELECT
    emp_name 이름,
    salary   급여
FROM
    employee
WHERE
    dept_id = '50'
    OR dept_id IS NULL
--ORDER BY salary DESC, emp_name;
--ORDER BY 급여, 이름;
ORDER BY
    2 DESC,
    1;

-- 2003년 1월 1일 이후 입사한 직원 명단 조회
-- 단, 해당 날짜는 제외함
-- 이름, 입사일 ,부서코드, 급여 : 별칭
-- 부서코드 기준 내림차순정렬하고, 같은 부서코드에 대해서는 입사일 기준 오름차순정렬하고,
-- 입사일도 같으면 이름 기준 오름차순정려 처리함
SELECT
    emp_name  이름,
    hire_date 입사일,
    dept_id   부서코드,
    salary    급여
FROM
    employee
WHERE
    hire_date > TO_DATE('20030101', 'rrrrmmdd')
--ORDER BY dept_id DESC NULLS LAST, hire_date;
--ORDER BY 부서코드 DESC NULLS LAST, 입사일, 이름;
ORDER BY
    3 DESC NULLS LAST,
    2,
    1;

-- ORDER BY 절의 NULL 위치 조정 구문 :
-- ORDER BY 정렬기준 정렬방식 NULLS LAST : NULL을 아래쪽에 배치함
-- ORDER BY 정렬기준 정렬방식 NULLS FIRST : NULL을 위쪽에 배치함(기본)

-- GROUP BY 절 --------------------------------------------------------------
-- 같은 값들이 여러 개 기록된 컬럼을 가지고 같은 값들을 그룹으로 묶어줌
-- GROUP BY 컬럼명 | 컬럼이 사용된 계산식
-- 같은 값들을 그룹으로 묶어서 그룹함수를 사용함
-- SELECT 절에 GRUOP BY 로 묶은 그룹별 그룹함수 사용 구문을 작성함

SELECT DISTINCT
    dept_id
FROM
    employee
ORDER BY
    1;

-- 부서별 급여의 합계 조회
SELECT
    dept_id,
    SUM(salary)
FROM
    employee
GROUP BY
    dept_id;

SELECT
    dept_id,
    SUM(salary)        부서별급여합계,
    floor(AVG(salary)) 부서별급여평균,
    COUNT(salary)      부서별직원수,
    MAX(salary)        부서별급여큰값,
    MIN(salary)        부서별급여작은값
FROM
    employee
GROUP BY
    dept_id
ORDER BY
    1 DESC NULLS LAST;
    
-- GROUP BY 절에는 그룹으로 묶기위한 계산식을 사용할 수도 있음'
-- 직원 정보에서 성별별 급여합계, 급여평균(천단위에서 반올림함), 직원수 조회
-- 성별로 오름차순정렬함
SELECT
    decode(substr(emp_no, 8 ,1), '1', '남', '3', '남', '여') 성별,
    sum(salary) 급여합계,
    ROUND(AVG(salary), -4) 급여평균,
    count(*) 직원수
FROM
    employee
GROUP BY
    decode(substr(emp_no, 8 ,1), '1', '남', '3', '남', '여')
ORDER BY 성별;

-- GROUP BY 관련 함수 ------------------------------------------

-- ROLLUP() 함수
-- GROUP BY 절에서 사용됨
-- 그룹별로 묶어서 계산한 결과에 대한 집계와 총집계를 표현하는 함수
-- 엑셀의 부분합과 같음. 소계 처리

-- 확인
SELECT
    dept_id,
    SUM(salary)
FROM
    employee
GROUP BY
    dept_id;

-- NULL 제외
SELECT
    dept_id,
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL
GROUP BY
    dept_id;

-- ROLLUP()
SELECT
    dept_id,
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL
GROUP BY
    ROLLUP(dept_id);

-- 총집계 확인
SELECT
    dept_id,
    SUM(salary),
    FLOOR(AVG(salary)),
    COUNT(salary),
    MIN(salary),
    MAX(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL
GROUP BY
    ROLLUP(dept_id);

-- 연습 : 부서코드와 직급코드를 함께 그룹을 묶고, 급여의 합계를 구함
-- NULL은 제외함, ROLLUP() 사용
SELECT
    dept_id,
    job_id,
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL AND job_id IS NOT NULL
GROUP BY
    dept_id, job_id
ORDER BY
    1 desc;

SELECT
    dept_id,
    job_id,
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL AND job_id IS NOT NULL
GROUP BY
    ROLLUP(dept_id, job_id)
ORDER BY
    1 desc;

SELECT
    dept_id,
    job_id,
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL AND job_id IS NOT NULL
GROUP BY
    ROLLUP(dept_id), ROLLUP(job_id)
ORDER BY
    1 desc;
    
SELECT
    dept_id,
    job_id,
    SUM(salary)
FROM
    employee
WHERE
    dept_id IS NOT NULL AND job_id IS NOT NULL
GROUP BY
    ROLLUP(job_id), ROLLUP(dept_id)
ORDER BY
    1 desc;

-- CUBE() 함수
SELECT
    dept_id,
    job_id,
    SUM(salary)    
FROM
    employee
WHERE
    dept_id IS NOT NULL AND job_id IS NOT NULL
GROUP BY
    CUBE(dept_id, job_id)
ORDER BY
    1 desc;
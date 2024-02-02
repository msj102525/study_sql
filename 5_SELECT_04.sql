-- 5_SELECT_04.sql

-- 숫자 처리 함수 ---------------------------------------------
-- ROUND(), TRUNC(), FLOOR(), ABS(), MOD()

-- ROUND(숫자 | 숫자가 기록된 컬럼면 | 계산식, 반올림할 자릿수)
-- 버려지는 값이 6이상이면 자동 반올림됨
-- 반올림할 자릿수가 양수이면, 소숫점 아래 표기(출력)할 자리를 의미함
-- 반올림할 자릿수가 음수이면, 소숫점 앞(정수부) 올림할 자리를 의미함

SELECT
    123.456,
    round(123.456), -- 123 : 자릿수 생략되면 기본값 0 임 (소숫점 위치임)
    round(123.456, 0), -- 123
    round(123.456, 1), -- 123.5
    round(123.456, - 1) -- 120
FROM
    dual;

-- 직원 정보에서 사번, 이름, 급여, 보너스포인트, 보너스포인트 적용 연봉
-- 연봉은 별칭 처리 : 1년급여
-- 연봉은 천단위에서 반올림 처리함
SELECT
    emp_id     사번,
    emp_name   이름,
    salary     급여,
    bonus_pct  보너스포인트,
    round(((salary +(salary * nvl(bonus_pct, 0))) * 12),
          - 4) "1년급여"
FROM
    employee;
    
-- TRUNC(숫자 | 숫자가 기록된 컬럼명 | 계산식, 자를 자릿수)
-- 지정한 자리 아래의 값을 버림, 절삭 함수, 반올림 없음
SELECT
    145.678,
    trunc(145.678), -- 145
    trunc(145.567, 0), -- 145
    trunc(145.678, 1), -- 145.6
    trunc(145.678, - 1), -- 140
    trunc(145.678, - 3) -- 0
FROM
    dual;

-- 직원 정보에서 급여의 평균을 조회
-- 10단위에서 절삭함
SELECT
    AVG(salary),
    trunc(AVG(salary),
          - 2)
FROM
    employee;

-- FLOOR(숫자 | 숫자가 기록된 컬럼명 | 계산식)
-- 정수 만들기 함수 (소숫점 아래값 버림)
SELECT
    round(123.5),
    trunc(123.5),
    floor(123.5)
FROM
    dual;
    
-- ABS(숫자 | 숫자기 기록된 컬럼명 | 계산식)
-- 절대값 리턴(양수, 0 : 값 그대로, 음수 : 양수로 바꿈)
SELECT
    abs(23),
    abs(- 23)
FROM
    dual;
    
-- 직원 정보에서 입사일 - 오늘, 오늘 - 입사일 조회
-- 별칭 : 근무일수
-- 오늘 날짜 조회 함수 : SYSDATE
-- 근무일수는 모두 양수로 처리함
SELECT
    emp_name,
    hire_date - sysdate,
    sysdate - hire_date,
    abs(floor(hire_date - sysdate)) 근무일수,
    floor(abs(sysdate - hire_date)) 근무일수
FROM
    employee;
    
-- MOD(나눌 값, 나눌 수)    
-- 나누기한 나머지를 리턴함
-- 데이터베이스에서는 % (MOD) 연산자 사용 못 함
SELECT
    floor(25 / 7) 몫,
    mod(25, 7)    나머지
FROM
    dual;
    
-- 직원 정보에서 사번이 홀수인 직원 조회
-- 사번, 이름
SELECT
    emp_id   사번,
    emp_name 이름
FROM
    c##student.employee -- 정식 표기 : 사용자계정.테이블객체명 => 사용자계정은 생략 가능
WHERE
    mod(emp_id, 2) = 1;
-- '101' => 숫자 101 자동형변환되어서 사용되었음

-- 날짜 처리 함수 ------------------------------------------------------------------------

-- SYSDATE 함수
-- 시스템으로 부터 현재 날짜와 시간을 조회할 때 사용
SELECT
    sysdate
FROM
    dual; -- 출력되는 날짜 형식(FORMAT) : 24/02/02 (RR/MM/DD)
    
-- 오라클에서는 환경설정, 객체 관련 정보들을 모두 저장 관리하고 있음
-- 데이터 딕셔너리 (데이터 사전) 형태로 관리하고 있음
-- 데이터 딕셔너리 영역에 테이블 형태로 각 정보들을 저장 관리하고 있음
-- 데이터 딕셔너리는 DB 시스템이 관리함. 사용자는 손댈 수 없음
-- 저장된 정보는 조회해 볼 수는 있음

-- 단, 환경설정과 관련된 PARAMETER(변수) 정보는 일부 변경할 수는 있음
SELECT
    *
FROM
    sys.nls_session_parameters;

-- 날짜 포맷과 관련된 변수 값만 조회한다면
SELECT
    value
FROM
    sys.nls_session_parameters
WHERE
    parameter = 'NLS_DATE_FORMAT';

-- 날짜 포맷을 수정한다면
ALTER SESSION SET nls_date_format = 'DD-MON-RR';

-- 확인
SELECT
    sysdate
FROM
    dual;

-- 원래 포맷으로 변경
ALTER SESSION SET nls_date_format = 'RR/MM/DD';

-- ADD_MONTHS('날짜' | 날짜가 기록된 컬럼명, 더할 개월수)
-- 더한 개월수에 대한 날짜가 리턴됨

-- 오늘 날짜에서 6개월 뒤 날짜는?
SELECT
    add_months(sysdate, 6)
FROM
    dual;
    
-- 직원 정보에서 입사일로 부터 20년된 날짜 조회
-- 사번, 이름, 입사일, 20년된 날짜 (별칭)
SELECT
    emp_id    사번,
    emp_name  이름,
    hire_date 입사일,
    add_months(hire_date, 240)
FROM
    employee;

-- 단일행 함수는 WHERE 절에서 사용할 수 있음
-- 직원들 중에서 근무년수가 20년이상된 직원 명단 조회
-- 사번, 이름, 부서코드, 직급코드, 입사일, 근무년수 (별칭)
-- 근무년수 기준 내림차순정렬 처리함
SELECT
    emp_id                             사번,
    emp_name                           이름,
    dept_id                            부서코드,
    job_id                             직급코드,
    hire_date                          입사일,
    floor((sysdate - hire_date) / 365) 근무년수
FROM
    employee
WHERE
    add_months(hire_date, 240) <= sysdate
ORDER BY
    근무년수 DESC;
    
-- MONTHS_BETWEEN(DATE1, DATE2)
-- '날짜' | 날짜가 기록된 컬럼며 | 날짜함수 사용할 수 있음
-- 두 날짜의 차이나는 개월수를 리턴함

-- 직원들의 이름, 입사일, 현재까지의 근무일수, 근무개월수, 근무년수 조회
-- 정수형으로 출력 처리함
SELECT
    emp_name                                       이름,
    hire_date                                      입사일,
    floor(sysdate - hire_date)                     근무일수,
    floor(months_between(sysdate, hire_date))      근무개월수,
    floor(months_between(sysdate, hire_date) / 12) 근무년수
FROM
    employee;
    
-- NEXT_DAY('날짜' | 날짜가 기록된 컬럼명, '요일이름')
-- 지정한 날짜 뒤쪽 날짜에서 가장 가까운 지정 요일의 날짜를 리턴함
-- 현재 DBMS의 사용 언어가 'KOREAN' 이므로, 요일이름은 한글로 써야 함
-- 영어 요일이름 사용하면 에러남
SELECT
    sysdate,
    next_day(sysdate, '일요일')
FROM
    dual;

SELECT
    sysdate,
    next_day(sysdate, 'SUNDAY') -- 영어 요일이름 사용시 에러 발생함
FROM
    dual;

-- 환경설정 변수의 언어를 변경해 봄
ALTER SESSION SET nls_language = american;

-- 원상 복구함
ALTER SESSION SET nls_language = korean;

-- LAST_DAY('날짜' | 날짜가 기록된 컬럼명)
-- 지정한 날짜의 월에 대한 맏막 날짜를 리턴함
SELECT
    sysdate,
    last_day(sysdate),
    '24/07/01',
    last_day('24/07/01')
FROM
    dual;
    
-- 직원 정보에서 이름, 입사일, 입사한 달의 근무일수 조회
-- 주말 포함 일수
SELECT
    emp_name                        이름,
    hire_date                       입사일,
    last_day(hire_date) - hire_date "입사 첫달 근무일수"
FROM
    employee;
    
-- 현재 날짜와 시간을 조회하려면 
SELECT
    sysdate,
    systimestamp,
    current_date,
    current_timestamp
FROM
    dual;

-- EXTRACT(추출할 정보 FROM 날짜)
-- 날짜 데이터에서 원하는 정보만 추출함
-- 추출할 정보 : YEAR, MONTH, DAY, HOUR, MINUTE, SECOND

-- 오늘 날짜에서 년, 월, 일 따로 추출
SELECT
    sysdate,
    EXTRACT(YEAR FROM sysdate),
    EXTRACT(MONTH FROM sysdate),
    EXTRACT(DAY FROM sysdate)
FROM
    dual;
    
-- 직원들의 이름, 입사일, 근무년수 조회
SELECT
    emp_name 이름,
    hire_date 입사일,
    EXTRACT(YEAR FROM sysdate) - EXTRACT(YEAR FROM hire_date) 근무년수
FROM
    employee;
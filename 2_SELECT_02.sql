-- 3_ SELECT_02.sql

-- 비교연산자 ***************************************************

-- BETWEEN AND 연산자
-- WHERE 컬럼명 BETWEEN 작은값 AND 큰값
-- 컬럼에 기록된 값이 작은 값 이상이면서 큰 값 이하인 값이라는 의미임
-- WHERE 컬럼명 >= 작은 값 AND 컬럼명 <= 큰 값과 같음

-- 직원 중에서 급여를 2백만 이상 4백만 이하 범위 안의 급여를 받는 직원 조회
-- 사번, 이름, 급여, 직급코드, 부서코드 : 별칭 -- 16행
SELECT emp_id 사번, emp_name 이름, salary 급여, job_id 직급코드, dept_id 부서코드
FROM employee
--WHERE salary >= 2000000 AND salary <= 4000000;
WHERE salary BETWEEN 2000000 AND 4000000;

-- 날짜 데이터에도 사용할 수 있음
-- 직원의 입사일이 95년 1월 1일부터 2000년 12월 31일 범위에 해당되는 직원 정보 조회
-- 사번, 이름, 입사일, 부서코드 : 별칭
SELECT emp_id 사번, emp_name 이름, hire_date 입사일, dept_id 부서코드
FROM employee
--WHERE hire_date BETWEEN '95/01/01' AND '00/12/31';
WHERE hire_date >= '95/01/01' AND hire_date <= '00/12/01';


-- LIKE 연산자
-- 와일드카드 문자(%, _)를 이용해서 문자패턴을 설정함
-- 컬럼에 기록된 값이 제시된 문자패턴과 일치하는 값들을 골라낼 때 사용함
-- WHERE 컬럼명 LIKE '문자패턴'
-- % : 0개 이상의 글자들, _ : 글자 한자리

-- 성이 '김'씨인 직원 조회
-- 사번, 이름, 전화번호, 이메일 : 별칭 -- 3행
SELECT emp_id 사번, emp_name, phone 전화번호, email 이메일
FROM employee
WHERE emp_name LIKE '김%';

-- 성이 '김'씨가 아닌 직원 조회 -- 19행
SELECT emp_id 사번, emp_name, phone 전화번호, email 이메일
FROM employee
--WHERE emp_name NOT LIKE '김%';
WHERE NOT emp_name LIKE '김%';

-- 직원들의 이름에 '혜'자가 들어있는 직원 조회 -- 1행
SELECT emp_id 사번, emp_name, phone 전화번호, email 이메일
FROM employee
WHERE emp_name LIKE '%해%';

-- 전화번호의 국번이 4자리이면서 9로 시작하는 번호를 가진 직원 조회
-- 이름, 전화번호
SELECT emp_name, phone 전화번호
FROM employee
--WHERE phone LIKE '___9_______'; -- 2행
WHERE phone LIKE '___9%'; -- 3행 : 국번의 시작값이 9인 전화번호만 고름

-- 성별이 여자인 직원 조회
-- 사번, 이름, 주민번호, 전화번호 : 별칭
-- 주민번호 8번째 글자가 1이면 남자, 2이면 여자임
SELECT emp_id 사번, emp_name 이름, emp_no 주민번호, phone 전화번호
FROM employee
WHERE emp_no LIKE '_______2%'; -- 8행

-- 남자 직원 조회
SELECT emp_id 사번, emp_name 이름, emp_no 주민번호, phone 전화번호
FROM employee
--WHERE emp_no NOT LIKE '_______2%'; -- 14행
WHERE emp_no LIKE '_______1%'; -- 14행

-- LIKE 연산 사용시에 컬럼에 기록된 기호문자(_, %)와 와일드카드 문자를 구분할 필요가 있는 경우가 있음
-- 예 : 이메일에 아이디 값에 '_' 문자가 포함되어 있음
-- ESCAPE OPTION을 사용해서 기록된 기호문자를 구분해 줌
-- 구분자로 사용할 기호는 임의대로 정하면 됨
-- 기록된 문자 바로 앞에 표시함

-- 이메일에서 기록된 '_' 문자 앞글자가 3글자인 직원 조회
SELECT emp_name, email
FROM employee
WHERE email LIKE '___+_%' ESCAPE '+'; -- 1행

-- IS NULL / IS NOT NULL
-- WHERE 컬럼명 IS NULL : 컬럼 칸이 비어 있는가
-- WHERE 컬럼명 IS NOT NULL : 컬럼 칸이 비어 있지 않는가 (값이 있는가)
-- 주의 : 컬럼명 = NULL 에러임

-- 부서도 직급도 배정받지 못한 직원 조회
-- 사번, 이름, 직급코드, 부서코드
SELECT emp_id, emp_name, job_id, dept_id
FROM employee
WHERE dept_id IS NULL
AND job_id IS NULL; -- 1행

-- 보너스포인트가 없는 직원 조회
-- 사번, 이름, 부서코드, 보너스포인트
SELECT emp_id, emp_name, dept_id, bonus_pct
FROM employee
WHERE bonus_pct IS NULL -- 14행
OR bonus_pct = 0.0; -- 14행

-- 보너스를 받는 직원
SELECT emp_id, emp_name, dept_id, bonus_pct
FROM employee
WHERE bonus_pct IS NOT NULL -- 8행
AND bonus_pct != 0.0; -- 8행

-- 부서는 배정받지 않았는데, 관리자가 있는 직원 조회
-- 사번, 이름, 관리자사번, 부서코드
SELECT emp_id, emp_name, mgr_id, dept_id
FROM employee
WHERE dept_id IS NULL
AND mgr_id IS NOT NULL; -- 0행

-- 부서도 없고 관리자도 없는 직원 조회
SELECT emp_id, emp_name, mgr_id, dept_id
FROM employee
WHERE dept_id IS NULL
AND mgr_id IS NULL;

-- 부서는 없는데, 보너스포인트 받는 직원 조회
-- 사번, 이름, 보너스포인트, 부서코드
SELECT emp_id, emp_name, bonus_pct, dept_id
FROM employee
WHERE dept_id IS NULL AND bonus_pct IS NOT NULL;

-- IN 연산자
-- WHERE 컬럼명 IN (비교값, 비교값, ...)
-- WHERE 컬럼명 = 비교값1 OR 컬럼명 = 비교값2 OR .....

-- 20번 부서 또는 90번 부서에 근무하는 직원 조회
SELECT *
FROM employee
--WHERE dept_id = '20' OR dept_id = '90'; -- 6행
WHERE dept_id IN ('20', '90'); -- 6행

-- 연산자 우선 순위에 따라 조건 계산이 적용됨
-- 60, 90번 부서에 소속된 직원들 중에서 급요를 3백만보다 많이 받는 직원 조회
SELECT emp_id, dept_id, salary
FROM employee
WHERE dept_id = '60' OR dept_id = '90' AND salary >= 3000000; -- 6행
-- AND가 OR 보다 우선 순위가 높음

-- 해결1 : 먼저 계산할 부분을 ()로 묶음
SELECT emp_id, dept_id, salary
FROM employee
WHERE (dept_id = '60' OR dept_id = '90') AND salary >= 3000000; -- 5행

-- 해결2 : IN 연산자 사용
SELECT emp_id, dept_id, salary
FROM employee
WHERE dept_id IN ('60', '90') AND salary >= 3000000; -- 5행

--SELECT 연습문제 ***********************************************************************

--1. 부서코드가 90이면서, 직급코드가 J2인 직원들의 사번, 이름, 부서코드, 직급코드, 급여 조회함 별칭 적용함
SELECT emp_id 사번, emp_name 이름, dept_id 부서코드, job_id 직급코드, salary 급여
FROM employee
WHERE dept_id = '90' AND job_id = 'J2';

--2. 입사일이 '1982-01-01' 이후이거나, 직급코드가 J3 인 직원들의 사번, 이름, 관리자 사번, 보너스포인트 조회함
SELECT emp_id, emp_name, dept_id, bonus_pct
FROM employee
WHERE hire_date > '82/01/01' OR job_id = 'J3';


--3. 직급코드가 J4가 아닌 직원들의 급여와 보너스포인트가 적용된 연봉을 조회함.
--  별칭 적용함, 사번, 사원명, 직급코드, 연봉(원)
--  단, 보너스포인트가 null 일 때는 0으로 바꾸어 계산하도록 함.
SELECT emp_id 사번, emp_name 이름, job_id 직급코드, salary, 
            (salary + (salary * NVL(bonus_pct, 0))) * 12 || ' (원)' "연봉(원)"
FROM employee
WHERE job_id != 'J4';

--4. 보너스포인트가 0.1 이상 0.2 이하인 직원들의 사번, 사원명, 이메일, 급여, 보너스포인트 조회함
SELECT emp_id, emp_name, email, salary, bonus_pct
FROM employee
WHERE bonus_pct BETWEEN 0.1 AND 0.2;

--5. 보너스포인트가 0.1 보다 작거나(미만), 0.2 보다 많은(초과) 직원들의 사번, 사원명, 보너스포인트, 급여, 입사일 조회함
SELECT emp_id, emp_name, email, salary, bonus_pct
FROM employee
WHERE bonus_pct NOT BETWEEN 0.1 AND 0.2;

--6. '1982-01-01' 이후에 입사한 직원들의 사원명, 보너스포인트, 급여 조회함
SELECT emp_name, bonus_pct, salary -- , hire_date
FROM employee
WHERE hire_date > '82/01/01';

--7. 보너스포인트가 0.1, 0.2 인 직원들의 사번, 사원명, 보너스포인트, 전화번호 조회함
SELECT emp_id, emp_name, bonus_pct, phone
FROM employee
WHERE bonus_pct IN (0.1, 0.2); -- 5행

--8. 보너스포인트가 0.1도 0.2도 아닌 직원들의 사번, 사원명, 보너스포인트, 주민번호 조회함
SELECT emp_id, emp_name, bonus_pct
FROM employee
WHERE bonus_pct NOT IN(0.1, 0.2);

--9. 성이 '이'씨인 직원들의 사번, 사원명, 입사일 조회함
--  단, 입사일 기준 오름차순 정렬함
SELECT emp_id, emp_name, hire_date
FROM employee
WHERE emp_name LIKE '이%'
ORDER BY hire_date;

--10. 주민번호 8번째 값이 '2'인 직원의 사번, 사원명, 주민번호, 급여를 조회함
--  단, 급여 기준 내림차순 정렬함

SELECT emp_id, emp_name, emp_no, salary
FROM employee
WHERE emp_no LIKE  '_______2%'
ORDER BY salary DESC;


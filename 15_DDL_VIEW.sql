-- 15_DDL_VIEW.sql

-- VIEW (뷰) --------------------------------------------------------------
-- STORED QUERY : SELECT 쿼리문 저장하는 객체
-- VIRTUAL TABLE : 저장된 SELECT 쿼리문이 실행이 되면 결과뷰를 보여줌
-- 사용목적 : 
-- 1. 보안에 유리 : 쿼리문을 보이지 않게 하고, 결과 뷰만 보이게 함
-- 2. 복잡하고 긴 쿠리문을 직접 실행하지 않고, 저장된 쿼리문을 실행함
--      => 실행 속도가 빠름, 실행구문이 간단함
-- 명령구문 : CREATE VIEW, DROP VIEW
--              ALTER VIEW 없음, ALTER VIEW 대신에 CREATE OR REPLACE VIEW 를 사용함
-- 작성 형식 : 
/*
CREATE [OR REPLACE] [FORCE] VIEW 뷰이름
AS
서브쿼리
[WITH READ ONLY CONSTRAINT 저장이름];
[WITH CHECK OPTION CONSTRAINT 저장이름];
*/

CREATE VIEW V_EMP
AS
SELECT * FROM employee; -- 권한 불충분 에러 발생

-- 관리자계정(SYSTEM/ORACLE)에서 권한 부여한 다음에 사용해야 함
--GRANT CREATE VIEW TO C##STUDENT;

CREATE VIEW V_EMP_DEPT90
AS
SELECT emp_name, dept_name, job_title, salary
FROM employee
LEFT JOIN JOB USING (job_id)
LEFT JOIN department USING (dept_id)
WHERE dept_id = '90';

-- 뷰 사용 : 테이블 대신 사용
SELECT * FROM v_emp_dept90;

-- 뷰 관련 딕셔너리 : USER_VIEWS, USER_CATALOGS, USER_OBJECTS
DESC user_views;

SELECT view_name, text_length, TEXT
FROM USER_VIEWS;

-- 실습 :
-- 직급명이 '사원'인 모든 직원들의 사원명, 부서명, 직급명을 조회하는 구문을 뷰로 저장하시오
-- 뷰이름은 : V_EMP_DEPT_JOB

CREATE OR REPLACE VIEW v_emp_dept_job
AS
SELECT emp_name, dept_name, job_title
FROM employee 
LEFT JOIN job USING(job_id)
LEFT JOIN department USING(dept_id)
WHERE job_title LIKE '사원';

-- 확인
SELECT * FROM v_emp_dept_job;

-- 딕셔너리 확인 : 
-- 뷰객체를 테이블 객체처럼 조회할 수도 있음
SELECT column_name, data_type, nullable
FROM user_tab_cols
WHERE table_name = 'V_EMP_DEPT_JOB';

-- 뷰 생성시 서브쿼리 SELECT 항목의 컬럼 별칭을 따로 지정할 수도 있음
-- SELECT 항목 전부 다 별칭 처리해야 함
CREATE OR REPLACE VIEW v_emp_dept_job (ename, dname, jtitle)
AS
SELECT emp_name, dept_name, job_title
FROM employee 
LEFT JOIN job USING(job_id)
LEFT JOIN department USING(dept_id)
WHERE job_title LIKE '사원';

SELECT * FROM v_emp_dept_job;

-- 서브쿼리 부분에서 별칭 적용해도 됨
CREATE OR REPLACE VIEW v_emp_dept_job
AS
SELECT emp_name enm, dept_name dnm, job_title
FROM employee 
LEFT JOIN job USING(job_id)
LEFT JOIN department USING(dept_id)
WHERE job_title LIKE '사원';

-- 주의 :
-- 서브쿼리 SELECT 절에 함수계산식은 반즈시 별칭 붙여야 함
CREATE OR REPLACE VIEW v_emp ("Ename", "Gender", "Years")
AS
SELECT emp_name,
            DECODE(SUBSTR(emp_no, 8, 1), '1', '남자', '3', '남자', '여자') 성별,
            ROUND(MONTHS_BETWEEN(sysdate, hire_date) / 12) 근무년수
FROM employee;

SELECT column_name, data_type, nullable
FROM user_tab_cols
WHERE table_name = 'v_emp';

-- 뷰 제약조건 ------------------------------------------------------
-- WITH READ ONLY : 뷰를 이용한 DML 작업을 못함 (읽기전용 뷰)
-- WITH CHECK OPTION : 뷰를 테이블처럼 사용해서 DML 수행할 수 있음
--                                  베이스테이블이 1개인 서브쿼리에 적용함
--                                  베이스테이블에 DML 이 적용됨 => DELETE 문은 사용 제한없음
--                                  => 서브쿼리 구문과 관련해서 제한된 DML(INSERT, UPDATE) 수행
-- 뷰 제약조건도 CONSTRAINT 이름으로 저장할 수 있음

-- WITH READ ONLY : 
CREATE OR REPLACE VIEW v_emp
AS
SELECT * FROM EMPLOYEE
WITH READ ONLY;

-- DML 사용 확인 :
INSERT INTO v_emp (emp_id, emp_name, emp_no)
VALUES ('666', '테스터', '901223-1234567'); -- ERROR

DELETE FROM v_emp; -- ERROR

SELECT * FROM v_emp;

-- WITH CHECK OPTION :
-- DELETE 문은 제한없이 사용 가능함
-- INSERT, UPDATE는 조건에 따라 작업이 제한되어 사용할 수 있음
CREATE OR REPLACE VIEW v_emp
AS
SELECT emp_id, emp_name, emp_no, marriage
FROM employee
WHERE marriage = 'N'
WITH CHECK OPTION; -- DML 사용 가능

SELECT * FROM v_emp;

INSERT INTO v_emp (emp_id, emp_name, emp_no, marriage)
VALUES ('666', '테스터', '991123-1234567', 'Y'); -- ERROR
-- 서브쿼리의 조건과 일치하는 값만 기록할 수 있음

UPDATE v_emp
SET marriage = 'Y'; -- ERROR

INSERT INTO v_emp (emp_id, emp_name, emp_no, marriage)
VALUES ('666', '테스터', '991123-1234567', 'N'); -- 베이스테이블에 추가 기록됨

SELECT * FROM employee;
SELECT * FROM v_emp;

-- 뷰에 보여지는 컬럼(항목)에 대해서만 UPDATE 실행할 수 있음
UPDATE v_emp
SET emp_id = '777'
WHERE emp_id = '666';

ROLLBACK;

-- 저장된 뷰객체는 다른 SELECT 구문의 FROM 절에 인라인뷰 사용할 수 있음
-- 인라인뷰 : FROM 절에 사용된 서브쿼리의 결과뷰를 말함
-- FROM (서브쿼리) 뷰별칭  => FROM 뷰이름

-- 인라인뷰 사용 예 1 : 
CREATE OR REPLACE VIEW v_emp_info
AS
SELECT emp_name, dept_name, job_title
FROM employee
LEFT JOIN JOB USING (job_id)
LEFT JOIN department USING (dept_id);

-- 뷰 객체를 테이블 대신에 사용함
SELECT emp_name
FROM v_emp_info -- 테이블 대신 뷰 사용
WHERE dept_name = '해외영업1팀'
AND job_title = '사원';

-- 인라인뷰 사용 예 2 :
CREATE OR REPLACE VIEW v_dept_sal ("Did", "Dname", "Davg")
AS
SELECT NVL(dept_id, '00'),
            NVL(dept_name, 'NONAME'),
            ROUND(AVG(salary), -3)
FROM department
RIGHT JOIN employee USING(dept_id)
GROUP BY dept_id, dept_name;

-- ""묶어서 만든 별칭은 사용시에도 "" 묶어서 표기해야 함
SELECT "Dname", "Davg"
FROM v_dept_sal
WHERE "Davg" > 3000000;

SELECT Dname, Davg
FROM v_dept_sal
WHERE Davg > 3000000; -- "" 표기하지 않으면 에러

-- 뷰 수정 구문 별도로 없음
-- ALTER VIEW 뷰이름 없음
-- 뷰 수정을 원하면, 기존 뷰를 삭제하고 다시 만들기함
-- 또는 CREATE OR REPLACE VIEW 사용함

-- 뷰 삭제
-- DROP VIEW 뷰이름;
DROP VIEW v_emp;

-- FORCE 옵션 :
-- 서브쿼리(저장되는 쿼리문)에 사용된 테이블이 존재하지 않아도 뷰를 생성해 줌
-- SELECT 구문 저장 용도로만 사용시 이용함

 CREATE OR REPLACE NOFORCE VIEW v_emp
 AS
 SELECT tcode, tname, tcontent
 FROM ttt; -- 테이블이 존재하지 않으면 에러남

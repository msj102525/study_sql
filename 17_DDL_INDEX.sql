-- 17_DDL_INDEX.sql

-- 인덱스 (INDEX)
-- SQL 구문 (SELECT, DML)의 처리 속도를 향상시키기 위해 컬럼에 대헤 생성하는 데이터베이스 객체임
-- 인덱스 내부 구조는 B* 트리(이진탐색트리 : BST, Binary Search Tree)임
-- 인덱스 객체는 생성하는데 시간이 필요하고, 공간도 필요함 => 반드시 좋은 것은 아님
-- 인덱스 생성 후에 DML 작업을 수행하면, 인덱스가 사용한 컬럼값(키워드)이 변경되므로 B*트리 내부 구조도
-- 다시 구축이 되어야 함으로(자동) DML 작업이 훨씬 무거워지게 됨

-- 장점
-- 검색 속도가 빠름
-- 시스템에 걸리는 부하를 줄여서 시스템 전체 성능을 향상시킴

-- 단점
-- 인덱스를 위한 추가적인 공간이 필요함
-- 인덱스를 생성하는 데 시간이 걸림
-- 테이블에 DML(INSERT, UPDATE, DELETE) 이 자주 발생하는 경우, 인덱스 트리 재구축 자동 진행되므로
-- 오히려 성능이 저하됨

-- 인덱스 생성 구문
/*
CREATE [UNIQUE] INDEX 인덱스이름
ON 테이블명 (컬럼명[, 컬럼명, ....] | 함수계산식);
*/

-- 인덱스 유형 : NONUNIQUE INDEX, UNIQUE INDEX

-- UNIQUE INDEX : 
-- 컬럼에 UNIQUE 제약조건 설정한 것과 같음 => 같은 값 두번 기록 못함 (중복 검사)
-- PRIMARY KEY 제약조건이 설정된 컬럼에 대헤 자동으로 UNIQUE INDEX 가 생성됨

-- NONUNIQUE INDEX :
-- 비번하게 사용하는 일반 컬럼에 적용하는 인덱스임
-- 성능 향상을 위해 사용됨

SELECT * FROM USER_OBJECTS;

-- UNIQUE INDEX 만들기 :
CREATE UNIQUE INDEX IDX_DNM
ON DEPARTMENT (dept_name);

-- 인덱스 자동으로 사용이 됨 : 
-- SELECT, UPDATE, DELETE 구문 사용시 사용시
-- WHERE 절, JOIN 컬럼 사용시

-- 인덱스 생성 실습 ---------------------------------------

-- 1. EMPLOYEE 테이블의 EMP_NAME 컬럼에
-- 'IDX_ENM' 이름의 UNIQUE INDEX 생성

CREATE UNIQUE INDEX IDX_ENM
ON employee (emp_name);

-- 2. 아래와 같이 새로운 데이터를 입력해 보고, 오류원인을 생각해 보기
CREATE SEQUENCE SEQ_EID
START WITH 400
NOMAXVALUE
NOCYCLE NOCACHE;

INSERT INTO employee (emp_id, emp_no, emp_name)
VALUES (SEQ_EID.NEXTVAL, '990909-1234567', '감우섭');

-- 오류원인 :
-- employee의 emp_name 컬럼에 '감우섭' 이름이 이미 ㅗㄴ재함
-- UNIQUE INDEX는 UNIQUE 제약 조건의 기능을 수행함 => 같은 값 두 번 기록 못하게 됨

-- 3. EMPLOYEE 테이블의 DEPT_ID 컬럼에
-- 'IDX_DID' 이름의 UNIQUE INDEX를 생성해 보고
-- 오류 원인을 생각하고 작성
CREATE UNIQUE INDEX IDX_DID
ON employee (dept_id);

-- 오류 원인 : 
-- dept_id 컬럼은 이미 중복값을 여러 번 사용하고 있는 컬럼임
-- UNIQUE INDEX 생성 못 함

-- 인덱스 수정은 없음 : ALTER INDEX 없음

-- 인덱스 삭제 ---------------------------------------------------------
-- 테이블이 삭제되면, 인덱스도 함께 자동 삭제됨
-- DROP INDEX 인덱스이름;
DROP INDEX IDX_ENM;

-- 인덱스 관련 딕셔너리 정보 확인
DESC USER_INDEXES;
DESC USER_IND_COLUMNS;

SELECT INDEX_NAME, COLUMN_NAME, TABLE_NAME, INDEX_TYPE, UNIQUENESS
FROM USER_INDEXES
JOIN USER_IND_COLUMNS USING (INDEX_NAME, TABLE_NAME)
WHERE TABLE_NAME = 'EMPLOYEE';

-- 검색 속도 비교해 보기
-- EMPLOYEE 테이블의 모든 정보를 서브쿼리 사용해서 복사한 EMP01, EMPL02 테이블 만듦
-- EMPL01 의 EMP_ID 컬럼에 대헤 UNIQUE INDEX 만들기 : IDX_EID
-- 검색 속도 비교를 위해 SELECT 쿼리문을 EMP_ID 컬럼으로 조회해 보기 : 사번 141 번 정보조회
CREATE TABLE EMP01
AS
SELECT * FROM employee;

CREATE TABLE EMP02
AS
SELECT * FROM employee;

CREATE UNIQUE INDEX IDX_EID
ON EMP01(emp_id);

SELECT * FROM EMP01
WHERE emp_id = '141';  -- 0.005

SELECT * FROM EMP02
WHERE emp_id = '141'; -- 0.007

-- 결합 인덱스 ----------------------
-- 단일 인덱스 : 한 개의 컬럼으로 구성한 인덱스
-- 결합 인덱스 : 두 개이상의 컬럼으로 구성한 인덱스
CREATE TABLE DEPT01
AS
SELECT * FROM department;

-- 부서번호와 부서명을 결합해서 인덱스 만들기
CREATE INDEX IDX_DEPT01_COMP
ON DEPT01 (dept_id, dept_name);


-- 테이터 딕셔너리에서 확인 : 
SELECT INDEX_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'DEPT01';

-- 함수 기반 인덱스 ---------------------------------
-- SELECT 절이나 WHERE 절에 산술계산식이나 함수계산식 사용하는 경우
-- 계산식은 인덱스의 적용을 받지 않는다. (인덱스가 계산을 수행하지 않음)
-- 계산 결과값은 키워드로 해서 검색 트리를 구성할 수 있음
-- 계산식으로 검색하는 경우가 많다면, 수식이나 함수식을 인덱스로 만듦

CREATE TABLE EMPL03
AS
SELECT * FROM EMPLOYEE;

CREATE INDEX IDX_EMPL03_SALCALC
ON EMPL03 ((salary + (salary * NVL(bonus_pct, 0)) * 12));

-- 테이터 딕셔너리에서 확인 : 
SELECT INDEX_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'EMPL03';

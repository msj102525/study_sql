-- 12_DDL_DML_02

-- DDL : CREATE TABLE - 제약조건(CONSTRAINT) : FOREIGN KEY 제약조건 --------------------
-- 다른 테이블(부모 테이블)에서 제공하는 값(참조컬럼)을 사용하는 컬럼(자식 레코드) 지종할 때 이용하는 제약조건
-- 컬럼레벨 : [CONSTRAINT 이름] REFERENCES 참조테이블명 [(참조컬럼명)]
-- 테이블레벨 : [CONSTRAINT 이름] FOREIGN KEY (적용할컬럼명) REFERENCES 참조테이블명 [(참조컬럼명)}
-- 참조컬럼은 반드시 PRIMARY KEY 또는 UNIQUE 제약조건이 설정된 컬럼이어야 함
-- (참조컬럼명)이 생략되면 참조테이블의 PRIMARY KEY 컬럼을 사용한다는 의미임
-- 제약사항 : 부모가 제공하는 값만 사용할 수 있다. 제공하지 않는 값 기록하면 에러 발생함
-- NULL 은 사용 가능함

CREATE TABLE testfk (
    emp_id CHAR(3) REFERENCES employee -- PRIMARY KEY 컬럼이 연결됨
    , dept_id CHAR(2) CONSTRAINT tfk_did REFERENCES department (dept_id)
    , job_id CHAR(2)
    -- 테이블레벨
    , CONSTRAINT tfk_jid FOREIGN KEY (job_id) REFERENCES job (job_id)
);
DROP table testfk;
desc testfk;

-- 참조 테이블(부모 테이블)의 참조컬럼에 있는 값만 기록에 사용할 수 있다는 제약조건임
INSERT INTO testfk VALUES ('300', NULL, NULL); -- ERROR 존재하지 않는 값 사용
INSERT INTO testfk VALUES ('100', NULL, NULL);
INSERT INTO testfk VALUES('200', '70', NULL); -- ERROR : 없는 부서코드 값 사용
INSERT INTO testfk VALUES('200', '90', NULL);
INSERT INTO testfk VALUES ('200', '80', 'j7'); -- ERROR : 대소문자 틀림, 없는 직급코드임
INSERT INTO testfk VALUES ('200', '80', 'J7');

SELECT * FROM testfk;

-- 참조 테이블(부모 테이블)의 참조컬럼(부모키)의 값 중에서, 자식레코드가 사용하고 있는 값 삭제 못 함
-- 예 : 부서 테이블의 90번 부서를 삭제 (행 삭제)
-- DML 의 DELETE 문 사용
/*
DELETE FROM 테이블명
WHERE 컬럼명 = 삭제할값; -- 삭제할 값이 있는 행을 찾아서 삭제해라.
*/
DELETE FROM department
WHERE dept_id = '90'; -- ERROR : 자식 레코드가 존재하면(값이 사용중이면) 삭제 못 함

-- FOREIGN KEY 제약조건 설정시 삭제 옵션을 추가할 수 있음
-- 삭제 옵션(DELETION OPTION) :
-- RESTRICTED (삭제 못 함, 기본), SET NULL(자식레코드 NULL로 바꿈), CASCADE(함께 삭제)

-- ON DELETE SET NULL -----------------
-- 부모키 값 삭제시 자식 레코드의 컬럼값을 NULL로 바꿈

-- 부모키 제공 테이블 : 
CREATE TABLE product_state (
    pstate char(1) PRIMARY KEY,
    pcomment VARCHAR2(10)
);

INSERT INTO product_state VALUES ('A', '최고급');
INSERT INTO product_state VALUES ('B', '보통');
INSERT INTO product_state VALUES ('C', '최저급');

SELECT * FROM product_state;

-- 외래키(FOREIGN KEY) 설정 테이블 :
CREATE TABLE product (
    pname VARCHAR2 (20) PRIMARY KEY,
    pprice NUMBER CHECK (pprice > 0),
    pstate CHAR(1) REFERENCES product_state ON DELETE SET NULL
);

INSERT INTO product VALUES ('갤럭시', 654000, 'A');
INSERT INTO product VALUES ('G9', 874500, 'B');
INSERT INTO product VALUES ('맥북', 2500000, 'C');

SELECT * FROM product;

SELECT *
FROM product
NATURAL JOIN product_state;

-- 부모키 값 삭제 확인
DELETE FROM product_state
WHERE pstate = 'A'; -- 행삭제, 에러 안 남

-- 자식레코드 값 확인 : NULL 로 바뀐 것 확인
SELECT * FROM product;

-- ON DELETE CASCADE -------------------------
-- 부모키 값 삭제시 자식 레코드 행도 함께 삭제함

-- 자식 레코드용 테이블 :
CREATE TABLE product2 (
    pname VARCHAR2 (20) PRIMARY KEY,
    pprice NUMBER CHECK (pprice > 0),
    pstate CHAR(1) REFERENCES product_state ON DELETE CASCADE
);

INSERT INTO product2 VALUES ('G9', 874500, 'B');
INSERT INTO product2 VALUES ('맥북', 2500000, 'C');

SELECT * FROM product2;

-- 부모키 값 삭제 :
DELETE FROM product_state
WHERE pstate = 'B';

-- 자식 레코드 확이; 행이 함께 삭제된 것 확인
SELECT * FROM product2;

CREATE TABLE constraint_emp (
    eid CHAR(3) CONSTRAINT pkeid PRIMARY KEY,
    ename VARCHAR2(20) CONSTRAINT nename NOT NULL,
    eno CHAR(14) CONSTRAINT neno NOT NULL CONSTRAINT ueno UNIQUE,
    email VARCHAR2(25) CONSTRAINT uemail UNIQUE,
    phone VARCHAR2(12),
    hire_date DATE DEFAULT SYSDATE,
    jid CHAR(2) CONSTRAINT fkjid REFERENCES job ON DELETE SET NULL,
    salary NUMBER,
    bonus_pct number,
    marriage CHAR(1) DEFAULT 'N' CONSTRAINT chk CHECK (MARRIAGE IN ('Y', 'N')),
    mid CHAR(3) CONSTRAINT fkmid REFERENCES constraint_emp ON DELETE SET NULL,
    did CHAR(2),
    CONSTRAINT fkdid FOREIGN KEY (did) REFERENCES department ON DELETE CASCADE
    );
    
-- 서브쿼리를 사용해서 새 테이블 만들기 -----------------------------
-- 복사 기능 또는 SELECT 문 결과를 테이블로 저장하는 용도임
-- CREATE TABLE 테이블명 AS 서브쿼리;

CREATE TABLE emp_copy90
AS
SELECT * FROM employee
WHERE dept_id = '90';

SELECT * FROM emp_copy90;

-- 테이블 구조 확인 : DESCRIBE 명령 사용
DESC emp_copy90;

-- 테이블 복사본 만들기
CREATE TABLE emp_copy
AS
SELECT * FROM employee;

SELECT * FROM emp_copy;
-- 서브쿼리를 이용해서 기존 테이블을 복사할 경우
-- 컬럼명, 자료형, NOT NULL 제약조건, 값(DATA)은 그대로 복사됨
-- 나머지 제약조건들은 복사 안됨, DEFAULT 지정도 복사 안됨

-- 실습 : 1
-- 모든 직원들의 사번, 이름, 급여, 직급명, 부서명, 근무지역명, 소속국가명 조회한 결과를
-- EMP_LIST 테이블에 저장
CREATE TABLE emp_list
AS
SELECT
    emp_no,
    emp_name,
    salary,
    dept_name,
    loc_describe,
    country_name
FROM employee e
LEFT JOIN department d USING(dept_id)
LEFT JOIN location l ON l.location_id = d.loc_id
LEFT JOIN country c USING(country_Id);
SELECT * FROM emp_list;

-- 실습 2 :
-- EMPLOYEE 테이블에서 남자 직원 정보만 골라내서, EMP_MAN 테이블에 저장
-- 컬럼은 모두 선택
CREATE TABLE emp_man
AS
SELECT *
FROM employee
WHERE SUBSTR(emp_no, 8,1) IN (1, 3);
SELECT * FROM emp_man;

-- 실습 3:
-- 여자 직원들의 정보만 골라내서, emp_femail 테이블에 저장
-- 컬럼은 모두 선택
CREATE TABLE emp_femail
AS
SELECT *
FROM employee
WHERE SUBSTR(emp_no, 8,1) IN (2, 4);
SELECT * FROM emp_femail;

-- 실습 4:
-- 부서별로 정렬된 직원들의 명단을 PART_LIST 테이블에 저장
-- DEPT_NAME, JOB_TITLE, EMP_NAME, EMP_ID 순으로 컬럼 선택
-- PART_LIST에 컬럼 설명 추가함 : 부서이름, 직급이름, 직원이름, 사번
CREATE TABLE part_list
AS
SELECT
    d.dept_name,
    j.job_title,
    e.emp_name,
    e.emp_id 
FROM
    employee e
LEFT JOIN department d ON d.dept_id = e.dept_id
LEFT JOIN job j ON j.job_id = e.job_id
ORDER BY dept_name;

COMMENT ON COLUMN part_list.dept_name IS '부서이름';
COMMENT ON COLUMN part_list.job_title IS '직급이름';
COMMENT ON COLUMN part_list.emp_name IS '직원이름';
COMMENT ON COLUMN part_list.emp_id IS '사번';
SELECT * FROM part_list;
DESC part_list;

-- 실습 : 제약조건이 설정된 테이블 만들기
-- 테이블명 : PHONEBOOK
-- 컬럼명 :  ID  CHAR(3) 기본키(저장이름 : PK_PBID)
--         PNAME      VARCHAR2(20)  널 사용못함.
--                                 (NN_PBNAME) 
--         PHONE      VARCHAR2(15)  널 사용못함
--                                 (NN_PBPHONE)
--                                 중복값 입력못함
--                                 (UN_PBPHONE)
--         ADDRESS    VARCHAR2(100) 기본값 지정함
--                                 '서울시 구로구'

-- NOT NULL을 제외하고, 모두 테이블 레벨에서 제약조건 지정함.

CREATE TABLE phonebook(
    id CHAR(3) CONSTRAINT pk_pbid PRIMARY KEY,
    pname VARCHAR2(20) CONSTRAINT nn_pbname NOT NULL,
    phone VARCHAR2(14) CONSTRAINT nn_pbphone NOT NULL CONSTRAINT un_pbphone UNIQUE,
    address VARCHAR2(100) DEFAULT '서울시 구로구'
);

DESC phonebook;

INSERT INTO phonebook
VALUES ('A01', '홍길동', '010-1234-5678', DEFAULT);

SELECT * FROM phonebook;

-- 서브쿼리로 새 테이블 만들 때,
-- 서브쿼리의 SELECT 한 컬럼명을 사용하지 않고, 새 테이블의 컬럼명을 바꿀 수도 있음
CREATE TABLE job_copy
AS
SELECT * FROM job;

SELECT * FROM job_copy;
DESC job_copy;

-- 테이블 제거 : DROP TABLE 테이블명;
DROP TABLE job_copy;

CREATE TABLE job_copy (직급코드, 직급명, 최저급여, 최고급여) -- 전체 컬럼명 변경
AS
SELECT * FROM job;

SELECT * FROM job_copy;
DESC job_copy;

-- 일부 항목 몇개만 컬럼명을 바꾸고자 한다면
CREATE TABLE dcopy (did, dname) -- 서브쿼리 SELECT 절의 항목과 갯수가 다름, ERROR
AS
SELECT dept_id, dept_name, loc_id
FROM department;

-- 해결
CREATE TABLE dcopy -- 서브쿼리 SELECT 절의 항목과 갯수가 다름, ERROR
AS
SELECT dept_id did, dept_name dname, loc_id
FROM department;

DESC dcopy;

-- 서브쿼리로 새 테이블 만들 때, 컬럼명 바꾸면서 제약조건도 추가할 수 있음
-- 단, 외래키(FOREIGN KEY) 제약조건은 추가할 수 없음
DROP TABLE tbl_subquery;

CREATE TABLE tbl_subquery (
    eid PRIMARY KEY,
    ename,
    sal CHECK (sal > 2000000), -- 에러 : 서브쿼리 결과에 2백만보다 작은 값이 존재함
    dname,
--    did  REFERENCES deapartment, -- 외래키 제약조건은 추가할 수 없음
    jtitle NOT NULL) -- 에러 : 서브쿼리 결과 컬럼에 NULL이 존재함
AS
SELECT emp_id, emp_name, salary, dept_name, -- dept_id 
            -- 해결 : NULL을 다른 값으로 바꾸는 방법
            NVL(job_title, '미지정')
FROM employee
LEFT JOIN job USING (job_id)
LEFT JOIN department USING (dept_id)
-- 해결 : 조건값에 해당되는 값만 기록되게 조건 처리함
WHERE salary > 2000000;

DESC tbl_subquery;
SELECT * FROM tbl_subquery;


-- 데이터 딕셔너리 (데이터 사전) ------------------------------------
-- 사용자가 생성한 모든 객체정보들은 테이블 형태로 DBMS에 자동 저장 관리됨
-- 즉, 사용자가 설정한 제약조건도 자동 저장되고 있음 >>  USER_CONSTRAINTS
-- 저장된 정보는 조회만 할 수 있음
-- 딕셔너리는 사용자가 생성 또는 수정할 수 없음 (DBMS가 자동으로 관리함)

DESC USER_CONSTRAINTS;

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'PHONEBOOK';

-- CONSTRAINT_TYPE
-- P : PRIMARY KEY
-- U : UNIQUE
-- R : FOREIGN KEY
-- C : CHECK, NOT NULL

-- 사용자가 만든 테이블 정보 : USER_TABLES, USER_CATEGORY, USER_OBJECTS
DESC USER_TABLES;

SELECT * FROM USER_TABLES;

-- 사용자가 만든 시퀀스 객체
SELECT * FROM USER_SEQUENCES;

-- 사용자가 만든 뷰 객체
SELECT * FROM USER_VIEWS;

-- 현재 사용자가 접근할 수 있는 모든 테이블들을 조회
SELECT * FROM ALL_TABLES;

-- DBA (DataBase Administrator : 데이터베이스 관리자)가 접근할 수 있는 테이블 조회
-- DBA_TABLES
SELECT * FROM DBA_TABLES; -- 관리자계저에서 확인해야 함



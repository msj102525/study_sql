-- 13_DDL_DML_03.sql

-- DDL (데이터 정의어)
-- 데이터베이스 객체를 생성(CREATE), 변경(ALTER), 제거(DROP)에 사용하는 구문

-- 테이블 수정 ---------------------------------
-- 컬럼 추가/삭제, 자료형 변경, 기본값(DEFAULT) 변경
-- 제약조건 추가/삭제
-- 이름 변경 : 테이블, 컬럼, 제약조건

-- 컬럼 추가
-- 테이블 만들 때 컬럼 설정과 동일하게 작성하면 됨
CREATE TABLE dcopy
AS
SELECT * FROM department;

SELECT * FROM dcopy;

ALTER TABLE dcopy ADD (
    lname VARCHAR2(40)
);

DESC dcopy;

ALTER TABLE dcopy ADD(
    cname VARCHAR2(30) DEFAULT '한국'
);

-- 제약조건 추가
CREATE TABLE emp2
AS
SELECT * FROM employee;

ALTER TABLE emp2 
ADD PRIMARY KEY (emp_id);

ALTER TABLE emp2
ADD CONSTRAINT e2_uneno UNIQUE (emp_no);

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMP2';

-- NOT NULL 은 ADD로 추가하는 것이 아니라, NULL에서 NOT NULL로 변경하는 것임
ALTER TABLE emp2
ADD NOT NULL (hire_date); -- ERROR

ALTER TABLE emp2
MODIFY (hire_date NOT NULL);

ALTER TABLE emp2
MODIFY (hire_date NULL);

-- 컬럼 자료형 변경
CREATE TABLE emp4
AS
SELECT emp_id, emp_name, hire_date
FROM employee;

DESC emp4;

ALTER TABLE emp4
MODIFY (emp_id VARCHAR2(20), 
             emp_name char(20) );

-- DEFAULT 값 변경
CREATE TABLE emp5 (
    emp_id char(3),
    emp_name VARCHAR2(20),
    addr1 VARCHAR2(20)   DEFAULT '서울',
    addr2 VARCHAR2(100)
);

INSERT INTO EMP5 VALUES ('A10', '임태히', DEFAULT, '청담 134');
INSERT INTO EMP5 VALUES ('B10', '이병안', DEFAULT, '분당구 정자동 77');
INSERT INTO EMP5 VALUES ('C10', '이병안', DEFAULT, '분당구 정자동 77');

SELECT * FROM emp5;

ALTER TABLE emp5
MODIFY (addr1 DEFAULT '경기');

--UPDATE emp5 SET addr1= '서울'
--WHERE emp_id = 'B10';

-- 변경 이후에 DEFAULT 사용시 바꾼값 적용됨
ALTER TABLE dcopy
DROP COLUMN cname;

DESC dcopy;

ALTER TABLE dcopy
drop (loc_id, lname); -- 컬럼 여러 개 삭제시 사용

-- 테이블의 컬럼은 모두 삭제할 수 없음
-- 테이블은 최소 한 개의 컬럼은 있어야 함 => 컬럼 없는 빈 테이블 생성 못 함
CREATE TABLE tco(); -- ERROR

ALTER TABLE dcopy
DROP (did, dname); -- ERROR

-- 외래키(FOREIGN KEY) 제약조건으로참조되는 컬럼(부모키)도 삭제 못 ㅎ마
ALTER TABLE department
DROP (dept_id); -- ERROR 

ALTER TABLE department
--DROP (dept_id); -- ERROR 
DROP (dept_id) CASCADE CONSTRAINTS; -- OK

-- 제약조건이 설정된 컬럼은 삭제할 수 없음
CREATE TABLE tb1(
    pk NUMBER PRIMARY KEY,
    fk NUMBER REFERENCES tb1,
    COL1 NUMBER,
    -- 테이블레벨
    CHECK (pk > 0 AND col1 > 0)
);

ALTER TABLE tb1
DROP (pk); -- ERROR

ALTER TABLE tb1
DROP (col1); -- ERROR

-- 제약조건도 함께 삭제하면 됨 : CASCADE CONSTRAINTS
ALTER TABLE tb1
DROP (pk) CASCADE CONSTRAINTS; 

ALTER TABLE tb1
DROP (col1) CASCADE CONSTRAINTS;

DESC tb1;

-- 제약조건 삭제 --------------------

-- 제약조건 저장한 딕셔너리에서 확인
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'CONSTRAINT_EMP';

-- 제약조건 1개 삭제
ALTER TABLE CONSTRAINT_EMP
DROP CONSTRAINT CHK;

-- 제약조건 여러 개 삭제
ALTER TABLE CONSTRAINT_EMP
DROP CONSTRAINT FKJID
DROP CONSTRAINT FKMID
DROP CONSTRAINT NENAME;

-- NOT NULL 제약조건 삭제는 MODIFY로 NULL로 바꿈
ALTER TABLE CONSTRAINT_EMP
MODIFY (eno null);

-- 테이블의 컬럼을 관리하는 데이터 딕셔너리 : USER_TAB_COLS
SELECT * FROM USER_TAB_COLS;
DESC USER_TAB_COLS;

-- 컬럼별 제약조건을 관리하는 데이터 딕셔너리 : USER_CONS_COLUMNS
CREATE TABLE tb_exam (
    col1 char(3) PRIMARY KEY,
    ename VARCHAR2(20),
    FOREIGN KEY (col1) REFERENCES employee
);

-- 딕셔너리로 확인
SELECT CONSTRAINT_NAME 이름,
            CONSTRAINT_TYPE 유형,
            COLUMN_NAME 컬럼,
            R_CONSTRAINT_NAME 참조,
            DELETE_RULE 삭제규칙
FROM USER_CONSTRAINTS
JOIN USER_CONS_COLUMNS USING (CONSTRAINT_NAME, TABLE_NAME)
WHERE TABLE_NAME = 'TB_EXAM';

-- 이름 바꾸기 -----------------
-- 테이블명, 컬럼명, 제약조건 이름

-- 컬럼명 바꾸기
ALTER TABLE TB_EXAM
RENAME COLUMN col1 to empid;

DESC tb_exam;

-- 제약조건 이름 바꾸기
ALTER TABLE TB_EXAM
RENAME CONSTRAINT SYS_C007614 TO pk_eid;

ALTER TABLE TB_EXAM
RENAME CONSTRAINT SYS_C007615 TO fd_eid;

-- 테이블명 바꾸기
ALTER TABLE TB_EXAM RENAME TO TB_SAMPLE1;
-- 또는
RENAME TB_SAMPLE1 TO TB_SAMPLE;

-- 테이블 제거하기 -----------------------------
-- DROP TABLE 테이블명 [CASCADE CONSTRAINTS];
CREATE TABLE dept (
    did CHAR(2) PRIMARY KEY,
    dname VARCHAR2(10)
);

CREATE TABLE emp6 (
    eid CHAR(3) PRIMARY KEY,
    ename VARCHAR2(10),
    did CHAR(2) REFERENCES dept
);

-- 참조되는 테이블(부모 테이블)은 삭제 못 함
DROP TABLE dept; -- ERROR
DROP TABLE dept CASCADE CONSTRAINTS;
-- dept에 대한 REFERENCES 제약조건도 함께 삭제됨

DESC emp6;

CREATE TABLE dept2 (
    did CHAR(2) PRIMARY KEY,
    dname VARCHAR2(10)
);

INSERT INTO dept2 VALUES ('77', '영업부');

SELECT * FROM dept2;

CREATE TABLE emp66 (
    eid CHAR(3) PRIMARY KEY,
    ename VARCHAR2(10),
    did CHAR(2) REFERENCES dept2 ON DELETE CASCADE
);
-- ON DELETE CASCADE : 부모키 값이 삭제되면, 자식 레코드(행) 함께 삭제함

INSERT INTO emp66 VALUES ('111', '홍길동', '77');

SELECT * FROM emp66;

-- 행삭제 : DML의 DELETE 문
DELETE FROM dept2
WHERE did = '77';

SELECT * FROM dept2;
SELECT * FROM emp66;

DROP TABLE dept2 CASCADE CONSTRAINTS;

-- **********************************************************
-- DML (Data Manipulation Language : 데이터 조작어)
-- 명령구문 : INSERT, UPDATE, DELETE
-- 테이블에 데이터를 추가 기록하거나(저장, INSERT), 기록된 데이터를 수정(UPDATE)하거나,
-- 데이터가 기록된 행을 삭제(DELETE)할 때 사용함
-- CRUD (C: INSERT, R: SELECT, U: UPDATE, D: DELETE)
-- INSERT 문 : 행을 추가함
-- UPDATE 문 : 행 갯수 변경없음 
-- DELETE 문 : 행 갯수 줄어듦 (복구됨)
-- TRUNCATE 문 : 테이블의 모든 행을 삭제함 (복구 안 됨)







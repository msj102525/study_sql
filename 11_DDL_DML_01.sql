-- 11_DDL_DML_01.sql

-- DDL (Data Definition Language : 데이터 정의어)
-- 명령어 : CREATE, ALTER, DROP
-- 데이터베이스 객체를 생성, 수정, 제거하는 구문임
-- 테이블 객체 : CREATE TABLE, ALTER TABLE, DROP TABLE
-- 뷰 객체 : CREATE VIEW, DROP VIEW
-- 시퀀스 객체 : CREATE SEQUENCE, ALTER SEQUENCE, DROP SEQUENCE
-- 사용자 객체 : CREATE USER, ALTER USER, DROP USER

-- 테이블 만들기
/*
CREATE TABLE 테이블명 (
    컬럼명   숫자자료형,
    컬럼명   문자자료형(기록할 최대 바이트 크기),
    컬럼명   날짜자료형
);

테이블은 최소 1개의 컬럼은 가져야 됨 => 컬럼없는 빈 테이블 만들 수 없음
*/

DROP TABLE TEST;

CREATE TABLE TEST (
    ID      NUMBER,
    NAME    VARCHAR2(20),
    ADDRESS VARCHAR2(100),
    ENROLL_DATE   DATE DEFAULT SYSDATE
);

CREATE TABLE TEST2 ();  -- ERROR, 컬럼 없음

-- 테이블 구조 확인 명령어 : DESCRIBE 테이블명;
DESCRIBE TEST;
-- 줄임말 사용 가능 : DESC 테이블명;
DESC TEST;

-- 테이블 생성 실습 : 
CREATE TABLE ORDERS (
    ORDERNO     CHAR(4),
    CUSTNO      CHAR(4),
    ORDERDATE   DATE    DEFAULT SYSDATE,
    SHIPDATE    DATE,
    SHIPADDRESS VARCHAR2(40),
    QUANTITY    NUMBER
);

DESC ORDERS;

-- 컬럼에 설명 추가 : 
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '설명';
COMMENT ON COLUMN ORDERS.ORDERNO IS '주문번호';
COMMENT ON COLUMN ORDERS.CUSTNO IS '고객번호';
COMMENT ON COLUMN ORDERS.ORDERDATE IS '주문일자';
COMMENT ON COLUMN ORDERS.SHIPDATE IS '배송일자';
COMMENT ON COLUMN ORDERS.SHIPADDRESS IS '배송주소';
COMMENT ON COLUMN ORDERS.QUANTITY IS '주문수량';

-- ******************************************************
-- 무결성 제약조건들 (CONSTRAINTS)
-- NOT NULL, UNIQUE, PRIMARY KEY, CHECK, FOREIGN KEY

-- 1. NOT NULL 제약조건
-- 컬럼에 반드시 값을 기록해야 됨 (필수 입력항목을 뜻함)
-- 컬럼에 NULL 사용 못 한다는 제약조건임
-- NULL 이 사용되면 에러 발생함
-- 주의 : 컬럼레벨에서만 설정할 수 있음 (테이블 레벨에서 설정 못 함)
-- 컬럼레벨 : 컬럼명 자료형 [DEFAULT 기본값] NOT NULL

CREATE TABLE TESTNN (
    NID     NUMBER(5)   NOT NULL,  -- 컬럼 레벨
    N_NAME  VARCHAR2(30)
);

-- 테이블에 데이터 기록 확인
-- DML 의 INSERT 명령문 사용함
INSERT INTO TESTNN (NID, N_NAME)
VALUES (1, '테스터');

INSERT INTO TESTNN (NID, N_NAME)
VALUES (NULL, '테스터2');  -- ERROR

INSERT INTO TESTNN (NID, N_NAME)
VALUES (2, NULL);  -- OK

SELECT * FROM TESTNN;

-- 제약조건은 DBMS 가 이름으로 관리함
-- 제약조건 설정시 이름을 지정하지 않으면, 자동으로 SYS_C....... 형식으로 부여됨
CREATE TABLE TESTNN2 (
    N_ID   NUMBER(5) CONSTRAINT T2_NID NOT NULL,  -- 컬럼레벨
    N_NAME  VARCHAR2(20CHAR)
    -- 테이블레벨에서 제약조건을 지정할 수 있음
    -- 제약조건종류(적용할 컬럼명)
    -- CONSTRAINT 저장할이름 제약조건종류(적용할컬럼명)
    --, CONSTRAINT T2_NNAME NOT NULL(N_NAME)  -- ERROR
);


-- 2. UNIQUE 제약조건 -------------------------------------------
-- 지정 컬럼에 중복값(같은 값 두번 기록) 입력을 검사하는 제약조건임
-- 같은 값은 두번 기록 못하는 컬럼이 됨
-- NULL 은 사용할 수 있음
-- 복합키(여러 개의 컬럼을 묶음)로 지정할 수도 있음

CREATE TABLE TESTUN (
    U_ID    CHAR(3)   UNIQUE,
    U_NAME  VARCHAR2(10)  NOT NULL
);

INSERT INTO TESTUN (U_ID, U_NAME) VALUES ('AAA', '오라클');
INSERT INTO TESTUN (U_ID, U_NAME) VALUES ('AAA', '자바');  -- 에러
INSERT INTO TESTUN (U_ID, U_NAME) VALUES ('AAB', '자바'); 
INSERT INTO TESTUN (U_ID, U_NAME) VALUES (NULL, '자바'); -- NULL 사용 가능

SELECT * FROM TESTUN;

-- 제약조건 설정시 이름 부여함
-- 컬럼레벨 : CONSTRAINT 이름 제약조건종류
-- 테이블레벨 : CONSTRAINT 이름 제약조건종류 (적용할컬럼명)
CREATE TABLE TESTUN2 (
    UN_ID  CHAR(3)   CONSTRAINT T2_UID UNIQUE
    , UN_NAME  VARCHAR2(10)  CONSTRAINT T2_UNAME NOT NULL
);

-- 테이블레벨 설정
CREATE TABLE TESTUN3 (
    UN_ID  CHAR(3)   
    , UN_NAME  VARCHAR2(10)  CONSTRAINT T3_UNAME NOT NULL
    -- 테이블레벨
    , CONSTRAINT T3_UID UNIQUE (UN_ID)
);


-- 3. PRIMARY KEY 제약조건  ---------------------------------
-- NOT NULL + UNIQUE
-- 테이블에서 한 행의 정보를 찾기 위해 이용할 수 있는 식별자(IDENTIFIER) 지정시 사용하는 제약조건임
-- 복합키(여러 개의 컬럼을 묶음)로 지정할 수 있음
-- 한 테이블에 한번만 사용할 수 있음

CREATE TABLE TESTPK (
    P_ID   NUMBER  PRIMARY KEY,
    P_NAME  VARCHAR2(10)  NOT NULL,
    P_DATE  DATE  DEFAULT SYSDATE
);

INSERT INTO TESTPK (P_ID, P_NAME) VALUES (1, '홍길동');
INSERT INTO TESTPK VALUES (2, '박문수', SYSDATE);
-- INSERT 시 컬럼명 생략하면, 테이블의 모든 컬럼에 값을 기록한다는 의미임
INSERT INTO TESTPK VALUES (NULL, '박문수', DEFAULT);  -- ERROR : NULL 사용 못 함
INSERT INTO TESTPK VALUES (2, '홍길동', DEFAULT);  -- ERROR : 중복값 사용 못 함
INSERT INTO TESTPK VALUES (3, '이순신', DEFAULT);

SELECT * FROM TESTPK;

CREATE TABLE TESTPK2 (
    PID  NUMBER  PRIMARY KEY,
    PNAME  VARCHAR2(10)  PRIMARY KEY
);  -- ERROR : 한 테이블에 기본키(PRIMARY KEY)는 한개만 사용할 수 있음

-- 컬럼레벨
CREATE TABLE TESTPK2 (
    PID NUMBER CONSTRAINT T2_PID PRIMARY KEY
    , PNAME VARCHAR2(15)
    , PDATE DATE
);

-- 테이블레벨
CREATE TABLE TESTPK3 (
    PID NUMBER 
    , PNAME VARCHAR2(15)
    , PDATE DATE
    -- 테이블레벨
    , CONSTRAINT T3_PID PRIMARY KEY (PID)
);


-- 4. CHECK 제약조건 --------------------------------
-- 컬럼에 기록되는 값에 대해 조건 설정하는 제약조건임
-- CHECK (컬럼명 연산자 조건값)
-- 주의 : 조건값은 바뀌는 값은 사용할 수 없음 (SYSDATE 같은)

CREATE TABLE TESTCHK (
    C_NAME  VARCHAR2(15)  CONSTRAINT TCK_NAME NOT NULL
    , C_PRICE  NUMBER(5)  CHECK (C_PRICE BETWEEN 1 AND 99999)
    , C_LEVEL  CHAR(1)  CHECK (C_LEVEL IN ('A', 'B', 'C'))
);

INSERT INTO TESTCHK VALUES ('갤럭시S22', 54000, 'A');
INSERT INTO TESTCHK VALUES ('LG G9', 125000, 'A');  -- ERROR : C_PRICE CHECK 제약조건 위배됨
INSERT INTO TESTCHK VALUES ('LG G9', 0, 'A');   -- ERROR : C_PRICE CHECK 제약조건 위배됨
INSERT INTO TESTCHK VALUES ('LG G9', 65000, 'D');  -- ERROR : C_LEVEL CHECK 제약조건 위배됨

SELECT * FROM TESTCHK;

CREATE TABLE TESTCHK2 (
    C_NAME VARCHAR2(15 CHAR) PRIMARY KEY
    , C_PRICE  NUMBER(5)  CHECK (C_PRICE >= 1 AND C_PRICE <= 99999)
    , C_LEVEL  CHAR(1)  CHECK (C_LEVEL = 'A' OR C_LEVEL = 'B' OR C_LEVEL = 'C')
    --, C_DATE  DATE  CHECK (C_DATE < SYSDATE)  -- ERROR : 사용시 바뀌는 값 지정 못 함
    -- , C_DATE  DATE  CHECK (C_DATE < TO_DATE('24/12/31'))  -- ERROR : BUG
    -- , C_DATE  DATE  CHECK (C_DATE < TO_DATE('24/12/31', 'RR/MM/DD'))  -- ERROR : BUG
    , C_DATE  DATE  CHECK (C_DATE < TO_DATE('24/12/31', 'YYYY/MM/DD'))  -- BUG
);








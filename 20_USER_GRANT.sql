-- 20_USER_GRANT.sql

-- 사용자 관리
-- 사용자 계정과 암호 설정, 권한 부여 / 권한 회수

/*
* 오라클 데이터베이스를 설치하면, 기본적으로 제공되는 계정은
    SYS
    SYSTEM (XE 모듈에서는 관리자 계정임)
    SYSDAB
    HR (샘플 계정 : 처음에는 LOCK 상태임, 10g까지는 제공됨)
    SCOTT (교육용 샘플 계정 : 버전에 따라 LOCK 상태일 수 있음)

* 데이터베이스 관리자 (DBA) 보안설정 : 
    - 사용자가 데이터베이스의 객체 (테이블, 뷰 등)에 대한 특정 접근 권한을
      가질 수 있게 설정함
    - 다수의 사용자가 공유하는 데이터베이스 정보에 대한 보안 설정함
    - 데이터베이스에 접근하는 사용자마다 서로 다른 권한과 롤을 부여함

* 권한 : 
    사용자가 특정 테이블에 접근할 수 있도록 하거나,
    해당 테이블에 SQL(SELECT, INSERT, UPDATE, DELETE)문을
    사용할 수 있도록 제한을 두는 것
    
    - 시스템 권한 : 
        데이터베이스 관리자가 가지고 있는 권한
        CREATE USER (사용자 계정 만들기)
        DROP USER (사용자 계정 삭제)
        DROP ANY TABLE (임의의 테이블 삭제)
        QUERY REWRITE (함수 기반 인덱스 생성)
        BACKUP ANY TABLE (테이블 백업)
    
    - 시스템 관리자가 사용자에게 부여하는 권한
        CREATE SESSION (데이터베이스에 접속)
        CREATE TABLE (테이블 생성)
        CREATE VIEW (뷰 생성)
        CREATE SEQUENCE (시퀀스 생성)
        CREATE PROCEDURE (프로시저 생성)
    
    - 객체 권한 :
        객체를 조작할 수 있는 권한    
*/

-- 사용자 계정 생성 :
-- 데이터베이스에 접근할 수 있는 아이디와 암호 만들기
-- 작성형식 : 
-- CREATE USER 아이디 IDENTIFIED BY 암호;

-- 시스템계정에 접속
-- SQL> conn system/설치시 지정한 암호

-- 접속한 계정 확인
-- SQL> show user

-- 새로운 사용자 계정과 암호 만들기 : 
-- 오라클 클라우드 버전에서는 계정에 'C##' + 아이디 로 작성함
CREATE USER C##USER01 IDENTIFIED BY PASS01;

-- 새로 만든 계정으로 접속 확인 : 에러 발생
-- 데이터베이스 접속 권한이 없음
CONNECT C##USER01/PASS01

-- 권한 부여하기 : GRANT 명령어 사용
-- 사용형식 : 
-- GRANT 권한종류, .... TO 사용자아이디 [WITH ADMIN OPTION];

-- 사용자아이디 대신에 PUBLIC 을 사용해도 됨
-- GRANT 권한종류, .... TO PUBLIC [WITH ADMIN OPTION];
-- 해당 권한을 모든 사용자에게 부여한다는 의미임

-- WITH ADMIN OPTION : 
-- 해당 권한에 대해 시스템(관리자)권한을 부여한다는 의미임
-- 해당 사용자가 다른 사용자에게 지정한 권한을 부여할 수 있게 됨

-- 로그인 권한 부여하기 : 
GRANT CREATE SESSION TO C##USER01;

-- SQL> CONN C##USER01/PASS01
-- SQL> SHOW USER

-- C##USER01 에서 테이블 생성 : 

CREATE TABLE EMP01 (
    ENO  NUMBER(4),
    ENAME VARCHAR2(20),
    JOB VARCHAR2(10),
    DPTNO  NUMBER(2)
);

-- 권한 불충분 에러 발생함
-- 시스템계정에서 CREATE TABLE 권한 부여함
GRANT CREATE TABLE TO C##USER01;

-- C##USER01 에서 테이블 생성 확인
-- 만약, 권한을 부여했는데도 테이블 생성이 안되고, TABLE SPACE 관련 에러가
-- 표시되면 USERS 에 테이블스페이스 쿼터(QUOTA)를 설정해 줘야 함

-- 테이블스페이스(TABLESPACE) : 
-- 테이블, 뷰, 그밖의 데이터베이스 객체들이 저장되는 디스크 상의 장소
-- 오라클 설치시 USERS 라는 테이블스페이스가 만들어짐
-- 일반 사용자는 USERS 안에 공간을 할당받아서 사용함

-- 시스템 계정에서 해당 사용자계정의 테이블 스페이스 확인
SELECT USERNAME, DEFAULT_TABLESPACE
FROM DBA_USERS
WHERE USERNAME = 'C##USER01';

-- 테이블스페이스 쿼터 할당하기 : 
ALTER USER C##USER01
--QUOTA 2M ON SYSTEM;
QUOTA 2M ON USERS;
-- QUOTA 절 : 10M, 5M, UNLIMITED 등 사용함

/*
[연습] ----------------------------------------------------------------
	사용자명 : C##USER007
	암 호 : PASS007
	테이블스페이스 : 3M (USERS에 할당)
	권 한 : DB 연결, 테이블 생성 허용함
	=> 실행 확인해 봄
------------------------------------------------------------------------
*/
CREATE USER C##USER007 IDENTIFIED BY PASS007;

ALTER USER C##USER007
QUOTA 3M ON USERS;

GRANT CREATE SESSION, CREATE TABLE TO C##USER007;


-- 객체 권한 ----------------------------------
-- 테이블, 뷰, 시퀀스, 함수 등 각 객체별로 DML 문을 사용할 수 있는 권한을
-- 설정하는 것
/*
작성형식 : 
GRANT 권한종류 [(컬럼명)] | ALL
ON 객체명 | ROLE 이름 | PUBLIC
TO 사용자명;

* 권한종류          대상 객체
ALTER   :       TABLE, SEQUENCE
DELETE  :       TABLE, VIEW
EXECUTE :       PROCEDURE
INDEX   :       TABLE
INSERT  :       TABLE, VIEW
REFERENCES  :   TABLE
SELECT  :       TABLE, VIEW, SEQUENCE
UPDATE  :       TABLE, VIEW

*/

-- C##USER01 에 접속 : -----------------------
-- 테이블 확인
SELECT * FROM EMP01;
DESCRIBE EMP01;

-- C##USER007 사용자가 C##USER01 이 가진 EMP01 테이블을 
-- SELECT 할 수 있는 권한을 부여해 줌
GRANT SELECT
ON EMP01
TO C##USER007;

-- C##USER007 로 접속 : 
-- C##USER01 의 EMP01 테이블을 SELECT 해 봄
SELECT * FROM C##USER01.EMP01;

-- 사용자에게 부여된 권한 조회하기
-- 사용자 권한과 관련된 데이터 딕셔너리 :
-- 자신에게 부여된 권한을 알고자 할 때 USER_TAB_PRIVS_RECD
-- C##USER007 에서 확인 : 
SELECT * FROM USER_TAB_PRIVS_RECD;

-- 현재 사용자가 다른 사용자에게 부여한 권한을 알고자 할 때
--  USER_TAB_PRIVS_MADE
-- C##USER01 에서 확인 : 
SELECT * FROM USER_TAB_PRIVS_RECD;

-- 권한 철회 -----------------------------
-- REVOKE 명령 사용
/*
사용형식 : 
REVOKE 권한종류 | ALL
ON 객체명
FROM 사용자명 | PUBLIC | ROLE 이름;
*/

-- C##USER01 로그인
-- 해당 사용자가 설정한 권한 확인함
SELECT * FROM USER_TAB_PRIVS_MADE;

-- 권한 해제함
REVOKE SELECT ON EMP01 FROM C##USER007;

-- 데이터 딕셔너리에서 삭제 확인함
SELECT * FROM USER_TAB_PRIVS_MADE;

-- WITH GRANT OPTION -------------------------------
-- 사용자가 해당 객체에 접근할 수 있는 권한을 부여받으면서
-- 이 권한을 다른 사용자에게 다시 부여할 수 있게 함

-- C##USER01 로그인
GRANT SELECT ON C##USER01.EMP01 TO C##USER007
WITH GRANT OPTION;

-- C##USER007 로그인
GRANT SELECT ON C##USER01.EMP01 TO C##STUDENT;
-- 받은 권한을 다른 사용자에게 다시 부여할 수 있음






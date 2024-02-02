-- 관리자(system) 계정에서 사용자 관리하기

/*
11g 까지는 오라클 설치시 스터디를 위한 계정이 제공이 되었음
scott/tiger, hr/hr => 샘프 테이블과 데이터들이 제공이 됨
18c 부터는 제공이 안 됨
*/

-- 현재 접속된 사용자 계정 보기
show user;
SHOW USER;

-- 수업을 위한 계정 만들기
-- create user 아이디명 identified by 암호;
-- 12c 부터는 사용자계정(아이디) 만들 때 아이디 글자 앞에 반드시 c##을 붙여야 함
-- 암호는 마음대로 정해도 됨
-- 데이터베이스 명령 구문은 대소문자 구분 안 함 (저장되는 값 == 데이터는 대소문자 구분함)
-- 아이디와 암호도 대소문자 구분함

-- 사용자 계정
--create user c##student IDENTIFIED BY student;
--create user c##scott IDENTIFIED by tiger;

--과제용 계정
--create user c##homework IDENTIFIED by homework;

--시험 평가용 계정
--create user c##test IDENTIFIED by test;

-- 데이터베이스는 사용자 계정과 암호 생성 후에 권한을 부여해야 함
-- 권한 부여시에 사용되는 명령 구문 : GRANT 권한 종류, 권한종류, ... BY 사용자계정;
-- 권한종류 : CREATE SESSTION (로그온 권한), CREATE TABLE, INSERT INTO, UPDATE, DELETE, SELECT 권한 등등
-- 여러 권한들을 모아 놓은 객체를 이용할 수 있음 : 롤(ROLE)이라고 함
-- 오라클이 제공하는 롤을 이용할 수 있음 : CONNECT롤, RESOURCE롤 등 : GRANT 롤이름, 롤이름, ... TO 사용자계정;
-- 사용자가 롤을 만들어서 사용할 수도 있음

--GRANT CONNECT, RESOURCE TO c##student
--GRANT CONNECT, RESOURCE TO c##scott;
--GRANT CONNECT, RESOURCE TO c##homework;
--GRANT CONNECT, RESOURCE TO c##test;

-- 오라클 12c 까지는 권한(grant)만 부여하면 테이블 생성할 수 있었음, 데이터 저장도 되었음
-- 18c 부터는 권한 부여 후에 테이블 스페이스(Table Space)를 할당받아야 테이블 생성과 데이터 저장 가능함
-- TABLESPACE 할당은 사용자 정보를 변경하여 설정함
-- ALTER USER c##student QUOTA 1024M ON USERS;
-- ALTER USER c##scott QUOTA 1024M ON USERS;
-- ALTER USER c##homework QUOTA 1024M ON USERS;
-- ALTER USER c##test QUOTA 1024M ON USERS;

-- 참고 : 로컬 데이터베이스는 사용자계정에 c## 반드시 표기해야 함
--  OCI(Oracle Cloud Infrastructure)에 설치된 오라클 db에는 c## 붙이지 않고 계정 만들기함

-- 사용자계정 제거하기
-- 사용자계정 문제가 있을 시, 제거하고 다시 만들기함
-- DROP USER 사용자 계정 [CASCADE];

CREATE USER c##ttt IDENTIFIED BY ttt;
DROP USER c##ttt;
DROP USER c##ttt CASCADE;

-- 데이터베이스 접속시 계정 또는 함호를 오타로 몇번 에러를 발생시키면 계정 잠김(LOCK)
-- 잠긴 사용자계정의 LOCK을 해제하려면 UNLOCK 처리함
--ALTER USER c##계정 IDENTIFIED BY 암호 ACCOUNT UNLOCK;

-- 사용자계정 잠그기 (LOCK)
--ALTER USER c##student IDENTIFIED BY student ACCOUNT LOCK;
--ALTER USER c##student IDENTIFIED BY student ACCOUNT UNLOCK;

-- 암호 변경
-- ALTER USER c##사용자계정 IDENTIFIED BY 바꿀암호;

 ALTER USER c##student IDENTIFIED BY student;





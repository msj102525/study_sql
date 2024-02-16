-- 18_DDL_SYNONYM.sql

-- 동의어 (SYNONYM)
-- 다른 사용자계정에 있는 객체에 대한 ALIAS (별칭, 줄임말)임
-- 여러 사용자가 테이블을 공유할 경우, 다른 사용자가 테이블에 접근할 때 사용자명.테이블명 으로 표현함
-- 이 때 동의어를 적용하면 간단하게 기술할 수 있게 됨

-- 작성형식 : 
-- CREATE SYNONYM 줄임말 FOR 사용자명.객체명;
-- 예 :
CREATE SYNONYM EP FOR C##STUDENT.EMPLOYEE;

SELECT * FROM C##STUDENT.EMPLOYEE; -- 자기 계정 안에서는 사용자명 생략함
SELECT * FROM EMPLOYEE;
SELECT * FROM EP;

-- 예 :
SELECT * FROM SYS.DUAL;
SELECT * FROM DUAL;
SELECT * FROM C##SCOTT.EMP; -- 다른 계정의 객체에 접근

-- 동의어는 모든 사용자가 사용할 수 있는 공개(PUBLIC) 동의어와
-- 개별 사용자가 사용하는 비공개 동의어가 있음
/*
작성형식 :
CREATE [PUBLIC] SYNONYM 동의어 FOR 사용자계정.객체명;
*/

-- 관리자계정에 있는 SYSTBL 테이블을 조회 확인
SELECT * FROM SYSTEM.SYSTBL;

-- 동의어 만들기
CREATE SYNONYM STB FOR SYSTEM.SYSTBL;

-- 동의어로 조회 확인
SELECT * FROM STB;

-- 동의어 제거하기
-- 비공개 동의어 : 해당 사용자계정에서 제거함
-- 구문 : DROP SYNONYM 줄임말;

DROP SYNONYM EP;
DROP SYNONYM STB;

-- 공개 동의어 : SYSTEM 계정에서 제거함
-- 구문 : DROP PUBLIC SYNONYM 공개동의어;




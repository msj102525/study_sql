-- 16_DDL_SEQUENCE.sql

-- 시퀀스 (SEQUENCE)
-- 자동 정수(숫자) 발생하는 객체
-- 순차적으로 정수값을 자동으로 발생함
/*
작성형식 :
CREATE SEQUENCE 시퀀스이름
[START WITH 시작숫자] -- 생략되면 기본 1 적용
[INCREMENT BY 증가감소숫자] -- 생략되면 기번 1 증가임
[MAXVALUE 최종값 | NOMAXVALUE] - NOMAXVALUE 이면 10의 27승까지 값이 발생함
[MINVALUE 최소값 | NOMINVALUE]
[CYCLE | NOCYCLE] -- 최종값에서 값이 순환되면 무조건 1부터 시작임
[CACHE 정장갯수 | NOCACHE] -- 캐시 메모리에 미리 발생시켜 저장할 숫자 갯수 지정 (저장갯수 2 ~ 20)
;
*/

-- 시퀀스 만들기 1 : 
CREATE SEQUENCE SEQ_EMPID
START WITH 300 -- 300 부터 시작
INCREMENT BY 5 -- 5씩 증가
MAXVALUE 310 -- 310 까지 숫자 발생
NOCYCLE -- 310까지 생성 후 더이상 숫자 생성 안됨
NOCACHE;  -- 미리 메모리에 숫자 생성 저장 안 함

-- 시퀀스 관련 데이터 딕셔너리 확인
DESC USER_SEQUENCES;

SELECT * FROM USER_SEQUENCES;

SELECT SEQUENCE_NAME, CACHE_SIZE, LAST_NUMBER
FROM USER_SEQUENCES;
-- LAST_NUMBER : 다음 발생값을 의미함

-- 시퀀스 사용 : 시퀀스이름.NEXTVAL 속성 사용으로 값 발생시킴
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;
-- NOCYCLE 이기 때문에 최종값 310 다음 값 발생시키면 에러가 발생

-- 시퀀스 만들기 2 :
CREATE SEQUENCE SEQ2_EMPID
START WITH 5
INCREMENT BY 5
MAXVALUE 15
CYCLE
NOCACHE;

-- 사용 : 
SELECT SEQ2_EMPID.NEXTVAL FROM DUAL;
-- 5, 10, 15, 1, 6, 11, 1, 6, .............. 반복됨

-- 시퀀스 사용 속성 : 
-- 시퀀스이름.NEXTVAL
-- 새로운 정수 숫자를 발생시키는 속성임
-- 시퀀스이름.CURRVAL
-- 시퀀스가 마지막으로 발생한 값 확인하는 속성임
-- 주의 : 시퀀스 객체 만들고, NEXTVAL 먼저 실행하고 나서 사용해야 함
--          NEXTVAL 실행하지 않고 사용하면 에러 발생함

CREATE SEQUENCE SEQ3_EMPID
INCREMENT BY 5
START WITH 300
MAXVALUE 310
NOCYCLE  NOCACHE;

-- 시퀀스 객체 만들고 바로 CURRVAL 사용
SELECT SEQ3_EMPID.CURRVAL FROM DUAL; -- 에러 발생

SELECT SEQ3_EMPID.NEXTVAL FROM DUAL; -- 300 발생
SELECT SEQ3_EMPID.CURRVAL FROM DUAL;  -- 마지막 발생값 300 확인

-- 시퀀스 객체는 주로 INSERT 문에서 순번 기록용으로 사용함
CREATE SEQUENCE SEQID
START WITH 300
INCREMENT BY 1 -- 기본이 1임, 생략해도 됨
 MAXVALUE 310
 NOCYCLE NOCACHE;
 
 INSERT INTO emp_copy (emp_id, emp_name, emp_no)
 VALUES (SEQID.NEXTVAL, '김영민', '977777-1234567');
 
 INSERT INTO emp_copy (emp_id, emp_name, emp_no)
 VALUES (TO_CHAR(SEQID.NEXTVAL), '구구구', '877777-1234567');
 
 SELECT * FROM emp_copy;
 
 -- 시퀀스 수정 ----------------------------------------
 /*
 주의 : START WITH 는 변경 못 함
        변경을 원하면 시퀀스 삭제하고 새로 만들기 함
        
작성형식 :
ALTER SEQUENCE 시퀀스 이름
[INCREMENT BY N]
[MAXVALUE N | NOMAXVALUE]
[MINVALUE N | NOMINVALUE]
[CYCLE | NOCYCLE]
[CACHE N | COCACHE]
;

변경한 이후에 바로 사용하면, 수정된 내용이 적용됨
 */

-- 시퀀스 수정 예 :
CREATE SEQUENCE SEQID2
START WITH 300
INCREMENT BY 1
MAXVALUE 310
NOCYCLE NOCACHE;

SELECT SEQID2.NEXTVAL FROM DUAL; --300
SELECT SEQID2.NEXTVAL FROM DUAL; --301

ALTER SEQUENCE SEQID2
INCREMENT BY 5;

-- 확인
SELECT SEQID2.NEXTVAL FROM DUAL; --306

-- 시퀀스 삭제 -------------------------------------------------
-- DROP SEQUENCE 시퀀스이름;
DROP SEQUENCE SEQID2;




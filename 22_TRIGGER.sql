-- 22_TRIGGER.sql

-- 트리거 (TRIGGER) 객체
-- 데이터베이스 이벤트 객체임
-- 주로 테이블에 DML(INSERT, UPDATE, DELETE) 이 수행될 때
-- 다른 테이블에도 자동으로 함께 DML을 작동시킬 때 이용함
/*
작성형식 :
CREATE OR REPLACE TRIGGER 트리거이름
[BEFORE | AFTER] -- 이벤트 발생 시점을 지종
[INSERT | UPDATE | DELTE] ON 테이블명 -- 이벤트 발생 대상
FOR EACH ROW -- 개별 행단위로 실행을 의미함
[WHEN 조건식] -- 대상 행에 대한 이벤트 조건 지정
BEGIN
    다른 테이블에 수행하여는 DML 구문 작성; -- 실행시킬 이벤트 내용
END;

트리거 수정구문 없음 => ALTER TRIGGER 없음
트리거 삭제 : DROP TRIGGER 트리거이름;
*/

-- 화면(콘솔)에 내용을 출력시키기 위한 설정값 확인
SHOW SERVEROUTPUT; 
-- OFF 상태이면 ON 으로 바꿈
SET SERVEROUTPUT ON;

-- 샘플 테이블 만들기 :
-- 테이블의 컬럼 구조만 복사해 옴
DROP TABLE empcpy;
CREATE TABLE empcpy
AS
SELECT emp_id, emp_name, dept_id
FROM employee
WHERE 1 = 0; -- 구조만 복사해 오게 함

DESC empcpy; -- 컬럼 구조만 복사함
SELECT * FROM empcpy; -- 데이터 없음

-- 특정 테이블에 DML이 수행이 되면, 자동으로 어떤 내용을 실행시키는 이벤트 객체 => 트리거임

-- 예 : EMPCPY 테이블에 INSERT 가 수행이 되고 나면(AFTER)
-- 자동으로 출력뷰(콘솔)에 환영메세지가 출력되는 이벤트가 실행되는 트리거 만들기
CREATE OR REPLACE TRIGGER TRI_WELCOME
AFTER INSERT ON empcpy
BEGIN
    DBMS_OUTPUT.PUT_LINE('입사를 환영합니다');
END;
/
-- / 실행을 의미함 (주석은 / 아래에 표기할 것);

-- / 때문에 구문 인식에 오류가 발생함
-- 이후 쿼리문 실행시 실행구문은 범위지정하고 실행하도록 함
-- sql developer 버그임

-- 트리거 자동 실행 확인
INSERT INTO empcpy VALUES('777', '홍순길', '90');

SELECT * FROM empcpy;

-- 실습 :
-- 직원 테이블(EMP03) 테이블에 새로웅ㄴ 직원 정보가 추가되면
-- 새 직원의 정보중 급여정보가 급여 테이블(SALARY)에 자동으로 추가 입력되는 트리고 설계

-- 직원 테이블
DROP TABLE emp03;
CREATE TABLE emp03(
    empno number(4) PRIMARY KEY,
    ename varchar2(15),
    sal number(7, 2)
);

-- 급여 테이블
CREATE TABLE SALARY(
    no number PRIMARY KEY,
    empno NUMBER(4),
    sal number(7,2)
);

-- SALARY 테이블의 no컬럼값 기록에 사용할 시퀀스 객체 만드리
CREATE SEQUENCE seq_salary_no
START WITH 1
INCREMENT  BY 1
NOCYCLE NOCACHE;

-- 트리거 만들기
CREATE OR REPLACE TRIGGER tri_salary
AFTER INSERT ON EMP03
FOR EACH ROW -- INSERT 된 값 사용시 필요함
BEGIN
    INSERT INTO salary
    VALUES (seq_salary_no.NEXTVAL, :NEW.empno, :NEW.sal);
END;
/

-- 트리거 자동 실행 확인 :
INSERT INTO emp03 VALUES (8888, '홍길수', 3500);
--TRUNCATE TABLE emp03;
SELECT * FROM emp03;
SELECT * FROM salary; -- emp03에 기록된 값이 salary에도 기록된 것 확인

-- 바인드 변수
-- FOR EACH ROW 사용시 이용할 수 있음
-- :NEW.컬럼명   => 새로 기록된 컬럼값
-- :OLD.컬럼명    => 기존에 기록되어 있던 컬럼값

-- 실습 :
-- 1. 상품 정보 저장용 상품테이블 만들기
-- 2. 상품에 대한 입고 정보 저장용 입고테이블 만들기
-- 3. 입고테이블에 제품이 입고되면(INSERT), 상품테이블 해당 상품의 재고량이 자동으로 변경되게 트리거
-- 4. 입고 테이블에 추가, 생성, 삭제가 실행되면, 상품테이블의 재고에 변화를  주는 트리거 설계

-- 1. 상품 테이블
CREATE TABLE 상품 (
    상품코드 CHAR(4) CONSTRAINT PK_상품 PRIMARY KEY,
    상품명 VARCHAR2(15) NOT NULL,
    제조사 VARCHAR2(15),
    소비자가격 NUMBER,
    재고수량 NUMBER DEFAULT 0        
);

-- 상품 등록 :
INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격)
VALUES ('a001', '마우스', 'LG', 1000);

INSERT INTO 상품 VALUES('a002', '키보드', '삼성', 50000, DEFAULT);
INSERT INTO 상품 VALUES('a003', '모니터', 'HP', 50000, DEFAULT);

COMMIT;
SELECT * FROM 상품;

-- 2. 입고 테이블
CREATE TABLE 입고 (
    입고번호 NUMBER PRIMARY KEY,
    상품코드 CHAR(4) REFERENCES 상품(상품코드),
    입고일자 DATE,
    입고수량 NUMBER,
    입고단가 NUMBER,
    입고금액 NUMBER
);

-- 입고번호에 사용될 시퀀스 만들기
CREATE SEQUENCE SEQ_입고번호
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

-- 입고수량과 입고단가를 가지고 입고금액을 계산하는 프로시저 만들기
-- 프로시저 : PL/SQL 구문 저장한 객체임
CREATE OR REPLACE PROCEDURE PROD_SP_INSERT(CODE CHAR, SU NUMBER, WON NUMBER)
IS
BEGIN
    INSERT INTO 입고
    VALUES(SEQ_입고번호.NEXTVAL, CODE, SYSDATE, SU, WON, SU * WON);
END;
/

-- 3. 입력 트리거 만들기
-- 입고 테이블에 상품에 대한 입고정보가 등록(INSERT)되면
-- 해당 상품의 입고수량에 대헤서
-- 상품테이블 해당 상품의 재고수량을 증가 처리하는 트리거

CREATE OR REPLACE TRIGGER TRI_PRODUCT_INSERT
AFTER INSERT ON 입고
FOR EACH ROW
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 + :NEW.입고수량
    WHERE 상품코드 = :NEW.상품코드;
END;
/

-- 수정 트리거 만들기 
-- 입고 테이블의 입고수량이 수정(변경, UPDATE)되면
-- 상품 테이블의 재고수량이 수정된 값으로 자동 변경되는 트리거
CREATE OR REPLACE TRIGGER TRI_PRODUCT_UPDATE
AFTER UPDATE ON 입고
FOR EACH ROW
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 - :OLD.입고수량 + :NEW.입고수량
    WHERE 상품코드 = :OLD.상품코드;
END;
/

-- 삭제 트리거 만들기
-- 입고 테이블에서 상품에 대한 행이 삭제되면
-- 상품 테이블의 해당 상품의 재고수량이 삭제된 행의 입고수량만큼 빼기하는 트리거
CREATE OR REPLACE TRIGGER TRI_PRODUCT_DELETE
AFTER DELETE ON 입고
FOR EACH ROW
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 - :OLD.입고수량
    WHERE 상품코드 = :OLD.상품코드;
END;
/

-- 트리거 자동 작동 확인 --------------------------------
-- 입고 테이블에 상품 등록하는 프로시저 실행함
-- EXCUTE 프로시저이름(전달값, 전달값, ....);
-- EXCUTE 는 단축 명령어로 EXEC 로 사용해도 됨
-- 프로시저에 전달값은 프로시저 만들 때 지정한 매개변수 갯수와 자료형 일치되게 사용해야함

-- 입력 트리거 작동
EXEC PROD_SP_INSERT('a002', 20, 5000);
EXEC PROD_SP_INSERT('a002', 10, 5000);

-- 확인
SELECT * FROM 입고;
SELECT * FROM 상품;

-- 수정 트리거 작동 학인
UPDATE 입고
SET 입고수량 = 15,
    입고금액 = 15 * 입고단가
WHERE 입고번호 = 2;

-- 확인
SELECT * FROM 입고; -- 압고 정보 변경 확인
SELECT * FROM 상품; -- 입고수량 변경에 대한 재고수량 변경 확인함

-- 삭제 트리거 작동 확인
DELETE FROM 입고
WHERE 입고번호 = 2;

-- 확인
SELECT * FROM 입고; -- 압고 정보 변경 확인
SELECT * FROM 상품; -- 입고수량 변경에 대한 재고수량 변경 확인함

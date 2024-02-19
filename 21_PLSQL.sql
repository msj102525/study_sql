-- 21_PLSQL.sql


-- PL/SQL
-- SQL에 절차적 프로그래밍 요소를 추가한 오라클 전용 데이터베이스 프로그래밍 언어

-- PS/SQL 유형 3가지
-- 이름없는(anonymus) PL/SQL 블럭 => PL/SQL 코드 작성해서 바로 실행함
-- PL/SQL 내용을 객체로 저장할 수 있음 => 프로시저(PROCEDURE), 함수(FUNCTION)
-- 프로시저는 리넡 기능 없음, 함수는 리턴 기능 있음

-- 유형 1 : PL/SQL 블럭
SET SERVEROUTPUT ON;

DECLARE -- 블럭의 시작
    -- 변수 선언부 : 변수명 자료형;
    BOX CHAR(3);
BEGIN -- 코드 작성부 시작
    -- SQL 구문을 사용해서 변수에 값 대입, 조건문, 반복문 등 사용
    SELECT emp_id
    INTO BOX -- BOX = EMP_ID 대입한다는 의미임
    FROM employee
    WHERE emp_name = '한선기';
    
    -- 출력 확인
    DBMS_OUTPUT.PUT_LINE(BOX);
    
END; -- 블럭의 끝
/ -- 바로 실행

-- 실습 :
-- '강중훈'의 사번과 이름을 조회해서, 변수에 저장하고 변수값 출력
-- 변수 : 사번(VEMPID), 이름(VENAME) 선언하고 사용
CREATE TABLE EMPCPY
AS
SELECT EMP_ID, EMP_NAME, DEPT_id
FROM employee;


SELECT * FROM EMPCPY;

DECLARE
--    VEMPID CHAR(3);
--    VENAME VARCHAR2(20);
    VEMPID EMPCPY.emp_id%type;
    VENAME empcpy.emp_name%type;
BEGIN
    SELECT
        dept_id,
        emp_name
    INTO VEMPID, VENAME
    FROM
        EMPCPY
    WHERE emp_name = '강중훈';
    
    SYS.DBMS_OUTPUT.PUT_LINE('사번 이름');
    DBMS_OUTPUT.put_line('------------');
    dbms_output.put_line(vempid || '  ' || vename);
END;
/

-- 실습 :
-- 사번을 입력('&메세지') 받아서 해당 사번의 직원 정보를 출력하는 PL/SQL 블럭 작성하기
-- 사번, 이름, 급여, 입사일 조회
-- 변수 선언 : 자료형은 컬럼 자료형에 맞춤
-- 조회한 결과를 변수에 저장해서 변수값들을 출력하기

DECLARE
    vempid employee.emp_id%TYPE;
    vename employee.emp_name%TYPE;
    vsal employee.salary%TYPE;
    vhdate employee.hire_date%TYPE;
BEGIN
    SELECT emp_id, emp_name, salary, hire_date
    INTO vempid, vename, vsal, vhdate
    FROM employee
    WHERE emp_id = '&사번';
    dbms_output.put_line(vempid || ', ' || vename || ', ' || vsal || ', ' || vhdate);
END;
/

-- 실습 : 조건문 사용
-- IF 조건 THEN 참 처리내용 ELSE 거짓 처리내용 END IF;
-- 직원의 이름을 입력받아, 해당 직원의 연봉을 구하는 PL/SQL 블럭 작성하시오
SET SERVEROUTPUT ON;

DECLARE
    vemp    employee%ROWTYPE; -- 행 참조변수 (한 행을 참조함)
    annsal number(15, 2);
BEGIN
    SELECT * 
    INTO vemp -- SELECT 해 온 한 행(ROW)의 정보를 저장하는 변수
    FROM employee
    WHERE emp_name = '&이름';
    
    IF (vemp.bonus_pct IS NULL) THEN
        annsal := vemp.salary * 12;
    ELSE
        annsal := (vemp.salary + (vemp.salary * vemp.bonus_pct)) * 12;
    END IF;
    
    dbms_output.put_line('사번   이름   연봉');
    dbms_output.put_line('-------------');
    dbms_output.put_line(vemp.emp_id || ' ' || vemp.emp_name || ' ' || annsal);
END;
/

-- 실습 : IF 조건 THEN 참 ELSE 거짓 END IF;
-- 사번을 입력받아 해당 직원의 전체 정보 조회 소속 부서코드를 이용해서 부서명을 출력
-- 사번, 이름, 부서코드, 부서명
-- 해당 직원의 부서코드가 NULL 이면 '소속부서 없음' 출력되게 함
-- 행 참조변수 사용함
SET SERVEROUTPUT ON;

DECLARE
    vemp employee%ROWTYPE;
    vdname department.dept_name%TYPE;
BEGIN
    SELECT *
    INTO vemp
    FROM
        employee
    WHERE emp_no = '&사번';
    
    IF vemp.dept_id IS NULL THEN
        vdname := '소속부서 없음';
    ELSE
        SELECT dept_name
        INTO vdname
        FROM department
        WHERE dept_id = vemp.dept_id;
    END IF;
    dbms_output.put_line(vemp.emp_id || vemp.emp_name || vemp.dept_id || vdname);
END;
/

--PL/SQL 반복문 ----------------------------------
-- BASIC LOOP, FOR LOOP, WHILE LOOP, EXIT (자바의 BREAK와 같음)

-- BASIC LOOP 문
-- 자바의 do ~ while 문과 같은 형태임.
/*
작성형식 :
LOOP
    반복 실행시킬 문장;
    ----..;
    IF 반복종료조건 THEN
        EXIT;
    END IF;
    또는
    EXIT [WHEN 반복종료조건];
END LOOP;
*/

-- 예제 > BASIC LOOP 문으로 1부터 5까지 출력하기
SET SERVEROUTPUT ON;
DECLARE
    n NUMBER:=1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(n);
        n := n+1;
        IF n > 5 THEN
            EXIT;
        END IF;
    END LOOP;
END;
/

-- FOR LOOP 문
-- FOR LOOP 문에서 카운트용 변수는 자동 선언되므로. 따로 변수 선언할 필요 없음
-- 카운트 값은 자동으로 1씩 증가함
-- REVERSE 는 1씩 감소함을 의미함
/*
작성형식 :
FOR 카운트용변수 IN [REVERSE] 시작값..종료값 LOOP
    반복 실행할 문장;
    .....
END LOOP;
*/

-- 예제 > FOR LOOP 문으로 1 부터 5까지 출력하기
DECLARE
BEGIN
    FOR n IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(n);
    END LOOP;
END;
/

-- 실습 > 1부터 10까지 반복하여 TEST1 테이블에 저장하기
CREATE TABLE TEST1(
    bunho NUMBER(3),
    irum VARCHAR2(10)
);

-- DECLARE -- 변수 선언이 없으면 생략해도 됨
BEGIN
    FOR no IN 1..10 LOOP
        INSERT INTO TEST1 VALUES(no, TO_CHAR(no || '번'));
    END LOOP;
    
    COMMIT;
END;
/
-- 확인
SELECT * FROM test1;
TRUNCATE TABLE test1;

-- 실습 2> 구구단의 홀수단만 출력되게 하기(for문, if문 혼합)
DECLARE
    result NUMBER;
BEGIN
    FOR dan in 2..9 LOOP
    IF MOD(dan, 2) = 1 THEN
        FOR su IN 1..9 LOOP
            result := dan * su;
            DBMS_OUTPUT.PUT_LINE(dan || ' * ' || su || ' = ' || result);
            END LOOP;
        END IF;        
    END LOOP;
END;
/

-- WHILE LOOP 문
-- 제어 조건이 TRUE 인 동안만 문장이 반복 실행됨
-- LOOP를  실행할 때 조건이 처음부터 FALSE이면 한번도 수행되지 않을 경우도 있음

/*
작성형식 :
WHILE 반복시킬조건식 LOOP
    반복실행할 구문;
    .....
END LOOP;
*/

-- 예제> WHILE LOOP 문으로 1부터 5까지 출력하기
DECLARE
    n NUMBER := 1;
BEGIN
    WHILE n<5 LOOP
        DBMS_OUTPUT.PUT_LINE(n);
        n := n+1;
    END LOOP;
END;
/

-- 실습 2> 구구단의 홀수단만 출력되게 하기
-- WHILE LOOP 사용
DECLARE
    RESULT NUMBER;
    DAN NUMBER := 2;
     SU NUMBER;
BEGIN
    WHILE DAN <= 9 LOOP
     SU := 1;
        WHILE SU <= 9 LOOP
        RESULT := DAN * SU;
        IF MOD(RESULT, 2) = 1 THEN
             DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || RESULT);
        END IF;
        SU := SU + 1;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE(' ');
    DAN := DAN + 1;
    END LOOP;
END;
/

-- PL/SQL 블럭의 EXCEPTION (예외) 처리 ********************
-- 예 > UNIQUE INDEX 가 설정된 컬럼에 중복값 입력한 경우의 예외처리
CREATE TABLE EXAM_MEMBERS (
    mid VARCHAR2(20) PRIMARY KEY,
    pwd VARCHAR2(20),
    name VARCHAR2(20)
);

INSERT INTO EXAM_MEMBERS VALUES ('javaKING', '111', '자바낑');
COMMIT;

SELECT * FROM EXAM_MEMBERS;

-- PL/SQL 블럭의 예외처리 :
BEGIN
    INSERT INTO EXAM_MEMBERS VALUES ('javaKING', '111', '자바낑');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('회원의 아이디가 중복되었습니다');
END;
/

-- 시스템이 제공하는 예외이름을 모르거나, 이름이 제공되지 않는 에러가 발생한 경우
-- 예외로 다루려면 직접 예외이름을 정의하면 됨
DECLARE
    TOOLARGE_MID EXCEPTION;
    PRAGMA EXCEPTION_INIT(TOOLARGE_MID, -12899);
BEGIN
    INSERT INTO EXAM_MEMBERS VALUES ('javaKING111111111111111111111111111', '111', '자바낑');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('회원의 아이디가 중복되었습니다');
    WHEN TOOLARGE_MID THEN
        DBMS_OUTPUT.PUT_LINE('아이디가 지정된 바이트수를 초과하였습니다');
END;
/

--실습> 아이디와 암호를 입력받아,
-- 아이디와 암호는 글자갯수가 10 글자이상 15 글자 미만일 때만 정상 출력하고
-- 글자 갯수가 10 글자 미만이면, TOOSHORT 에외 발생시키고 
-- 글자 갯수가 15 글자 이상이면, TOOLONG 예외 발생시키도록 PL/SQL 구문을작성하시오.
-- TOOLONG 은 제공되는 오류코드 -12899 에 대해 매핑하고,
-- TOOSHORT 는 오류코드를 -20001 로 새로 정하고, 메세지는 '글자갯수부족'으로 처리함
---- 아이디는 같은 값 두번 입력못하게 중복 예외 적용함.
---- 아이디 중복 예외 테스트용 초기값 대입한 아이디 변수 따로 준비해 놓음
---- 입력된 아이디와 준비된 변수값이 같으면 중복 예외 발생시킴
-- 참고 : (RAISE_APPLICATION_ERROR(-에러코드, 출력메세지);

DECLARE
    vid VARCHAR2(14) := 'STUDENT0123';
    v_id VARCHAR2(14);
    v_pwd varchar2(14);
    TOOSHORT EXCEPTION;
    TOOLONG EXCEPTION;
    PRAGMA EXCEPTION_INIT(TOOLONG, -12899);
    PRAGMA EXCEPTION_INIT(TOOSHORT, -20001);
BEGIN
    v_id := '&id';
    v_pwd := '&pwd';
    
    IF (LENGTH(V_ID) < 10 OR LENGTH(V_PWD) < 10) THEN
        RAISE_APPLICATION_ERROR(-20001, '글자 갯수 부족');
    END IF;

    IF VID = V_ID THEN
        RAISE DUP_VAL_ON_INDEX;
     END IF;
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('아이디가 중복되었습니다');
    WHEN TOOLONG THEN
        DBMS_OUTPUT.PUT_LINE('글자 갯수 범위 초과');
    WHEN TOOSHORT THEN
        DBMS_OUTPUT.PUT_LINE('글자 갯수 부족');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('알수 없는 오류가 발생');
END;
/

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








-- 23_프로시저_함수.sql

SELECT * FROM emp_copy;

-- 프로시저 만들기
-- 예 : EMP_COPY 테이브의 모든 행을 삭제하는 프로시저
CREATE OR REPLACE PROCEDURE PR_ECOPY_DEL
IS
BEGIN
    DELETE FROM EMP_COPY;
    COMMIT;
END;
/

-- 프로시저 실행
EXECUTE PR_ECOPY_DEL;
-- 축약 명령어 사용 : EXEC PR_ECOPY_DEL
-- 확인
SELECT * FROM EMP_COPY;

-- 프로시저 관련 데이터 딕셔너리 확인
DESC USER_SOURCE;

SELECT NAME, TEXT FROM USER_SOURCE;
-- 트리거 소스도 같이 저장되어 있음

-- 매개변수가 있는 프로시저 만들기
-- 예 : 직원 이름 또는 이름패턴을 전달받아서, 해당 값이 기록된 행들을 삭제
SELECT * FROM EMPCPY;

DROP TABLE EMPCPY CASCADE CONSTRAINTS;

CREATE TABLE EMPCPY
AS
SELECT EMP_ID, EMP_NAME, DEPT_ID
FROM employee;

SELECT *FROM empcpy;

-- 프로시저 만들기
CREATE OR REPLACE PROCEDURE DEL_ENAME(VENAME IN EMPCPY.emp_name%TYPE)
IS
BEGIN
    DELETE FROM empcpy
    WHERE emp_name LIKE vename;
    COMMIT;
END;
/

EXEC DEL_ENAME('이%'); -- 성이 이씨인 직원 정보 삭제

-- 삭제 확인
SELECT * FROM EMPCPY
WHERE emp_name LIKE '이%'; -- 이씨 성을 가진 직원 없는지 확인

SELECT * FROM EMPCPY; -- 행 갯수 줄었는지 확인

-- IN 모드, OUT 모드 매개변수 있는 프로시저 만들기
-- 예 : 사번을 전달받아 (IN), 해당 직원의 이름, 급여, 직급코드를 조회해서
-- 조회된 3개의 값을 내보내는(OUT) 프로시저
SELECT * FROM EMPLOYEE;

CREATE OR REPLACE PROCEDURE SEL_EMP(
    vempid IN EMPLOYEE.emp_id%TYPE,
    vename OUT EMPLOYEE.emp_name%TYPE,
    vsal OUT EMPLOYEE.salary%TYPE,
    vjob OUT EMPLOYEE.job_id%TYPE
)
IS
BEGIN
    SELECT emp_name, salary, job_id
    INTO vename, vsal, vjob
    FROM EMPLOYEE
    WHERE emp_id = vempid;
END;
/

-- 프로시저 실행
-- 실행할 프로시저의 OUT 모드 매개변수가 있을 때는 값을 받아줄 변수부터 만들어야 함
-- 변수 만들기 : VARIABLE 변수명 자료형(크기)
VARIABLE var_ename VARCHAR2(20);
VARIABLE var_sal NUMBER;
VARIABLE var_job CHAR(2);

-- EXEC 프로시저이름(IN모드매개변수로 전달할 값, :OUT모드변수가 가진 값 받을 변수명);
EXEC SEL_EMP('&사번', :var_ename, :var_sal, :var_job);

-- 변수가 받은 값 확인
PRINT var_ename;
PRINT var_sal;
PRINT var_job;

-- 실습 :
-- 부서번호를 전달받아, 해당 부서를 삭제하는 프로시저
-- 프로시저 이름 : DEL_DEPTID

DROP TABLE DEPT_COPY CASCADE CONSTRAINTS;

CREATE TABLE DEPT_COPY
AS
SELECT * FROM DEPARTMENT;

CREATE OR REPLACE PROCEDURE DEL_DEPTID(vdid IN dept_copy.dept_id%TYPE)
IS
BEGIN
    DELETE FROM DEPT_COPY
    WHERE dept_id = vdid;
    COMMIT;
END;
/

-- 프로시저 실행
EXEC DEL_DEPTID('&부서번호');
-- 80 입력시

-- 확인
SELECT * FROM dept_copy; -- 80번 부서 삭제 확인

-- 실습 :
-- 직원이름을 전달받아 직원 정보 삭제하고, '이름 이 퇴사하였습니다' 출력 프로시저
-- 프로시저 이름 : DEL_ENAME

DROP TABLE EMP_COPY CASCADE CONSTRAINTS;

CREATE TABLE EMP_COPY
AS
SELECT * FROM EMPLOYEE;

SET SERVEROUT ON;

CREATE OR REPLACE PROCEDURE DEL_ENAME(vename IN EMP_COPY.emp_name%TYPE)
IS
BEGIN
    DELETE FROM EMP_COPY
    WHERE emp_name = vename;
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE(vename || '이 퇴사함');
END;
/
EXEC DEL_ENAME('&직원이름');

-- 확인
SELECT * FROM EMP_COPY
WHERE emp_name = '강중훈';

-- ***************************************************************************
-- 함수 (FUNCTION) 객체
-- 프로시저와 다른 점은 RETURN을 사용함

-- 실습 : 
-- 사번을 전달받아, 해당 직원의 보너스를 계산해서 리턴하는 함수 작성
-- 함수명 : BONUS_CALC

CREATE OR REPLACE FUNCTION BONUS_CALC(vempid IN EMPLOYEE.emp_id%TYPE)
RETURN NUMBER -- 리턴값의 자료형 명시함
IS
    vsal EMPLOYEE.salary%TYPE;
    RESULT NUMBER;
BEGIN
    SELECT salary
    INTO vsal
    FROM EMPLOYEE
    WHERE emp_id = vempid;
    
    RESULT := vsal * 2;
    RETURN RESULT; -- 프로시저와 다른 점
END;
/

-- 함수 실행
-- 함수 실행 전에 리턴값 받을 바인드변수 만들기함
VARIABLE BONUS NUMBER;

EXECUTE :BONUS := BONUS_CALC('&사번');

PRINT BONUS;

SELECT salary
FROM employee
WHERE emp_id = '141';

-- ******************************************************
-- 패키지 (PACKAGE)
-- 프로시저와 함수를 따로 묶어서 관리하는 객체
-- 선언에 대한 구문과 코드 구현에 대한 BODY로 두 번 따로 작성해야 함

/*
선언부 작성형식 : 
CREATE OR REPLACE PACKAGE 패키지명
IS
    -- 프로시저 선언
    PROCEDURE 프로시저이름 (매개변수 모드 자료형, .....);
    -- 함수 선언
    FUCTION 함수명 (매개변수 모드 자료형, ....) RETURN 반환자료형;
END;
/
*/

/*
구현부 작성형식 : 
CREATE OR REPLACE PACKAGE BODY 선언한패키지명
IS
    -- 선언부에서 선언한 프로시저 구현
    PROCEDURE 프로시저이름 (매개변수명 모드 자료형, ...)
    IS
        지역변수 선언
    BEGIN
        -- 프로시저 코드 구현
    END; -- 프로시저 종료
    -- 선언부에서 선언한 함수 구현
    FUCTION 함수명 (매개변수 모드 자료형, ....) 
    RETURN 반환자료형;
    IS
        지역변수 선언
    BEGIN
        -- 함수 코드 구현
        RETURN 반환값;
    END; -- 함수 끝
END;
/
*/

-- 패키지 선언
CREATE OR REPLACE PACKAGE PMEMBER
IS
    PROCEDURE DEL_DEPTNO(delno IN DEPT_COPY.dept_id%TYPE);
    FUNCTION CAL_BONUS(vename IN EMPLOYEE.emp_name%TYPE) RETURN NUMBER;
END PMEMBER;
/

-- 패키지 구현
CREATE OR REPLACE PACKAGE BODY PMEMBER
IS
    PROCEDURE DEL_DEPTNO(delno IN DEPT_COPY.dept_id%TYPE)
    IS
    BEGIN
        DELETE FROM DEPT_COPYㄴ
        WHERE dept_id = delno;
        COMMIT;
        
        DBMS_OUTPUT.PUT_LINE(delno || '번 부서가 삭제되었습니다');
    END DEL_DEPTNO;
    
    FUNCTION CAL_BONUS(vename IN EMPLOYEE.emp_name%TYPE) RETURN NUMBER
    IS
        vsal EMPLOYEE.salary%TYPE;
        result NUMBER;
    BEGIN
        SELECT salary
        INTO vsal
        FROM employee
        WHERE emp_name = vename;
        
        result := vsal * 2;
        RETURN result;    
    END CAL_BONUS;
END PMEMBER;
/

-- 패키지 적용 프로시저와 함수 실행
SET SERVEROUT ON

EXECUTE PMEMBER.DEL_DEPTNO('&부서번호');

-- 함수 실행 
VARIABLE BONUS NUMBER;
EXEC :BONUS := PMEMBER.CAL_BONUS('&사원명');
PRINT BONUS;

-- ***************************************************************
-- 커서 (CURSOR)
-- SELECT 쿼리문의 실행 결과(RESULT SET)에 대한 결과행의 갯수가 여러개일 때
-- PL/SQL에서 행들을 하나씩 다루고자 할 때 사용하는 객체임
-- 자바의 객체배열의 인덱스(순번)와 비슷한 개념
-- 또는 자바 컬렉션의 Iterdator 와 비슷한 처리 구조를 가지고 있음

-- 실습 
-- 부서 테이블의 모든 행을 조회한 다음, 커서를 이요해서 한 행씩 처리
SET SERVEROUT ON;

-- PL/SQL 블럭 :
DECLARE
    v_dept DEPARTMENT%ROWTYPE; -- 행 참조변수
    -- v_dept.dept_id, v_dept.dept_name, v_dept.loc_id
    CURSOR C1 IS SELECT * FROM DEPARTMENT;
    -- 커서가 실행시킬 SELECT 쿼리문 지정함
BEGIN
    DBMS_OUTPUT.PUT_LINE('부서번호   부서명   지역번호');
    DBMS_OUTPUT.PUT_LINE('----------------------');
    
    OPEN C1; -- 커서를 통해 지정된 쿼리문 실행시켜서 결과를 저장함
    LOOP
        FETCH C1 -- 저장된 결과 행의 첫행을 참조해라 => 참조한 행의 컬럼값들을 처리함 : 반복 처리
        INTO v_dept.dept_id, v_dept.dept_name, v_dept.loc_id; -- 각 변수에 값 저장
        
        EXIT WHEN C1%NOTFOUND; -- 커사가 패치하는 행이 없다면 반복 종료
        
        DBMS_OUTPUT.PUT_LINE(v_dept.dept_id || ', ' || v_dept.dept_name || ', ' || v_dept.loc_id);
    END LOOP;
    CLOSE C1; -- 메모리에 저장된 결과집합 삭제함
END;
/









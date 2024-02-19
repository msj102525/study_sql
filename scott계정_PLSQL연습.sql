-- PL/SQL 선택문 연습

--IF ~ THEN ~ END IF 문
-- 부서번호로 부서명 알아내기
SHOW SERVEROUTPUT;
SET SERVEROUTPUT ON;

DECLARE
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vdeptno emp.deptno%TYPE;
    vdname VARCHAR2(20) := NULL;
BEGIN
    SELECT empno, ename, deptno
    INTO vempno, vename, vdeptno
    FROM emp
    WHERE empno = '&empno'`;
    
    IF (vdeptno = 10) THEN
        vdname :=  'ACCOUNTING';
    END IF;
    IF (vdeptno = 20) THEN
        vdname := 'RESEARCH';
    END IF;
    IF (vdeptno = 30) THEN
        vdname := 'SALES';
    END IF;
    IF (vdeptno = 40) THEN
        vdname := 'OPERATIONS';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번     이름     부서명');
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
    DBMS_OUTPUT.PUT_LINE(vempno || '  ' || vename || '   ' || vdname);
END;
/

-- IF ~ THEN ~ ELSE ~ END IF 문
-- 연봉 구하기

DECLARE
    vemp emp%ROWTYPE;
    annsal NUMBER(7, 2);
BEGIN
    SELECT *
    INTO vemp
    FROM emp
    WHERE ename = '&ename';
    
    IF (vemp.comm IS NULL) THEN
        annsal := vemp.sal * 12;
    ELSE
        annsal := vemp.sal * 12 + vemp.comm;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번     이름     부서명');
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
    DBMS_OUTPUT.PUT_LINE(vemp.empno || '  ' || vemp.ename || '   ' || annsal);
END;
/

DECLARE
    vempno emp.empno%TYPE;
    vcomm emp.comm%TYPE;
    vename emp.ename%TYPE;
BEGIN
    SELECT empno, ename, comm
    INTO vempno, vename, vcomm
    FROM emp
    WHERE empno = '&empno';
    
    IF (vcomm IS NULL OR vcomm = 0) THEN
        DBMS_OUTPUT.PUT_LINE('사번' || vempno || '은 ' || vename || '사원이고 커미션을 받지 않습니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('사번' || vempno || '은 ' || vename || '사원이고' || vcomm || '을 받습니다.' );
END IF;
END;
/


-- IF ~ THEN ~ ELSEIF ~ ELSE ~ END IF 문
-- 부서번호로 부서명 알아내기
DECLARE
    score int;
    grade VARCHAR2(2);
BEGIN
    score := &score;
IF score>=90 THEN
    Grade :='A';
ELSIF score>=80 THEN
    Grade :='B';
ELSIF score >=70 THEN
    grade :='C';
ELSIF score >=60 THEN
    grade :='D';
ELSE grade :='F';
END IF;
    DBMS_OUTPUT.PUT_LINE('당신의 SCOR 는 ' || score || '점이고,' || 'Grade 는 ' || grade || '입니다.');
END;
/

--CASE 문 자바의 switch 문과 같음.

DECLARE
    vempno EMP.EMPNO%TYPE;
    vename EMP.ENAME%TYPE;
    vdeptno EMP.DEPTNO%TYPE;
    vdname VARCHAR(20) := null;
BEGIN
    SELECT EMPNO, ENAME, DEPTNO
    INTO vempno, vename, vdeptno
    FROM EMP
    WHERE EMPNO = &EMPNO;
    vdname := CASE vdeptno
    WHEN 10 THEN 'ACCOUNT'
    WHEN 20 THEN 'RESEARCH'
    WHEN 30 THEN 'SALES'
    WHEN 40 THEN 'OPERATIONS'
END;

    DBMS_OUTPUT.PUT_LINE (VEMPNO || ' ' || VENAME || ' ' ||VDEPTNO || ' ' || VDNAME);
END;
/

--조건없이 반복 작업을 제공하기 위한 BASIC LOOP 문
--- COUNT 를 기본으로 작업의 반복 제어를 제공하는 FOR LOOP 문
--- 조건을 기본으로 작업의 반복 제어를 제공하기 위한 WHILE LOOP 문
--- LOOP 를 종료하기 위한 EXIT 문

-- 예제> BASIC LOOP 문으로 1 부터 5 까지 출력하기
DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE(N);
    N := N + 1;
    IF N > 5 THEN
    EXIT;
    END IF;
    END LOOP;
END;
/









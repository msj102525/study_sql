-- 23_���ν���_�Լ�.sql

SELECT * FROM emp_copy;

-- ���ν��� �����
-- �� : EMP_COPY ���̺��� ��� ���� �����ϴ� ���ν���
CREATE OR REPLACE PROCEDURE PR_ECOPY_DEL
IS
BEGIN
    DELETE FROM EMP_COPY;
    COMMIT;
END;
/

-- ���ν��� ����
EXECUTE PR_ECOPY_DEL;
-- ��� ��ɾ� ��� : EXEC PR_ECOPY_DEL
-- Ȯ��
SELECT * FROM EMP_COPY;

-- ���ν��� ���� ������ ��ųʸ� Ȯ��
DESC USER_SOURCE;

SELECT NAME, TEXT FROM USER_SOURCE;
-- Ʈ���� �ҽ��� ���� ����Ǿ� ����

-- �Ű������� �ִ� ���ν��� �����
-- �� : ���� �̸� �Ǵ� �̸������� ���޹޾Ƽ�, �ش� ���� ��ϵ� ����� ����
SELECT * FROM EMPCPY;

DROP TABLE EMPCPY CASCADE CONSTRAINTS;

CREATE TABLE EMPCPY
AS
SELECT EMP_ID, EMP_NAME, DEPT_ID
FROM employee;

SELECT *FROM empcpy;

-- ���ν��� �����
CREATE OR REPLACE PROCEDURE DEL_ENAME(VENAME IN EMPCPY.emp_name%TYPE)
IS
BEGIN
    DELETE FROM empcpy
    WHERE emp_name LIKE vename;
    COMMIT;
END;
/

EXEC DEL_ENAME('��%'); -- ���� �̾��� ���� ���� ����

-- ���� Ȯ��
SELECT * FROM EMPCPY
WHERE emp_name LIKE '��%'; -- �̾� ���� ���� ���� ������ Ȯ��

SELECT * FROM EMPCPY; -- �� ���� �پ����� Ȯ��

-- IN ���, OUT ��� �Ű����� �ִ� ���ν��� �����
-- �� : ����� ���޹޾� (IN), �ش� ������ �̸�, �޿�, �����ڵ带 ��ȸ�ؼ�
-- ��ȸ�� 3���� ���� ��������(OUT) ���ν���
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

-- ���ν��� ����
-- ������ ���ν����� OUT ��� �Ű������� ���� ���� ���� �޾��� �������� ������ ��
-- ���� ����� : VARIABLE ������ �ڷ���(ũ��)
VARIABLE var_ename VARCHAR2(20);
VARIABLE var_sal NUMBER;
VARIABLE var_job CHAR(2);

-- EXEC ���ν����̸�(IN���Ű������� ������ ��, :OUT��庯���� ���� �� ���� ������);
EXEC SEL_EMP('&���', :var_ename, :var_sal, :var_job);

-- ������ ���� �� Ȯ��
PRINT var_ename;
PRINT var_sal;
PRINT var_job;

-- �ǽ� :
-- �μ���ȣ�� ���޹޾�, �ش� �μ��� �����ϴ� ���ν���
-- ���ν��� �̸� : DEL_DEPTID

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

-- ���ν��� ����
EXEC DEL_DEPTID('&�μ���ȣ');
-- 80 �Է½�

-- Ȯ��
SELECT * FROM dept_copy; -- 80�� �μ� ���� Ȯ��

-- �ǽ� :
-- �����̸��� ���޹޾� ���� ���� �����ϰ�, '�̸� �� ����Ͽ����ϴ�' ��� ���ν���
-- ���ν��� �̸� : DEL_ENAME

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
    
    DBMS_OUTPUT.PUT_LINE(vename || '�� �����');
END;
/
EXEC DEL_ENAME('&�����̸�');

-- Ȯ��
SELECT * FROM EMP_COPY
WHERE emp_name = '������';

-- ***************************************************************************
-- �Լ� (FUNCTION) ��ü
-- ���ν����� �ٸ� ���� RETURN�� �����

-- �ǽ� : 
-- ����� ���޹޾�, �ش� ������ ���ʽ��� ����ؼ� �����ϴ� �Լ� �ۼ�
-- �Լ��� : BONUS_CALC

CREATE OR REPLACE FUNCTION BONUS_CALC(vempid IN EMPLOYEE.emp_id%TYPE)
RETURN NUMBER -- ���ϰ��� �ڷ��� �����
IS
    vsal EMPLOYEE.salary%TYPE;
    RESULT NUMBER;
BEGIN
    SELECT salary
    INTO vsal
    FROM EMPLOYEE
    WHERE emp_id = vempid;
    
    RESULT := vsal * 2;
    RETURN RESULT; -- ���ν����� �ٸ� ��
END;
/

-- �Լ� ����
-- �Լ� ���� ���� ���ϰ� ���� ���ε庯�� �������
VARIABLE BONUS NUMBER;

EXECUTE :BONUS := BONUS_CALC('&���');

PRINT BONUS;

SELECT salary
FROM employee
WHERE emp_id = '141';

-- ******************************************************
-- ��Ű�� (PACKAGE)
-- ���ν����� �Լ��� ���� ��� �����ϴ� ��ü
-- ���� ���� ������ �ڵ� ������ ���� BODY�� �� �� ���� �ۼ��ؾ� ��

/*
����� �ۼ����� : 
CREATE OR REPLACE PACKAGE ��Ű����
IS
    -- ���ν��� ����
    PROCEDURE ���ν����̸� (�Ű����� ��� �ڷ���, .....);
    -- �Լ� ����
    FUCTION �Լ��� (�Ű����� ��� �ڷ���, ....) RETURN ��ȯ�ڷ���;
END;
/
*/

/*
������ �ۼ����� : 
CREATE OR REPLACE PACKAGE BODY ��������Ű����
IS
    -- ����ο��� ������ ���ν��� ����
    PROCEDURE ���ν����̸� (�Ű������� ��� �ڷ���, ...)
    IS
        �������� ����
    BEGIN
        -- ���ν��� �ڵ� ����
    END; -- ���ν��� ����
    -- ����ο��� ������ �Լ� ����
    FUCTION �Լ��� (�Ű����� ��� �ڷ���, ....) 
    RETURN ��ȯ�ڷ���;
    IS
        �������� ����
    BEGIN
        -- �Լ� �ڵ� ����
        RETURN ��ȯ��;
    END; -- �Լ� ��
END;
/
*/

-- ��Ű�� ����
CREATE OR REPLACE PACKAGE PMEMBER
IS
    PROCEDURE DEL_DEPTNO(delno IN DEPT_COPY.dept_id%TYPE);
    FUNCTION CAL_BONUS(vename IN EMPLOYEE.emp_name%TYPE) RETURN NUMBER;
END PMEMBER;
/

-- ��Ű�� ����
CREATE OR REPLACE PACKAGE BODY PMEMBER
IS
    PROCEDURE DEL_DEPTNO(delno IN DEPT_COPY.dept_id%TYPE)
    IS
    BEGIN
        DELETE FROM DEPT_COPY��
        WHERE dept_id = delno;
        COMMIT;
        
        DBMS_OUTPUT.PUT_LINE(delno || '�� �μ��� �����Ǿ����ϴ�');
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

-- ��Ű�� ���� ���ν����� �Լ� ����
SET SERVEROUT ON

EXECUTE PMEMBER.DEL_DEPTNO('&�μ���ȣ');

-- �Լ� ���� 
VARIABLE BONUS NUMBER;
EXEC :BONUS := PMEMBER.CAL_BONUS('&�����');
PRINT BONUS;

-- ***************************************************************
-- Ŀ�� (CURSOR)
-- SELECT �������� ���� ���(RESULT SET)�� ���� ������� ������ �������� ��
-- PL/SQL���� ����� �ϳ��� �ٷ���� �� �� ����ϴ� ��ü��
-- �ڹ��� ��ü�迭�� �ε���(����)�� ����� ����
-- �Ǵ� �ڹ� �÷����� Iterdator �� ����� ó�� ������ ������ ����

-- �ǽ� 
-- �μ� ���̺��� ��� ���� ��ȸ�� ����, Ŀ���� �̿��ؼ� �� �྿ ó��
SET SERVEROUT ON;

-- PL/SQL �� :
DECLARE
    v_dept DEPARTMENT%ROWTYPE; -- �� ��������
    -- v_dept.dept_id, v_dept.dept_name, v_dept.loc_id
    CURSOR C1 IS SELECT * FROM DEPARTMENT;
    -- Ŀ���� �����ų SELECT ������ ������
BEGIN
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ   �μ���   ������ȣ');
    DBMS_OUTPUT.PUT_LINE('----------------------');
    
    OPEN C1; -- Ŀ���� ���� ������ ������ ������Ѽ� ����� ������
    LOOP
        FETCH C1 -- ����� ��� ���� ù���� �����ض� => ������ ���� �÷������� ó���� : �ݺ� ó��
        INTO v_dept.dept_id, v_dept.dept_name, v_dept.loc_id; -- �� ������ �� ����
        
        EXIT WHEN C1%NOTFOUND; -- Ŀ�簡 ��ġ�ϴ� ���� ���ٸ� �ݺ� ����
        
        DBMS_OUTPUT.PUT_LINE(v_dept.dept_id || ', ' || v_dept.dept_name || ', ' || v_dept.loc_id);
    END LOOP;
    CLOSE C1; -- �޸𸮿� ����� ������� ������
END;
/









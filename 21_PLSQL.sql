-- 21_PLSQL.sql


-- PL/SQL
-- SQL�� ������ ���α׷��� ��Ҹ� �߰��� ����Ŭ ���� �����ͺ��̽� ���α׷��� ���

-- PS/SQL ���� 3����
-- �̸�����(anonymus) PL/SQL �� => PL/SQL �ڵ� �ۼ��ؼ� �ٷ� ������
-- PL/SQL ������ ��ü�� ������ �� ���� => ���ν���(PROCEDURE), �Լ�(FUNCTION)
-- ���ν����� ���� ��� ����, �Լ��� ���� ��� ����

-- ���� 1 : PL/SQL ��
SET SERVEROUTPUT ON;

DECLARE -- ���� ����
    -- ���� ����� : ������ �ڷ���;
    BOX CHAR(3);
BEGIN -- �ڵ� �ۼ��� ����
    -- SQL ������ ����ؼ� ������ �� ����, ���ǹ�, �ݺ��� �� ���
    SELECT emp_id
    INTO BOX -- BOX = EMP_ID �����Ѵٴ� �ǹ���
    FROM employee
    WHERE emp_name = '�Ѽ���';
    
    -- ��� Ȯ��
    DBMS_OUTPUT.PUT_LINE(BOX);
    
END; -- ���� ��
/ -- �ٷ� ����

-- �ǽ� :
-- '������'�� ����� �̸��� ��ȸ�ؼ�, ������ �����ϰ� ������ ���
-- ���� : ���(VEMPID), �̸�(VENAME) �����ϰ� ���
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
    WHERE emp_name = '������';
    
    SYS.DBMS_OUTPUT.PUT_LINE('��� �̸�');
    DBMS_OUTPUT.put_line('------------');
    dbms_output.put_line(vempid || '  ' || vename);
END;
/

-- �ǽ� :
-- ����� �Է�('&�޼���') �޾Ƽ� �ش� ����� ���� ������ ����ϴ� PL/SQL �� �ۼ��ϱ�
-- ���, �̸�, �޿�, �Ի��� ��ȸ
-- ���� ���� : �ڷ����� �÷� �ڷ����� ����
-- ��ȸ�� ����� ������ �����ؼ� ���������� ����ϱ�

DECLARE
    vempid employee.emp_id%TYPE;
    vename employee.emp_name%TYPE;
    vsal employee.salary%TYPE;
    vhdate employee.hire_date%TYPE;
BEGIN
    SELECT emp_id, emp_name, salary, hire_date
    INTO vempid, vename, vsal, vhdate
    FROM employee
    WHERE emp_id = '&���';
    dbms_output.put_line(vempid || ', ' || vename || ', ' || vsal || ', ' || vhdate);
END;
/

-- �ǽ� : ���ǹ� ���
-- IF ���� THEN �� ó������ ELSE ���� ó������ END IF;
-- ������ �̸��� �Է¹޾�, �ش� ������ ������ ���ϴ� PL/SQL �� �ۼ��Ͻÿ�
SET SERVEROUTPUT ON;

DECLARE
    vemp    employee%ROWTYPE; -- �� �������� (�� ���� ������)
    annsal number(15, 2);
BEGIN
    SELECT * 
    INTO vemp -- SELECT �� �� �� ��(ROW)�� ������ �����ϴ� ����
    FROM employee
    WHERE emp_name = '&�̸�';
    
    IF (vemp.bonus_pct IS NULL) THEN
        annsal := vemp.salary * 12;
    ELSE
        annsal := (vemp.salary + (vemp.salary * vemp.bonus_pct)) * 12;
    END IF;
    
    dbms_output.put_line('���   �̸�   ����');
    dbms_output.put_line('-------------');
    dbms_output.put_line(vemp.emp_id || ' ' || vemp.emp_name || ' ' || annsal);
END;
/

-- �ǽ� : IF ���� THEN �� ELSE ���� END IF;
-- ����� �Է¹޾� �ش� ������ ��ü ���� ��ȸ �Ҽ� �μ��ڵ带 �̿��ؼ� �μ����� ���
-- ���, �̸�, �μ��ڵ�, �μ���
-- �ش� ������ �μ��ڵ尡 NULL �̸� '�ҼӺμ� ����' ��µǰ� ��
-- �� �������� �����
SET SERVEROUTPUT ON;

DECLARE
    vemp employee%ROWTYPE;
    vdname department.dept_name%TYPE;
BEGIN
    SELECT *
    INTO vemp
    FROM
        employee
    WHERE emp_no = '&���';
    
    IF vemp.dept_id IS NULL THEN
        vdname := '�ҼӺμ� ����';
    ELSE
        SELECT dept_name
        INTO vdname
        FROM department
        WHERE dept_id = vemp.dept_id;
    END IF;
    dbms_output.put_line(vemp.emp_id || vemp.emp_name || vemp.dept_id || vdname);
END;
/

--PL/SQL �ݺ��� ----------------------------------
-- BASIC LOOP, FOR LOOP, WHILE LOOP, EXIT (�ڹ��� BREAK�� ����)

-- BASIC LOOP ��
-- �ڹ��� do ~ while ���� ���� ������.
/*
�ۼ����� :
LOOP
    �ݺ� �����ų ����;
    ----..;
    IF �ݺ��������� THEN
        EXIT;
    END IF;
    �Ǵ�
    EXIT [WHEN �ݺ���������];
END LOOP;
*/

-- ���� > BASIC LOOP ������ 1���� 5���� ����ϱ�
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

-- FOR LOOP ��
-- FOR LOOP ������ ī��Ʈ�� ������ �ڵ� ����ǹǷ�. ���� ���� ������ �ʿ� ����
-- ī��Ʈ ���� �ڵ����� 1�� ������
-- REVERSE �� 1�� �������� �ǹ���
/*
�ۼ����� :
FOR ī��Ʈ�뺯�� IN [REVERSE] ���۰�..���ᰪ LOOP
    �ݺ� ������ ����;
    .....
END LOOP;
*/

-- ���� > FOR LOOP ������ 1 ���� 5���� ����ϱ�
DECLARE
BEGIN
    FOR n IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(n);
    END LOOP;
END;
/

-- �ǽ� > 1���� 10���� �ݺ��Ͽ� TEST1 ���̺� �����ϱ�
CREATE TABLE TEST1(
    bunho NUMBER(3),
    irum VARCHAR2(10)
);

-- DECLARE -- ���� ������ ������ �����ص� ��
BEGIN
    FOR no IN 1..10 LOOP
        INSERT INTO TEST1 VALUES(no, TO_CHAR(no || '��'));
    END LOOP;
    
    COMMIT;
END;
/
-- Ȯ��
SELECT * FROM test1;
TRUNCATE TABLE test1;

-- �ǽ� 2> �������� Ȧ���ܸ� ��µǰ� �ϱ�(for��, if�� ȥ��)
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

-- WHILE LOOP ��
-- ���� ������ TRUE �� ���ȸ� ������ �ݺ� �����
-- LOOP��  ������ �� ������ ó������ FALSE�̸� �ѹ��� ������� ���� ��쵵 ����

/*
�ۼ����� :
WHILE �ݺ���ų���ǽ� LOOP
    �ݺ������� ����;
    .....
END LOOP;
*/

-- ����> WHILE LOOP ������ 1���� 5���� ����ϱ�
DECLARE
    n NUMBER := 1;
BEGIN
    WHILE n<5 LOOP
        DBMS_OUTPUT.PUT_LINE(n);
        n := n+1;
    END LOOP;
END;
/

-- �ǽ� 2> �������� Ȧ���ܸ� ��µǰ� �ϱ�
-- WHILE LOOP ���
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

-- PL/SQL ���� EXCEPTION (����) ó�� ********************
-- �� > UNIQUE INDEX �� ������ �÷��� �ߺ��� �Է��� ����� ����ó��
CREATE TABLE EXAM_MEMBERS (
    mid VARCHAR2(20) PRIMARY KEY,
    pwd VARCHAR2(20),
    name VARCHAR2(20)
);

INSERT INTO EXAM_MEMBERS VALUES ('javaKING', '111', '�ڹٳ�');
COMMIT;

SELECT * FROM EXAM_MEMBERS;

-- PL/SQL ���� ����ó�� :
BEGIN
    INSERT INTO EXAM_MEMBERS VALUES ('javaKING', '111', '�ڹٳ�');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('ȸ���� ���̵� �ߺ��Ǿ����ϴ�');
END;
/

-- �ý����� �����ϴ� �����̸��� �𸣰ų�, �̸��� �������� �ʴ� ������ �߻��� ���
-- ���ܷ� �ٷ���� ���� �����̸��� �����ϸ� ��
DECLARE
    TOOLARGE_MID EXCEPTION;
    PRAGMA EXCEPTION_INIT(TOOLARGE_MID, -12899);
BEGIN
    INSERT INTO EXAM_MEMBERS VALUES ('javaKING111111111111111111111111111', '111', '�ڹٳ�');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('ȸ���� ���̵� �ߺ��Ǿ����ϴ�');
    WHEN TOOLARGE_MID THEN
        DBMS_OUTPUT.PUT_LINE('���̵� ������ ����Ʈ���� �ʰ��Ͽ����ϴ�');
END;
/

--�ǽ�> ���̵�� ��ȣ�� �Է¹޾�,
-- ���̵�� ��ȣ�� ���ڰ����� 10 �����̻� 15 ���� �̸��� ���� ���� ����ϰ�
-- ���� ������ 10 ���� �̸��̸�, TOOSHORT ���� �߻���Ű�� 
-- ���� ������ 15 ���� �̻��̸�, TOOLONG ���� �߻���Ű���� PL/SQL �������ۼ��Ͻÿ�.
-- TOOLONG �� �����Ǵ� �����ڵ� -12899 �� ���� �����ϰ�,
-- TOOSHORT �� �����ڵ带 -20001 �� ���� ���ϰ�, �޼����� '���ڰ�������'���� ó����
---- ���̵�� ���� �� �ι� �Է¸��ϰ� �ߺ� ���� ������.
---- ���̵� �ߺ� ���� �׽�Ʈ�� �ʱⰪ ������ ���̵� ���� ���� �غ��� ����
---- �Էµ� ���̵�� �غ�� �������� ������ �ߺ� ���� �߻���Ŵ
-- ���� : (RAISE_APPLICATION_ERROR(-�����ڵ�, ��¸޼���);

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
        RAISE_APPLICATION_ERROR(-20001, '���� ���� ����');
    END IF;

    IF VID = V_ID THEN
        RAISE DUP_VAL_ON_INDEX;
     END IF;
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('���̵� �ߺ��Ǿ����ϴ�');
    WHEN TOOLONG THEN
        DBMS_OUTPUT.PUT_LINE('���� ���� ���� �ʰ�');
    WHEN TOOSHORT THEN
        DBMS_OUTPUT.PUT_LINE('���� ���� ����');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('�˼� ���� ������ �߻�');
END;
/

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








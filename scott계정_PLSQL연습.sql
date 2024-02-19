-- PL/SQL ���ù� ����

--IF ~ THEN ~ END IF ��
-- �μ���ȣ�� �μ��� �˾Ƴ���
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
    
    DBMS_OUTPUT.PUT_LINE('���     �̸�     �μ���');
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
    DBMS_OUTPUT.PUT_LINE(vempno || '  ' || vename || '   ' || vdname);
END;
/

-- IF ~ THEN ~ ELSE ~ END IF ��
-- ���� ���ϱ�

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
    
    DBMS_OUTPUT.PUT_LINE('���     �̸�     �μ���');
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
        DBMS_OUTPUT.PUT_LINE('���' || vempno || '�� ' || vename || '����̰� Ŀ�̼��� ���� �ʽ��ϴ�');
    ELSE
        DBMS_OUTPUT.PUT_LINE('���' || vempno || '�� ' || vename || '����̰�' || vcomm || '�� �޽��ϴ�.' );
END IF;
END;
/


-- IF ~ THEN ~ ELSEIF ~ ELSE ~ END IF ��
-- �μ���ȣ�� �μ��� �˾Ƴ���
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
    DBMS_OUTPUT.PUT_LINE('����� SCOR �� ' || score || '���̰�,' || 'Grade �� ' || grade || '�Դϴ�.');
END;
/

--CASE �� �ڹ��� switch ���� ����.

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

--���Ǿ��� �ݺ� �۾��� �����ϱ� ���� BASIC LOOP ��
--- COUNT �� �⺻���� �۾��� �ݺ� ��� �����ϴ� FOR LOOP ��
--- ������ �⺻���� �۾��� �ݺ� ��� �����ϱ� ���� WHILE LOOP ��
--- LOOP �� �����ϱ� ���� EXIT ��

-- ����> BASIC LOOP ������ 1 ���� 5 ���� ����ϱ�
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









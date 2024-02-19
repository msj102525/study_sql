-- 22_TRIGGER.sql

-- Ʈ���� (TRIGGER) ��ü
-- �����ͺ��̽� �̺�Ʈ ��ü��
-- �ַ� ���̺� DML(INSERT, UPDATE, DELETE) �� ����� ��
-- �ٸ� ���̺��� �ڵ����� �Բ� DML�� �۵���ų �� �̿���
/*
�ۼ����� :
CREATE OR REPLACE TRIGGER Ʈ�����̸�
[BEFORE | AFTER] -- �̺�Ʈ �߻� ������ ����
[INSERT | UPDATE | DELTE] ON ���̺�� -- �̺�Ʈ �߻� ���
FOR EACH ROW -- ���� ������� ������ �ǹ���
[WHEN ���ǽ�] -- ��� �࿡ ���� �̺�Ʈ ���� ����
BEGIN
    �ٸ� ���̺� �����Ͽ��� DML ���� �ۼ�; -- �����ų �̺�Ʈ ����
END;

Ʈ���� �������� ���� => ALTER TRIGGER ����
Ʈ���� ���� : DROP TRIGGER Ʈ�����̸�;
*/

-- ȭ��(�ܼ�)�� ������ ��½�Ű�� ���� ������ Ȯ��
SHOW SERVEROUTPUT; 
-- OFF �����̸� ON ���� �ٲ�
SET SERVEROUTPUT ON;

-- ���� ���̺� ����� :
-- ���̺��� �÷� ������ ������ ��
DROP TABLE empcpy;
CREATE TABLE empcpy
AS
SELECT emp_id, emp_name, dept_id
FROM employee
WHERE 1 = 0; -- ������ ������ ���� ��

DESC empcpy; -- �÷� ������ ������
SELECT * FROM empcpy; -- ������ ����

-- Ư�� ���̺� DML�� ������ �Ǹ�, �ڵ����� � ������ �����Ű�� �̺�Ʈ ��ü => Ʈ������

-- �� : EMPCPY ���̺� INSERT �� ������ �ǰ� ����(AFTER)
-- �ڵ����� ��º�(�ܼ�)�� ȯ���޼����� ��µǴ� �̺�Ʈ�� ����Ǵ� Ʈ���� �����
CREATE OR REPLACE TRIGGER TRI_WELCOME
AFTER INSERT ON empcpy
BEGIN
    DBMS_OUTPUT.PUT_LINE('�Ի縦 ȯ���մϴ�');
END;
/
-- / ������ �ǹ��� (�ּ��� / �Ʒ��� ǥ���� ��);

-- / ������ ���� �νĿ� ������ �߻���
-- ���� ������ ����� ���౸���� ���������ϰ� �����ϵ��� ��
-- sql developer ������

-- Ʈ���� �ڵ� ���� Ȯ��
INSERT INTO empcpy VALUES('777', 'ȫ����', '90');

SELECT * FROM empcpy;

-- �ǽ� :
-- ���� ���̺�(EMP03) ���̺� ���ο��� ���� ������ �߰��Ǹ�
-- �� ������ ������ �޿������� �޿� ���̺�(SALARY)�� �ڵ����� �߰� �ԷµǴ� Ʈ���� ����

-- ���� ���̺�
DROP TABLE emp03;
CREATE TABLE emp03(
    empno number(4) PRIMARY KEY,
    ename varchar2(15),
    sal number(7, 2)
);

-- �޿� ���̺�
CREATE TABLE SALARY(
    no number PRIMARY KEY,
    empno NUMBER(4),
    sal number(7,2)
);

-- SALARY ���̺��� no�÷��� ��Ͽ� ����� ������ ��ü ���帮
CREATE SEQUENCE seq_salary_no
START WITH 1
INCREMENT  BY 1
NOCYCLE NOCACHE;

-- Ʈ���� �����
CREATE OR REPLACE TRIGGER tri_salary
AFTER INSERT ON EMP03
FOR EACH ROW -- INSERT �� �� ���� �ʿ���
BEGIN
    INSERT INTO salary
    VALUES (seq_salary_no.NEXTVAL, :NEW.empno, :NEW.sal);
END;
/

-- Ʈ���� �ڵ� ���� Ȯ�� :
INSERT INTO emp03 VALUES (8888, 'ȫ���', 3500);
--TRUNCATE TABLE emp03;
SELECT * FROM emp03;
SELECT * FROM salary; -- emp03�� ��ϵ� ���� salary���� ��ϵ� �� Ȯ��

-- ���ε� ����
-- FOR EACH ROW ���� �̿��� �� ����
-- :NEW.�÷���   => ���� ��ϵ� �÷���
-- :OLD.�÷���    => ������ ��ϵǾ� �ִ� �÷���

-- �ǽ� :
-- 1. ��ǰ ���� ����� ��ǰ���̺� �����
-- 2. ��ǰ�� ���� �԰� ���� ����� �԰����̺� �����
-- 3. �԰����̺� ��ǰ�� �԰�Ǹ�(INSERT), ��ǰ���̺� �ش� ��ǰ�� ����� �ڵ����� ����ǰ� Ʈ����
-- 4. �԰� ���̺� �߰�, ����, ������ ����Ǹ�, ��ǰ���̺��� ��� ��ȭ��  �ִ� Ʈ���� ����

-- 1. ��ǰ ���̺�
CREATE TABLE ��ǰ (
    ��ǰ�ڵ� CHAR(4) CONSTRAINT PK_��ǰ PRIMARY KEY,
    ��ǰ�� VARCHAR2(15) NOT NULL,
    ������ VARCHAR2(15),
    �Һ��ڰ��� NUMBER,
    ������ NUMBER DEFAULT 0        
);

-- ��ǰ ��� :
INSERT INTO ��ǰ (��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���)
VALUES ('a001', '���콺', 'LG', 1000);

INSERT INTO ��ǰ VALUES('a002', 'Ű����', '�Ｚ', 50000, DEFAULT);
INSERT INTO ��ǰ VALUES('a003', '�����', 'HP', 50000, DEFAULT);

COMMIT;
SELECT * FROM ��ǰ;

-- 2. �԰� ���̺�
CREATE TABLE �԰� (
    �԰��ȣ NUMBER PRIMARY KEY,
    ��ǰ�ڵ� CHAR(4) REFERENCES ��ǰ(��ǰ�ڵ�),
    �԰����� DATE,
    �԰���� NUMBER,
    �԰�ܰ� NUMBER,
    �԰�ݾ� NUMBER
);

-- �԰��ȣ�� ���� ������ �����
CREATE SEQUENCE SEQ_�԰��ȣ
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

-- �԰������ �԰�ܰ��� ������ �԰�ݾ��� ����ϴ� ���ν��� �����
-- ���ν��� : PL/SQL ���� ������ ��ü��
CREATE OR REPLACE PROCEDURE PROD_SP_INSERT(CODE CHAR, SU NUMBER, WON NUMBER)
IS
BEGIN
    INSERT INTO �԰�
    VALUES(SEQ_�԰��ȣ.NEXTVAL, CODE, SYSDATE, SU, WON, SU * WON);
END;
/

-- 3. �Է� Ʈ���� �����
-- �԰� ���̺� ��ǰ�� ���� �԰������� ���(INSERT)�Ǹ�
-- �ش� ��ǰ�� �԰������ ���켭
-- ��ǰ���̺� �ش� ��ǰ�� �������� ���� ó���ϴ� Ʈ����

CREATE OR REPLACE TRIGGER TRI_PRODUCT_INSERT
AFTER INSERT ON �԰�
FOR EACH ROW
BEGIN
    UPDATE ��ǰ
    SET ������ = ������ + :NEW.�԰����
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
END;
/

-- ���� Ʈ���� ����� 
-- �԰� ���̺��� �԰������ ����(����, UPDATE)�Ǹ�
-- ��ǰ ���̺��� �������� ������ ������ �ڵ� ����Ǵ� Ʈ����
CREATE OR REPLACE TRIGGER TRI_PRODUCT_UPDATE
AFTER UPDATE ON �԰�
FOR EACH ROW
BEGIN
    UPDATE ��ǰ
    SET ������ = ������ - :OLD.�԰���� + :NEW.�԰����
    WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
END;
/

-- ���� Ʈ���� �����
-- �԰� ���̺��� ��ǰ�� ���� ���� �����Ǹ�
-- ��ǰ ���̺��� �ش� ��ǰ�� �������� ������ ���� �԰������ŭ �����ϴ� Ʈ����
CREATE OR REPLACE TRIGGER TRI_PRODUCT_DELETE
AFTER DELETE ON �԰�
FOR EACH ROW
BEGIN
    UPDATE ��ǰ
    SET ������ = ������ - :OLD.�԰����
    WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
END;
/

-- Ʈ���� �ڵ� �۵� Ȯ�� --------------------------------
-- �԰� ���̺� ��ǰ ����ϴ� ���ν��� ������
-- EXCUTE ���ν����̸�(���ް�, ���ް�, ....);
-- EXCUTE �� ���� ��ɾ�� EXEC �� ����ص� ��
-- ���ν����� ���ް��� ���ν��� ���� �� ������ �Ű����� ������ �ڷ��� ��ġ�ǰ� ����ؾ���

-- �Է� Ʈ���� �۵�
EXEC PROD_SP_INSERT('a002', 20, 5000);
EXEC PROD_SP_INSERT('a002', 10, 5000);

-- Ȯ��
SELECT * FROM �԰�;
SELECT * FROM ��ǰ;

-- ���� Ʈ���� �۵� ����
UPDATE �԰�
SET �԰���� = 15,
    �԰�ݾ� = 15 * �԰�ܰ�
WHERE �԰��ȣ = 2;

-- Ȯ��
SELECT * FROM �԰�; -- �а� ���� ���� Ȯ��
SELECT * FROM ��ǰ; -- �԰���� ���濡 ���� ������ ���� Ȯ����

-- ���� Ʈ���� �۵� Ȯ��
DELETE FROM �԰�
WHERE �԰��ȣ = 2;

-- Ȯ��
SELECT * FROM �԰�; -- �а� ���� ���� Ȯ��
SELECT * FROM ��ǰ; -- �԰���� ���濡 ���� ������ ���� Ȯ����

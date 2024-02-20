-- FINAL_WorkShop

-- ����� ���̺� ���� ��ȸ
SELECT * FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('TB_BOOK', 'TB_BOOK_AUTHOR', 'TB_PUBLISHER', 'TB_WRITER');
 
-- 1.
SELECT 'SELECT COUNT(*) FROM' || TABLE_NAME || ', ' AS ���౸��
FROM USER_TABLES U
WHERE TABLE_NAME IN ('TB_BOOK', 'TB_BOOK_AUTHOR', 'TB_PUBLISHER', 'TB_WRITER');

SELECT COUNT(*) FROM TB_BOOK;
SELECT COUNT(*) FROM TB_BOOK_AUTHOR;
SELECT COUNT(*) FROM TB_PUBLISHER;
SELECT COUNT(*) FROM TB_WRITER;

SELECT DISTINCT 
    (SELECT COUNT(*) FROM TB_BOOK) TB_BOOK,
    (SELECT COUNT(*) FROM TB_BOOK_AUTHOR) TB_BOOK_AUTHOR,
    (SELECT COUNT(*) FROM TB_PUBLISHER) TB_PUBLISHER,
    (SELECT COUNT(*) FROM TB_WRITER) TB_WRITER
FROM dual;


--2.
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    DATA_DEFAULT,
    NULLABLE,
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM TB_BOOK;

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    DATA_DEFAULT,
    NULLABLE
FROM ALL_TAB_COLUMNS
WHERE OWNER = 'C##TEST';

SELECT 
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM ALL_CONSTRAINTS
WHERE OWNER = 'C##TEST';

SELECT 
    CONSTRAINT_NAME R_CONSTRAINT_NAME
FROM ALL_CONSTRAINTS
WHERE OWNER = 'C##TEST' AND CONSTRAINT_TYPE = 'R';

-- 3.
SELECT
    book_no å��ȣ,
    book_nm å�̸�
FROM
    TB_BOOK
WHERE LENGTH(book_nm) >= 25;

-- 4.
SELECT
    writer_nm �۰���,
    office_telno "�繫�� ��ȭ��ȣ",
    home_telno "�� ��ȭ��ȣ",
    mobile_no "�޴��� ��ȭ��ȣ"
FROM
    tb_writer
WHERE mobile_no LIKE '019%' AND writer_nm LIKE '��%';

-- 5.
SELECT
    '�۰�(' || COUNT(*) || '��)' AS "�۰�(��)"
FROM
    TB_WRITER
JOIN TB_BOOK_AUTHOR USING (writer_no)
WHERE compose_type = '�ű�';

-- 6.
SELECT
    COMPOSE_TYPE,
    COUNT(*) AS "���� ����"
FROM
    TB_BOOK_AUTHOR
GROUP BY
    COMPOSE_TYPE
HAVING
    COUNT(*) >= 300
    AND COMPOSE_TYPE IS NOT NULL;
    
-- 7.
SELECT
    book_nm,
    issue_date,
    publisher_nm
FROM
    TB_BOOK
JOIN TB_PUBLISHER USING (publisher_nm)
WHERE issue_date = (
    SELECT
    MAX(issue_date)
    FROM TB_BOOK
    );

--8.
SELECT *
    FROM (
    SELECT
        writer_nm,
        COUNT(book_no)
    FROM
        TB_BOOK_AUTHOR
    JOIN TB_WRITER USING (writer_no)
    GROUP BY writer_nm
    ORDER BY 2 DESC
    )
WHERE ROWNUM <= 3;

SELECT *
FROM (
    SELECT
    writer_nm,
    COUNT(book_no),
    RANK() OVER(ORDER BY COUNT(book_no) DESC) rank
    FROM
            TB_BOOK_AUTHOR
        JOIN TB_WRITER USING (writer_no)
        GROUP BY writer_nm
    )
WHERE rank <= 3;

-- 9.
UPDATE TB_WRITER
SET regist_date = (
    SELECT MIN(issue_date)
    FROM tb_book_author
    JOIN tb_book USING (book_no)
    WHERE tb_book_author.writer_no = TB_WRITER.writer_no
)
WHERE writer_no IN (
    SELECT writer_no
    FROM tb_book_author
    GROUP BY writer_no
);

COMMIT;

SELECT * FROM TB_WRITER;

-- 10.
CREATE TABLE TB_BOOK_TRANSLATOR (
    book_no VARCHAR2(10) PRIMARY KEY NOT NULL,
    writer_no VARCHAR2(10) NOT NULL,
    trans_lang VARCHAR2(60),
    CONSTRAINT FK_BOOK_TRANSLATOR_01 FOREIGN KEY (book_no) REFERENCES TB_BOOK(book_no),
    CONSTRAINT FK_BOOK_TRANSLATOR_02 FOREIGN KEY (writer_no) REFERENCES TB_WRITER(writer_no)
);

-- 11.
INSERT INTO TB_BOOK_TRANSLATOR (book_no, writer_no, trans_lang)
SELECT book_no, writer_no, NULL
FROM TB_BOOK_AUTHOR
WHERE compose_type IN ('�ű�', '����', '��', '����');

DELETE FROM TB_BOOK_AUTHOR
WHERE compose_type IN ('�ű�', '����', '��', '����');
COMMIT;

-- 12.
SELECT
    book_nm,
    writer_nm
FROM
    TB_BOOK_TRANSLATOR
JOIN tb_book USING(book_no)
JOIN tb_writer USING (writer_no)
WHERE SUBSTR(book_no, 1, 4) = 2007;

-- 13.
CREATE OR REPLACE VIEW VW_BOOK_TRANSLATOR
AS
SELECT book_nm, writer_nm, issue_date
FROM TB_BOOK
JOIN TB_BOOK_AUTHOR USING (book_no)
JOIN TB_WRITER USING (writer_no)
WHERE book_nm IN (
    SELECT
        book_nm
    FROM
        TB_BOOK_TRANSLATOR
    JOIN tb_book USING(book_no)
    JOIN tb_writer USING (writer_no)
    WHERE SUBSTR(book_no, 1, 4) = 2007
)
WITH READ ONLY;
SELECT * FROM VW_BOOK_TRANSLATOR;

--14 .
INSERT INTO TB_PUBLISHER
VALUES ('�� ���ǻ�', '02-6719-3737', DEFAULT);
COMMIT;
SELECT * FROM TB_PUBLISHER;

-- 15.
SELECT
    a.writer_nm,
    a.writer_no 
FROM
    tb_writer a
JOIN tb_writer b ON a.writer_no = b.writer_no
WHERE a.writer_nm = b.writer_nm AND a.writer_no != b.writer_no;

-- 16.
UPDATE TB_BOOK_AUTHOR
SET compose_type = '����'
WHERE compose_type IS NULL;
COMMIT;

-- 17.
SELECT
    writer_nm,
    office_telno
FROM
    tb_writer
WHERE office_telno LIKE '02-___-%';

-- 18.
SELECT
    writer_nm AS ���ڸ�,
    MONTHS_BETWEEN(06/01/01, issue_date)
FROM
    TB_WRITER
JOIN TB_BOOK_AUTHOR USING (writer_no)
JOIN TB_BOOK USING (book_no)
;
-- 19.
SELECT
    book_nm,
    price,
    stock_qty,
    CASE
        WHEN stock_qty < 5 THEN '�߰��ֹ��ʿ�'
        ELSE '�ҷ�����'
    END stock_status
FROM
    TB_BOOK
JOIN TB_PUBLISHER USING (publisher_nm)
WHERE publisher_nm = 'Ȳ�ݰ���' AND stock_qty < 10
ORDER BY stock_qty DESC;

-- 20.
SELECT 
    b.book_nm ������,
    wa.writer_nm �۰�,
    wt.writer_nm ����
FROM 
    TB_BOOK b
JOIN TB_BOOK_AUTHOR a ON a.book_no = b.book_no
JOIN TB_BOOK_TRANSLATOR t ON t.book_no = b.book_no
JOIN TB_WRITER wa ON wa.writer_no = a.writer_no
JOIN TB_WRITER wt ON wt.writer_no = t.writer_no
WHERE book_nm = '��ŸƮ��';

-- 21.
SELECT
    book_nm ������,
    stock_qty ������,
    price "����(org)",
    (price - (price * 0.2)) "����(new)",
    FLOOR((MONTHS_BETWEEN(sysdate, issue_date) / 12))
FROM
    TB_BOOK
WHERE   FLOOR((MONTHS_BETWEEN(sysdate, issue_date) / 12)) >= 30
ORDER BY ������ DESC, "����(new)" DESC, ������;





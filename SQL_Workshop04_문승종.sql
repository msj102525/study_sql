-- DDL
-- 1.
CREATE TABLE tb_category (
    name VARCHAR2(10),
    use_yn CHAR(1) DEFAULT 'Y'
);

-- 2.
CREATE TABLE tb_class_type (
    no VARCHAR2(5) PRIMARY KEY,
    name VARCHAR2(10)
);

-- 3.
ALTER TABLE tb_category ADD PRIMARY KEY (name);

-- 4.
ALTER TABLE tb_class_type MODIFY name VARCHAR(10) NOT NULL;
DESC tb_class_type;

-- 5.
ALTER TABLE tb_category MODIFY (name VARCHAR2(20));

ALTER TABLE tb_class_type MODIFY (no VARCHAR2(10), name VARCHAR2(20));

-- 6.
ALTER TABLE tb_category RENAME COLUMN name TO category_name;
DESC tb_category;

ALTER TABLE tb_class_type RENAME COLUMN no TO class_type_no;
ALTER TABLE tb_class_type RENAME COLUMN name TO class_type_name;
DESC tb_class_type;

-- 7.
ALTER TABLE tb_class_type DROP CONSTRAINT SYS_C007663;
ALTER TABLE tb_class_type ADD CONSTRAINT PK_CLASS_TYPE_NAME PRIMARY KEY (CLASS_TYPE_NO);

ALTER TABLE tb_category DROP CONSTRAINT SYS_C007664 CASCADE;
ALTER TABLE tb_category ADD CONSTRAINT PK_CATEGORY_NAME PRIMARY KEY (category_name);

-- 8.
INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT;
SELECT * FROM tb_category;

-- 9.
ALTER TABLE tb_department 
ADD CONSTRAINT FK_DEPARTMENT_CATEGORY FOREIGN KEY (category) REFERENCES tb_category (category_name);
DESC tb_department;

-- 10.
CREATE OR REPLACE VIEW VW_학생일반정보
AS
SELECT student_no 학번, student_name 학생이름, student_address 주소
FROM tb_student;
SELECT * FROM VW_학생일반정보;

-- 11.
CREATE OR REPLACE VIEW VW_지도면담
AS
SELECT 
    s.student_name 학생이름, 
    d.department_name 학과이름,
    p.professor_name 교수이름
FROM
    tb_student s
LEFT JOIN tb_department d USING(department_no)
LEFT JOIN tb_professor p ON p.professor_no = s.coach_professor_no;
SELECT * FROM vw_지도면담;

-- 12.
CREATE OR REPLACE VIEW VW_학과별학생수
AS
SELECT
    d.department_name,
    COUNT(student_name) STUDENT_COUNT
FROM
    tb_department d
JOIN tb_student s ON s.department_no = d.department_no
GROUP BY d.department_name;
SELECT * FROM VW_학과별학생수;

-- 13.
--UPDATE VW_학과별학생수


-- 15.
SELECT * FROM(
SELECT
    c.class_no,
    c.class_name,
    COUNT(s.student_name) 학생수
FROM
        tb_student s
    JOIN tb_grade g ON g.student_no = s.student_no
    JOIN tb_class c ON c.class_no = g.class_no
WHERE
    substr(g.term_no, 1, 4) BETWEEN '2007' AND '2009'
GROUP BY
    c.class_no,
    c.class_name
ORDER BY
    3 DESC
)
WHERE ROWNUM <=3 ;


    
    










    
    
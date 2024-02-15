-- 14_DML_TCL.sql

-- INSERT 문 -----------------------------------------------------------------------------------
-- 테이블에 새로운 데이터를 기록 저장할 때 사용함 : 행 갯수가 늘어남

/*
INSERT INTO 테이블명 (값기록할컬럼명, 컬럼명, ..........)
VALUES (기록할 값, 값, DEFAULT, NULL, ......);

VALUES 대신에 서브쿼리 사용해도 됨, (서브쿼리) 괄호 생략 가능함
INSERT INTO 테이블명
(SELECT 서브쿼리);

주의 :
1. 나열한 컬럼과 기록값의 갯수와 자료형 순서도 일치해야 함
2. 컬럼 나열이 생략되면, 테이블의 모든 컬럼에 값을 기록한다는 의미임
        => 테이블의 컬럼생성 순서에 맞춰서 값 기록해야 함
3. 기록값은 제약조건 위배되지 않는 값 사용할 것
4. 컬럼과 기록값에 논리적인 오류 주의할 것 (EMP_NO 에 직원이름 기록 등)
*/

CREATE TABLE dept (
    deptid   CHAR(2),
    deptname VARCHAR(20)
);

SELECT
    *
FROM
    dept;

SELECT
    COUNT(*)
FROM
    dept; -- 0

INSERT INTO dept (
    deptid,
    deptname
) VALUES (
    '10',
    '회계팀'
);

SELECT
    *
FROM
    dept;

SELECT
    COUNT(*)
FROM
    dept; -- 1

INSERT INTO dept VALUES (
    '20',
    '인사팀'
);

SELECT
    *
FROM
    dept;

SELECT
    COUNT(*)
FROM
    dept; -- 2

-- 지금 실행된 DML 명령문은 메모리의 버퍼상에서 작동되었음
-- 테이블에 추가/수정/삭제된 실행의 결과는 디스크상의 데이터베이스 파일시스템으로 저장(반영)시켜야 함
-- 트렌잭션 명령어(TCL : Transaction Control Language, 트랜잭션 제어어) : COMMIT, ROLLBACK
COMMIT;

-- 테이블이 가진 모든 컬럼에 값 기록시에는 컬럼명 생략할 수 있음
-- INSERT시에 기록값 대신에 DEFAULT, NULL 사용해도 됨
SELECT
    *
FROM
    emp_copy; -- 22행
DESC emp_copy;

INSERT INTO emp_copy (
    emp_id,
    emp_name,
    emp_no,
    email,
    phone,
    hire_date,
    job_id,
    salary,
    bonus_pct,
    marriage,
    mgr_id,
    dept_id
) VALUES (
    '900',
    '홍길동',
    '980711-1022222',
    'doorwinbell@test.org',
    '010123456',
    '2012-06-20',
    'J6',
    4500000,
    0.05, DEFAULT,
    '176',
    NULL
);

SELECT
    *
FROM
    emp_copy; --23행
SELECT
    *
FROM
    emp_copy
WHERE
    emp_id = '900'; -- 조회 확인

COMMIT;

INSERT INTO emp_copy (
    emp_id,
    emp_name,
    emp_no,
    email,
    phone,
    hire_date,
    job_id,
    salary,
    bonus_pct,
    marriage,
    mgr_id,
    dept_id
) VALUES (
    '840',
    '하준수',
    '980711-2022222',
    'hajSU@test.org',
    '0101234543',
    '90/12/3',
    'J7',
    4540000,
    0.1,
    'Y',
    '141',
    '30'
);

SELECT
    *
FROM
    emp_copy; --24행
COMMIT;

SELECT
    *
FROM
    emp_copy
WHERE
    emp_id = '840'; -- 조회 확인

-- INSERT 시에 컬럼명 생략되면, 해당 컬럼은 NULL 처리됨
-- DEFAULT가 지정되지 않은 컬럼에 DEFAULT 사용하면 NULL 처리됨
INSERT INTO emp_copy (
    emp_id,
    emp_name,
    emp_no,
    salary,
    marriage
) VALUES (
    '888',
    '신예찬',
    '891212-1234567', DEFAULT, DEFAULT
);

SELECT
    *
FROM
    emp_copy
WHERE
    emp_id = '888';

-- INSERT에 서브쿼리 사용
-- VALUES 대신에 사용함
CREATE TABLE emp (
    emp_id    CHAR(3),
    emp_name  VARCHAR2(20),
    dept_name VARCHAR2(20)
);

SELECT
    *
FROM
    emp;

INSERT INTO emp
    (
        SELECT
            emp_id,
            emp_name,
            dept_name
        FROM
            employee
            LEFT JOIN department USING ( dept_id )
    );

COMMIT;

-- 값 기록시 제약조건 위배되지 않는 값이어야 함
ALTER TABLE emp_copy
-- ADD PRIMARY KEY (emp_id);
-- ADD CONSTRAINT FK_MID_ECOPY FOREIGN KEY (mgr_id) REFERENCES emp_copy (emp_id); 
-- ADD CONSTRAINT fk_jid_ecopy FOREIGN KEY ( job_id ) REFERENCES job;
--ADD UNIQUE (emp_no);
ADD CONSTRAINT CHK_MRIG_ECOPY CHECK (MARRIAGE IN ('Y', 'N'));

-- DEFAULT 설정 변경
ALTER TABLE emp_copy MODIFY (
    hire_date DEFAULT sysdate
);

-- 제약조건 위배 에러 확인
INSERT INTO emp_copy (emp_id, emp_name, emp_no)
VALUES (NULL, '문승종', '980711-1234567'); -- emp_id는 PRIMARY KEY 설정 있음, NULL사용 못함

INSERT INTO emp_copy (emp_id, emp_name, emp_no)
VALUES (777, '문승종', '980711-1234567'); -- emp_id는 PRIMARY KEY 설정 있음, 같은 값 두번 기록 못 함

INSERT INTO emp_copy (emp_id, emp_name, emp_no)
VALUES ( 777, NULL, '980711-1234567'); -- emp_name는 PRIMARY KEY 설정 있음, NULL사용 못함

INSERT INTO emp_copy (emp_id, emp_name, emp_no)
VALUES ( 777, '문승종', NULL); -- emp_no는 PRIMARY KEY 설정 있음, NULL사용 못함

INSERT INTO emp_copy (emp_id, emp_name, emp_no)
VALUES (777, '문승종', '980711-1234567'); -- emp_no는 UNIQUE 설정 있음, 같은 값 두번 기록 못함

INSERT INTO emp_copy (emp_id, emp_name, emp_no, marriage)
VALUES (777, '문승종2', '980712-1234567', 'y'); -- marriage의 CHECK 제약조건 위배됨

-- DELETE 문 -----------------------------------------------------------------------------
-- 행을 삭제하는 구문임, 테이블의 행 갯수 줄어듦
-- ROLLBACK 가능함 (DELETE 실행을 취소할 수 있음)

/*
DELETE FROM 테이블명
WHERE 컬럼명 연산자 비교값;

주의 :
1. FOREIGN KEY 제약조건으로 참조(REFERENCE)되고 있는 테이블의 참조컬럼은 삭제 불가능임(기본)
    => 외래키 제약조건 지정시 삭제를(SET NULL, CASCADE)이 설정된 경우는 삭제 가능함
2.  WHERE 절이 생략되면 테이블의 모든 행이 삭제됨 (복구 가능함)

테이블의 모든 행을 삭제하는 명령구문으로 TRUNCATAE 문 있음
TRUNCATE TABLE 테이블명;
=> 롤백 안됨 (복구 불가능)
*/

SELECT * FROM dcopy;

-- WHERE 절 생략
DELETE FROM dcopy;

ROLLBACK; -- 방금 사용된 DML 구문을 실행 취소함

TRUNCATE TABLE dcopy;
SELECT * FROM dcopy;
ROLLBACK; -- 롤백 안됨

-- 다른 테이블에서 FOREIGN KEY(외래키)로 참조하고 있는 값(사용하고 있는 값)은 삭제 못 함
DELETE FROM department
WHERE dept_id = '90'; -- EMPLOYEE의 dept_id에서 사용하고 있는 값임

-- 사용값 확인 
SELECT * FROM department
ORDER BY dept_id;

-- 사용값 확인
SELECT DISTINCT dept_id
FROM employee
ORDER BY 1 NULLS LAST;

-- 사용되지 않은 값은 삭제할 수 있음
UPDATE emp_copy
SET dept_id = NULL
WHERE emp_id = '840';

COMMIT;

DELETE FROM department
WHERE dept_id = '30';

SELECT * FROM department ORDER BY 1;

ROLLBACK;

-- TCL (Transaction Control Language : 트랜잭션 제어어) -----------------------------------
-- 명령어 : COMMIT, ROLLBACK, SAVEPOINT
-- DML 명령구문 사용시 필요함

-- 트렌잭션의 시작 :
-- 이전 트렌잭션이 종료되고 나서, 첫번째 DML(INSERT, UPDATE, DELETE) 명령구문이 실행될 때
-- DDL(CREATE, ALTER, DROP) 구문이 실행될 때 : 직전 트랜잭션은 AUTO COMMIT 됨

-- 트랜잭셩의 종료 : 
-- COMMIT(저장 반영), ROLLBACK(명령구문들 취소) 실행
-- 자동 종료 : 새로운 DDL 명령구문이 실행될 때

-- DDL 실행 : 지정된 제약조건을 비활성화시킴 => 트렌잭션 시작
ALTER TABLE employee
--DISABLE CONSTRAINT FK_MGRID;
DROP CONSTRAINT FK_MGRID;
-- 새로운 트랜잭션 시작
SELECT TABLE_NAME, CONSTRAINT_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TESTFK';

SAVEPOINT S0;

INSERT INTO department
VALUES ('40', '기획전략팀', 'A1');
-- 확인
SELECT * FROM department ORDER BY 1;

SAVEPOINT S1;

UPDATE EMPLOYEE
SET dept_id = '40'
WHERE dept_id IS NULL;
-- 확인
SELECT * FROM employee
WHERE dept_id = '40';

SAVEPOINT S2;

DELETE FROM employee;
-- 확인
SELECT COUNT(*) FROM employee;

-- ROLLBACK; -- 트랜잭션 안의 DML 명령 전체 취소

-- S2 까지 롤백 : 
ROLLBACK TO S2;

-- 확인
SELECT * FROM employee;
SELECT COUNT(*) FROM employee;

-- S1 까지 롤백 : 
ROLLBACK TO S1; -- UPDATE 취소

-- 확인
SELECT * FROM employee
WHERE dept_id = '40';

SELECT * FROM employee
where dept_id IS NULL;

-- S0까지 롤백 : 
ROLLBACK TO S0; -- INSERT 취소

-- 확인
SELECT * FROM department ORDER BY 1;

-- 동시성 제어 : 잠금
-- 같은 계정으로
-- 여러 사용자가 접속이 된 경우
-- 세션(SESSION)이 여러 개
SELECT emp_name, marriage
FROM employee
WHERE emp_id = '143';

UPDATE employee
SET marriage = 'N'
WHERE emp_id = '143';

COMMIT;



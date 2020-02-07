SELECT *
FROM emp;

--Truncate테스트
--REDO로그를 생성하지 않기 때문에 삭제시 데이터 복구가 불가하다
--DML(SELECT, INSERT, UPDATE, DELETE)이 아니라 DDL로 분류 (ROLLBACK이 불가)

--테스트 시나리오
--EMP 테이블 복사를 하여 EMP_COPY라는 이름으로 테이블 생성
--EMP_COPY테이블을 대상으로 TRUNCATE TABLE EMP_COPY 실행

--EMP_COPY 테이블에 데이터가 존재하는지 (정상적으로 삭제가 되었는지) 확인

--EMP_COPY 테이블 복사
--CREATE TABLE emp_copy
--SELECT *
--FROM emp;

--CREATE=>> DDL (ROLLBACK이 안된다)
--다른명령어를 이용해서 직접 지워줘야 한다.
CREATE TABLE EMP_COPY AS
SELECT *
FROM emp;

SELECT *
FROM emp_copy;

TRUNCATE TABLE emp_copy;

--TRUNCATE TABLE 명령어는 DDL이기 때문에 ROLLBACK이 불가하다
--ROLLBACK 후 SELECT 를 해보면 데이터가 복구 되지 않은 것을 알 수 있다.
ROLLBACK;

--고립화 레벨



--part2
--DDL : Data Definition Language - 데이터 정의어
--객체를 생성, 수정, 삭제시 사용;
--롤백 불가, 자동커밋

--테이블 생성
--Create table [스키마명.]테이블명(   =>스키마는 계정 명
--    컬럼명1, 컬럼타입, [DEFAULT 기본값],
--    컬럼명1, 컬럼타입2, [기본 값설정],.....
--);

--ranger라는 이름의 테이블 생성;
CREATE TABLE ranger(
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE DEFAULT SYSDATE
);

SELECT *
FROM ranger;
INSERT INTO ranger (ranger_no, ranger_nm)VALUES (1,'brown');
commit;


--테이블 삭제
--DROP TABLE 테이블명
--ranger 테이블 삭제(drop)
DROP TABLE ranger;

SELECT *
FROM ranger;

--DDL은 롤백 불가;
ROLLBACK;
--테이블이 롤백되지 않은 것을 확인 할 수 있다.
SELECT *
FROM ranger;

--데이터 타입
--문자열 (varchar2사용, char 타입 사용 지양)
--varchar2(10) :    가변길이 문자열, 사이즈가 1~4000byte
--                입력되는 값이 컬럼 사이즈보다 작아도 남은 공간을 공백으로 채우지 않는다.
--char(10) : 고정길이 문자열
--            해당 컬럼에 문자열을 5byte만 지정하면 나머지 5byte 공백으로 채워진다.
--            'test' ==> 'test   '
--            'test' != 'test    '

--숫자
--NUMBER(p,s) : P - 전체자리수 (38), s - 소수점 자리수
--INTEGER ==> NUMBER(38,0)
--ranger_no NUMBER ==>NUMBER(30,0)

--날짜
--DATE 일자와 시간 정보를 저장   
--    7BYTE
--날짜 DATE
--    VARCHAR2(8)'20200207'
--위 두개의 타입은 하나의 데이터당 1 BYTE의 사이즈가 차이가 난다.
--데이터 양이 많아 지게 되면 무시할 수 없는 사이즈로 , 설계시 타입에 대한 고려가 필요하다

--LOB(Large Object)
--CLOB - Character Large Object
--      VARCHAR2로 담을 수 없는 사이즈의 문자열(4000byte 초과 문자열)
--      ex : 웹 에디터에 생성된 html코드


--BLOB - Byte Large Object
--      파일을 데이터베이스의 테이블에서 관리

--      일반적으로 게시글 첨부파일을 테이블에 직접 관리하지 않고
--      보통 첨부파일을 디스크의 특정 공간에 저장하고, 해당 경로만 문자열로 관리

--      파일이 매우 중요한 경우: 고객 정보사용 동의서 -> 파일을 테이블에 저장
--      


--이건 참고만 하자
SELECT EXTRACT(day FROM sysdate)
FROM dual;


--어려운건데 제약조건에 대해서 알아보자
--제약조건이란 데이터가 무결성을 지키도록 위한 설정을 의미한다.
--1. UNIQUE 제약조건
--      해당 컬럼의 값이 다른 행의 데이터와 중복되지 않도록 제약
--      ex: 사번이 같은 사원이 있을수가 없다.

--2. NOT NULL 제약조건 : (CHECK 제약조건)
--      해당 컬럼에 값이 반드시 존재해야하는 제약
--      ex : 사번 컬럼이 NULL인 사원은 존재할 수가 없다.
--           회원가입시 필수 입력사항 (github같은 경우는 이메일과 이름을 반드시 입력해야함)

--3. PRIMARY KEY 제약조건
--   UNIQUE + NOT NULL
--   ex: 사번이 같은 사원이 있을수가 없고, 사번이 없는 사원이 있을 수가 없다.
--   PRIMARY KEY 제약조건을 생성할 경우 해당 컬럼으로 UNIQUE INDEX가 생성된다.

--4. FOREIGN KEY 제약조건(참조무결성)
--      해당 컬럼이 참조하는 다른 테이블에 값이 존재하는 행이 있어야 한다.
--      emp 테이블의 deptno컬럼이 dept 테이블의 deptno 컬럼을 참조(관계)
--      emp 테이블의 deptno 컬럼에는 dept 테이블에 존재하지 않는 부서번호가 입력 할 수 없다.
--      ex : 만약 dept 테이블의 부서번호가 10,20,30,40, 번만 존재 할 경우
--          emp 테이블에 새로운 행을 추가 하면서 부서번호 값을 99번으로 등록할 경우 행 추가가 실패한다.

--5. CHECK 제약조건 (값을 체크)
--      NOT NULL 제약조건도 CHECK 제약에 포함
--      emp 테이블에 JOB 컬럼에 들어 올수 있는 값을 'SALESMAN','PRESTIDENT','CLEARK'


--제약 조건 생성방법
--1.테이블을 생성하면서 컬럼에 기록
--2.테이블을 생성하면서 컬럼 기술 이후에 별도로 제약조건을 기술
--3.테이블 생성과 별도로 추가적으로 제약조건을 추가

--CREATE TABLE 테이블명(
--    컬럼 1 컬럼 타입[1.제약조건],
--    컬럼 2 컬럼 타입[1.제약조건],
--
--    (2.TABLE_CONSTRAINT)
--);

--3. ALTER TABLE emp.....;


--PRIMARY KEY 제약조건을 컬럼 레벨로 생성(1번방법)
--dept을 테이블을 참고하여 dept_test 테이블을 PRIMARY kEY 제약조건과 함께 생성
--단 이방식은 테이블의 key 컬럼이 복합컬럼은 불가하고 단일 컬럼일 때만 가능하다

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);
INSERT INTO dept_test(deptno)VALUES(99); --정상적으로 실행
INSERT INTO dept_test(deptno)VALUES(99); --바로 위의 쿼리를 통해 같은 값의 데이터가 이미 저장됨


--참고사항
INSERT INTO dept(deptno)VALUES(99);
INSERT INTO dept(deptno)VALUES(99);
--우리가 이미 쓰고 있던 테이블은 제약조건이 없기 때문에 정상적으로 실행된다.
--우리가 기존에 사용한 dept테이블의 deptno컬럼에는 UNIQUE 제약이나 PRIMARY KEY제약 조건이 없었기 때문에
--아래 두개의 INSERT 구문이 정상적으로 실행된다.

ROLLBACK;


--제약조건 확인방법
--1. TOOL 을 통해 확인
-- 확인하고자 하는 테이블을 선택
--2.dictionary를 통해 확인(USER_TABLE);
SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = 'DEPT_TEST';--SYS_C007115

SELECT *
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME = 'SYS_C007115';

--3.모델링(ex : exerd)으로 확인


--제약조건 명을 기술하지 않을 경우 오라클에서 제약조건이름을 임의로 부여 (ex : SYS_c007115)
--가독성이 떨어지기 때문에
--명명 규칙지정을 하고 생성하는게 개발, 운영관리에 유리
--FRIMARY KEY 제약조건 : PK_테이블명
--FOREIGN KEY 제약조건 : PK_대상테이블명_참조테이블명

DROP TABLE dept_test;
--컬럼 레벨의 제약조건을 생성하면서 제약조건 이름을 부여
--CONSTRAINT 제약조건명 제약조건 타임(PRIMARY KEY)
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test (deptno) VALUES(99);
INSERT INTO dept_test (deptno) VALUES(99);
--오류 메세지 비교
--ORA-00001: unique constraint (LMH.SYS_C007115) violated
--ORA-00001: unique constraint (LMH.PK_DEPT_TEST) violated


--2.테이블 생성시 컬럼 기술이후 별도로 제약조건 기술
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT PK_dept_test PRIMARY KEY(deptno)
);

--3번째는 테이블을 변경하는거라서 나중에 배운다


--NOT NULL 제약조건 생성하기
--1.컬럼에 기술하기 (o)
-- 단, 컬럼에 기술하면서 제약조건 이름을 부여하는건 불가능하다
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13),
    CONSTRAINT PK_dept_test PRIMARY KEY(deptno)
);

--NOT NULL 제약조건 확인
INSERT INTO dept_test (deptno, dname) VALUES (99,NULL);
--ORA-01400: cannot insert NULL into ("LMH"."DEPT_TEST"."DNAME")
--오류가 뜨고 NOT NULL 제약조건을 두었기에 NULL값이 들어갈수 없다

--2. 테이블 생성시 컬럼 기술 이후에 제약 조건
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT NM_dept_test_dname CHECK (deptno IS NOT NULL)
);


--UNIQUE제약조건 : 해당 컬럼에 중복되는 값이 들어오는 것을 방지하는데, 단 NULL은 입력이 가능하다.
--PRIMARY = UNIQUE + NOT NULL;

--1.테이블 생성시 컬럼 레벨 UNIQUE제약조건
--  dname 컬럼에 UNIQUE 제약조건;
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14) CONSTRAINT UK_dept_test_dname UNIQUE,
    loc VARCHAR2(13)
    
);

--dept_test테이블의 dname 컬럼에 설정된 unique제약조건을 확인
INSERT INTO dept_test  VALUES(99,'ddit','daejeon');
INSERT INTO dept_test  VALUES(99,'ddit','daejeon');

--2.테이블 생성시 컬럼에 기술이후 제약조건 생성 - 복합 컬럼(deptno-dname)(unique);
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test_deptno_dname UNIQUE(deptno,dname)
);

--복합 컬럼에 대한 UNIQUE 제약 확인(deptno, dname)
INSERT INTO dept_test VALUES (99,'ddit','daejeon');
INSERT INTO dept_test VALUES (98,'ddit','daejeon');
INSERT INTO dept_test VALUES (98,'ddit','대전');
--ORA-00001: unique constraint (LMH.PK_DEPT_TEST_DEPTNO_DNAME) violated


--FOREIGN KEY 제약조건
--참조하는 테이블의 컬럼에 존재하는 값만 대상 테이블의 컬럼에 입력할 수 있도록 설정
-- EX: emp 테이블에 deptno 컬럼에 값을 입력할 때, dept 테이블의 deptno 컬럼에 존재하느 부서번호만
--      입력할 수 있도록 설정
--      존재하지 않는 부서번호를 emp 테이블에서 사용하지 못하게끔 방지

--1.dept_test 테이블 생성
--2. emp_test 테이블 생성
--    .emp_test테이블 생성시 deptno 컬럼으로 dept, deptno 컬럼을 참조하도로 FK를 설정;

DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno)
);

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno),
    CONSTRAINT PK_EMP_TEST PRIMARY KEY (empno)
);

--데이터 입력순서
--emp_test 테이블에 데이터를 입력하는게 가능한가???
-- .지금상황(dept_test, emp_test 테이블을 방금 생성- 데이터가 존재하지 않을 때;
INSERT INTO emp_test VALUES (9999,'brown',NULL); --FK이 설정된 컬럼에 NULL은 허용
INSERT INTO emp_test VALUES (9998,'sally',10);  --10번 부서가 dept_test 테이블에 존재하지 않아서 에러;

--dept_test테이블에 데이터를 준비
INSERT INTO dept_test VALUES(99,'ddit','daejeon');
INSERT INTO emp_test VALUES(9998,'sally',10); --10번 부서가 dept_test 에 존재하지 않으므로 에러
INSERT INTO emp_test VALUES(9998,'sally',99); --99번 부서는 dept_test 에 존재하므로 정상 실행


--테이블 생성시 컬럼 기술 이후 FOREIGN KEY 제약조건 생성;
DROP TABLE emp_test;
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno)
);
INSERT INTO dept_test VALUES (99,'ddit','daejeon');

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno)
);
INSERT INTO emp_test(9999,'brown',10); --dept_test 테이블에 10 번 부서가 존재하지 않아 에러;
INSERT INTO emp_test(9999,'brown',99); --dept_test 테이블에 99 번 부서가 존재하므로 정상실행;






CREATE TABLE tb_dept(
    d_cd VARCHAR2(20) NOT NULL,
    d_nm VARCHAR2(50) NOT NULL,
    p_d_cd VARCHAR(20)
);

CREATE TABLE tb_emp(
    e_no NUMBER NOT NULL,
    e_nm VARCHAR2(50) NOT NULL,
    g_cd VARCHAR2(20) NOT NULL,
    j_cd VARCHAR2(20) NOT NULL,
    d_cd VARCHAR2(20) NOT NULL   
);

CREATE TABLE tb_grade(
    g_cd VARCHAR2(20) NOT NULL,
    g_nm VARCHAR2(50) NOT NULL,
    ord NUMBER
);

CREATE TABLE tb_job(
    j_cd VARCHAR2(20) NOT NULL,
    j_nm VARCHAR2(50) NOT NULL,
    ord NUMBER
);

CREATE TABLE tb_counsel(
    cs_id VARCHAR2(20) NOT NULL,
    cs_reg_dt DATE  NOT NULL,
    cs_cont VARCHAR2(4000) NOT NULL,
    e_no NUMBER NOT NULL,
    cs_cd1 VARCHAR2(20) NOT NULL,
    cs_cd2 VARCHAR2(20),
    cs_cd3 VARCHAR2(20)
);

CREATE TABLE tb_cs_cd(
    cs_cd VARCHAR2(20) NOT NULL,
    cs_nm VARCHAR2(50) NOT NULL,
    p_cs_cd VARCHAR2(20)
);

ALTER TABLE tb_dept add primary key(d_cd);
ALTER TABLE tb_dept add foreign key(d_cd) references tb_dept(d_cd);

ALTER TABLE tb_emp add primary key(e_no);
ALTER TABLE tb_emp add foreign key(d_cd) references tb_dept(d_cd);

ALTER TABLE tb_grade add primary key(g_cd);
ALTER TABLE tb_emp add foreign key(g_cd) references tb_grade(g_cd);

ALTER TABLE tb_job add primary key(j_cd);
ALTER TABLE tb_emp add foreign key(j_cd) references tb_job(j_cd);

ALTER TABLE tb_counsel add primary key(cs_id);
ALTER TABLE tb_counsel add foreign key(e_no)references tb_emp(e_no);

ALTER TABLE tb_cs_cd add primary key (cs_cd);
ALTER TABLE tb_counsel add foreign key (cs_cd1)references tb_cs_cd(cs_cd);
ALTER TABLE tb_counsel add foreign key (cs_cd2)references tb_cs_cd(cs_cd);
ALTER TABLE tb_counsel add foreign key (cs_cd3)references tb_cs_cd(cs_cd);



drop table tb_counsel;
drop table tb_cs_cd;
drop table tb_emp;
drop table tb_job;
drop table tb_dept;
drop table tb_grade;






rollback;


--  d_cd , d_nm, p_d_cd
--  k_cd , 珥앹궗?뾽??, null
--  k_cd_1, 遺??궗?뾽??1, k_cd
--  k_cd_2, 遺??궗?뾽??2 k_cd


-- e_no, e_nm, g_cd, j_cd, d_cd
-- 100, ?씠紐낇쁽, 怨쇱옣, ???옣, k_cd_1
-- 101, 諛뺤냼?쁽, ??由?, null, k_cd_1
-- 102, ?씠?쑀吏?, 李⑥옣, ???옣, k_cd_2

-- j_cd, j_nm, ord
-- j_cd_1, ???옣, 1
-- j_cd_2, 遺??꽌?옣, 2

-- g_cd,g_nm , ord
-- g_cd_1, 怨쇱옣, 1
-- g_cd_2, ??由?, 2

-- cs_id, cs_reg_dt, cs_cont, e_no, cs_cd1 , cs_cd2, cs_cd3
-- cs_is_1, sysdate, ?쟾?솕?긽?떞?궡?슜?엯?땲?떎., 100, cs_cd1_1, cs_cd2_1, cs_cd3_1
-- cs_is_2, sysdate, ?쟾?솕?긽?떞?궡?슜?엯?땲?떎.2, 100, cs_cd1_1, cs_cd2_1, cs_cd3_1
-- cs_id_3, sysdate, ?쟾?솕?긽?떞?궡?슜3, 100, cs_cd2, cs_cd3, cs_cd5



-- cs_cd, cd_nm, p_cs_cd
-- cs_cd1, 援먰솚, null
-- cs_cd2, ?떒?닚蹂??떖, cs_cd1
-- cs_cd3, 臾쇨굔?븯?옄, cs_cd1
-- cs_cd4, 諛곗넚, null
-- cs_cd5, 二쇱냼吏?蹂?寃?, cs_cd4
-- cs_cd6, 諛곗넚痍⑥냼?슂泥?, cs_cd4


CREATE TABLE ts(
    cs_cd VARCHAR2(20) NOT NULL,
    cs_nm VARCHAR2(50) NOT NULL,
    p_cs_cd VARCHAR2(20),
    CONSTRAINT PK_example5 PRIMARY KEY(cs_cd)

);

ALTER TABLE ts DROP CONSTRAINT PK_example5;

ALTER TABLE ts ADD CONSTRAINT PK_example1 PRIMARY KEY(cs_cd)
;


-----------------------------------------------rename?쑝濡? 蹂?寃쎄??뒫
ALTER TABLE ts
RENAME CONSTRAINT PK_example1 TO PK_example0;
select *
FROM ts;
insert into ts (cs_cd,cs_nm,p_cs_cd)values('a','b','c');
commit;
ALTER TABLE ts
RENAME CONSTRAINT PK_example0 TO PK_example9;

------?뜲?씠?꽣媛? 議댁옱?븯吏? ?븡?쓣 ?븣 媛??뒫;



--20200210 수업 내용

--1. PRIMARY KEY 제약조건 생성시 오라클 dbms는 해당 컬럼으로 unique index를 자동으로 생성한다.
--(정확히는 UNIQUE 제약에 의해 UNIQUE 인덱스가 자동으로 생성된다.
--  PRIMARY KEY  = UNIQUE + nOT NULL )

--index : 해당 컬럼으로 미리 정렬을 해놓은 객체이다.
--정렬이 되어있기 때문에 찾고자 하는 값이 존재하는 지 빠르게 알수가 있다.
--만약에 인덱스가 없으면 새로운 데이터를 입력할 때 중복되는 값을 찾기 위해서 최악의 경우 테이블의 모든 테이터를 찾아야 한다.
--하지만 인덱스가 있으면 이미 정렬이 되어 있기 때문에 해당 값의 존재 유무를 빠르게 알수가 있다.

--2. Foreign key 제약조건도
--참조하는 테이블에 값이 있는지를 확인 해야한다.
--그래서 참조하는 컬럼에 인덱스가 있어야지만 Forign key 제약을 생성할 수가 있다.

--Foreign key 생성시 옵션
--Foreign key (참조 무결성) : 참조하는 테이블의 컬럼에 존재하는 값만 입력 될 수 있도록 제한
--(ex. : emp 테이블에 새로운 데이터를 입력시 deptno 컬럼에는 dept 테이블에 존재하는 부서번호만 입력 될 수 있다.)

--Foreign key 가 생성됨에 따라 데이터를 삭제할 때 유의점
--어떤 테이블에서 참조하고 있는 데이터는 바로 삭제가 안됨
--(ex : emp.deptno => dept.deptno 컬럼을 참조하고 있을 때
--      부서 테이블의 데이터를 삭제 할수가 없음)

select *
FROM emp_test;

SELECT *
FROM dept_test;

insert into dept_test VALUES(98,'ddit','대전');
insert into emp_test(empno, ename, deptno) Values( 9999,'brown',99);
commit;

--상황 설명 emp: 9999,99가 있고 dept는 98,99가 있음
--=> 98번부서를 참조하는 emp테이블의 데이터는 없음
--=> 99번부서를 참조하는 emp테이블의 데이터는 9999번 brown 사번이 있음

--심화생각해보자)
--만약에 다음 쿼리를 실행하게 되면 오류가 뜬다. 왜냐하면 emp 테이블이 참조하고 있는 데이터가 삭제되기 때문에 오류가 뜬다.
--(emp를 먼저 제거하고 dept해야함)
--DELETE dept_test
--WHERE deptno = 99;

--그렇다면 98번을 삭제하게 되면 어떻게 될까?
--emp테이블에서 참조하는 데이터가 없는 98번 부서를 삭제하면?
-- 이 경우는 FOREIGN KEY의 참조 무결성이 깨지지 않기 때문에 오류없이 정상으로 실행이 된다.
--DELETE dept_test
--WHERE deptno = 98;

--FOREIGN KEY옵션
--1. ON DELETE CASCADE : 부모가 삭제될 경우( dept를 말하고) 참조하는 자식 데이터도 같이 삭제해야 한다.(emp)
--2. ON DELETE SET NULL : 부모가 삭제될 경우(dept) 참조하는 자식 데이터의 걸럼을 NULL로 설정한다.

--emp_test테이블을 drop후 옵션을 번갈아 가며 생성후 삭제 테스트를 해본다.↓
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT PK_emp_test_dept_test FOREIGN KEY (deptno)
            REFERENCES dept_test(deptno) ON DELETE CASCADE
);
INSERT INTO emp_test VALUES (9999,'brown',99);
commit;
--상황설명↑
--emp_test 테이블의 deptno 컬럼은 dept_test 테이블의 deptno_test 컬럼을 참조하고 있는데 옵션이 (ON DELETE CASCADE)이다
--옵션에 따라서 부모테이블(dept_test)삭제시 참조하고 있는 자식 데이터도 같이 삭제된다.
DELETE dept_test
WHERE deptno = 99;

--옵션을 부여하지 않았을 때는 위의 DELETE 쿼리가 에러가 발생한다.
--옵션에 따라서 참조하는 자식 테이블의 데이터가 정상적으로 삭제가 되었는지 SELECT 통해서 확인한다.

SELECT *
FROM emp_test;
--최종적 결과는 부모에 있는 99번 테이블을 삭제하게 되면 옵션으로 인해서 자식 테이블에 있는 데이터까지 삭제가 됨


--2. FK ON DELETE SET NULL 옵션 테이스
--부모테이블의 데이터 삭제시 (dept_test) 자식 테이블에서 참조하는 데이터를 NULL로 업데이트 해준다.
ROLLBACK;
SELECT *
FROM dept_test;
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT PK_emp_test_dept_test FOREIGN KEY (deptno)
            REFERENCES dept_test(deptno) ON DELETE SET NULL
);
INSERT INTO emp_test VALUES (9999,'brown',99);
commit;

--dept_test 테이블의99번 부서를 삭제하게 되면 (부모 테이블을 삭제하면) 99번 부서를 참조하는 emp_test 테이블의
--9999번(brown)테이블의 deptno 컬럼을 FK 옵션에 따라 NULL로 변경한다.

DELETE dept_test
WHERE deptno = 99;
--자식 테이블의 데이터 삭제후 자식 테이블의 데이터가 NULL로 변경되었는지 확인한다.
SELECT *
FROM emp_test;
--결과적으로 NULL 바뀌게 된다.
SELECT *
FROM dept_test;


--CHCK 제약조건 : 컬럼이 들어가는 값의 종류를 제한할 때 사용
--ex: 급여 컬럼을 숫자로 관리, 급여가 음수가 들어갈 수 있을 까?
--      일반적인 경우 급여값은 > 0
--      CHECK 제약을 사용할 경우 급여값이 0보다 큰값이 검사 가능.
--      EMP 테이블의 JOB 컬럼에 들어가는 값을 다음 4가지로 제한 가능
--      'SALESMAN','PRESIDENT','ANALYST','MANAGER'

--테이블 생성시 컬럼 기술과 함께 CHECK 제약 생성
--emp_test 테이블의 sal 컬럼이 0보다 크다는 CHECK 제약조건 생성

INSERT INTO dept_test VALUES(99,'ddit','대전');
DROP TABLE emp_test;
CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        deptno NUMBER(2),
        sal NUMBER CHECK(sal>0),
        
        CONSTRAINT pk_emp_test PRIMARY KEY (empno),
        CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno)
                REFERENCES dept_test(deptno)
);
INSERT INTO emp_test VALUES (9999,'brown',99,1000);
INSERT INTO emp_test VALUES (9998,'sally',99,-1000);

--↑↑↑↑↑↑↑↑↑↑↑↑↑(sal_ 체크조건에 따라서 0보다 큰 값만 입력하능하다)
--INSERT INTO emp_test VALUES (9998,'sally',99,-1000)
--오류 보고 -
--ORA-02290: check constraint (LMH.SYS_C007216) violate

--새로운 테이블 생성
--CREATE TABLE 테이블명(
--    컬럼1....
--);
--CREATE TABLE 테이블명 AS
--SELECT 결과를 새로운 테이블로 생성

--emp 테이블을 이용해서 부서본호가 10인 사원들만 조회하여 해당 데이터로 emp_test2테이블을 생성;

CREATE TABLE emp_test2 AS
    SELECT *
    FROM emp
    WHERE deptno = 10;

SELECT *
FROM emp_test2;
--DDL (table - create table as)
--not null제약조건 이외의 조건은 복사되지 않는다.
--실무에서 데이터를 만질 때 불안하니까 그날 작업한 테이블을 20200210을 붙여서 백업을 해놓을 때 사용이 된다.
--하지만 이것이 너무 심하면(한달의 두,세건씩) 보기가 불편하다. (정석은 아님)
--즉, 개발시 데이터 백업과 테스트 개발을 위해서 사용된다.
--PT 34번은 참고만 하자


--TABLE 변경하기
--1. 컬럼추가하기
--2. 컬럼사이즈/ 타입 변경
--3. 기본값을 설정
--4. 컬럼면을 RENAME
--5. 컬럼을 삭제
--6. 제약조건 추가/삭제

--TABLE 변경 : 1. 컬럼추가하기  (HP varchar2(20));

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT pk_emp_test PRIMARY KEY (empno),
    CONSTRAINT fk_emp_test FOREIGN KEY (deptno)
            REFERENCES dept_test(deptno)
);

--ALTER TABLE 테이블명 ADD (신규컬럼명 신규컬럼 타입);
ALTER TABLE emp_test ADD HP varchar2(20);
INSERT INTO emp_test VALUES(9999,'brown',99,'010-1234-5678');
DELETE emp_test
WHERE empno = 9999;
SELECT *
FROM emp_test;

--TABLE 변경 : 2. 컬럼사이즈 변경, 타입변경 
--ex : 컬럼 varchar2(20) => varchar2(5)
--  기존에 데이터가 존재할 경우 정상적으로 실행이 안될 확률이 매우 높음
--  일반적으로 데이터가 존재하지 않는 상태, 즉 테이블을 생성한 직후에 컬럼의 사이즈, 타입이 잘못 된 경우
--  컬럼 사이즈 타입을 변경함

--  데이터가 입력된 이후로는 활용도가 매우 떨어진다(사이즈 늘리는것만 가능)
DESC emp_test;

--hp VARCHAR2(20) -> hp VARCHAR2(30)

--ALTER TABLE 테이블명 MODIFY (기존 컬럼명 신규 컬럼 타입(사이즈))
ALTER TABLE emp_test MODIFY (hp VARCHAR2(30));
DESC emp_test;
--MODIFY를 사용해서 사이즈를 변경함

--HP VARCHAR2(30) -> NUMBER로 변경
ALTER TABLE emp_test MODIFY (hp NUMBER);
DESC emp_test;
--타입을 변경함 올바른 예시는 아니다 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑

--컬럼 기본값 설정;
--ALTER TABLE 테이블명 MODIFY (컬럼명 DEFAULT 기본값)

--hp NUMBER -> hp VARCHAR2(20) DEFAULT '010'
ALTER TABLE emp_test MODIFY (hp VARCHAR2(20) DEFAULT '010');
DESC EMP_TEST;
--hp 컬럼에는 값을 넣지 않았지만 DEFAULT 설정에 의해 '010'으로 문자열이 기본값으로 저장된다.
INSERT INTO emp_test (empno, ename, deptno)VALUES (9999,'brown',99);
SELECT *
FROM emp_test;

--TABLE 변경 : 4 컬럼 변경
--변경하려고 하는 컬럼이 FK제약, PK제약이 있어도 상관 없음
--ALTER TABLE 테이블명 RENAME COLUMN 기존 컬럼명 TO 신규 컬럼명
-- hp => hp_n
ALTER TABLE emp_test RENAME COLUMN hp To hp_n;
SELECT *
FROM emp_test;


--TABLE 변경 : 5. 컬럼 삭제
--ALTER TANLE 테이블 명 DROP COLUMN 컬럼명
--emp_test 테이블에서 hp_n 컬럼 삭제

--emp_test에 hp_n 컬럼이 있는 것을 확인
SELECT *
FROM emp_test;

ALTER TABLE emp_test DROP COLUMN hp_n;

--emp_test hp_n 컬럼이 삭제되어 있는지 확인
SELECT *
FROM emp_test;

--과제
--1. emp_test 테이블을 drop한 후 empno, ename, deptno, hp 4개의 컬럼으로 테이블 생성
--2. empno, ename, deptno 3가지 컬럼에만 (9999,'brown',99)데이터로 INSERT
--3. emp_test 테이블의 hp 컬럼의 기본값을 '010'으로 설정
--4. 2번과정에 입력한 데이터의 hp 컬럼 값이 어떻게 바뀌는지 확인
--결과는 바뀌지 않고 (생성후에 DEFAULT 를 하면 기존의 컬럼에 영향을 주지 않음)NULL이 되어있을 것이다.
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    hp VARCHAR2(10)
);
INSERT INTO emp_test (empno, ename, deptno)VALUES(9999,'brown',99);
ALTER TABLE emp_test MODIFY (hp DEFAULT '010');
SELECT *
FROM emp_test;


--TABLE 변경 6. 제약조건 추가/ 삭제
--ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건 명 제약조건 타입(PRIMARY KEY, FOREIGN KEY) (해당컬럼);
--ALTER TABLE 테이블명 DROP CONSTRAUNT 제약조건 명;

--1.emp_test 테이블 삭제후
--2.제약조건 없이 테이블을 생성
--3.PRIMARY KEY, FOREIGN KEY 제약을 ALTER TABLE변경을 통해 생성;
DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT Fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);


--PRIMARY KEY 테스트
INSERT INTO emp_test VALUES (9999,'brown',99);
INSERT INTO emp_test VALUES (9999,'sally',99); --첫번째 INSERT 문에서 중복되므로 실패

--FOREIGN KEY 테이스
INSERT INTO emp_test VALUES (9998,'sally',97); --dept_test 테이블에 존재하지 않는 부서번호이므로 실패

--제약조건 삭제 : PRIMARY KEY, FOREIGN KEY 
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;
ALTER TABLE emp_test DROP CONSTRAINT fk_emp_test_dept_test;

--제약조건이 없으므로 empno가 중복된 값이 들어갈 수 있고, dept_test테이블에 존재하지 않는 deptno값도 들어갈 수 있다.
--중복된 empno값으로 데이터 입력
INSERT INTO emp_test VALUES (9999,'brown',99);

--존재하지 않는 98번 부서로 데이터 입력
INSERT INTO emp_test VALUES (9998,'sally',98);

--확인
SELECT *
FROM emp_test;
SELECT *
FROM dept_test;


--(PRIMARY, FOREIGN) KEY
--NOT NULL, UNIQUE, 

--제약조건 활성화/비활성화
--ALTER TABLE 테이블명 ENABLE | DISABLE CONSTRAINT 제약조건명
--1. emp_test 테이블 삭제
--2. emp_test 테이블 생서
--3. ALTER TABLE PRIMARY KEY(empno), FOREIGN KEY (dept_test_deptno) 제약조건 생성
--4. 두개의 제약조건을 비활성화
--5. 비활성화가 되었는지 INSERT 를 통해 확인
--6. 제약조건을 위배한 데이터가 들어간 상태에서 제약조건 활성화

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(4)
);
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno)
                                                            REFERENCES dept_test(deptno);

ALTER TABLE emp_test DISABLE CONSTRAINT pk_emp_test;
ALTER TABLE emp_test DISABLE CONSTRAINT fk_emp_test_dept_test;
INSERT INTO emp_test VALUES (9999,'brown',99);
INSERT INTO emp_test VALUES (9999,'sally',98);
commit;

SELECT *
FROM emp_test;
SELECT *
FROM dept_test;

--emp_test 테이블에는 empno컬럼의 값이 999인 사원이 두명이 존재하기 때문에
--PRIMARY KEY 제약조건을 활성화 할 수가 없다.
-- =>empno컬럼의 값이 중복되지 않도록 수정하고 제약조건 활성화 할수 있다.
DELETE emp_test
WHERE ename = 'sally';

ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test;
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test;

--dept_test 테이블에 존재하지 않는 부서번호 98을 emp_test 에서 사용중
--1. dept_test 테이블에 98번 부서를 등록하거나
--2. sally의 부서번호를 99번으로 변경하거나
--3. sally를 지우거나

UPDATE emp_test set deptno = 99
WHERE ename ='sally';
Drop table emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(4),
    hp VARCHAR2(20) 
);
INSERT INTO emp_test (empno, ename, deptno)VALUES(9999,'brown',99);
ALTER TABLE emp_test MODIFY (hp DEFAULT '010');

SELECT *
FROM emp_test;

-----------------------------------------------------------------------
--제약조건 확인 방법
--1. tool
--2. dictionary view
--제약조건 : USER_CONSTRAINTS
--제약조건-컬럼: USER_CONS_COLUMNS
--제어조건이 몇개의 컬럼에 관련되어 있는지 알수 없기 때문에 테이블을 별도로 분리하여 설계
--정규형;

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN('EMP','DEPT','EMP_TEST','DEPT_TEST');

--emp, dept pk, fk제약이 존재하지 않음
--2.emp :   pk (empno)
--3.        fk(depno) - dept.deptno
--          (fk 제약을 생성하기 위해서는 참조하는 테이블 컬럼에 인덱스가 존재해야 한다.)
--1.dept :  pk(deptno)
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
AlTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);


--테이블, 컬럼, 주석 : DICTINARY 확인가능
--테이블 주석 : USER_TAB_COMMENTS
--컬럼 주석 : USER_COL_COMMENTS

--주석생성
--테이블 주석 : COMMENT ON TABLE 테이블 명 IS '주석'
--컬럼 주석 : COMMENT ON COLUMN 테이블.컬럼 IS '주석'

--emp: 직원
--dept : 부서

COMMENT ON TABLE emp IS'직원';
COMMENT ON TABLE dept IS'부서';

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN('EMP','DEPT');


SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN('EMP','DEPT');



--DEPT	DEPTNO	    부서번호
--DEPT	DNAME	    부서명
--DEPT	LOC	        부서위치
--
--EMP	DEPTNO	    소속부서번호
--EMP	EMPNO	    직원번호
--EMP	ENAME	    직원이름
--EMP	JOB	        담당업무
--EMP	MGR	        매니저 직원번호
--EMP	HIREDATE	입사일자
--EMP	SAL	        금여
--EMP	COMM	    성과금

COMMENT ON COLUMN dept.deptno IS'부서번호';
COMMENT ON COLUMN dept.dname IS'부서명';
COMMENT ON COLUMN dept.loc IS'부서위치';

COMMENT ON COLUMN emp.deptno IS'소속부서번호';
COMMENT ON COLUMN emp.empno IS'직원번호';
COMMENT ON COLUMN emp.ename IS'직원이름';
COMMENT ON COLUMN emp.job IS'담당업무';
COMMENT ON COLUMN emp.mgr IS'매니저 직원번호';
COMMENT ON COLUMN emp.hiredate IS'입사일자';
COMMENT ON COLUMN emp.sal IS'급여';
COMMENT ON COLUMN emp.comm IS'성과금';

--실습comment1
--user_tab_comments, user_col_comments view를 이용하여 customer, product, cycle, daily 테이블과 컬럼의 주석 정보를 조회하라
SELECT *
FROM user_tab_comments
WHERE table_name IN ('CUSTOMER','CYCLE','PRODUCT','DAILY');

SELECT *
FROM user_col_comments
WHERE table_name IN ('CUSTOMER','CYCLE','PRODUCT','DAILY');


SELECT a.*,  b.column_name, b.comments
FROM user_tab_comments a, user_col_comments b
WHERE a.TABLE_name = b.TABLE_name 
AND a.table_name IN ('CUSTOMER','CYCLE','PRODUCT','DAILY');

SELECT a.*, b.column_name, b.comments
FROM user_tab_comments a inner join user_col_comments b on a.TABLE_name = b.TABLE_name
WHERE a.table_name IN ('CUSTOMER','CYCLE','PRODUCT','DAILY');

--view = query
--table 처럼 dbms에 미리 작성한 객체
--작성하지 않고 query에서 바로 작성한 view : IN_LINEVIEW -> 이름이 없기 때문에 재활용이 불가능
--view 는 테이블이다 (x)

--사용목적
--1. 보안 목적(특정 컬럼을 제외하고 나머지 결과인 개발자에 제공)
--2. INLINE -view 를 view로 생성하여 재활용
    --쿼리 길이 단축
    
--생성방법
--CREATE (OR REPLACE) VIEW 뷰명칭 : (COLUMN1,COLUMN2,....) AS
--SUBQUERY;

--emp 테이블에서 8개의 컬럼 중 sal, comn컬럼을 제외한 6개를 컬럼을 제공하는 v_emp VIEW 생성

CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;
--insufficient privileges(오류 메세지_)
--시스템 계정에서 LMH 계정으로 VIEW 생성권한 추가;
GRANT CREATE VIEW TO LMH;

--이제 View v_emp를 생성해보자.
--기존 인라인 뷰로 작성시
SELECT *
FROM v_emp;
--기존에는 인라인 뷰를 사용해서 원하는 컬럼을 조회해야 했는데 뷰테이블을 생성함으로서 서브쿼리를 하지 않고 볼수 있다.


--emp 테이블에는 부서명이 없음 => dept 테이블과 조인을 빈번하게 진행
--조인된 결과를 view로 생성 해놓으면 코드를 간겅하게 작성하는게 가능

--view : v_emp_dept
--dname(부서명), 직원번호(empno),ename(직원이름),job(담당업무),hiredate(입사일자)

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM  emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

--view 는 물리적인 데이터를 갖지 않고, 논리적인 데이터의 덩의 집합(sQL) 이기 때문에
--view에서 참조하는 테이블의 데이터가 변경이 되면 view의 조회결과도 영향을 받는다.


--Sequence
--Sequence : 시퀀스 = 중복되지 않는 정수값을 리턴해주는 오라클 객체이다.
--생성방법 
--CREATE Sequence 시퀀스_이름;
--[OPTRION....]
--[명명 규칙 : SEQ_테이블명]

--emp테이블에서 사용한 시퀀스 생성;
CREATE Sequence seq_emp;

--시퀀스 제공 함수
--1.NEXTVL : 시퀀스에서 다음 값을 가져올 때 사용
--2.CURRVAL : NEXTVAL를 사용하고 나서 현재 읽어 들인 값을 재확인

--시퀀스 주의점 
--ROLLBACK을 하더라도 NEXTVAL를 통해 얻은 값이 원복되진 않는다.
--NEXTVAL를 통해 값을 받아오면 그 값을 다시 사용할 수 없다.
SELECT seq_emp.NEXTVAL
FROM dual;

SELECT seq_emp.CURRVAL
FROM dual;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);
INSERT INTO emp_test VALUES(9999,'brown',99);
INSERT INTO emp_test VALUES(9998,'sally',98);
INSERT INTO emp_test VALUES(9997,'james',99);
DELETE emp_test 
WHERE ename = 'james';

INSERT INTO emp_test VALUES(seq_emp.NEXTVAL,'alis',10);

SELECT *
FROM emp_test;
--↑↑↑↑↑↑↑↑↑↑↑↑↑↑시퀀스를 사용하여 empno를 정의한것인데 순차적으로 데이터를
--넣을 수 있지만 insert가 아닌 곳에서 NEXTVAL를 한 상태에서 다시 insert를 하면
--번호를 건너뛰고 기록이 된다.(주의점이다)



--INDEX
SELECT rowID,a.*
FROM EMP a;


SELECT *
FROM emp
WHERE rowid = 'AAAE5tAAFAAAAEOAAH';

--인덱스가 없을 때 empno값으로 조회 하는 경우;
--emp 테이블에서 pk_emp제약조건을 삭제하여 empno컬럼으로 인덱스가 존재하지 않는 환경을 조성
ALTER TABLE emp DROP CONSTRAINT pk_emp;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7782);
   


--emp테이블의 empno컬럼으로 pk제약을 생성하고 동일한 sql을 실행
--pk : unique + not null
    --(UNIQUE 인덱스를 생성해준다)
--==> empno 컬럼으로 unique 인덱스가 생성됨
--인덱스로 sql을 실행하게 되면 인덱스가 없을 떄와 어떻게 다른지 차이점을 확인

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

SELECT rowid, emp.*
FROM emp;

SELECT empno, rowid
FROM emp
ORDER BY empno;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782);

--나의 결론 index 가 없으면 계산되는 과정이 필터링을 거치게 되고
-- index가 있으면 access 과정을 거치므로 속도면에서 더 우월하다.

SELECT *
FROM emp
WHERE ename = 'SMITH';

SELECT rowid, emp.*
FROM emp
WHERE ename = 'SMITH';
--index는 empno로 되어있는데 ename을 기준으로 조회를 하게 되면 테이블을 다 읽는 결과를 가져온다.
--비효율적이다.


--SELECT 조회 컬럼이 테이블 접근에 미치는 영향
--SELECT * FROM emp WHERE empno = 7782;
--=>
--SELECT empno FROM emp WHERE empno = 7782;

explain plan for
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782);
   
   
   
--UNIQUE VS NON-UNIQUE 인덱스의 차이 확인
--1.PK_emp 삭제
--2.empno컬럼으로 non-unique인덱스 생성
--3. 실행계획 확인

ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX idx_n_emp_01 ON emp(empno);

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 2778386618
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
   

--NON-UNIQUE INEX가 있다면 같은 값이 여러번 올수 있기 때문에 주소를 읽고 다른 7782를 찾기위해 검색한다


--emp 테이블에 job컬럼을 기준으로 하는 새로운 non-unique인덱스를 생성;
CREATE INDEX idx_n_emp_02 ON emp(job);

SELECT job, rowid
FROM emp
ORDER BY JOB;

--선택가능한 사항
--1.emp 테이블을 전체 읽기
--2.idx_n_emp_01(empno) 인덱스 활용
--3.idx_n_emp_02(job) 인덱스 활용
--오라클의 옵티마이져가 효율적인 방법을 선택하고 실행을 하게 된다.
--프로그램상으로 3번의 방법을 선택할 것이다.

explain plan for
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 1112338291
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     3 |   114 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     3 |   114 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER');
commit;



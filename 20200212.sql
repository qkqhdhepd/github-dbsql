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


----------------------------------------------------------------------
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECt *
FROM TABLE (dbms_xplan.display);

Plan hash value: 1112338291
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')
   
CREATE INDEX idx_n_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 4225125015
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')




SELECT job, ename, rowid
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';
--MANAGER	CLARK	AAAE5tAAFAAAAEOAAG

--1.table full
--2.idx1 : empno
--3.idx2 : job
--4.idx3 : ename
--5.idx4 : ename + job

CREATE INDEX idx_n_emp_04 ON emp(ename, job);

SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;

--3번째 인덱스를 지우자
--3, 4번째 인덱스가 컬럼 구성이 동일하고 순서만 다르다

DROP INDEX idx_n_emp_03;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 1173072073
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       
--조건절에 부합하는 인덱스가 있다고 해서 항상 인덱스를 사용하는 것은 아니다.
--옵티마이저의 판단에 의해 인덱스 스캔을 할수도 있고 테이블 전체 스캔을 할수도 있다.
--HINT를 사용하여 제어하는 것이 가능하긴 하다.
--DBMS에게 맡기는게 원본 사상이다.



--JOIN에서의 인덱스

--emp - table full, pk_emp(empno)
--dept - table full, pk_dept(deptno)

--(emp - table full, dept - table full)
--(dept -  table full, emp - table full)
--
--(emp - table full, dept - dept-pk_dept)
--(dept - dept-pk_dept, emp - table full)
--
--(emp - pk_emp, dept - table full)
--(dept - table full, emp - pk_emp)
--
--(emp - pk_emp, dept - pk_dept)
--(dept - pk_dept, emp - pk_emp)


--1.순서

-- 2개 테이블 조인
--각각의 테이블에 인덱스 5개씩 있다면
--한 테이블의 접근 전략 : 6개
--36 * 2 = 72

--ORACLE -  실시간 응답 : OLTP (ON LINE TRANSACTION PPOCESSING)
--         전체 처리시간 : OLAP (ON LINE ANALYSIS PPOCESSING) - 복잡한 쿼리의 실행계획을 세우는데 30Mㅡ1H       


--emp 부터 읽을까? dept부터 읽을까?

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECt *
FROM TABLE (dbms_xplan.display);

Plan hash value: 3070176698
 
 4 - 3 - 5 - 2 - 6 - 1 - 0
----------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |     1 |    33 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |              |       |       |            |          |
|   2 |   NESTED LOOPS                |              |     1 |    33 |     3   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    13 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN          | PK_DEPT      |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT         |     1 |    20 |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
   


사진 101
안만들면 안만드는게 좋은데
만약 쓴다면 5개정도?


--실습 idx1
--CREATE TABLE DEPT_TEST2 AS SELECT * FROM DEPT WHERE 1=1구문으로
--DEPT_TEST테이블 생성후 다음 조건에 맞는 인덱스를 생성하세요
--1.deptno컬럼을 기준으로 unique인덱스 생성
--2.dname컬럼을 기준으로 non-unique 인덱스 생성
--3.deptno, dname 컬럼을 기준으로 non-unique 인덱스 생성
CREATE TABLE DEPT_TEST2 AS
SELECT *
FROM DEPT
WHERE 1 = 1;

CREATE UNIQUE INDEX idx_u_dept_test2_01 ON dept_test2(deptno);
CREATE INDEX idx_n_dept_test2_01 ON dept_test2(dname);
CREATE INDEX idx_n_dept_test2_02 ON dept_test2(deptno,dname);


DROP INDEX idx_u_dept_test2_01;
DROP INDEX idx_n_dept_test2_01;
DROP INDEX idx_n_dept_test2_02;
--CTAS
--제약조건 복사가 NOT NULL만 된다.
--백업이나, 테스트용으로


--실습 idx2
--실습 idx1에서 생성한 인덱스를 삭제하는 DDL문을 작성하세요

--실습 idx3
--시스템에서 사용하는 쿼리가 다음과 같다고 할 때 적절한 emp테이블에 필요하다고 생각되는 인덱스를
--생성 스크립트를 만들어 보세요.
--1.empno 고유한 번호 (중복이 되면 안됨)--------------------------------------------
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
--프라이머리 키를 설정을 해주면 자동적으로 UNIQUE INDEX가 생성이 되어
--empno가 중복이 될수가 없게 생성

SELECT *
FROM emp
WHERE empno = :empno;
--------------------------------------------------------------------------------
--2. ename은 중복이 되어야 하므로 (동명이인) 제약조건을 설정하지 않고 인덱스도 설정하지 않음
SELECT *
FROM emp
WHERE ename = :ename;
--------------------------------------------------------------------------------
--3.join쿼리이다. 조건은 empno가 '%',  FULL table 조회
--만약에 empno가 1억개의 데이터를 가지고 있으면 부담이 될수있다.
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND emp.empno LIKE :empno || '%';
---------------------------------------------------------------------------------
--4.sal, deptno index---------------------------------------------------------------
CREATE INDEX idx_n_emp_01 ON emp(sal, deptno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE sal between :st_sal AND :ed_sal
AND deptno = :deptno;

SELECT *
FROM TABLE (dbms_xplan.display);

SELECT *
FROM emp;
Plan hash value: 825334541
 
---------------------------------------------------------------------------------------------
| Id  | Operation                    | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |              |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  FILTER                      |              |       |       |            |          |
|   2 |   TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  3 |    INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(TO_NUMBER(:ST_SAL)<=TO_NUMBER(:ED_SAL))
   3 - access("SAL">=TO_NUMBER(:ST_SAL) AND "DEPTNO"=TO_NUMBER(:DEPTNO) AND 
              "SAL"<=TO_NUMBER(:ED_SAL))
       filter("DEPTNO"=TO_NUMBER(:DEPTNO))
----------------------------------------------------------------------------------------------
--5.emp 내부 조인 쿼리이다. 조건절에 매니저넘버랑 직원넘버가 같다는 조건이 있음.
--부서별로 정렬을 해주기 위해 인덱스 생성
CREATE INDEX idx_n_emp_02 ON emp(deptno);

EXPLAIN PLAN FOR
SELECT B.*
FROM emp A, emp B
WHERE A.mgr = B.empno
AND a.deptno = :deptno;

SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 2934095731


6-5-4-3-2-1-0
----------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |     4 |   180 |     5  (20)| 00:00:01 |
|   1 |  MERGE JOIN                   |              |     4 |   180 |     5  (20)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID | EMP          |    14 |   532 |     2   (0)| 00:00:01 |
|   3 |    INDEX FULL SCAN            | PK_EMP       |    14 |       |     1   (0)| 00:00:01 |
|*  4 |   SORT JOIN                   |              |     4 |    28 |     3  (34)| 00:00:01 |
|*  5 |    TABLE ACCESS BY INDEX ROWID| EMP          |     4 |    28 |     2   (0)| 00:00:01 |
|*  6 |     INDEX RANGE SCAN          | IDX_N_EMP_02 |     5 |       |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("A"."MGR"="B"."EMPNO")
       filter("A"."MGR"="B"."EMPNO")
   5 - filter("A"."MGR" IS NOT NULL)
   6 - access("A"."DEPTNO"=TO_NUMBER(:DEPTNO))
-------------------------------------------------------------------------------------------------
--6
SELECT deptno, TO_CHAR(hiredate,'yyyymm'), COUNT(*)cnt
FROM emp
GROUP BY deptno, TO_CHAR(hiredate, 'YYYYMM');



--0.drop
DROP INDEX IDX_N_EMP_01;
DROP INDEX IDX_N_EMP_02;
DROP INDEX IDX_N_EMP_04;

--access pattern
--
--ename(=)
--depno(=), empno(Like 직원번호) ==> empno, deptno
--
--
--deptno(=), sal(BETWEEN)
--deptno(=)/mgr 동반하면 유리,
--deptno, hiredate 가 인덱스 존재하면 유리
--
--deptno, sal, mgr, hiredate



--index 실습 idx4
--시스템에서 사용하는 쿼리가 다음과 같다고 할 때 적절한 emp, dept
--테이블에 필요하다고 생각되는 인덱스를 생성 스크립트를 만들어 보세요.









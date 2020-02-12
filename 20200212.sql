--�ǽ�comment1
--user_tab_comments, user_col_comments view�� �̿��Ͽ� customer, product, cycle, daily ���̺�� �÷��� �ּ� ������ ��ȸ�϶�
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

--3��° �ε����� ������
--3, 4��° �ε����� �÷� ������ �����ϰ� ������ �ٸ���

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
       
--�������� �����ϴ� �ε����� �ִٰ� �ؼ� �׻� �ε����� ����ϴ� ���� �ƴϴ�.
--��Ƽ�������� �Ǵܿ� ���� �ε��� ��ĵ�� �Ҽ��� �ְ� ���̺� ��ü ��ĵ�� �Ҽ��� �ִ�.
--HINT�� ����Ͽ� �����ϴ� ���� �����ϱ� �ϴ�.
--DBMS���� �ñ�°� ���� ����̴�.



--JOIN������ �ε���

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


--1.����

-- 2�� ���̺� ����
--������ ���̺� �ε��� 5���� �ִٸ�
--�� ���̺��� ���� ���� : 6��
--36 * 2 = 72

--ORACLE -  �ǽð� ���� : OLTP (ON LINE TRANSACTION PPOCESSING)
--         ��ü ó���ð� : OLAP (ON LINE ANALYSIS PPOCESSING) - ������ ������ �����ȹ�� ����µ� 30M��1H       


--emp ���� ������? dept���� ������?

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
   


���� 101
�ȸ���� �ȸ���°� ������
���� ���ٸ� 5������?


--�ǽ� idx1
--CREATE TABLE DEPT_TEST2 AS SELECT * FROM DEPT WHERE 1=1��������
--DEPT_TEST���̺� ������ ���� ���ǿ� �´� �ε����� �����ϼ���
--1.deptno�÷��� �������� unique�ε��� ����
--2.dname�÷��� �������� non-unique �ε��� ����
--3.deptno, dname �÷��� �������� non-unique �ε��� ����
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
--�������� ���簡 NOT NULL�� �ȴ�.
--����̳�, �׽�Ʈ������


--�ǽ� idx2
--�ǽ� idx1���� ������ �ε����� �����ϴ� DDL���� �ۼ��ϼ���

--�ǽ� idx3
--�ý��ۿ��� ����ϴ� ������ ������ ���ٰ� �� �� ������ emp���̺� �ʿ��ϴٰ� �����Ǵ� �ε�����
--���� ��ũ��Ʈ�� ����� ������.
--1.empno ������ ��ȣ (�ߺ��� �Ǹ� �ȵ�)--------------------------------------------
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
--�����̸Ӹ� Ű�� ������ ���ָ� �ڵ������� UNIQUE INDEX�� ������ �Ǿ�
--empno�� �ߺ��� �ɼ��� ���� ����

SELECT *
FROM emp
WHERE empno = :empno;
--------------------------------------------------------------------------------
--2. ename�� �ߺ��� �Ǿ�� �ϹǷ� (��������) ���������� �������� �ʰ� �ε����� �������� ����
SELECT *
FROM emp
WHERE ename = :ename;
--------------------------------------------------------------------------------
--3.join�����̴�. ������ empno�� '%',  FULL table ��ȸ
--���࿡ empno�� 1�ﰳ�� �����͸� ������ ������ �δ��� �ɼ��ִ�.
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
--5.emp ���� ���� �����̴�. �������� �Ŵ����ѹ��� �����ѹ��� ���ٴ� ������ ����.
--�μ����� ������ ���ֱ� ���� �ε��� ����
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
--depno(=), empno(Like ������ȣ) ==> empno, deptno
--
--
--deptno(=), sal(BETWEEN)
--deptno(=)/mgr �����ϸ� ����,
--deptno, hiredate �� �ε��� �����ϸ� ����
--
--deptno, sal, mgr, hiredate



--index �ǽ� idx4
--�ý��ۿ��� ����ϴ� ������ ������ ���ٰ� �� �� ������ emp, dept
--���̺� �ʿ��ϴٰ� �����Ǵ� �ε����� ���� ��ũ��Ʈ�� ����� ������.









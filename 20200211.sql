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
--�������� Ȯ�� ���
--1. tool
--2. dictionary view
--�������� : USER_CONSTRAINTS
--��������-�÷�: USER_CONS_COLUMNS
--���������� ��� �÷��� ���õǾ� �ִ��� �˼� ���� ������ ���̺��� ������ �и��Ͽ� ����
--������;

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN('EMP','DEPT','EMP_TEST','DEPT_TEST');

--emp, dept pk, fk������ �������� ����
--2.emp :   pk (empno)
--3.        fk(depno) - dept.deptno
--          (fk ������ �����ϱ� ���ؼ��� �����ϴ� ���̺� �÷��� �ε����� �����ؾ� �Ѵ�.)
--1.dept :  pk(deptno)
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
AlTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);


--���̺�, �÷�, �ּ� : DICTINARY Ȯ�ΰ���
--���̺� �ּ� : USER_TAB_COMMENTS
--�÷� �ּ� : USER_COL_COMMENTS

--�ּ�����
--���̺� �ּ� : COMMENT ON TABLE ���̺� �� IS '�ּ�'
--�÷� �ּ� : COMMENT ON COLUMN ���̺�.�÷� IS '�ּ�'

--emp: ����
--dept : �μ�

COMMENT ON TABLE emp IS'����';
COMMENT ON TABLE dept IS'�μ�';

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN('EMP','DEPT');


SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN('EMP','DEPT');



--DEPT	DEPTNO	    �μ���ȣ
--DEPT	DNAME	    �μ���
--DEPT	LOC	        �μ���ġ
--
--EMP	DEPTNO	    �ҼӺμ���ȣ
--EMP	EMPNO	    ������ȣ
--EMP	ENAME	    �����̸�
--EMP	JOB	        ������
--EMP	MGR	        �Ŵ��� ������ȣ
--EMP	HIREDATE	�Ի�����
--EMP	SAL	        �ݿ�
--EMP	COMM	    ������

COMMENT ON COLUMN dept.deptno IS'�μ���ȣ';
COMMENT ON COLUMN dept.dname IS'�μ���';
COMMENT ON COLUMN dept.loc IS'�μ���ġ';

COMMENT ON COLUMN emp.deptno IS'�ҼӺμ���ȣ';
COMMENT ON COLUMN emp.empno IS'������ȣ';
COMMENT ON COLUMN emp.ename IS'�����̸�';
COMMENT ON COLUMN emp.job IS'������';
COMMENT ON COLUMN emp.mgr IS'�Ŵ��� ������ȣ';
COMMENT ON COLUMN emp.hiredate IS'�Ի�����';
COMMENT ON COLUMN emp.sal IS'�޿�';
COMMENT ON COLUMN emp.comm IS'������';

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

--view = query
--table ó�� dbms�� �̸� �ۼ��� ��ü
--�ۼ����� �ʰ� query���� �ٷ� �ۼ��� view : IN_LINEVIEW -> �̸��� ���� ������ ��Ȱ���� �Ұ���
--view �� ���̺��̴� (x)

--������
--1. ���� ����(Ư�� �÷��� �����ϰ� ������ ����� �����ڿ� ����)
--2. INLINE -view �� view�� �����Ͽ� ��Ȱ��
    --���� ���� ����
    
--�������
--CREATE (OR REPLACE) VIEW ���Ī : (COLUMN1,COLUMN2,....) AS
--SUBQUERY;

--emp ���̺��� 8���� �÷� �� sal, comn�÷��� ������ 6���� �÷��� �����ϴ� v_emp VIEW ����

CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;
--insufficient privileges(���� �޼���_)
--�ý��� �������� LMH �������� VIEW �������� �߰�;
GRANT CREATE VIEW TO LMH;

--���� View v_emp�� �����غ���.
--���� �ζ��� ��� �ۼ���
SELECT *
FROM v_emp;
--�������� �ζ��� �並 ����ؼ� ���ϴ� �÷��� ��ȸ�ؾ� �ߴµ� �����̺��� ���������μ� ���������� ���� �ʰ� ���� �ִ�.


--emp ���̺��� �μ����� ���� => dept ���̺�� ������ ����ϰ� ����
--���ε� ����� view�� ���� �س����� �ڵ带 �����ϰ� �ۼ��ϴ°� ����

--view : v_emp_dept
--dname(�μ���), ������ȣ(empno),ename(�����̸�),job(������),hiredate(�Ի�����)

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM  emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

--view �� �������� �����͸� ���� �ʰ�, ������ �������� ���� ����(sQL) �̱� ������
--view���� �����ϴ� ���̺��� �����Ͱ� ������ �Ǹ� view�� ��ȸ����� ������ �޴´�.


--Sequence
--Sequence : ������ = �ߺ����� �ʴ� �������� �������ִ� ����Ŭ ��ü�̴�.
--������� 
--CREATE Sequence ������_�̸�;
--[OPTRION....]
--[��� ��Ģ : SEQ_���̺��]

--emp���̺��� ����� ������ ����;
CREATE Sequence seq_emp;

--������ ���� �Լ�
--1.NEXTVL : ���������� ���� ���� ������ �� ���
--2.CURRVAL : NEXTVAL�� ����ϰ� ���� ���� �о� ���� ���� ��Ȯ��

--������ ������ 
--ROLLBACK�� �ϴ��� NEXTVAL�� ���� ���� ���� �������� �ʴ´�.
--NEXTVAL�� ���� ���� �޾ƿ��� �� ���� �ٽ� ����� �� ����.
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
--���������������������� ����Ͽ� empno�� �����Ѱ��ε� ���������� �����͸�
--���� �� ������ insert�� �ƴ� ������ NEXTVAL�� �� ���¿��� �ٽ� insert�� �ϸ�
--��ȣ�� �ǳʶٰ� ����� �ȴ�.(�������̴�)



--INDEX
SELECT rowID,a.*
FROM EMP a;


SELECT *
FROM emp
WHERE rowid = 'AAAE5tAAFAAAAEOAAH';

--�ε����� ���� �� empno������ ��ȸ �ϴ� ���;
--emp ���̺��� pk_emp���������� �����Ͽ� empno�÷����� �ε����� �������� �ʴ� ȯ���� ����
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
   


--emp���̺��� empno�÷����� pk������ �����ϰ� ������ sql�� ����
--pk : unique + not null
    --(UNIQUE �ε����� �������ش�)
--==> empno �÷����� unique �ε����� ������
--�ε����� sql�� �����ϰ� �Ǹ� �ε����� ���� ���� ��� �ٸ��� �������� Ȯ��

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

--���� ��� index �� ������ ���Ǵ� ������ ���͸��� ��ġ�� �ǰ�
-- index�� ������ access ������ ��ġ�Ƿ� �ӵ��鿡�� �� ����ϴ�.

SELECT *
FROM emp
WHERE ename = 'SMITH';

SELECT rowid, emp.*
FROM emp
WHERE ename = 'SMITH';
--index�� empno�� �Ǿ��ִµ� ename�� �������� ��ȸ�� �ϰ� �Ǹ� ���̺��� �� �д� ����� �����´�.
--��ȿ�����̴�.


--SELECT ��ȸ �÷��� ���̺� ���ٿ� ��ġ�� ����
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
   
   
   
--UNIQUE VS NON-UNIQUE �ε����� ���� Ȯ��
--1.PK_emp ����
--2.empno�÷����� non-unique�ε��� ����
--3. �����ȹ Ȯ��

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
   

--NON-UNIQUE INEX�� �ִٸ� ���� ���� ������ �ü� �ֱ� ������ �ּҸ� �а� �ٸ� 7782�� ã������ �˻��Ѵ�


--emp ���̺� job�÷��� �������� �ϴ� ���ο� non-unique�ε����� ����;
CREATE INDEX idx_n_emp_02 ON emp(job);

SELECT job, rowid
FROM emp
ORDER BY JOB;

--���ð����� ����
--1.emp ���̺��� ��ü �б�
--2.idx_n_emp_01(empno) �ε��� Ȱ��
--3.idx_n_emp_02(job) �ε��� Ȱ��
--����Ŭ�� ��Ƽ�������� ȿ������ ����� �����ϰ� ������ �ϰ� �ȴ�.
--���α׷������� 3���� ����� ������ ���̴�.

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



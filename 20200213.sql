--index �ǽ� idx4
--�ý��ۿ��� ����ϴ� ������ ������ ���ٰ� �� �� ������ emp, dept
--���̺� �ʿ��ϴٰ� �����Ǵ� �ε����� ���� ��ũ��Ʈ�� ����� ������.

SELECT *
FROM emp
WHERE empno = :empno;
SELECT *
FROM dept
WHERE deptno = :deptno;
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND emp.deptno LIKE :deptno || '%';
SELECT *
FROM emp
WHERE sal BETWEEN :st_sal AND : ed_sal
AND deptno = :deptno;
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND dept.loc = :loc;

--access pattern
--empno(=)
--deptno(=)[dept]

--depno(=), empno(Like ������ȣ) ==> empno, deptno
--deptno(=), sal(BETWEEN)

--deptno(=),loc(=)

--emp:    empno,(deptno,sal) 
--dept:   loc

--�ε��� ����
--empno, (deptno,sal,loc)
Create unique index idx_u_emp_01 ON emp(empno);
Create unique index idx_u_emp_02 ON emp(deptno,sal,loc);

----------------------------------------------------------------------------------------------------------------
--Synonym: ���Ǿ�
--1. ��ü ��Ī�� �ο�
--==>�̸��� �����ϰ� ǥ��
--
--LMH ����ڰ� �ڽ��� ���̺� emp���̺��� ����ؼ� ���� v_emp view
--hr ����ڰ� ����� �� �ְ� �� ������ �ο�
--
--v_emp : �ΰ��� ���� sal, comn�� ������ view
--
--hr ����� v_emp�� ����ϱ� ���� ������ ���� �ۼ�
--SELECT *
--FROM LMH.v_emp;
--
--hr ��������
--Synonym lmh.v_emp ==> v_emp
--v_emp == lmh.v_emp
--
--SELECT *
--FROM v_emp;

--1. sem �������� v_emp�� hr�������� ��ȸ�� �� �ֵ��� ��ȸ���� �ο�;

GRANT SELECT ON v_emp TO hr;

--2. hr ���� v_emp ��ȸ�ϴ°� ���� (���� 1������ �޾ұ� ������)
--  ���� �ش� ��ü�� �����ڸ� ��� : sem.v_emp
--  �����ϰ� sem.v_emp -> v_emp ����ϰ� ���� ����
--  sysnonym ����

--CREATE synonym �ó���̸� FOR ���� ��ü��;

--synonym ����
--drop synonym ���̺�;


--DCL(GRANT/REVOKE)
--����Ŭ�� �����ϱ� ���� �ʿ��� ���� : connect
--��ü�� �����ϱ� ���� �ʿ��� ���� : resource

--GRANT CONNECT ON LMH;
--GRANT CONNECT ON ��ü�� TO HR;

--��Ű�� : �츮�� ����ϴ� ���� �������� ��ü��� �̷���� �ִ�.
--���̺� ��ü �䵵 ��ü �ε����� ��ü�̴�.
--�̷��� ��ü���� ������ ��Ű����� �Ѵ�.



--����� �߰�
--CREATE USER lmh IDENTIFIED BY java
--DEFAULT TABLESPACE ts_lmh
--TEMPORARY TABLESPACE temp
--QUOTA UNLIMITED ON ts_LMH
--QUOTA 0m ON SYSTEM;

--��� ����
--ALTER USER lmh IDENTIFIED BY java;




--����Ŭ �ý��� : GRANT connect, resource to lmh
--            revoke resource from lmh
--����Ŭ ��ü :  Grant select,insert ON emp TO lmh
--                revoke select,insert ON emp FROM lmh

--ROLE ����
--CREATE ROLE role_name;
--ROLE ���� ���
--GRANT CREATE TABLE TO role_name;
--ROLE ���� ȸ��
--REVOKE CREATE TABLE FROM rol_name;
--ROLE ���� �ο�
--GRANT role_name to user_name;




--SEM �ʱ�
--���� ����
--1.�ý��� ���� : TABLE�� ����, view ��������
--2.��ü ���� : Ư�� ��ü�� ���� SELECT, UPDATE, INSERT, DELETE
--
--ROLE : ������ ��Ƴ��� ����
--����ں��� ���� ������ �ο��ϰ� �Ǹ� ������ �δ�
--Ư�� ROLE�� ������ �ο��ϰ� �ش� ROLE ����ڿ��� �ο�
--�ش� ROLE�� �����ϰ� �Ǹ� ROLE�� ���� �ִ� ��� ����ڿ��� ����

--���� �ο�/ȸ��
--�ý��� ���� : GRANT �����̸� TO����� | ROLE
--            REVOKE ���� �̸� FORM ����� | ROLE
--��ü ���� : GRANT �����̸� ON ��ü�� TO �����|: ROLE
--            REVOKE ���� �̸� ON ��ü�� FROM ����� | ROLE


--data dictionary : ����ڰ� �������� �ʰ�, dbms�� ��ü������ �����ϴ� �ý��� ������ ���� view
--
--data dictonary ���ξ�
--1.user : �ش� ����ڰ� ������ ��ü
--2.all : �ش� ����ڰ� ������ ��ü + �ٸ� ����ڷ� ���� �ع��� ��ü
--3.DBA : ��� ������� ��ü 
--
--* V$ Ư�� VIEW;

SELECT *
FROM user_tables;

SELECT *
FROM all_TABLES;

SELECT *
FROM DBA_TABLES;

--DICTIONARY ���� Ȯ�� : SYS.DICTIONARY


SELECT *
FROM DICTIONARY;
--��ǥ���� dictionary
--OBJECTS : ��ü ���� ��ȸ (���̺�, �ε���, view, sysnonym...)
--TABLE : ���̺� ������ ��ȸ
--TAB_COLUMN : ���̺��� �÷� ���� ��ȸ
--INDEXES : �ε��� ���� ��ȸ
--IND_COLUMNS : �ε��� ���� �÷���ȸ
--CONSTRAINTS : ���� ���� ��ȸ
--CONS_COLUMNS : �������� ���� �÷� ��ȸ
--TAB_COMMENTS : ���̺� �ּ�
--COL_COMMENTS  : ���̺��� �÷� �ּ�


--�ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡ�--
--emp, dept���̺��� �ε����� �ε��� �÷� ���� ��ȸ
--USER_indexes, USER_ind_column join
--���̺��, �ε�����, �÷���
--emp       ind_n_emp_04    ename
--emp       ind_n_emp_04    job
SELECT *
FROM user_indexes a , user_ind_columns b
WHERE a.index_name = b.index_name 
AND a.table_name IN ('EMP','DEPT');

SELECT table_name, index_name, column_name
FROM user_ind_columns
ORDER bY table_name, index_name, column_position;
--�ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡ�--




--part3 SQL����
--multiple insert : �ϳ��� insert �������� ���� ���̺� �����͸� �Է��ϴ� DML
SELECT *
FROM dept_test;

SELECT *
FROM dept_test2;

--������ ���� ���� ���̺� ���� �Է��ϴ� multiple insert
INSERT ALL
        INTO dept_test
        INTO dept_test2
SELECT 96,'���','�߾ӷ�'FROM dual UNION ALL
SELECT 97,'IT','����'FROM dual;

--���̺� �Է��� �÷��� �����Ͽ� multiple insert
ROLLBACK;
INSERT ALL
        INTO dept_test (deptno, loc) VALUES(deptno,loc)
        INTO dept_test2
SELECT 98 deptno,'���' dname ,'�߾ӷ�' loc FROM dual UNION ALL
SELECT 97,'IT','����'FROM dual;


--���̺� �Է��� �����͸� ���ǿ� ���� multiple insert;
--CASE
--    WHEN ���Ǳ��   THEN
--END
ROLLBACK;
INSERT ALL
    WHEN deptno = 98 THEN
        INTO dept_test (deptno, loc) VALUES(deptno,loc)
    ELSE
        INTO dept_test2
SELECT 98 deptno,'���' dname ,'�߾ӷ�' loc FROM dual UNION ALL
SELECT 97,'IT','����'FROM dual;

--deptno = 98�� ��� ���๮
ROLLBACK;
INSERT ALL
    WHEN deptno = 98 THEN
        INTO dept_test (deptno, loc) VALUES(deptno,loc)
        into dept_test2
    ELSE
        INTO dept_test2
SELECT 98 deptno,'���' dname ,'�߾ӷ�' loc FROM dual UNION ALL
SELECT 97,'IT','����'FROM dual;




--������ �����ϴ� ù��° insert�� �����ϴ� multiple insert
--INSERT FIRST �� ������ �����ϴ� ù��° �༮�� �����Ѵ�.
ROLLBACK;
INSERT FIRST
    WHEN deptno >= 98 THEN
        INTO dept_test (deptno, loc) VALUES(deptno,loc)
    WHEN deptno >= 97 then
        into dept_test2
    ELSE
        INTO dept_test2
SELECT 98 deptno,'���' dname ,'�߾ӷ�' loc FROM dual UNION ALL
SELECT 97,'IT','����'FROM dual;


--1�ﰳ
--��Ƽ��
--����Ŭ ��ü : ���̺� �������� ������ ��Ƽ������ ����
--���̺� �̸��� �����ϳ� ���� ������ ���� ����Ŭ ���������� ������ �и��� ������ �����͸� ����;

--dept_test =>dept_test_20200201
--���������� �����͸� �л��Ų��.

--���������� ����� ���̺�� ��¥ ���̸�...
--�̸��� ������ ���������� ������ ������ ���ָ� ���ϴ�.
--�ͽ������ǹ��������� ������ ���Ѵ�.(����Ŭ �������)
INSERT FIRST
    WHEN deptno >= 98 THEN
        INTO dept_test_20200201
    WHEN deptno >= 97 then
        into dept_test2_20200202
    ELSE
        INTO dept_test2
SELECT 98 deptno,'���' dname ,'�߾ӷ�' loc FROM dual UNION ALL
SELECT 97,'IT','����'FROM dual;


--MERGE : ����
--��Ȳ : ���̺� �����͸� �Է�/���� �Ϸ��� ��
--1.���࿡ ���� �Է��Ϸ��� �ϴ� �����Ͱ� �����ϸ� -> ������Ʈ�� ���־�� ��
--2.���� �Է��Ϸ��� �ϴ� �����Ͱ� �������� ������ ->INSERT���־�� ��

--1.SELECT������ ������ �ϰ� 
--2.�� ����� ������(row0) INSERT�ϸ� ��
--2-1. �� ����� ������(row1) update�ϸ� ��

--MERGE ������ ����ϰ� �Ǹ� SELECT �� ���� �ʾƵ� �ڵ����� ������ ������ ���� 
--INSERT Ȥ�� UPDATE�����Ѵ�.
--2���� ������ �ѹ����� �ش�.

--<<MERGE ����>>
--MERGE INTO ���̺�� [alias]
--USING (TABLE | VIEW | IN-LINE-VIEW)
--ON (��������)                         
--WHEN MATCHED THEN    (���࿡ ���⼭ �����ϴ� �����Ͱ� �ִٸ�)
--  UPDATE SET coll = �÷���, col2 = �÷���
--WHEN NOT MATCHED THEN        (���࿡ ���⼭ �����ϴ� �����Ͱ� ���ٸ�)
--  INSERT (�÷�1, �÷�2, �÷�3...)VALUES (�÷���1, �÷���2....);


DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno number(4),
    ename varchar2(10),
    deptno number(2),
    hp  varchar2(20)
);
ALTER TABLE emp_test MODIFY (hp DEFAULT '010');


SELECT *
FROM emp_test;

DELETE emp_test;

--�α׸� �ȳ����. ==>������ �ȵȴ� -->�׽�Ʈ ������ ���� ��
TRUNCATE TABLE emp_test;

--emp���̺��� emp_test���̺�� �����Ѵ�.(7369-SMITH)

INSERT INTO emp_test
SELECT empno, ename, deptno, '010'
FROM emp
WHERE empno = 7369;

--�����Ͱ� �� �Է� �Ǿ����� Ȯ��;
SELECT *
FROM emp_test;

UPDATE emp_test SET ename = 'brown'
WHERE empno = 7369;

COMMIT;

--emp���̺��� ��� ������ emp_test���̺�� ������ ����
--emp���̺��� ���������� emp_test���� �������� ������ insert
--emp���̺��� �����ϰ� emp_test���� �����ϸ� ename, deptno�� update


--emp���̺� �����ϴ� 14���� �������� emp_test���� �����ϴ�  7369 �� ������ 13���� �����Ͱ� 
--emp_test ���̺� �űԷ� �Է��� �ǰ�
--emp_test�� �����ϴ� 7369���� �����ʹ� ename(brown)�� emp ���̺� �����ϴ� �̸��� SMITH�� ����
MERGE INTO emp_test a
USING emp b
ON (a.empno= b.empno)
WHEN MATCHED THEN
    update set a.ename = b.ename,
                a.deptno = b.deptno
WHEN NOT MATCHED THEN
    INSERT (empno, ename, deptno) VALUES (b.empno, b.ename, b.deptno);

SELECT *
FROM emp_test;


--�ش� ���̺� �����Ͱ� ������ insert, ������ update
--emp_test���̺� ����� 9999���� ����� ������ ���Ӱ� insert
--������ update
--(9999,'brown',10,'010')

INSERT INTO emp_test VALUES (9999,'brown',10,'010');

UPDATE emp_test SET ename = 'brown',
                    deptno = 10,
                    hp = '010'
WHERE empno = 9999;

SELECT *
FROM emp_test;


MERGE INTO emp_test
USING dual
ON (empno = 9999)
WHEN MATCHED THEN
    UPDATE SET ename = 'brown',
                deptno = 10,
                hp = '010'
WHEN NOT MATCHED THEN
    INSERT VALUES (9999,'brown',10,'010');


SELECT *
FROM emp_test;
--MERGE, window function(�м��Լ�)

--report group funcion
--�μ��� �հ�, ��ü �հ踦 ������ ���� ���Ϸ���??(�ǽ�(group_ad1)
SELECT deptno,sum(sal)
FROM emp
GROUP BY deptno
ORDER BY deptno;

SELECT deptno, sum(sal)
FROM emp
GROUP BY deptno
union 
SELECT null ,sum(sal)
FROM emp;
--�Ұ�� ��ü���� ���ƴ�.



--I/O
--CPU CASHE > RAM > SSD > HDD > NETWORK
--REPORT GROUP FUNCTION
--ROLLUP
--CUBE
--GROUPING;

--ROLLUP
--����� : GROUP BY ROLLUP (�÷�1, �÷�2......)
--SUBGROUP�� �ڵ������� ����
--SUBGROUP �� �����ϴ� ��Ģ : ROLLUP�� ����� �÷��� �����ʿ������� �ϳ��� �����ϸ鼭
--                        SUB GROUP�� ����

-- EX : GROUP BY ROLLUP (deptno)
-->
--ù��° sub group : group BY deptno
--�ι�° sub group : group BY null -> ��ü ���� ���
SELECT deptno, sum(sal)
FROM emp
GROUP BY ROLLUP (deptno);
--����׷��� ����


SELECT job, deptno, sum(sal+NVL(comm, 0))sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--GROUP BY job, deptno    : ������, �μ��� �޿���
--GROUP BY job            : �������� �޿���
--GROUP BY                : ��ü �޿���

SELECT case grouping(job)
            WHEN 1 THEN '����'
        ELSE job
        END job, 
        deptno,
        grouping(job),grouping(deptno),
        sum(sal+NVL(comm, 0))sal
        
FROM emp
GROUP BY ROLLUP (job, deptno);

--GROUP_AD2
--grouping�� ����ؼ� ���� null������ Ȯ���Ͽ� �������� ������� �ִ�.
SELECT case grouping(job)
            WHEN 1 THEN '�Ѱ�'
        ELSE job
        END job, 
        deptno,
        sum(sal+NVL(comm, 0))sal
FROM emp
GROUP BY ROLLUP (job, deptno);

SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '�Ѱ�'
        else job
        END job,
        deptno,
        sum(sal+NVL(comm, 0))sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--DECODE�� �ϸ� ��� �ϸ� �ɱ�?
SELECT 
    DECODE (GROUPING(job),1,'�Ѱ�',0,job)job,
    deptno,
    sum(sal+NVL(comm, 0))sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--decode���� �ε��� �� ������ �ü� ���� ��?
--CREATE index idx_test ON emp(job);       --JOB�÷��� �������� �ε����� ����
--idx_test�� ������ ���� 


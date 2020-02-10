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
--  k_cd , 총사?��??, null
--  k_cd_1, �??��?��??1, k_cd
--  k_cd_2, �??��?��??2 k_cd


-- e_no, e_nm, g_cd, j_cd, d_cd
-- 100, ?��명현, 과장, ???��, k_cd_1
-- 101, 박소?��, ??�?, null, k_cd_1
-- 102, ?��?���?, 차장, ???��, k_cd_2

-- j_cd, j_nm, ord
-- j_cd_1, ???��, 1
-- j_cd_2, �??��?��, 2

-- g_cd,g_nm , ord
-- g_cd_1, 과장, 1
-- g_cd_2, ??�?, 2

-- cs_id, cs_reg_dt, cs_cont, e_no, cs_cd1 , cs_cd2, cs_cd3
-- cs_is_1, sysdate, ?��?��?��?��?��?��?��?��?��., 100, cs_cd1_1, cs_cd2_1, cs_cd3_1
-- cs_is_2, sysdate, ?��?��?��?��?��?��?��?��?��.2, 100, cs_cd1_1, cs_cd2_1, cs_cd3_1
-- cs_id_3, sysdate, ?��?��?��?��?��?��3, 100, cs_cd2, cs_cd3, cs_cd5



-- cs_cd, cd_nm, p_cs_cd
-- cs_cd1, 교환, null
-- cs_cd2, ?��?���??��, cs_cd1
-- cs_cd3, 물건?��?��, cs_cd1
-- cs_cd4, 배송, null
-- cs_cd5, 주소�?�?�?, cs_cd4
-- cs_cd6, 배송취소?���?, cs_cd4


CREATE TABLE ts(
    cs_cd VARCHAR2(20) NOT NULL,
    cs_nm VARCHAR2(50) NOT NULL,
    p_cs_cd VARCHAR2(20),
    CONSTRAINT PK_example5 PRIMARY KEY(cs_cd)

);

ALTER TABLE ts DROP CONSTRAINT PK_example5;

ALTER TABLE ts ADD CONSTRAINT PK_example1 PRIMARY KEY(cs_cd)
;


-----------------------------------------------rename?���? �?경�??��
ALTER TABLE ts
RENAME CONSTRAINT PK_example1 TO PK_example0;
select *
FROM ts;
insert into ts (cs_cd,cs_nm,p_cs_cd)values('a','b','c');
commit;
ALTER TABLE ts
RENAME CONSTRAINT PK_example0 TO PK_example9;

------?��?��?���? 존재?���? ?��?�� ?�� �??��;



--20200210 ���� ����

--1. PRIMARY KEY �������� ������ ����Ŭ dbms�� �ش� �÷����� unique index�� �ڵ����� �����Ѵ�.
--(��Ȯ���� UNIQUE ���࿡ ���� UNIQUE �ε����� �ڵ����� �����ȴ�.
--  PRIMARY KEY  = UNIQUE + nOT NULL )

--index : �ش� �÷����� �̸� ������ �س��� ��ü�̴�.
--������ �Ǿ��ֱ� ������ ã���� �ϴ� ���� �����ϴ� �� ������ �˼��� �ִ�.
--���࿡ �ε����� ������ ���ο� �����͸� �Է��� �� �ߺ��Ǵ� ���� ã�� ���ؼ� �־��� ��� ���̺��� ��� �����͸� ã�ƾ� �Ѵ�.
--������ �ε����� ������ �̹� ������ �Ǿ� �ֱ� ������ �ش� ���� ���� ������ ������ �˼��� �ִ�.

--2. Foreign key �������ǵ�
--�����ϴ� ���̺� ���� �ִ����� Ȯ�� �ؾ��Ѵ�.
--�׷��� �����ϴ� �÷��� �ε����� �־������ Forign key ������ ������ ���� �ִ�.

--Foreign key ������ �ɼ�
--Foreign key (���� ���Ἲ) : �����ϴ� ���̺��� �÷��� �����ϴ� ���� �Է� �� �� �ֵ��� ����
--(ex. : emp ���̺� ���ο� �����͸� �Է½� deptno �÷����� dept ���̺� �����ϴ� �μ���ȣ�� �Է� �� �� �ִ�.)

--Foreign key �� �����ʿ� ���� �����͸� ������ �� ������
--� ���̺��� �����ϰ� �ִ� �����ʹ� �ٷ� ������ �ȵ�
--(ex : emp.deptno => dept.deptno �÷��� �����ϰ� ���� ��
--      �μ� ���̺��� �����͸� ���� �Ҽ��� ����)

select *
FROM emp_test;

SELECT *
FROM dept_test;

insert into dept_test VALUES(98,'ddit','����');
insert into emp_test(empno, ename, deptno) Values( 9999,'brown',99);
commit;

--��Ȳ ���� emp: 9999,99�� �ְ� dept�� 98,99�� ����
--=> 98���μ��� �����ϴ� emp���̺��� �����ʹ� ����
--=> 99���μ��� �����ϴ� emp���̺��� �����ʹ� 9999�� brown ����� ����

--��ȭ�����غ���)
--���࿡ ���� ������ �����ϰ� �Ǹ� ������ ���. �ֳ��ϸ� emp ���̺��� �����ϰ� �ִ� �����Ͱ� �����Ǳ� ������ ������ ���.
--(emp�� ���� �����ϰ� dept�ؾ���)
--DELETE dept_test
--WHERE deptno = 99;

--�׷��ٸ� 98���� �����ϰ� �Ǹ� ��� �ɱ�?
--emp���̺��� �����ϴ� �����Ͱ� ���� 98�� �μ��� �����ϸ�?
-- �� ���� FOREIGN KEY�� ���� ���Ἲ�� ������ �ʱ� ������ �������� �������� ������ �ȴ�.
--DELETE dept_test
--WHERE deptno = 98;

--FOREIGN KEY�ɼ�
--1. ON DELETE CASCADE : �θ� ������ ���( dept�� ���ϰ�) �����ϴ� �ڽ� �����͵� ���� �����ؾ� �Ѵ�.(emp)
--2. ON DELETE SET NULL : �θ� ������ ���(dept) �����ϴ� �ڽ� �������� �ɷ��� NULL�� �����Ѵ�.

--emp_test���̺��� drop�� �ɼ��� ������ ���� ������ ���� �׽�Ʈ�� �غ���.��
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
--��Ȳ�����
--emp_test ���̺��� deptno �÷��� dept_test ���̺��� deptno_test �÷��� �����ϰ� �ִµ� �ɼ��� (ON DELETE CASCADE)�̴�
--�ɼǿ� ���� �θ����̺�(dept_test)������ �����ϰ� �ִ� �ڽ� �����͵� ���� �����ȴ�.
DELETE dept_test
WHERE deptno = 99;

--�ɼ��� �ο����� �ʾ��� ���� ���� DELETE ������ ������ �߻��Ѵ�.
--�ɼǿ� ���� �����ϴ� �ڽ� ���̺��� �����Ͱ� ���������� ������ �Ǿ����� SELECT ���ؼ� Ȯ���Ѵ�.

SELECT *
FROM emp_test;
--������ ����� �θ� �ִ� 99�� ���̺��� �����ϰ� �Ǹ� �ɼ����� ���ؼ� �ڽ� ���̺� �ִ� �����ͱ��� ������ ��


--2. FK ON DELETE SET NULL �ɼ� ���̽�
--�θ����̺��� ������ ������ (dept_test) �ڽ� ���̺��� �����ϴ� �����͸� NULL�� ������Ʈ ���ش�.
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

--dept_test ���̺���99�� �μ��� �����ϰ� �Ǹ� (�θ� ���̺��� �����ϸ�) 99�� �μ��� �����ϴ� emp_test ���̺���
--9999��(brown)���̺��� deptno �÷��� FK �ɼǿ� ���� NULL�� �����Ѵ�.

DELETE dept_test
WHERE deptno = 99;
--�ڽ� ���̺��� ������ ������ �ڽ� ���̺��� �����Ͱ� NULL�� ����Ǿ����� Ȯ���Ѵ�.
SELECT *
FROM emp_test;
--��������� NULL �ٲ�� �ȴ�.
SELECT *
FROM dept_test;


--CHCK �������� : �÷��� ���� ���� ������ ������ �� ���
--ex: �޿� �÷��� ���ڷ� ����, �޿��� ������ �� �� ���� ��?
--      �Ϲ����� ��� �޿����� > 0
--      CHECK ������ ����� ��� �޿����� 0���� ū���� �˻� ����.
--      EMP ���̺��� JOB �÷��� ���� ���� ���� 4������ ���� ����
--      'SALESMAN','PRESIDENT','ANALYST','MANAGER'

--���̺� ������ �÷� ����� �Բ� CHECK ���� ����
--emp_test ���̺��� sal �÷��� 0���� ũ�ٴ� CHECK �������� ����

INSERT INTO dept_test VALUES(99,'ddit','����');
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

--��������������(sal_ üũ���ǿ� ���� 0���� ū ���� �Է��ϴ��ϴ�)
--INSERT INTO emp_test VALUES (9998,'sally',99,-1000)
--���� ���� -
--ORA-02290: check constraint (LMH.SYS_C007216) violate

--���ο� ���̺� ����
--CREATE TABLE ���̺��(
--    �÷�1....
--);
--CREATE TABLE ���̺�� AS
--SELECT ����� ���ο� ���̺�� ����

--emp ���̺��� �̿��ؼ� �μ���ȣ�� 10�� ����鸸 ��ȸ�Ͽ� �ش� �����ͷ� emp_test2���̺��� ����;

CREATE TABLE emp_test2 AS
    SELECT *
    FROM emp
    WHERE deptno = 10;

SELECT *
FROM emp_test2;
--DDL (table - create table as)
--not null�������� �̿��� ������ ������� �ʴ´�.
--�ǹ����� �����͸� ���� �� �Ҿ��ϴϱ� �׳� �۾��� ���̺��� 20200210�� �ٿ��� ����� �س��� �� ����� �ȴ�.
--������ �̰��� �ʹ� ���ϸ�(�Ѵ��� ��,���Ǿ�) ���Ⱑ �����ϴ�. (������ �ƴ�)
--��, ���߽� ������ ����� �׽�Ʈ ������ ���ؼ� ���ȴ�.
--PT 34���� ���� ����


--TABLE �����ϱ�
--1. �÷��߰��ϱ�
--2. �÷�������/ Ÿ�� ����
--3. �⺻���� ����
--4. �÷����� RENAME
--5. �÷��� ����
--6. �������� �߰�/����

--TABLE ���� : 1. �÷��߰��ϱ�  (HP varchar2(20));

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT pk_emp_test PRIMARY KEY (empno),
    CONSTRAINT fk_emp_test FOREIGN KEY (deptno)
            REFERENCES dept_test(deptno)
);

--ALTER TABLE ���̺�� ADD (�ű��÷��� �ű��÷� Ÿ��);
ALTER TABLE emp_test ADD HP varchar2(20);
INSERT INTO emp_test VALUES(9999,'brown',99,'010-1234-5678');
DELETE emp_test
WHERE empno = 9999;
SELECT *
FROM emp_test;

--TABLE ���� : 2. �÷������� ����, Ÿ�Ժ��� 
--ex : �÷� varchar2(20) => varchar2(5)
--  ������ �����Ͱ� ������ ��� ���������� ������ �ȵ� Ȯ���� �ſ� ����
--  �Ϲ������� �����Ͱ� �������� �ʴ� ����, �� ���̺��� ������ ���Ŀ� �÷��� ������, Ÿ���� �߸� �� ���
--  �÷� ������ Ÿ���� ������

--  �����Ͱ� �Էµ� ���ķδ� Ȱ�뵵�� �ſ� ��������(������ �ø��°͸� ����)
DESC emp_test;

--hp VARCHAR2(20) -> hp VARCHAR2(30)

--ALTER TABLE ���̺�� MODIFY (���� �÷��� �ű� �÷� Ÿ��(������))
ALTER TABLE emp_test MODIFY (hp VARCHAR2(30));
DESC emp_test;
--MODIFY�� ����ؼ� ����� ������

--HP VARCHAR2(30) -> NUMBER�� ����
ALTER TABLE emp_test MODIFY (hp NUMBER);
DESC emp_test;
--Ÿ���� ������ �ùٸ� ���ô� �ƴϴ� ���������������

--�÷� �⺻�� ����;
--ALTER TABLE ���̺�� MODIFY (�÷��� DEFAULT �⺻��)

--hp NUMBER -> hp VARCHAR2(20) DEFAULT '010'
ALTER TABLE emp_test MODIFY (hp VARCHAR2(20) DEFAULT '010');
DESC EMP_TEST;
--hp �÷����� ���� ���� �ʾ����� DEFAULT ������ ���� '010'���� ���ڿ��� �⺻������ ����ȴ�.
INSERT INTO emp_test (empno, ename, deptno)VALUES (9999,'brown',99);
SELECT *
FROM emp_test;

--TABLE ���� : 4 �÷� ����
--�����Ϸ��� �ϴ� �÷��� FK����, PK������ �־ ��� ����
--ALTER TABLE ���̺�� RENAME COLUMN ���� �÷��� TO �ű� �÷���
-- hp => hp_n
ALTER TABLE emp_test RENAME COLUMN hp To hp_n;
SELECT *
FROM emp_test;


--TABLE ���� : 5. �÷� ����
--ALTER TANLE ���̺� �� DROP COLUMN �÷���
--emp_test ���̺��� hp_n �÷� ����

--emp_test�� hp_n �÷��� �ִ� ���� Ȯ��
SELECT *
FROM emp_test;

ALTER TABLE emp_test DROP COLUMN hp_n;

--emp_test hp_n �÷��� �����Ǿ� �ִ��� Ȯ��
SELECT *
FROM emp_test;

--����
--1. emp_test ���̺��� drop�� �� empno, ename, deptno, hp 4���� �÷����� ���̺� ����
--2. empno, ename, deptno 3���� �÷����� (9999,'brown',99)�����ͷ� INSERT
--3. emp_test ���̺��� hp �÷��� �⺻���� '010'���� ����
--4. 2�������� �Է��� �������� hp �÷� ���� ��� �ٲ���� Ȯ��
--����� �ٲ��� �ʰ� (�����Ŀ� DEFAULT �� �ϸ� ������ �÷��� ������ ���� ����)NULL�� �Ǿ����� ���̴�.
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


--TABLE ���� 6. �������� �߰�/ ����
--ALTER TABLE ���̺�� ADD CONSTRAINT �������� �� �������� Ÿ��(PRIMARY KEY, FOREIGN KEY) (�ش��÷�);
--ALTER TABLE ���̺�� DROP CONSTRAUNT �������� ��;

--1.emp_test ���̺� ������
--2.�������� ���� ���̺��� ����
--3.PRIMARY KEY, FOREIGN KEY ������ ALTER TABLE������ ���� ����;
DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT Fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);


--PRIMARY KEY �׽�Ʈ
INSERT INTO emp_test VALUES (9999,'brown',99);
INSERT INTO emp_test VALUES (9999,'sally',99); --ù��° INSERT ������ �ߺ��ǹǷ� ����

--FOREIGN KEY ���̽�
INSERT INTO emp_test VALUES (9998,'sally',97); --dept_test ���̺� �������� �ʴ� �μ���ȣ�̹Ƿ� ����

--�������� ���� : PRIMARY KEY, FOREIGN KEY 
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;
ALTER TABLE emp_test DROP CONSTRAINT fk_emp_test_dept_test;

--���������� �����Ƿ� empno�� �ߺ��� ���� �� �� �ְ�, dept_test���̺� �������� �ʴ� deptno���� �� �� �ִ�.
--�ߺ��� empno������ ������ �Է�
INSERT INTO emp_test VALUES (9999,'brown',99);

--�������� �ʴ� 98�� �μ��� ������ �Է�
INSERT INTO emp_test VALUES (9998,'sally',98);

--Ȯ��
SELECT *
FROM emp_test;
SELECT *
FROM dept_test;


--(PRIMARY, FOREIGN) KEY
--NOT NULL, UNIQUE, 

--�������� Ȱ��ȭ/��Ȱ��ȭ
--ALTER TABLE ���̺�� ENABLE | DISABLE CONSTRAINT �������Ǹ�
--1. emp_test ���̺� ����
--2. emp_test ���̺� ����
--3. ALTER TABLE PRIMARY KEY(empno), FOREIGN KEY (dept_test_deptno) �������� ����
--4. �ΰ��� ���������� ��Ȱ��ȭ
--5. ��Ȱ��ȭ�� �Ǿ����� INSERT �� ���� Ȯ��
--6. ���������� ������ �����Ͱ� �� ���¿��� �������� Ȱ��ȭ

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

--emp_test ���̺��� empno�÷��� ���� 999�� ����� �θ��� �����ϱ� ������
--PRIMARY KEY ���������� Ȱ��ȭ �� ���� ����.
-- =>empno�÷��� ���� �ߺ����� �ʵ��� �����ϰ� �������� Ȱ��ȭ �Ҽ� �ִ�.
DELETE emp_test
WHERE ename = 'sally';

ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test;
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test;

--dept_test ���̺� �������� �ʴ� �μ���ȣ 98�� emp_test ���� �����
--1. dept_test ���̺� 98�� �μ��� ����ϰų�
--2. sally�� �μ���ȣ�� 99������ �����ϰų�
--3. sally�� ����ų�

UPDATE emp_test set deptno = 99
WHERE ename ='sally';
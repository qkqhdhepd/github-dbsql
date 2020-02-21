set SERVEROUTPUT on;

create or replace procedure printtemp(p_empno IN emp.empno%type) is
    v_dname dept.dname%type;
    v_ename emp.ename%type;
begin
    select ename, dname into v_dname, v_ename
    from dept, emp
    where p_empno = emp.empno and dept.deptno = emp.deptno;
    
    DBMS_OUTPUT.PUT_LINE(v_dname || ', ' || v_ename);
end;
/

exec printtemp(7566);

SELECT *
FROM emp;

--PL/SQL
--regisdept_test procedure ����

set SERVEROUTPUT on;
create or replace procedure registdept_test(p_deptno IN dept_test.deptno%type,
											p_dname IN dept_test.dname%type,
											p_loc IN dept_test.loc%type)
											IS
	
begin
	INSERT INTO dept_test(deptno,dname,loc) VALUES(p_deptno, p_dname,p_loc);
end;
/

exec registdept_test(99,'ddit','daejeon');

SELECT *
FROm dept_test;
commit;

--���� �ǽ� pro_3
set SERVEROUTPUT on;
create or replace procedure updatedept_test(p_deptno IN dept_test.deptno%type,
											p_dname IN dept_test.dname%type,
											p_loc IN dept_test.loc%type)
											IS
	
begin
	Update dept_test set dname = p_dname, loc = p_loc
	WHERE deptno = 99;
end;
/

exec updatedept_test(99,'ddit_m','daejeon');

SELECT *
FROm dept_test;
commit;

--���պ��� %rowtype : Ư�� ���̺��� ���� ��� �÷��� ������ �� �ִ� ����
--��� ��� : ������ ���̺�� %rowtype;

SET SERVEROUTPUT ON;
DECLARE
	v_dept_row dept%ROWTYPE;
BEGIN
	SELECT * INTO v_dept_row
	FROM dept
	WHERE deptno = 10;
	
	DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' ' || v_dept_row.dname || ' ' || v_dept_row.loc);
END;
/

--���պ��� record
--�����ڰ� ���� �������� �÷��� ���� �� �� �ִ� Ÿ���� �����ϴ� ���
--JAVA �����ϸ� Ŭ������ �����ϴ� ����
--�ν��Ͻ��� ����� ������ ��������

--����
--type Ÿ���̸�(�����ڰ� ����) IS RECORD(
--	������ 1 ���� Ÿ��,
--	������ 2 ���� Ÿ��
--	);
--	
--������ Ÿ���̸�;

DECLARE
	TYPE dept_row IS RECORD(
		deptno NUMBER(2),
		dname VARCHAR2(14)
		);
		
		v_dept_row dept_row;
BEGIN
	SELECT deptno, dname INTO v_dept_row
	FROM dept
	WHERE deptno = 10;
	
	DBMS_OUTPUT.PUT_LINE( v_dept_row.deptno || ' ' || v_dept_row.dname);

END;
/

--table type ���̺� Ÿ��
--�� : ��Į�� ����
--�� : %rowtype, record type
--�� : table type
--	��� �� (%rowtype, record type)�� ������ �� �ִ���
--	�ε��� Ÿ���� ��������;
--DEPT ���̺��� ������ ���� �� �ִ� table type�� ����
--������ ��� ��Į�� Ÿ��, rowtype������ �� ���� ������ ���� �� �־�����
--table Ÿ�� ������ �̿��ϸ� ���� ���� ������ ���� �� �ִ�.

DECLARE
	TYPE dept_tab IS TABLE OF dept%rowTYPE INDEX BY BINARY_INTEGER;
	v_dept_tab dept_tab;
BEGIN
	SELECT * BULK COLLECT INTO v_dept_tab
	FROM dept;
	--���� ��Į�� ����, record Ÿ���� �ǽ��ÿ���
	--�ѻ��� ��ȸ �ǵ��� WHERE���� ���� �����Ͽ���.
	
	--���ٹ��
	--�ڹٿ����� �迭[�ε��� ��ȣ]
	--table ����(�ε��� ��ȣ)�� ����
	DBMS_OUTPUT.PUT_LINE(v_dept_tab(1).deptno || ' ' || v_dept_tab(1).dname);
	DBMS_OUTPUT.PUT_LINE(v_dept_tab(2).deptno || ' ' || v_dept_tab(2).dname);
	DBMS_OUTPUT.PUT_LINE(v_dept_tab(3).deptno || ' ' || v_dept_tab(3).dname);
	DBMS_OUTPUT.PUT_LINE(v_dept_tab(4).deptno || ' ' || v_dept_tab(4).dname);
END;
/

--������ loop����
DECLARE
	TYPE dept_tab IS TABLE OF dept%rowTYPE INDEX BY BINARY_INTEGER;
	v_dept_tab dept_tab;
BEGIN
	SELECT * BULK COLLECT INTO v_dept_tab
	FROM dept;
	--���� ��Į�� ����, record Ÿ���� �ǽ��ÿ���
	--�ѻ��� ��ȸ �ǵ��� WHERE���� ���� �����Ͽ���.
	
	--���ٹ��
	--�ڹٿ����� �迭[�ε��� ��ȣ]
	--table ����(�ε��� ��ȣ)�� ����
--	FOR(int i = 0; i < 10; i++){
--	}
	
	FOR i IN 1..v_dept_tab.count LOOP
		DBMS_OUTPUT.PUT_LINE(v_dept_tab(i).deptno || ' ' || v_dept_tab(i).dname);
	END LOOP;
	
END;
/

--���� ���� if
--����
--if ���ǹ� then
--	���๮;
--else if ���ǹ� then
--	���๮;
--else 
--	���๮;
--end if;

DECLARE
	p NUMBER(1) := 2;  --���� ����� ���ÿ� ���� ����
BEGIN
	IF p = 1 THEN
		DBMS_OUTPUT.PUT_LINE('1�Դϴ�');
	ELSIF p = 2 THEN
		DBMS_OUTPUT.PUT_LINE('2�Դϴ�');
	ELSE
		DBMS_OUTPUT.PUT_LINE('�˷����� �ʾҽ��ϴ�.');	
	END IF;
END;
/

--CASE ����
--1.�Ϲ� ���̽� (java�� switch���� ����)
--2.�˻� ���̽� (if, else if, else)

--CASE expression
--	WHEN value THEN
--		���๮;
--	WHEN value THEN
--		���๮;
--	ELSE
--		���๮;
--END CASE;

DECLARE
	p NUMBER(1) :=2;
BEGIN
	CASE p
		WHEN 1 THEN
			DBMS_OUTPUT.PUT_LINE('1�Դϴ�');
		WHEN 2 THEN
			DBMS_OUTPUT.PUT_LINE('2�Դϴ�');
		ELSE
			DBMS_OUTPUT.PUT_LINE('�𸣴� ���Դϴ�.');
	END CASE;
END;
/

--For LOOP ����
--FOR ��������/�ε��� ���� IN [REVERSE] ���۰�...���ᰪ LOOP
--	�ݺ��� ����;
--END LOOP;
--
--1���� 5���� FOR LOOP �ݺ����� �̿��Ͽ� ���� ���

DECLARE
BEGIN
	FOR i IN 1..5 LOOP
		DBMS_OUTPUT.PUT_LINE(i);
	END LOOP;
END;
/

--�ǽ� : 2-9�� ���� �������� ���;
DECLARE
BEGIN
	FOR i IN 2..9 LOOP
		FOR j IN 1..9 LOOP
			DBMS_OUTPUT.PUT_LINE(i || '*' || j || ' = ' || i*j);
		END LOOP;
	END LOOP;
END;
/


--while��
DECLARE
	i number := 0;
BEGIN
	FOR i <= 5 LOOP
		DBMS_OUTPUT.PUT_LINE(i);
		i := i+1;
	END LOOP;
END;
/


--LOOP�� ���� => while(true)
--LOOP
--	�ݺ������� ����;
--	EXIT
--END LOOP;
--LOOP���� ����� �� �ݺ��ϴ� ������ ��� �Ǿ� ���� �� �����غ���.
DECLARE
	i NUMBER := 0;
BEGIN
	LOOP
		EXIT WHEN i > 5;
		DBMS_OUTPUT.PUT_LINE(i);
		i := i + 1;
	END LOOP;
END;
/



--������ SQL �����̶� : �ؽ�Ʈ�� �Ϻ��ϰ� ������ SQL
--1.��ҹ��� ����
--2.���鵵 ���� �ؾ���
--3. ��ȸ ����� ���ٰ� ������ SQL�� �ƴ�
--4. �ּ��� ������ ��ħ
--�׷��� ������ ���� SQL ������ ������ ������ �ƴ�;
SELECT * FROM dept;
select * FROM dept;
select  * FROM dept;
select *
FROM dept;

--SQL ����� v$SQL �信 �����Ͱ� ��ȸ�Ǵ��� Ȯ��
SELECT /*sql_test*/*FROM dept;

/*�ý��� ��������*/
SELECT *
FROM v$SQL
WHERE sql_text LIKE '%dept%';

--�� �ΰ��� SQL�� �˻��ϰ��� �ϴ� �μ���ȣ�� �ٸ��� ������ �ؽ�Ʈ�� �����ϴ�.
--������ �μ���ȣ�� �ٸ��� ������ DBMS���忡���� ���� �ٸ� SQL�� �νĵȴ�.
--> �ٸ� SQL ���� ��ȹ�� �����
--> �ǻ� ��ȹ�� �������� ���Ѵ�.
--> �ذ�å ���̵� ����
--SQL���� ����Ǵ� �κ��� ������ ������ �ϰ� �����ȹ ������ ���Ŀ� ���ε� �۾��� ����
--���� ����ڰ� ���ϴ� ���� ������ ġȯ �� ����
--> ���� ��ȹ�� ���� -->�޸� �ڿ� ���� ����

SELECT /* sql_test */*
FROM dept
WHERE deptno = :deptno;

SELECT *
FROM dept;

--SQL Ŀ�� : SQL���� �����ϱ� ���� �޸� ����
--������ ����� SQL���� ������ Ŀ���� ���.
--������ �����ϱ� ���� Ŀ�� : ����� Ŀ��
--SELECT ��� �������� TABLEŸ���� ������ ������ �� ������
--�޸𸮴� �������̱� ������ ���� ���� �����͸� ��⿡�� ������ ����.

--SQL Ŀ���� ���� �����ڰ� ��wjq FETCH �����μ� SELECT ����� ���� �ҷ����� �ʰ� ������ ����
--Ŀ�� ���� ���:
--�����(DECLARE)���� ����
--	CURSOR Ŀ�� �̸� IS
--	������ ����
--����� (BEGIN)���� Ŀ�� ����
--	OPEN Ŀ���̸�;
--�����(BEGIN)���� Ŀ���� ���� ������ FETCH
--	FETCH Ŀ���̸� INTO ����;
--�����(BEGIN)���� Ŀ�� �ݱ�
--	CLOSE Ŀ���̸�;

--�μ� ���̺��� Ȱ���Ͽ� ��� �࿡ ���� �μ���ȣ�� �μ� �̸��� CURSOR�� ����
--FETCH, FETCH�� ����� Ȯ��;

SET SERVEROUTPUT ON;
DECLARE
	v_deptno dept.deptno%type;
	v_dname dept.dname%type;
	
	CURSOR dept_cursor IS
		SELECT deptno, dname
		FROM dept;
BEGIN
	OPEN dept_cursor;
	
	FETCH dept_cursor INTO v_deptno, v_dname;
	DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
	
	FETCH dept_cursor INTO v_deptno, v_dname;
	DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
	
	FETCH dept_cursor INTO v_deptno, v_dname;
	DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
	
	FETCH dept_cursor INTO v_deptno, v_dname;
	DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);

END;
/

--LOOP�� �ɾ �ϱ�

SET SERVEROUTPUT ON;
DECLARE
	v_deptno dept.deptno%type;
	v_dname dept.dname%type;
	
	CURSOR dept_cursor IS
		SELECT deptno, dname
		FROM dept;
BEGIN
	OPEN dept_cursor;
	
	LOOP 
		
		FETCH dept_cursor INTO v_deptno, v_dname;
		EXIT WHEN dept_cursor%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
		
	END LOOP;	

END;
/

--cursor�� ���� �ݴ� ������ �ټ� ������ ������.
--cursor�� �Ϲ������� Loop�� �Բ� ����ϴ� ��찡 ����
-->����� Ŀ���� FOR LOOP���� ����� �� �ְ� �� �������� ����.

--List<String> userNameList = new ArrayList<String>();
--userNameList.add("brown");
--userNameList.add("cony");
--userNameList.add("sally");
--
--�Ϲ� for
--for(int i = 0; i <  userNameList.size(); i++){
--	String userName = userNameList.get(i);
--}
--
--���� for
--for(String userName : userNameList){
--	userName���� ���...

--FOR record_name(������ ������ ���� �����̸�/���� �������) IS Ŀ���̸� LOOP
--	record_name.�÷���
--END LOOP;	

DECLARE
	v_deptno dept.deptno%TYPE;
	v_dname dept.dname%TYPE;
	
	Cursor dept_cursor IS
		SELECT deptno, dname
		FROM dept;
BEGIN
	FOR rec IN dept_cursor LOOP
		DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
	END LOOP;
END;
/



--���ڰ� �ִ� ����� Ŀ��
--���� Ŀ�� ������
--	CURSOR Ŀ���̸� IS
--	��������;
--���ڰ� �ִ� Ŀ�� ������
--	cursorĿ���̸�(�λ�1 ����1Ÿ��...)IS
--		��������
--		(Ŀ�� ����ÿ� �ۼ��� ���ڸ� ������������ ����� �� �ִ�)

--�������̽��� ��ü�� ������ �� ���� ��?
--FOR LOOP���� Ŀ���� �ζ��� ���·� �ۼ�
--FOR ���ڵ� �̸� IN Ŀ���̸�
--> FOR ���ڵ� �̸� IN (��������);

DECLARE
BEGIN
	FOR rec IN (SELECT deptno, dname FROM dept)LOOP
		DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
	END LOOP;
END;
/

SELECt *
FROM dt;

---------------Pro_3
DECLARE
BEGIN
	FOR rec IN (SELECT dt FROM dt)LOOP
		DBMS_OUTPUT.PUT_LINE(rec.dt || ' : ' || rec.dt);
	END LOOP;
END;
/

DECLARE
	i NUMBER := 0;
BEGIN
	FOR rec IN (SELECT dt FROM dt)LOOP
		EXIT WHEN i > 8;
		DBMS_OUTPUT.PUT_LINE(rec.dt || ' : ' || i);
		i := i + 1;
	END LOOP;
END;
/

SELECT ROWNUM, dt.*
FROm dt;


declare
	v_sum NUMBER := 0;
	v_avg NUMBER := 0;
begin
 for rec in (select dt, nvl(lead(dt)over(order by dt desc),'2020/01/30') dt1 from dt) loop
        dbms_output.put_line(rec.dt || ' - ' || rec.dt1 ||' : ' || (rec.dt - rec.dt1));
		v_sum := v_sum + (rec.dt-rec.dt1);
    end loop;
		v_avg := v_sum/7;
	    dbms_output.put_line('������ ���� = ' || v_sum);
		dbms_output.put_line('������ ����� = ' || v_avg );
end;
/

--SEM
CREATE OR REPLACE PROCEDURE avgdt IS
	TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
	v_dt_tab dt_tab;
	
	v_diff_sum NUMBER := 0;
BEGIN
	SELECT * BULK COLLECT INTO v_dt_tab
	FROM dt;
	
	--DT ���̺��� 8���� �ִµ� 1-7�� ������ LOOP�� ����
	FOR i IN 1..v_dt_tab.COUNT-1 LOOP
		v_diff_sum := v_diff_sum + v_dt_tab(i).dt - v_dt_tab(i+1).dt;
	END LOOP;
		DBMS_OUTPUT.PUT_LINE('������ ��հ� = '||v_diff_sum/(v_dt_tab.COUNT-1));
END;
/

EXEC AVGDT;
SELECT avg(dt_sum/7)dt_avg
FROM(
	SELECT sum(dt-dt1)dt_sum
	FROM(
		select dt, nvl(lead(dt)over(order by dt desc),'2020/01/30') dt1
		from dt)
);

-------sem
SELECT AVG(diff)
FROM (SELECT dt-Lead(dt)OVER(ORDER BY dt DESC)diff
	  FROM dt);
	
--MAx, MIN, COUNT

SELECT (MAX(dt) - MIN(dt))/(COUNT(dt)-1) avg
FROM dt;


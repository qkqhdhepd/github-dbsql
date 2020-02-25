SELECT *
FROM cycle;
--1�� ���� 100�� ��ǰ�� �����ϳ� 1�� ����
--2020�� 2���� ���� �Ͻ����� ����
--1.2020�� 2���� �����Ͽ� ���� �Ͻ��� ����
--2. 100 	 2  	1������ ���� 4���� ������ �����Ǿ�� �Ѵ�.
--20200203
--20200210
--20200217
--20200224

select '202002'
from dual
connect by level <= 29 ;

select to_date('202002'||'01','yyyymmdd')
from dual
connect by level <= 29 ;


select to_date('202002'||'01','yyyymmdd') + (level-1)
from dual
connect by level <= to_char(last_day(to_date('202002'||'01','yyyymmdd')),'dd');


select to_char(TO_DATE('202002'||'01','yyyymmdd') + (level-1),'YYYYMMDD') dt,
       to_char(TO_DATE('202002'||'01','yyyymmdd') + (level-1), 'D'))d,
from dual
connect by level <= to_char(last_day(to_date('202002'||'01','yyyymmdd')),'dd');


------------------------------------------------------------
--pro_4 1/2
create or replace procedure create_daily_sales(p_yyyymm in daily.dt%type) is
    TYPE cal_row IS RECORD(
        dt varchar2(8),
        d NUMBER);
    TYPE cal_tab IS TABLE OF cal_row INDEX BY BINARY_INTEGER;
    v_cal_tab cal_tab;
begin
    select to_char(to_date(p_yyyymm ||'01','yyyymmdd') + (level-1), 'yyyymmdd') dt,
           to_char(to_date ( p_yyyymm ||'01','yyyymmdd') + (level-1), 'D')d
           bulk collect into v_cal_tab
    from dual       
    connect by level <= to_char(last_day(to_date(p_yyyymm||'01','yyyymmdd')),'dd');
    
	--�Ͻ��� �����͸� �����ϱ� ���� ������ ������ �����͸� ����
	DELETE daily
	WHERE dt like p_yyyymm || '%';
	
	
    FOR daily_row IN (SELECT * FROM cycle) LOOP
        DBMS_OUTPUT.PUT_LINE(daily_row.cid || ' ' ||daily_row.pid || ' ' || daily_row.day || ' ' || daily_row.cnt);
        for i in 1..v_cal_tab.count loop
		
			IF daily_row.day = v_cal_tab(i).d THEN
			INSERT INTO daily VALUES (daily_row.cid, daily_row.pid, v_cal_tab(i).dt,daily_row.cnt);
            dbms_output.put_line(v_cal_tab(i).dt || ' ' || v_cal_tab(i).d);
			END IF;
        end loop;     
    END LOOP;   
	
	commit;
end;
/

set serveroutput on;
SELECT *
FROM daily;
exec create_daily_sales('202002');
SELECT *
FROM daily;
SELECT *
FROM cycle;

SELECT *
FROM daily
WHERE dt LIKE '202002%';

DELETE daily
WHERE dt like '202002%';

--Create_daily_sales ���ν������� �Ǻ��� insert �ϴ� ������ INSERT SELECT ����, ONE_QUERY���·�
--���� �Ͽ� �ӵ��� ����;

DELETE daily
WHERE dt LIKE '202002%';


SELECT cycle.cid,cycle.pid,cal.dt,cycle.cnt
FROM cycle,
	(SELECT TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1),'YYYYMMDD')dt,
		   TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1),'D')d
	FROM dual
	CONNECT BY LEVEL <=TO_CHAR(LAST_DAY(TO_DATE('202002','YYYYMM')),'DD'))cal
WHERE cycle.day = cal.d;



--PL/SQL ������ SELECT ����� ��� ���� : NO_DATA_FOUND;

DECLARE
	v_dname dept.dname%TYPE;
BEGIN
	SELECT dname INTO v_dname
	FROM dept
--	WHERE deptno = 70;
	
EXCEPTION
	WHEN no_data_found THEN
		DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
	WHERE too_many_rows THEN
		DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS');
END;
/


--����� ���� ���� ����
--NO_DATA_FOUND -> �츮�� �������� ����� ���ܷ� �����Ͽ� ���Ӱ� ���ܸ� ������ ����;
--(x)
DECLARE
	no_emp EXCEPTION;
	v_ename emp.ename%TYPE;
BEGIN
	SELECT ename INTO v_ename;
	FROM emp
	WHERE empno = 8000;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		RAISE no_emp;
	END;
	EXCEPTION
		WHEN no_emp THEN
			DBMS_OUTPUT.PUT_LINE('no_emp');
END;
/

--emp���̺��� ���ؼ��� �μ��̸��� �˼��� ����(�μ��̸� dept���̺� ����)
-->1.join
--	2.�������� -��Į�� �������� (SELECT )
--	3.function;
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROm emp join dept ON emp.deptno = dept.deptno;

SELECT emp.*, (SELECT dname FROM dept WHERE dept.deptno = emp.deptno)dname
FROm emp;

--�μ���ȣ�� ���ڷ� �ް� �μ����� �������ִ� �Լ� ����;
--getDeptName;
set serveroutput on;
CREATE OR REPLACE FUNCTION getDeptName(p_deptno dept.deptno%TYPE) RETURN VARCHAR2 IS
	v_dname dept.dname%TYPE;
BEGIN
	SELECT dname INTO v_dname
	FROM dept
	WHERE deptno = p_deptno;
	
	RETURN v_dname;
END;
/

select emp.*,getDeptName(emp.deptno)dname
FROM emp;


--getEmpName �Լ��� ����
--������ȣ�� ���ڷ� �ϰ�
--�ش� ������ �̸��� �������ִ� �Լ��� �����غ�����.
--SMITH;
--SELECT getEmpname(7369)
--FROM dual;

set serveroutput on;
CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE) RETURN VARCHAR2 IS
	v_ename emp.ename%TYPE;
BEGIN
	SELECT ename INTO v_ename
	FROM emp
	WHERE empno = p_empno;
	
	RETURN v_ename;
END;
/

select emp.*,getEmpName(emp.empno)ename
FROM emp
WHERE empno = 7369;

SELECT LPAD(' ', (LEVEL -1)*4) || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--�ǽ� SEM-

create or replace function getpadding(p_lv number,p_indent number,p_padding varchar2) return varchar2 is
    v_padding varchar(200);
begin
    select lpad(' ' , (p_lv-1)*p_indent,p_padding)into v_padding
    from dual;
    
    return v_padding;
end;
/

select '*' || lpad(' ',(:lv-1)*4) ||'*'
from dual;

select getPadding(level,10,'-')||deptnm
from dept_h
start with deptcd='dept0'
connect by prior deptcd=p_deptcd;


SELECT *
FROM TABLE(dbms_xplan.display)

--PACKAGE��
--PACKAGE - ������ PL/SQL ����� �����ִ� ����Ŭ ��ü
--�����
--��ü(������)�� ����
--getempname, getdeptname => names ��Ű���� ��ƺ���;

SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE names AS
	FUNCTION getEmpname(p_empno emp.empno%TYPE) RETURN VARCHAR2;
	FUNCTION getdeptname(p_deptno dept.deptno%TYPE) RETURN VARCHAR2;
end names;
/

--��Ű�� �ٵ�
CREATE or replace package body names as
	FUNCTION getDeptName(p_deptno dept.deptno%TYPE) RETURN VARCHAR2 AS
	v_dname dept.dname%TYPE;
BEGIN
	SELECT dname INTO v_dname
	FROM dept
	WHERE deptno = p_deptno;
	RETURN v_dname;
	END;
	
	FUNCTION getempName(p_empno emp.empno%TYPE) RETURN VARCHAR2 AS
	v_ename emp.ename%TYPE;
	
	BEGIN
		SELECT ename INTO v_ename
		FROM emp
		WHERE empno = p_empno;
		RETURN v_ename;
	END;
END;
/

SELECT emp.*, names.getdeptname(emp.deptno)dname
FROM emp;

--���� ��Ű�� �׽�Ʈ
SELECT names.getempname(empno),
names.getdeptname(deptno)
FROM emp;
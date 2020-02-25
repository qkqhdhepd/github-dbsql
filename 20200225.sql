SELECT *
FROM cycle;
--1번 고객이 100번 제품을 월요일날 1개 애음
--2020년 2월에 대한 일실적을 생성
--1.2020년 2월의 월요일에 대해 일실적 생성
--2. 100 	 2  	1한행이 다음 4개의 행으로 생성되어야 한다.
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
    
	--일시적 데이터를 생성하기 전에 기존에 생성된 데이터를 삭제
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

--Create_daily_sales 프로시져에서 건별로 insert 하던 로직은 INSERT SELECT 구문, ONE_QUERY형태로
--변형 하여 속도를 단축;

DELETE daily
WHERE dt LIKE '202002%';


SELECT cycle.cid,cycle.pid,cal.dt,cycle.cnt
FROM cycle,
	(SELECT TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1),'YYYYMMDD')dt,
		   TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1),'D')d
	FROM dual
	CONNECT BY LEVEL <=TO_CHAR(LAST_DAY(TO_DATE('202002','YYYYMM')),'DD'))cal
WHERE cycle.day = cal.d;



--PL/SQL 에서는 SELECT 결과가 없어도 예외 : NO_DATA_FOUND;

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


--사용자 정의 예외 생성
--NO_DATA_FOUND -> 우리가 직접만든 사용자 예외로 변경하여 새롭게 예외를 던지는 예제;
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

--emp테이블을 통해서는 부서이름을 알수가 없다(부서이름 dept테이블에 존재)
-->1.join
--	2.서브쿼리 -스칼라 서브쿼리 (SELECT )
--	3.function;
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROm emp join dept ON emp.deptno = dept.deptno;

SELECT emp.*, (SELECT dname FROM dept WHERE dept.deptno = emp.deptno)dname
FROm emp;

--부서번호를 인자로 받고 부서명을 리턴해주는 함수 생성;
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


--getEmpName 함수를 생성
--직원번호를 인자로 하고
--해당 직원의 이름을 리턴해주는 함수를 생성해보세요.
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

--실습 SEM-

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

--PACKAGE란
--PACKAGE - 연관된 PL/SQL 블록을 묶어주는 오라클 객체
--선언부
--몸체(구현부)로 구성
--getempname, getdeptname => names 패키지에 담아보자;

SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE names AS
	FUNCTION getEmpname(p_empno emp.empno%TYPE) RETURN VARCHAR2;
	FUNCTION getdeptname(p_deptno dept.deptno%TYPE) RETURN VARCHAR2;
end names;
/

--패키지 바디
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

--만든 패키지 테스트
SELECT names.getempname(empno),
names.getdeptname(deptno)
FROM emp;
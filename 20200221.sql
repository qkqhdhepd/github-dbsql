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
--regisdept_test procedure 생성

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

--생성 실습 pro_3
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

--복합변수 %rowtype : 특정 테이블의 행의 모든 컬럼을 저장할 수 있는 변수
--사용 방법 : 변수명 테이블명 %rowtype;

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

--복합변수 record
--개발자가 직접 여러개의 컬럼을 관리 할 수 있는 타입을 생성하는 명령
--JAVA 비유하면 클래스를 선언하는 과정
--인스턴스를 만드는 과정은 변수선언

--문법
--type 타입이름(개발자가 지정) IS RECORD(
--	변수명 1 변수 타입,
--	변수명 2 변수 타입
--	);
--	
--변수명 타입이름;

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

--table type 테이블 타입
--점 : 스칼라 변수
--선 : %rowtype, record type
--면 : table type
--	어던 선 (%rowtype, record type)을 저장할 수 있는지
--	인덱스 타입은 무엇인지;
--DEPT 테이블의 정보를 담을 수 있는 table type을 선언
--기존에 배운 스칼라 타입, rowtype에서는 한 행의 정보를 담을 수 있었지만
--table 타입 변수를 이용하면 여러 행의 정보를 담을 수 있다.

DECLARE
	TYPE dept_tab IS TABLE OF dept%rowTYPE INDEX BY BINARY_INTEGER;
	v_dept_tab dept_tab;
BEGIN
	SELECT * BULK COLLECT INTO v_dept_tab
	FROM dept;
	--기존 스칼라 변수, record 타입을 실습시에는
	--한생만 조회 되도록 WHERE절을 통해 제한하였다.
	
	--접근방식
	--자바에서는 배열[인덱스 번호]
	--table 변수(인덱스 번호)로 접근
	DBMS_OUTPUT.PUT_LINE(v_dept_tab(1).deptno || ' ' || v_dept_tab(1).dname);
	DBMS_OUTPUT.PUT_LINE(v_dept_tab(2).deptno || ' ' || v_dept_tab(2).dname);
	DBMS_OUTPUT.PUT_LINE(v_dept_tab(3).deptno || ' ' || v_dept_tab(3).dname);
	DBMS_OUTPUT.PUT_LINE(v_dept_tab(4).deptno || ' ' || v_dept_tab(4).dname);
END;
/

--위에꺼 loop쓰기
DECLARE
	TYPE dept_tab IS TABLE OF dept%rowTYPE INDEX BY BINARY_INTEGER;
	v_dept_tab dept_tab;
BEGIN
	SELECT * BULK COLLECT INTO v_dept_tab
	FROM dept;
	--기존 스칼라 변수, record 타입을 실습시에는
	--한생만 조회 되도록 WHERE절을 통해 제한하였다.
	
	--접근방식
	--자바에서는 배열[인덱스 번호]
	--table 변수(인덱스 번호)로 접근
--	FOR(int i = 0; i < 10; i++){
--	}
	
	FOR i IN 1..v_dept_tab.count LOOP
		DBMS_OUTPUT.PUT_LINE(v_dept_tab(i).deptno || ' ' || v_dept_tab(i).dname);
	END LOOP;
	
END;
/

--조건 제어 if
--문법
--if 조건문 then
--	실행문;
--else if 조건문 then
--	실행문;
--else 
--	실행문;
--end if;

DECLARE
	p NUMBER(1) := 2;  --변수 선언과 동시에 값을 대입
BEGIN
	IF p = 1 THEN
		DBMS_OUTPUT.PUT_LINE('1입니다');
	ELSIF p = 2 THEN
		DBMS_OUTPUT.PUT_LINE('2입니다');
	ELSE
		DBMS_OUTPUT.PUT_LINE('알려지지 않았습니다.');	
	END IF;
END;
/

--CASE 구문
--1.일반 케이스 (java의 switch문과 유사)
--2.검색 케이스 (if, else if, else)

--CASE expression
--	WHEN value THEN
--		실행문;
--	WHEN value THEN
--		실행문;
--	ELSE
--		실행문;
--END CASE;

DECLARE
	p NUMBER(1) :=2;
BEGIN
	CASE p
		WHEN 1 THEN
			DBMS_OUTPUT.PUT_LINE('1입니다');
		WHEN 2 THEN
			DBMS_OUTPUT.PUT_LINE('2입니다');
		ELSE
			DBMS_OUTPUT.PUT_LINE('모르는 값입니다.');
	END CASE;
END;
/

--For LOOP 문법
--FOR 루프변수/인덱스 변수 IN [REVERSE] 시작값...종료값 LOOP
--	반복할 로직;
--END LOOP;
--
--1부터 5까지 FOR LOOP 반복문을 이용하여 숫자 출력

DECLARE
BEGIN
	FOR i IN 1..5 LOOP
		DBMS_OUTPUT.PUT_LINE(i);
	END LOOP;
END;
/

--실습 : 2-9단 까지 구구단을 출력;
DECLARE
BEGIN
	FOR i IN 2..9 LOOP
		FOR j IN 1..9 LOOP
			DBMS_OUTPUT.PUT_LINE(i || '*' || j || ' = ' || i*j);
		END LOOP;
	END LOOP;
END;
/


--while문
DECLARE
	i number := 0;
BEGIN
	FOR i <= 5 LOOP
		DBMS_OUTPUT.PUT_LINE(i);
		i := i+1;
	END LOOP;
END;
/


--LOOP문 문법 => while(true)
--LOOP
--	반복실행할 문자;
--	EXIT
--END LOOP;
--LOOP문을 사용할 때 반복하는 순서가 어떻게 되야 할지 잘 생각해보자.
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



SELECT *
FROM emp;

--1.leaf(노드(랭)가 어떤 데이터인지 확인
--2.level => 상향탐색시 그룹을 묶기 위해 필요한값
--3.leaf 노드 부터 상향 탐색, ROWNUM

SELECT LPAD(' ', (level-1)*4) || org_cd, total
FROM 
(SELECT org_cd,parent_org_cd, SUM(total)total
FROM 
	(SELECT org_cd, parent_org_cd, no_emp,
		SUM(no_emp)OVER (partition BY gno Order by rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)total
	FROM(
		SELECT org_cd,parent_org_cd,no_emp,lv,ROWNUM rn, lv+ROWNUM gno,
			no_emp / count(*)OVER(partition BY org_cd)no_emp
		FROM(
			SELECT no_emp.*,LEVEL lv,CONNECT_BY_ISLEAF leaf
			FROM no_emp
			START WITH parent_org_cd IS null
			CONNECT BY PRIOR org_cd = parent_org_cd)
		START WITH leaf = 1
		CONNECT BY PRIOR parent_org_cd = org_cd))
GROUP BY org_cd,parent_org_cd)
START WITH parent_rog_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;


------------------------------------------------------------------------------------------------------------
--백만건
--gis_dt의 컬럼에서 2020년 2월에 해당하는 날짜를 중복되지 않게 구한다. : 최대 29건의 행
--2020/02/03 =>해당 일자의 데이터가 있으면 그 한건만 보이게 해보자.
--2020/02/04
--2020/02/05
--..

--sysdate의 일시가 있는데 다 10시 20분정도 인데2020/02/29인 TO_DATE는 시간으로 보면 00시00분임 (데이터는 10시까지임)
SELECT TO_CHAR(dt,'YYYY-MM-DD') dt
FROM gis_dt
WHERE dt BETWEEN TO_DATE('2020/02/01','YYYY/MM/DD') AND TO_DATE('2020/02/29 23:59:59','YYYY/MM/DD hh24:mi:ss')
GROUP BY dt;

--1.속도를 빠르게 하는 것
--		2월의 데이터를 테이블로 정답을 만든다.
SELECT *
FROM
(SELECT TO_DATE('20200201','YYYYMMDD') + (LEVEL-1) dt
FROM dual
CONNECT BY level <=29)a
WHERE EXISTS ( SELECT 'X'
			   FROM gis_dt
			   WHERE gis_dt.dt BETWEEN dt and TO_DATE(TO_CHAR(dt,'YYYYMMDD') || '235959','YYYYMMDDHH24MISS'));



DROP INDEX idx_n_gis_dt_02;
CREATE INDEX idx_n_gis_dt_02 ON gis_dt (dt);




-----------------------------------------------------------------------
--pl/sql 코드 라인의 끝을 기술은 java와 동일하게 세미콜론을 기술한다
java : string str;
pl/sql : deptno number(2);

--pl/sql 블룩의 죵료 표시하는 문자열 /
--sql의 종료 문자열 : ;
--
--hello world 출력 ;

set serveroutput on;
declare 
    msg varchar2(50);
begin 
    msg := 'hello, world!';
    dbms_output.put_line(msg);
end;
/
    
    
--부서 테이블에서 10번 부서의 부서번호와 , 부서이름을 pl/sql 변수에 저장하고 
--변수를 출력;



declare
	v_deptno NUMBER(2);
	v_dname VARCHAR2(14);
BEGIN
	SELECT deptno, dname INTO v_deptno,v_dname
	FROM dept
	WHERE deptno = 10;
	
	
	DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
END;
/


--PL/SQL 참조타입 부서 테이블의 부서번호, 부서명을 조회하여 변수에 담는 과정
--부서 번호, 부서명의 타입은 부서 테이블에 정의가 되어있음.

--NUMBER, VARCHAR2 타입을 직접 명시하는게 아니라 해당 테이블의 컬럼의 타입을 참조하도록 변수 타입을 선언 할 수 있다
--v_deptno NUMBER(2)-=> dept.deptno%Type;


DECLARE
    v_deptno dept.deptno%type;
    v_dname dept.dname%type;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;

    DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
END;
/

--프로시져 블록 유형
-- 익명 블럭(이름이 없는 블럭)
-- 재사용이 불가능 하다(인라인뷰 VS 뷰)

--프로시져(이름이 있는 블럭)
---재사용 가능하다
--이름이 있다
--프로시져를 실행할 때 함수처럼 인자를 받을 수 있다.

--함수(이름이 있는 블럭)
--재사용이 가능하다
--이름이 있다
--프로시져와 다른 점은 리턴 값이 있다.

--프로시져 형태
--CREATE OR REPLACE PROCEDURE 프로시져이름 IS (IN param, OUT param, IN out Param)
-- 선언부 (declare절이 별도로 없다)
--	BeGIN
--	EXCEPRINT(옵션)
--END;
--/

--부서 테이블에서 10번 부서의 부서번호와 부서이름을 PL/SQL 변수에 저장하고 
--DBMS_OUTPUT.PUT_LINE 함수를 이용하여 화면에 출력하는 printdept프로시져를 생성

CREATE OR REPLACE PROCEDURE printdept IS
		v_deptno dept.deptno%type;
		v_dname dept.dname%type;

		BEGIN
			SELECT deptno, dname INTO v_deptno, v_dname
			FROM dept
			WHERE deptno = 10;
			DbmS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
		END;
	/
	
프로시져 실행 방법
exec 프로시져명(인자....);

exec printdept_LMH;

----------------------------
printdept_p 인자로 부서번호를 받아서 
해당 부서번호에 해당하는 부서이름과 지역정보를 콘솔에 출력하는 프로시져;

CREATE OR REPLACE PROCEDURE printdept_p_lmh(p_deptno IN dept.deptno%type) IS
	v_dname dept.dname%type;
	v_loc dept.loc%type;
BEGIN
	SELECT dname, loc INTO v_dname, v_loc
	FROM dept
	WHERE deptno = p_deptno;
	DbmS_OUTPUT.PUT_LINE(v_dname || ' : ' || v_loc);
END;
/

exec printdept_p_lmh(10);


	
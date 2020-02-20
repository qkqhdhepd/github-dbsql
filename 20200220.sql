SELECT *
FROM emp;

--1.leaf(���(��)�� � ���������� Ȯ��
--2.level => ����Ž���� �׷��� ���� ���� �ʿ��Ѱ�
--3.leaf ��� ���� ���� Ž��, ROWNUM

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
--�鸸��
--gis_dt�� �÷����� 2020�� 2���� �ش��ϴ� ��¥�� �ߺ����� �ʰ� ���Ѵ�. : �ִ� 29���� ��
--2020/02/03 =>�ش� ������ �����Ͱ� ������ �� �ѰǸ� ���̰� �غ���.
--2020/02/04
--2020/02/05
--..

--sysdate�� �Ͻð� �ִµ� �� 10�� 20������ �ε�2020/02/29�� TO_DATE�� �ð����� ���� 00��00���� (�����ʹ� 10�ñ�����)
SELECT TO_CHAR(dt,'YYYY-MM-DD') dt
FROM gis_dt
WHERE dt BETWEEN TO_DATE('2020/02/01','YYYY/MM/DD') AND TO_DATE('2020/02/29 23:59:59','YYYY/MM/DD hh24:mi:ss')
GROUP BY dt;

--1.�ӵ��� ������ �ϴ� ��
--		2���� �����͸� ���̺�� ������ �����.
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
--pl/sql �ڵ� ������ ���� ����� java�� �����ϰ� �����ݷ��� ����Ѵ�
java : string str;
pl/sql : deptno number(2);

--pl/sql ����� �շ� ǥ���ϴ� ���ڿ� /
--sql�� ���� ���ڿ� : ;
--
--hello world ��� ;

set serveroutput on;
declare 
    msg varchar2(50);
begin 
    msg := 'hello, world!';
    dbms_output.put_line(msg);
end;
/
    
    
--�μ� ���̺��� 10�� �μ��� �μ���ȣ�� , �μ��̸��� pl/sql ������ �����ϰ� 
--������ ���;



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


--PL/SQL ����Ÿ�� �μ� ���̺��� �μ���ȣ, �μ����� ��ȸ�Ͽ� ������ ��� ����
--�μ� ��ȣ, �μ����� Ÿ���� �μ� ���̺� ���ǰ� �Ǿ�����.

--NUMBER, VARCHAR2 Ÿ���� ���� ����ϴ°� �ƴ϶� �ش� ���̺��� �÷��� Ÿ���� �����ϵ��� ���� Ÿ���� ���� �� �� �ִ�
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

--���ν��� ��� ����
-- �͸� ��(�̸��� ���� ��)
-- ������ �Ұ��� �ϴ�(�ζ��κ� VS ��)

--���ν���(�̸��� �ִ� ��)
---���� �����ϴ�
--�̸��� �ִ�
--���ν����� ������ �� �Լ�ó�� ���ڸ� ���� �� �ִ�.

--�Լ�(�̸��� �ִ� ��)
--������ �����ϴ�
--�̸��� �ִ�
--���ν����� �ٸ� ���� ���� ���� �ִ�.

--���ν��� ����
--CREATE OR REPLACE PROCEDURE ���ν����̸� IS (IN param, OUT param, IN out Param)
-- ����� (declare���� ������ ����)
--	BeGIN
--	EXCEPRINT(�ɼ�)
--END;
--/

--�μ� ���̺��� 10�� �μ��� �μ���ȣ�� �μ��̸��� PL/SQL ������ �����ϰ� 
--DBMS_OUTPUT.PUT_LINE �Լ��� �̿��Ͽ� ȭ�鿡 ����ϴ� printdept���ν����� ����

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
	
���ν��� ���� ���
exec ���ν�����(����....);

exec printdept_LMH;

----------------------------
printdept_p ���ڷ� �μ���ȣ�� �޾Ƽ� 
�ش� �μ���ȣ�� �ش��ϴ� �μ��̸��� ���������� �ֿܼ� ����ϴ� ���ν���;

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


	
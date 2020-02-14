--20200213homework�� ���� ����
--GROUP_ad2-1 decode 2��, case
SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '�Ѱ�'
            else job
        END job,
        deptno,
        SUM(sal + NVL(comm,0))sal,
        GROUPING (job) || GROUPING(deptno)
FROM emp
GROUP BY ROLLUP (job,deptno);

SELECT DECODE(GROUPING(job) || GROUPING(deptno), '11','��',
                                                 '00',job,
                                                 '01',job)job,
       DECODE(GROUPING(job) || GROUPING(deptno), '11','��',
                                                 '00',deptno,
                                                 '01','�Ұ�')deptno,
        SUM(sal + NVL(comm,0))sal
FROM emp
GROUP BY ROLLUP (job,deptno);
--------------------------------------------------------------------

--MERGE : SELECT �ϰ��� �����Ͱ� ��ȸ�Ǹ� UPDATE
--       SELECT�ϰ��� �����Ͱ� ��ȸ���� ������ INSERT

--SELECT + UPDATE /SELECT + INSER ==> MERGE;

--REPROT GROUP FUNCTION
--1.ROLLUP
--      -GROUP BY ROLLUP (�÷�1,�÷�2)
--      -ROLLUP���� ����� �÷��� �����ʿ��� �ϳ��� ������ �÷����� SUBGROUP
--      -GROUP BY �÷�1, �÷�2
--       UNION
--       GROUP BY �÷�1
--       UNION
--       GROUP BY
--2.CUBE
--3.GROUPINT SETS

--�ǽ� GROUP_AD3
SELECT deptno, job, sum(sal)sal
FROM emp
GROUP BY ROLLUP (deptno, job);

--�ǽ� GROUP_AD4
SELECT d.dname, e.job, sum(e.sal)
FROM emp e join dept d ON e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;

--�ǽ� GROUP_AD5
SELECT DECODE(grouping(d.dname),1,'����',d.dname)dname, e.job, sum(e.sal)
FROM emp e join dept d ON e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;


SELECT DECODE(grouping(d.dname),1,'����',d.dname)dname, e.job, sum(e.sal),
GROUPING(d.dname),GROUPING(e.job)
FROM emp e join dept d ON e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;

--�ǽ� GROUP_AD(BONUS)
SELECT DECODE(GROUPING(e.job) || GROUPING(d.dname), '11','��',
                                                    '00',d.dname,
                                                    '01','�Ұ�',
                                                    '10',d.dname)dname,
      DECODE(GROUPING(e.job) || GROUPING(d.dname),  '11','��',
                                                    '00',e.job,
                                                    '01',e.job,
                                                    '10','�Ұ�')job,
       sum(e.sal)
FROM emp e join dept d ON e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;


--REPORT GROUP FUNCTION
--1.ROLLUP
--2.CUBE
--3.GROUPING SETS
--Ȱ�뵵
--3,1 >>>>>>>>>>>>>>>>CUBE

--GROUPING SETS
--������ ������� ���� �׷��� ����ڰ� ���� ����
--����� : GROUP BY GROUPING SETS(col1,col2....)
-->
--GROUP BY col1
--UNION ALL
--GROUP BY col2

--GROUP BY GROUPING SETS((col1,col2),col3,col4)
--=>
--GROUP BY col1, col2
--UNION ALL
--GROUP BY col3
--UNION ALL
--GROUP BY col4

--<<GROUPING SETS�� ��� �÷� ��� ������ ����� ������ ��ġ�� �ʴ´�>>
--<<ROLLUP�� �÷� ��� ������ ��� ������ ��ģ��.>>
--GROUP BY GROUPING SETS(col1, col2);
--GROUP BY col1
--UNION ALL
--GROUP BY col2
--GROUP BY GROUPING SETS(col1, col2);
--GROUP BY col2
--UNION ALL
--GROUP BY col1


--SELECT JOB,deptno, sum(sal)sal
--FROM emp
--GROUP BY GROUPING SETS(jobs,deptno);
--
--GROUP BY GROUPING SETS(jobs,deptno)
--==>
--GROUP BY job
--UNION ALL
--GROUP BY deptno;

SELECT job, sum(sal)sal
FROM emp
GROUP BY GROUPING SETS(job,job);

--job, deptno�� GROUP BY �� ����� mgr�� GROUP BY�� ����� 
--��ȸ�ϴ� SQL�� GROUPING SETS�� �޿��� sum(sal)�� �ۼ�

SELECT sum(sal)
FROM emp
GROUP BY job,deptno
UNION ALL
SELECT sum(sal)
FROM emp
GROUP BY mgr;

SELECT job,deptno,mgr,sum(sal)
FROM emp
GROUP BY GROUPING sets((job,deptno),mgr);
---------------------------------------------
--ppt31
--SELECT job, deptno, sum(sal+NVL(comm,0))sal
--FROm emp
--GROUP BY grouping sets(job, deptno);

--<<cube
--������ ��� �������� �÷��� ������ sub GROUP�� �����Ѵ�.
--�� ����� �÷��� ������ ��Ų��.
--EX : GROUP BY cube(col1,col2);

--(col1,col2) ->
--(null, col2) == GROUP BY col2
--(null, null) == GROUP BY ��ü
--(col1, null) == GROUP BY col1
--(col1, col2) == GROUP BY col1, col2

--���� �÷�3���� cube���� ����� ��� ���ü� �ִ� �������� ??2�� n��

SELECT job, deptno, sum(sal)sal
FROm emp
GROUP BY  CUBE(job, deptno);


--ȥ��--����
SELECT job, deptno, mgr, SUM(sal)sal
FROM emp
GROUP BY job, rollup(deptno),cube(mgr);
--GROUP BY job, deptno, mgr           == GROUP BY job, deptno, mgr
--GROUP BY job, deptno, null          == GROUP BY job, deptno
--GROUP BY job, null, mgr             == GROUP BY job, mgr
--GROUP BY job, null, null            == GROUP BY job


--�������� update
--1.emp_test ���̺� drop
--2.emp ���̺��� �̿��ؼ� emp_test���̺����(��� �࿡ ���� ctas)
--3.emp_test���̺� dname VARCHAR2(14)�÷��߰�
--4.emp_test.dname �÷��� dept ���̺��� �̿��ؼ� �μ����� ������Ʈ

DROP TABLE emp_test;
CREATE TABLE emp_test AS
SELECT *
FROM emp;
ALTER TABLE emp_test ADD(dname VARCHAR2(14));

SELECT *
FROm emp_test;

UPDATE emp_test SET dname = (SELECT dname
                             FROM dept
                             WHERE dept.deptno = emp_test.deptno);
SELECT *
FROM emp_test;

commit;

SELECT *
FROM emp_test;

ALTER TABLE emp_test ADD(empcnt number(4));
rollback;

DROP TABLE dept_test;
CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD(empcnt number(4));


UPDATE dept_test SET empcnt = (SELECT count(*)cnt
                               FROM emp
                               WHERE deptno = dept_test.deptno
                               GROUP BY deptno);
update dept_test set empcnt = NVL((SELECT count(*)cnt
                                   FROM emp
                                   WHERE deptno = 40
                                   GROUP BY deptno),0);
SELECt *
FROM dept_test;
rollback;
SELECT *
FROM emp;



--sub a2
--dept_test���̺� �ִ� �μ��߿� ������ ������ ���� �μ� ������ ����
--dept_test.empcnt�÷��� ������� �ʰ�
--emp���̺��� �̿��Ͽ� ����
INSERT INTO dept_test VALUES(99,'it1','daejein',0);
INSERT INTO dept_test VALUES(98,'it2','daejein',0);
---------------------------------------------------------------
--������ ������ ���� �μ� ���� ��ȸ
--������ �ִ� ����?
--10�� �μ��� ���� �ִ� ����?
(SELECT *
FROM dept_test
WHERE empcnt IN(SELECT empcnt
              FROM dept_test
              WHERE deptno = 10));
SELECT count(*)
FROm emp
WHERE deptno = 10;

SELECT *
FROM dept_test
WHERE 0 < (SELECT COUNT(*)
            FROM emp
            WHERE deptno = deptno_test.deptno);

DELETE dept_test
WHERE 0 = (SELECT count(*)
            FROM emp
            WHERE deptno = dept_test.deptno);

SELECT DECODE((SELECT *
                FROM dept_test
                WHERE empcnt IN(SELECT empcnt
                FROM dept_test
                WHERE deptno = 10),null,'������ ����','������ �ִ�')
FROM dept_test;
-------------------------------------------------------------------------

SELECT*
FROM emp_test
WHERE deptno = 10;

SELECT *
FROM emp_test;

--�μ���ȣ�� 10�� ������� �ڽ��� �μ��� �޿���պ��� ���� ��� 200�� ����
update emp_test set sal =(SELECT (sal+200)sal
                            FROM emp_test
                            WHERE sal <(SELECT ROUND(avg(sal),2)
                                        FROM emp_test
                                        WHERE deptno = 10)
                            AND deptno = 10);
                            
                            SELECT (sal+200)sal
                            FROM emp_test
                            WHERE sal <(SELECT ROUND(avg(sal),2)
                                        FROM emp_test
                                        WHERE deptno = 10)
                            AND deptno = 10;

SELECT *
FROM emp_test
WHERE sal < (SELECT deptno, ROUND(avg (sal),2)
            FROM emp_test
            GROUP BY deptno)
GROUP BY deptno;

---------------sem-----------------------------------------------
rollback;

SELECT *
FROm emp_test;

7369	SMITH	CLERK	7902	1980/12/17	1000		20
7499	ALLEN	SALESMAN	7698	1981/02/20	1600	300	30
7521	WARD	SALESMAN	7698	1981/02/22	1450	500	30

UPDATE emp_test a SET sal = sal + 200
WHERE sal < (SELECT AVG(sal)
             FROM emp_test b
             WHERE a.deptno = b.deptno);

SELECT *
FROM emp_test;
SELECT AVG(sal)
FROM emp_test b
GROUP BY deptno;
-----------------------------------------------------------------
1.sal �߰�
2.dept - empcnt
-------------------------

--With��
--�ϳ��� �������� �ݺ��Ǵ� subquery�� ���� ��
--�ش� subquery�� ������ �����Ͽ� ����
--
--Main������ ����� �� with������ ���� ���� �޸𸮿�  �ӻ������� ����
---->main������ ���� �Ǹ� �޸� ����
--
--subquery �ۼ��ÿ��� �ش� subquery�� ����� ��ȸ�ϱ� ���ؼ� I/O�ݺ������� �Ͼ����
--
--with���� ���� �����ϸ� �ѹ��� suvquery�� ����ǰ� �� ����� �޸𸮿� ������ ���� ����
--
--��, �ϳ��� �������� ���̶� subquery�� �ݺ������� �����°Ŵ� �߸� �ۼ��� sql�� Ȯ���� ����
--
--with��������̸� as(
--    ��������
--)
--SELECT *
--FROM ��������̸�;

--������ �μ��� �޿� ����� ��ȸ�ϴ� ��������� with���� ���� ����
with sal_avg_dept AS(
    SELECT deptno, ROUND(avg(sal),2)sal
    FROM emp
    GROUP BY deptno),
    dept_empcnt AS(
    SELECT deptno, count(*) empcnt
    fROM emp
    GROUP BY deptno)
SELECT *
FROm sal_avg_dept a, dept_empcnt b
WHERE a.deptno = b.deptno;



commit;
rollback;

--with���� �̿��� �׽�Ʈ ���̺� �ۼ�
WITH temp AS(
    SELECT SYSDATE -1 FROM dual UNION all
    SELECT SYSDATE -2 FROM dual UNION all
    SELECT SYSDATE -3 FROM dual)
SELECT *
FROM temp;

--�ٸ������� ������ ���� �ַ� with���� �̿��ؼ� �����ش�.
SELECT *
FROM (
    SELECT SYSDATE -1 FROM dual UNION all
    SELECT SYSDATE -2 FROM dual UNION all
    SELECT SYSDATE -3 FROM dual);
    

--�޷¸����
--connect by level <(=)����
--�ش� ���̺��� ���� ���� ��ŭ �����ϰ�, ������ ���� �����ϱ� ���ؼ� LEVEL�� �ο�
--LEVEL�� 1���� ����

SELECT dummy, level
FROM dual
CONNECT BY LEVEL <= 10;

SELECT dept.*,level
FROM dept
CONNECT BY LEVEL <=5 ;


--2020�� 2���� �޷��� ����
:dt = 202002,202003

--�޷�
--��   ��   ȭ   ��   ��   ��   ��
select to_date('202002','yyyymm')  + (level-1),
       to_char(to_date('202002','yyyymm')  + (level-1),'d'),
       decode (to_char(to_date('202002','yyyymm')  + (level-1),'d'),
                1,to_date('202002','yyyymm')  + (level-1)) s,
        decode (to_char(to_date('202002','yyyymm')  + (level-1),'d'),
                2,to_date('202002','yyyymm')  + (level-1)) m,                
        decode (to_char(to_date('202002','yyyymm')  + (level-1),'d'),
                3,to_date('202002','yyyymm')  + (level-1)) t,        
        decode (to_char(to_date('202002','yyyymm')  + (level-1),'d'),
                4,to_date('202002','yyyymm')  + (level-1)) w,
        decode (to_char(to_date('202002','yyyymm')  + (level-1),'d'),
                5,to_date('202002','yyyymm')  + (level-1)) t2,
        decode (to_char(to_date('202002','yyyymm')  + (level-1),'d'),
                6,to_date('202002','yyyymm')  + (level-1)) f,
        decode (to_char(to_date('202002','yyyymm')  + (level-1),'d'),
                7,to_date('202002','yyyymm')  + (level-1)) s2
from dual
connect by level <= to_char(last_day(to_Date ('202002','yyyymm')),'dd');

select to_char(last_day(to_Date ('202002','yyyymm')),'dd')
from dual;



--�������� -1
SELECT  LAST_DAY(ADD_MONTHS(TO_DATE('202002','yyyymm'),-1)) + level
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002','yyyymm')),'dd');

--level�� 1�� ���� 
SELECT  TO_DATE('202002','yyyymm') + level-1
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002','yyyymm')),'dd');

SELECT TO_CHAR(LAST_DAY(TO_DATE('202002','yyyymm')),'dd') 
FROM dual;
--20200213homework에 대한 고찰
--GROUP_ad2-1 decode 2중, case
SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '총계'
            else job
        END job,
        deptno,
        SUM(sal + NVL(comm,0))sal,
        GROUPING (job) || GROUPING(deptno)
FROM emp
GROUP BY ROLLUP (job,deptno);

SELECT DECODE(GROUPING(job) || GROUPING(deptno), '11','총',
                                                 '00',job,
                                                 '01',job)job,
       DECODE(GROUPING(job) || GROUPING(deptno), '11','계',
                                                 '00',deptno,
                                                 '01','소계')deptno,
        SUM(sal + NVL(comm,0))sal
FROM emp
GROUP BY ROLLUP (job,deptno);
--------------------------------------------------------------------

--MERGE : SELECT 하고나서 데이터가 조회되면 UPDATE
--       SELECT하고나서 데이터가 조회되지 않으면 INSERT

--SELECT + UPDATE /SELECT + INSER ==> MERGE;

--REPROT GROUP FUNCTION
--1.ROLLUP
--      -GROUP BY ROLLUP (컬럼1,컬럼2)
--      -ROLLUP절에 기술한 컬럼을 오른쪽에서 하나씩 제거한 컬럼으로 SUBGROUP
--      -GROUP BY 컬럼1, 컬럼2
--       UNION
--       GROUP BY 컬럼1
--       UNION
--       GROUP BY
--2.CUBE
--3.GROUPINT SETS

--실습 GROUP_AD3
SELECT deptno, job, sum(sal)sal
FROM emp
GROUP BY ROLLUP (deptno, job);

--실습 GROUP_AD4
SELECT d.dname, e.job, sum(e.sal)
FROM emp e join dept d ON e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;

--실습 GROUP_AD5
SELECT DECODE(grouping(d.dname),1,'총합',d.dname)dname, e.job, sum(e.sal)
FROM emp e join dept d ON e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;


SELECT DECODE(grouping(d.dname),1,'총합',d.dname)dname, e.job, sum(e.sal),
GROUPING(d.dname),GROUPING(e.job)
FROM emp e join dept d ON e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;

--실습 GROUP_AD(BONUS)
SELECT DECODE(GROUPING(e.job) || GROUPING(d.dname), '11','총',
                                                    '00',d.dname,
                                                    '01','소계',
                                                    '10',d.dname)dname,
      DECODE(GROUPING(e.job) || GROUPING(d.dname),  '11','계',
                                                    '00',e.job,
                                                    '01',e.job,
                                                    '10','소계')job,
       sum(e.sal)
FROM emp e join dept d ON e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;


--REPORT GROUP FUNCTION
--1.ROLLUP
--2.CUBE
--3.GROUPING SETS
--활용도
--3,1 >>>>>>>>>>>>>>>>CUBE

--GROUPING SETS
--순서와 관계없이 서브 그룹을 사용자가 직접 선언
--사용방법 : GROUP BY GROUPING SETS(col1,col2....)
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

--<<GROUPING SETS의 경우 컬럼 기술 순서가 결과에 영향을 미치지 않는다>>
--<<ROLLUP은 컬럼 기술 순서가 결과 영향을 미친다.>>
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

--job, deptno를 GROUP BY 한 결과와 mgr로 GROUP BY한 결과를 
--조회하는 SQL을 GROUPING SETS로 급여합 sum(sal)을 작성

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
--가능한 모든 조합으로 컬럼을 조합한 sub GROUP을 생성한다.
--단 기술한 컬럼의 순서는 지킨다.
--EX : GROUP BY cube(col1,col2);

--(col1,col2) ->
--(null, col2) == GROUP BY col2
--(null, null) == GROUP BY 전체
--(col1, null) == GROUP BY col1
--(col1, col2) == GROUP BY col1, col2

--만약 컬럼3개를 cube절에 기술한 경우 나올수 있는 가지수는 ??2의 n승

SELECT job, deptno, sum(sal)sal
FROm emp
GROUP BY  CUBE(job, deptno);


--혼종--과제
SELECT job, deptno, mgr, SUM(sal)sal
FROM emp
GROUP BY job, rollup(deptno),cube(mgr);
--GROUP BY job, deptno, mgr           == GROUP BY job, deptno, mgr
--GROUP BY job, deptno, null          == GROUP BY job, deptno
--GROUP BY job, null, mgr             == GROUP BY job, mgr
--GROUP BY job, null, null            == GROUP BY job


--서브쿼리 update
--1.emp_test 테이블 drop
--2.emp 테이블을 이용해서 emp_test테이블생성(모든 행에 대해 ctas)
--3.emp_test테이블에 dname VARCHAR2(14)컬럼추가
--4.emp_test.dname 컬럼을 dept 테이블을 이용해서 부서명을 업데이트

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
--dept_test테이블에 있는 부서중에 직원이 속하지 않은 부서 정보를 삭제
--dept_test.empcnt컬럼은 사용하지 않고
--emp테이블을 이용하여 삭제
INSERT INTO dept_test VALUES(99,'it1','daejein',0);
INSERT INTO dept_test VALUES(98,'it2','daejein',0);
---------------------------------------------------------------
--직원이 속하지 않은 부서 정보 조회
--직원이 있다 없다?
--10번 부서에 직원 있다 없다?
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
                WHERE deptno = 10),null,'직원이 없다','직원이 있다')
FROM dept_test;
-------------------------------------------------------------------------

SELECT*
FROM emp_test
WHERE deptno = 10;

SELECT *
FROM emp_test;

--부서번호가 10인 사람들이 자신의 부서의 급여평균보다 작을 경우 200을 더함
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
1.sal 추가
2.dept - empcnt
-------------------------

--With절
--하나의 쿼리에서 반복되는 subquery가 있을 때
--해당 subquery를 별도로 선언하여 재사용
--
--Main쿼리가 실행될 때 with선언한 쿼리 블럭이 메모리에  임사적으로 저장
---->main쿼리가 종료 되면 메모리 해제
--
--subquery 작성시에는 해당 subquery의 결과를 조회하기 위해서 I/O반복적으로 일어나지만
--
--with절을 통해 선언하면 한번만 suvquery가 실행되고 그 결과를 메모리에 저장해 놓고 재사용
--
--단, 하나의 쿼리에서 동이랗 subquery가 반복적으로 나오는거는 잘못 작성한 sql일 확률이 높음
--
--with쿼리블록이름 as(
--    서브쿼리
--)
--SELECT *
--FROM 쿼리블록이름;

--직원의 부서별 급여 평균을 조회하는 쿼리블록을 with절을 통해 선언
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

--with절을 이용한 테스트 테이블 작성
WITH temp AS(
    SELECT SYSDATE -1 FROM dual UNION all
    SELECT SYSDATE -2 FROM dual UNION all
    SELECT SYSDATE -3 FROM dual)
SELECT *
FROM temp;

--다른사람들과 소통할 때는 주로 with절을 이용해서 보여준다.
SELECT *
FROM (
    SELECT SYSDATE -1 FROM dual UNION all
    SELECT SYSDATE -2 FROM dual UNION all
    SELECT SYSDATE -3 FROM dual);
    

--달력만들기
--connect by level <(=)정수
--해당 테이블의 행을 정수 만큼 복제하고, 복제된 행을 구별하기 위해서 LEVEL을 부여
--LEVEL은 1부터 시작

SELECT dummy, level
FROM dual
CONNECT BY LEVEL <= 10;

SELECT dept.*,level
FROM dept
CONNECT BY LEVEL <=5 ;


--2020년 2월의 달력을 생성
:dt = 202002,202003

--달력
--일   월   화   수   목   금   토
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



--다음달의 -1
SELECT  LAST_DAY(ADD_MONTHS(TO_DATE('202002','yyyymm'),-1)) + level
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002','yyyymm')),'dd');

--level에 1을 빼서 
SELECT  TO_DATE('202002','yyyymm') + level-1
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002','yyyymm')),'dd');

SELECT TO_CHAR(LAST_DAY(TO_DATE('202002','yyyymm')),'dd') 
FROM dual;
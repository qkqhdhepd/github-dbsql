SELECT *
FROM emp;


--CROSS JOIN ==>카타션 프로덕트(cartesian product)
--조인하는 두테이블의 연결 조건에 누락되는 경우 가능한 모든 조합에 대해 연걸이 시도
--dept(4건), demp(14건)의 cross join 의 결과는 4*14 = 56건

SELECT dept.dname, emp.empno, emp.ename
FROM dept , emp
WHERE  dept.deptno = emp.deptno
AND dept.deptno = 10;











--cross join 실습 crossjoin1
--customer, product 테이블을 이용하여 고객이 애음 가능한 모든 제품의 정보를 결합하여
--다음과 같이 조회되도록 쿼리를 작성하세요.
select *
FROm customer;

SELECT *
FROM product;

SELECT cid, cnm, pid, pnm
FROM customer CROSS JOIN product;

--구하고자 하는것
--smith가 속한 부서에 속하는 직원들의 정보를 조회
--1.smith가 속하는 부서번호를 구한다.
--2.1번에서 구한 부서 번호에 속하는 직원의 정보

SELECT deptno
FROM emp
WHERE ename = 'SMITH';

--2.1번에서 구한 부서번호를 이용하여 해당 부서에 속하는 직원 정보를 조회
SELECT *
FROM emp
WHERE deptno = 20;

--SUBQUERY를 이용하여 두개의 쿼리를 동시에 하나의 SQL로 실행이 가능
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

--SUBQUERY : 쿼리안에 다른 쿼리가 들어가 있는 경우
--SUBQUERY가 사용된 위치에 따라 3가지로 분류
--SELECT 절 : SCALAR SUNQUERY
--FROM 절 : INLINE VIEW
--WHERE 절 : SUBQUERY

--서브쿼리(실습 sub1)
--평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요.
SELECT count(sal)
FROM emp
WHERE sal>(
        SELECT ROUND(AVG( sal))
        FROM emp
        );

--서브쿼리(실습 sub2)
--평균 급여보다 높은 급여를 받는 직원의 정보를 조회하세요.
SELECT *
FROM emp
WHERE sal>(
        SELECT ROUND(AVG( sal))
        FROM emp
        );


--다중행 연산자
--IN
--ANY(활용도는 다소 떨어짐):서브쿼리의 여러행중 한 행이라도 조건을 만족할 때
--ALL(활용도는 다소 떨어짐):서브쿼리의 여러행중을 모든 행에 대해 조건을 만족할 때

--서브쿼리(실습 sub3)
--SMITH, WARD사원이 속한 부서의 모든 사원정보를 조회하는 쿼리를 다음과 같이 작성하세요.
SELECT *
FROM emp
WHERE deptno IN(SELECT deptno
                FROM emp 
                WHERE ename IN('SMITH','WARD'));

--SMITH, WARD 사원의 급여보다 급여가 작은 직원을 조회(SMITH, WARD의 급여중 아무거나)
--SMITH : 800
--WARD : 1250
-- ==> 1250 보다 작은 사원
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal
                FROM emp
                WHERE ename IN('SMITH','WARD'));




--사원번호가 7902가 아니면서(AND) null이 아닌 데이터
SELECT *
FROM emp
WHERE empno NOT IN(7902,NULL);
--풀어서 쓰면
SELECT *
FROM emp
WHERE empno != 7902
AND empno != null;
--데이터 조회가 안되는데 나오게 하려면
SELECT *
FROM emp
WHERE empno != 7902
AND empno IS NOT null;

--서브쿼리
--multi column subquey(pairwise)
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499,7782));
                        
--non-pairwise는 순서쌍을 동시에 만족시키지 않는 형태로 작성
--mgr 값이 7698이거나 7839이면서
--deptno가 10이거나 30번인 직원
--MGR, DEPTNO
--(7698,10), (7698,30)
--(7839,10), (7839,30)
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr 
              FROM emp
              WHERE empno IN(7499,7782))
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN(7499,7782));

--스칼라 서브쿼리 : select 절에 기술, 1개의 ROW, 1개의 col을 조회하는 쿼리
--스칼라 서브쿼리는 MAIN쿼리의 컬럼을 사용하는게 가능하다
SELECT SYSDATE
FROm dual;

SELECT (SELECT SYSDATE FROM dual), d.*
FROM dept d;

SELECT *
FROM emp;

SELECT empno, ename, deptno,
      (SELECT dname 
       FROM dept
       WHERE deptno = emp.deptno) dname
FROM emp ;


--INLINE VIEW : FROM 절에 기술되는 서브쿼리

--MAIN쿼리의 컬럼을 subquery에서 사용하는지 유무에 따른 분류
--사용할 경우 : correlated subquery(상호 연관 쿼리), 서브쿼리만 단독으로 실행하는 것이 불가능하다.
            --실행순서가 정해져 있다 (Main => sub)
--사용하지 않을 경우 : non-correlated subquery(비상호 연관 서브쿼리),서브쿼리만 단독으로 실행하는게 가능하다.
            --실행순서가 정해져 있지 않다(Main => sub, sub ->main)

--모든 직원의 급여 평균보다 급여가 높은 사람을 조회
SELECT *
FROM emp 
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
--직원이 속한 부서의 급여 평균보다 급여가 높은 사람을 조회
SELECT *
FROM emp a
WHERE sal > (SELECt ROUND(avg(sal))
             FROM emp b
             where a.deptno = b.deptno
             GROUP BY deptno)
ORDER BY deptno;

--위의 문제를 조인을 이용해서 풀어보자
--조인테이블선정
--emp, 부서별 급여 평균(inline view)
SELECT emp.*  --ename, sal, dept_sal.*
FROM emp, (SELECT deptno, ROUND(AVG(sal)) avg_sal
            FROM emp
            GROUP BY deptno) dept_SAL
WHERE emp.deptno = dept_sal.deptno
AND emp.sal> dept_sal.avg_sal;
-------ANSI로 바꿈------
SELECT e.*
FROM emp e join (SELECT deptno, ROUND(AVG(sal)) avg_sal
                    FROM emp
                    GROUP BY deptno) d ON e.deptno = d.deptno
WHERE e.sal > d.avg_sal;


--서브쿼리(실습 sub4)
--dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음
--직원이 속하지 않은 부서를 조회하는 쿼리를 작성해보세요
INSERT INTO dept VALUES (99,'ddit','daejeon');
commit;

--DELETE dept
--WHERE deptno = 99;
--데이터를 삭제하는 쿼리(행단위)

--ROLLBACK; --트랜잭션 취소
--COMMIT;  --트랜잭션 확정
--트랜잭션은 다른사용자에게도 영향을 준다

SELECT *
FROM dept
WHERE deptno NOT IN(select deptno
                    FROM emp);
--↑↑↑↑↑↑↑↑↑↑↑ 비상호연관 서브쿼리를 사용하고 NOT IN을 사용함






--서브쿼리(실습 sub5)
--cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하지 않는 제품을 조회하는
--쿼리를 작성하세요.
SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT *
FROM product 
WHERE pid  NOT IN (SELECT pid
                   FROM cycle 
                   WHERE cid = 1);
                   
--서브쿼리(실습 sub6)
--cycle 테이블을 이용하여 cid = 2인 고객이 애음하는 제품중 cid= 1인 고객도
--애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요.
SELECT *
FROM cycle;

SELECT *
FROM cycle 
WHERE pid  IN (SELECT a.pid
                FROM cycle a join cycle b on a.pid = b.pid
                WHERE a.cid = 1
                AND b.cid = 2
                group by a.pid)
AND cid = 1
ORDER BY day DESC;


--서브쿼리(실습 sub7)
--customer, cycle, product 테이블을 이용하여 cid =2 인 고객이 애음하는 제품중 
--cid =1 인 고객도 애음하는 제품의 애음정보를 조회하고 고객명과 제품명까지 포함하는 쿼리를 작성
SELECt *
FROM customer;

SELECT *
FROM cycle;

SELECT *
FROM product;


SELECT a.cid, b.cnm, a.pid, c.pnm, a.day, a.cnt 
FROM cycle a join customer b on a.cid = b.cid join product c on a.pid = c.pid
WHERE a.pid  IN (SELECT a.pid
                FROM cycle a join cycle b on a.pid = b.pid
                WHERE a.cid = 1
                AND b.cid = 2
                group by a.pid)
AND a.cid = 1
ORDER BY a.day desc;

--서브쿼리(실습 sub8)
--아래의 쿼리를 서브쿼리를 작성하지 않고 작성하라
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'x'
                FROM emp b
                WHERE b.empno = a.mgr);
                
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--서브쿼리(실습 sub8)
--cycle, product, 테이블을 이용하여 cid = 1 인 고객이 애음하는 제품을 조회하는
--쿼리를 EXISTS 연산자를 이용하여 작성하세요.
SELECT a.pid, b.pnm
FROM cycle a join product b on a.pid = b.pid
WHERE cid = 1
group by a.pid, b.pnm;

SELECT a.pid, b.pnm
FROM cycle a, product b
WHERE EXISTS (SELECT b.pnm
                FROM product b
                WHERE cid = 1
                group by b.pnm)
AND a.pid = b.pid
group by a.pid,b.pnm;


--실습sub10(미완성)
--cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하지 않는 제품을 
--조회하는 쿼리를 EXISTS 연산자를 이용하여 작성하세요.

SELECT a.pid, b.pnm
FROM cycle a, product b
WHERE NOT EXISTS (SELECT b.pnm
                  FROM product b
                  WHERE cid = 1
                  group by b.pnm)
AND a.pid = b.pid
group by a.pid,b.pnm;
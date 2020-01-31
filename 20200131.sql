--과제
SELECT *
FROM emp;

SELECT userid, usernm, alias, reg_dt,
        CASE
            WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt,'YYYY')),2) = MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2) THEN '건강검진 대상자'
            WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt,'YYYY')),2) != MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2) THEN '건강검진 비대상자'
            ELSE '건강검진 비대상자'
        END
FROM users;

--SELECT userid, usernm, alias, reg_dt,
--       DECODE (MOD(TO_NUMBER(TO_CHAR(reg_dt,'YYYY')),2), MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2),'건강검진 대상자',
--               MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2),'건강검진 비대상자')
--FROM users;

SELECT ename, deptno
FROM emp;

SELECT deptno, dname
FROM dept;


-- JOIN 두 테이블을 연결하는 작업
--1. ANSI 문법
--2. ORACLE 문법

--natural join
--두 테이블간 컬럼명이 같을 때 해당 컬럼으로 조인
--emp, dept 테이블에는 deptno라는 컬럼이 존재
--NATURAL JOIN에 사용된 조인 컬럼(deptno)는 한정자(ex : 테이블명, 테이블 별칭)을 사용하지 않고
--컬럼명만 기술한다 (dept.detpno ==>detpno)
SELECT ename, deptno, dname
FROM emp NATURAL JOIN dept ;

SELECT e.ename, e.empno, d.dname, deptno
FROM emp e NATURAL JOIN dept d;

--ORACLE JOIN
--FROM 절에 조인할 테이블 목록을 ,로 구분하여 나열한다
--조인할 테이블의 연결 조건을 WHERE절에 기술한다.
--emp, dept 테이블에 존재하는 deptno컬럼이 같을 때 조인

SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--Ansi : join with using
--조인하려는 두개의 테이블에 이름이 같은 컬럼이 두개이지만 하나의 컬럼으로만 조인을 하자고 할때 조인하려는 기준 컬럼을  기술
--emp, dept, 테이블의 공통 컬럼 : deptno;

--JOin with using을 ORACLE 로 표현하면
SELECT e. ename, d. dname, e.deptno
FROM emp e , dept d
WHERE e.deptno = d.deptno;

--ANSI : JOIN WITH ON
--조인 하려고 하는 테이블의 컬럼의 이름이 서로 다를 때
SELECT e. ename, d. dname, e.deptno
FROM emp e JOIN dept d on e.deptno = d.deptno;

--SELF JOIN : 같은 테이블간의 조인;
--예 : emp테이블에서 관리되는 사원의 관리자 사번을 이용하여 관리자 이름으로 조회할때
SELECT *
FROM emp;

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e join emp m on e.mgr = m.empno;

--위의 조인문을 오라클 문법으로 작성;
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

--equal 조인 : =
--non-equal조인 : !=, >, <, BTWEEN AND


--emp에는 sal은 있지만 등급은 없다
--사원의 급여 정보와 급여 등급 테이블을 이용하여 해당사원의 급여 등급을 구해보자.
--두 테이블은 조건이 (equals)가 아니기 때문에 emp테이블에서 sal이 salgrade의 losal과 hisal에
--포함된다는 것을 이용하여 BETWEEN을 활용하여 조인을 함
SELECT ename, sal
FROM emp;

SELECT *
FROM salgrade;
--<오라클 문법으로>
SELECT e.ename, e.sal, s.losal, s.hisal, s.grade
FROM emp e , salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;
--<안시 문법으로>
SELECT e.ename, e.sal, s.losal, s.hisal, s.grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;

--join 0 
--emp, dept테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하라
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON e.deptno = d.deptno
ORDER BY d.dname;

--join 0_1
--emp, dept테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
--(부서번호가 10,30인 데이터만 조회)
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE e.deptno IN(10,30);

--join 0_2
--emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
--(급여가 2500초과)
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE e.sal >2500
ORDER BY d.dname;

--join 0_3
--emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
--(급여 2500초과, 사번이 7600보다 큰 직원)
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE e.sal >2500 AND e.empno > 7600;

--join 0_4
--emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
--(급여 2500초과, 사번이 7600보다 크고 부서명이 RESEARCH인 부서에 속한 직원)
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE e.sal >2500 AND e.empno > 7600 AND d.dname = 'RESEARCH';


--eXERD 
--prod : prod_LGU
--lPROD : lprod_GU
--join1
--erd다이어그램을 참고하여 prod 테이블과 lprod테이블을 조인하여 다음과 같은 결과가 나오는 쿼리를 작성하세요
SELECT *
FROM prod;

SELECT *
FROM lprod;

SELECT p.prod_lgu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p JOIN lprod l on p.prod_lgu = l.lprod_gu
ORDER BY p.prod_lgu;

--join 2
--erd다이어그램을 참고하여 buyer, prod 테이블을 조인하여 buyer별 담당하는 제품 정보를
--다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
SELECT *
FROM buyer;

SELECT *
FROM prod;

SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM buyer b JOIN prod p on b.buyer_lgu = p.prod_lgu
ORDER BY b.buyer_id;

--join 3
--erd다이어그램을 참고하여 member, cart,prod 테이블을 조인하여 회원별 장바구니에 담은 제품 정보를
--다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
SELECT *
FROM member;

SELECT *
FROM cart;

SELECT *
FROM prod;

SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM MEMBER m, cart c, prod p
WHERE m.mem_id = c.cart_member AND c.cart_prod = p.prod_id
ORDER by mem_id;

--안시로 조인하기
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM member m join cart c on m.mem_id = c.cart_member join prod p on c.cart_prod = p.prod_id
ORDER by mem_id;


--join 4
--erd다이어그램을 참고하여 customer, cycle 테이블을 조인하여 고객별 애음제품, 애음요일, 개수를
--다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
--(고객명이 brown, sally인 고객만 조회),(정렬과 관계없이 값이 맞으면 정답)
SELECT *
FROM customer;

SELECT *
FROM cycle;

SELECT a.cid, a.cnm, b.pid, b.day, b.cnt 
FROM customer a join cycle b on a.cid = b.cid; 

--join 5
--erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
--고객별 애음 제품, 애음요일, 개수, 제품명을 다음과 같은 결과가 나오도록
--쿼리를 작성해보세요(고객명이 brown, sally인 고객만 조회)

SELECT a.cid, a.cnm, b.pid,c.pnm, b.day, b.cnt
FROM customer a, cycle b, product c
WHERE a.cid = b.cid AND b.pid = c.pid;
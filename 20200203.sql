SELECT *
FROM emp;

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
FROM customer a join cycle b on a.cid = b.cid
WHERE a.cnm IN ('brown','sally');
--join 5
--erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
--고객별 애음 제품, 애음요일, 개수, 제품명을 다음과 같은 결과가 나오도록
--쿼리를 작성해보세요(고객명이 brown, sally인 고객만 조회)

SELECT a.cid, a.cnm, b.pid,c.pnm, b.day, b.cnt
FROM customer a, cycle b, product c
WHERE a.cid = b.cid AND b.pid = c.pid
AND a.cnm IN ('brown','sally')
ORDER BY a.cnm;

--join 6
--erd다이어그램을 참고하여 customer,cycle, product 테이블을 조인하여 
--애음요일과 관계없이 고객별 애음 제품별, 개수의 합과 제품명을 다음과 같은
--결과가 나오도록 쿼리를 작성해보세요.
SELECT *
FROM customer;

SELECT *
FROM cycle
;

SELECT *
FROM product;

SELECT a.cid, a. cnm, c.pid, c.pnm, sum(b.cnt)
FROM customer a join cycle b on a.cid = b.cid 
join product c on b.pid = c.pid
GROUP BY a.cid, a. cnm, c.pid, c.pnm;

--join 7
--erd 다이어그램을 참고하여 cycle, product테이블을 이용하여
--제품별, 개수의 합과, 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
SELECT a.pid, b.pnm, sum(a.cnt)
FROM cycle a join product b on a.pid = b.pid
GROUP BY a.pid, b.pnm;

--join 8
--erd다이어그램을 참고하여 countries, regions테이블을 이용하여 
--지역별 소속 국가를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
--(지역은 유럽만 한정)
SELECT *
FROM countries;

SELECT *
FROM regions;

SELECT b.region_id, b.region_name, a.country_name
FROM countries a join regions b on a.region_id = b.region_id
WHERE region_name = 'Europe';

--join 9
SELECT *
FROM countries;

SELECT *
FROM regions;

SELECT *
FROM locations;

SELECT a.region_id, a.region_name, b.country_name, c.city
FROM regions a join countries b on a.region_id = b.region_id
join locations c on b.country_id = c.country_id
WHERE region_name = 'Europe';

--join10
SELECT a.region_id, a.region_name, c.city, department_name
FROM regions a join countries b on a.region_id = b.region_id
join locations c on b.country_id = c.country_id
join departments d on c.location_id = d.location_id
WHERE region_name = 'Europe';

--join11
SELECT a.region_id, a.region_name, c.city, d.department_name, e.first_name
FROM regions a join countries b on a.region_id = b.region_id
join locations c on b.country_id = c.country_id
join departments d on c.location_id = d.location_id
join employees e on d.department_id = e.department_id
WHERE region_name = 'Europe';

--join 12
SELECT *
FROM employees;

SELECT *
FROm jobs;

SELECT e.employee_id, concat(e.first_name,e.last_name), j.job_id, j.job_title
FROm employees e join jobs j on e.job_id = j.job_id;

--join13
SELECT *
FROm employees;

SELECT *
FROm jobs;

SELECT e.manager_id mgr_id, concat(m.first_name,m.last_name)mgr_name, e.employee_id, concat(e.first_name,e.last_name)name, j.job_id
FROm employees e join employees m on e.manager_id = m. employee_id
join jobs j on e.job_id = j.job_id;
--과제하세요.(8~13)


SELECT concat(first_name,last_name)
FROm employees;





--OUTER join
--두테이블을 조인할 떄 연결 조건을 만족 시키지 못하는 데이터를 기준으로 지정한 테이블의 데이터만이라도 조회 되게끔 하는 조인 방식;

--연결조건 : e.mgr = m.empno : KING 의 mgr NULL이기 때문에 조인에 실패한다.
--emp 테이블의 데이터는 총 14건이지만 아래와 같은 쿼리에서는 결과가 13건이 된다. (1건이 조인실패)
SELECT e.empno, e.ename, e.mgr, m.ename
FROm emp e, emp m
WHERE e. mgr = m.empno;

--ANSY LEFT outer
1조인에 실패하더라도 조회가될 테이블을 선정(매니저 정보가 없어도 사원정보는 나오게끔);

SELECT e.empno, e.ename, e.mgr, m.ename
FROm emp e left outer join emp m on e.mgr = m.empno;

--Right outer 로 변경
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT outer join emp e on e.mgr = m.empno;

--ORACLE OUTER JOIN
--13건이 나옴(데이터가 없는 쪽의 테이블 컬럼 뒤에 (+)기호를 붙여준다.
SELECT e.empno, e.ename, e.mgr, m.ename
FROm emp e, emp m 
WHERE e.mgr = m.empno(+);  

--위의 sql을 ansi sql(outer join)으로 변경해보세요
--매니저의 부서번호가 10번인 직원만 조회;
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno AND m.deptno = 10;

--WHERE 절에 조건이 들어가서 잘못된 조회결과를 가져옴(위와 차이가 있음)
--아래의 LEFT OUTER 조인은 실질적으로 OUTER조인이 아니다
--아래 INNER 조인과 결과가 동일하다.
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno
WHERE m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m ON e.mgr = m.empno
WHERE m.deptno = 10;

--아웃터가 잘된 안시 문법을 오라클 outer join으로

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno 
AND m.deptno = 10;

--1.이것은 잘못된 것이다.
--오라클 outer join
--오라클 outer join시 기준 테이블의 반대편 테이블의 모든 컬럼에 (+)를 붙여야
--정상적인 outer join으로 동작한다.
--한 컬럼이라도 (+)를 누락하면 INNER 조인으로 동작;

--아래의 oracle outer조인은 INNER조인으로 동작 : m.deptno 컬럼에 (+)붙지 않음
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

--최종 아웃터를 할려면 
--오라클 경우에는 아우터를 할떄 WHERE절과 and절에 둘다 (+)를 붙이고
--안시같은 경우에는 where절에 쓰지 말고 fROM 절에 기술해야 한다.(조건을)

--right outer join)
--사원 - 매니저간 right outer join;\
SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m on (e.mgr = m.empno);

--Full outer : left outer + right outer = 중복제거
--LEFT OUTER : 14건, RIGHT OUTER : 21건
SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROm emp e FULL OUTER JOIN emp m on (e.mgr = m.empno);

--uter join 실습 outerjoin 1
--buyprod 테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목 밖에 없다.
--모든 품목이 나올수 있도록 쿼리를 작성 해보세요.
--oracle outer에서는 (+)기호를 이용하여 FULL OUTER 문법을 지원하지 않는다.
SELECT *
FROM prod;

SELECT *
FROm buyprod;

SELECT b.buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM prod a left outer join buyprod b on a.prod_id = b.buy_prod and b.buy_date = TO_DATE('20050125','YYYYMMDD');


--outer join 실습 outerjoin 2
--outerjoin 1에서 작업을 시작하세요. buy_date 컬럼이 null인 항목이 안나오도록
--다음처럼 데이터를 채워지도록 쿼리를 작성 하세요.
SELECT nvl(b.buy_date,'2005/01/25')buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM prod a left outer join buyprod b on a.prod_id = b.buy_prod and b.buy_date = TO_DATE('20050125','YYYYMMDD');

--outer join 실습 outerjoin 3
--outerjoin2에서 작업을 시작하세요. buy_qty컬럼이 null일 경우 0으로 보이도록 쿼리를 수정하세요.
SELECT nvl(b.buy_date,'2005/01/25'), b.buy_prod, a.prod_id, a.prod_name, nvl(b.buy_qty,0)
FROm prod a left outer join buyprod b on a.prod_id = b.buy_prod and b.buy_date = TO_DATE('20050125','YYYYMMDD');

--outer join 실습 outerjoin 4
--cycle, product테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고, 애음하지 않는 제품도 다음과
--같이 조회되도록 쿼리를 작성하세요
--(고객은 cid =1인 고객만 나오도록 제한, null처리)
SELECT *
FROM cycle;

SELECt *
FROM product;

SELECT a.pid, b.pnm, a.cid, a.day, a.cnt
FROM cycle a left outer join product b on a.pid = b.pid
WHERE a.cid = 1;

--outer join 실습 outerjoin 5
--cycle, product, customer 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고, 
--애음하지 않는 제품도 다음과 같이 조회되며 고객이름을 포함하여 쿼리를 작성하세요.
--(고객은 cid = 1인 고객만 나오도록 제한, null처리)
SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT *
FROM customer;

SELECT a.pid, b.pnm, a.cid, c.cnm, a.day, a.cnt
FROM cycle a left join product b on a.pid = b.pid
join customer c on a.cid = c.cid and a.cid = 1;


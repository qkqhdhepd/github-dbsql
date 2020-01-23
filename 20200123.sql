--조건에 맞는 데이터 조회하기 (WHERE절 2)
--emp테이블에서 입사 일자가 1982년 1월 1일 이후 부터 1983년 1월 1일 이전인 사원의 ename, hiredate 데이터를
-- 조회하는 쿼리를 작성하시오.
--WHERE절에 기술하는 조건에 순서는 조회 결과에 영향을 미치지 않는다.
--SQL은 집합의 개념을 갖고 있다.
--집합 : 키가 185cm이상이고 몸무게가 70kg이상인 사람들의 모임
--    ->몸무게가 70kg인 사람들과 키가 185cm인 사람들의 모임
--      잘생긴 사람의 모임 ->집합x
--(1,5,10) -> (10,5,1) : 두 집합은 서로 동일하다.
--테이블에는 순서가 보장되지 않음
--SELECT 결과가 순서가 다르더라도 값이 동일하면 정답
-->정렬기능 제공(ORDER BY)
SELECT *
FROM emp;

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101','YYYYMMDD') AND hiredate <= TO_DATE('19830101','YYYYMMDD');


-- IN연산자
--특정 집합에 포함되는지 여부를 확인
--부서번호가 10혹은(OR) 20번에 속하는 직원 조회
SELECT empno, ename, deptno
FROM emp;

SELECT empno, ename, deptno
FROM emp
WHERE deptno IN(10,20);

-- IN 연산자를 사용하지 않고 OR연산자 사용
SELECT *
FROM emp
WHERE deptno = 10 OR deptno = 20;

--emp 테이블에서 사원이름이 SMITH, JONES인 직원만 조회 (empno, ename, deptno)
SELECT empno, ename, deptno
FROM emp
WHERE ename IN('SMITH','JONES');

--Users테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회하시오( IN 사용)
SELECT *
FROM users;

SELECT userid 아이디, usernm 이름, alias 별명
FROM users
WHERE userid IN('brown', 'cony', 'sally');


-- 문자열 매칭 연산자 : LIKE, %, _
-- 위에서 연습한 조건은 문자열 일치에 대해서 다룸
-- 이름이 BR로 시작하는 사람만 조회
-- 이름에 R 문자열이 들어가는 사람만 조회

--사원이름이 S로 시작하는 사원 조회
--% 어떤 문자열 (한글자, 글자 없을수도 있고 , 여러 문자열이 올수도 있다)
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE ename LIKE 'S%';

--글자수를 제한한 패턴 매칭
-- _ 정확히 한문자를 의미
-- 직원 이름이 S로 시작하고 이름의 전체 길이가 5글자 인 직원
-- S____라고 하면 됨
SELECT *
FROM emp
WHERE ename LIKE 'S____';

--사원 이름에 S글자가 들어가는 사원 조회
--'%S%'
SELECT *
FROM emp
WHERE ename LIKE '%S%';

--member테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오
SELECT *
FROM member;

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

--member 테이블에서 회원의 이름에 글자[이]가 들어가는 모든 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오.
SELECT *
FROM member;

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';


--null 비교 연산 (IS)
--comm컬럼의 값이 null인 데이터를 조회 (WHERE comm = null)
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE comm = null;
--위의 결과가 안나온다 null은 = 대신에 IS 라는 연산자를 사용해야 한다.

SELECT *
FROM emp
WHERE comm IS null;

--where6 
--emp테이블에서 상여(comm)가 있는 회원의 정보를 다음과 같이 조회되도록 쿼리를 작성하시오
SELECT *
FROM emp
WHERE comm >= 0;
--NOT 연산자
SELECT *
FROM emp
WHERE comm IS NOT null;

--사원의 관리자가 7698,7839 그리고 null이 아닌 직원만 조회
--NOT IN연산자에서는 NULL값을 포함 시키면 안된다.
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839)
AND mgr IS NOT null;

--where 7
--emp테이블에서 job이 SALESMAN이고 입사일자가 1981년 6월1일 이후인 직원의 정보를 조회하라
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--where 8
--emp 테이블에서 부서번호가 10이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
--(IN, NOT IN연산자 사용금지)
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE deptno != 10 AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--where 9
--emp 테이블에서 부서번호가 10이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
--(NOT IN연산자 사용)
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE deptno NOT IN(10) AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--where 10
--emp테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하시오.
--(부서는 10, 20, 30 만 있다고 가정하고 IN연산자를 이용)
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE deptno IN (20,30) AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--where 11
--emp테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월1일 이후인 직원의 정보를 다음과 같이 조회 하세요
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('19810601','YYYYMMDD');

--where 12
--emp테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회 하세요.
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';

--where 13
--emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회 하세요.
--LIKE 연산자 사용 금지
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899;                --이것은 반쪽자리 답이다.

--연산자 우선순위
--*,/연산자가 +,-보다 우선순위가 높다.
-- 1+5*2 = 11 ->(1+5)*2 x
--우선순위 변경 : ()
--AND > OR 
--emp테이블에서 사원 이름이 SMITH 이거나 
--                      (사원 이름이 ALLEN이면서 담당업무가 SALESMAN )사원 조회
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE ename = 'SMITH' OR (ename = 'ALLEN' and job = 'SALESMAN');

--사원 이름이 (SMITH 이거나 ALLEN )이면서 담당업무가 SALESMAN인 사원 조회
SELECT*
FROM emp;

SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN') and job = 'SALESMAN';

--emp테이블에서 job이 SALESMAN 이거나 사원번호가 78로 시작하면서 입사일자가 1981년06월01일 이후인 직원의 정보를 조회하라
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR (empno LIKE '78%' and hiredate >= TO_DATE('19210601','YYYYMMDD'));


--정렬
--SELECT *
--FORM  table
--[WHERE]
--ORDER BY 컬럼 [ASC | DESC],...|별칭|컬럼인덱스 |
--emp 테이블의 모든 사원을 ename컬럼 값을 기준으로 오름차순 정렬한 결과를 조회 하세요.
SELECT *
FROM emp
ORDER BY ename ASC;      --ASC는 기본값으로 생략가능

--emp 테이블의 모든 사원을 ename컬럼 값을 기준으로 내림차순 정렬한 결과를 조회 하세요.
SELECT *
FROM emp
ORDER BY ename DESC;  

--DESC emp;  --DESC : DESCRIBE[설명하다]
--ORDER BY ename DESC --DESC : DESCENDING[내림]

--emp테이블에서 사원 정보를 ename컬럼으로 내림차순, 
--ename값이 같을 경우 mgr컬럼으로 오름차순 정렬하는 쿼리 작성(order by 여러개 컬럼 가능)
SELECT *
FROM emp
ORDER BY ename DESC, mgr;
--정렬시 별칭을 사용(간이로 만든 컬럼도 오더바이 할수 있다. 또한 순서는 FROM -> SELECT -> ORDER BY)
SELECT empno, ename nm, sal *12 year_sal
FROM emp
ORDER BY year_sal;

--컬럼 인덱스로 정렬
--java array(배열)은 index의 시작이 0이지만 SQL 은 index가 1부터 시작한다.
SELECT empno, ename nm, sal *12 year_sal
FROM emp
ORDER BY 3;

--orderby1
--dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하라
SELECT *
FROM dept
ORDER BY dname;

--dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하라
SELECT *
FROM dept
ORDER BY loc DESC;

--order by2
--emp테이블에서 상여(comm)정보가 있는 사람들만 조회하고,
--상여(comm)를 많이 받는 사람이 먼저 조회되도록 하고, 상여가 같을 경우
--사번으로 오름차순 정렬하세요(상여가 0인 사람은 상여가 없는 것으로 간주)
SELECT*
FROM emp
WHERE comm IS NOT null AND comm >0
ORDER BY comm DESC, empno;

--order by3
--emp테이블에서 관리자가 있는 사람들만 조회하고, 직군(job)순으로 오름차순 정렬하고,
--직업이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하세요.
SELECT *
FROM emp
WHERE mgr IS NOt null
ORDER BY job,empno DESC;

--order by4
--emp 테이블에서 10부서(deptno) 혹은 30번 부서에 속하는 사람중 급여(sal)가
--1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬되도록 쿼리를 작성하세요.
SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal >1500
ORDER BY ename desc;



--쿼리 실행 결과 11건
--페이징 처리(페이지당 10건의 게시글)
--1페이지 : 1~10
--2페이징  11-20
--바인드 변수 1page, 2pageSize;

--WHERE rn (:n-1) * pageSize + 1 ~ :n * pageSize;
SELECT a.*
FROM
	(SELECT rownum rn, a.*
	FROM 
		(SELECT seq, LPAD(' ', (LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) root
		FROM board_test
		START WITH parent_seq IS NULL
		CONNECT BY PRIOR seq = parent_seq
		ORDER SIBLINGS BY root DESC, seq ASC)a)
WHERE rn BETWEEN ((:page - 1)*(:pageSize)) +1 AND :page * :pageSize;



--위에 쿼리를 분석함수를 사용해서 표현하면
SELECT ename, sal, deptno, ROW_NUMber() OVER (partition by deptno order by sal desc)rank
FROM emp;

--분석함수 문법
--분석함수명([인자]) OVER([PARTITION BY 컬럼] [ORDER BY 컬럼] [WINDOWING])
--PARTITION BY 컬럼명 : 해당 컬럼이 같은 row 끼리 하나의 그룸으로 묶는다.
--ORDER BY 컬럼 : PARTITION BY 에 의해 묶은 그룹 내에서 ORDER BY 컬럼으로 정렬

--ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC)rank;

--순위 관련 분석함수
--rank(): 같은 값을 가질 때 중복 순위를 인정, 후 순위는 중복 값만큼 떨어진 값부터 시작
--		2등이 2명이면 3등은 없고 4등부터 후순위가 생성된다.
--DESE_RANK(): 같은 값을 가질 때 중복 순위를 인정, 후순위는 중복순위 다음부터 시작
--		2등이 2명이더라도 후순위는 3등부터 시작
--ROW_NUMBER() : ROWNUM과 유사하고, 중복된 값을 허용하지 않음


--부서별, 급여 순위를 3개의 랭킹 관련함수를 적용
SELECT ename, sal, deptno,
	RANK() OVER (PARTITION BY deptno ORDER BY sal)sal_rank,
	DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal)sal_dense_rank,
	ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal)sal_row_number
FROM emp;

--실습 no_ana1
SELECT empno, ename, sal, deptno,
	RANK() OVER (ORDER BY sal desc, empno )sal_rank,
	DENSE_RANK() OVER (ORDER BY sal desc, empno)sal_dense_rank,
	ROW_NUMBER() OVER (ORDER BY sal desc, empno)sal_row_number
FROM emp;


--실습 no_ana2
SELECT a.empno,a.ename,a.deptno,b.cnt
FROM emp a,(
SELECT deptno, count(*)cnt
FROM emp
GROUP BY deptno
ORDER BY deptno)b
WHERE a.deptno = b.deptno;


--분석함수/window 함수(집계)
--1.sum(col)
--2.MIN(col)
--3.MAX(col)
--4.AVG(col)
--5.COUNT(col)

--window function을 이용하여 모든 사원에 대해 사원본호, 사원이름,
--해당 사원이 속한 부서의 사원 수를 구하기
SELECT empno, ename, deptno,
	COUNT(*) over (partition by deptno) cnt
FROM emp;

--실습 ana2
--window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여, 부서번호와
--해당 사원이 속한 부서의 급여 평균을 조회하는 쿼리를 작성하세요(급여 평균은 소수점 둘째자리)
SELECT empno, ename, sal, deptno, ROUND(AVG_SAL,2) AVG_SAL
FROM 
(SELECT empno, ename, sal, deptno,
	AVG(sal) OVER(partition by deptno) AVG_SAL
FROM emp);

--실습 ana3
--window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여, 부서번호와 
--해당 사원이 속한 부서의 가장 높은 급여를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, sal, deptno, 
	MAX(sal) OVER(partition by deptno) MAX_SAL
FROM emp;

--실습 ana4
--window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여, 부서번호와
--해당 사원이 속한 부서의 가장 낮은 급여를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, sal, deptno, 
	MIN(sal) OVER(partition by deptno) MIN_SAL
FROM emp;


--분석함수/window함수(그룹내 행 순서)
--1.LAG(col) : 파티션별 윈도우에서 이전 행의 걸럼 값
--2.LEAD(col) : 파티션별 윈도우에서 이후 행의 컬럼 값

--분석함수/window함수(그룹내 행 순서)
--window function을 이용하여 모든 사원에 대해 사원번호, 사원이름,
--입사일자, 급여, 전체 사원중 급여 순위가 1단계 낮은 사람의 급여를 구해보자
--(급여가 같을 경우 입사일이 빠른 사람이 높은 순위)
SELECT empno, ename, hiredate,sal,
	LEAD(SAL) OVER (ORDER BY sal desc, hiredate) lead_sal
FROM emp;

--그룹내 행 순서 실습 ana5
--window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여, 
--전체 사원중 급여 순위가 1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요
--(급여가 같을 경우 입사일이 빠른 사람이 높은 순위)
SELECT empno, ename, hiredate,sal,
	LAG(SAL) OVER (ORDER BY sal desc, hiredate) lead_sal
FROM emp;

--그룹내 행 순서 실습 ana6
--window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 직군(job),급여정보
--담당업무(job)별 급여 순위가 1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요
--(급여가 같을 경우 입사일이 빠른 사람이 높은 순위)
SELECT empno, ename, hiredate, job, sal,
	LAG(sal) OVER (partition BY job ORDER BY sal desc,job)LAG_SAL
FROM emp;

--그룹내 행 순서 - 생각해보기, 실습 no_ana3
--모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여를 급여가 낮은 순으로 조회해보자
--급여가 동일할 경우 사원번호가 빠른 사람이 우선순위가 높다
--우선순위가 가장 낮은 사람부터 본인 까지의 급여 합을 새로운 컬럼으로 생성
--window 함수없이

SELECT empno, ename, sal
FROM emp
ORDER BY sal;

--WHERE절의 범위에 따라 sum이 됨
SELECT sum(sal)
FROM
	(SELECT rownum rn,sal
	 FROM (SELECT empno, ename, sal
		   FROM emp
		   ORDER BY sal))
WHERE rn <= (   );

SELECT *
FROM
(
(SELECT rownum rn,a.*
FROM(
	SELECT empno, ename, job, sal
	FROM emp
	ORDER BY sal)a)a,

(SELECT rownum rn,b.*
FROM(
	SELECT empno, ename, job, sal
	FROM emp
	ORDER BY sal)b)b
)	
WHERE a.rn >= b.rn
;


------------------------------------------------------------------------
--no_ana3을 분석함수를 이용하여 SQL 작성
--window함수를 활용하여
SELECT empno, ename, sal,
	SUM(sal) OVER (order by sal,empno)c_sum
FROM emp;

SELECT empno, ename, sal,
	SUM(sal) OVER()c_sum
FROM emp;


--분석함수
--windowing
--window함수에 대상이 되는 행을 지정
--UNBOUNDED PRECEDING : 현재 행기준 모든 이전행
--CURRENT ROW : 현재행
--UNBOUNDED FOLLOWING : 현재 행 기준 모든 이후행
SELECT empno, ename, sal,
	SUM(sal) OVER (order by sal,empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)c_sum
FROM emp;


--분석함수/window함수(그룹내 행 순서)
--현재 행을 기준으로 이전 한행부터 이후 한행까지 총 3개행의 sal합계 구하기
SELECT empno, ename, sal,
	SUM(sal)OVER(ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)c_sum
FROM emp;

--그룹내 행 순서 실습 ana7
--사원번호, 사원이름, 부서번호, 급여 정보를 부서별로 급여, 사원번호 오름차순으로 정렬했을 때
--자신의 급여와 선행하는 사원들의 합을 조회하는 쿼리를 작성하세요
SELECT empno, ename, deptno, sal,
	SUM(sal)OVER(partition BY deptno ORDER BY deptno,sal ROWS BETWEEN UNBOUNDED PRECEDING  AND CURRENT ROW)c_sum
FROM emp;

--WINDOWUNG의 range, rows비교
--range : 논리적인 행의 단위, 같은 값을 가지는 컬럼까지 자신의 행으로 취급
--ROW : 물리적인 행의 단위


--마지막 쿼리
select empno, ename, deptno ,sal,
    sum(sal) over (partition by deptno order by sal rows unbounded preceding )row_,
    sum(sal) over (partition by deptno order by sal rows unbounded preceding )range_,
    sum(sal) over (partition by deptno order by sal  ) default_
from emp;
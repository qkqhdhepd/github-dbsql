SELECT ename, job, sal,
       DECODE(job, 'SALESMAN', CASE
                                    WHEN sal > 1400 THEN sal*1.05
                                    WHEN sal < 1400 THEN sal*1.1
                                END,
                                'MANAGER',sal*1.1,
                                'PRESIDENT',sal*1.2,
                                sal)bonus_sal
FROM emp;

--cond1
--emp 테이블을 이용하여 deptno에 따라 부서명으로 변경 해서 다음과 같이 조회되는 쿼리를 작성하세요
SELECT *
FROM emp;

SELECT empno, ename, deptno,
       DECODE(deptno,10,'ACCOUNTING',
                    20,'RESEARCH',
                    30,'SALES',
                    40,'OPERATIONS',
                    'DDIT')DNAME
FROM emp;

SELECT empno, ename, deptno,
        case
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END
FROM emp;

--cond2
--emp테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요
--(새년을 기준으로 하나 여기서는 입사년도를 기준으로 한다)
--올해는 짝수년이다 그러므로 홀수년인 사람들은 검사를 받아야 한다.
--올해년도가 짝수에만 
-- 입사년도가 짝수일 때 건강검진 대상자
-- 입사년도가 홀수일 때 건강검진 비대상자
--올해년도가 홀수이면
-- 입사년도가 짝수일 때 건강검진 비대상자
-- 입사년도가 홀수일 때 건강검진 대상자
--올해년도가 짝수인지, 홀수인지 확인
-- DATE타입 => 문자열 ( 여러가지 포맷, YYYY-MM-DD HH24:MI:SS)
SELECT MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)
FROM emp;

SELECT empno, ename, hiredate,
       CASE
            WHEN MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2) = MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2) THEN '건강검진 대상자'
            WHEN MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2) != MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2) THEN '건강검진 비대상자'
            ELSE '건강검진 비대상자'
       END
FROM emp;



--cond3
--users 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
--(생년을 기준으로 하나 여기서는 reg_dt를 기준으로 한다)
SELECT userid, usernm, alias, reg_dt,
        CASE
            WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt,'YYYY')),2) = MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2) THEN '건강검진 대상자'
            WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt,'YYYY')),2) != MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2) THEN '건강검진 비대상자'
            ELSE '건강검진 비대상자'
        END
FROM users;

--SELECT empno, ename, hiredate,
--        DECODE (MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2) = MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2),'건강검진 대상자',
--               MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2) != MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2),'건강검진 비대상자','건강검진 비대상자')
--            
--FROM emp;


--p.168
--Group by 행을 묶을 기준
--부서번호가 같은 ROW끼리 묶는 경우 : Group by deptno
--담당업무가 같은 ROW끼리 묶는 경우 : Group by job
--MGR가 같고 담당업무가 같은 ROW끼리 묶는 경우 : Group by mgr, job

--부서별 급여 합
--SUM : 합계
--COUNT : 갯수
--MAX : 최대값
--MIN : 최소값
--AVG : 평균
--GROUP BY의 특징
--해당 컬럼에 null값을 갖는 ROW가 존재할 경우 해당 값은 무시하고 계산다. null 연산의 결과는 null이었는데 그룹함수에서는 안된다.
--그룹함수의 주의점
--GROUP BY 절에서 나온 컬럼이외의 다른 컬럼이 SELECT절에 표현되면 에러
--부서별 급여합
SELECT deptno, ename,
       sum(sal) sum_sal, MAX(sal), MIN(sal), ROUND(AVG(sal),2), COUNT(sal)
FROM emp
GROUP BY deptno , ename;


--GROUP BY에 없는 상태에서 그룹함수를 사용한 경우
--전체행을 하나의 행으로 묶는다
SELECT deptno, ename,
       sum(sal) sum_sal, MAX(sal), MIN(sal), ROUND(AVG(sal),2), COUNT(sal)
FROM emp
GROUP BY deptno ;
/*ORA-00979: not a GROUP BY expression
00979. 00000 -  "not a GROUP BY expression"
*Cause:    
*Action:
101행, 16열에서 오류 발생*/


SELECT sum(sal) sum_sal, MAX(sal), MIN(sal), ROUND(AVG(sal),2), 
       COUNT(sal),  --sal 컬럼의 값이 null이 아닌 row갯수
       COUNT(comm),  --comm컬럼의 값이 null이 아닌 ROW갯수
       COUNT(*) --몇건의 데이터가 있는지
FROM emp;

--GROUP BY의 기준이 empno이면 결과수가 몇개일까?
--상수는 그룹함수를 적용안해도 사용이 가능하다.
--그룹화와 관련없는 임의의 문자열, 함수, 숫자 등은 SELECT절에 나오는 것이 가능
SELECT sum(sal) sum_sal, MAX(sal), MIN(sal), ROUND(AVG(sal),2), 
       COUNT(sal),  --sal 컬럼의 값이 null이 아닌 row갯수
       COUNT(comm),  --comm컬럼의 값이 null이 아닌 ROW갯수
       COUNT(*) --몇건의 데이터가 있는지
FROM emp
GROUP BY empno;

--SINGLE ROW FUNCTON 의 경우 wHERE 절에서 사용하는 것이 가능하다.
--MULTI ROW FUNCTION(GROUP_FUNCTION)의 경우 WHERE절에서 사용하는 것이 불가능 하고 HAVING절에서 조건을 기술한다.

--부서별 급여 합 조회, 단 급여함이 9000이상인 row만조회
--deptno, 급여함
SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

--grp1
--emp테이블을 이용하여 다음을 구하시오
SELECT  MAX(sal),MIN(sal),ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), count(*)
FROM emp;

--grp2
--emp테이블을 이용하여 다음을 구하시오
SELECT deptno,MAX(sal),MIN(sal),ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), count(*)
FROM emp
GROUP BY deptno;

--grp3
--emp테이블을 이용하여 다음을 구하시오
--grp2에서 작성한 쿼리를 활용하여 deptno대신 부서명이 나올수 있도록 수정하시오
SELECT DECODE(deptno,10,'ACCOUNTING',
                     20,'RESEARCH',
                     30,'SALES')DNAME,
       MAX(sal),MIN(sal),ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), count(*)
       
FROM emp
GROUP BY deptno
ORDER BY DNAME;
---위에는 자동변환이 이루어지고 밑에는 DECODE절을 GROUP BY 절로 묶음
SELECT DECODE(deptno,10,'ACCOUNTING',
                     20,'RESEARCH',
                     30,'SALES')DNAME,
       MAX(sal),MIN(sal),ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), count(*)
       
FROM emp
GROUP BY deptno, DECODE(deptno,10,'ACCOUNTING',
                     20,'RESEARCH',
                     30,'SALES')
ORDER BY DNAME;

--grp4
--emp테이블을 이용하여 다음을 구하시오
--직원의 입사 년월별로 몇명의 직원이 입사했는지 조회
--ORACLE 9i 이전까지는 GROUP BY 절에 기술한 컬럼으로 정렬을 보장
--ORACLE 10G 이후부터는 GROUP BY 절에 기술한 컬럼으로 보장하지 않는다.
--ORDER BY의 속도는 포기하고 GROUP BY의 속도를 향상시킴
SELECT *
FROM emp;

SELECT TO_CHAR(hiredate,'yyyymm')HIRE_YYYYMM,count(*)CNT
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyymm');

--grp5
--emp테이블을 이용하여 다음을 구하시오
--직원의 입사 년별로 몇명의 직원이 입사했는지 조회
SELECT TO_CHAR(hiredate,'yyyy')HIRE_YYYY,count(*)CNT
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyy');

--grp6
--회사에 존재하는 부서의 개수는 몇개인지 조회하는 쿼리를 작성하시오.
SELECT COUNT(*)CNT
FROM dept;

--grp7
--직원이 속한 부서의 개수를 조회하는 쿼리를 작성하시오
SELECT COUNT(*)CNT
FROM
    (SELECT deptno
    FROM emp
    GROUP BY deptno);


--inner join
SELECT a.ename, a.empno, b.deptno, b.loc
FROM emp a inner join dept b on a.deptno = b.deptno ;

SELECT ename, deptno, loc
FROM emp
join dept using (deptno);
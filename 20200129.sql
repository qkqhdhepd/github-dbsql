--과제
--1.2019년 12월 31일 date형으로 표현
--2.2019년 12월 31일 date형으로 표현하고 5일 이전날짜
--3.현재날짜
--4.현재 날짜에서 3일전 값

SELECT SYSDATE
FROM dual;

SELECT SYSDATE - 29 lastday, SYSDATE -34 lastdat_before5, SYSDATE now, SYSDATE +3 now_before3
FROM dual;

SELECT TO_DATE('20191231','yyyymmdd')lastday
FROM dual;

SELECT TO_DATE('20191231','yyyymmdd')-5 last_before5
FROM dual;

SELECT SYSDATE
FROM dual;


--DATE : TO_DATE 문자열 =>날짜(DATE)
--      TO_CHAR 날짜 =>문자열(날짜 포맷 지정)
--JAVA에서는 날짜 포맷의 대소문자를 가린다(MM/mm =>월 / 분)
--주간일자(1-7) : 일요일1,월요일2....토요일7
--주차 IW : ISO표준 =>해당주의 목요일을 기준으로 주차를 산정
--        2019/12/31 월요일 =>2020/01/02(목요일)이기 때문에 1주차로 나온다.
SELECT TO_CHAR(SYSDATE, 'YYYY-MM/DD HH24:MI:SS'),
       To_CHAR(SYSDATE, 'D'),    --오늘은 2020/01/29 (수)=>4
       TO_CHAR(SYSDATE, 'IW'),
       To_CHAR(TO_DATE('2019/12/31','YYYY/MM/DD'),'IW')
FROM dual;


--emp 테이블의 hiredate(입사일자) 컬럼의 년월일 시:분:초
SELECT ename, hiredate
FROM emp;

SELECT ename, TO_CHAR(hiredate, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(hiredate +1, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(hiredate +1/24, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(hiredate +1/48, 'YYYY-MM/DD HH24:MI:SS'),
       --hiredate에 30분을 더하여 TO_CHAR로 표현
       TO_CHAR(hiredate +30/1440, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(hiredate +(1/24/60)*30, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(hiredate, 'D'),
       TO_CHAR(hiredate, 'IW')
FROM emp;

--fn2
--오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오
1. 년-월-일
2. 년-월-일 시간(24)-분-초
3. 일-월-년
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24-MI-SS')DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY')DT_DD_MM_YYYY
FROM dual;


--FUNCTION(DATE)
--MONTHS_BETWEEN(DATE,DATE)
--인자로 돌아온 두 날짜 사이의 개월수
SELECT ename, hiredate,
       MONTHS_BETWEEN(sysdate, hiredate),
       MONTHS_BETWEEN(TO_DATE('2020-01-17','YYYY-MM-DD'),hiredate)       
FROM emp
WHERE ename = 'SMITH';

--ADD_MONTHS(DATE,NUMBER), 정수-가감할 개월수 
SELECT ADD_MONTHS(SYSDATE, 5), --2020/01/29 ->2020/06/29
       ADD_MONTHS(SYSDATE, -5)  --2020/01/29 ->2019/08/29
FROM dual;

--NEXT_DATE(DATE,weekday) : ex) NEXT_DATE(SYSDATE,5) =>SYSDATE이후 
--처음 등장하는 주간일자 5(목)에 해당하는 일자 SYSDATE 2020/01/29 (수) 이후 처음 등장하는 5(목) => 2020/01/30(목)
SELECT NEXT_DAY(SYSDATE, 5)
FROM dual;

--LAST_DATY(DATE) : DATE가 속한 월의 마지막 일자를 리턴
SELECT LAST_DAY(SYSDATE)
FROM dual;

--LAST_DAY를 통해 인자로 들어온 date가 속한 월의 마지막 일자를 구할수 있는데 date의 첫번째 일자는 어떻게 구할까?
SELECT SYSDATE, LAST_DAY(SYSDATE),LAST_DAY(SYSDATE)-30
FROM dual;

SELECT SYSDATE,
       LAST_DAY(SYSDATE),
       To_DATE('01','DD'),
       ADD_MONTHS(LAST_DAY(SYSDATE),-1)+1,
       ADD_MONTHS(LAST_DAY(SYSDATE +1),-1),
       To_DATE(TO_CHAR(SYSDATE,'YYYY-MM') || '-01' , 'YYYY-MM-DD')
FROM dual;

--hiredate값을 이용하여 해당 월의 첫번째 일자로 표현
SELECT ename, hiredate,
       LAST_DAY(hiredate),
       ADD_MONTHS(LAST_DAY(hiredate),-1)+1,
       To_DATE(TO_CHAR(hiredate,'YYYY-MM') || '-01' , 'YYYY-MM-DD')
FROM emp;

--empno는 NUMBER 타입, 인자는 문자열
--타입이 맞지 않기 때문에 묵시적 형변환이 일어남.
--테이블 컬럼의 타입에 맞게 올바른 인자 값을 주는게 중요
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM emp
WHERE empno = 7369;

--hiredate의 경우 date타입, 인자는 문자열로 주어졌기 때문에 묵시적 형변환이 발생
--날짜 문자열 보다 날짜 타입으로 명시적으로 기술하는 것이 좋음
SELECT *
FROM emp
WHERE hiredate = '80/12/17';

SELECT *
FROM emp
WHERE hiredate = '1980/12/17';

---------------------------------------------------------------------------
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM table(dbms_xplan.display);
--자식이 있으면 자식부터 읽는다

--숫자를 문자열로 변경하는 경우 : 포맷
--천단위 구분자
--1000이라는 숫자를 
--한국 : 1,000.50
--독일 : 1.000,50

--emp sal 컬럼(NUMBER 타입)을 포맷팅
--9 : 숫자
--0 : 강제 자리 맞춤(0으로 표기)
--L : 통화단위
SELECT ename, sal, TO_CHAR(sal,'L9,999')
FROM emp;


--null처리
--null에 대한 연산의 결과는 항상 null
--emp 테이블의 sal컬럼에는 null이 존재하지 않음(14건에 대해서)
--emp 테이블의 comm컬럼에는 null이 존재한다.
--sal + comm => comm의 null인 행에 대해서는 결과가 null로 나옴
SELECT ename, sal, comm, sal+comm
FROM emp;

--comm이 null이면 sal컬럼의 값만 조회되도록 하라(결함)
SELECT ename, sal, comm, sal+comm
FROM emp;
--그래서 우리는 NVL이라는 함수를 활용하여 null을 해결할 수 있다.
--NVL(타겟, 대체값)
--타겟의 값이 null이면 대체값을 변환하고 타겟의 값이 null이 아니면 타켓 값을 반환한다.
--if(타겟 == null)
--      return 대체값;
--else
--      return 타겟;
SELECT ename, sal, comm, NVL(comm, 0), sal + NVL(comm,0)
FROM emp;


--NVL2(인자1,인자2, 인자3)
--if(expr1 != null)
--      return expr2;
--else
--      return expr3;

SELECT ename, sal, comm, NVL2(comm, 10000, 0)
FROM emp;

--NULLIF(expr1, expr2)
--if(expr1 == expr2)
--      return null;
--else
--      return expr1;
SELECT ename, sal, comm, NULLIF(sal, 1250)  --sal이 1250인 사람은 null을 리턴, 아닌사람은 sal을 리턴
FROM emp;


--가변인자
--COALESCE 인자중에 가장 처음으로 등장하는 NULL이 아닌 인자를 반환
--COALESCE(expr1), expr2...)
--if (expr1 != nuill)
--      return expr1;
--else 
--      return COALESCE(expr2, expr3...);
--COALESCE(comm, sal) : comm이 null이 아니면 comm
--                    : comm이 null이면  sal (단, sal컬럼의 값이 null이 아닐때)
SELECT ename, sal, comm, COALESCE(comm, sal)
FROM emp;


--fn4
--emp 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요.(NVL, NVL2, coalesce)
SELECT empno, ename, mgr,
       NVL(mgr,9999)mgr_N,
       NVL2(mgr,mgr,9999)mgr_N_1,
       coalesce(mgr, 9999) mgr_N_2
FROM emp;


--fn5
--users테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요.
--reg_dt가 null일 경우 sysdate를 적용
SELECT userid, usernm, reg_dt, NVL(reg_dt, sysdate) N_REG_DT
FROM users
WHERE userid NOT IN ('brown');

SELECT userid, usernm, reg_dt, NVL2(reg_dt, reg_dt, sysdate)N_REG_DT
FROM users
WHERE userid NOT IN ('brown');


--Condition : 조건절
--case : java의 if - else if - else
--CASE
--      WHEN 조건 THEN 리턴값1
--      WHEN 조건2 THEN 리턴값2
--      ELSE 기본값
--END
--emp테이블에서 job 컬럼의 값이 SALESMAN이면 sal * 1.05리턴
--                          MANAGER 이면 sal * 1.1리턴
--                          PRESIDENT 이면 sal * 1.2리턴
--                          그밖의 사람들은 sal을 리턴

SELECT ename,JOB,sal,
       case
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal
        END bonus_sal
FROM EMP;

--DECODE 함수 : case절과 유사
--(다른점 CASE 절 : WHEN 절에 조건비교가 자유롭다
--              DECODE함수 : 하나의 값에 대해서 = 비교만 허용
--DECODE 함수: 가변인자 (인자의 개수가 상황에 따라서 늘어날 수가 있음)
--DECODE(컬럼, 첫번째 인자와 비교할 값1, 첫번째 인자와 두번째 인자가 같을 경우 반환 값,
--          첫번째 인자와 비교할 값,첫번째 인자와 네번째 인자가 같을 경우 반환 값 ...
--           option -else 푀종적으로 반환할 기본값)

--emp테이블에서 job 컬럼의 값이 SALESMAN이면 sal * 1.05리턴
--                          MANAGER 이면 sal * 1.1리턴
--                          PRESIDENT 이면 sal * 1.2리턴
--                          그밖의 사람들은 sal을 리턴
SELECT ename, job, sal,
       DECODE(job,'SALESMAN',sal * 1.05,
                  'MANAGER',sal* 1.1,
                  'PRESIDENT',sal * 1.2, sal) bonus_sal
       
FROM emp;



--emp테이블에서 job 컬럼의 값이 
--SALESMAN이면서 sal가 1400보다 크면 sal * 1.05리턴
--SALESMAN이면서 sal가 1400보다 작으면 sal * 1.1리턴
--MANAGER 이면 sal * 1.1리턴
--PRESIDENT 이면 sal * 1.2리턴
--그밖의 사람들은 sal을 리턴
--1.case이용
--2.decode와 혼용
SELECT ename,JOB,sal,
       case
            WHEN job = 'SALESMAN' and sal > 1400 THEN sal *1.05
            WHEN job = 'SALESMAN' and sal < 1400 THEN sal *1.1
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal
        END bonus_sal
FROM EMP;

SELECT ename,JOB,sal,
       case
            WHEN job = 'SALESMAN' and sal > 1400 THEN sal *1.05
            WHEN job = 'SALESMAN' and sal < 1400 THEN sal *1.1
            ELSE sal
        END bonus_sal,
        DECODE(job,'MANAGER',sal* 1.1,
                  'PRESIDENT',sal * 1.2, sal) bonus_sal
FROM EMP;





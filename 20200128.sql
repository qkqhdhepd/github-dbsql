--order by4
--emp 테이블에서 10부서(deptno) 혹은 30번 부서에 속하는 사람중 급여(sal)가
--1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬되도록 쿼리를 작성하세요.
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ename desc;


--ROWNUM : 행번호를 나타내는 컬럼
SELECT ROWNUM, empno, ename
FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ename desc;

--ROWNUM 을 WHERE 절에서도 사용가능
--동작하는거 : ROWNUM = 1, ROWNUM <= 2;  ROWNUM = 1, ROWNUM <= N
--동작하지 않은 것: ROWNUM = 2, ROWNUM >= 2;   ROWNUM= N(N은 1이 아닌 정수), ROWNUM >= N (N은 1인 아닌 정수)
--ROWNUM 이미 읽은 데이터에다가 순서를 부여
--유의점 : ORDER BY 절은 SELECT 절 이후에 실행
--읽지 않은 상대의 값을 (ROWNUM이 부여되지 않은 행)은 조회할 수가 없다.
--사용 용도 : 페이징 처리
--테이블에 있는 모든 행을 조회하는 것이 아니라 우리가 원하는 페이지에 해당하는 웹 데이터만 조회를 한다.
--페이징 처리시 고려사항, : 1 페이지당 건수, 정렬 기준
--emp테이블 중 row건수 : 14
--페이징당 5건의 데이터를 조회
--1page : 1-5
--2page : 6-10
--3page : 11-15
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM =1;

SELECT ROWNUM rn, empno, ename
FROM emp
ORDER by ename;

--정렬된 결과에 ROWNUM을 부여 하기 위해서는 IN - LINE VIEW를 사용한다.
--요점정리 : 1.정렬, 2.ROWNUM 부여

--SELECT *를 기술할 경우 다른 EXPRESSION을 표기 하기 위해서 테이블명.* 테이블명칭.*로 표현해야 한다.
SELECT ROWNUM, emp.*
FROM emp;
SELECT ROWNUM, e.*
FROM emp e;


SELECT ROWNUM rn,e.*
FROM
    (SELECT empno, ename
    FROM emp 
    ORDER BY ename)e;
    
SELECT *
FROM 
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp 
        ORDER BY ename) a)
WHERE rn = 2;

--1page : rn 1-5  ,정렬 기준은 ename
--2page : rn 6-10   --WHERE rn BETWEEN 6 AND 10;
--3page : rn 11-15  --WHERE rn BETWEEN 11 AND 15;
-- n page: rn (n-1) * pageSize + 1 ~ n * pageSize
SELECT *
FROM 
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp 
        ORDER BY ename) a)
WHERE rn >=1 AND rn <= 10;
--WHERE rn BETWEEN 6 AND 10;

SELECT *
FROM 
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp 
        ORDER BY ename) a)
WHERE rn BETWEEN (3 - 1) * 5 AND 3 * 5;

--row1
--emp 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성하시오(정렬 없이 진행)
SELECT ROWNUM rn,e.*
FROM emp e
WHERE rn <=10;
-----------------------------------------------

SELECT ROWNUM rn, a.*
FROM
    (SELECT empno, ename
    FROM emp) a
WHERE rn <=10;

-----------------------------------------------
SELECT *
FROM 
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp ) a)
WHERE rn <=10;
--sem
SELECT ROWNUM rn, empno, ename
from emp
WHERE rownum <=10;

--row2
--ROWNUM 값이 11~20(11~14)인 값만 조회하는 쿼리를 작성해보세요.
SELECT *
FROM 
    (SELECT ROWNUM rn,empno, ename
    FROM emp)
WHERE rn BETWEEN 11 and 20;

--row 3
--데이터 정렬
--emp테이블의 사원 정보를 이름컬럼으로 오름차순 적용 했을 때의 11~14번째 행을 다음과 같이 조회하는 쿼리를 작성해보세요
SELECT *
FROM emp;
--우선 emp테이블의 order by 를 적용하여 조회를한다.
--ROWNUM를 사용하기 위해   ORDER BY 구문을 FROM 으로 묶어서 적용시킨다.(읽는 순서가 ORDER BY가 마지막이기때문에)
--마지막으로 WHERE 절을 사용하여 조건을 주기 위해서 한번더 FROM 으로 묶는다 (조건절을 사용할 때 가상의 테이블을 읽어야 조건이 가능)

SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a;
--  WHERE rn BETWEEN 11 AND 14;      --오류가 뜨는데 RN을 인식할 수 없다고 뜸
--최종 쿼리문--
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN 11 AND 14;
--WHERE rn BETWEEN (1 - 1)*10 + 1 AND 1 * 10;   ->바인딩 변수(자바랑 연동되어 n값을 지정)
--WHERE rn BETWEEN (1page - 1)*pageSize + 1 AND 1page * pageSize;

--sql에서 변수를 지정하는 방법
--WHERE rn BETWEEN (:page - 1)*:pageSize + 1 AND :page * :pageSize;
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN (:page - 1)*:pageSize + 1 AND :page * :pageSize;

--sql에서는 두가지의 함수를 사용한다.
--Single row function
--Multi row function

--DUAL 테이블 : 데이터와 관계 없이, 함수를 테스트 해볼 목적으로 사용
SELECT *
FROM dual;

SELECT LENGTH ('TEST')
FROM dual;
--문자열의 대소문자 : lower, upper, initcap
SELECT LOWER('Hello, world'), UPPER('Hello, world'),INITCAP('Hello, world')
FROM dual;

SELECT LOWER(ename), UPPER(ename),INITCAP(ename)
FROM emp;
--함수는 WHERE 절에서도 사용 가능
--사원 이름이 SMITH인 사원만 조회
SELECT *
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE ename = :ename;

--sql작성시 아래 형태는 지양 해야한다.
SELECT *
FROM emp
WHERE LOWER(ename) = :ename;
--sql 위의 내용은 좌변을 가공하였기 때문에 쓰면 안된다.
SELECT *
FROM emp
WHERE ename = UPPER(:ename);


--이 형태를 기억하고 있자
SELECT CONCAT('Hello',', World') CONCAT, 
       SUBSTR('Hello, World', 1, 5)aub,
       LENGTH('Hello, World')len,
       INSTR('Hello, World','o') ins,
       INSTR('Hello, World','o', 6 ) ins2,
       LPAD('Hello, World',15,'*') lpad,
       RPAD('Hello, World',15,'*') rpad,
       REPLACE('Hello, World', 'H','T') REP,
       TRIM('Hello, World      ')TR, --공백을 제거
       TRIM('d' FROM 'Hello, World')TR --공백이 아닌 소문자 d제거
FROM dual;

--숫자 함수
-- ROUND : 반올림 (10.6을 소수점 첫번째 자리에서 반올림 =>11)
-- TRUNC : 절삭(버림)(10.6을 소수점 첫번째 자리에서 절삭 =>10)
-- ROUND, TURNC :몇번째 자리에서 반올림/절삭 (인자가 두개다)
-- MOD : 나머지 연산(몫이 아니라 나누기 연산을 한 나머지 값)(13/5 =>목은 2이고 나머지도 3)

--ROUND(대상 숫자값, 최종 결과 자리수)
/*반올림 결과가 소수점 첫번째 자리까지 나오도록 ->두번쨰 자리에서 반올림*/
SELECT ROUND(105.54, 1), 
       ROUND(105.55, 1),       --반올림 결과가 소수점 첫번째 자리까지 나오도록
       ROUND(105.55, 0),       --반올림 결과가 정수부만 =>소수점 첫번쨰 자리에서 반올림
       ROUND(105.55, -1),      --반올림 결과가 십의 자리까지 =>일의 자리에서 반올림
       ROUND(105.55)           --두번쨰 인자를 입력하지 않을 경우 0이 적용되어 결과값으로 나옴
FROM dual;

SELECT TRUNC(105.54, 1),    --절삭의 결과가 소수점 첫번쨰 자리까지 나오도록 =>두번째 자리에서 절삭
       TRUNC(105.55, 1),    --절삭의 결과가 소수점 첫번째 자리까지 나오도록 ->소수점 두번째 자리에서 절삭
       TRUNC(105.55, 0),    --절삭의 결과가 정수부(일의 자리)까지 나오도록 =>소수점 첫번째 자리에서 절삭
       TRUNC(105.55, -1),    --절삭의 결과가 10의 자리까지 나오도록 =>일의 자리에서 절삭
       TRUNC(105.55)        --두번쨰 인자를 입력하지 않을 경우 0이 적용
FROM dual;

--EMP 테이블에서 사원의 급여(sal)를 1000으로 나눴을 때 몫을 구하라
SELECT ename, sal, sal/1000, TRUNC(sal/1000) SAL_Quotient
FROM emp;

--EMP 테이블에서 사원의 급여(sal)를 1000으로 나눴을 때 나머지를 구하라
SELECT ename, 
        sal, 
        sal/1000, 
        TRUNC(sal/1000) SAL_Quotient, 
        --항상 나머지연산에서 1000으로 나머지연산을 하면 0~999까지 이다
        MOD(sal,1000) SAL_Reminder   
FROM emp;

DESC emp;

SELECT ename, hiredate
FROM emp;

--SYSDATE : 현재 오라클 서버의 시분초가 포함된 날자 정보를 리턴하는 특수한 함수
--함수명(인자1, 인자2)
--date = 정수 인자 연산
--1 =  하루
--1시간 = 1/24
SELECT SYSDATE
FROM dual;

SELECT SYSDATE +5, SYSDATE +1/24
FROM dual;

--숫자 표기 : 숫자
--문자 표기 : 싱글 쿼테이션 + 문자열 +싱글 쿼테이션 => '문자열'
--날짜 표기 : TO_DATE('문자열 날짜 값', '문자열 날짜 값의 표기 형식') 
-- =>TO_DATE('2020-01-24','yyyy-mm-dd')

SELECT ename, hiredate
FROm emp
WHERE ename = 'SMITH';

--과제
--1.2019년 12월 31일 date형으로 표현
--2.2019년 12월 31일 date형으로 표현하고 5일 이전날짜
--3.현재날짜
--4.현재 날짜에서 3일전 값

SELECT SYSDATE
FROM dual;

SELECT SYSDATE - 28 lastday, SYSDATE -33 lastdat_before5, SYSDATE now, SYSDATE +3 now_before3
FROM dual;




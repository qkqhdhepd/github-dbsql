--실습 select1
--PROD 테이블의 모든 컬럼의 자료 조회
SELECT *
FROM prod;
--PROD 테이블에서 PROD_ID, PROD_NAME 컬럼의 자료만 조회
SELECT prod_id, prod_name
FROM prod;
--1prod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM lprod;
--buyer 테이블에서 buyer_id, buyer_name컬럼만 조회하는 쿼리를 작성하세요.
SELECT buyer_id, buyer_name
FROM buyer;
--cart 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요.
SELECT *
FROM cart;
--member 테이블에서 mem_id, mem_pass, mem_name컬럼만 조회하는 쿼리를 작성하세요.
SELECT mem_id, mem_pass, mem_name
FROM member;
--users 테이블 조회
SELECT *
FROM users;
--테이블에 어떤 컬럼이 있는지 확인하는 방법
--1. SELECT *
--2. TOOL의 기능(사용자-TABLES)
--3. DESC 테이블명(DESE-DESCRIBE)
DESC users;

--users 테이블에서 userid,usernm,reg_dt컬럼만 조회하는 sql을 작성하세요.
--날짜 연산(reg_dt 컬럼은 date정보를 담을수 있는 타입)
--SQL 날짜 컬럼 + (더하기 연산)
--수학적인 사칙연산이 아닌것듯 (5+5)이런것을 제외한
--String h = "hello"l;
--String w = "world";
--String hw = h+w; --자바에서는 두 문자열을 결합
--SQL에서 정의된 날짜 연산 : 날짜 + 정수 = 날짜에서 정수를 일자로 취급하여 더한 날짜가 된다.
--(2019/01/28 + 5 = 2019/02/02)
--reg_dt : 등록일자 컬럼
--null : 값을 모르는 상태
--null에 대한 연산 결과는 항상 null이다.
SELECT userid, usernm, reg_dt, reg_dt + 5 AS reg_dt_after_5day
FROM users;

--실습 select2
--prod테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오.
--(단 prod_id ->id, prod_name->name으로 컬럼 별칭을 지정)
SELECT prod_id id, prod_name name
FROM prod;

--lprod테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하는 쿼리를 작성하시오.
--(단 lprod_gu ->gu, lprod_nm ->nm으로 컬럼 별칭을 지정)
SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

--buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오.
--(단 buyer_id ->바이어아이디, buyer_name -> 이름으로 컬럼 별칭을 지정)
SELECT buyer_id AS 바이어아이디, buyer_name 이름
FROM buyer;

--문자열 결합
--자바 언어에서 문자열 결합 : + ("Hello" + "world")
--SQL에서는 : || ('Hello' || 'world')
--SQL에서는 : concat('Hello','world')

--userid, usernm컬럼을 결함, 별칭 id_name
SELECT userid || usernm id_name
FROM users;

SELECT concat(userid, usernm) concat_id_name
FROM users;

--변수, 상수
--변수는 int a = 5; Stfrin msg = "HelloWorld";
--//변수를 이용한 출력
-- System.out.println(msg);
--//상수를 이용한 출력
--System.out.println("hello,world");

--SQL에서의 변수는 없음(컬럼이 비슷한 역할, pl/sql 변수 개념이 존재)
--SQL 에서 문자열 상수는 싱글 쿼데이션으로 표현
--"Hello, World" --> 'Hello, World'

--문자열 상수와 컬럼간의 결합
--user id : brown
--uwer id : cony
SELECT 'user id : ' || userid AS userid
FROM users;
--double quotation 적용 : 컬럼에 별칭을 사용할 때 공백을 사용할 수 없기 때문에 ""을 적용해 사용가능하다.
SELECT 'user id : ' || userid  "user id"
FROM users;

--현재 접속한 사용자가 소유한 테이블 목록을 조회
SELECT *
FROM USER_TABLES;

--문자열 결합을 이용하여 다음과 같이 조회 되도록 쿼리를 작성하라
SELECT * 
FROM emp;

SELECT concat(concat('SELECT * FROM', TABLE_NAME), ';')
FROM USER_TABLES;

--JAVA에서는 = 대입연산자이지만 SQL에서는 = equal이다.
--JAVA에서는 ==가 비교연산자이다.
--SQL에서는 대입의 개념이 없다(PL/SQL)

--users의 테이블의 모든 행에 대해서 조회
--users에는 5건의 제이터가 존재
SELECT *
FROM users;

--WHERE절 : 테이블에서 데이터를 조회할 때 조건에 맞는 행만 조회

--ex- userid 컬럼의 값이 brown인 행만 조회
--brown, 'brown' 구분
--컬럼, 문자열 상수
SELECT *
FROM users
WHERE userid = 'brown'; 
--DESC user

--userid가 brown이 아닌 행만 조회 (!=,<>의 연산자를 사용하면 된다.)
SELECT *
FROM users
WHERE userid != 'brown';

--emp테이블에 존재하는 컬럼을 확인 해보세요.
SELECT *
FROM emp;

--emp 테이블에서 ename컬럼 값이 JONES인 행만 조회
--SQL KEY WORD는 대소문자를 가리지 않지만 컬럼의 값이나, 문자열 상수는 대소문자를 가린다.
--'JONES','Jones'는 값이 다른 상수이다.
SELECT *
FROM emp
WHERE ename = 'JONES';

SELECT *
FROM emp; --employee

DESC emp;
--5 > 10 FALSE
--5 > 5 FALSE
--5 >= 5 TRUE

--emp테이블에서 deptno(부서번호)가 30보다 크거나 같은 사원들만 조회
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE deptno >= 30;

--문자열 : '문자열'
--숫자 : 50
--날짜 : ??? ->함수와 문자열을 결합하여 표현, 문자열만 이용하여 표현 가능 (권장하지 않음)
--      국가별로 날짜 표기 방법
--      한국 : 년도4자리-월2자리-일자2자리
--      미국 : 월2자리-일자2자리-년도4자리

--입사일자가 1980년 12월 17일 직원만 조회
SELECT *
FROM emp
WHERE hiredate = '80/12/17';
--TO_DATE : 문자열을 date타입으로 변경하는 함수
--TO_DATE(날짜 형식 문자열, 첫번째 인자의 형식)
--'1980/02/03'이 2월3일이지만 컴퓨터 입장에서 알 수 없다.
SELECT *
FROM emp
WHERE hiredate = TO_DATE('19801217','YYYYMMDD');

SELECT *
FROM emp
WHERE hiredate = TO_DATE('1980/12/17','YYYY/MM/DD');

--범위연산
--sal컬럼의 값이 1000에서 2000사이인 사람
--sal >=1000
--sal <=2000
SELECT *
FROM emp;

--AND 연사자의 사용법
SELECT *
FROM emp
WHERE sal>=1000 AND sal<=2000;

--범위연산자를 부등호 대신에 BETWEEN AND 연산자로 대체
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;
-- AND연산자는 계속 사용할 수 있다 (조건이 많아질수로 출력되는 데이터가 적어진다.)
SELECT *
FROM emp
WHERE sal>=1000 AND sal<=2000
AND deptno = 30;

--emp테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의 
--ename, hiredate 데이터를 조회하는 쿼리를 작성하시오
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01','YYYY/MM/DD') AND TO_DATE('1983/01/01','YYYY/MM/DD');

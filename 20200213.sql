--index 실습 idx4
--시스템에서 사용하는 쿼리가 다음과 같다고 할 때 적절한 emp, dept
--테이블에 필요하다고 생각되는 인덱스를 생성 스크립트를 만들어 보세요.

SELECT *
FROM emp
WHERE empno = :empno;
SELECT *
FROM dept
WHERE deptno = :deptno;
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND emp.deptno LIKE :deptno || '%';
SELECT *
FROM emp
WHERE sal BETWEEN :st_sal AND : ed_sal
AND deptno = :deptno;
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND dept.loc = :loc;

--access pattern
--empno(=)
--deptno(=)[dept]

--depno(=), empno(Like 직원번호) ==> empno, deptno
--deptno(=), sal(BETWEEN)

--deptno(=),loc(=)

--emp:    empno,(deptno,sal) 
--dept:   loc

--인덱스 생성
--empno, (deptno,sal,loc)
Create unique index idx_u_emp_01 ON emp(empno);
Create unique index idx_u_emp_02 ON emp(deptno,sal,loc);

----------------------------------------------------------------------------------------------------------------
--Synonym: 동의어
--1. 객체 별칭을 부여
--==>이름을 간단하게 표현
--
--LMH 사용자가 자신의 테이블 emp테이블을 사용해서 만든 v_emp view
--hr 사용자가 사용할 수 있게 끔 권한을 부여
--
--v_emp : 민감한 정보 sal, comn를 제외한 view
--
--hr 사용자 v_emp를 사용하기 위해 다음과 같이 작성
--SELECT *
--FROM LMH.v_emp;
--
--hr 계정에서
--Synonym lmh.v_emp ==> v_emp
--v_emp == lmh.v_emp
--
--SELECT *
--FROM v_emp;

--1. sem 계정에서 v_emp를 hr계정에서 조회할 수 있도록 조회권한 부여;

GRANT SELECT ON v_emp TO hr;

--2. hr 계정 v_emp 조회하는게 가능 (권한 1번에서 받았기 때문에)
--  사용시 해당 객체의 소유자를 명시 : sem.v_emp
--  간단하게 sem.v_emp -> v_emp 사용하고 싶은 상향
--  sysnonym 생성

--CREATE synonym 시노님이름 FOR 원래 객체명;

--synonym 삭제
--drop synonym 테이블;


--DCL(GRANT/REVOKE)
--오라클에 접속하기 위해 필요한 권한 : connect
--객체를 생성하기 위해 필요한 권한 : resource

--GRANT CONNECT ON LMH;
--GRANT CONNECT ON 객체명 TO HR;

--스키마 : 우리가 사용하는 것은 여러가지 객체들로 이루어져 있다.
--테이블도 객체 뷰도 객체 인덱스도 객체이다.
--이러한 객체들의 모임을 스키마라고 한다.



--사용자 추가
--CREATE USER lmh IDENTIFIED BY java
--DEFAULT TABLESPACE ts_lmh
--TEMPORARY TABLESPACE temp
--QUOTA UNLIMITED ON ts_LMH
--QUOTA 0m ON SYSTEM;

--비번 수정
--ALTER USER lmh IDENTIFIED BY java;




--오라클 시스템 : GRANT connect, resource to lmh
--            revoke resource from lmh
--오라클 객체 :  Grant select,insert ON emp TO lmh
--                revoke select,insert ON emp FROM lmh

--ROLE 생성
--CREATE ROLE role_name;
--ROLE 권한 등록
--GRANT CREATE TABLE TO role_name;
--ROLE 권한 회수
--REVOKE CREATE TABLE FROM rol_name;
--ROLE 권한 부여
--GRANT role_name to user_name;




--SEM 필기
--권한 종류
--1.시스템 권함 : TABLE을 생성, view 생성권한
--2.객체 권한 : 특정 객체에 대해 SELECT, UPDATE, INSERT, DELETE
--
--ROLE : 권한을 모아놓은 집합
--사용자별로 개별 권한을 부여하게 되면 관리의 부담
--특정 ROLE에 권한을 부여하고 해당 ROLE 사용자에게 부여
--해당 ROLE을 수정하게 되면 ROLE을 갖고 있는 모든 사용자에게 영향

--권한 부여/회수
--시스템 궘한 : GRANT 권한이름 TO사용자 | ROLE
--            REVOKE 권한 이름 FORM 사용자 | ROLE
--객체 권한 : GRANT 권한이름 ON 객체명 TO 사용자|: ROLE
--            REVOKE 권한 이름 ON 객체명 FROM 사용자 | ROLE


--data dictionary : 사용자가 관리하지 않고, dbms가 자체적으로 관리하는 시스템 정보를 담은 view
--
--data dictonary 접두어
--1.user : 해당 사용자가 소유한 객체
--2.all : 해당 사용자가 소유한 객체 + 다른 사용자로 부터 붕받은 객체
--3.DBA : 모든 사용자의 객체 
--
--* V$ 특수 VIEW;

SELECT *
FROM user_tables;

SELECT *
FROM all_TABLES;

SELECT *
FROM DBA_TABLES;

--DICTIONARY 종류 확인 : SYS.DICTIONARY


SELECT *
FROM DICTIONARY;
--대표적인 dictionary
--OBJECTS : 객체 정보 조회 (테이블, 인덱스, view, sysnonym...)
--TABLE : 테이블 정보만 조회
--TAB_COLUMN : 테이블의 컬럼 정보 조회
--INDEXES : 인덱스 정보 조회
--IND_COLUMNS : 인덱스 구성 컬럼조회
--CONSTRAINTS : 제약 조건 조회
--CONS_COLUMNS : 제약조건 구성 컬럼 조회
--TAB_COMMENTS : 테이블 주석
--COL_COMMENTS  : 테이블의 컬럼 주석


--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★--
--emp, dept테이블의 인덱스와 인덱스 컬럼 정보 조회
--USER_indexes, USER_ind_column join
--테이블명, 인덱스명, 컬럼명
--emp       ind_n_emp_04    ename
--emp       ind_n_emp_04    job
SELECT *
FROM user_indexes a , user_ind_columns b
WHERE a.index_name = b.index_name 
AND a.table_name IN ('EMP','DEPT');

SELECT table_name, index_name, column_name
FROM user_ind_columns
ORDER bY table_name, index_name, column_position;
--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★--




--part3 SQL응용
--multiple insert : 하나의 insert 구문으로 여러 테이블에 데이터를 입력하는 DML
SELECT *
FROM dept_test;

SELECT *
FROM dept_test2;

--동일한 값을 여러 테이블에 동시 입력하는 multiple insert
INSERT ALL
        INTO dept_test
        INTO dept_test2
SELECT 96,'대덕','중앙로'FROM dual UNION ALL
SELECT 97,'IT','영민'FROM dual;

--테이블에 입력할 컬럼을 지정하여 multiple insert
ROLLBACK;
INSERT ALL
        INTO dept_test (deptno, loc) VALUES(deptno,loc)
        INTO dept_test2
SELECT 98 deptno,'대덕' dname ,'중앙로' loc FROM dual UNION ALL
SELECT 97,'IT','영민'FROM dual;


--테이블에 입력할 데이터를 조건에 따라 multiple insert;
--CASE
--    WHEN 조건기술   THEN
--END
ROLLBACK;
INSERT ALL
    WHEN deptno = 98 THEN
        INTO dept_test (deptno, loc) VALUES(deptno,loc)
    ELSE
        INTO dept_test2
SELECT 98 deptno,'대덕' dname ,'중앙로' loc FROM dual UNION ALL
SELECT 97,'IT','영민'FROM dual;

--deptno = 98인 경우 실행문
ROLLBACK;
INSERT ALL
    WHEN deptno = 98 THEN
        INTO dept_test (deptno, loc) VALUES(deptno,loc)
        into dept_test2
    ELSE
        INTO dept_test2
SELECT 98 deptno,'대덕' dname ,'중앙로' loc FROM dual UNION ALL
SELECT 97,'IT','영민'FROM dual;




--조건을 만족하는 첫번째 insert만 실행하는 multiple insert
--INSERT FIRST 는 조건을 만족하는 첫번째 녀석만 실행한다.
ROLLBACK;
INSERT FIRST
    WHEN deptno >= 98 THEN
        INTO dept_test (deptno, loc) VALUES(deptno,loc)
    WHEN deptno >= 97 then
        into dept_test2
    ELSE
        INTO dept_test2
SELECT 98 deptno,'대덕' dname ,'중앙로' loc FROM dual UNION ALL
SELECT 97,'IT','영민'FROM dual;


--1억개
--파티션
--오라클 객체 : 테이블에 여러개의 구역을 파티션으로 구분
--테이블 이름은 동일하나 값의 종류에 따라 오라클 내부적으로 별도의 분리된 영역에 데이터를 저장;

--dept_test =>dept_test_20200201
--물리적으로 데이터를 분산시킨다.

--유지관리가 힘들다 테이블명에 날짜 붙이면...
--이름은 값은데 내부적으로 별도로 관리를 해주면 편하다.
--익스프레션버젼에서는 제공을 안한다.(오라클 무료버전)
INSERT FIRST
    WHEN deptno >= 98 THEN
        INTO dept_test_20200201
    WHEN deptno >= 97 then
        into dept_test2_20200202
    ELSE
        INTO dept_test2
SELECT 98 deptno,'대덕' dname ,'중앙로' loc FROM dual UNION ALL
SELECT 97,'IT','영민'FROM dual;


--MERGE : 통합
--상황 : 테이블에 데이터를 입력/갱신 하려고 함
--1.만약에 내가 입력하려고 하는 데이터가 존재하면 -> 업데이트를 해주어야 함
--2.내가 입력하려고 하는 데이터가 존재하지 않으면 ->INSERT해주어야 함

--1.SELECT쿼리를 실행을 하고 
--2.그 결과가 없으면(row0) INSERT하면 됨
--2-1. 그 결과가 있으면(row1) update하면 됨

--MERGE 구문을 사용하게 되면 SELECT 를 하지 않아도 자동으로 데이터 유무에 따라 
--INSERT 혹은 UPDATE실행한다.
--2번의 쿼리를 한번으로 준다.

--<<MERGE 사용법>>
--MERGE INTO 테이블명 [alias]
--USING (TABLE | VIEW | IN-LINE-VIEW)
--ON (조인조건)                         
--WHEN MATCHED THEN    (만약에 여기서 만족하는 데이터가 있다면)
--  UPDATE SET coll = 컬럼값, col2 = 컬럼값
--WHEN NOT MATCHED THEN        (만약에 여기서 만족하는 데이터가 없다면)
--  INSERT (컬럼1, 컬럼2, 컬럼3...)VALUES (컬럼값1, 컬럼값2....);


DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno number(4),
    ename varchar2(10),
    deptno number(2),
    hp  varchar2(20)
);
ALTER TABLE emp_test MODIFY (hp DEFAULT '010');


SELECT *
FROM emp_test;

DELETE emp_test;

--로그를 안남긴다. ==>복구가 안된다 -->테스트 용으로 많이 씀
TRUNCATE TABLE emp_test;

--emp테이블에서 emp_test테이블로 복사한다.(7369-SMITH)

INSERT INTO emp_test
SELECT empno, ename, deptno, '010'
FROM emp
WHERE empno = 7369;

--데이터가 잘 입력 되었는지 확인;
SELECT *
FROM emp_test;

UPDATE emp_test SET ename = 'brown'
WHERE empno = 7369;

COMMIT;

--emp테이블의 모든 직원을 emp_test테이블로 통합을 하자
--emp테이블에는 존재하지만 emp_test에는 존재하지 않으면 insert
--emp테이블에는 존재하고 emp_test에는 존재하면 ename, deptno를 update


--emp테이블에 존재하는 14건의 데이터중 emp_test에도 존재하는  7369 를 제외한 13건의 데이터가 
--emp_test 테이블에 신규로 입력이 되고
--emp_test에 존재하는 7369번의 데이터는 ename(brown)이 emp 테이블에 존재하는 이름인 SMITH로 갱신
MERGE INTO emp_test a
USING emp b
ON (a.empno= b.empno)
WHEN MATCHED THEN
    update set a.ename = b.ename,
                a.deptno = b.deptno
WHEN NOT MATCHED THEN
    INSERT (empno, ename, deptno) VALUES (b.empno, b.ename, b.deptno);

SELECT *
FROM emp_test;


--해당 테이블에 데이터가 있으면 insert, 없으면 update
--emp_test테이블에 사번이 9999번인 사람이 없으면 새롭게 insert
--있으면 update
--(9999,'brown',10,'010')

INSERT INTO emp_test VALUES (9999,'brown',10,'010');

UPDATE emp_test SET ename = 'brown',
                    deptno = 10,
                    hp = '010'
WHERE empno = 9999;

SELECT *
FROM emp_test;


MERGE INTO emp_test
USING dual
ON (empno = 9999)
WHEN MATCHED THEN
    UPDATE SET ename = 'brown',
                deptno = 10,
                hp = '010'
WHEN NOT MATCHED THEN
    INSERT VALUES (9999,'brown',10,'010');


SELECT *
FROM emp_test;
--MERGE, window function(분석함수)

--report group funcion
--부서별 합계, 전체 합계를 다음과 같이 구하려면??(실습(group_ad1)
SELECT deptno,sum(sal)
FROM emp
GROUP BY deptno
ORDER BY deptno;

SELECT deptno, sum(sal)
FROM emp
GROUP BY deptno
union 
SELECT null ,sum(sal)
FROM emp;
--소계와 전체합을 합쳤다.



--I/O
--CPU CASHE > RAM > SSD > HDD > NETWORK
--REPORT GROUP FUNCTION
--ROLLUP
--CUBE
--GROUPING;

--ROLLUP
--사용방법 : GROUP BY ROLLUP (컬럼1, 컬럼2......)
--SUBGROUP을 자동적으로 생성
--SUBGROUP 을 생성하는 규칙 : ROLLUP에 기술한 컬럼을 오른쪽에서부터 하나씩 제거하면서
--                        SUB GROUP을 생성

-- EX : GROUP BY ROLLUP (deptno)
-->
--첫번째 sub group : group BY deptno
--두번째 sub group : group BY null -> 전체 행을 대상
SELECT deptno, sum(sal)
FROM emp
GROUP BY ROLLUP (deptno);
--서브그룹을 생성


SELECT job, deptno, sum(sal+NVL(comm, 0))sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--GROUP BY job, deptno    : 담당업무, 부서별 급여합
--GROUP BY job            : 담당업무별 급여합
--GROUP BY                : 전체 급여함

SELECT case grouping(job)
            WHEN 1 THEN '총합'
        ELSE job
        END job, 
        deptno,
        grouping(job),grouping(deptno),
        sum(sal+NVL(comm, 0))sal
        
FROM emp
GROUP BY ROLLUP (job, deptno);

--GROUP_AD2
--grouping을 사용해서 값이 null값인지 확인하여 보기좋게 만들수가 있다.
SELECT case grouping(job)
            WHEN 1 THEN '총계'
        ELSE job
        END job, 
        deptno,
        sum(sal+NVL(comm, 0))sal
FROM emp
GROUP BY ROLLUP (job, deptno);

SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '총계'
        else job
        END job,
        deptno,
        sum(sal+NVL(comm, 0))sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--DECODE로 하면 어떻게 하면 될까?
SELECT 
    DECODE (GROUPING(job),1,'총계',0,job)job,
    deptno,
    sum(sal+NVL(comm, 0))sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--decode에서 인덱스 를 가지고 올수 있을 까?
--CREATE index idx_test ON emp(job);       --JOB컬럼을 기준으로 인덱스를 만듬
--idx_test를 가지고 오면 


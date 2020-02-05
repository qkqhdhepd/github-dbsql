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
WHERE deptno NOT IN (select deptno
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
-------↓↓↓↓↓↓↓↓↓--sem 답-- ↓↓↓↓↓↓↓↓↓↓----
SELECT *
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
                FROM cycle
                WHERE cid = 2);
----------↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑-----------------                
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
WHERE a.pid  IN (SELECT pid
                FROM cycle
                WHERE cid = 2)
AND a.cid = 1
ORDER BY a.day desc;

--sem 스칼라서브쿼리-----이거는 쓰지말도록 하자(권장하지않음)
SELECT cycle.cid, (SELECT cnm FROM customer WHERE cid = cycle.cid)cnm,
        cycle.pid, (SELECT pnm FROM product WHERE pid = cycle.pid)pnm,
        cycle.day, cycle.cnt
FROM cycle
WHERE cid = 1
AND pid IN(SELECT pid
            FROM cycle
            WHERE cid = 2);

-------------------------------------------------------------
--EXISTS 연산자
--매니저가 존재하는 직원을 조회(KING 을 제외한 13명의 데이터가 조회)
SELECT *
FROM emp
WHERE mgr IS NOT null;

--EXISTS 조건에 만족하는 행이 존재하는지 확인하는 연산자
--다른 연산자와 다르게 WHERE절에 컬럼을 기술하지 않는다.
--  WHERE empno = 7369
--  WHERE EXISTS(SELECT 'x'
--                FROM ......);

--매니저가 존재하는 직원을 EXISTS연산자를 통해 조회
--매니저도 직원
--EXISTS연산자를 사용하기 위해 억지로 만든 예
SELECT *
FROM emp a
WHERE EXISTS(SELECT 'x'
            FROM emp b
            WHERE b.empno = a.mgr);










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

--서브쿼리(실습 sub9)
--cycle, product, 테이블을 이용하여 cid = 1 인 고객이 애음하는 제품을 조회하는
--쿼리를 EXISTS 연산자를 이용하여 작성하세요.
SELECT a.pid, b.pnm
FROM cycle a join product b on a.pid = b.pid
WHERE cid = 1
group by a.pid, b.pnm;


SELECT a.pid, b.pnm
FROM cycle a, product b
WHERE EXISTS (SELECT 'x'
                FROM product b
                WHERE cid = 1)
AND a.pid = b.pid
group by a.pid,b.pnm;

------sem------↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
SELECT *
FROM product
WHERE EXISTS(SELECT 'x'
            FROM cycle
            WHERE cid = 1
            AND cycle.pid = product.pid);
--EXISTS의 이용 순서는 상호쿼리를 사용하는것이 기본으로 권장하고
--결과값의 컬럼을 확인한후 메인 테이블을 선정
--서브쿼리에서는 조건에 해당하는 테이블을 이용한다.
--서브쿼리 조건절에 원하는 (join에 해당하는 조건절을 )을 사용한다.


--실습sub10
--cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하지 않는 제품을 
--조회하는 쿼리를 EXISTS 연산자를 이용하여 작성하세요.
SELECT *
FROM product
WHERE NOT EXISTS(SELECT 'x'
            FROM cycle
            WHERE cid = 1
            AND cycle.pid = product.pid);
            
            

--집합연산
--UNION
--합집합, 중복을 제거(집합개념)
--UNION ALL
--합집합, 중복을 제거하지 않음(속도향상) =>union 연산자에 비해 속도가 빠르다
--INTERSECT
--교집합 : 두 집합의 공통된 부분
--MINUS
--차집합 : 한 집합에만 속하는 데이터
--집합연산 공통사항
--두 집합의 컬럼의 개수, 타입이 일치해야한다.

--동일한 집합을 합집하기 때문에 중복되는 데이터틑 한번만 적용된다.
SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698,7369)

UNION

SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698);

--UNION ALL
--UNION 연사자와 다르게 중복을 허용한다.
SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698,7369)

UNION ALL

SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698);


--INTERSECT
--위 아래 집합중 중복되는 데이터를 조회한다.
SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698,7369)

INTERSECT

SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698);


--MINUS 
--차집합 : 위 집합에서 아래 집합의 데이터를 제거한 나머지 집합
SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698,7369)

MINUS

SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698);


--집합의 기술 순서가 영향이 가는 집합연산자
--A UNION B      B UNION A ==>같음
--A UNION ALL B  B UNION ALL A ==>같음(집합)
--A INTERSECT B  B INTERSECT A ==>같음
--A MINUS B      B MINUS A  ==>다름

--집합연산의 결과 컬럼 이름은 첫번째 집합의 컬럼명을 다른다.
SELECT 'X'fir,'B'sec
FROm dual

UNION

SELECt 'Y'fir,'A'fir
FROM dual;

--정렬 ORDER BY 는 집합연산 가장 마지막 집합 다음에 기술한다.
SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (10, 20)

UNION
--UNION ALL

SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (30, 40)
ORDER BY deptno;


--햄버거 도시 발전지수;
SELECT *
FROM fastfood;

--시도, 시군구, 버거지수
--시도별로 kfc를 조회
select a.gb,a.sido,a.sigungu
FROM fastfood a
WHERE a.gb = 'KFC'
group by a.gb,a.sido, a.sigungu

UNION ALL

select a.gb,a.sido,a.sigungu
FROM fastfood a
WHERE a.gb = '맘스터치'
group by a.gb,a.sido, a.sigungu

UNION ALL

select a.gb,a.sido,a.sigungu
FROM fastfood a
WHERE a.gb = '맥도날드'
group by a.gb,a.sido, a.sigungu;

UNION aLL

select a.gb,a.sido,a.sigungu
FROM fastfood a
WHERE a.gb = '롯데리아'
group by a.gb,a.sido, a.sigungu;



--fast food지점의 중복을 제외한 전체의 도시와 군구
SELECT a.sido, a.sigungu
FROM fastfood a
group by a.sido, a.sigungu;

--fast food지점 개개의 도시에서 가지고 있는 gb
SELECT b.gb
FROM fastfood b
WHERE (SELECT a.sido, a.sigungu
        FROM fastfood a
        group by a.sido, a.sigungu)
GROUP BY b.gb;

SELECT gb
FROM fastfood 
group by gb;




--시군구별

SELECT *
FROM fastfood;

--대전광역시의 구별로 존재하는 햄버거 가게를 표시함
--대전광역시의 총 구별로 지점의 개수와 상관없이 분자의 햄버거가게의 수(롯데리아를 제외한)
SELECT a.sigungu,nm,count(a.nm)
FROM (
        SELECT sigungu, gb, nm, count(nm)
        FROM fastfood
        WHERE sido ='대전광역시'
        AND gb IN('KFC','버거킹', '맘스터치','맥도날드','파파이스')
        group by sigungu, gb, nm
        ORDER BY SIGUNGU
        )a
GROUP BY a.sigungu,nm;






SELECT sigungu, gb, nm, count(nm)
        FROM fastfood
        WHERE sido = '대전광역시'
        AND gb IN('KFC','버거킹', '맘스터치','맥도날드','파파이스')
        group by sigungu, gb, nm
        ORDER BY SIGUNGU;

SELECT *
FROM fastfood;

--대전광역시의 구별 버거지수



SELECT sigungu, gb, nm
FROM fastfood
WHERE sido ='서울특별시'
AND gb IN('KFC','버거킹', '맘스터치','맥도날드','파파이스')
group by sigungu, gb, nm
ORDER BY SIGUNGU;


SELECT SIDO, SIGUNGU
FROM tax;

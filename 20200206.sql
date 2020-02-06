SELECT *
FROM
            (SELECT  a.sido, a.sigungu,  round(a.cnt/b.cnt,2) 버거지수            
            FROM
                (SELECT sido, sigungu, COUNT(*) cnt
                 FROM fastfood
                 WHERE gb IN ('KFC', '버거킹', '맥도날드')
                GROUP BY SIDO, SIGUNGU )a
             ,
                 (SELECT  sido, sigungu, COUNT(*) cnt
                    FROM fastfood
                    WHERE gb IN ('롯데리아')
                    GROUP BY SIDO, SIGUNGU) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu
            ORDER BY 버거지수 DESC);
            
-----------a가 140개 b가 188개가 나오는데 이는 kfc따로 맥도날드 따로 버거킹 따로 구해서 조인하면 누락되는 경우가 생긴다.
----이는 경우에 따라 또는 생각하는거에 따라서 누락이 될수도 있고 아닐수도 있다.
SELECT a.sido, a.sigungu, round(a.cnt/b.cnt,2) 버거지수
    FROM 
    (SELECT SIDO, sigungu, count(*) cnt
    FROM fastfood
    WHERE gb IN ('KFC','맥도날드','버거킹')
    GROUP BY SIDO, sigungu) a
    ,
    (SELECT SIDO, sigungu, count(*) cnt
    FROM fastfood
    WHERE gb IN ('롯데리아')
    GROUP BY SIDO, sigungu) b
WHERE a.sido = b.sido AND a.sigungu = b.sigungu
ORDER BY 버거지수 DESC;
----------------------------------------------------------------------------

--대전시에 있는 5개의 구 햄버거 지수
--(kfc+버거킹+맥도날드)/롯데리아
SELECT sido, count(*)
FROM fastfood
WHERE sido LIKE '%대전%'
GROUP BY sido;

--분자(KFC, 버거킹, 맥도날드)
SELECT sido, sigungu, count(*)
FROM fastfood
WHERE sido = '대전광역시'
AND gb IN ('버거킹','KFC','맥도날드')
GROUP BY sido, sigungu;

--분모(롯데리아)
SELECT sido, sigungu, count(*)
FROM fastfood
WHERE sido = '대전광역시'
AND gb IN ('롯데리아')
GROUP BY sido, sigungu;

SELECT a.sido, a.sigungu, round(a.cnt/b.cnt,2)
FROM 
    (SELECT sido, sigungu, count(*)cnt
    FROM fastfood
    WHERE sido = '대전광역시'
    AND gb IN ('버거킹','KFC','맥도날드')
    GROUP BY sido, sigungu) a
    ,
    (SELECT sido, sigungu, count(*)cnt
    FROM fastfood
    WHERE sido = '대전광역시'
    AND gb IN ('롯데리아')
    GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu;
  
--fastfood 테이블을 한번만 읽는 방식으로 작성하라

SELECT sido, sigungu, ROUND((kfc+burgerking+mac)/lot,2)burger_score
FROM
    (SELECT sido, sigungu, 
                    NVL(sum(DECODE(gb, 'KFC', 1)),0)kfc,  
                    NVL(sum(DECODE(gb, '버거킹',1)),0)burgerking,
                    NVL(sum(DECODE(gb, '맥도날드',1)),0) mac,
                    NVL(sum(DECODE(gb, '롯데리아',1)),1) lot
    FROM fastfood
    WHERE gb IN('kfc','버거킹','맥도날드','롯데리아')
    GROUP BY sido, sigungu)
ORDER BY burger_score DESC;


-----------------------------------------------------------------
SELECT sido, sigungu, round(sal/people)pri_sal
FROM tax
ORDER BY pri_sal DESC;

/*
햄버거 지수, 개인별 근로소득 금액 순위가 같은 시도별로(조인)
지수, 새인별 근로소득 금액으로 정렬 후 ROWnum을 통해 순위를 부여

햄버거 지수 시도, 햄버거지수 시군구, 햄버거지수, 세금시도, 세금 시군구, 개인별 근로소득액

서울특별시   중구 5.67     서울특별시   강남구     70
서울특별시   도봉구 5       서울특별시   서초구     69
경기도     구리시 5       서울특별시   용산구     57
서울특별시   강남구       경기도         과천시     54
서울특별시   서초구     서울특별시       종로구     47
*/
----------------------------------------------------------
SELECT a.*, b.*
FROM 
    (SELECT a.*, ROWNUM RN 
     FROM
        (SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l,
               round(a.cnt/b.cnt, 2) 버거지수
        FROM 
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
             FROM fastfood
             WHERE gb IN ('KFC', '버거킹', '맥도날드')
             GROUP BY SIDO, SIGUNGU) a
            ,
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
             FROM fastfood
             WHERE gb IN ('롯데리아')
             GROUP BY SIDO, SIGUNGU) b
        WHERE a.sido = b.sido
        AND a.sigungu = b.sigungu
        ORDER BY 버거지수 DESC )a ) a,
    
        (SELECT b.*, rownum rn
         FROM 
            (SELECT sido, sigungu, round(sal/people)pri_sal
             FROM TAX
             ORDER BY pri_sal DESC) b ) b
WHERE b.rn = a.rn
ORDER BY b.rn;


--DML
DESC emp;
--무별성 제약조건
--empno값은 무조건 들어가있어야 함으로 NOT NULL로서 설정을 해줘야 한다.
--empno컬럼은 not null 제약 조건이 있다 - INSERT 시 반드시 값이 존재해야 정상적으로 입력된다.
--empno컬럼을 제외한 나머지 컬럼은 NULLABLE 이다(nullㄱ밧이 저장될 수 있다)
INSERT INTO emp (empno, ename, job)
VALUES (9999, 'brown',NULL);

SELECT *
FROM emp;

INSERT INTO emp (ename,job)
VALUES ('sally','SALESMAN');
/*명령의 152 행에서 시작하는 중 오류 발생 -
INSERT INTO emp (ename,job)
VALUES ('sally','SALESMAN')
오류 보고 -
ORA-01400: cannot insert NULL into ("LMH"."EMP"."EMPNO")*/


--문자열 : '문자열' => "문자열"
--숫자 : 10
--날짜 : TO_DATE('20200206','YYYYMMDD'), SYSDATE
--emp 테이블의 hiredate 컬럼은 date타입이다.
--emp 테이블의 8개의 컬럼에 값을 입력
DESC emp;
INSERT INTO emp VALUES(9998,'sally','SALESMAN',NULL, SYSDATE, 1000, NULL, 99);

SELECT *
FROM emp;

ROLLBACK;

--여러개의 데이터를 한번에 INSERT : 
--INSERT INTO 테이블명 (컬럼명1,컬럼명2 ....)
--SELECT ...
--FROM

INSERT INTO emp
SELECT 9998,'sally','SALESMAN',NULL, SYSDATE, 1000, NULL, 99
FROM dual
    UNION ALL 
SELECT 9999,'brown','CLERK',NULL,TO_DATE('20200205','YYYYMMDD'),1100,null,99
FROM dual;

SELECT *
FROM emp;

--UPDATE 쿼리
--UPDATE 테이블명 SET 컬럼명1 = 갱신할 컬럼 값1, 컬럼명2 = 갱신할 컬럼 값2...
--WHERE 행 제한 조건;
--업데이트 쿼리 작성시WHERE 절이 존재하지 않으면 해당 테이블의 모든 행을 대상으로 업데이트가 일어난다.
--UPDATE, DELETE절에 WHERE절이 없으면 의도한게 맞는지 다시 한번 확인한다.


--WHERE 절이 있다고 하더라도 해당 조건으로 해당 테이블을 SELECT 하는 쿼리를 작성하여 실행하면
--UPDATE대상 행을 조회 할수 있으므로 확인하고 실해하는 것도 사고 발생 방지에 도움이 된다.

--99번 부서번호를 갖는 부서 정보가 DEPT 테이블에 있는 상황
INSERT INTO dept VALUES (99,'ddit','daejeon');
commit;

SELECt *
FROM dept;

--99번 부서번호를 갖는 부서의 dname컬럼의 값을 '대덕 IT',loc 컬럼의 값을 '영민빌딩'으로 업데이트
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99;

SELECT *
FROM dept
WHERE deptno = 99;
ROLLBACK;
    
--실수로 WHERE절을 기술하지 않았을 경우
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩';
--WHERE deptno = 99;

--선생님의 첫번째 (신입사원 때) 실수
--여사님 - 시스템 번호를 잊어먹음 =>한달에 한번씩 모든 여사님을 대상으로
                                -->본인 주민번호 뒷자리로 비밀번호를 업데이트
--시스템 사용자 : 여사님(12,000), 영업점(550), 직원(1,1300)
--update 사용자 SET 비밀번호 = 주민번호뒷자리;

--뭐가 문제였을까?
--우선 where절이 없었고, 주민번호뒷자리가null값이었다. 고로 비밀번호도 null로 됨
--UPDATE 사용자 SET 비밀번호 = 주민번호 뒷자리
--WHERE 사용자 구분 = '여사님'
--commit;

--데이터를 삭제하는 프로그램

--10 -> subQUERY
--SMITH,WARD이 속한 부서에 소속된 직원 정보
SELECT *
FROM emp
WHERE deptno IN(20,30);

SELECT *
FROM emp
WHERE deptno IN(SELECT deptno
                FROM emp
                WHERE ename IN('SMITH','WARD'));
--update에서도 서브 쿼리 사용이 가능하다.
INSERT INTO emp (empno, ename)VALUES(9999,'brown');
--9999번 사원 deptno, job 정보를 SMITH 사원이 속한 부서정보, 담당업무로 업데이트
UPDATE emp SET deptno = (SELECT deptno
                        FROM emp
                        WHERE ename IN('SMITH')),
                job = (select job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;

SELECT *
FROM emp;

ROLLBACK;


--DELETE SQL : 특정 행을 삭제
--DELETE (FROM)
--WHERE 행 제한 조건
SELECT *
FROM dept;

--99번 부서번호에 해당하는 부서 정보 삭제
DELETE dept
WHERE deptno = 99;

SELECT *
FROM dept;

commit;


--SUBQUERY를 통해서 특정 행을 제한하는 조건을 갖는 DELETE
--매니저가 7499,7521,7654,7844,7698사번인 직원을 삭제하는 쿼리를 작성;
SELECT *
FROM emp;

--DELETE emp
--WHERE mgr IN(7499,7521,7654,7844,7698);

DELETE emp
WHERE empno IN(SELECT empno
                FROM emp
                WHERE mgr = 7698);
                
SELECT *
FROM emp;

ROLLBACK;


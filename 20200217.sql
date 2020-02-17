:dt ==> 202002;
SELECT
	DECODE(d,1,iw+1, iw) i
	,MIN (DECODE(d,1,dt)) sun
	,MIN (DECODE(d,2,dt)) mon
	,MIN (DECODE(d,3,dt)) tue
	,MIN (DECODE(d,4,dt)) wed
	,MIN (DECODE(d,5,dt)) tur
	,MIN (DECODE(d,6,dt)) fri
	,MIN (DECODE(d,7,dt)) sat
	
FROM
	(
		SELECT
			TO_DATE(:dt,'yyyymm')-(To_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1)+(level -1)dt,
			,TO_CHAR(TO_DATE(:dt,'yyyymm')) - (To_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1)+(level -1),'D') d
			,TO_CHAR(TO_DATE(:dt,'yyyymm')) - (To_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1)+(level -1),'iw') iw
		FROM
			dual
		CONNECT BY
			level <= LASt_DAY(TO_DATE(:dt, 'yyyymm'))+(7 - TO_CHAR(LAST_DAY(TO_DATE(:dt,'yyyymm')),'D'))
					-(TO_DATE(:dt,'yyyymm')-(TO_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1))
	)

GROUP BY DECODE(d,1,iw+1, iw)
ORDER BY DECODE(d,1,iw+1, iw);

--dt-(dt-1),
--NEXT_DAY(dt2,7);

--1.해당 월의 1일자가 속한 주의 일요일 구하기 2020-03-29
--2. 해당 월의 마지막 일자가 속한 주의 토요일 구하기

--1일자의 주가 수요일이면 -3
--이때의 주가 
----------------------------------------------sem--------------------------------------
SELECT 
	TO_DATE(:dt,'yyyymm')-(To_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1)st,
	LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAy(TO_DATE(:dt,'yyyymm')),'D'))ed,
	LAST_DAY(TO_DATE(:dt,'yyyymm')) + (7- TO_CHAR(LAST_DAy(TO_DATE(:dt,'yyyymm')),'D'))
			-(TO_DATE(:dt,'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'),'D')))
	
FROM dual;
----------------------------------------------------------------------------------------

--기존 : 시작일자 1일, 마지막 날짜 : 해당 월의 마지막 일자;
SELECT TO_DATE('202002','yyyymm')+(level-1)
FORM dual
CONNECT By LEVEL <=29;

--변경 : 시작일자 : 해장월의 1일자가 속한 주의 일요일
--		마지막일 자 : 해당월의 마지막일자가 속한 주의 토요일
SELECT TO_DATE('202002','yyyymm')+(level-1)
FROM dual
CONNECT BY LEVEL <= 35;


SELECT 
        TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) st,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                      - ( TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D'))) daycnt
FROM dual;  

SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  last_day(to_date(:dt,'yyyymm'))+(7-to_char(last_day(to_date(:dt,'yyyymm')),'D'))
                    -to_date(:dt,'yyyymm')-(to_char(to_date(:dt,'yyyymm'),'D')-1)  )
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);    


---------------------------------------------------최종--------------------------------------
원본쿼리 1일~말일자;
SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm')  + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm')  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  TO_CHAR(last_day(to_date(:dt,'yyyymm')), 'DD'))
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);
 

1일자가 속한 주의 일요일구하기
마지막일자가 속한 주의 토요일구 하기
일수 구하기; 
SELECT 
        TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) st,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                      - ( TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D'))) daycnt
FROM dual;      


1일자, 말일자가 속한 주차까지 표현한 달력
SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  last_day(to_date(:dt,'yyyymm'))+(7-to_char(last_day(to_date(:dt,'yyyymm')),'D'))
                    -to_date(:dt,'yyyymm')-(to_char(to_date(:dt,'yyyymm'),'D')-1)  )
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);


-----------------------------------------------------------
SELECT
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM (
		SELECT 
			TO_DATE(:YYYYMM,'YYYYMM')+(LEVEL -1)dt,
			TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (LEVEL -1),'d')d,
			TO_DATE(:YYYYMM,'YYYYMM')+(LEVEL -1) -TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM')+(LEVEL - 1),'d')+1 f_sun
		FROM dual
		CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')),'DD'))
	GROUP BY f_sun
	ORDER BY f_sun;
		
	------------------------------------pt	
		
		


SELECT  dt
FROM sales
WHERE dt IN( '2019/01/03','2019/01/15');

DESC sales;

SELECT TO_CHAR(TO_DATE(dt,'YYYY/MM/dd'))
FROM sales;

CONNECT BY LEVEL <2;


SELECT *
FROM sales;


SELECT 
	DECODE(dt1,1, sales) a,
	DECODE(dt1,2, sales) b,
	DECODE(dt1,4, sales) c,
	DECODE(dt1,5, sales) d,
	DECODE(dt1,6, sales) e,
FROM
(SELECT dt1,sum(sales)
FROM 
(SELECT 
	DECODE(dt, '2019/01/03',1,'2019/01/15',1,'2019/02/17',2,'2019/02/28',2,'2019/04/05',4
	,'2019/04/20', 4,'2019/05/11', 5,'2019/05/30', 5,'2019/06/22', 6,'2019/06/27', 6)dt1
	, sales
FROM sales)
GROUP BY dt1
ORDER BY dt1);
---------------------------sem---------------------------------------------------
1.dt(일자) =>월, 월단위별 sum(sales) -> 월의 수만큼 행이 그룹핑이 된다.
SELECT 
		SUM(jan)jan,
		SUM(feb)feb,
		NVL(sum(mar),0) mar,
		SUM(apr)apr,
		SUM(may)may,
		SUM(jun)jun,
		/*sum(NVL(jun,0))jun2*/          
FROM 
(SELECT DECODE(TO_CHAR(dt,'mm'),'01',sum(sales))JAN,
	    DECODE(TO_CHAR(dt,'mm'),'02',sum(sales))FEB,
		DECODE(TO_CHAR(dt,'mm'),'03',sum(sales))MAR,
	    DECODE(TO_CHAR(dt,'mm'),'04',sum(sales))APR,
	    DECODE(TO_CHAR(dt,'mm'),'05',sum(sales))MAY,
	    DECODE(TO_CHAR(dt,'mm'),'06',sum(sales))JUN
FROM sales
GROUP by TO_CHAR(dt,'mm'));



------------------계층쿼리(Oracle)
--오라클에서 제공하는 매리트있는 시스템
--select.....
--FROM ......
--WHERE
--START WITH 조건 : 어떤 행을 시작점으로 삼을지
--CONNECT BY 행과 행을 연결하는 기준
--	PRIOR : 이미 읽은 행
--	'    ': 앞으로 읽을 행

--계층쿼리문에서 WHERE절을 읽기 전에 계층쿼리를 먼저 읽음
--1. 하향식
--가장 상위에서 자식노드로 연결
--2. 상향식
--
--차이점 하샹식은 밑에있는 자식노드를 다 읽는데 상향식은 자신의 부모노드만 읽는다.

SELECT *
FROM dept_h;

--XX회사(최상위 조직) 에서 시작하여 하위 부서로 내려가는 계층 쿼리
/*
SELECT *
FROM dept_h
START WITH
	deptcd = 'dept0'
--START WITH
--	deptnm = 'XX회사'
--START WITH
--	p_deptcd IS null
CONNECT BY : 행과 행의  연결 조건 (PRIOR XX회사 = 3가지 부(디자인부, 정보기획부, 정보시스템부))
;*/
SELECT *
FROM dept_h
START WITH
	deptcd = 'dept0'
--START WITH
--	deptnm = 'XX회사'
--START WITH
--	p_deptcd IS null
CONNECT BY PRIOR deptcd = p_deptcd ;
--: 행과 행의  연결 조건 (PRIOR XX회사 = 3가지 부(디자인부, 정보기획부, 정보시스템부))
--1.디자인부에 대한 계층쿼리를 함
PRIOR XX회사.deptcd = 디자인부.p_deptcd
PRIOR 디자인부.deptcd = 디자인팀. p_deptcd

--2.정보기획부
PRIOR XX회사.deptcd = 정보기획부.p_deptcd
PRIOR 정보기획부.deptcd = 기획팀.p_deptcd
PRIOR 기획팀.deptcd = 기획파트.p_detpcd

--3.정보시스템부
PRIOR XX회사.deptcd = 정보시스템부.p_deptcd (개발1팀, 개발2팀)
PRIOR 정보시스템부.deptcd = 개발1팀.p_deptcd
PRIOR 개발1팀.deptcd = .......
PRIOR 정보시스템부.deptcd = 개발2팀.p_deptcd
PRIOR 개발2팀.deptcd = .......;

--계층쿼리(실습 h_1)
SELECT LPAD('HELLO, WORLD', 15, '*')"LPAD"
FROM dual;

SELECT dept_h.*, level, lpad(' ', (LEVEL-1)*4, ' ') || deptnm
FROM dept_h
START WITH	deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd ;
--CONNECT BY deptcd =PRIOR p_deptcd ;

--실습 h_2
SELECT level lv,deptcd,(lpad(' ', (LEVEL-1)*4, ' ') || deptnm)deptnm,p_deptcd
FROM dept_h
START WITH	deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd ;

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

--1.�ش� ���� 1���ڰ� ���� ���� �Ͽ��� ���ϱ� 2020-03-29
--2. �ش� ���� ������ ���ڰ� ���� ���� ����� ���ϱ�

--1������ �ְ� �������̸� -3
--�̶��� �ְ� 
----------------------------------------------sem--------------------------------------
SELECT 
	TO_DATE(:dt,'yyyymm')-(To_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1)st,
	LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAy(TO_DATE(:dt,'yyyymm')),'D'))ed,
	LAST_DAY(TO_DATE(:dt,'yyyymm')) + (7- TO_CHAR(LAST_DAy(TO_DATE(:dt,'yyyymm')),'D'))
			-(TO_DATE(:dt,'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'),'D')))
	
FROM dual;
----------------------------------------------------------------------------------------

--���� : �������� 1��, ������ ��¥ : �ش� ���� ������ ����;
SELECT TO_DATE('202002','yyyymm')+(level-1)
FORM dual
CONNECT By LEVEL <=29;

--���� : �������� : ������� 1���ڰ� ���� ���� �Ͽ���
--		�������� �� : �ش���� ���������ڰ� ���� ���� �����
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


---------------------------------------------------����--------------------------------------
�������� 1��~������;
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
 

1���ڰ� ���� ���� �Ͽ��ϱ��ϱ�
���������ڰ� ���� ���� ����ϱ� �ϱ�
�ϼ� ���ϱ�; 
SELECT 
        TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) st,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                      - ( TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D'))) daycnt
FROM dual;      


1����, �����ڰ� ���� �������� ǥ���� �޷�
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
1.dt(����) =>��, �������� sum(sales) -> ���� ����ŭ ���� �׷����� �ȴ�.
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



------------------��������(Oracle)
--����Ŭ���� �����ϴ� �Ÿ�Ʈ�ִ� �ý���
--select.....
--FROM ......
--WHERE
--START WITH ���� : � ���� ���������� ������
--CONNECT BY ��� ���� �����ϴ� ����
--	PRIOR : �̹� ���� ��
--	'    ': ������ ���� ��

--�������������� WHERE���� �б� ���� ���������� ���� ����
--1. �����
--���� �������� �ڽĳ��� ����
--2. �����
--
--������ �ϼ����� �ؿ��ִ� �ڽĳ�带 �� �дµ� ������� �ڽ��� �θ��常 �д´�.

SELECT *
FROM dept_h;

--XXȸ��(�ֻ��� ����) ���� �����Ͽ� ���� �μ��� �������� ���� ����
/*
SELECT *
FROM dept_h
START WITH
	deptcd = 'dept0'
--START WITH
--	deptnm = 'XXȸ��'
--START WITH
--	p_deptcd IS null
CONNECT BY : ��� ����  ���� ���� (PRIOR XXȸ�� = 3���� ��(�����κ�, ������ȹ��, �����ý��ۺ�))
;*/
SELECT *
FROM dept_h
START WITH
	deptcd = 'dept0'
--START WITH
--	deptnm = 'XXȸ��'
--START WITH
--	p_deptcd IS null
CONNECT BY PRIOR deptcd = p_deptcd ;
--: ��� ����  ���� ���� (PRIOR XXȸ�� = 3���� ��(�����κ�, ������ȹ��, �����ý��ۺ�))
--1.�����κο� ���� ���������� ��
PRIOR XXȸ��.deptcd = �����κ�.p_deptcd
PRIOR �����κ�.deptcd = ��������. p_deptcd

--2.������ȹ��
PRIOR XXȸ��.deptcd = ������ȹ��.p_deptcd
PRIOR ������ȹ��.deptcd = ��ȹ��.p_deptcd
PRIOR ��ȹ��.deptcd = ��ȹ��Ʈ.p_detpcd

--3.�����ý��ۺ�
PRIOR XXȸ��.deptcd = �����ý��ۺ�.p_deptcd (����1��, ����2��)
PRIOR �����ý��ۺ�.deptcd = ����1��.p_deptcd
PRIOR ����1��.deptcd = .......
PRIOR �����ý��ۺ�.deptcd = ����2��.p_deptcd
PRIOR ����2��.deptcd = .......;

--��������(�ǽ� h_1)
SELECT LPAD('HELLO, WORLD', 15, '*')"LPAD"
FROM dual;

SELECT dept_h.*, level, lpad(' ', (LEVEL-1)*4, ' ') || deptnm
FROM dept_h
START WITH	deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd ;
--CONNECT BY deptcd =PRIOR p_deptcd ;

--�ǽ� h_2
SELECT level lv,deptcd,(lpad(' ', (LEVEL-1)*4, ' ') || deptnm)deptnm,p_deptcd
FROM dept_h
START WITH	deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd ;

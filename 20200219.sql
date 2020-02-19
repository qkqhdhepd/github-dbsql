--���� ���� ��� 11��
--����¡ ó��(�������� 10���� �Խñ�)
--1������ : 1~10
--2����¡  11-20
--���ε� ���� 1page, 2pageSize;

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



--���� ������ �м��Լ��� ����ؼ� ǥ���ϸ�
SELECT ename, sal, deptno, ROW_NUMber() OVER (partition by deptno order by sal desc)rank
FROM emp;

--�м��Լ� ����
--�м��Լ���([����]) OVER([PARTITION BY �÷�] [ORDER BY �÷�] [WINDOWING])
--PARTITION BY �÷��� : �ش� �÷��� ���� row ���� �ϳ��� �׷����� ���´�.
--ORDER BY �÷� : PARTITION BY �� ���� ���� �׷� ������ ORDER BY �÷����� ����

--ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC)rank;

--���� ���� �м��Լ�
--rank(): ���� ���� ���� �� �ߺ� ������ ����, �� ������ �ߺ� ����ŭ ������ ������ ����
--		2���� 2���̸� 3���� ���� 4����� �ļ����� �����ȴ�.
--DESE_RANK(): ���� ���� ���� �� �ߺ� ������ ����, �ļ����� �ߺ����� �������� ����
--		2���� 2���̴��� �ļ����� 3����� ����
--ROW_NUMBER() : ROWNUM�� �����ϰ�, �ߺ��� ���� ������� ����


--�μ���, �޿� ������ 3���� ��ŷ �����Լ��� ����
SELECT ename, sal, deptno,
	RANK() OVER (PARTITION BY deptno ORDER BY sal)sal_rank,
	DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal)sal_dense_rank,
	ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal)sal_row_number
FROM emp;

--�ǽ� no_ana1
SELECT empno, ename, sal, deptno,
	RANK() OVER (ORDER BY sal desc, empno )sal_rank,
	DENSE_RANK() OVER (ORDER BY sal desc, empno)sal_dense_rank,
	ROW_NUMBER() OVER (ORDER BY sal desc, empno)sal_row_number
FROM emp;


--�ǽ� no_ana2
SELECT a.empno,a.ename,a.deptno,b.cnt
FROM emp a,(
SELECT deptno, count(*)cnt
FROM emp
GROUP BY deptno
ORDER BY deptno)b
WHERE a.deptno = b.deptno;


--�м��Լ�/window �Լ�(����)
--1.sum(col)
--2.MIN(col)
--3.MAX(col)
--4.AVG(col)
--5.COUNT(col)

--window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�,
--�ش� ����� ���� �μ��� ��� ���� ���ϱ�
SELECT empno, ename, deptno,
	COUNT(*) over (partition by deptno) cnt
FROM emp;

--�ǽ� ana2
--window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, ���α޿�, �μ���ȣ��
--�ش� ����� ���� �μ��� �޿� ����� ��ȸ�ϴ� ������ �ۼ��ϼ���(�޿� ����� �Ҽ��� ��°�ڸ�)
SELECT empno, ename, sal, deptno, ROUND(AVG_SAL,2) AVG_SAL
FROM 
(SELECT empno, ename, sal, deptno,
	AVG(sal) OVER(partition by deptno) AVG_SAL
FROM emp);

--�ǽ� ana3
--window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, ���α޿�, �μ���ȣ�� 
--�ش� ����� ���� �μ��� ���� ���� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT empno, ename, sal, deptno, 
	MAX(sal) OVER(partition by deptno) MAX_SAL
FROM emp;

--�ǽ� ana4
--window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, ���α޿�, �μ���ȣ��
--�ش� ����� ���� �μ��� ���� ���� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT empno, ename, sal, deptno, 
	MIN(sal) OVER(partition by deptno) MIN_SAL
FROM emp;


--�м��Լ�/window�Լ�(�׷쳻 �� ����)
--1.LAG(col) : ��Ƽ�Ǻ� �����쿡�� ���� ���� �ɷ� ��
--2.LEAD(col) : ��Ƽ�Ǻ� �����쿡�� ���� ���� �÷� ��

--�м��Լ�/window�Լ�(�׷쳻 �� ����)
--window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�,
--�Ի�����, �޿�, ��ü ����� �޿� ������ 1�ܰ� ���� ����� �޿��� ���غ���
--(�޿��� ���� ��� �Ի����� ���� ����� ���� ����)
SELECT empno, ename, hiredate,sal,
	LEAD(SAL) OVER (ORDER BY sal desc, hiredate) lead_sal
FROM emp;

--�׷쳻 �� ���� �ǽ� ana5
--window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, �Ի�����, �޿�, 
--��ü ����� �޿� ������ 1�ܰ� ���� ����� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���
--(�޿��� ���� ��� �Ի����� ���� ����� ���� ����)
SELECT empno, ename, hiredate,sal,
	LAG(SAL) OVER (ORDER BY sal desc, hiredate) lead_sal
FROM emp;

--�׷쳻 �� ���� �ǽ� ana6
--window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, �Ի�����, ����(job),�޿�����
--������(job)�� �޿� ������ 1�ܰ� ���� ����� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���
--(�޿��� ���� ��� �Ի����� ���� ����� ���� ����)
SELECT empno, ename, hiredate, job, sal,
	LAG(sal) OVER (partition BY job ORDER BY sal desc,job)LAG_SAL
FROM emp;

--�׷쳻 �� ���� - �����غ���, �ǽ� no_ana3
--��� ����� ���� �����ȣ, ����̸�, �Ի�����, �޿��� �޿��� ���� ������ ��ȸ�غ���
--�޿��� ������ ��� �����ȣ�� ���� ����� �켱������ ����
--�켱������ ���� ���� ������� ���� ������ �޿� ���� ���ο� �÷����� ����
--window �Լ�����

SELECT empno, ename, sal
FROM emp
ORDER BY sal;

--WHERE���� ������ ���� sum�� ��
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
--no_ana3�� �м��Լ��� �̿��Ͽ� SQL �ۼ�
--window�Լ��� Ȱ���Ͽ�
SELECT empno, ename, sal,
	SUM(sal) OVER (order by sal,empno)c_sum
FROM emp;

SELECT empno, ename, sal,
	SUM(sal) OVER()c_sum
FROM emp;


--�м��Լ�
--windowing
--window�Լ��� ����� �Ǵ� ���� ����
--UNBOUNDED PRECEDING : ���� ����� ��� ������
--CURRENT ROW : ������
--UNBOUNDED FOLLOWING : ���� �� ���� ��� ������
SELECT empno, ename, sal,
	SUM(sal) OVER (order by sal,empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)c_sum
FROM emp;


--�м��Լ�/window�Լ�(�׷쳻 �� ����)
--���� ���� �������� ���� ������� ���� ������� �� 3������ sal�հ� ���ϱ�
SELECT empno, ename, sal,
	SUM(sal)OVER(ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)c_sum
FROM emp;

--�׷쳻 �� ���� �ǽ� ana7
--�����ȣ, ����̸�, �μ���ȣ, �޿� ������ �μ����� �޿�, �����ȣ ������������ �������� ��
--�ڽ��� �޿��� �����ϴ� ������� ���� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT empno, ename, deptno, sal,
	SUM(sal)OVER(partition BY deptno ORDER BY deptno,sal ROWS BETWEEN UNBOUNDED PRECEDING  AND CURRENT ROW)c_sum
FROM emp;

--WINDOWUNG�� range, rows��
--range : ������ ���� ����, ���� ���� ������ �÷����� �ڽ��� ������ ���
--ROW : �������� ���� ����


--������ ����
select empno, ename, deptno ,sal,
    sum(sal) over (partition by deptno order by sal rows unbounded preceding )row_,
    sum(sal) over (partition by deptno order by sal rows unbounded preceding )range_,
    sum(sal) over (partition by deptno order by sal  ) default_
from emp;
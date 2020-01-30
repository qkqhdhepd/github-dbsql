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
--emp ���̺��� �̿��Ͽ� deptno�� ���� �μ������� ���� �ؼ� ������ ���� ��ȸ�Ǵ� ������ �ۼ��ϼ���
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
--emp���̺��� �̿��Ͽ� hiredate�� ���� ���� �ǰ����� ���� ��������� ��ȸ�ϴ� ������ �ۼ��ϼ���
--(������ �������� �ϳ� ���⼭�� �Ի�⵵�� �������� �Ѵ�)
--���ش� ¦�����̴� �׷��Ƿ� Ȧ������ ������� �˻縦 �޾ƾ� �Ѵ�.
--���س⵵�� ¦������ 
-- �Ի�⵵�� ¦���� �� �ǰ����� �����
-- �Ի�⵵�� Ȧ���� �� �ǰ����� ������
--���س⵵�� Ȧ���̸�
-- �Ի�⵵�� ¦���� �� �ǰ����� ������
-- �Ի�⵵�� Ȧ���� �� �ǰ����� �����
--���س⵵�� ¦������, Ȧ������ Ȯ��
-- DATEŸ�� => ���ڿ� ( �������� ����, YYYY-MM-DD HH24:MI:SS)
SELECT MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)
FROM emp;

SELECT empno, ename, hiredate,
       CASE
            WHEN MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2) = MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2) THEN '�ǰ����� �����'
            WHEN MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2) != MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2) THEN '�ǰ����� ������'
            ELSE '�ǰ����� ������'
       END
FROM emp;



--cond3
--users ���̺��� �̿��Ͽ� reg_dt�� ���� ���� �ǰ����� ���� ��������� ��ȸ�ϴ� ������ �ۼ��ϼ���.
--(������ �������� �ϳ� ���⼭�� reg_dt�� �������� �Ѵ�)
SELECT userid, usernm, alias, reg_dt,
        CASE
            WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt,'YYYY')),2) = MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2) THEN '�ǰ����� �����'
            WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt,'YYYY')),2) != MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2) THEN '�ǰ����� ������'
            ELSE '�ǰ����� ������'
        END
FROM users;

--SELECT empno, ename, hiredate,
--        DECODE (MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2) = MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2),'�ǰ����� �����',
--               MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2) != MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2),'�ǰ����� ������','�ǰ����� ������')
--            
--FROM emp;


--p.168
--Group by ���� ���� ����
--�μ���ȣ�� ���� ROW���� ���� ��� : Group by deptno
--�������� ���� ROW���� ���� ��� : Group by job
--MGR�� ���� �������� ���� ROW���� ���� ��� : Group by mgr, job

--�μ��� �޿� ��
--SUM : �հ�
--COUNT : ����
--MAX : �ִ밪
--MIN : �ּҰ�
--AVG : ���
--GROUP BY�� Ư¡
--�ش� �÷��� null���� ���� ROW�� ������ ��� �ش� ���� �����ϰ� ����. null ������ ����� null�̾��µ� �׷��Լ������� �ȵȴ�.
--�׷��Լ��� ������
--GROUP BY ������ ���� �÷��̿��� �ٸ� �÷��� SELECT���� ǥ���Ǹ� ����
--�μ��� �޿���
SELECT deptno, ename,
       sum(sal) sum_sal, MAX(sal), MIN(sal), ROUND(AVG(sal),2), COUNT(sal)
FROM emp
GROUP BY deptno , ename;


--GROUP BY�� ���� ���¿��� �׷��Լ��� ����� ���
--��ü���� �ϳ��� ������ ���´�
SELECT deptno, ename,
       sum(sal) sum_sal, MAX(sal), MIN(sal), ROUND(AVG(sal),2), COUNT(sal)
FROM emp
GROUP BY deptno ;
/*ORA-00979: not a GROUP BY expression
00979. 00000 -  "not a GROUP BY expression"
*Cause:    
*Action:
101��, 16������ ���� �߻�*/


SELECT sum(sal) sum_sal, MAX(sal), MIN(sal), ROUND(AVG(sal),2), 
       COUNT(sal),  --sal �÷��� ���� null�� �ƴ� row����
       COUNT(comm),  --comm�÷��� ���� null�� �ƴ� ROW����
       COUNT(*) --����� �����Ͱ� �ִ���
FROM emp;

--GROUP BY�� ������ empno�̸� ������� ��ϱ�?
--����� �׷��Լ��� ������ص� ����� �����ϴ�.
--�׷�ȭ�� ���þ��� ������ ���ڿ�, �Լ�, ���� ���� SELECT���� ������ ���� ����
SELECT sum(sal) sum_sal, MAX(sal), MIN(sal), ROUND(AVG(sal),2), 
       COUNT(sal),  --sal �÷��� ���� null�� �ƴ� row����
       COUNT(comm),  --comm�÷��� ���� null�� �ƴ� ROW����
       COUNT(*) --����� �����Ͱ� �ִ���
FROM emp
GROUP BY empno;

--SINGLE ROW FUNCTON �� ��� wHERE ������ ����ϴ� ���� �����ϴ�.
--MULTI ROW FUNCTION(GROUP_FUNCTION)�� ��� WHERE������ ����ϴ� ���� �Ұ��� �ϰ� HAVING������ ������ ����Ѵ�.

--�μ��� �޿� �� ��ȸ, �� �޿����� 9000�̻��� row����ȸ
--deptno, �޿���
SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

--grp1
--emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�
SELECT  MAX(sal),MIN(sal),ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), count(*)
FROM emp;

--grp2
--emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�
SELECT deptno,MAX(sal),MIN(sal),ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), count(*)
FROM emp
GROUP BY deptno;

--grp3
--emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�
--grp2���� �ۼ��� ������ Ȱ���Ͽ� deptno��� �μ����� ���ü� �ֵ��� �����Ͻÿ�
SELECT DECODE(deptno,10,'ACCOUNTING',
                     20,'RESEARCH',
                     30,'SALES')DNAME,
       MAX(sal),MIN(sal),ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), count(*)
       
FROM emp
GROUP BY deptno
ORDER BY DNAME;
---������ �ڵ���ȯ�� �̷������ �ؿ��� DECODE���� GROUP BY ���� ����
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
--emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�
--������ �Ի� ������� ����� ������ �Ի��ߴ��� ��ȸ
--ORACLE 9i ���������� GROUP BY ���� ����� �÷����� ������ ����
--ORACLE 10G ���ĺ��ʹ� GROUP BY ���� ����� �÷����� �������� �ʴ´�.
--ORDER BY�� �ӵ��� �����ϰ� GROUP BY�� �ӵ��� ����Ŵ
SELECT *
FROM emp;

SELECT TO_CHAR(hiredate,'yyyymm')HIRE_YYYYMM,count(*)CNT
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyymm');

--grp5
--emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�
--������ �Ի� �⺰�� ����� ������ �Ի��ߴ��� ��ȸ
SELECT TO_CHAR(hiredate,'yyyy')HIRE_YYYY,count(*)CNT
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyy');

--grp6
--ȸ�翡 �����ϴ� �μ��� ������ ����� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
SELECT COUNT(*)CNT
FROM dept;

--grp7
--������ ���� �μ��� ������ ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
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
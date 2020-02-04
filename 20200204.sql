SELECT *
FROM emp;


--CROSS JOIN ==>īŸ�� ���δ�Ʈ(cartesian product)
--�����ϴ� �����̺��� ���� ���ǿ� �����Ǵ� ��� ������ ��� ���տ� ���� ������ �õ�
--dept(4��), demp(14��)�� cross join �� ����� 4*14 = 56��

SELECT dept.dname, emp.empno, emp.ename
FROM dept , emp
WHERE  dept.deptno = emp.deptno
AND dept.deptno = 10;











--cross join �ǽ� crossjoin1
--customer, product ���̺��� �̿��Ͽ� ���� ���� ������ ��� ��ǰ�� ������ �����Ͽ�
--������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
select *
FROm customer;

SELECT *
FROM product;

SELECT cid, cnm, pid, pnm
FROM customer CROSS JOIN product;

--���ϰ��� �ϴ°�
--smith�� ���� �μ��� ���ϴ� �������� ������ ��ȸ
--1.smith�� ���ϴ� �μ���ȣ�� ���Ѵ�.
--2.1������ ���� �μ� ��ȣ�� ���ϴ� ������ ����

SELECT deptno
FROM emp
WHERE ename = 'SMITH';

--2.1������ ���� �μ���ȣ�� �̿��Ͽ� �ش� �μ��� ���ϴ� ���� ������ ��ȸ
SELECT *
FROM emp
WHERE deptno = 20;

--SUBQUERY�� �̿��Ͽ� �ΰ��� ������ ���ÿ� �ϳ��� SQL�� ������ ����
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

--SUBQUERY : �����ȿ� �ٸ� ������ �� �ִ� ���
--SUBQUERY�� ���� ��ġ�� ���� 3������ �з�
--SELECT �� : SCALAR SUNQUERY
--FROM �� : INLINE VIEW
--WHERE �� : SUBQUERY

--��������(�ǽ� sub1)
--��� �޿����� ���� �޿��� �޴� ������ ���� ��ȸ�ϼ���.
SELECT count(sal)
FROM emp
WHERE sal>(
        SELECT ROUND(AVG( sal))
        FROM emp
        );

--��������(�ǽ� sub2)
--��� �޿����� ���� �޿��� �޴� ������ ������ ��ȸ�ϼ���.
SELECT *
FROM emp
WHERE sal>(
        SELECT ROUND(AVG( sal))
        FROM emp
        );


--������ ������
--IN
--ANY(Ȱ�뵵�� �ټ� ������):���������� �������� �� ���̶� ������ ������ ��
--ALL(Ȱ�뵵�� �ټ� ������):���������� ���������� ��� �࿡ ���� ������ ������ ��

--��������(�ǽ� sub3)
--SMITH, WARD����� ���� �μ��� ��� ��������� ��ȸ�ϴ� ������ ������ ���� �ۼ��ϼ���.
SELECT *
FROM emp
WHERE deptno IN(SELECT deptno
                FROM emp 
                WHERE ename IN('SMITH','WARD'));

--SMITH, WARD ����� �޿����� �޿��� ���� ������ ��ȸ(SMITH, WARD�� �޿��� �ƹ��ų�)
--SMITH : 800
--WARD : 1250
-- ==> 1250 ���� ���� ���
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal
                FROM emp
                WHERE ename IN('SMITH','WARD'));




--�����ȣ�� 7902�� �ƴϸ鼭(AND) null�� �ƴ� ������
SELECT *
FROM emp
WHERE empno NOT IN(7902,NULL);
--Ǯ� ����
SELECT *
FROM emp
WHERE empno != 7902
AND empno != null;
--������ ��ȸ�� �ȵǴµ� ������ �Ϸ���
SELECT *
FROM emp
WHERE empno != 7902
AND empno IS NOT null;

--��������
--multi column subquey(pairwise)
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499,7782));
                        
--non-pairwise�� �������� ���ÿ� ������Ű�� �ʴ� ���·� �ۼ�
--mgr ���� 7698�̰ų� 7839�̸鼭
--deptno�� 10�̰ų� 30���� ����
--MGR, DEPTNO
--(7698,10), (7698,30)
--(7839,10), (7839,30)
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr 
              FROM emp
              WHERE empno IN(7499,7782))
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN(7499,7782));

--��Į�� �������� : select ���� ���, 1���� ROW, 1���� col�� ��ȸ�ϴ� ����
--��Į�� ���������� MAIN������ �÷��� ����ϴ°� �����ϴ�
SELECT SYSDATE
FROm dual;

SELECT (SELECT SYSDATE FROM dual), d.*
FROM dept d;

SELECT *
FROM emp;

SELECT empno, ename, deptno,
      (SELECT dname 
       FROM dept
       WHERE deptno = emp.deptno) dname
FROM emp ;


--INLINE VIEW : FROM ���� ����Ǵ� ��������

--MAIN������ �÷��� subquery���� ����ϴ��� ������ ���� �з�
--����� ��� : correlated subquery(��ȣ ���� ����), ���������� �ܵ����� �����ϴ� ���� �Ұ����ϴ�.
            --��������� ������ �ִ� (Main => sub)
--������� ���� ��� : non-correlated subquery(���ȣ ���� ��������),���������� �ܵ����� �����ϴ°� �����ϴ�.
            --��������� ������ ���� �ʴ�(Main => sub, sub ->main)

--��� ������ �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT *
FROM emp 
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
--������ ���� �μ��� �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT *
FROM emp a
WHERE sal > (SELECt ROUND(avg(sal))
             FROM emp b
             where a.deptno = b.deptno
             GROUP BY deptno)
ORDER BY deptno;

--���� ������ ������ �̿��ؼ� Ǯ���
--�������̺���
--emp, �μ��� �޿� ���(inline view)
SELECT emp.*  --ename, sal, dept_sal.*
FROM emp, (SELECT deptno, ROUND(AVG(sal)) avg_sal
            FROM emp
            GROUP BY deptno) dept_SAL
WHERE emp.deptno = dept_sal.deptno
AND emp.sal> dept_sal.avg_sal;
-------ANSI�� �ٲ�------
SELECT e.*
FROM emp e join (SELECT deptno, ROUND(AVG(sal)) avg_sal
                    FROM emp
                    GROUP BY deptno) d ON e.deptno = d.deptno
WHERE e.sal > d.avg_sal;


--��������(�ǽ� sub4)
--dept ���̺��� �ű� ��ϵ� 99�� �μ��� ���� ����� ����
--������ ������ ���� �μ��� ��ȸ�ϴ� ������ �ۼ��غ�����
INSERT INTO dept VALUES (99,'ddit','daejeon');
commit;

--DELETE dept
--WHERE deptno = 99;
--�����͸� �����ϴ� ����(�����)

--ROLLBACK; --Ʈ����� ���
--COMMIT;  --Ʈ����� Ȯ��
--Ʈ������� �ٸ�����ڿ��Ե� ������ �ش�

SELECT *
FROM dept
WHERE deptno NOT IN(select deptno
                    FROM emp);
--������������ ���ȣ���� ���������� ����ϰ� NOT IN�� �����






--��������(�ǽ� sub5)
--cycle, product ���̺��� �̿��Ͽ� cid = 1�� ���� �������� �ʴ� ��ǰ�� ��ȸ�ϴ�
--������ �ۼ��ϼ���.
SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT *
FROM product 
WHERE pid  NOT IN (SELECT pid
                   FROM cycle 
                   WHERE cid = 1);
                   
--��������(�ǽ� sub6)
--cycle ���̺��� �̿��Ͽ� cid = 2�� ���� �����ϴ� ��ǰ�� cid= 1�� ����
--�����ϴ� ��ǰ�� ���������� ��ȸ�ϴ� ������ �ۼ��ϼ���.
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


--��������(�ǽ� sub7)
--customer, cycle, product ���̺��� �̿��Ͽ� cid =2 �� ���� �����ϴ� ��ǰ�� 
--cid =1 �� ���� �����ϴ� ��ǰ�� ���������� ��ȸ�ϰ� ����� ��ǰ����� �����ϴ� ������ �ۼ�
SELECt *
FROM customer;

SELECT *
FROM cycle;

SELECT *
FROM product;


SELECT a.cid, b.cnm, a.pid, c.pnm, a.day, a.cnt 
FROM cycle a join customer b on a.cid = b.cid join product c on a.pid = c.pid
WHERE a.pid  IN (SELECT a.pid
                FROM cycle a join cycle b on a.pid = b.pid
                WHERE a.cid = 1
                AND b.cid = 2
                group by a.pid)
AND a.cid = 1
ORDER BY a.day desc;

--��������(�ǽ� sub8)
--�Ʒ��� ������ ���������� �ۼ����� �ʰ� �ۼ��϶�
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'x'
                FROM emp b
                WHERE b.empno = a.mgr);
                
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--��������(�ǽ� sub8)
--cycle, product, ���̺��� �̿��Ͽ� cid = 1 �� ���� �����ϴ� ��ǰ�� ��ȸ�ϴ�
--������ EXISTS �����ڸ� �̿��Ͽ� �ۼ��ϼ���.
SELECT a.pid, b.pnm
FROM cycle a join product b on a.pid = b.pid
WHERE cid = 1
group by a.pid, b.pnm;

SELECT a.pid, b.pnm
FROM cycle a, product b
WHERE EXISTS (SELECT b.pnm
                FROM product b
                WHERE cid = 1
                group by b.pnm)
AND a.pid = b.pid
group by a.pid,b.pnm;


--�ǽ�sub10(�̿ϼ�)
--cycle, product ���̺��� �̿��Ͽ� cid = 1�� ���� �������� �ʴ� ��ǰ�� 
--��ȸ�ϴ� ������ EXISTS �����ڸ� �̿��Ͽ� �ۼ��ϼ���.

SELECT a.pid, b.pnm
FROM cycle a, product b
WHERE NOT EXISTS (SELECT b.pnm
                  FROM product b
                  WHERE cid = 1
                  group by b.pnm)
AND a.pid = b.pid
group by a.pid,b.pnm;
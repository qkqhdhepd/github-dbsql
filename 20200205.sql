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
WHERE deptno NOT IN (select deptno
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
-------����������--sem ��-- �����������----
SELECT *
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
                FROM cycle
                WHERE cid = 2);
----------��������������������������������-----------------                
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
WHERE a.pid  IN (SELECT pid
                FROM cycle
                WHERE cid = 2)
AND a.cid = 1
ORDER BY a.day desc;

--sem ��Į�󼭺�����-----�̰Ŵ� ���������� ����(������������)
SELECT cycle.cid, (SELECT cnm FROM customer WHERE cid = cycle.cid)cnm,
        cycle.pid, (SELECT pnm FROM product WHERE pid = cycle.pid)pnm,
        cycle.day, cycle.cnt
FROM cycle
WHERE cid = 1
AND pid IN(SELECT pid
            FROM cycle
            WHERE cid = 2);

-------------------------------------------------------------
--EXISTS ������
--�Ŵ����� �����ϴ� ������ ��ȸ(KING �� ������ 13���� �����Ͱ� ��ȸ)
SELECT *
FROM emp
WHERE mgr IS NOT null;

--EXISTS ���ǿ� �����ϴ� ���� �����ϴ��� Ȯ���ϴ� ������
--�ٸ� �����ڿ� �ٸ��� WHERE���� �÷��� ������� �ʴ´�.
--  WHERE empno = 7369
--  WHERE EXISTS(SELECT 'x'
--                FROM ......);

--�Ŵ����� �����ϴ� ������ EXISTS�����ڸ� ���� ��ȸ
--�Ŵ����� ����
--EXISTS�����ڸ� ����ϱ� ���� ������ ���� ��
SELECT *
FROM emp a
WHERE EXISTS(SELECT 'x'
            FROM emp b
            WHERE b.empno = a.mgr);










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

--��������(�ǽ� sub9)
--cycle, product, ���̺��� �̿��Ͽ� cid = 1 �� ���� �����ϴ� ��ǰ�� ��ȸ�ϴ�
--������ EXISTS �����ڸ� �̿��Ͽ� �ۼ��ϼ���.
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

------sem------����������������
SELECT *
FROM product
WHERE EXISTS(SELECT 'x'
            FROM cycle
            WHERE cid = 1
            AND cycle.pid = product.pid);
--EXISTS�� �̿� ������ ��ȣ������ ����ϴ°��� �⺻���� �����ϰ�
--������� �÷��� Ȯ������ ���� ���̺��� ����
--�������������� ���ǿ� �ش��ϴ� ���̺��� �̿��Ѵ�.
--�������� �������� ���ϴ� (join�� �ش��ϴ� �������� )�� ����Ѵ�.


--�ǽ�sub10
--cycle, product ���̺��� �̿��Ͽ� cid = 1�� ���� �������� �ʴ� ��ǰ�� 
--��ȸ�ϴ� ������ EXISTS �����ڸ� �̿��Ͽ� �ۼ��ϼ���.
SELECT *
FROM product
WHERE NOT EXISTS(SELECT 'x'
            FROM cycle
            WHERE cid = 1
            AND cycle.pid = product.pid);
            
            

--���տ���
--UNION
--������, �ߺ��� ����(���հ���)
--UNION ALL
--������, �ߺ��� �������� ����(�ӵ����) =>union �����ڿ� ���� �ӵ��� ������
--INTERSECT
--������ : �� ������ ����� �κ�
--MINUS
--������ : �� ���տ��� ���ϴ� ������
--���տ��� �������
--�� ������ �÷��� ����, Ÿ���� ��ġ�ؾ��Ѵ�.

--������ ������ �����ϱ� ������ �ߺ��Ǵ� �����ͺz �ѹ��� ����ȴ�.
SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698,7369)

UNION

SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698);

--UNION ALL
--UNION �����ڿ� �ٸ��� �ߺ��� ����Ѵ�.
SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698,7369)

UNION ALL

SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698);


--INTERSECT
--�� �Ʒ� ������ �ߺ��Ǵ� �����͸� ��ȸ�Ѵ�.
SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698,7369)

INTERSECT

SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698);


--MINUS 
--������ : �� ���տ��� �Ʒ� ������ �����͸� ������ ������ ����
SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698,7369)

MINUS

SELECT empno, ename
FROm emp
WHERE empno IN(7566,7698);


--������ ��� ������ ������ ���� ���տ�����
--A UNION B      B UNION A ==>����
--A UNION ALL B  B UNION ALL A ==>����(����)
--A INTERSECT B  B INTERSECT A ==>����
--A MINUS B      B MINUS A  ==>�ٸ�

--���տ����� ��� �÷� �̸��� ù��° ������ �÷����� �ٸ���.
SELECT 'X'fir,'B'sec
FROm dual

UNION

SELECt 'Y'fir,'A'fir
FROM dual;

--���� ORDER BY �� ���տ��� ���� ������ ���� ������ ����Ѵ�.
SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (10, 20)

UNION
--UNION ALL

SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (30, 40)
ORDER BY deptno;


--�ܹ��� ���� ��������;
SELECT *
FROM fastfood;

--�õ�, �ñ���, ��������
--�õ����� kfc�� ��ȸ
select a.gb,a.sido,a.sigungu
FROM fastfood a
WHERE a.gb = 'KFC'
group by a.gb,a.sido, a.sigungu

UNION ALL

select a.gb,a.sido,a.sigungu
FROM fastfood a
WHERE a.gb = '������ġ'
group by a.gb,a.sido, a.sigungu

UNION ALL

select a.gb,a.sido,a.sigungu
FROM fastfood a
WHERE a.gb = '�Ƶ�����'
group by a.gb,a.sido, a.sigungu;

UNION aLL

select a.gb,a.sido,a.sigungu
FROM fastfood a
WHERE a.gb = '�Ե�����'
group by a.gb,a.sido, a.sigungu;



--fast food������ �ߺ��� ������ ��ü�� ���ÿ� ����
SELECT a.sido, a.sigungu
FROM fastfood a
group by a.sido, a.sigungu;

--fast food���� ������ ���ÿ��� ������ �ִ� gb
SELECT b.gb
FROM fastfood b
WHERE (SELECT a.sido, a.sigungu
        FROM fastfood a
        group by a.sido, a.sigungu)
GROUP BY b.gb;

SELECT gb
FROM fastfood 
group by gb;




--�ñ�����

SELECT *
FROM fastfood;

--������������ ������ �����ϴ� �ܹ��� ���Ը� ǥ����
--������������ �� ������ ������ ������ ������� ������ �ܹ��Ű����� ��(�Ե����Ƹ� ������)
SELECT a.sigungu,nm,count(a.nm)
FROM (
        SELECT sigungu, gb, nm, count(nm)
        FROM fastfood
        WHERE sido ='����������'
        AND gb IN('KFC','����ŷ', '������ġ','�Ƶ�����','�����̽�')
        group by sigungu, gb, nm
        ORDER BY SIGUNGU
        )a
GROUP BY a.sigungu,nm;






SELECT sigungu, gb, nm, count(nm)
        FROM fastfood
        WHERE sido = '����������'
        AND gb IN('KFC','����ŷ', '������ġ','�Ƶ�����','�����̽�')
        group by sigungu, gb, nm
        ORDER BY SIGUNGU;

SELECT *
FROM fastfood;

--������������ ���� ��������



SELECT sigungu, gb, nm
FROM fastfood
WHERE sido ='����Ư����'
AND gb IN('KFC','����ŷ', '������ġ','�Ƶ�����','�����̽�')
group by sigungu, gb, nm
ORDER BY SIGUNGU;


SELECT SIDO, SIGUNGU
FROM tax;

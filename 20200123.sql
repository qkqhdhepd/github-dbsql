--���ǿ� �´� ������ ��ȸ�ϱ� (WHERE�� 2)
--emp���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���� ���� 1983�� 1�� 1�� ������ ����� ename, hiredate �����͸�
-- ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--WHERE���� ����ϴ� ���ǿ� ������ ��ȸ ����� ������ ��ġ�� �ʴ´�.
--SQL�� ������ ������ ���� �ִ�.
--���� : Ű�� 185cm�̻��̰� �����԰� 70kg�̻��� ������� ����
--    ->�����԰� 70kg�� ������ Ű�� 185cm�� ������� ����
--      �߻��� ����� ���� ->����x
--(1,5,10) -> (10,5,1) : �� ������ ���� �����ϴ�.
--���̺��� ������ ������� ����
--SELECT ����� ������ �ٸ����� ���� �����ϸ� ����
-->���ı�� ����(ORDER BY)
SELECT *
FROM emp;

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101','YYYYMMDD') AND hiredate <= TO_DATE('19830101','YYYYMMDD');


-- IN������
--Ư�� ���տ� ���ԵǴ��� ���θ� Ȯ��
--�μ���ȣ�� 10Ȥ��(OR) 20���� ���ϴ� ���� ��ȸ
SELECT empno, ename, deptno
FROM emp;

SELECT empno, ename, deptno
FROM emp
WHERE deptno IN(10,20);

-- IN �����ڸ� ������� �ʰ� OR������ ���
SELECT *
FROM emp
WHERE deptno = 10 OR deptno = 20;

--emp ���̺��� ����̸��� SMITH, JONES�� ������ ��ȸ (empno, ename, deptno)
SELECT empno, ename, deptno
FROM emp
WHERE ename IN('SMITH','JONES');

--Users���̺��� userid�� brown, cony, sally�� �����͸� ������ ���� ��ȸ�Ͻÿ�( IN ���)
SELECT *
FROM users;

SELECT userid ���̵�, usernm �̸�, alias ����
FROM users
WHERE userid IN('brown', 'cony', 'sally');


-- ���ڿ� ��Ī ������ : LIKE, %, _
-- ������ ������ ������ ���ڿ� ��ġ�� ���ؼ� �ٷ�
-- �̸��� BR�� �����ϴ� ����� ��ȸ
-- �̸��� R ���ڿ��� ���� ����� ��ȸ

--����̸��� S�� �����ϴ� ��� ��ȸ
--% � ���ڿ� (�ѱ���, ���� �������� �ְ� , ���� ���ڿ��� �ü��� �ִ�)
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE ename LIKE 'S%';

--���ڼ��� ������ ���� ��Ī
-- _ ��Ȯ�� �ѹ��ڸ� �ǹ�
-- ���� �̸��� S�� �����ϰ� �̸��� ��ü ���̰� 5���� �� ����
-- S____��� �ϸ� ��
SELECT *
FROM emp
WHERE ename LIKE 'S____';

--��� �̸��� S���ڰ� ���� ��� ��ȸ
--'%S%'
SELECT *
FROM emp
WHERE ename LIKE '%S%';

--member���̺��� ȸ���� ���� [��]���� ����� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
SELECT *
FROM member;

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

--member ���̺��� ȸ���� �̸��� ����[��]�� ���� ��� ����� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
SELECT *
FROM member;

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';


--null �� ���� (IS)
--comm�÷��� ���� null�� �����͸� ��ȸ (WHERE comm = null)
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE comm = null;
--���� ����� �ȳ��´� null�� = ��ſ� IS ��� �����ڸ� ����ؾ� �Ѵ�.

SELECT *
FROM emp
WHERE comm IS null;

--where6 
--emp���̺��� ��(comm)�� �ִ� ȸ���� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��Ͻÿ�
SELECT *
FROM emp
WHERE comm >= 0;
--NOT ������
SELECT *
FROM emp
WHERE comm IS NOT null;

--����� �����ڰ� 7698,7839 �׸��� null�� �ƴ� ������ ��ȸ
--NOT IN�����ڿ����� NULL���� ���� ��Ű�� �ȵȴ�.
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839)
AND mgr IS NOT null;

--where 7
--emp���̺��� job�� SALESMAN�̰� �Ի����ڰ� 1981�� 6��1�� ������ ������ ������ ��ȸ�϶�
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--where 8
--emp ���̺��� �μ���ȣ�� 10�� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���
--(IN, NOT IN������ ������)
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE deptno != 10 AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--where 9
--emp ���̺��� �μ���ȣ�� 10�� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���
--(NOT IN������ ���)
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE deptno NOT IN(10) AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--where 10
--emp���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�Ͻÿ�.
--(�μ��� 10, 20, 30 �� �ִٰ� �����ϰ� IN�����ڸ� �̿�)
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE deptno IN (20,30) AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--where 11
--emp���̺��� job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6��1�� ������ ������ ������ ������ ���� ��ȸ �ϼ���
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('19810601','YYYYMMDD');

--where 12
--emp���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ������ ���� ��ȸ �ϼ���.
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';

--where 13
--emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ������ ���� ��ȸ �ϼ���.
--LIKE ������ ��� ����
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899;                --�̰��� �����ڸ� ���̴�.

--������ �켱����
--*,/�����ڰ� +,-���� �켱������ ����.
-- 1+5*2 = 11 ->(1+5)*2 x
--�켱���� ���� : ()
--AND > OR 
--emp���̺��� ��� �̸��� SMITH �̰ų� 
--                      (��� �̸��� ALLEN�̸鼭 �������� SALESMAN )��� ��ȸ
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE ename = 'SMITH' OR (ename = 'ALLEN' and job = 'SALESMAN');

--��� �̸��� (SMITH �̰ų� ALLEN )�̸鼭 �������� SALESMAN�� ��� ��ȸ
SELECT*
FROM emp;

SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN') and job = 'SALESMAN';

--emp���̺��� job�� SALESMAN �̰ų� �����ȣ�� 78�� �����ϸ鼭 �Ի����ڰ� 1981��06��01�� ������ ������ ������ ��ȸ�϶�
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR (empno LIKE '78%' and hiredate >= TO_DATE('19210601','YYYYMMDD'));


--����
--SELECT *
--FORM  table
--[WHERE]
--ORDER BY �÷� [ASC | DESC],...|��Ī|�÷��ε��� |
--emp ���̺��� ��� ����� ename�÷� ���� �������� �������� ������ ����� ��ȸ �ϼ���.
SELECT *
FROM emp
ORDER BY ename ASC;      --ASC�� �⺻������ ��������

--emp ���̺��� ��� ����� ename�÷� ���� �������� �������� ������ ����� ��ȸ �ϼ���.
SELECT *
FROM emp
ORDER BY ename DESC;  

--DESC emp;  --DESC : DESCRIBE[�����ϴ�]
--ORDER BY ename DESC --DESC : DESCENDING[����]

--emp���̺��� ��� ������ ename�÷����� ��������, 
--ename���� ���� ��� mgr�÷����� �������� �����ϴ� ���� �ۼ�(order by ������ �÷� ����)
SELECT *
FROM emp
ORDER BY ename DESC, mgr;
--���Ľ� ��Ī�� ���(���̷� ���� �÷��� �������� �Ҽ� �ִ�. ���� ������ FROM -> SELECT -> ORDER BY)
SELECT empno, ename nm, sal *12 year_sal
FROM emp
ORDER BY year_sal;

--�÷� �ε����� ����
--java array(�迭)�� index�� ������ 0������ SQL �� index�� 1���� �����Ѵ�.
SELECT empno, ename nm, sal *12 year_sal
FROM emp
ORDER BY 3;

--orderby1
--dept ���̺��� ��� ������ �μ��̸����� �������� ���ķ� ��ȸ�ǵ��� ������ �ۼ��϶�
SELECT *
FROM dept
ORDER BY dname;

--dept ���̺��� ��� ������ �μ���ġ�� �������� ���ķ� ��ȸ�ǵ��� ������ �ۼ��϶�
SELECT *
FROM dept
ORDER BY loc DESC;

--order by2
--emp���̺��� ��(comm)������ �ִ� ����鸸 ��ȸ�ϰ�,
--��(comm)�� ���� �޴� ����� ���� ��ȸ�ǵ��� �ϰ�, �󿩰� ���� ���
--������� �������� �����ϼ���(�󿩰� 0�� ����� �󿩰� ���� ������ ����)
SELECT*
FROM emp
WHERE comm IS NOT null AND comm >0
ORDER BY comm DESC, empno;

--order by3
--emp���̺��� �����ڰ� �ִ� ����鸸 ��ȸ�ϰ�, ����(job)������ �������� �����ϰ�,
--������ ���� ��� ����� ū ����� ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
SELECT *
FROM emp
WHERE mgr IS NOt null
ORDER BY job,empno DESC;

--order by4
--emp ���̺��� 10�μ�(deptno) Ȥ�� 30�� �μ��� ���ϴ� ����� �޿�(sal)��
--1500�� �Ѵ� ����鸸 ��ȸ�ϰ� �̸����� �������� ���ĵǵ��� ������ �ۼ��ϼ���.
SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal >1500
ORDER BY ename desc;



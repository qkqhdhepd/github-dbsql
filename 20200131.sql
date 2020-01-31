--����
SELECT *
FROM emp;

SELECT userid, usernm, alias, reg_dt,
        CASE
            WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt,'YYYY')),2) = MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2) THEN '�ǰ����� �����'
            WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt,'YYYY')),2) != MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2) THEN '�ǰ����� ������'
            ELSE '�ǰ����� ������'
        END
FROM users;

--SELECT userid, usernm, alias, reg_dt,
--       DECODE (MOD(TO_NUMBER(TO_CHAR(reg_dt,'YYYY')),2), MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2),'�ǰ����� �����',
--               MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),2),'�ǰ����� ������')
--FROM users;

SELECT ename, deptno
FROM emp;

SELECT deptno, dname
FROM dept;


-- JOIN �� ���̺��� �����ϴ� �۾�
--1. ANSI ����
--2. ORACLE ����

--natural join
--�� ���̺� �÷����� ���� �� �ش� �÷����� ����
--emp, dept ���̺��� deptno��� �÷��� ����
--NATURAL JOIN�� ���� ���� �÷�(deptno)�� ������(ex : ���̺��, ���̺� ��Ī)�� ������� �ʰ�
--�÷��� ����Ѵ� (dept.detpno ==>detpno)
SELECT ename, deptno, dname
FROM emp NATURAL JOIN dept ;

SELECT e.ename, e.empno, d.dname, deptno
FROM emp e NATURAL JOIN dept d;

--ORACLE JOIN
--FROM ���� ������ ���̺� ����� ,�� �����Ͽ� �����Ѵ�
--������ ���̺��� ���� ������ WHERE���� ����Ѵ�.
--emp, dept ���̺� �����ϴ� deptno�÷��� ���� �� ����

SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--Ansi : join with using
--�����Ϸ��� �ΰ��� ���̺� �̸��� ���� �÷��� �ΰ������� �ϳ��� �÷����θ� ������ ���ڰ� �Ҷ� �����Ϸ��� ���� �÷���  ���
--emp, dept, ���̺��� ���� �÷� : deptno;

--JOin with using�� ORACLE �� ǥ���ϸ�
SELECT e. ename, d. dname, e.deptno
FROM emp e , dept d
WHERE e.deptno = d.deptno;

--ANSI : JOIN WITH ON
--���� �Ϸ��� �ϴ� ���̺��� �÷��� �̸��� ���� �ٸ� ��
SELECT e. ename, d. dname, e.deptno
FROM emp e JOIN dept d on e.deptno = d.deptno;

--SELF JOIN : ���� ���̺��� ����;
--�� : emp���̺��� �����Ǵ� ����� ������ ����� �̿��Ͽ� ������ �̸����� ��ȸ�Ҷ�
SELECT *
FROM emp;

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e join emp m on e.mgr = m.empno;

--���� ���ι��� ����Ŭ �������� �ۼ�;
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

--equal ���� : =
--non-equal���� : !=, >, <, BTWEEN AND


--emp���� sal�� ������ ����� ����
--����� �޿� ������ �޿� ��� ���̺��� �̿��Ͽ� �ش����� �޿� ����� ���غ���.
--�� ���̺��� ������ (equals)�� �ƴϱ� ������ emp���̺��� sal�� salgrade�� losal�� hisal��
--���Եȴٴ� ���� �̿��Ͽ� BETWEEN�� Ȱ���Ͽ� ������ ��
SELECT ename, sal
FROM emp;

SELECT *
FROM salgrade;
--<����Ŭ ��������>
SELECT e.ename, e.sal, s.losal, s.hisal, s.grade
FROM emp e , salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;
--<�Ƚ� ��������>
SELECT e.ename, e.sal, s.losal, s.hisal, s.grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;

--join 0 
--emp, dept���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��϶�
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON e.deptno = d.deptno
ORDER BY d.dname;

--join 0_1
--emp, dept���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
--(�μ���ȣ�� 10,30�� �����͸� ��ȸ)
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE e.deptno IN(10,30);

--join 0_2
--emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
--(�޿��� 2500�ʰ�)
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE e.sal >2500
ORDER BY d.dname;

--join 0_3
--emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
--(�޿� 2500�ʰ�, ����� 7600���� ū ����)
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE e.sal >2500 AND e.empno > 7600;

--join 0_4
--emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
--(�޿� 2500�ʰ�, ����� 7600���� ũ�� �μ����� RESEARCH�� �μ��� ���� ����)
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE e.sal >2500 AND e.empno > 7600 AND d.dname = 'RESEARCH';


--eXERD 
--prod : prod_LGU
--lPROD : lprod_GU
--join1
--erd���̾�׷��� �����Ͽ� prod ���̺�� lprod���̺��� �����Ͽ� ������ ���� ����� ������ ������ �ۼ��ϼ���
SELECT *
FROM prod;

SELECT *
FROM lprod;

SELECT p.prod_lgu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p JOIN lprod l on p.prod_lgu = l.lprod_gu
ORDER BY p.prod_lgu;

--join 2
--erd���̾�׷��� �����Ͽ� buyer, prod ���̺��� �����Ͽ� buyer�� ����ϴ� ��ǰ ������
--������ ���� ����� �������� ������ �ۼ��غ�����.
SELECT *
FROM buyer;

SELECT *
FROM prod;

SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM buyer b JOIN prod p on b.buyer_lgu = p.prod_lgu
ORDER BY b.buyer_id;

--join 3
--erd���̾�׷��� �����Ͽ� member, cart,prod ���̺��� �����Ͽ� ȸ���� ��ٱ��Ͽ� ���� ��ǰ ������
--������ ���� ����� �������� ������ �ۼ��غ�����.
SELECT *
FROM member;

SELECT *
FROM cart;

SELECT *
FROM prod;

SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM MEMBER m, cart c, prod p
WHERE m.mem_id = c.cart_member AND c.cart_prod = p.prod_id
ORDER by mem_id;

--�Ƚ÷� �����ϱ�
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM member m join cart c on m.mem_id = c.cart_member join prod p on c.cart_prod = p.prod_id
ORDER by mem_id;


--join 4
--erd���̾�׷��� �����Ͽ� customer, cycle ���̺��� �����Ͽ� ���� ������ǰ, ��������, ������
--������ ���� ����� �������� ������ �ۼ��غ�����.
--(������ brown, sally�� ���� ��ȸ),(���İ� ������� ���� ������ ����)
SELECT *
FROM customer;

SELECT *
FROM cycle;

SELECT a.cid, a.cnm, b.pid, b.day, b.cnt 
FROM customer a join cycle b on a.cid = b.cid; 

--join 5
--erd ���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ�
--���� ���� ��ǰ, ��������, ����, ��ǰ���� ������ ���� ����� ��������
--������ �ۼ��غ�����(������ brown, sally�� ���� ��ȸ)

SELECT a.cid, a.cnm, b.pid,c.pnm, b.day, b.cnt
FROM customer a, cycle b, product c
WHERE a.cid = b.cid AND b.pid = c.pid;
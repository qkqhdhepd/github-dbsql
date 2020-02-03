SELECT *
FROM emp;

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
FROM customer a join cycle b on a.cid = b.cid
WHERE a.cnm IN ('brown','sally');
--join 5
--erd ���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ�
--���� ���� ��ǰ, ��������, ����, ��ǰ���� ������ ���� ����� ��������
--������ �ۼ��غ�����(������ brown, sally�� ���� ��ȸ)

SELECT a.cid, a.cnm, b.pid,c.pnm, b.day, b.cnt
FROM customer a, cycle b, product c
WHERE a.cid = b.cid AND b.pid = c.pid
AND a.cnm IN ('brown','sally')
ORDER BY a.cnm;

--join 6
--erd���̾�׷��� �����Ͽ� customer,cycle, product ���̺��� �����Ͽ� 
--�������ϰ� ������� ���� ���� ��ǰ��, ������ �հ� ��ǰ���� ������ ����
--����� �������� ������ �ۼ��غ�����.
SELECT *
FROM customer;

SELECT *
FROM cycle
;

SELECT *
FROM product;

SELECT a.cid, a. cnm, c.pid, c.pnm, sum(b.cnt)
FROM customer a join cycle b on a.cid = b.cid 
join product c on b.pid = c.pid
GROUP BY a.cid, a. cnm, c.pid, c.pnm;

--join 7
--erd ���̾�׷��� �����Ͽ� cycle, product���̺��� �̿��Ͽ�
--��ǰ��, ������ �հ�, ��ǰ���� ������ ���� ����� �������� ������ �ۼ��غ�����
SELECT a.pid, b.pnm, sum(a.cnt)
FROM cycle a join product b on a.pid = b.pid
GROUP BY a.pid, b.pnm;

--join 8
--erd���̾�׷��� �����Ͽ� countries, regions���̺��� �̿��Ͽ� 
--������ �Ҽ� ������ ������ ���� ����� �������� ������ �ۼ��غ�����
--(������ ������ ����)
SELECT *
FROM countries;

SELECT *
FROM regions;

SELECT b.region_id, b.region_name, a.country_name
FROM countries a join regions b on a.region_id = b.region_id
WHERE region_name = 'Europe';

--join 9
SELECT *
FROM countries;

SELECT *
FROM regions;

SELECT *
FROM locations;

SELECT a.region_id, a.region_name, b.country_name, c.city
FROM regions a join countries b on a.region_id = b.region_id
join locations c on b.country_id = c.country_id
WHERE region_name = 'Europe';

--join10
SELECT a.region_id, a.region_name, c.city, department_name
FROM regions a join countries b on a.region_id = b.region_id
join locations c on b.country_id = c.country_id
join departments d on c.location_id = d.location_id
WHERE region_name = 'Europe';

--join11
SELECT a.region_id, a.region_name, c.city, d.department_name, e.first_name
FROM regions a join countries b on a.region_id = b.region_id
join locations c on b.country_id = c.country_id
join departments d on c.location_id = d.location_id
join employees e on d.department_id = e.department_id
WHERE region_name = 'Europe';

--join 12
SELECT *
FROM employees;

SELECT *
FROm jobs;

SELECT e.employee_id, concat(e.first_name,e.last_name), j.job_id, j.job_title
FROm employees e join jobs j on e.job_id = j.job_id;

--join13
SELECT *
FROm employees;

SELECT *
FROm jobs;

SELECT e.manager_id mgr_id, concat(m.first_name,m.last_name)mgr_name, e.employee_id, concat(e.first_name,e.last_name)name, j.job_id
FROm employees e join employees m on e.manager_id = m. employee_id
join jobs j on e.job_id = j.job_id;
--�����ϼ���.(8~13)


SELECT concat(first_name,last_name)
FROm employees;





--OUTER join
--�����̺��� ������ �� ���� ������ ���� ��Ű�� ���ϴ� �����͸� �������� ������ ���̺��� �����͸��̶� ��ȸ �ǰԲ� �ϴ� ���� ���;

--�������� : e.mgr = m.empno : KING �� mgr NULL�̱� ������ ���ο� �����Ѵ�.
--emp ���̺��� �����ʹ� �� 14�������� �Ʒ��� ���� ���������� ����� 13���� �ȴ�. (1���� ���ν���)
SELECT e.empno, e.ename, e.mgr, m.ename
FROm emp e, emp m
WHERE e. mgr = m.empno;

--ANSY LEFT outer
1���ο� �����ϴ��� ��ȸ���� ���̺��� ����(�Ŵ��� ������ ��� ��������� �����Բ�);

SELECT e.empno, e.ename, e.mgr, m.ename
FROm emp e left outer join emp m on e.mgr = m.empno;

--Right outer �� ����
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT outer join emp e on e.mgr = m.empno;

--ORACLE OUTER JOIN
--13���� ����(�����Ͱ� ���� ���� ���̺� �÷� �ڿ� (+)��ȣ�� �ٿ��ش�.
SELECT e.empno, e.ename, e.mgr, m.ename
FROm emp e, emp m 
WHERE e.mgr = m.empno(+);  

--���� sql�� ansi sql(outer join)���� �����غ�����
--�Ŵ����� �μ���ȣ�� 10���� ������ ��ȸ;
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno AND m.deptno = 10;

--WHERE ���� ������ ���� �߸��� ��ȸ����� ������(���� ���̰� ����)
--�Ʒ��� LEFT OUTER ������ ���������� OUTER������ �ƴϴ�
--�Ʒ� INNER ���ΰ� ����� �����ϴ�.
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno
WHERE m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m ON e.mgr = m.empno
WHERE m.deptno = 10;

--�ƿ��Ͱ� �ߵ� �Ƚ� ������ ����Ŭ outer join����

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno 
AND m.deptno = 10;

--1.�̰��� �߸��� ���̴�.
--����Ŭ outer join
--����Ŭ outer join�� ���� ���̺��� �ݴ��� ���̺��� ��� �÷��� (+)�� �ٿ���
--�������� outer join���� �����Ѵ�.
--�� �÷��̶� (+)�� �����ϸ� INNER �������� ����;

--�Ʒ��� oracle outer������ INNER�������� ���� : m.deptno �÷��� (+)���� ����
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

--���� �ƿ��͸� �ҷ��� 
--����Ŭ ��쿡�� �ƿ��͸� �ҋ� WHERE���� and���� �Ѵ� (+)�� ���̰�
--�Ƚð��� ��쿡�� where���� ���� ���� fROM ���� ����ؾ� �Ѵ�.(������)

--right outer join)
--��� - �Ŵ����� right outer join;\
SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m on (e.mgr = m.empno);

--Full outer : left outer + right outer = �ߺ�����
--LEFT OUTER : 14��, RIGHT OUTER : 21��
SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROm emp e FULL OUTER JOIN emp m on (e.mgr = m.empno);

--uter join �ǽ� outerjoin 1
--buyprod ���̺� �������ڰ� 2005�� 1�� 25���� �����ʹ� 3ǰ�� �ۿ� ����.
--��� ǰ���� ���ü� �ֵ��� ������ �ۼ� �غ�����.
--oracle outer������ (+)��ȣ�� �̿��Ͽ� FULL OUTER ������ �������� �ʴ´�.
SELECT *
FROM prod;

SELECT *
FROm buyprod;

SELECT b.buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM prod a left outer join buyprod b on a.prod_id = b.buy_prod and b.buy_date = TO_DATE('20050125','YYYYMMDD');


--outer join �ǽ� outerjoin 2
--outerjoin 1���� �۾��� �����ϼ���. buy_date �÷��� null�� �׸��� �ȳ�������
--����ó�� �����͸� ä�������� ������ �ۼ� �ϼ���.
SELECT nvl(b.buy_date,'2005/01/25')buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM prod a left outer join buyprod b on a.prod_id = b.buy_prod and b.buy_date = TO_DATE('20050125','YYYYMMDD');

--outer join �ǽ� outerjoin 3
--outerjoin2���� �۾��� �����ϼ���. buy_qty�÷��� null�� ��� 0���� ���̵��� ������ �����ϼ���.
SELECT nvl(b.buy_date,'2005/01/25'), b.buy_prod, a.prod_id, a.prod_name, nvl(b.buy_qty,0)
FROm prod a left outer join buyprod b on a.prod_id = b.buy_prod and b.buy_date = TO_DATE('20050125','YYYYMMDD');

--outer join �ǽ� outerjoin 4
--cycle, product���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ ��Ī�� ǥ���ϰ�, �������� �ʴ� ��ǰ�� ������
--���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
--(���� cid =1�� ���� �������� ����, nulló��)
SELECT *
FROM cycle;

SELECt *
FROM product;

SELECT a.pid, b.pnm, a.cid, a.day, a.cnt
FROM cycle a left outer join product b on a.pid = b.pid
WHERE a.cid = 1;

--outer join �ǽ� outerjoin 5
--cycle, product, customer ���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ ��Ī�� ǥ���ϰ�, 
--�������� �ʴ� ��ǰ�� ������ ���� ��ȸ�Ǹ� ���̸��� �����Ͽ� ������ �ۼ��ϼ���.
--(���� cid = 1�� ���� �������� ����, nulló��)
SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT *
FROM customer;

SELECT a.pid, b.pnm, a.cid, c.cnm, a.day, a.cnt
FROM cycle a left join product b on a.pid = b.pid
join customer c on a.cid = c.cid and a.cid = 1;


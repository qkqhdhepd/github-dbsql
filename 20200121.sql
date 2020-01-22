--�ǽ� select1
--PROD ���̺��� ��� �÷��� �ڷ� ��ȸ
SELECT *
FROM prod;
--PROD ���̺��� PROD_ID, PROD_NAME �÷��� �ڷḸ ��ȸ
SELECT prod_id, prod_name
FROM prod;
--1prod ���̺��� ��� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT *
FROM lprod;
--buyer ���̺��� buyer_id, buyer_name�÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT buyer_id, buyer_name
FROM buyer;
--cart ���̺��� ��� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT *
FROM cart;
--member ���̺��� mem_id, mem_pass, mem_name�÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT mem_id, mem_pass, mem_name
FROM member;
--users ���̺� ��ȸ
SELECT *
FROM users;
--���̺� � �÷��� �ִ��� Ȯ���ϴ� ���
--1. SELECT *
--2. TOOL�� ���(�����-TABLES)
--3. DESC ���̺��(DESE-DESCRIBE)
DESC users;

--users ���̺��� userid,usernm,reg_dt�÷��� ��ȸ�ϴ� sql�� �ۼ��ϼ���.
--��¥ ����(reg_dt �÷��� date������ ������ �ִ� Ÿ��)
--SQL ��¥ �÷� + (���ϱ� ����)
--�������� ��Ģ������ �ƴѰ͵� (5+5)�̷����� ������
--String h = "hello"l;
--String w = "world";
--String hw = h+w; --�ڹٿ����� �� ���ڿ��� ����
--SQL���� ���ǵ� ��¥ ���� : ��¥ + ���� = ��¥���� ������ ���ڷ� ����Ͽ� ���� ��¥�� �ȴ�.
--(2019/01/28 + 5 = 2019/02/02)
--reg_dt : ������� �÷�
--null : ���� �𸣴� ����
--null�� ���� ���� ����� �׻� null�̴�.
SELECT userid, usernm, reg_dt, reg_dt + 5 AS reg_dt_after_5day
FROM users;

--�ǽ� select2
--prod���̺��� prod_id, prod_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--(�� prod_id ->id, prod_name->name���� �÷� ��Ī�� ����)
SELECT prod_id id, prod_name name
FROM prod;

--lprod���̺��� lprod_gu, lprod_nm �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--(�� lprod_gu ->gu, lprod_nm ->nm���� �÷� ��Ī�� ����)
SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

--buyer ���̺��� buyer_id, buyer_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--(�� buyer_id ->���̾���̵�, buyer_name -> �̸����� �÷� ��Ī�� ����)
SELECT buyer_id AS ���̾���̵�, buyer_name �̸�
FROM buyer;

--���ڿ� ����
--�ڹ� ���� ���ڿ� ���� : + ("Hello" + "world")
--SQL������ : || ('Hello' || 'world')
--SQL������ : concat('Hello','world')

--userid, usernm�÷��� ����, ��Ī id_name
SELECT userid || usernm id_name
FROM users;

SELECT concat(userid, usernm) concat_id_name
FROM users;

--����, ���
--������ int a = 5; Stfrin msg = "HelloWorld";
--//������ �̿��� ���
-- System.out.println(msg);
--//����� �̿��� ���
--System.out.println("hello,world");

--SQL������ ������ ����(�÷��� ����� ����, pl/sql ���� ������ ����)
--SQL ���� ���ڿ� ����� �̱� �����̼����� ǥ��
--"Hello, World" --> 'Hello, World'

--���ڿ� ����� �÷����� ����
--user id : brown
--uwer id : cony
SELECT 'user id : ' || userid AS userid
FROM users;
--double quotation ���� : �÷��� ��Ī�� ����� �� ������ ����� �� ���� ������ ""�� ������ ��밡���ϴ�.
SELECT 'user id : ' || userid  "user id"
FROM users;

--���� ������ ����ڰ� ������ ���̺� ����� ��ȸ
SELECT *
FROM USER_TABLES;

--���ڿ� ������ �̿��Ͽ� ������ ���� ��ȸ �ǵ��� ������ �ۼ��϶�
SELECT * 
FROM emp;

SELECT concat(concat('SELECT * FROM', TABLE_NAME), ';')
FROM USER_TABLES;

--JAVA������ = ���Կ����������� SQL������ = equal�̴�.
--JAVA������ ==�� �񱳿������̴�.
--SQL������ ������ ������ ����(PL/SQL)

--users�� ���̺��� ��� �࿡ ���ؼ� ��ȸ
--users���� 5���� �����Ͱ� ����
SELECT *
FROM users;

--WHERE�� : ���̺��� �����͸� ��ȸ�� �� ���ǿ� �´� �ุ ��ȸ

--ex- userid �÷��� ���� brown�� �ุ ��ȸ
--brown, 'brown' ����
--�÷�, ���ڿ� ���
SELECT *
FROM users
WHERE userid = 'brown'; 
--DESC user

--userid�� brown�� �ƴ� �ุ ��ȸ (!=,<>�� �����ڸ� ����ϸ� �ȴ�.)
SELECT *
FROM users
WHERE userid != 'brown';

--emp���̺� �����ϴ� �÷��� Ȯ�� �غ�����.
SELECT *
FROM emp;

--emp ���̺��� ename�÷� ���� JONES�� �ุ ��ȸ
--SQL KEY WORD�� ��ҹ��ڸ� ������ ������ �÷��� ���̳�, ���ڿ� ����� ��ҹ��ڸ� ������.
--'JONES','Jones'�� ���� �ٸ� ����̴�.
SELECT *
FROM emp
WHERE ename = 'JONES';

SELECT *
FROM emp; --employee

DESC emp;
--5 > 10 FALSE
--5 > 5 FALSE
--5 >= 5 TRUE

--emp���̺��� deptno(�μ���ȣ)�� 30���� ũ�ų� ���� ����鸸 ��ȸ
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE deptno >= 30;

--���ڿ� : '���ڿ�'
--���� : 50
--��¥ : ??? ->�Լ��� ���ڿ��� �����Ͽ� ǥ��, ���ڿ��� �̿��Ͽ� ǥ�� ���� (�������� ����)
--      �������� ��¥ ǥ�� ���
--      �ѱ� : �⵵4�ڸ�-��2�ڸ�-����2�ڸ�
--      �̱� : ��2�ڸ�-����2�ڸ�-�⵵4�ڸ�

--�Ի����ڰ� 1980�� 12�� 17�� ������ ��ȸ
SELECT *
FROM emp
WHERE hiredate = '80/12/17';
--TO_DATE : ���ڿ��� dateŸ������ �����ϴ� �Լ�
--TO_DATE(��¥ ���� ���ڿ�, ù��° ������ ����)
--'1980/02/03'�� 2��3�������� ��ǻ�� ���忡�� �� �� ����.
SELECT *
FROM emp
WHERE hiredate = TO_DATE('19801217','YYYYMMDD');

SELECT *
FROM emp
WHERE hiredate = TO_DATE('1980/12/17','YYYY/MM/DD');

--��������
--sal�÷��� ���� 1000���� 2000������ ���
--sal >=1000
--sal <=2000
SELECT *
FROM emp;

--AND �������� ����
SELECT *
FROM emp
WHERE sal>=1000 AND sal<=2000;

--���������ڸ� �ε�ȣ ��ſ� BETWEEN AND �����ڷ� ��ü
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;
-- AND�����ڴ� ��� ����� �� �ִ� (������ ���������� ��µǴ� �����Ͱ� ��������.)
SELECT *
FROM emp
WHERE sal>=1000 AND sal<=2000
AND deptno = 30;

--emp���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� 
--ename, hiredate �����͸� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01','YYYY/MM/DD') AND TO_DATE('1983/01/01','YYYY/MM/DD');

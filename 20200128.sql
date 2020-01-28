--order by4
--emp ���̺��� 10�μ�(deptno) Ȥ�� 30�� �μ��� ���ϴ� ����� �޿�(sal)��
--1500�� �Ѵ� ����鸸 ��ȸ�ϰ� �̸����� �������� ���ĵǵ��� ������ �ۼ��ϼ���.
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ename desc;


--ROWNUM : ���ȣ�� ��Ÿ���� �÷�
SELECT ROWNUM, empno, ename
FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ename desc;

--ROWNUM �� WHERE �������� ��밡��
--�����ϴ°� : ROWNUM = 1, ROWNUM <= 2;  ROWNUM = 1, ROWNUM <= N
--�������� ���� ��: ROWNUM = 2, ROWNUM >= 2;   ROWNUM= N(N�� 1�� �ƴ� ����), ROWNUM >= N (N�� 1�� �ƴ� ����)
--ROWNUM �̹� ���� �����Ϳ��ٰ� ������ �ο�
--������ : ORDER BY ���� SELECT �� ���Ŀ� ����
--���� ���� ����� ���� (ROWNUM�� �ο����� ���� ��)�� ��ȸ�� ���� ����.
--��� �뵵 : ����¡ ó��
--���̺� �ִ� ��� ���� ��ȸ�ϴ� ���� �ƴ϶� �츮�� ���ϴ� �������� �ش��ϴ� �� �����͸� ��ȸ�� �Ѵ�.
--����¡ ó���� �������, : 1 �������� �Ǽ�, ���� ����
--emp���̺� �� row�Ǽ� : 14
--����¡�� 5���� �����͸� ��ȸ
--1page : 1-5
--2page : 6-10
--3page : 11-15
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM =1;

SELECT ROWNUM rn, empno, ename
FROM emp
ORDER by ename;

--���ĵ� ����� ROWNUM�� �ο� �ϱ� ���ؼ��� IN - LINE VIEW�� ����Ѵ�.
--�������� : 1.����, 2.ROWNUM �ο�

--SELECT *�� ����� ��� �ٸ� EXPRESSION�� ǥ�� �ϱ� ���ؼ� ���̺��.* ���̺��Ī.*�� ǥ���ؾ� �Ѵ�.
SELECT ROWNUM, emp.*
FROM emp;
SELECT ROWNUM, e.*
FROM emp e;


SELECT ROWNUM rn,e.*
FROM
    (SELECT empno, ename
    FROM emp 
    ORDER BY ename)e;
    
SELECT *
FROM 
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp 
        ORDER BY ename) a)
WHERE rn = 2;

--1page : rn 1-5  ,���� ������ ename
--2page : rn 6-10   --WHERE rn BETWEEN 6 AND 10;
--3page : rn 11-15  --WHERE rn BETWEEN 11 AND 15;
-- n page: rn (n-1) * pageSize + 1 ~ n * pageSize
SELECT *
FROM 
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp 
        ORDER BY ename) a)
WHERE rn >=1 AND rn <= 10;
--WHERE rn BETWEEN 6 AND 10;

SELECT *
FROM 
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp 
        ORDER BY ename) a)
WHERE rn BETWEEN (3 - 1) * 5 AND 3 * 5;

--row1
--emp ���̺��� ROWNUM ���� 1~10�� ���� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�(���� ���� ����)
SELECT ROWNUM rn,e.*
FROM emp e
WHERE rn <=10;
-----------------------------------------------

SELECT ROWNUM rn, a.*
FROM
    (SELECT empno, ename
    FROM emp) a
WHERE rn <=10;

-----------------------------------------------
SELECT *
FROM 
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp ) a)
WHERE rn <=10;
--sem
SELECT ROWNUM rn, empno, ename
from emp
WHERE rownum <=10;

--row2
--ROWNUM ���� 11~20(11~14)�� ���� ��ȸ�ϴ� ������ �ۼ��غ�����.
SELECT *
FROM 
    (SELECT ROWNUM rn,empno, ename
    FROM emp)
WHERE rn BETWEEN 11 and 20;

--row 3
--������ ����
--emp���̺��� ��� ������ �̸��÷����� �������� ���� ���� ���� 11~14��° ���� ������ ���� ��ȸ�ϴ� ������ �ۼ��غ�����
SELECT *
FROM emp;
--�켱 emp���̺��� order by �� �����Ͽ� ��ȸ���Ѵ�.
--ROWNUM�� ����ϱ� ����   ORDER BY ������ FROM ���� ��� �����Ų��.(�д� ������ ORDER BY�� �������̱⶧����)
--���������� WHERE ���� ����Ͽ� ������ �ֱ� ���ؼ� �ѹ��� FROM ���� ���´� (�������� ����� �� ������ ���̺��� �о�� ������ ����)

SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a;
--  WHERE rn BETWEEN 11 AND 14;      --������ �ߴµ� RN�� �ν��� �� ���ٰ� ��
--���� ������--
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN 11 AND 14;
--WHERE rn BETWEEN (1 - 1)*10 + 1 AND 1 * 10;   ->���ε� ����(�ڹٶ� �����Ǿ� n���� ����)
--WHERE rn BETWEEN (1page - 1)*pageSize + 1 AND 1page * pageSize;

--sql���� ������ �����ϴ� ���
--WHERE rn BETWEEN (:page - 1)*:pageSize + 1 AND :page * :pageSize;
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN (:page - 1)*:pageSize + 1 AND :page * :pageSize;

--sql������ �ΰ����� �Լ��� ����Ѵ�.
--Single row function
--Multi row function

--DUAL ���̺� : �����Ϳ� ���� ����, �Լ��� �׽�Ʈ �غ� �������� ���
SELECT *
FROM dual;

SELECT LENGTH ('TEST')
FROM dual;
--���ڿ��� ��ҹ��� : lower, upper, initcap
SELECT LOWER('Hello, world'), UPPER('Hello, world'),INITCAP('Hello, world')
FROM dual;

SELECT LOWER(ename), UPPER(ename),INITCAP(ename)
FROM emp;
--�Լ��� WHERE �������� ��� ����
--��� �̸��� SMITH�� ����� ��ȸ
SELECT *
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE ename = :ename;

--sql�ۼ��� �Ʒ� ���´� ���� �ؾ��Ѵ�.
SELECT *
FROM emp
WHERE LOWER(ename) = :ename;
--sql ���� ������ �º��� �����Ͽ��� ������ ���� �ȵȴ�.
SELECT *
FROM emp
WHERE ename = UPPER(:ename);


--�� ���¸� ����ϰ� ����
SELECT CONCAT('Hello',', World') CONCAT, 
       SUBSTR('Hello, World', 1, 5)aub,
       LENGTH('Hello, World')len,
       INSTR('Hello, World','o') ins,
       INSTR('Hello, World','o', 6 ) ins2,
       LPAD('Hello, World',15,'*') lpad,
       RPAD('Hello, World',15,'*') rpad,
       REPLACE('Hello, World', 'H','T') REP,
       TRIM('Hello, World      ')TR, --������ ����
       TRIM('d' FROM 'Hello, World')TR --������ �ƴ� �ҹ��� d����
FROM dual;

--���� �Լ�
-- ROUND : �ݿø� (10.6�� �Ҽ��� ù��° �ڸ����� �ݿø� =>11)
-- TRUNC : ����(����)(10.6�� �Ҽ��� ù��° �ڸ����� ���� =>10)
-- ROUND, TURNC :���° �ڸ����� �ݿø�/���� (���ڰ� �ΰ���)
-- MOD : ������ ����(���� �ƴ϶� ������ ������ �� ������ ��)(13/5 =>���� 2�̰� �������� 3)

--ROUND(��� ���ڰ�, ���� ��� �ڸ���)
/*�ݿø� ����� �Ҽ��� ù��° �ڸ����� �������� ->�ι��� �ڸ����� �ݿø�*/
SELECT ROUND(105.54, 1), 
       ROUND(105.55, 1),       --�ݿø� ����� �Ҽ��� ù��° �ڸ����� ��������
       ROUND(105.55, 0),       --�ݿø� ����� �����θ� =>�Ҽ��� ù���� �ڸ����� �ݿø�
       ROUND(105.55, -1),      --�ݿø� ����� ���� �ڸ����� =>���� �ڸ����� �ݿø�
       ROUND(105.55)           --�ι��� ���ڸ� �Է����� ���� ��� 0�� ����Ǿ� ��������� ����
FROM dual;

SELECT TRUNC(105.54, 1),    --������ ����� �Ҽ��� ù���� �ڸ����� �������� =>�ι�° �ڸ����� ����
       TRUNC(105.55, 1),    --������ ����� �Ҽ��� ù��° �ڸ����� �������� ->�Ҽ��� �ι�° �ڸ����� ����
       TRUNC(105.55, 0),    --������ ����� ������(���� �ڸ�)���� �������� =>�Ҽ��� ù��° �ڸ����� ����
       TRUNC(105.55, -1),    --������ ����� 10�� �ڸ����� �������� =>���� �ڸ����� ����
       TRUNC(105.55)        --�ι��� ���ڸ� �Է����� ���� ��� 0�� ����
FROM dual;

--EMP ���̺��� ����� �޿�(sal)�� 1000���� ������ �� ���� ���϶�
SELECT ename, sal, sal/1000, TRUNC(sal/1000) SAL_Quotient
FROM emp;

--EMP ���̺��� ����� �޿�(sal)�� 1000���� ������ �� �������� ���϶�
SELECT ename, 
        sal, 
        sal/1000, 
        TRUNC(sal/1000) SAL_Quotient, 
        --�׻� ���������꿡�� 1000���� ������������ �ϸ� 0~999���� �̴�
        MOD(sal,1000) SAL_Reminder   
FROM emp;

DESC emp;

SELECT ename, hiredate
FROM emp;

--SYSDATE : ���� ����Ŭ ������ �ú��ʰ� ���Ե� ���� ������ �����ϴ� Ư���� �Լ�
--�Լ���(����1, ����2)
--date = ���� ���� ����
--1 =  �Ϸ�
--1�ð� = 1/24
SELECT SYSDATE
FROM dual;

SELECT SYSDATE +5, SYSDATE +1/24
FROM dual;

--���� ǥ�� : ����
--���� ǥ�� : �̱� �����̼� + ���ڿ� +�̱� �����̼� => '���ڿ�'
--��¥ ǥ�� : TO_DATE('���ڿ� ��¥ ��', '���ڿ� ��¥ ���� ǥ�� ����') 
-- =>TO_DATE('2020-01-24','yyyy-mm-dd')

SELECT ename, hiredate
FROm emp
WHERE ename = 'SMITH';

--����
--1.2019�� 12�� 31�� date������ ǥ��
--2.2019�� 12�� 31�� date������ ǥ���ϰ� 5�� ������¥
--3.���糯¥
--4.���� ��¥���� 3���� ��

SELECT SYSDATE
FROM dual;

SELECT SYSDATE - 28 lastday, SYSDATE -33 lastdat_before5, SYSDATE now, SYSDATE +3 now_before3
FROM dual;




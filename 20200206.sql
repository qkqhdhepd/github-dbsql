SELECT *
FROM
            (SELECT  a.sido, a.sigungu,  round(a.cnt/b.cnt,2) ��������            
            FROM
                (SELECT sido, sigungu, COUNT(*) cnt
                 FROM fastfood
                 WHERE gb IN ('KFC', '����ŷ', '�Ƶ�����')
                GROUP BY SIDO, SIGUNGU )a
             ,
                 (SELECT  sido, sigungu, COUNT(*) cnt
                    FROM fastfood
                    WHERE gb IN ('�Ե�����')
                    GROUP BY SIDO, SIGUNGU) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu
            ORDER BY �������� DESC);
            
-----------a�� 140�� b�� 188���� �����µ� �̴� kfc���� �Ƶ����� ���� ����ŷ ���� ���ؼ� �����ϸ� �����Ǵ� ��찡 �����.
----�̴� ��쿡 ���� �Ǵ� �����ϴ°ſ� ���� ������ �ɼ��� �ְ� �ƴҼ��� �ִ�.
SELECT a.sido, a.sigungu, round(a.cnt/b.cnt,2) ��������
    FROM 
    (SELECT SIDO, sigungu, count(*) cnt
    FROM fastfood
    WHERE gb IN ('KFC','�Ƶ�����','����ŷ')
    GROUP BY SIDO, sigungu) a
    ,
    (SELECT SIDO, sigungu, count(*) cnt
    FROM fastfood
    WHERE gb IN ('�Ե�����')
    GROUP BY SIDO, sigungu) b
WHERE a.sido = b.sido AND a.sigungu = b.sigungu
ORDER BY �������� DESC;
----------------------------------------------------------------------------

--�����ÿ� �ִ� 5���� �� �ܹ��� ����
--(kfc+����ŷ+�Ƶ�����)/�Ե�����
SELECT sido, count(*)
FROM fastfood
WHERE sido LIKE '%����%'
GROUP BY sido;

--����(KFC, ����ŷ, �Ƶ�����)
SELECT sido, sigungu, count(*)
FROM fastfood
WHERE sido = '����������'
AND gb IN ('����ŷ','KFC','�Ƶ�����')
GROUP BY sido, sigungu;

--�и�(�Ե�����)
SELECT sido, sigungu, count(*)
FROM fastfood
WHERE sido = '����������'
AND gb IN ('�Ե�����')
GROUP BY sido, sigungu;

SELECT a.sido, a.sigungu, round(a.cnt/b.cnt,2)
FROM 
    (SELECT sido, sigungu, count(*)cnt
    FROM fastfood
    WHERE sido = '����������'
    AND gb IN ('����ŷ','KFC','�Ƶ�����')
    GROUP BY sido, sigungu) a
    ,
    (SELECT sido, sigungu, count(*)cnt
    FROM fastfood
    WHERE sido = '����������'
    AND gb IN ('�Ե�����')
    GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu;
  
--fastfood ���̺��� �ѹ��� �д� ������� �ۼ��϶�

SELECT sido, sigungu, ROUND((kfc+burgerking+mac)/lot,2)burger_score
FROM
    (SELECT sido, sigungu, 
                    NVL(sum(DECODE(gb, 'KFC', 1)),0)kfc,  
                    NVL(sum(DECODE(gb, '����ŷ',1)),0)burgerking,
                    NVL(sum(DECODE(gb, '�Ƶ�����',1)),0) mac,
                    NVL(sum(DECODE(gb, '�Ե�����',1)),1) lot
    FROM fastfood
    WHERE gb IN('kfc','����ŷ','�Ƶ�����','�Ե�����')
    GROUP BY sido, sigungu)
ORDER BY burger_score DESC;


-----------------------------------------------------------------
SELECT sido, sigungu, round(sal/people)pri_sal
FROM tax
ORDER BY pri_sal DESC;

/*
�ܹ��� ����, ���κ� �ٷμҵ� �ݾ� ������ ���� �õ�����(����)
����, ���κ� �ٷμҵ� �ݾ����� ���� �� ROWnum�� ���� ������ �ο�

�ܹ��� ���� �õ�, �ܹ������� �ñ���, �ܹ�������, ���ݽõ�, ���� �ñ���, ���κ� �ٷμҵ��

����Ư����   �߱� 5.67     ����Ư����   ������     70
����Ư����   ������ 5       ����Ư����   ���ʱ�     69
��⵵     ������ 5       ����Ư����   ��걸     57
����Ư����   ������       ��⵵         ��õ��     54
����Ư����   ���ʱ�     ����Ư����       ���α�     47
*/
----------------------------------------------------------
SELECT a.*, b.*
FROM 
    (SELECT a.*, ROWNUM RN 
     FROM
        (SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l,
               round(a.cnt/b.cnt, 2) ��������
        FROM 
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
             FROM fastfood
             WHERE gb IN ('KFC', '����ŷ', '�Ƶ�����')
             GROUP BY SIDO, SIGUNGU) a
            ,
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
             FROM fastfood
             WHERE gb IN ('�Ե�����')
             GROUP BY SIDO, SIGUNGU) b
        WHERE a.sido = b.sido
        AND a.sigungu = b.sigungu
        ORDER BY �������� DESC )a ) a,
    
        (SELECT b.*, rownum rn
         FROM 
            (SELECT sido, sigungu, round(sal/people)pri_sal
             FROM TAX
             ORDER BY pri_sal DESC) b ) b
WHERE b.rn = a.rn
ORDER BY b.rn;


--DML
DESC emp;
--������ ��������
--empno���� ������ ���־�� ������ NOT NULL�μ� ������ ����� �Ѵ�.
--empno�÷��� not null ���� ������ �ִ� - INSERT �� �ݵ�� ���� �����ؾ� ���������� �Էµȴ�.
--empno�÷��� ������ ������ �÷��� NULLABLE �̴�(null������ ����� �� �ִ�)
INSERT INTO emp (empno, ename, job)
VALUES (9999, 'brown',NULL);

SELECT *
FROM emp;

INSERT INTO emp (ename,job)
VALUES ('sally','SALESMAN');
/*����� 152 �࿡�� �����ϴ� �� ���� �߻� -
INSERT INTO emp (ename,job)
VALUES ('sally','SALESMAN')
���� ���� -
ORA-01400: cannot insert NULL into ("LMH"."EMP"."EMPNO")*/


--���ڿ� : '���ڿ�' => "���ڿ�"
--���� : 10
--��¥ : TO_DATE('20200206','YYYYMMDD'), SYSDATE
--emp ���̺��� hiredate �÷��� dateŸ���̴�.
--emp ���̺��� 8���� �÷��� ���� �Է�
DESC emp;
INSERT INTO emp VALUES(9998,'sally','SALESMAN',NULL, SYSDATE, 1000, NULL, 99);

SELECT *
FROM emp;

ROLLBACK;

--�������� �����͸� �ѹ��� INSERT : 
--INSERT INTO ���̺�� (�÷���1,�÷���2 ....)
--SELECT ...
--FROM

INSERT INTO emp
SELECT 9998,'sally','SALESMAN',NULL, SYSDATE, 1000, NULL, 99
FROM dual
    UNION ALL 
SELECT 9999,'brown','CLERK',NULL,TO_DATE('20200205','YYYYMMDD'),1100,null,99
FROM dual;

SELECT *
FROM emp;

--UPDATE ����
--UPDATE ���̺�� SET �÷���1 = ������ �÷� ��1, �÷���2 = ������ �÷� ��2...
--WHERE �� ���� ����;
--������Ʈ ���� �ۼ���WHERE ���� �������� ������ �ش� ���̺��� ��� ���� ������� ������Ʈ�� �Ͼ��.
--UPDATE, DELETE���� WHERE���� ������ �ǵ��Ѱ� �´��� �ٽ� �ѹ� Ȯ���Ѵ�.


--WHERE ���� �ִٰ� �ϴ��� �ش� �������� �ش� ���̺��� SELECT �ϴ� ������ �ۼ��Ͽ� �����ϸ�
--UPDATE��� ���� ��ȸ �Ҽ� �����Ƿ� Ȯ���ϰ� �����ϴ� �͵� ��� �߻� ������ ������ �ȴ�.

--99�� �μ���ȣ�� ���� �μ� ������ DEPT ���̺� �ִ� ��Ȳ
INSERT INTO dept VALUES (99,'ddit','daejeon');
commit;

SELECt *
FROM dept;

--99�� �μ���ȣ�� ���� �μ��� dname�÷��� ���� '��� IT',loc �÷��� ���� '���κ���'���� ������Ʈ
UPDATE dept SET dname = '���IT', loc = '���κ���'
WHERE deptno = 99;

SELECT *
FROM dept
WHERE deptno = 99;
ROLLBACK;
    
--�Ǽ��� WHERE���� ������� �ʾ��� ���
UPDATE dept SET dname = '���IT', loc = '���κ���';
--WHERE deptno = 99;

--�������� ù��° (���Ի�� ��) �Ǽ�
--����� - �ý��� ��ȣ�� �ؾ���� =>�Ѵ޿� �ѹ��� ��� ������� �������
                                -->���� �ֹι�ȣ ���ڸ��� ��й�ȣ�� ������Ʈ
--�ý��� ����� : �����(12,000), ������(550), ����(1,1300)
--update ����� SET ��й�ȣ = �ֹι�ȣ���ڸ�;

--���� ����������?
--�켱 where���� ������, �ֹι�ȣ���ڸ���null���̾���. ��� ��й�ȣ�� null�� ��
--UPDATE ����� SET ��й�ȣ = �ֹι�ȣ ���ڸ�
--WHERE ����� ���� = '�����'
--commit;

--�����͸� �����ϴ� ���α׷�

--10 -> subQUERY
--SMITH,WARD�� ���� �μ��� �Ҽӵ� ���� ����
SELECT *
FROM emp
WHERE deptno IN(20,30);

SELECT *
FROM emp
WHERE deptno IN(SELECT deptno
                FROM emp
                WHERE ename IN('SMITH','WARD'));
--update������ ���� ���� ����� �����ϴ�.
INSERT INTO emp (empno, ename)VALUES(9999,'brown');
--9999�� ��� deptno, job ������ SMITH ����� ���� �μ�����, �������� ������Ʈ
UPDATE emp SET deptno = (SELECT deptno
                        FROM emp
                        WHERE ename IN('SMITH')),
                job = (select job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;

SELECT *
FROM emp;

ROLLBACK;


--DELETE SQL : Ư�� ���� ����
--DELETE (FROM)
--WHERE �� ���� ����
SELECT *
FROM dept;

--99�� �μ���ȣ�� �ش��ϴ� �μ� ���� ����
DELETE dept
WHERE deptno = 99;

SELECT *
FROM dept;

commit;


--SUBQUERY�� ���ؼ� Ư�� ���� �����ϴ� ������ ���� DELETE
--�Ŵ����� 7499,7521,7654,7844,7698����� ������ �����ϴ� ������ �ۼ�;
SELECT *
FROM emp;

--DELETE emp
--WHERE mgr IN(7499,7521,7654,7844,7698);

DELETE emp
WHERE empno IN(SELECT empno
                FROM emp
                WHERE mgr = 7698);
                
SELECT *
FROM emp;

ROLLBACK;


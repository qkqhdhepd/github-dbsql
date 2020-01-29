--����
--1.2019�� 12�� 31�� date������ ǥ��
--2.2019�� 12�� 31�� date������ ǥ���ϰ� 5�� ������¥
--3.���糯¥
--4.���� ��¥���� 3���� ��

SELECT SYSDATE
FROM dual;

SELECT SYSDATE - 29 lastday, SYSDATE -34 lastdat_before5, SYSDATE now, SYSDATE +3 now_before3
FROM dual;

SELECT TO_DATE('20191231','yyyymmdd')lastday
FROM dual;

SELECT TO_DATE('20191231','yyyymmdd')-5 last_before5
FROM dual;

SELECT SYSDATE
FROM dual;


--DATE : TO_DATE ���ڿ� =>��¥(DATE)
--      TO_CHAR ��¥ =>���ڿ�(��¥ ���� ����)
--JAVA������ ��¥ ������ ��ҹ��ڸ� ������(MM/mm =>�� / ��)
--�ְ�����(1-7) : �Ͽ���1,������2....�����7
--���� IW : ISOǥ�� =>�ش����� ������� �������� ������ ����
--        2019/12/31 ������ =>2020/01/02(�����)�̱� ������ 1������ ���´�.
SELECT TO_CHAR(SYSDATE, 'YYYY-MM/DD HH24:MI:SS'),
       To_CHAR(SYSDATE, 'D'),    --������ 2020/01/29 (��)=>4
       TO_CHAR(SYSDATE, 'IW'),
       To_CHAR(TO_DATE('2019/12/31','YYYY/MM/DD'),'IW')
FROM dual;


--emp ���̺��� hiredate(�Ի�����) �÷��� ����� ��:��:��
SELECT ename, hiredate
FROM emp;

SELECT ename, TO_CHAR(hiredate, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(hiredate +1, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(hiredate +1/24, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(hiredate +1/48, 'YYYY-MM/DD HH24:MI:SS'),
       --hiredate�� 30���� ���Ͽ� TO_CHAR�� ǥ��
       TO_CHAR(hiredate +30/1440, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(hiredate +(1/24/60)*30, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(hiredate, 'D'),
       TO_CHAR(hiredate, 'IW')
FROM emp;

--fn2
--���� ��¥�� ������ ���� �������� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
1. ��-��-��
2. ��-��-�� �ð�(24)-��-��
3. ��-��-��
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24-MI-SS')DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY')DT_DD_MM_YYYY
FROM dual;


--FUNCTION(DATE)
--MONTHS_BETWEEN(DATE,DATE)
--���ڷ� ���ƿ� �� ��¥ ������ ������
SELECT ename, hiredate,
       MONTHS_BETWEEN(sysdate, hiredate),
       MONTHS_BETWEEN(TO_DATE('2020-01-17','YYYY-MM-DD'),hiredate)       
FROM emp
WHERE ename = 'SMITH';

--ADD_MONTHS(DATE,NUMBER), ����-������ ������ 
SELECT ADD_MONTHS(SYSDATE, 5), --2020/01/29 ->2020/06/29
       ADD_MONTHS(SYSDATE, -5)  --2020/01/29 ->2019/08/29
FROM dual;

--NEXT_DATE(DATE,weekday) : ex) NEXT_DATE(SYSDATE,5) =>SYSDATE���� 
--ó�� �����ϴ� �ְ����� 5(��)�� �ش��ϴ� ���� SYSDATE 2020/01/29 (��) ���� ó�� �����ϴ� 5(��) => 2020/01/30(��)
SELECT NEXT_DAY(SYSDATE, 5)
FROM dual;

--LAST_DATY(DATE) : DATE�� ���� ���� ������ ���ڸ� ����
SELECT LAST_DAY(SYSDATE)
FROM dual;

--LAST_DAY�� ���� ���ڷ� ���� date�� ���� ���� ������ ���ڸ� ���Ҽ� �ִµ� date�� ù��° ���ڴ� ��� ���ұ�?
SELECT SYSDATE, LAST_DAY(SYSDATE),LAST_DAY(SYSDATE)-30
FROM dual;

SELECT SYSDATE,
       LAST_DAY(SYSDATE),
       To_DATE('01','DD'),
       ADD_MONTHS(LAST_DAY(SYSDATE),-1)+1,
       ADD_MONTHS(LAST_DAY(SYSDATE +1),-1),
       To_DATE(TO_CHAR(SYSDATE,'YYYY-MM') || '-01' , 'YYYY-MM-DD')
FROM dual;

--hiredate���� �̿��Ͽ� �ش� ���� ù��° ���ڷ� ǥ��
SELECT ename, hiredate,
       LAST_DAY(hiredate),
       ADD_MONTHS(LAST_DAY(hiredate),-1)+1,
       To_DATE(TO_CHAR(hiredate,'YYYY-MM') || '-01' , 'YYYY-MM-DD')
FROM emp;

--empno�� NUMBER Ÿ��, ���ڴ� ���ڿ�
--Ÿ���� ���� �ʱ� ������ ������ ����ȯ�� �Ͼ.
--���̺� �÷��� Ÿ�Կ� �°� �ùٸ� ���� ���� �ִ°� �߿�
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM emp
WHERE empno = 7369;

--hiredate�� ��� dateŸ��, ���ڴ� ���ڿ��� �־����� ������ ������ ����ȯ�� �߻�
--��¥ ���ڿ� ���� ��¥ Ÿ������ ��������� ����ϴ� ���� ����
SELECT *
FROM emp
WHERE hiredate = '80/12/17';

SELECT *
FROM emp
WHERE hiredate = '1980/12/17';

---------------------------------------------------------------------------
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM table(dbms_xplan.display);
--�ڽ��� ������ �ڽĺ��� �д´�

--���ڸ� ���ڿ��� �����ϴ� ��� : ����
--õ���� ������
--1000�̶�� ���ڸ� 
--�ѱ� : 1,000.50
--���� : 1.000,50

--emp sal �÷�(NUMBER Ÿ��)�� ������
--9 : ����
--0 : ���� �ڸ� ����(0���� ǥ��)
--L : ��ȭ����
SELECT ename, sal, TO_CHAR(sal,'L9,999')
FROM emp;


--nulló��
--null�� ���� ������ ����� �׻� null
--emp ���̺��� sal�÷����� null�� �������� ����(14�ǿ� ���ؼ�)
--emp ���̺��� comm�÷����� null�� �����Ѵ�.
--sal + comm => comm�� null�� �࿡ ���ؼ��� ����� null�� ����
SELECT ename, sal, comm, sal+comm
FROM emp;

--comm�� null�̸� sal�÷��� ���� ��ȸ�ǵ��� �϶�(����)
SELECT ename, sal, comm, sal+comm
FROM emp;
--�׷��� �츮�� NVL�̶�� �Լ��� Ȱ���Ͽ� null�� �ذ��� �� �ִ�.
--NVL(Ÿ��, ��ü��)
--Ÿ���� ���� null�̸� ��ü���� ��ȯ�ϰ� Ÿ���� ���� null�� �ƴϸ� Ÿ�� ���� ��ȯ�Ѵ�.
--if(Ÿ�� == null)
--      return ��ü��;
--else
--      return Ÿ��;
SELECT ename, sal, comm, NVL(comm, 0), sal + NVL(comm,0)
FROM emp;


--NVL2(����1,����2, ����3)
--if(expr1 != null)
--      return expr2;
--else
--      return expr3;

SELECT ename, sal, comm, NVL2(comm, 10000, 0)
FROM emp;

--NULLIF(expr1, expr2)
--if(expr1 == expr2)
--      return null;
--else
--      return expr1;
SELECT ename, sal, comm, NULLIF(sal, 1250)  --sal�� 1250�� ����� null�� ����, �ƴѻ���� sal�� ����
FROM emp;


--��������
--COALESCE �����߿� ���� ó������ �����ϴ� NULL�� �ƴ� ���ڸ� ��ȯ
--COALESCE(expr1), expr2...)
--if (expr1 != nuill)
--      return expr1;
--else 
--      return COALESCE(expr2, expr3...);
--COALESCE(comm, sal) : comm�� null�� �ƴϸ� comm
--                    : comm�� null�̸�  sal (��, sal�÷��� ���� null�� �ƴҶ�)
SELECT ename, sal, comm, COALESCE(comm, sal)
FROM emp;


--fn4
--emp ���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.(NVL, NVL2, coalesce)
SELECT empno, ename, mgr,
       NVL(mgr,9999)mgr_N,
       NVL2(mgr,mgr,9999)mgr_N_1,
       coalesce(mgr, 9999) mgr_N_2
FROM emp;


--fn5
--users���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
--reg_dt�� null�� ��� sysdate�� ����
SELECT userid, usernm, reg_dt, NVL(reg_dt, sysdate) N_REG_DT
FROM users
WHERE userid NOT IN ('brown');

SELECT userid, usernm, reg_dt, NVL2(reg_dt, reg_dt, sysdate)N_REG_DT
FROM users
WHERE userid NOT IN ('brown');


--Condition : ������
--case : java�� if - else if - else
--CASE
--      WHEN ���� THEN ���ϰ�1
--      WHEN ����2 THEN ���ϰ�2
--      ELSE �⺻��
--END
--emp���̺��� job �÷��� ���� SALESMAN�̸� sal * 1.05����
--                          MANAGER �̸� sal * 1.1����
--                          PRESIDENT �̸� sal * 1.2����
--                          �׹��� ������� sal�� ����

SELECT ename,JOB,sal,
       case
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal
        END bonus_sal
FROM EMP;

--DECODE �Լ� : case���� ����
--(�ٸ��� CASE �� : WHEN ���� ���Ǻ񱳰� �����Ӵ�
--              DECODE�Լ� : �ϳ��� ���� ���ؼ� = �񱳸� ���
--DECODE �Լ�: �������� (������ ������ ��Ȳ�� ���� �þ ���� ����)
--DECODE(�÷�, ù��° ���ڿ� ���� ��1, ù��° ���ڿ� �ι�° ���ڰ� ���� ��� ��ȯ ��,
--          ù��° ���ڿ� ���� ��,ù��° ���ڿ� �׹�° ���ڰ� ���� ��� ��ȯ �� ...
--           option -else ǣ�������� ��ȯ�� �⺻��)

--emp���̺��� job �÷��� ���� SALESMAN�̸� sal * 1.05����
--                          MANAGER �̸� sal * 1.1����
--                          PRESIDENT �̸� sal * 1.2����
--                          �׹��� ������� sal�� ����
SELECT ename, job, sal,
       DECODE(job,'SALESMAN',sal * 1.05,
                  'MANAGER',sal* 1.1,
                  'PRESIDENT',sal * 1.2, sal) bonus_sal
       
FROM emp;



--emp���̺��� job �÷��� ���� 
--SALESMAN�̸鼭 sal�� 1400���� ũ�� sal * 1.05����
--SALESMAN�̸鼭 sal�� 1400���� ������ sal * 1.1����
--MANAGER �̸� sal * 1.1����
--PRESIDENT �̸� sal * 1.2����
--�׹��� ������� sal�� ����
--1.case�̿�
--2.decode�� ȥ��
SELECT ename,JOB,sal,
       case
            WHEN job = 'SALESMAN' and sal > 1400 THEN sal *1.05
            WHEN job = 'SALESMAN' and sal < 1400 THEN sal *1.1
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal
        END bonus_sal
FROM EMP;

SELECT ename,JOB,sal,
       case
            WHEN job = 'SALESMAN' and sal > 1400 THEN sal *1.05
            WHEN job = 'SALESMAN' and sal < 1400 THEN sal *1.1
            ELSE sal
        END bonus_sal,
        DECODE(job,'MANAGER',sal* 1.1,
                  'PRESIDENT',sal * 1.2, sal) bonus_sal
FROM EMP;





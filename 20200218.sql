--����� �������� (leaf => root node(���� node))
--��ü ��带 �湮�ϴ°� �ƴ϶� �ڽ��� �θ��常 �湮 (����İ� �ٸ���)
--������ : ��������
--������ : �����μ�
SELECT *
FROM dept_h;

SELECT dept_h.*,LEVEL, LPAD(' ',(LEVEL-1)*4) || deptnm
FROM dept_h
START WITH deptnm = '��������'
CONNECT BY PRIOR p_deptcd = deptcd;

--����Ŭ���� Pre_order�� ���������� ������.(���� �˻�)

SELECT *
FROM h_sum;

--�ǽ� h_4
--������ ���� ����.sql�� �̿��Ͽ� ���̺��� �����ϰ� ������ ���� ����� �������� ������ �ۼ��Ͻÿ�.
SELECT LPAD(' ', (LEVEL - 1)*4) || s_id,value
FROM h_sum
START WITH s_id = 0
CONNECT BY PRIOR s_id = ps_id;

--�ǽ� h_5
--������ ���� ��ũ��Ʈ.sql�� �̿��Ͽ� ���̺��� �����ϰ� ������ ���� ����� �������� ������ �ۼ��Ͻÿ�.
SELECT *
FROM no_emp;

SELECT LPAD(' ',(level -1)*4) || ORG_CD, NO_EMP
FROM no_emp
START WITH ORG_CD = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;


-----------------------------------------------------------
--������ ���� (Pruning branch = ��ġ ġ��)
--FROM -> START WITH, CONNECT BY ->WHERE
--1.WHERE : ���� ������ �ϰ� ���� ���� ����
--2. CONNECT BY : ���� ������ �ϴ� �������� ���� ����

--WHERE�� ����� : �� 9���� ���� ��ȸ�Ǵ� ���� Ȯ��
--WHERE�� (deptnm != '������ȹ��') : ������ȹ�θ� ������ 8���� �� ��ȸ�ϴ� �� Ȯ��
SELECT *
FROM no_emp;

SELECT LPAD(' ',(level -1)*4) || ORG_CD org_cd, NO_EMP
FROM no_emp
WHERE org_cd != '������ȹ��'
START WITH ORG_CD = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;


--CONNECT BY ���� ������ ���
SELECT LPAD(' ',(level -1)*4) || ORG_CD org_cd, NO_EMP
FROM no_emp
START WITH ORG_CD = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD
AND org_cd != '������ȹ��';

--WHERE ���� �������� ���� ����
--Ư���Լ�
--connect_by_root(col)
--sys_connect_by_path(col,'-')
--connect_by_isleaf isleaf

--CONNECT_BY_ROOT(�÷�) : �ش� �÷��� �ֻ��� ���� ���� ��ȯ
--SYS_CONNECT_BY_PATH(�÷�, ������): �ش� ���� �÷��� ���Ŀ� �÷� ���� ��õ, �����ڷ� �̾��ش�
--CONNECT_BY_ISLEAF : �ش� ���� LEAF ������� (����� �ڽ��� ������) ���� ����(1:LEAF, 0: no LEAF)

SELECT *
FROM dept_h;

SELECT LEVEL lv, deptcd,
	LPAD(' ',(LEVEL -1)*4)|| deptnm deptnm,p_deptcd,
	connect_by_root(deptnm)root,
	LTRIM(SYS_CONNECT_BY_PATH(deptnm,'-'),'-')path,
	connect_by_isleaf isleaf
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;



--�ǽ� h6
--�Խñ��� �����ϴ� board_test ���̺��� �̿��Ͽ� ���� ������ �ۼ��Ͻÿ�.
SELECT *
FROM board_test;

SELECT SEQ,LPAD(' ',(LEVEL -1)*4)|| TITLE title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ;

--�ǽ� h7
--�Խñ��� ���� �ֽű��� �ֻ����� �´�. ���� �ֽű��� ������ ���� �Ͻÿ�.
SELECT SEQ,LPAD(' ',(LEVEL -1)*4)|| TITLE title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER BY SEQ desc;


--�ǽ� h8
SELECT SEQ,LPAD(' ',(LEVEL -1)*4)|| TITLE title, level
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER siblings BY PARENT_SEQ ASC, SEQ DESC;

--h9
SELECT SEQ,LPAD(' ',(LEVEL -1)*4)|| TITLE title, level
FROM board_test
START WITH SEQ IN(4)
CONNECT BY PRIOR SEQ = PARENT_SEQ

UNION ALL

SELECT SEQ,LPAD(' ',(LEVEL -1)*4)|| TITLE title, level
FROM board_test
START WITH SEQ IN(1,2)
CONNECT BY PRIOR SEQ = PARENT_SEQ;

--�������� ���� ����� ������
SELECT seq, LPAD(' ',(level -1)*4) || title title, DECODE(PARENT_SEQ, null, seq, parent_seq) root
FROM board_test
START WITH parent_seq IS null
CONNECT BY PRIOR seq = parent_seq
ORDER siblings by root desc, seq asc;

SELECT *
FROM board_test;


--�׷��ȣ�� ������ �÷��� �߰�;
--�� �ึ�� �÷��� �߰��ؼ� �׷��� �־ ������ ���ָ� �ȴ�.
ALTER TABLE board_test ADD(gn number);

UPDATE board_test SET gn = 4
WHERE seq IN(4,5,6,7,8,10,11);

UPDATE board_test SET gn = 2
WHERE seq IN(2,3);

UPDATE board_test SET gn = 1
WHERE seq IN(1,9);

commit;

SELECT *
FROM board_test;

SELECT gn,seq, LPAD(' ',(level -1)*4) || title title
FROM board_test
START WITH parent_seq IS null
CONNECT BY PRIOR seq = parent_seq
ORDER siblings by gn desc, seq asc;

---------------------------------------------------------
--�м��Լ�

SELECT ename, sal, deptno
FROM emp
ORDER BY DEPTNO;

SELECT ename, sal, deptno, rownum sal_rank
FROM 
(SELECT ename, sal, deptno
FROM emp
WHERE deptno IN (10))

UNION ALL

SELECT ename, sal, deptno, rownum sal_rank
FROM 
(SELECT ename, sal, deptno
FROM emp
WHERE deptno IN (20))

UNION ALL

SELECT ename, sal, deptno, rownum sal_rank
FROM 
(SELECT ename, sal, deptno
FROM emp
WHERE deptno IN (30));

SELECT ename, sal, deptno, rownum sal_rank
FROM emp
WHERE deptno IN(30);











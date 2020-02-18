--상향식 계층쿼리 (leaf => root node(상위 node))
--전체 노드를 방문하는게 아니라 자신의 부모노드만 방문 (하향식과 다른점)
--시작점 : 디자인팀
--연결은 : 상위부서
SELECT *
FROM dept_h;

SELECT dept_h.*,LEVEL, LPAD(' ',(LEVEL-1)*4) || deptnm
FROM dept_h
START WITH deptnm = '디자인팀'
CONNECT BY PRIOR p_deptcd = deptcd;

--오라클에서 Pre_order의 계층쿼리를 가진다.(구글 검색)

SELECT *
FROM h_sum;

--실습 h_4
--계층형 쿼리 복습.sql을 이용하여 테이블을 생성하고 다음과 같은 결과가 나오도록 쿼리를 작성하시오.
SELECT LPAD(' ', (LEVEL - 1)*4) || s_id,value
FROM h_sum
START WITH s_id = 0
CONNECT BY PRIOR s_id = ps_id;

--실습 h_5
--계층형 쿼리 스크립트.sql을 이용하여 테이블을 생성하고 다음과 같은 결과가 나오도록 쿼리를 작성하시오.
SELECT *
FROM no_emp;

SELECT LPAD(' ',(level -1)*4) || ORG_CD, NO_EMP
FROM no_emp
START WITH ORG_CD = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;


-----------------------------------------------------------
--계층형 쿼리 (Pruning branch = 가치 치기)
--FROM -> START WITH, CONNECT BY ->WHERE
--1.WHERE : 계층 연결을 하고 나서 행을 제한
--2. CONNECT BY : 계층 연결을 하는 과정에서 행을 제한

--WHERE절 기술전 : 총 9개의 행이 조회되는 것을 확인
--WHERE절 (deptnm != '정보기획부') : 정보기획부를 제외한 8개의 행 조회하는 것 확인
SELECT *
FROM no_emp;

SELECT LPAD(' ',(level -1)*4) || ORG_CD org_cd, NO_EMP
FROM no_emp
WHERE org_cd != '정보기획부'
START WITH ORG_CD = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;


--CONNECT BY 절에 조건을 기술
SELECT LPAD(' ',(level -1)*4) || ORG_CD org_cd, NO_EMP
FROM no_emp
START WITH ORG_CD = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD
AND org_cd != '정보기획부';

--WHERE 절은 계층쿼리 이후 적용
--특수함수
--connect_by_root(col)
--sys_connect_by_path(col,'-')
--connect_by_isleaf isleaf

--CONNECT_BY_ROOT(컬럼) : 해당 컬럼의 최상위 행의 값을 반환
--SYS_CONNECT_BY_PATH(컬럼, 구분자): 해당 행의 컬럼이 거쳐온 컬럼 값을 추천, 구분자로 이어준다
--CONNECT_BY_ISLEAF : 해당 행이 LEAF 노드인지 (연결된 자식이 없는지) 값을 리턴(1:LEAF, 0: no LEAF)

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



--실습 h6
--게시글을 저장하는 board_test 테이블을 이용하여 계층 쿼리를 작성하시오.
SELECT *
FROM board_test;

SELECT SEQ,LPAD(' ',(LEVEL -1)*4)|| TITLE title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ;

--실습 h7
--게시글은 가장 최신글이 최상위로 온다. 가장 최신글이 오도록 정렬 하시오.
SELECT SEQ,LPAD(' ',(LEVEL -1)*4)|| TITLE title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER BY SEQ desc;


--실습 h8
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

--종원씨의 좋은 방법의 쿼리문
SELECT seq, LPAD(' ',(level -1)*4) || title title, DECODE(PARENT_SEQ, null, seq, parent_seq) root
FROM board_test
START WITH parent_seq IS null
CONNECT BY PRIOR seq = parent_seq
ORDER siblings by root desc, seq asc;

SELECT *
FROM board_test;


--그룹번호를 저장할 컬럼을 추가;
--각 행마다 컬럼을 추가해서 그룹을 주어서 정렬을 해주면 된다.
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
--분석함수

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











--트리거 문법
--CREATE [OR REPLACE] TRIGGER trigger_name
--	timing
--		event1 [OR event2...] ON table_name
--	
--	[FOR EACH ROW [WHEN (condition)]]
--		trigger_body

--users테이블에 비밀번호가 변경 될 때 변경되기 전의 비밀번호를 users_history 테이블로 이력을 생성하는 트리거 생성
SELECT *
FROM users;

--1.users_history 테이블 생성
CREATE TABLE users_history(
	user_id	varchar2(20),
	pass varchar2(100),
	mod_dt DATE,
	CONSTRAINT pk_users_history PRIMARY KEY(user_id, mod_dt)
);

--↑↑↑↑↑↑해당 테이블의 해당 컬럼에 해당 값이 한번만 존재해야 한다. (PK)
--↑↑↑↑↑↑근데 여기서user_id를 키로 잡으면 패스워드가 변경될 때 아이디가 여러개가 생성되는데 한개만 생성되야 하므로 패스워드가 변경이 안됨
--해결책으로 user_id와 pass를 같이 제약 걸어야한다.

COMMENT ON TABLE users_history IS '사용자 비밀번호 이력';
COMMENT ON COLUMN users_history.user_id IS '사용자 아이디';
COMMENT ON COLUMN users_history.pass IS '비밀번호';
COMMENT ON COLUMN users_history.mod_dt IS '수정일시';

SELECT *
FROM user_col_COMMENTS
WHERE TABLE_NAME IN('USERS_HISTORY');

--2.USERS 테이블의 PASS 컬럼 변경을 감지할 TRIGGER를 생성;
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER make_history
	BEFORE UPDATE ON users
	FOR EACH ROW
	
	BEGIN
--		비밀번호가 변경 된 경우를 체크
--		기존 비밀번호/ 업데이트 하려고하는 신규 비밀번호
--		:OLD.컬럼/ :NEW.컬럼
		IF (:NEW.pass != :OLD.pass) THEN
			INSERT INTO users_history VALUES (:NEW.user_id, :OLD.pass, SYSDATE);
		END IF;
END;
/

--3. 트리거 확인
--	1. USERS_HISTORY에 데이터가 없는 것을 확인
--	2. USERS테이블의 BROWN 사용자의 비밀번호를 업데이트
--	3. USERS_HISTORY 테이블에 데이터가 생성이 되었는지(트리거를 통해)확인
--	4. USERS 테이블의 브라운 사용자의 별명을 업데이트
--	5. users_history테이블에 데이터가 생성이 되었는지 트리거를 통해 확인

--1.
SELECT*
FROM users_history;

--2.
UPDATE users
set pass='test'
WHERE userid = 'brown';

--3.
SELECT *
FROM USER_history;

--4.
SELECT users set (alias = '수정')
FROM user_history;

--5.
SELECT *
FROM users_history;



--mybatis :
--java를 이용하여 데이터베이스 프로그래밍 : jdbc
--jdbc가 코드의 중복이 심하다
--SQL을 실행할 준비
--SQL을 실행할 준비
--SQL을 실행할 준비
--SQL을 실행할 준비
--
--SQL 실행
--
--SQL실행 환경 close
--SQL실행 환경 close
--SQL실행 환경 close
--SQL실행 환경 close

--1.설정 -> mybatis 개발자가 정해놓은 방식으로 따라야...
--sql 실행하기 위해서는 dbms가 필요(연결정보 필요) -> xml
--마이바티스에서 제공해주는 클래스를 이용
--sql을 자바 코드에다가 직접 작성하는게 아니가 xml문서에 sql에 임의로 부여하는 id를 통해 관리한다.


2.활용

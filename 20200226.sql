--Ʈ���� ����
--CREATE [OR REPLACE] TRIGGER trigger_name
--	timing
--		event1 [OR event2...] ON table_name
--	
--	[FOR EACH ROW [WHEN (condition)]]
--		trigger_body

--users���̺� ��й�ȣ�� ���� �� �� ����Ǳ� ���� ��й�ȣ�� users_history ���̺�� �̷��� �����ϴ� Ʈ���� ����
SELECT *
FROM users;

--1.users_history ���̺� ����
CREATE TABLE users_history(
	user_id	varchar2(20),
	pass varchar2(100),
	mod_dt DATE,
	CONSTRAINT pk_users_history PRIMARY KEY(user_id, mod_dt)
);

--��������ش� ���̺��� �ش� �÷��� �ش� ���� �ѹ��� �����ؾ� �Ѵ�. (PK)
--�������ٵ� ���⼭user_id�� Ű�� ������ �н����尡 ����� �� ���̵� �������� �����Ǵµ� �Ѱ��� �����Ǿ� �ϹǷ� �н����尡 ������ �ȵ�
--�ذ�å���� user_id�� pass�� ���� ���� �ɾ���Ѵ�.

COMMENT ON TABLE users_history IS '����� ��й�ȣ �̷�';
COMMENT ON COLUMN users_history.user_id IS '����� ���̵�';
COMMENT ON COLUMN users_history.pass IS '��й�ȣ';
COMMENT ON COLUMN users_history.mod_dt IS '�����Ͻ�';

SELECT *
FROM user_col_COMMENTS
WHERE TABLE_NAME IN('USERS_HISTORY');

--2.USERS ���̺��� PASS �÷� ������ ������ TRIGGER�� ����;
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER make_history
	BEFORE UPDATE ON users
	FOR EACH ROW
	
	BEGIN
--		��й�ȣ�� ���� �� ��츦 üũ
--		���� ��й�ȣ/ ������Ʈ �Ϸ����ϴ� �ű� ��й�ȣ
--		:OLD.�÷�/ :NEW.�÷�
		IF (:NEW.pass != :OLD.pass) THEN
			INSERT INTO users_history VALUES (:NEW.user_id, :OLD.pass, SYSDATE);
		END IF;
END;
/

--3. Ʈ���� Ȯ��
--	1. USERS_HISTORY�� �����Ͱ� ���� ���� Ȯ��
--	2. USERS���̺��� BROWN ������� ��й�ȣ�� ������Ʈ
--	3. USERS_HISTORY ���̺� �����Ͱ� ������ �Ǿ�����(Ʈ���Ÿ� ����)Ȯ��
--	4. USERS ���̺��� ���� ������� ������ ������Ʈ
--	5. users_history���̺� �����Ͱ� ������ �Ǿ����� Ʈ���Ÿ� ���� Ȯ��

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
SELECT users set (alias = '����')
FROM user_history;

--5.
SELECT *
FROM users_history;



--mybatis :
--java�� �̿��Ͽ� �����ͺ��̽� ���α׷��� : jdbc
--jdbc�� �ڵ��� �ߺ��� ���ϴ�
--SQL�� ������ �غ�
--SQL�� ������ �غ�
--SQL�� ������ �غ�
--SQL�� ������ �غ�
--
--SQL ����
--
--SQL���� ȯ�� close
--SQL���� ȯ�� close
--SQL���� ȯ�� close
--SQL���� ȯ�� close

--1.���� -> mybatis �����ڰ� ���س��� ������� �����...
--sql �����ϱ� ���ؼ��� dbms�� �ʿ�(�������� �ʿ�) -> xml
--���̹�Ƽ������ �������ִ� Ŭ������ �̿�
--sql�� �ڹ� �ڵ忡�ٰ� ���� �ۼ��ϴ°� �ƴϰ� xml������ sql�� ���Ƿ� �ο��ϴ� id�� ���� �����Ѵ�.


2.Ȱ��

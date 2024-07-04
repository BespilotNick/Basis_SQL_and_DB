DROP DATABASE IF EXISTS hometask_6;
CREATE DATABASE hometask_6;

USE hometask_6;

-- 1. Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old. 
--     (использование транзакции с выбором commit или rollback – обязательно).

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old LIKE hometask_4.users;

DROP PROCEDURE IF EXISTS sp_moving_user;
DELIMITER //
CREATE PROCEDURE sp_moving_user(user_num INT,
OUT  tran_result VARCHAR(100), presence VARCHAR(100))
	BEGIN
		
		DECLARE `_rollback` BIT DEFAULT b'0';
		DECLARE code VARCHAR(100);
		DECLARE error_string VARCHAR(100); 
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
			SET `_rollback` = b'1';
			GET stacked DIAGNOSTICS CONDITION 1
				code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
		END;
        
        START TRANSACTION;
        
			IF NOT EXISTS(SELECT id FROM hometask_4.users WHERE hometask_4.users.id = user_num) THEN
				SET presence = 'Ошибка: указано значение id, которое отсуствует в таблице users';
				ROLLBACK;
			ELSEIF EXISTS(SELECT id FROM hometask_6.users_old WHERE hometask_6.users_old.id = user_num) THEN
				SET presence = 'Ошибка: указано значение id, которое уже существует в таблице users_old';
				ROLLBACK;
			ELSE
				SET presence = 'OK';
			END IF;
        
			INSERT INTO users_old SELECT * FROM hometask_4.users WHERE hometask_4.users.id = user_num;
			-- SAVEPOINT save_point_1;
			DELETE FROM hometask_4.users WHERE hometask_4.users.id = user_num LIMIT 1;
        
        IF `_rollback` THEN
			SET tran_result = CONCAT('УПС. Ошибка: ', code, ' Текст ошибки: ', error_string);
			ROLLBACK;
		ELSE
			SET tran_result = 'OK';
			COMMIT;
		END IF;
        
    END //
DELIMITER ;

CALL sp_moving_user(2, @tran_result, @presence);
SELECT @presence, @tran_result;

DROP TRIGGER IF EXISTS check_presence; 
DELIMITER //
CREATE TRIGGER check_presence 
BEFORE INSERT ON hometask_6.users_old
FOR EACH ROW
BEGIN
	IF NEW.id IN (SELECT id FROM hometask_6.users_old) THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Ошибка: указано значение id, которое уже существует в таблице users_old';
    END IF;
END//
DELIMITER ;

/*
-- USE hometask_4
DROP TRIGGER IF EXISTS check_absence; 
DELIMITER //
CREATE TRIGGER check_absence 
BEFORE DELETE ON hometask_4.users
FOR EACH ROW
BEGIN
	IF NOT EXISTS(SELECT id FROM hometask_4.users WHERE hometask_4.users.id = user_num) THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Ошибка: указано значение id, которое отсуствует в таблице users';
    END IF;
END//
DELIMITER ;
*/


-- 2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
--     с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;

DELIMITER //
CREATE FUNCTION hello()
RETURNS VARCHAR(15) READS SQL DATA
BEGIN
	
    DECLARE msg VARCHAR(15);
    
    IF CURRENT_TIME BETWEEN '06:00:00' AND '11:59:00' THEN
		SET msg = 'Доброе утро!';
    ELSEIF CURRENT_TIME BETWEEN '12:00:00' AND '17:59:59' THEN
		SET msg = 'Добрый день!';
    ELSEIF CURRENT_TIME BETWEEN '18:00:00' AND '23:59:59' THEN
		SET msg = 'Добрый вечер!';
    ELSE
		SET msg = 'Доброй ночи!';
	END IF;
    
    RETURN msg;
END //
DELIMITER ;

SELECT hello();


-- 3. (по желанию)* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, communities и messages в таблицу logs помещается время и дата создания записи, 
--     название таблицы, идентификатор первичного ключа.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs(
oper_num SERIAL,
oper_time TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
used_table VARCHAR(45),
id_prime_k BIGINT
)
ENGINE ARCHIVE;


DROP TRIGGER IF EXISTS new_ins_users;
DELIMITER //
CREATE TRIGGER new_ins_users
AFTER INSERT ON hometask_4.users
FOR EACH ROW
BEGIN
	INSERT INTO hometask_6.logs SET used_table = 'users', id_prime_k = NEW.id;
END //
DELIMITER ;

-- Проверка
INSERT INTO hometask_4.users (id, firstname, lastname, email) VALUES 
(11, 'Stephen', 'King', 'TheShawshankRedemption@example.org'),
(12, 'Ray', 'Bradbury', 'Fahrenheit451@example.org');


DROP TRIGGER IF EXISTS new_ins_communities;
DELIMITER //
CREATE TRIGGER new_ins_communities
AFTER INSERT ON hometask_4.communities
FOR EACH ROW
BEGIN
	INSERT INTO hometask_6.logs SET used_table = 'communities', id_prime_k = NEW.id;
END //
DELIMITER ;

-- Проверка
INSERT INTO `communities` (name) 
VALUES ('science fiction writers');


DROP TRIGGER IF EXISTS new_ins_messages;
DELIMITER //
CREATE TRIGGER new_ins_messages
AFTER INSERT ON hometask_4.messages
FOR EACH ROW
BEGIN
	INSERT INTO hometask_6.logs SET used_table = 'messages', id_prime_k = NEW.id;
END //
DELIMITER ;

-- Проверка
INSERT INTO messages  (from_user_id, to_user_id, body, created_at) VALUES
(11, 12, "Every man's got a breaking point. Get busy living or get busy dying. Hope is the good thing, maybe the best of things. And no good thing ever dies",  DATE_ADD(NOW(), INTERVAL 1 MINUTE)),
(12, 11, "A person has one remarkable property: if you have to start all over again, he does not despair and does not lose courage, 
because he knows that this is very important, that it is worth the effort. Don't ask for guarantees. And do not expect salvation from one thing - from a person, or a machine, or a library. 
Create for yourself what can save the world - and if you drown along the way, at least you will know that you were swimming to the shore.",  DATE_ADD(NOW(), INTERVAL 1 MINUTE));


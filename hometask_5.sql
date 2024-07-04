DROP DATABASE IF EXISTS hometask_5;
CREATE DATABASE hometask_5;
USE hometask_5;

-- 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет.

DROP VIEW IF EXISTS v_underages;
CREATE OR REPLACE VIEW v_underages AS
	SELECT firstname AS "Имя", lastname AS "Фамилия", 
    (SELECT hometown FROM lesson_4.profiles WHERE user_id = users.id) AS "Город", 
    (SELECT gender FROM lesson_4.profiles WHERE user_id = users.id) AS "Пол" 
FROM lesson_4.users
WHERE lesson_4.users.id IN 
	(SELECT lesson_4.profiles.user_id FROM lesson_4.profiles WHERE lesson_4.profiles.birthday > '2003-03-14');

SELECT * FROM v_underages;
    
    
-- 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователь, 
--    указав указать имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
--   (первое место у пользователя с максимальным количеством сообщений). (используйте DENSE_RANK)

SELECT
	CONCAT(firstname, ' ', lastname) AS 'Пользователь',
    COUNT(from_user_id) AS 'Количество сообщений',
    DENSE_RANK() OVER (ORDER BY COUNT(from_user_id) DESC) AS 'Рейтинг'
	-- RANK() OVER (ORDER BY COUNT(from_user_id) DESC) AS 'Альтернативный рейтинг'
FROM 
	(SELECT u.firstname, u.lastname, m.from_user_id FROM lesson_4.users u
	LEFT JOIN lesson_4.messages m
	ON u.id = m.from_user_id) AS new_tbl
    GROUP BY CONCAT(firstname, ' ', lastname);


-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) и найдите разницу дат отправления
--    между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)

SELECT m.*,
	LAG(created_at) OVER(ORDER BY created_at) AS prev_time,
    LEAD(created_at) OVER(ORDER BY created_at) AS past_time,
	TIMESTAMPDIFF(MINUTE, LEAD(created_at) OVER(ORDER BY created_at), created_at) AS diff_past,
    TIMESTAMPDIFF(MINUTE, LAG(created_at) OVER(ORDER BY created_at), created_at) AS diff_prev
FROM lesson_4.messages m;
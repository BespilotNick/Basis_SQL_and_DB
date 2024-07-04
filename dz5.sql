USE lesson_4;

-- Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет.
CREATE OR REPLACE VIEW v_users AS 
(SELECT 
	u.firstname, 
	u.lastname, 
	p.hometown,
	CASE (gender)
         WHEN 'm' THEN 'мужской'
         WHEN 'f' THEN 'женский'
         ELSE 'другой'
    END AS gender
FROM users u
JOIN profiles p ON  u.id=p.user_id
WHERE TIMESTAMPDIFF (YEAR, p.birthday, NOW())<21);

SELECT firstname, lastname, hometown, gender FROM v_users;

-- Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователь, 
-- указав указать имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
-- (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)

-- 1 вариант
SELECT 
	DENSE_RANK() OVER (ORDER BY cnt DESC) AS rank_cnt,
	sender,
	cnt
FROM (SELECT 
	CONCAT(u.firstname, ' ', u.lastname) AS sender,
	COUNT(m.id) AS cnt
FROM users u 
LEFT JOIN messages m ON u.id=m.from_user_id 
GROUP BY u.id) AS list
ORDER BY cnt DESC;

-- 2 вариант 
SELECT 
	DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS rank_message,
	CONCAT(u.firstname, ' ', u.lastname) AS sender, 
	COUNT(m.id) AS cnt
FROM users u 
LEFT JOIN messages m ON u.id = m.from_user_id
GROUP BY u.id
ORDER BY cnt DESC;


-- Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления 
-- (created_at) и найдите разницу дат отправления между соседними сообщениями, 
-- получившегося списка. (используйте LEAD или LAG)
SELECT id, from_user_id, to_user_id, body, created_at,
	LEAD(created_at) OVER(ORDER BY created_at) AS lead_time,
	TIMESTAMPDIFF (MINUTE, created_at, LEAD(created_at) OVER(ORDER BY created_at)) AS minute_lead_diff,
	LAG(created_at) OVER(ORDER BY created_at) AS lag_time,
	TIMESTAMPDIFF (MINUTE,  LAG(created_at) OVER(ORDER BY created_at), created_at ) AS minute_lag_diff
FROM messages;
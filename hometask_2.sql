-- DROP DATABASE IF EXISTS hometask_2;
CREATE DATABASE hometask_2;
USE hometask_2;

-- Задание 1
-- DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT UNIQUE,
    order_date DATE NOT NULL,
    count_product INT UNSIGNED NOT NULL
);

INSERT INTO sales (order_date, count_product)
VALUES ('2022-01-01', 156),
('2022-01-02',180),
('2022-01-03', 21),
('2022-01-04', 124),
('2022-01-05', 341);

-- Задание 2
SELECT id AS 'id заказа',
	CASE
		WHEN count_product < 100 THEN 'Маленький заказ'
        WHEN count_product BETWEEN 100 AND 300 THEN 'Средний заказ'
        ELSE 'Большой заказ'
	END AS 'Тип заказа'
FROM sales;

-- Задание 3
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	id SERIAL PRIMARY KEY,
    employee_id VARCHAR(20) NOT NULL,
    amount DECIMAL(6,2),
    order_status VARCHAR(20)
);

INSERT INTO orders (employee_id, amount, order_status)
VALUES ('e03', 15.00, 'OPEN'),
('e01', 25.50, 'OPEN'),
('e05', 100.70, 'CLOSE'),
('e02', 22.18, 'OPEN'),
('e04', 9.50, 'CANCELLED');

-- Решение вариант 1 (попроще):
SELECT id, employee_id, amount,
	CASE order_status
		WHEN 'OPEN' THEN 'Order is in open state'
        WHEN 'CLOSE' THEN 'Order is closed'
        WHEN 'CANCELLED' THEN 'Order is cancelled'
        ELSE 'Check if the field is filled in correctly'
	END AS 'full_order_status'
FROM orders;

/* Решение вариант 2 (не знаю зачем я это сделал, так ещё и в настройки пришлось лезть что бы отключить Safe Updates 
для получения возможности обновлять не по ключу. 
Но, вроде получилось): */

ALTER TABLE orders
ADD COLUMN full_order_status VARCHAR(45);

UPDATE orders SET full_order_status = 'Order is in open state' WHERE order_status = 'OPEN';
UPDATE orders SET full_order_status = 'Order is closed' WHERE order_status = 'CLOSE';
UPDATE orders SET full_order_status = 'Order is cancelled' WHERE order_status = 'CANCELLED';

/* 
ALTER TABLE orders
DROP COLUMN order_status; 
Это что бы не мешались лишние колонки, но, тогда предыдущий вариант не будет работать.
*/

SELECT * FROM orders;
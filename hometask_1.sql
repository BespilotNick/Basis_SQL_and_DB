-- Задание 2
SELECT product_name, manufacturer, price
FROM hometask_1
WHERE product_count > 2;

-- Задание 3
SELECT product_name, product_count
FROM hometask_1
WHERE manufacturer = 'Samsung';

-- Задание 4
-- 4.1
SELECT *
FROM hometask_1
WHERE product_name LIKE '%IPhone%' OR manufacturer LIKE '%IPhone%';

-- 4.2
SELECT *
FROM hometask_1
WHERE product_name LIKE '%Samsung%' OR manufacturer LIKE '%Samsung%';

-- 4.3 Код не работает, не пойму причину
SELECT product_name, manufacturer, product_count
FROM hometask_1
WHERE product_name LIKE '%[0-9]%';

-- 4.4
SELECT product_name, manufacturer, product_count
FROM hometask_1
WHERE product_name LIKE '%8%';
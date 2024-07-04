/* Cтили
PascalCase: MyAwesomeVariable 
camelCase: мyAwesomeVariable 
венгерская нотация: tblHugarianNotation, tbPassword 
kebab-case: my-awesome-variable

для SQL лучше использовать
_snake_case, snake_case : my_awesome_variable 
UPPER_CASE_SNAKE_CASE
*/ 

-- создаём базу данных
DROP DATABASE IF EXISTS lesson_1;
CREATE DATABASE lesson_1;
USE lesson_1;

-- студенты
CREATE TABLE students(
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
	name_student VARCHAR(45) NOT NULL, 
	email VARCHAR(45) NOT NULL,
	phone_number BIGINT UNSIGNED
);
-- учителя
CREATE TABLE teachers(
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
	name_teacher VARCHAR(45) NOT NULL, 
	post VARCHAR(100)
);

-- курсы
CREATE TABLE courses(
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
	name_course VARCHAR(100) NOT NULL, 
	name_teacher VARCHAR (45),
	name_student VARCHAR (45)
);

-- наполнение
INSERT INTO students (name_student, email, phone_number)
VALUES 
('Миша', 'misha@mail.ru', 9876543221),
('Антон', 'anton@mail.ru', 9876543222),
('Маша', 'masha@mail.ru', 9876543223),
('Паша', 'pasha@mail.ru', 9876543224);	

INSERT INTO teachers (name_teacher, post)
VALUES 
('Иванов И.И.', 'Профессор'),
('Петров П.П.', 'Преподаватель'),
('Сидоров С.С.', 'Доцент');

INSERT INTO courses (name_course, name_teacher, name_student)
VALUES 
('БД', 'Иванов И.И.', 'Миша'),
('PHP', 'Петров П.П.', 'Антон'),
('Аналитика', 'Сидоров С.С.', 'Маша');


-- Получить список с информацией обо всех студентах
-- SELECT * FROM students;  * - "дурной" тон
SELECT id, name_student, email, phone_number FROM students;


-- Получить список всех студентов с именем "Антон"
SELECT id, name_student, email, phone_number FROM students
WHERE name_student = 'Антон';

-- Вывести имя и почту из таблички "Студент" по всем студентам
SELECT name_student, email FROM students;

-- Выбрать информацию о студентах, имена которых начинаются с буквы «А».
SELECT id, name_student, email, phone_number 
FROM students WHERE name_student LIKE 'А%';



-- создание таблицы для работы через командную строку
DROP TABLE IF EXISTS workers;
CREATE TABLE workers (
    id INT  NOT NULL, 
    name_worker VARCHAR(45),
    dept VARCHAR(100) COMMENT 'Подразделение', -- COMMENT на случай, если имя неочевидное,
    salary INT,
    PRIMARY KEY(id)
);

INSERT INTO workers (id, name_worker, dept, salary)
VALUES 
(100, 'AndreyEx', 'Sales', 5000),
(200, 'Boris', 'IT', 5500),
(300, 'Anna', 'IT', 7000),
(400, 'Anton', 'Marketing', 9500),
(500, 'Dima', 'IT', 6000),
(501, 'Maxs', 'Accounting', NULL);	

-- Выбрать всех сотрудников, у которых зарплата больше 6000
SELECT name_worker, salary FROM workers WHERE salary > 6000;

-- Покажите всех сотрудников, которые принадлежат к отделу IT.

SELECT name_worker, dept FROM workers WHERE dept = 'IT';

-- Отобразите  всех сотрудников, который НЕ принадлежат к отделу IT
SELECT name_worker, dept FROM workers WHERE dept != 'IT';


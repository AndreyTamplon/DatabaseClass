-- При возникновении ошибки о нарушении уникальности pk, возможно произошла рассинхронизация последовательности
-- Так можно проверить так ли это
SELECT MAX(id) FROM factory.employees;
SELECT nextval('employees_id_seq');
-- Если первое число больше второго, то нужно обновить последовательность
SELECT setval('employees_id_seq', (SELECT MAX(id) FROM factory.employees));

-- 1) Нельзя добавить или обновить бригаду, в которой бригадир, не является рабочим
-- Должен выбросить исключение о том, что бригадир должен быть рабочим
INSERT INTO factory.brigades (name, brigadier_id, section_id) VALUES ('Бригада', 4, 1);
UPDATE factory.brigades SET brigadier_id = 4 WHERE name = 'Бригада №1';

-- 2) Нельзя добавить или обновить сотрудника с position = 'Бригадир', если он не является рабочим
-- Должен выбросить исключение о том, что бригадир должен быть рабочим
INSERT INTO factory.employees (name, job_id, manager_id, position, section_id)
VALUES ('Михайлов Аркадий Михайлович', 1, 4, 'Бригадир', 1);
UPDATE factory.employees SET position = 'Бригадир' WHERE name = 'Лебедев Андрей Владимирович';

-- 3) Нельзя добавить или обновить сотрудника с position = 'Мастер', если он не из инженерно технического персонала
-- Должен выбросить исключение о том, что мастер должен быть представителем инженерно технического персонала
INSERT INTO factory.employees (name, job_id, manager_id, position, section_id)
VALUES ('Михайлов Аркадий Михайлович', 4, 2, 'Мастер', 1);

INSERT INTO factory.employees (name, job_id, manager_id, position, section_id)
VALUES ('Михайлов Аркадий Михайлович', 4, 2, 'Испытатель', 1);
UPDATE factory.employees SET position = 'Мастер' WHERE name = 'Михайлов Аркадий Михайлович';
DELETE FROM factory.employees WHERE name = 'Михайлов Аркадий Михайлович';

-- 4) Нельзя добавить или обновить сотрудника с position = 'Начальник участка', если он не из инженерно технического персонала
-- Должен выбросить исключение о том, что начальник участка должен быть представителем инженерно технического персонала
INSERT INTO factory.employees (name, job_id, manager_id, position, section_id)
VALUES ('Михайлов Аркадий Михайлович', 4, 1, 'Начальник участка', 1);

INSERT INTO factory.employees (name, job_id, manager_id, position, section_id)
VALUES ('Михайлов Аркадий Михайлович', 4, 1, 'Испытатель', 1);
UPDATE factory.employees SET position = 'Начальник участка' WHERE name = 'Михайлов Аркадий Михайлович';
DELETE FROM factory.employees WHERE name = 'Михайлов Аркадий Михайлович';


-- 5) Нельзя добавить или обновить сотрудника с position = 'Начальник цеха', если он не из инженерно технического персонала
-- Должен выбросить исключение о том, что начальник цеха должен быть представителем инженерно технического персонала
INSERT INTO factory.employees (name, job_id, manager_id, position, section_id)
VALUES ('Михайлов Аркадий Михайлович', 4, 4, 'Начальник цеха', 1);
UPDATE factory.employees SET position = 'Начальник цеха' WHERE name = 'Петров Петр Петрович';

-- 6) Нельзя добавить запись в историю производства, если продукт производился больше чем в одном цехе
-- Должен выбросить исключение о том, что продукт должен производиться только в одном цехе
INSERT INTO factory.production_history (product_id, work_name, section_id, brigade_id, start_time)
VALUES (21, 'Сборка', 1, 1, '2020-01-01 00:00:00');

-- 7) Мастер должен подчиняться начальнику участка
-- Если это не так, должно выбросить исключение о том, что мастер должен подчиняться начальнику участка
INSERT INTO factory.employees (name, job_id, manager_id, position, section_id)
VALUES ('Михайлов Аркадий Михайлович', 4, 4, 'Мастер', 1);
UPDATE factory.employees SET manager_id = 4 WHERE name = 'Лебедев Андрей Владимирович';

-- 8) Начальник участка должен подчиняться начальнику цеха
-- Если это не так, должно выбросить исключение о том, что начальник участка должен подчиняться начальнику цеха
INSERT INTO factory.employees (name, job_id, manager_id, position, section_id)
VALUES ('Михайлов Аркадий Михайлович', 4, 1, 'Начальник участка', 1);
UPDATE factory.employees SET manager_id = 4 WHERE name = 'Жукова Елена Петровна';

-- 9) Проверка того, что дата завершения этапа производства >= даты начала этапа и что есть запись с началом этапа, если есть запись с завершением этапа
-- Должен выбросить исключение о том, что дата завершения этапа должна быть >= даты начала этапа
INSERT INTO factory.product_completion_history (work_id, end_time)
VALUES (1, '2017-01-01 00:00:00');
UPDATE factory.product_completion_history SET end_time = '2017-01-01 00:00:00' WHERE work_id = 1;
-- Должен выбросить исключение о том, что должна быть запись с началом этапа
INSERT INTO factory.product_completion_history (work_id, end_time)
VALUES (100, '2022-01-01 00:00:00');

-- 10) Проверка того, что дата начала этапа производства >= даты завершения предыдущего этапа
-- Должен выбросить исключение о том, что дата начала этапа должна быть >= даты завершения предыдущего этапа
INSERT INTO factory.production_history(product_id, work_name, section_id, brigade_id, start_time)
VALUES (1, 'Покраска', 1, 1, '2017-01-01 00:00:00');
UPDATE factory.production_history SET start_time = '2017-01-01 00:00:00' WHERE id = 21;

-- 11) Проверка того, что дата завершения этапа тестирования >= даты начала этапа и что есть запись с началом этапа, если есть запись с завершением этапа
-- Должен выбросить исключение о том, что дата завершения этапа должна быть >= даты начала этапа
INSERT INTO factory.test_completion_history (test_id, end_time)
VALUES (1, '2017-01-01 00:00:00');
UPDATE factory.test_completion_history SET end_time = '2017-01-01 00:00:00' WHERE test_id = 10;

-- 12) Проверка того, что дата начала этапа тестирования >= даты завершения предыдущего этапа
-- Должен выбросить исключение о том, что дата начала этапа должна быть >= даты завершения предыдущего этапа
INSERT INTO factory.testing_history(test_name, laboratory_id, product_id, start_time)
VALUES ('Тестирование на влагосодержание', 1, 2, '2017-01-01 00:00:00');
UPDATE factory.testing_history SET start_time = '2017-01-01 00:00:00' WHERE id = 10;
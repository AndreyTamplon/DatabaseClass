-- Добавление инженерно-технических профессий
INSERT INTO jobs (job_title, job_type)
VALUES ('Инженер-конструктор', 'Инженерно-технический персонал'),
       ('Технолог-конструктор', 'Инженерно-технический персонал'),
       ('Электротехник', 'Инженерно-технический персонал'),
       ('Сборщик', 'Рабочий'),
       ('Токарь', 'Рабочий'),
       ('Слесарь', 'Рабочий'),
       ('Сварщик', 'Рабочий'),
       ('Испытатель', 'Инженерно-технический персонал');

-- добавление атрибутов для профессий
INSERT INTO job_attributes (name, value, job_id)
VALUES  ('Зарплата', '50000', 1),
        ('Требования', 'высшее образование', 1),
        ('Зарплата', '40000', 2),
        ('Требования', 'опыт работы не менее 3 лет', 2),
        ('Зарплата', '35000', 3),
        ('Требования', 'умение читать чертежи', 1),
        ('Зарплата', '30000', 4),
        ('Зарплата', '45000', 5),
        ('Требования', 'знание электроники', 5),
        ('Зарплата', '55000', 6),
        ('Зарплата', '40000', 7),
        ('Требования', 'опыт работы с компьютером', 2),
        ('График работы', '5/2', 1),
        ('График работы', '5/2', 2),
        ('График работы', '5/2', 3),
        ('График работы', '5/2', 4),
        ('График работы', '5/2', 5),
        ('График работы', '5/2', 6),
        ('График работы', '5/2', 7),
        ('Дополнительные требования', 'владение Английским языком', 1),
        ('Дополнительные требования', 'умение работать с CAD программами', 1),
        ('Дополнительные требования', 'владение программированием на С++', 6);

-- Добавление сотрудников
INSERT INTO employees (id, name, job_id, manager_id, position)
VALUES  (1, 'Соколов Иван Александрович', 1, null, 'Начальник цеха'),

        (2, 'Белов Дмитрий Васильевич', 1, 1, 'Начальник участка'),
        (3, 'Жукова Елена Петровна', 2, 1, 'Начальник участка'),

        (4, 'Лебедев Андрей Владимирович', 3, 2, 'Мастер'),
        (5, 'Васильева Ольга Викторовна', 3, 3, 'Мастер'),

        (6, 'Михайлов Михаил Михайлович', 4, 4, 'Бригадир'),
        (7, 'Кузнецов Кузьма Кузьмич', 5, 5, 'Бригадир'),

        (8, 'Петров Петр Петрович', 5, 4, 'Рабочий'),
        (9, 'Сидоров Сидор Сидорович', 6, 4, 'Рабочий'),
        (10, 'Карпов Владимир Иванович', 4, 4, 'Рабочий'),
        (11, 'Белкин Алексей Петрович', 5, 5, 'Рабочий'),
        (12, 'Захаров Николай Иванович', 6, 5, 'Рабочий'),
        (13, 'Дмитриев Сергей Васильевич', 7, 5, 'Рабочий'),
        (14, 'Ситников Юрий Дмитриевич', 7, 5, 'Рабочий'),

        (15, 'Соколов Александр Маркович', 8, null, 'Испытатель'),
        (16, 'Герасимов Сергей Никитич', 8, 15, 'Испытатель');

-- Добавление истории работы сотрудников
INSERT INTO job_history (employee_id, job_id, start_date, end_date)
VALUES  (1, 2, '2018-01-01', '2018-03-01'),
        (1, 3, '2018-03-01', '2020-05-01'),
        (2, 3, '2018-05-01', '2018-07-01'),
        (2, 2, '2018-07-01', '2018-09-01'),
        (9, 4, '2018-09-01', '2018-11-01'),
        (9, 5, '2018-11-01', '2018-12-01'),
        (9, 6, '2018-12-01', '2019-01-01'),
        (14, 1, '2018-01-01', '2018-03-01'),
        (14, 2, '2018-03-01', '2018-05-01'),
        (14, 3, '2018-05-01', '2018-07-01'),
        (14, 4, '2018-07-01', '2018-09-01'),
        (14, 5, '2018-09-01', '2018-11-01'),
        (14, 6, '2018-11-01', '2018-12-01');

-- Добавление цехов
INSERT INTO workshops (name, workshop_leader)
VALUES ('Цех по созданию изделий', 1);

INSERT INTO sections (name, workshop_id, section_leader)
VALUES  ('Участок изготовления деталей', 1, 2),
        ('Участок сборки изделий', 1, 3);

-- Добавление бригад
INSERT INTO brigades (name, brigadier_id, section_id)
VALUES  ('Бригада №1', 6, 1),
        ('Бригада №2', 7, 2);

-- Добавление состава бригад
INSERT INTO brigade_employees (employee_id, brigade_id)
VALUES  (8, 1),
        (9, 1),
        (10, 1),
        (11, 2),
        (12, 2),
        (13, 2),
        (14, 2);

-- Добавление лабораторий
INSERT INTO laboratory (name)
VALUES  ('Лаборатория испытаний материалов'),
        ('Лаборатория электроники'),
        ('Лаборатория неразрушающего контроля');

-- Добавление оборудования
INSERT INTO equipment (name, laboratory_id)
VALUES  ('Спектрометр', 1),
        ('Микроскоп', 1),
        ('Термометр', 1),
        ('Осциллограф', 2),
        ('Анализатор', 2),
        ('Измерительный прибор', 2),
        ('Микроскоп', 3),
        ('Термометр', 3),
        ('Осциллограф', 3);

-- Добавление связи лабораторий и цехов
INSERT INTO workshops_n_labs (workshop_id, laboratory_id)
VALUES  (1, 1),
        (1, 2),
        (1, 3);

-- Добавление типов продуктов
INSERT INTO product_types (type, subtype)
VALUES  ('Самолет', 'Гражданский'),
        ('Самолет', 'Военный'),
        ('Самолет', 'Транспортный'),
        ('Планер', ''),
        ('Вертолет', ''),
        ('Дельтоплан', ''),
        ('Ракета', 'Артиллерийская'),
        ('Ракета', 'Авиационная'),
        ('Ракета', 'Военно-морская');

-- Добавление изделий
INSERT INTO products (name, type_id)
VALUES  ('Sukhoi Superjet 100', 1),
        ('Ил-96', 1),
        ('Ан-148', 1),

        ('F-16 Fighting Falcon', 2),
        ('F-22 Raptor', 2),
        ('F-35 Lightning II', 2),

        ('Boeing C-17 Globemaster III', 3),
        ('Lockheed C-130 Hercules', 3),

        ('Schleicher ASK 21', 4),
        ('Schempp-Hirth Nimbus 4', 4),

        ('Bell AH-1 Cobra', 5),
        ('Sikorsky UH-60 Black Hawk', 5),

        ('Wills Wing T2', 6),
        ('Moyes Litesport', 6),

        ('ATACMS Block I', 7),
        ('GMLRS M31A2', 7),

        ('AGM-65 Maverick', 8),
        ('AIM-9 Sidewinder', 8),

        ('Harpoon', 9),
        ('Tomahawk', 9);

-- Добавление атрибутов изделий
INSERT INTO product_attributes (name, value, product_id)
VALUES  ('Масса', '45,880 кг', 1),
        ('Масса', '270,000 кг', 2),
        ('Масса', '43,700 кг', 3),
        ('Масса', '8,570 кг', 4),
        ('Масса', '19,700 кг', 5),
        ('Масса', '13,290 кг', 6),
        ('Масса', '83,250 кг', 7),
        ('Масса', '34,000 кг', 8),
        ('Масса', '210 кг', 9),
        ('Масса', '332 кг', 10),
        ('Масса', '4,490 кг', 11),
        ('Масса', '10,660 кг', 12),
        ('Масса', '34 кг', 13),
        ('Масса', '32 кг', 14),
        ('Масса', '1,444 кг', 15),
        ('Масса', '691 кг', 16),
        ('Масса', '210 кг', 17),
        ('Масса', '85 кг', 18),
        ('Масса', '691 кг', 19),
        ('Масса', '1,450 кг', 20),

        ('Скорость', '870 км/час', 1),
        ('Скорость', '950 км/час', 2),
        ('Скорость', '870 км/час', 3),
        ('Скорость', '2414 км/час', 4),
        ('Скорость', '2414 км/час', 5),
        ('Скорость', '1931 км/час', 6),
        ('Скорость', '830 км/час', 7),
        ('Скорость', '650 км/час', 8),
        ('Скорость', '250 км/час', 9),
        ('Скорость', '280 км/час', 10),
        ('Скорость', '579 км/час', 11),
        ('Скорость', '295 км/час', 12),
        ('Скорость', '290 км/час', 13),
        ('Скорость', '350 км/час', 14),
        ('Скорость', '1,300 км/час', 15),
        ('Скорость', '2,700 км/час', 16),
        ('Скорость', '860 км/час', 17),
        ('Скорость', '2,125 км/час', 18),
        ('Скорость', '868 км/час', 19),
        ('Скорость', '839 км/час', 20),

        ('Дальность полета', '700 км', 15),
        ('Точность поражения цели', '5-10 м', 15),
        ('Боевая головка', 'High explosive unitary warhead', 15),

        ('Дальность полета', '70 км', 16),
        ('Точность поражения цели', '3 м', 16),
        ('Боевая головка', 'Blast-fragmentation', 16),

        ('Дальность полета', '22 км', 17),
        ('Точность поражения цели', '0.7-0.8 м', 17),
        ('Боевая головка', 'Penetration, blast-fragmentation', 17),

        ('Дальность полета', '18 км', 18),
        ('Точность поражения цели', '0.6 м', 18),
        ('Боевая головка', 'High explosive', 18),

        ('Дальность полета', '124-278 км', 19),
        ('Точность поражения цели', '10 м', 19),
        ('Боевая головка', 'Various, including high explosive, penetration, and fragmentation', 19),

        ('Дальность полета', '1600 км', 20),
        ('Точность поражения цели', '10-30 м', 20),
        ('Боевая головка', 'Various, including unitary nuclear, penetration, and high explosive', 20);

-- Добавление истории создания продуктов
INSERT INTO production_history (product_id, section_id, brigade_id, start_time)
VALUES (1, 1, 1, '2018-01-01 00:00:00'),
       (2, 1, 1, '2018-01-02 00:00:00'),
       (3, 1, 1, '2018-01-03 00:00:00'),
       (4, 1, 1, '2018-01-04 00:00:00'),
       (5, 1, 1, '2018-01-05 00:00:00'),
       (6, 1, 1, '2018-01-06 00:00:00'),
       (7, 1, 1, '2018-01-07 00:00:00'),
       (8, 1, 1, '2018-01-08 00:00:00'),
       (9, 1, 1, '2018-01-09 00:00:00'),
       (10, 1, 1, '2018-01-10 00:00:00'),
       (11, 1, 1, '2018-01-11 00:00:00'),
       (12, 1, 1, '2018-01-12 00:00:00'),
       (13, 1, 1, '2018-01-13 00:00:00'),
       (14, 1, 1, '2018-01-14 00:00:00'),
       (15, 1, 1, '2018-01-15 00:00:00'),
       (16, 1, 1, '2018-01-16 00:00:00'),
       (17, 1, 1, '2018-01-17 00:00:00'),
       (18, 1, 1, '2018-01-18 00:00:00'),
       (19, 1, 1, '2018-01-19 00:00:00'),
       (20, 1, 1, '2018-01-20 00:00:00'),
       (1, 2, 2, '2018-02-01 00:00:00'),
       (2, 2, 2, '2018-02-02 00:00:00'),
       (3, 2, 2, '2018-02-03 00:00:00'),
       (4, 2, 2, '2018-02-04 00:00:00'),
       (5, 2, 2, '2018-02-05 00:00:00'),
       (6, 2, 2, '2018-02-06 00:00:00'),
       (7, 2, 2, '2018-02-07 00:00:00'),
       (8, 2, 2, '2018-02-08 00:00:00'),
       (9, 2, 2, '2018-02-09 00:00:00'),
       (10, 2, 2, '2018-02-10 00:00:00'),
       (11, 2, 2, '2018-02-11 00:00:00'),
       (12, 2, 2, '2018-02-12 00:00:00'),
       (13, 2, 2, '2018-02-13 00:00:00'),
       (14, 2, 2, '2018-02-14 00:00:00'),
       (15, 2, 2, '2018-02-15 00:00:00'),
       (16, 2, 2, '2018-02-16 00:00:00'),
       (17, 2, 2, '2018-02-17 00:00:00'),
       (18, 2, 2, '2018-02-18 00:00:00'),
       (19, 2, 2, '2018-02-19 00:00:00'),
       (20, 2, 2, '2018-02-20 00:00:00');

-- Добавление истории завершения работы на определенном участке
INSERT INTO product_completion_history(work_id, end_time)
VALUES  (1, '2018-02-01 00:00:00'),
        (2, '2018-02-02 00:00:00'),
        (3, '2018-02-03 00:00:00'),
        (4, '2018-02-04 00:00:00'),
        (5, '2018-02-05 00:00:00'),
        (6, '2018-02-06 00:00:00'),
        (7, '2018-02-07 00:00:00'),
        (8, '2018-02-08 00:00:00'),
        (9, '2018-02-09 00:00:00'),
        (10, '2018-02-10 00:00:00'),
        (11, '2018-02-11 00:00:00'),
        (12, '2018-02-12 00:00:00'),
        (13, '2018-02-13 00:00:00'),
        (14, '2018-02-14 00:00:00'),
        (15, '2018-02-15 00:00:00'),
        (16, '2018-02-16 00:00:00'),
        (17, '2018-02-17 00:00:00'),
        (18, '2018-02-18 00:00:00'),
        (19, '2018-02-19 00:00:00'),
        (20, '2018-02-20 00:00:00');

-- Добавление истории испытаний продукта

INSERT INTO testing_history (test_name, laboratory_id, product_id, start_time)
VALUES ('Тестирование на прочность', 1, 1, '2018-03-01 00:00:00'),
       ('Тестирование на прочность', 1, 2, '2018-03-02 00:00:00'),
       ('Тестирование на прочность', 1, 3, '2018-03-03 00:00:00'),
       ('Тестирование на прочность', 1, 4, '2018-03-04 00:00:00'),
       ('Тестирование на прочность', 1, 5, '2018-03-05 00:00:00'),
       ('Тестирование на прочность', 1, 6, '2018-03-06 00:00:00'),
       ('Тестирование на прочность', 1, 7, '2018-03-07 00:00:00'),
       ('Тестирование на прочность', 1, 8, '2018-03-08 00:00:00'),
       ('Тестирование на прочность', 1, 9, '2018-03-09 00:00:00'),
       ('Тестирование на прочность', 1, 10, '2018-03-10 00:00:00'),
       ('Тестирование на прочность', 1, 11, '2018-03-11 00:00:00'),
       ('Тестирование на прочность', 1, 12, '2018-03-12 00:00:00'),
       ('Тестирование на прочность', 1, 13, '2018-03-13 00:00:00'),
       ('Тестирование на прочность', 1, 14, '2018-03-14 00:00:00'),
       ('Тестирование на прочность', 1, 15, '2018-03-15 00:00:00'),
       ('Тестирование на прочность', 1, 16, '2018-03-16 00:00:00'),
       ('Тестирование на прочность', 1, 17, '2018-03-17 00:00:00'),
       ('Тестирование на прочность', 1, 18, '2018-03-18 00:00:00'),
       ('Тестирование на прочность', 1, 19, '2018-03-19 00:00:00'),
       ('Тестирование на прочность', 1, 20, '2018-03-20 00:00:00');

-- Добавление истории завершения испытаний
INSERT INTO test_completion_history(test_id, end_time)
VALUES (1, '2018-04-01 00:00:00'),
        (2, '2018-04-02 00:00:00'),
        (3, '2018-04-03 00:00:00'),
        (4, '2018-04-04 00:00:00'),
        (5, '2018-04-05 00:00:00'),
        (6, '2018-04-06 00:00:00'),
        (7, '2018-04-07 00:00:00'),
        (8, '2018-04-08 00:00:00'),
        (9, '2018-04-09 00:00:00'),
        (10, '2018-04-10 00:00:00'),
        (11, '2018-04-11 00:00:00'),
        (12, '2018-04-12 00:00:00'),
        (13, '2018-04-13 00:00:00'),
        (14, '2018-04-14 00:00:00'),
        (15, '2018-04-15 00:00:00'),
        (16, '2018-04-16 00:00:00'),
        (17, '2018-04-17 00:00:00'),
        (18, '2018-04-18 00:00:00'),
        (19, '2018-04-19 00:00:00'),
        (20, '2018-04-20 00:00:00');

-- Добавление испытателей на испытаниях
INSERT INTO laboratorians_n_tests(laboratorian_id, test_id)
VALUES (1, 1),
       (1, 2),
       (1, 3),
       (1, 4),
       (1, 5),
       (1, 6),
       (1, 7),
       (1, 8),
       (1, 9),
       (2, 10),
       (2, 11),
       (2, 12),
       (2, 13),
       (2, 14),
       (2, 15),
       (2, 16),
       (2, 17),
       (2, 18),
       (2, 19),
       (2, 20);

-- Добавление оборудования на испытаниях
INSERT INTO equipment_n_tests(equipment_id, test_id)
VALUES  (1, 1),
        (1, 2),
        (1, 3),
        (1, 4),
        (1, 5),
        (1, 6),
        (1, 7),
        (1, 8),
        (1, 9),
        (2, 10),
        (2, 11),
        (2, 12),
        (2, 13),
        (2, 14),
        (2, 15),
        (2, 16),
        (2, 17),
        (2, 18),
        (2, 19),
        (2, 20),
        (3, 1),
        (3, 2),
        (3, 3),
        (3, 4),
        (3, 5),
        (3, 6),
        (3, 7),
        (3, 8),
        (3, 9),
        (4, 10),
        (4, 11),
        (4, 12),
        (4, 13),
        (4, 14),
        (4, 15),
        (4, 16),
        (4, 17),
        (4, 18),
        (4, 19),
        (4, 20),
        (5, 1),
        (5, 2),
        (5, 3),
        (5, 4),
        (5, 5),
        (5, 6),
        (5, 7),
        (5, 8),
        (5, 9),
        (6, 10),
        (6, 11),
        (6, 12),
        (6, 13),
        (6, 14),
        (6, 15),
        (6, 16),
        (6, 17),
        (6, 18),
        (6, 19),
        (6, 20),
        (7, 1),
        (7, 2),
        (7, 3),
        (7, 4),
        (7, 5),
        (7, 6),
        (7, 7),
        (7, 8),
        (7, 9),
        (8, 10),
        (8, 11),
        (8, 12),
        (8, 13),
        (8, 14),
        (8, 15),
        (8, 16),
        (8, 17),
        (8, 18),
        (8, 19),
        (8, 20),
        (9, 1),
        (9, 2),
        (9, 3),
        (9, 4),
        (9, 5),
        (9, 6),
        (9, 7),
        (9, 8),
        (9, 9);





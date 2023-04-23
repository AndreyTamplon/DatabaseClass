-- 1) Проверка того, что бригадир из числа рабочих (на таблице brigades)
CREATE OR REPLACE FUNCTION check_brigadier_job_type_on_brigades() RETURNS TRIGGER AS
$$
DECLARE
    job_type VARCHAR(150);
BEGIN
    SELECT j.job_type
    INTO job_type
    FROM employees e
             INNER JOIN jobs j ON e.job_id = j.id
    WHERE e.id = NEW.brigadier_id;
    IF job_type <> 'Рабочий' THEN
        RAISE EXCEPTION 'Бригадир должен быть рабочим';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_brigadier_job_type_trigger
    BEFORE INSERT OR UPDATE
    ON factory.brigades
    FOR EACH ROW
EXECUTE PROCEDURE check_brigadier_job_type_on_brigades();
-- 2) Проверка того, что бригадир из числа рабочих (на таблице employees)
CREATE OR REPLACE FUNCTION check_brigadier_job_type_in_employees() RETURNS TRIGGER AS
$$
DECLARE
    job_type VARCHAR(150);
BEGIN
    IF NEW.position = 'Бригадир' THEN
        SELECT j.job_type
        INTO job_type
        FROM jobs j
        WHERE j.id = NEW.job_id;
        IF job_type <> 'Рабочий' THEN
            RAISE EXCEPTION 'Бригадир должен быть рабочим';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_brigadier_job_type_on_employees_trigger
    BEFORE INSERT OR UPDATE
    ON factory.employees
    FOR EACH ROW
EXECUTE PROCEDURE check_brigadier_job_type_in_employees();


-- 3) Проверка того, что мастера назначаются из числа инженерно технического персонала
CREATE OR REPLACE FUNCTION check_master_job_type() RETURNS TRIGGER AS
$$
DECLARE
    job_type VARCHAR(150);
BEGIN
    IF NEW.position = 'Мастер' THEN
        SELECT j.job_type
        INTO job_type
        FROM jobs j
        WHERE j.id = NEW.job_id;
        IF job_type <> 'Инженерно-технический персонал' THEN
            RAISE EXCEPTION 'Мастер должен быть из инженерно-технического персонала';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_master_job_type_trigger
    BEFORE INSERT OR UPDATE
    ON factory.employees
    FOR EACH ROW
EXECUTE PROCEDURE check_master_job_type();

-- 4) Проверка того, что начальники участков назначаются из числа инженерно технического персонала
CREATE OR REPLACE FUNCTION check_section_chief_job_type() RETURNS TRIGGER AS
$$
DECLARE
    job_type VARCHAR(150);
BEGIN
    IF NEW.position = 'Начальник участка' THEN
        SELECT j.job_type
        INTO job_type
        FROM jobs j
        WHERE j.id = NEW.job_id;
        IF job_type <> 'Инженерно-технический персонал' THEN
            RAISE EXCEPTION 'Начальник участка должен быть из инженерно-технического персонала';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_section_chief_job_type_trigger
    BEFORE INSERT OR UPDATE
    ON factory.employees
    FOR EACH ROW
EXECUTE PROCEDURE check_section_chief_job_type();

-- 5) Проверка того, что начальники цехов назначаются из числа инженерно технического персонала
CREATE OR REPLACE FUNCTION check_workshop_chief_job_type() RETURNS TRIGGER AS
$$
DECLARE
    job_type VARCHAR(150);
BEGIN
    IF NEW.position = 'Начальник цеха' THEN
        SELECT j.job_type
        INTO job_type
        FROM jobs j
        WHERE j.id = NEW.job_id;
        IF job_type <> 'Инженерно-технический персонал' THEN
            RAISE EXCEPTION 'Начальник цеха должен быть из инженерно-технического персонала';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_workshop_chief_job_type_trigger
    BEFORE INSERT OR UPDATE
    ON factory.employees
    FOR EACH ROW
EXECUTE PROCEDURE check_workshop_chief_job_type();

-- 6) Проверка того, что изделие при создании проходило участки только одного цеха
CREATE OR REPLACE FUNCTION check_product_flow_workshops() RETURNS TRIGGER AS
$$
DECLARE
    product_workshop_id    INT;
    new_record_workshop_id INT;
BEGIN
    SELECT DISTINCT workshop_id
    INTO product_workshop_id
    FROM production_history ph
             inner join sections s on ph.section_id = s.id
    WHERE ph.product_id = NEW.product_id;

    SELECT DISTINCT workshop_id
    INTO new_record_workshop_id
    FROM sections s
    WHERE s.id = NEW.section_id;
    IF product_workshop_id <> new_record_workshop_id and product_workshop_id IS NOT NULL THEN
        RAISE EXCEPTION 'Изделие должно проходить участки только одного цеха';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_product_flow_workshops_trigger
    BEFORE INSERT
    ON factory.production_history
    FOR EACH ROW
EXECUTE PROCEDURE check_product_flow_workshops();

-- 7) Проверка того, что мастера подчиняются начальникам участков
CREATE OR REPLACE FUNCTION check_master_hierarchy() RETURNS TRIGGER AS
$$
DECLARE
    section_chief_id INT;
BEGIN
    IF NEW.position = 'Мастер' THEN
        SELECT e.id
        INTO section_chief_id
        FROM employees e
        WHERE e.position = 'Начальник участка'
          AND e.id = NEW.manager_id;

        IF section_chief_id IS NULL THEN
            RAISE EXCEPTION 'Мастер должен быть подчинен начальнику участка';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_master_hierarchy_trigger
    BEFORE INSERT OR UPDATE
    ON factory.employees
    FOR EACH ROW
EXECUTE PROCEDURE check_master_hierarchy();

-- 8) Проверка того, что начальники участков подчиняются начальникам цехов
CREATE OR REPLACE FUNCTION check_section_chief_hierarchy() RETURNS TRIGGER AS
$$
DECLARE
    workshop_chief_id INT;
BEGIN
    IF NEW.position = 'Начальник участка' THEN
        SELECT e.id
        INTO workshop_chief_id
        FROM employees e
        WHERE e.position = 'Начальник цеха'
          AND e.id = NEW.manager_id;

        IF workshop_chief_id IS NULL THEN
            RAISE EXCEPTION 'Начальник участка должен быть подчинен начальнику цеха';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_section_chief_hierarchy_trigger
    BEFORE INSERT OR UPDATE
    ON factory.employees
    FOR EACH ROW
EXECUTE PROCEDURE check_section_chief_hierarchy();

-- 9) Проверка того, что дата завершения этапа производства >= даты начала этапа
CREATE OR REPLACE FUNCTION check_stage_end_dates() RETURNS TRIGGER AS
$$
DECLARE
    start_time DATE;
BEGIN
    SELECT ph.start_time
    INTO start_time
    FROM production_history ph
    WHERE ph.id = NEW.work_id;
    IF start_time IS NULL THEN
        RAISE EXCEPTION 'Нельзя завершить этап, который не начат';
    END IF;
    IF NEW.end_time < start_time THEN
        RAISE EXCEPTION 'Дата завершения этапа должна быть больше или равна дате начала этапа';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_stage_end_dates_trigger
    BEFORE INSERT OR UPDATE
    ON factory.product_completion_history
    FOR EACH ROW
EXECUTE PROCEDURE check_stage_end_dates();

-- 10) Проверка того, что дата начала этапа производства >= даты завершения предыдущего этапа
CREATE OR REPLACE FUNCTION check_stage_start_dates() RETURNS TRIGGER AS
$$
DECLARE
    prev_stage_end_time DATE;
BEGIN
    SELECT MAX(pch.end_time)
    INTO prev_stage_end_time
    FROM production_history ph
             left join product_completion_history pch on ph.id = pch.work_id
    WHERE ph.product_id = NEW.product_id;

    IF NEW.start_time < prev_stage_end_time AND prev_stage_end_time IS NOT NULL THEN
        RAISE EXCEPTION 'Дата начала этапа должна быть больше или равна дате завершения предыдущего этапа';
    END IF;
    RETURN NEW;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_stage_start_dates_trigger
    BEFORE INSERT OR UPDATE
    ON factory.production_history
    FOR EACH ROW
EXECUTE PROCEDURE check_stage_start_dates();

-- 11) Проверка того, что дата завершения этапа тестирования >= даты начала этапа
CREATE OR REPLACE FUNCTION check_test_stage_end_dates() RETURNS TRIGGER AS
$$
DECLARE
    start_time DATE;
BEGIN
    SELECT th.start_time
    INTO start_time
    FROM testing_history th
    WHERE th.id = NEW.test_id;

    IF start_time IS NULL THEN
        RAISE EXCEPTION 'Нельзя завершить этап, который не начат';
    END IF;
    IF NEW.end_time < start_time THEN
        RAISE EXCEPTION 'Дата завершения этапа должна быть больше или равна дате начала этапа';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_test_stage_end_dates_trigger
    BEFORE INSERT OR UPDATE
    ON factory.test_completion_history
    FOR EACH ROW
EXECUTE PROCEDURE check_test_stage_end_dates();

-- 12) Проверка того, что дата начала этапа тестирования >= даты завершения предыдущего этапа
CREATE OR REPLACE FUNCTION check_test_stage_start_dates() RETURNS TRIGGER AS
$$
DECLARE
    prev_stage_end_time DATE;
BEGIN
    SELECT MAX(tch.end_time)
    INTO prev_stage_end_time
    FROM testing_history th
             left join test_completion_history tch on th.id = tch.test_id
    WHERE th.product_id = NEW.product_id;

    IF NEW.start_time < prev_stage_end_time AND prev_stage_end_time IS NOT NULL THEN
        RAISE EXCEPTION 'Дата начала этапа должна быть больше или равна дате завершения предыдущего этапа';
    END IF;
    RETURN NEW;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_test_stage_start_dates_trigger
    BEFORE INSERT OR UPDATE
    ON factory.testing_history
    FOR EACH ROW
EXECUTE PROCEDURE check_test_stage_start_dates();

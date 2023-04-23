-- 1. Получить перечень видов изделий отдельной категории и в целом, собираемых указанным
-- цехом, предприятием.
select pt.id as id, pt.name as type, category, subcategory, w.name as workshop, f.name as factory
from product_types pt
         INNER JOIN product_categories pc on pc.id = pt.category_id
         INNER JOIN workshops w on w.id = pt.workshop_id
         INNER JOIN factories f on w.factory_id = f.id
where f.id = :factory_id
  and workshop_id = :workshop_id
  and category_id = :category_id;


-- 2. Получить число и перечень изделий отдельной категории и в целом, собранных указанным
-- цехом, участком, предприятием в целом за определенный отрезок времени.
with last_section_in_workshop as (select *
                                  from sections s
                                  where s.id = (select max(id)
                                                from sections
                                                where workshop_id = s.workshop_id)),
     with_category (id, name, category, subcategory, workshop, factory, start_time, end_time) as (
-- Отдельной категории
-- Для цехов и предприятий
         select ph.product_id as id,
                pt.name       as type,
                category,
                subcategory,
                w.name        as workshop,
                f.name        as factory,
                start_time,
                end_time
         from (select * from production_history where start_time >= :start_time) ph
                  left join product_completion_history pch on ph.id = pch.work_id
                  inner join products p on ph.product_id = p.id
                  inner join product_types pt on p.type_id = pt.id
                  inner join product_categories pc on pt.category_id = pc.id
                  inner join sections s on ph.section_id = s.id
                  inner join workshops w on s.workshop_id = w.id
                  inner join factories f on w.factory_id = f.id
                  inner join last_section_in_workshop lsiw on s.workshop_id = lsiw.workshop_id
         where f.id = :factory_id
           and w.id = :workshop_id
           and category_id = :category_id
           and end_time <= :end_time
           and s.id = lsiw.id
         order by end_time)
-- select count(*) as "number of products" from with_category; -- Число собранных изделий
select *
from with_category;

-- Детали собранные определенным участком. Это отдельный случай, т.к. тут мы не смотрим на то собрано ли полностью изделение,
-- важно лишь, что оно прошло определенный участок
with with_category (id, type, start_time, end_time)
         as (select ph.product_id as id, pt.name as type, start_time, end_time
             from production_history ph
                      left join product_completion_history pch on ph.id = pch.work_id
                      inner join products p on ph.product_id = p.id
                      inner join product_types pt on p.type_id = pt.id
                      inner join sections s on ph.section_id = s.id
             where section_id = :section_id
               and category_id = :category_id
               and start_time >= :start_time
               and end_time <= :end_time
             order by end_time)
-- select count(*) as "number of products" from with_category; -- Число собранных изделий
select *
from with_category;

-- В целом
with last_section_in_workshop as (select *
                                  from sections s
                                  where s.id = (select max(id)
                                                from sections
                                                where workshop_id = s.workshop_id)),
     without_category (id, name, category, subcategory, workshop, factory, start_time, end_time) as (
-- Для цехов и предприятий
         select ph.product_id as id,
                pt.name       as type,
                category,
                subcategory,
                w.name        as workshop,
                f.name        as factory,
                start_time,
                end_time
         from (select * from production_history where start_time >= :start_time) ph
                  left join product_completion_history pch on ph.id = pch.work_id
                  inner join products p on ph.product_id = p.id
                  inner join product_types pt on p.type_id = pt.id
                  inner join product_categories pc on pt.category_id = pc.id
                  inner join sections s on ph.section_id = s.id
                  inner join workshops w on s.workshop_id = w.id
                  inner join factories f on w.factory_id = f.id
                  inner join last_section_in_workshop lsiw on s.workshop_id = lsiw.workshop_id
         where f.id = :factory_id
           and w.id = :workshop_id
           and end_time <= :end_time
           and s.id = lsiw.id
         order by start_time)
-- select count(*) as "number of products" from with_category; -- Число собранных изделий
select *
from without_category;

-- Для участков
with without_category (id, type, start_time, end_time)
         as (select ph.product_id as id, pt.name as type, start_time, end_time
             from production_history ph
                      left join product_completion_history pch on ph.id = pch.work_id
                      inner join products p on ph.product_id = p.id
                      inner join product_types pt on p.type_id = pt.id
                      inner join sections s on ph.section_id = s.id
             where section_id = :section_id
               and start_time >= :start_time
               and end_time <= :end_time
             order by end_time)
-- select count(*) as "number of products" from with_category; -- Число собранных изделий
select *
from without_category;

-- 3. Получить данные о кадровом составе цеха, предприятия в целом и по указанным
-- категориям инженерно-технического персонала и рабочих

-- В целом
select e.id       as id,
       e.name     as name,
       manager_id as manager,
       job_title  as job,
       job_type   as specialization,
       w.name     as workshop,
       f.name     as factory
from employees e
         inner join jobs j on j.id = e.job_id
         inner join sections s on e.section_id = s.id
         inner join workshops w on s.workshop_id = w.id
         inner join factories f on f.id = w.factory_id
where workshop_id = :workshop_id
  and section_id = :section_id
UNION
select e.id       as id,
       e.name     as name,
       manager_id as manager,
       job_title  as job,
       job_type   as specialization,
       w.name     as workshop,
       f.name     as factory
from workshops w
         inner join employees e on e.id = w.workshop_leader
         inner join factories f on w.factory_id = f.id
         inner join jobs j on j.id = e.job_id
ORDER BY id;

-- Для категорий
select e.id       as id,
       e.name     as name,
       manager_id as manager,
       job_title  as job,
       job_type   as specialization,
       w.name     as workshop,
       f.name     as factory
from employees e
         inner join jobs j on j.id = e.job_id
         inner join sections s on e.section_id = s.id
         inner join workshops w on s.workshop_id = w.id
         inner join factories f on f.id = w.factory_id
where workshop_id = :workshop_id
  and section_id = :section_id
  and job_id = :job_id
UNION
select e.id       as id,
       e.name     as name,
       manager_id as manager,
       job_title  as job,
       job_type   as specialization,
       w.name     as workshop,
       f.name     as factory
from workshops w
         inner join employees e on e.id = w.workshop_leader
         inner join factories f on w.factory_id = f.id
         inner join jobs j on j.id = e.job_id
where job_id = :job_id
ORDER BY id;

-- 4. Получить число и перечень участков указанного цеха, предприятия в целом и их
-- начальников

with _sections as (select s.id   as id,
                          s.name as section,
                          w.name as workshop,
                          f.name as factory,
                          e.name as manager
                   from sections s
                            inner join workshops w on s.workshop_id = w.id
                            inner join factories f on w.factory_id = f.id
                            right join employees e on e.section_id = s.id
                   where workshop_id = :workshop_id
                     and factory_id = :factory_id
                     and position = 'Начальник участка'
                   order by id)
-- select count(*)
-- from _sections;
select *
from _sections;

-- 5. Получить перечень работ, которые проходит указанное изделие.
select product_id, work_name, start_time, end_time
from production_history ph
         left join product_completion_history pch on ph.id = pch.work_id
where product_id = :product_id
order by start_time;

-- 6. Получить состав бригад указанного участка, цеха.
select e.id      as id,
       e.name    as name,
       brigade_id,
       job_title as job,
       job_type  as specialization,
       s.name    as section,
       w.name    as workshop

from employees e
         inner join brigade_employees be on e.id = be.employee_id
         inner join brigades b on b.id = be.brigade_id
         inner join sections s on s.id = b.section_id
         inner join workshops w on w.id = s.workshop_id
         inner join jobs j on j.id = e.job_id
where b.section_id = :section_id
  and workshop_id = :workshop_id
order by brigade_id, id;

-- 7. Получить список мастеров указанного участка, цеха.
select e.id      as id,
       e.name    as name,
       job_title as job,
       job_type  as specialization,
       s.name    as section,
       w.name    as workshop,
       position
from employees e
         inner join jobs j on j.id = e.job_id
         inner join sections s on e.section_id = s.id
         inner join workshops w on s.workshop_id = w.id
where workshop_id = :workshop_id
  and section_id = :section_id
  and position = 'Мастер';


-- 8. Получить перечень изделий отдельной категории и в целом, собираемых в настоящий
-- момент указанным участком, цехом, предприятием.
-- Отдельной категории
select ph.id         as id,
       ph.product_id as product_id,
       work_name,
       s.name        as section,
       w.name        as workshop,
       f.name        as factory,
       start_time
from production_history ph
         left join product_completion_history pch on ph.id = pch.work_id
         inner join products p on p.id = ph.product_id
         inner join product_types pt on pt.id = p.type_id
         inner join product_categories pc on pc.id = pt.category_id
         inner join sections s on ph.section_id = s.id
         inner join workshops w on w.id = s.workshop_id
         inner join factories f on f.id = w.factory_id
where section_id = :section_id
  and s.workshop_id = :workshop_id
  and factory_id = :factory_id
  and category_id = :category_id
  and end_time is null;
-- В целом
select ph.id         as id,
       ph.product_id as product_id,
       work_name,
       s.name        as section,
       w.name        as workshop,
       f.name        as factory,
       start_time
from production_history ph
         left join product_completion_history pch on ph.id = pch.work_id
         inner join products p on p.id = ph.product_id
         inner join product_types pt on pt.id = p.type_id
         inner join product_categories pc on pc.id = pt.category_id
         inner join sections s on ph.section_id = s.id
         inner join workshops w on w.id = s.workshop_id
         inner join factories f on f.id = w.factory_id
where section_id = :section_id
  and s.workshop_id = :workshop_id
  and factory_id = :factory_id
  and end_time is null;

-- 9. Получить состав бригад, участвующих в сборке указанного изделия.
select e.id as id, e.name as name, work_name, job_title as job, job_type as specialization, be.brigade_id as brigade_id
from products p
         inner join production_history ph on p.id = ph.product_id
         right join brigade_employees be on ph.brigade_id = be.brigade_id
         inner join employees e on e.id = be.employee_id
         inner join jobs j on j.id = e.job_id
where ph.product_id = :product_id;

-- 10. Получить перечень испытательных лабораторий, участвующих в испытаниях некоторого
-- конкретного изделия.
select p.id as product_id, pt.name as product_type, l.name as laboratory
from products p
         inner join testing_history th on p.id = th.product_id
         inner join product_types pt on pt.id = p.type_id
         inner join laboratory l on l.id = th.laboratory_id
where p.id = :product_id;

-- 11. Получить перечень изделий отдельной категории и в целом, проходивших испытание в
-- указанной лаборатории за определенный период.
-- Отдельной категории
select p.id          as product_id,
       pt.name       as product_type,
       l.name        as laboratory,
       th.start_time as start_time,
       tch.end_time  as end_time
from products p
         inner join testing_history th on p.id = th.product_id
         inner join product_types pt on pt.id = p.type_id
         inner join laboratory l on l.id = th.laboratory_id
         inner join product_categories pc on pc.id = pt.category_id
         left join test_completion_history tch on th.id = tch.test_id
where l.id = :laboratory_id
  and category_id = :category_id
  and th.start_time between :start_time and :end_time;
-- В целом
select p.id          as product_id,
       pt.name       as product_type,
       l.name        as laboratory,
       th.start_time as start_time,
       tch.end_time  as end_time
from products p
         inner join testing_history th on p.id = th.product_id
         inner join product_types pt on pt.id = p.type_id
         inner join laboratory l on l.id = th.laboratory_id
         left join test_completion_history tch on th.id = tch.test_id
where l.id = :laboratory_id
  and th.start_time between :start_time and :end_time;

-- 12. Получить список испытателей, участвующих в испытаниях указанного изделия, изделий
-- отдельной категории и в целом в некоторой лаборатории за определенный период.
-- Отдельного изделия
select e.name as laboratorian
from testing_history th
         inner join laboratorians_n_tests lnt on th.id = lnt.test_id
         inner join employees e on e.id = lnt.laboratorian_id
where th.product_id = :product_id
group by e.name;

-- Отдельной категории
select e.name as laboratorian
from testing_history th
         inner join laboratorians_n_tests lnt on th.id = lnt.test_id
         inner join products p on p.id = th.product_id
         inner join product_types pt on pt.id = p.type_id
         inner join product_categories pc on pc.id = pt.category_id
         inner join employees e on e.id = lnt.laboratorian_id
where pc.id = :category_id
group by e.name;

-- В целом
select e.name as laboratorian
from (select * from testing_history where start_time >= :start_time and start_time <= :end_time) th
         inner join laboratorians_n_tests lnt on th.id = lnt.test_id
         inner join employees e on e.id = lnt.laboratorian_id
         left join test_completion_history tch on th.id = tch.test_id
where th.laboratory_id = :laboratory_id
  and (end_time <= :end_time or end_time is null)
group by e.name;

-- 13. Получить состав оборудования, использовавшегося при испытании указанного изделия,
-- изделий отдельной категории и в целом в некоторой лаборатории за определенный период.

-- Отдельного изделия
select e.name as equipment
from testing_history th
         inner join laboratorians_n_tests lnt on th.id = lnt.test_id
         inner join equipment_n_tests ent on th.id = ent.test_id
         inner join equipment e on e.id = ent.equipment_id
where th.product_id = :product_id
group by e.name;

-- Отдельной категории
select e.name as equipment
from testing_history th
         inner join laboratorians_n_tests lnt on th.id = lnt.test_id
         inner join products p on p.id = th.product_id
         inner join product_types pt on pt.id = p.type_id
         inner join product_categories pc on pc.id = pt.category_id
         inner join equipment_n_tests ent on th.id = ent.test_id
         inner join equipment e on e.id = ent.equipment_id
where pc.id = :category_id
group by e.name;

-- В целом
select e.name as equipment
from (select * from testing_history where start_time >= :start_time and start_time <= :end_time) th
         inner join laboratorians_n_tests lnt on th.id = lnt.test_id
         inner join equipment_n_tests ent on th.id = ent.test_id
         inner join equipment e on e.id = ent.equipment_id
         left join test_completion_history tch on th.id = tch.test_id
where th.laboratory_id = :laboratory_id
  and (end_time <= :end_time or end_time is null)
group by e.name;

-- 14. Получить число и перечень изделий отдельной категории и в целом, собираемых
-- указанным цехом, участком, предприятием в целом в настоящее время.

-- Отдельной категории
with products_in_work as (select ph.id as id, pt.name as name
                          from production_history ph
                                   inner join products p on p.id = ph.product_id
                                   inner join product_types pt on pt.id = p.type_id
                                   inner join product_categories pc on pc.id = pt.category_id
                                   inner join sections s on s.id = ph.section_id
                                    inner join workshops w on w.id = s.workshop_id
                                      inner join factories f on f.id = w.factory_id
                                   left join product_completion_history pch on ph.id = pch.work_id
                          where end_time is null and pc.id = :category_id and section_id = :section_id
                            and s.workshop_id = :workshop_id and factory_id = :factory_id)
-- select count(*) from products_in_work;
select * from products_in_work;

-- В целом
with products_in_work as (select ph.id as id, pt.name as name
                          from production_history ph
                                   inner join products p on p.id = ph.product_id
                                   inner join product_types pt on pt.id = p.type_id
                                   inner join sections s on s.id = ph.section_id
                                    inner join workshops w on w.id = s.workshop_id
                                      inner join factories f on f.id = w.factory_id
                                   left join product_completion_history pch on ph.id = pch.work_id
                          where end_time is null and section_id = :section_id
                            and s.workshop_id = :workshop_id and factory_id = :factory_id)
-- select count(*) from products_in_work;
select * from products_in_work;
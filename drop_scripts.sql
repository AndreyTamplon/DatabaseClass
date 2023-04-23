select 'drop table if exists ' || tablename || ' cascade;' 
  from pg_tables
 where schemaname = 'factory';

drop table if exists product_attributes cascade;
drop table if exists employees cascade;
drop table if exists workshops cascade;
drop table if exists factories cascade;
drop table if exists jobs cascade;
drop table if exists product_categories cascade;
drop table if exists sections cascade;
drop table if exists product_types cascade;
drop table if exists job_attributes cascade;
drop table if exists brigades cascade;
drop table if exists workshops_n_labs cascade;
drop table if exists laboratory cascade;
drop table if exists equipment cascade;
drop table if exists testing_history cascade;
drop table if exists products cascade;
drop table if exists brigade_employees cascade;
drop table if exists production_history cascade;
drop table if exists job_history cascade;
drop table if exists laboratorians_n_tests cascade;
drop table if exists equipment_n_tests cascade;
drop table if exists product_completion_history cascade;
drop table if exists test_completion_history cascade;

-- triggers and functions drop
-- 1)
DROP TRIGGER IF EXISTS check_brigadier_job_type_trigger ON factory.brigades;
DROP FUNCTION IF EXISTS check_brigadier_job_type_on_brigades();

-- 2)
DROP TRIGGER IF EXISTS check_brigadier_job_type_on_employees_trigger ON factory.employees;
DROP FUNCTION IF EXISTS check_brigadier_job_type_in_employees();

-- 3)
DROP TRIGGER IF EXISTS check_master_job_type_trigger ON factory.employees;
DROP FUNCTION IF EXISTS check_master_job_type();

-- 4)
DROP TRIGGER IF EXISTS check_section_chief_job_type_trigger ON factory.employees;
DROP FUNCTION IF EXISTS check_section_chief_job_type();

-- 5)
DROP TRIGGER IF EXISTS check_workshop_chief_job_type_trigger ON factory.employees;
DROP FUNCTION IF EXISTS check_workshop_chief_job_type();

-- 6)
DROP TRIGGER IF EXISTS check_product_flow_workshops_trigger ON factory.production_history;
DROP FUNCTION IF EXISTS check_product_flow_workshops();

-- 7)
DROP TRIGGER IF EXISTS check_master_hierarchy_trigger ON factory.employees;
DROP FUNCTION IF EXISTS check_master_hierarchy();

-- 8)
DROP TRIGGER IF EXISTS check_section_chief_hierarchy_trigger ON factory.employees;
DROP FUNCTION IF EXISTS check_section_chief_hierarchy();

-- 9)
DROP TRIGGER IF EXISTS check_stage_end_dates_trigger ON factory.product_completion_history;
DROP FUNCTION IF EXISTS check_stage_end_dates();

-- 10)
DROP TRIGGER IF EXISTS check_stage_start_dates_trigger ON factory.production_history;
DROP FUNCTION IF EXISTS check_stage_start_dates();

-- 11)
DROP TRIGGER IF EXISTS check_test_stage_end_dates_trigger ON factory.test_completion_history;
DROP FUNCTION IF EXISTS check_test_stage_end_dates();

-- 12)
DROP TRIGGER IF EXISTS check_test_stage_start_dates_trigger ON factory.testing_history;
DROP FUNCTION IF EXISTS check_test_stage_start_dates();

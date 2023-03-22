CREATE TABLE factory.workshops (
	"id" serial NOT NULL,
	"name" character varying(150) NOT NULL UNIQUE,
	"workshop_leader" integer NOT NULL,
	"factory_id" integer NOT NULL,
	CONSTRAINT "workshops_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.sections (
	"id" serial NOT NULL,
	"name" character varying(150) NOT NULL,
	"workshop_id" integer NOT NULL,
	CONSTRAINT "sections_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.product_categories (
	"id" serial NOT NULL,
	"category" character varying(150) NOT NULL,
	"subcategory" character varying(150),
	CONSTRAINT "product_categories_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.product_attributes (
	"id" serial NOT NULL,
	"name" character varying(150) NOT NULL,
	"value" TEXT,
	"product_id" integer NOT NULL,
	CONSTRAINT "product_attributes_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.jobs (
	"id" serial NOT NULL,
	"job_title" character varying(150) NOT NULL,
	"job_type" character varying(150) NOT NULL,
	CONSTRAINT "jobs_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.job_attributes (
	"id" serial NOT NULL,
	"name" character varying(150) NOT NULL,
	"value" TEXT,
	"job_id" integer NOT NULL,
	CONSTRAINT "job_attributes_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.product_types (
	"id" serial NOT NULL,
	"name" character varying(150) NOT NULL,
	"category_id" integer NOT NULL,
	"workshop_id" integer NOT NULL,
	CONSTRAINT "product_types_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.employees (
	"id" serial NOT NULL,
	"name" character varying(150) NOT NULL,
	"job_id" integer NOT NULL,
	"manager_id" integer,
	"position" character varying(150) NOT NULL,
	"section_id" integer,
	CONSTRAINT "employees_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.brigades (
	"id" serial NOT NULL,
	"name" character varying(150) NOT NULL,
	"brigadier_id" integer NOT NULL,
	"section_id" integer NOT NULL,
	CONSTRAINT "brigades_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.laboratory (
	"id" serial NOT NULL,
	"name" character varying(150) NOT NULL UNIQUE,
	CONSTRAINT "laboratory_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.workshops_n_labs (
	"workshop_id" integer NOT NULL,
	"laboratory_id" integer NOT NULL
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.equipment (
	"id" serial NOT NULL,
	"name" character varying(150) NOT NULL,
	"laboratory_id" integer NOT NULL,
	CONSTRAINT "equipment_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.testing_history (
	"id" serial NOT NULL,
	"test_name" character varying(150) NOT NULL,
	"laboratory_id" integer NOT NULL,
	"product_id" integer NOT NULL,
	"start_time" timestamp with time zone NOT NULL,
	CONSTRAINT "testing_history_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.brigade_employees (
	"employee_id" integer NOT NULL,
	"brigade_id" integer NOT NULL
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.production_history (
	"id" serial NOT NULL,
	"product_id" integer NOT NULL,
	"work_name" character varying(150) NOT NULL,
	"section_id" integer NOT NULL,
	"brigade_id" integer NOT NULL,
	"start_time" timestamp with time zone,
	CONSTRAINT "production_history_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);




CREATE TABLE factory.job_history (
	"employee_id" integer NOT NULL,
	"start_date" timestamp with time zone,
	"end_date" timestamp with time zone,
	"job_id" integer NOT NULL
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.laboratorians_n_tests (
	"laboratorian_id" integer NOT NULL,
	"test_id" integer NOT NULL
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.equipment_n_tests (
	"equipment_id" integer NOT NULL,
	"test_id" integer NOT NULL
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.product_completion_history (
	"work_id" integer NOT NULL,
	"end_time" timestamp with time zone NOT NULL
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.test_completion_history (
	"test_id" integer NOT NULL,
	"end_time" timestamp with time zone NOT NULL
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.products (
	"id" serial NOT NULL,
	"product_id" uuid NOT NULL UNIQUE,
	"type_id" integer NOT NULL,
	CONSTRAINT "products_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE factory.factories (
	"id" serial NOT NULL,
	"name" character varying(150) NOT NULL UNIQUE,
	CONSTRAINT "factories_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



ALTER TABLE "workshops" ADD CONSTRAINT "workshops_fk0" FOREIGN KEY ("workshop_leader") REFERENCES "employees"("id");
ALTER TABLE "workshops" ADD CONSTRAINT "workshops_fk1" FOREIGN KEY ("factory_id") REFERENCES "factories"("id");

ALTER TABLE "sections" ADD CONSTRAINT "sections_fk0" FOREIGN KEY ("workshop_id") REFERENCES "workshops"("id");


ALTER TABLE "product_attributes" ADD CONSTRAINT "product_attributes_fk0" FOREIGN KEY ("product_id") REFERENCES "product_types"("id");


ALTER TABLE "job_attributes" ADD CONSTRAINT "job_attributes_fk0" FOREIGN KEY ("job_id") REFERENCES "jobs"("id");

ALTER TABLE "product_types" ADD CONSTRAINT "product_types_fk0" FOREIGN KEY ("category_id") REFERENCES "product_categories"("id");
ALTER TABLE "product_types" ADD CONSTRAINT "product_types_fk1" FOREIGN KEY ("workshop_id") REFERENCES "workshops"("id");

ALTER TABLE "employees" ADD CONSTRAINT "employees_fk0" FOREIGN KEY ("job_id") REFERENCES "jobs"("id");
ALTER TABLE "employees" ADD CONSTRAINT "employees_fk1" FOREIGN KEY ("manager_id") REFERENCES "employees"("id");
ALTER TABLE "employees" ADD CONSTRAINT "employees_fk2" FOREIGN KEY ("section_id") REFERENCES "sections"("id");

ALTER TABLE "brigades" ADD CONSTRAINT "brigades_fk0" FOREIGN KEY ("brigadier_id") REFERENCES "employees"("id");
ALTER TABLE "brigades" ADD CONSTRAINT "brigades_fk1" FOREIGN KEY ("section_id") REFERENCES "sections"("id");


ALTER TABLE "workshops_n_labs" ADD CONSTRAINT "workshops_n_labs_fk0" FOREIGN KEY ("workshop_id") REFERENCES "workshops"("id");
ALTER TABLE "workshops_n_labs" ADD CONSTRAINT "workshops_n_labs_fk1" FOREIGN KEY ("laboratory_id") REFERENCES "laboratory"("id");

ALTER TABLE "equipment" ADD CONSTRAINT "equipment_fk0" FOREIGN KEY ("laboratory_id") REFERENCES "laboratory"("id");

ALTER TABLE "testing_history" ADD CONSTRAINT "testing_history_fk0" FOREIGN KEY ("laboratory_id") REFERENCES "laboratory"("id");
ALTER TABLE "testing_history" ADD CONSTRAINT "testing_history_fk1" FOREIGN KEY ("product_id") REFERENCES "products"("id");

ALTER TABLE "brigade_employees" ADD CONSTRAINT "brigade_employees_fk0" FOREIGN KEY ("employee_id") REFERENCES "employees"("id");
ALTER TABLE "brigade_employees" ADD CONSTRAINT "brigade_employees_fk1" FOREIGN KEY ("brigade_id") REFERENCES "brigades"("id");

ALTER TABLE "production_history" ADD CONSTRAINT "production_history_fk0" FOREIGN KEY ("product_id") REFERENCES "products"("id");
ALTER TABLE "production_history" ADD CONSTRAINT "production_history_fk1" FOREIGN KEY ("section_id") REFERENCES "sections"("id");
ALTER TABLE "production_history" ADD CONSTRAINT "production_history_fk2" FOREIGN KEY ("brigade_id") REFERENCES "brigades"("id");

ALTER TABLE "job_history" ADD CONSTRAINT "job_history_fk0" FOREIGN KEY ("employee_id") REFERENCES "employees"("id");
ALTER TABLE "job_history" ADD CONSTRAINT "job_history_fk1" FOREIGN KEY ("job_id") REFERENCES "jobs"("id");

ALTER TABLE "laboratorians_n_tests" ADD CONSTRAINT "laboratorians_n_tests_fk0" FOREIGN KEY ("laboratorian_id") REFERENCES "employees"("id");
ALTER TABLE "laboratorians_n_tests" ADD CONSTRAINT "laboratorians_n_tests_fk1" FOREIGN KEY ("test_id") REFERENCES "testing_history"("id");

ALTER TABLE "equipment_n_tests" ADD CONSTRAINT "equipment_n_tests_fk0" FOREIGN KEY ("equipment_id") REFERENCES "equipment"("id");
ALTER TABLE "equipment_n_tests" ADD CONSTRAINT "equipment_n_tests_fk1" FOREIGN KEY ("test_id") REFERENCES "testing_history"("id");

ALTER TABLE "product_completion_history" ADD CONSTRAINT "product_completion_history_fk0" FOREIGN KEY ("work_id") REFERENCES "production_history"("id");

ALTER TABLE "test_completion_history" ADD CONSTRAINT "test_completion_history_fk0" FOREIGN KEY ("test_id") REFERENCES "testing_history"("id");

ALTER TABLE "products" ADD CONSTRAINT "products_fk0" FOREIGN KEY ("type_id") REFERENCES "product_types"("id");
























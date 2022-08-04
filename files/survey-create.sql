CREATE TABLE Person (
  person_id text,
  personal_name text,
  family_name text
);
CREATE TABLE Site (
  site_name text,
  lat real,
  long real
);
CREATE TABLE Visit (
  visit_id integer,
  site_name text,
  visit_date text
);
CREATE TABLE Measurement (
  visit_id integer,
  person_id text,
  type text,
  value real
);
CREATE TABLE Person (
  person_id text PRIMARY KEY NOT NULL,
  personal_name text NOT NULL,
  family_name text NOT NULL
);
CREATE TABLE Site (
  site_name text PRIMARY KEY NOT NULL,
  lat real NOT NULL,
  long real NOT NULL
);
CREATE TABLE Visit (
  visit_id integer PRIMARY KEY NOT NULL,
  site_name text NOT NULL,
  visit_date text,
  CONSTRAINT fk_visit_site
    FOREIGN KEY (site_name)
    REFERENCES Site(site_name)
);
CREATE TABLE Measurement (
  visit_id integer NOT NULL,
  person_id text,
  type text NOT NULL,
  value real NOT NULL,
  PRIMARY KEY (visit_id, person_id, type), 
  CONSTRAINT fk_survey_visit
    FOREIGN KEY (visit_id)
    REFERENCES Visit(visit_id),
  CONSTRAINT fk_survey_person
    FOREIGN KEY (person_id)
    REFERENCES Person(person_id)
);

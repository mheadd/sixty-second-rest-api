-- Set up a new table to hold our data. Copy your table structure below.
CREATE TABLE "simpleapi" (
	"ScoreRecent" DECIMAL NOT NULL, 
	"GradeRecent" VARCHAR NOT NULL, 
	"DateRecent" TIMESTAMP WITHOUT TIME ZONE, 
	"Score2" DECIMAL, 
	"Grade2" VARCHAR, 
	"Date2" TIMESTAMP WITHOUT TIME ZONE, 
	"Score3" DECIMAL, 
	"Grade3" VARCHAR, 
	"Date3" TIMESTAMP WITHOUT TIME ZONE, 
	permit_number DECIMAL NOT NULL, 
	facility_type DECIMAL NOT NULL, 
	facility_type_description VARCHAR NOT NULL, 
	subtype DECIMAL NOT NULL, 
	subtype_description VARCHAR NOT NULL, 
	premise_name VARCHAR NOT NULL, 
	premise_address VARCHAR NOT NULL, 
	premise_city VARCHAR NOT NULL, 
	premise_state VARCHAR NOT NULL, 
	premise_zip DECIMAL NOT NULL, 
	opening_date TIMESTAMP WITHOUT TIME ZONE
);

-- Import data from a CSV file into the table. Change the name below to match your file.
COPY simpleapi FROM '/tmp/Inspection_Results_School_Food_Service.csv' WITH (FORMAT csv);
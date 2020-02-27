# Sixty Second REST API

A powerful, simple, RESTful API generated from a CSV or text document in about 60 seconds.

Note - this example is [an update to an older version that I published a few years ago](https://github.com/mheadd/simple-rest-api) that described a similar approach to use containers to set up a REST API from a data file in CSV format.

This example builds on the previous one by using Docker Compose to set up separate containers for a [PostgreSQL](https://hub.docker.com/_/postgres) database and [PostgREST](http://postgrest.org/en/v6.0/), and also populate the database with test data.

## Structure

* `docker-compose.yml` - this is the Docker Compose file that will build and run the separate containes we need for the database and the REST front end.
* `.env` - a file to hold environmental variables used by the Docker Compose script. Modify these as needed.
* `init/setup.sql` - this is the SQL file that will be executed when the PostgreSQL container is run, it sets up a new table to hold our data and imports the data from a CSV file.
* `data/{name-of-your-data-file}.csv` - the file that holds the data you want to serve through your API.

## Usage

First, find a CSV file for some data that you want to use in your API. There are lots and lots of sources [here](https://www.data.gov/). For the purposes of this example, I'll use a data set that is similar to the one used in my [older example](https://github.com/mheadd/simple-rest-api). You can find meta information about this data set [here](https://data.louisvilleky.gov/dataset/environmental-health-inspection-results):

```bash
~$ curl -s https://data.louisvilleky.gov/sites/default/files/26911/Inspection_Results_School_Food_Service.csv > data/Inspection_Results_School_Food_Service.csv
```

Next, we need to crete the table structure in PostgreSQL. This is super easy if you have [csvkit](https://csvkit.readthedocs.io/en/1.0.2/scripts/csvsql.html) installed on your machine:

```bash
~$ csvsql -i postgresql data/Inspection_Results_School_Food_Service.csv
```

Copy and paste the `CREATE TABLE` syntax into the `data/setup.sql` file. In our Docker Compose file, we specify a SQL script to run when the container is started, and specify a place for the CSV data want to import. 

Now it's time to build and run our containers:

```bash
~$ docker-compose up -d
```

When the containers are up, you can access the data like so to get all records with a `C` inspection result: 

```bash
~$ curl -s "http://127.0.0.1:3000/simpleapi?GradeRecent=eq.C" | jq .
```

This will display the results and format the JSON using the fabulous `jq` tool.


```json
[
  {
    "ScoreRecent": 97,
    "GradeRecent": "C",
    "DateRecent": "2019-09-11T00:00:00",
    "Score2": 100,
    "Grade2": "A",
    "Date2": "2019-02-04T00:00:00",
    "Score3": 100,
    "Grade3": "A",
    "Date3": "2018-10-22T00:00:00",
    "permit_number": 30248,
    "facility_type": 605,
    "facility_type_description": "FOOD SERVICE ESTABLISHMENT",
    "subtype": 33,
    "subtype_description": "SCHOOL CAFETERIA OR FOOD SERVICE",
    "premise_name": "NEWCOMER ACADEMY",
    "premise_address": "3741 PULLIAM DR",
    "premise_city": "LOUISVILLE",
    "premise_state": "KY",
    "premise_zip": 40218,
    "opening_date": "1988-11-14T00:00:00"
  },
  {
    "ScoreRecent": 92,
    "GradeRecent": "C",
    "DateRecent": "2019-08-27T00:00:00",
    "Score2": 99,
    "Grade2": "A",
    "Date2": "2019-01-22T00:00:00",
    "Score3": 100,
    "Grade3": "A",
    "Date3": "2018-09-24T00:00:00",
    "permit_number": 31435,
    "facility_type": 605,
    "facility_type_description": "FOOD SERVICE ESTABLISHMENT",
    "subtype": 33,
    "subtype_description": "SCHOOL CAFETERIA OR FOOD SERVICE",
    "premise_name": "MOORE HIGH SCHOOL",
    "premise_address": "6415 OUTER LOOP",
    "premise_city": "LOUISVILLE",
    "premise_state": "KY",
    "premise_zip": 40228,
    "opening_date": "1988-07-14T00:00:00"
  }
]
```
For more on querying data using PostgREST, [check out the docs](http://postgrest.org/en/v6.0/).

## Pushing to the cloud

Once you've got your data and Docker Compose file working like you want, you can push it all to the cloud and make your API available to others. Amazon's Elastic Container Service [supports Docker Compose files](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI.html) for deploying multi-container apps so you can use the ECS CLI to push it to the cloud.
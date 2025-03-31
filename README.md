# NYC EMS Incident Calls

## Table of Contents
1. [Problem Statement](#problem-statement)
2. [Dataset](#dataset)
3. [Data Pipeline](#data-pipeline)
4. [Technologies Used](#technologies-used)
5. [Dashboard](#dashboard)
6. [Reproducability](#reproducability)

## Problem Statement:
There is a need to understand both the volume and distribution of EMS incidents in the New York metropolitan area, including Manhattan, Brooklyn, Bronx, Queens, and Staten Island. Most importantly, there is a desire to understand where EMS demand is highest and where the response time to incidents is slowest so that adjustments can be made in order to properly support the entire metropolitan area with EMS services.

## Dataset:
The data chosen for this project is sampled from the official NYC OpenData repository and was specifically provided by the Fire Department of New York City (FDNY). The description of the dataset is as follows:
"The EMS Incident Dispatch Data file contains data generated by the EMS Computer Aided Dispatch System. The data spans from the time the incident is created in the system to the time the incident is closed in the system. It covers information about the incident as it relates to the assignment of resources and the Fire Department’s response to the emergency. To protect personal identifying information in accordance with the Health Insurance Portability and Accountability Act (HIPAA), specific locations of incidents are not included and have been aggregated to a higher level of detail."
The EMS data ranges from 2005 to October 2024, totaling over 26 million records, and is accessed via an API endpoint. More information is provided here: [EMS-Incident-Dispatch-Data](https://data.cityofnewyork.us/Public-Safety/EMS-Incident-Dispatch-Data/76xm-jjuj/about_data)

## Data Pipeline:
1. API request via python code is made on Sunday for all EMS data from trigger date going back 7 days
2. API request returns JSON body which is converted to pandas dataframe
3. Pandas dataframe is uploaded to gcs data lake
    - Data lake is structered as /YEAR/MONTH/DATA.csv
    - CSV was chosen because although there are many files, each file is relatively manageable in size
4. Google BigQuery external table is created with the csv saved in step 3
5. External table is merged into the main data warehouse table using unique incidet ID as matching column
6. DBT staging model used to set up cleaned version of main data warehouse table
    - Tests made on unique incident ID to ensure uniqueness and absence of null values
7. DBT fact models derived from staging model
8. Looker dashboard linked to fact tables for visualization of data and ability to address problem statement

![Data Pipeline](/images/pipeline.png)

## Technologies Used:
* Cloud: 
    - GCP 
* Infrastructure:
    - Terraform
* Workflow:
    - Kestra
* Data Warehouse:
    - BigQuery
* Transformation
    - DBT
* Visualization
    - Looker Studio

## Dashboard:
Project dashboard can be found here: [Dashboard](https://lookerstudio.google.com/s/ifu3CpbM-yI)

## Reproducability:
* Prerequisites:
    - Docker/Docker Compose
    - GCP Project
    - DBT Core with BigQuery extension
    - Clone repo
1. Open the variables.tf file from within /terraform
2. Update all variables for you specific GCP project. You will also need to determine the naming for your BigQuery data set the the GCS bucket (must be globally unique)
    - In the console within /terraform run ```terraform init```
    - Run ```terraform plan``` and review the resources that will be built (BigQuery dataset and GCS bucket)
    - Run ```terraform apply``` and check your GCP project to make sure that the resources have been created
    - If at any point you would like to delete these resources run ```terraform destroy``` from this same directory 
3. Within /Docker you need to create a .env file that has 3 environment variables
    - ```SECRET_KESTRA_USERNAME=<email>```
    - ```SECRET_KESTRA_PASSWORD=<password>```
    - (OPTIONAL) ```SECRET_GITHUB_TOKEN=<base64 token generated in github>```
4. Witin /Docker run ```docker-compose up -d``` to initiate the Kestra and it postgres DB
5. Ensure that port 8082 on the VM is exposed to your local machine
6. Type localhost:8082 into your web browswer to open up Kestra
    - Import /kestra_flow/nyc-ems-calls-ingestion.yml into Kestra
    - Navigate to the flows trigger and begin process of executing a backfill since this project will use the backfill tool to simualate a weekly batch process
    - Execute the flow on backfill from 2005-01-01 to 2023-12-31
7. Once the backfill has executed navigate to /dbt_nyc_ems_calls
8. Execute a test run by running ```dbt build``` in the terminal
9. Check BigQuery to ensure everything was transfered over.
    - You should see nyc_ems_calls_dataset_staging and nyc_ems_calls_dataset_prod
10. Execute a production run by running ```dbt build --vars '{'is_test_run': 'false'}```
11. Check 'nyc_ems_calls_dataset_staging.stg_nyc_ems_calls' should have a row count of 26012701
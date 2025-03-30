# NYC EMS Incident Calls

## Problem Statement:
There is a need to understand both the volume and distribution of EMS incidents in the New York metropolitan area including Manhattan, Brooklyn, Bronx, Queens and Staten Island. Most importantly there is a desire to to understand where EMS demand is highest and where the response time to incidents is slowest so that adjustments can be made in order to properly support the entire metropolitan area with EMS services. 

## Dataset:
The data chosen for this project is sampled from the official NYC OpenData repository and was specifically provided by the Fire Department of New York City (FDNY). The description of the dataset is as follows: "The EMS Incident Dispatch Data file contains data that is generated by the EMS Computer Aided Dispatch System. The data spans from the time the incident is created in the system to the time the incident is closed in the system. It covers information about the incident as it relates to the assignment of resources and the Fire Department’s response to the emergency. To protect personal identifying information in accordance with the Health Insurance Portability and Accountability Act (HIPAA), specific locations of incidents are not included and have been aggregated to a higher level of detail." The ems data ranges from 2005 to October of 2024 totaling over 26 million records and is accessed via API enpoint. More information is provided here: [EMS-Incident-Dispatch-Data](https://data.cityofnewyork.us/Public-Safety/EMS-Incident-Dispatch-Data/76xm-jjuj/about_data)

## Data Pipeline:
1. API request via python code is made on Sunday for all EMS data from trigger date going back 7 days
2. API request returns JSON body which is converted to pandas dataframe
3. Pandas dataframe is uploaded to gcs data lake
 * Data lake is structered as /YEAR/MONTH/DATA.csv
 * CSV was chosen because although there are many files, each file is relatively manageable in size
4. Google BigQuery external table is created with the csv saved in step 3
5. External table is merged into the main data warehouse table using unique incidet ID as matching column
6. DBT staging model used to set up cleaned version of main data warehouse table
 * Tests made on unique incident ID to ensure uniqueness and absence of null values
7. DBT fact models derived from staging model
8. Looker dashboard linked to fact tables for visualization of data and ability to address problem statement

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
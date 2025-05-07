# DBT Project
This DBT project simulates inputs from an e-commerce platform and builds datasets using Google BigQuery as the data warehouse.

## Project Overview
The models are designed to read from raw tables that can be connected to a CDC (Change Data Capture) queue and support incremental loads.

Initially, the raw tables are populated using four test CSVs via dbt seed. These CSVs simulate historical and changed records from backend systems.

The data is then cleaned and deduplicated using a row_number() window over the updated_at column to create a snapshot of the latest version of each record.
The incremental load is made using the last updated_at. 

Finally, two fact views are built on top of the cleaned staging tables:

fact_orders: Contains total price per product per order

customer_total_spent: Aggregates total spend per customer (only includes customers who placed orders)

You can check the result tables directly in BigQuery by visiting this link (you must be logged into a Google account):


👉 View in BigQuery

## Project Structure
The models follow DBT’s layered architecture:

* **seed/**
  
    Ingests raw data from CSV seeds
* **models/stg/**
    Deduplicates using row_number() and qualify

    Filters new records using is_incremental() + updated_at

    Adds a load_at timestamp column

* **models/fact_tables/**

    fact_orders: One row per product per order, with total_price = quantity * price

    customer_total_spent: Aggregates total spending per customer and includes only customers who placed orders

## Data Tests
All key models are tested with:

Primary key uniqueness

Not null constraints

Referential integrity between related models

## ⚙️ Setup Instructions

This project uses Google BigQuery as the data warehouse.

### Prerequisites

Create or use an existing Google Cloud Project
https://cloud.google.com/resource-manager/docs/creating-managing-projects

Create a service account with the BigQuery Admin role:
https://cloud.google.com/bigquery/docs/access-control#bigquery.admin

Generate a service account JSON key:
https://cloud.google.com/iam/docs/keys-create-delete#creating

### 🛠️ Install and Configure

Run the following commands from your terminal:

#### Install the BigQuery adapter for DBT
`pip install dbt-bigquery`

#### Set environment variables
`export DBT_PROFILES_DIR=/{PATH_TO_THE_PROJECT}/dbt_project`

`export GCP_PROJECT_ID={your_gcp_project_id}`

`export GCP_JSON_KEYFILE_PATH=/{PATH_TO_THE_PROJECT}/{your_service_account_key}.json`

#### Running the Project
##### Load the raw CSV data into the warehouse
`dbt seed`
##### Build all models
`dbt run`
##### Run all tests
`dbt test`

### Results
You can now query the processed tables and views in your BigQuery project:

* stg_customers
* stg_orders
* stg_order_details
* stg_products
* fact_orders
* customer_total_spent

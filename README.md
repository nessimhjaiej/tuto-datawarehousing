# Data Warehousing Project (T-SQL)

## Overview
First end-to-end data warehousing project using T-SQL.  
Implements Medallion Architecture (Bronze, Silver, Gold).  
Covers Data Architecture, ETL Pipelines, Data Modeling, and Data Marts.

## Steps
1. Create database and schemas.
2. Build Bronze layer for raw ingestion.
3. Transform into Silver layer for standardized, cleansed data.
4. Model Gold layer as star schema for analytics.

## Data Architecture
![High level Architecture](https://github.com/user-attachments/assets/2df87ed6-7499-49b4-a02c-d80c69534b52)

- **Bronze**: Raw parsed data stored in staging tables.  
- **Silver**: Cleaned, normalized, and standardized data prepared for analytics.  
- **Gold**: Business-ready star schema with fact and dimension tables.  

## ETL Pipeline Diagram
![data_flow_diagram](https://github.com/user-attachments/assets/9def6e03-edeb-4022-a78e-404aa4444d0a)

## Data Integration Model
![data_integration](https://github.com/user-attachments/assets/9077e501-b1d9-4577-9b1f-beaee19346c0)

## Data Mart
![data_mart](https://github.com/user-attachments/assets/9c9a7539-8730-4831-8e39-bd499948017d)

## License
This project is licensed under the MIT License.  
Use, modify, and share with proper attribution.

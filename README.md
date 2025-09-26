
## About This project \ 
This is my first datawarehousing project using T-SQL \
This project involves: \
Data Architecture: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.\
ETL Pipelines: Extracting, transforming, and loading data from source systems into the warehouse.\
Data Modeling: Developing fact and dimension tables optimized for analytical queries.\
#first step is creating the database and schemas \
##Data Architecture \
![High level Architecture ](https://github.com/user-attachments/assets/2df87ed6-7499-49b4-a02c-d80c69534b52) \
the data architecture for this project follows the medallion architecture (bronze,silver,gold) layers
bronze : raw data parsed from the files and put into tables \
silver : transformed data (normalization standardization cleansing ) to prepare for analytics \
gold : business ready data modeled as star schema \
##ETP pipeline diagram \
![data_flow_diagram](https://github.com/user-attachments/assets/9def6e03-edeb-4022-a78e-404aa4444d0a) \
##DATA INTEGRATION MODEL \
this diagram represents how different tables are related to each other \
![data_integration](https://github.com/user-attachments/assets/9077e501-b1d9-4577-9b1f-beaee19346c0)\
##Data mart \
this is the data model that the project follows descibing the association between different business objects from the gold layer \
![data_mart](https://github.com/user-attachments/assets/9c9a7539-8730-4831-8e39-bd499948017d) \
This project is licensed under the MIT License. You are free to use, modify, and share this project with proper attribution.\

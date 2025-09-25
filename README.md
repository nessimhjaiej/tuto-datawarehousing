## datawarehousing
This is a test repository for me following a youtube tutorial \
#first step is creating the databases \
##Data Architecture \
![High level Architecture ](https://github.com/user-attachments/assets/2df87ed6-7499-49b4-a02c-d80c69534b52) \
the data architecture for this project follows the medallion architecture (bronze,silver,gold) layers
bronze : raw data parsed from the files and put into tables \
silver : transformed data (normalization standardization cleansing ) to prepare for analytics \
gold : business ready data modeled as star schema \
##ETP pipeline diagram \
![data_flow_diagram](https://github.com/user-attachments/assets/9def6e03-edeb-4022-a78e-404aa4444d0a) \
#DATA INTEGRATION MODEL \
this diagram represents how different tables are related to each other \
![data_integration](https://github.com/user-attachments/assets/7667a695-ba1c-421d-824d-5cbacc6a035e)

-- quality checks for the silver LAYER
-- ===================================
--checking for null or duplicate values 
--expectation : no result 
select cst_id , count(*) from silver.crm_cust_info
group by cst_id 
having count(*)  > 1 or cst_id is null 
--checking for unwanted spaces
--expected no result 
select cst_firstname --we can check for other columns too 
from silver.crm_cust_info
where cst_firstname != trim(cst_firstname)
--data standardization and normalization 
select distinct(cst_gndr)
from silver.crm_cust_info

-- crm_prd_info : 
select * from silver.crm_prd_info ; 
select prd_id , count(*) 
from silver.crm_prd_info 
group by prd_id
having count(*) > 1 or prd_id is null --we're good 
--checking for unwanted spaces
select prd_nm 
from silver.crm_prd_info
where trim(prd_nm)!=  prd_nm ; --we're good 
--checking for dates
select prd_start_dt , prd_end_dt
from silver.crm_prd_info
where prd_end_dt < prd_start_dt
--checking for normalization 
select distinct(prd_line)
from silver.crm_prd_info ; 
--checking 
select distinct(gen)
from silver.erp_cust_az12
select distinct(bdate) 
from silver.erp_cust_az12
where bdate > GETDATE()
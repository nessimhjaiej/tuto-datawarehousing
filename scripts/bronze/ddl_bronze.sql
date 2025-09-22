use bronze ; 
-- Create the table
drop table if exists crm_cust_info ; 
CREATE TABLE crm_cust_info (
    cst_id INT PRIMARY KEY,
    cst_key VARCHAR(20),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status CHAR(1), 
    cst_gndr CHAR(1),            
    cst_create_date DATE
);	
drop table if exists crm_prd_info ; 
CREATE TABLE crm_prd_info (
    prd_id INT PRIMARY KEY,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(255),
    prd_cost DECIMAL(10,2),      -- allows numbers with 2 decimals (cost can be NULL)
    prd_line CHAR(1),            -- short code like 'R'
    prd_start_dt DATE,
    prd_end_dt DATE
);
drop table if exists crm_sales_details ; 
CREATE TABLE sales_details (
    sls_ord_num   VARCHAR(20) PRIMARY KEY,   -- order number like SO43697
    sls_prd_key   VARCHAR(50),               -- links to product key
    sls_cust_id   INT,                       -- links to customer id
    sls_order_dt  DATE,
    sls_ship_dt   DATE,
    sls_due_dt    DATE,
    sls_sales     DECIMAL(10,2),
    sls_quantity  INT,
    sls_price     DECIMAL(10,2)
);
drop table if exists erp_cust_az12  ; 
CREATE TABLE erp_cust_az12 (
    cid    VARCHAR(20) PRIMARY KEY,  -- customer code/key
    bdate  DATE,                     -- birthdate
    gen    VARCHAR(10)               -- gender (e.g. 'Male', 'Female')
);
drop table if exists erp_loc_a101 ; 
CREATE TABLE erp_loc_a101 (
    cid    VARCHAR(20) PRIMARY KEY,
    cntry  VARCHAR(100)   -- country name
);
drop table if exists erp_px_cat_g1v2 ; 
CREATE TABLE erp_px_cat_g1v2 (
    id          VARCHAR(20) PRIMARY KEY,
    cat         VARCHAR(100),   -- category
    subcat      VARCHAR(100),   -- subcategory
    maintenance VARCHAR(10)     -- Yes / No
);
-- i used this because i made mistakes naming the tables when creating them 
-- alter table loc_a101 rename to erp_loc_a101; 
-- alter table px_cat_g1v2 rename to erp_px_cat_g1v2 ; 

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
	BEGIN TRY 
    DECLARE @start_all DATETIME = GETDATE();
    PRINT '>> Starting full load at ' + CAST(@start_all AS NVARCHAR(30));

    ------------------------------------------------------
    -- silver.crm_cust_info
    ------------------------------------------------------
    DECLARE @start_1 DATETIME = GETDATE();
    PRINT '>> Truncating table silver.crm_cust_info';
    TRUNCATE TABLE silver.crm_cust_info;

    PRINT '>> Inserting into table silver.crm_cust_info';
    INSERT INTO silver.crm_cust_info
    (cst_id , cst_key , cst_firstname , cst_lastname , cst_marital_status , cst_gndr, cst_create_date)
    SELECT cst_id,
           cst_key , 
           TRIM(cst_firstname) AS cst_firstname, 
           TRIM(cst_lastname) AS cst_lastname, 
           CASE WHEN cst_marital_status = 'M' THEN 'Married'
                WHEN cst_marital_status = 'S' THEN 'Single'
                ELSE 'Unknown' END AS cst_marital_status, 
           CASE WHEN cst_gndr = 'M' THEN 'Male'
                WHEN cst_gndr = 'F' THEN 'Female'
                ELSE 'Unknown' END AS cst_gndr,
           cst_create_date
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rn
        FROM bronze.crm_cust_info
    ) t
    WHERE rn = 1 AND cst_id IS NOT NULL;

    DECLARE @end_1 DATETIME = GETDATE();
    PRINT 'Duration crm_cust_info: ' + CAST(DATEDIFF(SECOND,@start_1,@end_1) AS NVARCHAR(20)) + ' seconds';

    ------------------------------------------------------
    -- silver.crm_prd_info
    ------------------------------------------------------
    DECLARE @start_2 DATETIME = GETDATE();
    PRINT '>> Truncating table silver.crm_prd_info';
    TRUNCATE TABLE silver.crm_prd_info;

    PRINT '>> Inserting into table silver.crm_prd_info';
    INSERT INTO silver.crm_prd_info 
    (prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
    SELECT prd_id,
           SUBSTRING(prd_key,1,5) AS cat_id,
           SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
           prd_nm,
           COALESCE(prd_cost,0),
           CASE UPPER(prd_line)
                WHEN 'R' THEN 'Road'
                WHEN 'S' THEN 'Other Sales'
                WHEN 'M' THEN 'Mountain'
                WHEN 'T' THEN 'Touring'
                ELSE 'Unknown' END AS prd_line,
           CAST(prd_start_dt AS DATE),
           CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE)
    FROM bronze.crm_prd_info;

    DECLARE @end_2 DATETIME = GETDATE();
    PRINT 'Duration crm_prd_info: ' + CAST(DATEDIFF(SECOND,@start_2,@end_2) AS NVARCHAR(20)) + ' seconds';

    ------------------------------------------------------
    -- silver.crm_sales_details
    ------------------------------------------------------
    DECLARE @start_3 DATETIME = GETDATE();
    PRINT '>> Truncating table silver.crm_sales_details';
    TRUNCATE TABLE silver.crm_sales_details;

    PRINT '>> Inserting into table silver.crm_sales_details';
    INSERT INTO silver.crm_sales_details
    (sls_ord_num, sls_prd_key, sls_cust_id,
     sls_order_dt, sls_ship_dt, sls_due_dt,
     sls_sales, sls_quantity, sls_price)
    SELECT sls_ord_num,
           sls_prd_key,
           sls_cust_id,
           CASE WHEN LEN(sls_order_dt)!=8 OR sls_order_dt<=0 THEN NULL ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) END,
           CASE WHEN LEN(sls_ship_dt)!=8 OR sls_ship_dt<=0 THEN NULL ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) END,
           CASE WHEN LEN(sls_due_dt)!=8 OR sls_due_dt<=0 THEN NULL ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) END,
           CASE WHEN sls_sales<=0 OR sls_sales IS NULL OR sls_sales!=sls_quantity*ABS(sls_price)
                THEN sls_quantity*ABS(sls_price)
                ELSE sls_sales END,
           sls_quantity,
           CASE WHEN sls_price<=0 OR sls_price IS NULL
                THEN sls_sales/COALESCE(sls_quantity,0) END
    FROM bronze.crm_sales_details;

    DECLARE @end_3 DATETIME = GETDATE();
    PRINT 'Duration crm_sales_details: ' + CAST(DATEDIFF(SECOND,@start_3,@end_3) AS NVARCHAR(20)) + ' seconds';

    ------------------------------------------------------
    -- silver.erp_cust_az12
    ------------------------------------------------------
    DECLARE @start_4 DATETIME = GETDATE();
    PRINT '>> Truncating table silver.erp_cust_az12';
    TRUNCATE TABLE silver.erp_cust_az12;

    PRINT '>> Inserting into table silver.erp_cust_az12';
    INSERT INTO silver.erp_cust_az12
    (cid,bdate,gen)
    SELECT CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid)) ELSE cid END,
           CASE WHEN bdate>GETDATE() THEN NULL ELSE bdate END,
           CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
                ELSE 'Unknown' END
    FROM bronze.erp_cust_az12;

    DECLARE @end_4 DATETIME = GETDATE();
    PRINT 'Duration erp_cust_az12: ' + CAST(DATEDIFF(SECOND,@start_4,@end_4) AS NVARCHAR(20)) + ' seconds';

    ------------------------------------------------------
    -- silver.erp_loc_a101
    ------------------------------------------------------
    DECLARE @start_5 DATETIME = GETDATE();
    PRINT '>> Truncating table silver.erp_loc_a101';
    TRUNCATE TABLE silver.erp_loc_a101;

    PRINT '>> Inserting into table silver.erp_loc_a101';
    INSERT INTO silver.erp_loc_a101
    (cid,cntry)
    SELECT REPLACE(cid,'-',''),
           CASE WHEN UPPER(TRIM(cntry))='DE' THEN 'Germany'
                WHEN UPPER(TRIM(cntry)) IN ('US','USA') THEN 'United States'
                WHEN UPPER(TRIM(cntry))='' OR cntry IS NULL THEN 'Unknown'
                ELSE TRIM(cntry) END
    FROM bronze.erp_loc_a101;

    DECLARE @end_5 DATETIME = GETDATE();
    PRINT 'Duration erp_loc_a101: ' + CAST(DATEDIFF(SECOND,@start_5,@end_5) AS NVARCHAR(20)) + ' seconds';

    ------------------------------------------------------
    -- silver.erp_px_cat_g1v2
    ------------------------------------------------------
    DECLARE @start_6 DATETIME = GETDATE();
    PRINT '>> Truncating table silver.erp_px_cat_g1v2';
    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    PRINT '>> Inserting into table silver.erp_px_cat_g1v2';
    INSERT INTO silver.erp_px_cat_g1v2
    (id,cat,subcat,maintenance)
    SELECT * FROM bronze.erp_px_cat_g1v2;

    DECLARE @end_6 DATETIME = GETDATE();
    PRINT 'Duration erp_px_cat_g1v2: ' + CAST(DATEDIFF(SECOND,@start_6,@end_6) AS NVARCHAR(20)) + ' seconds';

    ------------------------------------------------------
    -- Global duration
    ------------------------------------------------------
    DECLARE @end_all DATETIME = GETDATE();
    PRINT '>> Finished full load at ' + CAST(@end_all AS NVARCHAR(30));
    PRINT '>> Total duration of all loads: ' + CAST(DATEDIFF(SECOND,@start_all,@end_all) AS NVARCHAR(20)) + ' seconds';
	END TRY 
	BEGIN CATCH 
		print 'error occured , here is some information ' ; 
		print 'error message' + error_message() ; 
		print 'error number' + cast(error_number() as nvarchar) 
		print 'error state' + cast(error_state() as nvarchar)
	END CATCH
END;
GO

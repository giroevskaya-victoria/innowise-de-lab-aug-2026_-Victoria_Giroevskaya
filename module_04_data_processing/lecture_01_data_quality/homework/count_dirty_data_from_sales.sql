SELECT COUNT(*)
FROM bronze.bronze_sales
WHERE sales_timestamp IS NULL
   OR sales_timestamp = ''
   OR sales_timestamp ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$' = FALSE;

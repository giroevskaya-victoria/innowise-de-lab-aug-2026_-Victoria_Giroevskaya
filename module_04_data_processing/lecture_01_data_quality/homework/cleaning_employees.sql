WITH ranked_employees AS (
    SELECT employee_id,
           first_name,
           last_name,
           birth_date,
           hire_date,
           ROW_NUMBER() OVER (
               PARTITION BY first_name, last_name, birth_date
               ORDER BY hire_date DESC
           ) AS rn
    FROM silver.silver_employees
)
DELETE FROM silver.silver_employees
WHERE (employee_id) IN (
    SELECT employee_id
    FROM ranked_employees
    WHERE rn > 1
);

delete from silver.silver_employees 
where employee_id is null;

delete from silver.silver_employees  
where employee_id not in (
	select distinct employee_id
	from silver.silver_sales 
);

INSERT INTO gold.dim_date (date_sk, full_date, day_of_week, week_num, month_num, month_name, quarter_num, year_num)
SELECT 
    TO_CHAR(dt, 'YYYYMMDD')::INTEGER AS date_sk,
    dt::DATE AS full_date,
    TO_CHAR(dt, 'Day') AS day_of_week,
    EXTRACT(WEEK FROM dt)::INTEGER AS week_num,
    EXTRACT(MONTH FROM dt)::INTEGER AS month_num,
    TO_CHAR(dt, 'Month') AS month_name,
    EXTRACT(QUARTER FROM dt)::INTEGER AS quarter_num,
    EXTRACT(YEAR FROM dt)::INTEGER AS year_num
FROM generate_series('2022-01-01'::DATE, '2023-12-31'::DATE, '1 day'::INTERVAL) AS dt
ON CONFLICT (date_sk) DO NOTHING;

INSERT INTO gold.dim_location (location_sk, country_name, city_name, zipcode)
SELECT 
    ROW_NUMBER() OVER (ORDER BY ci.city_id) AS location_sk,
    co.country_name,
    ci.city_name,
    ci.zipcode
FROM silver.silver_cities ci
LEFT JOIN silver.silver_countries co ON ci.country_id = co.country_id
ON CONFLICT (location_sk) DO NOTHING;

INSERT INTO gold.dim_category (category_sk, category_bk, category_name)
SELECT 
    ROW_NUMBER() OVER (ORDER BY category_id) AS category_sk,
    category_id AS category_bk,
    category_name
FROM silver.silver_categories
ON CONFLICT (category_sk) DO NOTHING;

INSERT INTO gold.dim_shop (shop_sk, shop_bk, address, location_sk)
SELECT 
    ROW_NUMBER() OVER (ORDER BY s.shop_id) AS shop_sk,
    s.shop_id AS shop_bk,
    s.address,
    l.location_sk
FROM silver.silver_shops s
LEFT JOIN silver.silver_cities ci ON s.city_id = ci.city_id
LEFT JOIN gold.dim_location l ON l.city_name = ci.city_name
ON CONFLICT (shop_sk) DO NOTHING;

INSERT INTO gold.dim_product (product_sk, product_bk, product_name, class, resistant, is_allergic, vitality_days, category_sk)
SELECT 
    ROW_NUMBER() OVER (ORDER BY p.product_id) AS product_sk,
    p.product_id AS product_bk,
    p.product_name,
    p.class,
    p.resistant,
    p.is_allergic,
    p.vitality_days,
    c.category_sk
FROM silver.silver_products p
LEFT JOIN silver.silver_categories sc ON p.category_id = sc.category_id
LEFT JOIN gold.dim_category c ON c.category_bk = sc.category_id
ON CONFLICT (product_sk) DO NOTHING;

INSERT INTO gold.dim_customer (customer_sk, customer_bk, first_name, last_name, full_name, city_name, address)
SELECT 
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_sk,
    customer_id AS customer_bk,
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) AS full_name,
    ci.city_name,
    address
FROM silver.silver_customers c
LEFT JOIN silver.silver_cities ci ON c.city_id = ci.city_id
ON CONFLICT (customer_sk) DO NOTHING;

INSERT INTO gold.dim_employee (employee_sk, employee_bk, first_name, last_name, gender, city_name, valid_from_dt, valid_to_dt, is_current)
SELECT 
    ROW_NUMBER() OVER (ORDER BY employee_id) AS employee_sk,
    employee_id AS employee_bk,
    first_name,
    last_name,
    gender,
    ci.city_name,
    '1900-01-01'::DATE AS valid_from_dt,
    NULL AS valid_to_dt,
    TRUE AS is_current
FROM silver.silver_employees e
LEFT JOIN silver.silver_cities ci ON e.city_id = ci.city_id
ON CONFLICT (employee_sk) DO NOTHING;

INSERT INTO gold.fact_sales (sales_id, product_sk, customer_sk, shop_sk, employee_sk, date_sk, quantity, total_price, discount_amount)
SELECT 
    s.sales_id,
    p.product_sk,
    c.customer_sk,
    sh.shop_sk,
    e.employee_sk,
    d.date_sk,
    s.quantity,
    s.total_price,
    s.discount
FROM silver.silver_sales s
LEFT JOIN gold.dim_product p ON p.product_bk = s.product_id
LEFT JOIN gold.dim_customer c ON c.customer_bk = s.customer_id
LEFT JOIN gold.dim_shop sh ON sh.shop_bk = s.shop_id
LEFT JOIN gold.dim_employee e ON e.employee_bk = s.employee_id AND e.is_current = TRUE
LEFT JOIN gold.dim_date d ON d.date_sk = TO_CHAR(s.sales_timestamp, 'YYYYMMDD')::INTEGER
ON CONFLICT (sales_id) DO NOTHING;

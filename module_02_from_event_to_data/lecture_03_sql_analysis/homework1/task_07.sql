SELECT 
    country_name,
    shop_id,
    shop_address,
    total_sales_count,
    total_sales_amount,
    SUM(total_sales_amount) OVER (PARTITION BY country_name) AS country_total_amount,
    (total_sales_amount / SUM(total_sales_amount) OVER (PARTITION BY country_name)) AS country_sales_share,
    DENSE_RANK() OVER (PARTITION BY country_name ORDER BY total_sales_amount DESC) AS place,
    SUM(total_sales_amount) OVER (
        PARTITION BY country_name
        ORDER BY total_sales_amount desc
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS country_running_total
FROM (
    SELECT 
        c.country_name,
        s.shop_id,
        s.address AS shop_address,
        COUNT(s2.sales_id) AS total_sales_count,
        SUM(s2.total_price) AS total_sales_amount
    FROM countries c
    INNER JOIN cities c2 ON c.country_id = c2.country_id 
    INNER JOIN shops s ON s.city_id = c2.city_id 
    INNER JOIN employees e ON e.shop_id = s.shop_id 
    INNER JOIN sales s2 ON s2.employee_id = e.employee_id 
    GROUP BY c.country_name, s.shop_id, s.address
) AS shop_data
ORDER BY country_name, country_sales_share desc
LIMIT 22;
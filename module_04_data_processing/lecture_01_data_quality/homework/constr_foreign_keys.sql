ALTER TABLE silver.silver_cities ADD CONSTRAINT silver_cities_silver_countries_fk FOREIGN KEY (country_id) REFERENCES silver.silver_countries(country_id);

ALTER TABLE silver.silver_products ADD CONSTRAINT silver_products_silver_categories_fk FOREIGN KEY (category_id) REFERENCES silver.silver_categories(category_id);

ALTER TABLE silver.silver_shops ADD CONSTRAINT silver_shops_silver_cities_fk FOREIGN KEY (city_id) REFERENCES silver.silver_cities(city_id);

ALTER TABLE silver.silver_employees ADD CONSTRAINT silver_employees_silver_cities_fk FOREIGN KEY (city_id) REFERENCES silver.silver_cities(city_id);
ALTER TABLE silver.silver_employees ADD CONSTRAINT silver_employees_silver_shops_fk FOREIGN KEY (shop_id) REFERENCES silver.silver_shops(shop_id);

ALTER TABLE silver.silver_customers ADD CONSTRAINT silver_customers_silver_cities_fk FOREIGN KEY (city_id) REFERENCES silver.silver_cities(city_id);

ALTER TABLE silver.silver_sales ADD CONSTRAINT silver_sales_silver_cities_fk FOREIGN KEY (city_id) REFERENCES silver.silver_cities(city_id);
ALTER TABLE silver.silver_sales ADD CONSTRAINT silver_sales_silver_customers_fk FOREIGN KEY (customer_id) REFERENCES silver.silver_customers(customer_id);
ALTER TABLE silver.silver_sales ADD CONSTRAINT silver_sales_silver_employees_fk FOREIGN KEY (employee_id) REFERENCES silver.silver_employees(employee_id);
ALTER TABLE silver.silver_sales ADD CONSTRAINT silver_sales_silver_products_fk FOREIGN KEY (product_id) REFERENCES silver.silver_products(product_id);
ALTER TABLE silver.silver_sales ADD CONSTRAINT silver_sales_silver_shops_fk FOREIGN KEY (shop_id) REFERENCES silver.silver_shops(shop_id);

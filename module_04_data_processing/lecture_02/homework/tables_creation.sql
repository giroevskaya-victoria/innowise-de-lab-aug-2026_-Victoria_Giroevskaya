CREATE TABLE gold.dim_date (
    date_sk      INTEGER PRIMARY KEY, -- YYYYMMDD
    full_date    DATE NOT NULL,
    day_of_week  VARCHAR(20),
    week_num     INTEGER,
    month_num    INTEGER,
    month_name   VARCHAR(20),
    quarter_num  INTEGER,
    year_num     INTEGER
);

CREATE TABLE gold.dim_product (
    product_sk       INTEGER PRIMARY KEY,
    product_bk       INTEGER NOT NULL, -- натуральный ключ
    product_name     VARCHAR(255),
    category_name    VARCHAR(100),
    class            VARCHAR(10),
    resistant        BOOLEAN,
    is_allergic      BOOLEAN,
    vitality_days    INTEGER
);

CREATE TABLE gold.dim_customer (
    customer_sk   INTEGER PRIMARY KEY,
    customer_bk   INTEGER NOT NULL,
    first_name    VARCHAR(100),
    last_name     VARCHAR(100),
    full_name     VARCHAR(255),
    city_name     VARCHAR(100),
    address       VARCHAR(255)
);

CREATE TABLE gold.dim_shop (
    shop_sk     INTEGER PRIMARY KEY,
    shop_bk     INTEGER NOT NULL,
    city_name   VARCHAR(100),
    address     VARCHAR(255)
);

CREATE TABLE gold.dim_employee (
    employee_sk    INTEGER PRIMARY KEY,
    employee_bk    INTEGER NOT NULL,
    first_name     VARCHAR(100),
    last_name      VARCHAR(100),
    gender         VARCHAR(10),
    city_name      VARCHAR(100),
    valid_from_dt  DATE NOT NULL,
    valid_to_dt    DATE,
    is_current     BOOLEAN DEFAULT TRUE
);

CREATE TABLE gold.dim_location (
    location_sk   INTEGER PRIMARY KEY,
    country_name  VARCHAR(100),
    city_name     VARCHAR(100),
    zipcode       VARCHAR(10)
);

CREATE TABLE gold.dim_category (
    category_sk   INTEGER PRIMARY KEY,
    category_bk   INTEGER NOT NULL,
    category_name VARCHAR(100)
);

CREATE TABLE gold.fact_sales (
    sales_id       INTEGER PRIMARY KEY,
    product_sk     INTEGER REFERENCES gold.dim_product(product_sk),
    customer_sk    INTEGER REFERENCES gold.dim_customer(customer_sk),
    shop_sk        INTEGER REFERENCES gold.dim_shop(shop_sk),
    employee_sk    INTEGER REFERENCES gold.dim_employee(employee_sk),
    date_sk        INTEGER REFERENCES gold.dim_date(date_sk),
    quantity       INTEGER NOT NULL,
    total_price    NUMERIC(10,2) NOT NULL,
    discount_amount NUMERIC(10,2) DEFAULT 0
);

CREATE INDEX idx_fact_sales_product   ON gold.fact_sales(product_sk);
CREATE INDEX idx_fact_sales_customer  ON gold.fact_sales(customer_sk);
CREATE INDEX idx_fact_sales_shop      ON gold.fact_sales(shop_sk);
CREATE INDEX idx_fact_sales_employee  ON gold.fact_sales(employee_sk);
CREATE INDEX idx_fact_sales_date      ON gold.fact_sales(date_sk);

ALTER TABLE gold.dim_shop 
ADD COLUMN location_sk INTEGER REFERENCES gold.dim_location(location_sk);

ALTER TABLE gold.dim_product 
ADD COLUMN category_sk INTEGER REFERENCES gold.dim_category(category_sk);


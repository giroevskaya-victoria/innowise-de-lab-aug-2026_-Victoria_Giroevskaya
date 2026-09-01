import pandas as p
import sqlalchemy as a
from sqlalchemy.exc import SQLAlchemyError


def load_from_csv_to_table(csv_file, table_obj, the_engine, chunk_size=5000):
    try:
        df = p.read_csv(csv_file, sep=';')
        df.columns = df.columns.str.lower()
        df.to_sql(
            name=table_obj.name,
            con=the_engine,
            schema='bronze',
            if_exists='append',
            index=False,
            chunksize=chunk_size
        )
        print(f"Загружено {len(df)} строк в {table_obj.name}")
    except SQLAlchemyError as el:
        print(f'Ошибка загрузки csv-файла в таблицу: {el}')


DB_URL = "postgresql://admin:admin0312@localhost:5432/postgres"

try:
    engine = a.create_engine(DB_URL,echo=False)
    with engine.connect() as conn:
        conn.execute(a.text("CREATE SCHEMA IF NOT EXISTS bronze"))
        conn.commit()
        print("Подключение и создание схемы успешно.")
except SQLAlchemyError as e:
    print(f"Ошибка подключения: {e}")
    exit(1)

metadata = a.MetaData(schema='bronze')

bronze_categories = a.Table(
    "bronze_categories", metadata,
    a.Column('category_id', a.Integer, primary_key=True),
    a.Column('category_name', a.String)
)

bronze_products = a.Table(
    'bronze_products', metadata,
    a.Column('product_id', a.Integer, primary_key=True),
    a.Column('product_name', a.String),
    a.Column('price', a.String),  # строка, чтобы сохранить 28.92 и т.д.
    a.Column('category_id', a.Integer, a.ForeignKey('bronze.bronze_categories.category_id')),
    a.Column('class', a.String),
    a.Column('modify_timestamp', a.String),  # дата как строка
    a.Column('resistant', a.String),
    a.Column('is_allergic', a.String),
    a.Column('vitality_days', a.String)
)

bronze_countries = a.Table(
    'bronze_countries', metadata,
    a.Column('country_id', a.Integer, primary_key=True),
    a.Column('country_name', a.String),
    a.Column('country_code', a.String)
)

bronze_cities = a.Table(
    'bronze_cities', metadata,
    a.Column('city_id', a.Integer, primary_key=True),
    a.Column('city_name', a.String),
    a.Column('zipcode', a.String),
    a.Column('country_id', a.Integer, a.ForeignKey('bronze.bronze_countries.country_id'))
)

bronze_shops = a.Table(
    'bronze_shops', metadata,
    a.Column('shop_id', a.Integer, primary_key=True),
    a.Column('city_id', a.Integer, a.ForeignKey('bronze.bronze_cities.city_id')),
    a.Column('address', a.String)
)

bronze_employees = a.Table(
    'bronze_employees', metadata,
    a.Column('employee_id', a.Integer, primary_key=True),
    a.Column('first_name', a.String),
    a.Column('middle_initial', a.String),
    a.Column('last_name', a.String),
    # битые даты, так что строка
    a.Column('birth_date', a.String),
    a.Column('gender', a.String),
    a.Column('city_id', a.Integer, a.ForeignKey('bronze.bronze_cities.city_id')),
    a.Column('shop_id', a.Integer, a.ForeignKey('bronze.bronze_shops.shop_id')),
    # битые даты, так что строка
    a.Column('hire_date', a.String)
)

bronze_customers = a.Table(
    'bronze_customers', metadata,
    a.Column('customer_id', a.Integer, primary_key=True),
    a.Column('first_name', a.String),
    a.Column('middle_initial', a.String),
    a.Column('last_name', a.String),
    a.Column('city_id', a.Integer, a.ForeignKey('bronze.bronze_cities.city_id')),
    a.Column('address', a.String)
)

bronze_sales = a.Table(
    'bronze_sales', metadata,
    a.Column('sales_id', a.Integer, primary_key=True),
    a.Column('employee_id', a.Integer, a.ForeignKey('bronze.bronze_employees.employee_id')),
    a.Column('customer_id', a.Integer,  a.ForeignKey('bronze.bronze_customers.customer_id')),
    a.Column('product_id', a.Integer, a.ForeignKey('bronze.bronze_products.product_id')),
    a.Column('quantity', a.Integer),
    a.Column('discount', a.String),
    a.Column('total_price', a.String),
    a.Column('sales_timestamp', a.String),
    a.Column('transaction_number', a.String)
)

try:
    metadata.create_all(engine)
    print('Таблицы созданы в БДшке')
except SQLAlchemyError as em:
    print(f'Ошибка создания таблиц: {em}')
    exit(1)

try:
    load_from_csv_to_table("source/countries.csv", bronze_countries, engine)
    load_from_csv_to_table("source/categories.csv", bronze_categories, engine)
    load_from_csv_to_table("source/cities.csv", bronze_cities, engine)
    load_from_csv_to_table("source/products.csv", bronze_products, engine)
    load_from_csv_to_table("source/shops.csv", bronze_shops, engine)
    load_from_csv_to_table("source/employees.csv", bronze_employees, engine)
    load_from_csv_to_table("source/customers.csv", bronze_customers, engine)
    load_from_csv_to_table("source/sales.csv", bronze_sales, engine, chunk_size=10000)
    print("Все данные успешно загружены!")
except Exception as ex:
    print(f"Процесс прерван из-за ошибки: {ex}")
    exit(1)

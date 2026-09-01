import pandas as pd
import sys
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from datetime import datetime

DB_URL = "postgresql://admin:admin0312@localhost:5432/postgres"

try:
    engine = create_engine(DB_URL, echo=False)
    with engine.connect() as conn:
        conn.execute(text("SELECT 1"))
    print("Подключение успешно")
except SQLAlchemyError as e:
    print(f"Ошибка подключения: {e}")
    sys.exit(1)


def validate_and_fix_date(date_series):
    def fix_single_date(val):
        if pd.isna(val):
            return pd.NaT
        for fmt in ('%Y-%m-%d', '%d.%m.%Y', '%m/%d/%Y', '%Y/%m/%d', '%d-%m-%Y'):
            try:
                dt = datetime.strptime(str(val), fmt)
                if dt.year < 1900 or dt.year > 2100:
                    return datetime(1900, 1, 1)
                return dt
            except ValueError:
                continue
        return datetime(1900, 1, 1)
    return date_series.apply(fix_single_date)


def load_employees_to_silver():
    df = pd.read_sql("SELECT * FROM bronze.bronze_employees", engine)
    df['birth_date'] = validate_and_fix_date(df['birth_date'])
    df['hire_date'] = validate_and_fix_date(df['hire_date'])
    df = df.dropna(subset=['birth_date', 'hire_date'])
    df.to_sql('silver_employees', engine, schema='silver', if_exists='append', index=False, chunksize=5000)
    print(f"Загружено {len(df)} сотрудников")


def load_sales_to_silver():
    df = pd.read_sql("SELECT * FROM bronze.bronze_sales", engine)

    # 1. Преобразуем строку в дату-время.
    # Если в строке было только "2025-11-24" (без времени),
    # Pandas сам автоматически поставит время 00:00:00.
    df['sales_timestamp'] = pd.to_datetime(df['sales_timestamp'], errors='coerce')

    # 2. Удаляем строки, где дата полностью отсутствовала (была битая или пустая).
    df = df.dropna(subset=['sales_timestamp'])

    # 3. Приводим числа.
    df['discount'] = pd.to_numeric(df['discount'], errors='coerce').fillna(0)
    df['total_price'] = pd.to_numeric(df['total_price'], errors='coerce').fillna(0)
    df['quantity'] = pd.to_numeric(df['quantity'], errors='coerce').fillna(0).astype(int)

    # 4. Загружаем.
    df.to_sql('silver_sales', engine, schema='silver', if_exists='append', index=False, chunksize=10000)
    print(f"Загружено {len(df)} продаж")


def load_products_to_silver():
    df = pd.read_sql("SELECT * FROM bronze.bronze_products", engine)
    df['price'] = pd.to_numeric(df['price'], errors='coerce').fillna(0)
    df['modify_timestamp'] = pd.to_datetime(df['modify_timestamp'], errors='coerce')
    df['resistant'] = df['resistant'].map({'Yes': True, 'No': False})
    df['is_allergic'] = df['is_allergic'].map({'Yes': True, 'No': False})
    df.to_sql('silver_products', engine, schema='silver', if_exists='append', index=False, chunksize=5000)
    print(f"Загружено {len(df)} товаров")


def load_countries_to_silver():
    df = pd.read_sql("SELECT * FROM bronze.bronze_countries", engine)
    df.to_sql('silver_countries', engine, schema='silver', if_exists='append', index=False)
    print(f"Загружено {len(df)} стран")


def load_cities_to_silver():
    df = pd.read_sql("SELECT * FROM bronze.bronze_cities", engine)
    df.to_sql('silver_cities', engine, schema='silver', if_exists='append', index=False)
    print(f"Загружено {len(df)} городов")


def load_categories_to_silver():
    df = pd.read_sql("SELECT * FROM bronze.bronze_categories", engine)
    df.to_sql('silver_categories', engine, schema='silver', if_exists='append', index=False)
    print(f"Загружено {len(df)} категорий")


def load_shops_to_silver():
    df = pd.read_sql("SELECT * FROM bronze.bronze_shops", engine)
    df.to_sql('silver_shops', engine, schema='silver', if_exists='append', index=False)
    print(f"Загружено {len(df)} магазинов")


def load_customers_to_silver():
    df = pd.read_sql("SELECT * FROM bronze.bronze_customers", engine)
    df.to_sql('silver_customers', engine, schema='silver', if_exists='append', index=False)
    print(f"Загружено {len(df)} клиентов")


try:
    load_countries_to_silver()
    load_categories_to_silver()
    load_cities_to_silver()
    load_products_to_silver()
    load_shops_to_silver()
    load_employees_to_silver()
    load_customers_to_silver()
    load_sales_to_silver()
    print("Все данные загружены в Silver")
except Exception as e:
    print(f"Ошибка: {e}")
    sys.exit(1)

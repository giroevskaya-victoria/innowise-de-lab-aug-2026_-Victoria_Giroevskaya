ALTER TABLE silver.silver_employees ADD CONSTRAINT silver_employees_check CHECK (hire_date > birth_date);

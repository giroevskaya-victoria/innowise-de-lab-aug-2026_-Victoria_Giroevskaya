create or replace function AvgSalesPerEmployee()
RETURNS float AS $$
DECLARE 
	avgperemp float;
BEGIN
	select (sum(total_price) / count(e.*)) into avgperemp
	from sales s inner join employees e on e.employee_id = s.employee_id;
	
    RETURN avgperemp; 
END;

$$ LANGUAGE plpgsql;

select s.transaction_number transaction, p.product_name product, s.total_price total_price, c.last_name customer_name, s.sales_timestamp
from sales s inner join products p on p.product_id = s.product_id inner join customers c on c.customer_id = s.customer_id 
where s.total_price > 1500 and p.class = 'A'
order by 1
limit 10;
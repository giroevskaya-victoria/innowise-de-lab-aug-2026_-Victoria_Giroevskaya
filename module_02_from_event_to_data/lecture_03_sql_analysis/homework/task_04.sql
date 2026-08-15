select p.product_name product, SUM(s.total_price) sum_price, AVG(s.total_price)
from sales s inner join products p on p.product_id = s.product_id 
group by 1
having SUM(s.total_price) > 400000
order by 2 desc
limit 10;
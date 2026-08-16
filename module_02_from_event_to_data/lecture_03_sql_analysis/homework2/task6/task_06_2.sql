update products
set
	class = 'A'
where
	category_id in (
		select category_id 
		from sales s inner join products p on s.product_id = p.product_id
		group by 1
		having sum(total_price) > 5000
	);
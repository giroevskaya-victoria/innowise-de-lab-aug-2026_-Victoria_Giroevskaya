update products
set price = price * 1.1
where category_id = (
	select category_id
	from categories
	where category_name = 'Fruits'
);
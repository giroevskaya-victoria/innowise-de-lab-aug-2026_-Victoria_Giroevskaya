update products
set modify_timestamp = NOW()
where modify_timestamp is null;
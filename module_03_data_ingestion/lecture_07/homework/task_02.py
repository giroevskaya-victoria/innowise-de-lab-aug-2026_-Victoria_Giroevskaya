product = {"id": 105, "name": "Organic Buckwheat", "price": 3.50, "stock": 100}

product["price"] = 4.20
product["category"] = "Grains"

discount_rate = product.get("discount", 0)

print(f"Product: {product}")
print(f"Discount rate: {discount_rate}")

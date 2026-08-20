suppliers_log = [
    "FreshFarm Inc",
    "AgroWorld Co",
    "FreshFarm Inc",
    "GreenFields Ltd"
]
unique_suppliers = set(suppliers_log)
unique_suppliers.add("GreenFields Ltd")

if "FreshFarm Inc" in unique_suppliers:
    print("FreshFarm Inc is with us!:)")

print(f"Suppliers: {unique_suppliers}")
print(f"The amount of suppliers: {len(unique_suppliers)}")

import json

api_response_json = """ 
{ 
    "store": "StoreHub", 
    "orders": [ 
        {"id": 1, "total": 50}, 
        {"id": 2, "total": 200}, 
        {"id": 3, "total": 150} 
    ]
} 
"""

resp_dict = json.loads(api_response_json)
print(f"{resp_dict}\n")

orders = resp_dict["orders"]
print(f"{orders}\n")

high_value_orders = [value for value in orders if value["total"] > 100]
print(f"{high_value_orders}\n")

resp_dict["high_value_orders"] = high_value_orders

final_json = json.dumps(resp_dict)
print(final_json)

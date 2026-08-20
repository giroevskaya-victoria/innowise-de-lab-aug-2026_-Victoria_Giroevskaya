def audit_logger(func):
    def wrapper(*args, **kwargs):
        print("[AUDIT] Запуск анализа....")
        result = func(*args, **kwargs)
        print("[AUDIT] Анализ завершен...")
        return result
    return wrapper


@audit_logger
def get_sorted_report(bran):
   return sorted(bran, key=lambda item: item["revenue"], reverse=True)


branches = [
    {"city": "Minsk", "revenue": 15000},
    {"city": "Warsaw", "revenue": 32000},
    {"city": "London", "revenue": 12000}
]

print(get_sorted_report(branches))

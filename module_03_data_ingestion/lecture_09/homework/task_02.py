from typing import Optional


def calculate_total_delivery_cost(product_name: str, weights: list|tuple, prices: list | tuple, discount: Optional[float], currency_rate: int | float = 0.0, *extra_costs):
    if len(weights) == len(prices):
        total_sum: int = 0
        for i in range(len(weights)):
            total_sum += weights[i] * prices[i]

        discount_sum: float = total_sum
        if discount is not None:
            discount_sum = total_sum * (1 - discount)

        extra = sum(extra_costs)
        extra_sum: float = discount_sum + extra

        final_sum: float = extra_sum * currency_rate

        res_dict = {product_name: final_sum}
        return res_dict
    else:
        print("sorry prices and weights must be even")


vegetables = calculate_total_delivery_cost("Овощная партия", [100, 50], [4, 6], 0.1, 1, 20, 15)
print(f"Товар: Овощная партия, итоговая стоимость: {vegetables["Овощная партия"]}")

fruits = calculate_total_delivery_cost("Фруктовая партия", (30, 20, 10), (15, 12, 18), None, 1.2, 25)
print(f"Товар: Фруктовая партия, итоговая стоимость: {fruits["Фруктовая партия"]}")

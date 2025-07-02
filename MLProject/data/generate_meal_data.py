import random
import csv
import uuid
from datetime import datetime, timedelta

meal_options = {
    "Indian": ["Chana Masala", "Paneer Tikka", "Masala Dosa", "Biryani", "Dal Makhani"],
    "American": ["Cheeseburger", "Grilled Chicken Salad", "Mac and Cheese", "BBQ Ribs", "Pancakes"],
    "British": ["Fish and Chips", "Shepherd's Pie", "Full English Breakfast", "Bangers and Mash", "Roast Beef"],
    "Chinese": ["Kung Pao Chicken", "Sweet and Sour Pork", "Fried Rice", "Spring Rolls", "Mapo Tofu"],
    "Mexican": ["Tacos", "Burrito Bowl", "Enchiladas", "Quesadillas", "Chilaquiles"]
}

backgrounds = list(meal_options.keys())
times_of_day = ["Morning", "Noon", "Evening", "Night"]
health_levels = ["Low", "Medium", "High"]

rows = []
for _ in range(100_000):
    background = random.choice(backgrounds)
    meal = random.choice(meal_options[background])
    time_of_day = random.choice(times_of_day)
    family_size = random.choices([1, 2, 3, 4, 5, 6], weights=[0.3, 0.25, 0.2, 0.15, 0.07, 0.03])[0]
    health = random.choice(health_levels)
    record = {
        "id": str(uuid.uuid4()),
        "background": background,
        "meal": meal,
        "time_of_day": time_of_day,
        "family_size": family_size,
        "health_consciousness": health,
        "created_at": (datetime.now() - timedelta(days=random.randint(0, 365))).strftime("%Y-%m-%d")
    }
    rows.append(record)

with open("data/meal_data.csv", "w", newline="") as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=rows[0].keys())
    writer.writeheader()
    writer.writerows(rows)

print("Generated 100,000 meal records in data/meal_data.csv")

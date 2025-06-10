from supabase import create_client, Client
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

url: str = os.environ.get("SUPABASE_URL")
key: str = os.environ.get("SUPABASE_ANON_KEY")

if not url or not key:
    raise ValueError("Supabase URL or Key not found in environment variables. Make sure they are in your .env file.")

supabase: Client = create_client(url, key)

sample_produce_data = [
    {
        "name": "Organic Apples",
        "description": "Crisp and juicy organic apples, perfect for snacking or baking.",
        "category": "Fruits",
        "price": 2.99,
        "weight_kg": 5.0,
    },
    {
        "name": "Heirloom Tomatoes",
        "description": "Freshly picked heirloom tomatoes, ideal for salads and sauces.",
        "category": "Vegetables",
        "price": 3.50,
        "weight_kg": 3.0,
    },
    {
        "name": "Sweet Corn",
        "description": "Locally grown sweet corn, excellent for grilling or boiling.",
        "category": "Vegetables",
        "price": 1.20,
        "weight_kg": 2.5,
    },
    {
        "name": "Whole Wheat Grain",
        "description": "High-quality whole wheat grain, great for baking bread or cooking.",
        "category": "Grains",
        "price": 1.80,
        "weight_kg": 10.0,
    },
    {
        "name": "Fresh Strawberries",
        "description": "Sweet and ripe strawberries, hand-picked daily.",
        "category": "Fruits",
        "price": 4.50,
        "weight_kg": 1.5,
    },
    {
        "name": "Potatoes",
        "description": "Versatile potatoes, suitable for various dishes.",
        "category": "Vegetables",
        "price": 1.00,
        "weight_kg": 7.0,
    },
]

async def insert_sample_data():
    print("Attempting to insert sample produce data...")
    for item in sample_produce_data:
        try:
            response = supabase.table("public.products").insert(item).execute()
            # Supabase Python client's .execute() returns a PostgrestResponse object
            # We can check response.data for the inserted row or response.count for row count
            if response.data:
                print(f"Successfully inserted: {item['name']}")
            else:
                print(f"Failed to insert {item['name']}: No data returned, check response.error")
                print(f"Error details: {response.error}")
        except Exception as e:
            print(f"An error occurred while inserting {item['name']}: {e}")
            if hasattr(e, 'response') and hasattr(e.response, 'text'):
                print(f"Raw response from Supabase: {e.response.text}")

if __name__ == "__main__":
    import asyncio
    asyncio.run(insert_sample_data()) 
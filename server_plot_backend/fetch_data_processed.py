import json
import numpy as np
import matplotlib.pyplot as plt
import requests

url = "https://sonodirect.my.id/esp32_1_web.php"

try:
    response = requests.get(url)
    if response.status_code == 200:
        parsed_data = response.json()  # Directly use the parsed JSON
        print("Data received successfully")
    else:
        print("Failed to fetch data. Status code:", response.status_code)
except Exception as e:
    print("Error:", e)
    parsed_data = []  # Default to an empty list in case of error

# Initialize lists to store data

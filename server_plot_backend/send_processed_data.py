import csv
import json
import requests

# Path to your CSV file
csv_file_path = r"C:\Users\Acer\Documents\Flutter\server_plot_backend\full_features_data.csv"
# URL of the PHP endpoint
url = "https://sonodirect.my.id/test_processed_data.php"

# API Key for authentication
api_key = "tPmAT5Ab3j7F9"

# Read the CSV data
with open(csv_file_path, mode='r') as file:
    csv_reader = csv.DictReader(file)
    
    # Prepare the data to be sent (convert rows into list of dictionaries)
    data = []
    for row in csv_reader:
        # Convert numeric columns to float, if necessary (e.g., 'Sensor1_CrestFactor' should be a float)
        for key, value in row.items():
            try:
                row[key] = float(value)
            except ValueError:
                pass  # Leave non-numeric values as strings
        
        # Append the row to data list
        data.append(row)

# Package the data into the format your PHP script expects
payload = {
    'api_key': api_key,
    'data': data  # The data you read from the CSV file
}

# Send the POST request with the data
response = requests.post(url, json=payload)

# Check the response from the PHP server
if response.status_code == 200:
    print("Data successfully sent to the PHP server.")
    print("Server response:", response.text)
else:
    print(f"Failed to send data. Status code: {response.status_code}")
    print("Error response:", response.text)

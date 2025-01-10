import requests
import json
import csv

# Define the base URL of the API endpoint
url = "https://sonodirect.my.id/get_data_esp32.php"

# List of ESP types to loop through
esp_types = ['esp1', 'esp2', 'esp3', 'esp4']

# Loop through each ESP type
for esp_type in esp_types:
    # Set the 'type' parameter for each ESP type
    params = {'type': esp_type}

    # Send GET request to the PHP API
    response = requests.get(url, params=params)

    # Check if the request was successful
    if response.status_code == 200:
        try:
            # Parse the JSON response
            data = response.json()

            # Ensure we get data and it's a list
            if isinstance(data, list):
                # Print the fetched data to the console
                print(f"Fetched data for {esp_type}:")
                print(json.dumps(data, indent=4))  # Pretty print the JSON data

                # Use the esp_type to customize the file names
                json_filename = f"data_{esp_type}.json"
                csv_filename = f"data_{esp_type}.csv"
                
                # Save the data into a JSON file
                with open(json_filename, 'w') as json_file:
                    json.dump(data, json_file, indent=4)  # Write JSON data to a file
                print(f"Data for {esp_type} saved to {json_filename}")

                # Save the data into a CSV file
                with open(csv_filename, mode='w', newline='') as csv_file:
                    # Define CSV fieldnames based on the keys in the JSON
                    fieldnames = ['id', 'amplitude', 'mean_magnitude', 'timestamp', 'magnitudes']
                    writer = csv.DictWriter(csv_file, fieldnames=fieldnames)

                    writer.writeheader()  # Write the header row

                    for row in data:
                        # Convert the 'magnitudes' string into a proper list for CSV saving
                        if row.get('magnitudes'):
                            try:
                                row['magnitudes'] = json.loads(row['magnitudes'])  # Convert string to list
                            except json.JSONDecodeError:
                                row['magnitudes'] = []  # In case of malformed magnitudes string
                        
                        writer.writerow(row)  # Write each row to the CSV
                print(f"Data for {esp_type} saved to {csv_filename}")

            else:
                print(f"Error: Data for {esp_type} is not in expected list format.")
        
        except json.JSONDecodeError:
            print(f"Error: Failed to decode JSON from response for {esp_type}.")
    else:
        print(f"Error: Failed to fetch data for {esp_type}. Status code: {response.status_code}")

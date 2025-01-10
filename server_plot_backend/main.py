from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from typing import Dict, List
# import mysql.connector
import random
import uvicorn
import pandas as pd

app = FastAPI()

# Add CORS middleware to allow requests from any origin
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# MySQL database configuration
db_config = {
    'user': 'sonz2934_username',
    'password': 'YD}7~Gz{u#h-',
    'host': '103.247.10.175',  # or the IP address of the database server
    'database': 'sonz2934_esp32'
}

# Function to connect to MySQL and fetch sound metrics data
def fetch_data_from_mysql(query: str):
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor(dictionary=True)
        cursor.execute(query)
        result = cursor.fetchall()
        return result
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

# Endpoint to fetch data from MySQL
@app.get("/fetch-sound-metrics-mysql")
async def fetch_sound_metrics_mysql():
    query = "SELECT * FROM sound_metrics_table"  # Adjust this query based on your table structure
    data = fetch_data_from_mysql(query)
    if data is not None:
        return {"status": "success", "data": data}
    else:
        return {"status": "error", "message": "Failed to fetch data from MySQL"}

# Function to generate random data for multiple devices
def generate_random_data(length: int) -> Dict[str, List[float]]:
    return {f"Device_{i+1}": [random.uniform(0, 1000) for _ in range(length)] for i in range(4)}

# Function to generate degree recommendation and sound score
def generate_recommendation():
    degree = random.randint(-90, 90)  # Random degree between -90 and 90
    sound_score = random.randint(0, 100)  # Random sound score between 0 and 100
    return {"degree": degree, "score": sound_score}

# Function to generate a 15x11 heatmap matrix
def generate_heatmap_matrix() -> List[List[float]]:
    return [[round(random.uniform(0, 1), 2) for _ in range(15)] for _ in range(11)]

@app.get("/get_spl_data")
async def get_spl_data():
    return {
        "type": "SPL",
        "data": generate_random_data(13)
    }

@app.get("/get_sf_data")
async def get_sf_data():
    return {
        "type": "SF",
        "data": generate_random_data(13)
    }

@app.get("/get_thd_data")
async def get_thd_data():
    return {
        "type": "THD",
        "data": generate_random_data(13)
    }

@app.get("/get_snr_data")
async def get_snr_data():
    return {
        "type": "SNR",
        "data": generate_random_data(13)
    }

# Endpoint for degree recommendation
@app.get("/recommendation")
async def get_recommendation():
    return generate_recommendation()

# Endpoint for the heatmap data
@app.get("/heatmap")
async def get_heatmap():
    return {"heatmap": generate_heatmap_matrix()}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
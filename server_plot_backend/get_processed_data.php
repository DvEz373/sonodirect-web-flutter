<?php

// Add CORS headers at the top of your PHP file
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Database connection
$servername = "localhost";
$username = "sonz2934_username";
$password = "YD}7~Gz{u#h-";
$dbname = "sonz2934_esp32";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the type of data requested from the URL or query parameter
$dataType = isset($_GET['type']) ? $_GET['type'] : ''; // Example: ?type=SNR

// SQL query to get the required fields based on the requested type
switch ($dataType) {
    case 'SNR':
        $sql = "SELECT Angle, Sensor1_SNR, Sensor2_SNR, Sensor3_SNR, Sensor4_SNR FROM sensor_data";
        break;
    case 'SPL':
        $sql = "SELECT Angle, Sensor1_SPL, Sensor2_SPL, Sensor3_SPL, Sensor4_SPL FROM sensor_data";
        break;
    case 'THD':
        $sql = "SELECT Angle, Sensor1_THD, Sensor2_THD, Sensor3_THD, Sensor4_THD FROM sensor_data";
        break;
    case 'SpectralFlatness':
        $sql = "SELECT Angle, Sensor1_SpectralFlatness, Sensor2_SpectralFlatness, Sensor3_SpectralFlatness, Sensor4_SpectralFlatness FROM sensor_data";
        break;
    case 'Angle':
        // Return only the Angle data (same format as the other types)
        $sql = "SELECT Angle FROM sensor_data";
        break;
    case 'optimal_angle': // New case for optimal_angle request
        // Query to get Simulated Annealing value
        $sql = "SELECT Simulated_Annealing FROM optimal_angle LIMIT 1"; 
        break;
    default:
        echo json_encode(['error' => 'Invalid data type']);
        exit();
}

$result = $conn->query($sql);

// Prepare data array
$data = array();
$devices = array('Device_1', 'Device_2', 'Device_3', 'Device_4');

// Initialize the Angle data as an empty array
$angleData = array();

// Fetch data and filter based on angle step (every 15 degrees)
if ($dataType != 'optimal_angle' && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        // Check if the Angle is a multiple of 15
        if ($row['Angle'] % 15 == 0) {
            // If we are fetching angle data
            if ($dataType == 'Angle') {
                // Store the angle value for all devices
                $angleData[] = (int)$row['Angle'];
            } else {
                // Add data for each device (sensor values) for other types
                foreach ($devices as $index => $device) {
                    $sensorColumn = "Sensor" . ($index + 1) . "_{$dataType}";
                    $data[$device][] = (float)$row[$sensorColumn];
                }
            }
        }
    }
}

// If the data type is Angle, assign the angle data to all devices
if ($dataType == 'Angle') {
    foreach ($devices as $device) {
        $data[$device] = $angleData;
    }
}

// If the data type is optimal_angle, fetch the value from the optimal_angle table
if ($dataType == 'optimal_angle' && $result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $data = array(
        'Simulated_Annealing' => (float)$row['Simulated_Annealing']
    );
}

// Send response in the desired format
$response = array(
    'type' => $dataType,
    'data' => $data
);

echo json_encode($response);

$conn->close();
?>

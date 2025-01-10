<?php
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

// SQL query to fetch data for SNR, SPL, THD, and SpectralFlatness for sensors 1-4
$sql = "
    SELECT 
        Sensor1_SNR, Sensor1_SPL, Sensor1_THD, Sensor1_SpectralFlatness,
        Sensor2_SNR, Sensor2_SPL, Sensor2_THD, Sensor2_SpectralFlatness,
        Sensor3_SNR, Sensor3_SPL, Sensor3_THD, Sensor3_SpectralFlatness,
        Sensor4_SNR, Sensor4_SPL, Sensor4_THD, Sensor4_SpectralFlatness
    FROM sensor_data
";

$result = $conn->query($sql);

$data = array();

if ($result->num_rows > 0) {
    // Fetch each row as an associative array
    while($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
}

// Send data as JSON
header('Content-Type: application/json');
echo json_encode($data);

$conn->close();
?>
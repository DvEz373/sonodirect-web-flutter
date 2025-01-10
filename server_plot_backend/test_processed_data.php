<?php
// Database connection details
$servername = "localhost";
$username = "sonz2934_username";
$password = "YD}7~Gz{u#h-";
$dbname = "sonz2934_esp32";

// Check if the request is POST and contains JSON data
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get the raw POST data (JSON)
    $json_data = file_get_contents("php://input");

    // Log the received raw data for debugging
    error_log("Received JSON: " . $json_data);

    // Check if data was received
    if ($json_data) {
        // Decode the JSON into a PHP array
        $data = json_decode($json_data, true);

        // Log the decoded data
        error_log("Decoded Data: " . print_r($data, true));

        // Check if data is an array of rows and API key is correct
        if ($data && isset($data['api_key']) && $data['api_key'] == "tPmAT5Ab3j7F9") {
            // Create connection
            $conn = new mysqli($servername, $username, $password, $dbname);

            // Check connection
            if ($conn->connect_error) {
                error_log("Connection failed: " . $conn->connect_error);
                die("Connection failed: " . $conn->connect_error);
            }

            // Prepare the SQL insert statement for sensor_data with 51 placeholders
            $stmt = $conn->prepare("
                INSERT INTO sensor_data (
                    Angle, Sensor1_CrestFactor, Sensor1_DominantFreq, Sensor1_DynamicRange,
                    Sensor1_Kurtosis, Sensor1_Mean, Sensor1_SNR, Sensor1_SPL, Sensor1_Skewness,
                    Sensor1_SpectralFlatness, Sensor1_StdDev, Sensor1_THD, Sensor1_Variance,
                    Sensor2_CrestFactor, Sensor2_DominantFreq, Sensor2_DynamicRange, Sensor2_Kurtosis,
                    Sensor2_Mean, Sensor2_SNR, Sensor2_SPL, Sensor2_Skewness, Sensor2_SpectralFlatness,
                    Sensor2_StdDev, Sensor2_THD, Sensor2_Variance, Sensor3_CrestFactor,
                    Sensor3_DominantFreq, Sensor3_DynamicRange, Sensor3_Kurtosis, Sensor3_Mean,
                    Sensor3_SNR, Sensor3_SPL, Sensor3_Skewness, Sensor3_SpectralFlatness, Sensor3_StdDev,
                    Sensor3_THD, Sensor3_Variance, Sensor4_CrestFactor, Sensor4_DominantFreq,
                    Sensor4_DynamicRange, Sensor4_Kurtosis, Sensor4_Mean, Sensor4_SNR, Sensor4_SPL,
                    Sensor4_Skewness, Sensor4_SpectralFlatness, Sensor4_StdDev, Sensor4_THD,
                    Sensor4_Variance, equality_sound, score_sound
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ");

            // Check if the statement preparation was successful
            if ($stmt === false) {
                error_log("Error preparing SQL: " . $conn->error);
                die("Error preparing SQL: " . $conn->error);
            }

            // Loop through each row of sensor data and insert into the database
            foreach ($data['data'] as $row) {
                // Log the row data for debugging
                error_log("Row data: " . print_r($row, true));

                // Ensure that the row has exactly 51 elements
                if (count($row) !== 51) {
                    error_log("Row data count does not match 51 columns: " . print_r($row, true));
                    continue; // Skip this row if it doesn't match
                }

                // Dynamically bind parameters to the prepared statement
                $types = str_repeat('d', 51);  // Create a string of 51 'd' characters
                $values = array_values($row); // Get the row values as an array

                // Bind parameters dynamically using call_user_func_array
                $stmt->bind_param($types, ...$values);

                // Execute the prepared statement
                if (!$stmt->execute()) {
                    error_log("Error executing SQL: " . $stmt->error);
                }
            }

            // Insert optimal angle data into a separate table
            if (isset($data['optimal_angle'])) {
                $stmt_optimal = $conn->prepare("
                    INSERT INTO optimal_angle (
                        Particle_Swarm_Optimization, Genetic_Algorithm, L_BFGS_B, Heuristic_DataFrame,
                        Simulated_Annealing, Differential_Evolution, Bayesian_Optimization, COBYLA, Nealder_Mead,
                        Basinhopping_local_L_BFGS_B, Gradient_Descent_CG, TNC, Powell, SLSQP, Conjugate_Gradient,
                        Newton_Method
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ");

                // Check if the statement preparation was successful
                if ($stmt_optimal === false) {
                    error_log("Error preparing SQL for optimal_angle: " . $conn->error);
                    die("Error preparing SQL: " . $conn->error);
                }

                // Extract the optimal angle data and bind parameters
                $optimal_values = array_values($data['optimal_angle']);
                $stmt_optimal->bind_param(str_repeat('d', count($optimal_values)), ...$optimal_values);

                // Execute the prepared statement for optimal angle
                if (!$stmt_optimal->execute()) {
                    error_log("Error executing SQL for optimal_angle: " . $stmt_optimal->error);
                }

                // Close the optimal angle statement
                $stmt_optimal->close();
            }

            // Close the sensor data statement and connection
            $stmt->close();
            $conn->close();

            echo "Data successfully uploaded to the database.";
        } else {
            echo "Invalid API Key or Invalid Data Format.";
        }
    } else {
        echo "No data received.";
    }
} else {
    echo "No data posted.";
}
?>

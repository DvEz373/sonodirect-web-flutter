import numpy as np
import pandas as pd

# Parameters
Fs = 44100  # Sampling frequency (Hz)
duration = 5  # Duration in seconds
t = np.linspace(0, duration, int(Fs * duration))  # Time vector

# Speaker position
x_s, y_s = 0, 0

# Sensor positions
sensors = {
    "Sensor1": (-3, 0),
    "Sensor2": (-3, 8),
    "Sensor3": (3, 8),
    "Sensor4": (3, 0)
}

# Speech Signal Parameters
A_base = 0.5  # Base amplitude of the speech signal
m = 0.3  # Modulation index
f_m = 2  # Modulation frequency (Hz)
f_speech = 300  # Fundamental frequency of speech (Hz)

# Pink Noise Parameters
M = 10  # Number of pink noise components
frequencies = np.logspace(np.log10(20), np.log10(20000), M)  # Log-spaced frequencies

# Multipath Parameters: [(delay in seconds, attenuation factor), ...]
multipath_params = [
    (0.01, 0.6),  # 10 ms delay, 60% amplitude
    (0.02, 0.3),  # 20 ms delay, 30% amplitude
    (0.05, 0.1)   # 50 ms delay, 10% amplitude
]

# Function to generate pink noise
def generate_pink_noise(size):
    num_rows = 16
    array = np.random.randn(num_rows, size // num_rows)
    pink = np.cumsum(array, axis=0)
    pink = pink[-1]  # Take the last row
    pink -= np.mean(pink)
    pink /= np.max(np.abs(pink))  # Normalize to [-1, 1]
    return pink[:size]

# Function to apply multipath effects
def apply_multipath_effects(signal, Fs, multipath_params):
    output_signal = np.zeros_like(signal)
    for delay, attenuation in multipath_params:
        delay_samples = int(delay * Fs)
        delayed_signal = np.pad(signal, (delay_samples, 0), mode='constant')[:len(signal)]
        output_signal += attenuation * delayed_signal
    return output_signal

# Placeholder for data
data = []

# Simulate for angles -90 to +90 degrees in steps of 10 degrees
angles = range(-90, 91, 30)
for angle_deg in angles:
    # Convert angle to radians
    theta_s = np.radians(angle_deg)
    
    for sensor_name, (x_r, y_r) in sensors.items():
        # Calculate distance and angle for the current sensor
        d = np.sqrt((x_r - x_s)**2 + (y_r - y_s)**2)
        theta = np.arctan2(y_r - y_s, x_r - x_s) - theta_s
        gain = np.cos(theta)  # Directional gain

        # Random phase for speech signal
        phi = np.random.uniform(0, 2 * np.pi)

        # Compute the amplitude envelope of the speech signal
        A_speech = A_base * (1 + m * np.sin(2 * np.pi * f_m * t))

        # Compute the speech signal
        S_speech = A_speech * np.sin(2 * np.pi * f_speech * t + phi)

        # Attenuate speech signal with distance and directional gain
        attenuated_speech = (gain / d) * S_speech

        # Apply multipath effects
        attenuated_speech = apply_multipath_effects(attenuated_speech, Fs, multipath_params)

        # Generate pink noise
        phi_k = np.random.uniform(0, 2 * np.pi, M)  # Random phases for pink noise components
        pink_noise = np.zeros_like(t)
        for k, f_k in enumerate(frequencies):
            pink_noise += (1 / f_k) * np.sin(2 * np.pi * f_k * t + phi_k[k])
        pink_noise = 0.2 * pink_noise / np.max(np.abs(pink_noise))  # Scale pink noise

        # Combine attenuated speech signal and pink noise
        scaling_factor = 3000  # Amplify overall signal
        S_total = (attenuated_speech + 0.1 * pink_noise) * scaling_factor

        # Store data with corresponding angle and sensor name
        for amplitude in S_total:
            data.append({'Amplitude': amplitude, 'Angle': angle_deg, 'Sensor': sensor_name})

# Save data to CSV
df = pd.DataFrame(data)
df.to_csv("multi_sensor_simulated_sound_data.csv", index=False)

print("Simulation data saved to 'multi_sensor_simulated_sound_data.csv'.")

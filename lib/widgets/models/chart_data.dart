// lib/models/chart_data.dart

class ChartData {
  final Map<String, List<double>> deviceData;

  ChartData({required this.deviceData});

  // Factory constructor to create a ChartData object from JSON data
  factory ChartData.fromJson(Map<String, dynamic> json) {
    // Access the 'data' field directly to get device data
    final data = json['data'] as Map<String, dynamic>;
    return ChartData(
      deviceData: data.map((key, value) => MapEntry(key, List<double>.from(value))),
    );
  }
}
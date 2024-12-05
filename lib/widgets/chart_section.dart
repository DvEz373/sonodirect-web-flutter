import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/chart_data.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartSection extends StatelessWidget {
  final String title;
  final String chartType;
  final double height;

  const ChartSection({
    super.key,
    required this.title,
    required this.chartType,
    this.height = 350,
  });

  Future<ChartData> fetchChartData() async {
    String endpoint;
    switch (chartType) {
      case 'SPL':
        endpoint = 'SPL'; // https://sonodirect.my.id/get_spl_data.php
        break;
      case 'SpectralFlatness':
        endpoint = 'SpectralFlatness'; // https://sonodirect.my.id/get_sf_data.php
        break;
      case 'THD':
        endpoint = 'THD'; // https://sonodirect.my.id/get_thd_data.php
        break;
      case 'SNR':
        endpoint = 'SNR'; // https://sonodirect.my.id/get_snr_data.php
        break;
      default:
        throw Exception('Unknown chart type: $chartType');
    }

    final url = 'https://sonodirect.my.id/get_processed_data.php?type=$endpoint'; // https://sonodirect.my.id/<script_name>.php
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Response data for $chartType: ${response.body}");
      return ChartData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load chart data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1100) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(child: _buildChartCard('Device_1', 'Sensor 1')),
                  Flexible(child: _buildChartCard('Device_2', 'Sensor 2')),
                  Flexible(child: _buildChartCard('Device_3', 'Sensor 3')),
                  Flexible(child: _buildChartCard('Device_4', 'Sensor 4')),
                ],
              );
            } else if (constraints.maxWidth > 700) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(child: _buildChartCard('Device_1', 'Sensor 1')),
                      Flexible(child: _buildChartCard('Device_2', 'Sensor 2')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(child: _buildChartCard('Device_3', 'Sensor 3')),
                      Flexible(child: _buildChartCard('Device_4', 'Sensor 4')),
                    ],
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildChartCard('Device_1', 'Sensor 1'),
                  _buildChartCard('Device_2', 'Sensor 2'),
                  _buildChartCard('Device_3', 'Sensor 3'),
                  _buildChartCard('Device_4', 'Sensor 4'),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildChartCard(String deviceName, String sensorTitle) {
    return FutureBuilder<ChartData>(
      future: fetchChartData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData) {
          final chartData = snapshot.data!;
          final dataPoints = _getDataPointsForDevice(chartData, deviceName);
          return Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 300),
            margin: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    sensorTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: BarChartWidget(dataPoints: dataPoints),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
      },
    );
  }

  List<double> _getDataPointsForDevice(ChartData data, String deviceName) {
    return data.deviceData[deviceName] ?? [];
  }
}

class BarChartWidget extends StatelessWidget {
  final List<double> dataPoints;

  const BarChartWidget({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    // Calculate minY and maxY for dynamic scaling
    double minY = dataPoints.isNotEmpty
        ? dataPoints.reduce((a, b) => a < b ? a : b) - 5
        : 0;
    double maxY = dataPoints.isNotEmpty
        ? dataPoints.reduce((a, b) => a > b ? a : b) + 5
        : 10;

    return BarChart(
      BarChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (maxY - minY) / 5,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                );
              },
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: dataPoints.length / 5 > 0 ? (dataPoints.length / 5) : 1,
              getTitlesWidget: (value, meta) {
                int angle = -90 + (15 * value.toInt());
                return Text(
                  '$angle°',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[700]!, width: 1),
        ),
        barGroups: dataPoints
            .asMap()
            .entries
            .map(
              (entry) => BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value,
                    color: Colors.lightBlueAccent,
                    width: 12,
                  ),
                ],
              ),
            )
            .toList(),
        // Optionally, you can set the minY and maxY
        minY: 0,
        maxY: maxY,
      ),
    );
  }
}

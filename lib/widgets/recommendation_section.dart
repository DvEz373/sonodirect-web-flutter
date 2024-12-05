import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Icon package
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendationSection extends StatefulWidget {
  const RecommendationSection({super.key});

  @override
  _RecommendationSectionState createState() => _RecommendationSectionState();
}

class _RecommendationSectionState extends State<RecommendationSection> {
  String angleValue = 'Loading...';
  bool isLoading = true; // Loading state
  bool isError = false; // Error state

  @override
  void initState() {
    super.initState();
    fetchRecommendationData();
  }

  Future<void> fetchRecommendationData() async {
    try {
      final response = await http.get(Uri.parse('https://sonodirect.my.id/get_processed_data.php?type=optimal_angle'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is Map<String, dynamic>) {
          final angle = data['data'].values.first; // Get the first value in the data map
          setState(() {
            angleValue = '${angle.toStringAsFixed(3)}°'; // Format the angle to 3 decimal places
            isLoading = false;
          });
        } else {
          throw Exception("Invalid data format");
        }
      } else {
        setState(() {
          isError = true;
          angleValue = 'Error fetching data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isError = true;
        angleValue = 'Error fetching data';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;

        return Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                colors: [Colors.grey[900]!, Colors.grey[800]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title at the top
                Text(
                  'Recommendation Results',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                isSmallScreen ? _buildVerticalLayout() : _buildHorizontalLayout(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: 16),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(color: Colors.lightBlueAccent),
          )
        else if (isError)
          Text(
            'Error fetching data. Please try again later.',
            style: TextStyle(color: Colors.redAccent, fontSize: 16),
          )
        else
          _buildDataSection(),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildDataSection()),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        FaIcon(FontAwesomeIcons.compass, color: Colors.lightBlueAccent, size: 24),
        SizedBox(width: 10),
        Text(
          'Recommendation Result',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          angleValue,
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 56,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(color: Colors.white24, thickness: 1, height: 24),
        Text(
          'This angle represents the recommended optimal configuration for your setup.',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      ],
    );
  }
}

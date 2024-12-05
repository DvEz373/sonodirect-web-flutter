import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'About Sonodirect',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sonodirect is dedicated to providing high-quality sound metrics for our users. Our mission is to help users achieve optimal sound distribution and quality through easy-to-use tools and insights.',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Electrical Engineering Capstone Project',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Project Topic: Fine Tuning Sound System',
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Group 27',
                  style: TextStyle(fontSize: 18, color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Divider(color: Colors.white24, thickness: 1),
              ],
            ),
            SizedBox(height: 30),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildTeammateCard(
                  imagePath: 'teammate3.png', 
                  name: 'Arandhya Wikrama Wardana',
                  role1: 'IoT and Database Engineer',
                  role2: 'CAD Designer',
                  major: 'Electrical Engineering 2021',
                  specialization: 'Power System Engineering',
                ),
                _buildTeammateCard(
                  imagePath: 'teammate4.png',
                  name: 'Muhammad Anargya Nimpuno',
                  role1: 'IoT Engineer',
                  role2: 'Embedded System Electronics Engineer',
                  major: 'Electrical Engineering 2021',
                  specialization: 'Power System Engineering',
                ),
                _buildTeammateCard(
                  imagePath: 'teammate2.png',
                  name: 'Elisha Rachma Salsabila',
                  role1: 'AI/ML Engineer',
                  role2: 'UI/UX Designer',
                  major: 'Electrical Engineering 2021',
                  specialization: 'Power System Engineering',
                ),
                _buildTeammateCard(
                  imagePath: 'teammate1.png',
                  name: 'Devin Ezekiel Purba',
                  role1: 'Full Stack Developer',
                  role2: 'AI/ML Engineer',
                  major: 'Electrical Engineering 2021',
                  specialization: 'Control System Engineering',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeammateCard({
    required String imagePath,
    required String name,
    required String role1,
    required String role2,
    required String major,
    required String specialization,
  }) {
    return Container(
      width: 300, 
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 90,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            major,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          Text(
            specialization,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 5),
          Text(
            role1,
            style: TextStyle(fontSize: 14, color: Colors.blueAccent),
          ),
          Text(
            role2,
            style: TextStyle(fontSize: 14, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}

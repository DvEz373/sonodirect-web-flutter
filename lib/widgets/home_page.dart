// lib/widgets/home_page.dart

import 'package:flutter/material.dart';
import 'recommendation_section.dart';
import 'chart_section.dart';
import 'top_navigation_bar.dart';
import 'side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  // Define GlobalKeys for each section
  final GlobalKey _resultKey = GlobalKey();
  final GlobalKey _splKey = GlobalKey();
  final GlobalKey _sfKey = GlobalKey();
  final GlobalKey _thdKey = GlobalKey();
  final GlobalKey _snrKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sonodirect Dashboard'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      drawer: SideMenu(), // Add the side menu (Drawer) back here
      body: Column(
        children: [
          TopNavigationBar(onTabSelected: (index) {
            // Scroll to the section based on index
            if (index == 0) _scrollToSection(_resultKey);
            if (index == 1) _scrollToSection(_splKey);
            if (index == 2) _scrollToSection(_sfKey);
            if (index == 3) _scrollToSection(_thdKey);
            if (index == 4) _scrollToSection(_snrKey);
          }),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recommendation Result Section
                    Container(
                      key: _resultKey, // Assign the key for the Result section
                      child: RecommendationSection(),
                    ),
                    SizedBox(height: 60),

                    // Sound Pressure Level Section (SPL)
                    Container(
                      key: _splKey, // Assign the key for Sound Pressure Level
                      child: ChartSection(
                        title: 'Sound Pressure Level',
                        chartType: 'SPL', // Pass the correct chartType for SPL
                        height: 400,
                      ),
                    ),
                    SizedBox(height: 60),

                    // Spectral Flatness Section (SF)
                    Container(
                      key: _sfKey, // Assign the key for Spectral Flatness
                      child: ChartSection(
                        title: 'Spectral Flatness',
                        chartType: 'SpectralFlatness', // Pass the correct chartType for SF
                        height: 400,
                      ),
                    ),
                    SizedBox(height: 60),

                    // Total Harmonic Distortion Section (THD)
                    Container(
                      key: _thdKey, // Assign the key for Total Harmonic Distortion
                      child: ChartSection(
                        title: 'Total Harmonic Distortion',
                        chartType: 'THD', // Pass the correct chartType for THD
                        height: 400,
                      ),
                    ),
                    SizedBox(height: 60),

                    // Signal to Noise Ratio Section (SNR)
                    Container(
                      key: _snrKey, // Assign the key for Signal to Noise Ratio
                      child: ChartSection(
                        title: 'Signal to Noise Ratio',
                        chartType: 'SNR', // Pass the correct chartType for SNR
                        height: 400,
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

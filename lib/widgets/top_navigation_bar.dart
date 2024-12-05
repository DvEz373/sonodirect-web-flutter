import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome

class TopNavigationBar extends StatefulWidget {
  final Function(int) onTabSelected;

  const TopNavigationBar({super.key, required this.onTabSelected});

  @override
  _TopNavigationBarState createState() => _TopNavigationBarState();
}

class _TopNavigationBarState extends State<TopNavigationBar> {
  int _selectedIndex = 0;
  int _hoveredIndex = -1; // To keep track of the hovered item

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTabSelected(index);
  }

  void _onHoverEnter(int index) {
    setState(() {
      _hoveredIndex = index;
    });
  }

  void _onHoverExit() {
    setState(() {
      _hoveredIndex = -1; // Reset to default state when the cursor leaves
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    int itemsPerRow;
    if (screenWidth > 1000) {
      itemsPerRow = 5; // All items in one row
    } else if (screenWidth > 600) {
      itemsPerRow = 3; // Three items per row
    } else {
      itemsPerRow = 2; // Two items per row
    }

    List<Widget> navItems = [
      _buildNavItem('Result', FontAwesomeIcons.checkCircle, 0),
      _buildNavItem('Sound Pressure Level', FontAwesomeIcons.volumeUp, 1),
      _buildNavItem('Spectral Flatness', FontAwesomeIcons.waveSquare, 2),
      _buildNavItem('Total Harmonic Distortion', FontAwesomeIcons.chartLine, 3),
      _buildNavItem('Signal to Noise Ratio', FontAwesomeIcons.signal, 4),
    ];

    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 10,
        children: List.generate(navItems.length, (index) {
          return SizedBox(
            width: screenWidth / itemsPerRow - 20, // Adjust width dynamically
            child: navItems[index],
          );
        }),
      ),
    );
  }

  Widget _buildNavItem(String title, IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    bool isHovered = _hoveredIndex == index;

    return GestureDetector(
      onTap: () => _onButtonTapped(index),
      child: MouseRegion(
        onEnter: (event) => _onHoverEnter(index),
        onExit: (event) => _onHoverExit(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isHovered
                ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 10)]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Make the row size adaptive
            children: [
              FaIcon(
                icon,
                color: isSelected ? Colors.black : Colors.white70,
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14, // Reduce font size for compactness
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

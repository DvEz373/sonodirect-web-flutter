import 'package:flutter/material.dart';
import 'home_page.dart';
import 'about_us.dart'; // Import the About Us page

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 50,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 10),
                Text(
                  'Sonodirect',
                  style: TextStyle(color: Colors.blue, fontSize: 24),
                ),
              ],
            ),
          ),
          _buildMenuItem(Icons.dashboard, 'Dashboard', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }),
          _buildMenuItem(Icons.history, 'Recent', () {
            Navigator.pop(context);
          }),
          _buildMenuItem(Icons.file_download, 'Export', () {
            Navigator.pop(context);
          }),
          _buildMenuItem(Icons.info, 'About Us', () {
            // Navigate to AboutUsPage on About Us item click
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutUsPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}

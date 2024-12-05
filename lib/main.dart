import 'package:flutter/material.dart';
import 'widgets/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonodirect Dashboard',
      theme: ThemeData(
        brightness: Brightness.dark, // Use a dark theme
        primaryColor: Colors.blueAccent, // Set the primary color
        colorScheme: ColorScheme.dark( // Use ColorScheme for colors
          primary: Colors.blueAccent,
          secondary: Colors.lightBlueAccent,
        ),
        scaffoldBackgroundColor: Colors.black, // Set the background color
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0,
            color: Colors.white60,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black, // Set the app bar color
          elevation: 0, // Remove app bar shadow
          iconTheme: IconThemeData(color: Colors.lightBlueAccent),
          titleTextStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
            foregroundColor: WidgetStateProperty.all(Colors.black), // Text color
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.grey[850], // Dark background for cards
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4, // Subtle shadow effect
        ),
      ),
      home: HomePage(),
    );
  }
}

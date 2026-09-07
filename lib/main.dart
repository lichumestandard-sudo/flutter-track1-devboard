import 'package:flutter/material.dart';
import 'src/screens/dashboard_shell.dart';

void main() {
  runApp(const PreFlightApp());
}

class PreFlightApp extends StatefulWidget {
  const PreFlightApp({super.key});

  @override
  State<PreFlightApp> createState() => _PreFlightAppState();
}

class _PreFlightAppState extends State<PreFlightApp> {
  // 1. The master state living at the very top of the app
  bool _isDarkMode = true;

  // 2. The function that updates the state and rebuilds the app
  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PreFlight',
      debugShowCheckedModeBanner: false,
      
      // 3. Define the Light Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      
      // 4. Define the Dark Theme
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      
      // 5. Tell the app which theme to use based on our variable
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // 6. Pass the variable and the function down to the shell
      home: DashboardShell(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}
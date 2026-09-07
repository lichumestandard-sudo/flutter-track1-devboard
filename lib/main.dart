import 'package:flutter/material.dart';
import 'src/screens/dashboard_shell.dart'; // Make sure this path is correct

void main() {
  runApp(const PreFlightApp());
}

class PreFlightApp extends StatelessWidget {
  const PreFlightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PreFlight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark, // Standard for dev tools
        ),
        useMaterial3: true,
      ),
      home: const DashboardShell(), // Load the responsive shell here
    );
  }
}